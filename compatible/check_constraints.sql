-- PostgreSQL compatible tests from check_constraints
-- 108 tests

-- Helper: run a statement that is expected to error without emitting psql ERROR output.
CREATE OR REPLACE PROCEDURE pg_temp.expect_error(sql text)
LANGUAGE plpgsql
AS $$
DECLARE
  stmt text;
BEGIN
  stmt := regexp_replace(sql, ';[[:space:]]*$', '');
  EXECUTE stmt;
  RAISE NOTICE 'expected failure did not occur';
EXCEPTION WHEN OTHERS THEN
  RAISE NOTICE 'expected failure: %', SQLERRM;
END;
$$;

-- Test 1: statement (line 3)
CREATE TABLE t1 (a INT CHECK (a > 0), to_delete INT, b INT CHECK (b < 0) CHECK (b > -100));

-- Test 2: statement (line 6)
-- Expected ERROR: invalid input syntax for type integer: "3.3".
CALL pg_temp.expect_error($sql$INSERT INTO t1 VALUES ('3.3', 0, -1);$sql$);

-- Test 3: statement (line 9)
INSERT INTO t1 VALUES ('3', 0, -1);

-- Test 4: statement (line 12)
INSERT INTO t1 VALUES (3, 0, -1);

-- Test 5: statement (line 15)
ALTER TABLE t1 DROP COLUMN to_delete;

-- Test 6: statement (line 18)
INSERT INTO t1 (a, b) VALUES (4, -2);

-- Test 7: statement (line 21)
-- Expected ERROR: violates CHECK (a > 0).
CALL pg_temp.expect_error($sql$INSERT INTO t1 VALUES (-3, -1);$sql$);

-- Test 8: statement (line 24)
-- Expected ERROR: violates CHECK (b < 0).
CALL pg_temp.expect_error($sql$INSERT INTO t1 VALUES (3, 1);$sql$);

-- Test 9: statement (line 27)
-- Expected ERROR: violates CHECK (b > -100).
CALL pg_temp.expect_error($sql$INSERT INTO t1 VALUES (3, -101);$sql$);

-- Test 10: statement (line 30)
INSERT INTO t1 (b, a) VALUES (-2, 4);

-- Test 11: statement (line 33)
INSERT INTO t1 (a) VALUES (10);

-- Test 12: statement (line 36)
INSERT INTO t1 (b) VALUES (-1);

-- Test 13: statement (line 39)
CREATE TABLE t2 (a INT DEFAULT -1 CHECK (a >= 0), b INT CHECK (b <= 0), CHECK (b < a));

-- Test 14: statement (line 42)
-- Expected ERROR: violates CHECK (a >= 0) via default a = -1.
CALL pg_temp.expect_error($sql$INSERT INTO t2 (b) VALUES (-2);$sql$);

-- Test 15: statement (line 47)
ALTER TABLE t2 RENAME COLUMN b TO c;

-- Test 16: statement (line 50)
-- Expected ERROR: violates CHECK (c <= 0).
CALL pg_temp.expect_error($sql$INSERT INTO t2 (a, c) VALUES (2, 1);$sql$);

-- Test 17: statement (line 53)
-- Expected ERROR: violates CHECK (c < a).
CALL pg_temp.expect_error($sql$INSERT INTO t2 (a, c) VALUES (0, 0);$sql$);

-- Test 18: statement (line 56)
INSERT INTO t2 (a, c) VALUES (2, -1);

-- Test 19: statement (line 59)
CREATE TABLE t3 (a INT, b INT CHECK (b < a));

-- Test 20: statement (line 62)
INSERT INTO t3 (a, b) VALUES (3, 2);

-- Test 21: statement (line 65)
-- Expected ERROR: violates CHECK (b < a).
CALL pg_temp.expect_error($sql$INSERT INTO t3 (a, b) VALUES (2, 3);$sql$);

-- Test 22: statement (line 69)
-- Expected ERROR: aggregate functions are not allowed in check constraints.
CALL pg_temp.expect_error($sql$CREATE TABLE t4 (a INT, b INT CHECK (count(*) = 1));$sql$);

-- Test 23: statement (line 73)
-- Expected ERROR: subqueries are not allowed in check constraints.
CALL pg_temp.expect_error($sql$CREATE TABLE t4 (a INT, b INT CHECK (EXISTS (SELECT * FROM t2)));$sql$);

-- Test 24: statement (line 77)
-- Expected ERROR: CHECK constraint expression must be boolean.
CALL pg_temp.expect_error($sql$CREATE TABLE t4 (a INT CHECK(1));$sql$);

-- Test 25: statement (line 80)
-- Expected ERROR: CHECK constraint expression must be boolean.
CALL pg_temp.expect_error($sql$CREATE TABLE t4 (a INT CHECK(a));$sql$);

