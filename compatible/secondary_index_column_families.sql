-- PostgreSQL compatible tests from secondary_index_column_families
-- 22 tests

-- Test 1: statement (line 2)
CREATE TABLE t (
  x INT PRIMARY KEY,
  y INT,
  z INT,
  w INT,
  INDEX i (y) STORING (z, w),
  FAMILY (x), FAMILY (y), FAMILY (z), FAMILY (w)
);
INSERT INTO t VALUES (1, 2, 3, 4);
UPDATE t SET z = NULL, w = NULL WHERE y = 2

-- Test 2: query (line 14)
SELECT y, z, w FROM t@i WHERE y = 2

-- Test 3: statement (line 20)
DROP TABLE IF EXISTS t;

-- Test 4: query (line 34)
SELECT y, z, v FROM t@i

-- Test 5: statement (line 40)
INSERT INTO t VALUES (10, 2, '10', 10) ON CONFLICT (y) DO UPDATE set x = 20, z = '20', v = 20 WHERE t.y = 2

-- Test 6: query (line 43)
SELECT y, z, v FROM t@i

-- Test 7: statement (line 50)
DROP TABLE IF EXISTS t;

-- Test 8: statement (line 63)
INSERT INTO t VALUES (1, '2', 3.0, 4), (5, '6', 7.00, 8);
UPSERT INTO t VALUES (9, '10', 11.000, 12), (1, '3', 5.0, 16)

-- Test 9: query (line 67)
SELECT y, z, w FROM t@i

-- Test 10: statement (line 75)
DROP TABLE IF EXISTS t;

-- Test 11: statement (line 78)
CREATE TABLE t (
  x INT PRIMARY KEY,
  y DECIMAL,
  z INT,
  w INT,
  v INT
);

-- Test 12: statement (line 87)
INSERT INTO t VALUES (1, 2, 3, 4, 5), (6, 7, 8, 9, 10), (11, 12, 13, 14, 15);

-- Test 13: statement (line 90)
CREATE INDEX i ON t (y) STORING (z, w, v)

-- Test 14: query (line 93)
SELECT y, z, w, v FROM t@i

-- Test 15: statement (line 100)
DROP INDEX t@i

-- Test 16: query (line 103)
SELECT * FROM t

-- Test 17: statement (line 110)
ALTER TABLE t ADD COLUMN u INT DEFAULT (20) CREATE FAMILY new_fam;

-- Test 18: statement (line 113)
CREATE INDEX i ON t (y) STORING (z, w, v, u)

-- Test 19: query (line 116)
SELECT y, z, w, v, u FROM t@i

-- Test 20: statement (line 124)
CREATE TABLE t42992 (x TIMESTAMP PRIMARY KEY, y INT, z INT, UNIQUE INDEX i (y) STORING (z), FAMILY (x), FAMILY (y), FAMILY (z))

-- Test 21: statement (line 127)
INSERT INTO t42992 VALUES (now(), NULL, 2)

-- Test 22: query (line 130)
SELECT y, z FROM t42992@i

