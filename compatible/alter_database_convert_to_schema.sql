-- PostgreSQL compatible tests from alter_database_convert_to_schema
-- 2 tests

-- Test 1: statement (line 1)
SET client_min_messages = warning;

DROP DATABASE IF EXISTS parent;
DROP DATABASE IF EXISTS pgdatabase;

CREATE DATABASE parent;
CREATE DATABASE pgdatabase;

-- Test 2: statement (line 7)
-- PostgreSQL does not support "ALTER DATABASE ... CONVERT TO SCHEMA".
-- Simulate the intent by creating a schema named after the database in the
-- target database, then dropping the original database.
\connect pgdatabase
SET client_min_messages = warning;
DROP SCHEMA IF EXISTS parent CASCADE;
CREATE SCHEMA parent;

\connect postgres
SET client_min_messages = warning;
DROP DATABASE parent;

\connect pgdatabase
SET client_min_messages = warning;
SELECT schema_name FROM information_schema.schemata WHERE schema_name = 'parent';

\connect postgres
SET client_min_messages = warning;
DROP DATABASE pgdatabase;

RESET client_min_messages;
