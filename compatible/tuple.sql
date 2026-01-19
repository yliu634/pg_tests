-- PostgreSQL compatible tests from tuple
-- 131 tests

-- Test 1: statement (line 1)
CREATE TABLE tb(unused INT); INSERT INTO tb VALUES (1)

-- Test 2: query (line 6)
SELECT 1 IN (SELECT * FROM tb LIMIT 0)

-- Test 3: query (line 11)
SELECT 1 IN ()

-- Test 4: query (line 16)
SELECT 1 = ANY ()

-- Test 5: query (line 24)
SELECT (1, 2, 'hello', NULL, NULL) AS t, (true, NULL, (false, 6.6, false)) AS u FROM tb

-- Test 6: query (line 30)
SELECT (1, e'hello\nworld')

-- Test 7: query (line 36)
SELECT
  (2, 2) < (1, 1) AS a,
  (2, 2) < (1, 2) AS b,
  (2, 2) < (1, 3) AS c,
  (2, 2) < (2, 1) AS d,
  (2, 2) < (2, 2) AS e,
  (2, 2) < (2, 3) AS f,
  (2, 2) < (3, 1) AS g,
  (2, 2) < (3, 2) AS h,
  (2, 2) < (3, 3) AS i
  FROM tb

-- Test 8: query (line 52)
SELECT
  (2, 2) > (1, 1) AS a,
  (2, 2) > (1, 2) AS b,
  (2, 2) > (1, 3) AS c,
  (2, 2) > (2, 1) AS d,
  (2, 2) > (2, 2) AS e,
  (2, 2) > (2, 3) AS f,
  (2, 2) > (3, 1) AS g,
  (2, 2) > (3, 2) AS h,
  (2, 2) > (3, 3) AS i
  FROM tb

-- Test 9: query (line 68)
SELECT
  (2, 2) <= (1, 1) AS a,
  (2, 2) <= (1, 2) AS b,
  (2, 2) <= (1, 3) AS c,
  (2, 2) <= (2, 1) AS d,
  (2, 2) <= (2, 2) AS e,
  (2, 2) <= (2, 3) AS f,
  (2, 2) <= (3, 1) AS g,
  (2, 2) <= (3, 2) AS h,
  (2, 2) <= (3, 3) AS i
  FROM tb

-- Test 10: query (line 84)
SELECT
  (2, 2) >= (1, 1) AS a,
  (2, 2) >= (1, 2) AS b,
  (2, 2) >= (1, 3) AS c,
  (2, 2) >= (2, 1) AS d,
  (2, 2) >= (2, 2) AS e,
  (2, 2) >= (2, 3) AS f,
  (2, 2) >= (3, 1) AS g,
  (2, 2) >= (3, 2) AS h,
  (2, 2) >= (3, 3) AS i
  FROM tb

-- Test 11: query (line 100)
SELECT
  (2, 2) = (1, 1) AS a,
  (2, 2) = (1, 2) AS b,
  (2, 2) = (1, 3) AS c,
  (2, 2) = (2, 1) AS d,
  (2, 2) = (2, 2) AS e,
  (2, 2) = (2, 3) AS f,
  (2, 2) = (3, 1) AS g,
  (2, 2) = (3, 2) AS h,
  (2, 2) = (3, 3) AS i
  FROM tb

-- Test 12: query (line 116)
SELECT
  (2, 2) != (1, 1) AS a,
  (2, 2) != (1, 2) AS b,
  (2, 2) != (1, 3) AS c,
  (2, 2) != (2, 1) AS d,
  (2, 2) != (2, 2) AS e,
  (2, 2) != (2, 3) AS f,
  (2, 2) != (3, 1) AS g,
  (2, 2) != (3, 2) AS h,
  (2, 2) != (3, 3) AS i
  FROM tb

