-- PostgreSQL compatible tests from hash_sharded_index
-- 233 tests

-- Test 1: statement (line 2)
CREATE TABLE sharded_primary (a INT PRIMARY KEY USING HASH WITH (bucket_count=10))

onlyif config schema-locked-disabled

-- Test 2: query (line 6)
SHOW CREATE TABLE sharded_primary

-- Test 3: query (line 16)
SHOW CREATE TABLE sharded_primary

-- Test 4: statement (line 25)
CREATE TABLE invalid_bucket_count (k INT PRIMARY KEY USING HASH WITH (bucket_count=-1))

-- Test 5: statement (line 28)
CREATE TABLE invalid_bucket_count (k INT PRIMARY KEY USING HASH WITH (bucket_count=999999999))

-- Test 6: statement (line 31)
CREATE TABLE invalid_bucket_count (k INT PRIMARY KEY USING HASH WITH (bucket_count=1))

-- Test 7: statement (line 34)
CREATE TABLE fractional_bucket_count (k INT PRIMARY KEY USING HASH WITH (bucket_count=2.32))

-- Test 8: statement (line 37)
CREATE TABLE invalid_bucket_count (k INT PRIMARY KEY USING HASH WITH (bucket_count=(SELECT 1)))

-- Test 9: statement (line 41)
DROP TABLE sharded_primary

-- Test 10: statement (line 44)
CREATE TABLE sharded_primary (
                a INT8 NOT NULL,
                CONSTRAINT "primary" PRIMARY KEY (a ASC) USING HASH WITH (bucket_count=10),
                FAMILY "primary" (a)
)

onlyif config schema-locked-disabled

-- Test 11: query (line 52)
SHOW CREATE TABLE sharded_primary

-- Test 12: query (line 62)
SHOW CREATE TABLE sharded_primary

-- Test 13: query (line 71)
SELECT
  tablename, indexname, indexdef
FROM pg_indexes
WHERE tablename = 'sharded_primary'
ORDER BY 1, 2, 3

-- Test 14: query (line 81)
SELECT index_name, column_name, implicit FROM [SHOW INDEXES FROM sharded_primary]
ORDER BY index_name, seq_in_index

-- Test 15: query (line 88)
SELECT index_name, column_name, implicit FROM crdb_internal.index_columns
WHERE descriptor_name = 'sharded_primary' AND column_type = 'key'
ORDER BY 1, 2

-- Test 16: statement (line 97)
INSERT INTO sharded_primary values (1), (2), (3)

-- Test 17: query (line 100)
INSERT INTO sharded_primary values (1)

# Ensure that the shard column is assigned into the column family of the first column in
# the index column set.
statement ok
CREATE TABLE specific_family (
    a INT,
    b INT,
    INDEX (b) USING HASH WITH (bucket_count=10),
    FAMILY "a_family" (a),
    FAMILY "b_family" (b)
)

onlyif config schema-locked-disabled
query TT
SHOW CREATE TABLE specific_family

-- Test 18: query (line 130)
SHOW CREATE TABLE specific_family

-- Test 19: statement (line 145)
CREATE TABLE sharded_secondary (a INT, INDEX (a) USING HASH WITH (bucket_count=4))

onlyif config schema-locked-disabled

-- Test 20: query (line 149)
SHOW CREATE TABLE sharded_secondary

-- Test 21: query (line 161)
SHOW CREATE TABLE sharded_secondary

-- Test 22: statement (line 172)
DROP TABLE sharded_secondary

-- Test 23: statement (line 175)
CREATE TABLE sharded_secondary (
                        a INT8 NULL,
                        INDEX sharded_secondary_crdb_internal_a_shard_4_a_idx (a ASC) USING HASH WITH (bucket_count=4),
                        FAMILY "primary" (a, rowid)
)

onlyif config schema-locked-disabled

-- Test 24: query (line 183)
SHOW CREATE TABLE sharded_secondary

-- Test 25: query (line 195)
SHOW CREATE TABLE sharded_secondary

-- Test 26: statement (line 206)
INSERT INTO sharded_secondary values (1), (2), (1)

-- Test 27: statement (line 209)
DROP TABLE sharded_secondary

-- Test 28: statement (line 212)
CREATE TABLE sharded_secondary (
    a INT
)

