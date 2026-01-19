-- PostgreSQL compatible tests from index_join
-- 3 tests

-- Test 1: statement (line 7)
CREATE TABLE lineitem
(
    l_orderkey int PRIMARY KEY,
    l_extendedprice float NOT NULL,
    l_shipdate date NOT NULL,
    INDEX l_sd (l_shipdate ASC)
);
INSERT INTO lineitem VALUES (1, 200, '1994-01-01');

-- Test 2: statement (line 17)
ALTER TABLE lineitem INJECT STATISTICS '[
  {
    "columns": ["l_orderkey"],
    "created_at": "2018-01-01 1:00:00.00000+00:00",
    "row_count": 6001215,
    "distinct_count": 1500000
  },
  {
    "columns": ["l_extendedprice"],
    "created_at": "2018-01-01 1:00:00.00000+00:00",
    "row_count": 6001215,
    "distinct_count": 1000000
  },
  {
    "columns": ["l_shipdate"],
    "created_at": "2018-01-01 1:00:00.00000+00:00",
    "row_count": 6001215,
    "distinct_count": 2500
  }
]';

-- Test 3: query (line 39)
SELECT sum(l_extendedprice) FROM lineitem WHERE l_shipdate >= DATE '1994-01-01' AND l_shipdate < DATE '1994-01-01' + INTERVAL '1' YEAR AND l_extendedprice < 100

