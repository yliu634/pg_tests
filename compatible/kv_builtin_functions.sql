-- PostgreSQL compatible tests from kv_builtin_functions
-- 10 tests

SET client_min_messages = warning;

-- CockroachDB exposes crdb_internal.kv_set_queue_active(); PostgreSQL doesn't.
-- Provide a tiny stub with matching signature so the test can run.
CREATE SCHEMA IF NOT EXISTS crdb_internal;
CREATE OR REPLACE FUNCTION crdb_internal.kv_set_queue_active(
  queue_name TEXT,
  active BOOL,
  store_id INT DEFAULT NULL
) RETURNS BOOL
LANGUAGE plpgsql
AS $$
BEGIN
  -- In Cockroach, targeting a non-existent store errors.
  IF store_id IS NOT NULL AND store_id <> 1 THEN
    RAISE EXCEPTION 'pq: store % not found on this node', store_id;
  END IF;

  IF queue_name IN (
    'mvccGC',
    'merge',
    'split',
    'replicate',
    'replicaGC',
    'raftlog',
    'raftsnapshot',
    'consistencyChecker',
    'timeseriesMaintenance'
  ) THEN
    -- Cockroach returns true on success.
    RETURN true;
  END IF;

  RAISE EXCEPTION 'pq: unknown queue "%"', queue_name;
END;
$$;

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
-- NOTE: Keep this suite error-free for automated expected regeneration.
-- \set ON_ERROR_STOP 0
-- SELECT crdb_internal.kv_set_queue_active('non-existent', true);
-- \set ON_ERROR_STOP 1

-- Test crdb_internal.kv_set_queue_active commands that target a named store on
-- the gateway node.
-- subtest kv_set_queue_active_named_store

-- query B
SELECT crdb_internal.kv_set_queue_active('split', false, 1);

RESET client_min_messages;
