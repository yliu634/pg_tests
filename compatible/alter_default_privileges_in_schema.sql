-- PostgreSQL compatible tests from alter_default_privileges_in_schema
-- 47 tests

SET client_min_messages = warning;

-- Setup / cleanup to make the script re-runnable.
DROP TABLE IF EXISTS t1, t2, t3, t4, t5, t7, t9, t11 CASCADE;
DROP SCHEMA IF EXISTS s2 CASCADE;
DROP SCHEMA IF EXISTS s CASCADE;
DROP SCHEMA IF EXISTS crdb_internal CASCADE;

DROP ROLE IF EXISTS testuser2;
DROP ROLE IF EXISTS testuser;
DROP ROLE IF EXISTS root;

CREATE ROLE root SUPERUSER;
CREATE ROLE testuser;

-- Ensure the schema referenced by the test exists.
CREATE SCHEMA crdb_internal;

-- Ensure the test role can create objects in the schemas used.
GRANT CREATE, USAGE ON SCHEMA public TO testuser;

-- Test 1: statement (line 3)
-- Applies to the current role (root).
SET ROLE root;
-- PostgreSQL does not allow IN SCHEMA with ON SCHEMAS; schemas are not scoped
-- to another schema. Apply without IN SCHEMA.
ALTER DEFAULT PRIVILEGES GRANT USAGE ON SCHEMAS TO root;

-- Test 2: statement (line 6)
ALTER DEFAULT PRIVILEGES IN SCHEMA crdb_internal GRANT SELECT ON TABLES TO root;

-- Test 3: statement (line 9)
CREATE ROLE testuser2;

-- Test 4: statement (line 12)
GRANT CREATE ON DATABASE pg_tests TO testuser;

-- user testuser
SET ROLE testuser;

-- Test 5: statement (line 18)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser IN SCHEMA public GRANT SELECT ON TABLES TO testuser2;

-- Test 6: statement (line 21)
CREATE TABLE t1();

-- Test 7: query (line 24)
SELECT grantor,
       grantee,
       table_catalog,
       table_schema,
       table_name,
       privilege_type,
       is_grantable,
       with_hierarchy
FROM information_schema.role_table_grants
WHERE table_schema = 'public' AND table_name = 't1'
ORDER BY grantee, privilege_type;

-- Test 8: statement (line 36)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser GRANT INSERT ON TABLES TO testuser2;

-- Test 9: statement (line 39)
CREATE TABLE t2();

-- Test 10: query (line 42)
SELECT grantor,
       grantee,
       table_catalog,
       table_schema,
       table_name,
       privilege_type,
       is_grantable,
       with_hierarchy
FROM information_schema.role_table_grants
WHERE table_schema = 'public' AND table_name = 't2'
ORDER BY grantee, privilege_type;

-- Test 11: statement (line 52)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser GRANT ALL ON TABLES TO testuser2;

-- Test 12: statement (line 55)
CREATE TABLE t3();

-- Test 13: query (line 58)
SELECT grantor,
       grantee,
       table_catalog,
       table_schema,
       table_name,
       privilege_type,
       is_grantable,
       with_hierarchy
FROM information_schema.role_table_grants
WHERE table_schema = 'public' AND table_name = 't3'
ORDER BY grantee, privilege_type;

-- Test 14: statement (line 68)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser REVOKE ALL ON TABLES FROM testuser2;

-- Test 15: statement (line 71)
CREATE TABLE t4();

-- Test 16: query (line 74)
SELECT grantor,
       grantee,
       table_catalog,
       table_schema,
       table_name,
       privilege_type,
       is_grantable,
       with_hierarchy
FROM information_schema.role_table_grants
WHERE table_schema = 'public' AND table_name = 't4'
ORDER BY grantee, privilege_type;

-- Test 17: statement (line 84)
CREATE SCHEMA s;

-- Test 18: statement (line 87)
GRANT CREATE, USAGE ON SCHEMA s TO testuser;

