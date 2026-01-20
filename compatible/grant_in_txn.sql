-- PostgreSQL compatible tests from grant_in_txn
-- 72 tests

-- Test 1: statement (line 8)
SET statement_timeout = '10s';

-- Test 2: statement (line 11)
CREATE DATABASE IF NOT EXISTS db1;

-- Test 3: statement (line 14)
CREATE DATABASE IF NOT EXISTS db2;

-- Test 4: statement (line 17)
BEGIN;

-- Test 5: statement (line 20)
CREATE TABLE IF NOT EXISTS db1.t ();

-- Test 6: statement (line 23)
CREATE TABLE IF NOT EXISTS db2.t ();

-- Test 7: statement (line 26)
CREATE USER user1;

-- Test 8: statement (line 29)
CREATE USER user2;

-- Test 9: statement (line 32)
CREATE USER user3;

-- Test 10: statement (line 35)
CREATE USER user4;

-- Test 11: statement (line 38)
CREATE USER user5;

-- Test 12: statement (line 41)
CREATE USER user6;

-- Test 13: statement (line 44)
CREATE USER user7;

-- Test 14: statement (line 47)
CREATE ROLE role1;

-- Test 15: statement (line 50)
CREATE ROLE role2;

-- Test 16: statement (line 53)
CREATE ROLE role3;

-- Test 17: statement (line 56)
CREATE ROLE role4;

-- Test 18: statement (line 59)
CREATE ROLE role5;

-- Test 19: statement (line 62)
CREATE ROLE role6;

-- Test 20: statement (line 65)
CREATE ROLE role7;

-- Test 21: statement (line 68)
CREATE ROLE role8;

-- Test 22: statement (line 71)
GRANT CREATE ON DATABASE db1 TO role1;

-- Test 23: statement (line 74)
GRANT CREATE ON TABLE db1.* TO role1;

-- Test 24: statement (line 77)
GRANT CREATE ON DATABASE db2 TO role1;

-- Test 25: statement (line 80)
GRANT select, insert, delete, update ON TABLE db2.* TO role1;

-- Test 26: statement (line 83)
GRANT role1 TO user5;

-- Test 27: statement (line 86)
GRANT role2 TO user7;

-- Test 28: statement (line 89)
GRANT CREATE ON DATABASE db1 TO role3;

-- Test 29: statement (line 92)
GRANT SELECT, INSERT, DELETE, UPDATE ON TABLE db1.* TO role3;

-- Test 30: statement (line 95)
GRANT ALL ON DATABASE db1 TO role4;

-- Test 31: statement (line 98)
GRANT ALL ON TABLE db1.* TO role4;

-- Test 32: statement (line 101)
GRANT ALL ON DATABASE db1 TO role5;

-- Test 33: statement (line 104)
GRANT ALL ON TABLE db1.* TO role5;

-- Test 34: statement (line 107)
GRANT role5 TO user1;

-- Test 35: statement (line 110)
GRANT CREATE ON DATABASE db2 TO role6;

-- Test 36: statement (line 113)
GRANT SELECT, INSERT, DELETE, UPDATE ON TABLE db2.* TO role6;

-- Test 37: statement (line 116)
GRANT ALL ON DATABASE db2 TO role7;

-- Test 38: statement (line 119)
GRANT ALL ON TABLE db2.* TO role7;

-- Test 39: statement (line 122)
GRANT ALL ON DATABASE db2 TO role8;

-- Test 40: statement (line 125)
GRANT ALL ON TABLE db2.* TO role8;

-- Test 41: statement (line 128)
GRANT admin TO user2;

-- Test 42: statement (line 131)
GRANT admin TO user4;

-- Test 43: statement (line 134)
GRANT admin TO role2;

-- Test 44: statement (line 137)
CREATE ROLE role9;

-- Test 45: statement (line 140)
GRANT role3 TO role9;

-- Test 46: statement (line 143)
GRANT role6 TO role9;

-- Test 47: statement (line 146)
GRANT role9 TO user1;

-- Test 48: statement (line 149)
CREATE ROLE role10;

-- Test 49: statement (line 152)
GRANT role4 TO role10;

-- Test 50: statement (line 155)
GRANT role7 TO role10;

-- Test 51: statement (line 158)
CREATE ROLE role11;

-- Test 52: statement (line 161)
GRANT role5 TO role11;

-- Test 53: statement (line 164)
GRANT role8 TO role11;

-- Test 54: statement (line 167)
GRANT role11 TO user6;

-- Test 55: statement (line 170)
DROP TABLE db1.t;

-- Test 56: statement (line 173)
DROP TABLE db2.t;

-- Test 57: statement (line 176)
COMMIT;

-- Test 58: statement (line 182)
CREATE ROLE role_foo;

-- Test 59: statement (line 185)
CREATE ROLE role_bar;

-- Test 60: statement (line 188)
GRANT role_bar TO role_foo WITH ADMIN OPTION;

-- Test 61: statement (line 191)
GRANT role_foo TO testuser WITH ADMIN OPTION;

-- Test 62: query (line 197)
SELECT count(*) FROM system.lease WHERE desc_id = 'system.role_members'::REGCLASS::OID GROUP BY desc_id, version;

-- Test 63: statement (line 206)
SET autocommit_before_ddl = false

-- Test 64: statement (line 209)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- Test 65: query (line 212)
SELECT * FROM information_schema.applicable_roles ORDER BY role_name;

-- Test 66: statement (line 219)
REVOKE role_foo FROM testuser;

-- Test 67: statement (line 222)
SAVEPOINT before_invalid_grant

-- Test 68: statement (line 228)
GRANT role_bar TO testuser;

-- Test 69: statement (line 231)
ROLLBACK TO SAVEPOINT before_invalid_grant

-- Test 70: query (line 234)
SELECT * FROM information_schema.applicable_roles;

-- Test 71: statement (line 239)
COMMIT

-- Test 72: statement (line 242)
RESET autocommit_before_ddl

