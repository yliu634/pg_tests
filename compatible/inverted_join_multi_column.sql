-- PostgreSQL compatible tests from inverted_join_multi_column
-- 37 tests

-- Test 1: statement (line 5)
CREATE TABLE j1 (
  k INT PRIMARY KEY,
  j JSON
)

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
  (44, '[{"a": "b"}, {"c": "d"}]')

-- Test 3: statement (line 69)
INSERT INTO j2 (
  SELECT i, j, s FROM j1
  CROSS JOIN (VALUES (10), (20), (30), (NULL)) t1(i)
  CROSS JOIN (VALUES ('foo'), ('bar'), ('baz'), (NULL)) t2(s)
)

-- Test 4: query (line 79)
SELECT * FROM
(SELECT j1.k, j2.rowid FROM j1, j2@ij_idx WHERE i IN (10, 20) AND j2.j @> j1.j) AS inv_join(k1, k2)
FULL OUTER JOIN
(SELECT j1.k, j2.rowid FROM j1, j2@j2_pkey WHERE i IN (10, 20) AND j2.j @> j1.j) AS cross_join(k1, k2)
ON inv_join.k1 = cross_join.k1 AND inv_join.k2 = cross_join.k2
WHERE inv_join.k1 IS NULL OR cross_join.k1 IS NULL

-- Test 5: query (line 91)
SELECT * FROM
(SELECT j1.k, j2.rowid FROM j1, j2@isj_idx WHERE i IN (10, 20) AND s IN ('foo', 'bar') AND j2.j @> j1.j) AS inv_join(k1, k2)
FULL OUTER JOIN
(SELECT j1.k, j2.rowid FROM j1, j2@j2_pkey WHERE i IN (10, 20) AND s IN ('foo', 'bar') AND j2.j @> j1.j) AS cross_join(k1, k2)
ON inv_join.k1 = cross_join.k1 AND inv_join.k2 = cross_join.k2
WHERE inv_join.k1 IS NULL OR cross_join.k1 IS NULL

-- Test 6: query (line 103)
SELECT * FROM
(SELECT j1.k, j2.rowid FROM j1 INNER INVERTED JOIN j2@ij_idx ON i IN (10, 20) AND j2.j @> j1.j AND j2.j @> '{"a": {}}') AS inv_join(k1, k2)
FULL OUTER JOIN
(SELECT j1.k, j2.rowid FROM j1, j2@j2_pkey WHERE i IN (10, 20) AND j2.j @> j1.j AND j2.j @> '{"a": {}}') AS cross_join(k1, k2)
ON inv_join.k1 = cross_join.k1 AND inv_join.k2 = cross_join.k2
WHERE inv_join.k1 IS NULL OR cross_join.k1 IS NULL

-- Test 7: query (line 162)
SELECT j1.*, j2.*
FROM j1 LEFT INVERTED JOIN j2@ij_idx
  ON i = 10 AND j2.j @> j1.j AND j2.j = '"foo"'
WHERE k = 1
ORDER BY j1.k, j2.i

-- Test 8: query (line 172)
SELECT * FROM j1 WHERE EXISTS (
  SELECT * FROM j2@ij_idx
  WHERE j2.j @> j1.j AND j2.j @> '{"a": {}}' AND j2.i = 10
)
ORDER BY j1.k

-- Test 9: query (line 190)
SELECT * FROM j1 WHERE NOT EXISTS (
  SELECT * FROM j2@ij_idx
  WHERE j2.j @> j1.j AND j2.j @> '{"a": {}}' AND j2.i = 10
)
ORDER BY j1.k

-- Test 10: statement (line 233)
CREATE TABLE a1 (
  k INT PRIMARY KEY,
  a INT[]
)

-- Test 11: statement (line 239)
INSERT INTO a1 VALUES
  (1, '{}'),
  (2, '{1}'),
  (3, '{2}'),
  (4, '{1, 2}'),
  (5, '{1, 3}'),
  (6, '{1, 2, 3, 4}'),
  (7, ARRAY[NULL]::INT[]),
  (8, NULL)

-- Test 12: statement (line 250)
CREATE TABLE a2 (
  i INT,
  a INT[],
  INVERTED INDEX ia_idx (i, a)
)

-- Test 13: statement (line 258)
INSERT INTO a2 (
  SELECT i, a FROM a1
  CROSS JOIN (VALUES (10), (20), (30), (NULL)) t1(i)
)

-- Test 14: query (line 267)
SELECT * FROM
(SELECT a1.k, a2.rowid FROM a1, a2@ia_idx WHERE i IN (10, 20) AND a2.a @> a1.a) AS inv_join(k1, k2)
FULL OUTER JOIN
(SELECT a1.k, a2.rowid FROM a1, a2@a2_pkey WHERE i IN (10, 20) AND a2.a @> a1.a) AS cross_join(k1, k2)
ON inv_join.k1 = cross_join.k1 AND inv_join.k2 = cross_join.k2
WHERE inv_join.k1 IS NULL OR cross_join.k1 IS NULL

-- Test 15: query (line 279)
SELECT * FROM
(SELECT a1.k, a2.rowid FROM a1, a2@ia_idx WHERE i IN (10, 20) AND a2.a @> a1.a AND a1.a @> '{1}') AS inv_join(k1, k2)
FULL OUTER JOIN
(SELECT a1.k, a2.rowid FROM a1, a2@a2_pkey WHERE i IN (10, 20) AND a2.a @> a1.a AND a1.a @> '{1}') AS cross_join(k1, k2)
ON inv_join.k1 = cross_join.k1 AND inv_join.k2 = cross_join.k2
WHERE inv_join.k1 IS NULL OR cross_join.k1 IS NULL

