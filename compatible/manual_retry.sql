SET client_min_messages = warning;

-- PostgreSQL compatible tests from manual_retry
-- 51 tests

-- Test 1: statement (line 4)
CREATE SEQUENCE s;

-- Test 2: query (line 9)
-- COMMENTED: CockroachDB-specific: SELECT IF(nextval('s')<3, crdb_internal.force_retry('1h':::INTERVAL), 0);

-- Test 3: query (line 15)
SELECT currval('s');

-- Test 4: statement (line 20)
DROP SEQUENCE s;

-- Test 5: statement (line 25)
CREATE SEQUENCE s;

-- Test 6: statement (line 28)
BEGIN TRANSACTION;
  SAVEPOINT cockroach_restart;

-- Test 7: statement (line 34)
SELECT 1;

-- skipif config local-read-committed

-- Test 8: query (line 38)
-- COMMENTED: CockroachDB-specific: SELECT crdb_internal.force_retry('1h':::INTERVAL)

-- onlyif config local-read-committed
-- COMMENTED: CockroachDB-specific: query error restart transaction: read committed retry limit exceeded; set by max_retries_for_read_committed=100: TransactionRetryWithProtoRefreshError: forced by crdb_internal.force_retry\(\)
-- COMMENTED: CockroachDB-specific: SELECT crdb_internal.force_retry('1h':::INTERVAL)

-- statement ok
ROLLBACK TO SAVEPOINT cockroach_restart;

-- query I
-- COMMENTED: CockroachDB-specific: SELECT IF(nextval('s')<3, crdb_internal.force_retry('1h':::INTERVAL), 0);

-- Test 9: query (line 54)
SELECT currval('s');

-- Test 10: statement (line 59)
COMMIT;

-- Test 11: statement (line 66)
BEGIN;

-- Test 12: statement (line 69)
SAVEPOINT cockroach_restart;

-- Test 13: query (line 72)
SHOW TRANSACTION STATUS;

-- Test 14: statement (line 77)
RELEASE SAVEPOINT cockroach_restart;

-- Test 15: query (line 80)
SHOW TRANSACTION STATUS;

-- Test 16: statement (line 85)
ROLLBACK;

-- Test 17: statement (line 89)
BEGIN;

-- Test 18: statement (line 92)
SAVEPOINT "COCKROACH_RESTART";

-- Test 19: query (line 95)
SHOW TRANSACTION STATUS;

-- Test 20: statement (line 100)
RELEASE SAVEPOINT "COCKROACH_RESTART";

-- Test 21: query (line 103)
SHOW TRANSACTION STATUS;

-- Test 22: statement (line 108)
ROLLBACK;

-- Test 23: statement (line 117)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- Test 24: statement (line 120)
SET LOCAL autocommit_before_ddl=off;

-- Test 25: statement (line 123)
SAVEPOINT cockroach_restart;

-- Test 26: statement (line 126)
DROP TABLE IF EXISTS t CASCADE;
CREATE TABLE t (
id INT PRIMARY KEY
);

-- Test 27: statement (line 131)
ROLLBACK TO SAVEPOINT cockroach_restart;

-- Test 28: statement (line 137)
DROP TABLE IF EXISTS t CASCADE;
CREATE TABLE t (
id INT PRIMARY KEY
);

-- Test 29: statement (line 142)
INSERT INTO t (id) VALUES (1);

-- Test 30: statement (line 145)
COMMIT;

-- Test 31: query (line 148)
SELECT id FROM t;

-- Test 32: query (line 155)
show session force_savepoint_restart;

-- Test 33: statement (line 160)
SET force_savepoint_restart = true;

-- Test 34: query (line 163)
show session force_savepoint_restart;

-- Test 35: statement (line 169)
BEGIN TRANSACTION; SAVEPOINT something_else; COMMIT;

-- Test 36: statement (line 173)
BEGIN TRANSACTION; SAVEPOINT foo;

-- Test 37: statement (line 176)
ROLLBACK TO SAVEPOINT bar;

-- Test 38: statement (line 180)
ROLLBACK TO SAVEPOINT FOO;

-- Test 39: statement (line 183)
ABORT; BEGIN TRANSACTION;

-- Test 40: statement (line 187)
SAVEPOINT "Foo Bar";

-- Test 41: statement (line 190)
ROLLBACK TO SAVEPOINT FooBar;

-- Test 42: statement (line 194)
ROLLBACK TO SAVEPOINT "foo bar";

-- Test 43: statement (line 197)
ROLLBACK TO SAVEPOINT "Foo Bar";

-- Test 44: query (line 200)
SHOW SAVEPOINT STATUS;

-- Test 45: statement (line 206)
ABORT; BEGIN TRANSACTION;

-- Test 46: statement (line 210)
SAVEPOINT "UpperCase";

-- Test 47: statement (line 213)
ROLLBACK TO SAVEPOINT UpperCase;

-- Test 48: query (line 216)
SHOW SAVEPOINT STATUS;

-- Test 49: statement (line 222)
ABORT;

-- Test 50: statement (line 225)
RESET force_savepoint_restart;

-- Test 51: query (line 228)
show session force_savepoint_restart;



RESET client_min_messages;