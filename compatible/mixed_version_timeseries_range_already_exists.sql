-- PostgreSQL compatible tests from mixed_version_timeseries_range_already_exists
-- 2 tests

-- Test 1: statement (line 7)
ALTER RANGE timeseries CONFIGURE ZONE USING gc.ttlseconds = 12345, num_replicas = 5

-- Test 2: statement (line 19)
SET CLUSTER SETTING version = crdb_internal.node_executable_version()

