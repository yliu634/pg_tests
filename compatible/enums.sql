-- PostgreSQL compatible tests from enums
-- 361 tests

-- Test 1: statement (line 3)
CREATE TYPE t AS ENUM ()

-- Test 2: statement (line 6)
SELECT * FROM t

-- Test 3: statement (line 9)
CREATE TABLE t (x INT)

-- Test 4: statement (line 12)
CREATE TYPE t AS ENUM ()

-- Test 5: statement (line 15)
CREATE TABLE torename (x INT)

-- Test 6: statement (line 18)
ALTER TABLE torename RENAME TO t

-- Test 7: statement (line 21)
CREATE DATABASE db2;
CREATE TYPE db2.t AS ENUM ()

-- Test 8: statement (line 25)
SELECT * FROM db2.t

-- Test 9: statement (line 28)
CREATE TYPE db2.t AS ENUM ()

-- Test 10: statement (line 32)
DROP TABLE t

-- Test 11: statement (line 35)
CREATE TYPE bad AS ENUM ('dup', 'dup')

-- Test 12: statement (line 39)
CREATE TYPE notbad AS ENUM ('dup', 'DUP')

-- Test 13: statement (line 44)
CREATE TYPE int AS ENUM ('Z', 'S of int')

-- Test 14: statement (line 47)
SELECT 'Z'::int

-- Test 15: query (line 50)
SELECT 'Z'::public.int

-- Test 16: statement (line 55)
CREATE TYPE greeting AS ENUM ('hello', 'howdy', 'hi')

-- Test 17: statement (line 59)
SELECT 'hello'::pg_catalog.greeting

-- Test 18: query (line 62)
SELECT 'hello'::public.greeting

-- Test 19: query (line 70)
SELECT 'hello'::greeting, 'howdy'::greeting, 'hi'::greeting

-- Test 20: query (line 76)
SELECT 'hello':::greeting, 'howdy':::greeting, 'hi':::greeting

-- Test 21: statement (line 81)
SELECT 'goodbye'::greeting

-- Test 22: query (line 89)
SELECT 'hello'::greeting < 'howdy'::greeting,
       'howdy'::greeting < 'hi',
       'hi' > 'hello'::greeting,
       'howdy'::greeting < 'hello'::greeting,
       'hi'::greeting <= 'hi',
       NULL < 'hello'::greeting,
       'hi'::greeting < NULL,
       'hello'::greeting = 'hello'::greeting,
       'hello' != 'hi'::greeting,
       'howdy'::greeting IS NOT DISTINCT FROM NULL,
       'hello'::greeting IN ('hi'::greeting, 'howdy'::greeting, 'hello'::greeting)

-- Test 23: statement (line 104)
CREATE TYPE farewell AS ENUM ('bye', 'seeya')

-- Test 24: statement (line 107)
SELECT 'hello'::greeting = 'bye'::farewell

-- Test 25: statement (line 110)
SELECT 'hello'::greeting < 'bye'::farewell

-- Test 26: statement (line 113)
SELECT 'hello'::greeting <= 'bye'::farewell

-- Test 27: query (line 116)
SELECT 'hello'::greeting::greeting

-- Test 28: statement (line 121)
CREATE TYPE greeting2 AS ENUM ('hello')

-- Test 29: statement (line 124)
SELECT 'hello'::greeting::greeting2

-- Test 30: query (line 129)
SELECT 'hello'::greeting != 'howdy', 'hi' > 'hello'::greeting

-- Test 31: statement (line 136)
SELECT 'hello'::greeting = 'notagreeting'

-- Test 32: statement (line 140)
CREATE TYPE dbs AS ENUM ('postgres', 'mysql', 'spanner', 'cockroach')

-- Test 33: query (line 143)
SELECT enum_first('mysql'::dbs), enum_last('spanner'::dbs)

-- Test 34: query (line 148)
SELECT enum_first(null::dbs)

-- Test 35: query (line 153)
SELECT enum_first(val) FROM unnest(array_append(enum_range(null::dbs),null)) val

-- Test 36: statement (line 162)
SELECT enum_first(null)

-- Test 37: query (line 165)
SELECT enum_range('cockroach'::dbs)

-- Test 38: query (line 170)
SELECT enum_range(NULL, 'mysql'::dbs), enum_range('spanner'::dbs, NULL)

-- Test 39: query (line 175)
SELECT enum_range('postgres'::dbs, 'spanner'::dbs), enum_range('spanner'::dbs, 'cockroach'::dbs)

-- Test 40: query (line 180)
SELECT enum_range('cockroach'::dbs, 'cockroach'::dbs)

-- Test 41: query (line 185)
SELECT enum_range('cockroach'::dbs, 'spanner'::dbs)

-- Test 42: query (line 190)
SELECT enum_range(NULL::dbs, NULL::dbs)

query error pq: mismatched types
SELECT enum_range('cockroach'::dbs, 'hello'::greeting)

# Test inserting and reading enum data from tables.
statement ok
CREATE TABLE greeting_table (x1 greeting, x2 greeting)

statement error pq: invalid input value for enum greeting: "bye"
INSERT INTO greeting_table VALUES ('bye', 'hi')

statement ok
INSERT INTO greeting_table VALUES ('hi', 'hello')

query TT
SELECT * FROM greeting_table

-- Test 43: query (line 211)
SELECT 'hello'::greeting, x1 FROM greeting_table

-- Test 44: query (line 216)
SELECT x1, x1 < 'hello' FROM greeting_table

-- Test 45: query (line 221)
SELECT x1, enum_first(x1) FROM greeting_table

-- Test 46: statement (line 226)
CREATE TABLE t1 (x greeting, INDEX i (x));

-- Test 47: statement (line 229)
CREATE TABLE t2 (x greeting, INDEX i (x));
INSERT INTO t1 VALUES ('hello');
INSERT INTO t2 VALUES ('hello')

-- Test 48: query (line 234)
SELECT * FROM t1 INNER LOOKUP JOIN t2 ON t1.x = t2.x

