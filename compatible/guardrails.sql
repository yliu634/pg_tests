-- PostgreSQL compatible tests from guardrails
-- 2 tests

SET client_min_messages = warning;

DROP TABLE IF EXISTS guardrails;

-- Test 1: statement (line 5)
CREATE TABLE guardrails (i INT PRIMARY KEY);
INSERT INTO guardrails SELECT generate_series(1, 100);

-- Test 2: statement (line 11)
-- CockroachDB guardrail setting; no direct PostgreSQL equivalent.
-- SET transaction_rows_read_err = 1

DROP TABLE guardrails;

RESET client_min_messages;
