-- PostgreSQL compatible tests from experimental_distsql_planning
-- 14 tests

-- Test 1: query (line 31)
SELECT k FROM kv

-- Test 2: query (line 39)
SELECT v FROM kv

-- Test 3: query (line 47)
SELECT v, k FROM kv

-- Test 4: query (line 54)
SELECT v, k, k, v FROM kv

-- Test 5: query (line 61)
SELECT k, v, k + v FROM kv

-- Test 6: query (line 68)
SELECT * FROM kv WHERE k > v

-- Test 7: query (line 79)
SELECT v FROM kv ORDER BY k

-- Test 8: query (line 89)
SELECT v, min(k), max(k) FROM kv GROUP BY v

-- Test 9: query (line 98)
SELECT min(v) FROM kv

-- Test 10: query (line 104)
SELECT v FROM kv ORDER BY v DESC

-- Test 11: query (line 114)
SELECT * FROM generate_series(1, 3)

-- Test 12: query (line 123)
SELECT DISTINCT v FROM kv

-- Test 13: query (line 141)
SELECT n,a,b FROM a WHERE a = 5 AND b = 2

-- Test 14: query (line 146)
SELECT * FROM [EXPLAIN SELECT n,a,b FROM a WHERE a = 5 AND b = 2] WHERE info !~ '(distribution|vectorized):.*'

