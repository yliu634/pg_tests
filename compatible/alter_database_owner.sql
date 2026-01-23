-- PostgreSQL compatible tests from alter_database_owner
-- 17 tests

SET client_min_messages = warning;
\set root_user :USER

-- Ensure repeatable runs (this test creates cluster-scoped objects).
DROP DATABASE IF EXISTS d;
DROP DATABASE IF EXISTS "order";
DROP ROLE IF EXISTS testuser2;
DROP ROLE IF EXISTS testuser;
DROP ROLE IF EXISTS fake_user;
DROP ROLE IF EXISTS a;
DROP ROLE IF EXISTS b;

-- Test 1: statement (line 1)
CREATE DATABASE d;
CREATE USER testuser CREATEDB;
CREATE USER testuser2;
CREATE USER fake_user;
-- PostgreSQL requires membership in the target role to transfer ownership.
GRANT testuser2 TO testuser;

-- Test 2: statement (line 6)
ALTER DATABASE d OWNER TO fake_user;

-- Test 3: statement (line 10)
ALTER DATABASE d OWNER TO testuser;

-- Test 4: statement (line 13)
ALTER DATABASE d OWNER TO :"root_user";

-- Test 5: statement (line 19)
ALTER DATABASE d OWNER TO testuser;

-- Test 6: statement (line 23)
ALTER DATABASE d OWNER TO :"root_user";

-- Test 7: statement (line 29)
ALTER DATABASE d OWNER TO testuser;

SET ROLE testuser;

-- Test 8: statement (line 34)
ALTER DATABASE d OWNER TO testuser2;

RESET ROLE;

-- Test 9: statement (line 39)
GRANT testuser2 TO testuser;

SET ROLE testuser;

-- Test 10: statement (line 44)
ALTER DATABASE d OWNER TO testuser2;

RESET ROLE;

-- Test 11: statement (line 49)
ALTER USER testuser CREATEDB;

SET ROLE testuser;

-- Test 12: statement (line 54)
ALTER DATABASE d OWNER TO testuser2;
RESET ROLE;

-- Test 13: query (line 57)
SELECT r.rolname FROM pg_database d JOIN pg_roles r ON d.datdba = r.oid WHERE d.datname = 'd';

-- Test 14: statement (line 66)
CREATE ROLE a;
CREATE ROLE b;
GRANT a, b TO testuser;
ALTER DATABASE d OWNER TO a;

SET ROLE testuser;

-- Test 15: statement (line 74)
ALTER DATABASE d OWNER TO b;
RESET ROLE;

-- Test 16: query (line 77)
SELECT r.rolname FROM pg_database d JOIN pg_roles r ON d.datdba = r.oid WHERE d.datname = 'd';

-- Test 17: statement (line 85)
CREATE DATABASE "order";
ALTER DATABASE "order" OWNER TO testuser;

-- Cleanup cluster-scoped objects to avoid polluting other tests.
ALTER DATABASE d OWNER TO :"root_user";
ALTER DATABASE "order" OWNER TO :"root_user";
DROP DATABASE d;
DROP DATABASE "order";

DROP OWNED BY testuser2;
DROP OWNED BY testuser;
DROP ROLE testuser2;
DROP ROLE testuser;
DROP ROLE fake_user;
DROP ROLE a;
DROP ROLE b;
