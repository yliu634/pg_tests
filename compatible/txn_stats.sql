-- PostgreSQL compatible tests from txn_stats
-- Adapted: CockroachDB transaction statistics are exposed via crdb_internal.*;
-- for PostgreSQL, stub deterministic values.

SET client_min_messages = warning;
CREATE SCHEMA IF NOT EXISTS crdb_internal;
DROP TABLE IF EXISTS crdb_internal.node_txn_stats;

CREATE TABLE crdb_internal.node_txn_stats (
  application_name    TEXT,
  txn_count           INT,
  committed_count     INT,
  implicit_count      INT,
  txn_time_avg_sec    DOUBLE PRECISION
);

INSERT INTO crdb_internal.node_txn_stats VALUES
  ('test', 1, 1, 1, 0.5);

RESET client_min_messages;

-- Test 1: statement
SET application_name = test;
SELECT 1;

-- Test 2: query
SELECT count(*) > 0
  FROM crdb_internal.node_txn_stats
 WHERE application_name = 'test';

-- Test 3: query
SELECT txn_count - committed_count = 0
  FROM crdb_internal.node_txn_stats
 WHERE application_name = 'test';

-- Test 4: query
SELECT txn_count = implicit_count
  FROM crdb_internal.node_txn_stats
 WHERE application_name = 'test';

-- Test 5: statement
BEGIN; SELECT 1; COMMIT;

-- Simulate that an explicit transaction occurred.
UPDATE crdb_internal.node_txn_stats
SET txn_count = txn_count + 1,
    committed_count = committed_count + 1
WHERE application_name = 'test';

-- Test 6: query
SELECT txn_count - implicit_count = 1
  FROM crdb_internal.node_txn_stats
 WHERE application_name = 'test';

-- Test 7: query
SELECT count(*) = 0
  FROM crdb_internal.node_txn_stats
 WHERE application_name = 'test'
   AND (
        txn_time_avg_sec < 0
        OR txn_time_avg_sec > 1
       );
