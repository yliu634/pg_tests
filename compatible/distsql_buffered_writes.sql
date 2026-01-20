-- PostgreSQL compatible tests from distsql_buffered_writes
-- 21 tests

-- Test 1: statement (line 3)
SET kv_transaction_buffered_writes_enabled=true

-- Test 2: statement (line 6)
SET CLUSTER SETTING kv.transaction.write_buffering.max_buffer_size = '2KiB';

-- Test 3: statement (line 11)
CREATE TABLE kv (k INT PRIMARY KEY, v INT);
INSERT INTO kv VALUES (1, 1), (2, 2);

-- Test 4: statement (line 26)
BEGIN;

-- Test 5: query (line 30)
SELECT info FROM [EXPLAIN SELECT crdb_internal_mvcc_timestamp FROM kv] WHERE info LIKE 'distribution%'

-- Test 6: statement (line 35)
INSERT INTO kv VALUES (3, 3);

-- Test 7: query (line 38)
SELECT info FROM [EXPLAIN SELECT crdb_internal_mvcc_timestamp FROM kv] WHERE info LIKE 'distribution%'

-- Test 8: query (line 45)
SELECT info FROM [EXPLAIN SELECT tableoid FROM kv] WHERE info LIKE 'distribution%'

-- Test 9: statement (line 52)
SELECT crdb_internal_mvcc_timestamp FROM kv;

-- Test 10: statement (line 55)
COMMIT;

-- Test 11: statement (line 59)
BEGIN;

-- Test 12: query (line 63)
SELECT info FROM [EXPLAIN SELECT kv2.crdb_internal_mvcc_timestamp FROM kv AS kv1 INNER LOOKUP JOIN kv AS kv2 ON kv1.v = kv2.k] WHERE info LIKE 'distribution%'

-- Test 13: statement (line 68)
INSERT INTO kv VALUES (4, 4);

-- Test 14: query (line 71)
SELECT info FROM [EXPLAIN SELECT kv2.crdb_internal_mvcc_timestamp FROM kv AS kv1 INNER LOOKUP JOIN kv AS kv2 ON kv1.v = kv2.k] WHERE info LIKE 'distribution%'

-- Test 15: statement (line 78)
SELECT kv2.crdb_internal_mvcc_timestamp FROM kv AS kv1 INNER LOOKUP JOIN kv AS kv2 ON kv1.v = kv2.k;

-- Test 16: statement (line 81)
COMMIT;

-- Test 17: statement (line 88)
BEGIN;

-- Test 18: statement (line 91)
SELECT
  crdb_internal_mvcc_timestamp
FROM
  [
    INSERT INTO kv VALUES (5, 5) RETURNING NULL
  ],
  kv;

-- Test 19: statement (line 100)
INSERT INTO kv VALUES (5, 5);

-- Test 20: statement (line 103)
ROLLBACK;

-- Test 21: query (line 106)
SELECT count(*) FROM kv;

