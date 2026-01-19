-- PostgreSQL compatible tests from partial_index
-- 450 tests

-- Test 1: statement (line 4)
CREATE TABLE t1 (a INT, INDEX (a) WHERE a = 0)

-- Test 2: statement (line 7)
CREATE TABLE t2 (a INT, INDEX (a) WHERE false)

-- Test 3: statement (line 11)
CREATE TABLE t3 (a INT, INDEX (a) WHERE abs(1) > 2)

-- Test 4: statement (line 15)
CREATE TABLE error (a INT, INDEX (a) WHERE 1)

-- Test 5: statement (line 19)
CREATE TABLE error (a INT, INDEX (a) WHERE b = 3)

-- Test 6: statement (line 24)
CREATE TABLE error (t TIMESTAMPTZ, INDEX (t) WHERE t < now())

-- Test 7: statement (line 30)
CREATE TABLE error (t TIMESTAMPTZ, i TIMESTAMP, INDEX (t) WHERE i = t)

-- Test 8: statement (line 33)
CREATE TABLE error (t FLOAT, INDEX (t) WHERE t < random())

-- Test 9: statement (line 37)
CREATE TABLE error (a INT, INDEX (a) WHERE count(*) = 1)

-- Test 10: statement (line 41)
CREATE TABLE error (a INT, INDEX (a) WHERE (SELECT true))

-- Test 11: statement (line 45)
CREATE TABLE error (a INT, INDEX (a) WHERE sum(a) > 1)

-- Test 12: statement (line 49)
CREATE TABLE error (a INT, INDEX (a) WHERE row_number() OVER () > 1)

-- Test 13: statement (line 53)
CREATE TABLE error (a INT, INDEX (a) WHERE generate_series(1, 1))

-- Test 14: statement (line 57)
CREATE TABLE error (a INT, INDEX (a) WHERE false - true)

-- Test 15: statement (line 61)
CREATE TABLE error (a INT, INDEX (a) WHERE t1.a > 0)

-- Test 16: statement (line 65)
CREATE TABLE error (a INT, INDEX (a) WHERE unknown.a > 0)

-- Test 17: statement (line 69)
CREATE TABLE error (a INT, INDEX (a) WHERE unknown.error.a > 9)

-- Test 18: statement (line 74)
CREATE TABLE t4 (a INT, UNIQUE INDEX (a) WHERE a = 0)

-- Test 19: statement (line 77)
CREATE TABLE error (a INT, UNIQUE INDEX (a) WHERE 1)

-- Test 20: statement (line 82)
CREATE TABLE t5 (a INT)

-- Test 21: statement (line 85)
CREATE INDEX t5i ON t5 (a) WHERE a = 0

-- Test 22: statement (line 89)
CREATE INDEX error ON t5 (a) WHERE 1

-- Test 23: statement (line 93)
CREATE INDEX error ON t5 (a) WHERE t4.a = 1

-- Test 24: statement (line 98)
CREATE TABLE t6 (
    a INT,
    INDEX (a) WHERE a > 0,
    INDEX (a) WHERE t6.a > 1,
    INDEX (a DESC) WHERE test.t6.a > 2,
    UNIQUE INDEX (a) WHERE a > 3,
    UNIQUE INDEX (a) WHERE t6.a > 4,
    UNIQUE INDEX (a DESC) WHERE test.t6.a > 5
)

-- Test 25: statement (line 109)
CREATE INDEX t6i1 ON t6 (a) WHERE a > 6;
CREATE INDEX t6i2 ON t6 (a) WHERE t6.a > 7;
CREATE INDEX t6i3 ON t6 (a DESC) WHERE test.t6.a > 8;

onlyif config schema-locked-disabled

-- Test 26: query (line 115)
SHOW CREATE TABLE t6

-- Test 27: query (line 134)
SHOW CREATE TABLE t6

-- Test 28: query (line 153)
SHOW CREATE TABLE t6 WITH REDACT

-- Test 29: query (line 172)
SHOW CREATE TABLE t6 WITH REDACT

-- Test 30: statement (line 192)
ALTER TABLE t6 RENAME COLUMN a TO b

onlyif config schema-locked-disabled

-- Test 31: query (line 196)
SHOW CREATE TABLE t6

-- Test 32: query (line 215)
SHOW CREATE TABLE t6

-- Test 33: statement (line 235)
ALTER TABLE t6 RENAME TO t7

onlyif config schema-locked-disabled

-- Test 34: query (line 239)
SHOW CREATE TABLE t7

-- Test 35: query (line 258)
SHOW CREATE TABLE t7

-- Test 36: statement (line 289)
ALTER TABLE t8 DROP COLUMN c

onlyif config schema-locked-disabled

-- Test 37: query (line 293)
SHOW CREATE TABLE t8

-- Test 38: query (line 308)
SHOW CREATE TABLE t8

-- Test 39: statement (line 325)
CREATE TABLE t9 (a INT, b INT, INDEX (a) WHERE b > 1)

-- Test 40: statement (line 328)
CREATE TABLE t10 (LIKE t9 INCLUDING INDEXES)

onlyif config schema-locked-disabled

-- Test 41: query (line 332)
SHOW CREATE TABLE t10

-- Test 42: query (line 345)
SHOW CREATE TABLE t10

-- Test 43: statement (line 358)
CREATE TABLE t11 (a INT, b INT, UNIQUE INDEX (a) WHERE b > 0)

-- Test 44: statement (line 361)
CREATE UNIQUE INDEX t11_b_key ON t11 (b) WHERE a > 0

-- Test 45: query (line 364)
SHOW CONSTRAINTS FROM t11

-- Test 46: statement (line 374)
CREATE TABLE a (
    a INT,
    b INT,
    c INT,
    INDEX idx_c_b_gt_1 (c) WHERE b > 1,
    FAMILY (a),
    FAMILY (b),
    FAMILY (c)
)

-- Test 47: statement (line 385)
INSERT INTO a VALUES (1, 1, 1)

-- Test 48: statement (line 388)
UPDATE a SET b = b + 1 WHERE a = 1

-- Test 49: query (line 391)
SELECT * FROM a@idx_c_b_gt_1 WHERE b > 1

-- Test 50: statement (line 396)
SELECT * FROM a@idx_c_b_gt_1 WHERE b = 0

-- Test 51: statement (line 402)
CREATE TABLE b (a INT, b INT, INDEX (a) WHERE 1 / b = 1)

-- Test 52: statement (line 405)
INSERT INTO b VALUES (1, 0)

-- Test 53: query (line 408)
SELECT count(1) FROM b

-- Test 54: statement (line 413)
INSERT INTO b VALUES (1, 1)

-- Test 55: statement (line 416)
UPDATE b SET b = 0 WHERE a = 1

-- Test 56: query (line 419)
SELECT * FROM b

-- Test 57: statement (line 426)
CREATE TABLE c (
    k INT PRIMARY KEY,
    i INT,
    INDEX i_0_100_idx (i) WHERE i > 0 AND i < 100
)

-- Test 58: statement (line 433)
INSERT INTO c VALUES (3, 30), (300, 3000)

-- Test 59: statement (line 436)
UPDATE c SET i = i + 1

-- Test 60: query (line 439)
SELECT * FROM c@i_0_100_idx WHERE i > 0 AND i < 100

-- Test 61: statement (line 459)
INSERT INTO d VALUES
    (1, 1, 1.0, 'foo', true),
    (2, 2, 2.0, 'foo', false),
    (3, 3, 3.0, 'bar', true),
    (100, 100, 100.0, 'foo', true),
    (200, 200, 200.0, 'foo', false),
    (300, 300, 300.0, 'bar', true)

