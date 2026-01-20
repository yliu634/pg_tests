-- PostgreSQL compatible tests from alter_default_privileges_for_type
-- 28 tests

SET client_min_messages = warning;

-- Setup / cleanup to make the script re-runnable.
\connect pg_tests
DROP DATABASE IF EXISTS d WITH (FORCE);
DROP TYPE IF EXISTS t;
DROP TYPE IF EXISTS t2;
DROP TYPE IF EXISTS t3;

DROP ROLE IF EXISTS testuser2;
DROP ROLE IF EXISTS testuser;
DROP ROLE IF EXISTS root;

CREATE ROLE root SUPERUSER;
CREATE ROLE testuser;

SET ROLE root;

-- Test 1: statement (line 1)
CREATE DATABASE d;
GRANT CREATE ON DATABASE d TO testuser;

-- Test 2: statement (line 9)
\connect d
SET ROLE root;
GRANT CREATE, USAGE ON SCHEMA public TO testuser;

-- Test 3: statement (line 12)
CREATE TYPE testuser_t AS ENUM();

-- Test 4: query (line 15)
SELECT pg_get_userbyid(a.grantor) AS grantor,
       pg_get_userbyid(a.grantee) AS grantee,
       current_database() AS type_catalog,
       n.nspname AS type_schema,
       t.typname AS type_name,
       a.privilege_type,
       a.is_grantable
FROM pg_type t
JOIN pg_namespace n ON n.oid = t.typnamespace
JOIN LATERAL aclexplode(coalesce(t.typacl, acldefault('T'::"char", t.typowner))) a ON true
WHERE n.nspname = 'public' AND t.typname = 'testuser_t'
ORDER BY grantee, privilege_type;

-- Test 5: statement (line 24)
ALTER DEFAULT PRIVILEGES REVOKE ALL ON TYPES FROM testuser;
ALTER DEFAULT PRIVILEGES REVOKE USAGE ON TYPES FROM PUBLIC;
ALTER DEFAULT PRIVILEGES IN SCHEMA public REVOKE ALL ON TYPES FROM testuser;
ALTER DEFAULT PRIVILEGES IN SCHEMA public REVOKE USAGE ON TYPES FROM PUBLIC;

-- Test 6: statement (line 30)
CREATE TYPE testuser_t2 AS ENUM();

-- Test 7: query (line 33)
SELECT pg_get_userbyid(a.grantor) AS grantor,
       pg_get_userbyid(a.grantee) AS grantee,
       current_database() AS type_catalog,
       n.nspname AS type_schema,
       t.typname AS type_name,
       a.privilege_type,
       a.is_grantable
FROM pg_type t
JOIN pg_namespace n ON n.oid = t.typnamespace
JOIN LATERAL aclexplode(coalesce(t.typacl, acldefault('T'::"char", t.typowner))) a ON true
WHERE n.nspname = 'public' AND t.typname = 'testuser_t2'
ORDER BY grantee, privilege_type;

-- Test 8: statement (line 43)
\connect pg_tests
SET ROLE root;

-- Test 9: statement (line 46)
CREATE ROLE testuser2;

-- Test 10: statement (line 49)
ALTER DEFAULT PRIVILEGES GRANT ALL ON TYPES TO testuser, testuser2;

-- Test 11: statement (line 52)
CREATE TYPE t AS ENUM();

-- Test 12: query (line 55)
SELECT pg_get_userbyid(a.grantor) AS grantor,
       pg_get_userbyid(a.grantee) AS grantee,
       current_database() AS type_catalog,
       n.nspname AS type_schema,
       t.typname AS type_name,
       a.privilege_type,
       a.is_grantable
FROM pg_type t
JOIN pg_namespace n ON n.oid = t.typnamespace
JOIN LATERAL aclexplode(coalesce(t.typacl, acldefault('T'::"char", t.typowner))) a ON true
WHERE n.nspname = 'public' AND t.typname = 't'
ORDER BY grantee, privilege_type;

-- Test 13: statement (line 65)
ALTER DEFAULT PRIVILEGES REVOKE USAGE ON TYPES FROM testuser, testuser2;

