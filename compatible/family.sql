-- PostgreSQL compatible tests from family
-- 95 tests

SET client_min_messages = warning;

-- Test 1: statement (line 3)
CREATE TABLE abcd(
  a INT PRIMARY KEY,
  b INT,
  c INT,
  d INT
);

-- onlyif config schema-locked-disabled

-- Test 2: query (line 14)
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'public' AND table_name = 'abcd'
ORDER BY ordinal_position;

-- Test 3: query (line 28)
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'public' AND table_name = 'abcd'
ORDER BY ordinal_position;

-- Test 4: statement (line 41)
CREATE INDEX d_idx ON abcd(d);

-- Test 5: statement (line 44)
INSERT INTO abcd VALUES (1, 2, 3, 4), (5, 6, 7, 8);

-- Test 6: query (line 47)
SELECT * FROM abcd;

-- Test 7: query (line 55)
SELECT c FROM abcd WHERE a = 1;

-- Test 8: query (line 60)
SELECT count(*) FROM abcd;

-- Test 9: query (line 65)
SELECT count(*) FROM abcd;

-- Test 10: statement (line 70)
UPDATE abcd SET b = 9, d = 10, c = NULL WHERE c = 7;

-- Test 11: query (line 73)
SELECT * FROM abcd;

-- Test 12: statement (line 79)
DELETE FROM abcd WHERE c = 3;

-- Test 13: query (line 82)
SELECT * FROM abcd;

-- Test 14: statement (line 87)
INSERT INTO abcd (a, b, c, d)
VALUES (1, 2, 3, 4), (5, 6, 7, 8)
ON CONFLICT (a) DO UPDATE
SET b = EXCLUDED.b, c = EXCLUDED.c, d = EXCLUDED.d;

-- Test 15: query (line 90)
SELECT * FROM abcd;

-- Test 16: statement (line 96)
UPDATE abcd SET b = NULL, c = NULL, d = NULL WHERE a = 1;

-- Test 17: query (line 99)
SELECT * FROM abcd WHERE a = 1;

-- Test 18: statement (line 105)
INSERT INTO abcd (a) VALUES (2);

-- Test 19: query (line 108)
SELECT * FROM abcd WHERE a = 2;

-- Test 20: statement (line 113)
UPDATE abcd SET d = 5 WHERE a = 2;

-- Test 21: query (line 116)
SELECT * FROM abcd WHERE a = 2;

-- Test 22: statement (line 121)
DELETE FROM abcd WHERE a = 2;

-- Test 23: query (line 124)
SELECT * FROM abcd WHERE a = 2;

-- Test 24: statement (line 131)
\set ON_ERROR_STOP 0
INSERT INTO abcd VALUES (9, 10, 11, 12);
\set ON_ERROR_STOP 1

-- Test 25: query (line 134)
SELECT * FROM abcd WHERE a > 1;

-- Test 26: statement (line 141)
ALTER TABLE abcd ADD COLUMN f DECIMAL;

-- Test 27: statement (line 144)
ALTER TABLE abcd ADD COLUMN g INT;

-- Test 28: statement (line 147)
\set ON_ERROR_STOP 0
ALTER TABLE abcd ADD COLUMN IF NOT EXISTS g INT;
\set ON_ERROR_STOP 1

-- Test 29: statement (line 150)
ALTER TABLE abcd ADD COLUMN h INT;

-- Test 30: statement (line 153)
\set ON_ERROR_STOP 0
ALTER TABLE abcd ADD COLUMN IF NOT EXISTS h INT;
\set ON_ERROR_STOP 1

-- Test 31: statement (line 156)
ALTER TABLE abcd ADD COLUMN IF NOT EXISTS i INT;

-- Test 32: statement (line 159)
ALTER TABLE abcd ADD COLUMN IF NOT EXISTS j INT;

-- onlyif config schema-locked-disabled

-- Test 33: query (line 163)
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'public' AND table_name = 'abcd'
ORDER BY ordinal_position;

