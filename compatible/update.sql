-- PostgreSQL compatible tests from update
-- 149 tests

SET client_min_messages = warning;
\set ON_ERROR_STOP 0

-- Test 1: statement (line 1)
CREATE TABLE kv (
  k INT PRIMARY KEY,
  v INT
);

-- Test 2: statement (line 7)
UPDATE kv SET v = (SELECT (10, 11));

-- Test 3: statement (line 10)
UPDATE kv SET v = 3.2;

-- Test 4: statement (line 13)
UPDATE kv SET (k, v) = (3, 3.2);

-- Test 5: statement (line 16)
UPDATE kv SET (k, v) = (SELECT 3, 3.2);

-- Test 6: statement (line 28)
INSERT INTO kv VALUES (1, 2), (3, 4), (5, 6), (7, 8);

-- Test 7: statement (line 31)
UPDATE kv SET v = 9 WHERE k IN (1, 3);

-- Test 8: query (line 34)
SELECT * FROM kv;

-- Test 9: statement (line 42)
UPDATE kv SET v = k + v;

-- Test 10: query (line 45)
SELECT * FROM kv;

-- Test 11: statement (line 53)
UPDATE kv SET m = 9 WHERE k IN (1, 3);

-- Test 12: statement (line 56)
UPDATE kv SET kv.k = 9;

-- Test 13: statement (line 59)
UPDATE kv SET k.* = 9;

-- Test 14: statement (line 62)
UPDATE kv SET k.v = 9;

-- Test 15: statement (line 65)
CREATE VIEW kview as SELECT k,v from kv;

-- Test 16: query (line 68)
SELECT * FROM kview;

-- Test 17: statement (line 76)
UPDATE kview SET v = 99 WHERE k IN (1, 3);

-- Test 18: query (line 79)
SELECT * FROM kview;

-- Test 19: statement (line 87)
CREATE TABLE kv2 (
  k CHAR PRIMARY KEY,
  v CHAR
);
CREATE UNIQUE INDEX a ON kv2 (v);

-- Test 20: statement (line 96)
INSERT INTO kv2 VALUES ('a', 'b'), ('c', 'd'), ('e', 'f'), ('f', 'g');

-- Test 21: query (line 99)
SELECT * FROM kv2;

-- Test 22: statement (line 107)
UPDATE kv2 SET v = 'g' WHERE k IN ('a');

-- Test 23: statement (line 110)
UPDATE kv2 SET v = 'i' WHERE k IN ('a');

-- Test 24: query (line 113)
SELECT * FROM kv2;

-- Test 25: statement (line 121)
UPDATE kv2 SET v = 'b' WHERE k IN ('a');

-- Test 26: query (line 124)
SELECT * FROM kv2;

-- Test 27: statement (line 133)
UPDATE ONLY kv2 SET v = 'h' WHERE k IN ('a');

-- Test 28: query (line 136)
SELECT * FROM kv2;

-- Test 29: statement (line 144)
UPDATE kv2 * SET v = 'b' WHERE k IN ('a');

-- Test 30: query (line 147)
SELECT * FROM kv2;

-- Test 31: statement (line 155)
UPDATE ONLY kv2 * SET v = 'b' WHERE k IN ('a');

-- Test 32: query (line 158)
SELECT * FROM kv2;

-- Test 33: statement (line 166)
CREATE TABLE kv3 (
  k CHAR PRIMARY KEY,
  v CHAR NOT NULL
);

-- Test 34: statement (line 172)
INSERT INTO kv3 VALUES ('a', 'b');

-- Test 35: statement (line 175)
UPDATE kv3 SET v = NULL WHERE k = 'a';

-- Test 36: query (line 178)
SELECT * FROM kv3;

-- Test 37: statement (line 183)
UPDATE kv3 SET v = NULL WHERE nonexistent = 'a';

-- Test 38: statement (line 186)
CREATE TABLE abc (
  a INT PRIMARY KEY,
  b INT,
  c INT
);
CREATE UNIQUE INDEX d ON abc (c);

-- Test 39: statement (line 194)
INSERT INTO abc VALUES (1, 2, 3);

-- Test 40: statement (line 197)
UPDATE abc SET (b, c) = (4);

