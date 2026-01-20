-- PostgreSQL compatible tests from cascade
-- 481 tests

-- Test 1: statement (line 5)
CREATE TABLE parent (p INT PRIMARY KEY);

-- Test 2: statement (line 8)
CREATE TABLE child (
  c INT PRIMARY KEY,
  p INT NOT NULL REFERENCES parent(p) ON DELETE CASCADE
);

-- Test 3: statement (line 14)
INSERT INTO parent VALUES (1), (2);
INSERT INTO child VALUES (1, 1), (2, 2), (10, 1), (20, 2);

-- Test 4: query (line 18)
SELECT * FROM child

-- Test 5: statement (line 26)
DELETE FROM parent WHERE p >= 2

-- Test 6: query (line 29)
SELECT * FROM child

-- Test 7: statement (line 35)
DELETE FROM parent WHERE p <= 2

-- Test 8: query (line 38)
SELECT * FROM child

-- Test 9: statement (line 43)
CREATE TABLE grandchild (
  g INT PRIMARY KEY,
  c INT REFERENCES child(c)
);

-- Test 10: statement (line 49)
INSERT INTO parent VALUES (1), (2);

-- Test 11: statement (line 52)
INSERT INTO child VALUES (10, 1), (11, 1), (20, 2), (21, 2);

-- Test 12: statement (line 55)
INSERT INTO grandchild VALUES (100, 10), (101, 10), (110, 11);

-- Test 13: statement (line 58)
DELETE FROM parent WHERE p = 2

-- Test 14: statement (line 61)
DELETE FROM parent WHERE p = 1

-- Test 15: statement (line 64)
DELETE FROM grandchild WHERE c = 10

-- Test 16: statement (line 67)
DELETE FROM parent WHERE p = 1

-- Test 17: statement (line 70)
DELETE FROM grandchild WHERE c = 11

-- Test 18: statement (line 73)
DELETE FROM parent WHERE p = 1

-- Test 19: statement (line 76)
DROP TABLE grandchild

-- Test 20: statement (line 80)
CREATE TABLE grandchild (
  g INT PRIMARY KEY,
  c INT REFERENCES child(c) ON DELETE CASCADE
);

-- Test 21: statement (line 86)
INSERT INTO parent VALUES (1), (2);

-- Test 22: statement (line 89)
INSERT INTO child VALUES (10, 1), (11, 1), (20, 2), (21, 2);

-- Test 23: statement (line 92)
INSERT INTO grandchild VALUES (100, 10), (101, 10), (110, 11), (200, 20)

-- Test 24: statement (line 95)
DELETE FROM parent WHERE p = 1

-- Test 25: query (line 98)
SELECT * FROM child

-- Test 26: query (line 104)
SELECT * FROM grandchild

-- Test 27: statement (line 109)
DELETE FROM parent WHERE p = 2

-- Test 28: query (line 112)
SELECT * FROM child

-- Test 29: query (line 116)
SELECT * FROM grandchild

-- Test 30: statement (line 120)
DROP TABLE grandchild;

-- Test 31: statement (line 123)
DROP TABLE child;

-- Test 32: statement (line 126)
DROP TABLE parent

-- Test 33: statement (line 130)
CREATE TABLE parent_multi (pa INT, pb INT, pc INT, UNIQUE INDEX (pa,pb,pc));

-- Test 34: statement (line 133)
CREATE TABLE child_multi_1 (
  c INT,
  a INT,
  b INT,
  FOREIGN KEY (a,b,c) REFERENCES parent_multi(pa,pb,pc) ON DELETE CASCADE
);

-- Test 35: statement (line 141)
CREATE TABLE child_multi_2 (
  b INT,
  c INT,
  a INT,
  FOREIGN KEY (a,b,c) REFERENCES parent_multi(pa,pb,pc) ON DELETE CASCADE
)

-- Test 36: statement (line 149)
INSERT INTO parent_multi VALUES (1, 10, 100), (2, 20, 200), (3, 30, 300), (NULL, NULL, NULL);
INSERT INTO child_multi_1(a,b,c) VALUES (1, 10, 100), (2, 20, 200), (1, 10, 100), (2, 20, 200), (NULL, NULL, NULL);
INSERT INTO child_multi_2(a,b,c) VALUES (2, 20, 200), (3, 30, 300)

-- Test 37: query (line 154)
SELECT * FROM parent_multi

-- Test 38: query (line 162)
SELECT a,b,c FROM child_multi_1

-- Test 39: query (line 171)
SELECT a,b,c FROM child_multi_2

-- Test 40: statement (line 177)
DELETE FROM parent_multi WHERE pa = 1

-- Test 41: query (line 180)
SELECT * FROM parent_multi

-- Test 42: query (line 187)
SELECT a,b,c FROM child_multi_1

-- Test 43: query (line 194)
SELECT a,b,c FROM child_multi_2

-- Test 44: statement (line 200)
DELETE FROM parent_multi WHERE pb = 20

-- Test 45: query (line 203)
SELECT * FROM parent_multi

-- Test 46: query (line 209)
SELECT a,b,c FROM child_multi_1

-- Test 47: query (line 214)
SELECT a,b,c FROM child_multi_2

-- Test 48: statement (line 220)
DELETE FROM parent_multi WHERE pa IS NULL

-- Test 49: query (line 223)
SELECT * FROM parent_multi

-- Test 50: query (line 228)
SELECT a,b,c FROM child_multi_1

-- Test 51: query (line 233)
SELECT a,b,c FROM child_multi_2

-- Test 52: statement (line 238)
DROP TABLE child_multi_1;
DROP TABLE child_multi_2;
DROP TABLE parent_multi

-- Test 53: statement (line 244)
CREATE TABLE self (a INT PRIMARY KEY, b INT REFERENCES self(a) ON DELETE CASCADE)

-- Test 54: statement (line 247)
INSERT INTO self VALUES (1, NULL);
INSERT INTO self SELECT x, x-1 FROM generate_series(2, 10) AS g(x)

-- Test 55: statement (line 251)
DELETE FROM self WHERE a = 4

-- Test 56: query (line 254)
SELECT * FROM self

-- Test 57: statement (line 261)
DELETE FROM self WHERE a = 1

-- Test 58: query (line 264)
SELECT * FROM self

-- Test 59: statement (line 269)
INSERT INTO self VALUES (1, NULL);
INSERT INTO self SELECT x, x-1 FROM generate_series(2, 20) AS g(x)

-- Test 60: statement (line 273)
SET foreign_key_cascades_limit = 10

-- Test 61: statement (line 276)
DELETE FROM self WHERE a = 1

-- Test 62: statement (line 279)
RESET foreign_key_cascades_limit

-- Test 63: statement (line 282)
DROP TABLE self

-- Test 64: statement (line 291)
CREATE TABLE a (
  id INT PRIMARY KEY
);

-- Test 65: statement (line 296)
CREATE TABLE b (
  delete_no_action INT NOT NULL REFERENCES a ON DELETE NO ACTION
 ,update_no_action INT NOT NULL REFERENCES a ON UPDATE NO ACTION
 ,delete_restrict INT NOT NULL REFERENCES a ON DELETE RESTRICT
 ,update_restrict INT NOT NULL REFERENCES a ON UPDATE RESTRICT
 ,delete_cascade INT NOT NULL REFERENCES a ON DELETE CASCADE
 ,update_cascade INT NOT NULL REFERENCES a ON UPDATE CASCADE
 ,delete_null INT REFERENCES a ON DELETE SET NULL
 ,update_null INT REFERENCES a ON UPDATE SET NULL
 ,delete_default INT DEFAULT 109 REFERENCES a ON DELETE SET DEFAULT
 ,update_default INT DEFAULT 110 REFERENCES a ON UPDATE SET DEFAULT
);

-- Test 66: statement (line 310)
INSERT INTO a (id) VALUES (1), (2), (3), (4), (5), (6), (7), (8), (9), (10), (109), (110);
INSERT INTO b VALUES (1, 2, 3, 4, 5, 6, 7, 8, 9, 10);

-- Test 67: query (line 314)
SELECT * FROM b;

-- Test 68: statement (line 320)
DELETE FROM a WHERE id = 1;

-- Test 69: statement (line 324)
UPDATE a SET id = 1000 WHERE id = 2;

-- Test 70: statement (line 328)
DELETE FROM a WHERE id = 3;

-- Test 71: statement (line 332)
UPDATE a SET id = 1000 WHERE id = 4;

-- Test 72: statement (line 336)
DELETE FROM a WHERE id = 5;

-- Test 73: query (line 339)
SELECT count(*) FROM b;

-- Test 74: statement (line 344)
INSERT INTO a VALUES (5);
INSERT INTO b VALUES (1, 2, 3, 4, 5, 6, 7, 8, 9, 10);

-- Test 75: statement (line 349)
UPDATE a SET id = 1006 WHERE id = 6;

-- Test 76: query (line 352)
SELECT * FROM b;

-- Test 77: statement (line 358)
UPDATE a SET id = 1 WHERE id = 1006;

-- Test 78: statement (line 362)
DELETE FROM a WHERE id = 7;

-- Test 79: query (line 365)
SELECT * FROM b;

-- Test 80: statement (line 371)
UPDATE a SET id = 1008 WHERE id = 8;

-- Test 81: query (line 374)
SELECT * FROM b;

-- Test 82: statement (line 380)
DELETE FROM a WHERE id = 9

-- Test 83: query (line 383)
SELECT * FROM b;

-- Test 84: statement (line 389)
UPDATE a SET id = 1010 WHERE id = 10;

-- Test 85: query (line 392)
SELECT * FROM b;

-- Test 86: statement (line 398)
DROP TABLE b, a;

-- Test 87: statement (line 443)
INSERT INTO a VALUES ('a-pk1');
INSERT INTO b1 VALUES ('b1-pk1', 'a-pk1'), ('b1-pk2', 'a-pk1');
INSERT INTO b2 VALUES ('b2-pk1', 'a-pk1'), ('b2-pk2', 'a-pk1');
INSERT INTO c1 VALUES
  ('c1-pk1-b1-pk1', 'b1-pk1')
 ,('c1-pk2-b1-pk1', 'b1-pk1')
 ,('c1-pk3-b1-pk2', 'b1-pk2')
 ,('c1-pk4-b1-pk2', 'b1-pk2')
