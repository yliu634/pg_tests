-- PostgreSQL compatible tests from subquery
-- 152 tests


SET client_min_messages = warning;

-- PostgreSQL setup: tables/functions referenced by later tests.
CREATE TABLE abc (a INT, b INT, c INT);
CREATE TABLE kv (k INT, v TEXT);

-- CockroachDB compatibility stubs.
CREATE SCHEMA IF NOT EXISTS crdb_internal;
CREATE TABLE IF NOT EXISTS crdb_internal.zones (id INT);

CREATE OR REPLACE FUNCTION crdb_internal.force_error(_msg TEXT, _detail TEXT)
  RETURNS INT
  LANGUAGE SQL
  IMMUTABLE
AS $$
  SELECT 0;
$$;
-- Test 1: query (line 3)
SELECT (SELECT 1);

-- Test 2: query (line 8)
SELECT 1 IN (SELECT 1);

-- Test 3: query (line 13)
SELECT 1 IN ((((SELECT 1))));

-- Test 4: query (line 18)
SELECT (ARRAY(VALUES (1), (2)))[2];

-- Test 5: query (line 23)
SELECT 1 + (SELECT 1);

-- Test 6: query (line 28)
SELECT 1 + (SELECT a FROM (SELECT 1 AS a, 2 AS b) AS s);

-- query B
SELECT (1, 2, 3) IN (SELECT 1, 2, 3);

-- Test 7: query (line 36)
SELECT (1, 2, 3) = (SELECT 1, 2, 3);

-- Test 8: query (line 41)
SELECT (1, 2, 3) != (SELECT 1, 2, 3);

-- Test 9: query (line 46)
SELECT (SELECT ROW(1, 2, 3)) = (SELECT ROW(1, 2, 3));

-- Test 10: query (line 51)
SELECT (SELECT 1) IN (SELECT 1);

-- Test 11: query (line 56)
SELECT (SELECT 1) IN (1);

-- Test 12: query (line 71)
SELECT (SELECT ROW(1, 2)) IN (SELECT ROW(1, 2));

-- Test 13: query (line 80)
SELECT (SELECT ROW(1, 2)) IN ((1, 2));

-- Test 14: query (line 89)
SELECT (SELECT (1, 2)) IN (SELECT ROW(1, 2));

-- Test 15: query (line 94)
SELECT (SELECT (1, 2)) IN ((1, 2));

-- Test 16: query (line 103)
SELECT (SELECT ROW(1, 2)) IN (SELECT (1, 2));

-- Test 17: query (line 108)
SELECT (SELECT (1, 2)) IN (SELECT (1, 2));

-- Test 18: query (line 113)
SELECT 1 = ANY(SELECT 1);

-- Test 19: query (line 118)
SELECT (1, 2) = ANY(SELECT 1, 2);

-- Test 20: query (line 123)
SELECT 1 = SOME(SELECT 1);

-- Test 21: query (line 128)
SELECT (1, 2) = SOME(SELECT 1, 2);

-- Test 22: query (line 133)
SELECT 1 = ALL(SELECT 1);

-- Test 23: query (line 138)
SELECT (1, 2) = ALL(SELECT 1, 2);

-- Test 24: query (line 176)
SELECT (1, 2) IN (SELECT a, b FROM abc WHERE false);

-- Test 25: query (line 181)
SELECT (SELECT ROW(a, b, c) FROM abc LIMIT 1);

-- query error more than one row returned by a subquery used as an expression
SELECT (SELECT a FROM abc LIMIT 1);

-- query I
SELECT (SELECT a FROM abc WHERE false);

-- Test 26: query (line 192)
VALUES (1, (SELECT (2)));

-- Test 27: statement (line 197)
INSERT INTO abc VALUES ((SELECT 7), (SELECT 8), (SELECT 9));

-- Test 28: query (line 200)
SELECT * FROM abc WHERE a = 7;

