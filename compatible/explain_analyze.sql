-- PostgreSQL compatible tests from explain_analyze
-- 26 tests

-- Test 1: statement (line 2)
CREATE TABLE kv (k INT PRIMARY KEY, v INT, FAMILY (k, v));
INSERT INTO kv VALUES (1,10), (2,20), (3,30), (4,40);
CREATE TABLE ab (a INT PRIMARY KEY, b INT);
INSERT INTO ab VALUES (10,100), (40,400), (50,500);

-- Test 2: statement (line 10)
EXPLAIN ANALYZE (DISTSQL) CREATE TABLE a (a INT PRIMARY KEY)

-- Test 3: statement (line 13)
EXPLAIN ANALYZE (DISTSQL) CREATE INDEX ON a(a)

-- Test 4: statement (line 16)
EXPLAIN ANALYZE (DISTSQL) INSERT INTO a VALUES (1)

-- Test 5: statement (line 20)
EXPLAIN ANALYZE (DISTSQL) INSERT INTO a VALUES (1)

-- Test 6: statement (line 26)
EXPLAIN ANALYZE (DISTSQL) INSERT INTO a SELECT a+1 FROM a

-- Test 7: statement (line 29)
EXPLAIN ANALYZE (DISTSQL) UPDATE a SET a = a*3

-- Test 8: statement (line 32)
EXPLAIN ANALYZE (DISTSQL) UPDATE a SET a = a*3 RETURNING a

-- Test 9: statement (line 35)
EXPLAIN ANALYZE (DISTSQL) UPSERT INTO a VALUES(10)

-- Test 10: statement (line 38)
EXPLAIN ANALYZE (DISTSQL) SELECT (SELECT 1);

-- Test 11: statement (line 41)
EXPLAIN ANALYZE (DISTSQL) DELETE FROM a

-- Test 12: statement (line 44)
EXPLAIN ANALYZE (DISTSQL) DROP TABLE a

-- Test 13: statement (line 47)
EXPLAIN ANALYZE (PLAN) CREATE TABLE a (a INT PRIMARY KEY)

-- Test 14: statement (line 50)
EXPLAIN ANALYZE (PLAN) CREATE INDEX ON a(a)

-- Test 15: statement (line 53)
EXPLAIN ANALYZE (PLAN) INSERT INTO a VALUES (1)

-- Test 16: statement (line 57)
EXPLAIN ANALYZE (PLAN) INSERT INTO a VALUES (1)

-- Test 17: statement (line 63)
EXPLAIN ANALYZE (PLAN) INSERT INTO a SELECT a+1 FROM a

-- Test 18: statement (line 66)
EXPLAIN ANALYZE (PLAN) UPDATE a SET a = a*3

-- Test 19: statement (line 69)
EXPLAIN ANALYZE (PLAN) UPDATE a SET a = a*3 RETURNING a

-- Test 20: statement (line 72)
EXPLAIN ANALYZE (PLAN) UPSERT INTO a VALUES(10)

-- Test 21: statement (line 75)
EXPLAIN ANALYZE (PLAN) SELECT (SELECT 1);

-- Test 22: statement (line 78)
EXPLAIN ANALYZE (PLAN) DELETE FROM a

-- Test 23: statement (line 81)
EXPLAIN ANALYZE (PLAN) DROP TABLE a

-- Test 24: statement (line 85)
CREATE TABLE a (a INT PRIMARY KEY)

-- Test 25: statement (line 88)
EXPLAIN ANALYZE (DISTSQL) DELETE FROM a WHERE true

-- Test 26: statement (line 92)
CREATE TABLE p (p INT8 PRIMARY KEY);
CREATE TABLE c (c INT8 PRIMARY KEY, p INT8 REFERENCES p (p))

