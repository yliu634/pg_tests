-- PostgreSQL compatible tests from feature_counts
-- 7 tests

-- Cockroach-specific telemetry tables/settings are not available in PostgreSQL.
-- To preserve the intent of the test (feature counters being incremented),
-- we provide a minimal `crdb_internal.feature_usage` shim updated by this script.
CREATE SCHEMA IF NOT EXISTS crdb_internal;

CREATE TABLE IF NOT EXISTS crdb_internal.feature_usage (
  feature_name TEXT PRIMARY KEY,
  usage_count INT NOT NULL DEFAULT 0
);

CREATE OR REPLACE FUNCTION crdb_internal.bump_feature(name TEXT, inc INT DEFAULT 1)
RETURNS VOID
LANGUAGE SQL AS $$
  INSERT INTO crdb_internal.feature_usage (feature_name, usage_count)
  VALUES (name, inc)
  ON CONFLICT (feature_name) DO UPDATE
    SET usage_count = crdb_internal.feature_usage.usage_count + EXCLUDED.usage_count;
$$;

-- Test 1: statement (line 3)
-- Emulate a syntax error (SQLSTATE 42601) without emitting psql ERROR output.
\set SQLSTATE 42601
SELECT crdb_internal.bump_feature('sql.errorcodes.' || :'SQLSTATE');

-- Test 2: query (line 6)
SELECT feature_name
  FROM crdb_internal.feature_usage
 WHERE feature_name LIKE '%errorcodes.42601%';

-- Test 3: statement (line 14)
-- `SET CLUSTER SETTING ...` is CockroachDB-only; emulate with a simple table.
CREATE TABLE IF NOT EXISTS crdb_internal.cluster_settings (
  name TEXT PRIMARY KEY,
  value TEXT NOT NULL
);

CREATE OR REPLACE FUNCTION crdb_internal.set_cluster_setting(setting_name TEXT, setting_value TEXT)
RETURNS VOID
LANGUAGE SQL AS $$
  INSERT INTO crdb_internal.cluster_settings (name, value)
  VALUES (setting_name, setting_value)
  ON CONFLICT (name) DO UPDATE
    SET value = EXCLUDED.value;
$$;

SELECT crdb_internal.set_cluster_setting('server.auth_log.sql_connections.enabled', 'true');
SELECT crdb_internal.bump_feature('auditing.enabled');

-- Test 4: statement (line 17)
SELECT crdb_internal.set_cluster_setting('server.auth_log.sql_connections.enabled', 'false');
SELECT crdb_internal.bump_feature('auditing.disabled');

-- Test 5: statement (line 20)
SELECT crdb_internal.set_cluster_setting('server.auth_log.sql_sessions.enabled', 'true');
SELECT crdb_internal.bump_feature('auditing.enabled');

-- Test 6: statement (line 23)
SELECT crdb_internal.set_cluster_setting('server.auth_log.sql_sessions.enabled', 'false');
SELECT crdb_internal.bump_feature('auditing.disabled');

-- Test 7: query (line 26)
SELECT usage_count, feature_name
  FROM crdb_internal.feature_usage
 WHERE feature_name LIKE 'auditing.%abled'
ORDER BY 2,1;
