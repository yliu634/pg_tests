SET client_min_messages = warning;

-- PostgreSQL compatible tests from locality
-- 3 tests

-- Test 1: query (line 3)
-- COMMENTED: CockroachDB-specific: SELECT crdb_internal.locality_value('region');

-- Test 2: query (line 8)
-- COMMENTED: CockroachDB-specific: SELECT crdb_internal.locality_value('dc');

-- Test 3: query (line 13)
-- COMMENTED: CockroachDB-specific: SELECT crdb_internal.locality_value('unk')

RESET client_min_messages;