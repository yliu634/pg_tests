-- PostgreSQL compatible tests from inflight_trace_spans
-- 8 tests

-- Test 1: statement (line 9)
GRANT ADMIN TO testuser

-- Test 2: statement (line 12)
CREATE TABLE kv (k VARCHAR PRIMARY KEY, v VARCHAR);

-- Test 3: query (line 15)
SELECT * FROM kv

-- Test 4: statement (line 21)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE

-- Test 5: statement (line 31)
CREATE VIEW current_trace_spans(span_id, trace_id)
  AS SELECT span_id, trace_id
  FROM crdb_internal.node_inflight_trace_spans
  WHERE trace_id = $curr_trace_id

-- Test 6: query (line 38)
SELECT count(*) > 0
  FROM current_trace_spans

-- Test 7: statement (line 44)
INSERT INTO kv VALUES('k', 'v');
COMMIT

-- Test 8: query (line 52)
SELECT count(*) = 0
  FROM current_trace_spans

