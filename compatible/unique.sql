-- PostgreSQL compatible tests from unique
-- 180 tests

-- Test 1: statement (line 8)
CREATE TABLE uniq (
  k INT PRIMARY KEY,
  v INT UNIQUE,
  w INT UNIQUE WITHOUT INDEX,
  x INT,
  y INT DEFAULT 5,
  UNIQUE WITHOUT INDEX (x, y)
)

-- Test 2: statement (line 18)
CREATE TABLE uniq_overlaps_pk (
  a INT,
  b INT,
  c INT,
  d INT,
  PRIMARY KEY (a, b),
  UNIQUE WITHOUT INDEX (b, c),
  UNIQUE WITHOUT INDEX (a, b, d),
  UNIQUE WITHOUT INDEX (a),
  UNIQUE WITHOUT INDEX (c, d)
)

-- Test 3: statement (line 31)
CREATE TABLE uniq_hidden_pk (
  a INT,
  b INT,
  c INT,
  d INT,
  UNIQUE WITHOUT INDEX (b, c),
  UNIQUE WITHOUT INDEX (a, b, d),
  UNIQUE WITHOUT INDEX (a)
)

-- Test 4: statement (line 42)
CREATE TABLE uniq_fk_parent (
  a INT UNIQUE,
  b INT,
  c INT,
  d INT UNIQUE WITHOUT INDEX,
  e INT UNIQUE WITHOUT INDEX,
  UNIQUE WITHOUT INDEX (b, c)
)

-- Test 5: statement (line 52)
CREATE TABLE uniq_fk_child (
  a INT,
  b INT,
  c INT,
  d INT REFERENCES uniq_fk_parent (d),
  e INT REFERENCES uniq_fk_parent (e) ON DELETE SET NULL,
  FOREIGN KEY (b, c) REFERENCES uniq_fk_parent (b, c) ON UPDATE CASCADE,
  UNIQUE WITHOUT INDEX (c)
)

-- Test 6: statement (line 63)
CREATE TABLE uniq_partial (
  a INT,
  UNIQUE WITHOUT INDEX (a) WHERE b > 0
)

-- Test 7: statement (line 69)
CREATE TABLE uniq_partial (
  a INT,
  b INT,
  UNIQUE WITHOUT INDEX (a) WHERE b > 0
)

-- Test 8: statement (line 76)
CREATE TABLE uniq_partial_pk (
  k INT PRIMARY KEY,
  a INT,
  b INT,
  UNIQUE WITHOUT INDEX (a) WHERE b > 0
)

-- Test 9: statement (line 84)
CREATE TYPE region AS ENUM ('us-east', 'us-west', 'eu-west')

-- Test 10: statement (line 118)
CREATE TABLE uniq_uuid (
  id1 UUID,
  id2 UUID,
  UNIQUE WITHOUT INDEX (id1),
  UNIQUE WITHOUT INDEX (id2)
)

-- Test 11: statement (line 126)
CREATE TABLE other (k INT, v INT, w INT NOT NULL, x INT, y INT, u UUID)

-- Test 12: statement (line 130)
INSERT INTO other VALUES (10, 10, 1, 1, 1, '8597b0eb-7b89-4857-858a-fabf86f6a3ac')

-- Test 13: statement (line 138)
INSERT INTO uniq VALUES (1, 1, 1, 1, 1), (2, 2, 2, 2, 2)

-- Test 14: statement (line 142)
INSERT INTO uniq VALUES (1, 1, 1, 1, 1)

-- Test 15: statement (line 146)
INSERT INTO uniq VALUES (3, 1, 1, 1, 1)

-- Test 16: statement (line 150)
INSERT INTO uniq VALUES (3, 3, 3, 3, 3), (4, 4, 3, 3, 3)

-- Test 17: statement (line 153)
INSERT INTO uniq VALUES (3, 3, 1, 1, 1)

-- Test 18: statement (line 156)
INSERT INTO uniq VALUES (3, 3, 3, 1, 1)

-- Test 19: statement (line 160)
INSERT INTO uniq VALUES (3, 3, 3, 3, 1)

-- Test 20: statement (line 165)
INSERT INTO uniq VALUES (4, 4, NULL, NULL, 1), (5, 5, NULL, 2, NULL), (6, 6, NULL, NULL, 1), (7, 7, NULL, 2, NULL)

-- Test 21: statement (line 169)
INSERT INTO uniq SELECT k, v, w, x, y FROM other