-- Test 62: query (line 468)
SELECT * FROM d@i_0_100_idx WHERE i > 0 AND i < 100

-- Test 63: query (line 475)
SELECT * FROM d@f_b_s_foo_idx WHERE b AND s = 'foo'

-- Test 64: statement (line 484)
UPDATE d SET i = i + 10

-- Test 65: query (line 487)
SELECT * FROM d@i_0_100_idx WHERE i > 0 AND i < 100

-- Test 66: statement (line 497)
UPDATE d SET s = 'foo'

-- Test 67: query (line 500)
SELECT * FROM d@f_b_s_foo_idx WHERE b AND s = 'foo'

-- Test 68: statement (line 510)
UPSERT INTO d VALUES (300, 320, 300.0, 'bar', true)

-- Test 69: query (line 513)
SELECT * FROM d@f_b_s_foo_idx WHERE b AND s = 'foo'

-- Test 70: statement (line 522)
UPSERT INTO d VALUES (300, 330, 300.0, 'foo', true)

-- Test 71: query (line 525)
SELECT * FROM d@f_b_s_foo_idx WHERE b AND s = 'foo'

-- Test 72: statement (line 535)
UPSERT INTO d VALUES (400, 400, 400.0, 'foo', true)

-- Test 73: query (line 538)
SELECT * FROM d@i_0_100_idx WHERE i > 0 AND i < 100

-- Test 74: query (line 545)
SELECT * FROM d@f_b_s_foo_idx WHERE b AND s = 'foo'

-- Test 75: statement (line 556)
DELETE FROM d WHERE k = 1

-- Test 76: query (line 559)
SELECT * FROM d@i_0_100_idx WHERE i > 0 AND i < 100

-- Test 77: query (line 565)
SELECT * FROM d@f_b_s_foo_idx WHERE b AND s = 'foo'

-- Test 78: statement (line 575)
DELETE FROM d WHERE k = 2

-- Test 79: query (line 578)
SELECT * FROM d@i_0_100_idx WHERE i > 0 AND i < 100

-- Test 80: query (line 583)
SELECT * FROM d@f_b_s_foo_idx WHERE b AND s = 'foo'

-- Test 81: statement (line 593)
DELETE FROM d WHERE k = 200

-- Test 82: query (line 596)
SELECT * FROM d@i_0_100_idx WHERE i > 0 AND i < 100

-- Test 83: query (line 601)
SELECT * FROM d@f_b_s_foo_idx WHERE b AND s = 'foo'

-- Test 84: statement (line 611)
CREATE TABLE e (a INT, b INT)

-- Test 85: statement (line 614)
INSERT INTO e VALUES
    (1, 10),
    (2, 20),
    (3, 30),
    (4, 40),
    (5, 50),
    (6, 60)

-- Test 86: statement (line 623)
CREATE INDEX a_b_gt_30_idx ON e (a) WHERE b > 30

-- Test 87: query (line 629)
SELECT * FROM e@a_b_gt_30_idx WHERE b > 30

-- Test 88: statement (line 638)
BEGIN

-- Test 89: statement (line 641)
CREATE TABLE f (a INT, b INT)

-- Test 90: statement (line 644)
INSERT INTO f VALUES (1, 10), (6, 60)

-- Test 91: statement (line 647)
CREATE INDEX a_b_gt_30_idx ON f (a) WHERE b > 30

-- Test 92: statement (line 650)
COMMIT

-- Test 93: query (line 653)
SELECT * FROM f@a_b_gt_30_idx WHERE b > 30

-- Test 94: statement (line 660)
CREATE TYPE enum AS ENUM ('foo', 'bar', 'baz')

-- Test 95: statement (line 663)
CREATE TABLE h (a INT, b enum)

-- Test 96: statement (line 666)
INSERT INTO h VALUES (1, 'foo'), (2, 'bar')

-- Test 97: statement (line 669)
CREATE INDEX a_b_foo_idx ON h (a) WHERE b = 'foo'

-- Test 98: query (line 672)
SELECT * FROM h@a_b_foo_idx WHERE b = 'foo'

-- Test 99: query (line 704)
SELECT * FROM i@a_b_foo_idx WHERE b = 'foo'

-- Test 100: statement (line 711)
CREATE TABLE j (k INT NOT NULL, a INT, INDEX a_gt_5_idx (a) WHERE a > 5)

-- Test 101: statement (line 714)
INSERT INTO j VALUES (1, 1), (6, 6)

-- Test 102: statement (line 717)
ALTER TABLE j ADD PRIMARY KEY (k)

-- Test 103: query (line 720)
SELECT * FROM j@a_gt_5_idx WHERE a > 5

-- Test 104: statement (line 727)
CREATE TABLE k (a INT, b INT)

-- Test 105: statement (line 730)
INSERT INTO k VALUES (1, 1), (1, 2)

-- Test 106: statement (line 733)
CREATE UNIQUE INDEX ON k (a) WHERE b > 0

-- Test 107: statement (line 736)
UPDATE k SET b = 0 WHERE b = 2

-- Test 108: statement (line 739)
CREATE UNIQUE INDEX ON k (a) WHERE b > 0

-- Test 109: query (line 742)
SELECT * FROM k@k_a_key WHERE b > 0

-- Test 110: statement (line 750)
CREATE TABLE l (
    a INT PRIMARY KEY,
    b INT,
    INDEX a_b_gt_5 (a) WHERE b > 5
)

-- Test 111: statement (line 757)
INSERT INTO l VALUES (1, 1), (6, 6)

-- Test 112: statement (line 761)
ALTER TABLE l SET (schema_locked=false)

-- Test 113: statement (line 764)
TRUNCATE l

-- Test 114: statement (line 767)
ALTER TABLE l RESET (schema_locked)

-- Test 115: query (line 770)
SELECT * FROM l@a_b_gt_5 WHERE b > 5

-- Test 116: statement (line 774)
INSERT INTO l VALUES (1, 1), (7, 7)

-- Test 117: query (line 777)
SELECT * FROM l@a_b_gt_5 WHERE b > 5

-- Test 118: statement (line 785)
CREATE TABLE u (
    a INT,
    b INT,
    UNIQUE INDEX i (a) WHERE b > 0
)

-- Test 119: statement (line 793)
INSERT INTO u VALUES (1, 1), (1, 2)

-- Test 120: statement (line 797)
INSERT INTO u VALUES (1, 1), (2, 2), (1, -1)

-- Test 121: statement (line 801)
INSERT INTO u VALUES (1, 3)

-- Test 122: query (line 804)
SELECT * FROM u

-- Test 123: statement (line 812)
DELETE FROM u WHERE a = 2;

-- Test 124: statement (line 815)
INSERT INTO u VALUES (2, 2);

-- Test 125: statement (line 819)
UPDATE u SET a = 2 WHERE b = 1

-- Test 126: statement (line 824)
UPDATE u SET a = 2, b = 1 WHERE b = -1

-- Test 127: statement (line 829)
UPDATE u SET a = 2, b = -2 WHERE b = -1

-- Test 128: statement (line 834)
UPDATE u SET a = 3, b = 3  WHERE b = 2

-- Test 129: query (line 837)
SELECT * FROM u

-- Test 130: statement (line 844)
DELETE FROM u

-- Test 131: statement (line 850)
INSERT INTO u VALUES (1, -1) ON CONFLICT DO NOTHING

-- Test 132: query (line 853)
SELECT * FROM u

