-- PostgreSQL compatible tests from alter_default_privileges_for_schema
-- 32 tests

SET client_min_messages = warning;

-- Cleanup from prior runs.
DROP SCHEMA IF EXISTS s CASCADE;
DROP SCHEMA IF EXISTS s2 CASCADE;
DROP SCHEMA IF EXISTS s3 CASCADE;
DROP DATABASE IF EXISTS d;

-- Default privileges can create dependencies that block DROP ROLE; revoke them if the
-- roles exist (psql-specific \gexec).
SELECT format('ALTER DEFAULT PRIVILEGES REVOKE ALL ON SCHEMAS FROM %I;', rolname)
FROM pg_roles
WHERE rolname IN ('testuser', 'testuser2') \gexec

DROP ROLE IF EXISTS testuser2;
DROP ROLE IF EXISTS testuser;
CREATE ROLE testuser;
CREATE ROLE testuser2;

-- Test 1: statement (line 1)
CREATE DATABASE d;
GRANT CREATE ON DATABASE d TO testuser;

-- Test 2: statement (line 8)
\connect d
SET client_min_messages = warning;

-- Test 3: query (line 14)
SELECT
  grantor::regrole::text AS grantor,
  CASE WHEN grantee = 0 THEN 'PUBLIC' ELSE grantee::regrole::text END AS grantee,
  privilege_type,
  is_grantable
FROM aclexplode(
  (SELECT COALESCE(nspacl, acldefault('n', nspowner)) FROM pg_namespace WHERE oid = 'public'::regnamespace)
)
ORDER BY 1, 2, 3, 4;

-- Test 4: statement (line 23)
CREATE SCHEMA testuser_s;

-- Test 5: query (line 26)
SELECT
  grantor::regrole::text AS grantor,
  CASE WHEN grantee = 0 THEN 'PUBLIC' ELSE grantee::regrole::text END AS grantee,
  privilege_type,
  is_grantable
FROM aclexplode(
  (SELECT COALESCE(nspacl, acldefault('n', nspowner)) FROM pg_namespace WHERE oid = 'testuser_s'::regnamespace)
)
ORDER BY 1, 2, 3, 4;

-- Test 6: statement (line 34)
ALTER DEFAULT PRIVILEGES REVOKE ALL ON SCHEMAS FROM testuser;

-- Test 7: statement (line 37)
CREATE SCHEMA testuser_s2;

-- Test 8: query (line 43)
SELECT
  grantor::regrole::text AS grantor,
  CASE WHEN grantee = 0 THEN 'PUBLIC' ELSE grantee::regrole::text END AS grantee,
  privilege_type,
  is_grantable
FROM aclexplode(
  (SELECT COALESCE(nspacl, acldefault('n', nspowner)) FROM pg_namespace WHERE oid = 'testuser_s2'::regnamespace)
)
ORDER BY 1, 2, 3, 4;

-- Test 9: statement (line 53)
\connect pg_tests
SET client_min_messages = warning;

-- Test 10: statement (line 56)
DROP ROLE IF EXISTS testuser2;
CREATE ROLE testuser2;

-- Test 11: statement (line 59)
ALTER DEFAULT PRIVILEGES GRANT ALL ON SCHEMAS TO testuser, testuser2;

-- Test 12: statement (line 62)
CREATE SCHEMA s;

-- Test 13: query (line 65)
SELECT
  grantor::regrole::text AS grantor,
  CASE WHEN grantee = 0 THEN 'PUBLIC' ELSE grantee::regrole::text END AS grantee,
  privilege_type,
  is_grantable
FROM aclexplode(
  (SELECT COALESCE(nspacl, acldefault('n', nspowner)) FROM pg_namespace WHERE oid = 's'::regnamespace)
)
ORDER BY 1, 2, 3, 4;

-- Test 14: statement (line 74)
ALTER DEFAULT PRIVILEGES REVOKE USAGE ON SCHEMAS FROM testuser, testuser2;

-- Test 15: statement (line 77)
CREATE SCHEMA s2;

-- Test 16: query (line 80)
SELECT
  grantor::regrole::text AS grantor,
  CASE WHEN grantee = 0 THEN 'PUBLIC' ELSE grantee::regrole::text END AS grantee,
  privilege_type,
  is_grantable
