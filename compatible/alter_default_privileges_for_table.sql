-- PostgreSQL compatible tests from alter_default_privileges_for_table
-- 75 tests

SET client_min_messages = warning;

-- Setup / cleanup to make the script re-runnable.
\connect pg_tests
DROP DATABASE IF EXISTS d WITH (FORCE);

DROP VIEW IF EXISTS vx;
DROP TABLE IF EXISTS t;
DROP TABLE IF EXISTS t2;
DROP TABLE IF EXISTS t3;
DROP TABLE IF EXISTS t4;
DROP SEQUENCE IF EXISTS s;
DROP SEQUENCE IF EXISTS s2;
DROP SEQUENCE IF EXISTS s3;
DROP SEQUENCE IF EXISTS s4;

DROP ROLE IF EXISTS testuser3;
DROP ROLE IF EXISTS testuser2;
DROP ROLE IF EXISTS testuser;
DROP ROLE IF EXISTS who;
DROP ROLE IF EXISTS root;

CREATE ROLE root SUPERUSER;
CREATE ROLE who;
CREATE ROLE testuser;

SET ROLE root;

-- Test 1: statement (line 2)
ALTER DEFAULT PRIVILEGES FOR ROLE who GRANT SELECT ON TABLES TO testuser;

-- Test 2: statement (line 5)
ALTER DEFAULT PRIVILEGES GRANT SELECT ON TABLES TO who;

-- Test 3: statement (line 8)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser GRANT SELECT ON TABLES TO who;

-- Test 4: statement (line 11)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser GRANT SELECT ON TABLES TO testuser, who;

-- Test 5: statement (line 15)
-- CockroachDB supports `USAGE` on tables; PostgreSQL does not. Use INSERT.
ALTER DEFAULT PRIVILEGES GRANT INSERT ON TABLES TO testuser;

-- Test 6: statement (line 19)
-- CockroachDB: USE system (no direct equivalent in PostgreSQL)

-- Test 7: statement (line 22)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser REVOKE ALL ON TABLES FROM testuser;

-- Test 8: statement (line 25)
-- CockroachDB: RESET database (no direct equivalent in PostgreSQL)

-- Test 9: statement (line 29)
CREATE DATABASE d;
GRANT CREATE ON DATABASE d TO testuser;

-- Test 10: statement (line 36)
\connect d
SET ROLE root;
GRANT CREATE, USAGE ON SCHEMA public TO testuser;

-- Test 11: statement (line 39)
CREATE TABLE testuser_t();

-- Test 12: query (line 42)
SELECT grantor,
       grantee,
       table_catalog,
       table_schema,
       table_name,
       privilege_type,
       is_grantable,
       with_hierarchy
FROM information_schema.role_table_grants
WHERE table_schema = 'public' AND table_name = 'testuser_t'
ORDER BY grantee, privilege_type;

-- Test 13: statement (line 50)
ALTER DEFAULT PRIVILEGES REVOKE ALL ON TABLES FROM testuser;
ALTER DEFAULT PRIVILEGES IN SCHEMA public REVOKE ALL ON TABLES FROM testuser;

-- Test 14: statement (line 54)
CREATE TABLE testuser_t2();

-- Test 15: query (line 57)
SELECT grantor,
       grantee,
       table_catalog,
       table_schema,
       table_name,
       privilege_type,
       is_grantable,
       with_hierarchy
FROM information_schema.role_table_grants
WHERE table_schema = 'public' AND table_name = 'testuser_t2'
ORDER BY grantee, privilege_type;

-- Test 16: statement (line 67)
\connect pg_tests
SET ROLE root;

-- Test 17: statement (line 70)
ALTER DEFAULT PRIVILEGES GRANT SELECT ON TABLES TO testuser;

-- Test 18: statement (line 73)
CREATE TABLE t();

-- Test 19: query (line 76)
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

-- Test 20: statement (line 84)
CREATE SEQUENCE s;

-- Test 21: statement (line 87)
CREATE VIEW vx AS SELECT 1;

-- Test 22: query (line 90)
SELECT pg_get_userbyid(a.grantor) AS grantor,
       pg_get_userbyid(a.grantee) AS grantee,
       current_database() AS sequence_catalog,
       n.nspname AS sequence_schema,
       c.relname AS sequence_name,
       a.privilege_type,
       a.is_grantable
FROM pg_class c
JOIN pg_namespace n ON n.oid = c.relnamespace
JOIN LATERAL aclexplode(coalesce(c.relacl, acldefault('S'::"char", c.relowner))) a ON true
WHERE c.relkind = 'S' AND n.nspname = 'public' AND c.relname = 's'
ORDER BY grantee, privilege_type;

