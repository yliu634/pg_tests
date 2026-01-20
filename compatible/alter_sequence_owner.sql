-- PostgreSQL compatible tests from alter_sequence_owner
-- NOTE: This is a PostgreSQL-focused port. Cockroach-only IF EXISTS on ALTER SEQUENCE
-- is replaced with a psql-conditional execution.

SET client_min_messages = warning;

-- Cleanup from prior runs.
RESET ROLE;
DROP SEQUENCE IF EXISTS s.seq;
DROP SEQUENCE IF EXISTS seq;
DROP SCHEMA IF EXISTS s CASCADE;
DROP ROLE IF EXISTS testuser2;
DROP ROLE IF EXISTS testuser;

CREATE ROLE testuser;
CREATE ROLE testuser2;

-- Test 1: statement
CREATE SCHEMA s;
CREATE SEQUENCE seq;
CREATE SEQUENCE s.seq;

-- Test 2: statement
ALTER SEQUENCE seq OWNER TO testuser;
ALTER SEQUENCE s.seq OWNER TO testuser;

-- Test 3: query
SELECT 'seq' AS name, (SELECT relowner::regrole::text FROM pg_class WHERE oid = 'seq'::regclass) AS owner;
SELECT 's.seq' AS name, (SELECT relowner::regrole::text FROM pg_class WHERE oid = 's.seq'::regclass) AS owner;

-- Test 4: statement
ALTER SEQUENCE seq OWNER TO testuser2;

-- Test 5: query
SELECT 'seq' AS name, (SELECT relowner::regrole::text FROM pg_class WHERE oid = 'seq'::regclass) AS owner;

-- Test 6: statement
-- PostgreSQL ALTER SEQUENCE doesn't support IF EXISTS; emulate it.
SELECT format('ALTER SEQUENCE %I OWNER TO %I;', c.relname, 'testuser')
FROM pg_class c
JOIN pg_namespace n ON n.oid = c.relnamespace
WHERE n.nspname = 'public' AND c.relname = 'does_not_exist' AND c.relkind = 'S' \gexec

-- Cleanup.
RESET ROLE;
DROP SEQUENCE IF EXISTS s.seq;
DROP SEQUENCE IF EXISTS seq;
DROP SCHEMA IF EXISTS s CASCADE;
DROP OWNED BY testuser2;
DROP OWNED BY testuser;
DROP ROLE IF EXISTS testuser2;
DROP ROLE IF EXISTS testuser;

RESET client_min_messages;
