-- PostgreSQL compatible tests from statement_source
-- 16 tests

-- Test 1: statement (line 2)
CREATE TABLE a (a INT PRIMARY KEY, b INT)

-- Test 2: query (line 5)
SELECT 1 FROM [INSERT INTO a VALUES (1, 2)]

query error statement source "DELETE FROM a" does not return any columns
SELECT 1 FROM [DELETE FROM a]

query II
SELECT b, a+b FROM [INSERT INTO a VALUES (1,2) RETURNING b,a]

-- Test 3: query (line 17)
WITH a AS (INSERT INTO a VALUES (2,3), (3,4) RETURNING a,b)
SELECT * FROM a LIMIT 0

-- Test 4: query (line 22)
SELECT * FROM [INSERT INTO a VALUES (4,5), (5,6) RETURNING a,b] LIMIT 0

-- Test 5: query (line 26)
WITH a AS (UPSERT INTO a VALUES (2,3), (6,7) RETURNING a,b)
SELECT * FROM a LIMIT 0

-- Test 6: query (line 31)
SELECT * FROM [UPSERT INTO a VALUES (4,5), (7,8) RETURNING a,b] LIMIT 0

-- Test 7: query (line 36)
WITH a AS (UPDATE a SET a = -a WHERE b % 2 = 1 RETURNING a,b)
SELECT * FROM a LIMIT 0

-- Test 8: query (line 41)
SELECT * FROM [UPDATE a SET a = a*100 WHERE b < 3 RETURNING a,b] LIMIT 0

-- Test 9: query (line 45)
SELECT * FROM a ORDER BY b

-- Test 10: query (line 56)
WITH a AS (DELETE FROM a WHERE b IN (4,5) RETURNING a,b)
SELECT * FROM a LIMIT 0

-- Test 11: query (line 61)
SELECT * FROM [DELETE FROM a WHERE b IN (6,7) RETURNING a,b] LIMIT 0

-- Test 12: query (line 66)
SELECT * FROM a ORDER BY b

-- Test 13: statement (line 75)
CREATE TABLE b (a int, b int);

-- Test 14: query (line 78)
SELECT * FROM (VALUES (1, 2)) WHERE EXISTS (SELECT * FROM [INSERT INTO b VALUES (1,2) RETURNING a,b]);

-- Test 15: query (line 83)
SELECT 1 FROM [INSERT INTO b VALUES(2,3) RETURNING b] JOIN [INSERT INTO b VALUES(4,5) RETURNING b] ON true;

-- Test 16: query (line 88)
SELECT * FROM [INSERT INTO b VALUES(2,3) RETURNING b] JOIN [INSERT INTO b VALUES(4,5) RETURNING b, a] ON true;

