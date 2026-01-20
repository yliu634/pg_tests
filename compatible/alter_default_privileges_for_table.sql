-- PostgreSQL compatible tests from alter_default_privileges_for_table
-- 75 tests

SET client_min_messages = warning;

-- Cleanup from prior runs (pg_tests database).
DROP VIEW IF EXISTS vx;
DROP TABLE IF EXISTS t4;
DROP TABLE IF EXISTS t3;
DROP TABLE IF EXISTS t2;
DROP TABLE IF EXISTS t;
DROP SEQUENCE IF EXISTS s4;
DROP SEQUENCE IF EXISTS s3;
DROP SEQUENCE IF EXISTS s2;
DROP SEQUENCE IF EXISTS s;
DROP DATABASE IF EXISTS d;

DROP ROLE IF EXISTS testuser3;
DROP ROLE IF EXISTS testuser2;
DROP ROLE IF EXISTS who;
DROP ROLE IF EXISTS testuser;
CREATE ROLE who;
CREATE ROLE testuser;

-- Test 1: statement (line 2)
ALTER DEFAULT PRIVILEGES FOR ROLE who GRANT SELECT ON TABLES TO testuser;

-- Test 2: statement (line 5)
ALTER DEFAULT PRIVILEGES GRANT SELECT ON TABLES TO who;

-- Test 3: statement (line 8)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser GRANT SELECT ON TABLES TO who;

-- Test 4: statement (line 11)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser GRANT SELECT ON TABLES TO testuser, who;

-- Test 5: statement (line 15)
-- PostgreSQL does not support USAGE on TABLES; use SELECT instead.
ALTER DEFAULT PRIVILEGES GRANT SELECT ON TABLES TO testuser;

-- Test 6: statement (line 19)
-- Cockroach-only: USE system

-- Test 7: statement (line 22)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser REVOKE ALL ON TABLES FROM testuser;

-- Test 8: statement (line 25)
-- Cockroach-only: RESET database

-- Test 9: statement (line 29)
CREATE DATABASE d;
GRANT CREATE ON DATABASE d TO testuser;

-- Test 10: statement (line 36)
\connect d
SET client_min_messages = warning;
GRANT CREATE ON SCHEMA public TO testuser;

-- Test 11: statement (line 39)
CREATE TABLE testuser_t ();

-- Test 12: query (line 42)
SELECT
  grantor::regrole::text AS grantor,
  CASE WHEN grantee = 0 THEN 'PUBLIC' ELSE grantee::regrole::text END AS grantee,
  privilege_type,
  is_grantable
FROM aclexplode(
  (SELECT COALESCE(relacl, acldefault('r', relowner)) FROM pg_class WHERE oid = 'testuser_t'::regclass)
)
ORDER BY 1, 2, 3, 4;

-- Test 13: statement (line 50)
ALTER DEFAULT PRIVILEGES REVOKE ALL ON TABLES FROM testuser;
ALTER DEFAULT PRIVILEGES IN SCHEMA public REVOKE ALL ON TABLES FROM testuser;

-- Test 14: statement (line 54)
CREATE TABLE testuser_t2 ();

-- Test 15: query (line 57)
SELECT
  grantor::regrole::text AS grantor,
  CASE WHEN grantee = 0 THEN 'PUBLIC' ELSE grantee::regrole::text END AS grantee,
  privilege_type,
  is_grantable
FROM aclexplode(
  (SELECT COALESCE(relacl, acldefault('r', relowner)) FROM pg_class WHERE oid = 'testuser_t2'::regclass)
)
ORDER BY 1, 2, 3, 4;

-- Test 16: statement (line 67)
\connect pg_tests
SET client_min_messages = warning;

-- Test 17: statement (line 70)
ALTER DEFAULT PRIVILEGES GRANT SELECT ON TABLES TO testuser;

-- Test 18: statement (line 73)
CREATE TABLE t ();

-- Test 19: query (line 76)
SELECT
  grantor::regrole::text AS grantor,
  CASE WHEN grantee = 0 THEN 'PUBLIC' ELSE grantee::regrole::text END AS grantee,
  privilege_type,
  is_grantable
FROM aclexplode(
  (SELECT COALESCE(relacl, acldefault('r', relowner)) FROM pg_class WHERE oid = 't'::regclass)
)
ORDER BY 1, 2, 3, 4;

-- Test 20: statement (line 84)
CREATE SEQUENCE s;

-- Test 21: statement (line 87)
CREATE VIEW vx AS SELECT 1;