-- Test 26: statement (line 84)
CREATE TABLE calls_func (a INT CHECK(abs(a) < 2));

-- Test 27: statement (line 87)
INSERT INTO calls_func VALUES (1), (-1);

-- Test 28: statement (line 90)
-- Expected ERROR: violates CHECK (abs(a) < 2).
CALL pg_temp.expect_error($sql$INSERT INTO calls_func VALUES (-5);$sql$);

-- Test 29: statement (line 94)
-- Expected ERROR: aggregate functions are not allowed in check constraints.
CALL pg_temp.expect_error($sql$CREATE TABLE bad (a INT CHECK(sum(a) > 1));$sql$);

-- Test 30: statement (line 98)
-- Expected ERROR: window functions are not allowed in check constraints.
CALL pg_temp.expect_error($sql$CREATE TABLE bad (a INT CHECK(sum(a) OVER () > 1));$sql$);

-- Test 31: statement (line 102)
-- Expected ERROR: CHECK constraint expression must be boolean.
CALL pg_temp.expect_error($sql$CREATE TABLE t4 (a INT CHECK (false - true));$sql$);

-- Test 32: statement (line 105)
-- Expected ERROR: referenced columns do not exist.
CALL pg_temp.expect_error($sql$CREATE TABLE t4 (a INT, CHECK (a < b), CHECK (a+b+c+d < 20));$sql$);

-- Test 33: statement (line 108)
CREATE TABLE t4 (
  a INT, b INT DEFAULT 5, c INT, d INT,
  CHECK (a < b),
  CONSTRAINT "all" CHECK (a+b+c+d < 20)
);

-- Test 34: statement (line 116)
INSERT INTO t4 (a, b) VALUES (2, 3);

-- Test 35: statement (line 119)
-- Expected ERROR: violates CHECK (a < b) with default b = 5.
CALL pg_temp.expect_error($sql$INSERT INTO t4 (a) VALUES (6);$sql$);

-- Test 36: statement (line 122)
INSERT INTO t4 VALUES (1, 2, 3, 4);

-- Test 37: statement (line 125)
INSERT INTO t4 VALUES (NULL, 2, 22, NULL);

-- Test 38: statement (line 128)
-- Expected ERROR: violates CHECK (a+b+c+d < 20).
CALL pg_temp.expect_error($sql$INSERT INTO t4 VALUES (1, 2, 3, 19);$sql$);

-- Test 39: query (line 131)
SELECT * from t3;

-- Test 40: statement (line 137)
-- Expected ERROR: violates CHECK (b < a).
CALL pg_temp.expect_error($sql$UPDATE t3 SET b = 3 WHERE a = 3;$sql$);

-- onlyif config #112488 weak-iso-level-configs

-- Test 41: statement (line 141)
-- Expected ERROR: violates CHECK (b < a).
CALL pg_temp.expect_error($sql$UPDATE t3 SET b = 3 WHERE a = 3;$sql$);

-- skipif config #112488 weak-iso-level-configs

-- Test 42: statement (line 145)
UPDATE t3 SET b = 1 WHERE a = 3;

-- Test 43: statement (line 148)
-- Expected ERROR: violates CHECK (a < b).
CALL pg_temp.expect_error($sql$UPDATE t4 SET a = 2 WHERE c = 3;$sql$);

-- Test 44: statement (line 151)
UPDATE t4 SET a = 0 WHERE c = 3;

-- Test 45: statement (line 154)
CREATE TABLE t5 (
  k INT PRIMARY KEY,
  a INT,
  b int CHECK (a > b)
);

-- Test 46: statement (line 162)
-- Expected ERROR: violates CHECK (a > b).
CALL pg_temp.expect_error($sql$INSERT INTO t5 VALUES (1, 10, 20) ON CONFLICT (k) DO NOTHING;$sql$);

-- Test 47: statement (line 165)
INSERT INTO t5 VALUES (1, 10, 9) ON CONFLICT (k) DO NOTHING;

-- Test 48: statement (line 169)
-- Expected ERROR: violates CHECK (a > b).
CALL pg_temp.expect_error($sql$INSERT INTO t5 VALUES (1, 10, 20) ON CONFLICT (k) DO NOTHING;$sql$);

-- Test 49: statement (line 174)
-- Expected ERROR: violates CHECK (a > b).
CALL pg_temp.expect_error($sql$INSERT INTO t5 VALUES (2, 11, 12) ON CONFLICT (k) DO UPDATE SET b = 12 WHERE t5.k = 2;$sql$);

-- Test 50: statement (line 177)
-- Expected ERROR: violates CHECK (a > b).
CALL pg_temp.expect_error($sql$
INSERT INTO t5 VALUES (2, 11, 12)
  ON CONFLICT (k) DO UPDATE SET a = EXCLUDED.a, b = EXCLUDED.b;
$sql$);

