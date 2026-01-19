-- PostgreSQL compatible tests from explain
-- 5 tests

-- Test 1: statement (line 3)
CREATE TABLE t (a INT PRIMARY KEY)

-- Test 2: query (line 7)
SELECT info FROM [EXPLAIN (DISTSQL) SELECT * FROM (SELECT avg(a) OVER () FROM t)] WHERE info NOT LIKE 'vectorized%'

-- Test 3: statement (line 23)
EXPLAIN (DISTSQL) SELECT avg(a) OVER (ROWS (SELECT count(*) FROM t) PRECEDING) FROM t

-- Test 4: statement (line 28)
CREATE TABLE t88037 AS
SELECT g, g % 2 = 1 AS _bool, '0.0.0.0'::INET + g AS _inet
FROM generate_series(1, 5) AS g;

-- Test 5: query (line 33)
SELECT info FROM [
  EXPLAIN
  SELECT NULL AS col_1372
  FROM t88037@[0] AS tab_489
  WHERE tab_489._bool
  ORDER BY tab_489._inet, tab_489._bool ASC
  LIMIT 92:::INT8
] WHERE info NOT LIKE 'vectorized%'

