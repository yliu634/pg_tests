-- PostgreSQL compatible tests from skip_on_retry
-- 5 tests

-- Test 1: statement (line 6)
BEGIN; SELECT * FROM system.namespace LIMIT 1;

-- Test 2: statement (line 9)
SELECT crdb_internal.force_retry('1h');

-- Test 3: statement (line 12)
ROLLBACK;

skip_on_retry

-- Test 4: statement (line 19)
BEGIN; SELECT * FROM system.namespace LIMIT 1;

-- Test 5: statement (line 22)
SELECT crdb_internal.force_retry('1h');