-- Test 22: statement (line 174)
INSERT INTO uniq VALUES (100, 10, 1), (200, 20, 2), (400, 40, 4) ON CONFLICT (w) DO NOTHING

-- Test 23: statement (line 180)
INSERT INTO uniq VALUES (500, 50, 50), (600, 50, 50) ON CONFLICT (w) DO NOTHING

-- Test 24: statement (line 185)
INSERT INTO uniq VALUES (1, 20, 20, 20, 20), (20, 1, 20, 20, 20), (20, 20, 20, 20, 20),
                        (20, 20, 1, 20, 20), (20, 20, 20, 1, 1) ON CONFLICT DO NOTHING

-- Test 25: query (line 189)
SELECT * FROM uniq

-- Test 26: statement (line 207)
INSERT INTO uniq_overlaps_pk VALUES (1, 1, 1, 1), (2, 2, 2, 2)

-- Test 27: statement (line 210)
INSERT INTO uniq_overlaps_pk VALUES (1, 2, 3, 4)

-- Test 28: statement (line 213)
INSERT INTO uniq_overlaps_pk VALUES (3, 1, 1, 3)

-- Test 29: statement (line 216)
INSERT INTO uniq_overlaps_pk VALUES (3, 3, 1, 1)

-- Test 30: statement (line 219)
INSERT INTO uniq_overlaps_pk VALUES (3, 3, 1, 3)

-- Test 31: query (line 222)
SELECT * FROM uniq_overlaps_pk

-- Test 32: statement (line 232)
INSERT INTO uniq_hidden_pk VALUES (1, 1, 1, 1), (2, 2, 2, 2)

-- Test 33: statement (line 236)
INSERT INTO uniq_hidden_pk SELECT k, w, x, y FROM other

-- Test 34: query (line 239)
SELECT * FROM uniq_hidden_pk

-- Test 35: statement (line 248)
INSERT INTO uniq_fk_parent VALUES (1, 1, 1, 1, 1), (2, 2, 2, 2, 2);
INSERT INTO uniq_fk_child VALUES (1, 1, 1, 1, 1), (2, 2, 2, 2, 2)

-- Test 36: statement (line 253)
INSERT INTO uniq_fk_child VALUES (1, 1, 1), (2, 2, 2)

-- Test 37: statement (line 257)
INSERT INTO uniq_fk_child VALUES (3, 3, 3), (4, 4, 4)

-- Test 38: statement (line 261)
INSERT INTO uniq_fk_child VALUES (1, 1, 2), (4, 2, 2)

-- Test 39: query (line 264)
SELECT * FROM uniq_fk_child

-- Test 40: statement (line 274)
INSERT INTO uniq_enum VALUES ('us-west', 'foo', 1, 1), ('eu-west', 'bar', 2, 2)

-- Test 41: statement (line 280)
INSERT INTO uniq_enum (s, i) VALUES ('foo', 1), ('bar', 3)

-- Test 42: query (line 283)
SELECT * FROM uniq_enum

-- Test 43: statement (line 293)
INSERT INTO uniq_partial VALUES (1, 1), (1, -1), (2, 2)

-- Test 44: statement (line 297)
INSERT INTO uniq_partial VALUES (1, 3)

-- Test 45: statement (line 301)
INSERT INTO uniq_partial VALUES (1, -3)

-- Test 46: statement (line 305)
INSERT INTO uniq_partial VALUES (3, 3), (3, 4)

-- Test 47: statement (line 310)
INSERT INTO uniq_partial VALUES (1, 3), (3, 3)

-- Test 48: statement (line 314)
INSERT INTO uniq_partial VALUES (NULL, 5), (5, 5), (NULL, 5)

-- Test 49: statement (line 318)
INSERT INTO uniq_partial SELECT w, x FROM other

-- Test 50: statement (line 321)
INSERT INTO uniq_partial VALUES (1, 6), (6, 6) ON CONFLICT (a) DO NOTHING

-- Test 51: statement (line 326)
INSERT INTO uniq_partial VALUES (1, 6), (6, 6) ON CONFLICT (a) WHERE b > 0 DO NOTHING

-- Test 52: statement (line 332)
INSERT INTO uniq_partial VALUES (7, 7), (7, 8), (7, -7) ON CONFLICT (a) WHERE b > 0 DO NOTHING

