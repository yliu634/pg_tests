-- PostgreSQL compatible tests from stats
-- 20 tests

-- Test 1: statement (line 6)
SET CLUSTER SETTING jobs.registry.interval.adopt = '10ms'

-- Test 2: statement (line 14)
CREATE TABLE t (c INT2);

-- Test 3: statement (line 21)
INSERT INTO t SELECT generate_series(1, 10000);
INSERT INTO t SELECT generate_series(-10000, 0);

-- Test 4: statement (line 25)
ANALYZE t;

-- Test 5: query (line 37)
SELECT CASE
  WHEN (SELECT count(*) FROM [SHOW HISTOGRAM $histogram_id]) = 2
    THEN true -- if the sampling picked the boundary values, we're happy
  ELSE
    (SELECT min(upper_bound::INT) = -32768 AND max(upper_bound::INT) = 32767 FROM [SHOW HISTOGRAM $histogram_id])
  END

-- Test 6: statement (line 49)
CREATE TYPE greeting AS ENUM ('hello', 'hi', 'yo');

-- Test 7: statement (line 55)
ANALYZE t122312;

-- Test 8: statement (line 60)
INSERT INTO t122312 VALUES ('hi');

-- Test 9: statement (line 63)
ANALYZE t122312;

-- Test 10: statement (line 66)
BEGIN;
ALTER TYPE greeting ADD VALUE 'hey';
SELECT * FROM t122312 WHERE g = 'hi';
COMMIT;

-- Test 11: statement (line 82)
INSERT INTO t139381
SELECT i, ('{"name": "name_' || i || '", "data": "abcdefghij"}')::JSONB
FROM (VALUES (1), (2)) v(i)

-- Test 12: statement (line 87)
ANALYZE t139381

-- Test 13: query (line 90)
SELECT column_names, IF(histogram_id IS NOT NULL, 'histogram_collected', 'no_histogram_collected')
FROM [SHOW STATISTICS FOR TABLE t139381]

-- Test 14: statement (line 100)
SET CLUSTER SETTING sql.stats.non_indexed_json_histograms.enabled = true

-- Test 15: statement (line 103)
ANALYZE t139381

-- Test 16: query (line 106)
SELECT column_names, IF(histogram_id IS NOT NULL, 'histogram_collected', 'no_histogram_collected')
FROM [SHOW STATISTICS FOR TABLE t139381]

-- Test 17: statement (line 116)
CREATE TABLE t141448 (i INT, f FLOAT, b BOOL);

-- Test 18: statement (line 119)
INSERT INTO t141448 VALUES (NULL, NULL, false), (NULL, 1, false), (1, 1, false);

-- Test 19: statement (line 122)
ANALYZE t141448;

-- Test 20: query (line 125)
SELECT row_count, distinct_count FROM [SHOW STATISTICS FOR TABLE t141448] WHERE column_names = ARRAY['b'];

