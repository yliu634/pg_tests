-- PostgreSQL compatible tests from save_table
-- 17 tests

-- Test 1: statement (line 3)
CREATE DATABASE savetables; USE savetables

-- Test 2: statement (line 9)
INSERT INTO t SELECT i, to_english(i) FROM generate_series(1, 5) AS g(i)

-- Test 3: statement (line 15)
INSERT INTO u SELECT i, to_english(i) FROM generate_series(2, 10) AS g(i)

-- Test 4: statement (line 18)
SET save_tables_prefix = 'save_table_test'

-- Test 5: query (line 21)
SELECT * FROM t

-- Test 6: query (line 30)
SELECT * FROM u

statement ok
SET save_tables_prefix = 'st_test'

query IT rowsort
SELECT u.key, t.str FROM t, u WHERE t.k = u.key AND t.k >= 3

-- Test 7: statement (line 43)
SET save_tables_prefix = 'st'

-- Test 8: query (line 46)
SELECT u.key, t.str FROM t, u WHERE t.k = u.key AND u.val LIKE 't%'

-- Test 9: statement (line 53)
SET save_tables_prefix = ''

-- Test 10: query (line 56)
SELECT * FROM st_test_merge_join_2 ORDER BY k

-- Test 11: query (line 64)
SELECT * FROM st_scan_4 ORDER BY key

-- Test 12: query (line 78)
SHOW TABLES

-- Test 13: statement (line 95)
GRANT ALL ON t TO testuser

user testuser

-- Test 14: statement (line 100)
USE savetables

-- Test 15: query (line 103)
SELECT * FROM t

-- Test 16: statement (line 112)
SET save_tables_prefix = 'tt'

-- Test 17: statement (line 115)
SELECT * FROM t

