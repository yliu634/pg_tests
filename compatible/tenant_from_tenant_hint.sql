-- PostgreSQL compatible tests from tenant_from_tenant_hint
-- 3 tests

-- PG-NOT-SUPPORTED: CockroachDB tenant/virtual cluster boundary behavior (and
-- related `SET CLUSTER SETTING` knobs) has no PostgreSQL equivalent.
--
-- The original CockroachDB-derived SQL is preserved below for reference, but
-- is not executed under PostgreSQL.

SET client_min_messages = warning;

SELECT
  'skipped: tenant_from_tenant_hint uses CockroachDB tenant/cluster settings'
    AS notice;

RESET client_min_messages;

/*
-- Test 1: statement (line 16)
SET CLUSTER SETTING trace.redact_at_virtual_cluster_boundary.enabled = false;

-- Test 2: statement (line 20)
SET CLUSTER SETTING kv.rangefeed.enabled = true

-- Test 3: statement (line 23)
SET CLUSTER SETTING server.rangelog.ttl = '300s'
*/