-- Test 29: statement (line 205)
INSERT INTO abc VALUES ((SELECT 10), (SELECT 11), (SELECT 12));

-- Test 30: statement (line 208)
INSERT INTO abc SELECT 13, 14, 15;

-- Test 31: statement (line 211)
CREATE TABLE xyz (x INT PRIMARY KEY, y INT, z INT);

-- Test 32: statement (line 214)
INSERT INTO xyz SELECT * FROM abc;

-- Test 33: query (line 217)
SELECT * FROM xyz;

-- Test 34: statement (line 224)
INSERT INTO xyz (x, y, z) VALUES (16, 11, 12);

-- Test 35: statement (line 227)
UPDATE xyz SET z = (SELECT 10) WHERE x = 7;

-- Test 36: query (line 230)
SELECT * FROM xyz;

-- Test 37: statement (line 238)
UPDATE xyz SET z = (SELECT (ROW(10, 11)).f2) WHERE x = 7;

-- Test 38: statement (line 241)
UPDATE xyz SET (y, z) = (SELECT 11, 12) WHERE x = 7;

-- Test 39: query (line 244)
SELECT 1 IN (SELECT x FROM xyz ORDER BY x DESC);

-- Test 40: query (line 249)
SELECT * FROM xyz WHERE x = (SELECT min(x) FROM xyz);

-- Test 41: query (line 254)
SELECT * FROM xyz WHERE x = (SELECT max(x) FROM xyz);

-- Test 42: query (line 259)
SELECT * FROM xyz WHERE x = (SELECT max(x) FROM xyz WHERE EXISTS(SELECT * FROM xyz WHERE z=x+3));

-- Test 43: statement (line 264)
UPDATE xyz SET (y, z) = (SELECT 11, 12) WHERE x = 7;

-- Test 44: query (line 267)
SELECT * FROM xyz;

-- Test 45: statement (line 278)
INSERT INTO kv VALUES (1, 'one');

-- Test 46: query (line 281)
SELECT * FROM kv WHERE k = (SELECT k FROM kv WHERE (k, v) = (1, 'one'));

-- Test 47: query (line 286)
SELECT EXISTS(SELECT 1 FROM kv AS x WHERE x.k = 1);

-- Test 48: query (line 291)
SELECT EXISTS(SELECT 1 FROM kv WHERE k = 2);

-- Test 49: query (line 299)
SELECT * FROM (VALUES (1, 2)) AS foo;

-- Test 50: query (line 305)
SELECT * FROM (VALUES (1, 2));

-- Test 51: query (line 311)
SELECT * FROM (VALUES (1, 'one'), (2, 'two'), (3, 'three')) AS foo;

-- Test 52: query (line 319)
SELECT * FROM (VALUES (1, 2, 3), (4, 5, 6)) AS foo;

-- Test 53: query (line 326)
SELECT * FROM (VALUES (1, 2, 3), (4, 5, 6)) AS foo (foo1, foo2, foo3);

-- Test 54: query (line 333)
SELECT * FROM (VALUES (1, 2, 3), (4, 5, 6)) AS foo (foo1, foo2);

-- Test 55: query (line 340)
SELECT * FROM (SELECT * FROM xyz) AS foo WHERE x < 7;

-- Test 56: query (line 347)
SELECT * FROM (SELECT * FROM xyz) AS foo (foo1) WHERE foo1 < 7;

-- Test 57: query (line 354)
SELECT * FROM (SELECT * FROM xyz AS moo (moo1, moo2, moo3)) as foo (foo1) WHERE foo1 < 7;

-- Test 58: query (line 361)
SELECT * FROM (SELECT * FROM xyz AS moo (moo1, moo2, moo3) ORDER BY moo1) as foo (foo1) WHERE foo1 < 7;

-- Test 59: query (line 368)
SELECT * FROM (SELECT * FROM xyz AS moo (moo1, moo2, moo3) ORDER BY moo1) as foo (foo1) WHERE foo1 < 7 ORDER BY moo2 DESC;