-- Test 13: query (line 132)
SELECT
  (1, 1) > (0, NULL) AS a,
  (1, 1) > (1, NULL) AS b,
  (1, 1) > (2, NULL) AS c,
  (1, 1) > (NULL, 0) AS d
  FROM tb

-- Test 14: statement (line 143)
SELECT (1, 2) > (1, 'hi') FROM tb

-- Test 15: statement (line 146)
SELECT (1, 2) > (1, 2, 3) FROM tb

-- Test 16: statement (line 149)
CREATE TABLE t (a int, b int, c int)

-- Test 17: statement (line 152)
INSERT INTO t VALUES (1, 2, 3), (2, 3, 1), (3, 1, 2)

-- Test 18: query (line 155)
SELECT * FROM t ORDER BY a, b, c

-- Test 19: query (line 163)
SELECT * FROM t WHERE (a, b, c) > (1, 2, 3) AND (a, b, c) < (8, 9, 10) ORDER BY a, b, c

-- Test 20: query (line 170)
SELECT (t.*) AS a FROM t

-- Test 21: query (line 178)
SELECT ((1, 2), 'equal') = ((1, 2.0), 'equal') AS a,
       ((1, 2), 'equal') = ((1, 2.0), 'not equal') AS b
	   FROM tb

-- Test 22: query (line 186)
SELECT ((1, 2), 'equal') = ((1, 2.1), 'equal') AS a
  FROM tb

-- Test 23: query (line 193)
SELECT (ROW(pow(1, 10.0) + 9), 'a' || 'b') = (ROW(sqrt(100.0)), 'ab') AS a
  FROM tb

-- Test 24: query (line 200)
SELECT (ROW(sqrt(100.0)), 'ab') = (ROW(pow(1, 10.0) + 9), 'a' || 'b') AS a
  FROM tb

-- Test 25: query (line 207)
SELECT ((1, 2), 'equal') = ((1, 'huh'), 'equal') FROM tb

# Issue #3568

statement ok
CREATE TABLE kv (
  k INT PRIMARY KEY,
  v INT
)

statement ok
INSERT INTO kv VALUES (1, 2)

query II colnames
SELECT k, v FROM kv WHERE (k, v) = (1, 100)

-- Test 26: query (line 226)
SELECT k, v FROM kv WHERE (k, v) IN ((1, 100))

-- Test 27: statement (line 231)
DROP TABLE kv

-- Test 28: query (line 236)
SELECT 'foo' IN (x, 'aaa') AS r FROM (SELECT 'foo' AS x FROM tb)

-- Test 29: query (line 242)
SELECT 'foo' IN (x, 'zzz') AS r FROM (SELECT 'foo' AS x FROM tb)

-- Test 30: query (line 250)
SELECT 3 IN (SELECT c FROM t ORDER BY 1 ASC) AS r

-- Test 31: query (line 256)
SELECT 4 IN (SELECT c FROM t ORDER BY 1 DESC) AS r

-- Test 32: query (line 262)
SELECT (1, 2) IN (SELECT a, b FROM t ORDER BY 1 ASC, 2 ASC) AS r

-- Test 33: query (line 268)
SELECT (1, 2) IN (SELECT a, b FROM t ORDER BY 1 DESC, 2 DESC) AS r

-- Test 34: statement (line 274)
DROP TABLE t

-- Test 35: query (line 279)
SELECT 1 IN (2, NULL) AS r
  FROM tb

-- Test 36: query (line 286)
SELECT 1 IN (2, x) AS r FROM (SELECT NULL AS x FROM tb)

-- Test 37: query (line 293)
SELECT (now(), 2) = (now() :: timestamp, 2) AS r
  FROM tb

-- Test 38: query (line 300)
SELECT (1, 2) > (1.0, 2.0) AS r
  FROM tb

-- Test 39: statement (line 307)
CREATE TABLE uvw (
  u INT,
  v INT,
  w INT,
  INDEX (u,v,w)
)

