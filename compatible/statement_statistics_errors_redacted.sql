-- PostgreSQL compatible tests from statement_statistics_errors_redacted
-- 12 tests

-- Test 1: statement (line 12)
GRANT SYSTEM VIEWACTIVITYREDACTED TO testuser;

-- Test 2: query (line 15)
SHOW SYSTEM GRANTS

-- Test 3: statement (line 25)
SELECT 2/0;

-- Test 4: query (line 29)
SHOW DATABASES

-- Test 5: statement (line 37)
use posgres

-- Test 6: statement (line 41)
ALTER DEFAULT PRIVILEGES GRANT SELECT ON TABLES to who

-- Test 7: query (line 44)
SELECT last_error_code, last_error FROM crdb_internal.node_statement_statistics WHERE last_error_code!='NULL' AND application_name NOT LIKE '$ %' ORDER BY last_error_code ASC;

-- Test 8: statement (line 54)
GRANT SYSTEM VIEWACTIVITY TO testuser

-- Test 9: statement (line 57)
REVOKE SYSTEM VIEWACTIVITYREDACTED FROM testuser

user testuser

-- Test 10: query (line 63)
SELECT last_error_code, last_error FROM crdb_internal.node_statement_statistics WHERE last_error_code!='NULL' AND application_name NOT LIKE '$ %' ORDER BY last_error_code ASC;

-- Test 11: statement (line 74)
GRANT SYSTEM VIEWACTIVITYREDACTED TO testuser

user testuser

-- Test 12: query (line 79)
SELECT last_error_code, last_error FROM crdb_internal.node_statement_statistics WHERE last_error_code!='NULL' AND application_name NOT LIKE '$ %' ORDER BY last_error_code ASC;

