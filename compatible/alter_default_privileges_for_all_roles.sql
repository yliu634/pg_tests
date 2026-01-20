-- PostgreSQL compatible tests from alter_default_privileges_for_all_roles
-- 30 tests

SET client_min_messages = warning;

-- Setup / cleanup to make the script re-runnable.
DROP TABLE IF EXISTS t, t2, t3, t4, t5, t6, t7;
DROP SCHEMA IF EXISTS s CASCADE;
DROP SEQUENCE IF EXISTS seq;
DROP TYPE IF EXISTS typ;

DROP ROLE IF EXISTS testuser2;
DROP ROLE IF EXISTS testuser;
DROP ROLE IF EXISTS root;

CREATE ROLE root SUPERUSER;
CREATE ROLE testuser;

SET ROLE root;

-- Test 1: statement (line 1)
-- CockroachDB has `FOR ALL ROLES`; PostgreSQL doesn't. Apply to the role
-- executing the test (root).
ALTER DEFAULT PRIVILEGES GRANT SELECT ON TABLES TO testuser;

-- Test 2: statement (line 4)
CREATE TABLE t();

-- Test 3: query (line 7)
SELECT grantor,
       grantee,
       table_catalog,
       table_schema,
       table_name,
       privilege_type,
       is_grantable,
       with_hierarchy
FROM information_schema.role_table_grants
WHERE table_schema = 'public' AND table_name = 't'
ORDER BY grantee, privilege_type;

-- Test 4: statement (line 15)
-- CockroachDB supports `CREATE` on tables; PostgreSQL does not. Use INSERT as a
-- close stand-in that exercises default privileges on relations.
ALTER DEFAULT PRIVILEGES GRANT INSERT ON TABLES TO testuser;

-- Test 5: statement (line 18)
CREATE TABLE t2();

-- Test 6: query (line 23)
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

-- Test 7: statement (line 32)
ALTER DEFAULT PRIVILEGES REVOKE SELECT ON TABLES FROM testuser;

-- Test 8: statement (line 35)
CREATE TABLE t3();

-- Test 9: query (line 38)
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

-- Test 10: statement (line 46)
ALTER DEFAULT PRIVILEGES GRANT INSERT ON TABLES TO testuser;

-- Test 11: statement (line 49)
CREATE TABLE t4();

-- Test 12: query (line 54)
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

-- Test 13: statement (line 62)
CREATE ROLE testuser2;

-- Test 14: statement (line 65)
ALTER DEFAULT PRIVILEGES GRANT INSERT ON TABLES TO testuser, testuser2;

-- Test 15: statement (line 68)
CREATE TABLE t5();

-- Test 16: query (line 71)
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

-- Test 17: statement (line 80)
ALTER DEFAULT PRIVILEGES GRANT ALL ON TABLES TO testuser, testuser2;

-- Test 18: statement (line 83)
CREATE TABLE t6();

-- Test 19: query (line 86)
SELECT grantor,
       grantee,
       table_catalog,
       table_schema,
       table_name,
       privilege_type,
       is_grantable,
       with_hierarchy
FROM information_schema.role_table_grants
WHERE table_schema = 'public' AND table_name = 't6'
ORDER BY grantee, privilege_type;

-- Test 20: statement (line 97)
ALTER DEFAULT PRIVILEGES REVOKE ALL ON TABLES FROM testuser, testuser2;

-- Test 21: statement (line 100)
CREATE TABLE t7();

-- Test 22: query (line 103)
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

-- Test 23: statement (line 115)
ALTER DEFAULT PRIVILEGES GRANT SELECT ON TABLES TO testuser;

-- user root
SET ROLE root;

-- Test 24: statement (line 122)
ALTER DEFAULT PRIVILEGES GRANT ALL ON SEQUENCES TO testuser, testuser2;
ALTER DEFAULT PRIVILEGES GRANT ALL ON SCHEMAS TO testuser, testuser2;
ALTER DEFAULT PRIVILEGES GRANT ALL ON TYPES TO testuser, testuser2;

-- Test 25: statement (line 127)
CREATE SCHEMA s;

-- Test 26: query (line 130)
SELECT pg_get_userbyid(a.grantor) AS grantor,
       pg_get_userbyid(a.grantee) AS grantee,
       current_database() AS schema_catalog,
       n.nspname AS schema_name,
       a.privilege_type,
       a.is_grantable
FROM pg_namespace n
JOIN LATERAL aclexplode(coalesce(n.nspacl, acldefault('n'::"char", n.nspowner))) a ON true
WHERE n.nspname = 's'
ORDER BY grantee, privilege_type;

-- Test 27: statement (line 139)
CREATE SEQUENCE seq;

-- Test 28: query (line 142)
SELECT pg_get_userbyid(a.grantor) AS grantor,
       pg_get_userbyid(a.grantee) AS grantee,
       n.nspname AS schema_name,
       c.relname AS sequence_name,
       a.privilege_type,
       a.is_grantable
FROM pg_class c
JOIN pg_namespace n ON n.oid = c.relnamespace
JOIN LATERAL aclexplode(coalesce(c.relacl, acldefault('S'::"char", c.relowner))) a ON true
WHERE c.relkind = 'S' AND n.nspname = 'public' AND c.relname = 'seq'
ORDER BY grantee, privilege_type;

-- Test 29: statement (line 151)
CREATE TYPE typ AS ENUM();

-- Test 30: query (line 154)
SELECT pg_get_userbyid(a.grantor) AS grantor,
       pg_get_userbyid(a.grantee) AS grantee,
       n.nspname AS schema_name,
       t.typname AS type_name,
       a.privilege_type,
       a.is_grantable
FROM pg_type t
JOIN pg_namespace n ON n.oid = t.typnamespace
JOIN LATERAL aclexplode(coalesce(t.typacl, acldefault('T'::"char", t.typowner))) a ON true
WHERE n.nspname = 'public' AND t.typname = 'typ'
ORDER BY grantee, privilege_type;

-- Cleanup.
RESET ROLE;
DROP TABLE IF EXISTS t, t2, t3, t4, t5, t6, t7;
DROP SCHEMA IF EXISTS s CASCADE;
DROP SEQUENCE IF EXISTS seq;
DROP TYPE IF EXISTS typ;
DROP OWNED BY testuser2;
DROP OWNED BY testuser;
DROP OWNED BY root;
DROP ROLE IF EXISTS testuser2;
DROP ROLE IF EXISTS testuser;
DROP ROLE IF EXISTS root;

RESET client_min_messages;
