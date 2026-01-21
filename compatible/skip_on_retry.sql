-- PostgreSQL compatible tests from skip_on_retry
-- 5 tests

-- Test 1: statement (line 6)
SET client_min_messages = warning;

BEGIN;
SELECT 1;

-- Test 2: statement (line 9)
-- CockroachDB uses crdb_internal.force_retry() to force a retry error (SQLSTATE 40001).
-- Model that here with an explicit exception using the same SQLSTATE.
\set ON_ERROR_STOP 0
DO $$ BEGIN RAISE EXCEPTION 'force_retry' USING ERRCODE = '40001'; END $$;
\set ON_ERROR_STOP 1

-- Test 3: statement (line 12)
ROLLBACK;

-- skip_on_retry (CockroachDB logictest directive; no PostgreSQL equivalent)
-- The directive applies to the remainder of the file, so the rest is skipped
-- under PostgreSQL.

RESET client_min_messages;

-- Test 4: statement (line 19)
-- BEGIN; SELECT 1;

-- Test 5: statement (line 22)
-- DO $$ BEGIN RAISE EXCEPTION 'force_retry' USING ERRCODE = '40001'; END $$;