-- Test 29: statement (line 217)
CREATE INDEX ON sharded_secondary (a) USING HASH WITH (bucket_count=10)

-- Test 30: statement (line 220)
INSERT INTO sharded_secondary values (1), (2), (1)

onlyif config schema-locked-disabled

-- Test 31: query (line 224)
SHOW CREATE TABLE sharded_secondary

-- Test 32: query (line 236)
SHOW CREATE TABLE sharded_secondary

-- Test 33: statement (line 247)
INSERT INTO sharded_secondary values (3), (2), (1)

-- Test 34: statement (line 251)
CREATE INDEX ON sharded_secondary (a) USING HASH WITH (bucket_count=4)

onlyif config schema-locked-disabled

-- Test 35: query (line 255)
SHOW CREATE TABLE sharded_secondary

-- Test 36: query (line 269)
SHOW CREATE TABLE sharded_secondary

-- Test 37: statement (line 283)
DROP INDEX sharded_secondary_a_idx

onlyif config schema-locked-disabled

-- Test 38: query (line 287)
SHOW CREATE TABLE sharded_secondary

-- Test 39: statement (line 298)
DROP INDEX sharded_secondary_a_idx1


onlyif config schema-locked-disabled

-- Test 40: query (line 303)
SHOW CREATE TABLE sharded_secondary

-- Test 41: query (line 313)
SHOW CREATE TABLE sharded_secondary

-- Test 42: statement (line 324)
CREATE INDEX idx on sharded_secondary (a) USING HASH WITH (bucket_count=3)

skipif config schema-locked-disabled

-- Test 43: statement (line 328)
ALTER TABLE sharded_secondary SET (schema_locked=false)

-- Test 44: statement (line 331)
SET autocommit_before_ddl = false

-- Test 45: statement (line 335)
BEGIN TRANSACTION PRIORITY HIGH ISOLATION LEVEL SERIALIZABLE

-- Test 46: statement (line 338)
SELECT crdb_internal_a_shard_3 FROM sharded_secondary

-- Test 47: statement (line 341)
DROP INDEX sharded_secondary@idx

-- Test 48: statement (line 344)
SELECT crdb_internal_a_shard_3 FROM sharded_secondary

-- Test 49: statement (line 347)
ROLLBACK

-- Test 50: statement (line 350)
RESET autocommit_before_ddl

skipif config schema-locked-disabled

-- Test 51: statement (line 354)
ALTER TABLE sharded_secondary SET (schema_locked=true)

-- Test 52: statement (line 357)
DROP INDEX sharded_secondary@idx

-- Test 53: statement (line 361)
CREATE INDEX ON sharded_secondary (a) USING HASH WITH (bucket_count=10)

-- Test 54: statement (line 364)
CREATE INDEX ON sharded_secondary (a) USING HASH WITH (bucket_count=10)

-- Test 55: statement (line 367)
CREATE INDEX ON sharded_secondary (a) USING HASH WITH (bucket_count=10)

onlyif config schema-locked-disabled

-- Test 56: query (line 371)
SHOW CREATE TABLE sharded_secondary

-- Test 57: query (line 385)
SHOW CREATE TABLE sharded_secondary

-- Test 58: query (line 399)
SELECT count(*) FROM sharded_secondary

-- Test 59: statement (line 404)
CREATE INDEX ON sharded_primary (a) USING HASH WITH (bucket_count=4);

onlyif config schema-locked-disabled

-- Test 60: query (line 408)
SHOW CREATE TABLE sharded_primary

-- Test 61: query (line 420)
SHOW CREATE TABLE sharded_primary

-- Test 62: statement (line 431)
DROP INDEX sharded_primary_a_idx

-- Test 63: statement (line 434)
SELECT count(*) FROM sharded_primary

onlyif config schema-locked-disabled

-- Test 64: query (line 438)
SHOW CREATE TABLE sharded_primary

-- Test 65: query (line 448)
SHOW CREATE TABLE sharded_primary

-- Test 66: statement (line 457)
CREATE INDEX on sharded_primary (a) USING HASH WITH (bucket_count=10);

onlyif config schema-locked-disabled

-- Test 67: query (line 461)
SHOW CREATE TABLE sharded_primary

-- Test 68: query (line 472)
SHOW CREATE TABLE sharded_primary

-- Test 69: statement (line 482)
DROP INDEX sharded_primary_a_idx

