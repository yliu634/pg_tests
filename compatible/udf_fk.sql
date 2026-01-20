-- PostgreSQL compatible tests from udf_fk
-- 169 tests

-- Test 1: statement (line 5)
SET enable_insert_fast_path = $enable_insert_fast_path

-- Test 2: statement (line 8)
CREATE TABLE parent (p INT PRIMARY KEY);

-- Test 3: statement (line 11)
CREATE TABLE child (c INT PRIMARY KEY, p INT NOT NULL REFERENCES parent(p));

-- Test 4: statement (line 17)
CREATE FUNCTION f_fk_c(k INT, r INT) RETURNS RECORD AS $$
  INSERT INTO child VALUES (k,r) RETURNING *;
$$ LANGUAGE SQL;

-- Test 5: statement (line 22)
CREATE FUNCTION f_fk_p(r INT) RETURNS RECORD AS $$
  INSERT INTO parent VALUES (r) RETURNING *;
$$ LANGUAGE SQL;

-- Test 6: statement (line 27)
CREATE FUNCTION f_fk_c_p(k INT, r INT) RETURNS RECORD AS $$
  INSERT INTO child VALUES (k,r);
  INSERT INTO parent VALUES (r) RETURNING *;
$$ LANGUAGE SQL;

-- Test 7: statement (line 33)
CREATE FUNCTION f_fk_p_c(k INT, r INT) RETURNS RECORD AS $$
  INSERT INTO parent VALUES (r);
  INSERT INTO child VALUES (k, r) RETURNING *;
$$ LANGUAGE SQL;

-- Test 8: statement (line 39)
SELECT f_fk_c(100, 1);

-- Test 9: statement (line 42)
SELECT f_fk_c_p(100, 1);

-- Test 10: query (line 45)
SELECT f_fk_p_c(100, 1);

-- Test 11: statement (line 50)
WITH x AS (SELECT f_fk_c(101, 2)) INSERT INTO parent VALUES (2);

-- Test 12: query (line 53)
WITH x AS (INSERT INTO parent VALUES (2) RETURNING p) SELECT f_fk_c(101, 2);

-- Test 13: statement (line 58)
ALTER TABLE parent SET (schema_locked=false)

-- Test 14: statement (line 61)
ALTER TABLE child SET (schema_locked=false)

-- Test 15: statement (line 64)
TRUNCATE parent CASCADE

-- Test 16: statement (line 67)
ALTER TABLE parent RESET (schema_locked)

-- Test 17: statement (line 70)
ALTER TABLE child RESET (schema_locked)

-- Test 18: statement (line 73)
INSERT INTO parent (p) VALUES (1);

-- Test 19: statement (line 76)
CREATE FUNCTION f_fk_c_multi(k1 INT, r1 INT, k2 INT, r2 INT) RETURNS SETOF RECORD AS $$
  INSERT INTO child VALUES (k1,r1);
  INSERT INTO child VALUES (k2,r2);
  SELECT * FROM child WHERE c = k1 OR c = k2;
$$ LANGUAGE SQL;

-- Test 20: statement (line 83)
SELECT f_fk_c_multi(101, 1, 102, 2);

-- Test 21: statement (line 86)
SELECT f_fk_c_multi(101, 2, 102, 1);

-- Test 22: query (line 89)
SELECT f_fk_c_multi(101, 1, 102, 1);

-- Test 23: statement (line 96)
CREATE SEQUENCE s;

-- Test 24: statement (line 99)
CREATE FUNCTION f_fk_c_seq_first(k INT, r INT) RETURNS RECORD AS $$
  SELECT nextval('s');
  INSERT INTO child VALUES (k,r) RETURNING *;
$$ LANGUAGE SQL;

-- Test 25: statement (line 105)
CREATE FUNCTION f_fk_c_seq_last(k INT, r INT) RETURNS RECORD AS $$
  INSERT INTO child VALUES (k,r) RETURNING *;
  SELECT nextval('s');
$$ LANGUAGE SQL;

-- Test 26: statement (line 111)
SELECT f_fk_c_seq_last(103,2);

-- Test 27: statement (line 114)
SELECT currval('s');

-- Test 28: statement (line 117)
SELECT f_fk_c_seq_first(103,2);

