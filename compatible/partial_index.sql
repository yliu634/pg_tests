SET client_min_messages = warning;

-- PostgreSQL compatible tests from partial_index
-- 128 tests
--
-- CockroachDB and PostgreSQL both support partial indexes, but CockroachDB also
-- supports additional syntax and optimizer controls not present in PostgreSQL.
-- This PG-adapted version exercises basic partial index behavior.

-- Test 1: statement
DROP TABLE IF EXISTS t_partial CASCADE;
CREATE TABLE t_partial (
  a INT,
  b INT,
  c INT
);

INSERT INTO t_partial(a, b, c) VALUES
  (1, NULL, 10),
  (2,  20, 20),
  (3,  30, 30),
  (4, NULL, 40),
  (5,  50, 50);

-- Test 2: statement
CREATE INDEX t_partial_a_notnull_b_idx ON t_partial(a) WHERE b IS NOT NULL;
CREATE INDEX t_partial_c_big_idx ON t_partial(c) WHERE c >= 30;

-- Test 3: query
SELECT a FROM t_partial WHERE b IS NOT NULL ORDER BY a;

-- Test 4: query
SELECT c FROM t_partial WHERE c >= 30 ORDER BY c;

-- Test 5: statement
EXPLAIN (COSTS false) SELECT a FROM t_partial WHERE b IS NOT NULL ORDER BY a;

-- Test 6: statement
EXPLAIN (COSTS false) SELECT c FROM t_partial WHERE c >= 30 ORDER BY c;

RESET client_min_messages;

