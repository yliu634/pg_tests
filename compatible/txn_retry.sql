-- PostgreSQL compatible tests from txn_retry
-- Reduced subset: CockroachDB force_retry/cluster_logical_timestamp are not
-- available in PostgreSQL; validate basic transactional DML instead.

SET crdb.kv_transaction_buffered_writes_enabled = false;

CREATE TABLE test_retry (k INT PRIMARY KEY);

BEGIN;
INSERT INTO test_retry VALUES (1);
COMMIT;

RESET crdb.kv_transaction_buffered_writes_enabled;

SELECT * FROM test_retry ORDER BY k;
