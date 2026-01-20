-- PostgreSQL compatible tests from grant_on_all_tables_in_schema
-- 22 tests

-- Test 1: statement (line 1)
CREATE USER testuser2

-- Test 2: statement (line 4)
CREATE SCHEMA s;
CREATE SCHEMA s2;

-- Test 3: statement (line 9)
GRANT SELECT ON ALL TABLES IN SCHEMA s TO testuser

-- Test 4: query (line 12)
SHOW GRANTS FOR testuser

-- Test 5: statement (line 19)
CREATE TABLE s.t();
CREATE TABLE s2.t();

-- Test 6: statement (line 23)
GRANT SELECT ON ALL TABLES IN SCHEMA s TO testuser

-- Test 7: query (line 26)
SHOW GRANTS FOR testuser

-- Test 8: statement (line 34)
GRANT SELECT ON ALL TABLES IN SCHEMA s, s2 TO testuser, testuser2

-- Test 9: query (line 37)
SHOW GRANTS FOR testuser, testuser2

-- Test 10: statement (line 48)
GRANT ALL ON ALL TABLES IN SCHEMA s, s2 TO testuser, testuser2

-- Test 11: query (line 51)
SHOW GRANTS FOR testuser, testuser2

-- Test 12: statement (line 62)
REVOKE SELECT ON ALL TABLES IN SCHEMA s, s2 FROM testuser, testuser2

-- Test 13: query (line 65)
SHOW GRANTS FOR testuser, testuser2

-- Test 14: statement (line 116)
REVOKE ALL ON ALL TABLES IN SCHEMA s, s2 FROM testuser, testuser2

-- Test 15: query (line 119)
SHOW GRANTS FOR testuser, testuser2

-- Test 16: statement (line 127)
CREATE DATABASE otherdb

-- Test 17: statement (line 130)
CREATE TABLE otherdb.public.tbl (a int)

-- Test 18: statement (line 133)
GRANT SELECT ON ALL TABLES IN SCHEMA otherdb.public TO testuser

-- Test 19: query (line 136)
SHOW GRANTS ON TABLE otherdb.public.tbl

-- Test 20: statement (line 144)
CREATE TABLE t131157 (c1 INT)

-- Test 21: statement (line 147)
GRANT ALL ON t131157 TO testuser

-- Test 22: statement (line 150)
REVOKE CREATE ON SEQUENCE t131157 FROM testuser

