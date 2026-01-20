-- PostgreSQL compatible tests from alter_default_privileges_for_all_roles
-- 30 tests

-- Test 1: statement (line 1)
ALTER DEFAULT PRIVILEGES FOR ALL ROLES GRANT SELECT ON TABLES TO testuser

-- Test 2: statement (line 4)
CREATE TABLE t()

-- Test 3: query (line 7)
SHOW GRANTS ON t

-- Test 4: statement (line 15)
ALTER DEFAULT PRIVILEGES GRANT CREATE ON TABLES TO testuser

-- Test 5: statement (line 18)
CREATE TABLE t2()

-- Test 6: query (line 23)
SHOW GRANTS ON t2

-- Test 7: statement (line 32)
ALTER DEFAULT PRIVILEGES FOR ALL ROLES REVOKE SELECT ON TABLES FROM testuser

-- Test 8: statement (line 35)
CREATE TABLE t3()

-- Test 9: query (line 38)
SHOW GRANTS ON t3

-- Test 10: statement (line 46)
ALTER DEFAULT PRIVILEGES FOR ALL ROLES GRANT CREATE ON TABLES TO testuser

-- Test 11: statement (line 49)
CREATE TABLE t4()

-- Test 12: query (line 54)
SHOW GRANTS ON t4

-- Test 13: statement (line 62)
CREATE USER testuser2

-- Test 14: statement (line 65)
ALTER DEFAULT PRIVILEGES FOR ALL ROLES GRANT CREATE ON TABLES TO testuser, testuser2

-- Test 15: statement (line 68)
CREATE TABLE t5()

-- Test 16: query (line 71)
SHOW GRANTS ON t5

-- Test 17: statement (line 80)
ALTER DEFAULT PRIVILEGES FOR ALL ROLES GRANT ALL ON TABLES TO testuser, testuser2

-- Test 18: statement (line 83)
CREATE TABLE t6()

-- Test 19: query (line 86)
SHOW GRANTS ON t6

-- Test 20: statement (line 97)
ALTER DEFAULT PRIVILEGES REVOKE ALL ON TABLES FROM testuser, testuser2

-- Test 21: statement (line 100)
CREATE TABLE t7()

-- Test 22: query (line 103)
SHOW GRANTS ON t7

-- Test 23: statement (line 115)
ALTER DEFAULT PRIVILEGES FOR ALL ROLES GRANT SELECT ON TABLES TO testuser

user root

-- Test 24: statement (line 122)
ALTER DEFAULT PRIVILEGES FOR ALL ROLES GRANT ALL ON SEQUENCES TO testuser, testuser2;
ALTER DEFAULT PRIVILEGES FOR ALL ROLES GRANT ALL ON SCHEMAS TO testuser, testuser2;
ALTER DEFAULT PRIVILEGES FOR ALL ROLES GRANT ALL ON TYPES TO testuser, testuser2;

-- Test 25: statement (line 127)
CREATE SCHEMA s

-- Test 26: query (line 130)
SHOW GRANTS ON SCHEMA s

-- Test 27: statement (line 139)
CREATE SEQUENCE seq

-- Test 28: query (line 142)
SHOW GRANTS ON seq

-- Test 29: statement (line 151)
CREATE TYPE typ AS ENUM()

-- Test 30: query (line 154)
SHOW GRANTS ON TYPE typ

