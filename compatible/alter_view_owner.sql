-- PostgreSQL compatible tests from alter_view_owner
-- NOTE: This is a PostgreSQL-focused port. Error-only cases from Cockroach are
-- omitted to keep the script error-free.

SET client_min_messages = warning;

-- Cleanup from prior runs.
RESET ROLE;
DROP MATERIALIZED VIEW IF EXISTS mvx;
DROP VIEW IF EXISTS s.vx;
DROP VIEW IF EXISTS vx;
DROP SCHEMA IF EXISTS s CASCADE;
DROP ROLE IF EXISTS testuser2;
DROP ROLE IF EXISTS testuser;

CREATE ROLE testuser;
CREATE ROLE testuser2;

-- Test 1: statement
CREATE SCHEMA s;
CREATE VIEW vx AS SELECT 1 AS v;
CREATE VIEW s.vx AS SELECT 1 AS v;
CREATE MATERIALIZED VIEW mvx AS SELECT 1 AS v;

-- Test 2: statement
ALTER VIEW vx OWNER TO testuser;
ALTER VIEW s.vx OWNER TO testuser;
ALTER MATERIALIZED VIEW mvx OWNER TO testuser;

-- Test 3: query
SELECT 'vx' AS name, (SELECT relowner::regrole::text FROM pg_class WHERE oid = 'vx'::regclass) AS owner;
SELECT 's.vx' AS name, (SELECT relowner::regrole::text FROM pg_class WHERE oid = 's.vx'::regclass) AS owner;
SELECT 'mvx' AS name, (SELECT relowner::regrole::text FROM pg_class WHERE oid = 'mvx'::regclass) AS owner;

-- Test 4: statement
ALTER VIEW vx OWNER TO testuser2;
ALTER MATERIALIZED VIEW mvx OWNER TO testuser2;

-- Test 5: query
SELECT 'vx' AS name, (SELECT relowner::regrole::text FROM pg_class WHERE oid = 'vx'::regclass) AS owner;
SELECT 'mvx' AS name, (SELECT relowner::regrole::text FROM pg_class WHERE oid = 'mvx'::regclass) AS owner;

-- Cleanup.
RESET ROLE;
DROP MATERIALIZED VIEW IF EXISTS mvx;
DROP VIEW IF EXISTS s.vx;
DROP VIEW IF EXISTS vx;
DROP SCHEMA IF EXISTS s CASCADE;
DROP OWNED BY testuser2;
DROP OWNED BY testuser;
DROP ROLE IF EXISTS testuser2;
DROP ROLE IF EXISTS testuser;

RESET client_min_messages;