;
INSERT INTO c2 VALUES
  ('c2-pk1-b1-pk1', 'b1-pk1')
 ,('c2-pk2-b1-pk1', 'b1-pk1')
 ,('c2-pk3-b1-pk2', 'b1-pk2')
 ,('c2-pk4-b1-pk2', 'b1-pk2')
;
INSERT INTO c3 VALUES ('b2-pk1'), ('b2-pk2');

-- Test 88: statement (line 462)
DELETE FROM a WHERE id = 'a-pk1';

-- Test 89: query (line 465)
SELECT
  (SELECT count(*) FROM a)
 ,(SELECT count(*) FROM b1)
 ,(SELECT count(*) FROM b2)
 ,(SELECT count(*) FROM c1)
 ,(SELECT count(*) FROM c2)
 ,(SELECT count(*) FROM c3)
;

-- Test 90: statement (line 478)
DROP TABLE c3, c2, c1, b2, b1, a;

-- Test 91: statement (line 514)
INSERT INTO a VALUES ('pk1');
INSERT INTO b1 VALUES ('pk1');
INSERT INTO b2 VALUES ('pk1');
INSERT INTO c1 VALUES ('pk1');
INSERT INTO c2 VALUES ('pk1');

-- Test 92: statement (line 522)
DELETE FROM a WHERE id = 'pk1';

-- Test 93: query (line 525)
SELECT
  (SELECT count(*) FROM a)
 ,(SELECT count(*) FROM b1)
 ,(SELECT count(*) FROM b2)
 ,(SELECT count(*) FROM c1)
 ,(SELECT count(*) FROM c2)
;

-- Test 94: statement (line 537)
DROP TABLE c2, c1, b2, b1, a;

-- Test 95: statement (line 593)
INSERT INTO a VALUES ('a-pk1', 1);
INSERT INTO b1 VALUES ('b1-pk1', 'a-pk1', 1, 1), ('b1-pk2', 'a-pk1', 1, 2);
INSERT INTO b2 VALUES ('b2-pk1', 'a-pk1', 1, 1), ('b2-pk2', 'a-pk1', 1, 2);
INSERT INTO c1 VALUES
  ('c1-pk1-b1-pk1', 'b1-pk1', 1)
 ,('c1-pk2-b1-pk1', 'b1-pk1', 1)
 ,('c1-pk3-b1-pk2', 'b1-pk2', 1)
 ,('c1-pk4-b1-pk2', 'b1-pk2', 1)
;
INSERT INTO c2 VALUES
  ('c2-pk1-b1-pk1', 'b1-pk1', 1)
 ,('c2-pk2-b1-pk1', 'b1-pk1', 1)
 ,('c2-pk3-b1-pk2', 'b1-pk2', 1)
 ,('c2-pk4-b1-pk2', 'b1-pk2', 1)
;

-- Test 96: statement (line 611)
DELETE FROM a WHERE id = 'a-pk1';

-- Test 97: query (line 614)
SELECT
  (SELECT count(*) FROM a)
 ,(SELECT count(*) FROM b1)
 ,(SELECT count(*) FROM b2)
 ,(SELECT count(*) FROM c1)
 ,(SELECT count(*) FROM c2)
;

-- Test 98: statement (line 626)
DROP TABLE c2, c1, b2, b1, a;

-- Test 99: statement (line 682)
INSERT INTO a VALUES ('a-pk1', 1);
INSERT INTO b1 VALUES ('b1-pk1', 'a-pk1', 1, 1), ('b1-pk2', 'a-pk1', 1, 2);
INSERT INTO b2 VALUES ('b2-pk1', 'a-pk1', 1, 1), ('b2-pk2', 'a-pk1', 1, 2);
INSERT INTO c1 VALUES
  ('c1-pk1-b1-pk1', 'b1-pk1', 1)
 ,('c1-pk2-b1-pk1', 'b1-pk1', 1)
 ,('c1-pk3-b1-pk2', 'b1-pk2', 1)
 ,('c1-pk4-b1-pk2', 'b1-pk2', 1)
;
INSERT INTO c2 VALUES
  ('c2-pk1-b1-pk1', 'b1-pk1', 1)
 ,('c2-pk2-b1-pk1', 'b1-pk1', 1)
 ,('c2-pk3-b1-pk2', 'b1-pk2', 1)
 ,('c2-pk4-b1-pk2', 'b1-pk2', 1)
;

-- Test 100: statement (line 700)
DELETE FROM a WHERE id = 'a-pk1';

-- Test 101: query (line 703)
SELECT
  (SELECT count(*) FROM a)
 ,(SELECT count(*) FROM b1)
 ,(SELECT count(*) FROM b2)
 ,(SELECT count(*) FROM c1)
 ,(SELECT count(*) FROM c2)
;

-- Test 102: statement (line 715)
DROP TABLE c2, c1, b2, b1, a;

-- Test 103: statement (line 763)
INSERT INTO a VALUES ('a-pk1');
INSERT INTO b1 VALUES ('b1-pk1', 'a-pk1'), ('b1-pk2', 'a-pk1');
INSERT INTO b2 VALUES ('b2-pk1', 'a-pk1'), ('b2-pk2', 'a-pk1');
INSERT INTO c1 VALUES
  ('c1-pk1-b1-pk1', 'b1-pk1')
 ,('c1-pk2-b1-pk1', 'b1-pk1')
 ,('c1-pk3-b1-pk2', 'b1-pk2')
 ,('c1-pk4-b1-pk2', 'b1-pk2')
;
INSERT INTO c2 VALUES
  ('c2-pk1-b1-pk1', 'b1-pk1')
 ,('c2-pk2-b1-pk1', 'b1-pk1')
 ,('c2-pk3-b1-pk2', 'b1-pk2')
 ,('c2-pk4-b1-pk2', 'b1-pk2')
;
INSERT INTO d VALUES ('d-pk1-c2-pk4-b1-pk2', 'c2-pk4-b1-pk2');

-- Test 104: statement (line 782)
DELETE FROM a WHERE id = 'a-pk1';

-- Test 105: statement (line 786)
DROP TABLE d, c2, c1, b2, b1, a;

-- Test 106: statement (line 793)
CREATE TABLE self (
  id INT PRIMARY KEY
 ,other_id INT REFERENCES self ON DELETE CASCADE
);

-- Test 107: statement (line 799)
INSERT INTO self VALUES (1, NULL);
INSERT INTO self VALUES (2, 1);
INSERT INTO self VALUES (3, 2);
INSERT INTO self VALUES (4, 3);

-- Test 108: statement (line 805)
DELETE FROM self WHERE id = 1;

-- Test 109: query (line 808)
SELECT count(*) FROM self

-- Test 110: statement (line 814)
DROP TABLE self;

-- Test 111: statement (line 821)
CREATE TABLE self (
  id INT PRIMARY KEY
 ,other_id INT REFERENCES self ON DELETE CASCADE
);

-- Test 112: statement (line 827)
INSERT INTO self VALUES (1, NULL);
INSERT INTO self VALUES (2, 1);
INSERT INTO self VALUES (3, 2);
INSERT INTO self VALUES (4, 3);

-- Test 113: statement (line 833)
UPDATE self SET other_id = 4 WHERE id = 1;

-- Test 114: statement (line 836)
DELETE FROM self WHERE id = 1;

-- Test 115: query (line 839)
SELECT count(*) FROM self

-- Test 116: statement (line 845)
DROP TABLE self;

-- Test 117: statement (line 866)
ALTER TABLE loop_a ADD CONSTRAINT cascade_delete_constraint
  FOREIGN KEY (cascade_delete) REFERENCES loop_b (id)
  ON DELETE CASCADE;

-- Test 118: statement (line 871)
INSERT INTO loop_a (id, cascade_delete) VALUES ('loop_a-pk1', NULL);
INSERT INTO loop_b (id, cascade_delete) VALUES ('loop_b-pk1', 'loop_a-pk1');
INSERT INTO loop_a (id, cascade_delete) VALUES ('loop_a-pk2', 'loop_b-pk1');
INSERT INTO loop_b (id, cascade_delete) VALUES ('loop_b-pk2', 'loop_a-pk2');
INSERT INTO loop_a (id, cascade_delete) VALUES ('loop_a-pk3', 'loop_b-pk2');
INSERT INTO loop_b (id, cascade_delete) VALUES ('loop_b-pk3', 'loop_a-pk3');

-- Test 119: statement (line 879)
UPDATE loop_a SET cascade_delete = 'loop_b-pk3' WHERE id = 'loop_a-pk1';

-- Test 120: statement (line 882)
DELETE FROM loop_a WHERE id = 'loop_a-pk1';

-- Test 121: query (line 885)
SELECT
  (SELECT count(*) FROM loop_a)
 ,(SELECT count(*) FROM loop_b)
;

-- Test 122: statement (line 894)
DROP TABLE loop_a, loop_b;

-- Test 123: statement (line 915)
ALTER TABLE loop_a ADD CONSTRAINT cascade_delete_constraint
  FOREIGN KEY (cascade_delete) REFERENCES loop_b (id)
  ON DELETE CASCADE;

-- Test 124: statement (line 920)
INSERT INTO loop_a (id, cascade_delete) VALUES ('loop_a-pk1', NULL);
INSERT INTO loop_b (id, cascade_delete) VALUES ('loop_b-pk1', 'loop_a-pk1');
INSERT INTO loop_a (id, cascade_delete) VALUES ('loop_a-pk2', 'loop_b-pk1');
INSERT INTO loop_b (id, cascade_delete) VALUES ('loop_b-pk2', 'loop_a-pk2');
INSERT INTO loop_a (id, cascade_delete) VALUES ('loop_a-pk3', 'loop_b-pk2');
INSERT INTO loop_b (id, cascade_delete) VALUES ('loop_b-pk3', 'loop_a-pk3');

-- Test 125: statement (line 928)
DELETE FROM loop_a WHERE id = 'loop_a-pk1';

-- Test 126: query (line 931)
SELECT
  (SELECT count(*) FROM loop_a)
 ,(SELECT count(*) FROM loop_b)
