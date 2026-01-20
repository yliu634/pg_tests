-- PostgreSQL compatible tests from alter_external_connection
-- 11 tests

-- Test 1: statement (line 3)
CREATE EXTERNAL CONNECTION conn_1 AS 'nodelocal://1/conn_1';
CREATE EXTERNAL CONNECTION conn_2 AS 'nodelocal://1/conn_2';

-- Test 2: query (line 7)
SHOW EXTERNAL CONNECTIONS

-- Test 3: statement (line 17)
ALTER EXTERNAL CONNECTION conn_1 AS 'nodelocal://1/conn_update';

user root

-- Test 4: statement (line 22)
GRANT UPDATE ON EXTERNAL CONNECTION conn_1 TO testuser;
GRANT USAGE ON EXTERNAL CONNECTION conn_1 TO testuser;

user testuser

-- Test 5: statement (line 28)
ALTER EXTERNAL CONNECTION conn_1 AS 'nodelocal://1/conn_update_with_privilege';

-- Test 6: query (line 31)
SHOW EXTERNAL CONNECTION conn_1

-- Test 7: statement (line 39)
ALTER EXTERNAL CONNECTION conn_2 AS 'nodelocal://1/conn_update';

user root

-- Test 8: statement (line 44)
GRANT UPDATE ON EXTERNAL CONNECTION conn_2 TO testuser;
GRANT USAGE ON EXTERNAL CONNECTION conn_2 TO testuser;

user testuser

-- Test 9: statement (line 50)
ALTER EXTERNAL CONNECTION IF EXISTS conn_not_exist AS 'nodelocal://1/not_exist';

-- Test 10: statement (line 53)
ALTER EXTERNAL CONNECTION conn_2 AS 'nodelocal://1/connection_2_alter';

-- Test 11: query (line 56)
SHOW EXTERNAL CONNECTION conn_2

