-- PostgreSQL compatible tests from alter_primary_key
-- 427 tests

-- Test 1: statement (line 5)
CREATE TABLE t (x INT PRIMARY KEY, y INT NOT NULL, z INT NOT NULL, w INT, INDEX i (x), INDEX i2 (z));

-- Test 2: statement (line 8)
INSERT INTO t VALUES (1, 2, 3, 4), (5, 6, 7, 8);

-- Test 3: statement (line 11)
ALTER TABLE t ALTER PRIMARY KEY USING COLUMNS (y, y);

-- Test 4: statement (line 14)
ALTER TABLE t ALTER PRIMARY KEY USING COLUMNS (y, z)

-- Test 5: query (line 17)
SELECT * FROM t@t_pkey

-- Test 6: statement (line 23)
INSERT INTO t VALUES (9, 10, 11, 12)

-- Test 7: query (line 26)
SELECT * from t@t_pkey

-- Test 8: statement (line 33)
UPDATE t SET x = 2 WHERE z = 7

-- Test 9: query (line 36)
SELECT * from t@t_pkey

-- Test 10: query (line 43)
SELECT feature_name FROM crdb_internal.feature_usage
WHERE feature_name IN ('sql.schema.alter_table.alter_primary_key') AND usage_count > 0
ORDER BY feature_name

-- Test 11: statement (line 51)
DROP TABLE t;

-- Test 12: statement (line 54)
CREATE TABLE t (
  x INT PRIMARY KEY, y INT, z INT NOT NULL, w INT, v INT,
  INDEX i1 (y) STORING (w, v), INDEX i2 (z) STORING (y, v)
);

-- Test 13: statement (line 60)
INSERT INTO t VALUES (1, 2, 3, 4, 5), (6, 7, 8, 9, 10), (11, 12, 13, 14, 15);

-- Test 14: statement (line 63)
ALTER TABLE t ALTER PRIMARY KEY USING COLUMNS (z);

-- Test 15: statement (line 66)
INSERT INTO t VALUES (16, 17, 18, 19, 20)

-- Test 16: query (line 69)
SELECT y, w, v FROM t@i1

-- Test 17: query (line 77)
SELECT y, z, v FROM t@i2

-- Test 18: statement (line 86)
ALTER TABLE t ALTER PRIMARY KEY USING COLUMNS (gen_random_uuid());

-- Test 19: statement (line 90)
CREATE TABLE t_composite (x INT PRIMARY KEY, y DECIMAL NOT NULL);

-- Test 20: statement (line 93)
INSERT INTO t_composite VALUES (1, 1.0), (2, 1.001)

-- Test 21: statement (line 96)
ALTER TABLE t_composite ALTER PRIMARY KEY USING COLUMNS (y)

-- Test 22: query (line 99)
SELECT * FROM t_composite@t_composite_pkey

-- Test 23: statement (line 106)
DROP TABLE t_composite

-- Test 24: statement (line 112)
CREATE TABLE fk1 (x INT NOT NULL);

-- Test 25: statement (line 115)
CREATE TABLE fk2 (x INT NOT NULL, UNIQUE INDEX i (x));

-- Test 26: statement (line 118)
ALTER TABLE fk1 ADD CONSTRAINT fk FOREIGN KEY (x) REFERENCES fk2(x);

-- Test 27: statement (line 121)
INSERT INTO fk2 VALUES (1);

-- Test 28: statement (line 124)
INSERT INTO fk1 VALUES (1)

-- Test 29: statement (line 127)
ALTER TABLE fk1 ALTER PRIMARY KEY USING COLUMNS (x)

-- Test 30: statement (line 130)
INSERT INTO fk2 VALUES (2);

-- Test 31: statement (line 133)
INSERT INTO fk1 VALUES (2)

-- Test 32: statement (line 136)
ALTER TABLE fk2 ALTER PRIMARY KEY USING COLUMNS (x)

-- Test 33: statement (line 139)
INSERT INTO fk2 VALUES (3);
INSERT INTO fk1 VALUES (3)

-- Test 34: statement (line 144)
CREATE TABLE self (a INT PRIMARY KEY, x INT, y INT, z INT, w INT NOT NULL,
  INDEX (x), UNIQUE INDEX (y), INDEX (z));

-- Test 35: statement (line 148)
INSERT INTO self VALUES (1, 1, 1, 1, 1);

-- Test 36: statement (line 151)
ALTER TABLE self ADD CONSTRAINT fk1 FOREIGN KEY (z) REFERENCES self (y);

-- Test 37: statement (line 154)
ALTER TABLE self ADD CONSTRAINT fk2 FOREIGN KEY (x) REFERENCES self (y);

-- Test 38: statement (line 157)
ALTER TABLE self ALTER PRIMARY KEY USING COLUMNS (w)

-- Test 39: statement (line 160)
INSERT INTO self VALUES (2, 1, 2, 1, 2);
INSERT INTO self VALUES (3, 2, 3, 2, 3)

-- Test 40: statement (line 165)
CREATE TABLE t1 (x INT PRIMARY KEY, y INT NOT NULL, z INT, w INT, INDEX (y), INDEX (z), UNIQUE INDEX (w));

-- Test 41: statement (line 168)
CREATE TABLE t2 (y INT, UNIQUE INDEX (y));

-- Test 42: statement (line 171)
CREATE TABLE t3 (z INT, UNIQUE INDEX (z));

-- Test 43: statement (line 174)
CREATE TABLE t4 (w INT, INDEX (w));

-- Test 44: statement (line 177)
CREATE TABLE t5 (x INT, INDEX (x));

-- Test 45: statement (line 180)
INSERT INTO t1 VALUES (1, 1, 1, 1);
INSERT INTO t2 VALUES (1);
INSERT INTO t3 VALUES (1);
INSERT INTO t4 VALUES (1);
INSERT INTO t5 VALUES (1);

-- Test 46: statement (line 187)
ALTER TABLE t1 ADD CONSTRAINT fk1 FOREIGN KEY (y) REFERENCES t2(y);

-- Test 47: statement (line 190)
ALTER TABLE t1 ADD CONSTRAINT fk2 FOREIGN KEY (z) REFERENCES t3(z);

-- Test 48: statement (line 193)
ALTER TABLE t4 ADD CONSTRAINT fk3 FOREIGN KEY (w) REFERENCES t1(w);

