-- PostgreSQL compatible tests from drop_schema
-- 10 tests

-- Test 1: statement (line 1)
DROP SCHEMA public

-- Test 2: statement (line 4)
CREATE DATABASE test2

-- Test 3: statement (line 7)
DROP SCHEMA test2.public

-- Test 4: statement (line 13)
CREATE SCHEMA schema_123539;

-- Test 5: statement (line 16)
CREATE TYPE schema_123539.enum_123539 AS ENUM ('s', 't');

-- Test 6: statement (line 19)
BEGIN;
ALTER TYPE schema_123539.enum_123539 DROP VALUE 's';
DROP SCHEMA schema_123539 CASCADE;
COMMIT;

-- Test 7: statement (line 28)
DROP SCHEMA system.public

-- Test 8: statement (line 31)
DROP SCHEMA pg_catalog

user testuser

-- Test 9: statement (line 36)
DROP SCHEMA system.public

-- Test 10: statement (line 39)
DROP SCHEMA crdb_internal

user root

