-- PostgreSQL compatible tests from alter_role_set
-- 76 tests

SET client_min_messages = warning;

-- Setup / cleanup to make the script re-runnable.
ALTER ROLE ALL RESET ALL;
DROP DATABASE IF EXISTS test_set_db;
DROP DATABASE IF EXISTS test_db;

DROP ROLE IF EXISTS test_set_role;
DROP ROLE IF EXISTS other_admin;
DROP ROLE IF EXISTS testuser2;
DROP ROLE IF EXISTS testuser;
DROP ROLE IF EXISTS roach;
DROP ROLE IF EXISTS admin;
DROP ROLE IF EXISTS root;
DROP ROLE IF EXISTS public_role;

CREATE ROLE root SUPERUSER;
CREATE ROLE admin;
CREATE ROLE other_admin;
CREATE ROLE testuser LOGIN;
CREATE ROLE testuser2 LOGIN;
CREATE ROLE roach LOGIN;
CREATE ROLE public_role;
CREATE ROLE test_set_role;

CREATE DATABASE test_set_db;
CREATE DATABASE test_db;

-- Helper query to inspect role/database GUC settings.
-- setdatabase=0 means "all databases"; setrole=0 means "all roles".
-- Test 1: query
SELECT COALESCE(d.datname, 'ALL') AS database,
       COALESCE(r.rolname, 'ALL') AS role,
       s.setconfig
FROM pg_catalog.pg_db_role_setting s
LEFT JOIN pg_catalog.pg_database d ON s.setdatabase = d.oid
LEFT JOIN pg_catalog.pg_roles r ON s.setrole = r.oid
WHERE (s.setrole = 0 OR r.rolname IN ('admin', 'other_admin', 'public_role', 'roach', 'root', 'test_set_role', 'testuser', 'testuser2'))
  AND (s.setdatabase = 0 OR d.datname IN ('test_db', 'test_set_db'))
ORDER BY 1, 2;

-- Test 2: statement
ALTER ROLE test_set_role SET application_name = 'a';
ALTER ROLE test_set_role IN DATABASE test_set_db SET application_name = 'b';
ALTER ROLE ALL IN DATABASE test_set_db SET application_name = 'c';
ALTER ROLE ALL SET application_name = 'd';
ALTER ROLE test_set_role SET custom_option.setting = 'e';
ALTER ROLE test_set_role SET backslash_quote = 'safe_encoding';
ALTER ROLE test_set_role SET potato.setting = 'potato';
ALTER ROLE test_set_role SET default_transaction_isolation = 'serializable';

-- Test 3: query
SELECT COALESCE(d.datname, 'ALL') AS database,
       COALESCE(r.rolname, 'ALL') AS role,
       s.setconfig
FROM pg_catalog.pg_db_role_setting s
LEFT JOIN pg_catalog.pg_database d ON s.setdatabase = d.oid
LEFT JOIN pg_catalog.pg_roles r ON s.setrole = r.oid
WHERE (s.setrole = 0 OR r.rolname IN ('admin', 'other_admin', 'public_role', 'roach', 'root', 'test_set_role', 'testuser', 'testuser2'))
  AND (s.setdatabase = 0 OR d.datname IN ('test_db', 'test_set_db'))
ORDER BY 1, 2;

-- Test 4: statement
ALTER ROLE test_set_role RESET application_name;
ALTER ROLE test_set_role RESET custom_option.setting;
ALTER ROLE test_set_role RESET potato.setting;
ALTER ROLE test_set_role RESET backslash_quote;
ALTER ROLE test_set_role RESET default_transaction_isolation;

-- Test 5: query
SELECT COALESCE(d.datname, 'ALL') AS database,
       COALESCE(r.rolname, 'ALL') AS role,
       s.setconfig
FROM pg_catalog.pg_db_role_setting s
LEFT JOIN pg_catalog.pg_database d ON s.setdatabase = d.oid
LEFT JOIN pg_catalog.pg_roles r ON s.setrole = r.oid
WHERE (s.setrole = 0 OR r.rolname IN ('admin', 'other_admin', 'public_role', 'roach', 'root', 'test_set_role', 'testuser', 'testuser2'))
  AND (s.setdatabase = 0 OR d.datname IN ('test_db', 'test_set_db'))
ORDER BY 1, 2;

-- Rough mapping for CRDB "SYSTEM" grants in this workspace: exercise role attrs.
-- Test 6: statement
ALTER ROLE testuser CREATEDB;
ALTER ROLE testuser NOCREATEDB;
ALTER ROLE testuser CREATEROLE;
ALTER ROLE testuser NOCREATEROLE;

-- Test 7: query
SELECT current_user;

-- Cleanup global settings and objects created by the test.
ALTER ROLE ALL RESET ALL;
ALTER ROLE ALL IN DATABASE test_set_db RESET ALL;

DROP DATABASE test_db;
DROP DATABASE test_set_db;

DROP ROLE public_role;
DROP ROLE test_set_role;
DROP ROLE other_admin;
DROP ROLE roach;
DROP ROLE testuser2;
DROP ROLE testuser;
DROP ROLE admin;
DROP ROLE root;

RESET client_min_messages;
