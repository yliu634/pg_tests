-- PostgreSQL compatible tests from txn_retry
-- 10 tests

SET client_min_messages = warning;

CREATE SCHEMA IF NOT EXISTS test;
CREATE SCHEMA IF NOT EXISTS crdb_internal;

DROP TABLE IF EXISTS test.test_retry;
DROP ROLE IF EXISTS txn_retry_testuser;
CREATE ROLE txn_retry_testuser LOGIN;

-- CockroachDB function stub: deterministic and PostgreSQL-friendly.
CREATE OR REPLACE FUNCTION cluster_logical_timestamp() RETURNS BIGINT LANGUAGE SQL AS $$
  SELECT 0::bigint;
$$;

-- CockroachDB retry helper stub: emulate a retryable error.
CREATE OR REPLACE FUNCTION crdb_internal.force_retry(i INT) RETURNS INT LANGUAGE plpgsql AS $$
BEGIN
  RAISE EXCEPTION 'forced retry %', i USING ERRCODE = '40001';
END
$$;

-- Test table.
CREATE TABLE test.test_retry (
  k INT PRIMARY KEY
);

GRANT ALL ON test.test_retry TO txn_retry_testuser;

BEGIN;
SELECT * FROM test.test_retry ORDER BY k;

-- user root
SELECT cluster_logical_timestamp();
INSERT INTO test.test_retry VALUES (1);
COMMIT;

-- Expected ERROR (forced retry):
\set ON_ERROR_STOP 0
SELECT crdb_internal.force_retry(0);
\set ON_ERROR_STOP 1

-- Expected ERROR (forced retry):
\set ON_ERROR_STOP 0
SELECT crdb_internal.force_retry(3);
\set ON_ERROR_STOP 1

SELECT * FROM test.test_retry ORDER BY k;

DROP TABLE test.test_retry;
DROP ROLE txn_retry_testuser;

RESET client_min_messages;