-- Test 133: statement (line 859)
INSERT INTO u VALUES (1, 1) ON CONFLICT DO NOTHING;

-- Test 134: query (line 862)
SELECT * FROM u

-- Test 135: statement (line 869)
INSERT INTO u VALUES (1, -10), (1, -100) ON CONFLICT DO NOTHING;
INSERT INTO u VALUES (1, -1000) ON CONFLICT DO NOTHING;

-- Test 136: query (line 873)
SELECT * FROM u

-- Test 137: statement (line 882)
DELETE FROM u WHERE b IN (-10, -100, -1000)

-- Test 138: statement (line 887)
INSERT INTO u VALUES (2, 2), (2, 2), (2, -2) ON CONFLICT DO NOTHING

-- Test 139: query (line 890)
SELECT * FROM u

-- Test 140: statement (line 899)
INSERT INTO u VALUES (1, 10) ON CONFLICT DO NOTHING

-- Test 141: query (line 902)
SELECT * FROM u

-- Test 142: statement (line 912)
INSERT INTO u VALUES (2, 20), (3, 3) ON CONFLICT DO NOTHING

-- Test 143: query (line 915)
SELECT * FROM u

-- Test 144: statement (line 924)
CREATE UNIQUE INDEX i2 ON u (b) WHERE a > 0

-- Test 145: statement (line 929)
INSERT INTO u VALUES (4, 3) ON CONFLICT DO NOTHING

-- Test 146: query (line 932)
SELECT * FROM u

-- Test 147: statement (line 942)
INSERT INTO u VALUES (1, 3) ON CONFLICT DO NOTHING

-- Test 148: query (line 945)
SELECT * FROM u

-- Test 149: statement (line 955)
INSERT INTO u VALUES (4, 4), (1, -10), (-10, 2) ON CONFLICT DO NOTHING

-- Test 150: query (line 958)
SELECT * FROM u

-- Test 151: statement (line 970)
DROP INDEX i2

-- Test 152: statement (line 973)
DELETE from u

-- Test 153: statement (line 980)
INSERT INTO u VALUES (1, 1) ON CONFLICT (a) DO NOTHING

-- Test 154: statement (line 985)
INSERT INTO u VALUES (1, 1) ON CONFLICT (a) WHERE b < -1 DO NOTHING

-- Test 155: statement (line 990)
CREATE UNIQUE INDEX i2 ON u (b) WHERE 1 = 1;

-- Test 156: statement (line 993)
INSERT INTO u VALUES (1, 1) ON CONFLICT (b) DO NOTHING;

-- Test 157: statement (line 996)
DELETE FROM u;

-- Test 158: statement (line 999)
DROP INDEX i2;

-- Test 159: statement (line 1004)
CREATE UNIQUE INDEX i2 ON u (b);

-- Test 160: statement (line 1007)
INSERT INTO u VALUES (1, 1) ON CONFLICT (b) WHERE b > 0 DO NOTHING;

-- Test 161: statement (line 1010)
DROP INDEX i2;

-- Test 162: statement (line 1015)
INSERT INTO u VALUES (1, 1) ON CONFLICT (a) WHERE b > 1 DO NOTHING;
INSERT INTO u VALUES (1, 2) ON CONFLICT (a) WHERE b > 1 DO NOTHING;

-- Test 163: query (line 1019)
SELECT * FROM u

-- Test 164: statement (line 1026)
CREATE UNIQUE INDEX i2 ON u (a) WHERE b < 0;

-- Test 165: statement (line 1029)
INSERT INTO u VALUES (-1, -1);

-- Test 166: statement (line 1032)
INSERT INTO u VALUES (-1, -1) ON CONFLICT (a) WHERE b > 0 DO NOTHING

-- Test 167: statement (line 1036)
INSERT INTO u VALUES (1, 2), (-1, -2) ON CONFLICT (a) WHERE b > 0 AND b < 0 DO NOTHING

-- Test 168: statement (line 1041)
INSERT INTO u VALUES (1, 2)
ON CONFLICT (a) WHERE b < (CASE WHEN now() > '1980-01-01' THEN 0 ELSE 100 END) DO NOTHING

-- Test 169: statement (line 1045)
DROP INDEX i2

-- Test 170: statement (line 1048)
CREATE UNIQUE INDEX i2 ON u (a) WHERE true;

-- Test 171: statement (line 1053)
INSERT INTO u VALUES (1, 2)
ON CONFLICT (a) WHERE b < (CASE WHEN now() > '1980-01-01' THEN 0 ELSE 100 END) DO NOTHING

-- Test 172: statement (line 1057)
DROP INDEX i2

-- Test 173: statement (line 1060)
DELETE FROM u

-- Test 174: statement (line 1066)
INSERT INTO u VALUES (1, 1) ON CONFLICT (a) DO UPDATE SET b = 10

-- Test 175: statement (line 1070)
INSERT INTO u VALUES (1, 1) ON CONFLICT (a) WHERE b < 0 DO UPDATE SET b = 10

-- Test 176: statement (line 1073)
CREATE UNIQUE INDEX i2 ON u (a) WHERE b < 0

-- Test 177: statement (line 1077)
INSERT INTO u VALUES (1, 1) ON CONFLICT (a) WHERE b < 0 AND b > 0 DO UPDATE SET b = 10

-- Test 178: statement (line 1080)
DROP INDEX i2

-- Test 179: statement (line 1084)
INSERT INTO u VALUES (1, -1) ON CONFLICT (a) WHERE b > 0 DO UPDATE SET b = -10

-- Test 180: query (line 1087)
SELECT * FROM u

-- Test 181: statement (line 1093)
INSERT INTO u VALUES (1, 1) ON CONFLICT (a) WHERE b > 0 DO UPDATE SET b = 10

-- Test 182: query (line 1096)
SELECT * FROM u

-- Test 183: statement (line 1103)
INSERT INTO u VALUES (1, -10), (1, -100) ON CONFLICT (a) WHERE b > 0 DO UPDATE SET b = -11;
INSERT INTO u VALUES (1, -1000) ON CONFLICT (a) WHERE b > 0 DO UPDATE SET b = -11;

-- Test 184: query (line 1107)
SELECT * FROM u

-- Test 185: statement (line 1116)
DELETE FROM u WHERE b IN (-10, -100, -1000)

-- Test 186: statement (line 1121)
INSERT INTO u VALUES (1, 10), (3, 3) ON CONFLICT (a) WHERE b > 0 DO UPDATE SET b = 100

-- Test 187: query (line 1124)
SELECT * FROM u

-- Test 188: statement (line 1132)
INSERT INTO u VALUES (4, 4), (4, 40) ON CONFLICT (a) WHERE b > 0 DO UPDATE SET b = 300

-- Test 189: statement (line 1137)
INSERT INTO u VALUES (1, 11), (3, 33) ON CONFLICT (a) WHERE b > 0 DO UPDATE SET b = 10 WHERE u.a = 1

-- Test 190: query (line 1140)
SELECT * FROM u

-- Test 191: statement (line 1147)
CREATE UNIQUE INDEX i2 ON u (a) WHERE b < 0;

-- Test 192: statement (line 1152)
INSERT INTO u VALUES (1, -1) ON CONFLICT (a) WHERE b > 0 DO UPDATE SET a = 100

-- Test 193: statement (line 1155)
DROP INDEX i2

-- Test 194: statement (line 1158)
DELETE from u

