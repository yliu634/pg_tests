-- PostgreSQL compatible tests from distsql_datetime
-- 1 tests

SET client_min_messages = warning;
DROP TABLE IF EXISTS ts;
RESET client_min_messages;

CREATE TABLE ts (a TEXT, t TIMESTAMP);
INSERT INTO ts VALUES ('1 hour', '2020-01-01 00:00:00'), ('2 hours', '2020-01-01 01:00:00');

-- Test 1: statement (line 14)
SELECT t - (SELECT '0001-01-01 00:00:00'::TIMESTAMP - a::INTERVAL FROM ts ORDER BY a LIMIT 1) FROM ts;
