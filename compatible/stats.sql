-- PostgreSQL compatible tests from stats
-- 20 tests

SET client_min_messages = warning;
DROP TABLE IF EXISTS t;
DROP TABLE IF EXISTS t122312;
DROP TABLE IF EXISTS t139381;
DROP TABLE IF EXISTS t141448;
DROP TYPE IF EXISTS greeting;
RESET client_min_messages;

-- Test 1: statement (line 6)
SET jobs.registry.interval.adopt = '10ms';

-- Test 2: statement (line 14)
CREATE TABLE t (c INT2);

-- Test 3: statement (line 21)
INSERT INTO t SELECT generate_series(1, 10000);
INSERT INTO t SELECT generate_series(-10000, 0);

-- Test 4: statement (line 25)
ANALYZE t;

-- Test 5: query (line 37)
-- CockroachDB SHOW HISTOGRAM is not available in PostgreSQL; validate the
-- observed data bounds after ANALYZE instead.
SELECT min(c) = -10000 AND max(c) = 10000 FROM t;

-- Test 6: statement (line 49)
CREATE TYPE greeting AS ENUM ('hello', 'hi', 'yo');
CREATE TABLE t122312 (g greeting);

-- Test 7: statement (line 55)
ANALYZE t122312;

-- Test 8: statement (line 60)
INSERT INTO t122312 VALUES ('hi');

-- Test 9: statement (line 63)
ANALYZE t122312;

-- Test 10: statement (line 66)
-- ALTER TYPE ... ADD VALUE cannot run inside a transaction block in PostgreSQL.
ALTER TYPE greeting ADD VALUE IF NOT EXISTS 'hey';
SELECT * FROM t122312 WHERE g = 'hi';

-- Test 11: statement (line 82)
CREATE TABLE t139381 (i INT PRIMARY KEY, j JSONB);
INSERT INTO t139381
SELECT i, ('{"name": "name_' || i || '", "data": "abcdefghij"}')::JSONB
FROM (VALUES (1), (2)) v(i)
;

-- Test 12: statement (line 87)
ANALYZE t139381;

-- Test 13: query (line 90)
SELECT
  attname,
  CASE WHEN histogram_bounds IS NOT NULL THEN 'histogram_collected' ELSE 'no_histogram_collected' END AS histogram_status
FROM pg_stats
WHERE schemaname = 'public' AND tablename = 't139381'
ORDER BY attname;

-- Test 14: statement (line 100)
SET sql.stats.non_indexed_json_histograms.enabled = true;

-- Test 15: statement (line 103)
ANALYZE t139381;

-- Test 16: query (line 106)
SELECT
  attname,
  CASE WHEN histogram_bounds IS NOT NULL THEN 'histogram_collected' ELSE 'no_histogram_collected' END AS histogram_status
FROM pg_stats
WHERE schemaname = 'public' AND tablename = 't139381'
ORDER BY attname;

-- Test 17: statement (line 116)
CREATE TABLE t141448 (i INT, f FLOAT, b BOOL);

-- Test 18: statement (line 119)
INSERT INTO t141448 VALUES (NULL, NULL, false), (NULL, 1, false), (1, 1, false);

-- Test 19: statement (line 122)
ANALYZE t141448;

-- Test 20: query (line 125)
-- Use exact counts (deterministic) instead of CockroachDB SHOW STATISTICS output.
SELECT count(*) AS row_count, count(DISTINCT b) AS distinct_count FROM t141448;
