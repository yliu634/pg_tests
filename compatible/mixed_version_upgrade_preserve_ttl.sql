-- PostgreSQL compatible tests from mixed_version_upgrade_preserve_ttl
-- 4 tests

SET client_min_messages = warning;
CREATE SCHEMA IF NOT EXISTS crdb_internal;

-- CockroachDB TTL and cluster-version upgrades don't exist in Postgres. Model
-- the intent of the test using a table comment (TTL metadata) and a custom
-- setting (crdb.version) that can be updated within the session.
CREATE OR REPLACE FUNCTION crdb_internal.node_executable_version()
RETURNS text
LANGUAGE sql
AS $$
  SELECT current_setting('server_version');
$$;

-- Test 1: statement (line 9)
CREATE TABLE tbl (
  id INT PRIMARY KEY
);
COMMENT ON TABLE tbl IS 'ttl_expire_after=10 minutes';

-- Test 2: statement (line 16)
-- Capture a synthetic "initial" version, then "upgrade" by setting crdb.version
-- to the node executable version.
SELECT 'initial' AS initial_version \gset
SET crdb.version TO :'initial_version';
SELECT crdb_internal.node_executable_version() AS node_executable_version \gset
SET crdb.version TO :'node_executable_version';

-- Test 3: query (line 21)
SELECT current_setting('crdb.version') != :'initial_version' AS upgraded;

-- Test 4: query (line 26)
SELECT format(
  'CREATE TABLE tbl (id integer PRIMARY KEY); -- %s',
  obj_description('tbl'::regclass, 'pg_class')
) AS create_statement;

RESET client_min_messages;