-- Test 49: statement (line 196)
ALTER TABLE t5 ADD CONSTRAINT fk4 FOREIGN KEY (x) REFERENCES t1(x);

-- Test 50: statement (line 199)
ALTER TABLE t1 ALTER PRIMARY KEY USING COLUMNS (y)

-- Test 51: statement (line 202)
INSERT INTO t2 VALUES (5);
INSERT INTO t3 VALUES (6);
INSERT INTO t1 VALUES (7, 5, 6, 8);
INSERT INTO t4 VALUES (8);
INSERT INTO t5 VALUES (7)

-- Test 52: statement (line 209)
INSERT INTO t1 VALUES (100, 100, 100, 100)

-- Test 53: statement (line 212)
INSERT INTO t4 VALUES (101)

-- Test 54: statement (line 216)
DROP TABLE IF EXISTS t;

-- Test 55: statement (line 219)
CREATE TABLE t (rowid INT PRIMARY KEY, y INT NOT NULL, FAMILY (rowid, y));

-- Test 56: statement (line 222)
ALTER TABLE t ALTER PRIMARY KEY USING COLUMNS (y)

onlyif config schema-locked-disabled

-- Test 57: query (line 226)
SHOW CREATE t

-- Test 58: query (line 238)
SHOW CREATE t

-- Test 59: statement (line 251)
DROP TABLE IF EXISTS t;

-- Test 60: statement (line 254)
CREATE TABLE t (
  x INT PRIMARY KEY,
  y INT NOT NULL, -- will be new primary key.
  z INT NOT NULL,
  w INT,
  v JSONB,
  INDEX i1 (w), -- will get rewritten.
  INDEX i2 (y), -- will get rewritten.
  UNIQUE INDEX i3 (z) STORING (y), -- will be rewritten.
  UNIQUE INDEX i4 (z), -- will be rewritten.
  UNIQUE INDEX i5 (w) STORING (y), -- will be rewritten.
  INVERTED INDEX i6 (v), -- will be rewritten.
  INDEX i7 (z) USING HASH WITH (bucket_count=4), -- will be rewritten.
  FAMILY (x, y, z, w, v)
);

-- Test 61: statement (line 274)
ALTER TABLE t SET (schema_locked = false);

-- Test 62: statement (line 277)
INSERT INTO t VALUES (1, 2, 3, 4, '{}');

-- Test 63: statement (line 280)
ALTER TABLE t ALTER PRIMARY KEY USING COLUMNS (y)

-- Test 64: query (line 283)
SHOW CREATE t

-- Test 65: query (line 311)
SELECT index_id, index_name FROM crdb_internal.table_indexes WHERE descriptor_name = 't' ORDER BY index_name

-- Test 66: query (line 325)
SELECT index_id, index_name FROM crdb_internal.table_indexes WHERE descriptor_name = 't' ORDER BY index_name

-- Test 67: query (line 340)
SELECT * FROM [EXPLAIN SELECT * FROM t@i1] WHERE info !~ '(distribution|vectorized):.*'

-- Test 68: query (line 352)
SELECT * FROM t@i1

-- Test 69: query (line 357)
SELECT * FROM [EXPLAIN SELECT * FROM t@i2] WHERE info !~ '(distribution|vectorized):.*'

-- Test 70: query (line 369)
SELECT * FROM t@i2

-- Test 71: query (line 374)
SELECT * FROM [EXPLAIN SELECT * FROM t@i3] WHERE info !~ '(distribution|vectorized):.*'

-- Test 72: query (line 386)
SELECT * FROM t@i3

-- Test 73: query (line 391)
SELECT * FROM [EXPLAIN SELECT * FROM t@i4] WHERE info !~ '(distribution|vectorized):.*'

-- Test 74: query (line 403)
SELECT * FROM t@i4

-- Test 75: query (line 408)
SELECT * FROM [EXPLAIN SELECT * FROM t@i5] WHERE info !~ '(distribution|vectorized):.*'

-- Test 76: query (line 420)
SELECT * FROM t@i5

-- Test 77: query (line 425)
SELECT * FROM [EXPLAIN SELECT * FROM t@i7] WHERE info !~ '(distribution|vectorized):.*'

-- Test 78: query (line 437)
SELECT * FROM t@i5

-- Test 79: statement (line 448)
DROP TABLE IF EXISTS t;

-- Test 80: statement (line 451)
$index_rewrites_t_create_statement

-- Test 81: statement (line 458)
DROP TABLE IF EXISTS t;

-- Test 82: statement (line 461)
CREATE TABLE t (
  x INT PRIMARY KEY,
  y INT NOT NULL,
  z INT,
  INDEX i1 (z) USING HASH WITH (bucket_count=5),
  FAMILY (x, y, z)
);

-- Test 83: statement (line 470)
INSERT INTO t VALUES (1, 2, 3);

-- Test 84: statement (line 476)
ALTER TABLE t SET (schema_locked = false);

-- Test 85: statement (line 479)
ALTER TABLE t ALTER PRIMARY KEY USING COLUMNS (y) USING HASH WITH (bucket_count=10)

-- Test 86: query (line 482)
SHOW CREATE t

-- Test 87: query (line 497)
SELECT * FROM [EXPLAIN INSERT INTO t VALUES (4, 5, 6)] WHERE info !~ '(distribution|vectorized):.*'

-- Test 88: query (line 508)
SELECT index_id, index_name FROM crdb_internal.table_indexes WHERE descriptor_name = 't' ORDER BY index_name

-- Test 89: query (line 516)
SELECT index_id, index_name FROM crdb_internal.table_indexes WHERE descriptor_name = 't' ORDER BY index_name

-- Test 90: query (line 523)
SELECT * FROM t@t_pkey

-- Test 91: query (line 528)
SELECT * FROM t@t_x_key

-- Test 92: query (line 533)
SELECT * FROM t@i1

-- Test 93: statement (line 539)
DROP TABLE IF EXISTS t;

-- Test 94: statement (line 542)
CREATE TABLE t (
  x INT PRIMARY KEY USING HASH WITH (bucket_count=5),
  y INT NOT NULL,
  z INT,
  INDEX i (z),
  FAMILY (x, y, z)
);

-- Test 95: statement (line 551)
INSERT INTO t VALUES (1, 2, 3);

-- Test 96: statement (line 557)
ALTER TABLE t SET (schema_locked = false);

-- Test 97: statement (line 560)
ALTER TABLE t ALTER PRIMARY KEY USING COLUMNS (y)