-- Test 22: query (line 90)
SELECT
  grantor::regrole::text AS grantor,
  CASE WHEN grantee = 0 THEN 'PUBLIC' ELSE grantee::regrole::text END AS grantee,
  privilege_type,
  is_grantable
FROM aclexplode(
  (SELECT COALESCE(relacl, acldefault('s', relowner)) FROM pg_class WHERE oid = 's'::regclass)
)
ORDER BY 1, 2, 3, 4;

-- Test 23: query (line 97)
SELECT
  grantor::regrole::text AS grantor,
  CASE WHEN grantee = 0 THEN 'PUBLIC' ELSE grantee::regrole::text END AS grantee,
  privilege_type,
  is_grantable
FROM aclexplode(
  (SELECT COALESCE(relacl, acldefault('r', relowner)) FROM pg_class WHERE oid = 'vx'::regclass)
)
ORDER BY 1, 2, 3, 4;

-- Test 24: statement (line 105)
ALTER DEFAULT PRIVILEGES REVOKE SELECT ON TABLES FROM testuser;

-- Test 25: statement (line 108)
CREATE TABLE t2 ();

-- Test 26: query (line 111)
SELECT
  grantor::regrole::text AS grantor,
  CASE WHEN grantee = 0 THEN 'PUBLIC' ELSE grantee::regrole::text END AS grantee,
  privilege_type,
  is_grantable
FROM aclexplode(
  (SELECT COALESCE(relacl, acldefault('r', relowner)) FROM pg_class WHERE oid = 't2'::regclass)
)
ORDER BY 1, 2, 3, 4;

-- Test 27: statement (line 118)
CREATE SEQUENCE s2;

-- Test 28: query (line 121)
SELECT
  grantor::regrole::text AS grantor,
  CASE WHEN grantee = 0 THEN 'PUBLIC' ELSE grantee::regrole::text END AS grantee,
  privilege_type,
  is_grantable
FROM aclexplode(
  (SELECT COALESCE(relacl, acldefault('s', relowner)) FROM pg_class WHERE oid = 's2'::regclass)
)
ORDER BY 1, 2, 3, 4;

-- Test 29: statement (line 130)
CREATE ROLE testuser2;

-- Test 30: statement (line 133)
ALTER DEFAULT PRIVILEGES GRANT SELECT ON TABLES TO testuser, testuser2;

-- Test 31: statement (line 136)
CREATE TABLE t3 ();

-- Test 32: query (line 139)
SELECT
  grantor::regrole::text AS grantor,
  CASE WHEN grantee = 0 THEN 'PUBLIC' ELSE grantee::regrole::text END AS grantee,
  privilege_type,
  is_grantable
FROM aclexplode(
  (SELECT COALESCE(relacl, acldefault('r', relowner)) FROM pg_class WHERE oid = 't3'::regclass)
)
ORDER BY 1, 2, 3, 4;

-- Test 33: statement (line 148)
CREATE SEQUENCE s3;

-- Test 34: query (line 151)
SELECT
  grantor::regrole::text AS grantor,
  CASE WHEN grantee = 0 THEN 'PUBLIC' ELSE grantee::regrole::text END AS grantee,
  privilege_type,
  is_grantable
FROM aclexplode(
  (SELECT COALESCE(relacl, acldefault('s', relowner)) FROM pg_class WHERE oid = 's3'::regclass)
)
ORDER BY 1, 2, 3, 4;

-- Test 35: statement (line 158)
ALTER DEFAULT PRIVILEGES REVOKE SELECT ON TABLES FROM testuser, testuser2;

-- Test 36: statement (line 161)
CREATE TABLE t4 ();

-- Test 37: query (line 164)
SELECT
  grantor::regrole::text AS grantor,
  CASE WHEN grantee = 0 THEN 'PUBLIC' ELSE grantee::regrole::text END AS grantee,
  privilege_type,
  is_grantable
FROM aclexplode(
  (SELECT COALESCE(relacl, acldefault('r', relowner)) FROM pg_class WHERE oid = 't4'::regclass)
)
ORDER BY 1, 2, 3, 4;

-- Test 38: statement (line 171)
CREATE SEQUENCE s4;

-- Test 39: query (line 174)
SELECT
  grantor::regrole::text AS grantor,
  CASE WHEN grantee = 0 THEN 'PUBLIC' ELSE grantee::regrole::text END AS grantee,
  privilege_type,
  is_grantable
FROM aclexplode(
  (SELECT COALESCE(relacl, acldefault('s', relowner)) FROM pg_class WHERE oid = 's4'::regclass)
)
ORDER BY 1, 2, 3, 4;

