SET client_min_messages = warning;

-- PostgreSQL compatible tests from on_update
-- 98 tests

-- Test 1: statement (line 7)
INSERT INTO test_simple VALUES ('pk1', 'to_be_changed');

-- Test 2: query (line 10)
SELECT p, k FROM test_simple;

-- Test 3: statement (line 15)
UPDATE test_simple SET p = 'pk2' WHERE p = 'pk1';

-- Test 4: query (line 18)
SELECT p, k FROM test_simple;

-- Test 5: statement (line 26)
INSERT INTO test_with_default VALUES ('pk1');

-- Test 6: query (line 29)
SELECT p, k FROM test_with_default;

-- Test 7: statement (line 34)
UPDATE test_with_default SET p = 'pk2' WHERE p = 'pk1';

-- Test 8: query (line 37)
SELECT p, k FROM test_with_default;

-- Test 9: statement (line 48)
INSERT INTO test_upsert VALUES ('pk1', 'val1', 'whatevs');

-- Test 10: query (line 51)
SELECT p, j, k FROM test_upsert;

-- Test 11: statement (line 56)
UPSERT INTO test_upsert (p, j) VALUES ('pk1', 'val2'), ('pk2', 'val3');

-- Test 12: query (line 59)
SELECT p, j, k FROM test_upsert ORDER BY p;

-- Test 13: statement (line 67)
UPSERT INTO test_upsert VALUES ('pk1', 'val20'), ('pk2', 'val30');

-- Test 14: query (line 70)
SELECT p, j, k FROM test_upsert ORDER BY p;

-- Test 15: statement (line 82)
INSERT INTO test_alter VALUES ('pk1', 'to_be_changed');

-- Test 16: query (line 85)
SELECT p, k FROM test_alter;

-- Test 17: statement (line 90)
UPDATE test_alter SET p = 'pk2' WHERE p = 'pk1';

-- Test 18: query (line 93)
SELECT p, k FROM test_alter;

-- Test 19: statement (line 98)
ALTER TABLE test_alter ALTER COLUMN k SET ON UPDATE 'regress';

-- Test 20: statement (line 101)
UPDATE test_alter SET p = 'pk3' WHERE p = 'pk2';

-- Test 21: query (line 104)
SELECT p, k FROM test_alter;

-- Test 22: statement (line 109)
ALTER TABLE test_alter ALTER COLUMN k DROP ON UPDATE;

-- Test 23: statement (line 112)
UPDATE test_alter SET k = 'should_not_change' WHERE p = 'pk3';

-- Test 24: statement (line 115)
UPDATE test_alter SET p = 'pk4' WHERE p = 'pk3';

-- Test 25: query (line 118)
SELECT p, k FROM test_alter;

-- Test 26: statement (line 134)
INSERT INTO test_fk_base VALUES ('pk1', 'val1'), ('pk2', 'val2');

-- Test 27: statement (line 137)
UPSERT INTO test_fk_ref (p, j) VALUES ('pk1', 'val1'), ('pk2', 'val2');

-- Test 28: statement (line 140)
UPDATE test_fk_base SET j = 'arbitrary' WHERE p = 'pk1';

-- Test 29: query (line 143)
SELECT p, j FROM test_fk_base ORDER BY p;

-- Test 30: query (line 149)
SELECT p, j, k FROM test_fk_ref ORDER BY p;

-- Test 31: statement (line 170)
ALTER TABLE alter_fk ALTER COLUMN j SET ON UPDATE 'failure';

-- Test 32: statement (line 176)
ALTER TABLE alter_update ADD CONSTRAINT fk FOREIGN KEY (j) REFERENCES test_fk_base (j) ON UPDATE SET DEFAULT;

-- Test 33: query (line 192)
SHOW CREATE TABLE test_show_default;

-- Test 34: query (line 204)
SHOW CREATE TABLE test_show_default;

-- Test 35: query (line 226)
SHOW CREATE TABLE test_show_fk;

-- Test 36: query (line 241)
SHOW CREATE TABLE test_show_fk;

-- Test 37: statement (line 258)
CREATE SEQUENCE test_seq;

-- Test 38: statement (line 264)
INSERT INTO test_table_seq VALUES ('pk1', 20);

-- Test 39: query (line 267)
SELECT p, k FROM test_table_seq;

-- Test 40: statement (line 272)
UPDATE test_table_seq SET p = 'pk2' WHERE p = 'pk1';

-- Test 41: query (line 275)
SELECT p, k FROM test_table_seq;

-- Test 42: statement (line 280)
UPDATE test_table_seq SET p = 'pk3' WHERE p = 'pk2';

-- Test 43: query (line 283)
SELECT p, k FROM test_table_seq;

-- Test 44: statement (line 288)
ALTER TABLE test_table_seq ALTER COLUMN k SET DEFAULT nextval('test_seq');

-- Test 45: statement (line 291)
INSERT INTO test_table_seq VALUES ('pk1');

-- Test 46: query (line 294)
SELECT p, k FROM test_table_seq ORDER BY p;

-- Test 47: statement (line 301)
DROP SEQUENCE test_seq;

-- Test 48: statement (line 304)
ALTER TABLE test_table_seq ALTER COLUMN k DROP ON UPDATE;

-- Test 49: statement (line 309)
DROP SEQUENCE test_seq;

