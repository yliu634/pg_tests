-- PostgreSQL compatible tests from distsql_tenant_locality
-- 5 tests

-- Test 1: statement (line 11)
CREATE TABLE t (k INT PRIMARY KEY, v INT, FAMILY (k, v));
INSERT INTO t SELECT i, i FROM generate_series(1, 6) AS g(i)

-- Test 2: statement (line 54)
SELECT * FROM t

-- Test 3: query (line 58)
SELECT * FROM t WHERE k IN (1, 3, 5)

-- Test 4: query (line 66)
SELECT * FROM t WHERE k >= 3 AND k < 5

-- Test 5: query (line 73)
SELECT * FROM t WHERE k >= 1 LIMIT 10

