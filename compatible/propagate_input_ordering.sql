-- PostgreSQL compatible tests from propagate_input_ordering
-- 16 tests

SET client_min_messages = warning;

-- Test 1: statement (line 1)
-- CockroachDB setting; PostgreSQL preserves ordering only when explicitly
-- specified via ORDER BY.

-- Test 2: query (line 4)
WITH tmp AS (SELECT * FROM generate_series(1, 10) i ORDER BY i % 5 ASC, i ASC) SELECT * FROM tmp;

-- Test 3: query (line 18)
WITH tmp AS (SELECT * FROM generate_series(1, 10) i ORDER BY i % 5 ASC, i ASC) SELECT * FROM tmp;

-- Test 4: query (line 33)
SELECT foo FROM (SELECT i, i%2 FROM generate_series(1, 10) i ORDER BY i % 5 ASC, i ASC) AS foo;

-- Test 5: query (line 48)
SELECT foo.* FROM (SELECT i, i%2 FROM generate_series(1, 10) i ORDER BY i % 5 ASC, i ASC) AS foo;

-- Test 6: query (line 63)
SELECT array_agg(i) FROM (SELECT * FROM generate_series(1, 5) i ORDER BY i%2 DESC, i);

-- Test 7: query (line 69)
SELECT *
FROM (SELECT * FROM generate_series(1, 2) x) tmp,
     (SELECT * FROM generate_series(8, 12) i ORDER BY i % 5 ASC, i ASC) tmp2;

-- Test 8: query (line 87)
WITH tmp AS (SELECT * FROM generate_series(1, 10) i ORDER BY i % 5 ASC, i ASC)
SELECT * FROM tmp ORDER BY i DESC;

-- Test 9: query (line 104)
WITH tmp AS (SELECT * FROM generate_series(1, 10) i ORDER BY i % 5 ASC, i ASC)
SELECT * FROM tmp ORDER BY i DESC;

-- Test 10: statement (line 119)
DROP TABLE IF EXISTS ab;
DROP TABLE IF EXISTS xy;

CREATE TABLE ab (a int, b int);

-- Test 11: statement (line 122)
INSERT INTO ab VALUES (10, 100), (1, 10), (5, 50);

-- Test 12: statement (line 125)
CREATE TABLE xy (x int, y int);

-- Test 13: statement (line 128)
INSERT INTO xy VALUES (2, 20), (8, 80), (4, 41), (4, 40);

-- Test 14: query (line 131)
WITH
  cte1 AS (SELECT b FROM ab ORDER BY a),
  cte2 AS (SELECT y FROM xy ORDER BY x, y)
SELECT * FROM cte1 UNION ALL SELECT * FROM cte2;

-- Test 15: query (line 145)
WITH
  cte1 AS (SELECT b FROM ab ORDER BY a+b),
  cte2 AS (SELECT DISTINCT ON (x) y FROM xy ORDER BY x, y)
SELECT * FROM cte1 UNION ALL SELECT * FROM cte2;

-- Test 16: statement (line 158)
DROP TABLE IF EXISTS ab;
DROP TABLE IF EXISTS xy;

RESET client_min_messages;
