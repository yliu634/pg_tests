-- PostgreSQL compatible tests from alter_default_privileges_for_table
-- 75 tests

-- CockroachDB tests for ALTER DEFAULT PRIVILEGES include CRDB-only directives
-- (USE/RESET database, SHOW GRANTS, user switches). This file is rewritten as
-- pure PostgreSQL SQL/psql while keeping the same semantic focus: default
-- privileges for TABLES (including views), scoped to a schema, and how those
-- defaults differ from sequences.

SET client_min_messages = warning;

-- Keep role names scoped to this file to avoid cross-test collisions.
DROP SCHEMA IF EXISTS adp_table CASCADE;
DROP ROLE IF EXISTS adp_table_testuser3;
DROP ROLE IF EXISTS adp_table_testuser2;
DROP ROLE IF EXISTS adp_table_who;
DROP ROLE IF EXISTS adp_table_testuser;
DROP ROLE IF EXISTS adp_table_root;

CREATE ROLE adp_table_root SUPERUSER;
CREATE ROLE adp_table_testuser;
CREATE ROLE adp_table_who;
CREATE ROLE adp_table_testuser2;
CREATE ROLE adp_table_testuser3;

CREATE SCHEMA adp_table;
GRANT USAGE, CREATE ON SCHEMA adp_table TO adp_table_testuser;

-- Test 1: default privileges for objects created by adp_table_root.
ALTER DEFAULT PRIVILEGES FOR ROLE adp_table_root IN SCHEMA adp_table
  GRANT SELECT ON TABLES TO adp_table_who;

SET ROLE adp_table_root;
SET search_path = adp_table, public;
DROP TABLE IF EXISTS t_root;
CREATE TABLE t_root();

-- "SHOW GRANTS ON t_root"
SELECT grantee, privilege_type, is_grantable
FROM information_schema.table_privileges
WHERE table_schema = 'adp_table'
  AND table_name = 't_root'
ORDER BY grantee, privilege_type;

-- Test 2: default privileges for objects created by adp_table_testuser.
ALTER DEFAULT PRIVILEGES FOR ROLE adp_table_testuser IN SCHEMA adp_table
  GRANT SELECT ON TABLES TO adp_table_who, adp_table_testuser2;

SET ROLE adp_table_testuser;
DROP TABLE IF EXISTS t_testuser;
CREATE TABLE t_testuser();

-- "SHOW GRANTS ON t_testuser"
SELECT grantee, privilege_type, is_grantable
FROM information_schema.table_privileges
WHERE table_schema = 'adp_table'
  AND table_name = 't_testuser'
ORDER BY grantee, privilege_type;

-- Test 3: revoke from one grantee and create another table to show the delta.
ALTER DEFAULT PRIVILEGES FOR ROLE adp_table_testuser IN SCHEMA adp_table
  REVOKE SELECT ON TABLES FROM adp_table_who;

DROP TABLE IF EXISTS t_testuser2;
CREATE TABLE t_testuser2();

-- "SHOW GRANTS ON t_testuser2"
SELECT grantee, privilege_type, is_grantable
FROM information_schema.table_privileges
WHERE table_schema = 'adp_table'
  AND table_name = 't_testuser2'
ORDER BY grantee, privilege_type;

-- Test 4: views are included in "TABLES" default privileges in PostgreSQL.
DROP VIEW IF EXISTS v_testuser;
CREATE VIEW v_testuser AS SELECT 1 AS x;

-- "SHOW GRANTS ON v_testuser"
SELECT grantee, privilege_type, is_grantable
FROM information_schema.table_privileges
WHERE table_schema = 'adp_table'
  AND table_name = 'v_testuser'
ORDER BY grantee, privilege_type;

-- Test 5: sequences are NOT affected by default privileges on TABLES.
DROP SEQUENCE IF EXISTS s_testuser;
CREATE SEQUENCE s_testuser;

SELECT
  has_sequence_privilege('adp_table_who', 'adp_table.s_testuser', 'USAGE') AS who_usage,
  has_sequence_privilege('adp_table_testuser2', 'adp_table.s_testuser', 'USAGE') AS testuser2_usage,
  has_sequence_privilege('adp_table_testuser3', 'adp_table.s_testuser', 'USAGE') AS testuser3_usage;

RESET ROLE;

-- Expected ERROR: TABLES does not support USAGE privileges in PostgreSQL.
\set ON_ERROR_STOP 0
ALTER DEFAULT PRIVILEGES GRANT USAGE ON TABLES TO adp_table_testuser;
\set ON_ERROR_STOP 1

RESET client_min_messages;

