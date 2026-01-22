-- PostgreSQL compatible tests from multiregion_invalid_locality
-- 2 tests
--
-- PG-NOT-SUPPORTED: CockroachDB multi-region features (SHOW REGIONS FROM CLUSTER,
-- gateway_region()) do not exist in PostgreSQL.
--
-- The original CockroachDB-derived SQL is preserved below for reference, but is
-- not executed under PostgreSQL.

SET client_min_messages = warning;

SELECT
  'skipped: multiregion requires CockroachDB cluster regions/locality features'
    AS notice;

RESET client_min_messages;

/*
-- PostgreSQL compatible tests from multiregion_invalid_locality
-- 2 tests

-- Test 1: query (line 3)
SHOW REGIONS FROM CLUSTER

-- Test 2: query (line 9)
SELECT gateway_region()

query T nodeidx=2
SELECT gateway_region()
*/
