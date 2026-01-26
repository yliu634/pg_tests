-- PostgreSQL compatible tests from kv_builtin_functions_local
-- 2 tests

-- CockroachDB exposes these as crdb_internal builtins. PostgreSQL doesn't, so
-- provide local no-op shims so the calls can be exercised.
CREATE SCHEMA IF NOT EXISTS crdb_internal;
CREATE OR REPLACE FUNCTION crdb_internal.kv_enqueue_replica(
  rangeid bigint,
  queue_name text,
  should_process boolean
) RETURNS boolean
LANGUAGE sql
AS $$ SELECT true $$;
CREATE OR REPLACE FUNCTION crdb_internal.kv_enqueue_replica(
  rangeid bigint,
  queue_name text,
  should_process boolean,
  store_id integer
) RETURNS boolean
LANGUAGE sql
AS $$ SELECT true $$;

\set rangeid 1

-- Test 1: query (line 14)
SELECT crdb_internal.kv_enqueue_replica(:rangeid, 'mvccGC', true);

-- Test 2: query (line 19)
SELECT crdb_internal.kv_enqueue_replica(10000, 'mvccGC', true);

-- subtest kv_enqueue_replica_named_store
SELECT crdb_internal.kv_enqueue_replica(:rangeid, 'mvccGC', true, 1);
