-- PostgreSQL compatible tests from alter_database_convert_to_schema
-- 2 tests

-- Test 1: statement (line 1)
SET client_min_messages = warning;

DROP DATABASE IF EXISTS parent WITH (FORCE);
DROP DATABASE IF EXISTS pgdatabase WITH (FORCE);
CREATE DATABASE parent;
CREATE DATABASE pgdatabase;

-- Test 2: statement (line 7)
-- CockroachDB supports converting a database into a schema under a parent
-- database. PostgreSQL has no direct equivalent, so we simulate the end state:
-- a schema named "parent" exists inside database "pgdatabase".
\connect pgdatabase
DROP SCHEMA IF EXISTS parent CASCADE;
CREATE SCHEMA parent;
\connect pg_tests

DROP DATABASE IF EXISTS parent WITH (FORCE);
DROP DATABASE IF EXISTS pgdatabase WITH (FORCE);

RESET client_min_messages;
