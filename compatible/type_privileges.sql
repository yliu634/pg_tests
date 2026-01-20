-- PostgreSQL compatible tests from type_privileges
-- 27 tests

-- Test 1: statement (line 4)
GRANT CREATE, DROP ON DATABASE test TO testuser;

-- Test 2: statement (line 7)
CREATE TYPE test AS ENUM ('hello');

-- Test 3: statement (line 10)
CREATE TABLE for_view(x test);

-- Test 4: statement (line 13)
GRANT SELECT on for_view TO testuser;

-- Test 5: statement (line 20)
CREATE TABLE t(x test)

-- Test 6: statement (line 23)
DROP TABLE t

user root

-- Test 7: statement (line 28)
REVOKE USAGE ON TYPE test FROM public;

user testuser

-- Test 8: statement (line 33)
CREATE TABLE t(x test)

-- Test 9: statement (line 36)
SELECT 'hello'::test

-- Test 10: statement (line 39)
CREATE VIEW vx1 as SELECT 'hello'::test

-- Test 11: statement (line 42)
CREATE VIEW vx2 as SELECT x FROM for_view

-- Test 12: statement (line 49)
GRANT USAGE ON TYPE test TO testuser

user testuser

-- Test 13: statement (line 54)
CREATE TABLE t(x test);

-- Test 14: statement (line 57)
CREATE VIEW vx1 as SELECT 'hello'::test

-- Test 15: statement (line 60)
CREATE VIEW vx2 as SELECT x FROM for_view

-- Test 16: statement (line 64)
ALTER TYPE test RENAME TO not_test

-- Test 17: statement (line 68)
DROP TYPE test

user root

-- Test 18: statement (line 76)
GRANT SELECT ON type TEST to testuser

-- Test 19: statement (line 79)
GRANT INSERT ON type TEST to testuser

-- Test 20: statement (line 82)
GRANT DELETE ON type TEST to testuser

-- Test 21: statement (line 85)
GRANT UPDATE ON type TEST to testuser

-- Test 22: statement (line 88)
GRANT ZONECONFIG ON type TEST to testuser

-- Test 23: statement (line 93)
GRANT ALL ON type TEST to testuser

-- Test 24: statement (line 97)
GRANT root TO testuser

-- Test 25: statement (line 102)
DROP VIEW vx1;
DROP VIEW vx2;
DROP TABLE t;
DROP TABLE for_view;

user testuser

-- Test 26: statement (line 111)
ALTER TYPE test RENAME to test1

-- Test 27: statement (line 115)
DROP TYPE test1

