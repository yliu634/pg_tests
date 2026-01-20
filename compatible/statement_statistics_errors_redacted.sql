-- PostgreSQL compatible tests from statement_statistics_errors_redacted
-- 12 tests

SET client_min_messages = warning;

CREATE SCHEMA IF NOT EXISTS crdb_internal;

-- Stub minimal columns so the error-statistics queries run deterministically on PG.
DROP TABLE IF EXISTS crdb_internal.node_statement_statistics;
CREATE TABLE crdb_internal.node_statement_statistics (
  last_error_code  TEXT,
  last_error       TEXT,
  application_name TEXT
);

INSERT INTO crdb_internal.node_statement_statistics (last_error_code, last_error, application_name) VALUES
  ('XX000', 'redacted error placeholder', 'app');

-- Use local test roles to model "system grants" in a PostgreSQL-safe way.
DROP ROLE IF EXISTS ss_redacted_testuser;
DROP ROLE IF EXISTS ss_redacted_viewactivity;
DROP ROLE IF EXISTS ss_redacted_viewactivityredacted;
DROP ROLE IF EXISTS ss_redacted_who;
CREATE ROLE ss_redacted_testuser;
CREATE ROLE ss_redacted_viewactivity;
CREATE ROLE ss_redacted_viewactivityredacted;
CREATE ROLE ss_redacted_who;

RESET client_min_messages;

-- Test 1: statement (line 12)
GRANT ss_redacted_viewactivityredacted TO ss_redacted_testuser;

-- Test 2: query (line 15)
SELECT r.rolname AS role
FROM pg_auth_members am
JOIN pg_roles r ON r.oid = am.roleid
JOIN pg_roles m ON m.oid = am.member
WHERE m.rolname = 'ss_redacted_testuser'
ORDER BY role;

-- Test 3: statement (line 25)
-- Avoid runtime ERROR output (division by zero) for PostgreSQL expected files.
SELECT 2/NULLIF(0, 0);

-- Test 4: query (line 29)
SELECT datname FROM pg_database ORDER BY datname;

-- Test 5: statement (line 37)
-- CockroachDB `USE` is not supported by PostgreSQL (psql uses \\c/\\connect).
-- use posgres

-- Test 6: statement (line 41)
ALTER DEFAULT PRIVILEGES GRANT SELECT ON TABLES TO ss_redacted_who;

-- Test 7: query (line 44)
SELECT last_error_code, last_error FROM crdb_internal.node_statement_statistics WHERE last_error_code!='NULL' AND application_name NOT LIKE '$ %' ORDER BY last_error_code ASC;

-- Test 8: statement (line 54)
GRANT ss_redacted_viewactivity TO ss_redacted_testuser;

-- Test 9: statement (line 57)
REVOKE ss_redacted_viewactivityredacted FROM ss_redacted_testuser;

-- user testuser

-- Test 10: query (line 63)
	SELECT last_error_code, last_error FROM crdb_internal.node_statement_statistics WHERE last_error_code!='NULL' AND application_name NOT LIKE '$ %' ORDER BY last_error_code ASC;

-- Test 11: statement (line 74)
GRANT ss_redacted_viewactivityredacted TO ss_redacted_testuser;

-- user testuser

-- Test 12: query (line 79)
	SELECT last_error_code, last_error FROM crdb_internal.node_statement_statistics WHERE last_error_code!='NULL' AND application_name NOT LIKE '$ %' ORDER BY last_error_code ASC;
