-- PostgreSQL compatible tests from udf_deps
-- 76 tests

\set ON_ERROR_STOP 1
SET client_min_messages = warning;

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
);

-- Test 2: statement (line 20)
CREATE FUNCTION sel() RETURNS VOID LANGUAGE SQL BEGIN ATOMIC
  SELECT a, b, cascade_sel FROM t;
END;

-- skipif config local-legacy-schema-changer

-- Test 3: statement (line 26)
\set ON_ERROR_STOP 0
DROP TABLE t;
\set ON_ERROR_STOP 1

-- onlyif config local-legacy-schema-changer

-- Test 4: statement (line 30)
-- DROP TABLE t;

-- Test 5: statement (line 33)
ALTER TABLE t RENAME COLUMN c TO c2;

-- Test 6: statement (line 36)
ALTER TABLE t DROP COLUMN drop_sel;

-- Test 7: statement (line 39)
SELECT sel();

-- Test 8: statement (line 42)
ALTER TABLE t DROP COLUMN cascade_sel CASCADE;

-- Test 9: statement (line 45)
\set ON_ERROR_STOP 0
SELECT sel();
\set ON_ERROR_STOP 1

-- Test 10: statement (line 52)
CREATE FUNCTION ins() RETURNS VOID LANGUAGE SQL BEGIN ATOMIC
  INSERT INTO t VALUES (1, 10, DEFAULT);
END;

-- skipif config local-legacy-schema-changer

-- Test 11: statement (line 58)
\set ON_ERROR_STOP 0
DROP TABLE t;
\set ON_ERROR_STOP 1

-- onlyif config local-legacy-schema-changer

-- Test 12: statement (line 62)
-- DROP TABLE t;

-- Test 13: statement (line 67)
BEGIN;
ALTER TABLE t RENAME COLUMN b TO b2;
ROLLBACK;

-- Test 14: statement (line 70)
\set ON_ERROR_STOP 0
ALTER TABLE t DROP COLUMN b;
\set ON_ERROR_STOP 1

-- Test 15: statement (line 73)
\set ON_ERROR_STOP 0
ALTER TABLE t DROP COLUMN def;
\set ON_ERROR_STOP 1

-- Test 16: statement (line 76)
ALTER TABLE t RENAME COLUMN c2 TO c3;

-- Test 17: statement (line 79)
ALTER TABLE t DROP COLUMN drop_ins;

-- Test 18: statement (line 82)
SELECT ins();

-- Test 19: query (line 85)
SELECT a, b, def FROM t;

-- Test 20: statement (line 90)
DROP FUNCTION ins;

-- Test 21: statement (line 93)
CREATE FUNCTION ins2() RETURNS VOID LANGUAGE SQL BEGIN ATOMIC
  INSERT INTO t (a, b, cascade_ins2, def) VALUES (2, 20, 200, DEFAULT);
END;

-- skipif config local-legacy-schema-changer

-- Test 22: statement (line 99)
\set ON_ERROR_STOP 0
DROP TABLE t;
\set ON_ERROR_STOP 1

-- onlyif config local-legacy-schema-changer

-- Test 23: statement (line 103)
-- DROP TABLE t;

-- Test 24: statement (line 108)
BEGIN;
ALTER TABLE t RENAME COLUMN b TO b2;
ROLLBACK;

-- Test 25: statement (line 111)
\set ON_ERROR_STOP 0
ALTER TABLE t DROP COLUMN b;
\set ON_ERROR_STOP 1

-- Test 26: statement (line 114)
\set ON_ERROR_STOP 0
ALTER TABLE t DROP COLUMN def;
\set ON_ERROR_STOP 1

-- Test 27: statement (line 117)
ALTER TABLE t RENAME COLUMN c3 TO c4;

-- Test 28: statement (line 120)
ALTER TABLE t DROP COLUMN drop_ins2;

-- Test 29: statement (line 123)
SELECT ins2();

-- Test 30: query (line 126)
SELECT a, b, def FROM t;

-- Test 31: statement (line 132)
ALTER TABLE t DROP COLUMN cascade_ins2 CASCADE;

-- Test 32: statement (line 135)
\set ON_ERROR_STOP 0
SELECT ins2();
\set ON_ERROR_STOP 1

-- Test 33: statement (line 142)
CREATE FUNCTION ups() RETURNS VOID LANGUAGE SQL BEGIN ATOMIC
  INSERT INTO t (a, b, def) VALUES (3, 30, DEFAULT);
END;

-- skipif config local-legacy-schema-changer

-- Test 34: statement (line 148)
\set ON_ERROR_STOP 0
DROP TABLE t;
\set ON_ERROR_STOP 1

-- onlyif config local-legacy-schema-changer

-- Test 35: statement (line 152)
-- DROP TABLE t;

-- Test 36: statement (line 157)
BEGIN;
ALTER TABLE t RENAME COLUMN b TO b2;
ROLLBACK;

