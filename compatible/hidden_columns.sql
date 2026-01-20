-- PostgreSQL compatible tests from hidden_columns
-- 26 tests

-- Test 1: statement (line 1)
CREATE TABLE t (x INT NOT VISIBLE);

-- Test 2: statement (line 4)
CREATE TABLE kv (
    k INT PRIMARY KEY NOT VISIBLE,
    v INT NOT VISIBLE
  )

-- Test 3: statement (line 12)
INSERT INTO t(x) VALUES (123)

-- Test 4: statement (line 15)
INSERT INTO kv(k,v) VALUES (123,456);

-- Test 5: statement (line 20)
INSERT INTO t VALUES (123)

-- Test 6: statement (line 23)
INSERT INTO kv VALUES (111, 222)

-- Test 7: query (line 29)
SHOW CREATE TABLE t

-- Test 8: query (line 39)
SHOW CREATE TABLE t

-- Test 9: query (line 50)
SELECT 42, * FROM t

-- Test 10: query (line 55)
SELECT 42, * FROM kv

-- Test 11: query (line 62)
SELECT 42, x FROM t

-- Test 12: statement (line 69)
ALTER TABLE kv RENAME COLUMN v to x;

-- Test 13: query (line 72)
SELECT x FROM t

-- Test 14: statement (line 79)
CREATE INDEX ON kv(x);

-- Test 15: statement (line 84)
ALTER TABLE kv DROP COLUMN x;

-- Test 16: statement (line 87)
SELECT x FROM kv;

-- Test 17: statement (line 92)
CREATE TABLE t1(a INT, b INT, c INT NOT VISIBLE , PRIMARY KEY(b));
CREATE TABLE t2(b INT NOT VISIBLE, c INT, d INT, PRIMARY KEY (d));
CREATE TABLE t5(b INT NOT VISIBLE, c INT, d INT, PRIMARY KEY (d), FOREIGN KEY(b) REFERENCES t1(b));

-- Test 18: query (line 97)
SHOW CONSTRAINTS FROM t2

-- Test 19: statement (line 102)
ALTER TABLE t2 ADD FOREIGN KEY (b) REFERENCES t2

-- Test 20: query (line 105)
SELECT * FROM [SHOW CONSTRAINTS FROM t2] ORDER BY constraint_name

-- Test 21: statement (line 113)
CREATE TABLE t3(a INT, b INT NOT NULL, c INT NOT VISIBLE, PRIMARY KEY(c));
CREATE TABLE t4(c INT, d INT, e INT NOT NULL NOT VISIBLE, PRIMARY KEY(d));
CREATE TABLE t6(c INT, d INT, e INT NOT NULL NOT VISIBLE, PRIMARY KEY(d), FOREIGN KEY(c) REFERENCES t3(c));

-- Test 22: statement (line 120)
ALTER TABLE t3 ALTER PRIMARY KEY USING COLUMNS(b);

-- Test 23: query (line 123)
SELECT * FROM [SHOW CONSTRAINTS FROM t3] ORDER BY constraint_name

-- Test 24: query (line 129)
SHOW CONSTRAINTS FROM t4

-- Test 25: statement (line 134)
ALTER TABLE t4 ALTER PRIMARY KEY USING COLUMNS(e);

-- Test 26: query (line 137)
SELECT * FROM [SHOW CONSTRAINTS FROM t4] ORDER BY constraint_name

