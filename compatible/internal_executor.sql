-- PostgreSQL compatible tests from internal_executor
-- 3 tests

SET client_min_messages = warning;

DROP ROLE IF EXISTS ie_testuser;

-- Test 1: statement (line 13)
-- SET avoid_buffering = true; -- CockroachDB specific

-- Test 2: statement (line 16)
DROP TABLE IF EXISTS t;
CREATE TABLE t (i INT PRIMARY KEY);

-- Test 3: statement (line 19)
CREATE ROLE ie_testuser;
GRANT SELECT ON TABLE t TO ie_testuser;
SELECT has_table_privilege('ie_testuser', 't', 'SELECT');

DROP TABLE t;
DROP OWNED BY ie_testuser;
DROP ROLE ie_testuser;

RESET client_min_messages;
