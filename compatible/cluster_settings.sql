-- PostgreSQL compatible tests from cluster_settings
-- 62 tests

-- Test 1: statement (line 2)
SET CLUSTER SETTING sql.log.slow_query.latency_threshold = '1ms'

-- Test 2: statement (line 5)
SET CLUSTER SETTING sql.log.slow_query.latency_threshold = '-1ms'

-- Test 3: statement (line 8)
SET CLUSTER SETTING sql.log.slow_query.latency_threshold = '1'

-- Test 4: statement (line 11)
SET CLUSTER SETTING sql.log.slow_query.latency_threshold = '-1'

-- Test 5: statement (line 14)
SET CLUSTER SETTING sql.log.slow_query.latency_threshold = 'true'

-- Test 6: statement (line 17)
SET CLUSTER SETTING sql.log.slow_query.latency_threshold = true

-- Test 7: statement (line 20)
SET CLUSTER SETTING sql.conn.max_read_buffer_message_size = '1b'

-- Test 8: statement (line 23)
SET CLUSTER SETTING sql.conn.max_read_buffer_message_size = '64MB'

-- Test 9: statement (line 26)
RESET CLUSTER SETTING sql.conn.max_read_buffer_message_size

-- Test 10: statement (line 33)
SET CLUSTER SETTING sql.defaults.default_int_size = 4

-- Test 11: statement (line 36)
SET CLUSTER SETTING version = '22.2'

-- Test 12: statement (line 39)
SHOW CLUSTER SETTING sql.defaults.default_int_size

-- Test 13: statement (line 42)
SHOW CLUSTER SETTINGS

-- Test 14: statement (line 45)
SHOW ALL CLUSTER SETTINGS

user root

-- Test 15: statement (line 50)
ALTER USER testuser MODIFYCLUSTERSETTING

user testuser

-- Test 16: statement (line 55)
SET CLUSTER SETTING sql.defaults.default_int_size = 4

-- Test 17: query (line 58)
SHOW CLUSTER SETTING sql.defaults.default_int_size

-- Test 18: query (line 65)
SHOW CLUSTER SETTING diagnostics.reporting.enabled

-- Test 19: query (line 70)
SELECT variable, value FROM [SHOW CLUSTER SETTINGS]
WHERE variable IN ('sql.defaults.default_int_size')

-- Test 20: query (line 76)
SELECT variable, value FROM [SHOW ALL CLUSTER SETTINGS]
WHERE variable IN ('sql.defaults.default_int_size')

-- Test 21: query (line 82)
SELECT variable, value, default_value, origin FROM [SHOW ALL CLUSTER SETTINGS]
WHERE variable IN ('sql.index_recommendation.drop_unused_duration')

-- Test 22: statement (line 88)
SET CLUSTER SETTING sql.index_recommendation.drop_unused_duration = '10s'

-- Test 23: query (line 91)
SELECT variable, value, default_value, origin FROM [SHOW ALL CLUSTER SETTINGS]
WHERE variable IN ('sql.index_recommendation.drop_unused_duration')

-- Test 24: statement (line 97)
RESET CLUSTER SETTING sql.index_recommendation.drop_unused_duration

-- Test 25: query (line 100)
SELECT variable, value, default_value, origin FROM [SHOW ALL CLUSTER SETTINGS]
WHERE variable IN ('sql.index_recommendation.drop_unused_duration')

-- Test 26: query (line 114)
SELECT variable, value, default_value, origin FROM [SHOW ALL CLUSTER SETTINGS]
WHERE variable IN ('sql.index_recommendation.drop_unused_duration')

-- Test 27: statement (line 122)
ALTER USER testuser NOMODIFYCLUSTERSETTING

user testuser

-- Test 28: statement (line 127)
SET CLUSTER SETTING sql.defaults.default_int_size = 4

-- Test 29: statement (line 133)
GRANT SYSTEM MODIFYSQLCLUSTERSETTING TO testuser

