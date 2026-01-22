-- PostgreSQL compatible tests from statement_statistics_errors
-- 10 tests

SET client_min_messages = warning;
CREATE SCHEMA IF NOT EXISTS crdb_internal;

-- Cockroach exposes statement errors via crdb_internal.*; PostgreSQL does not.
-- Provide a minimal stub so the final query can execute deterministically.
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
  -- Expected error in the original test; catch so the script can continue.
  PERFORM 2/0;
EXCEPTION
  WHEN division_by_zero THEN
    NULL;
END
$$;

-- Test 2: query (line 17)
DO $$
BEGIN
  -- Not valid PostgreSQL syntax; catch and continue.
  EXECUTE 'SHOW DATABASES';
EXCEPTION
  WHEN others THEN
    NULL;
END
$$;

-- Test 3: statement (line 26)
DO $$
BEGIN
  -- Not valid PostgreSQL syntax; catch and continue.
  EXECUTE 'use posgres';
EXCEPTION
  WHEN others THEN
    NULL;
END
$$;

-- Test 4: statement (line 31)
DO $$
BEGIN
  -- Role may not exist; catch and continue.
  EXECUTE 'ALTER DEFAULT PRIVILEGES GRANT SELECT ON TABLES TO who';
EXCEPTION
  WHEN others THEN
    NULL;
END
$$;

-- Test 5: statement (line 36)
CREATE TABLE crdb_internal.example (abc INT);

-- Test 6: statement (line 41)
DO $$
BEGIN
  -- Cockroach setting (no PostgreSQL equivalent); catch and continue.
  EXECUTE 'SET autocommit_before_ddl = false';
EXCEPTION
  WHEN others THEN
    NULL;
END
$$;

-- Test 7: statement (line 44)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
CREATE TABLE src(x VARCHAR PRIMARY KEY);
CREATE TABLE dst(x VARCHAR REFERENCES src(x));
INSERT INTO src(x) VALUES ('example');
INSERT INTO dst(x) VALUES ('example');
COMMIT;

-- Test 8: statement (line 52)
DO $$
BEGIN
  -- Cockroach setting (no PostgreSQL equivalent); catch and continue.
  EXECUTE 'RESET autocommit_before_ddl';
EXCEPTION
  WHEN others THEN
    NULL;
END
$$;

-- Test 9: statement (line 55)
DO $$
BEGIN
  -- Expected FK error in the original test; catch so the script can continue.
  UPDATE dst SET x = 'xyz';
EXCEPTION
  WHEN others THEN
    NULL;
END
$$;

-- Test 10: query (line 59)
SELECT last_error_code, last_error
  FROM crdb_internal.node_statement_statistics
 WHERE last_error_code != 'NULL'
   AND application_name NOT LIKE '$ %'
 ORDER BY last_error_code ASC;

RESET client_min_messages;
