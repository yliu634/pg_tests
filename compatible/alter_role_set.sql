-- PostgreSQL compatible tests from alter_role_set
-- NOTE: This is a PostgreSQL-focused port. CockroachDB-specific system tables
-- (e.g. system.database_role_settings) and cluster privileges are not available.

SET client_min_messages = warning;

-- Cleanup from prior runs.
DROP DATABASE IF EXISTS test_set_db;
DROP ROLE IF EXISTS test_set_role;

-- Test 1: statement
CREATE ROLE test_set_role;
CREATE DATABASE test_set_db;

-- Test 2: statement
ALTER ROLE test_set_role SET application_name = 'a';
ALTER ROLE test_set_role IN DATABASE test_set_db SET application_name = 'b';
ALTER ROLE ALL IN DATABASE test_set_db SET application_name = 'c';
ALTER ROLE ALL SET application_name = 'd';
ALTER ROLE test_set_role SET custom_option.setting = 'e';

-- Test 3: query
SELECT
  COALESCE(d.datname, 'ALL') AS database,
  COALESCE(r.rolname, 'ALL') AS role,
  setconfig
FROM pg_catalog.pg_db_role_setting s
LEFT JOIN pg_catalog.pg_database d ON s.setdatabase = d.oid
LEFT JOIN pg_catalog.pg_roles r ON s.setrole = r.oid
ORDER BY 1, 2;

-- Test 4: statement
ALTER ROLE test_set_role RESET application_name;
ALTER ROLE test_set_role RESET custom_option.setting;

-- Test 5: query
SELECT
  COALESCE(d.datname, 'ALL') AS database,
  COALESCE(r.rolname, 'ALL') AS role,
  setconfig
FROM pg_catalog.pg_db_role_setting s
LEFT JOIN pg_catalog.pg_database d ON s.setdatabase = d.oid
LEFT JOIN pg_catalog.pg_roles r ON s.setrole = r.oid
ORDER BY 1, 2;

-- Test 6: statement
ALTER ROLE ALL RESET ALL;

-- Test 7: query
SELECT
  COALESCE(d.datname, 'ALL') AS database,
  COALESCE(r.rolname, 'ALL') AS role,
  setconfig
FROM pg_catalog.pg_db_role_setting s
LEFT JOIN pg_catalog.pg_database d ON s.setdatabase = d.oid
LEFT JOIN pg_catalog.pg_roles r ON s.setrole = r.oid
ORDER BY 1, 2;

-- Cleanup.
DROP DATABASE IF EXISTS test_set_db;
DROP ROLE IF EXISTS test_set_role;

RESET client_min_messages;
