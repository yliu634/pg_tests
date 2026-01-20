SET client_min_messages = warning;

-- PostgreSQL compatible tests from kv_builtin_functions_local
-- 2 tests

-- Test 1: query (line 14)
-- COMMENTED: CockroachDB-specific: SELECT crdb_internal.kv_enqueue_replica($rangeid, 'mvccGC', true);

-- Test 2: query (line 19)
-- COMMENTED: CockroachDB-specific: SELECT crdb_internal.kv_enqueue_replica(10000, 'mvccGC', true);


-- COMMENTED: Logic test directive: subtest kv_enqueue_replica_named_store

-- COMMENTED: CockroachDB-specific file: query B
-- COMMENTED: CockroachDB-specific: SELECT crdb_internal.kv_enqueue_replica($rangeid, 'mvccGC', true, 1);

RESET client_min_messages;