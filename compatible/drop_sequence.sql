-- PostgreSQL compatible tests from drop_sequence
-- 78 tests

SET client_min_messages = warning;

-- Cleanup for reruns (this file is typically executed in an isolated temp DB).
DROP VIEW IF EXISTS v CASCADE;
DROP TABLE IF EXISTS t1 CASCADE;
DROP TABLE IF EXISTS foo CASCADE;
DROP TABLE IF EXISTS bar CASCADE;
DROP TABLE IF EXISTS t2 CASCADE;
DROP TABLE IF EXISTS t3 CASCADE;
DROP TABLE IF EXISTS t4 CASCADE;
DROP TABLE IF EXISTS t5 CASCADE;
DROP TABLE IF EXISTS t6 CASCADE;
DROP SCHEMA IF EXISTS other_db CASCADE;
DROP SCHEMA IF EXISTS other_sc CASCADE;
DROP SEQUENCE IF EXISTS drop_test CASCADE;
DROP SEQUENCE IF EXISTS drop_if_exists_test CASCADE;
DROP SEQUENCE IF EXISTS s CASCADE;
DROP SEQUENCE IF EXISTS s2 CASCADE;
DROP SEQUENCE IF EXISTS s3 CASCADE;
DROP SEQUENCE IF EXISTS s5 CASCADE;
DROP SEQUENCE IF EXISTS s6 CASCADE;

-- Test 1: statement (line 3)
-- CockroachDB-only setting:
-- SET sql_safe_updates = true

-- Test 2: statement (line 6)
-- CockroachDB-only cluster setting:
-- SET CLUSTER SETTING sql.cross_db_sequence_references.enabled = TRUE

-- Test 3: statement (line 12)
CREATE SEQUENCE drop_test;

-- Test 4: statement (line 15)
DROP SEQUENCE drop_test;

-- Test 5: statement (line 18)
DROP SEQUENCE IF EXISTS nonexistent;

-- Test 6: statement (line 21)
CREATE SEQUENCE drop_if_exists_test;

-- Test 7: statement (line 24)
DROP SEQUENCE IF EXISTS drop_if_exists_test;

-- Test 8: statement (line 27)
CREATE SEQUENCE drop_test;

-- Test 9: statement (line 30)
CREATE TABLE t1 (i INT NOT NULL DEFAULT nextval('drop_test'));

-- onlyif config schema-locked-disabled

-- Test 10: query (line 34)
SELECT column_name, column_default
FROM information_schema.columns
WHERE table_schema = current_schema()
  AND table_name = 't1'
ORDER BY ordinal_position;

-- Test 11: query (line 44)
SELECT column_name, column_default
FROM information_schema.columns
WHERE table_schema = current_schema()
  AND table_name = 't1'
ORDER BY ordinal_position;

-- Test 12: query (line 53)
SELECT pg_get_serial_sequence('t1', 'i');

-- Test 13: statement (line 58)
-- Expected ERROR (dependent objects):
\set ON_ERROR_STOP 0
DROP SEQUENCE drop_test;
\set ON_ERROR_STOP 1

-- Test 14: statement (line 61)
DROP SEQUENCE drop_test CASCADE;

-- onlyif config schema-locked-disabled

-- Test 15: query (line 65)
SELECT column_name, column_default
FROM information_schema.columns
WHERE table_schema = current_schema()
  AND table_name = 't1'
ORDER BY ordinal_position;

-- Test 16: query (line 75)
SELECT column_name, column_default
FROM information_schema.columns
WHERE table_schema = current_schema()
  AND table_name = 't1'
ORDER BY ordinal_position;

-- Test 17: query (line 84)
SELECT pg_get_serial_sequence('t1', 'i');

-- Test 18: statement (line 89)
INSERT INTO t1 VALUES (1);

-- Test 19: statement (line 98)
-- PostgreSQL does not support cross-database references; model "other_db" as a schema.
CREATE SCHEMA other_db;

-- Test 20: statement (line 101)
CREATE SEQUENCE other_db.s;

-- Test 21: statement (line 104)
CREATE SEQUENCE s;