-- Test 53: statement (line 337)
INSERT INTO uniq_partial VALUES (1, 9), (9, 9), (9, 9), (9, -9) ON CONFLICT DO NOTHING

-- Test 54: statement (line 342)
INSERT INTO uniq_partial SELECT w, k FROM other ON CONFLICT DO NOTHING

-- Test 55: query (line 345)
SELECT * FROM uniq_partial

-- Test 56: statement (line 365)
INSERT INTO uniq_computed_pk (i, s, d) VALUES (1, 'a', 1.0), (2, 'b', 2.0)

-- Test 57: statement (line 368)
INSERT INTO uniq_computed_pk (i, s, d) VALUES (1, 'c', 3.0)

-- Test 58: statement (line 371)
INSERT INTO uniq_computed_pk (i, s, d) VALUES (3, 'b', 3.0)

-- Test 59: statement (line 374)
INSERT INTO uniq_computed_pk (i, s, d) VALUES (3, 'c', 1.00)

-- Test 60: query (line 377)
SELECT * FROM uniq_computed_pk

-- Test 61: statement (line 385)
INSERT INTO uniq_uuid (id1, id2) SELECT gen_random_uuid(), '8597b0eb-7b89-4857-858a-fabf86f6a3ac'

-- Test 62: statement (line 390)
INSERT INTO uniq_uuid (id1, id2) SELECT gen_random_uuid(), u FROM other

-- Test 63: statement (line 398)
UPDATE uniq SET w = 1, x = 2 WHERE k = 1

-- Test 64: statement (line 401)
UPDATE uniq SET w = 1, x = 2 WHERE k = 2

-- Test 65: statement (line 405)
UPDATE uniq SET w = 100, x = 200

-- Test 66: statement (line 409)
UPDATE uniq SET k = 10, v = 10, w = 10, x = NULL WHERE k = 2

-- Test 67: statement (line 413)
INSERT INTO uniq VALUES (2, 2, 2, 2, 2)

-- Test 68: statement (line 418)
UPDATE uniq SET k = 11, v = 11 WHERE k = 10

-- Test 69: query (line 421)
SELECT * FROM uniq

-- Test 70: statement (line 440)
UPDATE uniq_overlaps_pk SET a = 1, b = 2, c = 3, d = 4 WHERE a = 5

-- Test 71: statement (line 443)
UPDATE uniq_overlaps_pk SET a = 1, b = 2, c = 3, d = 4 WHERE a = 3

-- Test 72: query (line 446)
SELECT * FROM uniq_overlaps_pk

-- Test 73: statement (line 456)
UPDATE uniq_hidden_pk SET a = k FROM other

-- Test 74: query (line 459)
SELECT * FROM uniq_hidden_pk

-- Test 75: statement (line 469)
UPDATE uniq_fk_parent SET c = 1

-- Test 76: statement (line 473)
UPDATE uniq_fk_parent SET d = 3 WHERE a = 2

-- Test 77: statement (line 478)
UPDATE uniq_fk_child SET b = 2, c = 2

-- Test 78: query (line 481)
SELECT * FROM uniq_fk_child

-- Test 79: statement (line 491)
UPDATE uniq_enum SET r = DEFAULT, s = 'foo', j = 1 WHERE r = 'eu-west'

-- Test 80: query (line 494)
SELECT * FROM uniq_enum

-- Test 81: statement (line 502)
UPDATE uniq_partial SET a = 1 WHERE a = 1 AND b = 1

-- Test 82: statement (line 506)
UPDATE uniq_partial SET a = 1 WHERE a = 2

-- Test 83: statement (line 510)
UPDATE uniq_partial SET b = 10 WHERE a = 1 AND b = -1

-- Test 84: statement (line 514)
UPDATE uniq_partial SET a = NULL, b = 10 WHERE a = 1 AND b = -1

-- Test 85: statement (line 518)
UPDATE uniq_partial SET a = 10 WHERE a IS NULL AND b = 5

-- Test 86: statement (line 522)
UPDATE uniq_partial SET a = 10 WHERE a = 9 AND b = 9

-- Test 87: statement (line 526)
UPDATE uniq_partial SET a = 1 WHERE b = -7

-- Test 88: query (line 529)
SELECT * FROM uniq_partial

-- Test 89: statement (line 549)
UPDATE uniq_computed_pk SET i = 1 WHERE i = 2

-- Test 90: statement (line 552)
UPDATE uniq_computed_pk SET s = 'a' WHERE i = 2

