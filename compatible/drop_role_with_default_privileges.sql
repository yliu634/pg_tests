-- PostgreSQL compatible tests from drop_role_with_default_privileges
-- 53 tests

-- Test 1: statement (line 1)
CREATE USER testuser1;
CREATE USER testuser2;
GRANT testuser1 TO ROOT;

-- Test 2: statement (line 6)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser1 GRANT SELECT ON TABLES TO testuser2;

-- Test 3: statement (line 9)
DROP ROLE testuser1

-- Test 4: statement (line 12)
DROP ROLE testuser2;

-- Test 5: statement (line 15)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser1 REVOKE SELECT ON TABLES FROM testuser2;
ALTER DEFAULT PRIVILEGES FOR ROLE testuser1 GRANT USAGE ON SCHEMAS TO testuser2;

-- Test 6: statement (line 19)
DROP ROLE testuser1

-- Test 7: statement (line 22)
DROP ROLE testuser2;

-- Test 8: statement (line 25)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser1 REVOKE USAGE ON SCHEMAS FROM testuser2;
ALTER DEFAULT PRIVILEGES FOR ROLE testuser1 GRANT USAGE ON TYPES TO testuser2;

-- Test 9: statement (line 29)
DROP ROLE testuser1

-- Test 10: statement (line 32)
DROP ROLE testuser2;

-- Test 11: statement (line 35)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser1 REVOKE USAGE ON TYPES FROM testuser2;
ALTER DEFAULT PRIVILEGES FOR ROLE testuser1 GRANT SELECT ON SEQUENCES TO testuser2;

-- Test 12: statement (line 39)
DROP ROLE testuser1

-- Test 13: statement (line 42)
DROP ROLE testuser2;

-- Test 14: statement (line 45)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser1 REVOKE SELECT ON TABLES FROM testuser2;
ALTER DEFAULT PRIVILEGES FOR ROLE testuser1 REVOKE USAGE ON SCHEMAS FROM testuser2;
ALTER DEFAULT PRIVILEGES FOR ROLE testuser1 REVOKE USAGE ON TYPES FROM testuser2;
ALTER DEFAULT PRIVILEGES FOR ROLE testuser1 REVOKE SELECT ON SEQUENCES FROM testuser2;

-- Test 15: statement (line 51)
DROP ROLE testuser1;

-- Test 16: statement (line 54)
DROP ROLE testuser2;

-- Test 17: statement (line 57)
CREATE USER testuser2

-- Test 18: statement (line 60)
ALTER DEFAULT PRIVILEGES FOR ALL ROLES GRANT SELECT ON TABLES TO testuser2

-- Test 19: statement (line 63)
DROP ROLE testuser2;

-- Test 20: statement (line 66)
ALTER DEFAULT PRIVILEGES FOR ALL ROLES REVOKE SELECT ON TABLES FROM testuser2;
ALTER DEFAULT PRIVILEGES FOR ALL ROLES GRANT USAGE ON SCHEMAS TO testuser2;

-- Test 21: statement (line 70)
DROP ROLE testuser2;

-- Test 22: statement (line 73)
ALTER DEFAULT PRIVILEGES FOR ALL ROLES REVOKE USAGE ON SCHEMAS FROM testuser2;
ALTER DEFAULT PRIVILEGES FOR ALL ROLES GRANT USAGE ON TYPES TO testuser2;

-- Test 23: statement (line 77)
DROP ROLE testuser2

-- Test 24: statement (line 80)
ALTER DEFAULT PRIVILEGES FOR ALL ROLES REVOKE USAGE ON TYPES FROM testuser2;
ALTER DEFAULT PRIVILEGES FOR ALL ROLES GRANT SELECT ON SEQUENCES TO testuser2;

-- Test 25: statement (line 84)
DROP ROLE testuser2

