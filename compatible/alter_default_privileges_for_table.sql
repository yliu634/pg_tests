-- PostgreSQL compatible tests from alter_default_privileges_for_table
-- 75 tests

-- Test 1: statement (line 2)
ALTER DEFAULT PRIVILEGES FOR ROLE who GRANT SELECT ON TABLES to testuser

-- Test 2: statement (line 5)
ALTER DEFAULT PRIVILEGES GRANT SELECT ON TABLES to who

-- Test 3: statement (line 8)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser GRANT SELECT ON TABLES to who

-- Test 4: statement (line 11)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser GRANT SELECT ON TABLES to testuser, who

-- Test 5: statement (line 15)
ALTER DEFAULT PRIVILEGES GRANT USAGE ON TABLES to testuser

-- Test 6: statement (line 19)
USE system

-- Test 7: statement (line 22)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser REVOKE ALL ON TABLES FROM testuser

-- Test 8: statement (line 25)
RESET database

-- Test 9: statement (line 29)
CREATE DATABASE d;
GRANT CREATE ON DATABASE d TO testuser;

-- Test 10: statement (line 36)
USE d;

-- Test 11: statement (line 39)
CREATE TABLE testuser_t();

-- Test 12: query (line 42)
SHOW GRANTS ON testuser_t

-- Test 13: statement (line 50)
ALTER DEFAULT PRIVILEGES REVOKE ALL ON TABLES FROM testuser;
ALTER DEFAULT PRIVILEGES IN SCHEMA public REVOKE ALL ON TABLES FROM testuser;

-- Test 14: statement (line 54)
CREATE TABLE testuser_t2();

-- Test 15: query (line 57)
SHOW GRANTS ON testuser_t2

-- Test 16: statement (line 67)
USE test;

-- Test 17: statement (line 70)
ALTER DEFAULT PRIVILEGES GRANT SELECT ON TABLES to testuser

-- Test 18: statement (line 73)
CREATE TABLE t()

-- Test 19: query (line 76)
SHOW GRANTS ON t

-- Test 20: statement (line 84)
CREATE SEQUENCE s

-- Test 21: statement (line 87)
CREATE VIEW vx AS SELECT 1

-- Test 22: query (line 90)
SHOW GRANTS ON s

-- Test 23: query (line 97)
SHOW GRANTS ON vx

-- Test 24: statement (line 105)
ALTER DEFAULT PRIVILEGES REVOKE SELECT ON TABLES FROM testuser

-- Test 25: statement (line 108)
CREATE TABLE t2()

-- Test 26: query (line 111)
SHOW GRANTS ON t2

-- Test 27: statement (line 118)
CREATE SEQUENCE s2

-- Test 28: query (line 121)
SHOW GRANTS ON s2

-- Test 29: statement (line 130)
CREATE USER testuser2;

-- Test 30: statement (line 133)
ALTER DEFAULT PRIVILEGES GRANT SELECT ON TABLES TO testuser, testuser2

-- Test 31: statement (line 136)
CREATE TABLE t3()

-- Test 32: query (line 139)
SHOW GRANTS ON t3

-- Test 33: statement (line 148)
CREATE SEQUENCE s3

-- Test 34: query (line 151)
SHOW GRANTS ON s3

-- Test 35: statement (line 158)
ALTER DEFAULT PRIVILEGES REVOKE SELECT ON TABLES FROM testuser, testuser2

-- Test 36: statement (line 161)
CREATE TABLE t4()

-- Test 37: query (line 164)
SHOW GRANTS ON t4

-- Test 38: statement (line 171)
CREATE SEQUENCE s4

-- Test 39: query (line 174)
SHOW GRANTS ON s4

-- Test 40: statement (line 182)
use d

-- Test 41: statement (line 185)
GRANT CREATE ON DATABASE d TO testuser

-- Test 42: statement (line 188)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser GRANT SELECT ON TABLES to testuser, testuser2

user testuser

-- Test 43: statement (line 193)
USE d;

-- Test 44: statement (line 196)
CREATE TABLE t5()

-- Test 45: query (line 201)
SHOW GRANTS ON t5

-- Test 46: statement (line 212)
USE d;

-- Test 47: statement (line 215)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser REVOKE SELECT ON TABLES FROM testuser, testuser2

user testuser

-- Test 48: statement (line 220)
USE d;

-- Test 49: statement (line 223)
CREATE TABLE t6()

-- Test 50: query (line 226)
SHOW GRANTS ON t6

-- Test 51: statement (line 236)
ALTER DEFAULT PRIVILEGES GRANT ALL ON TABLES TO testuser, testuser2

-- Test 52: statement (line 239)
CREATE TABLE t7()

-- Test 53: query (line 242)
SHOW GRANTS ON t7

-- Test 54: statement (line 251)
ALTER DEFAULT PRIVILEGES REVOKE SELECT ON TABLES FROM testuser, testuser2

-- Test 55: statement (line 254)
CREATE TABLE t8()

-- Test 56: query (line 257)
SHOW GRANTS ON t8

-- Test 57: statement (line 289)
USE d

-- Test 58: statement (line 292)
ALTER DEFAULT PRIVILEGES FOR ROLE root GRANT SELECT ON TABLES TO testuser

-- Test 59: statement (line 298)
CREATE USER testuser3

-- Test 60: statement (line 301)
ALTER DEFAULT PRIVILEGES FOR ROLE root, testuser REVOKE ALL ON TABLES FROM testuser, testuser2, testuser3

-- Test 61: statement (line 304)
ALTER DEFAULT PRIVILEGES FOR ROLE root, testuser GRANT SELECT ON TABLES TO testuser2, testuser3

-- Test 62: statement (line 307)
CREATE TABLE t9()

-- Test 63: query (line 310)
SHOW GRANTS ON t9

-- Test 64: statement (line 321)
CREATE TABLE t10()

-- Test 65: query (line 324)
SHOW GRANTS ON t10

-- Test 66: statement (line 336)
ALTER DEFAULT PRIVILEGES FOR ROLE root, testuser REVOKE SELECT ON TABLES FROM testuser2, testuser3

-- Test 67: statement (line 339)
CREATE TABLE t11()

-- Test 68: query (line 342)
SHOW GRANTS ON t11

-- Test 69: statement (line 351)
CREATE TABLE t12()

-- Test 70: query (line 354)
SHOW GRANTS ON t12

-- Test 71: statement (line 363)
ALTER DEFAULT PRIVILEGES FOR ROLE public REVOKE SELECT ON TABLES FROM testuser2, testuser3

-- Test 72: statement (line 367)
ALTER DEFAULT PRIVILEGES REVOKE SELECT ON TABLES FROM public

-- Test 73: query (line 375)
SELECT role, inheriting_member, member_is_explicit
FROM crdb_internal.kv_inherited_role_members
WHERE inheriting_member = 'root'
ORDER BY role

-- Test 74: statement (line 383)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser GRANT ALL ON TABLES TO testuser2

-- Test 75: statement (line 386)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser REVOKE ALL ON TABLES FROM testuser2