-- Test 70: statement (line 486)
SELECT count(*) FROM sharded_primary

-- Test 71: statement (line 489)
DROP TABLE sharded_secondary

-- Test 72: statement (line 492)
CREATE TABLE sharded_secondary (a INT8, INDEX (a) USING HASH WITH (bucket_count=12))

-- Test 73: statement (line 497)
BEGIN TRANSACTION

-- Test 74: statement (line 500)
ALTER TABLE sharded_secondary ADD COLUMN b INT

-- Test 75: statement (line 503)
CREATE INDEX ON sharded_secondary (a, b) USING HASH WITH (bucket_count=12)

-- Test 76: statement (line 506)
COMMIT TRANSACTION

-- Test 77: statement (line 510)
ALTER TABLE sharded_secondary ADD COLUMN c INT AS (mod(a, 100)) STORED

-- Test 78: statement (line 513)
CREATE INDEX ON sharded_secondary (a, c) USING HASH WITH (bucket_count=12);

-- Test 79: statement (line 518)
CREATE TABLE shard_on_computed_column (
    a INT,
    b INT AS (a % 5) STORED,
    INDEX (b) USING HASH WITH (bucket_count=10)
)

-- Test 80: statement (line 525)
BEGIN TRANSACTION

-- Test 81: statement (line 528)
ALTER TABLE sharded_secondary ADD COLUMN d INT AS (mod(a, 100)) STORED

-- Test 82: statement (line 531)
CREATE INDEX ON sharded_secondary (a, d) USING HASH WITH (bucket_count=12);

-- Test 83: statement (line 534)
ROLLBACK TRANSACTION

-- Test 84: statement (line 538)
CREATE TABLE column_used_on_unsharded (
    a INT,
    INDEX foo (a) USING HASH WITH (bucket_count=10)
)

-- Test 85: statement (line 544)
CREATE INDEX on column_used_on_unsharded (crdb_internal_a_shard_10)

-- Test 86: statement (line 547)
DROP INDEX column_used_on_unsharded@foo

onlyif config schema-locked-disabled

-- Test 87: query (line 551)
SHOW CREATE TABLE column_used_on_unsharded

-- Test 88: query (line 563)
SHOW CREATE TABLE column_used_on_unsharded

-- Test 89: statement (line 574)
DROP INDEX column_used_on_unsharded_crdb_internal_a_shard_10_idx

-- Test 90: statement (line 577)
CREATE TABLE column_used_on_unsharded_create_table (
    a INT,
    INDEX foo (a) USING HASH WITH (bucket_count=10),
    INDEX (crdb_internal_a_shard_10)
)

-- Test 91: statement (line 584)
DROP INDEX column_used_on_unsharded_create_table@foo

onlyif config schema-locked-disabled

-- Test 92: query (line 588)
SHOW CREATE TABLE column_used_on_unsharded_create_table

-- Test 93: query (line 600)
SHOW CREATE TABLE column_used_on_unsharded_create_table

-- Test 94: statement (line 611)
DROP INDEX column_used_on_unsharded_create_table_crdb_internal_a_shard_10_idx

-- Test 95: statement (line 614)
DROP TABLE sharded_primary

-- Test 96: statement (line 618)
CREATE TABLE weird_names (
    "I am a column with spaces" INT PRIMARY KEY USING HASH WITH (bucket_count=12),
    "'quotes' in the column's name" INT,
    FAMILY "primary" ("I am a column with spaces", "'quotes' in the column's name")
    )

-- Test 97: statement (line 625)
CREATE INDEX foo on weird_names ("'quotes' in the column's name") USING HASH WITH (bucket_count=4)

-- Test 98: statement (line 628)
INSERT INTO weird_names VALUES (1, 2)

-- Test 99: query (line 631)
SELECT count(*) from weird_names WHERE "'quotes' in the column's name" = 2

-- Test 100: query (line 637)
SHOW CREATE TABLE weird_names

-- Test 101: query (line 650)
SHOW CREATE TABLE weird_names

-- Test 102: statement (line 664)
CREATE TABLE t0();

-- Test 103: statement (line 667)
CREATE INDEX ON t0 (c0) USING HASH WITH (bucket_count=8);

-- Test 104: statement (line 670)
DROP TABLE t0;

