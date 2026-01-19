-- PostgreSQL compatible tests from txn_retry
-- 10 tests

-- Test 1: statement (line 16)
SET kv_transaction_buffered_writes_enabled = false;

-- Test 2: statement (line 19)
CREATE TABLE test_retry (
  k INT PRIMARY KEY
)

-- Test 3: statement (line 24)
GRANT ALL ON test_retry TO testuser

-- Test 4: statement (line 28)
BEGIN

-- Test 5: statement (line 34)
SELECT * FROM test.test_retry

user root

-- Test 6: statement (line 44)
SELECT cluster_logical_timestamp(); INSERT INTO test_retry VALUES (1);

-- Test 7: statement (line 47)
COMMIT

-- Test 8: statement (line 50)
RESET kv_transaction_buffered_writes_enabled

-- Test 9: query (line 59)
SELECT crdb_internal.force_retry(0)

-- Test 10: query (line 74)
SELECT crdb_internal.force_retry(3)

