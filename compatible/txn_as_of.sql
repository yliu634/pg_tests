-- PostgreSQL compatible tests from txn_as_of
-- 51 tests

-- Test 1: statement (line 6)
CREATE TABLE t (i INT)

-- Test 2: statement (line 9)
INSERT INTO t VALUES (2)

-- Test 3: statement (line 17)
SET CLUSTER SETTING kv.gc_ttl.strict_enforcement.enabled = false

-- Test 4: statement (line 23)
COMMIT

-- Test 5: statement (line 29)
COMMIT

-- Test 6: query (line 35)
SELECT * FROM t

-- Test 7: statement (line 40)
COMMIT

-- Test 8: query (line 46)
SELECT * FROM t

-- Test 9: statement (line 51)
COMMIT

-- Test 10: statement (line 63)
COMMIT

-- Test 11: statement (line 69)
COMMIT

-- Test 12: statement (line 75)
COMMIT

-- Test 13: statement (line 81)
COMMIT

-- Test 14: statement (line 89)
INSERT INTO t VALUES (3)

-- Test 15: statement (line 92)
COMMIT

-- Test 16: statement (line 98)
INSERT INTO t VALUES (3)

-- Test 17: statement (line 101)
COMMIT

-- Test 18: query (line 110)
SELECT * FROM t

-- Test 19: statement (line 115)
COMMIT

-- Test 20: statement (line 124)
SELECT * FROM t

-- Test 21: statement (line 127)
COMMIT

-- Test 22: statement (line 136)
COMMIT

-- Test 23: statement (line 142)
BEGIN

-- Test 24: statement (line 148)
COMMIT

-- Test 25: statement (line 162)
COMMIT

-- Test 26: query (line 174)
SELECT * FROM (SELECT now())

-- Test 27: statement (line 179)
COMMIT

-- Test 28: statement (line 188)
SAVEPOINT cockroach_restart;

-- Test 29: query (line 191)
SELECT * FROM (SELECT now())

-- Test 30: statement (line 196)
ROLLBACK TO SAVEPOINT cockroach_restart;

-- Test 31: query (line 199)
SELECT * FROM (SELECT now())

-- Test 32: statement (line 204)
RELEASE SAVEPOINT cockroach_restart

-- Test 33: statement (line 207)
COMMIT;

-- Test 34: statement (line 213)
BEGIN;

-- Test 35: statement (line 219)
SAVEPOINT cockroach_restart;

-- Test 36: query (line 222)
SELECT * FROM (SELECT now())

-- Test 37: statement (line 227)
ROLLBACK TO SAVEPOINT cockroach_restart;

-- Test 38: query (line 230)
SELECT * FROM (SELECT now())

-- Test 39: statement (line 235)
RELEASE SAVEPOINT cockroach_restart

-- Test 40: statement (line 238)
COMMIT;

-- Test 41: statement (line 244)
BEGIN;

-- Test 42: statement (line 250)
SAVEPOINT cockroach_restart;

-- Test 43: statement (line 253)
SELCT;

-- Test 44: statement (line 256)
ROLLBACK TO SAVEPOINT cockroach_restart;

-- Test 45: query (line 259)
SELECT * FROM (SELECT now())

-- Test 46: statement (line 264)
RELEASE SAVEPOINT cockroach_restart

-- Test 47: statement (line 267)
COMMIT

-- Test 48: statement (line 276)
BEGIN

-- Test 49: statement (line 282)
ROLLBACK

-- Test 50: statement (line 288)
BEGIN

-- Test 51: statement (line 294)
ROLLBACK

