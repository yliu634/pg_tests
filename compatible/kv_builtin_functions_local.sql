-- PostgreSQL compatible tests from kv_builtin_functions_local
-- 2 tests

-- Test 1: query (line 14)
SELECT crdb_internal.kv_enqueue_replica($rangeid, 'mvccGC', true);

-- Test 2: query (line 19)
SELECT crdb_internal.kv_enqueue_replica(10000, 'mvccGC', true);


subtest kv_enqueue_replica_named_store

query B
SELECT crdb_internal.kv_enqueue_replica($rangeid, 'mvccGC', true, 1);

