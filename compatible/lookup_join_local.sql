SET client_min_messages = warning;

-- PostgreSQL compatible tests from lookup_join_local
-- 3 tests

-- Create missing tables
DROP TABLE IF EXISTS large CASCADE;
CREATE TABLE large (n INT, v TEXT);

DROP TABLE IF EXISTS small CASCADE;
CREATE TABLE small (n INT);
INSERT INTO small VALUES (0), (1), (2), (3), (4), (5), (6);

-- Test 1: statement (line 11)
-- COMMENTED: CockroachDB-specific setting: SET distsql_workmem = '8MiB';

-- Test 2: statement (line 24)
INSERT INTO large SELECT g % 7, repeat('a', 52) FROM generate_series(0, 69999) as g;

-- Test 3: query (line 30)
SELECT small.n, sum(length(large.v)) FROM small
INNER JOIN large ON small.n = large.n
GROUP BY small.n
ORDER BY small.n;

RESET client_min_messages;