-- Test 105: statement (line 677)
CREATE TABLE create_idx_drop_column (c0 INT PRIMARY KEY, c1 INT);

-- Test 106: statement (line 680)
begin; ALTER TABLE create_idx_drop_column DROP COLUMN c1;

-- Test 107: statement (line 683)
CREATE INDEX idx_create_idx_drop_column ON create_idx_drop_column (c1) USING HASH WITH (bucket_count=8);

-- Test 108: statement (line 686)
ROLLBACK;

-- Test 109: statement (line 689)
DROP TABLE create_idx_drop_column;

-- Test 110: statement (line 695)
CREATE TABLE sharded_index_with_nulls (
     a INT8 PRIMARY KEY,
     b INT8,
     INDEX (b) USING HASH WITH (bucket_count=8)
)

-- Test 111: statement (line 702)
INSERT INTO sharded_index_with_nulls VALUES (1, NULL);

-- Test 112: statement (line 705)
DROP TABLE sharded_index_with_nulls;

-- Test 113: statement (line 711)
CREATE TABLE rename_column (
    c0 INT,
    c1 INT,
    c2 INT,
    PRIMARY KEY (c0, c1) USING HASH WITH (bucket_count=8),
    INDEX (c2) USING HASH WITH (bucket_count=8),
    FAMILY "primary" (c0, c1, c2)
);

-- Test 114: statement (line 721)
INSERT INTO rename_column VALUES (1, 2, 3);

onlyif config schema-locked-disabled

-- Test 115: query (line 725)
SHOW CREATE TABLE rename_column

-- Test 116: query (line 739)
SHOW CREATE TABLE rename_column

-- Test 117: statement (line 752)
ALTER TABLE rename_column RENAME c2 TO c3;

-- Test 118: statement (line 756)
ALTER TABLE rename_column RENAME c1 TO c2;

-- Test 119: statement (line 759)
ALTER TABLE rename_column RENAME c0 TO c1;

onlyif config schema-locked-disabled

-- Test 120: query (line 763)
SHOW CREATE TABLE rename_column

-- Test 121: query (line 777)
SHOW CREATE TABLE rename_column

-- Test 122: query (line 790)
SELECT c3, c2, c1 FROM rename_column

-- Test 123: statement (line 796)
ALTER TABLE rename_column RENAME c1 TO c0, RENAME c2 TO c1, RENAME c3 TO c2;

onlyif config schema-locked-disabled

-- Test 124: query (line 800)
SHOW CREATE TABLE rename_column

-- Test 125: query (line 814)
SHOW CREATE TABLE rename_column

-- Test 126: query (line 827)
SELECT c2, c1, c0 FROM rename_column

-- Test 127: statement (line 833)
ALTER TABLE rename_column RENAME crdb_internal_c2_shard_8 TO foo;

-- Test 128: statement (line 836)
DROP TABLE rename_column;

-- Test 129: statement (line 844)
CREATE TABLE IF NOT EXISTS drop_earlier_hash_column (
    i INT PRIMARY KEY,
    j INT,
    k INT
);

-- Test 130: statement (line 851)
CREATE INDEX h1 ON drop_earlier_hash_column(j) USING HASH WITH (bucket_count=8)

-- Test 131: statement (line 854)
CREATE INDEX h2 ON drop_earlier_hash_column(k) USING HASH WITH (bucket_count=8)

-- Test 132: statement (line 857)
DROP INDEX h1

-- Test 133: statement (line 862)
CREATE TABLE poor_t (a INT PRIMARY KEY, b INT, INDEX t_idx_b (b) USING HASH WITH (bucket_count=8))

-- Test 134: query (line 865)
SELECT descriptor_id, descriptor_name, index_id, index_name, index_type, is_unique, is_inverted, is_sharded, shard_bucket_count
  FROM crdb_internal.table_indexes
 WHERE descriptor_name = 'poor_t'

-- Test 135: statement (line 874)
DROP TABLE poor_t

-- Test 136: statement (line 879)
DROP TABLE IF EXISTS child

-- Test 137: statement (line 882)
DROP TABLE IF EXISTS parent

-- Test 138: statement (line 885)
CREATE TABLE parent (
    id INT PRIMARY KEY USING HASH WITH (bucket_count=8)
);

