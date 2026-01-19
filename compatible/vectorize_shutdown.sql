-- PostgreSQL compatible tests from vectorize_shutdown
-- 5 tests

-- Test 1: statement (line 4)
CREATE TABLE square (n INT PRIMARY KEY, sq INT)

-- Test 2: statement (line 7)
INSERT INTO square VALUES (1,1), (2,4), (3,9), (4,16), (5,25), (6,36)

-- Test 3: statement (line 10)
CREATE TABLE pairs (a INT8, b INT8, FAMILY (a), FAMILY (b))

-- Test 4: statement (line 13)
INSERT INTO pairs VALUES (1,1), (1,2), (1,3), (1,4), (1,5), (1,6), (2,3), (2,4), (2,5), (2,6), (3,4), (3,5), (3,6), (4,5), (4,6)

-- Test 5: statement (line 16)
SELECT
	*
FROM
	(
		SELECT
			*
		FROM
			pairs
			LEFT JOIN square ON b = sq AND a > 1 AND n < 6
	)
WHERE
	b > 1 AND (n IS NULL OR n > 1) AND (n IS NULL OR a < sq)

