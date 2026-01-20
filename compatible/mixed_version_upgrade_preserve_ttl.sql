SET client_min_messages = warning;

-- PostgreSQL compatible tests from mixed_version_upgrade_preserve_ttl
-- 4 tests

-- Test 1: statement (line 9)
DROP TABLE IF EXISTS tbl CASCADE;
CREATE TABLE tbl (
  id INT PRIMARY KEY
);
-- COMMENTED: CockroachDB TTL option is not available in PostgreSQL.
-- WITH (ttl_expire_after = '10 minutes')

-- COMMENTED: Logic test directive: upgrade all

-- Test 2: statement (line 16)
-- COMMENTED: CockroachDB-specific: SET CLUSTER SETTING version = crdb_internal.node_executable_version();

-- Test 3: query (line 21)
-- COMMENTED: CockroachDB-only CLUSTER SETTING / variables.
-- SELECT version != '$initial_version' FROM [SHOW CLUSTER SETTING version];
SELECT current_setting('server_version') AS server_version;

-- Test 4: query (line 26)
-- COMMENTED: CockroachDB-only SHOW CREATE TABLE.
-- SELECT create_statement FROM [SHOW CREATE TABLE tbl];
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_schema = 'public' AND table_name = 'tbl'
ORDER BY ordinal_position;



RESET client_min_messages;
