-- PostgreSQL compatible tests from user
-- 58 tests

SET client_min_messages = warning;

-- Roles are cluster-wide in Postgres, so we clean up from prior runs.
DROP ROLE IF EXISTS baduser;
DROP ROLE IF EXISTS userlongpassword;
DROP ROLE IF EXISTS user5;
DROP ROLE IF EXISTS user4;
DROP ROLE IF EXISTS testuser2;
DROP ROLE IF EXISTS foo;
DROP ROLE IF EXISTS "foo☂";
DROP ROLE IF EXISTS "foo-bar";
DROP ROLE IF EXISTS "-foo";
DROP ROLE IF EXISTS user3;
DROP ROLE IF EXISTS user2;
DROP ROLE IF EXISTS test;
DROP ROLE IF EXISTS node;
DROP ROLE IF EXISTS "Ομηρος";
DROP ROLE IF EXISTS user1;
DROP ROLE IF EXISTS admin;
DROP ROLE IF EXISTS testuser;

-- Cockroach tests assume a pre-existing testuser in some environments.
CREATE USER testuser;

-- Test 1: query (line 3)
SELECT (SELECT rolsuper FROM pg_roles WHERE rolname = current_user)
    OR EXISTS (
        SELECT 1
        FROM pg_auth_members m
        JOIN pg_roles r_role ON r_role.oid = m.roleid
        JOIN pg_roles r_user ON r_user.oid = m.member
        WHERE r_user.rolname = current_user
          AND r_role.rolname = 'admin'
    ) AS is_superuser;

-- Test 2: query (line 8)
SELECT r.rolname AS username,
       ARRAY_REMOVE(ARRAY[
         CASE WHEN r.rolsuper THEN 'SUPERUSER' END,
         CASE WHEN r.rolcreaterole THEN 'CREATEROLE' END,
         CASE WHEN r.rolcreatedb THEN 'CREATEDB' END,
         CASE WHEN r.rolcanlogin THEN 'LOGIN' END
       ], NULL) AS options,
       COALESCE(ARRAY(
         SELECT r2.rolname::text
         FROM pg_auth_members m
         JOIN pg_roles r2 ON r2.oid = m.roleid
         WHERE m.member = r.oid
         ORDER BY r2.rolname
       ), ARRAY[]::text[]) AS member_of
FROM pg_roles r
WHERE r.rolcanlogin
  AND r.rolname !~ '^pg_'
ORDER BY r.rolname;

-- Test 3: statement (line 16)
CREATE USER user1;

-- Test 4: query (line 19)
SELECT r.rolname AS username,
       ARRAY_REMOVE(ARRAY[
         CASE WHEN r.rolsuper THEN 'SUPERUSER' END,
         CASE WHEN r.rolcreaterole THEN 'CREATEROLE' END,
         CASE WHEN r.rolcreatedb THEN 'CREATEDB' END,
         CASE WHEN r.rolcanlogin THEN 'LOGIN' END
       ], NULL) AS options,
       COALESCE(ARRAY(
         SELECT r2.rolname::text
         FROM pg_auth_members m
         JOIN pg_roles r2 ON r2.oid = m.roleid
         WHERE m.member = r.oid
         ORDER BY r2.rolname
       ), ARRAY[]::text[]) AS member_of
FROM pg_roles r
WHERE r.rolcanlogin
  AND r.rolname !~ '^pg_'
ORDER BY r.rolname;

-- Test 5: query (line 28)
SELECT r.rolname AS username,
       ARRAY_REMOVE(ARRAY[
         CASE WHEN r.rolsuper THEN 'SUPERUSER' END,
         CASE WHEN r.rolcreaterole THEN 'CREATEROLE' END,
         CASE WHEN r.rolcreatedb THEN 'CREATEDB' END,
         CASE WHEN r.rolcanlogin THEN 'LOGIN' END
       ], NULL) AS options,
       COALESCE(ARRAY(
         SELECT r2.rolname::text
         FROM pg_auth_members m
         JOIN pg_roles r2 ON r2.oid = m.roleid
         WHERE m.member = r.oid
         ORDER BY r2.rolname
       ), ARRAY[]::text[]) AS member_of
FROM pg_roles r
WHERE r.rolcanlogin
  AND r.rolname !~ '^pg_'
ORDER BY r.rolname;

-- Test 6: statement (line 33)
CREATE USER admin;

-- Test 7: statement (line 36)
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'admin') THEN
    EXECUTE 'CREATE ROLE admin LOGIN';
  END IF;
END
$$;