-- Test 23: query (line 97)
SELECT grantor,
       grantee,
       table_catalog,
       table_schema,
       table_name,
       privilege_type,
       is_grantable,
       with_hierarchy
FROM information_schema.role_table_grants
WHERE table_schema = 'public' AND table_name = 'vx'
ORDER BY grantee, privilege_type;

-- Test 24: statement (line 105)
ALTER DEFAULT PRIVILEGES REVOKE SELECT ON TABLES FROM testuser;

-- Test 25: statement (line 108)
CREATE TABLE t2();

-- Test 26: query (line 111)
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

-- Test 27: statement (line 118)
CREATE SEQUENCE s2;

-- Test 28: query (line 121)
SELECT pg_get_userbyid(a.grantor) AS grantor,
       pg_get_userbyid(a.grantee) AS grantee,
       current_database() AS sequence_catalog,
       n.nspname AS sequence_schema,
       c.relname AS sequence_name,
       a.privilege_type,
       a.is_grantable
FROM pg_class c
JOIN pg_namespace n ON n.oid = c.relnamespace
JOIN LATERAL aclexplode(coalesce(c.relacl, acldefault('S'::"char", c.relowner))) a ON true
WHERE c.relkind = 'S' AND n.nspname = 'public' AND c.relname = 's2'
ORDER BY grantee, privilege_type;

-- Test 29: statement (line 130)
CREATE ROLE testuser2;

-- Test 30: statement (line 133)
ALTER DEFAULT PRIVILEGES GRANT SELECT ON TABLES TO testuser, testuser2;

-- Test 31: statement (line 136)
CREATE TABLE t3();

-- Test 32: query (line 139)
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

-- Test 33: statement (line 148)
CREATE SEQUENCE s3;

-- Test 34: query (line 151)
SELECT pg_get_userbyid(a.grantor) AS grantor,
       pg_get_userbyid(a.grantee) AS grantee,
       current_database() AS sequence_catalog,
       n.nspname AS sequence_schema,
       c.relname AS sequence_name,
       a.privilege_type,
       a.is_grantable
FROM pg_class c
JOIN pg_namespace n ON n.oid = c.relnamespace
JOIN LATERAL aclexplode(coalesce(c.relacl, acldefault('S'::"char", c.relowner))) a ON true
WHERE c.relkind = 'S' AND n.nspname = 'public' AND c.relname = 's3'
ORDER BY grantee, privilege_type;

-- Test 35: statement (line 158)
ALTER DEFAULT PRIVILEGES REVOKE SELECT ON TABLES FROM testuser, testuser2;

-- Test 36: statement (line 161)
CREATE TABLE t4();

-- Test 37: query (line 164)
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

-- Test 38: statement (line 171)
CREATE SEQUENCE s4;

-- Test 39: query (line 174)
SELECT pg_get_userbyid(a.grantor) AS grantor,
       pg_get_userbyid(a.grantee) AS grantee,
       current_database() AS sequence_catalog,
       n.nspname AS sequence_schema,
       c.relname AS sequence_name,
       a.privilege_type,
       a.is_grantable
FROM pg_class c
JOIN pg_namespace n ON n.oid = c.relnamespace
JOIN LATERAL aclexplode(coalesce(c.relacl, acldefault('S'::"char", c.relowner))) a ON true
WHERE c.relkind = 'S' AND n.nspname = 'public' AND c.relname = 's4'
ORDER BY grantee, privilege_type;

-- Test 40: statement (line 182)
\connect d
SET ROLE root;

-- Test 41: statement (line 185)
GRANT CREATE ON DATABASE d TO testuser;

-- Test 42: statement (line 188)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser GRANT SELECT ON TABLES TO testuser, testuser2;

-- user testuser

-- Test 43: statement (line 193)
\connect d
SET ROLE testuser;

-- Test 44: statement (line 196)
CREATE TABLE t5();

-- Test 45: query (line 201)
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

-- Test 46: statement (line 212)
\connect d
SET ROLE testuser;

-- Test 47: statement (line 215)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser REVOKE SELECT ON TABLES FROM testuser, testuser2;

-- user testuser

-- Test 48: statement (line 220)
\connect d
SET ROLE testuser;

-- Test 49: statement (line 223)
CREATE TABLE t6();

-- Test 50: query (line 226)
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

-- Test 51: statement (line 236)
ALTER DEFAULT PRIVILEGES GRANT ALL ON TABLES TO testuser, testuser2;

-- Test 52: statement (line 239)
CREATE TABLE t7();

-- Test 53: query (line 242)
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

-- Test 54: statement (line 251)
ALTER DEFAULT PRIVILEGES REVOKE SELECT ON TABLES FROM testuser, testuser2;

-- Test 55: statement (line 254)
CREATE TABLE t8();