-- Test 22: statement (line 107)
CREATE TABLE foo (
  i INT NOT NULL DEFAULT nextval('other_db.s'),
  j INT NOT NULL DEFAULT nextval('s')
);

-- onlyif config schema-locked-disabled

-- Test 23: query (line 115)
SELECT column_name, column_default
FROM information_schema.columns
WHERE table_schema = current_schema()
  AND table_name = 'foo'
ORDER BY ordinal_position;

-- Test 24: query (line 127)
SELECT column_name, column_default
FROM information_schema.columns
WHERE table_schema = current_schema()
  AND table_name = 'foo'
ORDER BY ordinal_position;

-- Test 25: query (line 138)
SELECT pg_get_serial_sequence('foo', 'i'), pg_get_serial_sequence('foo', 'j');

-- Test 26: statement (line 143)
-- Expected ERROR (dependent objects):
\set ON_ERROR_STOP 0
DROP SCHEMA other_db;
\set ON_ERROR_STOP 1

-- Test 27: statement (line 146)
DROP SCHEMA other_db CASCADE;

-- onlyif config schema-locked-disabled

-- Test 28: query (line 150)
SELECT column_name, column_default
FROM information_schema.columns
WHERE table_schema = current_schema()
  AND table_name = 'foo'
ORDER BY ordinal_position;

-- Test 29: query (line 162)
SELECT column_name, column_default
FROM information_schema.columns
WHERE table_schema = current_schema()
  AND table_name = 'foo'
ORDER BY ordinal_position;

-- Test 30: query (line 173)
SELECT pg_get_serial_sequence('foo', 'i'), pg_get_serial_sequence('foo', 'j');

-- Test 31: statement (line 178)
INSERT INTO foo VALUES (1, default);

-- Test 32: statement (line 186)
CREATE SCHEMA other_sc;

-- Test 33: statement (line 189)
CREATE SEQUENCE other_sc.s;

-- Test 34: statement (line 192)
CREATE TABLE bar (
  i INT NOT NULL DEFAULT nextval('other_sc.s'),
  j INT NOT NULL DEFAULT nextval('s')
);

-- onlyif config schema-locked-disabled

-- Test 35: query (line 200)
SELECT column_name, column_default
FROM information_schema.columns
WHERE table_schema = current_schema()
  AND table_name = 'bar'
ORDER BY ordinal_position;

-- Test 36: query (line 212)
SELECT column_name, column_default
FROM information_schema.columns
WHERE table_schema = current_schema()
  AND table_name = 'bar'
ORDER BY ordinal_position;

-- Test 37: query (line 223)
SELECT pg_get_serial_sequence('bar', 'i'), pg_get_serial_sequence('bar', 'j');

-- Test 38: statement (line 228)
-- Expected ERROR (dependent objects):
\set ON_ERROR_STOP 0
DROP SCHEMA other_sc;
\set ON_ERROR_STOP 1

-- Test 39: statement (line 231)
DROP SCHEMA other_sc CASCADE;

-- onlyif config schema-locked-disabled

-- Test 40: query (line 235)
SELECT column_name, column_default
FROM information_schema.columns
WHERE table_schema = current_schema()
  AND table_name = 'bar'
ORDER BY ordinal_position;

-- Test 41: query (line 247)
SELECT column_name, column_default
FROM information_schema.columns
WHERE table_schema = current_schema()
  AND table_name = 'bar'
ORDER BY ordinal_position;

-- Test 42: query (line 258)
SELECT pg_get_serial_sequence('bar', 'i'), pg_get_serial_sequence('bar', 'j');

-- Test 43: statement (line 263)
INSERT INTO bar VALUES (1, default);

-- Test 44: statement (line 271)
CREATE TABLE t2 (i INT NOT NULL);

-- Test 45: statement (line 274)
CREATE SEQUENCE s2 OWNED BY t2.i;

-- Test 46: statement (line 277)
CREATE TABLE t3 (i INT NOT NULL DEFAULT nextval('s2'));

-- Test 47: query (line 280)
SELECT pg_get_serial_sequence('t3', 'i');

