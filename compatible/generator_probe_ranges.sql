-- PostgreSQL compatible tests from generator_probe_ranges
-- 3 tests

-- Test 1: query (line 3)
SELECT * FROM crdb_internal.probe_ranges(INTERVAL '1000ms', 'read') WHERE range_id < 0

-- Test 2: query (line 8)
SELECT count(1) FROM crdb_internal.probe_ranges(INTERVAL '1000ms', 'read') WHERE error != ''

-- Test 3: query (line 15)
SELECT count(1) FROM crdb_internal.probe_ranges(INTERVAL '1000ms', 'write') WHERE range_id = 2 AND verbose_trace LIKE '%proposing command%'

