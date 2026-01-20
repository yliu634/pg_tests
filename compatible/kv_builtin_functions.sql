-- PostgreSQL compatible tests from kv_builtin_functions
-- 10 tests

-- Test 1: query (line 7)
SELECT crdb_internal.kv_set_queue_active('mvccGC', true);

-- Test 2: query (line 12)
SELECT crdb_internal.kv_set_queue_active('merge', true);

-- Test 3: query (line 17)
SELECT crdb_internal.kv_set_queue_active('split', false);

-- Test 4: query (line 22)
SELECT crdb_internal.kv_set_queue_active('replicate', false);

-- Test 5: query (line 27)
SELECT crdb_internal.kv_set_queue_active('replicaGC', false);

-- Test 6: query (line 32)
SELECT crdb_internal.kv_set_queue_active('raftlog', false);

-- Test 7: query (line 37)
SELECT crdb_internal.kv_set_queue_active('raftsnapshot', false);

-- Test 8: query (line 42)
SELECT crdb_internal.kv_set_queue_active('consistencyChecker', false);

-- Test 9: query (line 47)
SELECT crdb_internal.kv_set_queue_active('timeseriesMaintenance', false);

-- Test 10: query (line 52)
SELECT crdb_internal.kv_set_queue_active('non-existent', true);

# Test crdb_internal.kv_set_queue_active commands that target a named store on
# the gateway node.
subtest kv_set_queue_active_named_store

query B
SELECT crdb_internal.kv_set_queue_active('split', false, 1);

