-- PostgreSQL compatible tests from two_phase_commit
-- 74 tests

SET client_min_messages = warning;

-- Note: PREPARE TRANSACTION requires `max_prepared_transactions` > 0 (postmaster setting).

-- Test 0: setup
DROP TABLE IF EXISTS t;
DROP ROLE IF EXISTS tpct_testuser;
CREATE ROLE tpct_testuser LOGIN;

-- Test 1: query (line 3)
SHOW max_prepared_transactions;

-- Store the setting for conditional execution below. `\gset` captures the
-- result without printing extra output.
SELECT (current_setting('max_prepared_transactions')::int > 0) AS prepared_txns_enabled \gset

-- Test 2: query (line 8)
SELECT gid AS global_id, owner, database
FROM pg_catalog.pg_prepared_xacts
ORDER BY gid;

-- Test 3: query (line 12)
SELECT gid, owner, database
FROM pg_catalog.pg_prepared_xacts
ORDER BY gid;

-- Test 4: statement (line 16)
CREATE TABLE t (a INT);

-- Test 5: statement (line 19)
GRANT ALL ON t TO tpct_testuser;

\if :prepared_txns_enabled

-- Test 6: statement (line 24)
BEGIN;

-- Test 7: query (line 27)
SELECT * FROM t ORDER BY a;

-- Test 8: statement (line 31)
PREPARE TRANSACTION 'read-only';

-- Test 9: query (line 35)
SELECT gid AS global_id, owner, database
FROM pg_catalog.pg_prepared_xacts
ORDER BY gid;

-- Test 10: query (line 42)
SELECT gid, owner, database
FROM pg_catalog.pg_prepared_xacts
ORDER BY gid;

-- Test 11: statement (line 48)
COMMIT PREPARED 'read-only';

-- Test 12: query (line 52)
SELECT gid AS global_id
FROM pg_catalog.pg_prepared_xacts
ORDER BY gid;

-- Test 13: statement (line 58)
BEGIN;

-- Test 14: query (line 61)
SELECT * FROM t ORDER BY a;

-- Test 15: statement (line 65)
PREPARE TRANSACTION 'read-only';

-- Test 16: statement (line 69)
ROLLBACK PREPARED 'read-only';

-- Test 17: statement (line 74)
BEGIN;

-- Test 18: statement (line 77)
INSERT INTO t(a) VALUES (1);

-- Test 19: statement (line 80)
PREPARE TRANSACTION 'read-write';

-- Test 20: query (line 84)
SELECT gid AS global_id
FROM pg_catalog.pg_prepared_xacts
ORDER BY gid;

-- Test 21: statement (line 90)
COMMIT PREPARED 'read-write';

-- Test 22: query (line 94)
SELECT * FROM t ORDER BY a;

-- Test 23: statement (line 101)
BEGIN;

-- Test 24: statement (line 104)
INSERT INTO t(a) VALUES (2);

-- Test 25: statement (line 107)
PREPARE TRANSACTION 'read-write';

-- Test 26: statement (line 110)
ROLLBACK PREPARED 'read-write';

-- Test 27: query (line 113)
SELECT * FROM t ORDER BY a;

-- Test 28: query (line 118)
SELECT gid AS global_id
FROM pg_catalog.pg_prepared_xacts
ORDER BY gid;

-- Test 29: statement (line 124)
BEGIN;

-- Test 30: statement (line 127)
INSERT INTO t(a) VALUES (2);

-- Test 31: statement (line 130)
PREPARE TRANSACTION 'duplicate';

-- Test 32: statement (line 133)
BEGIN;

-- Test 33: statement (line 136)
INSERT INTO t(a) VALUES (3);

-- Test 34: statement (line 139)
-- Expected ERROR (duplicate prepared transaction identifier):
\set ON_ERROR_STOP 0
PREPARE TRANSACTION 'duplicate';
\set ON_ERROR_STOP 1
ROLLBACK;

-- Test 35: query (line 142)
-- SHOW transaction_status is CockroachDB-only; no PostgreSQL equivalent.

-- Test 36: statement (line 148)
COMMIT PREPARED 'duplicate';

-- Test 37: query (line 153)
SELECT * FROM t ORDER BY a;

-- Test 38: statement (line 161)
BEGIN;

-- Test 39: statement (line 164)
-- Expected ERROR (gid too long in PostgreSQL):
\set ON_ERROR_STOP 0
PREPARE TRANSACTION 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
\set ON_ERROR_STOP 1
ROLLBACK;

-- Test 40: query (line 167)
-- SHOW transaction_status is CockroachDB-only; no PostgreSQL equivalent.

-- Test 41: statement (line 173)
BEGIN;

-- Test 42: statement (line 176)
PREPARE TRANSACTION 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';

-- Test 43: query (line 179)
SELECT gid AS global_id
FROM pg_catalog.pg_prepared_xacts
ORDER BY gid;

