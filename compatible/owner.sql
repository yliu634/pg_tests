SET client_min_messages = warning;

-- PostgreSQL compatible tests from owner
-- 29 tests
--
-- CockroachDB has database-level concepts and jobs that do not exist in
-- PostgreSQL. This PG-adapted version focuses on ownership changes for common
-- objects (tables, schemas, views).

-- Use unique role names to avoid collisions with other test files.
-- Test 1: statement (role setup)
DROP ROLE IF EXISTS owner_tests_role1;
DROP ROLE IF EXISTS owner_tests_role2;
DROP ROLE IF EXISTS owner_tests_role3;
CREATE ROLE owner_tests_role1;
CREATE ROLE owner_tests_role2;
CREATE ROLE owner_tests_role3;

-- Test 2: statement (table owner)
DROP TABLE IF EXISTS t_owner CASCADE;
CREATE TABLE t_owner(a INT);
ALTER TABLE t_owner OWNER TO owner_tests_role1;

-- Test 3: query
SELECT tableowner
FROM pg_catalog.pg_tables
WHERE schemaname = 'public' AND tablename = 't_owner';

-- Test 4: statement (schema owner)
DROP SCHEMA IF EXISTS s_owner CASCADE;
CREATE SCHEMA s_owner;
ALTER SCHEMA s_owner OWNER TO owner_tests_role2;

-- Test 5: query
SELECT nspname, nspowner::regrole::text AS owner
FROM pg_catalog.pg_namespace
WHERE nspname = 's_owner';

-- Test 6: statement (view owner)
DROP VIEW IF EXISTS v_owner CASCADE;
CREATE VIEW v_owner AS SELECT 1 AS one;
ALTER VIEW v_owner OWNER TO owner_tests_role3;

-- Test 7: query
SELECT viewowner
FROM pg_catalog.pg_views
WHERE schemaname = 'public' AND viewname = 'v_owner';

RESET client_min_messages;
