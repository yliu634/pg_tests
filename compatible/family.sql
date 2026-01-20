-- PostgreSQL compatible tests from family
-- 95 tests

-- Test 1: statement (line 3)
CREATE TABLE abcd(
  a INT PRIMARY KEY,
  b INT,
  c INT,
  d INT,
  FAMILY f1 (a, b),
  FAMILY (c, d)
)

onlyif config schema-locked-disabled

-- Test 2: query (line 14)
SHOW CREATE TABLE abcd

-- Test 3: query (line 28)
SHOW CREATE TABLE abcd

-- Test 4: statement (line 41)
CREATE INDEX d_idx ON abcd(d)

-- Test 5: statement (line 44)
INSERT INTO abcd VALUES (1, 2, 3, 4), (5, 6, 7, 8)

-- Test 6: query (line 47)
SELECT * FROM abcd

-- Test 7: query (line 55)
SELECT c FROM abcd WHERE a = 1

-- Test 8: query (line 60)
SELECT count(*) FROM abcd

-- Test 9: query (line 65)
SELECT count(*) FROM abcd@d_idx

-- Test 10: statement (line 70)
UPDATE abcd SET b = 9, d = 10, c = NULL where c = 7

-- Test 11: query (line 73)
SELECT * FROM abcd

-- Test 12: statement (line 79)
DELETE FROM abcd where c = 3

-- Test 13: query (line 82)
SELECT * FROM abcd

-- Test 14: statement (line 87)
UPSERT INTO abcd VALUES (1, 2, 3, 4), (5, 6, 7, 8)

-- Test 15: query (line 90)
SELECT * FROM abcd

-- Test 16: statement (line 96)
UPDATE abcd SET b = NULL, c = NULL, d = NULL WHERE a = 1

-- Test 17: query (line 99)
SELECT * FROM abcd WHERE a = 1

-- Test 18: statement (line 105)
INSERT INTO abcd (a) VALUES (2)

-- Test 19: query (line 108)
SELECT * FROM abcd WHERE a = 2

-- Test 20: statement (line 113)
UPDATE abcd SET d = 5 WHERE a = 2

-- Test 21: query (line 116)
SELECT * FROM abcd WHERE a = 2

-- Test 22: statement (line 121)
DELETE FROM abcd WHERE a = 2

-- Test 23: query (line 124)
SELECT * FROM abcd WHERE a = 2

-- Test 24: statement (line 131)
INSERT INTO abcd VALUES (9, 10, 11, 12, 'foo')

-- Test 25: query (line 134)
SELECT * from abcd WHERE a > 1

-- Test 26: statement (line 141)
ALTER TABLE abcd ADD COLUMN f DECIMAL

-- Test 27: statement (line 144)
ALTER TABLE abcd ADD COLUMN g INT FAMILY foo

-- Test 28: statement (line 147)
ALTER TABLE abcd ADD COLUMN g INT CREATE FAMILY

-- Test 29: statement (line 150)
ALTER TABLE abcd ADD COLUMN h INT CREATE FAMILY F1

-- Test 30: statement (line 153)
ALTER TABLE abcd ADD COLUMN h INT CREATE FAMILY f_h

-- Test 31: statement (line 156)
ALTER TABLE abcd ADD COLUMN i INT CREATE IF NOT EXISTS FAMILY F_H

-- Test 32: statement (line 159)
ALTER TABLE abcd ADD COLUMN j INT CREATE IF NOT EXISTS FAMILY f_j

onlyif config schema-locked-disabled

-- Test 33: query (line 163)
SHOW CREATE TABLE abcd

-- Test 34: query (line 187)
SHOW CREATE TABLE abcd

-- Test 35: statement (line 210)
ALTER TABLE abcd DROP c, DROP d, DROP e, DROP h, DROP i, DROP j

onlyif config schema-locked-disabled

-- Test 36: query (line 214)
SHOW CREATE TABLE abcd

-- Test 37: query (line 228)
SHOW CREATE TABLE abcd

-- Test 38: query (line 248)
SHOW CREATE TABLE f1

-- Test 39: query (line 259)
SHOW CREATE TABLE f1

-- Test 40: statement (line 269)
CREATE TABLE assign_at_create (a INT PRIMARY KEY FAMILY pri, b INT FAMILY foo, c INT CREATE FAMILY)

onlyif config schema-locked-disabled

-- Test 41: query (line 273)
SHOW CREATE TABLE assign_at_create

-- Test 42: query (line 287)
SHOW CREATE TABLE assign_at_create

-- Test 43: statement (line 301)
CREATE TABLE unsorted_colids (a INT PRIMARY KEY, b INT NOT NULL, c INT NOT NULL, FAMILY (c, b, a))

-- Test 44: statement (line 304)
INSERT INTO unsorted_colids VALUES (1, 1, 1)

-- Test 45: statement (line 307)
UPDATE unsorted_colids SET b = 2, c = 3 WHERE a = 1

-- Test 46: query (line 310)
SELECT * FROM unsorted_colids

-- Test 47: statement (line 319)
ALTER TABLE rename_col RENAME b TO d

-- Test 48: statement (line 322)
ALTER TABLE rename_col RENAME c TO e

onlyif config schema-locked-disabled

-- Test 49: query (line 326)
SHOW CREATE TABLE rename_col

-- Test 50: query (line 339)
SHOW CREATE TABLE rename_col

-- Test 51: statement (line 352)
CREATE TABLE xyz (x INT PRIMARY KEY, y INT, z INT, FAMILY (x, y), FAMILY (z), INDEX (y))

-- Test 52: statement (line 355)
INSERT INTO xyz VALUES (1, 1, NULL)

-- Test 53: query (line 358)
SELECT z FROM xyz WHERE y = 1