;

-- Test 127: statement (line 940)
DROP TABLE loop_a, loop_b;

-- Test 128: statement (line 955)
INSERT INTO self_x2 (x, y, z) VALUES ('pk1', NULL, NULL);
INSERT INTO self_x2 (x, y, z) VALUES ('pk2', 'pk1', NULL);
INSERT INTO self_x2 (x, y, z) VALUES ('pk3', 'pk2', 'pk1');

-- Test 129: statement (line 960)
DELETE FROM self_x2 WHERE x = 'pk1';

-- Test 130: query (line 963)
SELECT count(*) FROM self_x2

-- Test 131: statement (line 969)
DROP TABLE self_x2;

-- Test 132: statement (line 1011)
INSERT INTO a (id) VALUES ('a1');
INSERT INTO b (id, a_id) VALUES ('b1', 'a1');
INSERT INTO c (id, a_id) VALUES ('c1', 'a1');
INSERT INTO d (id, c_id) VALUES ('d1', 'c1');
INSERT INTO e (id, b_id, d_id) VALUES ('e1', 'b1', 'd1');

-- Test 133: statement (line 1018)
DELETE FROM a WHERE id = 'a1';

-- Test 134: query (line 1021)
SELECT
  (SELECT count(*) FROM a)
 ,(SELECT count(*) FROM b)
 ,(SELECT count(*) FROM c)
 ,(SELECT count(*) FROM d)
 ,(SELECT count(*) FROM e)
;

-- Test 135: statement (line 1033)
DROP TABLE e, d, c, b, a;

-- Test 136: statement (line 1039)
CREATE TABLE a (
  id INT PRIMARY KEY
);
CREATE TABLE b (
  id INT PRIMARY KEY
 ,a_id INT REFERENCES a ON DELETE CASCADE
)

-- Test 137: statement (line 1048)
INSERT INTO a VALUES (1), (2), (3);
INSERT INTO b VALUES (1, 1), (2, NULL), (3, 2), (4, 1), (5, NULL);

-- Test 138: statement (line 1052)
DELETE FROM a;

-- Test 139: query (line 1055)
SELECT id, a_id FROM b;

-- Test 140: statement (line 1062)
DROP TABLE b, a;

-- Test 141: statement (line 1107)
INSERT INTO a VALUES ('original');
INSERT INTO b1 VALUES ('b1-pk1', 'original');
INSERT INTO b2 VALUES ('b2-pk1', 'original');
INSERT INTO c1 VALUES
  ('c1-pk1', 'original')
 ,('c1-pk2', 'original')
 ,('c1-pk3', 'original')
 ,('c1-pk4', 'original')
;
INSERT INTO c2 VALUES
  ('c2-pk1', 'original')
 ,('c2-pk2', 'original')
 ,('c2-pk3', 'original')
 ,('c2-pk4', 'original')
;
INSERT INTO c3 VALUES ('original');

-- Test 142: statement (line 1126)
UPDATE a SET id = 'updated' WHERE id = 'original';

-- Test 143: query (line 1129)
SELECT * FROM a;

-- Test 144: query (line 1134)
SELECT * FROM b1;

-- Test 145: query (line 1139)
SELECT * FROM b2;

-- Test 146: query (line 1144)
SELECT * FROM c1;

-- Test 147: query (line 1152)
SELECT * FROM c2;

-- Test 148: statement (line 1161)
DROP TABLE c3, c2, c1, b2, b1, a;

-- Test 149: statement (line 1197)
INSERT INTO a VALUES ('original');
INSERT INTO b1 VALUES ('original');
INSERT INTO b2 VALUES ('original');
INSERT INTO c1 VALUES ('original');
INSERT INTO c2 VALUES ('original');

-- Test 150: statement (line 1205)
UPDATE a SET id = 'updated' WHERE id = 'original';

-- Test 151: query (line 1208)
SELECT
  (SELECT id FROM a)
 ,(SELECT id FROM b1)
 ,(SELECT id FROM b2)
 ,(SELECT id FROM c1)
 ,(SELECT id FROM c2)
;

-- Test 152: statement (line 1220)
DROP TABLE c2, c1, b2, b1, a;

-- Test 153: statement (line 1276)
INSERT INTO a VALUES ('a-pk1', 1);
INSERT INTO b1 VALUES ('b1-pk1', 'a-pk1', 1, 1), ('b1-pk2', 'a-pk1', 1, 2);
INSERT INTO b2 VALUES ('b2-pk1', 'a-pk1', 1, 1), ('b2-pk2', 'a-pk1', 1, 2);
INSERT INTO c1 VALUES
  ('c1-pk1-b1-pk1', 'b1-pk1', 1)
 ,('c1-pk2-b1-pk1', 'b1-pk1', 1)
 ,('c1-pk3-b1-pk2', 'b1-pk2', 1)
 ,('c1-pk4-b1-pk2', 'b1-pk2', 1)
;
INSERT INTO c2 VALUES
  ('c2-pk1-b1-pk1', 'b1-pk1', 1)
 ,('c2-pk2-b1-pk1', 'b1-pk1', 1)
 ,('c2-pk3-b1-pk2', 'b1-pk2', 1)
 ,('c2-pk4-b1-pk2', 'b1-pk2', 1)
;

-- Test 154: statement (line 1294)
UPDATE a SET x = 2 WHERE x = 1;

-- Test 155: query (line 1297)
SELECT * FROM a;

-- Test 156: query (line 1302)
SELECT * FROM b1;

-- Test 157: query (line 1308)
SELECT * FROM b2;

-- Test 158: query (line 1314)
SELECT * FROM c1;

-- Test 159: query (line 1322)
SELECT * FROM c2;

-- Test 160: statement (line 1331)
DROP TABLE c2, c1, b2, b1, a;

-- Test 161: statement (line 1387)
INSERT INTO a VALUES ('a-pk1', 1);
INSERT INTO b1 VALUES ('b1-pk1', 'a-pk1', 1, 1), ('b1-pk2', 'a-pk1', 1, 2);
INSERT INTO b2 VALUES ('b2-pk1', 'a-pk1', 1, 1), ('b2-pk2', 'a-pk1', 1, 2);
INSERT INTO c1 VALUES
  ('c1-pk1-b1-pk1', 'b1-pk1', 1)
 ,('c1-pk2-b1-pk1', 'b1-pk1', 1)
 ,('c1-pk3-b1-pk2', 'b1-pk2', 1)
 ,('c1-pk4-b1-pk2', 'b1-pk2', 1)
;
INSERT INTO c2 VALUES
  ('c2-pk1-b1-pk1', 'b1-pk1', 1)
 ,('c2-pk2-b1-pk1', 'b1-pk1', 1)
 ,('c2-pk3-b1-pk2', 'b1-pk2', 1)
 ,('c2-pk4-b1-pk2', 'b1-pk2', 1)
;

-- Test 162: statement (line 1405)
UPDATE a SET x = 2 WHERE x = 1;

-- Test 163: query (line 1408)
SELECT * FROM a;

-- Test 164: query (line 1413)
SELECT * FROM b1;

-- Test 165: query (line 1419)
SELECT * FROM b2;

-- Test 166: query (line 1425)
SELECT * FROM c1;

-- Test 167: query (line 1433)
SELECT * FROM c2;

-- Test 168: statement (line 1442)
DROP TABLE c2, c1, b2, b1, a;

-- Test 169: statement (line 1503)
INSERT INTO a VALUES ('original');
INSERT INTO b1 VALUES ('b1-pk1', 'original');
INSERT INTO b2 VALUES ('b2-pk1', 'original');
INSERT INTO c1 VALUES
  ('c1-pk1', 'original')
 ,('c1-pk2', 'original')
 ,('c1-pk3', 'original')
 ,('c1-pk4', 'original')
;
INSERT INTO c2 VALUES ('c2-pk1', 'original');
INSERT INTO c3 VALUES ('original');

-- Test 170: statement (line 1517)
INSERT INTO d1 VALUES ('d1-pk1', 'original');

-- Test 171: statement (line 1521)
UPDATE a SET id = 'updated' WHERE id = 'original';

-- Test 172: statement (line 1524)
DELETE FROM d1 WHERE id = 'd1-pk1';

-- Test 173: statement (line 1528)
INSERT INTO d2 VALUES ('original');

-- Test 174: statement (line 1532)
UPDATE a SET id = 'updated' WHERE id = 'original';

-- Test 175: statement (line 1536)
DROP TABLE d2, d1, c3, c2, c1, b2, b1, a;

-- Test 176: statement (line 1543)
CREATE TABLE self (
  id INT PRIMARY KEY
 ,other_id INT REFERENCES self ON UPDATE CASCADE
);

-- Test 177: statement (line 1549)
INSERT INTO self VALUES (1, NULL);
INSERT INTO self VALUES (2, 1);
INSERT INTO self VALUES (3, 2);

-- Test 178: query (line 1554)
SELECT * FROM self;

-- Test 179: statement (line 1561)
UPDATE self SET id = 4 WHERE id = 2;

-- Test 180: query (line 1564)
SELECT * FROM self;

-- Test 181: statement (line 1572)
DROP TABLE self;

-- Test 182: statement (line 1590)
INSERT INTO loop_a VALUES ('original');
INSERT INTO loop_b VALUES ('original');

-- Test 183: statement (line 1594)
ALTER TABLE loop_a ADD CONSTRAINT cascade_update_constraint
  FOREIGN KEY (id) REFERENCES loop_b
  ON UPDATE CASCADE;

-- Test 184: query (line 1599)
SELECT
  (SELECT id FROM loop_a)
 ,(SELECT id FROM loop_b)
;

-- Test 185: statement (line 1607)
UPDATE loop_a SET id = 'updated' WHERE id = 'original';

-- Test 186: query (line 1610)
SELECT
  (SELECT id FROM loop_a)
 ,(SELECT id FROM loop_b)
;

-- Test 187: statement (line 1618)
UPDATE loop_b SET id = 'updated2' WHERE id = 'updated';

-- Test 188: query (line 1621)
SELECT
  (SELECT id FROM loop_a)
 ,(SELECT id FROM loop_b)
