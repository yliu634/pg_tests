SET client_min_messages = warning;

-- PostgreSQL compatible tests from mixed_version_upgrade_preserve_ttl
-- 4 tests

-- Test 1: statement (line 9)
DROP TABLE IF EXISTS tbl CASCADE;
CREATE TABLE tbl (;
  id INT PRIMARY KEY
) WITH (ttl_expire_after = '10 minutes')

-- COMMENTED: Logic test directive: upgrade all

-- Test 2: statement (line 16)
-- COMMENTED: CockroachDB-specific: SET CLUSTER SETTING version = crdb_internal.node_executable_version();

-- Test 3: query (line 21)
SELECT version != '$initial_version' FROM [SHOW CLUSTER SETTING version];

-- Test 4: query (line 26)
SELECT create_statement FROM [SHOW CREATE TABLE tbl];



RESET client_min_messages;