-- Test 91: statement (line 555)
UPDATE uniq_computed_pk SET d = 1.00 WHERE i = 2

-- Test 92: query (line 558)
SELECT * FROM uniq_computed_pk

-- Test 93: statement (line 570)
UPSERT INTO uniq VALUES (1, 1, 1, 1, 1), (3, 3, 3, 3, 3), (5, 5, 5, 5, 5), (8, 8, 8, 8, 8)

-- Test 94: statement (line 574)
UPSERT INTO uniq VALUES (3, 3, 3, 3, 3), (4, 4, 3, 3, 3)

-- Test 95: statement (line 578)
UPSERT INTO uniq VALUES (3, 3, 1, 1, 1)

-- Test 96: statement (line 582)
UPSERT INTO uniq VALUES (9, 9, 9, 1, 1)

-- Test 97: statement (line 586)
UPSERT INTO uniq VALUES (3, 3, 3, 3, 2)

-- Test 98: statement (line 591)
UPSERT INTO uniq VALUES (8, 8, NULL, NULL, 1), (9, 9, NULL, 1, NULL)

-- Test 99: statement (line 595)
UPSERT INTO uniq (k, v, w, x) VALUES (5, 5, NULL, 5), (10, 10, NULL, 5)

-- Test 100: statement (line 599)
UPSERT INTO uniq (k, v) VALUES (5, 5), (10, 10)

-- Test 101: statement (line 605)
INSERT INTO uniq VALUES (1), (2) ON CONFLICT (k) DO UPDATE SET w = excluded.w + 1 WHERE uniq.v = 1

-- Test 102: statement (line 610)
INSERT INTO uniq SELECT k, v FROM other ON CONFLICT (v) DO UPDATE SET w = uniq.k + 1

-- Test 103: statement (line 614)
INSERT INTO uniq SELECT k, v FROM other ON CONFLICT (v) DO UPDATE SET w = 5

-- Test 104: statement (line 618)
INSERT INTO uniq SELECT k, v FROM other ON CONFLICT (v) DO UPDATE SET x = 5

-- Test 105: statement (line 623)
INSERT INTO uniq VALUES (100, 100, 1), (200, 200, 2) ON CONFLICT (w) DO UPDATE SET w = 10

-- Test 106: statement (line 628)
INSERT INTO uniq VALUES (100, 100, 1), (200, 200, 2) ON CONFLICT (w) DO UPDATE SET w = 12

-- Test 107: statement (line 633)
INSERT INTO uniq (k, v, x, y) VALUES (200, 200, 5, 5) ON CONFLICT (x, y) DO UPDATE SET w = 13, y = excluded.y + 1

-- Test 108: query (line 636)
SELECT * FROM uniq

-- Test 109: statement (line 660)
UPSERT INTO uniq_overlaps_pk VALUES (1, 1, 1, 1), (2, 2, 2, 2)

-- Test 110: statement (line 663)
UPSERT INTO uniq_overlaps_pk VALUES (1, 2, 3, 4)

-- Test 111: statement (line 666)
UPSERT INTO uniq_overlaps_pk VALUES (3, 1, 1, 3)

-- Test 112: statement (line 669)
UPSERT INTO uniq_overlaps_pk VALUES (3, 3, 1, 1)

-- Test 113: statement (line 672)
UPSERT INTO uniq_overlaps_pk VALUES (3, 3, 1, 4)

-- Test 114: statement (line 676)
UPSERT INTO uniq_overlaps_pk (a, b, d) SELECT k, v, x FROM other

-- Test 115: statement (line 681)
UPSERT INTO uniq_overlaps_pk SELECT k, v, x FROM other

-- Test 116: statement (line 686)
UPSERT INTO uniq_overlaps_pk (a, b, d) SELECT k, v, x FROM other

-- Test 117: query (line 689)
SELECT * FROM uniq_overlaps_pk

-- Test 118: statement (line 700)
UPSERT INTO uniq_hidden_pk SELECT k, w, x, y FROM other

-- Test 119: query (line 703)
SELECT * FROM uniq_hidden_pk

-- Test 120: statement (line 713)
INSERT INTO uniq_fk_parent VALUES (2, 1) ON CONFLICT (a) DO UPDATE SET c = 1

-- Test 121: statement (line 717)
UPSERT INTO uniq_fk_child VALUES (2, 1, 1)

