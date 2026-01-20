-- PostgreSQL compatible tests from poison_after_push
-- 18 tests

-- Test 1: statement (line 20)
SET CLUSTER SETTING kv.transaction.write_pipelining.enabled = false

-- Test 2: statement (line 23)
CREATE TABLE t (id INT PRIMARY KEY)

-- Test 3: statement (line 26)
INSERT INTO t VALUES (1)

-- Test 4: statement (line 29)
GRANT ALL ON t TO testuser

-- Test 5: statement (line 32)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE, PRIORITY LOW

-- Test 6: statement (line 35)
INSERT INTO t VALUES (2)

-- Test 7: statement (line 41)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE, PRIORITY HIGH

-- Test 8: query (line 45)
SELECT * FROM t

-- Test 9: statement (line 50)
COMMIT

-- Test 10: query (line 57)
SELECT * FROM t ORDER BY id

-- Test 11: statement (line 65)
COMMIT

-- Test 12: statement (line 70)
BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ, PRIORITY LOW

-- Test 13: statement (line 73)
INSERT INTO t VALUES (3)

user testuser

-- Test 14: statement (line 78)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE, PRIORITY HIGH

-- Test 15: query (line 82)
SELECT * FROM t ORDER BY id

-- Test 16: statement (line 88)
COMMIT

user root

-- Test 17: query (line 93)
SELECT * FROM t ORDER BY id

-- Test 18: statement (line 100)
COMMIT

