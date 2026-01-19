-- PostgreSQL compatible tests from column_families
-- 22 tests

-- Test 1: statement (line 5)
CREATE TABLE t (x INT PRIMARY KEY, y INT, z INT, FAMILY (y), FAMILY (z), FAMILY (x));
INSERT INTO t VALUES (1, 2, 3), (4, 5, 6)

-- Test 2: query (line 9)
SELECT * FROM t

-- Test 3: statement (line 15)
UPDATE t SET x = 2 WHERE y = 2

-- Test 4: query (line 18)
SELECT * FROM t

-- Test 5: statement (line 24)
UPDATE t SET z = 3 WHERE x = 4

-- Test 6: query (line 27)
SELECT * FROM t

-- Test 7: query (line 33)
SELECT y, z FROM t WHERE x = 2

-- Test 8: statement (line 38)
DROP TABLE t;

-- Test 9: statement (line 41)
CREATE TABLE t (x DECIMAL PRIMARY KEY, y INT, FAMILY (y), FAMILY (x));

-- Test 10: statement (line 44)
INSERT INTO t VALUES (5.607, 1), (5.6007, 2)

-- Test 11: query (line 47)
SELECT * FROM t

-- Test 12: statement (line 56)
DROP TABLE t;

-- Test 13: statement (line 59)
CREATE TABLE t (x DECIMAL, y DECIMAL, z INT, FAMILY (z), FAMILY (y), FAMILY (x), PRIMARY KEY (x, y));

-- Test 14: statement (line 62)
INSERT INTO t VALUES (1.00, 2.00, 1)

-- Test 15: query (line 74)
SELECT message FROM [SHOW KV TRACE FOR SESSION] WHERE
message LIKE 'fetched: /t/t_pkey/%'
ORDER BY message

-- Test 16: statement (line 85)
CREATE TABLE abc (a INT NOT NULL, b FLOAT NOT NULL, c INT, FAMILY (a), FAMILY (b), FAMILY (c))

-- Test 17: statement (line 88)
INSERT INTO abc VALUES (4, -0, 6)

-- Test 18: statement (line 91)
ALTER TABLE abc ADD PRIMARY KEY (a, b)

-- Test 19: statement (line 94)
UPDATE abc SET c = NULL WHERE a = 4 AND b = -0

-- Test 20: query (line 97)
SELECT * FROM abc

-- Test 21: statement (line 102)
UPDATE abc SET b = 0 WHERE a = 4 AND b = -0;

-- Test 22: query (line 105)
SELECT * FROM abc