-- Test 40: statement (line 315)
INSERT INTO uvw SELECT u, v, w FROM
  generate_series(0, 3) AS u,
  generate_series(0, 3) AS v,
  generate_series(0, 3) AS w;
UPDATE uvw SET u = NULL WHERE u = 0;
UPDATE uvw SET v = NULL WHERE v = 0;
UPDATE uvw SET w = NULL WHERE w = 0

-- Test 41: query (line 324)
SELECT * FROM uvw ORDER BY u, v, w

-- Test 42: query (line 393)
SELECT * FROM uvw WHERE (u, v, w) >= (1, 2, 3) ORDER BY u, v, w

-- Test 43: query (line 435)
SELECT * FROM uvw WHERE (u, v, w) > (2, 1, 1) ORDER BY u, v, w

-- Test 44: query (line 466)
SELECT * FROM uvw WHERE (u, v, w) <= (2, 3, 1) ORDER BY u, v, w

-- Test 45: query (line 496)
SELECT * FROM uvw WHERE (u, v, w) < (2, 2, 2) ORDER BY u, v, w

-- Test 46: query (line 522)
SELECT * FROM uvw WHERE (u, v, w) != (1, 2, 3) ORDER BY u, v, w

-- Test 47: query (line 583)
SELECT * FROM uvw WHERE (u, v, w) >= (1, NULL, 3) ORDER BY u, v, w

-- Test 48: query (line 620)
SELECT * FROM uvw WHERE (u, v, w) < (2, NULL, 3) ORDER BY u, v, w

-- Test 49: statement (line 641)
DROP TABLE uvw

-- Test 50: statement (line 646)
PREPARE x AS SELECT $1 = (1,2) AS r FROM tb

-- Test 51: statement (line 649)
PREPARE y AS SELECT (1,2) = $1 AS r FROM tb

-- Test 52: query (line 652)
EXECUTE x((1,2))

-- Test 53: query (line 658)
EXECUTE y((1,2))

-- Test 54: query (line 664)
EXECUTE x((1,2,3))

subtest labeled_tuple

# Selecting two tuples
query TT colnames
SELECT ((1, 2, 'hello', NULL, NULL) AS a1, b2, c3, d4, e5) AS r,
       ((true, NULL, (false, 6.6, false)) AS a1, b2, c3) AS s
  FROM tb

-- Test 55: query (line 680)
SELECT ((1, '2') AS a, a) FROM tb

-- Test 56: query (line 686)
SELECT ((1, '2', true) AS a, a, b) FROM tb

-- Test 57: query (line 691)
SELECT ((1, '2', true) AS a, b, a) FROM tb

-- Test 58: query (line 696)
SELECT ((1, 'asd', true) AS b, a, a) FROM tb

-- Test 59: query (line 701)
SELECT ((1, 2, 'hello', NULL, NULL) AS a, a, a, a, a) AS r,
       ((true, NULL, (false, 6.6, false)) AS a, a, a) AS s
  FROM tb

-- Test 60: query (line 710)
SELECT ((2, 2) AS a, b) < ((1, 1) AS c, d) AS r
      ,((2, 2) AS a, b) < (1, 2) AS s
      ,(2, 2) < ((1, 3) AS c, d) AS t
 FROM tb

-- Test 61: statement (line 719)
SELECT ((1, 2) AS a, b) > ((1, 'hi') AS c, d) FROM tb

-- Test 62: statement (line 722)
SELECT ((1, 2) AS a, b, c) > ((1, 2, 3) AS a, b, c) FROM tb