;

-- Test 189: statement (line 1630)
DROP TABLE loop_a, loop_b;

-- Test 190: statement (line 1645)
INSERT INTO self_x2 (x, y, z) VALUES ('pk1', NULL, NULL);
INSERT INTO self_x2 (x, y, z) VALUES ('pk2', 'pk1', NULL);
INSERT INTO self_x2 (x, y, z) VALUES ('pk3', 'pk2', 'pk1');

-- Test 191: statement (line 1651)
UPDATE self_x2 SET x = 'pk1-updated' WHERE x = 'pk1';

-- Test 192: statement (line 1654)
UPDATE self_x2 SET x = 'pk2-updated' WHERE x = 'pk2';

-- Test 193: statement (line 1657)
UPDATE self_x2 SET x = 'pk3-updated' WHERE x = 'pk3';

-- Test 194: query (line 1660)
SELECT * FROM self_x2

-- Test 195: statement (line 1668)
DROP TABLE self_x2;

-- Test 196: statement (line 1715)
INSERT INTO a (id) VALUES ('original');
INSERT INTO b (id) VALUES ('original');
INSERT INTO c (id) VALUES ('original');
INSERT INTO d (id) VALUES ('original');
INSERT INTO e (b_id, d_id) VALUES ('original', 'original');
INSERT INTO f (e_b_id, e_d_id) VALUES ('original', 'original');

-- Test 197: statement (line 1723)
UPDATE a SET id = 'updated' WHERE id = 'original';

-- Test 198: query (line 1726)
SELECT
  (SELECT id FROM a)
 ,(SELECT id FROM b)
 ,(SELECT id FROM c)
 ,(SELECT id FROM d)
;

-- Test 199: query (line 1736)
SELECT * FROM e

-- Test 200: query (line 1741)
SELECT * FROM f

-- Test 201: statement (line 1747)
DROP TABLE f, e, d, c, b, a;

-- Test 202: statement (line 1796)
INSERT INTO a (id) VALUES ('original');
INSERT INTO b (id) VALUES ('original');
INSERT INTO c (id) VALUES ('original');
INSERT INTO d (id) VALUES ('original');
INSERT INTO e (d_id, c_id) VALUES ('original', 'original');
INSERT INTO f (e_d_id, e_c_id) VALUES ('original', 'original');

-- Test 203: statement (line 1804)
UPDATE a SET id = 'updated' WHERE id = 'original';

-- Test 204: query (line 1807)
SELECT
  (SELECT id FROM a)
 ,(SELECT id FROM b)
 ,(SELECT id FROM c)
 ,(SELECT id FROM d)
;

-- Test 205: query (line 1817)
SELECT * FROM e

-- Test 206: query (line 1822)
SELECT * FROM f

-- Test 207: statement (line 1828)
DROP TABLE f, e, d, c, b, a;

-- Test 208: statement (line 1834)
CREATE TABLE a (
  id INT PRIMARY KEY
);
CREATE TABLE b (
  id INT PRIMARY KEY
 ,a_id INT REFERENCES a ON UPDATE CASCADE
)

-- Test 209: statement (line 1843)
INSERT INTO a VALUES (1), (2), (3);
INSERT INTO b VALUES (1, 1), (2, NULL), (3, 2), (4, 1), (5, NULL);

-- Test 210: statement (line 1847)
UPDATE a SET id = id + 10;

-- Test 211: query (line 1850)
SELECT id, a_id FROM b;

-- Test 212: statement (line 1860)
DROP TABLE b, a;

-- Test 213: statement (line 1871)
CREATE TABLE a (
  id INT PRIMARY KEY
);
CREATE TABLE b (
  id INT PRIMARY KEY REFERENCES a ON UPDATE CASCADE
 ,CONSTRAINT less_than_1000 CHECK (id < 1000)
);
CREATE TABLE c (
  id INT PRIMARY KEY REFERENCES b ON UPDATE CASCADE
 ,CONSTRAINT less_than_100 CHECK (id < 100)
 ,CONSTRAINT no_99 CHECK (id != 99)
);

-- Test 214: statement (line 1885)
INSERT INTO a VALUES (1), (2), (3);
INSERT INTO b VALUES (1), (2);
INSERT INTO c VALUES (1);

-- Test 215: statement (line 1891)
UPDATE a SET id = id*10;

-- Test 216: query (line 1894)
SELECT name, id FROM (
  SELECT 'a' AS name, id FROM a
UNION ALL
  SELECT 'b' AS name, id FROM b
UNION ALL
  SELECT 'c' AS name, id FROM c
)
ORDER BY name, id
;

-- Test 217: statement (line 1913)
UPDATE a SET id = id*10;

-- Test 218: statement (line 1918)
UPDATE a SET id = id*1000;

-- Test 219: statement (line 1922)
UPDATE a SET id = id*1000 WHERE id > 10;

-- Test 220: statement (line 1926)
UPDATE a SET id = 99 WHERE id = 10;

-- Test 221: statement (line 1931)
UPDATE a SET id = 99 WHERE id = 20;

-- Test 222: statement (line 1935)
UPDATE a SET id = 999 WHERE id = 99;

-- Test 223: statement (line 1939)
UPDATE a SET id = 100000 WHERE id = 30;

-- Test 224: query (line 1942)
SELECT name, id FROM (
  SELECT 'a' AS name, id FROM a
UNION ALL
  SELECT 'b' AS name, id FROM b
UNION ALL
  SELECT 'c' AS name, id FROM c
)
ORDER BY name, id
;

-- Test 225: statement (line 1961)
DROP TABLE c, b, a;

-- Test 226: statement (line 1972)
CREATE TABLE a (
  id INT PRIMARY KEY
);
CREATE TABLE b (
  id1 INT PRIMARY KEY REFERENCES a ON UPDATE CASCADE
 ,id2 INT UNIQUE NOT NULL REFERENCES a ON UPDATE CASCADE
 ,CONSTRAINT less_than_1000 CHECK (id1 + id2 < 1000)
);
CREATE TABLE c (
  id1 INT PRIMARY KEY REFERENCES b(id1) ON UPDATE CASCADE
 ,id2 INT UNIQUE NOT NULL REFERENCES b(id2) ON UPDATE CASCADE
 ,CONSTRAINT less_than_100 CHECK (id1 + id2 < 100)
);

-- Test 227: statement (line 1987)
INSERT INTO a VALUES (1), (2), (3), (4), (5);
INSERT INTO b VALUES (1, 1), (2, 2), (3, 4);
INSERT INTO c VALUES (2, 1), (1, 2);

-- Test 228: statement (line 1994)
UPDATE a SET id = id*10;

skipif config #112488 weak-iso-level-configs

-- Test 229: query (line 1998)
SELECT name, id1, id2 FROM (
  SELECT 'a' AS name, id AS id1, 0 AS id2 FROM a
UNION ALL
  SELECT 'b' AS name, id1, id2 FROM b
UNION ALL
  SELECT 'c' AS name, id1, id2 FROM c
) ORDER BY name, id1, id2
;

-- Test 230: statement (line 2021)
UPDATE a SET id = id*10;

-- Test 231: statement (line 2026)
UPDATE a SET id = id*10;

-- Test 232: statement (line 2031)
UPDATE a SET id = 1000 WHERE id = 30;

skipif config #112488 weak-iso-level-configs

-- Test 233: statement (line 2035)
UPDATE a SET id = 1000 WHERE id = 40;

-- Test 234: statement (line 2040)
UPDATE a SET id = 100000 WHERE id = 50;

-- Test 235: statement (line 2044)
DROP TABLE c, b, a;

-- Test 236: statement (line 2075)
INSERT INTO a VALUES ('delete_me'), ('untouched');
INSERT INTO b1 VALUES ('b1-pk1', 'untouched'), ('b1-pk2', 'untouched');
INSERT INTO b2 VALUES ('b2-pk1', 'untouched'), ('b2-pk2', 'delete_me');
INSERT INTO b3 VALUES ('b3-pk1', 'delete_me'), ('b3-pk2', 'untouched');
INSERT INTO b4 VALUES ('b4-pk1', 'delete_me'), ('b4-pk2', 'delete_me');

-- Test 237: statement (line 2083)
DELETE FROM a WHERE id = 'delete_me';

-- Test 238: query (line 2086)
SELECT id, delete_set_null FROM b1
UNION ALL
  SELECT id, delete_set_null FROM b2
UNION ALL
  SELECT id, delete_set_null FROM b3
UNION ALL
  SELECT id, delete_set_null FROM b4
;

-- Test 239: statement (line 2106)
DROP TABLE b4, b3, b2, b1, a;

-- Test 240: statement (line 2142)
INSERT INTO a VALUES ('a-pk1');
INSERT INTO b1 VALUES ('b1-pk1', 'a-pk1'), ('b1-pk2', 'a-pk1');
INSERT INTO b2 VALUES ('b2-pk1', 'a-pk1'), ('b2-pk2', 'a-pk1');
INSERT INTO c1 VALUES
  ('c1-pk1-b1-pk1', 'b1-pk1')
 ,('c1-pk2-b1-pk1', 'b1-pk1')
 ,('c1-pk3-b1-pk2', 'b1-pk2')
 ,('c1-pk4-b1-pk2', 'b1-pk2')
;
INSERT INTO c2 VALUES
  ('c2-pk1-b1-pk1', 'b1-pk1')
 ,('c2-pk2-b1-pk1', 'b1-pk1')
 ,('c2-pk3-b1-pk2', 'b1-pk2')
 ,('c2-pk4-b1-pk2', 'b1-pk2')
;
INSERT INTO c3 VALUES
  ('c3-pk1-b2-pk1', 'b2-pk1')
 ,('c3-pk2-b2-pk1', 'b2-pk1')
 ,('c3-pk3-b2-pk2', 'b2-pk2')
 ,('c3-pk4-b2-pk2', 'b2-pk2')
;

-- Test 241: statement (line 2167)
DELETE FROM a WHERE id = 'a-pk1';

-- Test 242: query (line 2170)
SELECT id, 'empty' FROM a
UNION ALL
  SELECT id, delete_cascade FROM b1
UNION ALL
  SELECT id, delete_cascade FROM b2
