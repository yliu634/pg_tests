-- PostgreSQL compatible tests from rename_view
-- 41 tests

-- Test 1: statement (line 1)
SET CLUSTER SETTING sql.cross_db_views.enabled = TRUE

-- Test 2: statement (line 4)
ALTER VIEW foo RENAME TO bar

-- Test 3: statement (line 7)
ALTER VIEW IF EXISTS foo RENAME TO bar

-- Test 4: statement (line 10)
CREATE TABLE kv (
  k INT PRIMARY KEY,
  v INT
)

-- Test 5: statement (line 16)
INSERT INTO kv VALUES (1, 2), (3, 4)

-- Test 6: statement (line 19)
CREATE VIEW v as SELECT k,v FROM kv

-- Test 7: query (line 22)
SELECT * FROM v

-- Test 8: query (line 28)
SHOW TABLES

-- Test 9: statement (line 34)
ALTER VIEW kv RENAME TO new_kv

-- Test 10: statement (line 38)
ALTER TABLE v RENAME TO new_v

-- Test 11: statement (line 41)
SELECT * FROM v

-- Test 12: query (line 44)
SELECT * FROM new_v

-- Test 13: query (line 50)
SHOW TABLES

-- Test 14: query (line 57)
SHOW GRANTS ON new_v

-- Test 15: statement (line 63)
ALTER VIEW "" RENAME TO foo

-- Test 16: statement (line 66)
ALTER VIEW new_v RENAME TO ""

-- Test 17: statement (line 69)
ALTER VIEW new_v RENAME TO new_v

-- Test 18: statement (line 72)
CREATE TABLE t (
  c1 INT PRIMARY KEY,
  c2 INT
)

-- Test 19: statement (line 78)
INSERT INTO t VALUES (4, 16), (5, 25)

-- Test 20: statement (line 81)
CREATE VIEW v as SELECT c1,c2 from t

-- Test 21: statement (line 84)
ALTER VIEW v RENAME TO new_v

user testuser

-- Test 22: statement (line 89)
ALTER VIEW test.v RENAME TO v2

user root

-- Test 23: statement (line 94)
GRANT DROP ON test.v TO testuser

-- Test 24: statement (line 97)
create database test2

user testuser

-- Test 25: statement (line 102)
ALTER VIEW test.v RENAME TO v2

user root

-- Test 26: statement (line 107)
GRANT CREATE ON DATABASE test TO testuser

-- Test 27: statement (line 110)
ALTER VIEW test.v RENAME TO v2

-- Test 28: query (line 113)
SHOW TABLES FROM test

-- Test 29: statement (line 123)
ALTER VIEW test.v2 RENAME TO test2.v

user root

-- Test 30: statement (line 128)
GRANT CREATE ON DATABASE test2 TO testuser

-- Test 31: statement (line 131)
GRANT DROP ON test.new_v TO testuser

user testuser

-- Test 32: statement (line 136)
ALTER VIEW test.new_v RENAME TO test.v

-- Test 33: query (line 139)
SHOW TABLES FROM test

-- Test 34: query (line 147)
SHOW TABLES FROM test2

-- Test 35: query (line 153)
SELECT * FROM test.v

-- Test 36: query (line 159)
SELECT * FROM test.v2

-- Test 37: statement (line 165)
CREATE VIEW v3 AS SELECT count(*) FROM test.v AS v JOIN test.v2 AS v2 ON v.k > v2.c1

-- Test 38: statement (line 169)
ALTER VIEW test.v RENAME TO test.v3

-- Test 39: statement (line 176)
ALTER VIEW test.v2 RENAME TO v4

-- Test 40: statement (line 179)
ALTER VIEW v3 RENAME TO v4

-- Test 41: statement (line 182)
ALTER VIEW test.v2 RENAME TO v5

