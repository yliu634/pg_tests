-- PostgreSQL compatible tests from rename_view
-- 41 tests

SET client_min_messages = warning;

-- Setup for repeatability (roles are cluster-wide; schemas are per-db).
DROP SCHEMA IF EXISTS test2 CASCADE;
DROP SCHEMA IF EXISTS test CASCADE;
DROP ROLE IF EXISTS testuser;

CREATE ROLE testuser LOGIN;

CREATE SCHEMA test;
CREATE SCHEMA test2;

RESET client_min_messages;

-- Test 1: statement (line 1)
-- Cockroach-only: SET CLUSTER SETTING sql.cross_db_views.enabled = TRUE;

-- Test 2: statement (line 4)
\set ON_ERROR_STOP 0
ALTER VIEW foo RENAME TO bar;
\set ON_ERROR_STOP 1

-- Test 3: statement (line 7)
ALTER VIEW IF EXISTS foo RENAME TO bar;

-- Test 4: statement (line 10)
CREATE TABLE kv (
  k INT PRIMARY KEY,
  v INT
);

-- Test 5: statement (line 16)
INSERT INTO kv VALUES (1, 2), (3, 4);

-- Test 6: statement (line 19)
CREATE VIEW v AS SELECT k, v FROM kv;

-- Test 7: query (line 22)
SELECT * FROM v;

-- Test 8: query (line 28)
SELECT table_name, table_type
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;

-- Test 9: statement (line 34)
\set ON_ERROR_STOP 0
ALTER VIEW kv RENAME TO new_kv;
\set ON_ERROR_STOP 1

-- Test 10: statement (line 38)
ALTER TABLE v RENAME TO new_v;

-- Test 11: statement (line 41)
\set ON_ERROR_STOP 0
SELECT * FROM v;
\set ON_ERROR_STOP 1

-- Test 12: query (line 44)
SELECT * FROM new_v;

-- Test 13: query (line 50)
SELECT table_name, table_type
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;

-- Test 14: query (line 57)
SELECT grantee, privilege_type
FROM information_schema.role_table_grants
WHERE table_schema = 'public'
  AND table_name = 'new_v'
ORDER BY grantee, privilege_type;

-- Test 15: statement (line 63)
\set ON_ERROR_STOP 0
ALTER VIEW "" RENAME TO foo;
\set ON_ERROR_STOP 1

-- Test 16: statement (line 66)
\set ON_ERROR_STOP 0
ALTER VIEW new_v RENAME TO "";
\set ON_ERROR_STOP 1

-- Test 17: statement (line 69)
\set ON_ERROR_STOP 0
ALTER VIEW new_v RENAME TO new_v;
\set ON_ERROR_STOP 1

-- Create base objects in schema test for the cross-schema rename tests.
CREATE TABLE test.kv (
  k INT PRIMARY KEY,
  v INT
);
INSERT INTO test.kv VALUES (1, 2), (3, 4);
CREATE VIEW test.new_v AS SELECT k, v FROM test.kv;

-- Test 18: statement (line 72)
CREATE TABLE test.t (
  c1 INT PRIMARY KEY,
  c2 INT
);

-- Test 19: statement (line 78)
INSERT INTO test.t VALUES (4, 16), (5, 25);

-- Test 20: statement (line 81)
CREATE VIEW test.v AS SELECT c1, c2 FROM test.t;

-- Test 21: statement (line 84)
\set ON_ERROR_STOP 0
ALTER VIEW test.v RENAME TO new_v;
\set ON_ERROR_STOP 1

SET SESSION AUTHORIZATION testuser;
SET search_path TO test, public;

-- Test 22: statement (line 89)
\set ON_ERROR_STOP 0
ALTER VIEW test.v RENAME TO v2;
\set ON_ERROR_STOP 1

SET SESSION AUTHORIZATION DEFAULT;

-- Test 23: statement (line 94)
ALTER VIEW test.v OWNER TO testuser;

-- Test 24: statement (line 97)
CREATE SCHEMA IF NOT EXISTS test2;

SET SESSION AUTHORIZATION testuser;
SET search_path TO test, public;

-- Test 25: statement (line 102)
\set ON_ERROR_STOP 0
ALTER VIEW test.v RENAME TO v2;
\set ON_ERROR_STOP 1

SET SESSION AUTHORIZATION DEFAULT;

-- Test 26: statement (line 107)
GRANT USAGE, CREATE ON SCHEMA test TO testuser;
GRANT SELECT ON test.kv, test.t TO testuser;

-- Test 27: statement (line 110)
ALTER VIEW test.v RENAME TO v2;

-- Test 28: query (line 113)
SELECT table_name, table_type
FROM information_schema.tables
WHERE table_schema = 'test'
ORDER BY table_name;

-- Test 29: statement (line 123)
\set ON_ERROR_STOP 0
ALTER VIEW test.v2 RENAME TO test2.v;
\set ON_ERROR_STOP 1

-- Test 30: statement (line 128)
GRANT USAGE, CREATE ON SCHEMA test2 TO testuser;

-- Test 31: statement (line 131)
ALTER VIEW test.new_v OWNER TO testuser;

SET SESSION AUTHORIZATION testuser;
SET search_path TO test, public;

-- Test 32: statement (line 136)
ALTER VIEW test.new_v RENAME TO v;

-- Test 33: query (line 139)
SELECT table_name, table_type
FROM information_schema.tables
WHERE table_schema = 'test'
ORDER BY table_name;

-- Test 34: query (line 147)
SELECT table_name, table_type
FROM information_schema.tables
WHERE table_schema = 'test2'
ORDER BY table_name;

-- Test 35: query (line 153)
SELECT * FROM test.v;

-- Test 36: query (line 159)
SELECT * FROM test.v2;

-- Test 37: statement (line 165)
CREATE VIEW v3 AS SELECT count(*) FROM test.v AS v JOIN test.v2 AS v2 ON v.k > v2.c1;

-- Test 38: statement (line 169)
\set ON_ERROR_STOP 0
ALTER VIEW test.v RENAME TO v3;
\set ON_ERROR_STOP 1

-- Test 39: statement (line 176)
ALTER VIEW test.v2 RENAME TO v4;

-- Test 40: statement (line 179)
\set ON_ERROR_STOP 0
ALTER VIEW v3 RENAME TO v4;
\set ON_ERROR_STOP 1

-- Test 41: statement (line 182)
\set ON_ERROR_STOP 0
ALTER VIEW test.v2 RENAME TO v5;
\set ON_ERROR_STOP 1

-- Cleanup
SET SESSION AUTHORIZATION DEFAULT;
DROP SCHEMA test2 CASCADE;
DROP SCHEMA test CASCADE;
DROP ROLE testuser;
