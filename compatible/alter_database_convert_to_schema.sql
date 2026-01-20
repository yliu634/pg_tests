-- PostgreSQL compatible tests from alter_database_convert_to_schema
-- 2 tests

-- Test 1: statement (line 1)
CREATE DATABASE parent;
USE parent;
CREATE DATABASE pgdatabase;
USE test;

-- Test 2: statement (line 7)
ALTER DATABASE parent CONVERT TO SCHEMA WITH PARENT pgdatabase

