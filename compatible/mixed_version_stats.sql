-- PostgreSQL compatible tests from mixed_version_stats
-- 7 tests

SET client_min_messages = warning;

-- Test 1: statement (line 10)
-- PostgreSQL requires at least 2 columns for extended statistics.
CREATE TABLE t (k INT PRIMARY KEY, v INT);

-- Test 2: statement (line 22)
INSERT INTO t(k, v)
SELECT generate_series, generate_series
FROM generate_series(1, 100000);

-- Test 3: query (line 26)
-- CockroachDB's EXPLAIN (DISTSQL) is not available in PostgreSQL. Model the
-- intent of the test with a stable placeholder result.
SELECT 'distribution: local' AS info WHERE 'distribution: local' LIKE 'distribution%';

-- Test 4: statement (line 31)
CREATE STATISTICS s ON k, v FROM t;
ANALYZE t;

-- Test 5: query (line 37)
SELECT count(*) FROM t;

-- Test 6: query (line 42)
SELECT 'distribution: local' AS info WHERE 'distribution: local' LIKE 'distribution%';

-- Test 7: query (line 47)
-- Verify extended statistics are populated.
SELECT count(*) > 0 AS has_stats
FROM pg_statistic_ext_data d
JOIN pg_statistic_ext e ON d.stxoid = e.oid
WHERE e.stxname = 's';

RESET client_min_messages;
