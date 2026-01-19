-- PostgreSQL compatible tests from tuple_local
-- 1 tests

-- Test 1: statement (line 8)
CREATE TABLE t93396 (c1 TIME PRIMARY KEY, c2 INT8);
INSERT INTO t93396 VALUES ('0:0:0'::TIME, 0);