-- Test 60: query (line 375)
SELECT * FROM (SELECT * FROM (VALUES (1, 2, 3), (4, 5, 6)) AS moo (moo1, moo2, moo3) WHERE moo1 = 4) as foo (foo1);

-- Test 61: query (line 381)
SELECT * FROM (SELECT * FROM (VALUES (1, 8, 8), (3, 1, 1), (2, 4, 4)) AS moo (moo1, moo2, moo3) ORDER BY moo2) as foo (foo1) ORDER BY foo1;

-- Test 62: query (line 389)
SELECT a, b FROM (VALUES (1, 2, 3), (3, 4, 7), (5, 6, 10)) AS foo (a, b, c) WHERE a + b = c;

-- Test 63: query (line 396)
SELECT foo.a FROM (VALUES (1), (2), (3)) AS foo (a);

-- Test 64: query (line 404)
SELECT foo.a, a, column2, foo.column2 FROM (VALUES (1, 'one'), (2, 'two'), (3, 'three')) AS foo (a);

-- Test 65: query (line 412)
SELECT x FROM xyz WHERE x IN (SELECT x FROM xyz WHERE x = 7);

-- Test 66: query (line 417)
SELECT x FROM xyz WHERE x = 7 LIMIT (SELECT x FROM xyz WHERE x = 1);

-- Test 67: query (line 422)
SELECT x FROM xyz ORDER BY x OFFSET (SELECT x FROM xyz WHERE x = 1);

-- Test 68: query (line 429)
INSERT INTO xyz (x, y, z) VALUES (17, 11, 12) RETURNING (y IN (SELECT y FROM xyz));

-- Test 69: statement (line 437)
CREATE TABLE tab4(col0 INTEGER, col1 FLOAT, col3 INTEGER, col4 FLOAT);

-- Test 70: statement (line 440)
INSERT INTO tab4 VALUES (1,1,1,1);

-- Test 71: statement (line 443)
CREATE INDEX idx_tab4_0 ON tab4 (col4,col0);

-- Test 72: query (line 446)
SELECT col0 FROM tab4 WHERE (col0 <= 0 AND col4 <= 5.38) OR (col4 IN (SELECT col1 FROM tab4 WHERE col1 > 8.27)) AND (col3 <= 5 AND (col3 BETWEEN 7 AND 9));

-- Test 73: statement (line 452)
CREATE TABLE corr (
  k INT PRIMARY KEY,
  i INT
);

-- Test 74: statement (line 458)
INSERT INTO corr VALUES (1, 10), (2, 22), (3, 30), (4, 40), (5, 50);

-- Test 75: query (line 461)
SELECT * FROM corr
WHERE CASE WHEN k < 5 THEN k*10 = (SELECT i FROM corr tmp WHERE k = corr.k) END;

-- Test 76: query (line 469)
SELECT k, i, CASE WHEN k > 1 THEN (SELECT i FROM corr tmp WHERE k = corr.k-1) END AS prev_i
FROM corr;

-- Test 77: query (line 482)
SELECT k, i,
  CASE WHEN k > 1 THEN (SELECT i/1 FROM corr tmp WHERE i < corr.i ORDER BY i DESC LIMIT 1) END prev_i
FROM corr;

-- Test 78: statement (line 496)
PREPARE corr_s1(INT) AS
SELECT k, i,
  CASE WHEN k > 1 THEN (SELECT i/$1 FROM corr tmp WHERE i < corr.i ORDER BY i DESC LIMIT $1) END prev_i
FROM corr;

-- Test 79: query (line 502)
EXECUTE corr_s1(1);

-- Test 80: query (line 513)
SELECT k, i,
  CASE WHEN k > 1 THEN (
    SELECT * FROM (VALUES (33::DECIMAL)) v(i)
    UNION ALL
    SELECT i/1 FROM corr tmp WHERE i < corr.i
    ORDER BY i DESC LIMIT 1
  ) END prev_i
