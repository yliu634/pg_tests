-- PostgreSQL compatible tests from index_join
-- 3 tests

SET client_min_messages = warning;
DROP TABLE IF EXISTS lineitem CASCADE;
RESET client_min_messages;

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
-- CockroachDB-specific. PostgreSQL has no "INJECT STATISTICS"; use ANALYZE.
ANALYZE lineitem;

-- Test 3: query (line 39)
SELECT sum(l_extendedprice)
FROM lineitem
WHERE l_shipdate >= DATE '1994-01-01'
  AND l_shipdate < DATE '1994-01-01' + INTERVAL '1' YEAR
  AND l_extendedprice < 100;
