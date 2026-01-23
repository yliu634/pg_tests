-- PostgreSQL compatible tests from inverted_join_multi_column
-- 37 tests

SET client_min_messages = warning;

-- This test suite originally relied on CockroachDB geospatial/geometry support
-- and inverted index join hints. Keep the query semantics but avoid PostGIS
-- and CRDB-only syntax by modeling a tiny subset using built-in geometric
-- types/operators and plain joins.

CREATE OR REPLACE FUNCTION wkt_point(wkt text)
RETURNS point
LANGUAGE plpgsql
IMMUTABLE
AS $$
DECLARE
  m text[];
BEGIN
  m := regexp_match(
    wkt,
    '(?i)^\s*POINT\s*\(\s*([+-]?[0-9]*\.?[0-9]+)\s+([+-]?[0-9]*\.?[0-9]+)\s*\)\s*$'
  );
  IF m IS NULL THEN
    RAISE EXCEPTION 'invalid POINT WKT: %', wkt;
  END IF;
  RETURN point(m[1]::float8, m[2]::float8);
END;
$$;

CREATE OR REPLACE FUNCTION wkt_polygon(wkt text)
RETURNS polygon
LANGUAGE plpgsql
IMMUTABLE
AS $$
DECLARE
  inner_coords text;
  poly_text text;
BEGIN
  inner_coords := regexp_replace(
    wkt,
    '(?i)^\s*POLYGON\s*\(\((.*)\)\)\s*$',
    '\1'
  );
  poly_text := regexp_replace(inner_coords, '\s+', ' ', 'g');
  poly_text := regexp_replace(
    poly_text,
    '([+-]?[0-9]*\.?[0-9]+)\s+([+-]?[0-9]*\.?[0-9]+)',
    '(\1,\2)',
    'g'
  );
  poly_text := regexp_replace(poly_text, '\s*,\s*', ',', 'g');
  poly_text := regexp_replace(poly_text, '\s+', '', 'g');
  RETURN ('(' || poly_text || ')')::polygon;
END;
$$;

CREATE OR REPLACE FUNCTION wkt_path(wkt text)
RETURNS path
LANGUAGE plpgsql
IMMUTABLE
AS $$
DECLARE
  m text[];
  inner_coords text;
  path_text text;
BEGIN
  m := regexp_match(wkt, '(?i)^\s*LINESTRING\s*\((.*)\)\s*$');
  IF m IS NULL THEN
    RAISE EXCEPTION 'invalid LINESTRING WKT: %', wkt;
  END IF;
  inner_coords := m[1];

  path_text := regexp_replace(inner_coords, '\s+', ' ', 'g');
  path_text := regexp_replace(
    path_text,
    '([+-]?[0-9]*\.?[0-9]+)\s+([+-]?[0-9]*\.?[0-9]+)',
    '(\1,\2)',
    'g'
  );
  path_text := regexp_replace(path_text, '\s*,\s*', ',', 'g');
  path_text := regexp_replace(path_text, '\s+', '', 'g');

  RETURN ('[' || path_text || ']')::path;
END;
$$;

CREATE OR REPLACE FUNCTION point_on_segment(p point, a point, b point)
RETURNS boolean
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT
    abs(((p)[0] - (a)[0]) * ((b)[1] - (a)[1]) - ((p)[1] - (a)[1]) * ((b)[0] - (a)[0])) < 1e-9
    AND (p)[0] BETWEEN LEAST((a)[0], (b)[0]) - 1e-9 AND GREATEST((a)[0], (b)[0]) + 1e-9
    AND (p)[1] BETWEEN LEAST((a)[1], (b)[1]) - 1e-9 AND GREATEST((a)[1], (b)[1]) + 1e-9;
$$;

CREATE OR REPLACE FUNCTION st_intersects(a text, b text)
RETURNS boolean
LANGUAGE plpgsql
IMMUTABLE
AS $$
DECLARE
  pa point;
  pb point;
  pts text;
  arr text[];
  i int;
  p1 point;
  p2 point;
  poly polygon;
