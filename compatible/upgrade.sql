-- PostgreSQL compatible tests from upgrade
-- 3 tests

-- Test 1: query (line 7)
SELECT crdb_internal.active_version()->'internal'

-- Test 2: statement (line 14)
SET CLUSTER SETTING version = crdb_internal.node_executable_version()

-- Test 3: query (line 18)
SELECT crdb_internal.release_series(version) FROM [SHOW CLUSTER SETTING version]

