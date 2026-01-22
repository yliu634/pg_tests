-- PostgreSQL compatible tests from shift
-- 12 tests

-- Test 1: statement (line 3)
CREATE TABLE t AS SELECT 1 AS i;

-- Test 2: statement (line 6)
SELECT i << 64 FROM t;

-- Test 3: statement (line 9)
SELECT i >> 64 FROM t;

-- Test 4: statement (line 12)
SELECT i << -1 FROM t;

-- Test 5: statement (line 15)
SELECT i >> -1 FROM t;

-- Test 6: query (line 18)
SELECT i << 63 >> 63, i << 62 >> 62 FROM t;

-- Test 7: statement (line 25)
SELECT 1 << 64;

-- Test 8: statement (line 28)
SELECT 1 >> 64;

-- Test 9: statement (line 31)
SELECT 1 << -1;

-- Test 10: statement (line 34)
SELECT 1 >> -1;

-- Test 11: query (line 37)
SELECT 1 << 63 >> 63, 1 << 62 >> 62;

-- Test 12: query (line 44)
SELECT 1 << 63 >> 63, 1::INT << 63 >> 63;