-- Test 139: statement (line 890)
CREATE TABLE child (
    id INT PRIMARY KEY,
    pid INT,
    CONSTRAINT fk_child_pid FOREIGN KEY (pid) REFERENCES parent(id) ON DELETE CASCADE
);

-- Test 140: statement (line 897)
INSERT INTO child VALUES (1,1)

-- Test 141: statement (line 900)
INSERT INTO parent VALUES (1)

-- Test 142: statement (line 903)
INSERT INTO child VALUES (1,1)

-- Test 143: statement (line 908)
DROP TABLE IF EXISTS child

-- Test 144: statement (line 911)
DROP TABLE IF EXISTS parent

-- Test 145: statement (line 914)
CREATE TABLE parent (
    id INT PRIMARY KEY,
    oid INT
);

-- Test 146: statement (line 920)
CREATE UNIQUE INDEX t_idx_oid ON parent(oid) USING HASH WITH (bucket_count=8)

-- Test 147: statement (line 923)
CREATE TABLE child (
    id INT PRIMARY KEY,
    poid INT,
    CONSTRAINT fk_child_pid FOREIGN KEY (poid) REFERENCES parent(oid) ON DELETE CASCADE
);

-- Test 148: statement (line 930)
INSERT INTO child VALUES (1,11)

-- Test 149: statement (line 933)
INSERT INTO parent VALUES (1,11)

-- Test 150: statement (line 936)
INSERT INTO child VALUES (1,11)

-- Test 151: statement (line 941)
DROP TABLE IF EXISTS child

-- Test 152: statement (line 944)
DROP TABLE IF EXISTS parent

-- Test 153: statement (line 947)
CREATE TABLE parent (
    a INT NOT NULL,
    b INT NOT NULL,
    PRIMARY KEY (a, b) USING HASH WITH (bucket_count=8)
);

-- Test 154: statement (line 954)
CREATE TABLE child (
    ca INT PRIMARY KEY,
    cb INT,
    CONSTRAINT fk_child_ca_cb FOREIGN KEY (ca, cb) REFERENCES parent(a, b) ON DELETE CASCADE
);

-- Test 155: statement (line 961)
INSERT INTO child VALUES (1,1)

-- Test 156: statement (line 964)
INSERT INTO parent VALUES (1,1)

-- Test 157: statement (line 967)
INSERT INTO child VALUES (1,1)

-- Test 158: statement (line 972)
DROP TABLE IF EXISTS child

-- Test 159: statement (line 975)
DROP TABLE IF EXISTS parent

-- Test 160: statement (line 978)
CREATE TABLE parent (
    a INT,
    b INT
);

-- Test 161: statement (line 984)
CREATE UNIQUE INDEX t_idx_a_b ON parent(a, b) USING HASH WITH (bucket_count=8)

-- Test 162: statement (line 988)
CREATE TABLE child (
    ca INT PRIMARY KEY,
    cb INT,
    CONSTRAINT fk_child_ca_cb FOREIGN KEY (ca, cb) REFERENCES parent(a, b) ON DELETE CASCADE
);

-- Test 163: statement (line 995)
INSERT INTO child VALUES (1,1)

-- Test 164: statement (line 998)
INSERT INTO parent VALUES (1,1)

-- Test 165: statement (line 1001)
INSERT INTO child VALUES (1,1)

-- Test 166: statement (line 1008)
DROP TABLE IF EXISTS t

-- Test 167: statement (line 1011)
CREATE TABLE t (
    a INT PRIMARY KEY USING HASH WITH (bucket_count=8)
);

let $create_statement
SELECT create_statement FROM [SHOW CREATE TABLE t]

-- Test 168: statement (line 1019)
DROP TABLE t

-- Test 169: statement (line 1022)
$create_statement

onlyif config schema-locked-disabled

-- Test 170: query (line 1026)
SELECT create_statement FROM [SHOW CREATE TABLE t]

-- Test 171: query (line 1036)
SELECT create_statement FROM [SHOW CREATE TABLE t]

-- Test 172: statement (line 1047)
DROP TABLE t