-- Test 63: query (line 725)
SELECT ((((1, 2) AS a, b), 'value') AS c, d) = ((((1, 2) AS e, f), 'value') AS g, h) AS nnnn
      ,((((1, 2) AS a, b), 'value') AS c, d) = (((1, 2) AS e, f), 'value')           AS nnnu
      ,((((1, 2) AS a, b), 'value') AS c, d) = (((1, 2), 'value') AS g, h)           AS nnun
      ,((((1, 2) AS a, b), 'value') AS c, d) = ((1, 2), 'value')                     AS nnuu
      ,(((1, 2) AS a, b), 'value')           = ((((1, 2) AS e, f), 'value') AS g, h) AS nunn
      ,(((1, 2) AS a, b), 'value')           = (((1, 2) AS e, f), 'value')           AS nunu
      ,(((1, 2) AS a, b), 'value')           = (((1, 2), 'value') AS g, h)           AS nuun
      ,(((1, 2) AS a, b), 'value')           = ((1, 2), 'value')                     AS nuuu
      ,(((1, 2), 'value') AS c, d)           = ((((1, 2) AS e, f), 'value') AS g, h) AS unnn
      ,(((1, 2), 'value') AS c, d)           = (((1, 2) AS e, f), 'value')           AS unnu
      ,(((1, 2), 'value') AS c, d)           = (((1, 2), 'value') AS g, h)           AS unun
      ,(((1, 2), 'value') AS c, d)           = ((1, 2), 'value')                     AS unuu
      ,((1, 2), 'value')                     = ((((1, 2) AS e, f), 'value') AS g, h) AS uunn
      ,((1, 2), 'value')                     = (((1, 2) AS e, f), 'value')           AS uunu
      ,((1, 2), 'value')                     = (((1, 2), 'value') AS g, h)           AS uuun
      ,((1, 2), 'value')                     = ((1, 2), 'value')                     AS uuuu
 FROM tb

-- Test 64: query (line 747)
SELECT (((ROW(pow(1, 10.0) + 9) AS t1), 'a' || 'b') AS t2, t3) = (((ROW(sqrt(100.0)) AS t4), 'ab') AS t5, t6) AS a
      ,(ROW(pow(1, 10.0) + 9), 'a' || 'b') = (((ROW(sqrt(100.0)) AS t4), 'ab') AS t5, t6) AS b
 FROM tb

-- Test 65: query (line 757)
SELECT ((((1, 2) AS a, b), 'equal') AS c, d) = ((((1, 'huh') AS e, f), 'equal') AS g, h) FROM tb

# Ensure the number of labels matches the number of expressions
query error pq: mismatch in tuple definition: 2 expressions, 1 labels
SELECT ((1, '2') AS a) FROM tb

query error pq: mismatch in tuple definition: 1 expressions, 2 labels
SELECT (ROW(1) AS a, b) FROM tb

# But inner tuples can reuse labels
query T colnames
SELECT ((
         (
          (((1, '2', 3) AS a, b, c),
           ((4,'5') AS a, b),
		   (ROW(6) AS a))
		   AS a, b, c),
		 ((7, 8) AS a, b),
		 (ROW('9') AS a))
		 AS a, b, c
		) AS r
 FROM tb

-- Test 66: query (line 789)
SELECT (((1,2,3) AS a,b,c)).x FROM tb

query ITBITB colnames
SELECT (((1,'2',true) AS a,b,c)).a
      ,(((1,'2',true) AS a,b,c)).b
      ,(((1,'2',true) AS a,b,c)).c
      ,((ROW(1,'2',true) AS a,b,c)).a
      ,((ROW(1,'2',true) AS a,b,c)).b
      ,((ROW(1,'2',true) AS a,b,c)).c
 FROM tb

-- Test 67: query (line 807)
SELECT (((1,2,3) AS a,b,c)).x FROM tb

# Missing extra parentheses
query error at or near ".": syntax error
SELECT ((1,2,3) AS a,b,c).x FROM tb

query error at or near ".": syntax error
SELECT ((1,2,3) AS a,b,c).* FROM tb

# Accessing duplicate labels
query error pq: column reference "a" is ambiguous
SELECT (((1,2,3) AS a,b,a)).a FROM tb

