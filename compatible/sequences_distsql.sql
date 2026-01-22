-- PostgreSQL compatible tests from sequences_distsql
-- 8 tests

-- Test 1: statement (line 3)
CREATE TABLE t (c int PRIMARY KEY);

-- Test 2: statement (line 6)
INSERT INTO t VALUES (1);

-- Test 3: statement (line 9)
CREATE SEQUENCE distsql_test START WITH 10;

-- Establish sequence state in this session to avoid lastval() errors.
-- Test 4: query (line 12)
SELECT nextval('distsql_test');

-- Test 5: query (line 15)
SELECT lastval();

-- Test 6: query (line 18)
SELECT c, lastval() FROM t;

-- Test 7: query (line 21)
SELECT nextval('distsql_test');

-- Test 8: query (line 26)
SELECT c, currval('distsql_test') FROM t;
