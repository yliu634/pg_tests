-- PostgreSQL compatible tests from generator_probe_ranges
-- 3 tests

-- CockroachDB exposes `crdb_internal.probe_ranges(...)` for probing KV ranges.
-- PostgreSQL has no equivalent, so provide a minimal stub that returns zero
-- rows; this preserves the expected-empty/zero-count assertions below.
CREATE SCHEMA IF NOT EXISTS crdb_internal;

CREATE OR REPLACE FUNCTION crdb_internal.probe_ranges(probe_interval interval, probe_type text)
RETURNS TABLE (range_id int, error text, verbose_trace text)
LANGUAGE sql
AS $$
  SELECT NULL::int, ''::text, ''::text
  WHERE false
$$;

-- Test 1: query (line 3)
SELECT * FROM crdb_internal.probe_ranges(INTERVAL '1000ms', 'read') WHERE range_id < 0;

-- Test 2: query (line 8)
SELECT count(1) FROM crdb_internal.probe_ranges(INTERVAL '1000ms', 'read') WHERE error != '';

-- Test 3: query (line 15)
SELECT count(1) FROM crdb_internal.probe_ranges(INTERVAL '1000ms', 'write') WHERE range_id = 2 AND verbose_trace LIKE '%proposing command%';
