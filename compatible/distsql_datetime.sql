-- PostgreSQL compatible tests from distsql_datetime
-- 1 tests

-- Test 1: statement (line 14)
SELECT t - (SELECT '0001-01-01 00:00:00'::TIMESTAMP - a::INTERVAL FROM ts ORDER BY a LIMIT 1) FROM ts