-- Test 173: statement (line 1050)
CREATE TABLE public.t (
    crdb_internal_a_shard_8 INT4 NOT VISIBLE NOT NULL AS (mod(fnv32(crdb_internal.datums_to_bytes(a)), 8:::INT8)) VIRTUAL,
    a INT8 NOT NULL,
    CONSTRAINT t_pkey PRIMARY KEY (a ASC) USING HASH WITH (bucket_count=8),
    FAMILY "primary" (a),
    CONSTRAINT check_crdb_internal_a_shard_8 CHECK (crdb_internal_a_shard_8 IN (0:::INT8, 1:::INT8, 2:::INT8, 3:::INT8, 4:::INT8, 5:::INT8, 6:::INT8, 7:::INT8))
)

onlyif config schema-locked-disabled

-- Test 174: query (line 1060)
SELECT create_statement FROM [SHOW CREATE TABLE t]

-- Test 175: query (line 1071)
SELECT create_statement FROM [SHOW CREATE TABLE t]

-- Test 176: statement (line 1120)
CREATE TABLE t_default_bucket_16 (
  a INT PRIMARY KEY USING HASH,
  b INT,
  c INT,
  INDEX idx_t_default_bucket_16_b (b) USING HASH,
  INDEX idx_t_default_bucket_16_c (c) USING HASH WITH (bucket_count=4),
  FAMILY fam_0_a (a),
  FAMILY fam_1_c_b (c, b)
);

onlyif config schema-locked-disabled

-- Test 177: query (line 1132)
SELECT create_statement FROM [SHOW CREATE TABLE t_default_bucket_16]

-- Test 178: query (line 1150)
SELECT create_statement FROM [SHOW CREATE TABLE t_default_bucket_16]

-- Test 179: statement (line 1167)
SET CLUSTER SETTING sql.defaults.default_hash_sharded_index_bucket_count = 8

-- Test 180: statement (line 1170)
CREATE TABLE t_default_bucket_8 (a INT PRIMARY KEY USING HASH);

onlyif config schema-locked-disabled

-- Test 181: query (line 1174)
SELECT create_statement FROM [SHOW CREATE TABLE t_default_bucket_8]

-- Test 182: query (line 1184)
SELECT create_statement FROM [SHOW CREATE TABLE t_default_bucket_8]

-- Test 183: statement (line 1196)
DROP TABLE IF EXISTS t

-- Test 184: statement (line 1199)
CREATE TABLE t (
    x INT PRIMARY KEY,
    y INT,
    z INT,
    duped BOOL DEFAULT false
)

-- Test 185: statement (line 1207)
CREATE UNIQUE INDEX t_uniq_idx_y_z ON t(y, z) USING HASH WITH (bucket_count=8)

-- Test 186: statement (line 1210)
INSERT INTO t (x, y, z) VALUES (1, 11, 111) ON CONFLICT (y, z) DO UPDATE SET duped = true

-- Test 187: query (line 1213)
SELECT * FROM t

-- Test 188: statement (line 1219)
INSERT INTO t (x, y, z) VALUES (2, 22, 222) ON CONFLICT (y, z) DO UPDATE SET duped = true

-- Test 189: query (line 1222)
SELECT * FROM t

-- Test 190: statement (line 1229)
INSERT INTO t (x, y, z) VALUES (1, 11, 111) ON CONFLICT (y, z) DO UPDATE SET duped = true

-- Test 191: query (line 1232)
SELECT * FROM t

-- Test 192: statement (line 1239)
INSERT INTO t (x, y, z) VALUES (3, 11, 111)

-- Test 193: statement (line 1242)
INSERT INTO t (x, y, z) VALUES (3, 11, 111) ON CONFLICT (y, z) DO UPDATE SET y = 22, z = 222

-- Test 194: statement (line 1245)
INSERT INTO t (x, y, z) VALUES (3, 11, 111) ON CONFLICT (y, z) DO NOTHING

-- Test 195: statement (line 1248)
INSERT INTO t (x, y, z) VALUES (3, 11, 111) ON CONFLICT DO NOTHING

-- Test 196: query (line 1251)
SELECT * FROM t

-- Test 197: statement (line 1259)
DROP TABLE IF EXISTS t

-- Test 198: statement (line 1262)
CREATE TABLE t (
    x INT PRIMARY KEY USING HASH WITH (bucket_count=8),
    duped BOOL DEFAULT false
)

-- Test 199: statement (line 1268)
INSERT INTO t (x) VALUES (1) ON CONFLICT (x) DO UPDATE SET duped = true

-- Test 200: query (line 1271)
SELECT * FROM t

