-- PostgreSQL compatible tests from grant_database
-- 37 tests

SET client_min_messages = warning;

-- CockroachDB exposes `SHOW GRANTS`. PostgreSQL does not, so this file uses
-- catalog queries (via `aclexplode`) to show effective database privileges.

-- Cleanup any leftover global objects from a previous run.
DROP DATABASE IF EXISTS a;
DROP DATABASE IF EXISTS owner_grant_option;
DROP SCHEMA IF EXISTS b CASCADE;

DROP ROLE IF EXISTS root;
DROP ROLE IF EXISTS admin;
DROP ROLE IF EXISTS readwrite;
DROP ROLE IF EXISTS "test-user";
DROP ROLE IF EXISTS testuser;
DROP ROLE IF EXISTS owner_grant_option_child;
DROP ROLE IF EXISTS other_owner;

CREATE ROLE root;
CREATE ROLE admin;
CREATE ROLE readwrite LOGIN;
CREATE ROLE "test-user" LOGIN;
CREATE ROLE testuser LOGIN;
CREATE ROLE owner_grant_option_child LOGIN;
CREATE ROLE other_owner;

-- Allow the harness user to switch into these roles with `SET ROLE`.
GRANT root, admin, readwrite, "test-user", testuser, owner_grant_option_child, other_owner TO CURRENT_USER;

-- Helper view approximating CockroachDB's `SHOW GRANTS ON DATABASE ...`.
CREATE OR REPLACE VIEW database_grants AS
SELECT
  d.datname AS database_name,
  pg_get_userbyid(a.grantee) AS grantee,
  a.privilege_type,
  CASE WHEN a.is_grantable THEN 'YES' ELSE 'NO' END AS is_grantable
FROM pg_database d
CROSS JOIN LATERAL aclexplode(COALESCE(d.datacl, acldefault('d', d.datdba))) a;

GRANT SELECT ON database_grants TO PUBLIC;

-- Test 1: statement (line 1)
CREATE DATABASE a;

-- Test 2: query (line 4)
SELECT grantee, privilege_type, is_grantable
FROM database_grants
WHERE database_name = 'a'
ORDER BY grantee, privilege_type;

-- Test 3: statement (line 12)
REVOKE CONNECT ON DATABASE a FROM root;

-- Test 4: statement (line 15)
REVOKE CONNECT ON DATABASE a FROM admin;

-- Test 5-8: statement (line 18)
GRANT ALL PRIVILEGES ON DATABASE a TO readwrite, "test-user";
GRANT ALL PRIVILEGES ON DATABASE a TO readwrite, "test-user" WITH GRANT OPTION;

-- Test 9-10: statement (line 30)
-- Postgres database privileges are CONNECT/CREATE/TEMPORARY; there is no
-- database-level SELECT. Exercise a subset grant + revoke.
GRANT CONNECT, CREATE ON DATABASE a TO readwrite;
REVOKE CONNECT, CREATE ON DATABASE a FROM readwrite;

-- Test 11: query (line 36)
SELECT grantee, privilege_type, is_grantable
FROM database_grants
WHERE database_name = 'a'
ORDER BY grantee, privilege_type;

-- Test 12: query (line 45)
SELECT grantee, privilege_type, is_grantable
FROM database_grants
WHERE database_name = 'a'
  AND grantee IN ('readwrite', 'test-user')
ORDER BY grantee, privilege_type;

-- Test 13: statement (line 52)
REVOKE CONNECT ON DATABASE a FROM "test-user", readwrite;

-- Test 14: query (line 55)
SELECT grantee, privilege_type, is_grantable
FROM database_grants
WHERE database_name = 'a'
ORDER BY grantee, privilege_type;

-- Test 15: query (line 74)
SELECT grantee, privilege_type, is_grantable
FROM database_grants
WHERE database_name = 'a'
  AND grantee IN ('readwrite', 'test-user')
ORDER BY grantee, privilege_type;

-- Test 16-22: statement (line 91)
REVOKE CREATE ON DATABASE a FROM "test-user";
REVOKE ALL PRIVILEGES ON DATABASE a FROM "test-user";
REVOKE ALL PRIVILEGES ON DATABASE a FROM readwrite, "test-user";

-- Test 23: statement (line 143)
-- PostgreSQL does not have USAGE on DATABASE; use CONNECT.
GRANT CONNECT ON DATABASE a TO testuser;

-- Test 24-27: statement (line 146)
-- Model CockroachDB's `b.t` as a schema-qualified table in the current DB.
CREATE SCHEMA b;
GRANT USAGE, CREATE ON SCHEMA b TO testuser;

SET ROLE testuser;
CREATE TABLE b.t();
RESET ROLE;

-- "SHOW GRANTS ON b.t"
SELECT grantee, privilege_type, is_grantable
FROM information_schema.table_privileges
WHERE table_schema = 'b' AND table_name = 't'
ORDER BY grantee, privilege_type;

-- Test 28: statement (line 169)
-- Simulate `SHOW GRANTS FOR invaliduser` with a stable empty result.
SELECT grantee, privilege_type, is_grantable
FROM database_grants
WHERE database_name = 'a' AND grantee = 'invaliduser'
ORDER BY grantee, privilege_type;

-- Test 29-34: statement (line 176)
GRANT testuser TO owner_grant_option_child;
ALTER ROLE testuser CREATEDB;

CREATE DATABASE owner_grant_option;
GRANT CONNECT ON DATABASE owner_grant_option TO owner_grant_option_child;

SELECT grantee, privilege_type, is_grantable
FROM database_grants
WHERE database_name = 'owner_grant_option'
ORDER BY grantee, privilege_type;

-- Test 35-37: statement (line 207)
ALTER DATABASE owner_grant_option OWNER TO other_owner;

SELECT grantee, privilege_type, is_grantable
FROM database_grants
WHERE database_name = 'owner_grant_option'
ORDER BY grantee, privilege_type;

-- Cleanup.
DROP SCHEMA b CASCADE;
DROP DATABASE a;
DROP DATABASE owner_grant_option;

DROP VIEW database_grants;

DROP ROLE other_owner;
DROP ROLE owner_grant_option_child;
DROP ROLE testuser;
DROP ROLE "test-user";
DROP ROLE readwrite;
DROP ROLE admin;
DROP ROLE root;

RESET client_min_messages;

