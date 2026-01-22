-- PostgreSQL compatible tests from partitioning
-- 2 tests

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

-- Test 2: statement (line 11)
DROP TABLE IF EXISTS t CASCADE;
CREATE TABLE t (
    a INT,
    b INT,
    PRIMARY KEY (a, b)
) PARTITION BY LIST (b);

CREATE TABLE t_p1 PARTITION OF t FOR VALUES IN (1);
CREATE INDEX t_b_idx ON t (b);
