-- PostgreSQL compatible tests from grant_database
-- 37 tests

-- Test 1: statement (line 1)
CREATE DATABASE a

-- Test 2: query (line 4)
SHOW GRANTS ON DATABASE a

-- Test 3: statement (line 12)
REVOKE CONNECT ON DATABASE a FROM root

-- Test 4: statement (line 15)
REVOKE CONNECT ON DATABASE a FROM admin

-- Test 5: statement (line 18)
CREATE USER readwrite

-- Test 6: statement (line 21)
GRANT ALL ON DATABASE a TO readwrite, "test-user"

-- Test 7: statement (line 24)
INSERT INTO system.users VALUES('test-user','',false,3);

-- Test 8: statement (line 27)
GRANT ALL PRIVILEGES ON DATABASE a TO readwrite, "test-user" WITH GRANT OPTION

-- Test 9: statement (line 30)
GRANT SELECT,ALL ON DATABASE a TO readwrite

-- Test 10: statement (line 33)
REVOKE SELECT,ALL ON DATABASE a FROM readwrite

-- Test 11: query (line 36)
SHOW GRANTS ON DATABASE a

-- Test 12: query (line 45)
SHOW GRANTS ON DATABASE a FOR readwrite, "test-user"

-- Test 13: statement (line 52)
REVOKE CONNECT ON DATABASE a FROM "test-user",readwrite

-- Test 14: query (line 55)
SHOW GRANTS ON DATABASE a

-- Test 15: query (line 74)
SHOW GRANTS ON DATABASE a FOR readwrite, "test-user"

-- Test 16: statement (line 91)
REVOKE CREATE ON DATABASE a FROM "test-user"

-- Test 17: query (line 94)
SHOW GRANTS ON DATABASE a

-- Test 18: statement (line 112)
REVOKE ALL PRIVILEGES ON DATABASE a FROM "test-user"

-- Test 19: query (line 115)
SHOW GRANTS ON DATABASE a FOR readwrite, "test-user"

-- Test 20: statement (line 126)
REVOKE ALL ON DATABASE a FROM readwrite,"test-user"

-- Test 21: query (line 129)
SHOW GRANTS ON DATABASE a

-- Test 22: query (line 136)
SHOW GRANTS ON DATABASE a FOR readwrite, "test-user"

-- Test 23: statement (line 143)
GRANT USAGE ON DATABASE a TO testuser

-- Test 24: statement (line 146)
CREATE DATABASE b

-- Test 25: statement (line 149)
GRANT CREATE, CONNECT ON DATABASE b TO testuser

user testuser

-- Test 26: statement (line 154)
CREATE TABLE b.t()

-- Test 27: query (line 159)
SHOW GRANTS ON b.t

-- Test 28: statement (line 169)
SHOW GRANTS FOR invaliduser

-- Test 29: statement (line 176)
CREATE USER owner_grant_option_child

-- Test 30: statement (line 179)
GRANT testuser to owner_grant_option_child

-- Test 31: statement (line 182)
ALTER USER testuser WITH createdb

user testuser

-- Test 32: statement (line 187)
CREATE DATABASE owner_grant_option

-- Test 33: statement (line 190)
GRANT CONNECT ON DATABASE owner_grant_option TO owner_grant_option_child

-- Test 34: query (line 193)
SHOW GRANTS ON DATABASE owner_grant_option

-- Test 35: statement (line 207)
CREATE ROLE other_owner

-- Test 36: statement (line 210)
ALTER DATABASE owner_grant_option OWNER TO other_owner

-- Test 37: query (line 213)
SHOW GRANTS ON DATABASE owner_grant_option