-- Test 41: statement (line 200)
UPDATE abc SET (b, c) = (SELECT (VALUES (DEFAULT, DEFAULT)));

-- Test 42: statement (line 203)
UPDATE abc SET (b, c) = (4, 5);

-- Test 43: query (line 206)
SELECT * FROM abc;

-- Test 44: statement (line 211)
UPDATE abc SET a = 1, (b, c) = (SELECT 1, 2);

-- Test 45: query (line 214)
UPDATE abc SET (b, c) = (8, 9) RETURNING abc.b, c, 4 AS d;

-- Test 46: query (line 220)
UPDATE abc SET (b, c) = (8, 9) RETURNING b as col1, c as col2, 4 as col3;

-- Test 47: query (line 226)
UPDATE abc SET (b, c) = (8, 9) RETURNING a;

-- Test 48: query (line 232)
UPDATE abc SET (b, c) = (5, 6) RETURNING a, b, c, 4 AS d;

-- Test 49: query (line 238)
UPDATE abc SET (b, c) = (7, 8) RETURNING *;

-- Test 50: query (line 244)
UPDATE abc SET (b, c) = (7, 8) RETURNING *, 4 AS d;

-- Test 51: query (line 250)
UPDATE abc SET (b, c) = (8, 9) RETURNING abc.*;

-- Test 52: statement (line 256)
UPDATE abc SET (b, c) = (8, 9) RETURNING abc.* as x;

-- Test 53: query (line 259)
SELECT * FROM abc;

-- Test 54: statement (line 264)
INSERT INTO abc VALUES (4, 5, 6);

-- Test 55: statement (line 267)
UPDATE abc SET a = 4, b = 3;

-- Test 56: statement (line 270)
UPDATE abc SET a = 2, c = 6;

-- Test 57: query (line 273)
UPDATE abc SET a = 2, b = 3 WHERE a = 1 RETURNING *;

-- Test 58: query (line 278)
SELECT * FROM abc;

-- Test 59: query (line 284)
-- CRDB index hint removed: @d
SELECT * FROM abc WHERE c = 9;

-- Test 60: statement (line 289)
UPDATE abc SET b = 10, b = 11;

-- Test 61: statement (line 292)
UPDATE abc SET (b, b) = (10, 11);

-- Test 62: statement (line 295)
UPDATE abc SET (b, c) = (10, 11), b = 12;

-- Test 63: statement (line 298)
CREATE TABLE xyz (
  x INT PRIMARY KEY,
  y INT,
  z INT
);

-- Test 64: statement (line 305)
INSERT INTO xyz VALUES (111, 222, 333);

-- Test 65: statement (line 309)
UPDATE xyz SET (z, y) = (SELECT 666, 777), x = (SELECT 2);

-- Test 66: query (line 312)
SELECT * from xyz;

-- Test 67: statement (line 317)
CREATE TABLE lots (
  k1 INT,
  k2 INT,
  k3 INT,
  k4 INT,
  k5 INT
);

-- Test 68: statement (line 326)
INSERT INTO lots VALUES (1, 2, 3, 4, 5);

-- Test 69: statement (line 329)
UPDATE lots SET (k1, k2) = (6, 7), k3 = 8, (k4, k5) = (9, 10);

-- Test 70: query (line 332)
SELECT * FROM lots;

-- Test 71: statement (line 337)
UPDATE lots SET (k5, k4, k3, k2, k1) = (SELECT * FROM lots);

-- Test 72: query (line 340)
SELECT * FROM lots;

-- Test 73: statement (line 345)
CREATE TABLE pks (
  k1 INT,
  k2 INT,
  v INT,
  PRIMARY KEY (k1, k2)
);
CREATE UNIQUE INDEX i ON pks (k2, v);

-- Test 74: statement (line 356)
INSERT INTO pks VALUES (1, 2, 3), (4, 5, 3);

-- Test 75: statement (line 359)
UPDATE pks SET k2 = 5 where k1 = 1;

-- Test 76: statement (line 364)
UPDATE pks SET k1 = 2 WHERE k1 = 1;

-- Test 77: query (line 367)
SELECT * FROM pks;

-- Test 78: statement (line 375)
-- ALTER TABLE kv SET (schema_locked=false) -- CockroachDB-specific

-- Test 79: statement (line 378)
TRUNCATE kv;

