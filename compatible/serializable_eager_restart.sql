-- PostgreSQL compatible tests from serializable_eager_restart
-- 11 tests

-- Test 1: statement (line 5)
CREATE TABLE t (a INT)

-- Test 2: statement (line 8)
GRANT ALL on t TO testuser

-- Test 3: statement (line 11)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE

-- Test 4: statement (line 15)
SAVEPOINT cockroach_restart

-- Test 5: query (line 19)
SELECT * FROM t

-- Test 6: statement (line 29)
INSERT INTO t(a) VALUES (2)

-- Test 7: query (line 34)
SELECT * FROM t

-- Test 8: statement (line 43)
INSERT INTO t(a) VALUES (1)

-- Test 9: statement (line 47)
RELEASE SAVEPOINT cockroach_restart

-- Test 10: statement (line 51)
ROLLBACK TO SAVEPOINT cockroach_restart

-- Test 11: query (line 55)
SELECT * FROM t

