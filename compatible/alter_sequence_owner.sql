-- PostgreSQL compatible tests from alter_sequence_owner
-- 14 tests

-- Test 1: statement (line 1)
CREATE SCHEMA s;
CREATE SEQUENCE seq;
CREATE SEQUENCE s.seq;
CREATE USER testuser2

-- Test 2: statement (line 8)
ALTER SEQUENCE seq OWNER TO fake_user

-- Test 3: statement (line 14)
ALTER SEQUENCE seq OWNER TO testuser

-- Test 4: statement (line 17)
ALTER SEQUENCE s.seq OWNER TO testuser

-- Test 5: statement (line 21)
ALTER SEQUENCE IF EXISTS does_not_exist OWNER TO testuser

-- Test 6: statement (line 24)
GRANT CREATE ON SCHEMA s TO testuser, testuser2

-- Test 7: statement (line 27)
ALTER TABLE seq OWNER TO root

-- Test 8: statement (line 31)
ALTER VIEW seq OWNER TO testuser

-- Test 9: statement (line 34)
ALTER SEQUENCE seq OWNER TO testuser;
ALTER SEQUENCE s.seq OWNER TO testuser;
ALTER SEQUENCE seq OWNER TO root;
ALTER SEQUENCE s.seq OWNER TO root;

-- Test 10: statement (line 43)
ALTER SEQUENCE seq OWNER TO testuser2

-- Test 11: statement (line 49)
ALTER SEQUENCE seq OWNER TO testuser

user testuser

-- Test 12: statement (line 54)
ALTER SEQUENCE seq OWNER TO testuser2

user root

-- Test 13: statement (line 59)
GRANT testuser2 TO testuser

user testuser

-- Test 14: statement (line 64)
ALTER SEQUENCE seq OWNER TO testuser2

