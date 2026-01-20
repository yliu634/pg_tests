SET client_min_messages = warning;

-- PostgreSQL compatible tests from lock_timeout
-- 36 tests

-- Test 1: statement (line 2)
DROP TABLE IF EXISTS t CASCADE;
DROP TABLE IF EXISTS t CASCADE;
CREATE TABLE t (k INT PRIMARY KEY, v int);

-- Test 2: statement (line 5)
-- COMMENTED: Logic test uses a separate user/session; keep single-user for psql execution.
-- GRANT ALL ON t TO testuser;

-- Test 3: statement (line 8)
INSERT INTO t VALUES (1, 1);

-- Test 4: statement (line 11)
BEGIN; UPDATE t SET v = 2 WHERE k = 1;

-- COMMENTED: Logic test directive: user testuser

-- Test 5: statement (line 18)
SET lock_timeout = '1ms';

-- skipif config weak-iso-level-configs

-- Test 6: statement (line 22)
SELECT * FROM t;

-- Test 7: statement (line 28)
SELECT * FROM t;

-- Test 8: statement (line 31)
SELECT * FROM t FOR UPDATE;

-- Test 9: statement (line 34)
SELECT * FROM t FOR UPDATE NOWAIT;

-- skipif config weak-iso-level-configs

-- Test 10: statement (line 38)
SELECT * FROM t WHERE k = 1;

-- Test 11: statement (line 44)
SELECT * FROM t WHERE k = 1;

-- Test 12: statement (line 47)
SELECT * FROM t WHERE k = 1 FOR UPDATE;

-- Test 13: statement (line 50)
SELECT * FROM t WHERE k = 1 FOR UPDATE NOWAIT;

-- Test 14: statement (line 53)
SELECT * FROM t WHERE k = 2;

-- Test 15: statement (line 56)
SELECT * FROM t WHERE k = 2 FOR UPDATE;

-- Test 16: statement (line 59)
SELECT * FROM t WHERE k = 2 FOR UPDATE NOWAIT;

-- skipif config weak-iso-level-configs

-- Test 17: statement (line 63)
SELECT * FROM t WHERE v = 9;

-- Test 18: statement (line 69)
SELECT * FROM t WHERE v = 9;

-- skipif config weak-iso-level-configs

-- Test 19: statement (line 73)
SELECT * FROM t WHERE v = 9 FOR UPDATE;

-- Test 20: statement (line 79)
SELECT * FROM t WHERE v = 9;

-- skipif config weak-iso-level-configs

-- Test 21: statement (line 83)
SELECT * FROM t WHERE v = 9 FOR UPDATE NOWAIT;

-- Test 22: statement (line 89)
SELECT * FROM t WHERE v = 9 FOR UPDATE NOWAIT;

-- Test 23: statement (line 92)
INSERT INTO t VALUES (1, 3) ON CONFLICT (k) DO NOTHING;

-- Test 24: statement (line 95)
INSERT INTO t VALUES (2, 3);

-- Test 25: statement (line 98)
INSERT INTO t VALUES (1, 3) ON CONFLICT (k) DO UPDATE SET v = EXCLUDED.v;

-- Test 26: statement (line 101)
INSERT INTO t VALUES (2, 3) ON CONFLICT (k) DO UPDATE SET v = EXCLUDED.v;

-- Test 27: statement (line 104)
UPDATE t SET v = 4;

-- Test 28: statement (line 107)
UPDATE t SET v = 4 WHERE k = 1;

-- Test 29: statement (line 110)
UPDATE t SET v = 4 WHERE k = 2;

-- skipif config weak-iso-level-configs

-- Test 30: statement (line 114)
UPDATE t SET v = 4 WHERE v = 9;

-- onlyif config weak-iso-level-configs

-- Test 31: statement (line 118)
UPDATE t SET v = 4 WHERE v = 9;

-- Test 32: statement (line 121)
DELETE FROM t;

-- Test 33: statement (line 124)
DELETE FROM t WHERE k = 1;

-- Test 34: statement (line 127)
DELETE FROM t WHERE k = 2;

-- skipif config weak-iso-level-configs

-- Test 35: statement (line 131)
DELETE FROM t WHERE v = 9;
-- onlyif config weak-iso-level-configs

-- Test 36: statement (line 135)
DELETE FROM t WHERE v = 9;



RESET client_min_messages;
