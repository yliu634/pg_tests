-- PostgreSQL compatible tests from alter_default_privileges_for_schema
-- 32 tests

-- Test 1: statement (line 1)
CREATE DATABASE d;
GRANT CREATE ON DATABASE d TO testuser

-- Test 2: statement (line 8)
USE d;

-- Test 3: query (line 14)
SHOW GRANTS ON SCHEMA public

-- Test 4: statement (line 23)
CREATE SCHEMA testuser_s;

-- Test 5: query (line 26)
SHOW GRANTS ON SCHEMA testuser_s;

-- Test 6: statement (line 34)
ALTER DEFAULT PRIVILEGES REVOKE ALL ON SCHEMAS FROM testuser;

-- Test 7: statement (line 37)
CREATE SCHEMA testuser_s2;

-- Test 8: query (line 43)
SHOW GRANTS ON SCHEMA testuser_s2

-- Test 9: statement (line 53)
USE test;

-- Test 10: statement (line 56)
CREATE USER testuser2

-- Test 11: statement (line 59)
ALTER DEFAULT PRIVILEGES GRANT ALL ON SCHEMAS TO testuser, testuser2

-- Test 12: statement (line 62)
CREATE SCHEMA s

-- Test 13: query (line 65)
SHOW GRANTS ON SCHEMA s

-- Test 14: statement (line 74)
ALTER DEFAULT PRIVILEGES REVOKE USAGE ON SCHEMAS FROM testuser, testuser2

-- Test 15: statement (line 77)
CREATE SCHEMA s2

-- Test 16: query (line 80)
SHOW GRANTS ON SCHEMA s2

-- Test 17: statement (line 91)
ALTER DEFAULT PRIVILEGES REVOKE ALL ON SCHEMAS FROM testuser, testuser2

-- Test 18: statement (line 94)
CREATE SCHEMA s3

-- Test 19: query (line 97)
SHOW GRANTS ON SCHEMA s3

-- Test 20: statement (line 104)
GRANT CREATE ON DATABASE d TO testuser

user testuser

-- Test 21: statement (line 108)
USE d

-- Test 22: statement (line 111)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser REVOKE ALL ON SCHEMAS FROM testuser, testuser2

-- Test 23: statement (line 114)
CREATE SCHEMA s4

-- Test 24: query (line 118)
SHOW GRANTS ON SCHEMA s4

-- Test 25: statement (line 127)
USE d

-- Test 26: statement (line 130)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser REVOKE ALL ON SCHEMAS FROM testuser, testuser2

user testuser

-- Test 27: statement (line 134)
USE d

-- Test 28: statement (line 137)
CREATE SCHEMA s5

-- Test 29: query (line 141)
SHOW GRANTS ON SCHEMA s5

-- Test 30: statement (line 149)
ALTER DEFAULT PRIVILEGES GRANT ALL ON SCHEMAS TO testuser, testuser2

user root

-- Test 31: statement (line 154)
CREATE SCHEMA s_72322

-- Test 32: query (line 158)
SHOW GRANTS ON SCHEMA s_72322

