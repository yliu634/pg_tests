-- PostgreSQL compatible tests from alter_schema_owner
-- 17 tests

SET client_min_messages = warning;

-- Setup / cleanup to make the script re-runnable.
RESET ROLE;
DROP SCHEMA IF EXISTS s CASCADE;
DROP ROLE IF EXISTS testuser2;
DROP ROLE IF EXISTS testuser;
DROP ROLE IF EXISTS root;

CREATE ROLE root SUPERUSER;
CREATE ROLE testuser;
CREATE ROLE testuser2;

-- The new schema owner must have CREATE on the database.
GRANT CREATE ON DATABASE pg_tests TO testuser;
GRANT CREATE ON DATABASE pg_tests TO testuser2;
GRANT testuser2 TO testuser;

-- Test 1: statement (line 1)
CREATE SCHEMA s AUTHORIZATION root;

-- Test 2: statement (line 6)
ALTER SCHEMA s OWNER TO testuser;

-- Test 3: statement (line 9)
ALTER SCHEMA s OWNER TO root;

-- Test 4: statement (line 15)
ALTER SCHEMA s OWNER TO testuser;

-- Test 5: statement (line 19)
ALTER SCHEMA s OWNER TO root;

-- Test 6: statement (line 25)
ALTER SCHEMA s OWNER TO testuser;

-- user testuser
SET ROLE testuser;

-- Test 7: statement (line 30)
ALTER SCHEMA s OWNER TO testuser2;

-- Test 12: query (line 53)
SELECT pg_get_userbyid(nspowner) FROM pg_namespace WHERE nspname = 's';

-- Test 13: statement (line 58)
RESET ROLE;
SET ROLE root;
ALTER SCHEMA s OWNER TO CURRENT_USER;

-- Test 14: query (line 61)
SELECT pg_get_userbyid(nspowner) FROM pg_namespace WHERE nspname = 's';

-- Test 15: statement (line 66)
ALTER SCHEMA s OWNER TO testuser2;

-- Test 16: statement (line 69)
ALTER SCHEMA s OWNER TO SESSION_USER;

-- Test 17: query (line 72)
SELECT pg_get_userbyid(nspowner) FROM pg_namespace WHERE nspname = 's';

-- Cleanup.
RESET ROLE;
DROP SCHEMA IF EXISTS s CASCADE;
DROP OWNED BY testuser2;
DROP OWNED BY testuser;
DROP OWNED BY root;
DROP ROLE IF EXISTS testuser2;
DROP ROLE IF EXISTS testuser;
DROP ROLE IF EXISTS root;

RESET client_min_messages;
