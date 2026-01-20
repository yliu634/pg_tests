-- PostgreSQL compatible tests from alter_type_owner
-- NOTE: This is a PostgreSQL-focused port. Nonexistent users and Cockroach user
-- directives are avoided to keep the script error-free.

SET client_min_messages = warning;

-- Cleanup from prior runs.
RESET ROLE;
DROP TYPE IF EXISTS s.typ;
DROP SCHEMA IF EXISTS s CASCADE;
DROP ROLE IF EXISTS testuser2;
DROP ROLE IF EXISTS testuser;

CREATE ROLE testuser;
CREATE ROLE testuser2;

-- Test 1: statement
CREATE SCHEMA s;
CREATE TYPE s.typ AS ENUM ('a');

-- Test 2: statement
ALTER TYPE s.typ OWNER TO testuser;

-- Test 3: query
SELECT 's.typ' AS name, (SELECT typowner::regrole::text FROM pg_type WHERE oid = 's.typ'::regtype) AS owner;

-- Test 4: statement
ALTER TYPE s.typ OWNER TO testuser2;

-- Test 5: query
SELECT 's.typ' AS name, (SELECT typowner::regrole::text FROM pg_type WHERE oid = 's.typ'::regtype) AS owner;

-- Cleanup.
RESET ROLE;
DROP TYPE IF EXISTS s.typ;
DROP SCHEMA IF EXISTS s CASCADE;
DROP OWNED BY testuser2;
DROP OWNED BY testuser;
DROP ROLE IF EXISTS testuser2;
DROP ROLE IF EXISTS testuser;

RESET client_min_messages;
