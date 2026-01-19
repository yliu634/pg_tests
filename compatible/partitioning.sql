-- PostgreSQL compatible tests from partitioning
-- 2 tests

-- Test 1: statement (line 5)
CREATE TABLE t (a INT, b INT, c INT, PRIMARY KEY (a, b)) PARTITION BY LIST (a) (
    PARTITION p1 VALUES IN (1),
    PARTITION p2 VALUES IN (2)
)

-- Test 2: statement (line 11)
CREATE TABLE t (
    a INT PRIMARY KEY, b INT,
    INDEX (b) PARTITION BY LIST (b) (
        PARTITION p1 VALUES IN (1)
    )
)

