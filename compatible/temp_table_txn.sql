-- PostgreSQL compatible tests from temp_table_txn
-- 2 tests

-- PG-NOT-SUPPORTED: This file relies on CockroachDB transaction retry behavior
-- via `crdb_internal.force_retry(...)` (and uses the CRDB-specific
-- `autocommit_before_ddl` setting). PostgreSQL has no equivalent retry
-- mechanism, so the original test can't be preserved.
--
-- The original CockroachDB-derived SQL is preserved below for reference, but
-- is not executed under PostgreSQL.

SET client_min_messages = warning;

SELECT
  'skipped: temp_table_txn depends on CockroachDB transaction retry behavior'
    AS notice;

RESET client_min_messages;

/*
-- Test 1: statement (line 11)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl=off;
CREATE TEMP TABLE tbl (a int primary key);
INSERT INTO tbl VALUES (1);
SELECT crdb_internal.force_retry('1s');
COMMIT

-- Test 2: query (line 19)
SELECT * FROM tbl
*/
