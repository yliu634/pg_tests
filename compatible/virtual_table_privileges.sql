-- PostgreSQL compatible tests from virtual_table_privileges
-- 31 tests

-- Test 1: statement (line 4)
SELECT * FROM crdb_internal.tables

-- Test 2: statement (line 7)


-- Test 3: query (line 9)
SELECT has_table_privilege('testuser', 'crdb_internal.tables', 'select');

-- Test 4: statement (line 16)
REVOKE SELECT ON crdb_internal.tables FROM public

-- Test 5: query (line 19)
SELECT username, path, privileges, grant_options FROM system.privileges

-- Test 6: statement (line 26)
GRANT SELECT ON crdb_internal.tables TO public

-- Test 7: query (line 29)
SELECT username, path, privileges, grant_options FROM system.privileges

-- Test 8: statement (line 35)
SELECT * FROM crdb_internal.tables

user root

-- Test 9: statement (line 40)
REVOKE SELECT ON TABLE crdb_internal.tables FROM public

-- Test 10: query (line 43)
SELECT has_table_privilege('testuser', 'crdb_internal.tables', 'select');

-- Test 11: statement (line 50)
SHOW TABLES

user root

-- Test 12: statement (line 55)
GRANT SELECT ON TABLE crdb_internal.tables TO public

-- Test 13: query (line 58)
SELECT has_table_privilege('testuser', 'crdb_internal.tables', 'select');

-- Test 14: statement (line 63)
REVOKE SELECT ON TABLE crdb_internal.tables FROM public

user testuser

-- Test 15: statement (line 68)
SELECT * FROM crdb_internal.tables

user root

-- Test 16: statement (line 73)
GRANT SELECT ON TABLE crdb_internal.tables TO public

user testuser

-- Test 17: statement (line 78)
SELECT * FROM crdb_internal.tables

user root

-- Test 18: statement (line 84)
CREATE DATABASE test2

-- Test 19: query (line 89)
GRANT SELECT ON TABLE test2.information_schema.columns TO testuser

-- Test 20: statement (line 95)
GRANT SELECT ON TABLE test2.information_schema.columns TO testuser

-- Test 21: query (line 98)
SELECT username, path, privileges, grant_options FROM system.privileges

-- Test 22: statement (line 105)
SELECT * FROM test2.information_schema.columns

-- Test 23: statement (line 109)
SELECT * FROM crdb_internal.cluster_sessions

user root

-- Test 24: statement (line 114)
use test2

-- Test 25: query (line 120)
select has_table_privilege('testuser', 'test2.crdb_internal.tables', 'select');

-- Test 26: statement (line 125)
use test

-- Test 27: query (line 128)
select has_table_privilege('testuser', 'test.crdb_internal.tables', 'select');

-- Test 28: statement (line 134)
SELECT * FROM crdb_internal.tables

-- Test 29: statement (line 137)
GRANT USAGE ON TABLE crdb_internal.tables TO testuser

-- Test 30: statement (line 140)
GRANT ZONECONFIG ON TABLE crdb_internal.tables TO testuser

-- Test 31: statement (line 143)
GRANT CREATE ON TABLE information_schema.tables TO testuser

