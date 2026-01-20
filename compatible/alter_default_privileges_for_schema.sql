-- PostgreSQL compatible tests from alter_default_privileges_for_schema
-- 32 tests

SET client_min_messages = warning;

-- Setup / cleanup to make the script re-runnable.
\connect pg_tests
DROP DATABASE IF EXISTS d WITH (FORCE);

DROP SCHEMA IF EXISTS s CASCADE;
DROP SCHEMA IF EXISTS s2 CASCADE;
DROP SCHEMA IF EXISTS s3 CASCADE;

DROP ROLE IF EXISTS testuser2;
DROP ROLE IF EXISTS testuser;
DROP ROLE IF EXISTS root;

CREATE ROLE root SUPERUSER;
CREATE ROLE testuser;

SET ROLE root;

-- Test 1: statement (line 1)
CREATE DATABASE d;
GRANT CREATE ON DATABASE d TO testuser;

-- Test 2: statement (line 8)
\connect d
SET ROLE root;

-- Test 3: query (line 14)
SELECT pg_get_userbyid(a.grantor) AS grantor,
       pg_get_userbyid(a.grantee) AS grantee,
       current_database() AS schema_catalog,
       n.nspname AS schema_name,
       a.privilege_type,
       a.is_grantable
FROM pg_namespace n
JOIN LATERAL aclexplode(coalesce(n.nspacl, acldefault('n'::"char", n.nspowner))) a ON true
WHERE n.nspname = 'public'
ORDER BY grantee, privilege_type;

-- Test 4: statement (line 23)
CREATE SCHEMA testuser_s;

-- Test 5: query (line 26)
SELECT pg_get_userbyid(a.grantor) AS grantor,
       pg_get_userbyid(a.grantee) AS grantee,
       current_database() AS schema_catalog,
       n.nspname AS schema_name,
       a.privilege_type,
       a.is_grantable
FROM pg_namespace n
JOIN LATERAL aclexplode(coalesce(n.nspacl, acldefault('n'::"char", n.nspowner))) a ON true
WHERE n.nspname = 'testuser_s'
ORDER BY grantee, privilege_type;

-- Test 6: statement (line 34)
ALTER DEFAULT PRIVILEGES REVOKE ALL ON SCHEMAS FROM testuser;

-- Test 7: statement (line 37)
CREATE SCHEMA testuser_s2;

-- Test 8: query (line 43)
SELECT pg_get_userbyid(a.grantor) AS grantor,
       pg_get_userbyid(a.grantee) AS grantee,
       current_database() AS schema_catalog,
       n.nspname AS schema_name,
       a.privilege_type,
       a.is_grantable
FROM pg_namespace n
JOIN LATERAL aclexplode(coalesce(n.nspacl, acldefault('n'::"char", n.nspowner))) a ON true
WHERE n.nspname = 'testuser_s2'
ORDER BY grantee, privilege_type;

-- Test 9: statement (line 53)
\connect pg_tests
SET ROLE root;

-- Test 10: statement (line 56)
CREATE ROLE testuser2;

-- Test 11: statement (line 59)
ALTER DEFAULT PRIVILEGES GRANT ALL ON SCHEMAS TO testuser, testuser2;

-- Test 12: statement (line 62)
CREATE SCHEMA s;

-- Test 13: query (line 65)
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

-- Test 14: statement (line 74)
ALTER DEFAULT PRIVILEGES REVOKE USAGE ON SCHEMAS FROM testuser, testuser2;

-- Test 15: statement (line 77)
CREATE SCHEMA s2;

-- Test 16: query (line 80)
SELECT pg_get_userbyid(a.grantor) AS grantor,
       pg_get_userbyid(a.grantee) AS grantee,
       current_database() AS schema_catalog,
       n.nspname AS schema_name,
       a.privilege_type,
       a.is_grantable
FROM pg_namespace n
JOIN LATERAL aclexplode(coalesce(n.nspacl, acldefault('n'::"char", n.nspowner))) a ON true
WHERE n.nspname = 's2'
ORDER BY grantee, privilege_type;