-- Test 49: query (line 239)
SELECT * FROM t1 INNER HASH JOIN t2 ON t1.x = t2.x

-- Test 50: query (line 244)
SELECT * FROM t1 INNER MERGE JOIN t2 ON t1.x = t2.x

-- Test 51: statement (line 249)
INSERT INTO t2 VALUES ('hello'), ('hello'), ('howdy'), ('hi')

-- Test 52: query (line 252)
SELECT DISTINCT x FROM t2

-- Test 53: query (line 259)
SELECT DISTINCT x FROM t2 ORDER BY x DESC

-- Test 54: query (line 267)
SELECT x FROM t2 WHERE x > (SELECT x FROM t1 ORDER BY x LIMIT 1)

-- Test 55: query (line 274)
SELECT * FROM t2 WITH ORDINALITY ORDER BY x

-- Test 56: statement (line 284)
INSERT INTO t1 VALUES ('hi'), ('hello'), ('howdy'), ('howdy'), ('howdy'), ('hello')

-- Test 57: query (line 287)
SELECT x FROM t1 ORDER BY x DESC

-- Test 58: query (line 298)
SELECT x FROM t1 ORDER BY x ASC

-- Test 59: query (line 309)
SELECT x FROM t1 ORDER BY x ASC LIMIT 3

-- Test 60: query (line 316)
SELECT x FROM t1 ORDER BY x DESC LIMIT 3

-- Test 61: query (line 324)
(SELECT * FROM t1) UNION (SELECT * FROM t2)

-- Test 62: statement (line 331)
CREATE TABLE enum_agg (x greeting, y INT);
INSERT INTO enum_agg VALUES
  ('hello', 1),
  ('hello', 3),
  ('howdy', 5),
  ('howdy', 0),
  ('howdy', 1),
  ('hi', 10)

-- Test 63: query (line 341)
SELECT x, max(y), sum(y), min(y) FROM enum_agg GROUP BY x

-- Test 64: query (line 349)
SELECT max(x), min(x) FROM enum_agg

-- Test 65: statement (line 356)
CREATE TYPE empty AS ENUM ();
CREATE TABLE empty_enum (x empty)

-- Test 66: query (line 360)
SELECT max(x), min(x) FROM empty_enum

-- Test 67: statement (line 367)
CREATE TABLE greeting_stats (x greeting PRIMARY KEY);
INSERT INTO greeting_stats VALUES ('hi');
CREATE STATISTICS s FROM greeting_stats

-- Test 68: query (line 372)
SELECT x FROM greeting_stats

-- Test 69: statement (line 379)
CREATE TYPE as_bytes AS ENUM ('bytes')

-- Test 70: query (line 382)
SELECT b'\x80'::as_bytes, b'\x80':::as_bytes

-- Test 71: query (line 387)
SELECT b'\xFF'::as_bytes

# Regression for #49300. Ensure that virtual tables have access to hydrated
# type descriptors.
onlyif config schema-locked-disabled
query TT
SHOW CREATE t1

-- Test 72: query (line 404)
SHOW CREATE t1

-- Test 73: query (line 417)
SELECT create_statement FROM crdb_internal.create_statements WHERE descriptor_name = 't1'

-- Test 74: query (line 428)
SELECT create_statement FROM crdb_internal.create_statements WHERE descriptor_name = 't1'

-- Test 75: query (line 439)
SELECT ARRAY['hello']::_greeting, ARRAY['hello'::greeting]

-- Test 76: query (line 445)
SELECT ARRAY['hello'::greeting, 'cockroach'::dbs]

statement ok
CREATE TABLE enum_array (x _greeting, y greeting[]);
INSERT INTO enum_array VALUES (ARRAY['hello'], ARRAY['hello']), (ARRAY['howdy'], ARRAY['howdy'])

query TT rowsort
SELECT * FROM enum_array

-- Test 77: query (line 458)
SELECT pg_typeof(x), pg_typeof(x[1]), pg_typeof(ARRAY['hello']::_greeting) FROM enum_array LIMIT 1

-- Test 78: statement (line 467)
CREATE TYPE _collision AS ENUM ();
CREATE TYPE collision AS ENUM ();

-- Test 79: query (line 473)
SELECT
  typname, oid, typelem, typarray
FROM
  pg_type
WHERE
  typname IN ('collision', '_collision', '__collision', '___collision')

-- Test 80: query (line 487)
SELECT
  column_name, column_type
FROM
  crdb_internal.table_columns
WHERE
  descriptor_name = 'enum_array' AND column_name = 'x'

-- Test 81: statement (line 498)
CREATE TABLE enum_default (
  x INT,
  y greeting DEFAULT 'hello',
  z BOOL DEFAULT ('hello':::greeting IS OF (greeting, greeting)),
  FAMILY (x, y, z)
);
INSERT INTO enum_default VALUES (1), (2)

-- Test 82: query (line 507)
SELECT * FROM enum_default

-- Test 83: query (line 513)
SELECT
  pg_get_expr(d.adbin, d.adrelid)
FROM
  pg_attribute AS a
  LEFT JOIN pg_attrdef AS d ON a.attrelid = d.adrelid AND a.attnum = d.adnum
  LEFT JOIN pg_type AS t ON a.atttypid = t.oid
  LEFT JOIN pg_collation AS c ON
    a.attcollation = c.oid AND a.attcollation != t.typcollation
WHERE
  a.attrelid = 'enum_default'::REGCLASS
  AND NOT a.attisdropped
  AND attname = 'y'

-- Test 84: query (line 531)
SHOW CREATE enum_default

-- Test 85: query (line 544)
SHOW CREATE enum_default

-- Test 86: query (line 557)
SELECT
  column_name, default_expr
FROM
  crdb_internal.table_columns
WHERE
  descriptor_name='enum_default' AND (column_name = 'y' OR column_name = 'z')
ORDER BY
  column_name

-- Test 87: query (line 571)
SELECT
  column_name, column_default
FROM
  information_schema.columns
WHERE
  table_name='enum_default' AND (column_name = 'y' OR column_name = 'z')
ORDER BY
  column_name

