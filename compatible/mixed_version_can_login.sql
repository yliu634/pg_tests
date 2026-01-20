-- PostgreSQL compatible tests from mixed_version_can_login
-- 7 tests

-- Test 1: query (line 11)
SELECT crdb_internal.release_series(crdb_internal.node_executable_version()) = '$origver'

-- Test 2: query (line 17)
SELECT crdb_internal.release_series(crdb_internal.node_executable_version()) = '$origver'

-- Test 3: query (line 25)
SELECT crdb_internal.release_series(crdb_internal.node_executable_version()) = '$origver'

-- Test 4: query (line 33)
SELECT crdb_internal.release_series(crdb_internal.node_executable_version()) = '$origver'

-- Test 5: query (line 41)
SELECT crdb_internal.release_series(crdb_internal.node_executable_version()) = '$origver'

-- Test 6: query (line 49)
SELECT crdb_internal.release_series(crdb_internal.node_executable_version()) = '$origver'

-- Test 7: query (line 56)
SELECT crdb_internal.release_series(crdb_internal.node_executable_version()) = '$origver'

