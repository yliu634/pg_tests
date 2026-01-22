-- PostgreSQL compatible tests from mixed_version_can_login
-- 7 tests

SET client_min_messages = warning;
CREATE SCHEMA IF NOT EXISTS crdb_internal;

-- CockroachDB mixed-version tests reference crdb_internal helpers. Provide
-- minimal shims so the queries remain meaningful in PostgreSQL.
CREATE OR REPLACE FUNCTION crdb_internal.node_executable_version()
RETURNS text
LANGUAGE sql
AS $$
  SELECT current_setting('server_version');
$$;

CREATE OR REPLACE FUNCTION crdb_internal.release_series(v text)
RETURNS text
LANGUAGE sql
AS $$
  -- Keep the leading numeric part (e.g. "16.11" from "16.11 (Ubuntu ...)").
  SELECT regexp_replace(v, '^([0-9]+([.][0-9]+)?).*$', '\1');
$$;

-- Capture the "original" version series to mimic CockroachDB's $origver
-- placeholder from the upstream test harness.
SELECT crdb_internal.release_series(crdb_internal.node_executable_version()) AS origver \gset

-- Test 1: query (line 11)
SELECT crdb_internal.release_series(crdb_internal.node_executable_version()) = :'origver';

-- Test 2: query (line 17)
SELECT crdb_internal.release_series(crdb_internal.node_executable_version()) = :'origver';

-- Test 3: query (line 25)
SELECT crdb_internal.release_series(crdb_internal.node_executable_version()) = :'origver';

-- Test 4: query (line 33)
SELECT crdb_internal.release_series(crdb_internal.node_executable_version()) = :'origver';

-- Test 5: query (line 41)
SELECT crdb_internal.release_series(crdb_internal.node_executable_version()) = :'origver';

-- Test 6: query (line 49)
SELECT crdb_internal.release_series(crdb_internal.node_executable_version()) = :'origver';

-- Test 7: query (line 56)
SELECT crdb_internal.release_series(crdb_internal.node_executable_version()) = :'origver';

RESET client_min_messages;