-- Test 48: statement (line 285)
-- Expected ERROR (dependent objects):
\set ON_ERROR_STOP 0
DROP TABLE t2;
\set ON_ERROR_STOP 1

-- Test 49: statement (line 288)
DROP TABLE t2 CASCADE;

-- onlyif config schema-locked-disabled

-- Test 50: query (line 292)
SELECT column_name, column_default
FROM information_schema.columns
WHERE table_schema = current_schema()
  AND table_name = 't3'
ORDER BY ordinal_position;

-- Test 51: query (line 302)
SELECT column_name, column_default
FROM information_schema.columns
WHERE table_schema = current_schema()
  AND table_name = 't3'
ORDER BY ordinal_position;

-- Test 52: query (line 311)
SELECT pg_get_serial_sequence('t3', 'i');

-- Test 53: statement (line 316)
INSERT INTO t3 VALUES (1);

-- Test 54: statement (line 319)
CREATE SEQUENCE s3;

-- Test 55: statement (line 322)
CREATE TABLE t4 (i INT NOT NULL DEFAULT nextval('s3'));

-- Test 56: statement (line 325)
ALTER SEQUENCE s3 OWNED BY t3.i;

-- Test 57: query (line 328)
SELECT pg_get_serial_sequence('t4', 'i');

-- Test 58: statement (line 333)
DROP TABLE t3 CASCADE;

-- onlyif config schema-locked-disabled

-- Test 59: query (line 337)
SELECT column_name, column_default
FROM information_schema.columns
WHERE table_schema = current_schema()
  AND table_name = 't4'
ORDER BY ordinal_position;

-- Test 60: query (line 347)
SELECT column_name, column_default
FROM information_schema.columns
WHERE table_schema = current_schema()
  AND table_name = 't4'
ORDER BY ordinal_position;

-- Test 61: query (line 356)
SELECT pg_get_serial_sequence('t4', 'i');

-- Test 62: statement (line 361)
INSERT INTO t4 VALUES (1);

-- Test 63: statement (line 369)
CREATE TABLE t5 (i INT NOT NULL);

-- Test 64: statement (line 372)
CREATE SEQUENCE s5 OWNED BY t5.i;

-- Test 65: statement (line 375)
CREATE TABLE t6 (i INT NOT NULL DEFAULT nextval('s5'));

-- Test 66: query (line 378)
SELECT pg_get_serial_sequence('t6', 'i');

-- Test 67: statement (line 383)
-- Expected ERROR (dependent objects):
\set ON_ERROR_STOP 0
ALTER TABLE t5 DROP COLUMN i;
\set ON_ERROR_STOP 1

-- Test 68: statement (line 386)
-- SET sql_safe_updates = false

-- Test 69: statement (line 389)
ALTER TABLE t5 DROP COLUMN i CASCADE;

-- onlyif config schema-locked-disabled

-- Test 70: query (line 393)
SELECT column_name, column_default
FROM information_schema.columns
WHERE table_schema = current_schema()
  AND table_name = 't6'
ORDER BY ordinal_position;

-- Test 71: query (line 403)
SELECT column_name, column_default
FROM information_schema.columns
WHERE table_schema = current_schema()
  AND table_name = 't6'
ORDER BY ordinal_position;

-- Test 72: query (line 412)
SELECT pg_get_serial_sequence('t6', 'i');

-- Test 73: statement (line 417)
INSERT INTO t6 VALUES (1);

-- Test 74: statement (line 425)
CREATE SEQUENCE s6;

-- Test 75: statement (line 428)
CREATE VIEW v AS SELECT nextval('s6');

-- Test 76: statement (line 431)
-- Expected ERROR (dependent objects):
\set ON_ERROR_STOP 0
DROP SEQUENCE s6;
\set ON_ERROR_STOP 1

-- Test 77: statement (line 434)
DROP SEQUENCE s6 CASCADE;

-- Test 78: statement (line 437)
-- Expected ERROR (view does not exist after CASCADE):
\set ON_ERROR_STOP 0
SELECT * FROM v;
\set ON_ERROR_STOP 1

RESET client_min_messages;

