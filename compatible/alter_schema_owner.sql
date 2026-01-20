-- PostgreSQL compatible tests from alter_schema_owner
-- 17 tests

-- Test 1: statement (line 1)
CREATE SCHEMA s;
CREATE USER testuser2

-- Test 2: statement (line 6)
ALTER SCHEMA s OWNER TO testuser

-- Test 3: statement (line 9)
ALTER SCHEMA s OWNER TO root

-- Test 4: statement (line 15)
ALTER SCHEMA s OWNER TO testuser

-- Test 5: statement (line 19)
ALTER SCHEMA s OWNER TO root

-- Test 6: statement (line 25)
ALTER SCHEMA s OWNER TO testuser

user testuser

-- Test 7: statement (line 30)
ALTER SCHEMA s OWNER TO testuser2

user root

-- Test 8: statement (line 35)
GRANT testuser2 TO testuser

user testuser

-- Test 9: statement (line 40)
ALTER SCHEMA s OWNER TO testuser2

user root

-- Test 10: statement (line 45)
GRANT CREATE ON DATABASE test TO testuser

user testuser

-- Test 11: statement (line 50)
ALTER SCHEMA s OWNER TO testuser2

-- Test 12: query (line 53)
SELECT pg_get_userbyid(nspowner) FROM pg_namespace WHERE nspname = 's';

-- Test 13: statement (line 58)
ALTER SCHEMA s OWNER TO CURRENT_USER

-- Test 14: query (line 61)
SELECT pg_get_userbyid(nspowner) FROM pg_namespace WHERE nspname = 's';

-- Test 15: statement (line 66)
ALTER SCHEMA s OWNER TO testuser2

-- Test 16: statement (line 69)
ALTER SCHEMA s OWNER TO SESSION_USER

-- Test 17: query (line 72)
SELECT pg_get_userbyid(nspowner) FROM pg_namespace WHERE nspname = 's';