-- Test 29: query (line 120)
SELECT currval('s');

-- Test 30: statement (line 130)
ALTER TABLE parent SET (schema_locked=false)

-- Test 31: statement (line 133)
ALTER TABLE child SET (schema_locked=false)

-- Test 32: statement (line 136)
TRUNCATE parent CASCADE

-- Test 33: statement (line 139)
ALTER TABLE parent RESET (schema_locked)

-- Test 34: statement (line 142)
ALTER TABLE child RESET (schema_locked)

-- Test 35: statement (line 145)
INSERT INTO parent (p) VALUES (1), (2), (3), (4);

-- Test 36: statement (line 148)
INSERT INTO child (c, p) VALUES (100, 1), (101, 2), (102, 3);

-- Test 37: query (line 151)
SELECT * FROM parent

-- Test 38: query (line 159)
SELECT * FROM child

-- Test 39: statement (line 166)
CREATE FUNCTION f_fk_c_del(k INT) RETURNS RECORD AS $$
  DELETE FROM child WHERE c = k RETURNING *;
$$ LANGUAGE SQL;

-- Test 40: statement (line 171)
CREATE FUNCTION f_fk_p_del(r INT) RETURNS RECORD AS $$
  DELETE FROM parent WHERE p = r RETURNING *;
$$ LANGUAGE SQL;

-- Test 41: statement (line 176)
CREATE FUNCTION f_fk_c_p_del(k INT, r INT) RETURNS RECORD AS $$
  DELETE FROM child WHERE c = k RETURNING *;
  DELETE FROM parent WHERE p = r RETURNING *;
$$ LANGUAGE SQL;

-- Test 42: statement (line 182)
CREATE FUNCTION f_fk_p_c_del(k INT, r INT) RETURNS RECORD AS $$
  DELETE FROM parent WHERE p = r RETURNING *;
  DELETE FROM child WHERE c = k RETURNING *;
$$ LANGUAGE SQL;

-- Test 43: query (line 188)
SELECT f_fk_p_del(4);

-- Test 44: statement (line 193)
SELECT f_fk_p_del(3);

-- Test 45: query (line 196)
SELECT f_fk_c_del(102);

-- Test 46: query (line 201)
SELECT f_fk_p_del(3);

-- Test 47: statement (line 206)
SELECT f_fk_p_c_del(101,2);

-- Test 48: query (line 209)
SELECT f_fk_c_p_del(101,2);

-- Test 49: query (line 214)
SELECT f_fk_c_del(100), f_fk_p_del(1);

-- Test 50: query (line 219)
SELECT * FROM parent

-- Test 51: query (line 223)
SELECT * FROM child

-- Test 52: statement (line 231)
ALTER TABLE child SET (schema_locked=false)

-- Test 53: statement (line 234)
ALTER TABLE parent SET (schema_locked=false)

-- Test 54: statement (line 237)
TRUNCATE parent CASCADE

-- Test 55: statement (line 240)
ALTER TABLE child RESET (schema_locked)

-- Test 56: statement (line 243)
ALTER TABLE parent RESET (schema_locked)

-- Test 57: statement (line 246)
CREATE FUNCTION f_fk_c_ocdu(k INT, r INT) RETURNS RECORD AS $$
  INSERT INTO child VALUES (k, r) ON CONFLICT (c) DO UPDATE SET p = r RETURNING *;
$$ LANGUAGE SQL;

-- Test 58: statement (line 251)
INSERT INTO parent VALUES (1), (3);

-- Test 59: query (line 255)
SELECT f_fk_c_ocdu(100,1);

-- Test 60: statement (line 261)
SELECT f_fk_c_ocdu(100,2);

-- Test 61: statement (line 265)
SELECT f_fk_c_ocdu(101,2);

-- Test 62: statement (line 268)
CREATE FUNCTION f_fk_c_ups(k INT, r INT) RETURNS RECORD AS $$
  UPSERT INTO child VALUES (k, r) RETURNING *;
$$ LANGUAGE SQL;

-- Test 63: query (line 273)
SELECT f_fk_c_ups(102,3);

-- Test 64: statement (line 278)
SELECT f_fk_c_ups(102,4);

-- Test 65: statement (line 281)
SELECT f_fk_c_ups(103,4);