user testuser

-- Test 30: statement (line 138)
SHOW CLUSTER SETTINGS

-- Test 31: statement (line 141)
SHOW CLUSTER SETTING diagnostics.reporting.enabled

-- Test 32: statement (line 144)
SET CLUSTER SETTING sql.defaults.default_int_size = 4

-- Test 33: statement (line 147)
SET CLUSTER SETTING diagnostics.reporting.enabled = false

user root

-- Test 34: statement (line 152)
ALTER USER testuser NOMODIFYCLUSTERSETTING

-- Test 35: statement (line 155)
ALTER USER testuser VIEWCLUSTERSETTING

user testuser

-- Test 36: statement (line 162)
SET CLUSTER SETTING diagnostics.reporting.enabled = false

-- Test 37: query (line 165)
SHOW CLUSTER SETTING diagnostics.reporting.enabled

-- Test 38: statement (line 172)
REVOKE SYSTEM MODIFYSQLCLUSTERSETTING FROM testuser

user testuser

-- Test 39: query (line 177)
SHOW CLUSTER SETTING diagnostics.reporting.enabled

-- Test 40: statement (line 182)
SET CLUSTER SETTING sql.defaults.default_int_size = 4

-- Test 41: query (line 185)
SHOW CLUSTER SETTING sql.defaults.default_int_size

-- Test 42: query (line 190)
SELECT variable, value FROM [SHOW CLUSTER SETTINGS]
WHERE variable IN ('sql.defaults.default_int_size')

-- Test 43: query (line 196)
SELECT variable, value FROM [SHOW ALL CLUSTER SETTINGS]
WHERE variable IN ('sql.defaults.default_int_size')

-- Test 44: statement (line 204)
ALTER USER testuser NOVIEWCLUSTERSETTING

user testuser

-- Test 45: statement (line 209)
SET CLUSTER SETTING sql.defaults.default_int_size = 4

-- Test 46: statement (line 212)
SHOW CLUSTER SETTINGS

-- Test 47: statement (line 215)
SHOW ALL CLUSTER SETTINGS

user root

-- Test 48: statement (line 220)
GRANT admin TO testuser

user testuser

-- Test 49: query (line 225)
SELECT variable, value FROM [SHOW CLUSTER SETTINGS]
WHERE variable IN ( 'sql.defaults.default_int_size')

-- Test 50: query (line 231)
SELECT variable, value FROM [SHOW ALL CLUSTER SETTINGS]
WHERE variable IN ('sql.defaults.default_int_size')

-- Test 51: query (line 237)
SHOW CLUSTER SETTING sql.defaults.stub_catalog_tables.enabled

-- Test 52: query (line 247)
SHOW CLUSTER SETTING kv.snapshot_rebalance.max_rate

-- Test 53: query (line 253)
SELECT crdb_internal.cluster_setting_encoded_default('kv.snapshot_rebalance.max_rate')

-- Test 54: query (line 259)
SELECT crdb_internal.decode_cluster_setting('kv.snapshot_rebalance.max_rate', '33554432')

-- Test 55: statement (line 409)
SHOW CLUSTER SETTING sql.defaults.distsql;

-- Test 56: query (line 412)
SHOW CLUSTER SETTING sql.notices.enabled

-- Test 57: query (line 424)
SHOW CLUSTER SETTING sql.trace.log_statement_execute

-- Test 58: query (line 429)
RESET CLUSTER SETTING sql.trace.log_statement_execute

-- Test 59: query (line 455)
SET CLUSTER SETTING sql.ttl.default_delete_rate_limit = 90;

-- Test 60: statement (line 461)
SET CLUSTER SETTING sql.ttl.default_delete_rate_limit = 100;

-- Test 61: query (line 464)
SET CLUSTER SETTING sql.ttl.default_select_rate_limit = 100;

-- Test 62: statement (line 470)
SET CLUSTER SETTING sql.ttl.default_select_rate_limit = 0;

