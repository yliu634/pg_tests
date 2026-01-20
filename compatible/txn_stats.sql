-- PostgreSQL compatible tests from txn_stats
-- 7 tests

-- Test 1: statement (line 3)
SET application_name = test; SELECT 1

-- Test 2: query (line 6)
SELECT count(*) > 0
  FROM crdb_internal.node_txn_stats
 WHERE application_name = 'test'

-- Test 3: query (line 14)
SELECT txn_count - committed_count = 0
  FROM crdb_internal.node_txn_stats
 WHERE application_name = 'test'

-- Test 4: query (line 22)
SELECT txn_count = implicit_count
  FROM crdb_internal.node_txn_stats
 WHERE application_name = 'test'

-- Test 5: statement (line 29)
BEGIN TRANSACTION; SELECT 1; COMMIT TRANSACTION

-- Test 6: query (line 33)
SELECT txn_count - implicit_count = 1
  FROM crdb_internal.node_txn_stats
 WHERE application_name = 'test'

-- Test 7: query (line 44)
SELECT count(*) = 0
  FROM crdb_internal.node_txn_stats
 WHERE application_name = 'test'
   AND (
        txn_time_avg_sec < 0
        OR txn_time_avg_sec > 1
       )

