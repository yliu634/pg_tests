-- PostgreSQL compatible tests from index_join
-- 3 tests

-- Test 1: statement (line 7)
CREATE TABLE lineitem
(
    l_orderkey int PRIMARY KEY,
    l_extendedprice float NOT NULL,
    l_shipdate date NOT NULL
);
CREATE INDEX l_sd ON lineitem (l_shipdate ASC);
INSERT INTO lineitem VALUES (1, 200, '1994-01-01');

-- Test 2: statement (line 17)
-- CockroachDB-only: ALTER TABLE ... INJECT STATISTICS '...'
-- PostgreSQL collects planner statistics via ANALYZE instead.
ANALYZE lineitem;

-- Test 3: query (line 39)
SELECT sum(l_extendedprice) FROM lineitem WHERE l_shipdate >= DATE '1994-01-01' AND l_shipdate < DATE '1994-01-01' + INTERVAL '1' YEAR AND l_extendedprice < 100;
