-- PostgreSQL compatible tests from computed
-- 254 tests

-- Test 1: statement (line 6)
CREATE TABLE with_no_column_refs (
  a INT,
  b INT,
  c INT AS (3) STORED,
  FAMILY "primary" (a, b, c, rowid)
)

onlyif config schema-locked-disabled

-- Test 2: query (line 15)
SHOW CREATE TABLE with_no_column_refs

-- Test 3: query (line 27)
SHOW CREATE TABLE with_no_column_refs

-- Test 4: query (line 39)
SHOW CREATE TABLE with_no_column_refs WITH REDACT

-- Test 5: query (line 51)
SHOW CREATE TABLE with_no_column_refs WITH REDACT

-- Test 6: statement (line 62)
CREATE TABLE extra_parens (
  a INT,
  b INT,
  c INT AS ((3)) STORED,
  FAMILY "primary" (a, b, c, rowid)
)

onlyif config schema-locked-disabled

-- Test 7: query (line 71)
SHOW CREATE TABLE extra_parens

-- Test 8: query (line 83)
SHOW CREATE TABLE extra_parens

-- Test 9: statement (line 94)
INSERT INTO with_no_column_refs VALUES (1, 2, 3)

-- Test 10: statement (line 97)
INSERT INTO with_no_column_refs (SELECT 1, 2, 3)

-- Test 11: statement (line 100)
INSERT INTO with_no_column_refs (a, c) (SELECT 1, 3)

-- Test 12: statement (line 103)
INSERT INTO with_no_column_refs (c) VALUES (1)

-- Test 13: statement (line 106)
INSERT INTO with_no_column_refs (a, b) VALUES (1, 2)

-- Test 14: statement (line 109)
INSERT INTO with_no_column_refs VALUES (1, 2)

-- Test 15: statement (line 112)
UPDATE with_no_column_refs SET c = 1

-- Test 16: statement (line 115)
UPDATE with_no_column_refs SET (a, b, c) = (1, 2, 3)

-- Test 17: statement (line 118)
UPDATE with_no_column_refs SET (a, b, c) = (SELECT 1, 2, 3)

-- Test 18: query (line 121)
SELECT c FROM with_no_column_refs

-- Test 19: statement (line 127)
CREATE TABLE x (
  a INT DEFAULT 3,
  b INT DEFAULT 7,
  c INT AS (a) STORED,
  d INT AS (a + b) STORED,
  FAMILY "primary" (a, b, c, d, rowid)
)

onlyif config schema-locked-disabled

-- Test 20: query (line 137)
SHOW CREATE TABLE x

-- Test 21: query (line 150)
SHOW CREATE TABLE x

-- Test 22: query (line 162)
SELECT * FROM  [SHOW COLUMNS FROM x] ORDER BY column_name

-- Test 23: statement (line 172)
INSERT INTO x (c) VALUES (1)

-- Test 24: statement (line 175)
INSERT INTO x (a, b) VALUES (1, 2)

-- Test 25: query (line 178)
SELECT c, d FROM x

-- Test 26: statement (line 183)
DELETE FROM x

-- Test 27: statement (line 186)
DELETE FROM x

-- Test 28: statement (line 189)
DROP TABLE x

-- Test 29: statement (line 192)
CREATE TABLE x (
  a INT NOT NULL,
  b INT,
  c INT AS (a) STORED,
  d INT AS (a + b) STORED
)

-- Test 30: statement (line 200)
INSERT INTO x (a) VALUES (1)

-- Test 31: statement (line 203)
INSERT INTO x (b) VALUES (1)

-- Test 32: query (line 206)
SELECT c, d FROM x

-- Test 33: statement (line 211)
DROP TABLE x

-- Test 34: statement (line 215)
CREATE TABLE x (
  a INT PRIMARY KEY,
  b INT,
  c INT AS (b + 1) STORED,
  d INT AS (b - 1) STORED
)

-- Test 35: statement (line 223)
INSERT INTO x (a, b) VALUES (1, 1) ON CONFLICT (a) DO UPDATE SET b = excluded.b + 1

-- Test 36: query (line 226)
SELECT c, d FROM x

-- Test 37: statement (line 231)
INSERT INTO x (a, b) VALUES (1, 1) ON CONFLICT (a) DO UPDATE SET b = excluded.b + 1