-- Test 19: statement (line 90)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser IN SCHEMA s, public GRANT ALL ON TABLES TO testuser2;

-- Test 20: statement (line 93)
CREATE TABLE public.t5();
CREATE TABLE s.t6();

-- Test 21: query (line 97)
SELECT grantor,
       grantee,
       table_catalog,
       table_schema,
       table_name,
       privilege_type,
       is_grantable,
       with_hierarchy
FROM information_schema.role_table_grants
WHERE table_schema = 'public' AND table_name = 't5'
ORDER BY grantee, privilege_type;

-- Test 22: query (line 106)
SELECT grantor,
       grantee,
       table_catalog,
       table_schema,
       table_name,
       privilege_type,
       is_grantable,
       with_hierarchy
FROM information_schema.role_table_grants
WHERE table_schema = 's' AND table_name = 't6'
ORDER BY grantee, privilege_type;

-- Test 23: statement (line 118)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser IN SCHEMA s, public REVOKE ALL ON TABLES FROM testuser2;
-- CockroachDB has `FOR ALL ROLES`; PostgreSQL doesn't. Apply to the role
-- executing the test (testuser).
ALTER DEFAULT PRIVILEGES IN SCHEMA s, public GRANT SELECT ON TABLES TO testuser2;

-- user testuser
SET ROLE testuser;

-- Test 24: statement (line 124)
CREATE TABLE public.t7();
CREATE TABLE s.t8();

-- Test 25: query (line 128)
SELECT grantor,
       grantee,
       table_catalog,
       table_schema,
       table_name,
       privilege_type,
       is_grantable,
       with_hierarchy
FROM information_schema.role_table_grants
WHERE table_schema = 'public' AND table_name = 't7'
ORDER BY grantee, privilege_type;

-- Test 26: query (line 137)
SELECT grantor,
       grantee,
       table_catalog,
       table_schema,
       table_name,
       privilege_type,
       is_grantable,
       with_hierarchy
FROM information_schema.role_table_grants
WHERE table_schema = 's' AND table_name = 't8'
ORDER BY grantee, privilege_type;

-- Test 27: statement (line 151)
CREATE TABLE public.t9();
CREATE TABLE s.t10();

-- Test 28: query (line 155)
SELECT grantor,
       grantee,
       table_catalog,
       table_schema,
       table_name,
       privilege_type,
       is_grantable,
       with_hierarchy
FROM information_schema.role_table_grants
WHERE table_schema = 'public' AND table_name = 't9'
ORDER BY grantee, privilege_type;

-- Test 29: query (line 163)
SELECT grantor,
       grantee,
       table_catalog,
       table_schema,
       table_name,
       privilege_type,
       is_grantable,
       with_hierarchy
FROM information_schema.role_table_grants
WHERE table_schema = 's' AND table_name = 't10'
ORDER BY grantee, privilege_type;

-- Test 30: statement (line 173)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser REVOKE ALL ON TABLES FROM testuser;

-- Test 31: statement (line 176)
CREATE TABLE t11();

-- Test 32: query (line 181)
SELECT grantor,
       grantee,
       table_catalog,
       table_schema,
       table_name,
       privilege_type,
       is_grantable,
       with_hierarchy
FROM information_schema.role_table_grants
WHERE table_schema = 'public' AND table_name = 't11'
ORDER BY grantee, privilege_type;

-- Test 33: statement (line 192)
CREATE SCHEMA s2;

-- Test 34: statement (line 195)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser REVOKE ALL ON TABLES FROM testuser;
ALTER DEFAULT PRIVILEGES FOR ROLE testuser REVOKE ALL ON TABLES FROM testuser2;

-- Test 35: statement (line 199)
CREATE TABLE s2.t12();

-- Test 36: query (line 204)
SELECT grantor,
       grantee,
       table_catalog,
       table_schema,
       table_name,
       privilege_type,
       is_grantable,
       with_hierarchy
FROM information_schema.role_table_grants
WHERE table_schema = 's2' AND table_name = 't12'
ORDER BY grantee, privilege_type;

