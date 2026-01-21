-- PostgreSQL compatible tests from rename_index
-- 36 tests

SET client_min_messages = warning;

-- Test 1: statement (line 1)
DROP TABLE IF EXISTS users_dupe;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id    INT PRIMARY KEY,
  name  VARCHAR NOT NULL,
  title VARCHAR
);

CREATE TABLE users_dupe (
  id    INT PRIMARY KEY,
  name  VARCHAR NOT NULL,
  title VARCHAR
);

-- In CockroachDB, index names are table-scoped. In PostgreSQL they are schema-scoped,
-- so the duplicate table uses distinct index names to avoid conflicts.
CREATE INDEX foo ON users (name);
CREATE UNIQUE INDEX bar ON users (id, name);

CREATE INDEX foo_dupe ON users_dupe (name);
CREATE UNIQUE INDEX bar_dupe ON users_dupe (id, name);

-- Test 3: statement (line 19)
INSERT INTO users VALUES (1, 'tom', 'cat'),(2, 'jerry', 'rat');

-- Test 4: statement (line 22)
INSERT INTO users_dupe VALUES (1, 'tom', 'cat'),(2, 'jerry', 'rat');

-- Test 5: query (line 25)
SELECT tablename, indexname, indexdef
FROM pg_indexes
WHERE schemaname = 'public' AND tablename = 'users'
ORDER BY 1, 2, 3;

-- Test 6: query (line 37)
SELECT tablename, indexname, indexdef
FROM pg_indexes
WHERE schemaname = 'public' AND tablename = 'users_dupe'
ORDER BY 1, 2, 3;

-- Test 7: statement (line 49)
-- Expected ERROR (name conflict with existing index):
\set ON_ERROR_STOP 0
ALTER INDEX foo RENAME TO bar;

-- Test 8: statement (line 52)
-- Expected ERROR (empty identifier is not allowed):
ALTER INDEX foo RENAME TO "";

-- Test 9: statement (line 55)
-- Expected ERROR (index does not exist):
ALTER INDEX ffo RENAME TO ufo;

-- Test 10: statement (line 58)
-- Expected ERROR (index does not exist):
ALTER INDEX ffo RENAME TO ufo;

-- Test 11: statement (line 61)
-- CockroachDB allows duplicate index names across tables; PostgreSQL does not.
-- The original test exercised ambiguous `ALTER INDEX foo ...` resolution. Skip.
-- ALTER INDEX foo RENAME TO ufo;

-- Test 12: statement (line 64)
-- ALTER INDEX IF EXISTS foo RENAME TO ufo;

-- Test 13: statement (line 67)
-- Expected NOTICE/NO-OP:
ALTER INDEX IF EXISTS ffo RENAME TO ufo;

-- Test 14: statement (line 71)
-- Expected NOTICE/NO-OP:
ALTER INDEX IF EXISTS ffo RENAME TO ufo;
\set ON_ERROR_STOP 1

-- Test 15: statement (line 74)
ALTER INDEX foo RENAME TO ufooo;

-- Test 16: statement (line 77)
ALTER INDEX ufooo RENAME TO ufoo;

-- Test 17: statement (line 80)
ALTER INDEX ufoo RENAME TO ufo;

-- Test 18: query (line 83)
SELECT tablename, indexname, indexdef
FROM pg_indexes
WHERE schemaname = 'public' AND tablename = 'users'
ORDER BY 1, 2, 3;

-- Test 19: statement (line 97)
ALTER INDEX bar RENAME TO rar;

-- Test 20: statement (line 102)
DROP ROLE IF EXISTS rename_index_testuser;
CREATE ROLE rename_index_testuser;

GRANT SELECT ON users TO rename_index_testuser;

-- Test 21: statement (line 107)
-- Expected ERROR (must be owner):
\set ON_ERROR_STOP 0
SET ROLE rename_index_testuser;
ALTER INDEX rar RENAME TO bar;
RESET ROLE;
\set ON_ERROR_STOP 1

-- Test 22: query (line 110)
SELECT tablename, indexname, indexdef
FROM pg_indexes
WHERE schemaname = 'public' AND tablename = 'users'
ORDER BY 1, 2, 3;

-- Test 23: query (line 124)
SET ROLE rename_index_testuser;
SELECT * FROM users ORDER BY id;
RESET ROLE;

-- Test 24: statement (line 133)
ALTER INDEX ufo RENAME TO foo;

-- Test 25: statement (line 136)
ALTER INDEX rar RENAME TO bar;

-- Test 26: statement (line 140)
ALTER INDEX users_pkey RENAME TO pk;

-- Test 27: query (line 143)
SELECT indexname
FROM pg_indexes
WHERE schemaname = 'public' AND tablename = 'users' AND indexname = 'pk';

-- Test 28: statement (line 149)
-- SET vectorize=on;

-- Test 29: query (line 152)
-- PostgreSQL does not support EXPLAIN for DDL.
-- EXPLAIN ALTER INDEX bar RENAME TO woo;

-- Test 30: statement (line 159)
-- RESET vectorize;

-- Test 31: query (line 163)
SELECT DISTINCT indexname AS index_name
FROM pg_indexes
WHERE schemaname = 'public' AND tablename = 'users'
ORDER BY index_name;

-- Test 32: statement (line 171)
CREATE TABLE t1(a int);

-- Test 33: statement (line 174)
BEGIN;

-- Test 34: statement (line 177)
CREATE INDEX i1 ON t1(a);

-- Test 35: statement (line 180)
ALTER INDEX i1 RENAME TO i2;

-- Test 36: statement (line 183)
COMMIT;

REVOKE ALL ON TABLE users FROM rename_index_testuser;
DROP ROLE IF EXISTS rename_index_testuser;

RESET client_min_messages;
