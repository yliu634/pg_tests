-- PostgreSQL compatible tests from routine_schema_change
-- 13 tests

-- Test 1: statement (line 3)
SET use_declarative_schema_changer = 'on'

-- Test 2: statement (line 7)
SET CLUSTER SETTING sql.schema.force_declarative_statements='!CREATE FUNCTION'

-- Test 3: statement (line 11)
EXPLAIN (DDL) CREATE FUNCTION f() RETURNS INT LANGUAGE SQL AS 'SELECT 1'

-- Test 4: statement (line 15)
CREATE FUNCTION f() RETURNS INT LANGUAGE SQL AS 'SELECT 1'

-- Test 5: statement (line 19)
SET CLUSTER SETTING sql.schema.force_declarative_statements='!CREATE PROCEDURE'

-- Test 6: statement (line 23)
EXPLAIN (DDL) CREATE PROCEDURE p() LANGUAGE SQL as 'SELECT 1'

-- Test 7: statement (line 27)
CREATE PROCEDURE p() LANGUAGE SQL as 'SELECT 1'

-- Test 8: statement (line 31)
SET CLUSTER SETTING sql.schema.force_declarative_statements='!DROP FUNCTION'

-- Test 9: statement (line 35)
EXPLAIN (DDL) DROP FUNCTION f

-- Test 10: statement (line 39)
DROP FUNCTION f

-- Test 11: statement (line 43)
SET CLUSTER SETTING sql.schema.force_declarative_statements='!DROP PROCEDURE'

-- Test 12: statement (line 47)
EXPLAIN (DDL) DROP PROCEDURE p

-- Test 13: statement (line 51)
DROP PROCEDURE p