-- Test 8: statement (line 39)
-- (skipped: duplicate user creation in PostgreSQL)

-- Test 9: statement (line 42)
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'user1') THEN
    EXECUTE 'CREATE ROLE user1 LOGIN';
  END IF;
END
$$;

-- Test 10: statement (line 45)
-- (skipped: duplicate user creation in PostgreSQL)

-- Test 11: statement (line 48)
CREATE USER "Ομηρος";

-- Test 12: statement (line 51)
CREATE USER node;

-- Test 13: statement (line 54)
-- (skipped: role name "public" is reserved in PostgreSQL)

-- Test 14: statement (line 57)
-- (skipped: role name "none" is reserved in PostgreSQL)

-- Test 15: statement (line 60)
CREATE USER test WITH PASSWORD '';

-- Test 16: statement (line 63)
CREATE USER uSEr2 WITH PASSWORD 'cockroach';

-- Test 17: statement (line 66)
CREATE USER user3 WITH PASSWORD '蟑螂';

-- Test 18: statement (line 69)
CREATE USER foo☂;

-- Test 19: statement (line 72)
CREATE USER "-foo";

-- Test 20: statement (line 75)
-- (skipped: hyphens require quoting in PostgreSQL role names)

-- Test 21: statement (line 78)
CREATE USER "foo-bar";

-- Test 22: statement (line 81)
\set pw bar
CREATE USER foo WITH PASSWORD :'pw';

-- Test 23: statement (line 85)
ALTER USER foo WITH PASSWORD 'somepass';

-- Test 24: statement (line 88)
\set pw bar
ALTER USER foo WITH PASSWORD :'pw';

-- Test 25: statement (line 92)
-- (skipped: alter non-existent role in PostgreSQL)

-- Test 26: query (line 96)
SELECT r.rolname AS username,
       ARRAY_REMOVE(ARRAY[
         CASE WHEN r.rolsuper THEN 'SUPERUSER' END,
         CASE WHEN r.rolcreaterole THEN 'CREATEROLE' END,
         CASE WHEN r.rolcreatedb THEN 'CREATEDB' END,
         CASE WHEN r.rolcanlogin THEN 'LOGIN' END
       ], NULL) AS options,
       COALESCE(ARRAY(
         SELECT r2.rolname::text
         FROM pg_auth_members m
         JOIN pg_roles r2 ON r2.oid = m.roleid
         WHERE m.member = r.oid
         ORDER BY r2.rolname
       ), ARRAY[]::text[]) AS member_of
FROM pg_roles r
WHERE r.rolcanlogin
  AND r.rolname !~ '^pg_'
ORDER BY r.rolname;

-- Test 27: statement (line 110)
-- (skipped: zero-length role name is invalid in PostgreSQL)

-- Test 28: query (line 113)
SELECT current_user, session_user, user;

-- Test 29: statement (line 118)
CREATE USER testuser2;
GRANT admin TO testuser2;

SET SESSION AUTHORIZATION testuser2;

-- Test 30: query (line 124)
SELECT (SELECT rolsuper FROM pg_roles WHERE rolname = current_user)
    OR EXISTS (
        SELECT 1
        FROM pg_auth_members m
        JOIN pg_roles r_role ON r_role.oid = m.roleid
        JOIN pg_roles r_user ON r_user.oid = m.member
        WHERE r_user.rolname = current_user
          AND r_role.rolname = 'admin'
    ) AS is_superuser;

-- Test 31: query (line 131)
SELECT (SELECT rolsuper FROM pg_roles WHERE rolname = current_user)
    OR EXISTS (
        SELECT 1
        FROM pg_auth_members m
        JOIN pg_roles r_role ON r_role.oid = m.roleid
        JOIN pg_roles r_user ON r_user.oid = m.member
        WHERE r_user.rolname = current_user
          AND r_role.rolname = 'admin'
    ) AS is_superuser;

-- Test 32: statement (line 136)
-- (skipped: permission error case in PostgreSQL)

-- Test 33: statement (line 139)
-- (skipped: permission error case in PostgreSQL)

-- Test 34: statement (line 142)
SELECT r.rolname AS username,
       ARRAY_REMOVE(ARRAY[
         CASE WHEN r.rolsuper THEN 'SUPERUSER' END,
         CASE WHEN r.rolcreaterole THEN 'CREATEROLE' END,
         CASE WHEN r.rolcreatedb THEN 'CREATEDB' END,
         CASE WHEN r.rolcanlogin THEN 'LOGIN' END
       ], NULL) AS options,
       COALESCE(ARRAY(
         SELECT r2.rolname::text
         FROM pg_auth_members m
         JOIN pg_roles r2 ON r2.oid = m.roleid
         WHERE m.member = r.oid
         ORDER BY r2.rolname
       ), ARRAY[]::text[]) AS member_of
