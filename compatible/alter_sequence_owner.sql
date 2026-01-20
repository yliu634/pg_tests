-- PostgreSQL compatible tests from alter_sequence_owner
-- 14 tests

SET client_min_messages = warning;

-- Setup / cleanup to make the script re-runnable.
RESET ROLE;
DROP SEQUENCE IF EXISTS seq;
DROP SCHEMA IF EXISTS s CASCADE;
DROP ROLE IF EXISTS fake_user;
DROP ROLE IF EXISTS testuser2;
DROP ROLE IF EXISTS testuser;
DROP ROLE IF EXISTS root;

CREATE ROLE root SUPERUSER;
CREATE ROLE testuser;
CREATE ROLE testuser2;
CREATE ROLE fake_user;

-- Ensure potential owners can own objects in the schemas used.
GRANT USAGE, CREATE ON SCHEMA public TO testuser, testuser2, fake_user;
CREATE SCHEMA s AUTHORIZATION root;
GRANT USAGE, CREATE ON SCHEMA s TO testuser, testuser2, fake_user;

-- Test 1: statement (line 1)
CREATE SEQUENCE seq;
CREATE SEQUENCE s.seq;

-- Test 2: statement (line 8)
ALTER SEQUENCE seq OWNER TO fake_user;

-- Test 3: statement (line 14)
ALTER SEQUENCE seq OWNER TO testuser;

-- Test 4: statement (line 17)
ALTER SEQUENCE s.seq OWNER TO testuser;

-- Test 5: statement (line 21)
ALTER SEQUENCE IF EXISTS does_not_exist OWNER TO testuser;

-- Test 6: statement (line 24)
GRANT CREATE ON SCHEMA s TO testuser, testuser2;

-- Test 7: statement (line 27)
ALTER SEQUENCE seq OWNER TO root;

-- Test 8: statement (line 31)
ALTER SEQUENCE seq OWNER TO testuser;

-- Test 9: statement (line 34)
ALTER SEQUENCE seq OWNER TO testuser;
ALTER SEQUENCE s.seq OWNER TO testuser;
ALTER SEQUENCE seq OWNER TO root;
ALTER SEQUENCE s.seq OWNER TO root;

-- Test 10: statement (line 43)
ALTER SEQUENCE seq OWNER TO testuser2;

-- Test 11: statement (line 49)
ALTER SEQUENCE seq OWNER TO testuser;

-- user root
-- Allow the current owner to transfer ownership to testuser2.
GRANT testuser2 TO testuser;

-- user testuser
SET ROLE testuser;

-- Test 12: statement (line 54)
ALTER SEQUENCE seq OWNER TO testuser2;

-- Cleanup.
RESET ROLE;
DROP SEQUENCE IF EXISTS s.seq;
DROP SEQUENCE IF EXISTS seq;
DROP SCHEMA IF EXISTS s CASCADE;
DROP OWNED BY fake_user;
DROP OWNED BY testuser2;
DROP OWNED BY testuser;
DROP OWNED BY root;
DROP ROLE IF EXISTS fake_user;
DROP ROLE IF EXISTS testuser2;
DROP ROLE IF EXISTS testuser;
DROP ROLE IF EXISTS root;

RESET client_min_messages;