-- Test 14: statement (line 68)
CREATE TYPE t2 AS ENUM();

-- Test 15: query (line 71)
SELECT pg_get_userbyid(a.grantor) AS grantor,
       pg_get_userbyid(a.grantee) AS grantee,
       current_database() AS type_catalog,
       n.nspname AS type_schema,
       t.typname AS type_name,
       a.privilege_type,
       a.is_grantable
FROM pg_type t
JOIN pg_namespace n ON n.oid = t.typnamespace
JOIN LATERAL aclexplode(coalesce(t.typacl, acldefault('T'::"char", t.typowner))) a ON true
WHERE n.nspname = 'public' AND t.typname = 't2'
ORDER BY grantee, privilege_type;

-- Test 16: statement (line 79)
ALTER DEFAULT PRIVILEGES REVOKE ALL ON TYPES FROM testuser, testuser2;

-- Test 17: statement (line 82)
CREATE TYPE t3 AS ENUM();

-- Test 18: query (line 85)
SELECT pg_get_userbyid(a.grantor) AS grantor,
       pg_get_userbyid(a.grantee) AS grantee,
       current_database() AS type_catalog,
       n.nspname AS type_schema,
       t.typname AS type_name,
       a.privilege_type,
       a.is_grantable
FROM pg_type t
JOIN pg_namespace n ON n.oid = t.typnamespace
JOIN LATERAL aclexplode(coalesce(t.typacl, acldefault('T'::"char", t.typowner))) a ON true
WHERE n.nspname = 'public' AND t.typname = 't3'
ORDER BY grantee, privilege_type;

-- Test 19: statement (line 93)
GRANT CREATE ON DATABASE d TO testuser;

-- user testuser

-- Test 20: statement (line 97)
\connect d
SET ROLE testuser;

-- Test 21: statement (line 100)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser REVOKE ALL ON TYPES FROM testuser, testuser2;

-- Test 22: statement (line 103)
CREATE TYPE t4 AS ENUM();

-- Test 23: query (line 106)
SELECT pg_get_userbyid(a.grantor) AS grantor,
       pg_get_userbyid(a.grantee) AS grantee,
       current_database() AS type_catalog,
       n.nspname AS type_schema,
       t.typname AS type_name,
       a.privilege_type,
       a.is_grantable
FROM pg_type t
JOIN pg_namespace n ON n.oid = t.typnamespace
JOIN LATERAL aclexplode(coalesce(t.typacl, acldefault('T'::"char", t.typowner))) a ON true
WHERE n.nspname = 'public' AND t.typname = 't4'
ORDER BY grantee, privilege_type;

-- Test 24: statement (line 115)
\connect d
SET ROLE testuser;

-- Test 25: statement (line 118)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser REVOKE ALL ON TYPES FROM testuser, testuser2;

-- user testuser

-- Test 26: statement (line 122)
\connect d
SET ROLE testuser;

-- Test 27: statement (line 125)
CREATE TYPE t5 AS ENUM();

-- Test 28: query (line 128)
SELECT pg_get_userbyid(a.grantor) AS grantor,
       pg_get_userbyid(a.grantee) AS grantee,
       current_database() AS type_catalog,
       n.nspname AS type_schema,
       t.typname AS type_name,
       a.privilege_type,
       a.is_grantable
FROM pg_type t
JOIN pg_namespace n ON n.oid = t.typnamespace
JOIN LATERAL aclexplode(coalesce(t.typacl, acldefault('T'::"char", t.typowner))) a ON true
WHERE n.nspname = 'public' AND t.typname = 't5'
ORDER BY grantee, privilege_type;

-- Cleanup.
RESET ROLE;
\connect pg_tests
DROP TYPE IF EXISTS t;
DROP TYPE IF EXISTS t2;
DROP TYPE IF EXISTS t3;
DROP DATABASE IF EXISTS d WITH (FORCE);
DROP OWNED BY testuser2;
DROP OWNED BY testuser;
DROP OWNED BY root;
DROP ROLE IF EXISTS testuser2;
DROP ROLE IF EXISTS testuser;
DROP ROLE IF EXISTS root;

RESET client_min_messages;
