-- PostgreSQL compatible tests from show_create_all_schemas
-- 13 tests

-- Test 1: statement (line 3)
CREATE DATABASE d

-- Test 2: statement (line 6)
USE d

-- Test 3: query (line 9)
SHOW CREATE ALL SCHEMAS

-- Test 4: statement (line 15)
CREATE SCHEMA test

-- Test 5: query (line 18)
SHOW CREATE ALL SCHEMAS

-- Test 6: statement (line 25)
CREATE SCHEMA test2

-- Test 7: query (line 28)
SHOW CREATE ALL SCHEMAS

-- Test 8: statement (line 36)
DROP SCHEMA test

-- Test 9: query (line 39)
SHOW CREATE ALL SCHEMAS

-- Test 10: statement (line 46)
COMMENT ON SCHEMA public IS 'test comment';

-- Test 11: query (line 49)
SHOW CREATE ALL SCHEMAS

-- Test 12: statement (line 58)
CREATE DATABASE "d-d";
USE "d-d";
SHOW CREATE ALL SCHEMAS;

-- Test 13: statement (line 64)
CREATE DATABASE "a""bc";
USE "a""bc";
SHOW CREATE ALL SCHEMAS;

