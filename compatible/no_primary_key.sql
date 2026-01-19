-- PostgreSQL compatible tests from no_primary_key
-- 15 tests

-- Test 1: statement (line 1)
CREATE TABLE t (
  a INT,
  b INT
)

-- Test 2: statement (line 7)
INSERT INTO t VALUES (1, 2)

-- Test 3: statement (line 10)
INSERT INTO t VALUES (1, 2)

-- Test 4: statement (line 13)
INSERT INTO t VALUES (3, 4)

-- Test 5: query (line 16)
SELECT a, b FROM t

-- Test 6: query (line 23)
SELECT count(rowid) FROM t

-- Test 7: statement (line 33)
INSERT INTO t VALUES (5, 6, '7')

-- Test 8: query (line 36)
select * from t

-- Test 9: statement (line 44)
SELECT a, b, c, rowid FROM t

-- Test 10: statement (line 47)
INSERT INTO t (a, rowid) VALUES (10, 11)

-- Test 11: query (line 50)
SELECT rowid FROM t WHERE a = 10

-- Test 12: query (line 55)
SELECT * FROM [SHOW COLUMNS FROM t] ORDER BY 1

-- Test 13: statement (line 63)
CREATE INDEX a_idx ON t (a)

-- Test 14: statement (line 66)
INSERT INTO t DEFAULT VALUES

-- Test 15: statement (line 69)
INSERT INTO t (a, b) DEFAULT VALUES

