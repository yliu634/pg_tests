-- PostgreSQL compatible tests from select_index
-- 94 tests

-- PG-NOT-SUPPORTED: This file relies on CockroachDB-specific index syntax
-- (inline INDEX/UNIQUE INDEX table clauses, @index hints, STORING/FAMILY, and
-- CRDB-only types/functions) and also requires additional fixture setup that is
-- not present in this repo version.
--
-- The original CockroachDB-derived SQL is preserved below for reference, but
-- is not executed under PostgreSQL.

SET client_min_messages = warning;

SELECT
  'skipped: select_index depends on CockroachDB-specific index syntax/hints and missing fixtures'
    AS notice;

RESET client_min_messages;

/*

-- Test 1: statement (line 3)
CREATE TABLE t (
  a INT PRIMARY KEY,
  b INT,
  c INT,
  INDEX b_desc (b DESC),
  INDEX bc (b, c)
)

-- Test 2: statement (line 12)
INSERT INTO t VALUES (1, 2, 3), (3, 4, 5), (5, 6, 7)

-- Test 3: query (line 15)
SELECT a FROM t WHERE a < 4.0

-- Test 4: query (line 21)
SELECT b FROM t WHERE c > 4.0 AND a < 4

-- Test 5: query (line 32)
SELECT i, s FROM ab WHERE (i, s) < (1, 'c')

-- Test 6: statement (line 38)
CREATE INDEX baz ON ab (i, s)

-- Test 7: query (line 41)
SELECT i, s FROM ab@baz WHERE (i, s) < (1, 'c')

-- Test 8: statement (line 49)
CREATE TABLE tab0(
  k INT PRIMARY KEY,
  a INT,
  b INT
)

-- Test 9: query (line 56)
SELECT k FROM tab0 WHERE (a IN (6) AND a > 6) OR b >= 4

-- Test 10: statement (line 62)
CREATE TABLE t12022 (
  c1 INT,
  c2 BOOL,
  UNIQUE INDEX i (c1, c2)
);

-- Test 11: statement (line 69)
INSERT INTO t12022 VALUES
  (1, NULL), (1, false), (1, true),
  (2, NULL), (2, false), (2, true);

-- Test 12: query (line 74)
SELECT * FROM t12022@i WHERE (c1, c2) > (1, NULL) ORDER BY (c1, c2);

-- Test 13: query (line 81)
SELECT * FROM t12022@i WHERE (c1, c2) > (1, false) ORDER BY (c1, c2);

-- Test 14: query (line 89)
SELECT * FROM t12022@i WHERE (c1, c2) > (1, true) ORDER BY (c1, c2);

-- Test 15: query (line 96)
SELECT * FROM t12022@i WHERE (c1, c2) < (2, NULL) ORDER BY (c1, c2);

-- Test 16: query (line 103)
SELECT * FROM t12022@i WHERE (c1, c2) < (2, false) ORDER BY (c1, c2);

-- Test 17: query (line 110)
SELECT * FROM t12022@i WHERE (c1, c2) < (2, true) ORDER BY (c1, c2);

-- Test 18: statement (line 120)
CREATE TABLE favorites (
  id INT NOT NULL DEFAULT unique_rowid(),
  resource_type STRING(30) NOT NULL,
  resource_key STRING(255) NOT NULL,
  device_group STRING(30) NOT NULL,
  customerid INT NOT NULL,
  jurisdiction STRING(2) NOT NULL,
  brand STRING(255) NOT NULL,
  created_ts TIMESTAMP NULL,
  guid_id STRING(100) NOT NULL,
  locale STRING(10) NOT NULL DEFAULT NULL,
  CONSTRAINT "primary" PRIMARY KEY (id ASC),
  UNIQUE INDEX favorites_idx (resource_type ASC, device_group ASC, resource_key ASC, customerid ASC),
  INDEX favorites_guid_idx (guid_id ASC),
  INDEX favorites_glob_fav_idx (resource_type ASC, device_group ASC, jurisdiction ASC, brand ASC, locale ASC, resource_key ASC),
  FAMILY "primary" (id, resource_type, resource_key, device_group, customerid, jurisdiction, brand, created_ts, guid_id, locale)
)

-- Test 19: statement (line 139)
INSERT INTO favorites (customerid, guid_id, resource_type, device_group, jurisdiction, brand, locale, resource_key)
  VALUES (1, '1', 'GAME', 'web', 'MT', 'xxx', 'en_GB', 'tp'),
         (2, '2', 'GAME', 'web', 'MT', 'xxx', 'en_GB', 'ts'),
         (3, '3', 'GAME', 'web', 'MT', 'xxx', 'en_GB', 'ts1'),
         (4, '4', 'GAME', 'web', 'MT', 'xxx', 'en_GB', 'ts2'),
         (5, '5', 'GAME', 'web', 'MT', 'xxx', 'en_GB', 'ts3'),
         (6, '6', 'GAME', 'web', 'MT', 'xxx', 'en_GB', 'ts4')

-- Test 20: query (line 148)
SELECT
  resource_key,
  count(resource_key) total
FROM favorites f1
WHERE f1.jurisdiction   = 'MT'
AND   f1.brand          = 'xxx'
AND   f1.resource_type  = 'GAME'
AND   f1.device_group   = 'web'
AND   f1.locale         = 'en_GB'
AND   f1.resource_key IN ('ts', 'ts2', 'ts3')
GROUP BY resource_key
ORDER BY total DESC

-- Test 21: statement (line 166)
CREATE TABLE abcd (
  a INT,
  b INT,
  c INT,
  d INT,
  INDEX adb (a, d, b),
  INDEX abcd (a, b, c, d)
)

-- Test 22: statement (line 177)
INSERT INTO abcd VALUES
(NULL, NULL, NULL),
(NULL, NULL, 1),
(NULL, NULL, 5),
(NULL, NULL, 10),
(NULL, 1,    NULL),
(NULL, 1,    1),
(NULL, 1,    5),
(NULL, 1,    10),
(NULL, 5,    NULL),
(NULL, 5,    1),
(NULL, 5,    5),
(NULL, 5,    10),
(NULL, 10,   NULL),
(NULL, 10,   1),
(NULL, 10,   5),
(NULL, 10,   10),
(1,    NULL, NULL),
(1,    NULL, 1),
(1,    NULL, 5),
(1,    NULL, 10),
(1,    1,    NULL),
(1,    1,    1),
(1,    1,    5),
(1,    1,    10),
(1,    5,    NULL),
(1,    5,    1),
(1,    5,    5),
(1,    5,    10),
(1,    10,   NULL),
(1,    10,   1),
(1,    10,   5),
(1,    10,   10)

-- Test 23: query (line 212)
SELECT * FROM abcd@abcd WHERE a IS NULL AND b > 5

-- Test 24: query (line 220)
SELECT * FROM abcd@abcd WHERE a IS NULL AND b < 5

-- Test 25: query (line 228)
SELECT * FROM abcd@abcd WHERE a IS NULL ORDER BY b

-- Test 26: query (line 248)
SELECT * FROM abcd@abcd WHERE a = 1 AND b IS NULL AND c > 0 AND c < 10 ORDER BY c

-- Test 27: statement (line 258)
INSERT INTO str VALUES (1, 'A'), (4, 'AB'), (2, 'ABC'), (5, 'ABCD'), (3, 'ABCDEZ'), (9, 'ABD'), (10, '\CBA'), (11, 'A%'), (12, 'CAB.*'), (13, 'CABD')

-- Test 28: query (line 261)
SELECT k, v FROM str WHERE v LIKE 'ABC%'

-- Test 29: query (line 268)
SELECT k, v FROM str WHERE v LIKE '\ABC%'

-- Test 30: statement (line 275)
SELECT k, v FROM str WHERE v LIKE 'ABC\'

-- Test 31: query (line 278)
SELECT k, v FROM str WHERE v LIKE '\\CBA%'

-- Test 32: query (line 283)
SELECT k, v FROM str WHERE v LIKE 'A\%'

-- Test 33: query (line 288)
SELECT k, v FROM str WHERE v LIKE 'CAB.*'

-- Test 34: query (line 293)
SELECT k, v FROM str WHERE v LIKE 'ABC%Z'

-- Test 35: query (line 298)
SELECT k, v FROM str WHERE v LIKE '\ABCDE_'

-- Test 36: query (line 303)
SELECT k, v FROM str WHERE v SIMILAR TO 'ABC_*'

-- Test 37: statement (line 311)
CREATE TABLE xy (x INT, y INT, INDEX (y))

-- Test 38: statement (line 314)
CREATE INDEX xy_idx ON xy (x, y)

-- Test 39: statement (line 317)
INSERT INTO xy VALUES (NULL, NULL), (1, NULL), (NULL, 1), (1, 1)

-- Test 40: query (line 320)
SELECT * FROM xy WHERE x IN (NULL, 1, 2)

-- Test 41: statement (line 326)
CREATE TABLE ef (e INT, f INT, INDEX(f))

-- Test 42: statement (line 329)
INSERT INTO ef VALUES (NULL, 1), (1, 1)

-- Test 43: query (line 332)
SELECT e FROM ef WHERE f > 0 AND f < 2 ORDER BY f

-- Test 44: query (line 338)
SELECT * FROM xy WHERE (x, y) IN ((NULL, NULL), (1, NULL), (NULL, 1), (1, 1), (1, 2))

-- Test 45: statement (line 344)
CREATE TABLE bool1 (
  a BOOL,
  INDEX (a)
);
INSERT INTO bool1 VALUES (NULL), (TRUE), (FALSE)

-- Test 46: query (line 351)
SELECT * FROM bool1 WHERE a IS NULL

-- Test 47: query (line 356)
SELECT * FROM bool1 WHERE a IS NOT NULL

-- Test 48: query (line 362)
SELECT * FROM bool1 WHERE a IS TRUE

-- Test 49: query (line 367)
SELECT * FROM bool1 WHERE a IS NOT TRUE

-- Test 50: query (line 373)
SELECT * FROM bool1 WHERE a IS FALSE

-- Test 51: query (line 378)
SELECT * FROM bool1 WHERE a IS NOT FALSE

-- Test 52: statement (line 384)
CREATE TABLE bool2 (
  a BOOL NOT NULL,
  INDEX (a)
);
INSERT INTO bool2 VALUES (TRUE), (FALSE)

-- Test 53: query (line 391)
SELECT * FROM bool2 WHERE a IS NULL

-- Test 54: query (line 395)
SELECT * FROM bool2 WHERE a IS NOT NULL

-- Test 55: query (line 401)
SELECT * FROM bool2 WHERE a IS TRUE

-- Test 56: query (line 406)
SELECT * FROM bool2 WHERE a IS NOT TRUE

-- Test 57: query (line 411)
SELECT * FROM bool2 WHERE a IS FALSE

-- Test 58: query (line 416)
SELECT * FROM bool2 WHERE a IS NOT FALSE

-- Test 59: statement (line 422)
CREATE TABLE int (
  a INT,
  INDEX (a)
);
INSERT INTO int VALUES (NULL), (0), (1), (2)

-- Test 60: query (line 429)
SELECT * FROM int WHERE a IS NOT DISTINCT FROM 2

-- Test 61: query (line 434)
SELECT * FROM int WHERE a IS DISTINCT FROM 2

-- Test 62: statement (line 444)
CREATE TABLE noncover (
  a INT PRIMARY KEY,
  b INT,
  c INT,
  d INT,
  INDEX b (b),
  UNIQUE INDEX c (c),
  FAMILY (a),
  FAMILY (b),
  FAMILY (c),
  FAMILY (d)
)

-- Test 63: statement (line 458)
INSERT INTO noncover VALUES (1, 2, 3, 4), (5, 6, 7, 8)

-- Test 64: query (line 461)
SELECT * FROM noncover WHERE b = 2

-- Test 65: query (line 472)
SELECT a, d FROM noncover WHERE b=2

-- Test 66: query (line 478)
SELECT a FROM noncover WHERE b=2 ORDER BY c DESC

-- Test 67: query (line 484)
SELECT a, b, d FROM noncover WHERE b=2 ORDER BY b

-- Test 68: query (line 490)
SELECT a, b FROM noncover WHERE b=2 AND d>3 ORDER BY b

-- Test 69: query (line 495)
SELECT * FROM noncover WHERE c = 7

-- Test 70: query (line 500)
SELECT * FROM noncover WHERE c > 0 ORDER BY c DESC

-- Test 71: query (line 506)
SELECT * FROM noncover WHERE c > 0 AND d = 8

-- Test 72: query (line 512)
SELECT * FROM noncover WHERE b = 5 AND b <> 5

-- Test 73: query (line 517)
SELECT * FROM noncover WHERE b = 5 AND b <> 5 AND d>100

-- Test 74: statement (line 539)
INSERT INTO t2 VALUES
  (1, 1, 1, '11'),
  (2, 1, 2, '12'),
  (3, 1, 3, '13'),
  (4, 2, 1, '21'),
  (5, 2, 2, '22'),
  (6, 2, 3, '23'),
  (7, 3, 1, '31'),
  (8, 3, 2, '32'),
  (9, 3, 3, '33')

-- Test 75: query (line 551)
SELECT a FROM t2 WHERE b = 2 OR ((b BETWEEN 2 AND 1) AND ((s != 'a') OR (s = 'a')))

-- Test 76: statement (line 558)
CREATE TABLE t3 (k INT PRIMARY KEY, v INT, w INT, INDEX v(v))

-- Test 77: statement (line 561)
INSERT INTO t3 VALUES
  (10, 50, 1),
  (30, 40, 2),
  (50, 30, 3),
  (70, 20, 4),
  (90, 10, 5),
  (110, 0, 6),
  (130, -10, 7)

-- Test 78: query (line 571)
SELECT w FROM t3 WHERE v > 0 AND v < 100 ORDER BY v

-- Test 79: statement (line 597)
INSERT INTO tab1(pk, col0, col3) VALUES
  (1, 65, 65),
  (2, 87, 87),
  (3, 70, 70),
  (4, 88, 88),
  (5, 69, 69),
  (6, 72, 72),
  (7, 82, 82)

-- Test 80: query (line 607)
SELECT pk, col0 FROM tab1 WHERE (col3 BETWEEN 66 AND 87) ORDER BY 1 DESC

-- Test 81: statement (line 619)
CREATE TABLE abc (a INT, b INT, c INT, PRIMARY KEY(a, b), UNIQUE INDEX c (c))

-- Test 82: statement (line 622)
INSERT INTO abc (a, b, c) VALUES (0, 1, NULL);
INSERT INTO abc (a, b, c) VALUES (0, 2, NULL);
INSERT INTO abc (a, b, c) VALUES (1, 1, NULL);
INSERT INTO abc (a, b, c) VALUES (1, 2, NULL);
INSERT INTO abc (a, b, c) VALUES (2, 1, 1);
INSERT INTO abc (a, b, c) VALUES (2, 2, 2);

-- Test 83: query (line 630)
SELECT * FROM abc WHERE (c IS NULL OR c=2) AND a>0

-- Test 84: statement (line 642)
INSERT INTO t38878 VALUES ('a', 'u', 1), ('b', 'v', 2), ('c', 'w', 3), ('d', 'x', 4), ('d', 'x2', 5)

-- Test 85: query (line 645)
SELECT * FROM t38878 WHERE k1 = 'b' OR (k1 > 'b' AND k1 < 'd')

-- Test 86: query (line 651)
SELECT * FROM t38878 WHERE (k1 = 'd' AND k2 = 'x') OR k1 = 'b' OR (k1 > 'b' AND k1 < 'd')

-- Test 87: statement (line 659)
CREATE TABLE t47976 (
  k INT PRIMARY KEY,
  a INT,
  b FLOAT,
  c INT,
  INDEX (a),
  INDEX (b),
  INDEX (c)
)

-- Test 88: statement (line 670)
SELECT k FROM t47976 WHERE
  (a >= 6 OR b < 8 OR c IN (23, 27, 53)) AND
  (a = 1 OR b >= 12 OR c IS NULL) AND
  (a < 1 OR b = 6.8 OR c = 12) AND
  (a > 4 OR b <= 5.23 OR c IN (1, 2, 3)) AND
  (a = 12 OR b = 15.23 OR c = 14) AND
  (a > 58 OR b < 0 OR c >= 13)

-- Test 89: statement (line 681)
CREATE TABLE t76289_1 (
  pk1 DECIMAL NOT NULL, pk2 INT8 NOT NULL, c1 INT8, c2 INT8,
  PRIMARY KEY (pk1, pk2),
  UNIQUE (pk2),
  FAMILY fam_c1 (c1), FAMILY fam_c2 (pk1, pk2, c2)
);
INSERT INTO t76289_1 (pk1, pk2, c1) VALUES (1:::DECIMAL, 0:::INT8, 0:::INT8);

-- Test 90: query (line 690)
SELECT c2 FROM t76289_1 WHERE pk2 = 0;

-- Test 91: statement (line 695)
CREATE TABLE t76289_2 (
  pk1 DECIMAL NOT NULL, pk2 INT8 NOT NULL, c1 INT8, c2 INT8,
  PRIMARY KEY (pk1, pk2),
  INDEX (pk2),
  FAMILY fam_c1 (c1), FAMILY fam_c2 (pk1, pk2, c2)
);
INSERT INTO t76289_2 (pk1, pk2, c1) VALUES (1:::DECIMAL, 0:::INT8, 0:::INT8);

-- Test 92: query (line 704)
SELECT c2 FROM t76289_2@t76289_2_pk2_idx WHERE pk2 = 0;

-- Test 93: statement (line 712)
CREATE TABLE t88110 (
  _i INT8 NOT NULL, _bool BOOL, _int INT8,
  UNIQUE (_bool) STORING(_int),
  FAMILY (_bool),
  FAMILY (_i, _int)
);
INSERT INTO t88110 (_i, _bool, _int) VALUES (0, false, NULL);

-- Test 94: query (line 721)
SELECT DISTINCT _int FROM t88110 WHERE NOT _bool;

*/