-- Test 38: query (line 234)
SELECT a, b, c, d FROM x

-- Test 39: statement (line 239)
INSERT INTO x (a, b) VALUES (1, 1) ON CONFLICT (a) DO UPDATE SET b = x.b + 1

-- Test 40: query (line 242)
SELECT a, b, c FROM x

-- Test 41: statement (line 249)
UPDATE x SET b = 3

-- Test 42: query (line 252)
SELECT a, b, c FROM x

-- Test 43: statement (line 259)
UPDATE x SET b = c

-- Test 44: query (line 262)
SELECT a, b, c FROM x

-- Test 45: statement (line 269)
UPDATE x SET (b, c) = (1, DEFAULT)

-- Test 46: statement (line 274)
UPSERT INTO x (a, b) VALUES (1, 2)

-- Test 47: query (line 277)
SELECT a, b, c, d FROM x

-- Test 48: statement (line 282)
ALTER TABLE x SET (schema_locked=false)

-- Test 49: statement (line 285)
TRUNCATE x

-- Test 50: statement (line 288)
ALTER TABLE x RESET (schema_locked)

-- Test 51: statement (line 294)
UPSERT INTO x VALUES (2, 3)

-- Test 52: query (line 297)
SELECT a, b, c, d FROM x

-- Test 53: statement (line 302)
ALTER TABLE x SET (schema_locked=false)

-- Test 54: statement (line 305)
TRUNCATE x

-- Test 55: statement (line 308)
ALTER TABLE x RESET (schema_locked)

-- Test 56: statement (line 311)
UPSERT INTO x VALUES (2, 3, 12)

-- Test 57: statement (line 314)
UPSERT INTO x (a, b) VALUES (2, 3)

-- Test 58: query (line 317)
SELECT a, b, c, d FROM x

-- Test 59: statement (line 322)
DROP TABLE x

-- Test 60: statement (line 347)
CREATE TABLE y (
  a INT AS 3 STORED
)

-- Test 61: statement (line 352)
CREATE TABLE y (
  a INT AS (3)
)

-- Test 62: statement (line 357)
CREATE TABLE tmp (x INT)

-- Test 63: statement (line 360)
DROP TABLE tmp

-- Test 64: statement (line 376)
CREATE TABLE x (
  a INT
)

-- Test 65: statement (line 384)
DROP TABLE x

-- Test 66: statement (line 387)
CREATE TABLE y (
  a TIMESTAMP AS (now()) STORED
)

-- Test 67: statement (line 413)
CREATE TABLE y (
  a TIMESTAMPTZ,
  b TIMESTAMP AS (a::TIMESTAMP) STORED
)

-- Test 68: statement (line 419)
CREATE TABLE y (
  a TIMESTAMPTZ,
  b INTERVAL,
  c TIMESTAMPTZ AS (a+ b) STORED
)

-- Test 69: statement (line 431)
CREATE TABLE y (
  a INT AS (3) STORED,
  b INT AS (a) STORED
)

-- Test 70: statement (line 437)
CREATE TABLE y (
  b INT AS (a) STORED
)

-- Test 71: statement (line 442)
CREATE TABLE y (
  b INT AS (count(1)) STORED
)

-- Test 72: statement (line 447)
CREATE TABLE y (
  a INT AS (3) STORED DEFAULT 4
)

-- Test 73: statement (line 452)
CREATE TABLE x (a INT PRIMARY KEY)

-- Test 74: statement (line 455)
CREATE TABLE y (
  r INT AS (1) STORED REFERENCES x (a)
);

-- Test 75: statement (line 460)
DROP TABLE y;

-- Test 76: statement (line 463)
CREATE TABLE y (
  r INT AS (1) STORED REFERENCES x
);

-- Test 77: statement (line 468)
DROP TABLE y;

-- Test 78: statement (line 471)
CREATE TABLE y (
  a INT,
  r INT AS (1) STORED REFERENCES x
);

-- Test 79: statement (line 477)
DROP TABLE y;

-- Test 80: statement (line 483)
CREATE TABLE p (p INT PRIMARY KEY)