-- Test 16: query (line 289)
SELECT a1.*, a2.* FROM a1@a1_pkey
LEFT INVERTED JOIN a2@ia_idx
ON a2.a @> a1.a AND a2.a @> '{1}' AND a2.i = 10
ORDER BY a1.a, a2.a

-- Test 17: query (line 315)
SELECT a1.*, a2.* FROM a1@a1_pkey
LEFT INVERTED JOIN a2@ia_idx
ON a2.a @> a1.a AND a2.a = '{100}' AND a2.i = 10
ORDER BY a1.a, a2.a

-- Test 18: query (line 331)
SELECT a1.* FROM a1@a1_pkey WHERE EXISTS (
  SELECT * FROM a2@ia_idx
  WHERE a2.a @> a1.a AND a2.i = 10
)
ORDER BY a1.k

-- Test 19: query (line 346)
SELECT a1.* FROM a1@a1_pkey WHERE NOT EXISTS (
  SELECT * FROM a2@ia_idx
  WHERE a2.a @> a1.a AND a2.i = 10
)
ORDER BY a1.k

-- Test 20: statement (line 356)
CREATE TABLE g1 (
  k INT PRIMARY KEY,
  geom GEOMETRY
)

-- Test 21: statement (line 362)
INSERT INTO g1 VALUES
  (1, ST_MakePolygon('LINESTRING(0 0, 0 15, 15 15, 15 0, 0 0)'::geometry)),
  (2, ST_MakePolygon('LINESTRING(0 0, 0 2, 2 2, 2 0, 0 0)'::geometry))

-- Test 22: statement (line 367)
CREATE TABLE g2 (
  i INT,
  geom GEOMETRY,
  INVERTED INDEX igeom_idx (i, geom)
)

-- Test 23: statement (line 375)
INSERT INTO g2 (
  SELECT i, geom FROM g1
  CROSS JOIN (VALUES (10), (20), (30), (NULL)) t1(i)
)

-- Test 24: query (line 383)
SELECT * FROM
(SELECT g1.k, g2.rowid FROM g1, g2@igeom_idx WHERE i IN (10, 20) AND ST_Contains(g2.geom, g1.geom)) AS inv_join(k1, k2)
FULL OUTER JOIN
(SELECT g1.k, g2.rowid FROM g1, g2@g2_pkey WHERE i IN (10, 20) AND ST_Contains(g2.geom, g1.geom)) AS cross_join(k1, k2)
ON inv_join.k1 = cross_join.k1 AND inv_join.k2 = cross_join.k2
WHERE inv_join.k1 IS NULL OR cross_join.k1 IS NULL

-- Test 25: statement (line 392)
CREATE TABLE ltable (
  lk INT PRIMARY KEY,
  geom1 GEOMETRY,
  geom2 GEOMETRY
)

-- Test 26: statement (line 399)
INSERT INTO ltable VALUES
  (1, 'POINT(3.0 3.0)', 'POINT(3.0 3.0)'),
  (2, 'POINT(4.5 4.5)', 'POINT(3.0 3.0)'),
  (3, 'POINT(1.5 1.5)', 'POINT(3.0 3.0)'),
  (4, NULL, 'POINT(3.0 3.0)'),
  (5, 'POINT(1.5 1.5)', NULL),
  (6, NULL, NULL)

-- Test 27: statement (line 408)
CREATE TABLE rtable(
  rk INT PRIMARY KEY,
  i INT,
  geom GEOMETRY,
  INVERTED INDEX igeom_idx (geom)
)

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
  (22, 20, 'POLYGON((1.0 1.0, 5.0 1.0, 5.0 5.0, 1.0 5.0, 1.0 1.0))')

-- Test 29: query (line 431)
SELECT lk, rk FROM ltable
JOIN rtable@igeom_idx
  ON i = 10 AND ST_Intersects(ltable.geom1, rtable.geom)
ORDER BY (lk, rk)

-- Test 30: query (line 446)
SELECT lk, rk FROM ltable
JOIN rtable@igeom_idx
  ON i = 10 AND ST_DWithin(ltable.geom1, rtable.geom, 2)
ORDER BY (lk, rk)

-- Test 31: query (line 465)
SELECT lk, rk FROM ltable
JOIN rtable@igeom_idx
  ON i = 10 AND (ST_Intersects(rtable.geom, ltable.geom1) OR ST_DWithin(ltable.geom1, rtable.geom, 2))
ORDER BY (lk, rk)

-- Test 32: query (line 484)
SELECT lk, rk FROM ltable
JOIN rtable@igeom_idx
  ON i = 10 AND (ST_Intersects(ltable.geom1, rtable.geom) AND ST_DWithin(rtable.geom, ltable.geom1, 2))
ORDER BY (lk, rk)

-- Test 33: statement (line 501)
CREATE TABLE t59615_inv (
  x INT NOT NULL CHECK (x in (1, 3)),
  y JSON,
  z INT,
  INVERTED INDEX (x, y)
)

-- Test 34: query (line 509)
SELECT * FROM (VALUES ('"a"'::jsonb), ('"b"'::jsonb)) AS u(y) LEFT JOIN t59615_inv t ON t.y @> u.y

-- Test 35: query (line 515)
SELECT * FROM (VALUES ('"a"'::jsonb), ('"b"'::jsonb)) AS u(y) WHERE NOT EXISTS (
  SELECT * FROM t59615_inv t WHERE t.y @> u.y
)

-- Test 36: statement (line 523)
INSERT INTO t59615_inv VALUES (1, '"a"'::JSONB), (3, '"a"'::JSONB)

-- Test 37: query (line 526)
SELECT * FROM (VALUES ('"a"'::jsonb), ('"b"'::jsonb)) AS u(y) WHERE EXISTS (
  SELECT * FROM t59615_inv t WHERE t.y @> u.y
)

