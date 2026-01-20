-- PostgreSQL compatible tests from cluster_locks_write_buffering
-- 65 tests

-- Test 1: statement (line 3)
SET kv_transaction_buffered_writes_enabled = true;

-- Test 2: statement (line 6)
SET CLUSTER SETTING kv.transaction.write_buffering.max_buffer_size = '2KiB';

-- Test 3: statement (line 12)
SET default_transaction_isolation = 'SERIALIZABLE'

-- Test 4: statement (line 19)
GRANT ALL ON t TO testuser

-- Test 5: statement (line 22)
INSERT INTO t VALUES ('a', 'val1'), ('b', 'val2'), ('c', 'val3'), ('l', 'val4'), ('m', 'val5'), ('p', 'val6'), ('s', 'val7'), ('t', 'val8'), ('z', 'val9')

-- Test 6: statement (line 41)
CREATE USER testuser2 WITH VIEWACTIVITYREDACTED

-- Test 7: statement (line 44)
GRANT ALL ON t TO testuser2

-- Test 8: statement (line 50)
INSERT INTO t2 VALUES ('a', 'val1'), ('b', 'val2')

-- Test 9: statement (line 54)
BEGIN PRIORITY HIGH

-- Test 10: statement (line 57)
UPDATE t SET v = '_updated' WHERE k >= 'b' AND k < 'x'

let $root_session
SHOW session_id

user testuser

-- Test 11: statement (line 65)
SET kv_transaction_buffered_writes_enabled = true;

-- Test 12: statement (line 68)
SET default_transaction_isolation = 'SERIALIZABLE'

let $testuser_session
SHOW session_id

-- Test 13: statement (line 74)
BEGIN

-- Test 14: query (line 97)
SELECT * FROM t

-- Test 15: query (line 112)
SELECT user_name, query, phase FROM crdb_internal.cluster_queries WHERE txn_id='$txn2'

-- Test 16: query (line 119)
SELECT database_name, schema_name, table_name, lock_key_pretty, lock_strength, durability, isolation_level, granted, contended FROM crdb_internal.cluster_locks WHERE range_id=$r1 AND txn_id='$txn1'

-- Test 17: query (line 126)
SELECT database_name, schema_name, table_name, lock_key_pretty, lock_strength, durability, isolation_level, granted, contended FROM crdb_internal.cluster_locks WHERE range_id=$r1 AND txn_id='$txn2'

-- Test 18: query (line 134)
SELECT database_name, schema_name, table_name, lock_key_pretty, lock_strength, durability, isolation_level, granted, contended FROM crdb_internal.cluster_locks WHERE range_id=$r2 AND txn_id='$txn1'

-- Test 19: query (line 142)
SELECT database_name, schema_name, table_name, lock_key_pretty, lock_strength, durability, isolation_level, granted, contended FROM crdb_internal.cluster_locks WHERE range_id=$r2 AND txn_id='$txn2'

-- Test 20: query (line 147)
SELECT database_name, schema_name, table_name, lock_key_pretty, lock_strength, durability, isolation_level, granted, contended FROM crdb_internal.cluster_locks WHERE range_id=$r3 AND txn_id='$txn1'

-- Test 21: query (line 154)
SELECT database_name, schema_name, table_name, lock_key_pretty, lock_strength, durability, isolation_level, granted, contended FROM crdb_internal.cluster_locks WHERE range_id=$r3 AND txn_id='$txn2'

-- Test 22: query (line 162)
SELECT database_name, schema_name, table_name, lock_key_pretty, lock_strength, durability, isolation_level, granted, contended FROM crdb_internal.cluster_locks WHERE range_id=$r1 AND txn_id='$txn1'

-- Test 23: query (line 171)
SELECT database_name, schema_name, table_name, lock_key_pretty, lock_strength, durability, isolation_level, granted, contended FROM crdb_internal.cluster_locks WHERE database_name='test'

-- Test 24: query (line 184)
SELECT database_name, schema_name, table_name, lock_key_pretty, lock_strength, durability, isolation_level, granted, contended FROM crdb_internal.cluster_locks WHERE table_id='t'::regclass::oid::int

-- Test 25: query (line 197)
SELECT database_name, schema_name, table_name, lock_key_pretty, lock_strength, durability, isolation_level, granted, contended FROM crdb_internal.cluster_locks WHERE contended=true AND lock_key_pretty LIKE '/Table/106%'

-- Test 26: query (line 204)
SELECT database_name, schema_name, table_name, lock_key_pretty, lock_strength, durability, isolation_level, granted, contended FROM crdb_internal.cluster_locks WHERE contended=false AND lock_key_pretty LIKE '/Table/106%'

-- Test 27: query (line 215)
SELECT count(*) FROM crdb_internal.cluster_locks WHERE table_name = 't'

-- Test 28: statement (line 220)
COMMIT

-- Test 29: query (line 223)
SELECT count(*) FROM crdb_internal.cluster_locks WHERE table_name = 't'

-- Test 30: statement (line 232)
COMMIT