FROM corr;

-- Test 81: query (line 530)
SELECT * FROM corr
WHERE CASE WHEN k < 5 THEN EXISTS (SELECT i FROM corr tmp WHERE i = corr.k*10) END;

-- Test 82: query (line 538)
SELECT *,
  CASE WHEN k < 5 THEN EXISTS (SELECT i FROM corr tmp WHERE i = corr.k*10) END
FROM corr;

-- Test 83: statement (line 550)
SELECT * FROM corr
WHERE CASE WHEN k < 5 THEN k*10 = ANY (SELECT i FROM corr tmp WHERE k <= corr.k) END;

-- Test 84: query (line 555)
WITH w AS MATERIALIZED (
  (VALUES (1))
)
SELECT k, i,
  CASE WHEN k > 0 THEN (SELECT i+corr.i FROM corr tmp UNION ALL SELECT * FROM w LIMIT 1) END i_plus_first_i
FROM corr;

-- Test 85: query (line 572)
WITH w AS MATERIALIZED (
  (VALUES (1))
)
SELECT k, i,
  CASE WHEN k > 0 THEN (SELECT i+corr.i FROM corr tmp WHERE k = (SELECT * FROM w)) END i_plus_first_i
FROM corr;

-- Test 86: query (line 588)
WITH w(i) AS MATERIALIZED (
  (VALUES (1))
)
SELECT k, i,
  CASE WHEN k > 0 THEN (
    WITH w(i) AS MATERIALIZED (
      (VALUES (2))
    )
    SELECT * FROM w UNION ALL SELECT i+corr.i FROM corr tmp LIMIT 1
  ) END w
FROM corr
UNION ALL
SELECT NULL, NULL, i FROM w;

-- Test 87: statement (line 611)
CREATE TABLE corr2 (i INT);

-- Test 88: statement (line 615)
WITH tmp AS NOT MATERIALIZED (INSERT INTO corr2 VALUES (1) RETURNING i)
SELECT * FROM corr
WHERE CASE WHEN k < 5 THEN k+1 = (SELECT i FROM tmp WHERE i = corr.k) END;

-- Test 89: query (line 621)
SELECT count(*) FROM corr2;

-- Test 90: query (line 627)
SELECT i FROM (VALUES (1), (2)) v(i)
WHERE CASE
  WHEN i < 3 THEN (SELECT 1/i = 1 FROM (VALUES (1)) WHERE EXISTS (SELECT * FROM corr))
  ELSE false
END;

-- Test 91: query (line 637)
SELECT i FROM (VALUES (1), (10)) v(i)
WHERE CASE
  WHEN i > 0 THEN (
    SELECT i/1 = j FROM (VALUES (1), (10)) w(j)
    WHERE CASE
      WHEN j > 0 THEN EXISTS (SELECT * FROM corr WHERE k/1 = j)
      ELSE false
    END
  )
  ELSE false
END;

-- Test 92: statement (line 655)
CREATE TABLE z (z INT PRIMARY KEY);

-- Test 93: query (line 659)
SELECT * FROM  z WHERE CAST(COALESCE((SELECT 'a' FROM crdb_internal.zones LIMIT 1 OFFSET 5), (SELECT 'b' FROM pg_catalog.pg_trigger LIMIT 1)) AS BYTEA) <= 'a';

-- Test 94: query (line 664)
SELECT * FROM z WHERE CAST(COALESCE((SELECT 'a'), (SELECT 'a')) AS bytea) < 'a';

-- Test 95: statement (line 668)
CREATE TABLE test (a INT PRIMARY KEY);

-- Test 96: statement (line 671)
CREATE TABLE test2(b INT PRIMARY KEY);

-- Test 97: query (line 675)
SELECT * FROM test2 WHERE 0 = CASE WHEN true THEN (SELECT a FROM test LIMIT 1) ELSE 10 END;

