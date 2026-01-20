-- PostgreSQL compatible tests from auto_span_config_reconciliation_job
-- 4 tests

SET client_min_messages = warning;

-- Test 1: statement (line 2)
-- CRDB cluster setting; in PG treat as a custom GUC (no-op).
SET spanconfig.reconciliation_job.enabled = true;

-- Test 2: query (line 7)
-- PG does not have CRDB's job system; return an empty result set with the
-- expected columns.
SELECT count(*), job_type, status
FROM (
  SELECT NULL::text AS job_type, NULL::text AS status
  WHERE false
) AS automatic_jobs
WHERE job_type = 'AUTO SPAN CONFIG RECONCILIATION'
GROUP BY job_type, status;

-- Test 3: statement (line 24)
-- CRDB-only syntax; keep a deterministic placeholder statement.
SELECT 'CANCEL JOB not supported in PostgreSQL'::text AS notice;

-- Test 4: query (line 28)
SELECT status
FROM (
  SELECT NULL::bigint AS job_id, NULL::text AS status
  WHERE false
) AS automatic_jobs
WHERE job_id = 0;

RESET client_min_messages;