query error pq: column reference "unnest" is ambiguous
SELECT ((unnest(ARRAY[1,2], ARRAY[1,2]))).unnest;

# No labels
query error pq: could not identify column "x" in record data type
SELECT ((1,2,3)).x FROM tb

query I colnames
SELECT ((1,2,3)).@2 FROM tb

-- Test 68: query (line 834)
SELECT ((1,2,3)).* FROM tb

-- Test 69: query (line 842)
SELECT (((1,'2',true) AS a,b,c)).* FROM tb

-- Test 70: query (line 848)
SELECT ((ROW(1,'2',true) AS a,b,c)).* FROM tb

-- Test 71: query (line 854)
SELECT (((ROW(1,'2',true) AS a,b,c)).*, 456) FROM tb

-- Test 72: query (line 859)
SELECT ((ROW(1) AS a)).* FROM tb

-- Test 73: query (line 868)
SELECT (x).e, (x).f, (x).g
FROM (
  SELECT ((1,'2',true) AS e,f,g) AS x FROM tb
)

-- Test 74: query (line 877)
SELECT (x).*
FROM (
  SELECT ((1,'2',true) AS e,f,g) AS x FROM tb
)

-- Test 75: query (line 888)
SELECT (x).a, (x).b
    FROM (SELECT (ROW(a, b) AS a, b) AS x FROM (VALUES (1, 'one')) AS t(a, b))

-- Test 76: statement (line 897)
INSERT INTO t VALUES (1, 'one'), (2, 'two')

-- Test 77: query (line 900)
SELECT (x).a, (x).b
    FROM (SELECT (ROW(a, b) AS a, b) AS x FROM t)
ORDER BY 1
   LIMIT 1

-- Test 78: query (line 910)
SELECT (t.*).* FROM t ORDER BY 1,2

-- Test 79: query (line 917)
SELECT (t).a FROM t

-- Test 80: query (line 923)
SELECT t FROM t

-- Test 81: query (line 929)
SELECT row_to_json(t) FROM t

-- Test 82: statement (line 935)
DROP TABLE t

-- Test 83: query (line 938)
SELECT (1, 2, 3) IS NULL AS r

-- Test 84: query (line 945)
SELECT () = ()

-- Test 85: statement (line 954)
CREATE TABLE t58439 (a INT, b INT);
INSERT INTO t58439 VALUES (1, 10), (2, 20), (3, 30);

-- Test 86: query (line 958)
SELECT (ARRAY[t58439.*][0]).* FROM t58439

-- Test 87: query (line 965)
SELECT (ARRAY[t58439.*][2]).* FROM t58439

-- Test 88: query (line 976)
SELECT (1::INT2, NULL)
UNION
SELECT (1::INT, NULL)

-- Test 89: statement (line 987)
CREATE TABLE t(x INT);
CREATE TABLE t40297 AS SELECT g FROM generate_series(NULL, NULL) AS g

-- Test 90: query (line 991)
SELECT COALESCE((SELECT ()), NULL) FROM t40297

-- Test 91: query (line 996)
SELECT COALESCE((SELECT ())::record, NULL) FROM t40297

-- Test 92: statement (line 1001)
SELECT COALESCE((SELECT ()), (SELECT ROW (1))) FROM t40297

-- Test 93: statement (line 1005)
SELECT COALESCE((SELECT ()), (SELECT ROW (1))::t) FROM t40297

-- Test 94: statement (line 1009)
SELECT COALESCE((SELECT ()), NULL::t) FROM t40297

-- Test 95: query (line 1013)
SELECT COALESCE((SELECT '(1)'::t), NULL::t) FROM t40297

-- Test 96: statement (line 1018)
SELECT COALESCE((SELECT (1)), NULL::t) FROM t40297

-- Test 97: query (line 1022)
SELECT COALESCE((SELECT ROW (1)), NULL::t) FROM t40297

-- Test 98: statement (line 1027)
SELECT COALESCE((SELECT ROW (1, 2)), NULL::t) FROM t40297

