-- PostgreSQL compatible tests from drop_owned_by
--
-- Adapted for psql execution:
-- - Replace Cockroach logic-test directives (e.g. `user ...`) with `SET ROLE`.
-- - Replace Cockroach `SHOW ...` statements with catalog queries.
-- - Avoid multi-database Cockroach semantics; keep the core `DROP OWNED BY` behavior.

SET client_min_messages = warning;

-- Roles are global (cluster-wide). Clean up any leftovers from prior runs.
DROP SCHEMA IF EXISTS dob_s CASCADE;
DROP ROLE IF EXISTS dob_udf_owner;
DROP ROLE IF EXISTS dob_r2;
DROP ROLE IF EXISTS dob_r1;
DROP ROLE IF EXISTS dob_testuser2;
DROP ROLE IF EXISTS dob_testuser;
DROP ROLE IF EXISTS root;

CREATE ROLE root SUPERUSER;
CREATE ROLE dob_testuser LOGIN;
CREATE ROLE dob_testuser2 LOGIN;
CREATE ROLE dob_r1;
CREATE ROLE dob_r2;

-- Ensure these roles can create objects in the test database.
DO $$
BEGIN
  EXECUTE format('GRANT CREATE ON DATABASE %I TO dob_testuser, dob_testuser2, dob_r1, dob_r2', current_database());
END $$;
GRANT CREATE ON SCHEMA public TO dob_testuser, dob_r1, dob_r2;

-- Deterministic introspection helpers.
CREATE OR REPLACE VIEW dob_tables AS
SELECT table_schema, table_name, table_type
FROM information_schema.tables
WHERE table_schema IN ('public', 'dob_s')
ORDER BY 1, 2, 3;

CREATE OR REPLACE VIEW dob_enums AS
SELECT n.nspname AS schema_name, t.typname AS type_name, e.enumlabel AS enum_label
FROM pg_type t
JOIN pg_namespace n ON n.oid = t.typnamespace
JOIN pg_enum e ON e.enumtypid = t.oid
WHERE n.nspname IN ('public', 'dob_s')
ORDER BY 1, 2, 3;

CREATE OR REPLACE VIEW dob_table_grants AS
SELECT table_schema, table_name, grantee, privilege_type, is_grantable
FROM information_schema.role_table_grants
WHERE table_schema IN ('public', 'dob_s')
ORDER BY 1, 2, 3, 4;

-- Scenario 1: DROP OWNED BY revokes privileges for grantees and drops owned objects.
SET ROLE dob_testuser;

CREATE TABLE dob_t(a int);
CREATE VIEW dob_v AS SELECT a FROM dob_t;
CREATE SEQUENCE dob_seq;
CREATE TYPE dob_enum AS ENUM ('a', 'b');
CREATE SCHEMA dob_s;
CREATE TABLE dob_s.dob_s_t(a int);

RESET ROLE;

-- Grant a privilege to dob_testuser2 that should be revoked by DROP OWNED.
GRANT SELECT ON dob_t TO dob_testuser2;

-- Introspection before DROP OWNED.
SELECT * FROM dob_tables;
SELECT * FROM dob_enums;
SELECT table_schema, table_name, grantee, privilege_type
FROM dob_table_grants
WHERE table_name = 'dob_t'
ORDER BY 1, 2, 3, 4;

-- Drop owned by the grantee: should revoke its privileges but not drop the objects.
DROP OWNED BY dob_testuser2;

SELECT table_schema, table_name, grantee, privilege_type
FROM dob_table_grants
WHERE table_name = 'dob_t'
ORDER BY 1, 2, 3, 4;

-- Drop owned by the owner: should drop the objects.
DROP OWNED BY dob_testuser;

SELECT * FROM dob_tables;
SELECT * FROM dob_enums;
SELECT to_regclass('public.dob_t') IS NULL AS dob_t_dropped,
       to_regclass('public.dob_v') IS NULL AS dob_v_dropped;

-- Scenario 2: DROP OWNED supports multiple roles.
SET ROLE dob_r1;
CREATE TABLE r1_t(a int);

SET ROLE dob_r2;
CREATE TABLE r2_t(a int);

RESET ROLE;

SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public' AND table_name IN ('r1_t', 'r2_t')
ORDER BY 1;

DROP OWNED BY dob_r1, dob_r2;

SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public' AND table_name IN ('r1_t', 'r2_t')
ORDER BY 1;

-- Scenario 3: DROP OWNED removes functions owned by the role.
CREATE ROLE dob_udf_owner LOGIN;
CREATE FUNCTION dob_udf() RETURNS int LANGUAGE sql AS $$ SELECT 1 $$;
ALTER FUNCTION dob_udf() OWNER TO dob_udf_owner;

DROP OWNED BY dob_udf_owner;

SELECT to_regprocedure('dob_udf()') IS NULL AS dob_udf_dropped;

DROP ROLE dob_udf_owner;

-- Final cleanup.
DROP ROLE dob_r2;
DROP ROLE dob_r1;
DROP ROLE dob_testuser2;
DROP ROLE dob_testuser;
DROP ROLE root;

RESET client_min_messages;
