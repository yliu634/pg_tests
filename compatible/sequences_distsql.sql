-- PostgreSQL compatible tests from sequences_distsql
-- 8 tests

-- Test 1: statement (line 3)
CREATE TABLE t (c int PRIMARY KEY);

-- Test 2: statement (line 6)
INSERT INTO t VALUES (1);

-- Test 3: statement (line 9)
CREATE SEQUENCE distsql_test START WITH 10;

-- Test 4: statement (line 12)
\set ON_ERROR_STOP 0
SELECT lastval();

-- Test 5: statement (line 18)
SELECT c, lastval() from t;
\set ON_ERROR_STOP 1

-- Test 6: query (line 21)
SELECT nextval('distsql_test');

-- Test 7: query (line 26)
SELECT c, lastval() FROM t;

-- Test 8: query (line 31)
SELECT c, currval('distsql_test') FROM t;
