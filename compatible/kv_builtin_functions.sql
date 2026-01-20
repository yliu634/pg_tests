SET client_min_messages = warning;

-- PostgreSQL compatible tests from kv_builtin_functions
-- 10 tests

-- Test 1: query (line 7)
-- COMMENTED: CockroachDB-specific: SELECT crdb_internal.kv_set_queue_active('mvccGC', true);

-- Test 2: query (line 12)
-- COMMENTED: CockroachDB-specific: SELECT crdb_internal.kv_set_queue_active('merge', true);

-- Test 3: query (line 17)
-- COMMENTED: CockroachDB-specific: SELECT crdb_internal.kv_set_queue_active('split', false);

-- Test 4: query (line 22)
-- COMMENTED: CockroachDB-specific: SELECT crdb_internal.kv_set_queue_active('replicate', false);

-- Test 5: query (line 27)
-- COMMENTED: CockroachDB-specific: SELECT crdb_internal.kv_set_queue_active('replicaGC', false);

-- Test 6: query (line 32)
-- COMMENTED: CockroachDB-specific: SELECT crdb_internal.kv_set_queue_active('raftlog', false);

-- Test 7: query (line 37)
-- COMMENTED: CockroachDB-specific: SELECT crdb_internal.kv_set_queue_active('raftsnapshot', false);

-- Test 8: query (line 42)
-- COMMENTED: CockroachDB-specific: SELECT crdb_internal.kv_set_queue_active('consistencyChecker', false);

-- Test 9: query (line 47)
-- COMMENTED: CockroachDB-specific: SELECT crdb_internal.kv_set_queue_active('timeseriesMaintenance', false);

-- Test 10: query (line 52)
-- COMMENTED: CockroachDB-specific: SELECT crdb_internal.kv_set_queue_active('non-existent', true);

-- COMMENTED: CockroachDB-specific: # Test crdb_internal.kv_set_queue_active commands that target a named store on
-- COMMENTED: CockroachDB-specific file: # the gateway node.
-- COMMENTED: Logic test directive: subtest kv_set_queue_active_named_store

-- COMMENTED: CockroachDB-specific file: query B
-- COMMENTED: CockroachDB-specific: SELECT crdb_internal.kv_set_queue_active('split', false, 1);

RESET client_min_messages;