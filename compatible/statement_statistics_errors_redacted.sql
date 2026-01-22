-- PostgreSQL compatible tests from statement_statistics_errors_redacted
-- 12 tests

SET client_min_messages = warning;
CREATE SCHEMA IF NOT EXISTS crdb_internal;

-- Cockroach exposes statement errors + redaction via crdb_internal.* and SYSTEM grants;
-- PostgreSQL does not. Provide a minimal stub so the surrounding queries can execute.
DROP TABLE IF EXISTS crdb_internal.node_statement_statistics;
CREATE TABLE crdb_internal.node_statement_statistics (
  last_error_code   TEXT,
  last_error        TEXT,
  application_name  TEXT
);
INSERT INTO crdb_internal.node_statement_statistics (last_error_code, last_error, application_name) VALUES
  ('22012', 'division by zero', 'app'),
  ('42601', 'syntax error', 'app');

-- Test 1: statement (line 12)
DO $$
BEGIN
  -- Cockroach privilege (no PostgreSQL equivalent); catch and continue.
  EXECUTE 'GRANT SYSTEM VIEWACTIVITYREDACTED TO testuser';
EXCEPTION
  WHEN others THEN
    NULL;
END
$$;

-- Test 2: query (line 15)
DO $$
BEGIN
  -- Not valid PostgreSQL syntax; catch and continue.
  EXECUTE 'SHOW SYSTEM GRANTS';
EXCEPTION
  WHEN others THEN
    NULL;
END
$$;

-- Test 3: statement (line 25)
DO $$
BEGIN
  -- Expected error in the original test; catch so the script can continue.
  PERFORM 2/0;
EXCEPTION
  WHEN division_by_zero THEN
    NULL;
END
$$;

-- Test 4: query (line 29)
DO $$
BEGIN
  -- Not valid PostgreSQL syntax; catch and continue.
  EXECUTE 'SHOW DATABASES';
EXCEPTION
  WHEN others THEN
    NULL;
END
$$;

-- Test 5: statement (line 37)
DO $$
BEGIN
  -- Not valid PostgreSQL syntax; catch and continue.
  EXECUTE 'use posgres';
EXCEPTION
  WHEN others THEN
    NULL;
END
$$;

-- Test 6: statement (line 41)
DO $$
BEGIN
  -- Role may not exist; catch and continue.
  EXECUTE 'ALTER DEFAULT PRIVILEGES GRANT SELECT ON TABLES TO who';
EXCEPTION
  WHEN others THEN
    NULL;
END
$$;

-- Test 7: query (line 44)
SELECT last_error_code, last_error
  FROM crdb_internal.node_statement_statistics
 WHERE last_error_code != 'NULL'
   AND application_name NOT LIKE '$ %'
 ORDER BY last_error_code ASC;

-- Test 8: statement (line 54)
DO $$
BEGIN
  -- Cockroach privilege (no PostgreSQL equivalent); catch and continue.
  EXECUTE 'GRANT SYSTEM VIEWACTIVITY TO testuser';
EXCEPTION
  WHEN others THEN
    NULL;
END
$$;

-- Test 9: statement (line 57)
DO $$
BEGIN
  -- Cockroach privilege (no PostgreSQL equivalent); catch and continue.
  EXECUTE 'REVOKE SYSTEM VIEWACTIVITYREDACTED FROM testuser';
EXCEPTION
  WHEN others THEN
    NULL;
END
$$;

-- user testuser (sqllogic directive; no PostgreSQL equivalent)

-- Test 10: query (line 63)
SELECT last_error_code, last_error
  FROM crdb_internal.node_statement_statistics
 WHERE last_error_code != 'NULL'
   AND application_name NOT LIKE '$ %'
 ORDER BY last_error_code ASC;

-- Test 11: statement (line 74)
DO $$
BEGIN
  -- Cockroach privilege (no PostgreSQL equivalent); catch and continue.
  EXECUTE 'GRANT SYSTEM VIEWACTIVITYREDACTED TO testuser';
EXCEPTION
  WHEN others THEN
    NULL;
END
$$;

-- user testuser (sqllogic directive; no PostgreSQL equivalent)

-- Test 12: query (line 79)
SELECT last_error_code, last_error
  FROM crdb_internal.node_statement_statistics
 WHERE last_error_code != 'NULL'
   AND application_name NOT LIKE '$ %'
 ORDER BY last_error_code ASC;

RESET client_min_messages;
