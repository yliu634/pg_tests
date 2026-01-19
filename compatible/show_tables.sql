-- PostgreSQL compatible tests from show_tables
-- 13 tests

-- Test 1: statement (line 3)
CREATE TABLE show_this_table()

-- Test 2: query (line 6)
SHOW TABLES

-- Test 3: statement (line 11)
CREATE DATABASE other;
SET DATABASE = 'other'

-- Test 4: query (line 15)
SHOW TABLES FROM test

-- Test 5: statement (line 20)
SET DATABASE = 'test'

-- Test 6: statement (line 23)
SET CLUSTER SETTING sql.show_tables.estimated_row_count.enabled = false

-- Test 7: query (line 26)
SHOW TABLES

-- Test 8: query (line 31)
SHOW TABLES WITH COMMENT

-- Test 9: statement (line 36)
SET CLUSTER SETTING sql.show_tables.estimated_row_count.enabled = default

-- Test 10: statement (line 39)
CREATE DATABASE "Do you like this for a database name?";
SET database = "Do you like this for a database name?";
CREATE SCHEMA sc;
CREATE TABLE sc.foo (i INT8);
CREATE TABLE foo (i INT8);

-- Test 11: query (line 46)
SHOW TABLES

-- Test 12: statement (line 53)
USE other

-- Test 13: query (line 56)
SHOW TABLES FROM "Do you like this for a database name?".sc

