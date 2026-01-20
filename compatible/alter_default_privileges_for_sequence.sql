-- PostgreSQL compatible tests from alter_default_privileges_for_sequence
-- 30 tests

-- Test 1: statement (line 1)
CREATE DATABASE d;
GRANT CREATE ON DATABASE d TO testuser

-- Test 2: statement (line 8)
USE d;

-- Test 3: statement (line 11)
CREATE SEQUENCE testuser_s;

-- Test 4: query (line 14)
SHOW GRANTS ON testuser_s;

-- Test 5: statement (line 22)
ALTER DEFAULT PRIVILEGES REVOKE ALL ON SEQUENCES FROM testuser;
ALTER DEFAULT PRIVILEGES IN SCHEMA public REVOKE ALL ON SEQUENCES FROM testuser;

-- Test 6: statement (line 26)
CREATE SEQUENCE testuser_s2;

-- Test 7: query (line 32)
SHOW GRANTS ON testuser_s2

-- Test 8: statement (line 42)
USE test;

-- Test 9: statement (line 45)
CREATE USER testuser2

-- Test 10: statement (line 48)
ALTER DEFAULT PRIVILEGES GRANT ALL ON SEQUENCES TO testuser, testuser2

-- Test 11: statement (line 51)
CREATE SEQUENCE s

-- Test 12: query (line 54)
SHOW GRANTS ON s

-- Test 13: statement (line 64)
CREATE TABLE t()

-- Test 14: query (line 67)
SHOW GRANTS ON t

-- Test 15: statement (line 75)
ALTER DEFAULT PRIVILEGES REVOKE SELECT ON SEQUENCES FROM testuser, testuser2

-- Test 16: statement (line 78)
CREATE SEQUENCE s2

-- Test 17: query (line 81)
SHOW GRANTS ON s2

-- Test 18: statement (line 104)
ALTER DEFAULT PRIVILEGES REVOKE ALL ON SEQUENCES FROM testuser, testuser2

-- Test 19: statement (line 107)
CREATE SEQUENCE s3

-- Test 20: query (line 110)
SHOW GRANTS ON s3

-- Test 21: statement (line 117)
GRANT CREATE ON DATABASE d TO testuser

user testuser

-- Test 22: statement (line 121)
USE d

-- Test 23: statement (line 124)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser REVOKE ALL ON SEQUENCES FROM testuser, testuser2

-- Test 24: statement (line 127)
CREATE SEQUENCE s4

-- Test 25: query (line 131)
SHOW GRANTS ON s4

-- Test 26: statement (line 140)
USE d

-- Test 27: statement (line 143)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser REVOKE ALL ON SEQUENCES FROM testuser, testuser2

user testuser

-- Test 28: statement (line 147)
USE d

-- Test 29: statement (line 150)
CREATE SEQUENCE s5

-- Test 30: query (line 154)
SHOW GRANTS ON s5