-- Test 122: query (line 720)
SELECT * FROM uniq_fk_child

-- Test 123: statement (line 731)
UPSERT INTO uniq_enum VALUES ('us-west', 'foo', 1, 1), ('us-east', 'bar', 2, 2)

-- Test 124: query (line 734)
SELECT * FROM uniq_enum

-- Test 125: statement (line 744)
UPSERT INTO uniq_partial_pk VALUES (1, 1, 1), (2, 2, 2), (3, 1, -1)

-- Test 126: statement (line 748)
UPSERT INTO uniq_partial_pk VALUES (4, 1, 1)

-- Test 127: statement (line 752)
UPSERT INTO uniq_partial_pk VALUES (3, 1, 1)

-- Test 128: statement (line 756)
UPSERT INTO uniq_partial_pk VALUES (4, 1, -1)

-- Test 129: statement (line 760)
UPSERT INTO uniq_partial_pk VALUES (2, 1, -1)

-- Test 130: query (line 763)
SELECT * FROM uniq_partial_pk

-- Test 131: statement (line 775)
DELETE FROM uniq_partial;

-- Test 132: statement (line 778)
INSERT INTO uniq_partial VALUES (1, 1), (2, 2), (1, -1)

-- Test 133: statement (line 782)
INSERT INTO uniq_partial VALUES (3, 3), (1, -2) ON CONFLICT (a) WHERE b > 0 DO UPDATE SET b = -10

-- Test 134: statement (line 786)
INSERT INTO uniq_partial VALUES (4, 4), (3, 30) ON CONFLICT (a) WHERE b > 0 DO UPDATE SET b = 33

-- Test 135: statement (line 790)
INSERT INTO uniq_partial VALUES (5, 5), (5, 50) ON CONFLICT (a) WHERE b > 0 DO UPDATE SET b = 33

-- Test 136: statement (line 794)
INSERT INTO uniq_partial VALUES (4, 40) ON CONFLICT (a) WHERE b > 0 DO UPDATE SET a = 1

-- Test 137: statement (line 798)
INSERT INTO uniq_partial VALUES (4, 40) ON CONFLICT (a) WHERE b > 0 DO UPDATE SET a = 1, b = -40

-- Test 138: query (line 801)
SELECT * FROM uniq_partial

-- Test 139: statement (line 814)
CREATE TABLE uniq_partial_index_and_constraint (
  i INT,
  UNIQUE WITHOUT INDEX (i),
  UNIQUE INDEX (i) WHERE i > 0
)

-- Test 140: statement (line 821)
INSERT INTO uniq_partial_index_and_constraint VALUES (-1) ON CONFLICT (i) WHERE i > 0 DO UPDATE SET i = 1;
INSERT INTO uniq_partial_index_and_constraint VALUES (-1) ON CONFLICT (i) WHERE i > 0 DO UPDATE SET i = 2

-- Test 141: query (line 825)
SELECT * FROM uniq_partial_index_and_constraint

-- Test 142: statement (line 834)
INSERT INTO uniq_computed_pk (i, s, d) VALUES (1, 'a', 1.0) ON CONFLICT (s) DO UPDATE SET i = 2

-- Test 143: statement (line 837)
UPSERT INTO uniq_computed_pk (i, s, d) VALUES (3, 'b', 3.0)

-- Test 144: statement (line 840)
UPSERT INTO uniq_computed_pk (i, s, d) VALUES (3, 'c', 2.00)

-- Test 145: query (line 843)
SELECT * FROM uniq_computed_pk

-- Test 146: statement (line 858)
DELETE FROM uniq_fk_parent WHERE a = 2

-- Test 147: statement (line 861)
UPDATE uniq_fk_child SET b = NULL WHERE a = 2

-- Test 148: statement (line 865)
DELETE FROM uniq_fk_parent WHERE a = 2

-- Test 149: statement (line 868)
UPDATE uniq_fk_child SET d = NULL WHERE a = 2

-- Test 150: statement (line 872)
DELETE FROM uniq_fk_parent WHERE a = 2

-- Test 151: query (line 875)
SELECT * FROM uniq_fk_child

-- Test 152: statement (line 886)
SELECT b FROM uniq_hidden_pk GROUP BY a

-- Test 153: statement (line 891)
SELECT x FROM uniq GROUP BY v

-- Test 154: query (line 896)
SELECT r, i FROM uniq_enum GROUP BY i

