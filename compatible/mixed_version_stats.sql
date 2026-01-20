SET client_min_messages = warning;

-- PostgreSQL compatible tests from mixed_version_stats
-- 7 tests

-- Test 1: statement (line 10)
DROP TABLE IF EXISTS t CASCADE;
DROP TABLE IF EXISTS t CASCADE;
CREATE TABLE t (k INT PRIMARY KEY, v INT);

-- Test 2: statement (line 22)
INSERT INTO t (k, v) SELECT g, g FROM generate_series(1, 100000) AS g;

-- Test 3: query (line 26)
-- COMMENTED: CockroachDB EXPLAIN (DISTSQL) output is not available in PostgreSQL.
-- SELECT * FROM [EXPLAIN (DISTSQL) CREATE STATISTICS s FROM t] WHERE info LIKE 'distribution%';

-- Test 4: statement (line 31)
DROP STATISTICS IF EXISTS s;
CREATE STATISTICS s ON k, v FROM t;

-- Test 5: query (line 37)
SELECT count(*) FROM t;

-- Test 6: query (line 42)
-- COMMENTED: CockroachDB EXPLAIN (DISTSQL) output is not available in PostgreSQL.
-- SELECT * FROM [EXPLAIN (DISTSQL) CREATE STATISTICS s FROM t] WHERE info LIKE 'distribution%';

-- Test 7: query (line 47)
DROP STATISTICS IF EXISTS s;
CREATE STATISTICS s ON k, v FROM t;



RESET client_min_messages;
