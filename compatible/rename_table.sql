-- PostgreSQL compatible tests from rename_table
-- 93 tests

SET client_min_messages = warning;

-- Setup for repeatability (roles are cluster-wide; schemas are per-db).
DROP SCHEMA IF EXISTS test2 CASCADE;
DROP SCHEMA IF EXISTS test CASCADE;
DROP ROLE IF EXISTS testuser;

CREATE ROLE testuser LOGIN;

CREATE SCHEMA test;
CREATE SCHEMA test2;

-- Helper: run a statement that is expected to error without emitting psql ERROR output.
-- Returns true if the statement errored, false otherwise.
CREATE OR REPLACE FUNCTION pg_temp.expect_error(sql text) RETURNS boolean
LANGUAGE plpgsql
AS $$
BEGIN
  EXECUTE sql;
  RETURN false;
EXCEPTION WHEN OTHERS THEN
  RETURN true;
END;
$$;

RESET client_min_messages;

-- Test 1: statement (line 1)
SELECT pg_temp.expect_error($sql$ALTER TABLE foo RENAME TO bar$sql$);

-- Test 2: statement (line 4)
ALTER TABLE IF EXISTS foo RENAME TO bar;

-- Test 3: statement (line 7)
CREATE TABLE kv (
  k INT PRIMARY KEY,
  v INT
);

-- Test 4: statement (line 13)
INSERT INTO kv VALUES (1, 2), (3, 4);

-- Test 5: query (line 16)
SELECT * FROM kv;

-- Test 6: query (line 22)
SELECT table_name, table_type
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;

-- Test 7: statement (line 27)
ALTER TABLE kv RENAME TO new_kv;

-- Test 8: statement (line 30)
SELECT pg_temp.expect_error($sql$SELECT * FROM kv$sql$);

-- Test 9: query (line 33)
SELECT * FROM new_kv;

-- Test 10: query (line 39)
SELECT table_name, table_type
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;

-- Test 11: query (line 45)
SELECT grantee, privilege_type
FROM information_schema.role_table_grants
WHERE table_schema = 'public'
  AND table_name = 'new_kv'
ORDER BY grantee, privilege_type;

-- Test 12: statement (line 51)
SELECT pg_temp.expect_error($sql$ALTER TABLE "" RENAME TO foo$sql$);

-- Test 13: statement (line 54)
SELECT pg_temp.expect_error($sql$ALTER TABLE new_kv RENAME TO ""$sql$);

-- Test 14: statement (line 57)
SELECT pg_temp.expect_error($sql$ALTER TABLE new_kv RENAME TO new_kv$sql$);

-- Test 15: statement (line 60)
CREATE TABLE t (
  c1 INT PRIMARY KEY,
  c2 INT
);

-- Test 16: statement (line 66)
INSERT INTO t VALUES (4, 16), (5, 25);

-- Test 17: statement (line 69)
SELECT pg_temp.expect_error($sql$ALTER TABLE t RENAME TO new_kv$sql$);

-- Create base objects in schema test for the permission/namespace tests.
CREATE TABLE test.t (
  c1 INT PRIMARY KEY,
  c2 INT
);
CREATE TABLE test.new_kv (
  k INT PRIMARY KEY,
  v INT
);

SET SESSION AUTHORIZATION testuser;
SET search_path TO test, public;

-- Test 18: statement (line 74)
SELECT pg_temp.expect_error($sql$ALTER TABLE test.t RENAME TO t2$sql$);

SET SESSION AUTHORIZATION DEFAULT;
RESET search_path;

-- Test 19: statement (line 79)
ALTER TABLE test.t OWNER TO testuser;
GRANT USAGE, CREATE ON SCHEMA test TO testuser;

-- Test 20: statement (line 82)
CREATE SCHEMA IF NOT EXISTS test2;

SET SESSION AUTHORIZATION testuser;
SET search_path TO test, public;

-- Test 21: statement (line 87)
ALTER TABLE test.t RENAME TO t2;

SET SESSION AUTHORIZATION DEFAULT;
RESET search_path;

