-- PostgreSQL compatible tests from operator
-- 10 tests

-- Test 1: query (line 1)
SELECT |/ 1.0::float;

-- COMMENTED: Logic test directive: query error cannot take square root of a negative number
SELECT |/ 1.0::decimal;

-- query I
SELECT ~(-1);

-- Test 2: query (line 12)
SELECT ~0;

-- Test 3: query (line 17)
SELECT ~1;

-- Test 4: query (line 22)
SELECT ~2;

-- Test 5: query (line 27)
SELECT ~B'0';

-- Test 6: query (line 32)
SELECT ~B'1';

-- Test 7: statement (line 37)
SELECT ~B'10';

-- Test 8: statement (line 40)
SELECT ~('0'::bit(1));

-- Test 9: statement (line 43)
SELECT ~('1'::bit(1));

-- Test 10: query (line 46)
SELECT ~2;