BEGIN
  IF a IS NULL OR b IS NULL THEN
    RETURN false;
  END IF;

  pa := wkt_point(a);

  IF b ILIKE 'POINT%' THEN
    pb := wkt_point(b);
    RETURN abs((pa)[0] - (pb)[0]) < 1e-9 AND abs((pa)[1] - (pb)[1]) < 1e-9;
  ELSIF b ILIKE 'LINESTRING%' THEN
    pts := regexp_replace(b, '(?i)^\s*LINESTRING\s*\((.*)\)\s*$', '\1');
    arr := regexp_split_to_array(pts, '\s*,\s*');
    IF array_length(arr, 1) IS NULL OR array_length(arr, 1) < 2 THEN
      RAISE EXCEPTION 'invalid LINESTRING WKT: %', b;
    END IF;
    FOR i IN 1..array_length(arr, 1) - 1 LOOP
      p1 := wkt_point('POINT(' || arr[i] || ')');
      p2 := wkt_point('POINT(' || arr[i + 1] || ')');
      IF point_on_segment(pa, p1, p2) THEN
        RETURN true;
      END IF;
    END LOOP;
    RETURN false;
  ELSIF b ILIKE 'POLYGON%' THEN
    poly := wkt_polygon(b);
    RETURN poly @> pa;
  ELSE
    RAISE EXCEPTION 'unsupported geometry WKT: %', b;
  END IF;
END;
$$;

CREATE OR REPLACE FUNCTION st_dwithin(a text, b text, dist float8)
RETURNS boolean
LANGUAGE plpgsql
IMMUTABLE
AS $$
DECLARE
  pa point;
  pb point;
  pth path;
  poly polygon;
BEGIN
  IF a IS NULL OR b IS NULL OR dist IS NULL THEN
    RETURN false;
  END IF;

  pa := wkt_point(a);

  IF b ILIKE 'POINT%' THEN
    pb := wkt_point(b);
    RETURN (pa <-> pb) <= dist;
  ELSIF b ILIKE 'LINESTRING%' THEN
    pth := wkt_path(b);
    RETURN (pa <-> pth) <= dist;
  ELSIF b ILIKE 'POLYGON%' THEN
    poly := wkt_polygon(b);
    RETURN (pa <-> poly) <= dist;
  ELSE
    RAISE EXCEPTION 'unsupported geometry WKT: %', b;
  END IF;
END;
$$;

CREATE OR REPLACE FUNCTION st_makepolygon(wkt text)
RETURNS polygon
LANGUAGE plpgsql
IMMUTABLE
AS $$
DECLARE
  m text[];
BEGIN
  m := regexp_match(wkt, '(?i)^\s*LINESTRING\s*\((.*)\)\s*$');
  IF m IS NULL THEN
    RAISE EXCEPTION 'invalid LINESTRING WKT: %', wkt;
  END IF;
  RETURN wkt_polygon('POLYGON((' || m[1] || '))');
END;
$$;

CREATE OR REPLACE FUNCTION st_contains(a polygon, b polygon)
RETURNS boolean
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT a @> b;
$$;

-- Test 1: statement (line 5)
CREATE TABLE j1 (
  k INT PRIMARY KEY,
  j JSONB
);

-- Test 2: statement (line 12)
INSERT INTO j1 VALUES
  (1, '{"a": "b"}'),
  (2, '[1,2,3,4, "foo"]'),
  (3, '{"a": {"b": "c"}}'),
  (4, '{"a": {"b": [1]}}'),
  (5, '{"a": {"b": [1, [2]]}}'),
  (6, '{"a": {"b": [[2]]}}'),
  (7, '{"a": "b", "c": "d"}'),
  (8, '{"a": {"b":true}}'),
  (9, '{"a": {"b":false}}'),
  (10, '"a"'),
  (11, 'null'),
  (12, 'true'),
  (13, 'false'),
  (14, '1'),
  (15, '1.23'),
  (16, '[{"a": {"b": [1, [2]]}}, "d"]'),
  (17, '{}'),
  (18, '[]'),
  (19, '["a", "a"]'),
  (20, '[{"a": "a"}, {"a": "a"}]'),
  (21, '[[[["a"]]], [[["a"]]]]'),
  (22, '[1,2,3,1]'),
  (23, '{"a": 123.123}'),
  (24, '{"a": 123.123000}'),
  (25, '{"a": [{}]}'),
  (26, '[[], {}]'),
  (27, '[true, false, null, 1.23, "a"]'),
  (28, '{"a": {}}'),
  (29, NULL),
  (30, '{"a": []}'),
  (31, '{"a": {"b": "c", "d": "e"}, "f": "g"}'),
  (32, '{"a": [1]}'),
  (33, '[1, "bar"]'),
  (34, '{"a": 1}'),
  (35, '[1]'),
  (36, '[2]'),
  (37, '[[1]]'),
  (38, '[[2]]'),
  (39, '["a"]'),
  (40, '{"a": [[]]}'),
  (41, '[[1, 2]]'),
  (42, '[[1], [2]]'),
  (43, '[{"a": "b", "c": "d"}]'),
  (44, '[{"a": "b"}, {"c": "d"}]');

