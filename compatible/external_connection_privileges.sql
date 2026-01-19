-- PostgreSQL compatible tests from external_connection_privileges
-- 21 tests

-- Test 1: query (line 7)
SELECT username, path, privileges, grant_options FROM system.privileges

-- Test 2: statement (line 12)
GRANT USAGE ON EXTERNAL CONNECTION foo TO testuser

-- Test 3: statement (line 15)
GRANT DROP ON EXTERNAL CONNECTION foo TO testuser

-- Test 4: statement (line 19)
GRANT UPDATE ON EXTERNAL CONNECTION foo TO testuser

-- Test 5: statement (line 22)
CREATE EXTERNAL CONNECTION foo AS 'nodelocal://1/foo'

-- Test 6: statement (line 25)
GRANT USAGE,DROP,UPDATE ON EXTERNAL CONNECTION foo TO testuser

-- Test 7: query (line 28)
SELECT username, path, privileges, grant_options FROM system.privileges ORDER by username

-- Test 8: statement (line 34)
REVOKE USAGE,DROP,UPDATE ON EXTERNAL CONNECTION foo FROM testuser

-- Test 9: query (line 37)
SELECT username, path, privileges, grant_options FROM system.privileges ORDER by username

-- Test 10: statement (line 42)
GRANT USAGE,DROP,UPDATE ON EXTERNAL CONNECTION foo TO testuser

-- Test 11: statement (line 45)
CREATE USER bar

-- Test 12: statement (line 51)
GRANT USAGE,DROP,UPDATE ON EXTERNAL CONNECTION foo TO bar

user root

-- Test 13: statement (line 56)
GRANT USAGE,DROP,UPDATE ON EXTERNAL CONNECTION foo TO testuser WITH GRANT OPTION

-- Test 14: statement (line 62)
GRANT USAGE,DROP,UPDATE ON EXTERNAL CONNECTION foo TO bar

user root

-- Test 15: query (line 67)
SELECT username, path, privileges, grant_options FROM system.privileges ORDER BY username

-- Test 16: statement (line 76)
GRANT SELECT ON EXTERNAL CONNECTION foo TO testuser

-- Test 17: statement (line 79)
GRANT INSERT ON EXTERNAL CONNECTION foo TO testuser

-- Test 18: statement (line 82)
CREATE ROLE testuser2

-- Test 19: statement (line 85)
GRANT DROP,UPDATE,USAGE ON EXTERNAL CONNECTION foo TO testuser2 WITH GRANT OPTION

-- Test 20: query (line 88)
SHOW GRANTS ON EXTERNAL CONNECTION foo

-- Test 21: query (line 103)
SHOW GRANTS ON EXTERNAL CONNECTION foo FOR testuser, testuser2

