SET client_min_messages = warning;

-- PostgreSQL compatible tests from merge_join
-- 17 tests

-- Test 1: statement (line 3)
DROP TABLE IF EXISTS t1 CASCADE;
CREATE TABLE t1 (k INT PRIMARY KEY, v INT);

-- Test 2: statement (line 6)
INSERT INTO t1 VALUES (-1, -1), (0, 4), (2, 1), (3, 4), (5, 4);

-- Test 3: statement (line 9)
DROP TABLE IF EXISTS t2 CASCADE;
CREATE TABLE t2 (x INT, y INT);
CREATE INDEX t2_x_idx ON t2 (x);

-- Test 4: statement (line 12)
INSERT INTO t2 VALUES (0, 5), (1, 3), (1, 4), (3, 2), (3, 3), (4, 6);

-- Test 5: query (line 15)
SELECT k, v, x, y FROM t1 INNER JOIN t2 ON k = x;

-- Test 6: statement (line 22)
DROP TABLE t1;

-- Test 7: statement (line 25)
DROP TABLE t2;

-- Test 8: statement (line 30)
DROP TABLE IF EXISTS t1 CASCADE;
CREATE TABLE t1 (k INT);
CREATE INDEX t1_k_idx ON t1 (k);

-- Test 9: statement (line 33)
INSERT INTO t1 VALUES (0), (null);

-- Test 10: statement (line 36)
DROP TABLE IF EXISTS t2 CASCADE;
CREATE TABLE t2 (x INT);
CREATE INDEX t2_x_idx ON t2 (x);

-- Test 11: statement (line 39)
INSERT INTO t2 VALUES (0), (null);

-- Test 12: query (line 42)
SELECT k, x FROM t1 INNER JOIN t2 ON k = x;

-- Test 13: statement (line 49)
DROP TABLE IF EXISTS t44798_0 CASCADE;
CREATE TABLE t44798_0(c0 INT4 PRIMARY KEY); CREATE TABLE t44798_1(c0 INT8 PRIMARY KEY);

-- Test 14: statement (line 52)
INSERT INTO t44798_0(c0) VALUES(0), (1), (2); INSERT INTO t44798_1(c0) VALUES(0), (2), (4);

-- Test 15: query (line 56)
SELECT * FROM t44798_0 NATURAL JOIN t44798_1;

-- Test 16: statement (line 64)
DROP TABLE IF EXISTS l CASCADE;
CREATE TABLE l (l INT PRIMARY KEY); INSERT INTO l VALUES (1), (2);
CREATE TABLE r (r INT PRIMARY KEY); INSERT INTO r VALUES (1);

-- Test 17: query (line 68)
SELECT *, true FROM (SELECT l FROM l WHERE l NOT IN (SELECT r FROM r));



RESET client_min_messages;