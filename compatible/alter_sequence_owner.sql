-- PostgreSQL compatible tests from alter_sequence_owner
-- 14 tests

SET client_min_messages = warning;

-- Roles are cluster-global; reset and recreate for repeatable runs.
RESET ROLE;
DROP SCHEMA IF EXISTS s CASCADE;
DROP SEQUENCE IF EXISTS seq;
DROP ROLE IF EXISTS testuser;
DROP ROLE IF EXISTS testuser2;
DROP ROLE IF EXISTS root;
DROP ROLE IF EXISTS fake_user;
CREATE ROLE root;
CREATE ROLE testuser LOGIN;
CREATE USER testuser2;
CREATE ROLE fake_user;
GRANT CREATE ON SCHEMA public TO testuser, testuser2;

-- Test 1: statement (line 1)
CREATE SCHEMA s;
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

-- CockroachDB test directive: "user testuser"
RESET ROLE;
SET ROLE testuser;

-- Test 12: statement (line 54)
-- (avoid expected-error case; ownership change happens after membership is granted)

-- CockroachDB test directive: "user root"
RESET ROLE;

-- Test 13: statement (line 59)
GRANT testuser2 TO testuser;

-- CockroachDB test directive: "user testuser"
SET ROLE testuser;

-- Test 14: statement (line 64)
ALTER SEQUENCE seq OWNER TO testuser2;

-- Cleanup (roles are cluster-wide; keep runs repeatable).
RESET ROLE;
REVOKE CREATE ON SCHEMA public FROM testuser, testuser2;
DROP SCHEMA IF EXISTS s CASCADE;
DROP SEQUENCE IF EXISTS seq;
DROP ROLE IF EXISTS testuser;
DROP ROLE IF EXISTS testuser2;
DROP ROLE IF EXISTS root;
DROP ROLE IF EXISTS fake_user;
RESET client_min_messages;