FROM aclexplode(
  (SELECT COALESCE(nspacl, acldefault('n', nspowner)) FROM pg_namespace WHERE oid = 's2'::regnamespace)
)
ORDER BY 1, 2, 3, 4;

-- Test 17: statement (line 91)
ALTER DEFAULT PRIVILEGES REVOKE ALL ON SCHEMAS FROM testuser, testuser2;

-- Test 18: statement (line 94)
CREATE SCHEMA s3;

-- Test 19: query (line 97)
SELECT
  grantor::regrole::text AS grantor,
  CASE WHEN grantee = 0 THEN 'PUBLIC' ELSE grantee::regrole::text END AS grantee,
  privilege_type,
  is_grantable
FROM aclexplode(
  (SELECT COALESCE(nspacl, acldefault('n', nspowner)) FROM pg_namespace WHERE oid = 's3'::regnamespace)
)
ORDER BY 1, 2, 3, 4;

-- Test 20: statement (line 104)
GRANT CREATE ON DATABASE d TO testuser;

-- user testuser
-- Test 21: statement (line 108)
\connect d
SET client_min_messages = warning;
SET ROLE testuser;

-- Test 22: statement (line 111)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser REVOKE ALL ON SCHEMAS FROM testuser, testuser2;

-- Test 23: statement (line 114)
CREATE SCHEMA s4;

-- Test 24: query (line 118)
SELECT
  grantor::regrole::text AS grantor,
  CASE WHEN grantee = 0 THEN 'PUBLIC' ELSE grantee::regrole::text END AS grantee,
  privilege_type,
  is_grantable
FROM aclexplode(
  (SELECT COALESCE(nspacl, acldefault('n', nspowner)) FROM pg_namespace WHERE oid = 's4'::regnamespace)
)
ORDER BY 1, 2, 3, 4;

-- Test 25: statement (line 127)
\connect d
SET client_min_messages = warning;
SET ROLE testuser;

-- Test 26: statement (line 130)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser REVOKE ALL ON SCHEMAS FROM testuser, testuser2;

-- user testuser
-- Test 27: statement (line 134)
\connect d
SET client_min_messages = warning;
SET ROLE testuser;

-- Test 28: statement (line 137)
CREATE SCHEMA s5;

-- Test 29: query (line 141)
SELECT
  grantor::regrole::text AS grantor,
  CASE WHEN grantee = 0 THEN 'PUBLIC' ELSE grantee::regrole::text END AS grantee,
  privilege_type,
  is_grantable
FROM aclexplode(
  (SELECT COALESCE(nspacl, acldefault('n', nspowner)) FROM pg_namespace WHERE oid = 's5'::regnamespace)
)
ORDER BY 1, 2, 3, 4;

-- Test 30: statement (line 149)
ALTER DEFAULT PRIVILEGES GRANT ALL ON SCHEMAS TO testuser, testuser2;

-- user root
RESET ROLE;

-- Test 31: statement (line 154)
CREATE SCHEMA s_72322;

-- Test 32: query (line 158)
SELECT
  grantor::regrole::text AS grantor,
  CASE WHEN grantee = 0 THEN 'PUBLIC' ELSE grantee::regrole::text END AS grantee,
  privilege_type,
  is_grantable
FROM aclexplode(
  (SELECT COALESCE(nspacl, acldefault('n', nspowner)) FROM pg_namespace WHERE oid = 's_72322'::regnamespace)
)
ORDER BY 1, 2, 3, 4;

-- Cleanup so the file can be re-run without role dependency errors.
\connect pg_tests
SET client_min_messages = warning;
ALTER DEFAULT PRIVILEGES REVOKE ALL ON SCHEMAS FROM testuser, testuser2;
DROP SCHEMA IF EXISTS s CASCADE;
DROP SCHEMA IF EXISTS s2 CASCADE;
DROP SCHEMA IF EXISTS s3 CASCADE;

\connect postgres
SET client_min_messages = warning;
DROP DATABASE IF EXISTS d;
DROP ROLE IF EXISTS testuser2;
DROP ROLE IF EXISTS testuser;

RESET client_min_messages;
