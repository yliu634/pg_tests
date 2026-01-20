-- PostgreSQL compatible tests from alter_default_privileges_for_sequence
-- 30 tests

SET client_min_messages = warning;

-- Cleanup from prior runs.
DROP TABLE IF EXISTS t;
DROP SEQUENCE IF EXISTS s5;
DROP SEQUENCE IF EXISTS s4;
DROP SEQUENCE IF EXISTS s3;
DROP SEQUENCE IF EXISTS s2;
DROP SEQUENCE IF EXISTS s;
DROP DATABASE IF EXISTS d;

-- Default privileges can create dependencies that block DROP ROLE; revoke them if the
-- roles exist (psql-specific \gexec).
SELECT format('ALTER DEFAULT PRIVILEGES REVOKE ALL ON SEQUENCES FROM %I;', rolname)
FROM pg_roles
WHERE rolname IN ('testuser', 'testuser2') \gexec
SELECT format('ALTER DEFAULT PRIVILEGES REVOKE ALL ON TABLES FROM %I;', rolname)
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
GRANT CREATE ON SCHEMA public TO testuser;

-- Test 3: statement (line 11)
CREATE SEQUENCE testuser_s;

-- Test 4: query (line 14)
SELECT
  grantor::regrole::text AS grantor,
  CASE WHEN grantee = 0 THEN 'PUBLIC' ELSE grantee::regrole::text END AS grantee,
  privilege_type,
  is_grantable
FROM aclexplode(
  (SELECT COALESCE(relacl, acldefault('s', relowner)) FROM pg_class WHERE oid = 'testuser_s'::regclass)
)
ORDER BY 1, 2, 3, 4;

-- Test 5: statement (line 22)
ALTER DEFAULT PRIVILEGES REVOKE ALL ON SEQUENCES FROM testuser;
ALTER DEFAULT PRIVILEGES IN SCHEMA public REVOKE ALL ON SEQUENCES FROM testuser;

-- Test 6: statement (line 26)
CREATE SEQUENCE testuser_s2;

-- Test 7: query (line 32)
SELECT
  grantor::regrole::text AS grantor,
  CASE WHEN grantee = 0 THEN 'PUBLIC' ELSE grantee::regrole::text END AS grantee,
  privilege_type,
  is_grantable
FROM aclexplode(
  (SELECT COALESCE(relacl, acldefault('s', relowner)) FROM pg_class WHERE oid = 'testuser_s2'::regclass)
)
ORDER BY 1, 2, 3, 4;

-- Test 8: statement (line 42)
\connect pg_tests
SET client_min_messages = warning;

-- Test 9: statement (line 45)
DROP ROLE IF EXISTS testuser2;
CREATE ROLE testuser2;

-- Test 10: statement (line 48)
ALTER DEFAULT PRIVILEGES GRANT ALL ON SEQUENCES TO testuser, testuser2;

-- Test 11: statement (line 51)
CREATE SEQUENCE s;

-- Test 12: query (line 54)
SELECT
  grantor::regrole::text AS grantor,
  CASE WHEN grantee = 0 THEN 'PUBLIC' ELSE grantee::regrole::text END AS grantee,
  privilege_type,
  is_grantable
FROM aclexplode(
  (SELECT COALESCE(relacl, acldefault('s', relowner)) FROM pg_class WHERE oid = 's'::regclass)
)
ORDER BY 1, 2, 3, 4;

-- Test 13: statement (line 64)
CREATE TABLE t ();

-- Test 14: query (line 67)
SELECT
  grantor::regrole::text AS grantor,
  CASE WHEN grantee = 0 THEN 'PUBLIC' ELSE grantee::regrole::text END AS grantee,
  privilege_type,
  is_grantable
FROM aclexplode(
  (SELECT COALESCE(relacl, acldefault('r', relowner)) FROM pg_class WHERE oid = 't'::regclass)
)
ORDER BY 1, 2, 3, 4;