user root

-- Test 31: statement (line 238)
BEGIN

user testuser

-- Test 32: statement (line 244)
BEGIN

user root

-- Test 33: query (line 249)
SELECT * FROM t FOR UPDATE

-- Test 34: statement (line 270)
DELETE FROM t WHERE k >= 'b' AND k < 'x'

user root

-- Test 35: query (line 275)
SELECT user_name, query, phase FROM crdb_internal.cluster_queries WHERE txn_id='$txn4'

-- Test 36: query (line 282)
SELECT database_name, schema_name, table_name, lock_key_pretty, lock_strength, durability, isolation_level, granted, contended FROM crdb_internal.cluster_locks WHERE range_id=$r1 AND txn_id='$txn3'

-- Test 37: query (line 290)
SELECT database_name, schema_name, table_name, lock_key_pretty, lock_strength, durability, isolation_level, granted, contended FROM crdb_internal.cluster_locks WHERE range_id=$r1 AND txn_id='$txn4'

-- Test 38: query (line 296)
SELECT database_name, schema_name, table_name, lock_key_pretty, lock_strength, durability, isolation_level, granted, contended FROM crdb_internal.cluster_locks WHERE range_id=$r2 AND txn_id='$txn3'

-- Test 39: query (line 304)
SELECT database_name, schema_name, table_name, lock_key_pretty, lock_strength, durability, isolation_level, granted, contended FROM crdb_internal.cluster_locks WHERE range_id=$r2 AND txn_id='$txn4'

-- Test 40: query (line 309)
SELECT database_name, schema_name, table_name, lock_key_pretty, lock_strength, durability, isolation_level, granted, contended FROM crdb_internal.cluster_locks WHERE range_id=$r3 AND txn_id='$txn3'

-- Test 41: query (line 317)
SELECT database_name, schema_name, table_name, lock_key_pretty, lock_strength, durability, isolation_level, granted, contended FROM crdb_internal.cluster_locks WHERE range_id=$r3 AND txn_id='$txn4'

-- Test 42: query (line 322)
SELECT count(*) FROM crdb_internal.cluster_locks WHERE table_name = 't'

-- Test 43: statement (line 327)
ROLLBACK

user testuser

awaitstatement deleteReq

-- Test 44: statement (line 334)
COMMIT

user root

-- Test 45: query (line 339)
SELECT count(*) FROM crdb_internal.cluster_locks WHERE table_name = 't'

-- Test 46: statement (line 345)
BEGIN

-- Test 47: query (line 348)
SELECT * FROM t FOR UPDATE

-- Test 48: query (line 354)
SELECT * FROM t2 FOR UPDATE

-- Test 49: query (line 360)
SELECT count(*) FROM crdb_internal.cluster_locks WHERE table_name IN ('t','t2')

-- Test 50: query (line 367)
SELECT database_name, schema_name, table_name, lock_key_pretty, lock_strength, durability, isolation_level, granted, contended FROM crdb_internal.cluster_locks

user testuser2

query TTTTTTTBB colnames,rowsort
SELECT database_name, schema_name, table_name, lock_key_pretty, lock_strength, durability, isolation_level, granted, contended FROM crdb_internal.cluster_locks WHERE table_name IN ('t', 't2')

-- Test 51: statement (line 381)
ROLLBACK

-- Test 52: query (line 384)
SELECT count(*) FROM crdb_internal.cluster_locks WHERE table_name IN ('t','t2')

-- Test 53: statement (line 391)
SET CLUSTER SETTING sql.txn.repeatable_read_isolation.enabled = true

-- Test 54: statement (line 394)
BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT * FROM t WHERE k = 'a' FOR UPDATE;

user testuser

-- Test 55: statement (line 400)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- Test 56: statement (line 403)
SELECT * FROM t WHERE k = 'a' FOR UPDATE;

user root

-- Test 57: query (line 408)
SELECT database_name, schema_name, table_name, lock_key_pretty, lock_strength, durability, regexp_replace(isolation_level, 'READ COMMITTED', 'READ_COMMITTED') AS isolation_level, granted, contended FROM crdb_internal.cluster_locks WHERE table_name = 't'

-- Test 58: statement (line 415)
COMMIT

user testuser

awaitstatement iso1

-- Test 59: statement (line 422)
COMMIT

user root

-- Test 60: statement (line 427)
BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SELECT * FROM t WHERE k = 'a' FOR UPDATE;

user testuser

-- Test 61: statement (line 433)
BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- Test 62: statement (line 436)
SELECT * FROM t WHERE k = 'a' FOR UPDATE;

user root

-- Test 63: query (line 441)
SELECT database_name, schema_name, table_name, lock_key_pretty, lock_strength, durability, regexp_replace(isolation_level, ' ', '_') AS isolation_level, granted, contended FROM crdb_internal.cluster_locks WHERE table_name = 't'

-- Test 64: statement (line 448)
COMMIT

user testuser

awaitstatement iso2

-- Test 65: statement (line 455)
COMMIT