-- Test 44: statement (line 184)
ROLLBACK PREPARED 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';

-- Test 45: statement (line 190)
BEGIN;
-- Expected ERROR (division by zero):
\set ON_ERROR_STOP 0
SELECT 1/0;
-- Expected ERROR (transaction is aborted):
PREPARE TRANSACTION 'aborted-txn';
\set ON_ERROR_STOP 1
ROLLBACK;

-- Test 46: statement (line 193)
-- (covered by Test 45)

-- Test 47: query (line 196)
-- SHOW transaction_status is CockroachDB-only; no PostgreSQL equivalent.

-- Test 48: query (line 201)
SELECT gid AS global_id, owner, database
FROM pg_catalog.pg_prepared_xacts
ORDER BY gid;

-- Test 49: statement (line 205)
-- SET autocommit_before_ddl is CockroachDB-only; no PostgreSQL equivalent.

-- Test 50: statement (line 209)
-- Expected ERROR (PREPARE TRANSACTION must be inside an explicit txn block):
\set ON_ERROR_STOP 0
PREPARE TRANSACTION 'implicit-txn';
\set ON_ERROR_STOP 1

-- Test 51: statement (line 212)
-- RESET autocommit_before_ddl is CockroachDB-only; no PostgreSQL equivalent.

-- Test 52: query (line 215)
-- Expected ERROR (PREPARE TRANSACTION must be inside an explicit txn block):
\set ON_ERROR_STOP 0
PREPARE TRANSACTION 'implicit-txn';
\set ON_ERROR_STOP 1

-- Test 53: statement (line 222)
BEGIN;

-- Test 54: statement (line 225)
-- Expected ERROR (COMMIT PREPARED cannot run inside a transaction block):
\set ON_ERROR_STOP 0
COMMIT PREPARED 'txn';
\set ON_ERROR_STOP 1
ROLLBACK;

-- Test 55: statement (line 228)
BEGIN;

-- Test 56: statement (line 231)
-- Expected ERROR (ROLLBACK PREPARED cannot run inside a transaction block):
\set ON_ERROR_STOP 0
ROLLBACK PREPARED 'txn';
\set ON_ERROR_STOP 1
ROLLBACK;

-- Test 57: statement (line 234)
-- (covered by Test 56)

-- Test 58: statement (line 239)
-- Expected ERROR (unknown prepared transaction):
\set ON_ERROR_STOP 0
COMMIT PREPARED 'unknown';
\set ON_ERROR_STOP 1

-- Test 59: statement (line 242)
-- Expected ERROR (unknown prepared transaction):
\set ON_ERROR_STOP 0
ROLLBACK PREPARED 'unknown';
\set ON_ERROR_STOP 1

-- Test 60: statement (line 247)
BEGIN;

-- Test 61: statement (line 250)
INSERT INTO t(a) VALUES (3);

-- Test 62: statement (line 253)
PREPARE TRANSACTION 'read-write-root';

-- Test 63: query (line 256)
SELECT gid AS global_id, owner, database
FROM pg_catalog.pg_prepared_xacts
ORDER BY gid;

-- Test 64: statement (line 263)
-- Switch to non-owner to verify permission checks.
SET ROLE tpct_testuser;
\set ON_ERROR_STOP 0
COMMIT PREPARED 'read-write-root';
\set ON_ERROR_STOP 1

-- Test 65: statement (line 267)
BEGIN;

-- Test 66: statement (line 270)
INSERT INTO t(a) VALUES (4);

-- Test 67: statement (line 273)
PREPARE TRANSACTION 'read-write-testuser';

-- Test 68: statement (line 278)
SELECT gid AS global_id, owner, database
FROM pg_catalog.pg_prepared_xacts
ORDER BY gid;

-- Test 69: statement (line 281)
-- Expected ERROR (pg_prepared_xacts is a system view):
\set ON_ERROR_STOP 0
DELETE FROM pg_catalog.pg_prepared_xacts;
\set ON_ERROR_STOP 1

-- user root
RESET ROLE;

-- Test 70: query (line 286)
SELECT gid AS global_id, owner, database
FROM pg_catalog.pg_prepared_xacts
ORDER BY gid;

-- Test 71: query (line 292)
SELECT gid, owner, database
FROM pg_catalog.pg_prepared_xacts
ORDER BY gid;

-- Test 72: statement (line 298)
ROLLBACK PREPARED 'read-write-root';

-- Test 73: statement (line 301)
ROLLBACK PREPARED 'read-write-testuser';

-- Test 74: query (line 304)
SELECT gid AS global_id, owner, database
FROM pg_catalog.pg_prepared_xacts
ORDER BY gid;

\else
-- `max_prepared_transactions` is a postmaster setting; when it is 0, prepared
-- transactions are disabled, so the rest of this test cannot run.
\endif

-- cleanup
DROP TABLE t;
DROP ROLE tpct_testuser;
RESET client_min_messages;
