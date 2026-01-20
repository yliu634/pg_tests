-- PostgreSQL compatible tests from alter_view_owner
-- 23 tests

-- Test 1: statement (line 1)
CREATE SCHEMA s;
CREATE VIEW vx AS SELECT 1;
CREATE VIEW s.vx AS SELECT 1;
CREATE MATERIALIZED VIEW mvx AS SELECT 1;
CREATE USER testuser2

-- Test 2: statement (line 9)
ALTER VIEW vx OWNER TO fake_user

-- Test 3: statement (line 15)
ALTER VIEW vx OWNER TO testuser

-- Test 4: statement (line 18)
ALTER VIEW s.vx OWNER TO testuser

-- Test 5: statement (line 22)
ALTER VIEW IF EXISTS does_not_exist OWNER TO testuser

-- Test 6: statement (line 25)
GRANT CREATE ON SCHEMA s TO testuser, testuser2

-- Test 7: statement (line 28)
ALTER TABLE vx OWNER TO root

-- Test 8: statement (line 32)
ALTER TABLE mvx OWNER TO testuser

-- Test 9: statement (line 35)
ALTER TABLE mvx OWNER TO root

-- Test 10: statement (line 39)
ALTER SEQUENCE vx OWNER TO testuser

-- Test 11: statement (line 43)
ALTER MATERIALIZED VIEW vx OWNER TO testuser;

-- Test 12: statement (line 47)
ALTER VIEW mvx OWNER TO testuser;

-- Test 13: statement (line 50)
ALTER VIEW vx OWNER TO testuser;
ALTER MATERIALIZED VIEW mvx OWNER TO testuser;
ALTER VIEW s.vx OWNER TO testuser;
ALTER VIEW vx OWNER TO root;
ALTER MATERIALIZED VIEW mvx OWNER TO root;
ALTER VIEW s.vx OWNER TO root;

-- Test 14: statement (line 61)
ALTER VIEW vx OWNER TO testuser2

-- Test 15: statement (line 64)
ALTER MATERIALIZED VIEW mvx OWNER TO testuser2

-- Test 16: statement (line 70)
ALTER VIEW vx OWNER TO testuser

-- Test 17: statement (line 73)
ALTER MATERIALIZED VIEW mvx OWNER TO testuser

user testuser

-- Test 18: statement (line 78)
ALTER VIEW vx OWNER TO testuser2

-- Test 19: statement (line 81)
ALTER MATERIALIZED VIEW mvx OWNER TO testuser2

user root

-- Test 20: statement (line 86)
GRANT testuser2 TO testuser

user testuser

-- Test 21: statement (line 91)
ALTER VIEW vx OWNER TO testuser2

-- Test 22: statement (line 94)
ALTER MATERIALIZED VIEW mvx OWNER TO testuser2

user root

-- Test 23: query (line 99)
SELECT viewowner FROM pg_views WHERE schemaname = 'public' AND viewname = 'vx'