-- Test 56: query (line 257)
SELECT grantor,
       grantee,
       table_catalog,
       table_schema,
       table_name,
       privilege_type,
       is_grantable,
       with_hierarchy
FROM information_schema.role_table_grants
WHERE table_schema = 'public' AND table_name = 't8'
ORDER BY grantee, privilege_type;

-- Test 57: statement (line 289)
\connect d
SET ROLE root;

-- Test 58: statement (line 292)
ALTER DEFAULT PRIVILEGES FOR ROLE root GRANT SELECT ON TABLES TO testuser;

-- Test 59: statement (line 298)
CREATE ROLE testuser3;

-- Test 60: statement (line 301)
ALTER DEFAULT PRIVILEGES FOR ROLE root, testuser REVOKE ALL ON TABLES FROM testuser, testuser2, testuser3;

-- Test 61: statement (line 304)
ALTER DEFAULT PRIVILEGES FOR ROLE root, testuser GRANT SELECT ON TABLES TO testuser2, testuser3;

-- Test 62: statement (line 307)
CREATE TABLE t9();

-- Test 63: query (line 310)
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

-- Test 64: statement (line 321)
CREATE TABLE t10();

-- Test 65: query (line 324)
SELECT grantor,
       grantee,
       table_catalog,
       table_schema,
       table_name,
       privilege_type,
       is_grantable,
       with_hierarchy
FROM information_schema.role_table_grants
WHERE table_schema = 'public' AND table_name = 't10'
ORDER BY grantee, privilege_type;

-- Test 66: statement (line 336)
ALTER DEFAULT PRIVILEGES FOR ROLE root, testuser REVOKE SELECT ON TABLES FROM testuser2, testuser3;

-- Test 67: statement (line 339)
CREATE TABLE t11();

-- Test 68: query (line 342)
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

-- Test 69: statement (line 351)
CREATE TABLE t12();

-- Test 70: query (line 354)
SELECT grantor,
       grantee,
       table_catalog,
       table_schema,
       table_name,
       privilege_type,
       is_grantable,
       with_hierarchy
FROM information_schema.role_table_grants
WHERE table_schema = 'public' AND table_name = 't12'
ORDER BY grantee, privilege_type;

-- Test 71: statement (line 363)
-- PostgreSQL does not support `FOR ROLE public` in ALTER DEFAULT PRIVILEGES.
ALTER DEFAULT PRIVILEGES FOR ROLE root REVOKE SELECT ON TABLES FROM testuser2, testuser3;

-- Test 72: statement (line 367)
ALTER DEFAULT PRIVILEGES REVOKE SELECT ON TABLES FROM PUBLIC;

-- Test 73: query (line 375)
WITH RECURSIVE inherited AS (
  SELECT r.rolname AS role,
         m.rolname AS inheriting_member,
         true AS member_is_explicit,
         r.oid AS role_oid
  FROM pg_auth_members am
  JOIN pg_roles r ON r.oid = am.roleid
  JOIN pg_roles m ON m.oid = am.member
  WHERE m.rolname = 'root'
  UNION ALL
  SELECT r.rolname AS role,
         inherited.inheriting_member,
         false AS member_is_explicit,
         r.oid AS role_oid
  FROM inherited
  JOIN pg_auth_members am ON am.member = inherited.role_oid
  JOIN pg_roles r ON r.oid = am.roleid
)
SELECT role, inheriting_member, bool_or(member_is_explicit) AS member_is_explicit
FROM inherited
WHERE inheriting_member = 'root'
GROUP BY role, inheriting_member
ORDER BY role;

-- Test 74: statement (line 383)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser GRANT ALL ON TABLES TO testuser2;

-- Test 75: statement (line 386)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser REVOKE ALL ON TABLES FROM testuser2;

-- Cleanup.
RESET ROLE;
\connect pg_tests
DROP VIEW IF EXISTS vx;
DROP TABLE IF EXISTS t;
DROP TABLE IF EXISTS t2;
DROP TABLE IF EXISTS t3;
DROP TABLE IF EXISTS t4;
DROP SEQUENCE IF EXISTS s;
DROP SEQUENCE IF EXISTS s2;
DROP SEQUENCE IF EXISTS s3;
DROP SEQUENCE IF EXISTS s4;
DROP DATABASE IF EXISTS d WITH (FORCE);
DROP OWNED BY testuser3;
DROP OWNED BY testuser2;
DROP OWNED BY testuser;
DROP OWNED BY who;
DROP OWNED BY root;
DROP ROLE IF EXISTS testuser3;
DROP ROLE IF EXISTS testuser2;
DROP ROLE IF EXISTS testuser;
DROP ROLE IF EXISTS who;
DROP ROLE IF EXISTS root;

RESET client_min_messages;