-- Test 22: statement (line 92)
GRANT USAGE, CREATE ON SCHEMA test TO testuser;

-- Test 23: statement (line 95)
SELECT pg_temp.expect_error($sql$ALTER TABLE test.t RENAME TO t2$sql$);

-- Test 24: query (line 98)
SELECT table_name, table_type
FROM information_schema.tables
WHERE table_schema = 'test'
ORDER BY table_name;

-- Test 25: statement (line 106)
ALTER TABLE test.t2 SET SCHEMA test2;
ALTER TABLE test2.t2 RENAME TO t;

-- Test 26: statement (line 111)
GRANT USAGE, CREATE ON SCHEMA test2 TO testuser;

-- Test 27: statement (line 114)
ALTER TABLE test.new_kv OWNER TO testuser;

SET SESSION AUTHORIZATION testuser;
SET search_path TO test, public;

-- Test 28: query (line 119)
SELECT table_name, table_type
FROM information_schema.tables
WHERE table_schema = 'test'
ORDER BY table_name;

-- Test 29: query (line 125)
SELECT table_name, table_type
FROM information_schema.tables
WHERE table_schema = 'test2'
ORDER BY table_name;

-- Test 30: statement (line 131)
CREATE TABLE test2.t2(c1 INT, c2 INT);

-- Test 31: statement (line 134)
CREATE VIEW test2.v1 AS SELECT c1,c2 FROM test2.t2;

-- Test 32: statement (line 137)
ALTER TABLE test2.v1 RENAME TO v2;

-- Test 33: statement (line 140)
ALTER TABLE test2.v2 RENAME TO v1;

-- Test 34: statement (line 143)
ALTER TABLE test2.t2 RENAME TO t3;

-- Back to the default superuser for the transaction/DDL semantics tests.
SET SESSION AUTHORIZATION DEFAULT;
RESET search_path;

-- Test 35: statement (line 150)
BEGIN;

-- Test 36: statement (line 153)
CREATE SCHEMA d;
CREATE TABLE d.kv (k CHAR PRIMARY KEY, v CHAR);

-- Test 37: statement (line 156)
INSERT INTO d.kv (k,v) VALUES ('a', 'b');

-- Test 38: statement (line 159)
COMMIT;

-- Test 39: statement (line 162)
INSERT INTO d.kv (k,v) VALUES ('c', 'd');

-- Test 40: statement (line 166)
SELECT pg_temp.expect_error($sql$SET autocommit_before_ddl = false$sql$);

-- Test 41: statement (line 169)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- Test 42: statement (line 172)
CREATE SCHEMA dd;
CREATE TABLE dd.kv (k CHAR PRIMARY KEY, v CHAR);

-- Test 43: statement (line 175)
INSERT INTO dd.kv (k,v) VALUES ('a', 'b');

-- Test 44: statement (line 178)
ROLLBACK;

-- Test 45: statement (line 181)
SELECT pg_temp.expect_error($sql$INSERT INTO dd.kv (k,v) VALUES ('c', 'd')$sql$);

-- Test 46: statement (line 185)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- Test 47: statement (line 188)
CREATE TABLE d.kv2 (k CHAR PRIMARY KEY, v CHAR);

-- Test 48: statement (line 191)
INSERT INTO d.kv2 (k,v) VALUES ('a', 'b');

-- Test 49: statement (line 194)
ROLLBACK;

-- Test 50: statement (line 197)
SELECT pg_temp.expect_error($sql$RESET autocommit_before_ddl$sql$);

-- Test 51: statement (line 200)
SELECT pg_temp.expect_error($sql$INSERT INTO d.kv2 (k,v) VALUES ('c', 'd')$sql$);

-- Test 52: statement (line 203)
SET search_path TO d, public;

-- Test 53: query (line 206)
SELECT table_name, table_type
FROM information_schema.tables
WHERE table_schema = 'd'
ORDER BY table_name;

-- Test 54: statement (line 211)
SELECT pg_temp.expect_error($sql$SET vectorize=on$sql$);

-- Test 55: query (line 214)
SELECT pg_temp.expect_error($sql$EXPLAIN ALTER TABLE kv RENAME TO kv2$sql$);

