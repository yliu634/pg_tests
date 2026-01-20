-- PostgreSQL compatible tests from connect_privilege
-- 7 tests
-- NOTE: CockroachDB `user <name>` directives are not supported by PostgreSQL.
-- This file focuses on CONNECT privilege metadata in pg_database.

SET client_min_messages = warning;

-- Ensure idempotent role setup without DO wrappers.
SELECT 'DROP OWNED BY testuser;'
WHERE EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'testuser')
\gexec
SELECT 'DROP ROLE testuser;'
WHERE EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'testuser')
\gexec
CREATE ROLE testuser;

-- Test 1: query (line 4)
SELECT datname, datacl FROM pg_database WHERE datname = current_database();

-- Test 2: statement (line 9)
REVOKE CONNECT ON DATABASE pg_tests FROM PUBLIC;

-- Test 3: query (line 14)
SELECT datname, datacl FROM pg_database WHERE datname = current_database();

-- Test 4: statement (line 27)
GRANT CONNECT ON DATABASE pg_tests TO testuser;

-- Test 5: query (line 32)
SELECT datname, datacl FROM pg_database WHERE datname = current_database();

-- Cleanup
GRANT CONNECT ON DATABASE pg_tests TO PUBLIC;
REVOKE CONNECT ON DATABASE pg_tests FROM testuser;
SELECT 'DROP OWNED BY testuser;'
WHERE EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'testuser')
\gexec
SELECT 'DROP ROLE testuser;'
WHERE EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'testuser')
\gexec

RESET client_min_messages;