-- Test 54: statement (line 363)
CREATE TABLE y (y INT)

-- Test 55: statement (line 366)
INSERT INTO y VALUES (1)

-- Test 56: query (line 369)
SELECT xyz.z FROM y INNER LOOKUP JOIN xyz ON y.y = xyz.y

-- Test 57: statement (line 378)
CREATE TABLE t1 (
  a INT PRIMARY KEY, b INT NOT NULL, c INT, d INT,
  FAMILY (d), FAMILY (c), FAMILY (b), FAMILY (a)
);
INSERT INTO t1 VALUES (10, 20, 30, 40)

-- Test 58: query (line 387)
SELECT a FROM t1 WHERE a = 10

-- Test 59: query (line 392)
SELECT info FROM [EXPLAIN SELECT a FROM t1 WHERE a = 10] WHERE info LIKE '%table%' OR info LIKE '%spans%'

-- Test 60: query (line 400)
SELECT b FROM t1 WHERE a = 10

-- Test 61: query (line 405)
SELECT info FROM [EXPLAIN SELECT b FROM t1 WHERE a = 10] WHERE info LIKE '%table%' OR info LIKE '%spans%'

-- Test 62: query (line 413)
SELECT a, b FROM t1 WHERE a = 10

-- Test 63: query (line 418)
SELECT info FROM [EXPLAIN SELECT a, b FROM t1 WHERE a = 10] WHERE info LIKE '%table%' OR info LIKE '%spans%'

-- Test 64: query (line 426)
SELECT c FROM t1 WHERE a = 10

-- Test 65: query (line 431)
SELECT info FROM [EXPLAIN SELECT c FROM t1 WHERE a = 10] WHERE info LIKE '%table%' OR info LIKE '%spans%'

-- Test 66: query (line 439)
SELECT b, d FROM t1 WHERE a = 10

-- Test 67: query (line 444)
SELECT info FROM [EXPLAIN SELECT b, d FROM t1 WHERE a = 10] WHERE info LIKE '%table%' OR info LIKE '%spans%'

-- Test 68: statement (line 452)
CREATE UNIQUE INDEX b_idx ON t1 (b) STORING (c, d)

-- Test 69: query (line 455)
SELECT a FROM t1 WHERE b = 20

-- Test 70: query (line 460)
SELECT info FROM [EXPLAIN SELECT a FROM t1 WHERE b = 20] WHERE info LIKE '%table%' OR info LIKE '%spans%'

-- Test 71: statement (line 468)
CREATE TABLE t2 (
  a DECIMAL PRIMARY KEY, b INT, c INT NOT NULL, d INT,
  FAMILY (d), FAMILY (c), FAMILY (b), FAMILY (a)
);
INSERT INTO t2 VALUES (10.00, 20, 30, 40)

-- Test 72: query (line 476)
SELECT a FROM t2 WHERE a = 10

-- Test 73: query (line 481)
SELECT info FROM [EXPLAIN SELECT a FROM t2 WHERE a = 10] WHERE info LIKE '%table%' OR info LIKE '%spans%'

-- Test 74: query (line 488)
SELECT a, b FROM t2 WHERE a = 10

-- Test 75: query (line 493)
SELECT info FROM [EXPLAIN SELECT a, b FROM t2 WHERE a = 10] WHERE info LIKE '%table%' OR info LIKE '%spans%'

-- Test 76: statement (line 500)
CREATE UNIQUE INDEX a_idx ON t2 (a) STORING (b, c, d)

-- Test 77: query (line 504)
SELECT a, b FROM t2@a_idx WHERE a = 10

-- Test 78: query (line 509)
SELECT info FROM [EXPLAIN SELECT a FROM t2@a_idx WHERE a = 10] WHERE info LIKE '%table%' OR info LIKE '%spans%'

-- Test 79: query (line 516)
SELECT a, b FROM t2@a_idx WHERE a = 10

-- Test 80: query (line 521)
SELECT info FROM [EXPLAIN SELECT a, b FROM t2@a_idx WHERE a = 10] WHERE info LIKE '%table%' OR info LIKE '%spans%'

-- Test 81: statement (line 532)
CREATE TABLE fam (x INT PRIMARY KEY, y INT, y2 INT, y3 INT, FAMILY (x), FAMILY (y, y2), FAMILY (y3))

-- Test 82: statement (line 535)
INSERT INTO fam VALUES (1, NULL, NULL, NULL)

-- Test 83: statement (line 538)
INSERT INTO fam (x, y) VALUES (1, 1), (2, 2) ON CONFLICT (x) DO UPDATE SET y2=excluded.y, y3=excluded.y

-- Test 84: query (line 541)
SELECT * from fam

-- Test 85: statement (line 548)
CREATE UNIQUE INDEX secondary ON fam (y)

-- Test 86: statement (line 551)
INSERT INTO fam (x, y) VALUES (2, NULL), (3, NULL) ON CONFLICT (x) DO UPDATE SET y=NULL, y3=2

-- Test 87: query (line 554)
SELECT * from fam

-- Test 88: query (line 561)
SELECT * from fam@secondary

-- Test 89: statement (line 569)
DROP INDEX secondary

-- Test 90: statement (line 572)
CREATE UNIQUE INDEX secondary ON fam (y) STORING (y2)

-- Test 91: statement (line 575)
UPSERT INTO fam (x, y) VALUES (4, 4), (5, 5)

-- Test 92: statement (line 578)
INSERT INTO fam (x, y) VALUES (4, 4), (5, 5)
ON CONFLICT (y) DO UPDATE SET y=NULL, y2=excluded.y, y3=excluded.y

-- Test 93: query (line 582)
SELECT * from fam

-- Test 94: query (line 591)
SELECT * from fam@secondary

-- Test 95: statement (line 600)
DROP TABLE fam

