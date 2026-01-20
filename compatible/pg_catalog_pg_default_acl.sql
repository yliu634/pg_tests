SET client_min_messages = warning;

-- PostgreSQL compatible tests from pg_catalog_pg_default_acl
-- 50 tests
--
-- CockroachDB and PostgreSQL differ around default privileges syntax and roles.
-- This PG-adapted version exercises ALTER DEFAULT PRIVILEGES and validates the
-- resulting entries in pg_default_acl.

-- Test 1: statement (role setup)
DROP ROLE IF EXISTS default_acl_owner;
DROP ROLE IF EXISTS default_acl_grantee;
CREATE ROLE default_acl_owner;
CREATE ROLE default_acl_grantee;

-- Test 2: statement (schema setup)
DROP SCHEMA IF EXISTS acl_schema CASCADE;
CREATE SCHEMA acl_schema AUTHORIZATION default_acl_owner;

-- Test 3: statement (default privileges)
ALTER DEFAULT PRIVILEGES FOR ROLE default_acl_owner IN SCHEMA acl_schema
GRANT SELECT ON TABLES TO default_acl_grantee;

-- Test 4: query (pg_default_acl)
SELECT defaclrole::regrole::text AS role,
       defaclnamespace::regnamespace::text AS schema,
       defaclobjtype,
       defaclacl
FROM pg_catalog.pg_default_acl
WHERE defaclrole = 'default_acl_owner'::regrole
ORDER BY defaclobjtype;

-- Test 5: statement (create table under role)
SET ROLE default_acl_owner;
DROP TABLE IF EXISTS acl_schema.t CASCADE;
CREATE TABLE acl_schema.t (a INT);
RESET ROLE;

-- Test 6: query (privilege check)
SELECT has_table_privilege('default_acl_grantee', 'acl_schema.t', 'SELECT') AS grantee_can_select;

RESET client_min_messages;

