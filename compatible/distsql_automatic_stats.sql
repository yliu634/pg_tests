-- PostgreSQL compatible tests from distsql_automatic_stats
-- 23 tests

-- Test 1: statement (line 4)
SET CLUSTER SETTING jobs.registry.interval.adopt = '10ms'

-- Test 2: statement (line 8)
CREATE TABLE data (a INT, b INT, c FLOAT, d DECIMAL, PRIMARY KEY (a, b, c), INDEX d_idx (d)) WITH (sql_stats_automatic_collection_enabled = true)

-- Test 3: statement (line 12)
INSERT INTO data SELECT a, b, c::FLOAT, NULL FROM
   generate_series(1, 10) AS a(a),
   generate_series(1, 10) AS b(b),
   generate_series(1, 10) AS c(c)

-- Test 4: query (line 22)
SELECT DISTINCT ON (column_names) statistics_name, column_names, row_count, distinct_count, null_count
FROM [SHOW STATISTICS FOR TABLE data] ORDER BY column_names, created DESC

-- Test 5: statement (line 35)
ALTER TABLE data SET (sql_stats_automatic_collection_enabled = false)

-- Test 6: statement (line 39)
UPDATE data SET d = 10 WHERE (a = 1 OR a = 2 OR a = 3) AND b > 1

-- Test 7: query (line 43)
SELECT DISTINCT ON (column_names) statistics_name, column_names, row_count, distinct_count, null_count
FROM [SHOW STATISTICS FOR TABLE data] ORDER BY column_names ASC, created DESC

-- Test 8: statement (line 56)
ALTER TABLE data SET (sql_stats_automatic_collection_enabled = true)

-- Test 9: statement (line 60)
UPDATE data SET d = 12 WHERE d = 10

-- Test 10: query (line 76)
SELECT DISTINCT ON (column_names) statistics_name, column_names, row_count, distinct_count, null_count
FROM [SHOW STATISTICS FOR TABLE data] ORDER BY column_names ASC, created DESC

-- Test 11: statement (line 89)
UPSERT INTO data SELECT a, b, c::FLOAT, 1 FROM
generate_series(1, 11) AS a(a),
generate_series(1, 10) AS b(b),
generate_series(1, 5) AS c(c)

-- Test 12: query (line 95)
SELECT DISTINCT ON (column_names) statistics_name, column_names, row_count, distinct_count, null_count
FROM [SHOW STATISTICS FOR TABLE data] ORDER BY column_names ASC, created DESC

-- Test 13: statement (line 108)
DELETE FROM data WHERE c > 5

-- Test 14: query (line 111)
SELECT DISTINCT ON (column_names) statistics_name, column_names, row_count, distinct_count, null_count
FROM [SHOW STATISTICS FOR TABLE data] ORDER BY column_names ASC, created DESC

-- Test 15: statement (line 124)
CREATE TABLE copy WITH (sql_stats_automatic_collection_enabled = true) AS SELECT * FROM data

-- Test 16: query (line 129)
SELECT DISTINCT ON (column_names) statistics_name, column_names, row_count, null_count
FROM [SHOW STATISTICS FOR TABLE copy] ORDER BY column_names ASC, created DESC

-- Test 17: statement (line 140)
CREATE TABLE test_create (x INT PRIMARY KEY, y CHAR) WITH (sql_stats_automatic_collection_enabled = true)

-- Test 18: query (line 143)
SELECT DISTINCT ON (column_names) statistics_name, column_names, row_count, distinct_count, null_count
FROM [SHOW STATISTICS FOR TABLE test_create] ORDER BY column_names ASC, created DESC

-- Test 19: statement (line 152)
DELETE FROM copy WHERE true

-- Test 20: query (line 155)
SELECT DISTINCT ON (column_names) statistics_name, column_names, row_count, null_count
FROM [SHOW STATISTICS FOR TABLE copy] ORDER BY column_names ASC, created DESC

-- Test 21: statement (line 175)
ALTER TABLE my_schema.my_table SET (sql_stats_automatic_collection_enabled = true)

-- Test 22: statement (line 179)
INSERT INTO my_schema.my_table SELECT k, NULL FROM
   generate_series(1, 10) AS k(k)

-- Test 23: query (line 183)
SELECT DISTINCT ON (column_names) statistics_name, column_names, row_count, distinct_count, null_count
FROM [SHOW STATISTICS FOR TABLE my_schema.my_table] ORDER BY column_names ASC, created DESC

