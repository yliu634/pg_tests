-- PostgreSQL compatible tests from delete_batch
-- 4 tests

-- DELETE BATCH is a CockroachDB-specific syntax not available in PostgreSQL
-- These statements are commented out as they have no PostgreSQL equivalent

-- Test 1: statement (line 3)
-- DELETE BATCH FROM tbl;

-- Test 2: statement (line 10)
-- DELETE BATCH (SIZE 1) FROM tbl;

-- Test 3: statement (line 17)
-- DELETE BATCH (SIZE (SELECT 1)) FROM tbl;

-- Test 4: statement (line 24)
-- DELETE BATCH (SIZE 1, SIZE 1) FROM tbl;