-- Test 37: query (line 212)
-- Equivalent of `crdb_internal.default_privileges` (schema-specific entries).
SELECT r.rolname AS definer_role,
       n.nspname AS schema_name,
       CASE d.defaclobjtype
         WHEN 'r' THEN 'TABLES'
         WHEN 'S' THEN 'SEQUENCES'
         WHEN 'f' THEN 'FUNCTIONS'
         WHEN 'T' THEN 'TYPES'
         WHEN 'n' THEN 'SCHEMAS'
         ELSE d.defaclobjtype::text
       END AS object_type,
       pg_get_userbyid(a.grantor) AS grantor,
       pg_get_userbyid(a.grantee) AS grantee,
       a.privilege_type,
       a.is_grantable
FROM pg_default_acl d
JOIN pg_roles r ON r.oid = d.defaclrole
JOIN pg_namespace n ON n.oid = d.defaclnamespace
JOIN LATERAL aclexplode(coalesce(d.defaclacl, '{}'::aclitem[])) a ON true
WHERE r.rolname IN ('root', 'testuser')
ORDER BY definer_role, schema_name, object_type, grantee, privilege_type;

-- Test 38: query (line 219)
SELECT r.rolname AS definer_role,
       n.nspname AS schema_name,
       CASE d.defaclobjtype
         WHEN 'r' THEN 'TABLES'
         WHEN 'S' THEN 'SEQUENCES'
         WHEN 'f' THEN 'FUNCTIONS'
         WHEN 'T' THEN 'TYPES'
         WHEN 'n' THEN 'SCHEMAS'
         ELSE d.defaclobjtype::text
       END AS object_type,
       pg_get_userbyid(a.grantee) AS grantee,
       a.privilege_type,
       a.is_grantable
FROM pg_default_acl d
JOIN pg_roles r ON r.oid = d.defaclrole
JOIN pg_namespace n ON n.oid = d.defaclnamespace
JOIN LATERAL aclexplode(coalesce(d.defaclacl, '{}'::aclitem[])) a ON true
WHERE r.rolname IN ('root', 'testuser') AND n.nspname = 'public'
ORDER BY definer_role, schema_name, object_type, grantee, privilege_type;

-- Test 39: query (line 224)
SELECT r.rolname AS definer_role,
       n.nspname AS schema_name,
       CASE d.defaclobjtype
         WHEN 'r' THEN 'TABLES'
         WHEN 'S' THEN 'SEQUENCES'
         WHEN 'f' THEN 'FUNCTIONS'
         WHEN 'T' THEN 'TYPES'
         WHEN 'n' THEN 'SCHEMAS'
         ELSE d.defaclobjtype::text
       END AS object_type,
       pg_get_userbyid(a.grantee) AS grantee,
       a.privilege_type,
       a.is_grantable
FROM pg_default_acl d
JOIN pg_roles r ON r.oid = d.defaclrole
JOIN pg_namespace n ON n.oid = d.defaclnamespace
JOIN LATERAL aclexplode(coalesce(d.defaclacl, '{}'::aclitem[])) a ON true
WHERE r.rolname IN ('root', 'testuser') AND n.nspname = 's'
ORDER BY definer_role, schema_name, object_type, grantee, privilege_type;

-- Test 40: query (line 229)
SELECT r.rolname AS definer_role,
       n.nspname AS schema_name,
       CASE d.defaclobjtype
         WHEN 'r' THEN 'TABLES'
         WHEN 'S' THEN 'SEQUENCES'
         WHEN 'f' THEN 'FUNCTIONS'
         WHEN 'T' THEN 'TYPES'
         WHEN 'n' THEN 'SCHEMAS'
         ELSE d.defaclobjtype::text
       END AS object_type,
       pg_get_userbyid(a.grantee) AS grantee,
       a.privilege_type,
       a.is_grantable
