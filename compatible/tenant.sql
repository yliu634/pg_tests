-- PostgreSQL compatible tests from tenant
-- 18 tests

-- PG-NOT-SUPPORTED: CockroachDB tenant/virtual cluster behavior (and
-- tenant-scoped privilege checks like `MANAGEVIRTUALCLUSTER` / `SET CLUSTER
-- SETTING`) has no PostgreSQL equivalent.
--
-- The original CockroachDB-derived SQL is preserved below for reference, but
-- is not executed under PostgreSQL.

SET client_min_messages = warning;

SELECT
  'skipped: tenant/virtual cluster tests have no PostgreSQL equivalent'
    AS notice;

RESET client_min_messages;

/*
-- Test 1: statement (line 134)
set default_transaction_read_only = on;

-- Test 2: statement (line 140)
set default_transaction_read_only = off;

user testuser

-- Test 3: statement (line 187)
set default_transaction_read_only = on;

-- Test 4: statement (line 193)
set default_transaction_read_only = off;

user testuser

-- Test 5: statement (line 209)
GRANT SYSTEM MANAGEVIRTUALCLUSTER TO testuser

user testuser

-- Test 6: statement (line 231)
REVOKE SYSTEM MANAGEVIRTUALCLUSTER FROM testuser

-- Test 7: statement (line 251)
SET default_transaction_read_only = true

-- Test 8: statement (line 263)
SET default_transaction_read_only = false

-- Test 9: statement (line 386)
SET CLUSTER SETTING server.controller.default_target_cluster = noservice

-- Test 10: statement (line 396)
SET CLUSTER SETTING server.controller.default_target_cluster = withservice

-- Test 11: statement (line 403)
RESET CLUSTER SETTING server.controller.default_target_cluster

-- Test 12: statement (line 411)
SET CLUSTER SETTING sql.restrict_system_interface.enabled = true

-- Test 13: statement (line 414)
SET CLUSTER SETTING ui.display_timezone = 'America/New_York'

-- Test 14: statement (line 417)
CREATE TABLE foo(x INT)

-- Test 15: statement (line 420)
CREATE DATABASE foo

-- Test 16: statement (line 423)
CREATE SCHEMA foo

-- Test 17: statement (line 426)
CREATE VIEW foo AS SELECT latitude,longitude FROM system.locations

-- Test 18: statement (line 429)
RESET CLUSTER SETTING sql.restrict_system_interface.enabled
*/