-- Test 88: statement (line 585)
CREATE TABLE enum_computed (
  x INT,
  y greeting AS ('hello') STORED,
  z BOOL AS (w = 'howdy') STORED,
  w greeting,
  FAMILY (x, y, z)
);
INSERT INTO enum_computed (x, w) VALUES (1, 'hello'), (2, 'hello')

-- Test 89: query (line 595)
SELECT * FROM enum_computed

-- Test 90: query (line 602)
SHOW CREATE enum_computed

-- Test 91: query (line 616)
SHOW CREATE enum_computed

-- Test 92: query (line 631)
SELECT
  column_name, generation_expression
FROM
  information_schema.columns
WHERE
  table_name='enum_computed' AND (column_name = 'y' OR column_name = 'z')
ORDER BY
  column_name

-- Test 93: statement (line 645)
CREATE TABLE enum_checks (
  x greeting,
  CHECK (x = 'hello'::greeting),
  CHECK ('hello':::greeting = 'hello':::greeting)
);

-- Test 94: statement (line 652)
INSERT INTO enum_checks VALUES ('hello')

onlyif config schema-locked-disabled

-- Test 95: query (line 656)
SHOW CREATE enum_checks

-- Test 96: query (line 668)
SHOW CREATE enum_checks

-- Test 97: statement (line 680)
DROP TABLE enum_checks;

-- Test 98: statement (line 689)
CREATE TABLE enum_checks (x greeting);
INSERT INTO enum_checks VALUES ('hi'), ('howdy');
ALTER TABLE enum_checks ADD CHECK (x > 'hello')

-- Test 99: statement (line 695)
INSERT INTO enum_checks VALUES ('hello')

-- Test 100: statement (line 699)
ALTER TABLE enum_checks ADD CHECK (x = 'hello')

-- Test 101: statement (line 703)
DROP TABLE enum_checks;

-- Test 102: statement (line 706)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl = false;
CREATE TABLE enum_checks (x greeting);
INSERT INTO enum_checks VALUES ('hi'), ('howdy');
ALTER TABLE enum_checks ADD CHECK (x > 'hello')

-- Test 103: statement (line 713)
INSERT INTO enum_checks VALUES ('hello')

-- Test 104: statement (line 716)
ROLLBACK

-- Test 105: statement (line 719)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl = false;
CREATE TABLE enum_checks (x greeting);
INSERT INTO enum_checks VALUES ('hi'), ('howdy');

-- Test 106: statement (line 726)
ALTER TABLE enum_checks ADD CHECK (x = 'hello')

-- Test 107: statement (line 729)
ROLLBACK

-- Test 108: statement (line 733)
CREATE DATABASE other;
CREATE TYPE other.t AS ENUM ('other')

-- Test 109: statement (line 739)
CREATE TABLE other.tt (x other.t)

-- Test 110: statement (line 743)
CREATE TABLE cross_error (x other.t)

-- Test 111: statement (line 747)
CREATE TABLE cross_error (x BOOL DEFAULT ('other':::other.t = 'other':::other.t))

-- Test 112: statement (line 750)
CREATE TABLE cross_error (x BOOL AS ('other':::other.t = 'other':::other.t) STORED)

-- Test 113: statement (line 753)
CREATE TABLE cross_error (x INT, CHECK ('other':::other.t = 'other':::other.t))

-- Test 114: statement (line 757)
CREATE TABLE cross_error (x INT)

-- Test 115: statement (line 760)
ALTER TABLE cross_error ADD COLUMN y other.t

-- Test 116: statement (line 763)
ALTER TABLE cross_error ADD COLUMN y BOOL DEFAULT ('other':::other.t = 'other':::other.t)

-- Test 117: statement (line 766)
ALTER TABLE cross_error ADD COLUMN y BOOL AS ('other':::other.t = 'other':::other.t) STORED

-- Test 118: statement (line 769)
ALTER TABLE cross_error ADD CHECK ('other':::other.t = 'other':::other.t)

-- Test 119: statement (line 776)
CREATE TABLE sc (x greeting NOT NULL, y int NOT NULL);
INSERT INTO sc VALUES ('hello', 0), ('howdy', 1), ('hi', 2);

-- Test 120: statement (line 780)
CREATE INDEX i1 ON sc (x);
CREATE INDEX i2 ON sc (y);
CREATE INDEX i3 ON sc (x, y)

-- Test 121: query (line 785)
SELECT x FROM sc@i1

-- Test 122: query (line 792)
SELECT x, y FROM sc@i3

-- Test 123: statement (line 799)
DROP INDEX sc@i1;
DROP INDEX sc@i2;
DROP INDEX sc@i3

-- Test 124: statement (line 805)
DROP TABLE sc

-- Test 125: statement (line 808)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl = false;
CREATE TABLE sc (x greeting NOT NULL, y int NOT NULL);
INSERT INTO sc VALUES ('hello', 0), ('howdy', 1), ('hi', 2);
CREATE INDEX i1 ON sc (x);
CREATE INDEX i2 ON sc (y);
CREATE INDEX i3 ON sc (x, y)

-- Test 126: query (line 817)
SELECT x FROM sc@i1

-- Test 127: query (line 824)
SELECT x, y FROM sc@i3

-- Test 128: statement (line 831)
DROP INDEX sc@i1;
DROP INDEX sc@i2;
DROP INDEX sc@i3;
COMMIT

-- Test 129: statement (line 839)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl = false;
CREATE TYPE in_txn AS ENUM ('in', 'txn');
CREATE TABLE tbl_in_txn (x in_txn);
INSERT INTO tbl_in_txn VALUES ('txn');
CREATE INDEX i ON tbl_in_txn (x)

-- Test 130: query (line 847)
SELECT * FROM tbl_in_txn@i

-- Test 131: statement (line 852)
ROLLBACK

-- Test 132: statement (line 856)
CREATE TABLE enum_not_pk (x INT PRIMARY KEY, y greeting NOT NULL);
INSERT INTO enum_not_pk VALUES (1, 'howdy');
ALTER TABLE enum_not_pk ALTER PRIMARY KEY USING COLUMNS (y);
DROP TABLE enum_not_pk