-- Test 34: query (line 187)
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'public' AND table_name = 'abcd'
ORDER BY ordinal_position;

-- Test 35: statement (line 210)
ALTER TABLE abcd
  DROP COLUMN c,
  DROP COLUMN d,
  DROP COLUMN IF EXISTS e,
  DROP COLUMN h,
  DROP COLUMN i,
  DROP COLUMN j;

-- onlyif config schema-locked-disabled

-- Test 36: query (line 214)
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'public' AND table_name = 'abcd'
ORDER BY ordinal_position;

-- Test 37: query (line 228)
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'public' AND table_name = 'abcd'
ORDER BY ordinal_position;

-- Make f1 exist so these queries don't hard-error under PostgreSQL.
CREATE TABLE IF NOT EXISTS f1 (a INT);

-- Test 38: query (line 248)
\set ON_ERROR_STOP 0
SELECT * FROM f1;
\set ON_ERROR_STOP 1

-- Test 39: query (line 259)
\set ON_ERROR_STOP 0
SELECT * FROM f1;
\set ON_ERROR_STOP 1

-- Test 40: statement (line 269)
CREATE TABLE assign_at_create (a INT PRIMARY KEY, b INT, c INT);

-- onlyif config schema-locked-disabled

-- Test 41: query (line 273)
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'public' AND table_name = 'assign_at_create'
ORDER BY ordinal_position;

-- Test 42: query (line 287)
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'public' AND table_name = 'assign_at_create'
ORDER BY ordinal_position;

-- Test 43: statement (line 301)
CREATE TABLE unsorted_colids (a INT PRIMARY KEY, b INT NOT NULL, c INT NOT NULL);

-- Test 44: statement (line 304)
INSERT INTO unsorted_colids VALUES (1, 1, 1);

-- Test 45: statement (line 307)
UPDATE unsorted_colids SET b = 2, c = 3 WHERE a = 1;

-- Test 46: query (line 310)
SELECT * FROM unsorted_colids;

CREATE TABLE rename_col (a INT, b INT, c INT);

-- Test 47: statement (line 319)
ALTER TABLE rename_col RENAME COLUMN b TO d;

-- Test 48: statement (line 322)
ALTER TABLE rename_col RENAME COLUMN c TO e;

-- onlyif config schema-locked-disabled

-- Test 49: query (line 326)
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'public' AND table_name = 'rename_col'
ORDER BY ordinal_position;

-- Test 50: query (line 339)
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'public' AND table_name = 'rename_col'
ORDER BY ordinal_position;

-- Test 51: statement (line 352)
CREATE TABLE xyz (x INT PRIMARY KEY, y INT, z INT);
CREATE INDEX xyz_y_idx ON xyz(y);

-- Test 52: statement (line 355)
INSERT INTO xyz VALUES (1, 1, NULL);

-- Test 53: query (line 358)
SELECT z FROM xyz WHERE y = 1;

-- Test 54: statement (line 363)
CREATE TABLE y (y INT);

-- Test 55: statement (line 366)
INSERT INTO y VALUES (1);

-- Test 56: query (line 369)
SELECT xyz.z FROM y INNER JOIN xyz ON y.y = xyz.y;

-- Test 57: statement (line 378)
CREATE TABLE t1 (
  a INT PRIMARY KEY, b INT NOT NULL, c INT, d INT
);
INSERT INTO t1 VALUES (10, 20, 30, 40);

-- Test 58: query (line 387)
SELECT a FROM t1 WHERE a = 10;

-- Test 59: query (line 392)
EXPLAIN (COSTS OFF) SELECT a FROM t1 WHERE a = 10;

-- Test 60: query (line 400)
SELECT b FROM t1 WHERE a = 10;

-- Test 61: query (line 405)
EXPLAIN (COSTS OFF) SELECT b FROM t1 WHERE a = 10;

-- Test 62: query (line 413)
SELECT a, b FROM t1 WHERE a = 10;

-- Test 63: query (line 418)
EXPLAIN (COSTS OFF) SELECT a, b FROM t1 WHERE a = 10;