-- Test 81: statement (line 486)
CREATE TABLE c_update (
  p_cascade INT REFERENCES p (p) ON UPDATE CASCADE,
  p_default INT DEFAULT 0 REFERENCES p (p) ON UPDATE SET DEFAULT,
  p_null INT REFERENCES p (p) ON UPDATE SET NULL,
  c_cascade INT AS (p_cascade + 100) STORED,
  c_default INT AS (p_default) STORED,
  c_null INT AS (p_null + 100) STORED
)

-- Test 82: statement (line 496)
CREATE TABLE c_delete_cascade (
  p_cascade INT REFERENCES p (p) ON DELETE CASCADE,
  c_cascade INT AS (p_cascade + 100) STORED
)

-- Test 83: statement (line 502)
CREATE TABLE c_delete_set (
  p_default INT DEFAULT 0 REFERENCES p (p) ON DELETE SET DEFAULT,
  p_null INT REFERENCES p (p) ON DELETE SET NULL,
  c_default INT AS (p_default) STORED,
  c_null INT AS (p_null + 100) STORED
)

-- Test 84: statement (line 510)
INSERT INTO p VALUES (0), (1), (2), (3)

-- Test 85: statement (line 513)
INSERT INTO c_update VALUES (1, 1, 1), (2, 2, 2)

-- Test 86: statement (line 516)
UPDATE p SET p = 10 WHERE p = 1

-- Test 87: query (line 519)
SELECT * FROM c_update

-- Test 88: statement (line 526)
INSERT INTO c_delete_cascade VALUES (2), (3);
INSERT INTO c_delete_set VALUES (2, 2), (3, 3);

-- Test 89: statement (line 530)
DELETE FROM p WHERE p = 3

-- Test 90: query (line 533)
SELECT * FROM c_delete_cascade

-- Test 91: query (line 539)
SELECT * FROM c_delete_set

-- Test 92: statement (line 547)
CREATE TABLE tt (i INT8 AS (1) STORED)

-- Test 93: statement (line 553)
ALTER TABLE tt ADD COLUMN c INT8 AS (i) STORED

-- Test 94: statement (line 558)
CREATE TABLE xx (
  a INT,
  b INT,
  UNIQUE (a, b)
);

-- Test 95: statement (line 565)
INSERT INTO xx VALUES (3,3);

-- Test 96: statement (line 568)
CREATE TABLE yy (
  x INT,
  y INT AS (3) STORED,
  FOREIGN KEY (x, y) REFERENCES xx (a, b)
);

-- Test 97: statement (line 575)
INSERT INTO yy VALUES (3);

-- Test 98: statement (line 578)
INSERT INTO yy VALUES (4);

-- Test 99: statement (line 581)
CREATE TABLE uu (x INT, y INT AS (3) STORED, FOREIGN KEY (x, y) REFERENCES xx (a, b) ON UPDATE CASCADE);

-- Test 100: statement (line 584)
CREATE TABLE uu (x INT, y INT AS (3) STORED, FOREIGN KEY (x, y) REFERENCES xx (a, b) ON UPDATE SET NULL);

-- Test 101: statement (line 587)
CREATE TABLE uu (x INT, y INT AS (3) STORED, FOREIGN KEY (x, y) REFERENCES xx (a, b) ON UPDATE SET DEFAULT);

-- Test 102: statement (line 590)
CREATE TABLE uu (x INT, y INT AS (3) STORED, FOREIGN KEY (x, y) REFERENCES xx (a, b) ON UPDATE SET DEFAULT ON DELETE SET NULL);

-- Test 103: statement (line 593)
CREATE TABLE uu (x INT, y INT AS (3) STORED, FOREIGN KEY (x, y) REFERENCES xx (a, b) ON DELETE SET NULL);

-- Test 104: statement (line 596)
CREATE TABLE uu (x INT, y INT AS (3) STORED, FOREIGN KEY (x, y) REFERENCES xx (a, b) ON DELETE SET DEFAULT);

-- Test 105: statement (line 599)
CREATE TABLE uu (x INT, y INT AS (3) STORED, FOREIGN KEY (x, y) REFERENCES xx (a, b) ON DELETE CASCADE);

-- Test 106: statement (line 602)
DROP TABLE uu;

-- Test 107: statement (line 605)
DROP TABLE yy;

-- Test 108: statement (line 608)
DROP TABLE xx;

