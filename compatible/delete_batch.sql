-- PostgreSQL compatible tests from delete_batch
-- 4 tests

-- Test 1: statement (line 3)
-- Expected ERROR (PostgreSQL does not support CockroachDB's DELETE BATCH syntax):
\set ON_ERROR_STOP 0
DELETE BATCH FROM tbl;
\set ON_ERROR_STOP 1

-- Test 2: statement (line 10)
\set ON_ERROR_STOP 0
DELETE BATCH (SIZE 1) FROM tbl;
\set ON_ERROR_STOP 1

-- Test 3: statement (line 17)
\set ON_ERROR_STOP 0
DELETE BATCH (SIZE (SELECT 1)) FROM tbl;
\set ON_ERROR_STOP 1

-- Test 4: statement (line 24)
\set ON_ERROR_STOP 0
DELETE BATCH (SIZE 1, SIZE 1) FROM tbl;
\set ON_ERROR_STOP 1
