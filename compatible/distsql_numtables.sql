-- PostgreSQL compatible tests from distsql_numtables
-- 18 tests

-- Test 1: statement (line 10)
CREATE TABLE NumToSquare (x INT PRIMARY KEY, xsquared INT)

-- Test 2: statement (line 13)
INSERT INTO NumToSquare SELECT i, i*i FROM generate_series(1, 100) AS g(i)

-- Test 3: statement (line 29)
INSERT INTO NumToStr SELECT i, to_english(i) FROM generate_series(1, 100*100) AS g(i)

-- Test 4: query (line 56)
SELECT 5, 2+y, * FROM NumToStr WHERE y <= 10 ORDER BY str

-- Test 5: query (line 72)
SELECT 5, 2 + y, * FROM NumToStr WHERE y % 1000 = 0 ORDER BY str

-- Test 6: query (line 87)
SELECT str FROM NumToStr WHERE y < 10 AND str LIKE '%e%' ORDER BY y

-- Test 7: query (line 98)
SELECT str FROM NumToStr WHERE y % 1000 = 0 AND str LIKE '%i%' ORDER BY y

-- Test 8: query (line 112)
SELECT i, to_english(i*i) FROM generate_series(1, 100) AS g(i)

# Compare the results of this query to the one above.
query IT rowsort label-sq-str
SELECT x, str FROM NumToSquare JOIN NumToStr ON y = xsquared

# Save the result of the following statement to a label.
query IT rowsort label-sq-2-str
SELECT 2*i, to_english(2*i) FROM generate_series(1, 50) AS g(i)

# Compare the results of this query to the one above.
query IT rowsort label-sq-2-str
SELECT x, str FROM NumToSquare JOIN NumToStr ON x = y WHERE x % 2 = 0


#
# -- Aggregation tests --
#

# Sum the numbers in the NumToStr table. The expected result is
#  n * n * (n * n + 1) / 2
query R
SELECT sum(y) FROM NumToStr

-- Test 9: query (line 140)
SELECT count(*) FROM NumToStr

-- Test 10: query (line 147)
SELECT count(*) FROM NumToStr WHERE str LIKE '%five%'

-- Test 11: query (line 157)
SELECT y FROM NumToStr ORDER BY y LIMIT 5

-- Test 12: query (line 166)
SELECT y FROM NumToStr WHERE y < 1000 OR y > 9000 ORDER BY y DESC LIMIT 5

-- Test 13: query (line 175)
SELECT y FROM NumToStr ORDER BY y OFFSET 5 LIMIT 2

-- Test 14: query (line 180)
SELECT y FROM NumToStr ORDER BY y LIMIT 0

-- Test 15: query (line 184)
SELECT * FROM (SELECT y FROM NumToStr LIMIT 3) AS a ORDER BY y OFFSET 3

-- Test 16: query (line 188)
SELECT y FROM NumToStr ORDER BY str LIMIT 5

-- Test 17: query (line 197)
SELECT y FROM (SELECT y FROM NumToStr ORDER BY y LIMIT 5) AS a WHERE y <> 2

-- Test 18: query (line 206)
SELECT count(*) FROM (SELECT 1 AS one FROM NumToSquare WHERE x > 10 ORDER BY xsquared LIMIT 10)