-- Test 195: statement (line 1168)
ALTER TABLE join_small INJECT STATISTICS '[
  {
    "columns": ["m"],
    "created_at": "2019-02-08 04:10:40.001179+00:00",
    "row_count": 20,
    "distinct_count": 20
  }
]';

-- Test 196: statement (line 1178)
ALTER TABLE join_large INJECT STATISTICS '[
  {
    "columns": ["i"],
    "created_at": "2018-05-01 1:00:00.00000+00:00",
    "row_count": 10000,
    "distinct_count": 10000
  },
  {
    "columns": ["s"],
    "created_at": "2018-05-01 1:00:00.00000+00:00",
    "row_count": 10000,
    "distinct_count": 50
  }
]';

-- Test 197: statement (line 1194)
INSERT INTO join_small VALUES (1, 1), (2, 2), (3, 3);
INSERT INTO join_large VALUES (1, 'foo'), (2, 'not'), (3, 'bar'), (4, 'not');

-- Test 198: query (line 1198)
SELECT m FROM join_small JOIN join_large ON n = i AND s IN ('foo', 'bar', 'baz')

-- Test 199: query (line 1204)
SELECT m FROM join_small JOIN join_large ON n = i AND s = 'foo'

-- Test 200: query (line 1211)
SELECT m FROM join_small WHERE EXISTS (SELECT 1 FROM join_large WHERE n = i AND s IN ('foo', 'bar', 'baz'))

-- Test 201: query (line 1219)
SELECT m FROM join_small WHERE NOT EXISTS (SELECT 1 FROM join_large WHERE n = i AND s IN ('foo', 'bar', 'baz'))

-- Test 202: statement (line 1227)
CREATE TYPE enum_type AS ENUM ('foo', 'bar', 'baz');
CREATE TABLE enum_table (
    a INT PRIMARY KEY,
    b enum_type,
    INDEX i (a) WHERE b IN ('foo', 'bar')
);

-- Test 203: statement (line 1235)
INSERT INTO enum_table VALUES
    (1, 'foo'),
    (2, 'bar'),
    (3, 'baz')

-- Test 204: query (line 1241)
SELECT * FROM enum_table@i WHERE b IN ('foo', 'bar')

-- Test 205: statement (line 1247)
UPDATE enum_table SET b = 'baz' WHERE a = 1;
UPDATE enum_table SET b = 'foo' WHERE a = 3;

-- Test 206: query (line 1251)
SELECT * FROM enum_table@i WHERE b IN ('foo', 'bar')

-- Test 207: statement (line 1257)
DELETE FROM enum_table WHERE a = 2

-- Test 208: query (line 1260)
SELECT * FROM enum_table@i WHERE b IN ('foo', 'bar')

-- Test 209: statement (line 1265)
UPSERT INTO enum_table VALUES
    (1, 'foo'),
    (2, 'bar'),
    (3, 'baz')

-- Test 210: query (line 1271)
SELECT * FROM enum_table@i WHERE b IN ('foo', 'bar')

-- Test 211: statement (line 1279)
CREATE TABLE enum_table_show (
    a INT,
    b enum_type,
    INDEX i (a) WHERE b IN ('foo', 'bar'),
    FAMILY (a, b)
)

onlyif config schema-locked-disabled

-- Test 212: query (line 1288)
SHOW CREATE TABLE enum_table_show

-- Test 213: query (line 1301)
SHOW CREATE TABLE enum_table_show

-- Test 214: statement (line 1316)
CREATE TABLE inv (j JSON, i INT, INVERTED INDEX (j) WHERE i > 0);
DROP TABLE inv;

-- Test 215: statement (line 1324)
INSERT INTO inv VALUES
    (1, '{"x": "y", "num": 1}', 'foo'),
    (2, '{"x": "y", "num": 2}', 'baz'),
    (3, '{"x": "y", "num": 3}', 'bar')

-- Test 216: query (line 1330)
SELECT * FROM inv@i WHERE j @> '{"x": "y"}' AND s = 'foo'

-- Test 217: query (line 1335)
SELECT * FROM inv@i WHERE j @> '{"num": 1}' AND s IN ('foo', 'bar')

-- Test 218: query (line 1340)
SELECT * FROM inv@i WHERE j @> '{"x": "y"}' AND s IN ('foo', 'bar') ORDER BY k

-- Test 219: statement (line 1346)
DELETE FROM inv WHERE k = 3

-- Test 220: query (line 1349)
SELECT * FROM inv@i WHERE j @> '{"x": "y"}' AND s IN ('foo', 'bar')

-- Test 221: statement (line 1354)
UPDATE inv SET j = '{"x": "y", "num": 10}' WHERE k = 1

-- Test 222: query (line 1357)
SELECT * FROM inv@i WHERE j @> '{"num": 10}' AND s = 'foo'

-- Test 223: statement (line 1362)
UPDATE inv SET k = 10 WHERE k = 1

-- Test 224: statement (line 1365)
UPDATE inv SET s = 'bar' WHERE k = 2

-- Test 225: query (line 1368)
SELECT * FROM inv@i WHERE j @> '{"x": "y"}' AND s IN ('foo', 'bar') ORDER BY k

-- Test 226: statement (line 1374)
UPDATE inv SET s = 'baz' WHERE k = 10

-- Test 227: query (line 1377)
SELECT * FROM inv@i WHERE j @> '{"x": "y"}' AND s IN ('foo', 'bar')

-- Test 228: statement (line 1382)
UPSERT INTO inv VALUES (3, '{"x": "y", "num": 3}', 'bar')

-- Test 229: query (line 1385)
SELECT * FROM inv@i WHERE j @> '{"x": "y"}' AND s = 'bar' ORDER BY k

-- Test 230: statement (line 1391)
UPSERT INTO inv VALUES (3, '{"x": "y", "num": 4}', 'bar')

-- Test 231: query (line 1394)
SELECT * FROM inv@i WHERE j @> '{"num": 4}' AND s = 'bar'

-- Test 232: statement (line 1399)
SELECT * FROM inv@i WHERE j @> '{"num": 2}' AND s = 'baz'

-- Test 233: statement (line 1407)
INSERT INTO inv_b VALUES
    (1, '{"x": "y", "num": 1}', 'foo'),
    (2, '{"x": "y", "num": 2}', 'baz'),
    (3, '{"x": "y", "num": 3}', 'bar')

-- Test 234: statement (line 1413)
CREATE INVERTED INDEX i ON inv_b (j) WHERE s IN ('foo', 'bar')

-- Test 235: query (line 1416)
SELECT * FROM inv_b@i WHERE j @> '{"x": "y"}' AND s IN ('foo', 'bar') ORDER BY k

-- Test 236: statement (line 1425)
BEGIN

-- Test 237: statement (line 1431)
INSERT INTO inv_c VALUES
    (1, '{"x": "y", "num": 1}', 'foo'),
    (2, '{"x": "y", "num": 2}', 'baz'),
    (3, '{"x": "y", "num": 3}', 'bar')

-- Test 238: statement (line 1437)
CREATE INVERTED INDEX i ON inv_c (j) WHERE s IN ('foo', 'bar')

-- Test 239: statement (line 1440)
COMMIT

-- Test 240: query (line 1443)
SELECT * FROM inv_c@i WHERE j @> '{"x": "y"}' AND s IN ('foo', 'bar') ORDER BY k

-- Test 241: statement (line 1451)
CREATE TABLE prune (
    a INT PRIMARY KEY,
    b INT,
    c INT,
    d INT,
    INDEX idx (b) WHERE c > 0,
    FAMILY (a),
    FAMILY (b),
    FAMILY (c),
    FAMILY (d)
)

