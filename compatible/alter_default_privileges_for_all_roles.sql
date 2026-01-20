-- PostgreSQL compatible tests from alter_default_privileges_for_all_roles
-- 30 tests

SET client_min_messages = warning;

-- Cleanup from prior runs.
DROP TABLE IF EXISTS t7;
DROP TABLE IF EXISTS t6;
DROP TABLE IF EXISTS t5;
DROP TABLE IF EXISTS t4;
DROP TABLE IF EXISTS t3;
DROP TABLE IF EXISTS t2;
DROP TABLE IF EXISTS t;
DROP SEQUENCE IF EXISTS seq;
DROP SCHEMA IF EXISTS s CASCADE;
DROP TYPE IF EXISTS typ;

-- Default privileges can create dependencies that block DROP ROLE; revoke them if the
-- roles exist (psql-specific \gexec).
SELECT format('ALTER DEFAULT PRIVILEGES REVOKE ALL ON TABLES FROM %I;', rolname)
FROM pg_roles
WHERE rolname IN ('testuser', 'testuser2') \gexec
SELECT format('ALTER DEFAULT PRIVILEGES REVOKE ALL ON SEQUENCES FROM %I;', rolname)
FROM pg_roles
WHERE rolname IN ('testuser', 'testuser2') \gexec
SELECT format('ALTER DEFAULT PRIVILEGES REVOKE ALL ON SCHEMAS FROM %I;', rolname)
FROM pg_roles
WHERE rolname IN ('testuser', 'testuser2') \gexec
SELECT format('ALTER DEFAULT PRIVILEGES REVOKE ALL ON TYPES FROM %I;', rolname)
FROM pg_roles
WHERE rolname IN ('testuser', 'testuser2') \gexec

DROP ROLE IF EXISTS testuser2;
DROP ROLE IF EXISTS testuser;
CREATE ROLE testuser;

-- Test 1: statement (line 1)
ALTER DEFAULT PRIVILEGES GRANT SELECT ON TABLES TO testuser;

-- Test 2: statement (line 4)
CREATE TABLE t();

-- Test 3: query (line 7)
SELECT
  grantor::regrole::text AS grantor,
  CASE WHEN grantee = 0 THEN 'PUBLIC' ELSE grantee::regrole::text END AS grantee,
  privilege_type,
  is_grantable
FROM aclexplode(
  (SELECT COALESCE(relacl, acldefault('r', relowner)) FROM pg_class WHERE oid = 't'::regclass)
)
ORDER BY 1, 2, 3, 4;

-- Test 4: statement (line 15)
ALTER DEFAULT PRIVILEGES GRANT INSERT ON TABLES TO testuser;

-- Test 5: statement (line 18)
CREATE TABLE t2();

-- Test 6: query (line 23)
SELECT
  grantor::regrole::text AS grantor,
  CASE WHEN grantee = 0 THEN 'PUBLIC' ELSE grantee::regrole::text END AS grantee,
  privilege_type,
  is_grantable
FROM aclexplode(
  (SELECT COALESCE(relacl, acldefault('r', relowner)) FROM pg_class WHERE oid = 't2'::regclass)
)
ORDER BY 1, 2, 3, 4;

-- Test 7: statement (line 32)
ALTER DEFAULT PRIVILEGES REVOKE SELECT ON TABLES FROM testuser;

-- Test 8: statement (line 35)
CREATE TABLE t3();

-- Test 9: query (line 38)
SELECT
  grantor::regrole::text AS grantor,
  CASE WHEN grantee = 0 THEN 'PUBLIC' ELSE grantee::regrole::text END AS grantee,
  privilege_type,
  is_grantable
FROM aclexplode(
  (SELECT COALESCE(relacl, acldefault('r', relowner)) FROM pg_class WHERE oid = 't3'::regclass)
)
ORDER BY 1, 2, 3, 4;

-- Test 10: statement (line 46)
ALTER DEFAULT PRIVILEGES GRANT INSERT ON TABLES TO testuser;

-- Test 11: statement (line 49)
CREATE TABLE t4();

-- Test 12: query (line 54)
SELECT
  grantor::regrole::text AS grantor,
  CASE WHEN grantee = 0 THEN 'PUBLIC' ELSE grantee::regrole::text END AS grantee,
  privilege_type,
  is_grantable
FROM aclexplode(
  (SELECT COALESCE(relacl, acldefault('r', relowner)) FROM pg_class WHERE oid = 't4'::regclass)
)
ORDER BY 1, 2, 3, 4;

-- Test 13: statement (line 62)
DROP ROLE IF EXISTS testuser2;
CREATE ROLE testuser2;

-- Test 14: statement (line 65)
ALTER DEFAULT PRIVILEGES GRANT INSERT ON TABLES TO testuser, testuser2;

-- Test 15: statement (line 68)
CREATE TABLE t5();

