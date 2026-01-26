-- PostgreSQL compatible tests from multiregion_invalid_locality
-- 2 tests

-- Test 1: query (line 3)
-- CockroachDB-only: SHOW REGIONS FROM CLUSTER
SELECT 'global'::text AS region;

-- Test 2: query (line 9)
-- CockroachDB-only: gateway_region()
CREATE OR REPLACE FUNCTION gateway_region()
RETURNS text
LANGUAGE sql
AS $$ SELECT 'global'::text $$;
SELECT gateway_region();

-- query T nodeidx=2
SELECT gateway_region();
