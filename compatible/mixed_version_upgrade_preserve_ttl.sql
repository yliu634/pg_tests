-- PostgreSQL compatible tests from mixed_version_upgrade_preserve_ttl
-- 4 tests

-- Test 1: statement (line 9)
CREATE TABLE tbl (
  id INT PRIMARY KEY
) WITH (ttl_expire_after = '10 minutes')

upgrade all

-- Test 2: statement (line 16)
SET CLUSTER SETTING version = crdb_internal.node_executable_version()

-- Test 3: query (line 21)
SELECT version != '$initial_version' FROM [SHOW CLUSTER SETTING version]

-- Test 4: query (line 26)
SELECT create_statement FROM [SHOW CREATE TABLE tbl]

