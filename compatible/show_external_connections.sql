-- PostgreSQL compatible tests from show_external_connections
-- 13 tests

-- Test 1: statement (line 5)
CREATE EXTERNAL CONNECTION foo_conn AS 'nodelocal://1/foo';
CREATE EXTERNAL CONNECTION bar_conn AS 'nodelocal://1/bar';

-- Test 2: query (line 9)
SHOW EXTERNAL CONNECTIONS

-- Test 3: query (line 16)
SHOW EXTERNAL CONNECTION foo_conn

-- Test 4: query (line 24)
SHOW EXTERNAL CONNECTIONS

-- Test 5: statement (line 29)
SHOW EXTERNAL CONNECTION foo_conn

user root

-- Test 6: statement (line 34)
GRANT USAGE ON EXTERNAL CONNECTION foo_conn TO testuser;

user testuser

-- Test 7: query (line 39)
SHOW EXTERNAL CONNECTIONS

-- Test 8: query (line 45)
SHOW EXTERNAL CONNECTION foo_conn

-- Test 9: statement (line 51)
SHOW EXTERNAL CONNECTION bar_conn

user root

-- Test 10: statement (line 56)
GRANT SYSTEM EXTERNALCONNECTION TO testuser;

user testuser

-- Test 11: statement (line 62)
CREATE EXTERNAL CONNECTION baz_conn AS 'nodelocal://1/baz';

-- Test 12: query (line 65)
SHOW EXTERNAL CONNECTIONS

-- Test 13: statement (line 73)
CHECK EXTERNAL CONNECTION NULLIF WITH CONCURRENTLY = EXISTS ( ( TABLE error ) );