-- Test 98: query (line 563)
SHOW CREATE t

-- Test 99: query (line 577)
SELECT * FROM t@t_x_key

-- Test 100: query (line 582)
SELECT * FROM t@i

-- Test 101: statement (line 588)
DROP TABLE IF EXISTS t;

-- Test 102: statement (line 591)
CREATE TABLE t (rowid INT NOT NULL);

onlyif config schema-locked-disabled

-- Test 103: query (line 595)
SHOW CREATE t

-- Test 104: query (line 605)
SHOW CREATE t

-- Test 105: statement (line 614)
ALTER TABLE t ALTER PRIMARY KEY USING COLUMNS (rowid)

-- Test 106: query (line 620)
SHOW CREATE t

-- Test 107: query (line 629)
SHOW CREATE t

-- Test 108: statement (line 642)
DROP TABLE IF EXISTS t;

-- Test 109: statement (line 645)
CREATE TABLE t (x INT PRIMARY KEY, y INT NOT NULL, z INT NOT NULL, FAMILY (x, y, z));

-- Test 110: statement (line 648)
INSERT INTO t VALUES (1, 2, 3);

-- Test 111: statement (line 651)
ALTER TABLE t ALTER PRIMARY KEY USING COLUMNS (z);

-- Test 112: statement (line 654)
UPDATE t SET y = 3 WHERE z = 3

-- Test 113: statement (line 659)
DROP TABLE IF EXISTS t;

-- Test 114: statement (line 662)
CREATE TABLE t (x INT PRIMARY KEY, y INT NOT NULL) WITH (schema_locked = false);

-- Test 115: statement (line 665)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl = false;

-- Test 116: statement (line 669)
ALTER TABLE t ALTER PRIMARY KEY USING COLUMNS (y)

-- Test 117: statement (line 672)
CREATE INDEX ON t (y)

-- Test 118: statement (line 675)
ROLLBACK

-- Test 119: statement (line 678)
DROP TABLE IF EXISTS t;

-- Test 120: statement (line 681)
CREATE TABLE t (x INT PRIMARY KEY, y INT NOT NULL) WITH (schema_locked = false)

-- Test 121: statement (line 684)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl = false;

-- Test 122: statement (line 688)
ALTER TABLE t ALTER PRIMARY KEY USING COLUMNS (y)

-- Test 123: statement (line 691)
ALTER TABLE t ADD COLUMN z INT

-- Test 124: statement (line 694)
ROLLBACK

-- Test 125: statement (line 699)
DROP TABLE IF EXISTS t;

-- Test 126: statement (line 702)
CREATE TABLE t (x INT PRIMARY KEY)

-- Test 127: statement (line 705)
ALTER TABLE t ADD PRIMARY KEY (x)

-- Test 128: statement (line 708)
DROP TABLE IF EXISTS t;

-- Test 129: statement (line 711)
CREATE TABLE t (x INT NOT NULL)

-- Test 130: statement (line 714)
ALTER TABLE t ADD PRIMARY KEY (x)

-- Test 131: query (line 720)
SHOW CREATE t

-- Test 132: query (line 729)
SHOW CREATE t

-- Test 133: statement (line 737)
DROP TABLE IF EXISTS t;

-- Test 134: statement (line 740)
CREATE TABLE t (x INT NOT NULL);

-- Test 135: statement (line 743)
ALTER TABLE t ADD PRIMARY KEY (x) USING HASH WITH (bucket_count=4)

onlyif config schema-locked-disabled
skipif config local-legacy-schema-changer

-- Test 136: query (line 748)
SHOW CREATE t

-- Test 137: query (line 758)
SHOW CREATE t

-- Test 138: statement (line 767)
DROP TABLE IF EXISTS t;

-- Test 139: statement (line 770)
CREATE TABLE t (x INT NOT NULL);

-- Test 140: statement (line 773)
ALTER TABLE t ADD CONSTRAINT "my_pk" PRIMARY KEY (x)

-- Test 141: query (line 779)
SHOW CREATE t

-- Test 142: query (line 788)
SHOW CREATE t

-- Test 143: statement (line 796)
CREATE INDEX i ON t (x)

skipif config schema-locked-disabled

-- Test 144: statement (line 800)
ALTER TABLE t SET (schema_locked = false);

-- Test 145: statement (line 803)
ALTER TABLE t DROP CONSTRAINT "my_pk", ADD CONSTRAINT "i" PRIMARY KEY (x);

skipif config schema-locked-disabled

-- Test 146: statement (line 807)
ALTER TABLE t SET (schema_locked = true);

-- Test 147: statement (line 811)
DROP TABLE IF EXISTS t;

-- Test 148: statement (line 814)
CREATE TABLE t (x INT NOT NULL) WITH (schema_locked = false)

-- Test 149: statement (line 817)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl = false;

-- Test 150: statement (line 821)
ALTER TABLE t ADD COLUMN y INT

-- Test 151: statement (line 824)
ALTER TABLE t ALTER PRIMARY KEY USING COLUMNS (x)

-- Test 152: statement (line 827)
ROLLBACK

-- Test 153: statement (line 833)
DROP TABLE IF EXISTS t;

-- Test 154: statement (line 836)
CREATE TABLE t (x INT NOT NULL);

-- Test 155: statement (line 839)
ALTER TABLE t ALTER PRIMARY KEY USING COLUMNS (x)

-- Test 156: statement (line 850)
DROP TABLE IF EXISTS t;

-- Test 157: statement (line 854)
CREATE TABLE t (x INT PRIMARY KEY, y INT NOT NULL, FAMILY (x), FAMILY (y)) WITH (schema_locked = false)

-- Test 158: statement (line 857)
ALTER TABLE t DROP CONSTRAINT "t_pkey"

-- Test 159: statement (line 860)
ALTER TABLE t ADD CONSTRAINT "t_pkey" PRIMARY KEY (y), DROP CONSTRAINT "t_pkey"

-- Test 160: statement (line 863)
ALTER TABLE t ADD CONSTRAINT "t_pkey" PRIMARY KEY (y)

-- Test 161: statement (line 866)
ALTER TABLE t DROP CONSTRAINT "t_pkey", ADD CONSTRAINT "t_pkey" PRIMARY KEY (y)

-- Test 162: statement (line 869)
ALTER TABLE t DROP CONSTRAINT "t_pkey", ADD CONSTRAINT "t_pkey_v2" PRIMARY KEY (y)

