-- PostgreSQL compatible tests from serializable_eager_restart
-- 11 tests

-- Test 1: statement (line 5)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- Test 2: statement (line 8)
CREATE ROLE testuser;
CREATE TABLE t (a INT);
GRANT ALL ON TABLE t TO testuser;

-- Test 3: statement (line 11)
SAVEPOINT cockroach_restart;

-- Test 4: statement (line 15)
SELECT * FROM t;

-- Test 5: statement (line 29)
INSERT INTO t(a) VALUES (2);

-- Test 6: query (line 34)
SELECT * FROM t;

-- Test 7: statement (line 43)
INSERT INTO t(a) VALUES (1);

-- Test 8: statement (line 47)
ROLLBACK TO SAVEPOINT cockroach_restart;

-- Test 10: statement (line 51)
RELEASE SAVEPOINT cockroach_restart;

-- Test 11: query (line 55)
SELECT * FROM t;

ROLLBACK;
