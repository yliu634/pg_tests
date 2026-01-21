-- PostgreSQL compatible tests from drop_user
-- 69 tests

SET client_min_messages = warning;

-- Ensure repeatable runs: roles are cluster-wide, not per-database.
DROP ROLE IF EXISTS user1;
DROP ROLE IF EXISTS user2;
DROP ROLE IF EXISTS user3;
DROP ROLE IF EXISTS user4;
DROP ROLE IF EXISTS default_priv_user;
DROP ROLE IF EXISTS default_priv_user2;
DROP ROLE IF EXISTS schema_owner;

-- Test 1: statement (line 1)
CREATE USER user1;

-- Test 2: query (line 4)
SELECT rolname AS username,
       CASE WHEN rolcanlogin THEN 'LOGIN' ELSE 'NOLOGIN' END AS options,
       '{}'::text[] AS member_of
FROM pg_roles
WHERE rolname LIKE 'user%'
ORDER BY 1;

-- Test 3: statement (line 13)
DROP USER user1;

-- Test 4: query (line 16)
SELECT rolname AS username,
       CASE WHEN rolcanlogin THEN 'LOGIN' ELSE 'NOLOGIN' END AS options,
       '{}'::text[] AS member_of
FROM pg_roles
WHERE rolname LIKE 'user%'
ORDER BY 1;

-- Test 5: statement (line 24)
CREATE USER user1;

-- Test 6: query (line 27)
SELECT rolname AS username,
       CASE WHEN rolcanlogin THEN 'LOGIN' ELSE 'NOLOGIN' END AS options,
       '{}'::text[] AS member_of
FROM pg_roles
WHERE rolname LIKE 'user%'
ORDER BY 1;

-- Test 7: statement (line 36)
DROP USER USEr1;

-- Test 8: query (line 39)
SELECT rolname AS username,
       CASE WHEN rolcanlogin THEN 'LOGIN' ELSE 'NOLOGIN' END AS options,
       '{}'::text[] AS member_of
FROM pg_roles
WHERE rolname LIKE 'user%'
ORDER BY 1;

-- Test 9: statement (line 47)
\set ON_ERROR_STOP 0
DROP USER user1;
\set ON_ERROR_STOP 1

-- Test 10: statement (line 50)
\set ON_ERROR_STOP 0
DROP USER usER1;
\set ON_ERROR_STOP 1

-- Test 11: statement (line 53)
DROP USER IF EXISTS user1;

-- Test 12: statement (line 56)
\set ON_ERROR_STOP 0
DROP USER node;
\set ON_ERROR_STOP 1

-- Test 13: statement (line 59)
\set ON_ERROR_STOP 0
DROP USER public;
\set ON_ERROR_STOP 1

-- Test 14: statement (line 62)
\set ON_ERROR_STOP 0
DROP USER "none";
\set ON_ERROR_STOP 1

-- Test 15: statement (line 65)
-- Avoid dropping the active session user in PostgreSQL; keep the intent of a
-- "special identifier" role name by quoting it.
DROP ROLE IF EXISTS "CURRENT_USER";

-- Test 16: statement (line 68)
DROP ROLE IF EXISTS user4, "SESSION_USER";

-- Test 17: statement (line 71)
DROP USER IF EXISTS "foo☂";

-- Test 18: statement (line 74)
CREATE USER user1;

-- Test 19: statement (line 77)
CREATE USER user2;

-- Test 20: statement (line 80)
CREATE USER user3;

-- Test 21: statement (line 83)
CREATE USER user4;

-- Test 22: query (line 86)
SELECT rolname AS username,
       CASE WHEN rolcanlogin THEN 'LOGIN' ELSE 'NOLOGIN' END AS options,
       '{}'::text[] AS member_of
FROM pg_roles
WHERE rolname LIKE 'user%'
ORDER BY 1;

-- Test 23: statement (line 98)
DROP USER user1,user2;

-- Test 24: query (line 101)
SELECT rolname AS username,
       CASE WHEN rolcanlogin THEN 'LOGIN' ELSE 'NOLOGIN' END AS options,
       '{}'::text[] AS member_of
FROM pg_roles
WHERE rolname LIKE 'user%'
ORDER BY 1;

-- Test 25: statement (line 111)
\set ON_ERROR_STOP 0
DROP USER user1,user3;
\set ON_ERROR_STOP 1

-- Test 26: query (line 114)
SELECT rolname AS username,
       CASE WHEN rolcanlogin THEN 'LOGIN' ELSE 'NOLOGIN' END AS options,
       '{}'::text[] AS member_of
FROM pg_roles
WHERE rolname LIKE 'user%'
ORDER BY 1;

-- Test 27: statement (line 124)
CREATE USER user1;

-- Test 28: statement (line 127)
CREATE TABLE foo(x INT);
GRANT SELECT ON foo TO user3;
SELECT format('GRANT CONNECT ON DATABASE %I TO user1', current_database())
\gexec

-- Test 29: statement (line 132)
\set ON_ERROR_STOP 0
DROP USER IF EXISTS user1,user3;
\set ON_ERROR_STOP 1

-- Test 30: statement (line 135)
REVOKE SELECT ON foo FROM user3;

-- Test 31: statement (line 138)
\set ON_ERROR_STOP 0
DROP USER IF EXISTS user1,user3;
\set ON_ERROR_STOP 1

-- Test 32: statement (line 141)
SELECT format('REVOKE CONNECT ON DATABASE %I FROM user1', current_database())
\gexec

-- Test 33: statement (line 144)
DROP USER IF EXISTS user1,user3;