-- Test 163: query (line 874)
SHOW CREATE t

-- Test 164: query (line 887)
SHOW CREATE t

-- Test 165: statement (line 899)
ALTER TABLE t ADD CONSTRAINT IF NOT EXISTS "t_pkey" PRIMARY KEY (x)

-- Test 166: statement (line 904)
DROP TABLE t;

-- Test 167: statement (line 907)
CREATE TABLE t (x INT PRIMARY KEY, y INT NOT NULL, FAMILY (x), FAMILY (y)) WITH (schema_locked = false)

-- Test 168: statement (line 910)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl = false;

-- Test 169: statement (line 914)
ALTER TABLE t DROP CONSTRAINT "t_pkey"

-- Test 170: statement (line 917)
ALTER TABLE t ADD CONSTRAINT "t_pkey" PRIMARY KEY (y)

-- Test 171: statement (line 920)
ROLLBACK;

-- Test 172: statement (line 923)
DROP TABLE t;

-- Test 173: statement (line 926)
CREATE TABLE t (x INT PRIMARY KEY, y INT NOT NULL, FAMILY (x), FAMILY (y))  WITH (schema_locked = false)

-- Test 174: statement (line 929)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl = false;

-- Test 175: statement (line 933)
ALTER TABLE t DROP CONSTRAINT "t_pkey"

-- Test 176: statement (line 936)
ALTER TABLE t ADD CONSTRAINT "t_pkey_v2" PRIMARY KEY (y)

-- Test 177: statement (line 939)
COMMIT

-- Test 178: query (line 942)
SHOW CREATE t

-- Test 179: statement (line 955)
DROP TABLE t;

-- Test 180: statement (line 958)
CREATE TABLE t (x INT PRIMARY KEY, y INT NOT NULL) WITH (schema_locked = false)

-- Test 181: statement (line 961)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl = false;

-- Test 182: statement (line 965)
ALTER TABLE t DROP CONSTRAINT t_pkey

-- Test 183: statement (line 968)
INSERT INTO t VALUES (1, 1)

-- Test 184: statement (line 971)
ROLLBACK

-- Test 185: statement (line 974)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl = false;

-- Test 186: statement (line 978)
ALTER TABLE t DROP CONSTRAINT t_pkey

-- Test 187: statement (line 981)
DELETE FROM t WHERE x = 1

-- Test 188: statement (line 984)
ROLLBACK

-- Test 189: statement (line 987)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl = false;

-- Test 190: statement (line 991)
ALTER TABLE t DROP CONSTRAINT t_pkey

-- Test 191: statement (line 994)
UPDATE t SET x = 1 WHERE y = 1

-- Test 192: statement (line 997)
ROLLBACK

-- Test 193: statement (line 1000)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl = false;

-- Test 194: statement (line 1004)
ALTER TABLE t DROP CONSTRAINT t_pkey

-- Test 195: statement (line 1007)
SELECT * FROM t

-- Test 196: statement (line 1010)
ROLLBACK

-- Test 197: statement (line 1016)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl = false;

-- Test 198: statement (line 1020)
ALTER TABLE t DROP CONSTRAINT t_pkey

-- Test 199: statement (line 1023)
CREATE INDEX ON t(x)

-- Test 200: statement (line 1026)
ROLLBACK

-- Test 201: statement (line 1029)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl = false;

-- Test 202: statement (line 1033)
ALTER TABLE t DROP CONSTRAINT t_pkey

-- Test 203: statement (line 1036)
ALTER TABLE t ADD COLUMN z INT

-- Test 204: statement (line 1039)
ROLLBACK

-- Test 205: statement (line 1042)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl = false;

-- Test 206: statement (line 1046)
ALTER TABLE t DROP CONSTRAINT t_pkey

-- Test 207: statement (line 1049)
ALTER TABLE t ADD COLUMN z INT, ADD PRIMARY KEY (x)

-- Test 208: statement (line 1052)
ROLLBACK

-- Test 209: statement (line 1057)
DROP TABLE IF EXISTS t1, t2 CASCADE;

-- Test 210: statement (line 1060)
CREATE TABLE t1 (x INT PRIMARY KEY, y INT NOT NULL) WITH (schema_locked = false);

-- Test 211: statement (line 1063)
CREATE TABLE t2 (x INT) WITH (schema_locked = false)

-- Test 212: statement (line 1066)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl = false;

-- Test 213: statement (line 1070)
ALTER TABLE t1 DROP CONSTRAINT t1_pkey

-- Test 214: statement (line 1073)
INSERT INTO t2 VALUES (1)

-- Test 215: statement (line 1076)
COMMIT

-- Test 216: query (line 1079)
SELECT * FROM t2

-- Test 217: statement (line 1083)
DROP TABLE IF EXISTS t;

-- Test 218: statement (line 1086)
CREATE TABLE t (x INT PRIMARY KEY, y INT NOT NULL) WITH (schema_locked = false)

onlyif config local-legacy-schema-changer

-- Test 219: statement (line 1090)
ALTER TABLE t DROP CONSTRAINT t_pkey, ADD COLUMN z INT AS (x + 1) STORED, ADD PRIMARY KEY (y)

-- Test 220: statement (line 1096)
ALTER TABLE t DROP CONSTRAINT t_pkey, ADD COLUMN z INT AS (x + 1) STORED, ADD PRIMARY KEY (y)

skipif config local-legacy-schema-changer

-- Test 221: query (line 1100)
SHOW CREATE t

-- Test 222: statement (line 1113)
DROP TABLE IF EXISTS t CASCADE

-- Test 223: statement (line 1116)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl = false;

-- Test 224: statement (line 1120)
CREATE TABLE t (x INT NOT NULL, y INT, FAMILY (x, y), INDEX (y))

-- Test 225: statement (line 1123)
ALTER TABLE t ADD PRIMARY KEY (x)

-- Test 226: statement (line 1126)
COMMIT

onlyif config schema-locked-disabled

-- Test 227: query (line 1130)
SHOW CREATE t

-- Test 228: query (line 1144)
SELECT index_id, index_name FROM crdb_internal.table_indexes WHERE descriptor_name = 't' ORDER BY index_id

-- Test 229: statement (line 1152)
DROP TABLE IF EXISTS t

-- Test 230: statement (line 1155)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl = false;

