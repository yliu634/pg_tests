-- PostgreSQL compatible tests from swap_mutation
-- 40 tests

-- Test 1: statement (line 3)
SET use_swap_mutations = on

-- Test 2: statement (line 8)
CREATE TABLE xyz (
  x INT PRIMARY KEY,
  y INT,
  z INT,
  UNIQUE INDEX (y),
  FAMILY (x, y, z)
)

-- Test 3: statement (line 17)
INSERT INTO xyz VALUES (1, 1, 1), (2, 2, 2)

-- Test 4: statement (line 22)
UPDATE xyz SET y = 1 WHERE x = 2 AND y = 2 AND z = 2

-- Test 5: query (line 25)
SELECT * FROM xyz ORDER BY x

-- Test 6: statement (line 33)
UPDATE xyz SET y = 1 WHERE x = 2 AND y = 2 AND z = 3

-- Test 7: query (line 36)
SELECT * FROM xyz ORDER BY x

-- Test 8: statement (line 44)
BEGIN

-- Test 9: statement (line 47)
UPDATE xyz SET z = 11 WHERE x = 1 AND y = 1 AND z = 1

-- Test 10: query (line 50)
SELECT * FROM xyz ORDER BY x

-- Test 11: statement (line 56)
SAVEPOINT a

-- Test 12: statement (line 59)
UPDATE xyz SET z = 12 WHERE x = 2 AND y = 2 AND z = 2

-- Test 13: query (line 62)
SELECT * FROM xyz ORDER BY x

-- Test 14: statement (line 68)
ROLLBACK TO a

-- Test 15: statement (line 71)
UPDATE xyz SET z = 21 WHERE x = 1 AND y = 1 AND z = 11

-- Test 16: query (line 74)
SELECT * FROM xyz ORDER BY x

-- Test 17: statement (line 80)
SAVEPOINT b

-- Test 18: statement (line 85)
UPDATE xyz SET z = 31 WHERE x = 1 AND y = 1 AND z = 11

-- Test 19: query (line 88)
SELECT * FROM xyz ORDER BY x

-- Test 20: statement (line 94)
ROLLBACK TO b

-- Test 21: query (line 97)
SELECT * FROM xyz ORDER BY x

-- Test 22: statement (line 103)
ROLLBACK TO a

-- Test 23: query (line 106)
SELECT * FROM xyz ORDER BY x

-- Test 24: statement (line 114)
UPDATE xyz SET z = 31 WHERE x = 1 AND y = 1 AND z = 21

-- Test 25: query (line 117)
SELECT * FROM xyz ORDER BY x

-- Test 26: statement (line 123)
COMMIT

-- Test 27: query (line 126)
SELECT * FROM xyz ORDER BY x

-- Test 28: statement (line 132)
CREATE TABLE mno (m INT PRIMARY KEY, n INT, o INT NOT NULL, UNIQUE INDEX (o), INDEX (n), FAMILY (m, n, o))

-- Test 29: statement (line 135)
INSERT INTO mno VALUES (3, 3, 3), (4, 4, 4)

-- Test 30: statement (line 138)
UPDATE mno SET o = 4 WHERE m = 3 AND n IS NOT DISTINCT FROM 3 AND o IS NOT DISTINCT FROM 3

-- Test 31: query (line 141)
SELECT * FROM mno ORDER BY m

-- Test 32: statement (line 150)
UPDATE mno SET o = 4 WHERE m = 3 AND n IS NOT DISTINCT FROM 4 AND o IS NOT DISTINCT FROM 3

-- Test 33: query (line 153)
SELECT * FROM mno ORDER BY m

-- Test 34: statement (line 159)
ALTER TABLE mno ADD COLUMN p INT

-- Test 35: statement (line 162)
ALTER TABLE mno DROP COLUMN p

-- Test 36: statement (line 165)
UPDATE mno SET o = 4 WHERE m = 3 AND n IS NOT DISTINCT FROM 3 AND o IS NOT DISTINCT FROM 3

-- Test 37: query (line 168)
SELECT * FROM mno ORDER BY m

-- Test 38: statement (line 178)
UPDATE mno SET o = 4 WHERE m = 3 AND n IS NOT DISTINCT FROM 4 AND o IS NOT DISTINCT FROM 3

-- Test 39: query (line 181)
SELECT * FROM mno ORDER BY m

-- Test 40: statement (line 187)
RESET use_swap_mutations