-- Test 16: query (line 71)
SELECT
  grantor::regrole::text AS grantor,
  CASE WHEN grantee = 0 THEN 'PUBLIC' ELSE grantee::regrole::text END AS grantee,
  privilege_type,
  is_grantable
FROM aclexplode(
  (SELECT COALESCE(relacl, acldefault('r', relowner)) FROM pg_class WHERE oid = 't5'::regclass)
)
ORDER BY 1, 2, 3, 4;

-- Test 17: statement (line 80)
ALTER DEFAULT PRIVILEGES GRANT ALL ON TABLES TO testuser, testuser2;

-- Test 18: statement (line 83)
CREATE TABLE t6();

-- Test 19: query (line 86)
SELECT
  grantor::regrole::text AS grantor,
  CASE WHEN grantee = 0 THEN 'PUBLIC' ELSE grantee::regrole::text END AS grantee,
  privilege_type,
  is_grantable
FROM aclexplode(
  (SELECT COALESCE(relacl, acldefault('r', relowner)) FROM pg_class WHERE oid = 't6'::regclass)
)
ORDER BY 1, 2, 3, 4;

-- Test 20: statement (line 97)
ALTER DEFAULT PRIVILEGES REVOKE ALL ON TABLES FROM testuser, testuser2;

-- Test 21: statement (line 100)
CREATE TABLE t7();

-- Test 22: query (line 103)
SELECT
  grantor::regrole::text AS grantor,
  CASE WHEN grantee = 0 THEN 'PUBLIC' ELSE grantee::regrole::text END AS grantee,
  privilege_type,
  is_grantable
FROM aclexplode(
  (SELECT COALESCE(relacl, acldefault('r', relowner)) FROM pg_class WHERE oid = 't7'::regclass)
)
ORDER BY 1, 2, 3, 4;

-- Test 23: statement (line 115)
ALTER DEFAULT PRIVILEGES GRANT SELECT ON TABLES TO testuser;

-- user root

-- Test 24: statement (line 122)
ALTER DEFAULT PRIVILEGES GRANT ALL ON SEQUENCES TO testuser, testuser2;
ALTER DEFAULT PRIVILEGES GRANT ALL ON SCHEMAS TO testuser, testuser2;
ALTER DEFAULT PRIVILEGES GRANT ALL ON TYPES TO testuser, testuser2;

-- Test 25: statement (line 127)
CREATE SCHEMA s;

-- Test 26: query (line 130)
SELECT
  grantor::regrole::text AS grantor,
  CASE WHEN grantee = 0 THEN 'PUBLIC' ELSE grantee::regrole::text END AS grantee,
  privilege_type,
  is_grantable
FROM aclexplode(
  (SELECT COALESCE(nspacl, acldefault('n', nspowner)) FROM pg_namespace WHERE oid = 's'::regnamespace)
)
ORDER BY 1, 2, 3, 4;

-- Test 27: statement (line 139)
CREATE SEQUENCE seq;

-- Test 28: query (line 142)
SELECT
  grantor::regrole::text AS grantor,
  CASE WHEN grantee = 0 THEN 'PUBLIC' ELSE grantee::regrole::text END AS grantee,
  privilege_type,
  is_grantable
FROM aclexplode(
  (SELECT COALESCE(relacl, acldefault('s', relowner)) FROM pg_class WHERE oid = 'seq'::regclass)
)
ORDER BY 1, 2, 3, 4;

-- Test 29: statement (line 151)
CREATE TYPE typ AS ENUM ('a');

-- Test 30: query (line 154)
SELECT
  grantor::regrole::text AS grantor,
  CASE WHEN grantee = 0 THEN 'PUBLIC' ELSE grantee::regrole::text END AS grantee,
  privilege_type,
  is_grantable
FROM aclexplode(
  (SELECT COALESCE(typacl, acldefault('T', typowner)) FROM pg_type WHERE oid = 'typ'::regtype)
)
ORDER BY 1, 2, 3, 4;

-- Cleanup so the file can be re-run without role dependency errors.
ALTER DEFAULT PRIVILEGES REVOKE ALL ON TABLES FROM testuser, testuser2;
ALTER DEFAULT PRIVILEGES REVOKE ALL ON SEQUENCES FROM testuser, testuser2;
ALTER DEFAULT PRIVILEGES REVOKE ALL ON SCHEMAS FROM testuser, testuser2;
ALTER DEFAULT PRIVILEGES REVOKE ALL ON TYPES FROM testuser, testuser2;

DROP TABLE IF EXISTS t7;
DROP TABLE IF EXISTS t6;
DROP TABLE IF EXISTS t5;
DROP TABLE IF EXISTS t4;
DROP TABLE IF EXISTS t3;
DROP TABLE IF EXISTS t2;
DROP TABLE IF EXISTS t;
DROP SEQUENCE IF EXISTS seq;
DROP SCHEMA IF EXISTS s CASCADE;
DROP TYPE IF EXISTS typ;
DROP ROLE IF EXISTS testuser2;
DROP ROLE IF EXISTS testuser;

RESET client_min_messages;
