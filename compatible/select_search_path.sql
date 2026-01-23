-- PostgreSQL compatible tests from select_search_path
-- 31 tests

-- Test 1: query (line 4)
SELECT table_name
FROM information_schema.tables
WHERE table_schema = current_schema()
  AND table_type = 'BASE TABLE'
ORDER BY table_name;

-- Test 2: query (line 9)
SELECT count(DISTINCT(1)) FROM pg_attrdef;

-- Test 3: query (line 14)
SELECT count(DISTINCT(1)) FROM pg_attribute;

-- Test 4: query (line 19)
SELECT count(DISTINCT(1)) FROM pg_class;

-- Test 5: query (line 24)
SELECT count(DISTINCT(1)) FROM pg_namespace;

-- Test 6: query (line 29)
SELECT count(DISTINCT(1)) FROM pg_tables;

-- Test 7: statement (line 35)
DROP SCHEMA IF EXISTS t1 CASCADE;
CREATE SCHEMA t1;

-- Test 8: statement (line 38)
CREATE TABLE t1.numbers (n INTEGER);
CREATE TABLE t1.words (w TEXT);
INSERT INTO t1.numbers VALUES (1), (2);

-- Test 9: statement (line 41)
DROP SCHEMA IF EXISTS t2 CASCADE;
CREATE SCHEMA t2;

-- Test 10: statement (line 44)
CREATE TABLE t2.words (w TEXT);
CREATE TABLE t2.numbers (n INTEGER);
INSERT INTO t2.words VALUES ('a');

-- Test 11: statement (line 50)
SET search_path = t1, public;

-- Test 12: query (line 53)
SELECT count(*) FROM numbers;

-- Test 13: query (line 58)
SELECT count(*) FROM words;

-- There's no table with default values in t1.
-- query I
SELECT count(DISTINCT(1)) FROM pg_attrdef;

-- Test 14: query (line 67)
SELECT count(DISTINCT(1)) FROM pg_attribute;

-- Test 15: query (line 72)
SELECT count(DISTINCT(1)) FROM pg_class;

-- Test 16: query (line 77)
SELECT count(DISTINCT(1)) FROM pg_namespace;

-- Test 17: query (line 82)
SELECT count(DISTINCT(1)) FROM pg_tables;

-- Test 18: statement (line 90)
SET search_path = t2, public;

-- Test 19: query (line 93)
SELECT count(*) FROM numbers;

-- query I
SELECT count(*) FROM words;

-- Test 20: query (line 102)
SELECT count(DISTINCT(1)) FROM pg_attrdef;

-- Test 21: query (line 107)
SELECT count(DISTINCT(1)) FROM pg_attribute;

-- Test 22: query (line 112)
SELECT count(DISTINCT(1)) FROM pg_class;

-- Test 23: query (line 117)
SELECT count(DISTINCT(1)) FROM pg_namespace;

-- Test 24: query (line 122)
SELECT count(DISTINCT(1)) FROM pg_tables;

-- Test 25: statement (line 130)
SET search_path = nonexistent, public;

-- Test 26: query (line 133)
SELECT current_schema();

-- Test 27: statement (line 138)
SET search_path = nonexistent;

-- Test 28: query (line 141)
SELECT current_schema();

-- Test 29: statement (line 149)
SET search_path = nonexistent, public;

-- Test 30: query (line 152)
SELECT current_schemas(false);

-- Test 31: statement (line 160)
CREATE TABLE sometable(x INT);
SELECT * FROM public.sometable;
