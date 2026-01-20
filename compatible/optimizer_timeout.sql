SET client_min_messages = warning;

-- PostgreSQL compatible tests from optimizer_timeout
-- 4 tests
--
-- CockroachDB has optimizer timeout settings and schema features (inverted
-- indexes, virtual computed columns, etc) that do not translate directly to
-- PostgreSQL. This file exercises the closest PG-native mechanism: statement
-- timeout during planning/execution, using a moderately complex query.

-- Test 1: statement (line 2)
DROP TABLE IF EXISTS table1 CASCADE;
CREATE TABLE table1 (
  col1_0 INT,
  col1_2 INT,
  col1_3 INT NOT NULL,
  col1_4 INT NOT NULL,
  col1_6 TIMETZ NOT NULL,
  col1_7 UUID,
  col1_8 INT NOT NULL
);

INSERT INTO table1(col1_0, col1_2, col1_3, col1_4, col1_6, col1_7, col1_8) VALUES
  (1, 10, 1, 100, '00:00:00+00'::timetz, '00000000-0000-0000-0000-000000000001'::uuid, 1),
  (2, 20, 1, 200, '00:00:01+00'::timetz, '00000000-0000-0000-0000-000000000002'::uuid, 2),
  (3, 30, 2, 300, '00:00:02+00'::timetz, '00000000-0000-0000-0000-000000000003'::uuid, 3);

CREATE INDEX table1_col1_0_col1_2_idx ON table1(col1_0, col1_2);
CREATE INDEX table1_col1_3_idx ON table1(col1_3);

-- Test 2: statement (line 27)
SET statement_timeout = '0.1s';

-- Test 3: statement (line 30)
EXPLAIN (COSTS false)
SELECT t1.col1_4, t2.col1_8
FROM table1 AS t1
JOIN table1 AS t2 ON t1.col1_3 = t2.col1_3
WHERE t1.col1_4 >= 100
ORDER BY t1.col1_4, t2.col1_8;

-- Test 4: statement (line 56)
RESET statement_timeout;

RESET client_min_messages;