-- Test 133: statement (line 863)
CREATE TABLE enum_pk (x GREETING PRIMARY KEY, y INT NOT NULL);
INSERT INTO enum_pk VALUES ('howdy', 1);
ALTER TABLE enum_pk ALTER PRIMARY KEY USING COLUMNS (y);
DROP TABLE enum_pk

-- Test 134: statement (line 870)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl = false;
CREATE TABLE enum_not_pk (x INT PRIMARY KEY, y greeting NOT NULL);
INSERT INTO enum_not_pk VALUES (1, 'howdy');
ALTER TABLE enum_not_pk ALTER PRIMARY KEY USING COLUMNS (y);
ROLLBACK

-- Test 135: statement (line 878)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl = false;
CREATE TABLE enum_pk (x GREETING PRIMARY KEY, y INT NOT NULL);
INSERT INTO enum_pk VALUES ('howdy', 1);
ALTER TABLE enum_pk ALTER PRIMARY KEY USING COLUMNS (y);
ROLLBACK

-- Test 136: statement (line 887)
CREATE TABLE enum_ctas_base (x greeting, y greeting, z _greeting);
INSERT INTO enum_ctas_base VALUES ('hi', 'howdy', ARRAY['hello']);
CREATE TABLE enum_ctas AS TABLE enum_ctas_base

-- Test 137: query (line 892)
SELECT * from enum_ctas

-- Test 138: statement (line 897)
DROP TABLE enum_ctas

-- Test 139: statement (line 901)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl = false;
CREATE TABLE enum_ctas AS TABLE enum_ctas_base

-- Test 140: query (line 906)
SELECT * from enum_ctas

-- Test 141: statement (line 911)
ROLLBACK

-- Test 142: statement (line 915)
CREATE TABLE enum_ctas AS (SELECT x, enum_first(y), z, enum_range(x) FROM enum_ctas_base)

-- Test 143: query (line 918)
SELECT * FROM enum_ctas

-- Test 144: statement (line 923)
DROP TABLE enum_ctas;

-- Test 145: statement (line 927)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl = false;
CREATE TABLE enum_ctas AS (SELECT x, enum_first(y), z, enum_range(x) FROM enum_ctas_base)

-- Test 146: query (line 932)
SELECT * FROM enum_ctas

-- Test 147: statement (line 937)
ROLLBACK

-- Test 148: statement (line 941)
CREATE TABLE enum_ctas AS VALUES ('howdy'::greeting, ('how' || 'dy')::greeting, 'cockroach'::dbs)

-- Test 149: query (line 944)
SELECT * FROM enum_ctas

-- Test 150: statement (line 949)
DROP TABLE enum_ctas;

-- Test 151: statement (line 953)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl = false;
CREATE TABLE enum_ctas AS VALUES ('howdy'::greeting, 'cockroach'::dbs)

-- Test 152: query (line 958)
SELECT * FROM enum_ctas

-- Test 153: statement (line 963)
ROLLBACK

-- Test 154: statement (line 967)
CREATE TABLE column_add (x greeting);
INSERT INTO column_add VALUES ('hello')

-- Test 155: statement (line 972)
ALTER TABLE column_add ADD COLUMN y INT DEFAULT 1

-- Test 156: query (line 975)
SELECT * FROM column_add

-- Test 157: statement (line 981)
ALTER TABLE column_add ADD COLUMN z greeting DEFAULT 'howdy'

-- Test 158: query (line 984)
SELECT * FROM column_add

-- Test 159: statement (line 990)
ALTER TABLE column_add ADD COLUMN w greeting AS ('hi') STORED

-- Test 160: query (line 993)
SELECT * FROM column_add

-- Test 161: statement (line 999)
ALTER TABLE column_add ADD COLUMN v BOOL AS (z < 'hi' AND x >= 'hello') STORED

-- Test 162: query (line 1002)
SELECT * FROM column_add

-- Test 163: statement (line 1009)
DROP TABLE column_add

-- Test 164: statement (line 1012)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl = false;
CREATE TABLE column_add (x greeting);
INSERT INTO column_add VALUES ('hello');
ALTER TABLE column_add ADD COLUMN y INT DEFAULT 1;
ALTER TABLE column_add ADD COLUMN z greeting DEFAULT 'howdy';
ALTER TABLE column_add ADD COLUMN w greeting AS ('hi') STORED;
ALTER TABLE column_add ADD COLUMN v BOOL AS (z < 'hi' AND x >= 'hello') STORED

-- Test 165: query (line 1022)
SELECT * FROM column_add

-- Test 166: statement (line 1027)
COMMIT

-- Test 167: statement (line 1032)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl = false;
CREATE TYPE in_txn AS ENUM ('in', 'txn');
CREATE TABLE tbl_in_txn (x INT);
INSERT INTO tbl_in_txn VALUES (1);
ALTER TABLE tbl_in_txn ADD COLUMN y in_txn DEFAULT 'txn';

-- Test 168: query (line 1040)
SELECT * FROM tbl_in_txn

-- Test 169: statement (line 1045)
ROLLBACK

-- Test 170: statement (line 1049)
CREATE TABLE enum_origin (x greeting PRIMARY KEY);
CREATE TABLE enum_referenced (x greeting PRIMARY KEY);
INSERT INTO enum_origin VALUES ('hello');
INSERT INTO enum_referenced VALUES ('hello');
ALTER TABLE enum_origin ADD FOREIGN KEY (x) REFERENCES enum_referenced (x)

-- Test 171: statement (line 1057)
INSERT INTO enum_origin VALUES ('howdy')

-- Test 172: statement (line 1060)
DROP TABLE enum_referenced, enum_origin;

-- Test 173: statement (line 1064)
SET autocommit_before_ddl = false

-- Test 174: statement (line 1067)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl = false;
CREATE TABLE enum_origin (x greeting PRIMARY KEY);
CREATE TABLE enum_referenced (x greeting PRIMARY KEY);
INSERT INTO enum_origin VALUES ('hello');
INSERT INTO enum_referenced VALUES ('hello');
ALTER TABLE enum_origin ADD FOREIGN KEY (x) REFERENCES enum_referenced (x)