-- Test 98: query (line 680)
SELECT (SELECT ARRAY(SELECT 1))[1];

-- Test 99: query (line 685)
SELECT (SELECT 123 IN (VALUES (1), (2)));

-- Test 100: statement (line 690)
SELECT * FROM xyz WHERE x IN (SELECT crdb_internal.force_error('', 'subqueryfail'));

-- Test 101: statement (line 693)
PREPARE a AS SELECT 1 = (SELECT $1::int);

-- Test 102: query (line 696)
EXECUTE a(1);

-- Test 103: query (line 701)
EXECUTE a(2);

-- Test 104: statement (line 706)
PREPARE b AS SELECT EXISTS (SELECT $1::int);

-- Test 105: query (line 709)
EXECUTE b(3);

-- Test 106: statement (line 717)
CREATE TABLE a (a TEXT PRIMARY KEY);

-- Test 107: statement (line 723)
UPDATE abc SET a = 2, (b, c) = (SELECT 5, 6) WHERE a = 1;

-- Test 108: statement (line 727)
-- CockroachDB-only: SELECT crdb_internal.force_error('foo', 'bar') FROM [INSERT INTO abc VALUES (11,12,13) RETURNING a]
INSERT INTO abc VALUES (11, 12, 13);

-- Test 109: query (line 730)
SELECT * FROM abc WHERE a = 11;

-- Test 110: statement (line 734)
INSERT INTO abc VALUES (1,2, (SELECT crdb_internal.force_error('foo', 'bar')));

-- Test 111: query (line 738)
SELECT 3::decimal IN (SELECT 1);

-- Test 112: query (line 743)
SELECT 3::decimal IN (SELECT 1::int);

-- query B
SELECT 1 IN (SELECT '1'::int);

-- Test 113: query (line 752)
SELECT
  t.oid, t.typname, t.typsend, t.typreceive, t.typoutput, t.typinput, t.typelem
FROM
  pg_type AS t
WHERE
  t.oid
  NOT IN (SELECT (ARRAY[704, 11676, 10005, 3912, 11765, 59410, 11397])[i] FROM generate_series(1, 376) AS i);

-- Test 114: statement (line 763)
CREATE TABLE t96441 (
  k INT PRIMARY KEY,
  i INT,
  CHECK (k IN (1, 2))
);
INSERT INTO t96441 VALUES (1, 10);

-- Test 115: query (line 771)
SELECT * FROM (VALUES (0))
LEFT JOIN t96441 AS t1
ON 1 IN (SELECT t1.i FROM t96441);

-- Test 116: statement (line 779)
-- CockroachDB-only: ALTER TABLE abc INJECT STATISTICS '[
-- {
-- "columns": ["a"],
-- "created_at": "2018-05-01 1:00:00.00000+00:00",
-- "row_count": 10000,
-- "distinct_count": 10000
-- }
-- ]'

-- Test 117: statement (line 789)
-- CockroachDB-only: ALTER TABLE abc INJECT STATISTICS '[
-- {
-- "columns": ["b"],
-- "created_at": "2018-05-01 1:00:00.00000+00:00",
-- "row_count": 10000,
-- "distinct_count": 10000
-- }
-- ]'

-- Test 118: statement (line 799)
-- CockroachDB-only: ALTER TABLE xyz INJECT STATISTICS '[
-- {
-- "columns": ["x"],
-- "created_at": "2018-05-01 1:00:00.00000+00:00",
-- "row_count": 1000,
-- "distinct_count": 1000
-- }
-- ]'

-- Test 119: statement (line 809)
-- CockroachDB-only: ALTER TABLE xyz INJECT STATISTICS '[
-- {
-- "columns": ["y"],
-- "created_at": "2018-05-01 1:00:00.00000+00:00",
-- "row_count": 1000,
-- "distinct_count": 1000
-- }
-- ]'

