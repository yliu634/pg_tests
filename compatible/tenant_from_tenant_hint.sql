-- PostgreSQL compatible tests from tenant_from_tenant_hint
-- 3 tests

-- Test 1: statement (line 16)
SET trace.redact_at_virtual_cluster_boundary.enabled = false;

-- Test 2: statement (line 20)
SET kv.rangefeed.enabled = true;

-- Test 3: statement (line 23)
SET server.rangelog.ttl = '300s';
