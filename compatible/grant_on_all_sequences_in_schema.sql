-- PostgreSQL compatible tests from grant_on_all_sequences_in_schema
-- CockroachDB logic tests used SHOW GRANTS; PostgreSQL uses catalog helpers.

SET client_min_messages = warning;

DROP SCHEMA IF EXISTS s CASCADE;
DROP SCHEMA IF EXISTS s2 CASCADE;
DROP SCHEMA IF EXISTS s3 CASCADE;
DROP SCHEMA IF EXISTS s4 CASCADE;
DROP ROLE IF EXISTS testuser;
DROP ROLE IF EXISTS testuser2;
DROP ROLE IF EXISTS testuser3;

CREATE ROLE testuser;
CREATE ROLE testuser2;
CREATE ROLE testuser3;

CREATE SCHEMA s;
CREATE SCHEMA s2;

CREATE SEQUENCE s.q;
CREATE SEQUENCE s2.q;
CREATE TABLE s2.t (id INT);

-- Before grants.
SELECT 's.q SELECT' AS check, has_sequence_privilege('testuser', 's.q', 'SELECT') AS has_priv
UNION ALL
SELECT 's2.q SELECT', has_sequence_privilege('testuser', 's2.q', 'SELECT')
ORDER BY 1;

GRANT SELECT ON ALL SEQUENCES IN SCHEMA s TO testuser;
SELECT 's.q SELECT' AS check, has_sequence_privilege('testuser', 's.q', 'SELECT') AS has_priv
UNION ALL
SELECT 's2.q SELECT', has_sequence_privilege('testuser', 's2.q', 'SELECT')
ORDER BY 1;

GRANT USAGE ON ALL SEQUENCES IN SCHEMA s TO testuser;
SELECT 's.q USAGE' AS check, has_sequence_privilege('testuser', 's.q', 'USAGE') AS has_priv
UNION ALL
SELECT 's2.q USAGE', has_sequence_privilege('testuser', 's2.q', 'USAGE')
ORDER BY 1;

GRANT SELECT ON ALL SEQUENCES IN SCHEMA s, s2 TO testuser, testuser2;
SELECT
  r.rolname AS grantee,
  n.nspname AS schema_name,
  c.relname AS seq_name,
  has_sequence_privilege(r.rolname, format('%I.%I', n.nspname, c.relname), 'SELECT') AS has_select
FROM pg_class c
JOIN pg_namespace n ON n.oid = c.relnamespace
JOIN pg_roles r ON r.rolname IN ('testuser', 'testuser2')
WHERE c.relkind = 'S' AND n.nspname IN ('s', 's2')
ORDER BY 1, 2, 3;

GRANT ALL ON ALL SEQUENCES IN SCHEMA s, s2 TO testuser, testuser2;
SELECT
  r.rolname AS grantee,
  n.nspname AS schema_name,
  c.relname AS seq_name,
  has_sequence_privilege(r.rolname, format('%I.%I', n.nspname, c.relname), 'USAGE') AS has_usage,
  has_sequence_privilege(r.rolname, format('%I.%I', n.nspname, c.relname), 'SELECT') AS has_select,
  has_sequence_privilege(r.rolname, format('%I.%I', n.nspname, c.relname), 'UPDATE') AS has_update
FROM pg_class c
JOIN pg_namespace n ON n.oid = c.relnamespace
JOIN pg_roles r ON r.rolname IN ('testuser', 'testuser2')
WHERE c.relkind = 'S' AND n.nspname IN ('s', 's2')
ORDER BY 1, 2, 3;

GRANT ALL ON ALL TABLES IN SCHEMA s2 TO testuser3;
SELECT
  p AS privilege,
  has_table_privilege('testuser3', 's2.t', p) AS has_priv
FROM (VALUES ('SELECT'), ('INSERT'), ('UPDATE'), ('DELETE')) AS v(p)
ORDER BY 1;

-- Default privileges in PG are per role + optional schema (no "FOR ALL ROLES").
CREATE SCHEMA s3;
CREATE SCHEMA s4;
ALTER DEFAULT PRIVILEGES IN SCHEMA s3 GRANT USAGE ON SEQUENCES TO testuser3;
ALTER DEFAULT PRIVILEGES IN SCHEMA s4 GRANT USAGE ON SEQUENCES TO testuser3;
CREATE SEQUENCE s3.q;
CREATE SEQUENCE s4.q;
SELECT
  's3.q USAGE' AS check,
  has_sequence_privilege('testuser3', 's3.q', 'USAGE') AS has_priv
UNION ALL
SELECT
  's4.q USAGE',
  has_sequence_privilege('testuser3', 's4.q', 'USAGE')
ORDER BY 1;

-- Cleanup.
DROP SCHEMA s CASCADE;
DROP SCHEMA s2 CASCADE;
DROP SCHEMA s3 CASCADE;
DROP SCHEMA s4 CASCADE;
DROP OWNED BY testuser, testuser2, testuser3;
DROP ROLE testuser;
DROP ROLE testuser2;
DROP ROLE testuser3;

RESET client_min_messages;
