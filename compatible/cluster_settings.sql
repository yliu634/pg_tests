-- PostgreSQL compatible tests from cluster_settings
-- 62 tests

SET client_min_messages = warning;

-- CockroachDB cluster settings do not exist in PostgreSQL. To keep this test
-- runnable and deterministic, we treat them as custom GUCs and introspect via
-- SHOW/current_setting().

SET sql.log.slow_query.latency_threshold = '1ms';
SHOW sql.log.slow_query.latency_threshold;
SET sql.log.slow_query.latency_threshold = '-1ms';
SHOW sql.log.slow_query.latency_threshold;

SET sql.conn.max_read_buffer_message_size = '1b';
SHOW sql.conn.max_read_buffer_message_size;
SET sql.conn.max_read_buffer_message_size = '64MB';
SHOW sql.conn.max_read_buffer_message_size;
RESET sql.conn.max_read_buffer_message_size;
SHOW sql.conn.max_read_buffer_message_size;

SET sql.defaults.default_int_size = 4;
SHOW sql.defaults.default_int_size;

-- "version" is not a PG setting; store it under a custom namespace.
SET crdb.version = '22.2';
SHOW crdb.version;

-- Rough "SHOW ALL CLUSTER SETTINGS" equivalent for a small subset.
SELECT 'sql.defaults.default_int_size' AS variable,
       current_setting('sql.defaults.default_int_size', true) AS value;
SELECT 'sql.conn.max_read_buffer_message_size' AS variable,
       current_setting('sql.conn.max_read_buffer_message_size', true) AS value;
SELECT 'crdb.version' AS variable,
       current_setting('crdb.version', true) AS value;

SET sql.index_recommendation.drop_unused_duration = '10s';
SHOW sql.index_recommendation.drop_unused_duration;

-- Misc settings referenced in Cockroach tests.
SELECT current_setting('sql.defaults.distsql', true) AS "sql.defaults.distsql";
SELECT current_setting('sql.notices.enabled', true) AS "sql.notices.enabled";
SELECT current_setting('sql.trace.log_statement_execute', true) AS "sql.trace.log_statement_execute";
RESET sql.trace.log_statement_execute;

SET sql.ttl.default_delete_rate_limit = 90;
SHOW sql.ttl.default_delete_rate_limit;
SET sql.ttl.default_delete_rate_limit = 100;
SHOW sql.ttl.default_delete_rate_limit;
SET sql.ttl.default_select_rate_limit = 100;
SHOW sql.ttl.default_select_rate_limit;
SET sql.ttl.default_select_rate_limit = 0;
SHOW sql.ttl.default_select_rate_limit;

-- CRDB internal helpers (no PG equivalent).
SELECT NULL::text AS encoded_default;
SELECT NULL::text AS decoded_value;

RESET client_min_messages;