-- Test 231: statement (line 1159)
CREATE TABLE t (x INT NOT NULL, y INT, FAMILY (x, y), INDEX (y))

-- Test 232: statement (line 1162)
ALTER TABLE t ALTER PRIMARY KEY USING COLUMNS (x)

-- Test 233: statement (line 1165)
COMMIT

onlyif config schema-locked-disabled

-- Test 234: query (line 1169)
SHOW CREATE t

-- Test 235: query (line 1183)
SHOW CREATE t

-- Test 236: query (line 1197)
SELECT index_id, index_name FROM crdb_internal.table_indexes WHERE descriptor_name = 't' ORDER BY index_id

-- Test 237: statement (line 1204)
DROP TABLE IF EXISTS t

skip_on_retry

-- Test 238: statement (line 1209)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl = false;

-- Test 239: statement (line 1213)
CREATE TABLE t (
  x INT NOT NULL, y INT, z INT, w INT,
  INDEX i1 (y), UNIQUE INDEX i2 (z),
  INDEX i3 (w) STORING (y, z),
  FAMILY (x, y, z, w)
)

-- Test 240: statement (line 1221)
ALTER TABLE t ADD PRIMARY KEY (x)

-- Test 241: statement (line 1224)
COMMIT

onlyif config schema-locked-disabled

-- Test 242: query (line 1228)
SHOW CREATE t

-- Test 243: query (line 1245)
SHOW CREATE t

-- Test 244: query (line 1262)
SELECT index_id, index_name FROM crdb_internal.table_indexes WHERE descriptor_name = 't' ORDER BY index_id

-- Test 245: statement (line 1273)
DROP TABLE IF EXISTS t CASCADE;

-- Test 246: statement (line 1276)
CREATE TABLE t (x INT PRIMARY KEY USING HASH WITH (bucket_count=2));

-- Test 247: statement (line 1279)
ALTER TABLE t ALTER PRIMARY KEY USING COLUMNS (x) USING HASH WITH (bucket_count=3)

-- Test 248: query (line 1285)
SHOW CREATE t

-- Test 249: query (line 1295)
SHOW CREATE t

-- Test 250: statement (line 1306)
DROP TABLE t;

-- Test 251: statement (line 1309)
CREATE TABLE t (x INT PRIMARY KEY USING HASH WITH (bucket_count=2), y INT NOT NULL, FAMILY (x, y));

-- Test 252: statement (line 1312)
ALTER TABLE t ALTER PRIMARY KEY USING COLUMNS (y) USING HASH WITH (bucket_count=2)

onlyif config schema-locked-disabled

-- Test 253: query (line 1316)
SHOW CREATE t

-- Test 254: query (line 1330)
SHOW CREATE t

-- Test 255: statement (line 1344)
DROP TABLE t;

-- Test 256: statement (line 1347)
CREATE TABLE t (x INT, y INT, z INT, PRIMARY KEY (x, y));

-- Test 257: statement (line 1350)
ALTER TABLE t ALTER PRIMARY KEY USING COLUMNS (y);

-- Test 258: statement (line 1353)
SET sql_safe_updates=false;

-- Test 259: statement (line 1356)
ALTER TABLE t DROP COLUMN z

-- Test 260: statement (line 1360)
CREATE TABLE t54629 (c INT NOT NULL, UNIQUE INDEX (c));

-- Test 261: statement (line 1363)
ALTER TABLE t54629 ALTER PRIMARY KEY USING COLUMNS (c);

-- Test 262: statement (line 1366)
INSERT INTO t54629 VALUES (1);

-- Test 263: statement (line 1369)
DELETE FROM t54629 WHERE c = 1

-- Test 264: statement (line 1372)
DROP TABLE t54629;

-- Test 265: statement (line 1375)
CREATE TABLE t54629(a INT PRIMARY KEY, c INT NOT NULL, UNIQUE INDEX (c));

-- Test 266: statement (line 1378)
ALTER TABLE t54629 ALTER PRIMARY KEY USING COLUMNS (c);

-- Test 267: statement (line 1381)
DROP INDEX t54629_a_key CASCADE;

-- Test 268: statement (line 1384)
INSERT INTO t54629 VALUES (1, 1);

-- Test 269: statement (line 1387)
DELETE FROM t54629 WHERE c = 1;

-- Test 270: statement (line 1391)
DROP TABLE t1 CASCADE;

-- Test 271: statement (line 1394)
create table t1(id integer not null, id2 integer not null, name varchar(32));

-- Test 272: query (line 1397)
SELECT index_name, column_name, direction
  FROM [SHOW INDEXES FROM t1]
  WHERE index_name LIKE 'primary%'
  ORDER BY 1,2,3;

-- Test 273: statement (line 1404)
alter table t1 alter primary key using columns(id, id2);

-- Test 274: query (line 1409)
SELECT index_name, column_name, direction FROM [SHOW INDEXES FROM t1] ORDER BY 1,2,3

-- Test 275: statement (line 1416)
alter table t1 alter primary key using columns(id, id2);

-- Test 276: query (line 1421)
SELECT index_name, column_name, direction FROM [SHOW INDEXES FROM t1] ORDER BY 1,2,3

-- Test 277: statement (line 1429)
ALTER TABLE t1 SET (schema_locked = false)

-- Test 278: statement (line 1433)
alter table t1 drop constraint t1_pkey, alter primary key using columns(id, id2);

skipif config schema-locked-disabled

-- Test 279: statement (line 1437)
ALTER TABLE t1 SET (schema_locked = true)

-- Test 280: query (line 1442)
SELECT index_name, column_name, direction FROM [SHOW INDEXES FROM t1] ORDER BY 1,2,3

-- Test 281: statement (line 1449)
alter table t1 alter primary key using columns(id);

-- Test 282: query (line 1454)
SELECT index_name, column_name, direction FROM [SHOW INDEXES FROM t1] ORDER BY 1,2,3

-- Test 283: statement (line 1463)
alter table t1 alter primary key using columns(id desc);

-- Test 284: query (line 1468)
SELECT index_name, column_name, direction FROM [SHOW INDEXES FROM t1] ORDER BY 1,2,3

-- Test 285: statement (line 1479)
alter table t1 alter primary key using columns(id desc);

-- Test 286: query (line 1484)
SELECT index_name, column_name, direction FROM [SHOW INDEXES FROM t1] ORDER BY 1,2,3

-- Test 287: statement (line 1494)
alter table t1 alter primary key using columns(id desc);