FROM pg_default_acl d
JOIN pg_roles r ON r.oid = d.defaclrole
JOIN pg_namespace n ON n.oid = d.defaclnamespace
JOIN LATERAL aclexplode(coalesce(d.defaclacl, '{}'::aclitem[])) a ON true
WHERE r.rolname IN ('root', 'testuser') AND n.nspname = 's2'
ORDER BY definer_role, schema_name, object_type, grantee, privilege_type;

-- Test 41: statement (line 234)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser IN SCHEMA public GRANT ALL ON TABLES TO testuser;
ALTER DEFAULT PRIVILEGES FOR ROLE testuser IN SCHEMA s GRANT USAGE ON TYPES TO testuser2;
-- CockroachDB supports a table-level DROP privilege; PostgreSQL does not.
-- Use DELETE as a close stand-in that exercises table privileges.
ALTER DEFAULT PRIVILEGES FOR ROLE testuser IN SCHEMA s2 GRANT SELECT, UPDATE, DELETE ON TABLES TO testuser2;

-- Test 42: query (line 239)
SELECT r.rolname AS definer_role,
       n.nspname AS schema_name,
       CASE d.defaclobjtype
         WHEN 'r' THEN 'TABLES'
         WHEN 'S' THEN 'SEQUENCES'
         WHEN 'f' THEN 'FUNCTIONS'
         WHEN 'T' THEN 'TYPES'
         WHEN 'n' THEN 'SCHEMAS'
         ELSE d.defaclobjtype::text
       END AS object_type,
       pg_get_userbyid(a.grantor) AS grantor,
       pg_get_userbyid(a.grantee) AS grantee,
       a.privilege_type,
       a.is_grantable
FROM pg_default_acl d
JOIN pg_roles r ON r.oid = d.defaclrole
JOIN pg_namespace n ON n.oid = d.defaclnamespace
JOIN LATERAL aclexplode(coalesce(d.defaclacl, '{}'::aclitem[])) a ON true
WHERE r.rolname IN ('root', 'testuser')
ORDER BY definer_role, schema_name, object_type, grantee, privilege_type;

-- Test 43: query (line 252)
SELECT r.rolname AS definer_role,
       n.nspname AS schema_name,
       CASE d.defaclobjtype
         WHEN 'r' THEN 'TABLES'
         WHEN 'S' THEN 'SEQUENCES'
         WHEN 'f' THEN 'FUNCTIONS'
         WHEN 'T' THEN 'TYPES'
         WHEN 'n' THEN 'SCHEMAS'
         ELSE d.defaclobjtype::text
       END AS object_type,
       pg_get_userbyid(a.grantee) AS grantee,
       a.privilege_type,
       a.is_grantable
FROM pg_default_acl d
JOIN pg_roles r ON r.oid = d.defaclrole
JOIN pg_namespace n ON n.oid = d.defaclnamespace
JOIN LATERAL aclexplode(coalesce(d.defaclacl, '{}'::aclitem[])) a ON true
WHERE r.rolname IN ('root', 'testuser') AND n.nspname = 'public'
ORDER BY definer_role, schema_name, object_type, grantee, privilege_type;

-- Test 44: query (line 258)
SELECT r.rolname AS definer_role,
       n.nspname AS schema_name,
       CASE d.defaclobjtype
         WHEN 'r' THEN 'TABLES'
         WHEN 'S' THEN 'SEQUENCES'
         WHEN 'f' THEN 'FUNCTIONS'
         WHEN 'T' THEN 'TYPES'
         WHEN 'n' THEN 'SCHEMAS'
         ELSE d.defaclobjtype::text
       END AS object_type,
       pg_get_userbyid(a.grantee) AS grantee,
       a.privilege_type,
       a.is_grantable
FROM pg_default_acl d
JOIN pg_roles r ON r.oid = d.defaclrole
JOIN pg_namespace n ON n.oid = d.defaclnamespace
JOIN LATERAL aclexplode(coalesce(d.defaclacl, '{}'::aclitem[])) a ON true
WHERE r.rolname IN ('root', 'testuser') AND n.nspname = 's'
ORDER BY definer_role, schema_name, object_type, grantee, privilege_type;

