-- PostgreSQL compatible tests from as_of
-- 20 tests

SET client_min_messages = warning;

-- CockroachDB AOST helpers are not available in PostgreSQL; stub them so the
-- surrounding tests can run.
CREATE OR REPLACE FUNCTION with_min_timestamp(ts timestamptz)
RETURNS timestamptz
LANGUAGE SQL
AS $$ SELECT ts $$;

CREATE OR REPLACE FUNCTION with_max_staleness(i interval)
RETURNS interval
LANGUAGE SQL
AS $$ SELECT i $$;

-- Test 1: statement (line 2)
DROP TABLE IF EXISTS t;
CREATE TABLE t (i INT);

-- Test 2: statement (line 5)
INSERT INTO t VALUES (2);

-- Test 3: query (line 35)
SELECT pg_sleep(5); -- allow timestamps to advance a bit

-- Test 4: statement (line 105)
SELECT with_min_timestamp('2020-01-15 15:16:17');

-- skipif config enterprise-configs

-- Test 5: statement (line 109)
SELECT with_min_timestamp(statement_timestamp());

-- skipif config enterprise-configs

-- Test 6: statement (line 113)
SELECT with_max_staleness('1s');

-- skipif config enterprise-configs

-- Test 7: statement (line 128)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- Test 8: statement (line 131)
SELECT * FROM t;

-- Test 9: statement (line 137)
ROLLBACK;

-- Test 10: statement (line 140)
-- In CRDB this is a real setting; in PG treat as a custom GUC (no-op).
SET kv.transaction_buffered_writes_enabled = false;

-- Test 11: statement (line 143)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- Test 12: statement (line 146)
INSERT INTO t VALUES (1);

-- Test 13: statement (line 152)
ROLLBACK;

-- Test 14: statement (line 155)
SET kv.transaction_buffered_writes_enabled = true;

-- Test 15: statement (line 159)
-- CRDB-only syntax; rewrite as a custom GUC so the test runs.
SET kv.transaction.write_buffering.max_buffer_size = '2KiB';

-- Test 16: statement (line 162)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- Test 17: statement (line 165)
INSERT INTO t VALUES (1);

-- Test 18: statement (line 171)
ROLLBACK;

-- Test 19: statement (line 174)
RESET kv.transaction_buffered_writes_enabled;

-- Test 20: statement (line 233)
DROP TABLE IF EXISTS v00;
CREATE TABLE v00 (c01 INT);

RESET client_min_messages;
