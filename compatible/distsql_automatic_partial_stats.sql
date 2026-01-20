-- PostgreSQL compatible tests from distsql_automatic_partial_stats
-- 29 tests

-- Test 1: statement (line 4)
SET CLUSTER SETTING jobs.registry.interval.adopt = '10ms'

-- Test 2: statement (line 9)
SET CLUSTER SETTING sql.stats.automatic_partial_collection.min_stale_rows = 5

-- Test 3: statement (line 12)
CREATE TABLE data (a INT, b INT, c FLOAT, d DECIMAL, PRIMARY KEY (a, b, c), INDEX c_idx (c), INDEX d_idx (d)) WITH (sql_stats_automatic_partial_collection_enabled = true)

-- Test 4: statement (line 15)
INSERT INTO data SELECT a, b, c::FLOAT, 1 FROM
   generate_series(1, 10) AS a(a),
   generate_series(1, 10) AS b(b),
   generate_series(1, 10) AS c(c)

-- Test 5: query (line 22)
SELECT DISTINCT ON (statistics_name, column_names) statistics_name, column_names, row_count, distinct_count, null_count, partial_predicate
FROM [SHOW STATISTICS FOR TABLE data] ORDER BY statistics_name, column_names, created DESC

-- Test 6: statement (line 29)
CREATE STATISTICS __auto__ FROM data

-- Test 7: query (line 32)
SELECT DISTINCT ON (statistics_name, column_names) statistics_name, column_names, row_count, distinct_count, null_count, partial_predicate
FROM [SHOW STATISTICS FOR TABLE data] ORDER BY statistics_name, column_names, created DESC

-- Test 8: statement (line 45)
SET CLUSTER SETTING sql.stats.automatic_full_collection.enabled = false

-- Test 9: statement (line 48)
SET CLUSTER SETTING sql.stats.automatic_collection.enabled = true

-- Test 10: statement (line 52)
UPDATE DATA SET d = 2 WHERE a = 1

-- Test 11: query (line 59)
SELECT DISTINCT ON (statistics_name, column_names) statistics_name, column_names, row_count, distinct_count, null_count, partial_predicate
FROM [SHOW STATISTICS FOR TABLE data] ORDER BY statistics_name, column_names, created DESC

-- Test 12: statement (line 75)
SET CLUSTER SETTING sql.stats.automatic_full_collection.enabled = true

-- Test 13: statement (line 79)
ALTER TABLE data SET (sql_stats_automatic_partial_collection_enabled = false);
ALTER TABLE data SET (sql_stats_automatic_full_collection_enabled = false)

-- Test 14: statement (line 84)
UPDATE DATA SET d = 3 WHERE a = 1 OR a = 2

-- Test 15: query (line 87)
SELECT DISTINCT ON (statistics_name, column_names) statistics_name, column_names, row_count, distinct_count, null_count, partial_predicate
FROM [SHOW STATISTICS FOR TABLE data] ORDER BY statistics_name, column_names, created DESC

-- Test 16: statement (line 104)
SET CLUSTER SETTING sql.internal_executor.session_overrides = 'EnableCreateStatsUsingExtremes=false';

-- Test 17: statement (line 107)
ALTER TABLE data SET (sql_stats_automatic_partial_collection_enabled = true)

-- Test 18: statement (line 111)
UPDATE DATA SET d = 4 WHERE a = 1 OR a = 2

-- Test 19: query (line 114)
SELECT DISTINCT ON (statistics_name, column_names) statistics_name, column_names, row_count, distinct_count, null_count, partial_predicate
FROM [SHOW STATISTICS FOR TABLE data] ORDER BY statistics_name, column_names, created DESC

-- Test 20: statement (line 129)
SET CLUSTER SETTING sql.internal_executor.session_overrides = 'EnableCreateStatsUsingExtremes=true';

-- Test 21: statement (line 133)
INSERT INTO data SELECT a, b, c FROM
  generate_series(11, 14) AS a(a),
  generate_series(11, 14) AS b(b),
  generate_series(11, 14) AS c(c)

-- Test 22: query (line 139)
SELECT DISTINCT ON (statistics_name, column_names) statistics_name, column_names, row_count, distinct_count, null_count, partial_predicate
FROM [SHOW STATISTICS FOR TABLE data] ORDER BY statistics_name, column_names, created DESC

-- Test 23: statement (line 155)
UPSERT INTO data SELECT a, b, c::FLOAT, 5 FROM
  generate_series(11, 15) AS a(a),
  generate_series(11, 14) AS b(b),
  generate_series(11, 13) AS c(c)

-- Test 24: query (line 161)
SELECT DISTINCT ON (statistics_name, column_names) statistics_name, column_names, row_count, distinct_count, null_count, partial_predicate
FROM [SHOW STATISTICS FOR TABLE data] ORDER BY statistics_name, column_names, created DESC

-- Test 25: statement (line 177)
DELETE FROM data WHERE a > 11

-- Test 26: query (line 180)
SELECT DISTINCT ON (statistics_name, column_names) statistics_name, column_names, row_count, distinct_count, null_count, partial_predicate
FROM [SHOW STATISTICS FOR TABLE data] ORDER BY statistics_name, column_names, created DESC

-- Test 27: statement (line 196)
ALTER TABLE data SET (sql_stats_automatic_partial_collection_enabled = false);
ALTER TABLE data SET (sql_stats_automatic_full_collection_enabled = true)

-- Test 28: statement (line 201)
INSERT INTO data SELECT a, b, c FROM
  generate_series(15, 25) AS a(a),
  generate_series(15, 25) AS b(b),
  generate_series(15, 25) AS c(c)

-- Test 29: query (line 207)
SELECT DISTINCT ON (statistics_name, column_names) statistics_name, column_names, row_count, distinct_count, null_count, partial_predicate
FROM [SHOW STATISTICS FOR TABLE data] ORDER BY statistics_name, column_names, created DESC