-- Test 288: query (line 1499)
SELECT index_name, column_name, direction FROM [SHOW INDEXES FROM t1] ORDER BY 1,2,3

-- Test 289: statement (line 1509)
alter table t1 alter primary key using columns(id) USING HASH WITH (bucket_count=10)

-- Test 290: query (line 1514)
SELECT index_name, column_name, direction FROM [SHOW INDEXES FROM t1] ORDER BY 1,2,3

-- Test 291: statement (line 1529)
CREATE TABLE table_with_virtual_cols (
  id INT PRIMARY KEY,
  new_pk INT NOT NULL,
  virtual_col INT AS (1::int) VIRTUAL,
  FAMILY (id, new_pk)
);
ALTER TABLE table_with_virtual_cols ALTER PRIMARY KEY USING COLUMNS (new_pk)

onlyif config schema-locked-disabled

-- Test 292: query (line 1539)
SHOW CREATE TABLE table_with_virtual_cols

-- Test 293: query (line 1552)
SHOW CREATE TABLE table_with_virtual_cols

-- Test 294: statement (line 1568)
DROP TABLE IF EXISTS t;

-- Test 295: statement (line 1571)
CREATE TABLE t (i INT PRIMARY KEY)

-- Test 296: query (line 1574)
SELECT index_name,column_name,direction FROM [SHOW INDEXES FROM t]

-- Test 297: statement (line 1579)
ALTER TABLE t ALTER PRIMARY KEY USING COLUMNS (i) USING HASH WITH (bucket_count=2)

-- Test 298: query (line 1582)
SELECT index_name,column_name,direction FROM [SHOW INDEXES FROM t]

-- Test 299: statement (line 1588)
ALTER TABLE t ALTER PRIMARY KEY USING COLUMNS (i);

-- Test 300: query (line 1591)
SELECT index_name,column_name,direction FROM [SHOW INDEXES FROM t]

-- Test 301: statement (line 1601)
CREATE TABLE t71553 (a INT PRIMARY KEY, b INT NOT NULL);

-- Test 302: statement (line 1604)
INSERT INTO t71553 VALUES (1, 1);

-- Test 303: statement (line 1607)
ALTER TABLE t71553 ALTER PRIMARY KEY USING COLUMNS (b);

-- Test 304: query (line 1610)
SELECT * FROM t71553

-- Test 305: statement (line 1615)
ALTER TABLE t71553 ALTER PRIMARY KEY USING COLUMNS (a);

-- Test 306: query (line 1618)
SELECT * FROM t71553

-- Test 307: query (line 1623)
SELECT * FROM t71553@t71553_a_key

-- Test 308: query (line 1628)
SELECT * FROM t71553@t71553_b_key

-- Test 309: statement (line 1634)
DROP TABLE IF EXISTS t;

-- Test 310: statement (line 1637)
CREATE TABLE t (
  a INT NOT NULL,
  b INT NOT NULL,
  k INT NOT NULL AS (a+b) VIRTUAL,
  PRIMARY KEY (a),
  INDEX t_idx_b_k (b, k),
  FAMILY "primary" (a, b)
);

-- Test 311: statement (line 1647)
INSERT INTO t VALUES (1,2), (3,4);

-- Test 312: query (line 1650)
SELECT * FROM t@t_pkey;

-- Test 313: query (line 1657)
SELECT * FROM t@t_idx_b_k;

-- Test 314: statement (line 1664)
ALTER TABLE t ALTER PRIMARY KEY USING COLUMNS (k);

onlyif config schema-locked-disabled

-- Test 315: query (line 1668)
SELECT create_statement FROM [SHOW CREATE TABLE t];

-- Test 316: query (line 1681)
SELECT create_statement FROM [SHOW CREATE TABLE t];

-- Test 317: query (line 1693)
SELECT * FROM t@t_pkey

-- Test 318: query (line 1700)
SELECT * FROM t@t_a_key

-- Test 319: query (line 1707)
SELECT * FROM t@t_idx_b_k

-- Test 320: statement (line 1714)
ALTER TABLE t ALTER PRIMARY KEY USING COLUMNS (b, k);

onlyif config schema-locked-disabled

-- Test 321: query (line 1718)
SELECT create_statement FROM [SHOW CREATE TABLE t];

-- Test 322: query (line 1733)
SELECT create_statement FROM [SHOW CREATE TABLE t];

-- Test 323: query (line 1746)
SELECT * FROM t@t_pkey

-- Test 324: query (line 1753)
SELECT * FROM t@t_a_key

-- Test 325: query (line 1760)
SELECT * FROM t@t_k_key

-- Test 326: query (line 1767)
SELECT * FROM t@t_idx_b_k

-- Test 327: statement (line 1774)
ALTER TABLE t ALTER PRIMARY KEY USING COLUMNS (a);

onlyif config schema-locked-disabled

-- Test 328: query (line 1778)
SELECT create_statement FROM [SHOW CREATE TABLE t];

-- Test 329: query (line 1794)
SELECT create_statement FROM [SHOW CREATE TABLE t];

-- Test 330: query (line 1808)
SELECT * FROM t@t_pkey

-- Test 331: query (line 1815)
SELECT * FROM t@t_a_key

-- Test 332: query (line 1822)
SELECT * FROM t@t_k_key

-- Test 333: query (line 1829)
SELECT * FROM t@t_idx_b_k

-- Test 334: query (line 1836)
SELECT * FROM t@t_b_k_key

-- Test 335: statement (line 1845)
CREATE TABLE t_test_param (
  a INT PRIMARY KEY,
  b INT NOT NULL,
  FAMILY fam_0_a_b (a, b)
);

-- Test 336: statement (line 1852)
ALTER TABLE t_test_param ALTER PRIMARY KEY USING COLUMNS (b) WITH (s2_max_level=20);

-- Test 337: statement (line 1855)
ALTER TABLE t_test_param ALTER PRIMARY KEY USING COLUMNS (b) USING HASH WITH (s2_max_level=20);

-- Test 338: statement (line 1858)
ALTER TABLE t_test_param ALTER PRIMARY KEY USING COLUMNS (b) WITH (bucket_count=5);

-- Test 339: statement (line 1861)
ALTER TABLE t_test_param ALTER PRIMARY KEY USING COLUMNS (b) USING HASH WITH BUCKET_COUNT = 5 WITH (bucket_count=5);

