-- PostgreSQL compatible tests from multiregion_invalid_locality
-- 2 tests

-- Test 1: query (line 3)
SHOW REGIONS FROM CLUSTER;

-- Test 2: query (line 9)
SELECT gateway_region();

-- query T nodeidx=2
SELECT gateway_region();

