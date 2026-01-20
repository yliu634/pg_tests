-- PostgreSQL compatible tests from alter_database_owner
-- 17 tests

SET client_min_messages = warning;

-- Make this file rerunnable and avoid leaking cluster-level objects that can
-- break later tests.
DROP DATABASE IF EXISTS d;
DROP DATABASE IF EXISTS "order";
DROP ROLE IF EXISTS a;
DROP ROLE IF EXISTS b;
DROP ROLE IF EXISTS testuser2;
DROP ROLE IF EXISTS testuser;
DROP ROLE IF EXISTS fake_user;
DROP ROLE IF EXISTS root;

-- Test 1: statement (line 1)
CREATE ROLE fake_user LOGIN;
CREATE ROLE root LOGIN;
CREATE ROLE testuser LOGIN;
CREATE ROLE testuser2 LOGIN;
CREATE DATABASE d;
-- Test 2: statement (line 6)
ALTER DATABASE d OWNER TO fake_user;

-- Test 3: statement (line 10)
ALTER DATABASE d OWNER TO testuser;

-- Test 4: statement (line 13)
ALTER DATABASE d OWNER TO root;

-- Test 5: statement (line 19)
ALTER DATABASE d OWNER TO testuser;

-- Test 6: statement (line 23)
ALTER DATABASE d OWNER TO root;

-- Test 7: statement (line 29)
ALTER DATABASE d OWNER TO testuser;

-- Test 8: statement (line 34)
ALTER DATABASE d OWNER TO testuser2;

-- Test 9: statement (line 39)
GRANT testuser2 TO testuser;

-- Test 10: statement (line 44)
ALTER DATABASE d OWNER TO testuser2;

-- Test 11: statement (line 49)
ALTER USER testuser CREATEDB;

-- Test 12: statement (line 54)
ALTER DATABASE d OWNER TO testuser2;

-- Test 13: query (line 57)
SELECT r.rolname FROM pg_database d JOIN pg_roles r ON d.datdba = r.oid WHERE d.datname = 'd';

-- Test 14: statement (line 66)
CREATE ROLE a;
CREATE ROLE b;
GRANT a, b TO testuser;
ALTER DATABASE d OWNER TO a;

-- Test 15: statement (line 74)
ALTER DATABASE d OWNER TO b;

-- Test 16: query (line 77)
SELECT r.rolname FROM pg_database d JOIN pg_roles r ON d.datdba = r.oid WHERE d.datname = 'd';

-- Test 17: statement (line 85)
CREATE DATABASE "order";
ALTER DATABASE "order" OWNER TO testuser;

-- Cleanup
DROP DATABASE d;
DROP DATABASE "order";
DROP ROLE a;
DROP ROLE b;
DROP ROLE testuser2;
DROP ROLE testuser;
DROP ROLE fake_user;
DROP ROLE root;

RESET client_min_messages;