-- Test 66: statement (line 288)
CREATE TABLE parent_cascade (p INT PRIMARY KEY);

-- Test 67: statement (line 291)
CREATE TABLE child_cascade (
  c INT PRIMARY KEY,
  p INT NOT NULL REFERENCES parent_cascade(p) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Test 68: statement (line 297)
CREATE FUNCTION f_fk_p_cascade(old INT, new INT) RETURNS RECORD AS $$
  UPDATE parent_cascade SET p = new WHERE p = old RETURNING *;
$$ LANGUAGE SQL;

-- Test 69: statement (line 302)
INSERT INTO parent_cascade VALUES (1);

-- Test 70: statement (line 305)
INSERT INTO child_cascade VALUES (100,1);

-- Test 71: query (line 309)
SELECT f_fk_p_cascade(1, 2);

-- Test 72: query (line 314)
SELECT * FROM child_cascade;

-- Test 73: statement (line 319)
INSERT INTO child_cascade VALUES (101,2), (102,2);

-- Test 74: query (line 323)
SELECT f_fk_p_cascade(2, 3);

-- Test 75: query (line 328)
SELECT * FROM child_cascade;

-- Test 76: query (line 336)
SELECT f_fk_p_cascade(3, 4), f_fk_p_cascade(4, 2);

-- Test 77: query (line 341)
SELECT * FROM child_cascade;

-- Test 78: statement (line 348)
DROP TABLE child_cascade;

-- Test 79: statement (line 353)
CREATE TABLE child_cascade (
  c INT PRIMARY KEY,
  p INT UNIQUE NOT NULL REFERENCES parent_cascade(p) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Test 80: statement (line 359)
CREATE TABLE grandchild_cascade (
  c INT PRIMARY KEY,
  p INT NOT NULL REFERENCES child_cascade(p) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Test 81: statement (line 365)
INSERT INTO child_cascade VALUES (100,2);

-- Test 82: statement (line 368)
INSERT INTO grandchild_cascade VALUES (1000,2);

-- Test 83: query (line 372)
SELECT f_fk_p_cascade(2, 3);

-- Test 84: query (line 377)
SELECT * FROM child_cascade;

-- Test 85: query (line 382)
SELECT * FROM grandchild_cascade;

-- Test 86: statement (line 387)
CREATE OR REPLACE FUNCTION f_fk_c(k INT, r INT) RETURNS RECORD AS $$
  INSERT INTO child_cascade VALUES (k,r) RETURNING *;
$$ LANGUAGE SQL;

-- Test 87: statement (line 393)
SELECT f_fk_p_cascade(3, 4), f_fk_c(10, 100);

-- Test 88: query (line 396)
SELECT * FROM child_cascade;

-- Test 89: query (line 401)
SELECT * FROM grandchild_cascade;

-- Test 90: statement (line 406)
CREATE FUNCTION f_fk_p_del_cascade(old INT) RETURNS RECORD AS $$
  DELETE FROM parent_cascade WHERE p = old RETURNING *;
$$ LANGUAGE SQL;

-- Test 91: query (line 412)
SELECT f_fk_p_del_cascade(3);

-- Test 92: query (line 417)
SELECT * FROM child_cascade;

-- Test 93: query (line 421)
SELECT * FROM grandchild_cascade;

-- Test 94: statement (line 425)
INSERT INTO parent_cascade VALUES (1), (2);

-- Test 95: statement (line 428)
INSERT INTO child_cascade VALUES (1, 1), (2, 2);

-- Test 96: statement (line 431)
INSERT INTO grandchild_cascade VALUES (11, 1), (12, 2);

-- Test 97: query (line 435)
SELECT f_fk_p_cascade(1, 3), f_fk_p_cascade(2, 4);

-- Test 98: query (line 440)
SELECT * FROM child_cascade;

-- Test 99: query (line 446)
SELECT * FROM grandchild_cascade;

-- Test 100: query (line 453)
SELECT f_fk_p_cascade(3, 5), f_fk_p_del_cascade(4), f_fk_p_del_cascade(5);

-- Test 101: query (line 458)
SELECT * FROM parent_cascade;

-- Test 102: query (line 462)
SELECT * FROM child_cascade;

-- Test 103: query (line 466)
SELECT * FROM grandchild_cascade;

-- Test 104: statement (line 470)
DROP TABLE grandchild_cascade;

-- Test 105: statement (line 473)
DROP TABLE child_cascade CASCADE;

-- Test 106: statement (line 476)
CREATE TABLE child_cascade (
  c INT PRIMARY KEY,
  p INT REFERENCES parent_cascade(p) ON DELETE SET NULL ON UPDATE SET NULL
);

-- Test 107: statement (line 482)
INSERT INTO parent_cascade VALUES (3);

-- Test 108: statement (line 485)
INSERT INTO child_cascade VALUES (100,3);

-- Test 109: query (line 489)
SELECT f_fk_p_cascade(3, 4);

-- Test 110: query (line 494)
SELECT * FROM child_cascade;

-- Test 111: statement (line 499)
INSERT INTO child_cascade VALUES(101, 4);

-- Test 112: query (line 503)
SELECT f_fk_p_del_cascade(4);

-- Test 113: query (line 508)
SELECT * FROM child_cascade;

-- Test 114: query (line 514)
SELECT * FROM parent_cascade;

-- Test 115: statement (line 518)
DROP TABLE child_cascade

-- Test 116: statement (line 526)
CREATE TABLE IF NOT EXISTS parent_cascade (p INT PRIMARY KEY);

-- Test 117: statement (line 529)
CREATE TABLE child_cascade (
  c INT PRIMARY KEY,
  p INT UNIQUE NOT NULL REFERENCES parent_cascade(p) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Test 118: statement (line 535)
CREATE TABLE grandchild_cascade (
  c INT PRIMARY KEY,
  p INT NOT NULL REFERENCES child_cascade(p) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Test 119: statement (line 541)
CREATE OR REPLACE FUNCTION f_fk_p_cascade(old INT, new INT) RETURNS RECORD AS $$
  UPDATE parent_cascade SET p = new WHERE p = old RETURNING *;
$$ LANGUAGE SQL;

-- Test 120: statement (line 546)
INSERT INTO parent_cascade VALUES (1), (2), (3);

-- Test 121: statement (line 549)
INSERT INTO child_cascade VALUES (1, 1), (2, 2), (3, 3);

-- Test 122: statement (line 552)
INSERT INTO grandchild_cascade VALUES (11, 1), (12, 2), (13, 3);

-- Test 123: query (line 555)
SELECT
  (SELECT * FROM (VALUES ((SELECT x FROM (VALUES (1)) AS s (x)) + y))),
  f_fk_p_cascade(y, y+10)
FROM
  (VALUES (1), (2), (3)) AS t (y)

-- Test 124: query (line 566)
SELECT * FROM child_cascade

-- Test 125: query (line 573)
SELECT * FROM grandchild_cascade

-- Test 126: statement (line 581)
CREATE OR REPLACE FUNCTION f_fk_swap(a INT, b INT) RETURNS RECORD AS $$
  UPDATE parent_cascade SET p = a+1 WHERE p = b RETURNING *;
  UPDATE parent_cascade SET p = b WHERE p = a RETURNING *;
  UPDATE parent_cascade SET p = a WHERE p = a+1 RETURNING *;
$$ LANGUAGE SQL;

-- Test 127: query (line 588)
SELECT f_fk_swap(13, 12);

-- Test 128: query (line 593)
SELECT * FROM grandchild_cascade

-- Test 129: statement (line 600)
CREATE TABLE grandchild(
  c INT PRIMARY KEY,
  p INT NOT NULL REFERENCES child_cascade(p)
);

-- Test 130: statement (line 606)
INSERT INTO grandchild VALUES (11,11), (12,13), (13,12);

-- Test 131: statement (line 609)
SELECT f_fk_p_cascade(13, 14)

-- Test 132: statement (line 612)
SELECT f_fk_swap(13, 12);

-- Test 133: statement (line 615)
CREATE TABLE selfref (a INT PRIMARY KEY, b INT NOT NULL REFERENCES selfref(a) ON UPDATE CASCADE)

-- Test 134: statement (line 618)
INSERT INTO selfref VALUES (1,1);

-- Test 135: statement (line 621)
CREATE FUNCTION f_selfref(old INT, new INT) RETURNS RECORD AS $$
  UPDATE selfref SET a = new WHERE a = old RETURNING *;
$$ LANGUAGE SQL;

-- Test 136: query (line 627)
SELECT f_selfref(1,2);

-- Test 137: query (line 632)
SELECT * FROM selfref;

-- Test 138: statement (line 642)
DROP TABLE IF EXISTS parent CASCADE;

-- Test 139: statement (line 645)
DROP TABLE IF EXISTS child CASCADE;

-- Test 140: statement (line 648)
DROP TABLE IF EXISTS grandchild CASCADE;

-- Test 141: statement (line 651)
CREATE TABLE parent (j INT PRIMARY KEY);

-- Test 142: statement (line 654)
CREATE TABLE child (i INT PRIMARY KEY, j INT REFERENCES parent (j) ON UPDATE CASCADE ON DELETE CASCADE, INDEX (j));

-- Test 143: statement (line 657)
INSERT INTO parent VALUES (0), (2), (4);

-- Test 144: statement (line 660)
INSERT INTO child VALUES (0, 0);

-- Test 145: statement (line 663)
CREATE OR REPLACE FUNCTION f(k INT) RETURNS INT AS $$
  UPDATE parent SET j = j + 1 WHERE j = k RETURNING j
$$ LANGUAGE SQL;

-- Test 146: statement (line 669)
WITH x AS (SELECT f(0) AS j), y AS (UPDATE child SET j = 2 WHERE i = 0 RETURNING j) SELECT * FROM x;

-- Test 147: query (line 672)
SELECT i, j FROM child@primary;

-- Test 148: query (line 677)
SELECT i, j FROM child@child_j_idx;

-- Test 149: statement (line 682)
CREATE FUNCTION f2(old INT, new INT) RETURNS INT AS $$
  UPDATE child SET j = new WHERE i = old RETURNING i
$$ LANGUAGE SQL;

-- Test 150: statement (line 691)
UPDATE parent SET j = j + 1 WHERE j = f2(0, 2);

-- Test 151: query (line 694)
SELECT i, j FROM child@primary;

-- Test 152: query (line 699)
SELECT i, j FROM child@child_j_idx;

-- Test 153: statement (line 704)
DROP TABLE IF EXISTS child CASCADE;

-- Test 154: statement (line 708)
ALTER TABLE parent SET (schema_locked=false)

-- Test 155: statement (line 711)
TRUNCATE TABLE parent;

-- Test 156: statement (line 714)
ALTER TABLE parent RESET (schema_locked)

-- Test 157: statement (line 717)
CREATE TABLE child (i INT PRIMARY KEY, j INT UNIQUE REFERENCES parent (j) ON UPDATE CASCADE ON DELETE CASCADE, INDEX (j));

-- Test 158: statement (line 720)
CREATE TABLE grandchild (i INT PRIMARY KEY, j INT REFERENCES child (j) ON UPDATE CASCADE ON DELETE CASCADE, INDEX (j));

-- Test 159: statement (line 723)
INSERT INTO parent VALUES (0), (2), (4);

-- Test 160: statement (line 726)
INSERT INTO child VALUES (0, 0);

-- Test 161: statement (line 729)
INSERT INTO grandchild VALUES (0,0)

-- Test 162: statement (line 733)
WITH x AS (SELECT f(0) AS j), y AS (UPDATE grandchild SET j = 2 WHERE i = 0 RETURNING j) SELECT * FROM x;

-- Test 163: statement (line 736)
DROP TABLE IF EXISTS child CASCADE;

-- Test 164: statement (line 739)
DROP TABLE IF EXISTS grandchild CASCADE;

-- Test 165: statement (line 742)
CREATE TABLE child (i INT PRIMARY KEY, j INT UNIQUE REFERENCES parent (j), k INT UNIQUE REFERENCES parent (j) ON UPDATE RESTRICT, INDEX (j));

-- Test 166: statement (line 745)
INSERT INTO child VALUES (0,4)

-- Test 167: statement (line 749)
WITH x AS (SELECT f(0) AS j), y AS (UPDATE child SET j = 2, k = 2 WHERE i = 0 RETURNING j) SELECT * FROM x;

-- Test 168: query (line 752)
SELECT i, j FROM child@primary;

-- Test 169: query (line 757)
SELECT i, j FROM child@child_j_idx;

