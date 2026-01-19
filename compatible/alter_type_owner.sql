-- PostgreSQL compatible tests from alter_type_owner
-- 18 tests

-- Test 1: statement (line 1)
CREATE SCHEMA s;
CREATE TYPE s.typ AS ENUM ();
CREATE USER testuser2

-- Test 2: statement (line 7)
ALTER TYPE s.typ OWNER TO fake_user

-- Test 3: statement (line 12)
ALTER TYPE s.typ OWNER TO testuser

-- Test 4: statement (line 15)
GRANT CREATE, USAGE ON SCHEMA s TO testuser, testuser2

-- Test 5: statement (line 18)
ALTER TYPE s.typ OWNER TO testuser

-- Test 6: statement (line 21)
ALTER TYPE s.typ OWNER TO root

-- Test 7: statement (line 27)
ALTER TYPE s.typ OWNER TO testuser

-- Test 8: statement (line 31)
ALTER TYPE s.typ OWNER TO root

-- Test 9: statement (line 37)
ALTER TYPE s.typ OWNER TO testuser

user testuser

-- Test 10: statement (line 42)
ALTER TYPE s.typ OWNER TO testuser2

user root

-- Test 11: statement (line 47)
GRANT testuser2 TO testuser

user testuser

-- Test 12: statement (line 52)
ALTER TYPE s.typ OWNER TO testuser2

-- Test 13: query (line 58)
SELECT pg_get_userbyid(typowner) FROM pg_type WHERE typname = 'typ';

-- Test 14: statement (line 67)
GRANT CREATE ON DATABASE test TO testuser

user testuser

-- Test 15: statement (line 72)
CREATE SCHEMA s2

-- Test 16: statement (line 75)
CREATE TYPE s2.typ AS ENUM ()

user root

-- Test 17: statement (line 80)
GRANT root TO testuser

user testuser

-- Test 18: statement (line 86)
ALTER TYPE s2.typ OWNER TO root