-- Test 175: statement (line 1076)
INSERT INTO enum_origin VALUES ('howdy')

-- Test 176: statement (line 1079)
ROLLBACK

-- Test 177: statement (line 1082)
RESET autocommit_before_ddl

-- Test 178: statement (line 1088)
CREATE TABLE enum_origin (x greeting PRIMARY KEY);
CREATE TABLE enum_referenced (x greeting PRIMARY KEY);
INSERT INTO enum_origin VALUES ('hello');
INSERT INTO enum_referenced VALUES ('howdy')

-- Test 179: statement (line 1094)
ALTER TABLE enum_origin ADD FOREIGN KEY (x) REFERENCES enum_referenced (x)

-- Test 180: statement (line 1108)
ALTER TABLE enum_data_type ALTER COLUMN y SET DATA TYPE greeting;

-- Test 181: statement (line 1114)
ALTER TABLE enum_data_type ALTER COLUMN y SET DATA TYPE greeting USING y::greeting;

-- Test 182: statement (line 1119)
ALTER TABLE enum_data_type ALTER COLUMN x SET DATA TYPE greeting;

skipif config local-legacy-schema-changer

-- Test 183: statement (line 1123)
ALTER TABLE enum_data_type ALTER COLUMN x SET DATA TYPE greeting USING x::greeting;

-- Test 184: statement (line 1126)
INSERT INTO enum_data_type VALUES ('hi')

-- Test 185: query (line 1129)
SELECT x FROM enum_data_type

-- Test 186: statement (line 1136)
DROP TABLE enum_data_type;

-- Test 187: statement (line 1145)
CREATE TABLE enum_data_type (x greeting);
INSERT INTO enum_data_type VALUES ('hello'), ('howdy')

-- Test 188: statement (line 1150)
ALTER TABLE enum_data_type ALTER COLUMN x SET DATA TYPE greeting

-- Test 189: query (line 1158)
SELECT * FROM enum_data_type

-- Test 190: statement (line 1165)
DROP TABLE enum_data_type;

-- Test 191: statement (line 1174)
CREATE TABLE enum_data_type (x greeting);
INSERT INTO enum_data_type VALUES ('hello'), ('hi')

skipif config local-legacy-schema-changer

-- Test 192: statement (line 1179)
ALTER TABLE enum_data_type ALTER COLUMN x SET DATA TYPE dbs USING
  (CASE WHEN x = 'hello' THEN 'cockroach' ELSE 'postgres' END)

skipif config local-legacy-schema-changer

-- Test 193: query (line 1184)
SELECT * FROM enum_data_type

-- Test 194: statement (line 1191)
DROP TABLE enum_data_type;

-- Test 195: statement (line 1205)
ALTER TABLE enum_data_type ALTER COLUMN x SET DATA TYPE greeting USING x::greeting

skipif config local-legacy-schema-changer

-- Test 196: statement (line 1209)
ALTER TABLE enum_data_type
  ALTER COLUMN x SET DATA TYPE greeting USING (CASE WHEN x = 'notagreeting' THEN 'hello' ELSE 'hi' END)

skipif config local-legacy-schema-changer

-- Test 197: query (line 1214)
SELECT * FROM enum_data_type

-- Test 198: query (line 1220)
SELECT to_json('hello'::greeting)

-- Test 199: statement (line 1226)
CREATE TABLE t51474 (x greeting);
INSERT INTO t51474 VALUES ('hello'), ('howdy')

-- Test 200: query (line 1230)
SELECT * FROM t51474 INTERSECT ALL SELECT * FROM t51474

-- Test 201: statement (line 1238)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl = false;
CREATE TYPE local_type AS ENUM ('local');
CREATE TABLE local_table (x INT);
INSERT INTO local_table VALUES (1), (2)

-- Test 202: query (line 1245)
SELECT * FROM [EXPLAIN SELECT * FROM local_table] LIMIT 1

-- Test 203: statement (line 1250)
ROLLBACK

-- Test 204: statement (line 1253)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl = false;
ALTER TYPE greeting RENAME TO greeting_local;
CREATE TABLE local_table (x INT);
INSERT INTO local_table VALUES (1), (2)

-- Test 205: query (line 1260)
SELECT * FROM [EXPLAIN SELECT * FROM local_table] LIMIT 1

-- Test 206: statement (line 1265)
ROLLBACK

-- Test 207: statement (line 1271)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl = false;
CREATE TYPE local_type AS ENUM ('local');
CREATE TABLE local_table (x local_type);
INSERT INTO local_table VALUES ('local')

-- Test 208: query (line 1278)
SELECT * FROM local_table

-- Test 209: statement (line 1283)
ROLLBACK

-- Test 210: query (line 1286)
SELECT * FROM [SHOW ENUMS] ORDER BY name

-- Test 211: query (line 1302)
SHOW TYPES

-- Test 212: statement (line 1318)
CREATE SCHEMA uds;
CREATE TYPE uds.typ AS ENUM ('schema')

-- Test 213: query (line 1322)
SELECT * FROM [SHOW ENUMS] ORDER BY name

-- Test 214: statement (line 1339)
CREATE TYPE fakedb.typ AS ENUM ('schema')

-- Test 215: statement (line 1348)
CREATE TYPE enum_with_vals AS ENUM ('val', 'other_val');

-- Test 216: statement (line 1351)
CREATE TABLE table_with_not_null_enum (i INT PRIMARY KEY, v enum_with_vals NOT NULL) WITH (schema_locked=false);

-- Test 217: statement (line 1354)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl = false;

-- Test 218: statement (line 1358)
ALTER TABLE table_with_not_null_enum DROP COLUMN v;

-- Test 219: statement (line 1361)
INSERT INTO table_with_not_null_enum VALUES (1);

-- Test 220: statement (line 1364)
COMMIT; DROP TABLE table_with_not_null_enum; DROP TYPE enum_with_vals;