-- Test 56: statement (line 221)
SELECT pg_temp.expect_error($sql$RESET vectorize$sql$);

-- Test 57: query (line 225)
SELECT table_name, table_type
FROM information_schema.tables
WHERE table_schema = 'd'
ORDER BY table_name;

RESET search_path;

-- Test 58: statement (line 234)
CREATE SCHEMA olddb;

-- Test 59: statement (line 237)
CREATE SCHEMA newdb;

-- Test 60: statement (line 240)
SET search_path TO olddb, public;

-- Test 61: statement (line 243)
CREATE SCHEMA olddb_oldsc;

-- Test 62: statement (line 246)
SET search_path TO newdb, public;

-- Test 63: statement (line 249)
CREATE SCHEMA newdb_newsc;

-- Test 64: statement (line 252)
CREATE TABLE olddb.tbl1();

-- Test 65: statement (line 255)
CREATE TABLE olddb_oldsc.tbl2();

-- Test 66: statement (line 258)
ALTER TABLE IF EXISTS olddb.tbl1 SET SCHEMA newdb_newsc;

-- Test 67: statement (line 261)
ALTER TABLE IF EXISTS olddb_oldsc.tbl2 SET SCHEMA newdb;

-- Test 68: statement (line 264)
ALTER TABLE IF EXISTS olddb_oldsc.tbl2 SET SCHEMA newdb_newsc;

-- Test 69: statement (line 269)
ALTER TABLE IF EXISTS olddb.tbl1 SET SCHEMA newdb_newsc;

-- Test 70: statement (line 272)
ALTER TABLE IF EXISTS olddb_oldsc.tbl2 SET SCHEMA newdb;

-- Test 71: statement (line 275)
RESET search_path;
DROP SCHEMA IF EXISTS olddb_oldsc CASCADE;
DROP SCHEMA IF EXISTS olddb CASCADE;

-- Test 72: statement (line 278)
DROP SCHEMA IF EXISTS newdb_newsc CASCADE;
DROP SCHEMA IF EXISTS newdb CASCADE;

-- Test 73: statement (line 283)
CREATE SCHEMA olddb;

-- Test 74: statement (line 286)
CREATE SCHEMA newdb;

-- Test 75: statement (line 289)
SET search_path TO olddb, public;

-- Test 76: statement (line 292)
CREATE TYPE typ AS ENUM ('foo');

-- Test 77: statement (line 295)
CREATE TABLE tbl(a typ);

-- Test 78: statement (line 298)
SELECT pg_temp.expect_error($sql$ALTER TABLE tbl RENAME TO newdb.tbl$sql$);

-- Test 79: statement (line 303)
CREATE TABLE tbl2();

-- Test 80: statement (line 306)
BEGIN;

-- Test 81: statement (line 309)
ALTER TABLE tbl2 ADD COLUMN b typ;

-- Test 82: statement (line 312)
SELECT pg_temp.expect_error($sql$ALTER TABLE tbl2 RENAME TO newdb.tbl2$sql$);

-- Test 83: statement (line 315)
ROLLBACK;

-- Test 84: statement (line 318)
BEGIN;

-- Test 85: statement (line 321)
ALTER TABLE tbl DROP COLUMN a;

-- Test 86: statement (line 324)
SELECT pg_temp.expect_error($sql$ALTER TABLE tbl RENAME TO newdb.tbl$sql$);

-- Test 87: statement (line 327)
ROLLBACK;

-- Test 88: statement (line 330)
RESET search_path;
DROP SCHEMA IF EXISTS olddb CASCADE;

-- Test 89: statement (line 333)
DROP SCHEMA IF EXISTS newdb CASCADE;

-- Test 90: statement (line 338)
CREATE SCHEMA newdb;

-- Test 91: statement (line 341)
SET search_path TO newdb, public;

-- Test 92: statement (line 346)
CREATE SCHEMA d1;
CREATE TABLE d1.t();
CREATE SCHEMA d2;

-- Test 93: statement (line 351)
ALTER TABLE d1.t SET SCHEMA d2;