-- Test 242: statement (line 1464)
INSERT INTO prune (a, b, c, d) VALUES (1, 2, 3, 4)

-- Test 243: statement (line 1469)
UPDATE prune SET d = d + 1 WHERE a = 1

-- Test 244: query (line 1472)
SELECT * FROM prune@idx WHERE c > 0

-- Test 245: statement (line 1479)
UPSERT INTO prune (a, d) VALUES (1, 6)

-- Test 246: query (line 1482)
SELECT * FROM prune@idx WHERE c > 0

-- Test 247: statement (line 1489)
INSERT INTO prune (a, d) VALUES (1, 6) ON CONFLICT (a) DO UPDATE SET d = 7

-- Test 248: query (line 1492)
SELECT * FROM prune@idx WHERE c > 0

-- Test 249: statement (line 1500)
CREATE TABLE vec (id INT PRIMARY KEY, v VECTOR(3), VECTOR INDEX (v) WHERE id > 0);

-- Test 250: statement (line 1503)
INSERT INTO vec VALUES
    (1, '[1,2,3]'),
    (2, '[4,5,6]'),
    (3, '[7,8,9]'),
    (4, '[10,11,12]')

-- Test 251: query (line 1510)
SELECT * FROM vec@vec_v_idx WHERE id > 0 ORDER BY v <-> '[3,1,2]' LIMIT 2

-- Test 252: query (line 1516)
SELECT * FROM vec@primary WHERE id > 0 ORDER BY v <-> '[3,1,2]' LIMIT 2

-- Test 253: statement (line 1522)
DROP TABLE vec;

-- Test 254: statement (line 1525)
CREATE TABLE vec (
  id INT PRIMARY KEY,
  v VECTOR(3),
  VECTOR INDEX (v) WHERE v <-> '[3,1,2]' >= 3,
  FAMILY (id, v)
);

onlyif config schema-locked-disabled

-- Test 255: query (line 1534)
SHOW CREATE TABLE vec

-- Test 256: query (line 1546)
SHOW CREATE TABLE vec

-- Test 257: statement (line 1557)
INSERT INTO vec VALUES
    (1, '[1,2,3]'),
    (2, '[4,5,6]'),
    (3, '[7,8,9]'),
    (4, '[10,11,12]')

-- Test 258: query (line 1564)
SELECT * FROM vec@vec_v_idx WHERE v <-> '[3,1,2]' >= 3 ORDER BY v <-> '[3,1,2]' LIMIT 2

-- Test 259: query (line 1570)
SELECT * FROM vec@primary WHERE v <-> '[3,1,2]' >= 3 ORDER BY v <-> '[3,1,2]' LIMIT 2

-- Test 260: statement (line 1576)
DROP TABLE vec;

-- Test 261: statement (line 1583)
INSERT INTO vec VALUES
    (1, 'foo', '[1,2,3]'),
    (2, 'bar', '[4,5,6]'),
    (3, 'baz', '[7,8,9]'),
    (4, 'bar', '[10,11,12]')

-- Test 262: query (line 1590)
SELECT * FROM vec@vec_v_idx WHERE s IN ('foo', 'bar') ORDER BY v <-> '[3,1,2]' LIMIT 2

-- Test 263: query (line 1596)
SELECT * FROM vec@primary WHERE s IN ('foo', 'bar') ORDER BY v <-> '[3,1,2]' LIMIT 2

-- Test 264: statement (line 1602)
DROP TABLE vec;

-- Test 265: statement (line 1609)
INSERT INTO vec VALUES
    (1, '[1,2]', 'foo'),
    (2, '[3,4]', 'foo'),
    (3, '[5,6]', 'baz'),
    (4, '[5,6]', 'bar')

-- Test 266: query (line 1617)
SELECT * FROM vec@i WHERE s = 'foo' ORDER BY v <-> '[5,5]' LIMIT 1

-- Test 267: query (line 1623)
SELECT * FROM vec@i WHERE s IN ('foo', 'bar') ORDER BY v <-> '[5,5]' LIMIT 1

-- Test 268: statement (line 1629)
DELETE FROM vec WHERE k = 4

-- Test 269: query (line 1632)
SELECT * FROM vec@i WHERE s IN ('foo', 'bar') ORDER BY v <-> '[5,5]' LIMIT 1

-- Test 270: statement (line 1638)
UPDATE vec SET v = '[6,6]' WHERE k = 1

-- Test 271: query (line 1641)
SELECT * FROM vec@i WHERE s = 'foo' ORDER BY v <-> '[5,5]' LIMIT 1

-- Test 272: statement (line 1647)
UPDATE vec SET k = 10 WHERE k = 1

-- Test 273: statement (line 1650)
UPDATE vec SET s = 'bar' WHERE k = 3

-- Test 274: query (line 1653)
SELECT * FROM vec@i WHERE s IN ('foo', 'bar') ORDER BY v <-> '[5,5]' LIMIT 3

-- Test 275: statement (line 1661)
UPDATE vec SET s = 'baz' WHERE k = 10

-- Test 276: query (line 1664)
SELECT * FROM vec@i WHERE s IN ('foo', 'bar') ORDER BY v <-> '[5,5]' LIMIT 3

-- Test 277: statement (line 1671)
UPSERT INTO vec VALUES (3, '[7, 8]', 'bar')

-- Test 278: query (line 1674)
SELECT * FROM vec@i WHERE s = 'bar' ORDER BY v <-> '[5,5]' LIMIT 3

-- Test 279: statement (line 1679)
SELECT * FROM vec@i WHERE s = 'baz' ORDER BY v <-> '[5,5]' LIMIT 3

-- Test 280: statement (line 1682)
DROP TABLE vec

-- Test 281: statement (line 1689)
INSERT INTO vec_b VALUES
    (1, '[1,2]', 'foo'),
    (2, '[3,4]', 'foo'),
    (3, '[5,6]', 'baz'),
    (4, '[5,6]', 'bar')

-- Test 282: statement (line 1696)
CREATE VECTOR INDEX i ON vec_b (s, v) WHERE s IN ('foo', 'bar')

-- Test 283: query (line 1699)
SELECT * FROM vec_b@i WHERE s IN ('foo', 'bar') ORDER BY v <-> '[5,5]' LIMIT 3

-- Test 284: statement (line 1706)
DROP TABLE vec_b

-- Test 285: statement (line 1712)
BEGIN

-- Test 286: statement (line 1718)
INSERT INTO vec_c VALUES
    (1, '[1,2]', 'foo'),
    (2, '[3,4]', 'foo'),
    (3, '[5,6]', 'baz'),
    (4, '[5,6]', 'bar')

-- Test 287: statement (line 1725)
CREATE VECTOR INDEX i ON vec_c (s, v) WHERE s IN ('foo', 'bar')

-- Test 288: query (line 1728)
SELECT * FROM vec_c@i WHERE s IN ('foo', 'bar') ORDER BY v <-> '[5,5]' LIMIT 3

-- Test 289: statement (line 1735)
COMMIT

-- Test 290: statement (line 1738)
DROP TABLE vec_c

-- Test 291: statement (line 1745)
CREATE TABLE virt (
    a INT PRIMARY KEY,
    b INT,
    c INT AS (b + 10) VIRTUAL,
    INDEX idx (a) WHERE c = 10
)

-- Test 292: statement (line 1753)
INSERT INTO virt (a, b) VALUES
    (1, 0),
    (2, 2),
    (3, 0)

-- Test 293: query (line 1759)
SELECT * FROM virt@idx WHERE c = 10

