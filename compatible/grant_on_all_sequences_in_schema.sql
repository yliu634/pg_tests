-- PostgreSQL compatible tests from grant_on_all_sequences_in_schema
-- 23 tests

-- Test 1: statement (line 1)
CREATE USER testuser2

-- Test 2: statement (line 4)
CREATE SCHEMA s;
CREATE SCHEMA s2;

-- Test 3: statement (line 9)
GRANT SELECT ON ALL SEQUENCES IN SCHEMA s TO testuser

-- Test 4: query (line 12)
SHOW GRANTS FOR testuser

-- Test 5: statement (line 19)
CREATE SEQUENCE s.q;
CREATE SEQUENCE s2.q;
CREATE TABLE s.t();
CREATE TABLE s2.t();

-- Test 6: statement (line 25)
SET ROLE testuser

-- Test 7: statement (line 28)
SELECT * FROM s.q;

-- Test 8: statement (line 31)
SET ROLE root

-- Test 9: statement (line 34)
GRANT SELECT ON ALL SEQUENCES IN SCHEMA s TO testuser

-- Test 10: query (line 55)
SHOW GRANTS FOR testuser

-- Test 11: statement (line 64)
GRANT USAGE ON ALL SEQUENCES IN SCHEMA s TO testuser

-- Test 12: query (line 67)
SHOW GRANTS FOR testuser

-- Test 13: statement (line 77)
GRANT SELECT ON ALL SEQUENCES IN SCHEMA s, s2 TO testuser, testuser2

-- Test 14: query (line 80)
SHOW GRANTS FOR testuser, testuser2

-- Test 15: statement (line 93)
GRANT ALL ON ALL SEQUENCES IN SCHEMA s, s2 TO testuser, testuser2

-- Test 16: query (line 96)
SHOW GRANTS FOR testuser, testuser2

-- Test 17: statement (line 108)
CREATE USER testuser3

-- Test 18: statement (line 112)
GRANT ALL ON ALL TABLES IN SCHEMA s2 TO testuser3

-- Test 19: query (line 115)
SHOW GRANTS FOR testuser3

-- Test 20: statement (line 124)
ALTER DEFAULT PRIVILEGES FOR ALL ROLES GRANT USAGE ON SEQUENCES TO testuser3;

-- Test 21: statement (line 127)
CREATE SCHEMA s3;
CREATE SCHEMA s4;
CREATE SEQUENCE s3.q;
CREATE SEQUENCE s4.q;

-- Test 22: query (line 133)
SHOW GRANTS FOR testuser, testuser2

-- Test 23: query (line 147)
SHOW GRANTS FOR testuser3