-- Test 80: statement (line 381)
-- ALTER TABLE kv RESET (schema_locked) -- CockroachDB-specific

-- Test 81: statement (line 384)
INSERT INTO kv VALUES (1, 9), (8, 2), (3, 7), (6, 4);

-- Test 82: query (line 387)
UPDATE kv
SET v = v + 1
WHERE k IN (SELECT k FROM kv ORDER BY v DESC, k LIMIT 3)
RETURNING k, v;

-- Test 83: statement (line 397)
-- ALTER TABLE kv SET (schema_locked=false) -- CockroachDB-specific

-- Test 84: statement (line 400)
TRUNCATE kv;

-- Test 85: statement (line 403)
-- ALTER TABLE kv RESET (schema_locked) -- CockroachDB-specific

-- Test 86: statement (line 406)
INSERT INTO kv VALUES (1, 2), (2, 3), (3, 4);

-- Test 87: query (line 409)
UPDATE kv
SET v = v - 1
WHERE k IN (SELECT k FROM kv WHERE k < 10 ORDER BY k LIMIT 1)
RETURNING k, v;

-- Test 88: query (line 414)
SELECT * FROM kv;

-- Test 89: statement (line 424)
CREATE TABLE tu (a INT PRIMARY KEY, b INT, c INT, d INT);
INSERT INTO tu VALUES (1, 2, 3, 4);

-- Test 90: statement (line 428)
UPDATE tu SET b = NULL, c = NULL, d = NULL;

-- Test 91: query (line 431)
SELECT * FROM tu;

-- Test 92: statement (line 444)
CREATE TABLE tn(x INT NULL CHECK(x IS NOT NULL), y CHAR(4) CHECK(length(y) < 4));
  INSERT INTO tn(x, y) VALUES (123, 'abc');

-- Test 93: statement (line 448)
UPDATE tn SET x = NULL;

-- Test 94: statement (line 451)
UPDATE tn SET y = 'abcd';

-- Test 95: statement (line 455)
CREATE TABLE tn2(x INT NOT NULL CHECK(x IS NOT NULL), y CHAR(3) CHECK(length(y) < 4));
  INSERT INTO tn2(x, y) VALUES (123, 'abc');

-- Test 96: statement (line 459)
UPDATE tn2 SET x = NULL;

-- Test 97: statement (line 462)
UPDATE tn2 SET y = 'abcd';

-- Test 98: statement (line 469)
CREATE TABLE src(x VARCHAR(3) PRIMARY KEY);

-- Test 99: statement (line 472)
INSERT INTO src(x) VALUES ('abc');

-- Test 100: statement (line 475)
CREATE TABLE derived(
  x VARCHAR(3) REFERENCES src(x),
  y VARCHAR(3) CHECK(length(y) < 4) REFERENCES src(x)
);

-- Test 101: statement (line 479)
INSERT INTO derived(x, y) VALUES ('abc', 'abc');

-- Test 102: statement (line 483)
UPDATE derived SET x = 'xxx';

-- Test 103: statement (line 486)
UPDATE derived SET x = 'abcd';

-- Test 104: statement (line 489)
UPDATE derived SET y = 'abcd';

-- Test 105: statement (line 494)
CREATE TABLE t29494(x INT PRIMARY KEY);
INSERT INTO t29494 VALUES (12);

-- Test 106: statement (line 497)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
-- SET LOCAL autocommit_before_ddl=off; -- CockroachDB-specific
ALTER TABLE t29494 ADD COLUMN y INT NOT NULL DEFAULT 123;

-- Test 107: query (line 503)
-- SHOW CREATE is CockroachDB-specific, skip this test
-- SELECT create_statement FROM [SHOW CREATE t29494];

-- Test 108: statement (line 512)
UPDATE t29494 SET x = 123 RETURNING y;

-- Test 109: statement (line 517)
ROLLBACK;
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
-- SET LOCAL autocommit_before_ddl=off; -- CockroachDB-specific
ALTER TABLE t29494 ADD COLUMN y INT NOT NULL DEFAULT 123;

-- Test 110: query (line 524)
UPDATE t29494 SET x = 124 WHERE x = 12 RETURNING *;

-- Test 111: statement (line 529)
UPDATE t29494 SET y = 123;