-- CockroachDB exposes an implicit rowid. Model it explicitly for comparisons.
CREATE TABLE j2 (
  rowid BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  i INT,
  j JSONB,
  s TEXT
);

-- Test 3: statement (line 69)
INSERT INTO j2 (i, j, s)
  SELECT i, j, s FROM j1
  CROSS JOIN (VALUES (10), (20), (30), (NULL)) t1(i)
  CROSS JOIN (VALUES ('foo'), ('bar'), ('baz'), (NULL)) t2(s);

-- Test 4: query (line 79)
SELECT * FROM
(SELECT j1.k, j2.rowid FROM j1, j2 WHERE i IN (10, 20) AND j2.j @> j1.j) AS inv_join(k1, k2)
FULL OUTER JOIN
(SELECT j1.k, j2.rowid FROM j1, j2 WHERE i IN (10, 20) AND j2.j @> j1.j) AS cross_join(k1, k2)
ON inv_join.k1 = cross_join.k1 AND inv_join.k2 = cross_join.k2
WHERE inv_join.k1 IS NULL OR cross_join.k1 IS NULL;

-- Test 5: query (line 91)
SELECT * FROM
(SELECT j1.k, j2.rowid FROM j1, j2 WHERE i IN (10, 20) AND s IN ('foo', 'bar') AND j2.j @> j1.j) AS inv_join(k1, k2)
FULL OUTER JOIN
(SELECT j1.k, j2.rowid FROM j1, j2 WHERE i IN (10, 20) AND s IN ('foo', 'bar') AND j2.j @> j1.j) AS cross_join(k1, k2)
ON inv_join.k1 = cross_join.k1 AND inv_join.k2 = cross_join.k2
WHERE inv_join.k1 IS NULL OR cross_join.k1 IS NULL;

-- Test 6: query (line 103)
SELECT * FROM
(SELECT j1.k, j2.rowid FROM j1 JOIN j2 ON i IN (10, 20) AND j2.j @> j1.j AND j2.j @> '{"a": {}}') AS inv_join(k1, k2)
FULL OUTER JOIN
(SELECT j1.k, j2.rowid FROM j1, j2 WHERE i IN (10, 20) AND j2.j @> j1.j AND j2.j @> '{"a": {}}') AS cross_join(k1, k2)
ON inv_join.k1 = cross_join.k1 AND inv_join.k2 = cross_join.k2
WHERE inv_join.k1 IS NULL OR cross_join.k1 IS NULL;

-- Test 7: query (line 162)
SELECT j1.*, j2.*
FROM j1 LEFT JOIN j2
  ON i = 10 AND j2.j @> j1.j AND j2.j = '"foo"'
WHERE j1.k = 1
ORDER BY j1.k, j2.i;

-- Test 8: query (line 172)
SELECT * FROM j1 WHERE EXISTS (
  SELECT * FROM j2
  WHERE j2.j @> j1.j AND j2.j @> '{"a": {}}' AND j2.i = 10
)
ORDER BY j1.k;

-- Test 9: query (line 190)
SELECT * FROM j1 WHERE NOT EXISTS (
  SELECT * FROM j2
  WHERE j2.j @> j1.j AND j2.j @> '{"a": {}}' AND j2.i = 10
)
ORDER BY j1.k;

-- Test 10: statement (line 233)
CREATE TABLE a1 (
  k INT PRIMARY KEY,
  a INT[]
);