-- Test 51: statement (line 180)
INSERT INTO t5 VALUES (2, 11, 10)
  ON CONFLICT (k) DO UPDATE SET a = EXCLUDED.a, b = EXCLUDED.b;

-- Test 52: query (line 183)
SELECT * FROM t5;

-- Test 53: statement (line 189)
INSERT INTO t5 VALUES (2, 11, 9)
  ON CONFLICT (k) DO UPDATE SET a = EXCLUDED.a, b = EXCLUDED.b;

-- Test 54: query (line 192)
SELECT * FROM t5;

-- Test 55: statement (line 198)
-- Expected ERROR: violates CHECK (a > b).
CALL pg_temp.expect_error($sql$INSERT INTO t5 VALUES (2, 11, 12) ON CONFLICT (k) DO UPDATE SET b = 12 WHERE t5.k = 2;$sql$);

-- Test 56: statement (line 201)
-- Expected ERROR: violates CHECK (a > b).
CALL pg_temp.expect_error($sql$
INSERT INTO t5 VALUES (2, 11, 12)
  ON CONFLICT (k) DO UPDATE SET a = EXCLUDED.a, b = EXCLUDED.b;
$sql$);

-- Test 57: statement (line 204)
-- Expected ERROR: violates CHECK (a > b).
CALL pg_temp.expect_error($sql$INSERT INTO t5 VALUES (2, 11, 12) ON CONFLICT (k) DO UPDATE SET b = t5.a + 1 WHERE t5.k = 2;$sql$);

-- Test 58: query (line 207)
SELECT * FROM t5;

-- Test 59: statement (line 213)
-- Expected ERROR: subqueries are not allowed in check constraints.
CALL pg_temp.expect_error($sql$CREATE TABLE t6 (x INT CHECK (x = (SELECT 1)));$sql$);

-- Test 60: statement (line 218)
CREATE TABLE t7 (
  x INT,
  y INT,
  z INT,
  CHECK (x > 0),
  CHECK (x + y > 0),
  CHECK (y + z > 0),
  CHECK (y + z = 0),
  CONSTRAINT named_constraint CHECK (z = 1)
  -- CockroachDB column families are not supported in PostgreSQL.
);

-- onlyif config schema-locked-disabled

-- Test 61: query (line 232)
SELECT conname, pg_get_constraintdef(oid) AS condef
FROM pg_constraint
WHERE conrelid = 't7'::regclass
  AND contype = 'c'
ORDER BY conname;

-- Test 62: query (line 249)
SELECT conname, pg_get_constraintdef(oid) AS condef
FROM pg_constraint
WHERE conrelid = 't7'::regclass
  AND contype = 'c'
ORDER BY conname;

-- Test 63: query (line 266)
SELECT conname, pg_get_constraintdef(oid) AS condef
FROM pg_constraint
WHERE conrelid = 't7'::regclass
  AND contype = 'c'
ORDER BY conname;

-- Test 64: query (line 283)
SELECT conname, pg_get_constraintdef(oid) AS condef
FROM pg_constraint
WHERE conrelid = 't7'::regclass
  AND contype = 'c'
ORDER BY conname;

-- Test 65: statement (line 301)
-- Expected ERROR: check constraints cannot reference other relations.
CALL pg_temp.expect_error($sql$
CREATE TABLE t8 (
  a INT,
  CHECK (different_table.a > 0)
);
$sql$);

-- Test 66: statement (line 307)
-- Expected ERROR: check constraints cannot reference other schemas/relations.
CALL pg_temp.expect_error($sql$
CREATE TABLE t8 (
  a INT,
  CHECK (different_database.t8.a > 0)
);
$sql$);

-- Test 67: statement (line 313)
CREATE SCHEMA IF NOT EXISTS test;
CREATE TABLE test.t8 (
  a INT,
  CHECK (a > 0),
  CHECK (t8.a > 0),
  CHECK (test.t8.a > 0)
);

-- onlyif config schema-locked-disabled

-- Test 68: query (line 322)
SELECT conname, pg_get_constraintdef(oid) AS condef
FROM pg_constraint
WHERE conrelid = 'test.t8'::regclass
  AND contype = 'c'
ORDER BY conname;

-- Test 69: query (line 335)
SELECT conname, pg_get_constraintdef(oid) AS condef
FROM pg_constraint
WHERE conrelid = 'test.t8'::regclass
  AND contype = 'c'
ORDER BY conname;

-- Test 70: statement (line 347)
CREATE SCHEMA test2;

-- Test 71: statement (line 350)
CREATE TABLE test2.t (
  a INT,
  CHECK (a > 0),
  CHECK (t.a > 0),
  CHECK (test2.t.a > 0)
);