-- Test 221: statement (line 1367)
CREATE TYPE enum_with_no_vals AS ENUM ();

-- Test 222: statement (line 1370)
CREATE TABLE table_with_not_null_enum_no_vals (i INT PRIMARY KEY, v enum_with_no_vals NOT NULL) WITH (schema_locked=false);

-- Test 223: statement (line 1373)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl = false;

-- Test 224: statement (line 1377)
ALTER TABLE table_with_not_null_enum_no_vals DROP COLUMN v;

-- Test 225: statement (line 1380)
INSERT INTO table_with_not_null_enum_no_vals VALUES (1);

-- Test 226: statement (line 1383)
ROLLBACK; DROP TABLE table_with_not_null_enum_no_vals; DROP TYPE enum_with_no_vals;

-- Test 227: statement (line 1391)
CREATE DATABASE to_drop;
USE to_drop;
CREATE TYPE greeting AS ENUM ('hi');
CREATE TABLE t(a greeting);
USE defaultdb;

-- Test 228: statement (line 1405)
DROP DATABASE to_drop CASCADE;

-- Test 229: statement (line 1411)
SELECT * FROM crdb_internal.tables

-- Test 230: statement (line 1414)
create DATABASE test_57196;
CREATE SCHEMA test_57196.sc;
CREATE TYPE test_57196.public.greeting AS ENUM ('hi');
CREATE TYPE test_57196.sc.greeting AS ENUM('hello');

-- Test 231: query (line 1420)
SHOW ENUMS FROM test_57196.public

-- Test 232: query (line 1426)
SHOW ENUMS FROM test_57196.sc

-- Test 233: query (line 1434)
SHOW ENUMS FROM test_57196

-- Test 234: statement (line 1440)
USE test_57196

-- Test 235: query (line 1443)
SHOW ENUMS

-- Test 236: query (line 1450)
SHOW ENUMS FROM public

-- Test 237: query (line 1456)
SHOW ENUMS FROM sc

-- Test 238: statement (line 1465)
CREATE TYPE ifne AS ENUM ('hi')

-- Test 239: statement (line 1468)
CREATE TYPE ifne AS ENUM ('hi')

-- Test 240: statement (line 1471)
CREATE TYPE IF NOT EXISTS ifne AS ENUM ('hi')

-- Test 241: statement (line 1474)
CREATE TABLE table_ifne (x INT)

-- Test 242: statement (line 1479)
CREATE TYPE IF NOT EXISTS table_ifne AS ENUM ('hi')

-- Test 243: statement (line 1485)
CREATE TYPE typ AS ENUM('a', 'b', 'c')

-- Test 244: statement (line 1491)
INSERT INTO arr_t VALUES (default)

-- Test 245: query (line 1494)
SELECT * FROM arr_t

-- Test 246: statement (line 1499)
CREATE TABLE arr_t2 (i typ DEFAULT ('{a, b, c}'::typ[])[2])

-- Test 247: statement (line 1502)
INSERT INTO arr_t2 VALUES (default)

-- Test 248: query (line 1505)
SELECT * FROM arr_t2

-- Test 249: statement (line 1513)
INSERT INTO arr_t3 VALUES (default)

-- Test 250: query (line 1516)
SELECT * FROM arr_t3

-- Test 251: statement (line 1521)
CREATE TABLE arr_t4 (i typ DEFAULT ARRAY['a'::typ][1], j typ DEFAULT ARRAY['a'::typ, 'b'::typ, 'c'::typ][2])

-- Test 252: statement (line 1524)
INSERT INTO arr_t4 VALUES (default, default)

-- Test 253: query (line 1527)
SELECT * from arr_t4

-- Test 254: statement (line 1532)
CREATE TABLE arr_t5 (i typ[] default ARRAY['a'::typ, 'b'::typ])

-- Test 255: statement (line 1535)
INSERT INTO arr_t5 VALUES (default)

-- Test 256: query (line 1538)
SELECT * from arr_t5

-- Test 257: statement (line 1548)
CREATE TYPE default_abc AS ENUM ('a', 'b', 'c')

-- Test 258: statement (line 1551)
CREATE TYPE default_abc2 AS ENUM('a', 'b', 'c')

-- Test 259: statement (line 1554)
CREATE TABLE t (k INT PRIMARY KEY, v default_abc DEFAULT 'a')

-- Test 260: statement (line 1557)
ALTER TYPE default_abc DROP VALUE 'a'

-- Test 261: statement (line 1560)
ALTER TYPE default_abc2 DROP VALUE 'a'

-- Test 262: statement (line 1566)
ALTER TYPE default_abc DROP VALUE 'b'

-- Test 263: statement (line 1569)
ALTER TYPE default_abc DROP VALUE 'c'

-- Test 264: statement (line 1577)
ALTER TYPE default_abc2 DROP VALUE 'b'

-- Test 265: statement (line 1580)
ALTER TYPE default_abc2 DROP VALUE 'c'

-- Test 266: statement (line 1583)
CREATE TYPE default_abc3 AS ENUM ('a', 'b', 'c')

-- Test 267: statement (line 1592)
ALTER TYPE default_abc3 DROP VALUE 'a'

-- Test 268: statement (line 1595)
ALTER TYPE default_abc3 DROP VALUE 'b'

-- Test 269: statement (line 1598)
ALTER TYPE default_abc3 DROP VALUE 'c'

-- Test 270: statement (line 1601)
CREATE TYPE computed_abc AS ENUM ('a', 'b', 'c')

-- Test 271: statement (line 1604)
CREATE TYPE computed_abc2 AS ENUM ('a', 'b', 'c')

-- Test 272: statement (line 1607)
CREATE TABLE t5 (k INT PRIMARY KEY, y computed_abc AS ('a') STORED)

-- Test 273: statement (line 1610)
ALTER TYPE computed_abc DROP VALUE 'a'

-- Test 274: statement (line 1616)
ALTER TYPE computed_abc DROP VALUE 'b'

-- Test 275: statement (line 1619)
ALTER TYPE computed_abc DROP VALUE 'c'

