-- PostgreSQL compatible tests from alter_default_privileges_for_sequence
-- 30 tests

SET client_min_messages = warning;

-- Setup / cleanup to make the script re-runnable.
\connect pg_tests
DROP DATABASE IF EXISTS d WITH (FORCE);
DROP TABLE IF EXISTS t;
DROP SEQUENCE IF EXISTS s;
DROP SEQUENCE IF EXISTS s2;
DROP SEQUENCE IF EXISTS s3;

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
GRANT CREATE, USAGE ON SCHEMA public TO testuser;

-- Test 3: statement (line 11)
CREATE SEQUENCE testuser_s;

-- Test 4: query (line 14)
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
WHERE c.relkind = 'S' AND n.nspname = 'public' AND c.relname = 'testuser_s'
ORDER BY grantee, privilege_type;

-- Test 5: statement (line 22)
ALTER DEFAULT PRIVILEGES REVOKE ALL ON SEQUENCES FROM testuser;
ALTER DEFAULT PRIVILEGES IN SCHEMA public REVOKE ALL ON SEQUENCES FROM testuser;

-- Test 6: statement (line 26)
CREATE SEQUENCE testuser_s2;

-- Test 7: query (line 32)
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
WHERE c.relkind = 'S' AND n.nspname = 'public' AND c.relname = 'testuser_s2'
ORDER BY grantee, privilege_type;

-- Test 8: statement (line 42)
\connect pg_tests
SET ROLE root;

-- Test 9: statement (line 45)
CREATE ROLE testuser2;

-- Test 10: statement (line 48)
ALTER DEFAULT PRIVILEGES GRANT ALL ON SEQUENCES TO testuser, testuser2;

-- Test 11: statement (line 51)
CREATE SEQUENCE s;

-- Test 12: query (line 54)
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

-- Test 13: statement (line 64)
CREATE TABLE t();

-- Test 14: query (line 67)
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

-- Test 15: statement (line 75)
ALTER DEFAULT PRIVILEGES REVOKE SELECT ON SEQUENCES FROM testuser, testuser2;

-- Test 16: statement (line 78)
CREATE SEQUENCE s2;

-- Test 17: query (line 81)
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

-- Test 18: statement (line 104)
ALTER DEFAULT PRIVILEGES REVOKE ALL ON SEQUENCES FROM testuser, testuser2;

-- Test 19: statement (line 107)
CREATE SEQUENCE s3;

-- Test 20: query (line 110)
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

-- Test 21: statement (line 117)
GRANT CREATE ON DATABASE d TO testuser;

-- user testuser

-- Test 22: statement (line 121)
\connect d
SET ROLE testuser;

-- Test 23: statement (line 124)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser REVOKE ALL ON SEQUENCES FROM testuser, testuser2;

-- Test 24: statement (line 127)
CREATE SEQUENCE s4;

-- Test 25: query (line 131)
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

-- Test 26: statement (line 140)
\connect d
SET ROLE testuser;

-- Test 27: statement (line 143)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser REVOKE ALL ON SEQUENCES FROM testuser, testuser2;

-- user testuser

-- Test 28: statement (line 147)
\connect d
SET ROLE testuser;

-- Test 29: statement (line 150)
CREATE SEQUENCE s5;

-- Test 30: query (line 154)
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
WHERE c.relkind = 'S' AND n.nspname = 'public' AND c.relname = 's5'
ORDER BY grantee, privilege_type;

-- Cleanup.
RESET ROLE;
\connect pg_tests
DROP TABLE IF EXISTS t;
DROP SEQUENCE IF EXISTS s;
DROP SEQUENCE IF EXISTS s2;
DROP SEQUENCE IF EXISTS s3;
DROP DATABASE IF EXISTS d WITH (FORCE);
DROP OWNED BY testuser2;
DROP OWNED BY testuser;
DROP OWNED BY root;
DROP ROLE IF EXISTS testuser2;
DROP ROLE IF EXISTS testuser;
DROP ROLE IF EXISTS root;

RESET client_min_messages;
