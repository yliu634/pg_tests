-- PostgreSQL compatible tests from schema_change_retry
-- 8 tests

-- Test 1: statement (line 9)
SET CLUSTER SETTING kv.transaction.max_refresh_spans_bytes = 0;

-- Test 2: statement (line 13)
SET autocommit_before_ddl = false

-- Test 3: statement (line 16)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- Test 4: statement (line 19)
SAVEPOINT cockroach_restart

-- Test 5: statement (line 22)
CREATE TABLE t (x INT PRIMARY KEY, y INT) WITH (schema_locked=false);

-- Test 6: statement (line 29)
CREATE INDEX y_idx ON t (y);

-- Test 7: statement (line 36)
BEGIN TRANSACTION PRIORITY HIGH;
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- Test 8: statement (line 40)
SHOW TABLES

user root