-- Test 109: statement (line 611)
CREATE TABLE aa (
  a INT,
  b INT,
  UNIQUE (a, b)
);

-- Test 110: statement (line 618)
INSERT INTO aa VALUES (3,3);

-- Test 111: statement (line 621)
CREATE TABLE bb (
  x INT,
  y INT AS (3) STORED,
  FOREIGN KEY (y, x) REFERENCES aa (a, b)
);

-- Test 112: statement (line 628)
INSERT INTO bb VALUES (3);

-- Test 113: statement (line 631)
INSERT INTO bb VALUES (4);

-- Test 114: statement (line 634)
DROP TABLE bb;

-- Test 115: statement (line 637)
DROP TABLE aa;

-- Test 116: statement (line 640)
CREATE TABLE y (
  r INT AS (1) STORED,
  INDEX (r)
);

-- Test 117: statement (line 646)
ALTER TABLE y ADD FOREIGN KEY (r) REFERENCES x (a);

-- Test 118: statement (line 649)
DROP TABLE y;

-- Test 119: statement (line 652)
CREATE TABLE y (
  r INT AS ((SELECT 1)) STORED
)

-- Test 120: statement (line 657)
CREATE TABLE y (
  r INT AS (x.a) STORED
)

-- Test 121: statement (line 662)
CREATE TABLE y (
  q INT,
  r INT AS (x.q) STORED
)

-- Test 122: statement (line 668)
CREATE TABLE y (
  q INT,
  r INT AS (y.q) STORED
)

-- Test 123: statement (line 674)
DROP TABLE y

-- Test 124: statement (line 678)
CREATE TABLE y (
  q INT REFERENCES x (a) ON UPDATE CASCADE,
  r INT AS (3) STORED
)

-- Test 125: statement (line 684)
DROP TABLE y

-- Test 126: statement (line 687)
DROP TABLE x

-- Test 127: statement (line 691)
CREATE TABLE x (
  k INT PRIMARY KEY,
  a JSON,
  b TEXT AS (a->>'q') STORED,
  INDEX (b)
)

-- Test 128: statement (line 699)
INSERT INTO x (k, a, b) VALUES (1, '{"q":"xyz"}', 'not allowed!'), (2, '{"q":"abc"}', 'also not allowed')

-- Test 129: statement (line 702)
UPDATE x SET (k, a, b) = (1, '{"q":"xyz"}', 'not allowed!')

-- Test 130: statement (line 705)
INSERT INTO x (k, a) VALUES (1, '{"q":"xyz"}'), (2, '{"q":"abc"}')

-- Test 131: query (line 708)
SELECT k, b FROM x ORDER BY b

-- Test 132: statement (line 714)
DROP TABLE x

-- Test 133: statement (line 717)
CREATE TABLE x (
  k INT AS ((data->>'id')::INT) STORED PRIMARY KEY,
  data JSON
)

-- Test 134: statement (line 723)
INSERT INTO x (data) VALUES
 ('{"id": 1, "name": "lucky"}'),
 ('{"id": 2, "name": "rascal"}'),
 ('{"id": 3, "name": "captain"}'),
 ('{"id": 4, "name": "lola"}')

-- Test 135: statement (line 731)
INSERT INTO x (data) VALUES ('{"id": 1, "name": "ernie"}')
ON CONFLICT (k) DO UPDATE SET data = '{"id": 5, "name": "ernie"}'

-- Test 136: statement (line 736)
INSERT INTO x (data) VALUES ('{"id": 5, "name": "oliver"}')
ON CONFLICT (k) DO UPDATE SET data = '{"id": 2, "name": "rascal"}'

-- Test 137: statement (line 741)
UPDATE x SET data = data || '{"name": "carl"}' WHERE k = 2

-- Test 138: query (line 744)
SELECT data->>'name' FROM x WHERE k = 2

-- Test 139: query (line 749)
SELECT data->>'name' FROM x WHERE k = 5

-- Test 140: statement (line 755)
create table y (
  a INT REFERENCES x (k)
)

-- Test 141: statement (line 760)
INSERT INTO y VALUES (5)

-- Test 142: statement (line 763)
INSERT INTO y VALUES (100)

-- Test 143: statement (line 766)
DROP TABLE x CASCADE

