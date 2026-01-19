-- PostgreSQL compatible tests from show_grants_on_virtual_table
-- 7 tests

-- Test 1: query (line 1)
SHOW GRANTS ON crdb_internal.tables

-- Test 2: statement (line 7)
GRANT SELECT ON crdb_internal.tables TO testuser

-- Test 3: query (line 10)
SHOW GRANTS ON crdb_internal.tables

-- Test 4: statement (line 17)
GRANT ALL ON crdb_internal.tables TO testuser

-- Test 5: statement (line 20)
CREATE USER testuser2

-- Test 6: statement (line 23)
GRANT SELECT ON crdb_internal.tables TO testuser2 WITH GRANT OPTION

-- Test 7: query (line 26)
SHOW GRANTS ON crdb_internal.tables

