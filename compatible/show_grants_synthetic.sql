-- PostgreSQL compatible tests from show_grants_synthetic
-- 16 tests

-- Test 1: statement (line 1)
GRANT SYSTEM MODIFYCLUSTERSETTING TO testuser

-- Test 2: statement (line 4)
GRANT SYSTEM VIEWACTIVITY TO testuser

-- Test 3: statement (line 7)
GRANT SYSTEM EXTERNALCONNECTION TO testuser WITH GRANT OPTION

-- Test 4: query (line 10)
SHOW SYSTEM GRANTS

-- Test 5: query (line 18)
SHOW SYSTEM GRANTS FOR testuser

-- Test 6: statement (line 26)
REVOKE SYSTEM VIEWACTIVITY FROM testuser

-- Test 7: query (line 29)
SHOW SYSTEM GRANTS

-- Test 8: statement (line 36)
CREATE USER testuser2

-- Test 9: statement (line 39)
GRANT SYSTEM VIEWACTIVITY TO testuser2 WITH GRANT OPTION

-- Test 10: statement (line 42)
GRANT SYSTEM EXTERNALCONNECTION TO testuser2

-- Test 11: statement (line 46)
GRANT SYSTEM REPAIRCLUSTER TO testuser2

-- Test 12: statement (line 49)
GRANT SYSTEM REPAIRCLUSTERMETADATA TO testuser

-- Test 13: query (line 52)
SHOW SYSTEM GRANTS

-- Test 14: query (line 63)
SHOW SYSTEM GRANTS FOR testuser2

-- Test 15: query (line 71)
SHOW SYSTEM GRANTS FOR testuser, testuser2

-- Test 16: statement (line 87)
SHOW SYSTEM GRANTS FOR testuser

