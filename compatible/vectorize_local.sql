-- PostgreSQL compatible tests from vectorize_local
-- 2 tests

-- Test 1: statement (line 5)
CREATE TABLE t111474_0 (c0 INT);
CREATE TABLE t111474_1 (c0 INT);
INSERT INTO t111474_0 (c0) VALUES (1);

-- Test 2: query (line 13)
SELECT * FROM t111474_0, t111474_1 WHERE chr(-1) > '';

