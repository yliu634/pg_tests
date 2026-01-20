SET client_min_messages = warning;

-- PostgreSQL compatible tests from partitioning
-- 2 tests
--
-- CockroachDB and PostgreSQL both support table partitioning but with different
-- DDL syntax. This file exercises PostgreSQL LIST partitioning.

-- Test 1: statement (line 5)
DROP TABLE IF EXISTS t CASCADE;
CREATE TABLE t (
  a INT,
  b INT,
  c INT,
  PRIMARY KEY (a, b)
) PARTITION BY LIST (a);

CREATE TABLE t_p1 PARTITION OF t FOR VALUES IN (1);
CREATE TABLE t_p2 PARTITION OF t FOR VALUES IN (2);

-- Test 2: query (line 11)
INSERT INTO t VALUES (1, 10, 100), (2, 20, 200);
SELECT * FROM t ORDER BY a, b;

RESET client_min_messages;

