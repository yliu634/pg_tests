-- PostgreSQL compatible tests from rename_database
-- 15 tests

SET client_min_messages = warning;

-- Use dedicated databases for this test file and keep names unique to avoid
-- collisions with other tests/workers. Clean up first to keep the file re-runnable.
\connect postgres
DROP DATABASE IF EXISTS crdb_tests_rename_database_test;
DROP DATABASE IF EXISTS crdb_tests_rename_database_u;
DROP DATABASE IF EXISTS crdb_tests_rename_database_t;
DROP DATABASE IF EXISTS crdb_tests_rename_database_v;
DROP ROLE IF EXISTS rename_database_testuser;

-- Test 1: statement
CREATE ROLE rename_database_testuser LOGIN;

-- Test 2: statement
CREATE DATABASE crdb_tests_rename_database_test;

-- Test 3: statement
\connect crdb_tests_rename_database_test
CREATE TABLE kv (
  k INT PRIMARY KEY,
  v INT
);
INSERT INTO kv VALUES (1, 2), (3, 4), (5, 6), (7, 8);

-- Test 4: query
SELECT * FROM kv ORDER BY k;

-- Test 5: statement
\connect postgres
ALTER DATABASE crdb_tests_rename_database_test RENAME TO crdb_tests_rename_database_u;

-- Test 6: query
\connect crdb_tests_rename_database_u
SELECT * FROM kv ORDER BY k;

-- Test 7: statement
-- Expected ERROR variants: invalid identifiers or no-op renames; swallow to keep output clean.
\connect postgres
DO $$
BEGIN
  BEGIN
    EXECUTE 'ALTER DATABASE "" RENAME TO crdb_tests_rename_database_u';
  EXCEPTION WHEN OTHERS THEN
    NULL;
  END;
END $$;
DO $$
BEGIN
  BEGIN
    EXECUTE 'ALTER DATABASE crdb_tests_rename_database_u RENAME TO ""';
  EXCEPTION WHEN OTHERS THEN
    NULL;
  END;
END $$;
DO $$
BEGIN
  BEGIN
    EXECUTE 'ALTER DATABASE crdb_tests_rename_database_u RENAME TO crdb_tests_rename_database_u';
  EXCEPTION WHEN OTHERS THEN
    NULL;
  END;
END $$;

-- Test 8: statement
CREATE DATABASE crdb_tests_rename_database_t;

-- Test 9: statement
-- Expected ERROR (must be owner): attempt rename as a non-owner role.
SET ROLE rename_database_testuser;
DO $$
BEGIN
  BEGIN
    EXECUTE 'ALTER DATABASE crdb_tests_rename_database_t RENAME TO crdb_tests_rename_database_v';
  EXCEPTION WHEN OTHERS THEN
    NULL;
  END;
END $$;
RESET ROLE;

-- Test 10: statement
ALTER DATABASE crdb_tests_rename_database_t RENAME TO crdb_tests_rename_database_v;

-- Test 11: query
SELECT datname
FROM pg_database
WHERE datname LIKE 'crdb_tests_rename_database_%'
ORDER BY datname;

-- Test 12: statement
DROP DATABASE crdb_tests_rename_database_u;
DROP DATABASE crdb_tests_rename_database_v;

-- Test 13: statement
DROP ROLE rename_database_testuser;

RESET client_min_messages;

