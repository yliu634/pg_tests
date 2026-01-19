-- PostgreSQL compatible tests from statement_statistics_errors
-- 10 tests

-- Test 1: statement (line 12)
SELECT 2/0;

-- Test 2: query (line 17)
SHOW DATABASES

-- Test 3: statement (line 26)
use posgres

-- Test 4: statement (line 31)
ALTER DEFAULT PRIVILEGES GRANT SELECT ON TABLES to who

-- Test 5: statement (line 36)
CREATE TABLE crdb_internal.example (abc INT)

-- Test 6: statement (line 41)
SET autocommit_before_ddl = false

-- Test 7: statement (line 44)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
CREATE TABLE src(x VARCHAR PRIMARY KEY);
CREATE TABLE dst(x VARCHAR REFERENCES src(x));
INSERT INTO src(x) VALUES ('example');
INSERT INTO dst(x) VALUES ('example');
COMMIT;

-- Test 8: statement (line 52)
RESET autocommit_before_ddl

-- Test 9: statement (line 55)
UPDATE dst SET x = 'xyz'

-- Test 10: query (line 59)
SELECT last_error_code, last_error   FROM crdb_internal.node_statement_statistics WHERE last_error_code!='NULL' AND application_name NOT LIKE '$ %' ORDER BY last_error_code ASC;

