-- PostgreSQL compatible tests from internal_executor
-- 3 tests

-- Test 1: statement (line 13)
-- SET avoid_buffering = true; -- CockroachDB specific

-- Test 2: statement (line 16)
DROP TABLE IF EXISTS t;
CREATE TABLE t (i INT PRIMARY KEY);

-- Test 3: statement (line 19)
SELECT has_table_privilege('testuser', 't', 'SELECT');
