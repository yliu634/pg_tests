-- PostgreSQL compatible tests from alter_table_owner
-- NOTE: This is a PostgreSQL-focused port. CockroachDB's user directives are
-- treated as comments; ownership changes are executed as superuser for a clean run.

SET client_min_messages = warning;

-- Cleanup from prior runs.
RESET ROLE;
DROP TABLE IF EXISTS s.t;
DROP TABLE IF EXISTS t;
DROP SCHEMA IF EXISTS s CASCADE;
DROP ROLE IF EXISTS testuser2;
DROP ROLE IF EXISTS testuser;

CREATE ROLE testuser;
CREATE ROLE testuser2;

-- Test 1: statement
CREATE SCHEMA s;
CREATE TABLE t ();
CREATE TABLE s.t ();

-- Test 2: statement
ALTER TABLE t OWNER TO testuser;
ALTER TABLE s.t OWNER TO testuser;

-- Test 3: query
SELECT 't' AS name, (SELECT relowner::regrole::text FROM pg_class WHERE oid = 't'::regclass) AS owner;
SELECT 's.t' AS name, (SELECT relowner::regrole::text FROM pg_class WHERE oid = 's.t'::regclass) AS owner;

-- Test 4: statement
ALTER TABLE t OWNER TO testuser2;

-- Test 5: query
SELECT 't' AS name, (SELECT relowner::regrole::text FROM pg_class WHERE oid = 't'::regclass) AS owner;

-- Test 6: statement
ALTER TABLE IF EXISTS does_not_exist OWNER TO testuser;

-- Cleanup.
RESET ROLE;
DROP TABLE IF EXISTS s.t;
DROP TABLE IF EXISTS t;
DROP SCHEMA IF EXISTS s CASCADE;
DROP OWNED BY testuser2;
DROP OWNED BY testuser;
DROP ROLE IF EXISTS testuser2;
DROP ROLE IF EXISTS testuser;

RESET client_min_messages;