UNION ALL
  SELECT id, delete_set_null FROM c1
UNION ALL
  SELECT id, delete_set_null FROM c2
UNION ALL
  SELECT id, delete_set_null FROM c3
;

-- Test 243: statement (line 2197)
ALTER TABLE c3 SET (schema_locked=false)

-- Test 244: statement (line 2200)
ALTER TABLE c2 SET (schema_locked=false)

-- Test 245: statement (line 2203)
ALTER TABLE c1 SET (schema_locked=false)

-- Test 246: statement (line 2206)
ALTER TABLE b2 SET (schema_locked=false)

-- Test 247: statement (line 2209)
ALTER TABLE b1 SET (schema_locked=false)

-- Test 248: statement (line 2212)
ALTER TABLE a SET (schema_locked=false)

-- Test 249: statement (line 2215)
TRUNCATE c3, c2, c1, b2, b1, a;

-- Test 250: statement (line 2218)
ALTER TABLE c3 RESET (schema_locked)

-- Test 251: statement (line 2221)
ALTER TABLE c2 RESET (schema_locked)

-- Test 252: statement (line 2224)
ALTER TABLE c1 RESET (schema_locked)

-- Test 253: statement (line 2227)
ALTER TABLE b2 RESET (schema_locked)

-- Test 254: statement (line 2230)
ALTER TABLE b1 RESET (schema_locked)

-- Test 255: statement (line 2233)
ALTER TABLE a RESET (schema_locked)

-- Test 256: statement (line 2237)
DROP TABLE c3, c2, c1, b2, b1, a;

-- Test 257: statement (line 2262)
INSERT INTO a VALUES ('delete-me'), ('untouched');
INSERT INTO b VALUES ('b1', 'delete-me'), ('b2', 'untouched');
INSERT INTO c VALUES
  ('c1-b1', 'delete-me')
 ,('c2-b1', 'delete-me')
 ,('c3-b2', 'untouched')
 ,('c4-b2', 'untouched')
;

-- Test 258: statement (line 2272)
DELETE FROM a WHERE id = 'delete-me';

-- Test 259: query (line 2275)
SELECT count(*) FROM a;

-- Test 260: query (line 2280)
SELECT id, a_id FROM b
UNION ALL
  SELECT id, b_a_id FROM c
;

-- Test 261: statement (line 2294)
DROP TABLE c, b, a;

-- Test 262: statement (line 2319)
INSERT INTO a VALUES ('delete-me'), ('untouched');
INSERT INTO b VALUES ('b1', 'delete-me'), ('b2', 'untouched');
INSERT INTO c VALUES
  ('c1-b1', 'delete-me')
 ,('c2-b1', 'delete-me')
 ,('c3-b2', 'untouched')
 ,('c4-b2', 'untouched')
;

-- Test 263: statement (line 2329)
DELETE FROM a WHERE id = 'delete-me';

-- Test 264: statement (line 2333)
DROP TABLE c, b, a;

-- Test 265: statement (line 2364)
INSERT INTO a VALUES ('original'), ('untouched');
INSERT INTO b1 VALUES ('b1-pk1', 'untouched'), ('b1-pk2', 'untouched');
INSERT INTO b2 VALUES ('b2-pk1', 'untouched'), ('b2-pk2', 'original');
INSERT INTO b3 VALUES ('b3-pk1', 'original'), ('b3-pk2', 'untouched');
INSERT INTO b3 VALUES ('b4-pk1', 'original'), ('b4-pk2', 'original');

-- Test 266: statement (line 2372)
UPDATE a SET id = 'updated' WHERE id = 'original';

-- Test 267: query (line 2375)
SELECT id, update_set_null FROM b1
UNION ALL
  SELECT id, update_set_null FROM b2
UNION ALL
  SELECT id, update_set_null FROM b3
UNION ALL
  SELECT id, update_set_null FROM b4
;

-- Test 268: statement (line 2395)
DROP TABLE b4, b3, b2, b1, a;

-- Test 269: statement (line 2431)
INSERT INTO a VALUES ('original'), ('untouched');
INSERT INTO b1 VALUES ('b1-pk1', 'original'), ('b1-pk2', 'untouched');
INSERT INTO b2 VALUES ('b2-pk1', 'original'), ('b2-pk2', 'untouched');
INSERT INTO c1 VALUES
  ('c1-pk1-b1-pk1', 'original')
 ,('c1-pk2-b1-pk1', 'original')
 ,('c1-pk3-b1-pk2', 'untouched')
 ,('c1-pk4-b1-pk2', 'untouched')
;
INSERT INTO c2 VALUES
  ('c2-pk1-b1-pk1', 'original')
 ,('c2-pk2-b1-pk1', 'original')
 ,('c2-pk3-b1-pk2', 'untouched')
 ,('c2-pk4-b1-pk2', 'untouched')
;
INSERT INTO c3 VALUES
  ('c3-pk1-b2-pk1', 'original')
 ,('c3-pk2-b2-pk1', 'original')
 ,('c3-pk3-b2-pk2', 'untouched')
 ,('c3-pk4-b2-pk2', 'untouched')
;

-- Test 270: statement (line 2455)
UPDATE a SET id = 'updated' WHERE id = 'original';

-- Test 271: query (line 2458)
SELECT id, update_cascade FROM b1
UNION ALL
  SELECT id, update_cascade FROM b2
UNION ALL
  SELECT id, update_set_null FROM c1
UNION ALL
  SELECT id, update_set_null FROM c2
UNION ALL
  SELECT id, update_set_null FROM c3
;

-- Test 272: statement (line 2488)
DROP TABLE c3, c2, c1, b2, b1, a;

-- Test 273: statement (line 2513)
INSERT INTO a VALUES ('original'), ('untouched');
INSERT INTO b VALUES ('b1', 'original'), ('b2', 'untouched');
INSERT INTO c VALUES
  ('c1-b1', 'original')
 ,('c2-b1', 'original')
 ,('c3-b2', 'untouched')
 ,('c4-b2', 'untouched')
;

-- Test 274: statement (line 2523)
UPDATE a SET id = 'updated' WHERE id = 'original';

-- Test 275: query (line 2526)
SELECT id, a_id FROM b
UNION ALL
  SELECT id, b_a_id FROM c

-- Test 276: statement (line 2539)
DROP TABLE c, b, a;

-- Test 277: statement (line 2564)
INSERT INTO a VALUES ('original'), ('untouched');
INSERT INTO b VALUES ('b1', 'original'), ('b2', 'untouched');
INSERT INTO c VALUES
  ('c1-b1', 'original')
 ,('c2-b1', 'original')
 ,('c3-b2', 'untouched')
 ,('c4-b2', 'untouched')
;

-- Test 278: statement (line 2574)
UPDATE a SET id = 'updated' WHERE id = 'original';

-- Test 279: statement (line 2578)
DROP TABLE c, b, a;

-- Test 280: statement (line 2611)
INSERT INTO a VALUES ('delete_me'), ('untouched'), ('b1-default'), ('b2-default'), ('b3-default'), ('b4-default');
INSERT INTO b1 VALUES ('b1-pk1', 'untouched'), ('b1-pk2', 'untouched');
INSERT INTO b2 VALUES ('b2-pk1', 'untouched'), ('b2-pk2', 'delete_me');
INSERT INTO b3 VALUES ('b3-pk1', 'delete_me'), ('b3-pk2', 'untouched');
INSERT INTO b4 VALUES ('b4-pk1', 'delete_me'), ('b4-pk2', 'delete_me');

-- Test 281: statement (line 2619)
DELETE FROM a WHERE id = 'delete_me';

-- Test 282: query (line 2622)
SELECT id, delete_set_default FROM b1
UNION ALL
  SELECT id, delete_set_default FROM b2
UNION ALL
  SELECT id, delete_set_default FROM b3
UNION ALL
  SELECT id, delete_set_default FROM b4
;

-- Test 283: statement (line 2642)
DROP TABLE b4, b3, b2, b1, a;

-- Test 284: statement (line 2674)
INSERT INTO a VALUES ('delete_me'), ('untouched'), ('b1-def'), ('b2-def'), ('b3-def'), ('b4-def');
INSERT INTO b1 VALUES ('b1-pk1', 'untouched'), ('b1-pk2', 'untouched');
INSERT INTO b2 VALUES ('b2-pk1', 'untouched'), ('b2-pk2', 'delete_me');
INSERT INTO b3 VALUES ('b3-pk1', 'delete_me'), ('b3-pk2', 'untouched');
INSERT INTO b4 VALUES ('b4-pk1', 'delete_me'), ('b4-pk2', 'delete_me');

-- Test 285: statement (line 2682)
DELETE FROM a WHERE id = 'delete_me';

-- Test 286: statement (line 2686)
DROP TABLE b4, b3, b2, b1, a;

-- Test 287: statement (line 2722)
INSERT INTO a VALUES ('a-pk1'), ('a-default');
INSERT INTO b1 VALUES ('b1-pk1', 'a-pk1'), ('b1-pk2', 'a-pk1'), ('b1-default', 'a-default');
INSERT INTO b2 VALUES ('b2-pk1', 'a-pk1'), ('b2-pk2', 'a-pk1'), ('b2-default', 'a-default');
INSERT INTO c1 VALUES
  ('c1-pk1-b1-pk1', 'b1-pk1')
 ,('c1-pk2-b1-pk1', 'b1-pk1')
 ,('c1-pk3-b1-pk2', 'b1-pk2')
 ,('c1-pk4-b1-pk2', 'b1-pk2')
;
INSERT INTO c2 VALUES
  ('c2-pk1-b1-pk1', 'b1-pk1')
 ,('c2-pk2-b1-pk1', 'b1-pk1')
 ,('c2-pk3-b1-pk2', 'b1-pk2')
 ,('c2-pk4-b1-pk2', 'b1-pk2')
;
INSERT INTO c3 VALUES
  ('c3-pk1-b2-pk1', 'b2-pk1')
 ,('c3-pk2-b2-pk1', 'b2-pk1')
 ,('c3-pk3-b2-pk2', 'b2-pk2')
 ,('c3-pk4-b2-pk2', 'b2-pk2')
;