-- Test 17: statement (line 91)
ALTER DEFAULT PRIVILEGES REVOKE ALL ON SCHEMAS FROM testuser, testuser2;

-- Test 18: statement (line 94)
CREATE SCHEMA s3;

-- Test 19: query (line 97)
SELECT pg_get_userbyid(a.grantor) AS grantor,
       pg_get_userbyid(a.grantee) AS grantee,
       current_database() AS schema_catalog,
       n.nspname AS schema_name,
       a.privilege_type,
       a.is_grantable
FROM pg_namespace n
JOIN LATERAL aclexplode(coalesce(n.nspacl, acldefault('n'::"char", n.nspowner))) a ON true
WHERE n.nspname = 's3'
ORDER BY grantee, privilege_type;

-- Test 20: statement (line 104)
GRANT CREATE ON DATABASE d TO testuser;

-- user testuser

-- Test 21: statement (line 108)
\connect d
SET ROLE testuser;

-- Test 22: statement (line 111)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser REVOKE ALL ON SCHEMAS FROM testuser, testuser2;

-- Test 23: statement (line 114)
CREATE SCHEMA s4;

-- Test 24: query (line 118)
SELECT pg_get_userbyid(a.grantor) AS grantor,
       pg_get_userbyid(a.grantee) AS grantee,
       current_database() AS schema_catalog,
       n.nspname AS schema_name,
       a.privilege_type,
       a.is_grantable
FROM pg_namespace n
JOIN LATERAL aclexplode(coalesce(n.nspacl, acldefault('n'::"char", n.nspowner))) a ON true
WHERE n.nspname = 's4'
ORDER BY grantee, privilege_type;

-- Test 25: statement (line 127)
\connect d
SET ROLE testuser;

-- Test 26: statement (line 130)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser REVOKE ALL ON SCHEMAS FROM testuser, testuser2;

-- user testuser

-- Test 27: statement (line 134)
\connect d
SET ROLE testuser;

-- Test 28: statement (line 137)
CREATE SCHEMA s5;

-- Test 29: query (line 141)
SELECT pg_get_userbyid(a.grantor) AS grantor,
       pg_get_userbyid(a.grantee) AS grantee,
       current_database() AS schema_catalog,
       n.nspname AS schema_name,
       a.privilege_type,
       a.is_grantable
FROM pg_namespace n
JOIN LATERAL aclexplode(coalesce(n.nspacl, acldefault('n'::"char", n.nspowner))) a ON true
WHERE n.nspname = 's5'
ORDER BY grantee, privilege_type;

-- Test 30: statement (line 149)
ALTER DEFAULT PRIVILEGES GRANT ALL ON SCHEMAS TO testuser, testuser2;

-- user root
SET ROLE root;

-- Test 31: statement (line 154)
CREATE SCHEMA s_72322;

-- Test 32: query (line 158)
SELECT pg_get_userbyid(a.grantor) AS grantor,
       pg_get_userbyid(a.grantee) AS grantee,
       current_database() AS schema_catalog,
       n.nspname AS schema_name,
       a.privilege_type,
       a.is_grantable
FROM pg_namespace n
JOIN LATERAL aclexplode(coalesce(n.nspacl, acldefault('n'::"char", n.nspowner))) a ON true
WHERE n.nspname = 's_72322'
ORDER BY grantee, privilege_type;

-- Cleanup.
RESET ROLE;
\connect pg_tests
DROP SCHEMA IF EXISTS s CASCADE;
DROP SCHEMA IF EXISTS s2 CASCADE;
DROP SCHEMA IF EXISTS s3 CASCADE;
DROP DATABASE IF EXISTS d WITH (FORCE);
DROP OWNED BY testuser2;
DROP OWNED BY testuser;
DROP OWNED BY root;
DROP ROLE IF EXISTS testuser2;
DROP ROLE IF EXISTS testuser;
DROP ROLE IF EXISTS root;

RESET client_min_messages;