-- Test 294: statement (line 1765)
DELETE FROM virt WHERE a = 1

-- Test 295: query (line 1768)
SELECT * FROM virt@idx WHERE c = 10

-- Test 296: statement (line 1773)
UPDATE virt SET b = 0 WHERE a = 2

-- Test 297: statement (line 1776)
UPDATE virt SET b = 3 WHERE a = 3

-- Test 298: query (line 1779)
SELECT * FROM virt@idx WHERE c = 10

-- Test 299: statement (line 1784)
UPDATE virt SET a = 4 WHERE a = 2

-- Test 300: query (line 1787)
SELECT * FROM virt@idx WHERE c = 10

-- Test 301: statement (line 1792)
UPSERT INTO virt (a, b) VALUES (5, 5), (6, 6);
UPSERT INTO virt (a, b) VALUES (5, 0);

-- Test 302: query (line 1796)
SELECT * FROM virt@idx WHERE c = 10

-- Test 303: statement (line 1802)
INSERT INTO virt (a, b) VALUES (7, 7), (8, 0) ON CONFLICT (a) DO NOTHING;
INSERT INTO virt (a, b) VALUES (7, 0) ON CONFLICT (a) DO NOTHING;

-- Test 304: query (line 1806)
SELECT * FROM virt@idx WHERE c = 10

-- Test 305: statement (line 1813)
INSERT INTO virt (a, b) VALUES (7, 0), (9, 9), (10, 0) ON CONFLICT (a) DO UPDATE SET b = 0

-- Test 306: query (line 1816)
SELECT * FROM virt@idx WHERE c = 10

-- Test 307: statement (line 1827)
DELETE FROM virt;

-- Test 308: statement (line 1830)
DROP INDEX virt@idx;

-- Test 309: statement (line 1833)
CREATE UNIQUE INDEX idx ON virt (b) WHERE c > 10;

-- Test 310: statement (line 1836)
INSERT INTO virt (a, b) VALUES (1, 1), (2, 2), (3, 1) ON CONFLICT DO NOTHING

-- Test 311: query (line 1839)
SELECT * FROM virt@idx WHERE c > 10

-- Test 312: statement (line 1845)
INSERT INTO virt (a, b) VALUES (4, 1), (5, 5) ON CONFLICT (b) DO NOTHING

-- Test 313: statement (line 1848)
INSERT INTO virt (a, b) VALUES (4, 1), (5, 5) ON CONFLICT (b) WHERE c > 10 DO NOTHING

-- Test 314: query (line 1851)
SELECT * FROM virt@idx WHERE c > 10

-- Test 315: statement (line 1859)
INSERT INTO virt (a, b) VALUES (1, 2), (6, 6) ON CONFLICT (b) WHERE c > 10 DO UPDATE SET b = 5

-- Test 316: statement (line 1863)
INSERT INTO virt (a, b) VALUES (1, 3), (7, 7) ON CONFLICT (b) WHERE c > 10 DO UPDATE SET b = 8

-- Test 317: statement (line 1866)
INSERT INTO virt (a, b) VALUES (1, 2), (8, 8) ON CONFLICT (b) WHERE c > 10 DO UPDATE SET b = 9

-- Test 318: query (line 1869)
SELECT * FROM virt@idx WHERE c > 10

-- Test 319: statement (line 1881)
CREATE TABLE t52318 (
    a INT PRIMARY KEY,
    b INT,
    INDEX (a)
)

-- Test 320: statement (line 1888)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
CREATE INDEX i ON t52318 (a) WHERE b > 5

-- Test 321: statement (line 1892)
INSERT INTO t52318 (a, b) VALUES (1, 1), (6, 6)

-- Test 322: query (line 1895)
SELECT * FROM t52318 WHERE b > 5

-- Test 323: statement (line 1900)
UPDATE t52318 SET b = b + 1

-- Test 324: query (line 1903)
SELECT * FROM t52318 WHERE b > 5

-- Test 325: statement (line 1908)
DELETE FROM t52318

-- Test 326: statement (line 1911)
COMMIT

-- Test 327: statement (line 1919)
CREATE TABLE t52702 (
    a INT,
    b INT,
    INDEX t52702_true (a) WHERE 1 = 1,
    INDEX t52702_false (a) WHERE 1 = 2
)

-- Test 328: statement (line 1927)
SELECT * FROM t52702@t52702_true;
SELECT * FROM t52702@t52702_true WHERE true;
SELECT * FROM t52702@t52702_true WHERE 1 = 1;
SELECT * FROM t52702@t52702_true WHERE 's' = 's';
SELECT * FROM t52702@t52702_true WHERE b = 1;
SELECT * FROM t52702@t52702_true WHERE false;

-- Test 329: statement (line 1935)
SELECT * FROM t52702@t52702_false WHERE 1 = 2;
SELECT * FROM t52702@t52702_false WHERE 's' = 't';
SELECT * FROM t52702@t52702_false WHERE false;

-- Test 330: statement (line 1946)
CREATE TABLE t53922 (
    a INT NOT NULL,
    UNIQUE INDEX (a) WHERE a > 10
)

-- Test 331: statement (line 1952)
INSERT INTO t53922 VALUES (1), (2), (3), (3)

-- Test 332: query (line 1955)
SELECT distinct(a) FROM t53922

-- Test 333: statement (line 1966)
CREATE TABLE t54649_a (
  i INT,
  b BOOL,
  INDEX (i) WHERE b
)

-- Test 334: statement (line 1973)
SELECT i FROM t54649_a WHERE (NULL OR b) OR b

-- Test 335: statement (line 1976)
CREATE TABLE t54649_b (
  i INT,
  b BOOL,
  c BOOL,
  INDEX (i) WHERE (b OR NULL) OR b
)

-- Test 336: statement (line 1984)
SELECT i FROM t54649_b WHERE c

-- Test 337: statement (line 1990)
CREATE TABLE public.indexes_article (
    id INT8 NOT NULL DEFAULT unique_rowid(),
    headline VARCHAR(100) NOT NULL,
    pub_date TIMESTAMPTZ NOT NULL,
    published BOOL NOT NULL,
    CONSTRAINT "primary" PRIMARY KEY (id ASC),
    INDEX indexes_article_headline_pub_date_b992dbba_idx (headline ASC, pub_date ASC),
    FAMILY "primary" (id, headline, pub_date, published)
)

-- Test 338: statement (line 2001)
CREATE INDEX "recent_article_idx" ON "indexes_article" ("pub_date") WHERE "pub_date" IS NOT NULL

-- Test 339: statement (line 2008)
CREATE TABLE t55387 (
  k INT PRIMARY KEY,
  a INT,
  b INT,
  INDEX (a) WHERE a > 1,
  INDEX (b) WHERE b > 2
);
INSERT INTO t55387 VALUES (1, 1, 5);

-- Test 340: query (line 2018)
SELECT k FROM t55387 WHERE a > 1 AND b > 3

-- Test 341: statement (line 2026)
CREATE TABLE t55672_a (
    a INT PRIMARY KEY,
    t TIMESTAMPTZ DEFAULT NULL,
    UNIQUE INDEX (a) WHERE t is NULL
)

-- Test 342: statement (line 2033)
CREATE TABLE t55672_b (
    b INT PRIMARY KEY,
    a INT NOT NULL REFERENCES t55672_a (a)
)

-- Test 343: statement (line 2039)
INSERT INTO t55672_a (a) VALUES (1)

-- Test 344: statement (line 2042)
INSERT INTO t55672_b (b,a) VALUES (1,1)