-- Test 288: statement (line 2747)
DELETE FROM a WHERE id = 'a-pk1';

-- Test 289: query (line 2750)
SELECT id, 'empty' FROM a
UNION ALL
  SELECT id, delete_cascade FROM b1
UNION ALL
  SELECT id, delete_cascade FROM b2
UNION ALL
  SELECT id, delete_set_default FROM c1
UNION ALL
  SELECT id, delete_set_default FROM c2
UNION ALL
  SELECT id, delete_set_default FROM c3
;

-- Test 290: statement (line 2780)


-- Test 291: statement (line 2782)
ALTER TABLE c3 SET (schema_locked=false)

-- Test 292: statement (line 2785)
ALTER TABLE c2 SET (schema_locked=false)

-- Test 293: statement (line 2788)
ALTER TABLE c1 SET (schema_locked=false)

-- Test 294: statement (line 2791)
ALTER TABLE b2 SET (schema_locked=false)

-- Test 295: statement (line 2794)
ALTER TABLE b1 SET (schema_locked=false)

-- Test 296: statement (line 2797)
ALTER TABLE a SET (schema_locked=false)

-- Test 297: statement (line 2800)
TRUNCATE c3, c2, c1, b2, b1, a;

-- Test 298: statement (line 2803)
ALTER TABLE c3 RESET (schema_locked)

-- Test 299: statement (line 2806)
ALTER TABLE c2 RESET (schema_locked)

-- Test 300: statement (line 2809)
ALTER TABLE c1 RESET (schema_locked)

-- Test 301: statement (line 2812)
ALTER TABLE b2 RESET (schema_locked)

-- Test 302: statement (line 2815)
ALTER TABLE b1 RESET (schema_locked)

-- Test 303: statement (line 2818)
ALTER TABLE a RESET (schema_locked)

-- Test 304: statement (line 2822)
DROP TABLE c3, c2, c1, b2, b1, a;

-- Test 305: statement (line 2859)
INSERT INTO a VALUES ('a-pk1'), ('a-default');
INSERT INTO b1 VALUES ('b1-pk1', 'a-pk1'), ('b1-pk2', 'a-pk1'), ('b1-default', 'a-default');
INSERT INTO b2 VALUES ('b2-pk1', 'a-pk1'), ('b2-pk2', 'a-pk1'), ('b2-default', 'a-default');
INSERT INTO c1 VALUES
  ('c1-pk1-b1-pk1', 'b1-pk1')
 ,('c1-pk2-b1-pk1', 'b1-pk1')
 ,('c1-pk3-b1-pk2', 'b1-pk2')
 ,('c1-pk4-b1-pk2', 'b1-pk2')
;
INSERT INTO c2 VALUES
  ('c2-pk1-b1-pk1', 'b1-pk1')
 ,('c2-pk2-b1-pk1', 'b1-pk1')
 ,('c2-pk3-b1-pk2', 'b1-pk2')
 ,('c2-pk4-b1-pk2', 'b1-pk2')
;
INSERT INTO c3 VALUES
  ('c3-pk1-b2-pk1', 'b2-pk1')
 ,('c3-pk2-b2-pk1', 'b2-pk1')
 ,('c3-pk3-b2-pk2', 'b2-pk2')
 ,('c3-pk4-b2-pk2', 'b2-pk2')
;

-- Test 306: statement (line 2885)
DELETE FROM a WHERE id = 'a-pk1';

-- Test 307: statement (line 2889)
DROP TABLE c3, c2, c1, b2, b1, a;

-- Test 308: statement (line 2914)
INSERT INTO a VALUES ('delete-me'), ('untouched'), ('default');
INSERT INTO b VALUES ('b1', 'delete-me'), ('b2', 'untouched');
INSERT INTO c VALUES
  ('c1-b1', 'delete-me')
 ,('c2-b1', 'delete-me')
 ,('c3-b2', 'untouched')
 ,('c4-b2', 'untouched')
;

-- Test 309: statement (line 2924)
DELETE FROM a WHERE id = 'delete-me';

-- Test 310: query (line 2927)
SELECT id FROM a;

-- Test 311: query (line 2933)
SELECT id, a_id FROM b
UNION ALL
  SELECT id, b_a_id FROM c
;

-- Test 312: statement (line 2947)
DROP TABLE c, b, a;

-- Test 313: statement (line 2972)
INSERT INTO a VALUES ('delete-me'), ('untouched');
INSERT INTO b VALUES ('b1', 'delete-me'), ('b2', 'untouched');
INSERT INTO c VALUES
  ('c1-b1', 'delete-me')
 ,('c2-b1', 'delete-me')
 ,('c3-b2', 'untouched')
 ,('c4-b2', 'untouched')
;

-- Test 314: statement (line 2983)
DELETE FROM a WHERE id = 'delete-me';

-- Test 315: query (line 2986)
SELECT id, a_id FROM b
UNION ALL
  SELECT id, b_a_id FROM c
;

-- Test 316: statement (line 3000)
DROP TABLE c, b, a;

-- Test 317: statement (line 3025)
INSERT INTO a VALUES ('delete-me'), ('untouched');
INSERT INTO b VALUES ('b1', 'delete-me'), ('b2', 'untouched');
INSERT INTO c VALUES
  ('c1-b1', 'delete-me')
 ,('c2-b1', 'delete-me')
 ,('c3-b2', 'untouched')
 ,('c4-b2', 'untouched')
;

-- Test 318: statement (line 3037)
DELETE FROM a WHERE id = 'delete-me';

-- Test 319: statement (line 3041)
DROP TABLE c, b, a;

-- Test 320: statement (line 3059)
INSERT INTO a VALUES ('original'), ('default');
INSERT INTO b VALUES ('b1', 'original'), ('b2', 'default');

-- Test 321: statement (line 3063)
DELETE FROM a WHERE id = 'original';

-- Test 322: statement (line 3067)
DROP TABLE b, a;

-- Test 323: statement (line 3098)
INSERT INTO a VALUES ('original'), ('untouched'), ('b1-default'), ('b2-default'), ('b3-default'), ('b4-default');
INSERT INTO b1 VALUES ('b1-pk1', 'untouched'), ('b1-pk2', 'untouched');
INSERT INTO b2 VALUES ('b2-pk1', 'untouched'), ('b2-pk2', 'original');
INSERT INTO b3 VALUES ('b3-pk1', 'original'), ('b3-pk2', 'untouched');
INSERT INTO b3 VALUES ('b4-pk1', 'original'), ('b4-pk2', 'original');

-- Test 324: statement (line 3106)
UPDATE a SET id = 'updated' WHERE id = 'original';

-- Test 325: query (line 3109)
SELECT id, update_set_null FROM b1
UNION ALL
  SELECT id, update_set_null FROM b2
UNION ALL
  SELECT id, update_set_null FROM b3
UNION ALL
  SELECT id, update_set_null FROM b4
;

-- Test 326: statement (line 3129)
DROP TABLE b4, b3, b2, b1, a;

-- Test 327: statement (line 3160)
INSERT INTO a VALUES ('original'), ('untouched'), ('b1-default'), ('b2-default'), ('b3-default'), ('b4-default');
INSERT INTO b1 VALUES ('b1-pk1', 'untouched'), ('b1-pk2', 'untouched');
INSERT INTO b2 VALUES ('b2-pk1', 'untouched'), ('b2-pk2', 'original');
INSERT INTO b3 VALUES ('b3-pk1', 'original'), ('b3-pk2', 'untouched');
INSERT INTO b3 VALUES ('b4-pk1', 'original'), ('b4-pk2', 'original');

-- Test 328: statement (line 3168)
UPDATE a SET id = 'updated' WHERE id = 'original';

-- Test 329: statement (line 3172)
DROP TABLE b4, b3, b2, b1, a;

-- Test 330: statement (line 3208)
INSERT INTO a VALUES ('original'), ('untouched'), ('b1-default'), ('b2-default');
INSERT INTO b1 VALUES ('b1-pk1', 'original'), ('b1-pk2', 'untouched'), ('b1-default', 'b1-default');
INSERT INTO b2 VALUES ('b2-pk1', 'original'), ('b2-pk2', 'untouched'), ('b2-default', 'b2-default');
INSERT INTO c1 VALUES
  ('c1-pk1-b1-pk1', 'original')
 ,('c1-pk2-b1-pk1', 'original')
 ,('c1-pk3-b1-pk2', 'untouched')
 ,('c1-pk4-b1-pk2', 'untouched')
;
INSERT INTO c2 VALUES
  ('c2-pk1-b1-pk1', 'original')
 ,('c2-pk2-b1-pk1', 'original')
 ,('c2-pk3-b1-pk2', 'untouched')
 ,('c2-pk4-b1-pk2', 'untouched')
;
INSERT INTO c3 VALUES
  ('c3-pk1-b2-pk1', 'original')
 ,('c3-pk2-b2-pk1', 'original')
 ,('c3-pk3-b2-pk2', 'untouched')
 ,('c3-pk4-b2-pk2', 'untouched')
;

-- Test 331: statement (line 3233)
UPDATE a SET id = 'updated' WHERE id = 'original';

-- Test 332: query (line 3236)
SELECT id, update_cascade FROM b1
UNION ALL
  SELECT id, update_cascade FROM b2
UNION ALL
  SELECT id, update_set_null FROM c1
UNION ALL
  SELECT id, update_set_null FROM c2
UNION ALL
  SELECT id, update_set_null FROM c3
;

-- Test 333: statement (line 3268)
DROP TABLE c3, c2, c1, b2, b1, a;

-- Test 334: statement (line 3304)
INSERT INTO a VALUES ('original'), ('untouched'), ('b1-default'), ('b2-default');
INSERT INTO b1 VALUES ('b1-pk1', 'original'), ('b1-pk2', 'untouched'), ('b1-default', 'b1-default');
INSERT INTO b2 VALUES ('b2-pk1', 'original'), ('b2-pk2', 'untouched'), ('b2-default', 'b2-default');
INSERT INTO c1 VALUES
  ('c1-pk1-b1-pk1', 'original')
 ,('c1-pk2-b1-pk1', 'original')
 ,('c1-pk3-b1-pk2', 'untouched')
 ,('c1-pk4-b1-pk2', 'untouched')
