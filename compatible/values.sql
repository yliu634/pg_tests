-- PostgreSQL compatible tests from values
-- 7 tests

-- Test 1: query (line 2)
SELECT 1

-- Test 2: query (line 7)
SELECT 1 + 2

-- Test 3: query (line 12)
VALUES (1, 2, 3), (4, 5, 6)

-- Test 4: query (line 19)
VALUES (length('a')), (1 + length('a')), (length('abc')), (length('ab') * 2)

-- Test 5: query (line 27)
SELECT a + b FROM (VALUES (1, 2), (3, 4), (5, 6)) AS v(a, b)

-- Test 6: query (line 34)
VALUES (1), (2, 3)

query I
VALUES (1), (1), (2), (3) ORDER BY 1 DESC LIMIT 3

-- Test 7: query (line 44)
VALUES (1), (1), (2), (3) ORDER BY z

# subqueries can be evaluated in VALUES
query I nosort
VALUES ((SELECT 1)), ((SELECT 2))