-- Test 276: statement (line 1622)
CREATE TABLE t7 (x _computed_abc2 AS (ARRAY['a'::computed_abc2]) STORED, y computed_abc2[] AS (ARRAY['b':::computed_abc2]) STORED)

-- Test 277: statement (line 1625)
ALTER TYPE computed_abc2 DROP VALUE 'a'

-- Test 278: statement (line 1628)
ALTER TYPE computed_abc2 DROP VALUE 'b'

-- Test 279: statement (line 1635)
CREATE TYPE arr_typ AS ENUM ('a', 'b', 'c')

-- Test 280: statement (line 1638)
CREATE TABLE arr_t6 (
  i arr_typ[] DEFAULT ARRAY['a'::arr_typ],
  j arr_typ DEFAULT ARRAY['b'::arr_typ][1],
  k _arr_typ DEFAULT ARRAY['c'::arr_typ]::_arr_typ,
  FAMILY (i, j, k))

-- Test 281: statement (line 1645)
ALTER TYPE arr_typ RENAME TO arr_typ2

-- Test 282: statement (line 1648)
INSERT INTO arr_t6 VALUES (default, default, default)

onlyif config schema-locked-disabled

-- Test 283: query (line 1652)
SHOW CREATE TABLE arr_t6

-- Test 284: query (line 1665)
SHOW CREATE TABLE arr_t6

-- Test 285: statement (line 1679)
CREATE TYPE typ2 AS ENUM ('a')

-- Test 286: statement (line 1682)
CREATE TABLE tab (k typ2 PRIMARY KEY)

-- Test 287: statement (line 1685)
CREATE INDEX foo ON tab(k) WHERE k = ANY (ARRAY['a', 'a']:::typ2[])

-- Test 288: query (line 1693)
SELECT typname FROM pg_type WHERE oid = $oid

-- Test 289: statement (line 1700)
DROP TYPE IF EXISTS enum_for_predicate;
CREATE TYPE enum_for_predicate AS ENUM ('a', 'b');
CREATE TABLE uses_in_index_predicate (i INT PRIMARY KEY, t enum_for_predicate, INDEX (t) WHERE (t = 'a'))

-- Test 290: statement (line 1705)
ALTER TYPE enum_for_predicate DROP VALUE 'a'

-- Test 291: statement (line 1710)
CREATE TYPE enum_test AS ENUM ('a', 'b');

-- Test 292: statement (line 1713)
CREATE TABLE enum_table (id SERIAL PRIMARY KEY, elem enum_test);

-- Test 293: statement (line 1716)
INSERT INTO enum_table (elem) VALUES ('a'), ('b');

-- Test 294: statement (line 1719)
CREATE TABLE enum_array_table (id SERIAL PRIMARY KEY, elems enum_test[]);

-- Test 295: statement (line 1722)
INSERT INTO enum_array_table (elems) VALUES (array['a']), (array['b']), (array['a', 'b'])

-- Test 296: query (line 1725)
SELECT
  elem,
  elem = 'a'
FROM enum_table
ORDER BY id

-- Test 297: query (line 1735)
SELECT
  elems,
  elems = '{a}'
FROM enum_array_table
ORDER BY id

-- Test 298: query (line 1746)
SELECT
  a.elems,
  b.elems,
  a.elems = b.elems,
  a.elems < b.elems,
  a.elems <= b.elems,
  a.elems IS NOT DISTINCT FROM b.elems
FROM enum_array_table a, enum_array_table b
ORDER BY a.id, b.id

-- Test 299: query (line 1767)
SELECT '{a,b}'::enum_test[] = '{a,b}'

-- Test 300: statement (line 1772)
DROP TABLE enum_table

-- Test 301: statement (line 1778)
CREATE TYPE enum_70378 AS ENUM ('a', 'b');
CREATE TABLE enum_table (a enum_70378);
PREPARE q AS INSERT INTO enum_table VALUES($1);
EXECUTE q('a')

-- Test 302: query (line 1784)
SELECT * FROM enum_table

-- Test 303: statement (line 1789)
ALTER TYPE enum_70378 ADD VALUE 'c';

-- Test 304: statement (line 1792)
EXECUTE q('c')

-- Test 305: query (line 1795)
SELECT * FROM enum_table

-- Test 306: statement (line 1802)
DROP TYPE IF EXISTS greeting;

-- Test 307: statement (line 1805)
CREATE TYPE greeting AS ENUM ('hello', 'howdy', 'hi');

-- Test 308: statement (line 1808)
CREATE TABLE seed AS SELECT g::INT8 AS _int8 FROM generate_series(1, 5) AS g;

-- Test 309: statement (line 1811)
WITH
  cte1 (col1)
    AS (
      SELECT * FROM (VALUES (COALESCE((NULL, 'hello':::greeting), (1, 'howdy':::greeting))), ((2, 'hi':::greeting)))
    ),
  cte2 (col2) AS (SELECT _int8 FROM seed)
SELECT
  col1, col2
FROM
  cte1, cte2;

-- Test 310: query (line 1834)
SELECT _enum FROM t58889 WHERE _enum::greeting58889 IN (NULL, 'hi':::greeting58889);

-- Test 311: statement (line 1841)
CREATE TYPE myenum AS ENUM ('foo', 'bar');

-- Test 312: statement (line 1844)
SELECT 'foo'::myenum::bytes;

-- Test 313: statement (line 1847)
SELECT 'foo'::myenum::bytea;

-- Test 314: statement (line 1850)
SELECT 'foo'::myenum::blob;

-- Test 315: statement (line 1855)
CREATE TABLE tab2 (k greeting)

-- Test 316: statement (line 1858)
INSERT INTO tab2 VALUES ('hello')

skipif config schema-locked-disabled

-- Test 317: statement (line 1862)
ALTER TABLE tab2 SET (schema_locked=false)

-- Test 318: statement (line 1865)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl = false;

-- Test 319: statement (line 1869)
ALTER TABLE tab2 ADD COLUMN j INT