-- Test 15: statement (line 75)
ALTER DEFAULT PRIVILEGES REVOKE SELECT ON SEQUENCES FROM testuser, testuser2;

-- Test 16: statement (line 78)
CREATE SEQUENCE s2;

-- Test 17: query (line 81)
SELECT
  grantor::regrole::text AS grantor,
  CASE WHEN grantee = 0 THEN 'PUBLIC' ELSE grantee::regrole::text END AS grantee,
  privilege_type,
  is_grantable
FROM aclexplode(
  (SELECT COALESCE(relacl, acldefault('s', relowner)) FROM pg_class WHERE oid = 's2'::regclass)
)
ORDER BY 1, 2, 3, 4;

-- Test 18: statement (line 104)
ALTER DEFAULT PRIVILEGES REVOKE ALL ON SEQUENCES FROM testuser, testuser2;

-- Test 19: statement (line 107)
CREATE SEQUENCE s3;

-- Test 20: query (line 110)
SELECT
  grantor::regrole::text AS grantor,
  CASE WHEN grantee = 0 THEN 'PUBLIC' ELSE grantee::regrole::text END AS grantee,
  privilege_type,
  is_grantable
FROM aclexplode(
  (SELECT COALESCE(relacl, acldefault('s', relowner)) FROM pg_class WHERE oid = 's3'::regclass)
)
ORDER BY 1, 2, 3, 4;

-- Test 21: statement (line 117)
GRANT CREATE ON DATABASE d TO testuser;

-- user testuser
-- Test 22: statement (line 121)
\connect d
SET client_min_messages = warning;
SET ROLE testuser;

-- Test 23: statement (line 124)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser REVOKE ALL ON SEQUENCES FROM testuser, testuser2;

-- Test 24: statement (line 127)
CREATE SEQUENCE s4;

-- Test 25: query (line 131)
SELECT
  grantor::regrole::text AS grantor,
  CASE WHEN grantee = 0 THEN 'PUBLIC' ELSE grantee::regrole::text END AS grantee,
  privilege_type,
  is_grantable
FROM aclexplode(
  (SELECT COALESCE(relacl, acldefault('s', relowner)) FROM pg_class WHERE oid = 's4'::regclass)
)
ORDER BY 1, 2, 3, 4;

-- Test 26: statement (line 140)
\connect d
SET client_min_messages = warning;
SET ROLE testuser;

-- Test 27: statement (line 143)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser REVOKE ALL ON SEQUENCES FROM testuser, testuser2;

-- user testuser
-- Test 28: statement (line 147)
\connect d
SET client_min_messages = warning;
SET ROLE testuser;

-- Test 29: statement (line 150)
CREATE SEQUENCE s5;

-- Test 30: query (line 154)
SELECT
  grantor::regrole::text AS grantor,
  CASE WHEN grantee = 0 THEN 'PUBLIC' ELSE grantee::regrole::text END AS grantee,
  privilege_type,
  is_grantable
FROM aclexplode(
  (SELECT COALESCE(relacl, acldefault('s', relowner)) FROM pg_class WHERE oid = 's5'::regclass)
)
ORDER BY 1, 2, 3, 4;

-- Cleanup so the file can be re-run without role dependency errors.
\connect pg_tests
SET client_min_messages = warning;
ALTER DEFAULT PRIVILEGES REVOKE ALL ON SEQUENCES FROM testuser, testuser2;
DROP TABLE IF EXISTS t;
DROP SEQUENCE IF EXISTS s5;
DROP SEQUENCE IF EXISTS s4;
DROP SEQUENCE IF EXISTS s3;
DROP SEQUENCE IF EXISTS s2;
DROP SEQUENCE IF EXISTS s;

\connect postgres
SET client_min_messages = warning;
DROP DATABASE IF EXISTS d;
DROP ROLE IF EXISTS testuser2;
DROP ROLE IF EXISTS testuser;

RESET client_min_messages;
