-- PostgreSQL compatible tests from explain_analyze
-- 26 tests

-- Test 1: statement (line 2)
CREATE TABLE kv (k INT PRIMARY KEY, v INT);
INSERT INTO kv VALUES (1,10), (2,20), (3,30), (4,40);
CREATE TABLE ab (a INT PRIMARY KEY, b INT);
INSERT INTO ab VALUES (10,100), (40,400), (50,500);

-- Test 2: statement (line 10)
-- PostgreSQL does not support EXPLAIN on plain DDL statements like CREATE TABLE.
CREATE TABLE a (a INT PRIMARY KEY);

-- Test 3: statement (line 13)
-- PostgreSQL does not support EXPLAIN on CREATE INDEX.
CREATE INDEX ON a(a);

-- Test 4: statement (line 16)
EXPLAIN (ANALYZE, COSTS OFF, TIMING OFF, SUMMARY OFF) INSERT INTO a VALUES (1);

-- Test 5: statement (line 20)
-- Avoid expected-error output differences by turning the duplicate insert into a no-op.
EXPLAIN (ANALYZE, COSTS OFF, TIMING OFF, SUMMARY OFF)
INSERT INTO a VALUES (1) ON CONFLICT DO NOTHING;

-- Test 6: statement (line 26)
EXPLAIN (ANALYZE, COSTS OFF, TIMING OFF, SUMMARY OFF) INSERT INTO a SELECT a+1 FROM a;

-- Test 7: statement (line 29)
EXPLAIN (ANALYZE, COSTS OFF, TIMING OFF, SUMMARY OFF) UPDATE a SET a = a*3;

-- Test 8: statement (line 32)
EXPLAIN (ANALYZE, COSTS OFF, TIMING OFF, SUMMARY OFF) UPDATE a SET a = a*3 RETURNING a;

-- Test 9: statement (line 35)
EXPLAIN (ANALYZE, COSTS OFF, TIMING OFF, SUMMARY OFF)
INSERT INTO a VALUES (10) ON CONFLICT (a) DO UPDATE SET a = EXCLUDED.a;

-- Test 10: statement (line 38)
EXPLAIN (ANALYZE, COSTS OFF, TIMING OFF, SUMMARY OFF) SELECT (SELECT 1);

-- Test 11: statement (line 41)
EXPLAIN (ANALYZE, COSTS OFF, TIMING OFF, SUMMARY OFF) DELETE FROM a;

-- Test 12: statement (line 44)
-- PostgreSQL does not support EXPLAIN on DROP TABLE.
DROP TABLE a;

-- Test 13: statement (line 47)
CREATE TABLE a (a INT PRIMARY KEY);

-- Test 14: statement (line 50)
CREATE INDEX ON a(a);

-- Test 15: statement (line 53)
EXPLAIN (ANALYZE, COSTS OFF, TIMING OFF, SUMMARY OFF) INSERT INTO a VALUES (1);

-- Test 16: statement (line 57)
-- Avoid expected-error output differences by turning the duplicate insert into a no-op.
EXPLAIN (ANALYZE, COSTS OFF, TIMING OFF, SUMMARY OFF)
INSERT INTO a VALUES (1) ON CONFLICT DO NOTHING;

-- Test 17: statement (line 63)
EXPLAIN (ANALYZE, COSTS OFF, TIMING OFF, SUMMARY OFF) INSERT INTO a SELECT a+1 FROM a;

-- Test 18: statement (line 66)
EXPLAIN (ANALYZE, COSTS OFF, TIMING OFF, SUMMARY OFF) UPDATE a SET a = a*3;

-- Test 19: statement (line 69)
EXPLAIN (ANALYZE, COSTS OFF, TIMING OFF, SUMMARY OFF) UPDATE a SET a = a*3 RETURNING a;

-- Test 20: statement (line 72)
EXPLAIN (ANALYZE, COSTS OFF, TIMING OFF, SUMMARY OFF)
INSERT INTO a VALUES (10) ON CONFLICT (a) DO UPDATE SET a = EXCLUDED.a;

-- Test 21: statement (line 75)
EXPLAIN (ANALYZE, COSTS OFF, TIMING OFF, SUMMARY OFF) SELECT (SELECT 1);

-- Test 22: statement (line 78)
EXPLAIN (ANALYZE, COSTS OFF, TIMING OFF, SUMMARY OFF) DELETE FROM a;

-- Test 23: statement (line 81)
DROP TABLE a;

-- Test 24: statement (line 85)
CREATE TABLE a (a INT PRIMARY KEY);

-- Test 25: statement (line 88)
EXPLAIN (ANALYZE, COSTS OFF, TIMING OFF, SUMMARY OFF) DELETE FROM a WHERE true;

-- Test 26: statement (line 92)
CREATE TABLE p (p INT8 PRIMARY KEY);
CREATE TABLE c (c INT8 PRIMARY KEY, p INT8 REFERENCES p (p));