-- Test 11: statement (line 239)
INSERT INTO a1 VALUES
  (1, '{}'),
  (2, '{1}'),
  (3, '{2}'),
  (4, '{1, 2}'),
  (5, '{1, 3}'),
  (6, '{1, 2, 3, 4}'),
  (7, ARRAY[NULL]::INT[]),
  (8, NULL);

-- Test 12: statement (line 250)
CREATE TABLE a2 (
  rowid BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  i INT,
  a INT[]
);

-- Test 13: statement (line 258)
INSERT INTO a2 (i, a)
  SELECT i, a FROM a1
  CROSS JOIN (VALUES (10), (20), (30), (NULL)) t1(i);

-- Test 14: query (line 267)
SELECT * FROM
(SELECT a1.k, a2.rowid FROM a1, a2 WHERE i IN (10, 20) AND a2.a @> a1.a) AS inv_join(k1, k2)
FULL OUTER JOIN
(SELECT a1.k, a2.rowid FROM a1, a2 WHERE i IN (10, 20) AND a2.a @> a1.a) AS cross_join(k1, k2)
ON inv_join.k1 = cross_join.k1 AND inv_join.k2 = cross_join.k2
WHERE inv_join.k1 IS NULL OR cross_join.k1 IS NULL;

-- Test 15: query (line 279)
SELECT * FROM
(SELECT a1.k, a2.rowid FROM a1, a2 WHERE i IN (10, 20) AND a2.a @> a1.a AND a1.a @> '{1}') AS inv_join(k1, k2)
FULL OUTER JOIN
(SELECT a1.k, a2.rowid FROM a1, a2 WHERE i IN (10, 20) AND a2.a @> a1.a AND a1.a @> '{1}') AS cross_join(k1, k2)
ON inv_join.k1 = cross_join.k1 AND inv_join.k2 = cross_join.k2
WHERE inv_join.k1 IS NULL OR cross_join.k1 IS NULL;

-- Test 16: query (line 289)
SELECT a1.*, a2.* FROM a1
LEFT JOIN a2
ON a2.a @> a1.a AND a2.a @> '{1}' AND a2.i = 10
ORDER BY a1.a, a2.a;

-- Test 17: query (line 315)
SELECT a1.*, a2.* FROM a1
LEFT JOIN a2
ON a2.a @> a1.a AND a2.a = '{100}' AND a2.i = 10
ORDER BY a1.a, a2.a;

-- Test 18: query (line 331)
SELECT a1.* FROM a1 WHERE EXISTS (
  SELECT * FROM a2
  WHERE a2.a @> a1.a AND a2.i = 10
)
ORDER BY a1.k;

-- Test 19: query (line 346)
SELECT a1.* FROM a1 WHERE NOT EXISTS (
  SELECT * FROM a2
  WHERE a2.a @> a1.a AND a2.i = 10
)
ORDER BY a1.k;

-- Test 20: statement (line 356)
CREATE TABLE g1 (
  k INT PRIMARY KEY,
  geom polygon
);

-- Test 21: statement (line 362)
INSERT INTO g1 VALUES
  (1, st_makepolygon('LINESTRING(0 0, 0 15, 15 15, 15 0, 0 0)')),
  (2, st_makepolygon('LINESTRING(0 0, 0 2, 2 2, 2 0, 0 0)'));

-- Test 22: statement (line 367)
CREATE TABLE g2 (
  rowid BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  i INT,
  geom polygon
);

-- Test 23: statement (line 375)
INSERT INTO g2 (i, geom)
  SELECT i, geom FROM g1
  CROSS JOIN (VALUES (10), (20), (30), (NULL)) t1(i);

-- Test 24: query (line 383)
SELECT * FROM
(SELECT g1.k, g2.rowid FROM g1, g2 WHERE i IN (10, 20) AND st_contains(g2.geom, g1.geom)) AS inv_join(k1, k2)
FULL OUTER JOIN
(SELECT g1.k, g2.rowid FROM g1, g2 WHERE i IN (10, 20) AND st_contains(g2.geom, g1.geom)) AS cross_join(k1, k2)
ON inv_join.k1 = cross_join.k1 AND inv_join.k2 = cross_join.k2
WHERE inv_join.k1 IS NULL OR cross_join.k1 IS NULL;