-- Test 345: statement (line 2045)
INSERT INTO t55672_a (a, t) VALUES (2, now())

-- Test 346: statement (line 2048)
INSERT INTO t55672_b (b,a) VALUES (2,2)

-- Test 347: statement (line 2056)
CREATE TABLE t57085_p1 (
    p INT PRIMARY KEY
);
CREATE TABLE t57085_c1 (
    c INT PRIMARY KEY,
    p INT REFERENCES t57085_p1 ON UPDATE CASCADE,
    i INT,
    INDEX idx (p) WHERE i > 0
);

-- Test 348: statement (line 2067)
INSERT INTO t57085_p1 VALUES (1);
INSERT INTO t57085_c1 VALUES (10, 1, 100), (20, 1, -100);
UPDATE t57085_p1 SET p = 2 WHERE p = 1;

-- Test 349: query (line 2072)
SELECT c, p, i FROM t57085_c1@idx WHERE p = 2 AND i > 0

-- Test 350: statement (line 2079)
CREATE TABLE t57085_p2 (
    p INT PRIMARY KEY
);
CREATE TABLE t57085_c2 (
    c INT PRIMARY KEY,
    p INT REFERENCES t57085_p2 ON UPDATE CASCADE,
    b BOOL,
    INDEX idx (p) WHERE b
);

-- Test 351: statement (line 2090)
INSERT INTO t57085_p2 VALUES (1);
INSERT INTO t57085_c2 VALUES (10, 1, true), (20, 1, false);
UPDATE t57085_p2 SET p = 2 WHERE p = 1;

-- Test 352: query (line 2095)
SELECT c, p, b FROM t57085_c2@idx WHERE p = 2 AND b

-- Test 353: statement (line 2101)
INSERT INTO t57085_p2 VALUES (2) ON CONFLICT (p) DO UPDATE SET p = 3

-- Test 354: query (line 2104)
SELECT c, p, b FROM t57085_c2@idx WHERE p = 3 AND b

-- Test 355: statement (line 2111)
CREATE TABLE t57085_p3 (
    p INT PRIMARY KEY
);
CREATE TABLE t57085_c3 (
    c INT PRIMARY KEY,
    p INT REFERENCES t57085_p3 ON UPDATE CASCADE,
    i INT,
    INDEX idx (i) WHERE p = 3
);

-- Test 356: statement (line 2122)
INSERT INTO t57085_p3 VALUES (1), (2);
INSERT INTO t57085_c3 VALUES (10, 1, 100), (20, 2, 200);
UPDATE t57085_p3 SET p = 3 WHERE p = 1;

-- Test 357: query (line 2127)
SELECT c, p, i FROM t57085_c3@idx WHERE p = 3 AND i = 100

-- Test 358: statement (line 2132)
UPDATE t57085_p3 SET p = 4 WHERE p = 3;

-- Test 359: query (line 2135)
SELECT c, p, i FROM t57085_c3@idx WHERE p = 3 AND i = 100

-- Test 360: statement (line 2144)
CREATE TABLE t58390 (
  a INT PRIMARY KEY,
  b INT NOT NULL,
  c INT,
  INDEX (c) WHERE a = 1 OR b = 1
)

-- Test 361: statement (line 2152)
ALTER TABLE t58390 ALTER PRIMARY KEY USING COLUMNS (b, a)

-- Test 362: statement (line 2160)
create table t61414_a (
  k INT PRIMARY KEY
)

-- Test 363: statement (line 2174)
INSERT INTO t61414_a VALUES (2)

-- Test 364: statement (line 2177)
INSERT INTO t61414_b (k, a, b)
VALUES (1, 'a', 2)
ON CONFLICT (a, b) DO UPDATE SET a = excluded.a
WHERE t61414_b.a = 'x'
RETURNING k

-- Test 365: statement (line 2187)
CREATE TABLE t61414_c (
  k INT PRIMARY KEY,
  a INT,
  b INT,
  c INT,
  d INT,
  INDEX (b) WHERE b > 0,
  UNIQUE WITHOUT INDEX (b) WHERE b > 0,
  FAMILY (k, a, c)
)

skipif config #126592 weak-iso-level-configs

-- Test 366: statement (line 2200)
UPSERT INTO t61414_c (k, a, b, d) VALUES (1, 2, 3, 4)

-- Test 367: statement (line 2209)
CREATE TABLE t61284 (
  a INT,
  INDEX (a) WHERE a > 0
)

-- Test 368: statement (line 2215)
UPDATE t61284 SET a = v.a FROM (VALUES (1), (2)) AS v(a) WHERE t61284.a = v.a

-- Test 369: query (line 2234)
SELECT * FROM t74385@b_idx
WHERE b = 'b' AND c IS NULL;

-- Test 370: statement (line 2241)
CREATE TABLE t75907 (k INT PRIMARY KEY, j JSONB);
INSERT INTO t75907 VALUES (1, '{"a": 1}');
CREATE INDEX t75907_partial_idx ON t75907 (k) WHERE (j->'b' = '1') IS NULL

-- Test 371: query (line 2246)
SELECT k, (j->'b' = '1') IS NULL FROM t75907@t75907_partial_idx WHERE (j->'b' = '1') IS NULL

-- Test 372: statement (line 2255)
SET autocommit_before_ddl = false

-- Test 373: statement (line 2258)
CREATE TABLE t79613 (i INT PRIMARY KEY) WITH (schema_locked=false);

-- Test 374: statement (line 2261)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
   ALTER TABLE t79613 ADD COLUMN k INT DEFAULT 1;
   CREATE INDEX idx ON t79613(i) WHERE (k > 1);

-- Test 375: statement (line 2266)
ROLLBACK

-- Test 376: statement (line 2269)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
   ALTER TABLE t79613 ADD COLUMN k INT DEFAULT 1;
   CREATE UNIQUE INDEX idx ON t79613(i) WHERE (k > 1);

-- Test 377: statement (line 2274)
ROLLBACK

-- Test 378: statement (line 2277)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
   ALTER TABLE t79613 ADD COLUMN k INT DEFAULT 1;
   ALTER TABLE t79613 ADD CONSTRAINT c UNIQUE (k) WHERE (k > 1);

-- Test 379: statement (line 2282)
ROLLBACK

-- Test 380: statement (line 2285)
DROP TABLE t79613

-- Test 381: statement (line 2292)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
   CREATE TABLE t79613 (i INT PRIMARY KEY);
   ALTER TABLE t79613 ADD COLUMN k INT DEFAULT 1;
   CREATE INDEX idx ON t79613(i) WHERE (k > 1);
COMMIT;
SELECT * FROM t79613;

-- Test 382: statement (line 2300)
DROP TABLE t79613;

-- Test 383: statement (line 2303)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
   CREATE TABLE t79613 (i INT PRIMARY KEY);
   ALTER TABLE t79613 ADD COLUMN k INT DEFAULT 1;
   CREATE UNIQUE INDEX idx ON t79613(i) WHERE (k > 1);
COMMIT;
SELECT * FROM t79613;

-- Test 384: statement (line 2311)
DROP TABLE t79613;

-- Test 385: statement (line 2314)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
   CREATE TABLE t79613 (i INT PRIMARY KEY);
   ALTER TABLE t79613 ADD COLUMN k INT DEFAULT 1;
   ALTER TABLE t79613 ADD CONSTRAINT c UNIQUE (k) WHERE (k > 1);
COMMIT;
SELECT * FROM t79613;

-- Test 386: statement (line 2322)
DROP TABLE t79613;

