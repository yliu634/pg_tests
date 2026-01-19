-- PostgreSQL compatible tests from auto_span_config_reconciliation_job
-- 4 tests

-- Test 1: statement (line 2)
SET CLUSTER SETTING spanconfig.reconciliation_job.enabled = true;

-- Test 2: query (line 7)
SELECT count(*), job_type, status FROM [SHOW AUTOMATIC JOBS] WHERE job_type = 'AUTO SPAN CONFIG RECONCILIATION' GROUP BY (job_type, status)

-- Test 3: statement (line 24)
CANCEL JOB $job_id

-- Test 4: query (line 28)
SELECT status FROM [SHOW AUTOMATIC JOBS] WHERE job_id = $job_id