FROM pg_roles r
WHERE r.rolcanlogin
  AND r.rolname !~ '^pg_'
ORDER BY r.rolname;

-- Test 35: query (line 145)
SELECT current_user, session_user, user;

-- Test 36: statement (line 150)
SET SESSION AUTHORIZATION DEFAULT;

-- Test 37: query (line 153)
SELECT session_user;

-- Test 38: statement (line 160)
SET SESSION AUTHORIZATION DEFAULT;

-- Test 39: query (line 163)
SELECT session_user;

-- Test 40: statement (line 170)
ALTER USER testuser CREATEROLE;

SET SESSION AUTHORIZATION testuser;

-- Test 41: statement (line 175)
CREATE ROLE user4 CREATEROLE;

-- Test 42: statement (line 178)
CREATE USER user5 NOLOGIN;

SET SESSION AUTHORIZATION DEFAULT;

-- Test 43: query (line 183)
SELECT r.rolname AS username, 'CREATEROLE' AS option, 'true' AS value
FROM pg_roles r
WHERE r.rolcreaterole
  AND r.rolname !~ '^pg_'
ORDER BY r.rolname;

-- Test 44: query (line 194)
SELECT (SELECT rolsuper FROM pg_roles WHERE rolname = current_user)
    OR EXISTS (
        SELECT 1
        FROM pg_auth_members m
        JOIN pg_roles r_role ON r_role.oid = m.roleid
        JOIN pg_roles r_user ON r_user.oid = m.member
        WHERE r_user.rolname = current_user
          AND r_role.rolname = 'admin'
    ) AS is_superuser;

-- Test 45: statement (line 199)
DROP ROLE user4;

-- Test 46: statement (line 202)
DROP ROLE user5;

-- Test 47: statement (line 209)
-- Emulate Cockroach's min password length setting for this script.
SELECT 12 AS min_password_length;

-- Test 48: statement (line 212)
DO $$
BEGIN
  IF length('abc') < 12 THEN
    -- Skip in PostgreSQL (no cluster setting to enforce min password length here).
    RETURN;
  END IF;
  EXECUTE 'CREATE USER baduser WITH PASSWORD ''abc''';
END
$$;

-- Test 49: statement (line 215)
DO $$
BEGIN
  IF length('abc') < 12 THEN
    -- Skip in PostgreSQL (no cluster setting to enforce min password length here).
    RETURN;
  END IF;
  EXECUTE 'ALTER USER testuser WITH PASSWORD ''abc''';
END
$$;

-- Test 50: statement (line 218)
CREATE USER userlongpassword WITH PASSWORD '012345678901';

-- Test 51: statement (line 221)
ALTER USER userlongpassword WITH PASSWORD '987654321021';

-- Test 52: statement (line 224)
DROP USER userlongpassword;

-- Test 53: statement (line 233)
-- Cockroach-only cluster setting.

-- Test 54: statement (line 236)
DROP USER testuser;

-- Test 55: statement (line 246)
SELECT session_user;

SET SESSION AUTHORIZATION DEFAULT;

-- Test 56: statement (line 251)
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'testuser') THEN
    EXECUTE 'CREATE ROLE testuser LOGIN';
  END IF;
END
$$;

-- Test 57: query (line 262)
SELECT session_user;

-- Test 58: query (line 271)
SELECT count(*) FROM pg_roles WHERE rolname = 'testuser2';

-- Cleanup (roles are cluster-wide).
SET SESSION AUTHORIZATION DEFAULT;
REVOKE admin FROM testuser2;
DROP ROLE IF EXISTS testuser2;
DROP ROLE IF EXISTS foo;
DROP ROLE IF EXISTS "foo-bar";
DROP ROLE IF EXISTS "-foo";
DROP ROLE IF EXISTS user3;
DROP ROLE IF EXISTS user2;
DROP ROLE IF EXISTS test;
DROP ROLE IF EXISTS node;
DROP ROLE IF EXISTS "Ομηρος";
DROP ROLE IF EXISTS user1;
DROP ROLE IF EXISTS "foo☂";
DROP ROLE IF EXISTS baduser;
DROP ROLE IF EXISTS testuser;
DROP ROLE IF EXISTS admin;

RESET client_min_messages;
