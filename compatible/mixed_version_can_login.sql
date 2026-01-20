SET client_min_messages = warning;

-- PostgreSQL compatible tests from mixed_version_can_login
-- 7 tests

-- Test 1: query (line 11)
-- COMMENTED: CockroachDB-specific: SELECT crdb_internal.release_series(crdb_internal.node_executable_version()) = '$origver'

-- Test 2: query (line 17)
-- COMMENTED: CockroachDB-specific: SELECT crdb_internal.release_series(crdb_internal.node_executable_version()) = '$origver'

-- Test 3: query (line 25)
-- COMMENTED: CockroachDB-specific: SELECT crdb_internal.release_series(crdb_internal.node_executable_version()) = '$origver'

-- Test 4: query (line 33)
-- COMMENTED: CockroachDB-specific: SELECT crdb_internal.release_series(crdb_internal.node_executable_version()) = '$origver'

-- Test 5: query (line 41)
-- COMMENTED: CockroachDB-specific: SELECT crdb_internal.release_series(crdb_internal.node_executable_version()) = '$origver'

-- Test 6: query (line 49)
-- COMMENTED: CockroachDB-specific: SELECT crdb_internal.release_series(crdb_internal.node_executable_version()) = '$origver'

-- Test 7: query (line 56)
-- COMMENTED: CockroachDB-specific: SELECT crdb_internal.release_series(crdb_internal.node_executable_version()) = '$origver'

RESET client_min_messages;