-- Test 99: statement (line 1031)
SELECT COALESCE(ROW (1, 2), NULL::t) FROM t40297

-- Test 100: query (line 1038)
SELECT
  col
FROM
  (VALUES ((ARRAY[]::RECORD[])), ((ARRAY[()])))
    AS t(col)
ORDER BY
  col ASC

-- Test 101: query (line 1050)
SELECT
  col
FROM
  (VALUES (NULL), ((ARRAY[]::RECORD[])), ((ARRAY[()])))
    AS t(col)
ORDER BY
  col ASC

-- Test 102: statement (line 1064)
SELECT
  col
FROM
  (VALUES ((ARRAY[]::RECORD[])), ((ARRAY[(1)])))
    AS t(col)
ORDER BY
  col ASC

-- Test 103: statement (line 1073)
SELECT
  col
FROM
  (VALUES ((ARRAY[]::RECORD[])), ((ARRAY[(1,2)])), ((ARRAY[(1,'cat')])))
    AS t(col)
ORDER BY
  col ASC

-- Test 104: query (line 1082)
SELECT
  col
FROM
  (VALUES ((ARRAY[]::RECORD[])), ((ARRAY[(1,2)])))
    AS t(col)
ORDER BY
  col ASC

-- Test 105: query (line 1094)
SELECT
  col
FROM
  (VALUES ((ARRAY[(1,2)])), ((ARRAY[]::RECORD[])))
    AS t(col)
ORDER BY
  col ASC

-- Test 106: query (line 1106)
SELECT
  col
FROM
  (VALUES ((ARRAY[]::RECORD[])),  ((ARRAY[(1,2), (3,4)])))
    AS t(col)
ORDER BY
  col ASC

-- Test 107: statement (line 1118)
SELECT
  col
FROM
  (VALUES ((ARRAY[]::RECORD[])),  ((ARRAY[(1,2), (3,4), (3,4,5)])))
    AS t(col)
ORDER BY
  col ASC

-- Test 108: query (line 1127)
SELECT
  col
FROM
  (VALUES ((ARRAY[]::RECORD[])), ((ARRAY[(1,'cat')])))
    AS t(col)
ORDER BY
  col ASC

-- Test 109: query (line 1139)
SELECT
  t2.c4
FROM
  (
    VALUES
      (NULL, (1:::DECIMAL, ARRAY[]:::record[])),
      (NULL, (2:::DECIMAL, ARRAY[(1::INT8, 2::INT8)]))
  )
    AS t2 (c3, c4)

-- Test 110: statement (line 1153)
SELECT
  t2.c4
FROM
  (
    VALUES
      (NULL, (1:::DECIMAL, ARRAY[]:::record[])),
      (NULL, (2:::DECIMAL, ARRAY[(1::INT8, 2::INT8, 3::INT8)])),
      (NULL, (2:::DECIMAL, ARRAY[(1::INT8, 2::INT8)]))
  )
    AS t2 (c3, c4)

-- Test 111: statement (line 1165)
SELECT
  t2.c4
FROM
  (
    VALUES
      (NULL, (1:::DECIMAL, ARRAY[]:::record[])),
      (NULL, (2:::DECIMAL, ARRAY[(1::INT8, 2::INT8)])),
      (NULL, (2:::DECIMAL, ARRAY[(1::INT8, 2::INT8, 3::INT8)]))
  )
    AS t2 (c3, c4)

-- Test 112: statement (line 1180)
SELECT CASE WHEN true THEN ('a', 2) ELSE NULL:::RECORD END

-- Test 113: statement (line 1183)
CREATE TABLE t74729 AS SELECT g % 2 = 1 AS _bool FROM generate_series(1, 5) AS g

-- Test 114: statement (line 1186)
SELECT CASE WHEN _bool THEN (1, ('a', 2)) ELSE (3, NULL) END FROM t74729

