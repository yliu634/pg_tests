-- PostgreSQL compatible tests from alter_default_privileges_for_type
-- 28 tests

-- Test 1: statement (line 1)
CREATE DATABASE d;
GRANT CREATE ON DATABASE d TO testuser;

-- Test 2: statement (line 9)
USE d;

-- Test 3: statement (line 12)
CREATE TYPE testuser_t AS ENUM();

-- Test 4: query (line 15)
SHOW GRANTS ON TYPE testuser_t;

-- Test 5: statement (line 24)
ALTER DEFAULT PRIVILEGES REVOKE ALL ON TYPES FROM testuser;
ALTER DEFAULT PRIVILEGES REVOKE USAGE ON TYPES FROM public;
ALTER DEFAULT PRIVILEGES IN SCHEMA public REVOKE ALL ON TYPES FROM testuser;
ALTER DEFAULT PRIVILEGES IN SCHEMA public REVOKE USAGE ON TYPES FROM public;

-- Test 6: statement (line 30)
CREATE TYPE testuser_t2 AS ENUM();

-- Test 7: query (line 33)
SHOW GRANTS ON TYPE testuser_t2

-- Test 8: statement (line 43)
USE test;

-- Test 9: statement (line 46)
CREATE USER testuser2

-- Test 10: statement (line 49)
ALTER DEFAULT PRIVILEGES GRANT ALL ON TYPES TO testuser, testuser2

-- Test 11: statement (line 52)
CREATE TYPE t AS ENUM()

-- Test 12: query (line 55)
SHOW GRANTS ON TYPE t

-- Test 13: statement (line 65)
ALTER DEFAULT PRIVILEGES REVOKE USAGE ON TYPES FROM testuser, testuser2

-- Test 14: statement (line 68)
CREATE TYPE t2 AS ENUM()

-- Test 15: query (line 71)
SHOW GRANTS ON TYPE t2

-- Test 16: statement (line 79)
ALTER DEFAULT PRIVILEGES REVOKE ALL ON TYPES FROM testuser, testuser2

-- Test 17: statement (line 82)
CREATE TYPE t3 AS ENUM()

-- Test 18: query (line 85)
SHOW GRANTS ON TYPE t3

-- Test 19: statement (line 93)
GRANT CREATE ON DATABASE d TO testuser

user testuser

-- Test 20: statement (line 97)
USE d

-- Test 21: statement (line 100)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser REVOKE ALL ON TYPES FROM testuser, testuser2

-- Test 22: statement (line 103)
CREATE TYPE t4 AS ENUM()

-- Test 23: query (line 106)
SHOW GRANTS ON TYPE t4

-- Test 24: statement (line 115)
USE d

-- Test 25: statement (line 118)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser REVOKE ALL ON TYPES FROM testuser, testuser2

user testuser

-- Test 26: statement (line 122)
USE d

-- Test 27: statement (line 125)
CREATE TYPE t5 AS ENUM()

-- Test 28: query (line 128)
SHOW GRANTS ON TYPE t5

