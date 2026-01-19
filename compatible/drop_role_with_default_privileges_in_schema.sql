-- PostgreSQL compatible tests from drop_role_with_default_privileges_in_schema
-- 29 tests

-- Test 1: statement (line 3)
CREATE ROLE test1;
CREATE ROLE test2;
GRANT test1, test2 TO root;

-- Test 2: statement (line 8)
ALTER DEFAULT PRIVILEGES FOR ROLE test1 IN SCHEMA public GRANT SELECT ON TABLES TO test2;

-- Test 3: statement (line 11)
DROP ROLE test1

-- Test 4: statement (line 14)
DROP ROLE test2;

-- Test 5: statement (line 17)
ALTER DEFAULT PRIVILEGES FOR ROLE test1 IN SCHEMA public REVOKE ALL ON TABLES FROM test2;
ALTER DEFAULT PRIVILEGES FOR ROLE test1 IN SCHEMA public REVOKE ALL ON TYPES FROM test2;
ALTER DEFAULT PRIVILEGES FOR ROLE test1 IN SCHEMA public REVOKE ALL ON SEQUENCES FROM test2;

-- Test 6: statement (line 22)
DROP ROLE test1;

-- Test 7: statement (line 25)
DROP ROLE test2;

-- Test 8: statement (line 28)
CREATE USER test2

-- Test 9: statement (line 31)
ALTER DEFAULT PRIVILEGES FOR ALL ROLES IN SCHEMA public GRANT SELECT ON TABLES TO test2

-- Test 10: statement (line 34)
DROP ROLE test2;

-- Test 11: statement (line 37)
ALTER DEFAULT PRIVILEGES FOR ALL ROLES IN SCHEMA public REVOKE SELECT ON TABLES FROM test2;
ALTER DEFAULT PRIVILEGES FOR ALL ROLES IN SCHEMA public GRANT USAGE ON TYPES TO test2;

-- Test 12: statement (line 41)
DROP ROLE test2

-- Test 13: statement (line 44)
ALTER DEFAULT PRIVILEGES FOR ALL ROLES IN SCHEMA public REVOKE USAGE ON TYPES FROM test2;
ALTER DEFAULT PRIVILEGES FOR ALL ROLES IN SCHEMA public GRANT SELECT ON SEQUENCES TO test2;

-- Test 14: statement (line 48)
DROP ROLE test2

-- Test 15: statement (line 53)
CREATE SCHEMA s

-- Test 16: statement (line 56)
CREATE ROLE test3;
CREATE ROLE test4;
GRANT test3, test4 TO root;

-- Test 17: statement (line 61)
ALTER DEFAULT PRIVILEGES FOR ROLE test3 IN SCHEMA s GRANT SELECT ON TABLES TO test4;

-- Test 18: statement (line 64)
DROP ROLE test3

-- Test 19: statement (line 67)
DROP ROLE test4;

-- Test 20: statement (line 70)
ALTER DEFAULT PRIVILEGES FOR ROLE test3 IN SCHEMA s REVOKE ALL ON TABLES FROM test4;
ALTER DEFAULT PRIVILEGES FOR ROLE test3 IN SCHEMA s REVOKE ALL ON TYPES FROM test4;
ALTER DEFAULT PRIVILEGES FOR ROLE test3 IN SCHEMA s REVOKE ALL ON SEQUENCES FROM test4;

-- Test 21: statement (line 75)
DROP ROLE test3;

-- Test 22: statement (line 78)
DROP ROLE test4;

-- Test 23: statement (line 81)
CREATE USER test4

-- Test 24: statement (line 84)
ALTER DEFAULT PRIVILEGES FOR ALL ROLES IN SCHEMA s GRANT SELECT ON TABLES TO test4

-- Test 25: statement (line 87)
DROP ROLE test4;

-- Test 26: statement (line 90)
ALTER DEFAULT PRIVILEGES FOR ALL ROLES IN SCHEMA s REVOKE SELECT ON TABLES FROM test4;
ALTER DEFAULT PRIVILEGES FOR ALL ROLES IN SCHEMA s GRANT USAGE ON TYPES TO test4;

-- Test 27: statement (line 94)
DROP ROLE test4

-- Test 28: statement (line 97)
ALTER DEFAULT PRIVILEGES FOR ALL ROLES IN SCHEMA s REVOKE USAGE ON TYPES FROM test4;
ALTER DEFAULT PRIVILEGES FOR ALL ROLES IN SCHEMA s GRANT SELECT ON SEQUENCES TO test4;

-- Test 29: statement (line 101)
DROP ROLE test4

