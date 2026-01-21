-- PostgreSQL compatible tests from alter_role_set
-- Adapted from CockroachDB's alter_role_set logic tests.

SET client_min_messages = warning;

-- Roles are cluster-global; reset and recreate for repeatable runs.
RESET ROLE;
DROP ROLE IF EXISTS test_set_role;
CREATE ROLE test_set_role;

-- Helper query: show role settings (global and database-specific) for test_set_role.
SELECT
  COALESCE(d.datname, '<all dbs>') AS database,
  r.rolname AS role,
  s.setconfig
FROM pg_catalog.pg_db_role_setting s
JOIN pg_catalog.pg_roles r ON s.setrole = r.oid
LEFT JOIN pg_catalog.pg_database d ON s.setdatabase = d.oid
WHERE r.rolname = 'test_set_role'
ORDER BY 1, 2;

-- Basic role settings.
ALTER ROLE test_set_role SET application_name = 'a';
SELECT format(
  'ALTER ROLE test_set_role IN DATABASE %I SET application_name = %L',
  current_database(),
  'b'
) \gexec
ALTER ROLE test_set_role SET custom_option.setting = 'e';

SELECT
  COALESCE(d.datname, '<all dbs>') AS database,
  r.rolname AS role,
  s.setconfig
FROM pg_catalog.pg_db_role_setting s
JOIN pg_catalog.pg_roles r ON s.setrole = r.oid
LEFT JOIN pg_catalog.pg_database d ON s.setdatabase = d.oid
WHERE r.rolname = 'test_set_role'
ORDER BY 1, 2;

-- Mix in another built-in GUC and update/reset values.
ALTER ROLE test_set_role SET backslash_quote = 'safe_encoding';
ALTER ROLE test_set_role SET application_name = 'f';
ALTER ROLE test_set_role RESET application_name;

-- Custom (dot-qualified) GUCs are allowed in PostgreSQL; use them for CRDB-only knobs.
ALTER ROLE test_set_role SET custom_option.potato = 'potato';
ALTER ROLE test_set_role RESET custom_option.potato;
ALTER ROLE test_set_role SET custom_option.potato TO DEFAULT;

SELECT
  COALESCE(d.datname, '<all dbs>') AS database,
  r.rolname AS role,
  s.setconfig
FROM pg_catalog.pg_db_role_setting s
JOIN pg_catalog.pg_roles r ON s.setrole = r.oid
LEFT JOIN pg_catalog.pg_database d ON s.setdatabase = d.oid
WHERE r.rolname = 'test_set_role'
ORDER BY 1, 2;

-- Cleanup.
ALTER ROLE test_set_role RESET ALL;
DROP ROLE test_set_role;
RESET client_min_messages;

