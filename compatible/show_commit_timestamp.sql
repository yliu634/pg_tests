-- PostgreSQL compatible tests from show_commit_timestamp
-- 18 tests

SET client_min_messages = warning;

CREATE SCHEMA IF NOT EXISTS crdb_internal;

-- CockroachDB has SHOW COMMIT TIMESTAMP to surface the commit timestamp for the
-- current transaction. PostgreSQL does not expose commit timestamps unless
-- track_commit_timestamp is enabled cluster-wide. Approximate by assigning a
-- deterministic, monotonic "commit timestamp" per transaction.
CREATE SEQUENCE IF NOT EXISTS crdb_internal.commit_ts_seq START 1;

CREATE TABLE IF NOT EXISTS crdb_internal.txn_commit_ts (
  xid BIGINT PRIMARY KEY,
  commit_ts BIGINT NOT NULL
);

CREATE OR REPLACE FUNCTION crdb_internal.show_commit_timestamp()
RETURNS BIGINT
LANGUAGE plpgsql AS $$
DECLARE
  xid_val BIGINT;
  ts BIGINT;
BEGIN
  xid_val := txid_current();
  SELECT t.commit_ts INTO ts
  FROM crdb_internal.txn_commit_ts AS t
  WHERE t.xid = xid_val;

  IF ts IS NULL THEN
    ts := nextval('crdb_internal.commit_ts_seq'::regclass);
    INSERT INTO crdb_internal.txn_commit_ts(xid, commit_ts) VALUES (xid_val, ts);
  END IF;

  RETURN ts;
END;
$$;

DROP TABLE IF EXISTS foo;
CREATE TABLE foo (
  i INT PRIMARY KEY,
  ts BIGINT NOT NULL
);

-- Test 1: statement (basic insert)
BEGIN;
INSERT INTO foo(i, ts) VALUES (1, crdb_internal.show_commit_timestamp());
SELECT crdb_internal.show_commit_timestamp() AS ts1 \gset
COMMIT;

-- Test 2: query (ts1 matches inserted row)
SELECT :ts1::bigint = (SELECT ts FROM foo WHERE i = 1) AS ts_matches_row;

-- Test 3: query (select by timestamp)
SELECT * FROM foo WHERE ts = :ts1::bigint ORDER BY i;

-- Test 4: statement (savepoint/release; ts stable within txn)
BEGIN;
SAVEPOINT cockroach_restart;
INSERT INTO foo(i, ts) VALUES (2, crdb_internal.show_commit_timestamp());
RELEASE SAVEPOINT cockroach_restart;
SELECT crdb_internal.show_commit_timestamp() AS ts2 \gset
SELECT crdb_internal.show_commit_timestamp() AS ts2_again \gset
COMMIT;

-- Test 5: query (ts stable within txn)
SELECT :ts2::bigint = :ts2_again::bigint AS ts_stable_within_tx;

-- Test 6: query (select by timestamp)
SELECT * FROM foo WHERE ts = :ts2::bigint ORDER BY i;

-- Test 7: statement (autocommit insert; capture ts via RETURNING)
INSERT INTO foo(i, ts)
VALUES (3, crdb_internal.show_commit_timestamp())
RETURNING ts AS ts3 \gset

-- Test 8: query (select by timestamp)
SELECT * FROM foo WHERE ts = :ts3::bigint ORDER BY i;

-- Test 9: statement (rollback-to-savepoint keeps ts)
BEGIN;
SELECT crdb_internal.show_commit_timestamp() AS ts4 \gset
SAVEPOINT sp;
INSERT INTO foo(i, ts) VALUES (99, crdb_internal.show_commit_timestamp());
ROLLBACK TO SAVEPOINT sp;
SELECT crdb_internal.show_commit_timestamp() AS ts4_again \gset
COMMIT;

-- Test 10: query (ts stable across savepoint rollback)
SELECT :ts4::bigint = :ts4_again::bigint AS ts_stable_across_savepoint_rollback;

-- Test 11: statement (rollback removes writes)
BEGIN;
INSERT INTO foo(i, ts)
VALUES (4, crdb_internal.show_commit_timestamp())
RETURNING ts AS ts_rolled \gset
ROLLBACK;

-- Test 12: query (row not present after rollback)
SELECT count(*) AS rows_i4 FROM foo WHERE i = 4;

-- Test 13: statement (SQL UDF wrapper)
CREATE OR REPLACE FUNCTION f_commit_ts() RETURNS BIGINT LANGUAGE sql AS $$
  SELECT crdb_internal.show_commit_timestamp();
$$;

-- Test 14: statement (UDF stable within txn)
BEGIN;
SELECT f_commit_ts() AS f_ts1 \gset
SELECT f_commit_ts() AS f_ts2 \gset
COMMIT;

-- Test 15: query (UDF stable)
SELECT :f_ts1::bigint = :f_ts2::bigint AS func_ts_stable;

-- Test 16: statement (prepared statement stable within txn)
BEGIN;
PREPARE s_commit_ts AS SELECT crdb_internal.show_commit_timestamp();
EXECUTE s_commit_ts;
EXECUTE s_commit_ts;
DEALLOCATE s_commit_ts;
COMMIT;

-- Test 17: query (CTE usage)
WITH committs AS (SELECT crdb_internal.show_commit_timestamp() AS ts)
SELECT * FROM committs;

-- Test 18: statement (cleanup)
DROP FUNCTION f_commit_ts();
DROP TABLE foo;

RESET client_min_messages;
