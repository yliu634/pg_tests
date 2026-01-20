-- PostgreSQL compatible tests from temp_table_txn
-- 2 tests

-- Test 1: statement (line 11)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl=off;
CREATE TEMP TABLE tbl (a int primary key);
INSERT INTO tbl VALUES (1);
SELECT crdb_internal.force_retry('1s');
COMMIT

-- Test 2: query (line 19)
SELECT * FROM tbl