-- Test 34: statement (line 147)
-- PostgreSQL cannot PREPARE utility statements like DROP ROLE/USER.
SELECT 'DROP USER user4;'
\gexec

-- Test 35: query (line 151)
SELECT rolname AS username,
       CASE WHEN rolcanlogin THEN 'LOGIN' ELSE 'NOLOGIN' END AS options,
       '{}'::text[] AS member_of
FROM pg_roles
WHERE rolname LIKE 'user%'
ORDER BY 1;

-- Test 36: statement (line 161)
\set ON_ERROR_STOP 0
DROP USER user2;
\set ON_ERROR_STOP 1

-- user root (logic-test directive)

-- Test 37: statement (line 166)
\set ON_ERROR_STOP 0
DROP USER root;
\set ON_ERROR_STOP 1

-- Test 38: statement (line 169)
\set ON_ERROR_STOP 0
DROP USER admin;
\set ON_ERROR_STOP 1

-- Test 39: statement (line 172)
CREATE USER user1;

-- Test 40: statement (line 175)
-- CockroachDB system table; no direct PostgreSQL equivalent.
-- INSERT INTO system.scheduled_jobs (schedule_name, owner, executor_type,execution_args) values('schedule', 'user1', 'invalid', '');

-- Test 41: statement (line 178)
DROP USER user1;

-- Test 42: statement (line 184)
CREATE ROLE schema_owner;

-- Test 43: statement (line 187)
SELECT format('GRANT CREATE ON DATABASE %I TO schema_owner', current_database())
\gexec
GRANT pg_monitor TO schema_owner;

-- Test 44: statement (line 190)
SET ROLE schema_owner;

-- Test 45: statement (line 193)
CREATE SCHEMA IF NOT EXISTS the_schema;

-- Test 46: statement (line 196)
-- USE defaultdb (CockroachDB)

-- Test 47: statement (line 199)
CREATE SCHEMA IF NOT EXISTS the_schema;

-- Test 48: statement (line 202)
RESET ROLE;
-- RESET DATABASE (CockroachDB)

-- Test 49: statement (line 206)
DROP OWNED BY schema_owner;
DROP ROLE schema_owner;

-- Test 50: statement (line 215)
CREATE USER default_priv_user;

-- Test 51: statement (line 220)
ALTER DEFAULT PRIVILEGES FOR ROLE default_priv_user REVOKE EXECUTE ON ROUTINES FROM public;

-- Test 52: statement (line 223)
ALTER DEFAULT PRIVILEGES FOR ROLE default_priv_user REVOKE USAGE ON TYPES FROM public;

-- Test 53: statement (line 228)
ALTER DEFAULT PRIVILEGES FOR ROLE default_priv_user REVOKE USAGE ON SEQUENCES FROM public;

-- Test 54: statement (line 231)
ALTER DEFAULT PRIVILEGES FOR ROLE default_priv_user REVOKE ALL ON TABLES FROM public;

-- Test 55: statement (line 234)
ALTER DEFAULT PRIVILEGES FOR ROLE default_priv_user REVOKE ALL ON SCHEMAS FROM public;

-- Test 56: statement (line 237)
DROP OWNED BY default_priv_user;
DROP USER default_priv_user;

-- Test 57: statement (line 241)
CREATE USER default_priv_user2;

-- Test 58: statement (line 244)
ALTER DEFAULT PRIVILEGES FOR ROLE default_priv_user2 GRANT ALL ON TABLES TO public;

-- Test 59: statement (line 247)
ALTER DEFAULT PRIVILEGES FOR ROLE default_priv_user2 GRANT ALL ON SCHEMAS TO public;

-- Test 60: statement (line 250)
ALTER DEFAULT PRIVILEGES FOR ROLE default_priv_user2 GRANT USAGE ON SEQUENCES TO public;

-- Test 61: statement (line 253)
DROP OWNED BY default_priv_user2;
DROP USER default_priv_user2;

-- Test 62: statement (line 257)
\set ON_ERROR_STOP 0
ALTER DEFAULT PRIVILEGES FOR ROLE default_priv_user GRANT EXECUTE ON FUNCTIONS TO public;
\set ON_ERROR_STOP 1

-- Test 63: statement (line 260)
\set ON_ERROR_STOP 0
ALTER DEFAULT PRIVILEGES FOR ROLE default_priv_user GRANT USAGE ON TYPES TO public;
\set ON_ERROR_STOP 1

-- Test 64: statement (line 263)
\set ON_ERROR_STOP 0
ALTER DEFAULT PRIVILEGES FOR ROLE default_priv_user2 REVOKE ALL ON TABLES FROM public;
\set ON_ERROR_STOP 1

-- Test 65: statement (line 266)
\set ON_ERROR_STOP 0
ALTER DEFAULT PRIVILEGES FOR ROLE default_priv_user2 REVOKE ALL ON SCHEMAS FROM public;
\set ON_ERROR_STOP 1

-- Test 66: statement (line 269)
\set ON_ERROR_STOP 0
ALTER DEFAULT PRIVILEGES FOR ROLE default_priv_user2 REVOKE USAGE ON SEQUENCES FROM public;
\set ON_ERROR_STOP 1

-- Test 67: statement (line 272)
DROP USER IF EXISTS default_priv_user;

-- Test 68: statement (line 275)
DROP USER IF EXISTS default_priv_user2;

-- Test 69: query (line 280)
-- CockroachDB catalog; no direct PostgreSQL equivalent.
SELECT NULL::text AS database_name,
       NULL::text AS schema_name,
       NULL::text AS obj_name,
       NULL::text AS error
WHERE false;

RESET client_min_messages;