-- Test 120: statement (line 819)
INSERT INTO xyz VALUES(5, 4, 7);

-- Test 121: statement (line 822)
INSERT INTO abc VALUES(12, 13, 14);

-- Test 122: statement (line 825)
CREATE INDEX abc_b ON abc(b);

-- Test 123: statement (line 828)
CREATE INDEX xyz_y ON xyz(y);

-- Test 124: query (line 832)
SELECT * FROM abc WHERE EXISTS (SELECT * FROM xyz WHERE abc.a = xyz.x OR abc.b = xyz.y);

-- Test 125: query (line 839)
SELECT * FROM abc WHERE EXISTS (SELECT * FROM xyz WHERE abc.a = xyz.y OR abc.b = xyz.x);

-- Test 126: query (line 846)
SELECT * FROM abc WHERE EXISTS (SELECT * FROM xyz WHERE (abc.a = xyz.x OR abc.b = xyz.y)and abc.a > 3 AND xyz.z > 10);

-- Test 127: query (line 851)
SELECT * FROM abc WHERE EXISTS (SELECT * FROM xyz WHERE (abc.a = xyz.y OR abc.b = xyz.x) AND abc.a > 3 AND xyz.z > 10);

-- Test 128: query (line 856)
SELECT * FROM abc WHERE NOT EXISTS (SELECT * FROM xyz WHERE abc.a = xyz.x OR abc.b = xyz.y);

-- Test 129: query (line 861)
SELECT * FROM abc WHERE NOT EXISTS (SELECT * FROM xyz WHERE abc.a = xyz.y OR abc.b = xyz.x);

-- Test 130: query (line 866)
SELECT * FROM abc WHERE NOT EXISTS (SELECT * FROM xyz WHERE (abc.a = xyz.x OR abc.b = xyz.y)and abc.a > 3 AND xyz.z > 10);

-- Test 131: query (line 873)
SELECT * FROM abc WHERE NOT EXISTS (SELECT * FROM xyz WHERE (abc.a = xyz.y OR abc.b = xyz.x) AND abc.a > 3 AND xyz.z > 10);

-- Test 132: query (line 880)
SELECT * FROM abc WHERE EXISTS (SELECT * FROM xyz WHERE (abc.a = xyz.x OR abc.b = xyz.y) AND (abc.a = xyz.y OR abc.b = xyz.y));

-- Test 133: query (line 886)
SELECT * FROM abc WHERE NOT EXISTS (SELECT * FROM xyz WHERE (abc.a = xyz.x OR abc.b = xyz.y) AND (abc.a = xyz.y OR abc.b = xyz.y));

-- Test 134: query (line 899)
-- CockroachDB-only: select lower((select session_id from [show session_id])) = lower('$session_id')

-- Test 135: statement (line 906)
CREATE TABLE xy (x INT, y INT);

-- Test 136: statement (line 909)
CREATE TABLE ab (a INT, b INT);

-- Test 137: statement (line 912)
INSERT INTO xy VALUES (1,1), (2,2); INSERT INTO ab VALUES (2,2);

-- Test 138: query (line 917)
SELECT * FROM ab WHERE (a, b) IN (SELECT x+1, y+1 FROM xy);

-- Test 139: query (line 925)
-- CockroachDB-specific nested tuple comparison; PostgreSQL errors on record-vs-scalar comparison.
-- SELECT * FROM ab WHERE ROW(ROW(a, b)) IN (SELECT x+1 FROM xy);

-- The outer ROW(ROW(a, b)) is already a tuple, so shouldn't be wrapped in
-- another tuple before comparison. But the comparison should fail due to
-- mismatched types. Could this case possibly be supported?
-- query error pgcode 22023 unsupported comparison operator: <tuple\{tuple\{int, int\}\}> IN <tuple\{tuple\{int, int\}\}>
-- SELECT * FROM ab WHERE ROW(ROW(a, b)) IN (SELECT (x, y) FROM xy);