-- Test 144: statement (line 769)
CREATE TABLE x (
  a INT,
  b INT,
  c INT,
  d INT[] AS (ARRAY[a, b, c]) STORED
)

-- Test 145: statement (line 777)
INSERT INTO x (a, b, c) VALUES (1, 2, 3)

-- Test 146: query (line 780)
SELECT d FROM x

-- Test 147: statement (line 785)
ALTER TABLE x SET (schema_locked=false)

-- Test 148: statement (line 788)
TRUNCATE x

-- Test 149: statement (line 791)
ALTER TABLE x RESET (schema_locked)

-- Test 150: statement (line 796)
INSERT INTO x (b, a, c) VALUES (1, 2, 3)

-- Test 151: query (line 799)
SELECT d FROM x

-- Test 152: statement (line 805)
UPDATE x SET (c, a, b) = (1, 2, 3)

-- Test 153: query (line 808)
SELECT d FROM x

-- Test 154: statement (line 813)
UPDATE x SET (a, c) = (1, 2)

-- Test 155: query (line 816)
SELECT d FROM x

-- Test 156: statement (line 821)
UPDATE x SET c = 2, a = 3, b = 1

-- Test 157: query (line 824)
SELECT d FROM x

-- Test 158: statement (line 830)
INSERT INTO x (rowid) VALUES ((SELECT rowid FROM x)) ON CONFLICT(rowid) DO UPDATE SET (a, b, c) = (1, 2, 3)

-- Test 159: query (line 833)
SELECT d FROM x

-- Test 160: statement (line 838)
INSERT INTO x (rowid) VALUES ((SELECT rowid FROM x)) ON CONFLICT(rowid) DO UPDATE SET (c, a, b) = (1, 2, 3)

-- Test 161: query (line 841)
SELECT d FROM x

-- Test 162: statement (line 846)
INSERT INTO x (rowid) VALUES ((SELECT rowid FROM x)) ON CONFLICT(rowid) DO UPDATE SET (c, a) = (1, 2)

-- Test 163: query (line 849)
SELECT d FROM x

-- Test 164: statement (line 854)
DROP TABLE x

-- Test 165: statement (line 857)
CREATE TABLE x (
  a INT,
  b INT as (x.a) STORED,
  FAMILY "primary" (a, b, rowid)
)

onlyif config schema-locked-disabled

-- Test 166: query (line 865)
SHOW CREATE TABLE x

-- Test 167: query (line 876)
SHOW CREATE TABLE x

-- Test 168: statement (line 886)
DROP TABLE x

-- Test 169: statement (line 890)
CREATE TABLE x (
  a INT,
  b INT AS (a) STORED,
  FAMILY "primary" (a, b, rowid)
)

-- Test 170: statement (line 897)
ALTER TABLE x RENAME COLUMN a TO c

onlyif config schema-locked-disabled

-- Test 171: query (line 901)
SHOW CREATE TABLE x

-- Test 172: query (line 912)
SHOW CREATE TABLE x

-- Test 173: statement (line 922)
DROP TABLE x

-- Test 174: statement (line 925)
CREATE TABLE x (
  a INT,
  b INT AS (a * 2) STORED,
  FAMILY "primary" (a, b, rowid)
)

-- Test 175: query (line 932)
SELECT generation_expression FROM information_schema.columns
WHERE table_name = 'x' and column_name = 'b'

-- Test 176: query (line 939)
SELECT count(*) FROM information_schema.columns
WHERE table_name = 'x' and generation_expression = ''

-- Test 177: statement (line 945)
INSERT INTO x VALUES (3)

-- Test 178: statement (line 949)
ALTER TABLE x ADD COLUMN c INT NOT NULL AS (a + 4) STORED

onlyif config schema-locked-disabled

-- Test 179: query (line 953)
SHOW CREATE TABLE x

-- Test 180: query (line 965)
SHOW CREATE TABLE x

-- Test 181: query (line 977)
SHOW CREATE TABLE x WITH REDACT

-- Test 182: query (line 989)
SHOW CREATE TABLE x WITH REDACT

-- Test 183: statement (line 1000)
INSERT INTO x VALUES (6)

-- Test 184: query (line 1003)
SELECT * FROM x ORDER BY a

-- Test 185: statement (line 1010)
ALTER TABLE x SET (schema_locked=false);

