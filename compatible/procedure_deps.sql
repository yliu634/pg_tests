-- PostgreSQL compatible tests from procedure_deps
-- 76 tests

-- Test 1: statement (line 1)
CREATE TABLE t (
  a INT PRIMARY KEY,
  b INT,
  def INT DEFAULT 10,
  c INT,
  drop_sel INT,  cascade_sel INT,
  drop_ins INT,
  drop_ins2 INT, cascade_ins2 INT,
  drop_ups INT,
  drop_ups2 INT, cascade_ups2 INT,
  drop_up INT,   cascade_up INT,
  drop_del INT,  cascade_del INT
)

-- Test 2: statement (line 20)
CREATE PROCEDURE sel() LANGUAGE SQL AS $$
  SELECT a, b, cascade_sel FROM t;
$$

skipif config local-legacy-schema-changer

-- Test 3: statement (line 26)
DROP TABLE t

onlyif config local-legacy-schema-changer

-- Test 4: statement (line 30)
DROP TABLE t

-- Test 5: statement (line 33)
ALTER TABLE t RENAME COLUMN c TO c2

-- Test 6: statement (line 36)
ALTER TABLE t DROP COLUMN drop_sel

-- Test 7: statement (line 39)
CALL sel()

-- Test 8: statement (line 42)
ALTER TABLE t DROP COLUMN cascade_sel CASCADE

-- Test 9: statement (line 45)
CALL sel()

-- Test 10: statement (line 52)
CREATE PROCEDURE ins() LANGUAGE SQL AS $$
  INSERT INTO t VALUES (1, 10, DEFAULT);
$$

skipif config local-legacy-schema-changer

-- Test 11: statement (line 58)
DROP TABLE t

onlyif config local-legacy-schema-changer

-- Test 12: statement (line 62)
DROP TABLE t

-- Test 13: statement (line 67)
ALTER TABLE t RENAME COLUMN b TO b2

-- Test 14: statement (line 70)
ALTER TABLE t DROP COLUMN b

-- Test 15: statement (line 73)
ALTER TABLE t DROP COLUMN def

-- Test 16: statement (line 76)
ALTER TABLE t RENAME COLUMN c2 TO c3

-- Test 17: statement (line 79)
ALTER TABLE t DROP COLUMN drop_ins

-- Test 18: statement (line 82)
CALL ins()

-- Test 19: query (line 85)
SELECT a, b, def FROM t

-- Test 20: statement (line 90)
DROP PROCEDURE ins

-- Test 21: statement (line 93)
CREATE PROCEDURE ins2() LANGUAGE SQL AS $$
  INSERT INTO t (a, b, cascade_ins2, def) VALUES (2, 20, 200, DEFAULT);
$$

skipif config local-legacy-schema-changer

-- Test 22: statement (line 99)
DROP TABLE t

onlyif config local-legacy-schema-changer

-- Test 23: statement (line 103)
DROP TABLE t

-- Test 24: statement (line 108)
ALTER TABLE t RENAME COLUMN b TO b2

-- Test 25: statement (line 111)
ALTER TABLE t DROP COLUMN b

-- Test 26: statement (line 114)
ALTER TABLE t DROP COLUMN def

-- Test 27: statement (line 117)
ALTER TABLE t RENAME COLUMN c3 TO c4

-- Test 28: statement (line 120)
ALTER TABLE t DROP COLUMN drop_ins2

-- Test 29: statement (line 123)
CALL ins2()

-- Test 30: query (line 126)
SELECT a, b, def FROM t

-- Test 31: statement (line 132)
ALTER TABLE t DROP COLUMN cascade_ins2 CASCADE

-- Test 32: statement (line 135)
CALL ins2()

-- Test 33: statement (line 142)
CREATE PROCEDURE ups() LANGUAGE SQL AS $$
  UPSERT INTO t VALUES (3, 30, DEFAULT);
$$

skipif config local-legacy-schema-changer

-- Test 34: statement (line 148)
DROP TABLE t

