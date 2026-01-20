-- PostgreSQL compatible tests from cluster_locks
-- 76 tests

-- Test 1: statement (line 3)
SET kv_transaction_buffered_writes_enabled = false;

-- Test 2: statement (line 9)
SET default_transaction_isolation = 'SERIALIZABLE'

-- Test 3: statement (line 16)
GRANT ALL ON t TO testuser

-- Test 4: statement (line 19)
INSERT INTO t VALUES ('a', 'val1'), ('b', 'val2'), ('c', 'val3'), ('l', 'val4'), ('m', 'val5'), ('p', 'val6'), ('s', 'val7'), ('t', 'val8'), ('z', 'val9')

-- Test 5: statement (line 38)
CREATE USER testuser2 WITH VIEWACTIVITYREDACTED

-- Test 6: statement (line 41)
GRANT ALL ON t TO testuser2

-- Test 7: statement (line 47)
INSERT INTO t2 VALUES ('a', 'val1'), ('b', 'val2')

-- Test 8: statement (line 51)
BEGIN PRIORITY HIGH

-- Test 9: statement (line 54)
UPDATE t SET v = '_updated' WHERE k >= 'b' AND k < 'x'

let $root_session
SHOW session_id

user testuser

-- Test 10: statement (line 62)
SET kv_transaction_buffered_writes_enabled = false;

-- Test 11: statement (line 65)
SET default_transaction_isolation = 'SERIALIZABLE'

let $testuser_session
SHOW session_id

-- Test 12: statement (line 71)
BEGIN

-- Test 13: query (line 94)
SELECT * FROM t

-- Test 14: query (line 109)
SELECT user_name, query, phase FROM crdb_internal.cluster_queries WHERE txn_id='$txn2'

-- Test 15: query (line 116)
SELECT database_name, schema_name, table_name, lock_key_pretty, lock_strength, durability, isolation_level, granted, contended FROM crdb_internal.cluster_locks WHERE range_id=$r1 AND txn_id='$txn1'

-- Test 16: query (line 123)
SELECT database_name, schema_name, table_name, lock_key_pretty, lock_strength, durability, isolation_level, granted, contended FROM crdb_internal.cluster_locks WHERE range_id=$r1 AND txn_id='$txn2'

-- Test 17: query (line 131)
SELECT database_name, schema_name, table_name, lock_key_pretty, lock_strength, durability, isolation_level, granted, contended FROM crdb_internal.cluster_locks WHERE range_id=$r2 AND txn_id='$txn1'

-- Test 18: query (line 136)
SELECT database_name, schema_name, table_name, lock_key_pretty, lock_strength, durability, isolation_level, granted, contended FROM crdb_internal.cluster_locks WHERE range_id=$r2 AND txn_id='$txn2'

-- Test 19: query (line 141)
SELECT database_name, schema_name, table_name, lock_key_pretty, lock_strength, durability, isolation_level, granted, contended FROM crdb_internal.cluster_locks WHERE range_id=$r3 AND txn_id='$txn1'

-- Test 20: query (line 146)
SELECT database_name, schema_name, table_name, lock_key_pretty, lock_strength, durability, isolation_level, granted, contended FROM crdb_internal.cluster_locks WHERE range_id=$r3 AND txn_id='$txn2'

-- Test 21: query (line 154)
SELECT database_name, schema_name, table_name, lock_key_pretty, lock_strength, durability, isolation_level, granted, contended FROM crdb_internal.cluster_locks WHERE range_id=$r1 AND txn_id='$txn1'

-- Test 22: query (line 163)
SELECT database_name, schema_name, table_name, lock_key_pretty, lock_strength, durability, isolation_level, granted, contended FROM crdb_internal.cluster_locks WHERE database_name='test'

-- Test 23: query (line 171)
SELECT database_name, schema_name, table_name, lock_key_pretty, lock_strength, durability, isolation_level, granted, contended FROM crdb_internal.cluster_locks WHERE table_id='t'::regclass::oid::int

-- Test 24: query (line 179)
SELECT database_name, schema_name, table_name, lock_key_pretty, lock_strength, durability, isolation_level, granted, contended FROM crdb_internal.cluster_locks WHERE contended=true AND lock_key_pretty LIKE '/Table/106%'

-- Test 25: query (line 186)
SELECT database_name, schema_name, table_name, lock_key_pretty, lock_strength, durability, isolation_level, granted, contended FROM crdb_internal.cluster_locks WHERE contended=false AND lock_key_pretty LIKE '/Table/106%'

-- Test 26: query (line 192)
SELECT count(*) FROM crdb_internal.cluster_locks WHERE table_name = 't'

-- Test 27: statement (line 197)
COMMIT

-- Test 28: query (line 200)
SELECT count(*) FROM crdb_internal.cluster_locks WHERE table_name = 't'

-- Test 29: statement (line 209)
COMMIT

user root

-- Test 30: statement (line 215)
BEGIN

user testuser

-- Test 31: statement (line 221)
BEGIN

user root

-- Test 32: query (line 226)
SELECT * FROM t FOR UPDATE

-- Test 33: statement (line 247)
DELETE FROM t WHERE k >= 'b' AND k < 'x'

user root

-- Test 34: query (line 252)
SELECT user_name, query, phase FROM crdb_internal.cluster_queries WHERE txn_id='$txn4'

-- Test 35: query (line 259)
SELECT database_name, schema_name, table_name, lock_key_pretty, lock_strength, durability, isolation_level, granted, contended FROM crdb_internal.cluster_locks WHERE range_id=$r1 AND txn_id='$txn3'