-- Test 340: statement (line 1865)
ALTER TABLE t_test_param ALTER PRIMARY KEY USING COLUMNS (b) USING HASH WITH BUCKET_COUNT = 5;

onlyif config schema-locked-disabled

-- Test 341: query (line 1869)
SELECT create_statement FROM [SHOW CREATE TABLE t_test_param]

-- Test 342: query (line 1882)
SELECT create_statement FROM [SHOW CREATE TABLE t_test_param]

-- Test 343: statement (line 1897)
CREATE TABLE pkey_comment (a INT8, b INT8, c INT8, CONSTRAINT pkey PRIMARY KEY (a, b));

-- Test 344: statement (line 1900)
COMMENT ON INDEX pkey IS 'idx';
COMMENT ON CONSTRAINT pkey ON pkey_comment IS 'const';

-- Test 345: statement (line 1905)
CREATE UNIQUE INDEX i2 ON pkey_comment(c);

-- Test 346: statement (line 1908)
COMMENT ON INDEX i2 IS 'idx2';
COMMENT ON CONSTRAINT i2 ON pkey_comment IS 'idx3';

-- Test 347: query (line 1913)
SELECT substring(create_statement, strpos(create_statement, 'COMMENT')) FROM [SHOW CREATE pkey_comment];

-- Test 348: statement (line 1922)
ALTER TABLE pkey_comment ALTER PRIMARY KEY USING COLUMNS (b);

-- Test 349: query (line 1929)
SELECT trim(trailing ';' from unnest(regexp_split_to_array(substring(create_statement, strpos(create_statement, 'COMMENT')), '\n', 'g'))) AS comment
FROM [SHOW CREATE pkey_comment]
ORDER BY comment;

-- Test 350: statement (line 1946)
DROP TABLE IF EXISTS t;

-- Test 351: statement (line 1949)
CREATE TABLE t (a INT PRIMARY KEY, b INT NOT NULL, UNIQUE INDEX t_a_key (a));

-- Test 352: statement (line 1952)
ALTER TABLE t ALTER PRIMARY KEY USING COLUMNS (b);

-- Test 353: query (line 1955)
SELECT index_name, column_name, direction FROM [SHOW INDEXES FROM t]

-- Test 354: statement (line 1967)
DROP TABLE IF EXISTS t;

-- Test 355: statement (line 1970)
CREATE TABLE t (a INT PRIMARY KEY, b INT NOT NULL, UNIQUE INDEX t_a_b_key (a, b));

-- Test 356: statement (line 1973)
ALTER TABLE t ALTER PRIMARY KEY USING COLUMNS (b);

-- Test 357: query (line 1979)
SELECT index_name, column_name, direction, storing FROM [SHOW INDEXES FROM t] ORDER BY 1,2,3,4;

-- Test 358: statement (line 1995)
DROP TABLE IF EXISTS t

-- Test 359: statement (line 1998)
CREATE TABLE t (
  a INT NOT NULL,
  b INT NOT NULL,
  c INT NOT NULL,
  PRIMARY KEY (a, b),
  UNIQUE INDEX uniq_idx (c)
);

-- Test 360: statement (line 2007)
ALTER TABLE t ALTER PRIMARY KEY USING COLUMNS (a)

-- Test 361: statement (line 2010)
ALTER TABLE t DROP COLUMN b

-- Test 362: query (line 2013)
SELECT index_name, column_name, direction FROM [SHOW INDEXES FROM t] ORDER BY 1,2,3

-- Test 363: statement (line 2024)
DROP TABLE IF EXISTS t;

-- Test 364: statement (line 2027)
CREATE TABLE t (
	i INT PRIMARY KEY USING HASH WITH (bucket_count=7) DEFAULT unique_rowid(),
	j INT NOT NULL UNIQUE
)

-- Test 365: statement (line 2036)
ALTER TABLE t SET (schema_locked = false);

-- Test 366: query (line 2040)
SELECT index_name, column_name, direction FROM [SHOW INDEXES FROM t] ORDER BY 1,2,3

-- Test 367: statement (line 2051)
ALTER TABLE t ALTER PRIMARY KEY USING COLUMNS (i)

-- Test 368: query (line 2056)
SELECT index_name,column_name,direction FROM [SHOW INDEXES FROM t] ORDER BY 1,2,3

-- Test 369: statement (line 2066)
CREATE TABLE t_multiple_cf (i INT PRIMARY KEY, j INT NOT NULL, FAMILY (i), FAMILY (j))

-- Test 370: statement (line 2069)
INSERT INTO t_multiple_cf VALUES (23, 24)

-- Test 371: statement (line 2072)
ALTER TABLE t_multiple_cf ALTER PRIMARY KEY USING COLUMNS (j)

-- Test 372: statement (line 2081)
CREATE TABLE t_child (id INT8 PRIMARY KEY, CONSTRAINT fk FOREIGN KEY (id) REFERENCES t_rowid (rowid))

-- Test 373: statement (line 2087)
ALTER TABLE t_rowid ALTER PRIMARY KEY USING COLUMNS (k)

-- Test 374: query (line 2090)
SELECT column_name FROM [SHOW COLUMNS FROM t_rowid] ORDER BY column_name;

-- Test 375: statement (line 2103)
ALTER TABLE t_rowid ALTER PRIMARY KEY USING COLUMNS (k)

-- Test 376: query (line 2108)
SELECT column_name FROM [SHOW COLUMNS FROM t_rowid] ORDER BY column_name;

-- Test 377: statement (line 2116)
CREATE TABLE t_name_check (a INT NOT NULL, CONSTRAINT ctcheck CHECK (a > 0))

skipif config local-legacy-schema-changer

-- Test 378: statement (line 2120)
ALTER TABLE t_name_check ADD CONSTRAINT ctcheck PRIMARY KEY (a)

-- Test 379: statement (line 2123)
ALTER TABLE t_name_check ADD CONSTRAINT t_name_check_pkey PRIMARY KEY (a)

-- Test 380: statement (line 2126)
DROP TABLE t_name_check

-- Test 381: statement (line 2129)
CREATE TABLE t_name_check (a INT NOT NULL, CONSTRAINT ctuniq UNIQUE (a))

skipif config local-legacy-schema-changer

-- Test 382: statement (line 2133)
ALTER TABLE t_name_check ADD CONSTRAINT ctuniq PRIMARY KEY (a)