-- Test 320: statement (line 1872)
ALTER TYPE greeting ADD VALUE 'salud' AFTER 'hello'

-- Test 321: statement (line 1876)
INSERT INTO tab2 VALUES ('salud')

-- Test 322: statement (line 1879)
ROLLBACK

skipif config schema-locked-disabled

-- Test 323: statement (line 1883)
ALTER TABLE tab2 SET (schema_locked=true)

-- Test 324: statement (line 1889)
DROP TABLE IF EXISTS t CASCADE;
CREATE TABLE t (i INT PRIMARY KEY);
CREATE TYPE "MixedCase" AS ENUM ('mixed', 'Case');
CREATE TYPE "Emoji 😉" AS ENUM ('😊', '😔');

-- Test 325: statement (line 1895)
ALTER TABLE t ADD COLUMN "MixedCase Column" "MixedCase" DEFAULT ('mixed');

-- Test 326: statement (line 1898)
ALTER TABLE t ADD COLUMN "🙏" "Emoji 😉" DEFAULT ('😊'::"Emoji 😉") ON UPDATE ('😔':::"Emoji 😉");

-- Test 327: statement (line 1901)
DROP TABLE t CASCADE;

-- Test 328: statement (line 1904)
CREATE TABLE t ("🙏" "Emoji 😉" DEFAULT ('😊'::"Emoji 😉") ON UPDATE ('😔':::"Emoji 😉"));

-- Test 329: statement (line 1907)
CREATE FUNCTION "🙏"("🙏" "Emoji 😉") RETURNS "MixedCase" LANGUAGE SQL AS $$
   SELECT 'mixed'::"MixedCase" WHERE "🙏" IS NULL
$$;

-- Test 330: query (line 1912)
SELECT "🙏"('😊'), "🙏"(NULL:::"Emoji 😉")

-- Test 331: statement (line 1917)
CREATE DATABASE "DB➕➕";
USE "DB➕➕"

-- Test 332: statement (line 1921)
CREATE SCHEMA "➖➖"

-- Test 333: statement (line 1925)
CREATE TABLE t (i INT PRIMARY KEY);
CREATE TYPE "➖➖"."MixedCase" AS ENUM ('mixed', 'Case');
CREATE TYPE "Emoji 😉" AS ENUM ('😊', '😔');

-- Test 334: statement (line 1930)
ALTER TABLE t ADD COLUMN "MixedCase Column" "➖➖"."MixedCase" DEFAULT ('mixed');

-- Test 335: statement (line 1933)
ALTER TABLE t ADD COLUMN "🙏" "DB➕➕".public."Emoji 😉" DEFAULT ('😊'::"DB➕➕".public."Emoji 😉") ON UPDATE ('😔':::public."Emoji 😉");

onlyif config schema-locked-disabled

-- Test 336: query (line 1937)
SELECT create_statement FROM [SHOW CREATE TABLE t]

-- Test 337: query (line 1949)
SELECT create_statement FROM [SHOW CREATE TABLE t]

-- Test 338: statement (line 1964)
CREATE DATABASE db1;
CREATE TYPE db1.mytype AS ENUM ('foo');

-- Test 339: statement (line 1968)
CREATE TABLE db1.t (m db1.mytype)

onlyif config schema-locked-disabled

-- Test 340: query (line 1972)
SELECT create_statement FROM [SHOW CREATE TABLE db1.public.t]

-- Test 341: query (line 1982)
SELECT create_statement FROM [SHOW CREATE TABLE db1.public.t]

-- Test 342: statement (line 1995)
USE test

-- Test 343: statement (line 1998)
CREATE TYPE e154461 AS ENUM ('e', 'f', 'g')

-- Test 344: statement (line 2001)
CREATE TABLE t154461 (a e154461, INDEX (a)) WITH (sql_stats_histogram_buckets_count = 2)

-- Test 345: statement (line 2004)
INSERT INTO t154461 VALUES ('e'), ('e'), ('f'), ('g'), ('g')

-- Test 346: statement (line 2007)
CREATE STATISTICS s FROM t154461

-- Test 347: query (line 2010)
SELECT * FROM t154461 WHERE a != 'g' ORDER BY a

-- Test 348: query (line 2021)
SHOW HISTOGRAM $hist_id_1

-- Test 349: query (line 2028)
SELECT jsonb_pretty(stat)
FROM (
  SELECT json_array_elements(statistics) - 'created_at' - 'id' - 'avg_size' AS stat
  FROM [SHOW STATISTICS USING JSON FOR TABLE t154461]
)
WHERE stat->>'columns' = '["a"]'

-- Test 350: statement (line 2064)
DELETE FROM t154461 WHERE a = 'e'

-- Test 351: statement (line 2067)
ALTER TYPE e154461 DROP VALUE 'e'

-- Test 352: query (line 2070)
SELECT * FROM t154461 WHERE a != 'g' ORDER BY a

-- Test 353: query (line 2079)
SHOW HISTOGRAM $hist_id_1

-- Test 354: query (line 2086)
SELECT jsonb_pretty(stat)
FROM (
  SELECT json_array_elements(statistics) - 'created_at' - 'id' - 'avg_size' AS stat
  FROM [SHOW STATISTICS USING JSON FOR TABLE t154461]
)
WHERE stat->>'columns' = '["a"]'

-- Test 355: statement (line 2124)
CREATE TYPE typ158154 AS ENUM ('foo', 'bar');

-- Test 356: statement (line 2127)
CREATE TABLE t158154 (a INT, b typ158154);

-- Test 357: statement (line 2130)
CREATE PROCEDURE p158154() LANGUAGE SQL AS $$
  INSERT INTO t158154 (a) VALUES (1);
  UPDATE t158154 SET a = a + 1;
$$;

-- Test 358: statement (line 2136)
CALL p158154();

-- Test 359: statement (line 2139)
ALTER TABLE t158154 DROP COLUMN b;

-- Test 360: statement (line 2142)
CALL p158154();

-- Test 361: statement (line 2145)
DROP PROCEDURE p158154;
DROP TABLE t158154;
DROP TYPE typ158154;

