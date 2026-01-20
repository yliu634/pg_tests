-- PostgreSQL compatible tests from locality
-- 3 tests

-- Test 1: query (line 3)
SELECT crdb_internal.locality_value('region')

-- Test 2: query (line 8)
SELECT crdb_internal.locality_value('dc')

-- Test 3: query (line 13)
SELECT crdb_internal.locality_value('unk')