-- Test 201: statement (line 1277)
INSERT INTO t (x) VALUES (2) ON CONFLICT (x) DO UPDATE SET duped = true

-- Test 202: query (line 1280)
SELECT * FROM t ORDER BY x

-- Test 203: statement (line 1287)
INSERT INTO t (x) VALUES (1) ON CONFLICT (x) DO UPDATE SET duped = true

-- Test 204: query (line 1290)
SELECT * FROM t ORDER BY x

-- Test 205: statement (line 1297)
INSERT INTO t (x) VALUES (2) ON CONFLICT (x) DO UPDATE SET duped = true

-- Test 206: query (line 1300)
SELECT * FROM t ORDER BY x

-- Test 207: statement (line 1307)
INSERT INTO t (x) VALUES (1)

-- Test 208: statement (line 1310)
INSERT INTO t (x) VALUES (1) ON CONFLICT (x) DO UPDATE SET x = 2

-- Test 209: statement (line 1313)
INSERT INTO t (x) VALUES (1) ON CONFLICT (x) DO NOTHING

-- Test 210: statement (line 1316)
INSERT INTO t (x) VALUES (1) ON CONFLICT DO NOTHING

-- Test 211: query (line 1319)
SELECT * FROM t ORDER BY x

-- Test 212: statement (line 1338)
CREATE TABLE products (
    id INT8 PRIMARY KEY USING HASH DEFAULT unique_rowid(),
    title VARCHAR(150) NOT NULL,
    price INT8 NOT NULL
);

-- Test 213: statement (line 1345)
INSERT INTO products (title, price) VALUES ('Test Product', '55');
INSERT INTO products (title, price) VALUES ('Test Product B', '60');

-- Test 214: statement (line 1353)
ALTER TABLE products DROP COLUMN description;

-- Test 215: statement (line 1362)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL use_declarative_schema_changer = off;
ALTER TABLE products DROP COLUMN description;
COMMIT;

-- Test 216: statement (line 1368)
DROP TABLE products;

-- Test 217: statement (line 1371)
CREATE TABLE t103755 (c0 INT4, c1 INT);

-- Test 218: statement (line 1374)
CREATE INDEX ON t103755(c0) USING HASH WITH BUCKET_COUNT=794;

-- Test 219: statement (line 1377)
INSERT INTO t103755 (c0, c1) VALUES(-10, 1), (-20, 1);

-- Test 220: query (line 1382)
SELECT c0 FROM t103755 WHERE c0 < 0 OR c0 IN (VALUES (2)) ORDER BY c0;

-- Test 221: query (line 1390)
SELECT c0 FROM t103755 WHERE c0 < 0 OR (c0 IN (VALUES (2)) AND c1 IN (6,8,9)) ORDER BY c0

-- Test 222: statement (line 1396)
CREATE TABLE t104484 (c0 VARBIT(10) AS (B'1') STORED)

-- Test 223: statement (line 1401)
CREATE INDEX ON t104484(c0 DESC) USING HASH

-- Test 224: statement (line 1407)
CREATE TABLE decimals (
  d DECIMAL NOT NULL PRIMARY KEY USING HASH WITH (bucket_count=16),
  id INT8
)

-- Test 225: statement (line 1413)
INSERT INTO decimals SELECT generate_series(0, 1023), 101;

-- Test 226: query (line 1417)
SELECT crdb_internal_d_shard_16 AS shard, count(*) < 20 FROM decimals GROUP BY 1 ORDER BY 1

-- Test 227: statement (line 1443)
CREATE TABLE t158154 (col1 INT8 NOT NULL, col2 TIMESTAMP NOT NULL);

-- Test 228: statement (line 1446)
CREATE INDEX idx1 ON t158154 (col2 ASC) USING HASH WITH (bucket_count = 6);

-- Test 229: statement (line 1449)
CREATE OR REPLACE PROCEDURE p158154 () LANGUAGE PLpgSQL AS $proc$
  BEGIN
    UPDATE t158154 SET col1 = col1 + 1;
  END;
$proc$;

-- Test 230: statement (line 1456)
CALL p158154();

-- Test 231: statement (line 1461)
DROP INDEX t158154@idx1;

-- Test 232: statement (line 1464)
CALL p158154();

-- Test 233: statement (line 1467)
DROP PROCEDURE p158154;
DROP TABLE t158154;

