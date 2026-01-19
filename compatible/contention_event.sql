-- PostgreSQL compatible tests from contention_event
-- 13 tests

-- Test 1: statement (line 8)
GRANT CREATE ON DATABASE test TO testuser

-- Test 2: statement (line 15)
GRANT INSERT ON TABLE kv TO testuser

-- Test 3: statement (line 18)
GRANT SYSTEM VIEWACTIVITYREDACTED TO testuser

-- Test 4: query (line 21)
SELECT * FROM kv

-- Test 5: statement (line 27)
BEGIN

-- Test 6: statement (line 30)
INSERT INTO kv VALUES('k', 'v')

user root

-- Test 7: statement (line 42)
BEGIN;
SET TRANSACTION PRIORITY HIGH;
SELECT * FROM kv ORDER BY k ASC

user testuser nodeidx=3

-- Test 8: statement (line 49)
ROLLBACK

-- Test 9: query (line 67)
WITH spans AS (
  SELECT span_id
  FROM crdb_internal.node_inflight_trace_spans
  WHERE trace_id = crdb_internal.trace_id()
), payloads AS (
  SELECT *
  FROM spans, LATERAL crdb_internal.payloads_for_span(spans.span_id)
) SELECT count(*) > 0
  FROM payloads
  WHERE payload_type = 'roachpb.ContentionEvent'
  AND crdb_internal.pretty_key(decode(payload_jsonb->>'key', 'base64'), 1) LIKE '/1/"k"/%'

-- Test 10: query (line 83)
WITH payloads AS (
  SELECT *
  FROM crdb_internal.payloads_for_trace(crdb_internal.trace_id())
) SELECT count(*) > 0
  FROM payloads
  WHERE payload_type = 'roachpb.ContentionEvent'
  AND crdb_internal.pretty_key(decode(payload_jsonb->>'key', 'base64'), 1) LIKE '/1/"k"/%'

-- Test 11: query (line 95)
WITH payloads AS (
  SELECT *
  FROM crdb_internal.payloads_for_trace(crdb_internal.trace_id())
) SELECT count(*) > 0
  FROM payloads
  WHERE payload_type = 'roachpb.ContentionEvent'
  AND crdb_internal.pretty_key(decode(payload_jsonb->>'key', 'base64'), 1) LIKE '/1/"k"/%'
  AND (payload_jsonb->'txnMeta'->>'coordinatorNodeId')::INTEGER = 4

-- Test 12: query (line 109)
SELECT count(*) > 0 FROM crdb_internal.cluster_contention_events WHERE table_id = 'kv'::REGCLASS::INT

-- Test 13: query (line 114)
SELECT count(*) > 0 FROM crdb_internal.node_contention_events WHERE table_id = 'kv'::REGCLASS::INT