-- Test 115: statement (line 1193)
CREATE TABLE t78159 (b BOOL)

-- Test 116: statement (line 1196)
INSERT INTO t78159 VALUES (false)

-- Test 117: query (line 1199)
SELECT (CASE WHEN b THEN NULL ELSE ((ROW(1) AS a)) END).a from t78159

-- Test 118: query (line 1204)
SELECT (CASE WHEN b THEN ((ROW(1) AS a)) ELSE NULL END).a from t78159

-- Test 119: statement (line 1213)
SELECT (CASE WHEN false THEN (ROW(1) AS a) ELSE (ROW(2) AS a) END).a;

-- Test 120: statement (line 1218)
SELECT (CASE WHEN false THEN (ROW(1) AS a) ELSE (ROW(2) AS b) END).a;

-- Test 121: statement (line 1221)
SELECT (CASE WHEN false THEN (ROW(1) AS a) ELSE (ROW(2) AS b) END).b;

-- Test 122: query (line 1230)
SELECT * FROM (
  VALUES
    ((ARRAY[15181:::INT8], ARRAY[]:::RECORD[])),
    (
      (ARRAY[1534:::INT8], ARRAY[('infinity':::DATE, 'cat':::TEXT)])
    ),
    (NULL)
) AS tab(col)

-- Test 123: statement (line 1248)
CREATE TABLE t94092 (c INT);
INSERT INTO t94092 VALUES (1);

-- Test 124: query (line 1252)
SELECT (c, 1) != (()) FROM t94092;

# Regression test for #106303.
statement error pgcode 42601 mismatch in tuple definition: 0 expressions, 1 labels
SELECT (ROW() AS a) IS NOT UNKNOWN

statement error pgcode 42601 mismatch in tuple definition: 0 expressions, 1 labels
SELECT CASE WHEN False THEN ROW() ELSE (ROW() AS a) END

subtest 109105

statement ok
CREATE TABLE t109105 (a int);

statement ok
INSERT INTO t109105 VALUES (1),(2),(3),(4),(5),(6);

# This should CAST the nulls in the rows to the types of the constant values
# instead of erroring out.
query T
SELECT (CASE WHEN a = 1 THEN NULL
             WHEN a = 2 THEN ROW(NULL, NULL, 1.1e3::FLOAT)
             WHEN a = 3 THEN ROW(NULL, 1.1::DECIMAL, NULL)
             WHEN a = 4 THEN ROW(1::INT, null, NULL)
             WHEN a = 5 THEN NULL
             ELSE NULL END) FROM t109105 ORDER BY 1;

-- Test 125: statement (line 1289)
CREATE TABLE t125367 AS SELECT
    g AS _int8, g * '1 day'::INTERVAL AS _interval, g::DECIMAL AS _decimal
    FROM generate_series(1, 5) AS g;
UPDATE t125367 SET _interval = '7 years 1 mon 887 days 18:22:39.99567';
SET testing_optimizer_random_seed = 1481092000980190599;
SET testing_optimizer_disable_rule_probability = 1.000000;
SET vectorize = off;
SET distsql_workmem = '2B';

-- Test 126: statement (line 1305)
RESET testing_optimizer_random_seed;
RESET testing_optimizer_disable_rule_probability;
RESET vectorize;
RESET distsql_workmem;

-- Test 127: query (line 1313)
SELECT * FROM (SELECT (NULL, NULL) AS a) AS b WHERE a IS NOT NULL;

-- Test 128: query (line 1317)
SELECT * FROM (SELECT (1, NULL) AS a) AS b WHERE a IS NOT NULL;

-- Test 129: query (line 1321)
SELECT * FROM (SELECT (1, 2) AS a) AS b WHERE a IS NOT NULL;

-- Test 130: query (line 1326)
SELECT ROW() IS NULL;

-- Test 131: query (line 1331)
SELECT ROW() IS NOT NULL;