;
INSERT INTO c2 VALUES
  ('c2-pk1-b1-pk1', 'original')
 ,('c2-pk2-b1-pk1', 'original')
 ,('c2-pk3-b1-pk2', 'untouched')
 ,('c2-pk4-b1-pk2', 'untouched')
;
INSERT INTO c3 VALUES
  ('c3-pk1-b2-pk1', 'original')
 ,('c3-pk2-b2-pk1', 'original')
 ,('c3-pk3-b2-pk2', 'untouched')
 ,('c3-pk4-b2-pk2', 'untouched')
;

-- Test 335: statement (line 3329)
UPDATE a SET id = 'updated' WHERE id = 'original';

-- Test 336: statement (line 3333)
DROP TABLE c3, c2, c1, b2, b1, a;

-- Test 337: statement (line 3358)
INSERT INTO a VALUES ('original'), ('untouched'), ('default');
INSERT INTO b VALUES ('b1', 'original'), ('b2', 'untouched');
INSERT INTO c VALUES
  ('c1-b1', 'original')
 ,('c2-b1', 'original')
 ,('c3-b2', 'untouched')
 ,('c4-b2', 'untouched')
;

-- Test 338: statement (line 3368)
UPDATE a SET id = 'updated' WHERE id = 'original';

-- Test 339: query (line 3371)
SELECT id, a_id FROM b
UNION ALL
  SELECT id, b_a_id FROM c

-- Test 340: statement (line 3384)
DROP TABLE c, b, a;

-- Test 341: statement (line 3410)
INSERT INTO a VALUES ('original'), ('untouched'), ('default');
INSERT INTO b VALUES ('b1', 'original'), ('b2', 'untouched');
INSERT INTO c VALUES
  ('c1-b1', 'original')
 ,('c2-b1', 'original')
 ,('c3-b2', 'untouched')
 ,('c4-b2', 'untouched')
;

-- Test 342: statement (line 3420)
UPDATE a SET id = 'updated' WHERE id = 'original';

-- Test 343: statement (line 3424)
DROP TABLE c, b, a;

-- Test 344: statement (line 3442)
INSERT INTO a VALUES ('original'), ('default');
INSERT INTO b VALUES ('b1', 'original'), ('b2', 'default');

-- Test 345: statement (line 3446)
UPDATE a SET id = 'updated' WHERE id = 'original';

-- Test 346: statement (line 3450)
DROP TABLE b, a;

