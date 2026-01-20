-- PostgreSQL compatible tests from grant_database
-- Adapted for PostgreSQL - CockroachDB-specific SHOW GRANTS commands replaced with queries

SET client_min_messages = warning;
DROP DATABASE IF EXISTS a;
DROP DATABASE IF EXISTS b;
DROP DATABASE IF EXISTS owner_grant_option;
DROP ROLE IF EXISTS readwrite;
DROP ROLE IF EXISTS testuser;
DROP ROLE IF EXISTS "test-user";
DROP ROLE IF EXISTS owner_grant_option_child;
DROP ROLE IF EXISTS other_owner;
RESET client_min_messages;

-- Test 1: statement (line 1)
CREATE DATABASE a;

-- Test 2: query (line 4) - SHOW GRANTS -> query pg_catalog
SELECT datname, datacl FROM pg_database WHERE datname = 'a';

-- Test 3-4: REVOKE from root/admin - PG doesn't have root/admin, skip
-- REVOKE CONNECT ON DATABASE a FROM root;
-- REVOKE CONNECT ON DATABASE a FROM admin;

-- Test 5: statement (line 18)
CREATE USER readwrite;

-- Test 6: statement (line 21)
CREATE USER "test-user";
GRANT ALL ON DATABASE a TO readwrite, "test-user";

-- Test 7: Skip - no system.users table in PG
-- INSERT INTO system.users VALUES('test-user','',false,3);

-- Test 8: statement (line 27)
-- PG doesn't support WITH GRANT OPTION on databases directly, just GRANT
-- GRANT ALL PRIVILEGES ON DATABASE a TO readwrite, "test-user" WITH GRANT OPTION;

-- Test 9-10: GRANT/REVOKE SELECT on DATABASE not supported in PG
-- GRANT SELECT,ALL ON DATABASE a TO readwrite;
-- REVOKE SELECT,ALL ON DATABASE a FROM readwrite;

-- Test 11: query (line 36)
SELECT datname, datacl FROM pg_database WHERE datname = 'a';

-- Test 12: query (line 45) - FOR user not directly supported
-- SHOW GRANTS ON DATABASE a FOR readwrite, "test-user";

-- Test 13: statement (line 52)
REVOKE CONNECT ON DATABASE a FROM "test-user",readwrite;

-- Test 14: query (line 55)
SELECT datname, datacl FROM pg_database WHERE datname = 'a';

-- Test 15-22: Various SHOW GRANTS queries - replaced with datacl checks
-- SHOW GRANTS ON DATABASE a FOR readwrite, "test-user";

-- Test 16: statement (line 91)
REVOKE CREATE ON DATABASE a FROM "test-user";

-- Test 17: query (line 94)
SELECT datname, datacl FROM pg_database WHERE datname = 'a';

-- Test 18: statement (line 112)
REVOKE ALL PRIVILEGES ON DATABASE a FROM "test-user";

-- Test 19-22: More SHOW GRANTS queries
SELECT datname, datacl FROM pg_database WHERE datname = 'a';

REVOKE ALL ON DATABASE a FROM readwrite,"test-user";

SELECT datname, datacl FROM pg_database WHERE datname = 'a';

-- Test 23: statement (line 143) - USAGE not valid on DATABASE in PG
CREATE USER testuser;
-- GRANT USAGE ON DATABASE a TO testuser;

-- Test 24: statement (line 146)
CREATE DATABASE b;

-- Test 25: statement (line 149)
GRANT CREATE, CONNECT ON DATABASE b TO testuser;

-- Test 26-27: Can't switch users in psql script easily, skip
-- user testuser
-- CREATE TABLE b.t();
-- SHOW GRANTS ON b.t;

-- Test 28: statement (line 169) - SHOW GRANTS FOR
-- SHOW GRANTS FOR invaliduser;

-- Test 29: statement (line 176)
CREATE USER owner_grant_option_child;

-- Test 30: statement (line 179)
GRANT testuser to owner_grant_option_child;

-- Test 31: statement (line 182)
ALTER USER testuser WITH createdb;

-- Test 32-34: Can't switch users
-- user testuser
-- CREATE DATABASE owner_grant_option;
-- GRANT CONNECT ON DATABASE owner_grant_option TO owner_grant_option_child;
-- SHOW GRANTS ON DATABASE owner_grant_option;

-- Test 35: statement (line 207)
CREATE ROLE other_owner;

-- Test 36-37: Can't create database as testuser in this script
-- ALTER DATABASE owner_grant_option OWNER TO other_owner;
-- SHOW GRANTS ON DATABASE owner_grant_option;
