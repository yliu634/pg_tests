-- PostgreSQL compatible tests from two_phase_commit
-- 74 tests

-- Test 1: query (line 3)
SHOW max_prepared_transactions

-- Test 2: query (line 8)
SELECT * FROM system.prepared_transactions

-- Test 3: query (line 12)
SELECT * FROM pg_catalog.pg_prepared_xacts

-- Test 4: statement (line 16)
CREATE TABLE t (a INT)

-- Test 5: statement (line 19)
GRANT ALL on t TO testuser

-- Test 6: statement (line 24)
BEGIN

-- Test 7: query (line 27)
SELECT * FROM t

-- Test 8: statement (line 31)
PREPARE TRANSACTION 'read-only'

-- Test 9: query (line 35)
SELECT global_id, owner, database FROM system.prepared_transactions

-- Test 10: query (line 42)
SELECT transaction, gid, owner, database FROM pg_catalog.pg_prepared_xacts

-- Test 11: statement (line 48)
COMMIT PREPARED 'read-only'

-- Test 12: query (line 52)
SELECT global_id FROM system.prepared_transactions

-- Test 13: statement (line 58)
BEGIN

-- Test 14: query (line 61)
SELECT * FROM t

-- Test 15: statement (line 65)
PREPARE TRANSACTION 'read-only'

-- Test 16: statement (line 69)
ROLLBACK PREPARED 'read-only'

-- Test 17: statement (line 74)
BEGIN

-- Test 18: statement (line 77)
INSERT INTO t(a) VALUES (1)

-- Test 19: statement (line 80)
PREPARE TRANSACTION 'read-write'

-- Test 20: query (line 84)
SELECT global_id FROM system.prepared_transactions

-- Test 21: statement (line 90)
COMMIT PREPARED 'read-write'

-- Test 22: query (line 94)
SELECT * FROM t

-- Test 23: statement (line 101)
BEGIN

-- Test 24: statement (line 104)
INSERT INTO t(a) VALUES (2)

-- Test 25: statement (line 107)
PREPARE TRANSACTION 'read-write'

-- Test 26: statement (line 110)
ROLLBACK PREPARED 'read-write'

-- Test 27: query (line 113)
SELECT * FROM t

-- Test 28: query (line 118)
SELECT global_id FROM system.prepared_transactions

-- Test 29: statement (line 124)
BEGIN

-- Test 30: statement (line 127)
INSERT INTO t(a) VALUES (2)

-- Test 31: statement (line 130)
PREPARE TRANSACTION 'duplicate'

-- Test 32: statement (line 133)
BEGIN

-- Test 33: statement (line 136)
INSERT INTO t(a) VALUES (3)

-- Test 34: statement (line 139)
PREPARE TRANSACTION 'duplicate'

-- Test 35: query (line 142)
SHOW transaction_status

-- Test 36: statement (line 148)
COMMIT PREPARED 'duplicate'

-- Test 37: query (line 153)
SELECT * FROM t ORDER BY a

-- Test 38: statement (line 161)
BEGIN

-- Test 39: statement (line 164)
PREPARE TRANSACTION 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';

-- Test 40: query (line 167)
SHOW transaction_status

-- Test 41: statement (line 173)
BEGIN

-- Test 42: statement (line 176)
PREPARE TRANSACTION 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';

-- Test 43: query (line 179)
SELECT global_id FROM system.prepared_transactions

-- Test 44: statement (line 184)
ROLLBACK PREPARED 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';

-- Test 45: statement (line 190)
BEGIN; SELECT 1/0

-- Test 46: statement (line 193)
PREPARE TRANSACTION 'aborted-txn'

-- Test 47: query (line 196)
SHOW transaction_status

-- Test 48: query (line 201)
SELECT global_id, owner, database FROM system.prepared_transactions

-- Test 49: statement (line 205)
SET autocommit_before_ddl = false

-- Test 50: statement (line 209)
PREPARE TRANSACTION 'implicit-txn'

-- Test 51: statement (line 212)
RESET autocommit_before_ddl

-- Test 52: query (line 215)
PREPARE TRANSACTION 'implicit-txn'

-- Test 53: statement (line 222)
BEGIN

-- Test 54: statement (line 225)
COMMIT PREPARED 'txn'

-- Test 55: statement (line 228)
ROLLBACK; BEGIN

-- Test 56: statement (line 231)
ROLLBACK PREPARED 'txn'

-- Test 57: statement (line 234)
ROLLBACK

-- Test 58: statement (line 239)
COMMIT PREPARED 'unknown'

-- Test 59: statement (line 242)
ROLLBACK PREPARED 'unknown'

-- Test 60: statement (line 247)
BEGIN

-- Test 61: statement (line 250)
INSERT INTO t(a) VALUES (3)

-- Test 62: statement (line 253)
PREPARE TRANSACTION 'read-write-root'

-- Test 63: query (line 256)
SELECT global_id, owner, database FROM system.prepared_transactions

-- Test 64: statement (line 263)
COMMIT PREPARED 'read-write-root'

-- Test 65: statement (line 267)
BEGIN

-- Test 66: statement (line 270)
INSERT INTO t(a) VALUES (4)

-- Test 67: statement (line 273)
PREPARE TRANSACTION 'read-write-testuser'

-- Test 68: statement (line 278)
SELECT global_id, owner, database FROM system.prepared_transactions

-- Test 69: statement (line 281)
DELETE FROM system.prepared_transactions

user root

-- Test 70: query (line 286)
SELECT global_id, owner, database FROM system.prepared_transactions

-- Test 71: query (line 292)
SELECT transaction, gid, owner, database FROM pg_catalog.pg_prepared_xacts

-- Test 72: statement (line 298)
ROLLBACK PREPARED 'read-write-root'

-- Test 73: statement (line 301)
ROLLBACK PREPARED 'read-write-testuser'

-- Test 74: query (line 304)
SELECT global_id, owner, database FROM system.prepared_transactions

