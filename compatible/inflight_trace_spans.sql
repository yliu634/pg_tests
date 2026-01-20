-- PostgreSQL compatible tests from inflight_trace_spans
--
-- CockroachDB exposes inflight trace spans via crdb_internal.*. PostgreSQL does
-- not, but it does expose whether a transaction has been assigned an XID.
-- This file uses txid_current_if_assigned() as a lightweight stand-in.

SET client_min_messages = warning;

DROP VIEW IF EXISTS current_trace_spans;
DROP TABLE IF EXISTS its_kv;

CREATE TABLE its_kv (k TEXT PRIMARY KEY, v TEXT);

CREATE VIEW current_trace_spans(span_id, trace_id) AS
SELECT
  pg_backend_pid()::TEXT AS span_id,
  txid_current_if_assigned()::TEXT AS trace_id
WHERE txid_current_if_assigned() IS NOT NULL;

BEGIN;
INSERT INTO its_kv VALUES ('k', 'v');
SELECT count(*) > 0 FROM current_trace_spans;
COMMIT;

SELECT count(*) = 0 FROM current_trace_spans;

DROP VIEW current_trace_spans;
DROP TABLE its_kv;

RESET client_min_messages;
