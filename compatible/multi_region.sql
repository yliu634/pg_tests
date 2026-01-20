-- PostgreSQL compatible tests from multi_region
-- 2 tests

-- Test 1: statement (line 3)
-- COMMENTED: CockroachDB multi-region database options are not available in PostgreSQL.
DROP DATABASE IF EXISTS region_test_db;
CREATE DATABASE region_test_db;

-- Test 2: statement (line 6)
-- COMMENTED: CockroachDB PRIMARY REGION is not available in PostgreSQL.
ALTER DATABASE region_test_db SET timezone TO 'UTC';