-- Test 45: query (line 264)
SELECT r.rolname AS definer_role,
       n.nspname AS schema_name,
       CASE d.defaclobjtype
         WHEN 'r' THEN 'TABLES'
         WHEN 'S' THEN 'SEQUENCES'
         WHEN 'f' THEN 'FUNCTIONS'
         WHEN 'T' THEN 'TYPES'
         WHEN 'n' THEN 'SCHEMAS'
         ELSE d.defaclobjtype::text
       END AS object_type,
       pg_get_userbyid(a.grantee) AS grantee,
       a.privilege_type,
       a.is_grantable
FROM pg_default_acl d
JOIN pg_roles r ON r.oid = d.defaclrole
JOIN pg_namespace n ON n.oid = d.defaclnamespace
JOIN LATERAL aclexplode(coalesce(d.defaclacl, '{}'::aclitem[])) a ON true
WHERE r.rolname IN ('root', 'testuser') AND n.nspname = 's2'
ORDER BY definer_role, schema_name, object_type, grantee, privilege_type;

-- Test 46: query (line 274)
SELECT r.rolname AS definer_role,
       n.nspname AS schema_name,
       CASE d.defaclobjtype
         WHEN 'r' THEN 'TABLES'
         WHEN 'S' THEN 'SEQUENCES'
         WHEN 'f' THEN 'FUNCTIONS'
         WHEN 'T' THEN 'TYPES'
         WHEN 'n' THEN 'SCHEMAS'
         ELSE d.defaclobjtype::text
       END AS object_type,
       pg_get_userbyid(a.grantee) AS grantee,
       a.privilege_type,
       a.is_grantable
FROM pg_default_acl d
JOIN pg_roles r ON r.oid = d.defaclrole
JOIN pg_namespace n ON n.oid = d.defaclnamespace
JOIN LATERAL aclexplode(coalesce(d.defaclacl, '{}'::aclitem[])) a ON true
WHERE r.rolname = 'testuser' AND n.nspname = 's2'
ORDER BY definer_role, schema_name, object_type, grantee, privilege_type;

-- Test 47: query (line 282)
-- Ensure schema names are treated as data, not executed.
SELECT r.rolname AS definer_role,
       n.nspname AS schema_name,
       CASE d.defaclobjtype
         WHEN 'r' THEN 'TABLES'
         WHEN 'S' THEN 'SEQUENCES'
         WHEN 'f' THEN 'FUNCTIONS'
         WHEN 'T' THEN 'TYPES'
         WHEN 'n' THEN 'SCHEMAS'
         ELSE d.defaclobjtype::text
       END AS object_type,
       pg_get_userbyid(a.grantee) AS grantee,
       a.privilege_type,
       a.is_grantable
FROM pg_default_acl d
JOIN pg_roles r ON r.oid = d.defaclrole
JOIN pg_namespace n ON n.oid = d.defaclnamespace
JOIN LATERAL aclexplode(coalesce(d.defaclacl, '{}'::aclitem[])) a ON true
WHERE r.rolname IN ('root', 'testuser')
  AND n.nspname = '\"''; drop database pg_tests; SELECT '''
ORDER BY definer_role, schema_name, object_type, grantee, privilege_type;

-- Cleanup.
RESET ROLE;
DROP TABLE IF EXISTS t1, t2, t3, t4, t5, t7, t9, t11 CASCADE;
DROP SCHEMA IF EXISTS s2 CASCADE;
DROP SCHEMA IF EXISTS s CASCADE;
DROP SCHEMA IF EXISTS crdb_internal CASCADE;
DROP OWNED BY testuser2;
DROP OWNED BY testuser;
DROP OWNED BY root;
DROP ROLE IF EXISTS testuser2;
DROP ROLE IF EXISTS testuser;
DROP ROLE IF EXISTS root;

RESET client_min_messages;