-- Test 26: statement (line 88)
CREATE ROLE testuser3;
GRANT testuser2 TO root;
GRANT testuser3 TO root;
CREATE DATABASE testdb2;
USE testdb2;
ALTER DEFAULT PRIVILEGES FOR ALL ROLES GRANT SELECT ON SEQUENCES TO testuser2;
ALTER DEFAULT PRIVILEGES FOR ROLE testuser3 GRANT SELECT ON SEQUENCES TO testuser2;
ALTER DEFAULT PRIVILEGES FOR ROLE testuser2 GRANT SELECT ON SEQUENCES TO testuser3;

-- Test 27: statement (line 98)
DROP ROLE testuser2

-- Test 28: statement (line 102)
DROP ROLE testuser2

-- Test 29: statement (line 106)
CREATE ROLE testuser4;
GRANT testuser4 TO root;

-- Test 30: statement (line 110)
ALTER DEFAULT PRIVILEGES FOR ALL ROLES IN SCHEMA PUBLIC GRANT SELECT ON SEQUENCES TO testuser4;

-- Test 31: statement (line 113)
DROP ROLE testuser4

-- Test 32: statement (line 116)
CREATE SCHEMA s;
ALTER DEFAULT PRIVILEGES FOR ALL ROLES IN SCHEMA s GRANT SELECT ON SEQUENCES TO testuser4;
ALTER DEFAULT PRIVILEGES FOR ROLE testuser3 IN SCHEMA s GRANT SELECT ON SEQUENCES TO testuser4;
ALTER DEFAULT PRIVILEGES FOR ROLE testuser4 IN SCHEMA s GRANT SELECT ON SEQUENCES TO testuser3;

-- Test 33: statement (line 122)
DROP ROLE testuser4

-- Test 34: statement (line 125)
DROP ROLE testuser4

-- Test 35: statement (line 131)
USE test;

-- Test 36: statement (line 134)
ALTER DEFAULT PRIVILEGES FOR ALL ROLES REVOKE ALL ON SEQUENCES FROM testuser2;

-- Test 37: statement (line 137)
USE testdb2;

-- Test 38: statement (line 140)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser3 REVOKE ALL ON SEQUENCES FROM testuser2;
ALTER DEFAULT PRIVILEGES FOR ROLE testuser2 REVOKE ALL ON SEQUENCES FROM testuser3;
ALTER DEFAULT PRIVILEGES FOR ALL ROLES REVOKE ALL ON SEQUENCES FROM testuser2;

-- Test 39: statement (line 145)
DROP ROLE testuser2;

-- Test 40: statement (line 149)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser3 IN SCHEMA s REVOKE ALL ON SEQUENCES FROM testuser4;
ALTER DEFAULT PRIVILEGES FOR ROLE testuser4 IN SCHEMA s REVOKE ALL ON SEQUENCES FROM testuser3;

-- Test 41: statement (line 153)
DROP ROLE testuser3;

-- Test 42: statement (line 156)
ALTER DEFAULT PRIVILEGES FOR ALL ROLES IN SCHEMA s REVOKE ALL ON SEQUENCES FROM testuser4;
ALTER DEFAULT PRIVILEGES FOR ALL ROLES IN SCHEMA public REVOKE ALL ON SEQUENCES FROM testuser4;

-- Test 43: statement (line 160)
DROP ROLE testuser4;

-- Test 44: statement (line 165)
CREATE USER not_admin WITH PASSWORD '123';
GRANT SYSTEM CREATEROLE TO not_admin;
SET ROLE not_admin;

-- Test 45: statement (line 170)
DROP USER a_user_that_does_not_exist;

-- Test 46: statement (line 173)
DROP USER IF EXISTS a_user_that_does_not_exist;

-- Test 47: statement (line 176)
SET ROLE admin;

-- Test 48: statement (line 179)
DROP USER a_user_that_does_not_exist;

-- Test 49: statement (line 182)
DROP USER IF EXISTS a_user_that_does_not_exist;

-- Test 50: statement (line 191)
CREATE ROLE self_referencing_role

-- Test 51: statement (line 194)
ALTER DEFAULT PRIVILEGES FOR ROLE self_referencing_role GRANT INSERT ON TABLES TO self_referencing_role

-- Test 52: statement (line 197)
DROP ROLE self_referencing_role

-- Test 53: query (line 200)
SELECT count(*) FROM crdb_internal.invalid_objects