-- Test 112: statement (line 534)
ROLLBACK;
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
-- SET LOCAL autocommit_before_ddl=off; -- CockroachDB-specific
ALTER TABLE t29494 ADD COLUMN y INT NOT NULL DEFAULT 123;

-- Test 113: statement (line 540)
UPDATE t29494 SET x = y;

-- Test 114: statement (line 543)
COMMIT;

-- Test 115: statement (line 547)
CREATE TABLE mutation (m INT PRIMARY KEY, n INT);

-- Test 116: statement (line 550)
INSERT INTO mutation VALUES (1, 1);

-- Test 117: statement (line 553)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
ALTER TABLE mutation ADD COLUMN o INT DEFAULT 10;
ALTER TABLE mutation ADD COLUMN p INT GENERATED ALWAYS AS (o + n) STORED;

-- Test 118: statement (line 557)
UPDATE mutation SET m=2 WHERE n=1;

-- Test 119: statement (line 560)
COMMIT TRANSACTION;

-- Test 120: query (line 563)
SELECT * FROM mutation;

-- Test 121: statement (line 572)
CREATE TABLE t32477 AS SELECT 1 AS x;

-- Test 122: statement (line 575)
UPDATE t32477 SET x = count(x);

-- Test 123: statement (line 578)
UPDATE t32477 SET x = rank() OVER ();

-- Test 124: statement (line 581)
UPDATE t32477 SET x = generate_series(1,2);

-- Test 125: statement (line 587)
CREATE TABLE t32054 AS SELECT 1 AS x, 2 AS y;

-- Test 126: statement (line 590)
CREATE TABLE t32054_empty(x INT, y INT);

-- Test 127: statement (line 593)
UPDATE t32054 SET (x,y) = (SELECT x,y FROM t32054_empty);

-- Test 128: query (line 596)
SELECT * FROM t32054;

-- Test 129: statement (line 606)
CREATE TABLE t35364(x DECIMAL(1,0) CHECK (x >= 1));

-- Test 130: statement (line 609)
INSERT INTO t35364 VALUES (2);

-- Test 131: statement (line 612)
UPDATE t35364 SET x=0.5;

-- Test 132: query (line 615)
SELECT x FROM t35364;

-- Test 133: statement (line 623)
CREATE TABLE table35970 (
  a INT PRIMARY KEY,
  b INT,
  c BIGINT[]
);

-- Test 134: statement (line 632)
INSERT INTO table35970 VALUES (1, 1, NULL);

-- Test 135: query (line 635)
UPDATE table35970
SET c = c
RETURNING b;

-- Test 136: statement (line 643)
CREATE TABLE generated_as_id_t (
  a INT UNIQUE,
  b INT GENERATED ALWAYS AS IDENTITY,
  c INT GENERATED BY DEFAULT AS IDENTITY
);

-- Test 137: statement (line 650)
INSERT INTO generated_as_id_t (a) VALUES (7), (8), (9);

-- Test 138: query (line 653)
SELECT * FROM generated_as_id_t ORDER BY a;

-- Test 139: statement (line 660)
UPDATE generated_as_id_t SET b=(1+1) WHERE a > 6;

-- Test 140: statement (line 663)
UPDATE generated_as_id_t SET c=(1+1) WHERE a > 6;

-- Test 141: query (line 666)
SELECT * FROM generated_as_id_t ORDER BY a;

-- Test 142: statement (line 673)
UPDATE generated_as_id_t SET b=DEFAULT WHERE a > 6;

-- Test 143: query (line 676)
SELECT * FROM generated_as_id_t ORDER BY a;

-- Test 144: statement (line 683)
UPDATE generated_as_id_t SET c=DEFAULT WHERE a > 6;

-- Test 145: query (line 686)
SELECT * FROM generated_as_id_t ORDER BY a;

-- Test 146: statement (line 696)
CREATE TABLE t107634 (a INT);

-- Test 147: statement (line 699)
UPDATE t107634 SET a = 1 ORDER BY sum(a) LIMIT 1;

-- Test 148: statement (line 708)
CREATE TABLE t108166 (a INT);

-- Test 149: statement (line 711)
UPDATE t108166 SET a = 1 ORDER BY COALESCE(sum(a), 1) LIMIT 1;