-- Test 25: statement (line 392)
CREATE TABLE ltable (
  lk INT PRIMARY KEY,
  geom1 text,
  geom2 text
);

-- Test 26: statement (line 399)
INSERT INTO ltable VALUES
  (1, 'POINT(3.0 3.0)', 'POINT(3.0 3.0)'),
  (2, 'POINT(4.5 4.5)', 'POINT(3.0 3.0)'),
  (3, 'POINT(1.5 1.5)', 'POINT(3.0 3.0)'),
  (4, NULL, 'POINT(3.0 3.0)'),
  (5, 'POINT(1.5 1.5)', NULL),
  (6, NULL, NULL);

-- Test 27: statement (line 408)
CREATE TABLE rtable(
  rk INT PRIMARY KEY,
  i INT,
  geom text
);

-- Test 28: statement (line 416)
INSERT INTO rtable VALUES
  (11, 10, 'POINT(1.0 1.0)'),
  (12, 10, 'LINESTRING(1.0 1.0, 2.0 2.0)'),
  (13, 10, 'POINT(3.0 3.0)'),
  (14, 10, 'LINESTRING(4.0 4.0, 5.0 5.0)'),
  (15, 10, 'LINESTRING(40.0 40.0, 41.0 41.0)'),
  (16, 10, 'POLYGON((1.0 1.0, 5.0 1.0, 5.0 5.0, 1.0 5.0, 1.0 1.0))'),
  (17, 20, 'POINT(1.0 1.0)'),
  (18, 20, 'LINESTRING(1.0 1.0, 2.0 2.0)'),
  (19, 20, 'POINT(3.0 3.0)'),
  (20, 20, 'LINESTRING(4.0 4.0, 5.0 5.0)'),
  (21, 20, 'LINESTRING(40.0 40.0, 41.0 41.0)'),
  (22, 20, 'POLYGON((1.0 1.0, 5.0 1.0, 5.0 5.0, 1.0 5.0, 1.0 1.0))');

-- Test 29: query (line 431)
SELECT lk, rk FROM ltable
JOIN rtable
  ON i = 10 AND st_intersects(ltable.geom1, rtable.geom)
ORDER BY lk, rk;

-- Test 30: query (line 446)
SELECT lk, rk FROM ltable
JOIN rtable
  ON i = 10 AND st_dwithin(ltable.geom1, rtable.geom, 2)
ORDER BY lk, rk;

-- Test 31: query (line 465)
SELECT lk, rk FROM ltable
JOIN rtable
  ON i = 10 AND (st_intersects(ltable.geom1, rtable.geom) OR st_dwithin(ltable.geom1, rtable.geom, 2))
ORDER BY lk, rk;

-- Test 32: query (line 484)
SELECT lk, rk FROM ltable
JOIN rtable
  ON i = 10 AND (st_intersects(ltable.geom1, rtable.geom) AND st_dwithin(ltable.geom1, rtable.geom, 2))
ORDER BY lk, rk;

-- Test 33: statement (line 501)
CREATE TABLE t59615_inv (
  x INT NOT NULL CHECK (x in (1, 3)),
  y JSONB
);

-- Test 34: query (line 509)
SELECT * FROM (VALUES ('"a"'::jsonb), ('"b"'::jsonb)) AS u(y) LEFT JOIN t59615_inv t ON t.y @> u.y;

-- Test 35: query (line 515)
SELECT * FROM (VALUES ('"a"'::jsonb), ('"b"'::jsonb)) AS u(y) WHERE NOT EXISTS (
  SELECT * FROM t59615_inv t WHERE t.y @> u.y
);

-- Test 36: statement (line 523)
INSERT INTO t59615_inv VALUES (1, '"a"'::JSONB), (3, '"a"'::JSONB);

-- Test 37: query (line 526)
SELECT * FROM (VALUES ('"a"'::jsonb), ('"b"'::jsonb)) AS u(y) WHERE EXISTS (
  SELECT * FROM t59615_inv t WHERE t.y @> u.y
);

RESET client_min_messages;
