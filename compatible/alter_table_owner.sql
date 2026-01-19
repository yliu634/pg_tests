-- PostgreSQL compatible tests from alter_table_owner
-- 14 tests

-- Test 1: statement (line 1)
CREATE SCHEMA s;
CREATE TABLE t ();
CREATE TABLE s.t ();
CREATE USER testuser2

-- Test 2: statement (line 8)
ALTER TABLE t OWNER TO fake_user

-- Test 3: statement (line 14)
ALTER TABLE t OWNER TO testuser

-- Test 4: statement (line 17)
ALTER TABLE s.t OWNER TO testuser

-- Test 5: statement (line 21)
ALTER TABLE IF EXISTS does_not_exist OWNER TO testuser

-- Test 6: statement (line 24)
GRANT CREATE ON SCHEMA s TO testuser, testuser2

-- Test 7: statement (line 27)
ALTER TABLE s.t OWNER TO testuser;
ALTER TABLE t OWNER TO root;
ALTER TABLE s.t OWNER TO root

-- Test 8: statement (line 35)
ALTER TABLE t OWNER TO testuser2

-- Test 9: statement (line 39)
ALTER TABLE t OWNER TO root

-- Test 10: statement (line 45)
ALTER TABLE t OWNER TO testuser

user testuser

-- Test 11: statement (line 50)
ALTER TABLE t OWNER TO testuser2

user root

-- Test 12: statement (line 55)
GRANT testuser2 TO testuser

user testuser

-- Test 13: statement (line 60)
ALTER TABLE t OWNER TO testuser2

user root

-- Test 14: query (line 65)
SELECT tableowner FROM pg_tables WHERE schemaname = 'public' AND tablename = 't'

