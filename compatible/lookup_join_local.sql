-- PostgreSQL compatible tests from lookup_join_local
-- 3 tests

-- Test 1: statement (line 11)
SET distsql_workmem = '8MiB';

-- Test 2: statement (line 24)
INSERT INTO large SELECT g % 7, repeat('a', 52) FROM generate_series(0, 69999) as g;

-- Test 3: query (line 30)
SELECT small.n, sum_int(length(large.v)) FROM small
INNER LOOKUP JOIN large ON small.n = large.n
GROUP BY small.n
ORDER BY small.n

