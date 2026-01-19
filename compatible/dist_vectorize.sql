-- PostgreSQL compatible tests from dist_vectorize
-- 14 tests

-- Test 1: statement (line 3)
CREATE TABLE kv (k INT PRIMARY KEY, v INT)

-- Test 2: statement (line 6)
INSERT INTO kv SELECT i, i FROM generate_series(1,5) AS g(i)

-- Test 3: statement (line 9)
CREATE TABLE kw (k INT PRIMARY KEY, w INT)

-- Test 4: statement (line 12)
INSERT INTO kw SELECT i, i FROM generate_series(1,5) AS g(i)

-- Test 5: query (line 57)
SELECT kv.k FROM kv JOIN kw ON kv.k = kw.k

-- Test 6: statement (line 66)
RESET vectorize

-- Test 7: query (line 70)
SELECT EXISTS(SELECT * FROM kv WHERE k > 2)

-- Test 8: statement (line 77)
CREATE TABLE t1(a INT PRIMARY KEY, b INT)

-- Test 9: statement (line 80)
INSERT INTO t1 VALUES (1, NULL), (2, NULL)

-- Test 10: query (line 83)
SELECT CASE WHEN a>1 THEN b*2 ELSE b*10 END FROM t1

-- Test 11: query (line 100)
SELECT 1::INT2, s COLLATE en FROM t66306;

-- Test 12: statement (line 107)
SET direct_columnar_scans_enabled = false

-- Test 13: query (line 112)
EXPLAIN (VEC) SELECT 1::INT2, s COLLATE en FROM t66306;

-- Test 14: statement (line 124)
RESET direct_columnar_scans_enabled