-- Test 383: statement (line 2136)
DROP TABLE t_name_check

-- Test 384: statement (line 2139)
CREATE TABLE t_name_check (a INT NOT NULL, INDEX idx (a))

skipif config local-legacy-schema-changer

-- Test 385: statement (line 2143)
ALTER TABLE t_name_check ADD CONSTRAINT idx PRIMARY KEY (a)

-- Test 386: statement (line 2150)
CREATE TABLE t_85877(i INT NOT NULL, j INT NOT NULL, PRIMARY KEY (i))

-- Test 387: statement (line 2153)
ALTER TABLE t_85877 ALTER PRIMARY KEY USING COLUMNS (i, j)

-- Test 388: statement (line 2156)
DROP TABLE t_85877

-- Test 389: statement (line 2159)
CREATE TABLE t_85877 (i INT NOT NULL, j INT NOT NULL, PRIMARY KEY (i, j))

-- Test 390: statement (line 2162)
ALTER TABLE t_85877 ALTER PRIMARY KEY USING COLUMNS (i)

-- Test 391: statement (line 2165)
DROP TABLE t_85877

-- Test 392: statement (line 2168)
CREATE TABLE t_85877 (i INT NOT NULL, j INT NOT NULL, k INT NOT NULL, PRIMARY KEY (i, j))

-- Test 393: statement (line 2171)
ALTER TABLE t_85877 ALTER PRIMARY KEY USING COLUMNS (j, k)

-- Test 394: statement (line 2178)
CREATE TABLE t_90306 (j INT[], k INT NOT NULL, INVERTED INDEX (j));

-- Test 395: statement (line 2181)
ALTER TABLE t_90306 ALTER PRIMARY KEY USING COLUMNS (k);

-- Test 396: statement (line 2186)
CREATE TABLE t_90836(a INT NOT NULL, b INT NOT NULL, CONSTRAINT "constraint" PRIMARY KEY (a)) WITH (schema_locked = false);

-- Test 397: statement (line 2189)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl = false;
ALTER TABLE t_90836 DROP CONSTRAINT "constraint";
ALTER TABLE t_90836 ADD CONSTRAINT "constraint" PRIMARY KEY (b);
COMMIT;

-- Test 398: statement (line 2202)
CREATE TABLE t_97296 (a DECIMAL PRIMARY KEY, b INT NOT NULL, c INT NOT NULL, INDEX i4(c));

-- Test 399: statement (line 2205)
INSERT INTO t_97296 VALUES (0.0, 5, 32);

-- Test 400: statement (line 2208)
ALTER TABLE t_97296 ALTER PRIMARY KEY USING COLUMNS (b, a);

-- Test 401: statement (line 2217)
ALTER TABLE t_96730 ALTER PRIMARY KEY USING COLUMNS (j, k) USING HASH

onlyif config schema-locked-disabled

-- Test 402: query (line 2221)
SHOW CREATE TABLE t_96730

-- Test 403: query (line 2234)
SHOW CREATE TABLE t_96730

-- Test 404: statement (line 2252)
CREATE TABLE t_99303 (i INT NOT NULL PRIMARY KEY, j INT NOT NULL, UNIQUE INDEX (i) WHERE (i > 0), FAMILY "primary" (i, j));

-- Test 405: statement (line 2255)
ALTER TABLE t_99303 ALTER PRIMARY KEY USING COLUMNS (j);

onlyif config schema-locked-disabled

-- Test 406: query (line 2259)
SHOW CREATE t_99303

-- Test 407: query (line 2271)
SHOW CREATE t_99303

-- Test 408: statement (line 2292)
CREATE TABLE t_114436 (j INT NOT NULL, UNIQUE INDEX idx (j));

-- Test 409: statement (line 2295)
ALTER TABLE t_114436 ALTER PRIMARY KEY USING COLUMNS (j);

-- Test 410: statement (line 2298)
ALTER TABLE t_114436 DROP COLUMN IF EXISTS rowid;

-- Test 411: query (line 2301)
SELECT index_name, column_name, direction FROM [SHOW INDEXES FROM t_114436] ORDER BY 1,2,3

-- Test 412: statement (line 2308)
DROP TABLE t_114436;

-- Test 413: statement (line 2311)
CREATE TABLE t_114436 (i INT PRIMARY KEY, j INT NOT NULL, UNIQUE INDEX idx (j));

-- Test 414: statement (line 2314)
ALTER TABLE t_114436 ALTER PRIMARY KEY USING COLUMNS (j);

-- Test 415: statement (line 2317)
ALTER TABLE t_114436 DROP COLUMN i;

-- Test 416: query (line 2320)
SELECT index_name, column_name, direction FROM [SHOW INDEXES FROM t_114436] ORDER BY 1,2,3

-- Test 417: statement (line 2330)
CREATE TABLE tab_122871 (
  col0_4         TSVECTOR NOT NULL,
  col0_6         OID,
  col0_18        REGTYPE,
  PRIMARY KEY (col0_18 DESC)
);

-- Test 418: statement (line 2338)
ALTER TABLE tab_122871 ALTER PRIMARY KEY USING COLUMNS (col0_4);

-- Test 419: statement (line 2360)
ALTER TABLE t_view_func_ref_123017 ALTER PRIMARY KEY USING COLUMNS (a);

-- Test 420: statement (line 2363)
DROP FUNCTION f_123017;

-- Test 421: statement (line 2366)
ALTER TABLE t_view_func_ref_123017 ALTER PRIMARY KEY USING COLUMNS (a);

-- Test 422: statement (line 2369)
DROP VIEW t_view_123017;

-- Test 423: statement (line 2372)
ALTER TABLE t_view_func_ref_123017 ALTER PRIMARY KEY USING COLUMNS (a);

-- Test 424: statement (line 2379)
CREATE TABLE table_w0_66 ( "Abc" INT4 PRIMARY KEY, "ab\f" INT2 NOT NULL, FAMILY ("Abc", "ab\f"));

-- Test 425: statement (line 2382)
ALTER TABLE public.table_w0_66 ALTER PRIMARY KEY USING COLUMNS ("Abc", "ab\f") USING HASH;

onlyif config schema-locked-disabled

-- Test 426: query (line 2386)
SELECT create_statement FROM [SHOW CREATE TABLE public.table_w0_66]

-- Test 427: query (line 2399)
SELECT create_statement FROM [SHOW CREATE TABLE public.table_w0_66]