-- Test 387: statement (line 2325)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
   CREATE TABLE t79613 (i INT PRIMARY KEY);
   ALTER TABLE t79613 ADD COLUMN k INT DEFAULT 1,
       ADD CONSTRAINT c UNIQUE (k) WHERE (k > 1);
COMMIT;
SELECT * FROM t79613;

-- Test 388: statement (line 2333)
DROP TABLE t79613;

-- Test 389: statement (line 2336)
RESET autocommit_before_ddl

-- Test 390: statement (line 2346)
CREATE TABLE t96924 (
  a INT,
  b INT,
  c INT,
  d INT,
  e INT,
  f JSON,
  g INT,
  h INT,
  i INT,
  INDEX (a) WHERE (b > 0),
  UNIQUE INDEX (b) WHERE (b > 0),
  UNIQUE (c) WHERE (c > 0),
  UNIQUE WITHOUT INDEX (d) WHERE (d > 0),
  INVERTED INDEX (e, f) WHERE (e > 0),
  INDEX (g) WHERE (h > 0),
  UNIQUE WITHOUT INDEX (g) WHERE (i > 0)
)

-- Test 391: statement (line 2368)
ALTER TABLE t96924 DROP COLUMN a

-- Test 392: statement (line 2371)
ALTER TABLE t96924 DROP COLUMN b

-- Test 393: statement (line 2374)
DROP INDEX t96924_b_key CASCADE

-- Test 394: statement (line 2377)
ALTER TABLE t96924 DROP COLUMN b

-- Test 395: statement (line 2380)
ALTER TABLE t96924 DROP COLUMN c

-- Test 396: statement (line 2383)
DROP INDEX t96924_c_key CASCADE

-- Test 397: statement (line 2386)
ALTER TABLE t96924 DROP COLUMN c

-- Test 398: statement (line 2389)
ALTER TABLE t96924 DROP COLUMN d

-- Test 399: statement (line 2392)
ALTER TABLE t96924 DROP CONSTRAINT unique_d

-- Test 400: statement (line 2395)
ALTER TABLE t96924 DROP COLUMN d

-- Test 401: statement (line 2398)
ALTER TABLE t96924 DROP COLUMN e

-- Test 402: statement (line 2401)
DROP INDEX t96924_e_f_idx CASCADE

-- Test 403: statement (line 2404)
ALTER TABLE t96924 DROP COLUMN e

-- Test 404: statement (line 2409)
ALTER TABLE t96924 DROP COLUMN f

-- Test 405: statement (line 2414)
ALTER TABLE t96924 DROP COLUMN h

-- Test 406: statement (line 2417)
DROP INDEX t96924_g_idx

-- Test 407: statement (line 2420)
ALTER TABLE t96924 DROP COLUMN h

-- Test 408: statement (line 2425)
ALTER TABLE t96924 DROP COLUMN i

-- Test 409: statement (line 2428)
ALTER TABLE t96924 DROP CONSTRAINT unique_g

-- Test 410: statement (line 2431)
ALTER TABLE t96924 DROP COLUMN i

-- Test 411: statement (line 2434)
ALTER TABLE t96924 DROP COLUMN g

-- Test 412: statement (line 2440)
DROP TABLE t96924

-- Test 413: statement (line 2443)
CREATE TABLE t96924 (a INT NOT NULL)

-- Test 414: statement (line 2446)
CREATE INDEX t96924_idx_1 ON t96924(a) WHERE (rowid > 0);

skipif config local-legacy-schema-changer

-- Test 415: statement (line 2450)
ALTER TABLE t96924 ALTER PRIMARY KEY USING COLUMNS (a);

-- Test 416: statement (line 2453)
DROP INDEX t96924_idx_1

-- Test 417: statement (line 2456)
ALTER TABLE t96924 ALTER PRIMARY KEY USING COLUMNS (a);

-- Test 418: statement (line 2470)
CREATE INDEX idx97551 ON t97551 (j) WHERE (j::enum97551 = 'a'::enum97551);

-- Test 419: statement (line 2473)
DROP TYPE enum97551;

-- Test 420: statement (line 2476)
DROP INDEX idx97551;

-- Test 421: statement (line 2479)
DROP TYPE enum97551;

-- Test 422: statement (line 2484)
CREATE TYPE enum97551 AS ENUM ('a', 'b', 'c');

-- Test 423: statement (line 2487)
ALTER TABLE t97551 ADD COLUMN e enum97551;

-- Test 424: statement (line 2490)
CREATE INDEX idx97551 ON t97551 (e) WHERE (e = 'a'::enum97551);

-- Test 425: statement (line 2493)
DROP TYPE enum97551;

-- Test 426: statement (line 2496)
DROP INDEX idx97551;

-- Test 427: statement (line 2499)
DROP TABLE t97551;
DROP TYPE enum97551;

-- Test 428: statement (line 2510)
CREATE TABLE t158154 (a INT, b INT, INDEX b_idx (b) WHERE (b > 0));

-- Test 429: statement (line 2513)
CREATE PROCEDURE p158154() LANGUAGE SQL AS $$
  INSERT INTO t158154 (a) VALUES (1);
  UPDATE t158154 SET a = a + 1;
$$;

-- Test 430: statement (line 2519)
CALL p158154();

-- Test 431: statement (line 2522)
DROP INDEX t158154@b_idx;

-- Test 432: statement (line 2525)
ALTER TABLE t158154 DROP COLUMN b;

-- Test 433: statement (line 2528)
CALL p158154();

-- Test 434: statement (line 2531)
DROP PROCEDURE p158154;
DROP TABLE t158154;

-- Test 435: statement (line 2536)
CREATE TABLE t158154 (a INT, b INT);

-- Test 436: statement (line 2539)
CREATE UNIQUE INDEX a_idx ON t158154 (a) WHERE (b > 0);

-- Test 437: statement (line 2543)
CREATE PROCEDURE p158154() LANGUAGE SQL AS $$
  INSERT INTO t158154 (a) VALUES (1) ON CONFLICT (a) WHERE (false) DO NOTHING;
  INSERT INTO t158154 (a) VALUES (2) ON CONFLICT (a) WHERE (false) DO UPDATE SET a = EXCLUDED.a + 1;
$$;

-- Test 438: statement (line 2549)
CALL p158154();

-- Test 439: statement (line 2552)
DROP INDEX t158154@a_idx;

-- Test 440: statement (line 2555)
ALTER TABLE t158154 DROP COLUMN b;

-- Test 441: statement (line 2558)
CREATE UNIQUE INDEX a_idx ON t158154 (a);

-- Test 442: statement (line 2561)
CALL p158154();

-- Test 443: statement (line 2564)
DROP PROCEDURE p158154;
DROP TABLE t158154;

-- Test 444: statement (line 2570)
CREATE TABLE t158154 (a INT, b INT, INDEX b_idx (b) WHERE (b > 0));

-- Test 445: statement (line 2573)
CREATE PROCEDURE p158154() LANGUAGE SQL AS $$
  SELECT a FROM t158154;
  SELECT count(*) FROM t158154 WHERE a > 5;
$$;

-- Test 446: statement (line 2579)
CALL p158154();

-- Test 447: statement (line 2582)
DROP INDEX t158154@b_idx;

-- Test 448: statement (line 2585)
ALTER TABLE t158154 DROP COLUMN b;

-- Test 449: statement (line 2588)
CALL p158154();

-- Test 450: statement (line 2591)
DROP PROCEDURE p158154;
DROP TABLE t158154;

