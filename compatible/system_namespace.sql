-- PostgreSQL compatible tests from system_namespace
-- 2 tests

-- Test 1: query (line 1)
SELECT * FROM system.namespace WHERE id >= 100 OR name IN ('comments', 'locations', 'descriptor_id_seq')

-- Test 2: query (line 15)
SHOW COLUMNS FROM system.namespace