-- Test 37: statement (line 160)
\set ON_ERROR_STOP 0
ALTER TABLE t DROP COLUMN b;
\set ON_ERROR_STOP 1

-- Test 38: statement (line 163)
\set ON_ERROR_STOP 0
ALTER TABLE t DROP COLUMN def;
\set ON_ERROR_STOP 1

-- Test 39: statement (line 166)
ALTER TABLE t RENAME COLUMN c4 TO c5;

-- Test 40: statement (line 169)
ALTER TABLE t DROP COLUMN drop_ups;

-- Test 41: statement (line 172)
SELECT ups();

-- Test 42: query (line 175)
SELECT a, b, def FROM t;

-- Test 43: statement (line 182)
DROP FUNCTION ups;

-- Test 44: statement (line 185)
CREATE FUNCTION ups2() RETURNS VOID LANGUAGE SQL BEGIN ATOMIC
  INSERT INTO t (a, b, cascade_ups2, def) VALUES (4, 40, 400, DEFAULT);
END;

-- skipif config local-legacy-schema-changer

-- Test 45: statement (line 191)
\set ON_ERROR_STOP 0
DROP TABLE t;
\set ON_ERROR_STOP 1

-- onlyif config local-legacy-schema-changer

-- Test 46: statement (line 195)
-- DROP TABLE t;

-- Test 47: statement (line 200)
BEGIN;
ALTER TABLE t RENAME COLUMN b TO b2;
ROLLBACK;

-- Test 48: statement (line 203)
\set ON_ERROR_STOP 0
ALTER TABLE t DROP COLUMN b;
\set ON_ERROR_STOP 1

-- Test 49: statement (line 206)
\set ON_ERROR_STOP 0
ALTER TABLE t DROP COLUMN def;
\set ON_ERROR_STOP 1

-- Test 50: statement (line 209)
ALTER TABLE t RENAME COLUMN c5 TO c6;

-- Test 51: statement (line 212)
ALTER TABLE t DROP COLUMN drop_ups2;

-- Test 52: statement (line 215)
SELECT ups2();

-- Test 53: query (line 218)
SELECT a, b, def FROM t;

-- Test 54: statement (line 226)
ALTER TABLE t DROP COLUMN cascade_ups2 CASCADE;

-- Test 55: statement (line 229)
\set ON_ERROR_STOP 0
SELECT ups2();
\set ON_ERROR_STOP 1

-- Test 56: statement (line 236)
CREATE FUNCTION up() RETURNS VOID LANGUAGE SQL BEGIN ATOMIC
  UPDATE t SET b = 11 WHERE a = 1 AND cascade_up IS NULL;
END;

-- skipif config local-legacy-schema-changer

-- Test 57: statement (line 242)
\set ON_ERROR_STOP 0
DROP TABLE t;
\set ON_ERROR_STOP 1

-- onlyif config local-legacy-schema-changer

-- Test 58: statement (line 246)
-- DROP TABLE t;

-- Test 59: statement (line 249)
BEGIN;
ALTER TABLE t RENAME COLUMN a TO a2;
ROLLBACK;

-- Test 60: statement (line 256)
ALTER TABLE t RENAME COLUMN c6 TO c7;

-- Test 61: statement (line 259)
ALTER TABLE t DROP COLUMN drop_up;

-- Test 62: statement (line 262)
SELECT up();

-- Test 63: query (line 265)
SELECT a, b, def FROM t;

-- Test 64: statement (line 273)
ALTER TABLE t DROP COLUMN cascade_up CASCADE;

-- Test 65: statement (line 276)
\set ON_ERROR_STOP 0
SELECT up();
\set ON_ERROR_STOP 1

-- Test 66: statement (line 283)
CREATE FUNCTION del() RETURNS VOID LANGUAGE SQL BEGIN ATOMIC
  DELETE FROM t WHERE a = 1 AND cascade_del = 1;
END;

-- skipif config local-legacy-schema-changer

-- Test 67: statement (line 289)
\set ON_ERROR_STOP 0
DROP TABLE t;
\set ON_ERROR_STOP 1

-- onlyif config local-legacy-schema-changer

-- Test 68: statement (line 293)
-- DROP TABLE t;

-- Test 69: statement (line 296)
BEGIN;
ALTER TABLE t RENAME COLUMN a TO a2;
ROLLBACK;

-- Test 70: statement (line 299)
ALTER TABLE t RENAME COLUMN c7 TO c8;

-- Test 71: statement (line 302)
ALTER TABLE t DROP COLUMN drop_del;

-- Test 72: statement (line 305)
SELECT del();

-- Test 73: query (line 308)
SELECT a, b, def FROM t;

-- Test 74: statement (line 316)
ALTER TABLE t DROP COLUMN cascade_del CASCADE;

-- Test 75: statement (line 319)
\set ON_ERROR_STOP 0
SELECT del();
\set ON_ERROR_STOP 1

-- Test 76: statement (line 322)
DROP TABLE t;

RESET client_min_messages;
