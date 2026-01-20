-- PostgreSQL compatible tests from alter_default_privileges_for_type
-- 28 tests

SET client_min_messages = warning;

-- Cleanup from prior runs.
DROP TYPE IF EXISTS t3;
DROP TYPE IF EXISTS t2;
DROP TYPE IF EXISTS t;
DROP DATABASE IF EXISTS d;
DROP ROLE IF EXISTS testuser2;
DROP ROLE IF EXISTS testuser;
CREATE ROLE testuser;
CREATE ROLE testuser2;

-- Test 1: statement (line 1)
CREATE DATABASE d;
GRANT CREATE ON DATABASE d TO testuser;

-- Test 2: statement (line 9)
\connect d
SET client_min_messages = warning;
GRANT CREATE ON SCHEMA public TO testuser;

-- Test 3: statement (line 12)
CREATE TYPE testuser_t AS ENUM ('a');

-- Test 4: query (line 15)
SELECT
  grantor::regrole::text AS grantor,
  CASE WHEN grantee = 0 THEN 'PUBLIC' ELSE grantee::regrole::text END AS grantee,
  privilege_type,
  is_grantable
FROM aclexplode(
  (SELECT COALESCE(typacl, acldefault('T', typowner)) FROM pg_type WHERE oid = 'testuser_t'::regtype)
)
ORDER BY 1, 2, 3, 4;

-- Test 5: statement (line 24)
ALTER DEFAULT PRIVILEGES REVOKE ALL ON TYPES FROM testuser;
ALTER DEFAULT PRIVILEGES REVOKE USAGE ON TYPES FROM PUBLIC;
ALTER DEFAULT PRIVILEGES IN SCHEMA public REVOKE ALL ON TYPES FROM testuser;
ALTER DEFAULT PRIVILEGES IN SCHEMA public REVOKE USAGE ON TYPES FROM PUBLIC;

-- Test 6: statement (line 30)
CREATE TYPE testuser_t2 AS ENUM ('a');

-- Test 7: query (line 33)
SELECT
  grantor::regrole::text AS grantor,
  CASE WHEN grantee = 0 THEN 'PUBLIC' ELSE grantee::regrole::text END AS grantee,
  privilege_type,
  is_grantable
FROM aclexplode(
  (SELECT COALESCE(typacl, acldefault('T', typowner)) FROM pg_type WHERE oid = 'testuser_t2'::regtype)
)
ORDER BY 1, 2, 3, 4;

-- Test 8: statement (line 43)
\connect pg_tests
SET client_min_messages = warning;

-- Test 9: statement (line 46)
DROP ROLE IF EXISTS testuser2;
CREATE ROLE testuser2;

-- Test 10: statement (line 49)
ALTER DEFAULT PRIVILEGES GRANT ALL ON TYPES TO testuser, testuser2;

-- Test 11: statement (line 52)
CREATE TYPE t AS ENUM ('a');

-- Test 12: query (line 55)
SELECT
  grantor::regrole::text AS grantor,
  CASE WHEN grantee = 0 THEN 'PUBLIC' ELSE grantee::regrole::text END AS grantee,
  privilege_type,
  is_grantable
FROM aclexplode(
  (SELECT COALESCE(typacl, acldefault('T', typowner)) FROM pg_type WHERE oid = 't'::regtype)
)
ORDER BY 1, 2, 3, 4;

-- Test 13: statement (line 65)
ALTER DEFAULT PRIVILEGES REVOKE USAGE ON TYPES FROM testuser, testuser2;

-- Test 14: statement (line 68)
CREATE TYPE t2 AS ENUM ('a');

-- Test 15: query (line 71)
SELECT
  grantor::regrole::text AS grantor,
  CASE WHEN grantee = 0 THEN 'PUBLIC' ELSE grantee::regrole::text END AS grantee,
  privilege_type,
  is_grantable
FROM aclexplode(
  (SELECT COALESCE(typacl, acldefault('T', typowner)) FROM pg_type WHERE oid = 't2'::regtype)
)
ORDER BY 1, 2, 3, 4;

-- Test 16: statement (line 79)
ALTER DEFAULT PRIVILEGES REVOKE ALL ON TYPES FROM testuser, testuser2;

-- Test 17: statement (line 82)
CREATE TYPE t3 AS ENUM ('a');

-- Test 18: query (line 85)
SELECT
  grantor::regrole::text AS grantor,
  CASE WHEN grantee = 0 THEN 'PUBLIC' ELSE grantee::regrole::text END AS grantee,
  privilege_type,
  is_grantable
FROM aclexplode(
  (SELECT COALESCE(typacl, acldefault('T', typowner)) FROM pg_type WHERE oid = 't3'::regtype)
)
ORDER BY 1, 2, 3, 4;

-- Test 19: statement (line 93)
GRANT CREATE ON DATABASE d TO testuser;

-- user testuser
-- Test 20: statement (line 97)
\connect d
SET client_min_messages = warning;
SET ROLE testuser;

-- Test 21: statement (line 100)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser REVOKE ALL ON TYPES FROM testuser, testuser2;

-- Test 22: statement (line 103)
CREATE TYPE t4 AS ENUM ('a');

-- Test 23: query (line 106)
SELECT
  grantor::regrole::text AS grantor,
  CASE WHEN grantee = 0 THEN 'PUBLIC' ELSE grantee::regrole::text END AS grantee,
  privilege_type,
  is_grantable
FROM aclexplode(
  (SELECT COALESCE(typacl, acldefault('T', typowner)) FROM pg_type WHERE oid = 't4'::regtype)
)
ORDER BY 1, 2, 3, 4;

-- Test 24: statement (line 115)
\connect d
SET client_min_messages = warning;
SET ROLE testuser;

-- Test 25: statement (line 118)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser REVOKE ALL ON TYPES FROM testuser, testuser2;

-- user testuser
-- Test 26: statement (line 122)
\connect d
SET client_min_messages = warning;
SET ROLE testuser;

-- Test 27: statement (line 125)
CREATE TYPE t5 AS ENUM ('a');

-- Test 28: query (line 128)
SELECT
  grantor::regrole::text AS grantor,
  CASE WHEN grantee = 0 THEN 'PUBLIC' ELSE grantee::regrole::text END AS grantee,
  privilege_type,
  is_grantable
FROM aclexplode(
  (SELECT COALESCE(typacl, acldefault('T', typowner)) FROM pg_type WHERE oid = 't5'::regtype)
)
ORDER BY 1, 2, 3, 4;

-- Cleanup so the file can be re-run without role dependency errors.
\connect pg_tests
SET client_min_messages = warning;
RESET ROLE;

ALTER DEFAULT PRIVILEGES REVOKE ALL ON TYPES FROM testuser, testuser2;
DROP TYPE IF EXISTS t3;
DROP TYPE IF EXISTS t2;
DROP TYPE IF EXISTS t;

DROP OWNED BY testuser;
DROP OWNED BY testuser2;

\connect postgres
SET client_min_messages = warning;
DROP DATABASE IF EXISTS d;
DROP ROLE IF EXISTS testuser2;
DROP ROLE IF EXISTS testuser;

RESET client_min_messages;
