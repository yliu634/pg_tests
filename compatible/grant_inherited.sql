-- PostgreSQL compatible tests from grant_inherited
-- 41 tests

-- Test 1: statement (line 3)
CREATE USER alice

-- Test 2: statement (line 6)
CREATE USER bob

-- Test 3: statement (line 9)
CREATE USER chuck

-- Test 4: statement (line 12)
CREATE USER dave

-- Test 5: statement (line 15)
CREATE ROLE meeter

-- Test 6: statement (line 18)
CREATE ROLE greeter

-- Test 7: statement (line 21)
CREATE ROLE granter

-- Test 8: statement (line 24)
GRANT granter TO alice,bob,chuck,dave

-- Test 9: statement (line 27)
GRANT meeter TO granter

-- Test 10: statement (line 30)
GRANT greeter TO alice WITH ADMIN OPTION

-- Test 11: query (line 33)
SELECT * FROM "".crdb_internal.kv_inherited_role_members

-- Test 12: query (line 49)
SHOW GRANTS ON ROLE

-- Test 13: statement (line 61)
GRANT ALL ON DATABASE defaultdb TO meeter WITH GRANT OPTION

-- Test 14: query (line 64)
SHOW GRANTS ON DATABASE defaultdb FOR alice

-- Test 15: statement (line 71)
CREATE SCHEMA sc

-- Test 16: statement (line 74)
GRANT ALL ON SCHEMA sc TO meeter WITH GRANT OPTION

-- Test 17: query (line 77)
SHOW GRANTS ON SCHEMA sc FOR alice

-- Test 18: statement (line 83)
CREATE SEQUENCE sq

-- Test 19: statement (line 86)
GRANT ALL ON SEQUENCE sq TO meeter WITH GRANT OPTION

-- Test 20: query (line 89)
SHOW GRANTS ON SEQUENCE sq FOR alice

-- Test 21: statement (line 95)
CREATE TABLE tbl (i INT PRIMARY KEY);

-- Test 22: statement (line 98)
GRANT ALL ON TABLE tbl TO meeter WITH GRANT OPTION

-- Test 23: query (line 101)
SHOW GRANTS ON TABLE tbl FOR alice

-- Test 24: statement (line 107)
CREATE TYPE typ AS ENUM ('a', 'b')

-- Test 25: statement (line 110)
GRANT ALL ON TYPE typ TO meeter WITH GRANT OPTION

-- Test 26: query (line 113)
SHOW GRANTS ON TYPE typ FOR alice

-- Test 27: statement (line 120)
CREATE FUNCTION fn(IN x INT)
	RETURNS INT
	STABLE
	LANGUAGE SQL
	AS $$
SELECT x + 1;
$$

-- Test 28: statement (line 129)
GRANT EXECUTE ON FUNCTION fn TO meeter WITH GRANT OPTION

-- Test 29: query (line 132)
SHOW GRANTS ON FUNCTION fn FOR alice

-- Test 30: statement (line 139)
CREATE EXTERNAL CONNECTION conn AS 'nodelocal://1/foo';

-- Test 31: statement (line 142)
GRANT ALL ON EXTERNAL CONNECTION conn TO meeter WITH GRANT OPTION

-- Test 32: query (line 145)
SHOW GRANTS ON EXTERNAL CONNECTION conn FOR alice

-- Test 33: statement (line 151)
GRANT SYSTEM ALL TO meeter WITH GRANT OPTION

-- Test 34: query (line 154)
SHOW SYSTEM GRANTS FOR alice

-- Test 35: statement (line 163)
CREATE ROLE parent

-- Test 36: statement (line 166)
CREATE ROLE child

-- Test 37: statement (line 169)
GRANT parent TO child

-- Test 38: statement (line 172)
CREATE SCHEMA test_schema

-- Test 39: statement (line 175)
GRANT USAGE ON SCHEMA test_schema TO public

-- Test 40: statement (line 178)
GRANT CREATE ON SCHEMA test_schema TO parent

-- Test 41: query (line 181)
SHOW GRANTS FOR child