-- Test 155: statement (line 903)
ALTER TABLE uniq_hidden_pk ALTER COLUMN b SET NOT NULL

-- Test 156: statement (line 908)
SELECT a FROM uniq_hidden_pk GROUP BY b, c

-- Test 157: statement (line 911)
ALTER TABLE uniq_hidden_pk ALTER COLUMN c SET NOT NULL

-- Test 158: query (line 916)
SELECT a,d FROM uniq_hidden_pk GROUP BY b, c

-- Test 159: statement (line 925)
SELECT a FROM uniq_hidden_pk GROUP BY b

-- Test 160: statement (line 930)
SELECT x FROM uniq GROUP BY v

-- Test 161: statement (line 933)
ALTER TABLE uniq ALTER COLUMN v SET NOT NULL

-- Test 162: query (line 938)
SELECT x FROM uniq GROUP BY v ORDER BY v

-- Test 163: statement (line 960)
CREATE TABLE t1 (
  pk int PRIMARY KEY,
  pk2 int,
  a int,
  b int,
  j JSON,
  INDEX (a),
  UNIQUE WITHOUT INDEX(b, a),
  INDEX (b,a) STORING(pk2, j),
  INVERTED INDEX (j),
  FAMILY (pk, pk2, a, b)
)

-- Test 164: statement (line 974)
INSERT INTO t1 (pk, pk2, a, b, j) VALUES
   (0, 0, 1, 3, '{"a": "b"}');

-- Test 165: statement (line 979)
INSERT INTO t1 (pk, pk2, a, b, j) VALUES
   (2, 2, 1, 3, '{"a": "b"}'), (4, 5, 6, 7, '{"a": "b"}');

-- Test 166: statement (line 983)
CREATE TABLE multiple_uniq (
  a INT,
  b INT,
  c INT,
  d INT,
  UNIQUE WITHOUT INDEX (b, c),
  UNIQUE WITHOUT INDEX (a, b, d),
  UNIQUE WITHOUT INDEX (a),
  INDEX (a, b, d),
  INDEX (b, c),
  FAMILY (a),
  FAMILY (b),
  FAMILY (c),
  FAMILY (d)
)

-- Test 167: statement (line 1001)
INSERT INTO multiple_uniq
VALUES (1,2,3,4), (5,6,7,8)

-- Test 168: statement (line 1007)
INSERT INTO multiple_uniq
VALUES (1,12,13,14), (15,16,17,18)

-- Test 169: statement (line 1013)
INSERT INTO multiple_uniq (a,c,b,d)
VALUES (11,3,2,14), (15,16,17,18)

-- Test 170: statement (line 1017)
PREPARE p1 AS INSERT INTO multiple_uniq
VALUES ($1, $1, $1, $1), ($2, $2, $2, $2)

-- Test 171: statement (line 1023)
EXECUTE p1(1, 2)

-- Test 172: statement (line 1026)
ALTER TABLE multiple_uniq ADD CONSTRAINT uniq_fk FOREIGN KEY (d) REFERENCES uniq (k) ON DELETE CASCADE;

-- Test 173: statement (line 1032)
INSERT INTO multiple_uniq (a,b,c,d)
VALUES (11,12,13,14), (15,16,17,18)

-- Test 174: statement (line 1037)
CREATE TABLE t115377 (
  k INT,
  a INT,
  b INT,
  s TEXT NOT NULL,
  PRIMARY KEY (s, k),
  UNIQUE WITHOUT INDEX (k),
  UNIQUE (s, a, b),
  UNIQUE WITHOUT INDEX (a, b),
  CHECK (s IN ('east', 'west'))
)

-- Test 175: statement (line 1050)
INSERT INTO t115377 VALUES (2, 0, 0, 'east')

-- Test 176: statement (line 1053)
INSERT INTO t115377 VALUES (2, 1, 1, 'east')

-- Test 177: statement (line 1057)
CREATE TABLE t126988 (
  k INT PRIMARY KEY,
  j INT,
  i INT,
  v INT AS (i) VIRTUAL,
  UNIQUE WITHOUT INDEX (i, j),
  INDEX (j, v) STORING (i)
)

-- Test 178: statement (line 1067)
INSERT INTO t126988 VALUES (1, 10, 200)

-- Test 179: statement (line 1070)
INSERT INTO t126988 VALUES (1, 10, 200)

-- Test 180: query (line 1090)
SELECT id, a, b FROM t123103;