-- Test 40: statement (line 182)
\connect d
SET client_min_messages = warning;

-- Test 41: statement (line 185)
GRANT CREATE ON DATABASE d TO testuser;

-- Test 42: statement (line 188)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser GRANT SELECT ON TABLES TO testuser, testuser2;

-- user testuser
-- Test 43: statement (line 193)
\connect d
SET client_min_messages = warning;
SET ROLE testuser;

-- Test 44: statement (line 196)
CREATE TABLE t5 ();

-- Test 45: query (line 201)
SELECT
  grantor::regrole::text AS grantor,
  CASE WHEN grantee = 0 THEN 'PUBLIC' ELSE grantee::regrole::text END AS grantee,
  privilege_type,
  is_grantable
FROM aclexplode(
  (SELECT COALESCE(relacl, acldefault('r', relowner)) FROM pg_class WHERE oid = 't5'::regclass)
)
ORDER BY 1, 2, 3, 4;

-- Test 46: statement (line 212)
\connect d
SET client_min_messages = warning;
SET ROLE testuser;

-- Test 47: statement (line 215)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser REVOKE SELECT ON TABLES FROM testuser, testuser2;

-- user testuser
-- Test 48: statement (line 220)
\connect d
SET client_min_messages = warning;
SET ROLE testuser;

-- Test 49: statement (line 223)
CREATE TABLE t6 ();

-- Test 50: query (line 226)
SELECT
  grantor::regrole::text AS grantor,
  CASE WHEN grantee = 0 THEN 'PUBLIC' ELSE grantee::regrole::text END AS grantee,
  privilege_type,
  is_grantable
FROM aclexplode(
  (SELECT COALESCE(relacl, acldefault('r', relowner)) FROM pg_class WHERE oid = 't6'::regclass)
)
ORDER BY 1, 2, 3, 4;

-- Test 51: statement (line 236)
ALTER DEFAULT PRIVILEGES GRANT ALL ON TABLES TO testuser, testuser2;

-- Test 52: statement (line 239)
CREATE TABLE t7 ();

-- Test 53: query (line 242)
SELECT
  grantor::regrole::text AS grantor,
  CASE WHEN grantee = 0 THEN 'PUBLIC' ELSE grantee::regrole::text END AS grantee,
  privilege_type,
  is_grantable
FROM aclexplode(
  (SELECT COALESCE(relacl, acldefault('r', relowner)) FROM pg_class WHERE oid = 't7'::regclass)
)
ORDER BY 1, 2, 3, 4;

-- Test 54: statement (line 251)
ALTER DEFAULT PRIVILEGES REVOKE SELECT ON TABLES FROM testuser, testuser2;

-- Test 55: statement (line 254)
CREATE TABLE t8 ();

-- Test 56: query (line 257)
SELECT
  grantor::regrole::text AS grantor,
  CASE WHEN grantee = 0 THEN 'PUBLIC' ELSE grantee::regrole::text END AS grantee,
  privilege_type,
  is_grantable
FROM aclexplode(
  (SELECT COALESCE(relacl, acldefault('r', relowner)) FROM pg_class WHERE oid = 't8'::regclass)
)
ORDER BY 1, 2, 3, 4;

-- Test 57: statement (line 289)
\connect d
SET client_min_messages = warning;
RESET ROLE;

-- Test 58: statement (line 292)
ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT SELECT ON TABLES TO testuser;

-- Test 59: statement (line 298)
CREATE ROLE testuser3;

-- Test 60: statement (line 301)
ALTER DEFAULT PRIVILEGES FOR ROLE postgres REVOKE ALL ON TABLES FROM testuser, testuser2, testuser3;
ALTER DEFAULT PRIVILEGES FOR ROLE testuser REVOKE ALL ON TABLES FROM testuser, testuser2, testuser3;

-- Test 61: statement (line 304)
ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT SELECT ON TABLES TO testuser2, testuser3;
ALTER DEFAULT PRIVILEGES FOR ROLE testuser GRANT SELECT ON TABLES TO testuser2, testuser3;

-- Test 62: statement (line 307)
CREATE TABLE t9 ();

-- Test 63: query (line 310)
SELECT
  grantor::regrole::text AS grantor,
  CASE WHEN grantee = 0 THEN 'PUBLIC' ELSE grantee::regrole::text END AS grantee,
  privilege_type,
  is_grantable
