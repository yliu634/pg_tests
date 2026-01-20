-- PostgreSQL compatible tests from grant_on_all_tables_in_schema
-- CockroachDB logic tests used SHOW GRANTS and cross-database references; for
-- PostgreSQL we validate privileges via has_table_privilege() and keep the test
-- in-database by using schemas.

SET client_min_messages = warning;

DROP SCHEMA IF EXISTS s CASCADE;
DROP SCHEMA IF EXISTS s2 CASCADE;
DROP SCHEMA IF EXISTS otherdb_public CASCADE;
DROP TABLE IF EXISTS t131157;
DROP ROLE IF EXISTS testuser;
DROP ROLE IF EXISTS testuser2;

CREATE ROLE testuser;
CREATE ROLE testuser2;

CREATE SCHEMA s;
CREATE SCHEMA s2;

CREATE TABLE s.t (a INT);
CREATE TABLE s2.t (a INT);

-- Before grants.
SELECT
  's.t SELECT' AS check,
  has_table_privilege('testuser', 's.t', 'SELECT') AS has_priv
UNION ALL
SELECT
  's2.t SELECT',
  has_table_privilege('testuser', 's2.t', 'SELECT')
ORDER BY 1;

GRANT SELECT ON ALL TABLES IN SCHEMA s TO testuser;
SELECT
  's.t SELECT' AS check,
  has_table_privilege('testuser', 's.t', 'SELECT') AS has_priv
UNION ALL
SELECT
  's2.t SELECT',
  has_table_privilege('testuser', 's2.t', 'SELECT')
ORDER BY 1;

GRANT SELECT ON ALL TABLES IN SCHEMA s, s2 TO testuser, testuser2;
SELECT
  r.rolname AS grantee,
  n.nspname AS schema_name,
  c.relname AS table_name,
  has_table_privilege(r.rolname, format('%I.%I', n.nspname, c.relname), 'SELECT') AS has_select
FROM pg_class c
JOIN pg_namespace n ON n.oid = c.relnamespace
JOIN pg_roles r ON r.rolname IN ('testuser', 'testuser2')
WHERE c.relkind = 'r' AND n.nspname IN ('s', 's2')
ORDER BY 1, 2, 3;

GRANT ALL ON ALL TABLES IN SCHEMA s, s2 TO testuser, testuser2;
SELECT
  r.rolname AS grantee,
  n.nspname AS schema_name,
  c.relname AS table_name,
  has_table_privilege(r.rolname, format('%I.%I', n.nspname, c.relname), 'SELECT') AS has_select,
  has_table_privilege(r.rolname, format('%I.%I', n.nspname, c.relname), 'INSERT') AS has_insert,
  has_table_privilege(r.rolname, format('%I.%I', n.nspname, c.relname), 'UPDATE') AS has_update,
  has_table_privilege(r.rolname, format('%I.%I', n.nspname, c.relname), 'DELETE') AS has_delete
FROM pg_class c
JOIN pg_namespace n ON n.oid = c.relnamespace
JOIN pg_roles r ON r.rolname IN ('testuser', 'testuser2')
WHERE c.relkind = 'r' AND n.nspname IN ('s', 's2')
ORDER BY 1, 2, 3;

REVOKE SELECT ON ALL TABLES IN SCHEMA s, s2 FROM testuser, testuser2;
SELECT
  r.rolname AS grantee,
  n.nspname AS schema_name,
  c.relname AS table_name,
  has_table_privilege(r.rolname, format('%I.%I', n.nspname, c.relname), 'SELECT') AS has_select
FROM pg_class c
JOIN pg_namespace n ON n.oid = c.relnamespace
JOIN pg_roles r ON r.rolname IN ('testuser', 'testuser2')
WHERE c.relkind = 'r' AND n.nspname IN ('s', 's2')
ORDER BY 1, 2, 3;

REVOKE ALL ON ALL TABLES IN SCHEMA s, s2 FROM testuser, testuser2;
SELECT
  r.rolname AS grantee,
  n.nspname AS schema_name,
  c.relname AS table_name,
  has_table_privilege(r.rolname, format('%I.%I', n.nspname, c.relname), 'SELECT') AS has_select,
  has_table_privilege(r.rolname, format('%I.%I', n.nspname, c.relname), 'INSERT') AS has_insert,
  has_table_privilege(r.rolname, format('%I.%I', n.nspname, c.relname), 'UPDATE') AS has_update,
  has_table_privilege(r.rolname, format('%I.%I', n.nspname, c.relname), 'DELETE') AS has_delete
FROM pg_class c
JOIN pg_namespace n ON n.oid = c.relnamespace
JOIN pg_roles r ON r.rolname IN ('testuser', 'testuser2')
WHERE c.relkind = 'r' AND n.nspname IN ('s', 's2')
ORDER BY 1, 2, 3;

-- Cross-database qualifiers aren't supported in PG; use a schema-scoped grant.
CREATE SCHEMA otherdb_public;
CREATE TABLE otherdb_public.tbl (a INT);
GRANT SELECT ON ALL TABLES IN SCHEMA otherdb_public TO testuser;
SELECT has_table_privilege('testuser', 'otherdb_public.tbl', 'SELECT') AS other_schema_select;

-- Regression-style sanity check: grant then revoke a valid privilege.
CREATE TABLE t131157 (c1 INT);
GRANT ALL ON TABLE t131157 TO testuser;
REVOKE INSERT ON TABLE t131157 FROM testuser;
SELECT has_table_privilege('testuser', 't131157', 'INSERT') AS t131157_has_insert;

-- Cleanup.
DROP TABLE t131157;
DROP SCHEMA s CASCADE;
DROP SCHEMA s2 CASCADE;
DROP SCHEMA otherdb_public CASCADE;
DROP OWNED BY testuser, testuser2;
DROP ROLE testuser;
DROP ROLE testuser2;

RESET client_min_messages;