-- A similar case to the previous one, but this time matching on 2 tuple
-- expressions works.
-- query II
SELECT * FROM ab WHERE ((a,b), (1, 1)) IN (SELECT (x+1, y+1), (x, y) FROM xy);

-- Test 140: query (line 942)
SELECT * FROM ab WHERE (a, b) IN (SELECT x+1, y+1 FROM xy);

-- Test 141: query (line 949)
SELECT (SELECT ROW(2, 2)) IN (SELECT ROW(x+1, y+1) FROM xy);

-- Test 142: query (line 954)
SELECT (2, 2) IN (SELECT x+1, y+1 FROM xy);

-- Test 143: query (line 962)
-- CockroachDB-specific scalar subquery returning multiple columns; PostgreSQL requires a single column.
-- SELECT (SELECT (2, 2), (3, 3)) IN (SELECT x+1, y+1 FROM xy);

-- Outer scalar is a tuple with 2 elements. Subquery has only 1 column.
-- query error pgcode 42601 subquery has too few columns
-- SELECT (SELECT 2, 2) IN (SELECT x+1 FROM xy)

-- Outer scalar is a tuple with 2 elements. Subquery has 3 columns.
-- query error pgcode 42601 subquery has too many columns
-- SELECT (SELECT 2, 2) IN (SELECT x+1, y+1, x+y FROM xy)

-- subtest end

-- subtest regression_100561

-- Regression test for #100561.
-- statement ok
CREATE TABLE t100561a (a INT);
CREATE TABLE t100561bc (b INT, c INT);
INSERT INTO t100561bc (b) VALUES(1);

-- The query below should return a single row. Prior to the fix for #100561, no
-- rows were returned because the optimizer synthesized an incorrect
-- null-rejecting filter for column c.
-- query IIII
SELECT * FROM (
  SELECT bc.c + 1 AS y, bc.b + 1 AS x
  FROM t100561a a FULL OUTER JOIN t100561bc bc ON true
) tmp, t100561bc bc
WHERE tmp.x = bc.b + 1;

-- Test 144: query (line 1002)
WITH a (colA) AS (
	VALUES ('row-1'), ('row-2')
),
b (colB) AS (
	VALUES ('row-1'), ('row-2')
)
SELECT a.colA, l.colB, l.colB_agg, l.count
FROM a
LEFT JOIN LATERAL (
	SELECT colB, array_agg(colB) AS colB_agg, count(*) AS count
	FROM b
	WHERE colB = a.colA
	GROUP BY colB
) l ON true;

-- Test 145: query (line 1021)
WITH a (colA) AS (
	VALUES ('row-1'), ('row-2')
),
b (colB) AS (
	VALUES ('row-1'), ('row-2')
)
SELECT a.colA, l.colB, l.colB_agg, l.count
FROM a
LEFT JOIN LATERAL (
	SELECT colB, array_agg(colB) AS colB_agg, count(*) AS count
	FROM b
	WHERE colB = a.colA
	GROUP BY colB
) l ON true
  -- redundant filter
	AND l.colB = a.colA;

-- Test 146: statement (line 1044)
CREATE TABLE t127814_empty (i INT);

-- Test 147: statement (line 1047)
CREATE TABLE t127814 (o OID);

-- Test 148: statement (line 1050)
INSERT INTO t127814 VALUES (0);

-- Test 149: query (line 1053)
SELECT o NOT IN (SELECT NULL::oid FROM t127814_empty) FROM t127814;

-- Test 150: statement (line 1060)
CREATE TABLE t130759 (
  i INT
);

-- Test 151: statement (line 1065)
INSERT INTO t130759 VALUES (0);

-- Test 152: query (line 1068)
SELECT 1
FROM t130759
WHERE NOT (
  ('127.0.0.1'::INET - i) IN (
    SELECT NULL::inet FROM (VALUES (0)) v(i) WHERE false
  )
);