-- Test 50: statement (line 312)
INSERT INTO test_table_seq VALUES ('pk2');

-- Test 51: query (line 315)
SELECT p, k FROM test_table_seq ORDER BY p;

-- Test 52: statement (line 324)
CREATE SEQUENCE seq_72116;
CREATE TABLE table_72116 (a INT);
ALTER TABLE table_72116 ADD COLUMN b INT DEFAULT nextval('seq_72116') ON UPDATE NULL;

-- Test 53: statement (line 330)
DROP SEQUENCE seq_72116;

-- Test 54: statement (line 333)
DROP TABLE table_72116;

-- Test 55: statement (line 336)
DROP TABLE IF EXISTS table_72116 CASCADE;
CREATE TABLE table_72116 (a INT DEFAULT nextval('seq_72116') ON UPDATE NULL);

-- Test 56: statement (line 339)
DROP SEQUENCE seq_72116;

-- Test 57: statement (line 342)
DROP TABLE table_72116;

-- Test 58: statement (line 345)
DROP TABLE IF EXISTS table_72116 CASCADE;
CREATE TABLE table_72116 (a INT);

-- Test 59: statement (line 348)
ALTER TABLE table_72116 ADD COLUMN b INT DEFAULT (1) ON UPDATE nextval('seq_72116');

-- Test 60: statement (line 351)
DROP SEQUENCE seq_72116;

-- Test 61: statement (line 354)
DROP TABLE table_72116;
CREATE TABLE table_72116 (a INT DEFAULT (1) ON UPDATE nextval('seq_72116'));

-- Test 62: statement (line 358)
DROP SEQUENCE seq_72116;

-- Test 63: statement (line 363)
CREATE TYPE test_enum AS ENUM ('x', 'y', 'z');

-- Test 64: statement (line 369)
INSERT INTO test_table_enum VALUES ('pk1', 'y');

-- Test 65: query (line 372)
SELECT p, k FROM test_table_enum;

-- Test 66: statement (line 377)
ALTER TYPE test_enum DROP VALUE 'z';

-- Test 67: statement (line 380)
ALTER TYPE test_enum DROP VALUE 'x';

-- Test 68: statement (line 383)
ALTER TYPE test_enum ADD VALUE 'z';

-- Test 69: statement (line 386)
UPDATE test_table_enum SET p = 'pk2' WHERE p = 'pk1';

-- Test 70: query (line 389)
SELECT p, k FROM test_table_enum;

-- Test 71: statement (line 395)
DROP TYPE test_enum;

-- Test 72: statement (line 398)
ALTER TABLE test_table_enum ALTER COLUMN k SET DEFAULT 'z';

-- Test 73: statement (line 401)
INSERT INTO test_table_enum VALUES ('pk3');

-- Test 74: query (line 404)
SELECT p, k FROM test_table_enum ORDER BY p;

-- Test 75: statement (line 410)
ALTER TABLE test_table_enum ALTER COLUMN k DROP ON UPDATE;

-- Test 76: statement (line 413)
DELETE FROM test_table_enum WHERE p = 'pk2';

-- Test 77: statement (line 416)
ALTER TYPE test_enum DROP VALUE 'x';

-- Test 78: statement (line 420)
DROP TYPE test_enum;

-- Test 79: statement (line 423)
ALTER TABLE test_table_enum DROP COLUMN k;

-- Test 80: statement (line 426)
DROP TYPE test_enum;

-- Test 81: statement (line 429)
CREATE TYPE test_enum AS ENUM ('x', 'y', 'z');

-- Test 82: statement (line 435)
ALTER TYPE test_enum DROP VALUE 'z';

-- Test 83: statement (line 438)
ALTER TYPE test_enum DROP VALUE 'x';

-- Test 84: statement (line 441)
ALTER TYPE test_enum DROP VALUE 'y';

-- Test 85: statement (line 447)
DROP TABLE IF EXISTS test_backfill CASCADE;
CREATE TABLE test_backfill (x INT, y INT DEFAULT 100 ON UPDATE 50);

-- Test 86: statement (line 450)
INSERT INTO test_backfill VALUES (1), (2), (3);

-- Test 87: query (line 453)
SELECT * FROM test_backfill ORDER BY x;

-- Test 88: statement (line 460)
ALTER TABLE test_backfill ADD COLUMN z INT DEFAULT 20;

-- Test 89: query (line 463)
SELECT * FROM test_backfill ORDER BY x;

-- Test 90: statement (line 470)
SET sql_safe_updates = false;

-- Test 91: statement (line 473)
ALTER TABLE test_backfill DROP COLUMN z;

-- Test 92: query (line 476)
SELECT * FROM test_backfill ORDER BY x;

-- Test 93: statement (line 483)
SET sql_safe_updates = true;

-- Test 94: statement (line 486)
DROP TABLE test_backfill;

-- Test 95: statement (line 493)
DROP TABLE IF EXISTS t81698 CASCADE;
CREATE TABLE t81698 (i INT PRIMARY KEY);

-- Test 96: statement (line 496)
INSERT INTO t81698 VALUES (1);

-- Test 97: statement (line 500)
ALTER TABLE t81698 ADD COLUMN v VARCHAR(2) NOT NULL DEFAULT 'd' ON UPDATE 'on_update';

-- Test 98: statement (line 503)
UPDATE t81698 SET i = 2 where i = 1;



RESET client_min_messages;