-- Test 347: statement (line 3456)
CREATE TABLE IF NOT EXISTS example (
  a INT UNIQUE,
  b INT REFERENCES example (a) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Test 348: statement (line 3462)
INSERT INTO example VALUES (20, NULL);
INSERT INTO example VALUES (30, 20);
INSERT INTO example VALUES (NULL, 30);

-- Test 349: statement (line 3467)
DELETE FROM example where a = 30;

-- Test 350: query (line 3470)
SELECT * FROM example;

-- Test 351: statement (line 3477)
DROP TABLE example;

-- Test 352: statement (line 3483)
CREATE TABLE a (
  x INT
 ,y INT
 ,UNIQUE (x, y)
);

-- Test 353: statement (line 3490)
CREATE TABLE b (
  x INT
 ,y INT
 ,INDEX (x, y)
 ,FOREIGN KEY (x, y) REFERENCES a (x, y) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Test 354: statement (line 3498)
INSERT INTO a VALUES (NULL, NULL), (NULL, 1), (2, NULL), (3, 3);
INSERT INTO b VALUES (NULL, NULL), (NULL, 1), (2, NULL), (3, 3);

-- Test 355: query (line 3503)
SELECT * FROM b ORDER BY x, y;

-- Test 356: statement (line 3513)
DELETE FROM a;

-- Test 357: query (line 3517)
SELECT * FROM b ORDER BY x, y;

-- Test 358: query (line 3526)
SELECT * FROM a ORDER BY x;

-- Test 359: statement (line 3531)
ALTER TABLE b SET (schema_locked=false);

-- Test 360: statement (line 3534)
ALTER TABLE a SET (schema_locked=false);

-- Test 361: statement (line 3538)
TRUNCATE b, a;
INSERT INTO a VALUES (NULL, NULL), (NULL, 4), (5, NULL), (6, 6);
INSERT INTO b VALUES (NULL, NULL), (NULL, 4), (5, NULL), (6, 6);

-- Test 362: statement (line 3543)
ALTER TABLE b RESET (schema_locked);

-- Test 363: statement (line 3546)
ALTER TABLE a RESET (schema_locked);

-- Test 364: statement (line 3550)
UPDATE a SET y = y*10 WHERE y > 0;
UPDATE a SET x = x*10 WHERE x > 0;

-- Test 365: query (line 3554)
SELECT * FROM b ORDER BY x, y;

-- Test 366: statement (line 3564)
DROP TABLE b, a;

-- Test 367: statement (line 3570)
CREATE TABLE a (
  x INT
 ,y INT
 ,UNIQUE (x, y)
);

-- Test 368: statement (line 3577)
CREATE TABLE b (
  x INT
 ,y INT
 ,INDEX (x, y)
 ,FOREIGN KEY (x, y) REFERENCES a (x, y) MATCH FULL ON DELETE CASCADE ON UPDATE CASCADE
);

-- Test 369: statement (line 3585)
INSERT INTO a VALUES (NULL, NULL), (NULL, 1), (2, NULL), (3, 3);
INSERT INTO b VALUES (NULL, NULL), (3, 3);

-- Test 370: query (line 3590)
SELECT * FROM b ORDER BY x, y;

-- Test 371: statement (line 3598)
DELETE FROM a;

-- Test 372: query (line 3602)
SELECT * FROM b ORDER BY x, y;

-- Test 373: query (line 3609)
SELECT * FROM a ORDER BY x;

-- Test 374: statement (line 3614)
ALTER TABLE b SET (schema_locked=false);

-- Test 375: statement (line 3617)
ALTER TABLE a SET (schema_locked=false);

-- Test 376: statement (line 3621)
TRUNCATE b, a;
INSERT INTO a VALUES (NULL, NULL), (NULL, 4), (5, NULL), (6, 6);
INSERT INTO b VALUES (NULL, NULL), (6, 6);

-- Test 377: statement (line 3626)
ALTER TABLE b RESET (schema_locked);

-- Test 378: statement (line 3629)
ALTER TABLE a RESET (schema_locked);

-- Test 379: statement (line 3633)
UPDATE a SET y = y*10 WHERE y > 0;
UPDATE a SET x = x*10 WHERE x > 0;

-- Test 380: query (line 3637)
SELECT * FROM b ORDER BY x, y;

-- Test 381: statement (line 3645)
DROP TABLE b, a;

-- Test 382: statement (line 3652)
CREATE TABLE a (
  x INT
 ,y INT
 ,UNIQUE (x, y)
);

-- Test 383: statement (line 3659)
CREATE TABLE b (
  x INT DEFAULT 1
 ,y INT DEFAULT NULL
 ,UNIQUE (x, y)
 ,FOREIGN KEY (x, y) REFERENCES a (x, y) MATCH SIMPLE ON DELETE SET DEFAULT ON UPDATE SET DEFAULT
);

-- Test 384: statement (line 3667)
CREATE TABLE c (
  x INT
 ,y INT
 ,UNIQUE (x, y)
 ,FOREIGN KEY (x, y) REFERENCES b (x, y) MATCH FULL ON UPDATE CASCADE
);

-- Test 385: statement (line 3675)
INSERT INTO a VALUES (2,2);
INSERT INTO b VALUES (2,2);
INSERT INTO c VALUES (2,2);

-- Test 386: statement (line 3681)
DELETE FROM a;

-- Test 387: statement (line 3685)
UPDATE a SET x = 3 WHERE x = 2;

-- Test 388: query (line 3689)
SELECT * from a;

-- Test 389: statement (line 3695)
DROP TABLE c, b, a;

-- Test 390: statement (line 3700)
CREATE TABLE a (
  x INT
 ,y INT
 ,UNIQUE (x, y)
);

-- Test 391: statement (line 3707)
CREATE TABLE b (
  x INT
 ,y INT
 ,UNIQUE (x, y)
 ,FOREIGN KEY (x, y) REFERENCES a (x, y) MATCH SIMPLE ON DELETE SET NULL ON UPDATE CASCADE
);

-- Test 392: statement (line 3715)
CREATE TABLE c (
  x INT
 ,y INT
 ,UNIQUE (x, y)
 ,FOREIGN KEY (x, y) REFERENCES b (x, y) MATCH FULL ON UPDATE CASCADE
);

-- Test 393: statement (line 3723)
INSERT INTO a VALUES (2,2), (3,3);
INSERT INTO b VALUES (2,2), (3,3);
INSERT INTO c VALUES (2,2), (3,3);

-- Test 394: statement (line 3729)
DELETE FROM a WHERE x = 2;

-- Test 395: statement (line 3733)
UPDATE a SET x = NULL WHERE x = 3;

-- Test 396: statement (line 3736)
UPDATE a SET y = NULL WHERE y = 3;

-- Test 397: statement (line 3740)
UPDATE a SET x = NULL, y = NULL WHERE x = 3;

-- Test 398: query (line 3743)
SELECT * from c;

-- Test 399: statement (line 3750)
DROP TABLE c, b, a;

-- Test 400: statement (line 3757)
CREATE TABLE self_ab (
  a INT UNIQUE,
  b INT DEFAULT 1 CHECK (b != 1),
  INDEX (b)
)

-- Test 401: statement (line 3764)
INSERT INTO self_ab VALUES (1, 2), (2, 2)

-- Test 402: statement (line 3767)
ALTER TABLE self_ab ADD CONSTRAINT fk FOREIGN KEY (b) REFERENCES self_ab (a) ON UPDATE SET DEFAULT

-- Test 403: statement (line 3772)
UPDATE self_ab SET a = 3 WHERE a = 2

-- Test 404: statement (line 3776)
CREATE TABLE self_ab_parent (p INT PRIMARY KEY)

-- Test 405: statement (line 3779)
INSERT INTO self_ab_parent VALUES (1), (2)

-- Test 406: statement (line 3782)
ALTER TABLE self_ab ADD CONSTRAINT fk2 FOREIGN KEY (a) REFERENCES self_ab_parent (p) ON UPDATE CASCADE

-- Test 407: statement (line 3785)
UPDATE self_ab_parent SET p = 3 WHERE p = 2

-- Test 408: statement (line 3789)
DROP TABLE self_ab, self_ab_parent

-- Test 409: statement (line 3795)
CREATE TABLE self_abcd (
  a INT DEFAULT 2,
  b INT DEFAULT 2,
  c INT DEFAULT 2,
  d INT DEFAULT 2,
  INDEX (c),
  INDEX (d),
  PRIMARY KEY (a), FAMILY (a, b, c, d)
)

-- Test 410: statement (line 3806)
INSERT INTO self_abcd VALUES (1, 2, 3, 4), (4, 1, 2, 3), (3, 4, 1, 2), (2, 3, 4, 1)

-- Test 411: statement (line 3809)
ALTER TABLE self_abcd ADD CONSTRAINT fk1 FOREIGN KEY (c) REFERENCES self_abcd(a) ON UPDATE SET DEFAULT;
ALTER TABLE self_abcd ADD CONSTRAINT fk2 FOREIGN KEY (d) REFERENCES self_abcd(a) ON UPDATE SET DEFAULT

-- Test 412: statement (line 3813)
UPDATE self_abcd SET a = 5 WHERE a = 1

-- Test 413: query (line 3816)
SELECT * FROM self_abcd ORDER BY (a, b, c, d)

-- Test 414: statement (line 3825)
DROP TABLE self_abcd

-- Test 415: statement (line 3830)
CREATE TABLE parent (pk INT PRIMARY KEY, p INT UNIQUE)

-- Test 416: statement (line 3833)
CREATE TABLE child (pk INT PRIMARY KEY, p INT REFERENCES parent(p) ON UPDATE CASCADE)

-- Test 417: statement (line 3836)
INSERT INTO parent VALUES (1, 1), (2, 2);
INSERT INTO child VALUES (1, 1), (2, 1), (3, 2), (4, 2)

-- Test 418: statement (line 3840)
UPSERT INTO parent VALUES (2, 20), (3, 3)

-- Test 419: query (line 3843)
SELECT * FROM child

-- Test 420: statement (line 3851)
INSERT INTO parent VALUES (1, 1), (4, 4) ON CONFLICT (pk) DO UPDATE SET p = parent.pk * 10

-- Test 421: query (line 3854)
SELECT * FROM child

-- Test 422: statement (line 3862)
INSERT INTO parent VALUES (100, 20) ON CONFLICT(p) DO UPDATE SET p = 50

-- Test 423: query (line 3865)
SELECT * FROM child

-- Test 424: statement (line 3873)
DROP TABLE child, parent

-- Test 425: statement (line 3878)
CREATE TABLE parent (pk INT PRIMARY KEY, p INT, q INT, UNIQUE (p,q))

-- Test 426: statement (line 3881)
CREATE TABLE child (pk INT PRIMARY KEY, p INT, q INT, CONSTRAINT fk FOREIGN KEY (p,q) REFERENCES parent(p,q) ON UPDATE CASCADE)

-- Test 427: statement (line 3884)
INSERT INTO parent VALUES (1, 1, 1), (2, 2, 2);
INSERT INTO child VALUES (1, 1, 1), (2, 1, 1), (3, 2, 2), (4, 2, 2)

-- Test 428: statement (line 3888)
UPSERT INTO parent(pk, p) VALUES (1, 1)

-- Test 429: query (line 3891)
SELECT * FROM child

-- Test 430: statement (line 3899)
UPSERT INTO parent(pk, q) VALUES (2, 20)

-- Test 431: query (line 3902)
SELECT * FROM child

-- Test 432: statement (line 3910)
UPSERT INTO parent VALUES (1, 10, 10)

-- Test 433: query (line 3913)
SELECT * FROM child

-- Test 434: statement (line 3921)
DROP TABLE child, parent

-- Test 435: statement (line 3926)
CREATE TABLE parent (pk INT PRIMARY KEY, p INT UNIQUE)

-- Test 436: statement (line 3929)
CREATE TABLE child (pk INT PRIMARY KEY, p INT REFERENCES parent(p) ON UPDATE SET NULL)

-- Test 437: statement (line 3932)
INSERT INTO parent VALUES (1, 1), (2, 2);
INSERT INTO child VALUES (1, 1), (2, 1), (3, 2), (4, 2)

-- Test 438: statement (line 3936)
UPSERT INTO parent VALUES (2, 20), (3, 3)

-- Test 439: query (line 3939)
SELECT * FROM child

-- Test 440: statement (line 3948)
UPSERT INTO parent VALUES (1, 1)

-- Test 441: query (line 3951)
SELECT * FROM child

-- Test 442: statement (line 3961)
UPSERT INTO parent(pk) VALUES (1)

-- Test 443: query (line 3964)
SELECT * FROM child

-- Test 444: statement (line 3972)
INSERT INTO parent VALUES (100, 1) ON CONFLICT(p) DO UPDATE SET p = 50

-- Test 445: query (line 3975)
SELECT * FROM child

-- Test 446: statement (line 3983)
DROP TABLE child, parent

-- Test 447: statement (line 3988)
CREATE TABLE parent (pk INT PRIMARY KEY, p INT UNIQUE)

-- Test 448: statement (line 3991)
CREATE TABLE child (pk INT PRIMARY KEY, p INT DEFAULT 1 REFERENCES parent(p) ON UPDATE SET DEFAULT)

-- Test 449: statement (line 3994)
INSERT INTO parent VALUES (1, 1), (2, 2);
INSERT INTO child VALUES (1, 1), (2, 1), (3, 2), (4, 2)

-- Test 450: statement (line 3999)
UPSERT INTO parent VALUES (2, 2)

-- Test 451: query (line 4002)
SELECT * FROM child

-- Test 452: statement (line 4012)
UPSERT INTO parent(pk) VALUES (2)

-- Test 453: query (line 4015)
SELECT * FROM child

-- Test 454: statement (line 4023)
UPSERT INTO parent VALUES (2, 20), (3, 3)

-- Test 455: query (line 4026)
SELECT * FROM child

-- Test 456: statement (line 4034)
INSERT INTO parent VALUES (100, 1) ON CONFLICT(p) DO UPDATE SET p = 50

-- Test 457: statement (line 4037)
DROP TABLE child, parent

-- Test 458: statement (line 4043)
SET autocommit_before_ddl = false

-- Test 459: statement (line 4046)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
CREATE TABLE parent (p INT, q INT, PRIMARY KEY(p,q));
CREATE TABLE child (
  p INT, q INT,
  FOREIGN KEY (p,q) REFERENCES parent(p,q) ON DELETE CASCADE
);
INSERT INTO parent VALUES (1,1), (1,2), (2,2), (3,3);
INSERT INTO child VALUES
  (NULL, NULL),
  (NULL, 1),
  (NULL, 2),
  (NULL, 3),
  (1,    NULL),
  (2,    NULL),
  (3,    NULL),
  (1,    1),
  (1,    1),
  (1,    2),
  (2,    2),
  (2,    2),
  (3,    3),
  (3,    3);
COMMIT;

-- Test 460: statement (line 4071)
RESET autocommit_before_ddl

-- Test 461: statement (line 4074)
DELETE FROM parent WHERE p = 1

-- Test 462: query (line 4077)
SELECT * FROM child

-- Test 463: statement (line 4092)
DELETE FROM parent WHERE q = 2

-- Test 464: query (line 4095)
SELECT * FROM child

-- Test 465: statement (line 4108)
DELETE FROM parent WHERE true

-- Test 466: query (line 4111)
SELECT * FROM child

-- Test 467: statement (line 4122)
DROP TABLE child, parent

-- Test 468: statement (line 4130)
SET autocommit_before_ddl = false

-- Test 469: statement (line 4133)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
CREATE TABLE parent (a INT PRIMARY KEY, b INT);
CREATE TABLE child (a INT PRIMARY KEY, p_a INT NOT NULL REFERENCES parent(a) ON DELETE CASCADE);
INSERT INTO parent VALUES (1, 2), (3, 4);
INSERT INTO child VALUES (1, 1), (3, 3);
COMMIT;

-- Test 470: statement (line 4141)
RESET autocommit_before_ddl

-- Test 471: statement (line 4144)
PREPARE del AS DELETE FROM parent WHERE a = $1

-- Test 472: statement (line 4147)
EXECUTE del (1)

-- Test 473: query (line 4150)
SELECT * FROM parent

-- Test 474: query (line 4155)
SELECT * FROM child

-- Test 475: statement (line 4160)
DROP TABLE child, parent

-- Test 476: statement (line 4165)
CREATE TABLE a (a INT UNIQUE);
CREATE TABLE b (b INT, FOREIGN KEY (b) REFERENCES a (a) ON DELETE CASCADE);

-- Test 477: statement (line 4169)
DELETE FROM a WHERE EXISTS (SELECT a FROM a)

-- Test 478: statement (line 4172)
SET autocommit_before_ddl = false

-- Test 479: statement (line 4176)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
CREATE TABLE users (
  user_id INT PRIMARY KEY,
  region UUID NOT NULL,
  UNIQUE (region, user_id),
  CHECK (region IN ('00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000002'))
);
CREATE TABLE posts (
  user_id INT NOT NULL,
  region UUID NOT NULL,
  post_id INT NOT NULL,
  PRIMARY KEY (region, user_id, post_id),
  FOREIGN KEY (region, user_id) REFERENCES users (region, user_id) ON UPDATE CASCADE
);
INSERT INTO users (user_id, region) VALUES (1, '00000000-0000-0000-0000-000000000001');
INSERT INTO posts (user_id, region, post_id) VALUES (1, '00000000-0000-0000-0000-000000000001', 1);
COMMIT;

-- Test 480: statement (line 4195)
RESET autocommit_before_ddl

-- Test 481: statement (line 4198)
UPDATE users SET region = '00000000-0000-0000-0000-000000000002' WHERE user_id = 1;