onlyif config local-legacy-schema-changer

-- Test 35: statement (line 152)
DROP TABLE t

-- Test 36: statement (line 157)
ALTER TABLE t RENAME COLUMN b TO b2

-- Test 37: statement (line 160)
ALTER TABLE t DROP COLUMN b

-- Test 38: statement (line 163)
ALTER TABLE t DROP COLUMN def

-- Test 39: statement (line 166)
ALTER TABLE t RENAME COLUMN c4 TO c5

-- Test 40: statement (line 169)
ALTER TABLE t DROP COLUMN drop_ups

-- Test 41: statement (line 172)
CALL ups()

-- Test 42: query (line 175)
SELECT a, b, def FROM t

-- Test 43: statement (line 182)
DROP PROCEDURE ups

-- Test 44: statement (line 185)
CREATE PROCEDURE ups2() LANGUAGE SQL AS $$
  UPSERT INTO t (a, b, cascade_ups2, def) VALUES (4, 40, 400, DEFAULT);
$$

skipif config local-legacy-schema-changer

-- Test 45: statement (line 191)
DROP TABLE t

onlyif config local-legacy-schema-changer

-- Test 46: statement (line 195)
DROP TABLE t

-- Test 47: statement (line 200)
ALTER TABLE t RENAME COLUMN b TO b2

-- Test 48: statement (line 203)
ALTER TABLE t DROP COLUMN b

-- Test 49: statement (line 206)
ALTER TABLE t DROP COLUMN def

-- Test 50: statement (line 209)
ALTER TABLE t RENAME COLUMN c5 TO c6

-- Test 51: statement (line 212)
ALTER TABLE t DROP COLUMN drop_ups2

-- Test 52: statement (line 215)
CALL ups2()

-- Test 53: query (line 218)
SELECT a, b, def FROM t

-- Test 54: statement (line 226)
ALTER TABLE t DROP COLUMN cascade_ups2 CASCADE

-- Test 55: statement (line 229)
CALL ups2()

-- Test 56: statement (line 236)
CREATE PROCEDURE up() LANGUAGE SQL AS $$
  UPDATE t SET b = 11 WHERE a = 1 AND cascade_up IS NULL
$$

skipif config local-legacy-schema-changer

-- Test 57: statement (line 242)
DROP TABLE t

onlyif config local-legacy-schema-changer

-- Test 58: statement (line 246)
DROP TABLE t

-- Test 59: statement (line 249)
ALTER TABLE t RENAME COLUMN a TO a2

-- Test 60: statement (line 256)
ALTER TABLE t RENAME COLUMN c6 TO c7

-- Test 61: statement (line 259)
ALTER TABLE t DROP COLUMN drop_up

-- Test 62: statement (line 262)
CALL up()

-- Test 63: query (line 265)
SELECT a, b, def FROM t

-- Test 64: statement (line 273)
ALTER TABLE t DROP COLUMN cascade_up CASCADE

-- Test 65: statement (line 276)
CALL up()

-- Test 66: statement (line 283)
CREATE PROCEDURE del() LANGUAGE SQL AS $$
  DELETE FROM t WHERE a = 1 AND cascade_del = 1
$$

skipif config local-legacy-schema-changer

-- Test 67: statement (line 289)
DROP TABLE t

onlyif config local-legacy-schema-changer

-- Test 68: statement (line 293)
DROP TABLE t

-- Test 69: statement (line 296)
ALTER TABLE t RENAME COLUMN a TO a2

-- Test 70: statement (line 299)
ALTER TABLE t RENAME COLUMN c7 TO c8

-- Test 71: statement (line 302)
ALTER TABLE t DROP COLUMN drop_del

-- Test 72: statement (line 305)
CALL del()

-- Test 73: query (line 308)
SELECT a, b, def FROM t

-- Test 74: statement (line 316)
ALTER TABLE t DROP COLUMN cascade_del CASCADE

-- Test 75: statement (line 319)
CALL del()

-- Test 76: statement (line 322)
DROP TABLE t