FROM aclexplode(
  (SELECT COALESCE(relacl, acldefault('r', relowner)) FROM pg_class WHERE oid = 't9'::regclass)
)
ORDER BY 1, 2, 3, 4;

-- Test 64: statement (line 321)
CREATE TABLE t10 ();

-- Test 65: query (line 324)
SELECT
  grantor::regrole::text AS grantor,
  CASE WHEN grantee = 0 THEN 'PUBLIC' ELSE grantee::regrole::text END AS grantee,
  privilege_type,
  is_grantable
FROM aclexplode(
  (SELECT COALESCE(relacl, acldefault('r', relowner)) FROM pg_class WHERE oid = 't10'::regclass)
)
ORDER BY 1, 2, 3, 4;

-- Test 66: statement (line 336)
ALTER DEFAULT PRIVILEGES FOR ROLE postgres REVOKE SELECT ON TABLES FROM testuser2, testuser3;
ALTER DEFAULT PRIVILEGES FOR ROLE testuser REVOKE SELECT ON TABLES FROM testuser2, testuser3;

-- Test 67: statement (line 339)
CREATE TABLE t11 ();

-- Test 68: query (line 342)
SELECT
  grantor::regrole::text AS grantor,
  CASE WHEN grantee = 0 THEN 'PUBLIC' ELSE grantee::regrole::text END AS grantee,
  privilege_type,
  is_grantable
FROM aclexplode(
  (SELECT COALESCE(relacl, acldefault('r', relowner)) FROM pg_class WHERE oid = 't11'::regclass)
)
ORDER BY 1, 2, 3, 4;

-- Test 69: statement (line 351)
CREATE TABLE t12 ();

-- Test 70: query (line 354)
SELECT
  grantor::regrole::text AS grantor,
  CASE WHEN grantee = 0 THEN 'PUBLIC' ELSE grantee::regrole::text END AS grantee,
  privilege_type,
  is_grantable
FROM aclexplode(
  (SELECT COALESCE(relacl, acldefault('r', relowner)) FROM pg_class WHERE oid = 't12'::regclass)
)
ORDER BY 1, 2, 3, 4;

-- Test 71: statement (line 363)
ALTER DEFAULT PRIVILEGES FOR ROLE postgres REVOKE SELECT ON TABLES FROM testuser2, testuser3;

-- Test 72: statement (line 367)
ALTER DEFAULT PRIVILEGES REVOKE SELECT ON TABLES FROM PUBLIC;

-- Test 73: query (line 375)
SELECT r.rolname AS role, m.rolname AS inheriting_member, am.admin_option AS member_is_explicit
FROM pg_auth_members am
JOIN pg_roles r ON r.oid = am.roleid
JOIN pg_roles m ON m.oid = am.member
WHERE m.rolname = 'postgres'
ORDER BY role;

-- Test 74: statement (line 383)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser GRANT ALL ON TABLES TO testuser2;

-- Test 75: statement (line 386)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser REVOKE ALL ON TABLES FROM testuser2;

-- Cleanup so the file can be re-run without role dependency errors.
\connect pg_tests
SET client_min_messages = warning;
RESET ROLE;

ALTER DEFAULT PRIVILEGES REVOKE ALL ON TABLES FROM who, testuser, testuser2, testuser3;
ALTER DEFAULT PRIVILEGES REVOKE SELECT ON TABLES FROM PUBLIC;
ALTER DEFAULT PRIVILEGES FOR ROLE who REVOKE ALL ON TABLES FROM who, testuser, testuser2, testuser3, PUBLIC;
ALTER DEFAULT PRIVILEGES FOR ROLE testuser REVOKE ALL ON TABLES FROM who, testuser, testuser2, testuser3, PUBLIC;

DROP OWNED BY who;
DROP OWNED BY testuser;
DROP OWNED BY testuser2;
DROP OWNED BY testuser3;

DROP VIEW IF EXISTS vx;
DROP TABLE IF EXISTS t4;
DROP TABLE IF EXISTS t3;
DROP TABLE IF EXISTS t2;
DROP TABLE IF EXISTS t;
DROP SEQUENCE IF EXISTS s4;
DROP SEQUENCE IF EXISTS s3;
DROP SEQUENCE IF EXISTS s2;
DROP SEQUENCE IF EXISTS s;

\connect postgres
SET client_min_messages = warning;
DROP DATABASE IF EXISTS d;
DROP ROLE IF EXISTS testuser3;
DROP ROLE IF EXISTS testuser2;
DROP ROLE IF EXISTS who;
DROP ROLE IF EXISTS testuser;

RESET client_min_messages;