-- Test 186: statement (line 1025)
ALTER TABLE x RESET (schema_locked);

-- Test 187: statement (line 1029)
ALTER TABLE x ADD COLUMN d INT AS (a + 'a') STORED

-- Test 188: statement (line 1032)
ALTER TABLE x ADD COLUMN d INT AS ('a') STORED

-- Test 189: statement (line 1035)
ALTER TABLE x ADD COLUMN d INT AS (a / 0) STORED

-- Test 190: statement (line 1039)
ALTER TABLE x ADD COLUMN d INT AS (a // 0) STORED

-- Test 191: statement (line 1042)
DROP TABLE x

-- Test 192: statement (line 1046)
CREATE TABLE x (
  a INT DEFAULT 1,
  b INT AS (2) STORED
)

-- Test 193: statement (line 1052)
INSERT INTO x (a) SELECT 1

-- Test 194: statement (line 1055)
DROP TABLE x

-- Test 195: statement (line 1058)
CREATE TABLE x (
  b INT AS (2) STORED,
  a INT DEFAULT 1
)

-- Test 196: statement (line 1064)
INSERT INTO x (a) SELECT 1

-- Test 197: statement (line 1067)
DROP TABLE x

-- Test 198: statement (line 1074)
INSERT INTO error_check VALUES(1, '1')

-- Test 199: statement (line 1077)
INSERT INTO error_check VALUES(2, 'foo')

-- Test 200: statement (line 1080)
UPDATE error_check SET s = 'foo' WHERE k = 1

-- Test 201: statement (line 1086)
UPSERT INTO error_check VALUES (1, 'foo')

-- Test 202: statement (line 1090)
UPSERT INTO error_check VALUES (3, 'foo')

-- Test 203: statement (line 1093)
CREATE TABLE x (
  a INT PRIMARY KEY,
  b INT AS (a+1) STORED
)

-- Test 204: statement (line 1099)
INSERT INTO x VALUES(1.4)

-- Test 205: query (line 1102)
SELECT * FROM x

-- Test 206: statement (line 1127)
CREATE TABLE t42418 (x INT GENERATED ALWAYS AS (1) STORED);

-- Test 207: statement (line 1130)
ALTER TABLE t42418 ADD COLUMN y INT GENERATED ALWAYS AS (1) STORED

onlyif config schema-locked-disabled

-- Test 208: query (line 1134)
SHOW CREATE t42418

-- Test 209: query (line 1145)
SHOW CREATE t42418

-- Test 210: query (line 1172)
SELECT create_statement FROM [SHOW CREATE TABLE trewrite]

-- Test 211: query (line 1184)
SELECT create_statement FROM [SHOW CREATE TABLE trewrite]

-- Test 212: statement (line 1195)
DROP TABLE trewrite

-- Test 213: statement (line 1198)
CREATE TABLE trewrite(k INT PRIMARY KEY, ts TIMESTAMPTZ, FAMILY (k,ts))

-- Test 214: query (line 1205)
SELECT create_statement FROM [SHOW CREATE TABLE trewrite]

-- Test 215: query (line 1217)
SELECT create_statement FROM [SHOW CREATE TABLE trewrite]

-- Test 216: statement (line 1231)
CREATE TABLE trewrite_copy (LIKE trewrite INCLUDING ALL)

onlyif config schema-locked-disabled

-- Test 217: query (line 1235)
SELECT create_statement FROM [SHOW CREATE TABLE trewrite_copy]

-- Test 218: query (line 1246)
SELECT create_statement FROM [SHOW CREATE TABLE trewrite_copy]

-- Test 219: statement (line 1256)
DROP TABLE trewrite

-- Test 220: statement (line 1259)
DROP TABLE trewrite_copy

-- Test 221: query (line 1283)
SELECT create_statement FROM [SHOW CREATE TABLE trewrite2]

-- Test 222: query (line 1300)
SELECT create_statement FROM [SHOW CREATE TABLE trewrite2]

-- Test 223: statement (line 1315)
DROP TABLE trewrite2

-- Test 224: query (line 1334)
SELECT * FROM t69327

-- Test 225: statement (line 1340)
ALTER TABLE t69327 ALTER COLUMN v SET DEFAULT 'foo'

-- Test 226: query (line 1353)
SELECT length(c), length(v) FROM t69665

-- Test 227: statement (line 1360)
CREATE TABLE t75907 (j JSONB);
INSERT INTO t75907 VALUES ('{"a": 1}');
ALTER TABLE t75907 ADD COLUMN c BOOL AS (j->'b' = '1') STORED

-- Test 228: query (line 1365)
SELECT j, c, j->'b' = '1' AS expected_c FROM t75907

-- Test 229: statement (line 1373)
CREATE TABLE t88128 (t TIME);
INSERT INTO t88128 VALUES ('10:00:00');
ALTER TABLE t88128 ADD COLUMN b1 BOOL as (t - '5 hrs'::INTERVAL < '23:00:00'::TIME) STORED;
ALTER TABLE t88128 ADD COLUMN b2 BOOL as (t + '5 hrs'::INTERVAL > '01:00:00'::TIME) STORED

-- Test 230: query (line 1379)
SELECT
  b1, t - '5 hrs'::INTERVAL < '23:00:00'::TIME AS expected_b1,
  b2, t + '5 hrs'::INTERVAL > '01:00:00'::TIME AS expected_b2
FROM t88128

-- Test 231: statement (line 1392)
CREATE TABLE foooooo (
    id INT PRIMARY KEY,
    x INT NOT NULL,
    y INT NOT NULL,
    gen INT AS (x + y) STORED
);

-- Test 232: statement (line 1400)
ALTER TABLE foooooo ALTER COLUMN gen SET DEFAULT 1;

-- Test 233: statement (line 1403)
ALTER TABLE foooooo ALTER COLUMN gen SET ON UPDATE 1;

-- Test 234: statement (line 1406)
ALTER TABLE foooooo ALTER COLUMN gen SET DEFAULT NULL;

-- Test 235: statement (line 1409)
ALTER TABLE foooooo ALTER COLUMN gen DROP DEFAULT;

-- Test 236: statement (line 1416)
CREATE TABLE t81698 (i INT PRIMARY KEY);

-- Test 237: statement (line 1419)
INSERT INTO t81698 VALUES (1);

skipif config local-legacy-schema-changer

-- Test 238: statement (line 1423)
ALTER TABLE t81698 ADD COLUMN s VARCHAR(2) AS (i || 'stored') STORED;

skipif config local-legacy-schema-changer

-- Test 239: statement (line 1427)
ALTER TABLE t81698 ADD COLUMN v VARCHAR(2) AS (i || 'virtual') VIRTUAL;

-- Test 240: statement (line 1441)
CREATE INDEX secondary_idx ON test_table (col_to_drop) STORING (other_col)

-- Test 241: statement (line 1447)
INSERT INTO test_table (id, col_to_drop, other_col) VALUES (1, 'test1', 100), (2, 'test2', 200)

-- Test 242: query (line 1450)
SELECT id, col_to_drop, computed_col FROM test_table

-- Test 243: statement (line 1464)
ALTER TABLE test_table DROP COLUMN computed_col

-- Test 244: statement (line 1467)
ALTER TABLE test_table DROP COLUMN col_to_drop CASCADE

-- Test 245: query (line 1470)
SELECT column_name FROM [SHOW COLUMNS FROM test_table] WHERE column_name != 'rowid'

-- Test 246: query (line 1477)
SELECT index_name FROM [SHOW INDEXES FROM test_table] WHERE index_name != 'test_table_pkey'

-- Test 247: query (line 1481)
SELECT * FROM test_table

-- Test 248: statement (line 1488)
DROP TABLE test_table

-- Test 249: statement (line 1502)
CREATE INDEX secondary_idx_virtual ON test_virtual (col_to_drop) STORING (other_col)

-- Test 250: statement (line 1508)
INSERT INTO test_virtual (id, col_to_drop, other_col) VALUES (1, 'virtual1', 300), (2, 'virtual2', 400)

-- Test 251: statement (line 1518)
ALTER TABLE test_virtual DROP COLUMN computed_col

-- Test 252: statement (line 1521)
ALTER TABLE test_virtual DROP COLUMN col_to_drop CASCADE

-- Test 253: query (line 1524)
SELECT column_name FROM [SHOW COLUMNS FROM test_virtual] WHERE column_name != 'rowid'

-- Test 254: statement (line 1530)
DROP TABLE test_virtual

