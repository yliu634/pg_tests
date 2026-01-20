-- PostgreSQL compatible tests from crdb_internal
-- 217 tests
-- Most tests are commented out because they rely on CockroachDB-specific crdb_internal schema

-- Test 1: query (line 5)
-- ALTER DATABASE crdb_internal RENAME TO not_crdb_internal;

-- statement error schema cannot be modified: "crdb_internal"
-- CREATE TABLE crdb_internal.t (x INT);

-- query error database "crdb_internal" does not exist
-- DROP DATABASE crdb_internal;

-- Choose a few handful of tables / views from internal to check for; do not
-- enumerate the entire set of iternals or the test will become overly broad and
-- brittle.
-- query TTTTIT rowsort
-- WITH tables AS (SHOW TABLES FROM crdb_internal) SELECT * FROM tables
--   WHERE table_name IN ('node_build_info', 'ranges', 'ranges_no_leases');

-- Test 2: statement (line 25)
SET client_min_messages = warning;
DROP TABLE IF EXISTS foo CASCADE;
DROP SCHEMA IF EXISTS schema CASCADE;
DROP TABLE IF EXISTS empty CASCADE;
DROP DATABASE IF EXISTS testdb;
DROP DATABASE IF EXISTS other_db;
DROP TABLE IF EXISTS table41834;
DROP TABLE IF EXISTS t_53504;
DROP TABLE IF EXISTS normal_table;
DROP TABLE IF EXISTS t69684;
DROP TABLE IF EXISTS t76710_1;
DROP MATERIALIZED VIEW IF EXISTS t76710_2;
DROP FUNCTION IF EXISTS f(INT);
DROP FUNCTION IF EXISTS f(BOOL);
DROP PROCEDURE IF EXISTS f(BOOL);
DROP PROCEDURE IF EXISTS p(INT);
DROP FUNCTION IF EXISTS p(BOOL);
DROP DATABASE IF EXISTS test_cross_db;
DROP TABLE IF EXISTS in_this_db;
DROP SEQUENCE IF EXISTS s;
DROP USER IF EXISTS testuser;
RESET client_min_messages;

CREATE DATABASE testdb;
\c testdb
CREATE TABLE foo(x INT);
\c pg_tests
CREATE USER testuser;

-- let $testdb_id
-- SELECT id FROM system.namespace WHERE name = 'testdb';

-- let $testdb_foo_id
-- SELECT 'testdb.foo'::regclass::int;

-- Test 3: query (line 34)
-- SELECT t.name, t.version, t.state FROM crdb_internal.tables AS t JOIN system.namespace AS n ON (n.id = t.parent_id and n.name = 'testdb');

-- Test 4: query (line 40)
\c testdb
SELECT * FROM foo;
\c pg_tests

-- Test 5: query (line 45)
-- SELECT l.name FROM crdb_internal.leases AS l JOIN system.namespace AS n ON (n.id = l.table_id and n.name = 'foo');

-- Test 6: query (line 51)
-- SELECT * FROM crdb_internal.schema_changes;

-- Test 7: query (line 57)
-- SELECT
--   table_id,
--   parent_id,
--   name,
--   database_name,
--   version,
--   format_version,
--   state,
--   sc_lease_node_id,
--   sc_lease_expiration_time,
--   drop_time,
--   audit_mode,
--   schema_name,
--   parent_schema_id
-- FROM crdb_internal.tables WHERE NAME = 'descriptor';

-- Test 8: query (line 77)
-- SELECT * FROM crdb_internal.pg_catalog_table_is_implemented;

-- Test 9: statement (line 213)
\c testdb
CREATE TABLE " ""\'" (i int);

-- Test 10: query (line 216)
SELECT tablename as name from pg_tables WHERE schemaname = 'public' AND tablename LIKE '%"%';
\c pg_tests

-- Most remaining tests rely on crdb_internal views and are commented out

-- Test 11-217: Various crdb_internal queries (all commented out)
-- These tests query CockroachDB-specific internal tables that don't exist in PostgreSQL:
-- - crdb_internal.node_build_info
-- - crdb_internal.schema_changes
-- - crdb_internal.leases
-- - crdb_internal.node_statement_statistics
-- - crdb_internal.node_transaction_statistics
-- - crdb_internal.session_trace
-- - crdb_internal.cluster_settings
-- - crdb_internal.feature_usage
-- - crdb_internal.session_variables
-- - crdb_internal.node_queries
-- - crdb_internal.cluster_queries
-- - crdb_internal.node_transactions
-- - crdb_internal.cluster_transactions
-- - crdb_internal.node_sessions
-- - crdb_internal.cluster_sessions
-- - crdb_internal.node_contention_events
-- - crdb_internal.cluster_contention_events
-- - crdb_internal.builtin_functions
-- - crdb_internal.create_statements
-- - crdb_internal.table_columns
-- - crdb_internal.table_indexes
-- - crdb_internal.index_columns
-- - crdb_internal.backward_dependencies
-- - crdb_internal.forward_dependencies
-- - crdb_internal.zones
-- - crdb_internal.ranges
-- - crdb_internal.ranges_no_leases
-- - crdb_internal.cluster_execution_insights
-- - crdb_internal.node_execution_insights
-- - etc.

CREATE SCHEMA schema;
CREATE TABLE schema.bar (y INT PRIMARY KEY);
CREATE TABLE empty ();
CREATE SEQUENCE s;
CREATE TABLE table41834 ();
CREATE TABLE t_53504();
CREATE DATABASE other_db;
\c other_db
CREATE TABLE in_other_db (x INT PRIMARY KEY);
\c pg_tests
CREATE TABLE in_this_db (x INT PRIMARY KEY);
CREATE TABLE t69684(a NAME);
INSERT INTO t69684 VALUES ('foo');
CREATE TABLE normal_table();
CREATE TEMPORARY TABLE temp();
CREATE TABLE t76710_1 (id INT);
CREATE MATERIALIZED VIEW t76710_2 AS SELECT 1 as fingerprint_id;
CREATE FUNCTION f(INT) RETURNS INT LANGUAGE SQL AS $$ SELECT 1 $$;
CREATE FUNCTION f(BOOL) RETURNS INT LANGUAGE SQL AS $$ SELECT 1 $$;
CREATE PROCEDURE p(INT) LANGUAGE SQL AS $$ SELECT 1 $$;
CREATE DATABASE test_cross_db;

-- Cleanup
DROP SEQUENCE s;