-- Test 64: query (line 426)
SELECT c FROM t1 WHERE a = 10;

-- Test 65: query (line 431)
EXPLAIN (COSTS OFF) SELECT c FROM t1 WHERE a = 10;

-- Test 66: query (line 439)
SELECT b, d FROM t1 WHERE a = 10;

-- Test 67: query (line 444)
EXPLAIN (COSTS OFF) SELECT b, d FROM t1 WHERE a = 10;

-- Test 68: statement (line 452)
CREATE UNIQUE INDEX b_idx ON t1 (b) INCLUDE (c, d);

-- Test 69: query (line 455)
SELECT a FROM t1 WHERE b = 20;

-- Test 70: query (line 460)
EXPLAIN (COSTS OFF) SELECT a FROM t1 WHERE b = 20;

-- Test 71: statement (line 468)
CREATE TABLE t2 (
  a DECIMAL PRIMARY KEY, b INT, c INT NOT NULL, d INT
);
INSERT INTO t2 VALUES (10.00, 20, 30, 40);

-- Test 72: query (line 476)
SELECT a FROM t2 WHERE a = 10;

-- Test 73: query (line 481)
EXPLAIN (COSTS OFF) SELECT a FROM t2 WHERE a = 10;

-- Test 74: query (line 488)
SELECT a, b FROM t2 WHERE a = 10;

-- Test 75: query (line 493)
EXPLAIN (COSTS OFF) SELECT a, b FROM t2 WHERE a = 10;

-- Test 76: statement (line 500)
CREATE UNIQUE INDEX a_idx ON t2 (a) INCLUDE (b, c, d);

-- Test 77: query (line 504)
SELECT a, b FROM t2 WHERE a = 10;

-- Test 78: query (line 509)
EXPLAIN (COSTS OFF) SELECT a FROM t2 WHERE a = 10;

-- Test 79: query (line 516)
SELECT a, b FROM t2 WHERE a = 10;

-- Test 80: query (line 521)
EXPLAIN (COSTS OFF) SELECT a, b FROM t2 WHERE a = 10;

-- Test 81: statement (line 532)
CREATE TABLE fam (x INT PRIMARY KEY, y INT, y2 INT, y3 INT);

-- Test 82: statement (line 535)
INSERT INTO fam VALUES (1, NULL, NULL, NULL);

-- Test 83: statement (line 538)
INSERT INTO fam (x, y) VALUES (1, 1), (2, 2) ON CONFLICT (x) DO UPDATE SET y2 = EXCLUDED.y, y3 = EXCLUDED.y;

-- Test 84: query (line 541)
SELECT * FROM fam;

-- Test 85: statement (line 548)
CREATE UNIQUE INDEX secondary ON fam (y);

-- Test 86: statement (line 551)
INSERT INTO fam (x, y) VALUES (2, NULL), (3, NULL) ON CONFLICT (x) DO UPDATE SET y = NULL, y3 = 2;

-- Test 87: query (line 554)
SELECT * FROM fam;

-- Test 88: query (line 561)
SELECT * FROM fam;

-- Test 89: statement (line 569)
DROP INDEX secondary;

-- Test 90: statement (line 572)
CREATE UNIQUE INDEX secondary ON fam (y) INCLUDE (y2);

-- Test 91: statement (line 575)
INSERT INTO fam (x, y) VALUES (4, 4), (5, 5)
ON CONFLICT (x) DO UPDATE SET y = EXCLUDED.y;

-- Test 92: statement (line 578)
INSERT INTO fam (x, y) VALUES (4, 4), (5, 5)
ON CONFLICT (y) DO UPDATE SET y = NULL, y2 = EXCLUDED.y, y3 = EXCLUDED.y;

-- Test 93: query (line 582)
SELECT * FROM fam;

-- Test 94: query (line 591)
SELECT * FROM fam;

-- Test 95: statement (line 600)
DROP TABLE fam;

RESET client_min_messages;
