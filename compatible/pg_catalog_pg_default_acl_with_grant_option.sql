SET client_min_messages = warning;

-- PostgreSQL compatible tests from pg_catalog_pg_default_acl_with_grant_option
-- 50 tests
--
-- Exercise ALTER DEFAULT PRIVILEGES WITH GRANT OPTION and verify via
-- information_schema.table_privileges.

-- Test 1: statement (role setup)
DROP ROLE IF EXISTS default_acl_owner_go;
DROP ROLE IF EXISTS default_acl_grantee_go;
CREATE ROLE default_acl_owner_go;
CREATE ROLE default_acl_grantee_go;

-- Test 2: statement (schema setup)
DROP SCHEMA IF EXISTS acl_schema_go CASCADE;
CREATE SCHEMA acl_schema_go AUTHORIZATION default_acl_owner_go;

-- Test 3: statement (default privileges with grant option)
ALTER DEFAULT PRIVILEGES FOR ROLE default_acl_owner_go IN SCHEMA acl_schema_go
GRANT SELECT ON TABLES TO default_acl_grantee_go WITH GRANT OPTION;

-- Test 4: statement (create table under role)
SET ROLE default_acl_owner_go;
DROP TABLE IF EXISTS acl_schema_go.t CASCADE;
CREATE TABLE acl_schema_go.t (a INT);
RESET ROLE;

-- Test 5: query (is_grantable)
SELECT grantee, privilege_type, is_grantable
FROM information_schema.table_privileges
WHERE table_schema = 'acl_schema_go'
  AND table_name = 't'
  AND grantee = 'default_acl_grantee_go'
ORDER BY privilege_type;

RESET client_min_messages;

