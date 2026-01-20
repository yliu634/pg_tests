-- PostgreSQL compatible tests from system
-- Reduced subset: CockroachDB `system` database and SHOW commands are not
-- available in PostgreSQL; validate catalog introspection instead.

-- Test 1: SHOW DATABASES (PostgreSQL equivalent)
SELECT datname FROM pg_database ORDER BY datname;

-- Test 2: List a few catalogs/tables.
SELECT table_schema, table_name, table_type
FROM information_schema.tables
WHERE table_schema IN ('pg_catalog', 'information_schema')
ORDER BY table_schema, table_name
LIMIT 10;

-- Test 3: SHOW COLUMNS for a system catalog.
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'pg_catalog' AND table_name = 'pg_database'
ORDER BY ordinal_position
LIMIT 10;

-- Test 4: Basic privilege checks on the current database.
SET client_min_messages = warning;
DROP ROLE IF EXISTS system_testuser;
RESET client_min_messages;

CREATE ROLE system_testuser;
GRANT CONNECT ON DATABASE pg_tests TO system_testuser;

SELECT
  has_database_privilege('system_testuser', current_database(), 'CONNECT') AS can_connect,
  has_database_privilege('system_testuser', current_database(), 'CREATE') AS can_create;
