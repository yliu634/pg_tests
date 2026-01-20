-- PostgreSQL compatible tests from alter_database_convert_to_schema
-- 2 tests

SET client_min_messages = warning;

-- Test 1: statement (line 1)
DROP DATABASE IF EXISTS parent;
DROP DATABASE IF EXISTS pgdatabase;

CREATE DATABASE parent;
\connect parent

CREATE DATABASE pgdatabase;
\connect pg_tests

-- Test 2: statement (line 7)
-- CockroachDB's `ALTER DATABASE ... CONVERT TO SCHEMA WITH PARENT ...` has no
-- direct equivalent in PostgreSQL. Approximate by dropping the database and
-- creating a schema with the same name in the target database.
DROP DATABASE parent;
\connect pgdatabase
CREATE SCHEMA parent;
\connect pg_tests
DROP DATABASE pgdatabase;

RESET client_min_messages;