-- Test 72: statement (line 360)
CREATE TABLE t9 (
  a INT PRIMARY KEY,
  b INT,
  c INT,
  d INT,
  e INT,
  CHECK (a > b),
  CHECK (d IS NULL)
);

-- Test 73: statement (line 375)
INSERT INTO t9 VALUES (5, 3);

-- Test 74: statement (line 378)
-- Expected ERROR: violates CHECK (a > b).
CALL pg_temp.expect_error($sql$INSERT INTO t9 VALUES (6, 7);$sql$);

-- skipif config #112488 weak-iso-level-configs

-- Test 75: statement (line 382)
UPDATE t9 SET b = 4 WHERE a = 5;

-- skipif config #112488 weak-iso-level-configs

-- Test 76: statement (line 386)
-- Expected ERROR: violates CHECK (a > b).
CALL pg_temp.expect_error($sql$UPDATE t9 SET b = 6 WHERE a = 5;$sql$);

-- skipif config #112488 weak-iso-level-configs

-- Test 77: statement (line 390)
UPDATE t9 SET a = 7 WHERE a = 4;

-- skipif config #112488 weak-iso-level-configs

-- Test 78: statement (line 394)
-- Expected ERROR: violates CHECK (a > b).
CALL pg_temp.expect_error($sql$UPDATE t9 SET a = 2 WHERE a = 5;$sql$);

-- onlyif config #112488 weak-iso-level-configs

-- Test 79: statement (line 398)
UPDATE t9 SET b = 4 WHERE a = 5;

-- Test 80: statement (line 403)
CREATE TABLE t10 (
  a INT,
  b INT GENERATED ALWAYS AS (a - 1) STORED,
  CHECK (b > 0)
);

-- Test 81: statement (line 410)
INSERT INTO t10 VALUES (2);

-- Test 82: statement (line 413)
INSERT INTO t10 VALUES (2);

-- Test 83: statement (line 416)
INSERT INTO t10 VALUES (3);

-- Test 84: statement (line 419)
INSERT INTO t10 VALUES (3);

-- Test 85: statement (line 422)
UPDATE t10 SET a = 4;

-- Test 86: statement (line 425)
UPDATE t10 SET a = 3;

-- Test 87: statement (line 430)
CREATE TABLE t36293 (x bool);

-- Test 88: statement (line 433)
ALTER TABLE t36293
  ADD COLUMN y INT
  CHECK (
    CASE
    WHEN false
    THEN x
    ELSE false
    END
  );

-- Test 89: statement (line 445)
CREATE TABLE t46675isnull (k int, a int, CHECK ((k, a) IS NULL));

-- Test 90: statement (line 449)
INSERT INTO t46675isnull VALUES (NULL, NULL);

-- Test 91: statement (line 452)
CREATE TABLE t46675isnotnull (k int, a int, CHECK ((k, a) IS NOT NULL));

-- Test 92: statement (line 457)
-- Expected ERROR: violates CHECK ((k, a) IS NOT NULL).
CALL pg_temp.expect_error($sql$INSERT INTO t46675isnotnull VALUES (1, NULL);$sql$);

-- Test 93: statement (line 462)
CREATE TABLE t51690(x INT, y INT, CHECK(x / y = 1));

-- Test 94: statement (line 465)
INSERT INTO t51690 VALUES (1, 1);

-- Test 95: statement (line 471)
CREATE TABLE t67100a (a INT, CHECK (false));
CREATE TABLE t67100b (a INT, CHECK (true AND 0 > 1));

-- Test 96: statement (line 475)
INSERT INTO t67100a SELECT 1 WHERE false;

-- Test 97: statement (line 478)
INSERT INTO t67100a SELECT 1 WHERE false;

-- Test 98: statement (line 481)
INSERT INTO t67100b SELECT 1 WHERE false;

-- Test 99: statement (line 484)
INSERT INTO t67100b SELECT 1 WHERE false;

-- Test 100: statement (line 489)
CREATE TABLE t_91697(a OID);

-- Test 101: statement (line 492)
ALTER TABLE t_91697 ADD CHECK (a < 123);

-- Test 102: statement (line 495)
INSERT INTO t_91697 VALUES (42);

-- Test 103: statement (line 502)
CREATE TABLE t158154 (a INT, b INT, CONSTRAINT foo CHECK (b > 0));

-- Test 104: statement (line 505)
CREATE PROCEDURE p158154() LANGUAGE SQL AS $$
  INSERT INTO t158154 (a) VALUES (1);
  UPDATE t158154 SET a = a + 1;
$$;

-- Test 105: statement (line 511)
CALL p158154();

-- Test 106: statement (line 516)
ALTER TABLE t158154 DROP CONSTRAINT foo, DROP COLUMN b;

-- Test 107: statement (line 519)
CALL p158154();

-- Test 108: statement (line 522)
DROP PROCEDURE p158154;
DROP TABLE t158154;
