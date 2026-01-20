-- PostgreSQL compatible tests from multiregion_invalid_locality
-- 2 tests

-- Test 1: query (line 3)
-- COMMENTED: CockroachDB-only SHOW REGIONS FROM CLUSTER.
SELECT current_database() AS database_name;

-- Test 2: query (line 9)
-- COMMENTED: CockroachDB-only gateway_region().
SELECT 'unknown'::text AS gateway_region;

-- query T nodeidx=2
-- COMMENTED: CockroachDB-only gateway_region().
SELECT 'unknown'::text AS gateway_region;
