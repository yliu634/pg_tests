-- PostgreSQL compatible tests from feature_counts
-- 7 tests

-- Test 1: statement (line 3)
SELECT 'a'::INTERVAL(123)

-- Test 2: query (line 6)
SELECT feature_name
  FROM crdb_internal.feature_usage
 WHERE feature_name LIKE '%errorcodes.42601%'

-- Test 3: statement (line 14)
SET CLUSTER SETTING server.auth_log.sql_connections.enabled = true;

-- Test 4: statement (line 17)
SET CLUSTER SETTING server.auth_log.sql_connections.enabled = false;

-- Test 5: statement (line 20)
SET CLUSTER SETTING server.auth_log.sql_sessions.enabled = true;

-- Test 6: statement (line 23)
SET CLUSTER SETTING server.auth_log.sql_sessions.enabled = false

-- Test 7: query (line 26)
SELECT usage_count, feature_name
  FROM crdb_internal.feature_usage
 WHERE feature_name LIKE 'auditing.%abled'
ORDER BY 2,1