-- Test 36: query (line 267)
SELECT database_name, schema_name, table_name, lock_key_pretty, lock_strength, durability, isolation_level, granted, contended FROM crdb_internal.cluster_locks WHERE range_id=$r1 AND txn_id='$txn4'

-- Test 37: query (line 273)
SELECT database_name, schema_name, table_name, lock_key_pretty, lock_strength, durability, isolation_level, granted, contended FROM crdb_internal.cluster_locks WHERE range_id=$r2 AND txn_id='$txn3'

-- Test 38: query (line 281)
SELECT database_name, schema_name, table_name, lock_key_pretty, lock_strength, durability, isolation_level, granted, contended FROM crdb_internal.cluster_locks WHERE range_id=$r2 AND txn_id='$txn4'

-- Test 39: query (line 286)
SELECT database_name, schema_name, table_name, lock_key_pretty, lock_strength, durability, isolation_level, granted, contended FROM crdb_internal.cluster_locks WHERE range_id=$r3 AND txn_id='$txn3'

-- Test 40: query (line 294)
SELECT database_name, schema_name, table_name, lock_key_pretty, lock_strength, durability, isolation_level, granted, contended FROM crdb_internal.cluster_locks WHERE range_id=$r3 AND txn_id='$txn4'

-- Test 41: query (line 299)
SELECT count(*) FROM crdb_internal.cluster_locks WHERE table_name = 't'

-- Test 42: statement (line 304)
ROLLBACK

user testuser

awaitstatement deleteReq

-- Test 43: statement (line 311)
COMMIT

user root

-- Test 44: query (line 316)
SELECT count(*) FROM crdb_internal.cluster_locks WHERE table_name = 't'

-- Test 45: statement (line 322)
BEGIN

-- Test 46: query (line 325)
SELECT * FROM t FOR UPDATE

-- Test 47: query (line 331)
SELECT * FROM t2 FOR UPDATE

-- Test 48: query (line 337)
SELECT count(*) FROM crdb_internal.cluster_locks WHERE table_name IN ('t','t2')

-- Test 49: query (line 344)
SELECT database_name, schema_name, table_name, lock_key_pretty, lock_strength, durability, isolation_level, granted, contended FROM crdb_internal.cluster_locks

user testuser2

query TTTTTTTBB colnames,rowsort
SELECT database_name, schema_name, table_name, lock_key_pretty, lock_strength, durability, isolation_level, granted, contended FROM crdb_internal.cluster_locks WHERE table_name IN ('t', 't2')

-- Test 50: statement (line 358)
ROLLBACK

-- Test 51: query (line 361)
SELECT count(*) FROM crdb_internal.cluster_locks WHERE table_name IN ('t','t2')

-- Test 52: statement (line 368)
SET CLUSTER SETTING sql.txn.repeatable_read_isolation.enabled = true

-- Test 53: statement (line 371)
BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT * FROM t WHERE k = 'a' FOR UPDATE;

user testuser

-- Test 54: statement (line 377)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- Test 55: statement (line 380)
SELECT * FROM t WHERE k = 'a' FOR UPDATE;

user root

-- Test 56: query (line 385)
SELECT database_name, schema_name, table_name, lock_key_pretty, lock_strength, durability, regexp_replace(isolation_level, 'READ COMMITTED', 'READ_COMMITTED') AS isolation_level, granted, contended FROM crdb_internal.cluster_locks WHERE table_name = 't'

-- Test 57: statement (line 392)
COMMIT

user testuser

awaitstatement iso1

-- Test 58: statement (line 399)
COMMIT

user root

-- Test 59: statement (line 404)
BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SELECT * FROM t WHERE k = 'a' FOR UPDATE;

user testuser

-- Test 60: statement (line 410)
BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- Test 61: statement (line 413)
SELECT * FROM t WHERE k = 'a' FOR UPDATE;

user root

-- Test 62: query (line 418)
SELECT database_name, schema_name, table_name, lock_key_pretty, lock_strength, durability, regexp_replace(isolation_level, ' ', '_') AS isolation_level, granted, contended FROM crdb_internal.cluster_locks WHERE table_name = 't'

-- Test 63: statement (line 425)
COMMIT

user testuser

awaitstatement iso2

-- Test 64: statement (line 432)
COMMIT

user root

-- Test 65: statement (line 437)
BEGIN;
SELECT * FROM t WHERE k = 'a' FOR UPDATE;

user testuser

-- Test 66: statement (line 443)
BEGIN;
SET enable_shared_locking_for_serializable = true

-- Test 67: statement (line 447)
SELECT * FROM t WHERE k = 'a' FOR SHARE;

user root

-- Test 68: query (line 453)
SELECT database_name, schema_name, table_name, lock_key_pretty, lock_strength, durability, granted, contended FROM crdb_internal.cluster_locks WHERE table_name = 't'

-- Test 69: statement (line 460)
COMMIT

user testuser

awaitstatement share1

-- Test 70: statement (line 467)
COMMIT

user root

-- Test 71: statement (line 474)
BEGIN;
SELECT * FROM t WHERE k = 'a' FOR UPDATE;

user testuser2

-- Test 72: statement (line 480)
BEGIN;

-- Test 73: statement (line 483)
DELETE FROM t WHERE k = 'a';

user root

-- Test 74: query (line 489)
SELECT database_name, schema_name, table_name, lock_key_pretty, lock_strength, durability, granted, contended FROM crdb_internal.cluster_locks WHERE table_name = 't'

-- Test 75: statement (line 496)
COMMIT

user testuser2

awaitstatement del1

-- Test 76: statement (line 503)
ROLLBACK

