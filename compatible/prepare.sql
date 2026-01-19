-- PostgreSQL compatible tests from prepare
-- 293 tests

-- Test 1: statement (line 5)
DEALLOCATE a

statement
PREPARE a AS SELECT 1

-- Test 2: query (line 11)
EXECUTE a

-- Test 3: query (line 16)
EXECUTE a

-- Test 4: statement (line 21)
PREPARE a AS SELECT 1

statement
DEALLOCATE a

-- Test 5: statement (line 27)
DEALLOCATE a

-- Test 6: statement (line 30)
EXECUTE a

statement
PREPARE a AS SELECT 1

statement
PREPARE b AS SELECT 1

-- Test 7: query (line 39)
EXECUTE a

-- Test 8: query (line 44)
EXECUTE b

-- Test 9: statement (line 49)
DEALLOCATE ALL

-- Test 10: statement (line 52)
DEALLOCATE a

-- Test 11: statement (line 55)
EXECUTE a

-- Test 12: statement (line 58)
DEALLOCATE b

-- Test 13: statement (line 61)
EXECUTE b

-- Test 14: query (line 66)
PREPARE a as ()

statement error could not determine data type of placeholder \$1
PREPARE a AS SELECT $1

statement error could not determine data type of placeholder \$1
PREPARE a AS SELECT $2:::int

statement error could not determine data type of placeholder \$2
PREPARE a AS SELECT $1:::int, $3:::int

statement ok
PREPARE a AS SELECT $1:::int + $2

query I
EXECUTE a(3, 1)

-- Test 15: query (line 86)
EXECUTE a('foo', 1)

query I
EXECUTE a(3.5, 1)

-- Test 16: query (line 94)
EXECUTE a(max(3), 1)

query error window functions are not allowed in EXECUTE parameter
EXECUTE a(rank() over (partition by 3), 1)

query error variable sub-expressions are not allowed in EXECUTE parameter
EXECUTE a((SELECT 3), 1)

query error wrong number of parameters for prepared statement \"a\": expected 2, got 3
EXECUTE a(1, 1, 1)

query error wrong number of parameters for prepared statement \"a\": expected 2, got 0
EXECUTE a

# Regression test for #36153.
statement error unknown signature: array_length\(int, int\)
PREPARE fail AS SELECT array_length($1, 1)

## Type hints

statement
PREPARE b (int) AS SELECT $1

query I
EXECUTE b(3)

-- Test 17: query (line 140)
EXECUTE c

-- Test 18: query (line 154)
EXECUTE i(1)

-- Test 19: query (line 159)
EXECUTE i(2)

-- Test 20: query (line 164)
EXECUTE i('foo')

query I
EXECUTE i(3.3)

-- Test 21: query (line 172)
EXECUTE i(4.3::int)

-- Test 22: query (line 177)
EXECUTE s

-- Test 23: query (line 188)
EXECUTE s DISCARD ROWS

-- Test 24: query (line 201)
EXECUTE x

-- Test 25: query (line 210)
EXECUTE y

-- Test 26: statement (line 233)
EXECUTE x

-- Test 27: statement (line 247)
EXECUTE y (3, 4)

-- Test 28: query (line 250)
SELECT * FROM f

-- Test 29: query (line 268)
EXECUTE groupbyhaving(1)

-- Test 30: statement (line 286)
EXECUTE wrongTypeImpossibleCast('crabgas')

-- Test 31: statement (line 291)
PREPARE s AS SELECT a FROM t; PREPARE p1 AS UPSERT INTO t(a) VALUES($1) RETURNING a

-- Test 32: query (line 294)
EXECUTE s

-- Test 33: query (line 302)
EXECUTE p1(123)

-- Test 34: statement (line 307)
PREPARE p2 AS UPDATE t SET a = a + $1 RETURNING a

-- Test 35: query (line 310)
EXECUTE s

-- Test 36: query (line 319)
EXECUTE p2(123)

-- Test 37: statement (line 328)
PREPARE p3 AS DELETE FROM t WHERE a = $1 RETURNING a

-- Test 38: query (line 331)
EXECUTE s

-- Test 39: query (line 340)
EXECUTE p3(124)

-- Test 40: statement (line 345)
PREPARE p4 AS CANCEL JOB $1

-- Test 41: query (line 372)
EXECUTE setp('hello'); SHOW application_name

-- Test 42: statement (line 383)
EXECUTE sets('hello')

-- Test 43: statement (line 388)
PREPARE x19597 AS SELECT $1 IN ($2, null);

-- Test 44: statement (line 391)
PREPARE invalid AS SELECT $1:::int + $1:::float

-- Test 45: statement (line 394)
PREPARE invalid (int) AS SELECT $1:::float

-- Test 46: statement (line 397)
PREPARE innerStmt AS SELECT $1:::int i, 'foo' t

-- Test 47: statement (line 400)
PREPARE outerStmt AS SELECT * FROM [EXECUTE innerStmt(3)] WHERE t = $1

-- Test 48: query (line 403)
SELECT * FROM [EXECUTE innerStmt(1)] CROSS JOIN [EXECUTE x]

statement ok
PREPARE selectin AS SELECT 1 in ($1, $2)

statement ok
PREPARE selectin2 AS SELECT $1::int in ($2, $3)

query B
EXECUTE selectin(5, 1)

-- Test 49: query (line 417)
EXECUTE selectin2(1, 5, 1)

-- Test 50: statement (line 423)
CREATE TABLE kv (k INT PRIMARY KEY, v INT)

-- Test 51: statement (line 426)
INSERT INTO kv VALUES (1, 1), (2, 2), (3, 3)

-- Test 52: statement (line 429)
PREPARE x21701a AS SELECT * FROM kv WHERE k = $1

-- Test 53: query (line 432)
EXECUTE x21701a(NULL)

-- Test 54: statement (line 436)
PREPARE x21701b AS SELECT * FROM kv WHERE k IS DISTINCT FROM $1

-- Test 55: query (line 439)
EXECUTE x21701b(NULL)

-- Test 56: statement (line 446)
PREPARE x21701c AS SELECT * FROM kv WHERE k IS NOT DISTINCT FROM $1

-- Test 57: query (line 449)
EXECUTE x21701c(NULL)

-- Test 58: statement (line 453)
DROP TABLE kv

-- Test 59: statement (line 460)
BEGIN TRANSACTION

-- Test 60: statement (line 463)
create table bar (id integer)

-- Test 61: statement (line 466)
PREPARE forbar AS insert into bar (id) VALUES (1)

-- Test 62: statement (line 469)
COMMIT TRANSACTION

-- Test 63: statement (line 473)
CREATE TABLE aggtab (a INT PRIMARY KEY);
INSERT INTO aggtab (a) VALUES (1)

-- Test 64: statement (line 477)
PREPARE aggprep AS SELECT max(a + $1:::int) FROM aggtab

-- Test 65: query (line 480)
EXECUTE aggprep(10)

-- Test 66: query (line 485)
EXECUTE aggprep(20)

-- Test 67: statement (line 492)
CREATE TABLE abc (a INT PRIMARY KEY, b INT, c INT);
CREATE TABLE xyz (x INT PRIMARY KEY, y INT, z INT, INDEX(y));
INSERT INTO abc (a, b, c) VALUES (1, 10, 100);
INSERT INTO xyz (x, y, z) VALUES (1, 5, 50);
INSERT INTO xyz (x, y, z) VALUES (2, 6, 60);

-- Test 68: statement (line 499)
PREPARE subqueryprep AS SELECT * FROM abc WHERE EXISTS(SELECT * FROM xyz WHERE y IN ($1 + 1))

-- Test 69: query (line 502)
EXECUTE subqueryprep(4)

-- Test 70: query (line 507)
EXECUTE subqueryprep(5)

-- Test 71: query (line 512)
EXECUTE subqueryprep(6)

-- Test 72: statement (line 521)
CREATE DATABASE otherdb

-- Test 73: statement (line 524)
USE otherdb

-- Test 74: statement (line 527)
CREATE TABLE othertable (a INT PRIMARY KEY, b INT); INSERT INTO othertable (a, b) VALUES (1, 10)

-- Test 75: statement (line 532)
PREPARE change_db AS SELECT current_database()

-- Test 76: query (line 535)
EXECUTE change_db

-- Test 77: statement (line 540)
USE test

-- Test 78: query (line 543)
EXECUTE change_db

-- Test 79: statement (line 548)
USE otherdb

-- Test 80: statement (line 553)
PREPARE change_db_2 AS SELECT * FROM othertable

-- Test 81: query (line 556)
EXECUTE change_db_2

-- Test 82: statement (line 561)
USE test

-- Test 83: query (line 564)
EXECUTE change_db_2

statement ok
CREATE TABLE othertable (a INT PRIMARY KEY, b INT); INSERT INTO othertable (a, b) VALUES (2, 20)

query II
EXECUTE change_db_2

-- Test 84: statement (line 577)
PREPARE change_db_3 AS SELECT * from othertable AS t1, test.othertable AS t2

-- Test 85: query (line 580)
EXECUTE change_db_3

-- Test 86: statement (line 585)
USE otherdb

-- Test 87: query (line 588)
EXECUTE change_db_3

-- Test 88: statement (line 593)
DROP TABLE test.othertable

-- Test 89: statement (line 598)
PREPARE change_search_path AS SELECT * FROM othertable

-- Test 90: query (line 601)
EXECUTE change_search_path

-- Test 91: statement (line 606)
SET search_path = pg_catalog

-- Test 92: statement (line 630)
DROP TABLE pg_type

-- Test 93: statement (line 635)
PREPARE new_table_in_search_path_2 AS
  SELECT a.typname, b.typname FROM pg_type AS a, pg_catalog.pg_type AS b ORDER BY a.typname, b.typname LIMIT 1

-- Test 94: query (line 639)
EXECUTE new_table_in_search_path_2

-- Test 95: query (line 647)
EXECUTE new_table_in_search_path_2

-- Test 96: statement (line 652)
DROP TABLE pg_type

-- Test 97: statement (line 655)
RESET search_path

-- Test 98: query (line 660)
SELECT has_column_privilege('testuser', 'othertable', 1, 'SELECT')

-- Test 99: statement (line 665)
GRANT ALL ON othertable TO testuser

-- Test 100: query (line 668)
SELECT has_column_privilege('testuser', 'othertable', 1, 'SELECT')

-- Test 101: statement (line 673)
REVOKE ALL ON othertable FROM testuser

-- Test 102: statement (line 678)
PREPARE change_loc AS SELECT '2000-01-01 18:05:10.123'::timestamptz

-- Test 103: query (line 681)
EXECUTE change_loc

-- Test 104: statement (line 686)
SET TIME ZONE 'EST'

-- Test 105: query (line 689)
EXECUTE change_loc

-- Test 106: statement (line 694)
SET TIME ZONE 'UTC'

-- Test 107: statement (line 701)
PREPARE loc_dependent_operator AS
SELECT
  extract(EPOCH FROM TIMESTAMP WITH TIME ZONE '2010-11-06 23:59:00-05:00'),
  extract(EPOCH FROM TIMESTAMP WITH TIME ZONE '2010-11-06 23:59:00-05:00' + INTERVAL '1 day')

-- Test 108: statement (line 707)
SET TIME ZONE 'America/Chicago'

-- Test 109: query (line 710)
EXECUTE loc_dependent_operator

-- Test 110: statement (line 715)
SET TIME ZONE 'Europe/Berlin'

-- Test 111: query (line 718)
EXECUTE loc_dependent_operator

-- Test 112: statement (line 723)
SET TIME ZONE 'UTC'

-- Test 113: statement (line 728)
GRANT ALL ON othertable TO testuser

user testuser

-- Test 114: statement (line 733)
USE otherdb

-- Test 115: statement (line 736)
PREPARE change_privileges AS SELECT * FROM othertable

-- Test 116: query (line 739)
EXECUTE change_privileges

-- Test 117: statement (line 746)
REVOKE ALL ON othertable FROM testuser

user testuser

-- Test 118: query (line 751)
EXECUTE change_privileges

user root

## Permissions: Use UPDATE statement that requires both UPDATE and SELECT
## privileges.
statement ok
GRANT ALL ON othertable TO testuser

user testuser

statement ok
USE otherdb

statement ok
PREPARE update_privileges AS UPDATE othertable SET b=$1

user root

statement ok
REVOKE UPDATE ON othertable FROM testuser

user testuser

query error pq: user testuser does not have UPDATE privilege on relation othertable
EXECUTE update_privileges(5)

user root

statement ok
GRANT UPDATE ON othertable TO testuser

statement ok
REVOKE SELECT ON othertable FROM testuser

user testuser

query error pq: user testuser does not have SELECT privilege on relation othertable
EXECUTE update_privileges(5)

user root

query II
SELECT * FROM othertable

-- Test 119: statement (line 803)
PREPARE change_rename AS SELECT * FROM othertable

-- Test 120: query (line 806)
EXECUTE change_rename

-- Test 121: statement (line 812)
ALTER TABLE othertable RENAME COLUMN b TO c

-- Test 122: query (line 815)
EXECUTE change_rename

-- Test 123: statement (line 821)
ALTER TABLE othertable RENAME COLUMN c TO b

-- Test 124: query (line 824)
EXECUTE change_rename

-- Test 125: statement (line 832)
PREPARE change_placeholders AS SELECT * FROM othertable WHERE a=$1

-- Test 126: query (line 835)
EXECUTE change_placeholders(1)

-- Test 127: statement (line 841)
ALTER TABLE othertable RENAME COLUMN b TO c

-- Test 128: query (line 844)
EXECUTE change_placeholders(1)

-- Test 129: statement (line 850)
ALTER TABLE othertable RENAME COLUMN c TO b

-- Test 130: query (line 853)
EXECUTE change_placeholders(1)

-- Test 131: statement (line 861)
CREATE VIEW otherview AS SELECT a, b FROM othertable

-- Test 132: statement (line 864)
PREPARE change_view AS SELECT * FROM otherview

-- Test 133: query (line 867)
EXECUTE change_view

-- Test 134: statement (line 872)
ALTER VIEW otherview RENAME TO otherview2

-- Test 135: query (line 875)
EXECUTE change_view

statement ok
DROP VIEW otherview2

## Schema change: Drop column and ensure that correct error is reported.
statement ok
PREPARE change_drop AS SELECT * FROM othertable WHERE b=10

query II
EXECUTE change_drop

-- Test 136: statement (line 890)
ALTER TABLE othertable DROP COLUMN b

-- Test 137: query (line 893)
EXECUTE change_drop

statement ok
ALTER TABLE othertable ADD COLUMN b INT;

statement ok
UPDATE othertable SET b=10

query II
EXECUTE change_drop

-- Test 138: statement (line 909)
PREPARE change_schema_uncommitted AS SELECT * FROM othertable

-- Test 139: statement (line 912)
BEGIN TRANSACTION

-- Test 140: query (line 915)
EXECUTE change_schema_uncommitted

-- Test 141: statement (line 921)
ALTER TABLE othertable RENAME COLUMN b TO c

-- Test 142: query (line 924)
EXECUTE change_schema_uncommitted

-- Test 143: statement (line 933)
ALTER TABLE othertable RENAME COLUMN c TO d

-- Test 144: query (line 936)
EXECUTE change_schema_uncommitted

-- Test 145: statement (line 942)
ROLLBACK TRANSACTION

-- Test 146: statement (line 947)
CREATE SEQUENCE seq

-- Test 147: statement (line 950)
PREPARE pg_catalog_query AS SELECT * FROM pg_catalog.pg_sequence

-- Test 148: query (line 953)
EXECUTE pg_catalog_query

-- Test 149: statement (line 959)
USE test

-- Test 150: query (line 962)
EXECUTE pg_catalog_query

-- Test 151: statement (line 968)
SELECT $1:::int

-- Test 152: statement (line 972)
CREATE SEQUENCE seq

-- Test 153: statement (line 975)
PREPARE seqsel AS SELECT * FROM seq

-- Test 154: query (line 978)
SELECT nextval('seq')

-- Test 155: query (line 983)
EXECUTE seqsel

-- Test 156: statement (line 988)
DROP SEQUENCE seq

-- Test 157: statement (line 991)
CREATE SEQUENCE seq

-- Test 158: query (line 994)
EXECUTE seqsel

-- Test 159: query (line 1004)
EXECUTE foobar(NULL, NULL)

-- Test 160: statement (line 1013)
SET application_name = ap35145

-- Test 161: statement (line 1018)
CREATE DATABASE d35145; SET database = d35145;

-- Test 162: statement (line 1021)
PREPARE display_appname AS SELECT setting FROM pg_settings WHERE name = 'application_name'

-- Test 163: query (line 1024)
EXECUTE display_appname

-- Test 164: statement (line 1031)
DROP DATABASE d35145

-- Test 165: query (line 1034)
EXECUTE display_appname

statement ok
CREATE DATABASE d35145

query T
EXECUTE display_appname

-- Test 166: statement (line 1047)
CREATE DATABASE d35145_2; SET database = d35145_2; DROP DATABASE d35145_2

-- Test 167: query (line 1050)
EXECUTE display_appname

# Check what happens when the stmt is executed over no db whatsoever.

statement ok
SET database = ''

query error  cannot access virtual schema in anonymous database
EXECUTE display_appname

statement ok
SET database = 'test'

# Lookup by ID: Rename column in table and ensure that the prepared statement
# is updated to incorporate it.
statement ok
CREATE TABLE ab (a INT PRIMARY KEY, b INT); INSERT INTO ab(a, b) VALUES (1, 10)

let $id
SELECT id FROM system.namespace WHERE name='ab'

statement ok
PREPARE change_rename_2 AS SELECT * FROM [$id AS ab]

query II colnames
EXECUTE change_rename_2

-- Test 168: statement (line 1081)
ALTER TABLE ab RENAME COLUMN b TO c

-- Test 169: query (line 1084)
EXECUTE change_rename_2

-- Test 170: statement (line 1090)
ALTER TABLE ab RENAME COLUMN c TO b

-- Test 171: query (line 1093)
EXECUTE change_rename_2

-- Test 172: statement (line 1099)
USE test

-- Test 173: statement (line 1105)
INSERT INTO t2 SELECT i, to_english(i) FROM generate_series(1, 5) AS g(i)

-- Test 174: statement (line 1108)
PREPARE a AS OPT PLAN 'xx'

-- Test 175: statement (line 1111)
SET allow_prepare_as_opt_plan = ON

-- Test 176: statement (line 1114)
PREPARE a AS OPT PLAN '
(Root
  (Scan [ (Table "t2") (Cols "k,str") ])
  (Presentation "k,str")
  (NoOrdering)
)'

-- Test 177: query (line 1122)
EXECUTE a

-- Test 178: statement (line 1131)
PREPARE b AS OPT PLAN '
(Root
  (Sort
    (Select
      (Scan [ (Table "t2") (Cols "k,str") ])
      [
        (Eq
          (Mod (Var "k") (Const 2 "int"))
          (Const 1 "int")
        )
      ]
    )
  )
  (Presentation "k,str")
  (OrderingChoice "+str")
)'

-- Test 179: query (line 1149)
EXECUTE b

-- Test 180: query (line 1179)
EXECUTE e

-- Test 181: statement (line 1206)
USE test

-- Test 182: statement (line 1209)
SET allow_prepare_as_opt_plan = ON

-- Test 183: statement (line 1212)
SELECT * FROM t2

-- Test 184: statement (line 1215)
PREPARE a AS OPT PLAN '
(Root
  (Scan [ (Table "t2") (Cols "k") ])
  (Presentation "k")
  (NoOrdering)
)'

-- Test 185: statement (line 1224)
PREPARE b AS OPT PLAN '
(Root
  (Scan [ (Table "t2") (Cols "k,str") ])
  (Presentation "k,str")
  (NoOrdering)
)'

-- Test 186: query (line 1236)
EXECUTE rcc('t')

-- Test 187: statement (line 1248)
CREATE TABLE ts (d DATE PRIMARY KEY, x INT)

-- Test 188: statement (line 1251)
ALTER TABLE ts INJECT STATISTICS '[
  {
    "columns": ["d"],
    "created_at": "2020-03-24 15:34:22.863634+00:00",
    "distinct_count": 1000,
    "histo_buckets": [
      {
        "distinct_range": 0,
        "num_eq": 1,
        "num_range": 0,
        "upper_bound": "2020-03-24 15:16:12.117516+00:00"
      },
      {
        "distinct_range": 501.60499999999996,
        "num_eq": 10,
        "num_range": 9999,
        "upper_bound": "2020-03-25 00:05:28.117516+00:00"
      }
    ],
    "histo_col_type": "TIMESTAMP",
    "name": "__auto__",
    "null_count": 0,
    "row_count": 100000
  }
]'

-- Test 189: statement (line 1279)
CREATE VIEW tview AS VALUES (1)

-- Test 190: statement (line 1282)
PREPARE tview_prep AS SELECT * FROM tview

-- Test 191: statement (line 1285)
CREATE OR REPLACE VIEW tview AS VALUES (2)

-- Test 192: query (line 1288)
EXECUTE tview_prep

-- Test 193: statement (line 1295)
CREATE TABLE t3 (i INT PRIMARY KEY)

-- Test 194: statement (line 1298)
PREPARE a1 AS SELECT * FROM t3 FOR UPDATE

-- Test 195: statement (line 1301)
BEGIN READ ONLY

-- Test 196: statement (line 1304)
EXECUTE a1

-- Test 197: statement (line 1307)
ROLLBACK

-- Test 198: statement (line 1310)
DEALLOCATE a1

-- Test 199: statement (line 1313)
PREPARE a1 AS SELECT * FROM t3 FOR NO KEY UPDATE

-- Test 200: statement (line 1316)
BEGIN READ ONLY

-- Test 201: statement (line 1319)
EXECUTE a1

-- Test 202: statement (line 1322)
ROLLBACK

-- Test 203: statement (line 1325)
DEALLOCATE a1

-- Test 204: statement (line 1328)
PREPARE a1 AS SELECT * FROM t3 FOR SHARE

-- Test 205: statement (line 1331)
BEGIN READ ONLY

-- Test 206: statement (line 1334)
EXECUTE a1

-- Test 207: statement (line 1337)
ROLLBACK

-- Test 208: statement (line 1340)
DEALLOCATE a1

-- Test 209: statement (line 1343)
PREPARE a1 AS SELECT * FROM t3 FOR KEY SHARE

-- Test 210: statement (line 1346)
BEGIN READ ONLY

-- Test 211: statement (line 1349)
EXECUTE a1

-- Test 212: statement (line 1352)
ROLLBACK

-- Test 213: statement (line 1355)
DEALLOCATE a1

-- Test 214: statement (line 1358)
DROP TABLE t3

-- Test 215: statement (line 1362)
CREATE TYPE greeting AS ENUM ('hello', 'hi');
CREATE TABLE greeting_table (x greeting NOT NULL, y INT, INDEX (x, y))

-- Test 216: statement (line 1367)
PREPARE enum_query AS SELECT x, y FROM greeting_table WHERE y = 2

-- Test 217: statement (line 1371)
PREPARE enum_drop AS DROP TYPE greeting

-- Test 218: statement (line 1375)
ALTER TYPE greeting ADD VALUE 'howdy'

-- Test 219: statement (line 1379)
INSERT INTO greeting_table VALUES ('howdy', 2)

-- Test 220: query (line 1383)
EXECUTE enum_query

-- Test 221: statement (line 1389)
DROP TABLE greeting_table

-- Test 222: statement (line 1393)
EXECUTE enum_drop

-- Test 223: statement (line 1397)
CREATE TABLE t64765 (x INT PRIMARY KEY, y INT, z INT)

-- Test 224: statement (line 1400)
PREPARE q64765 as SELECT * FROM t64765 WHERE x = $1 AND y = $2

-- Test 225: statement (line 1403)
EXECUTE q64765(1, 1)

-- Test 226: statement (line 1407)
CREATE TABLE t81315 (a DECIMAL NOT NULL PRIMARY KEY, b INT);
PREPARE q81315 AS SELECT * FROM t81315 WHERE a = $1::INT8;
INSERT INTO t81315 VALUES (1, 100), (2, 200)

-- Test 227: query (line 1412)
SELECT * FROM t81315 WHERE a = 1

-- Test 228: query (line 1417)
EXECUTE q81315 (1)

-- Test 229: statement (line 1422)
CREATE TABLE t81315_2 (
  k INT PRIMARY KEY,
  a INT
);
PREPARE q81315_2 AS SELECT * FROM t81315_2 WHERE k = $1;
INSERT INTO t81315_2 VALUES (1, 1)

-- Test 230: query (line 1430)
EXECUTE q81315_2(1::DECIMAL)

-- Test 231: statement (line 1437)
PREPARE args_test_many(int, int) as select $1

-- Test 232: query (line 1440)
EXECUTE args_test_many(1, 2)

-- Test 233: query (line 1445)
EXECUTE args_test_many(1)

statement ok
PREPARE args_test_few(int) as select $1, $2::int

query II
EXECUTE args_test_few(1, 2)

-- Test 234: query (line 1456)
EXECUTE args_test_few(1)

statement ok
DROP TABLE IF EXISTS t;

statement ok
CREATE TABLE t (x int, y varchar(10), z int2);

statement ok
PREPARE args_deduce_type(int, int, int, int) AS INSERT INTO t VALUES ($1, $2, $3);

statement ok
EXECUTE args_deduce_type(1,2,3,4);
EXECUTE args_deduce_type('1','2',3,'4');

query ITI rowsort
SELECT * FROM t;

-- Test 235: statement (line 1478)
PREPARE args_deduce_type_1(int) AS SELECT $1::int, $2::varchar(10), $3::varchar(20);

-- Test 236: query (line 1481)
EXECUTE args_deduce_type_1(1,10,100);

-- Test 237: statement (line 1489)
DEALLOCATE ALL

-- Test 238: statement (line 1494)
SET prepared_statements_cache_size = '1 KiB'

-- Test 239: statement (line 1497)
PREPARE pscs01 AS SELECT $1::bool, 1

-- Test 240: statement (line 1500)
PREPARE pscs02 AS SELECT $1::float, 2

-- Test 241: statement (line 1503)
PREPARE pscs03 AS SELECT $1::decimal, 3

-- Test 242: statement (line 1509)
PREPARE pscs05 AS SELECT $1::json, 5

-- Test 243: statement (line 1512)
PREPARE pscs06 AS SELECT $1::int, 6

-- Test 244: query (line 1515)
SELECT name FROM pg_catalog.pg_prepared_statements ORDER BY name

-- Test 245: query (line 1520)
EXECUTE pscs06(6)

-- Test 246: statement (line 1525)
EXECUTE pscs05(5)

-- Test 247: statement (line 1528)
EXECUTE pscs04(4)

-- Test 248: statement (line 1531)
EXECUTE pscs03(3)

-- Test 249: statement (line 1534)
EXECUTE pscs02(2)

-- Test 250: statement (line 1537)
EXECUTE pscs01(1)

-- Test 251: statement (line 1541)
SET prepared_statements_cache_size = '20 KiB'

-- Test 252: statement (line 1544)
PREPARE pscs07 AS SELECT $1::date, 7

-- Test 253: statement (line 1547)
PREPARE pscs08 AS SELECT $1::timestamp, 8

-- Test 254: statement (line 1550)
PREPARE pscs09 AS SELECT $1::bool, 9

-- Test 255: statement (line 1553)
PREPARE pscs10 AS SELECT $1::bytes, 10

-- Test 256: statement (line 1556)
PREPARE pscs11 AS SELECT $1::smallint, 11

-- Test 257: statement (line 1559)
PREPARE pscs12 AS SELECT $1::time, 12

-- Test 258: statement (line 1562)
PREPARE pscs13 AS SELECT $1::bigint, 13

-- Test 259: query (line 1565)
SELECT name FROM pg_catalog.pg_prepared_statements ORDER BY name

-- Test 260: statement (line 1574)
DEALLOCATE pscs10

-- Test 261: statement (line 1578)
PREPARE pscs14 AS SELECT $1::int, 14

-- Test 262: query (line 1581)
SELECT name FROM pg_catalog.pg_prepared_statements ORDER BY name

-- Test 263: query (line 1591)
EXECUTE pscs11(11)

-- Test 264: statement (line 1596)
PREPARE pscs15 AS SELECT $1::timetz, 15

-- Test 265: statement (line 1599)
PREPARE pscs16 AS SELECT $1::float, 16

-- Test 266: statement (line 1602)
PREPARE pscs17 AS SELECT $1::interval, 17

-- Test 267: query (line 1605)
SELECT name FROM pg_catalog.pg_prepared_statements ORDER BY name

-- Test 268: statement (line 1618)
CREATE SEQUENCE s

-- Test 269: statement (line 1634)
INSERT INTO prep_stmts SELECT 3, name FROM pg_catalog.pg_prepared_statements

-- Test 270: query (line 1638)
SELECT currval('s')

-- Test 271: query (line 1646)
SELECT which, name FROM prep_stmts ORDER BY which, name

-- Test 272: statement (line 1667)
DROP TABLE prep_stmts

-- Test 273: statement (line 1670)
DROP SEQUENCE s

-- Test 274: statement (line 1673)
DEALLOCATE ALL

-- Test 275: statement (line 1676)
RESET prepared_statements_cache_size

-- Test 276: statement (line 1679)
PREPARE p AS EXPLAIN ANALYZE SELECT 1

-- Test 277: statement (line 1686)
CREATE TYPE color AS ENUM ('red', 'blue', 'green');
CREATE TABLE test_114867 (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    colors color[] DEFAULT ARRAY[]::color[]
)

-- Test 278: statement (line 1693)
PREPARE s_114867 AS INSERT INTO test_114867(colors) VALUES (ARRAY[$1::text]::color[]);
EXECUTE s_114867('red')

-- Test 279: statement (line 1698)
ALTER TABLE test_114867 SET (schema_locked=false)

-- Test 280: statement (line 1701)
TRUNCATE TABLE test_114867 CASCADE

-- Test 281: statement (line 1704)
ALTER TABLE test_114867 RESET (schema_locked)

-- Test 282: statement (line 1707)
EXECUTE s_114867('red')

-- Test 283: query (line 1710)
SELECT colors FROM test_114867

-- Test 284: statement (line 1718)
CREATE PROCEDURE foo(x INT) LANGUAGE SQL AS $$
  SELECT 1;
  SELECT 2;
$$;

-- Test 285: statement (line 1724)
PREPARE bar AS CALL foo(0);

-- Test 286: statement (line 1727)
PREPARE bar AS CALL foo($1);

-- Test 287: statement (line 1736)
PREPARE p AS
ALTER DATABASE test CONFIGURE ZONE USING gc.ttlseconds = $1

-- Test 288: statement (line 1740)
EXECUTE p(120)

-- Test 289: statement (line 1747)
PREPARE p152664 (BOOL, UNKNOWN, DECIMAL) AS SELECT IF($1, $2, $3) IS NOT NAN

-- Test 290: query (line 1750)
EXECUTE p152664(false, NULL, 4)

-- Test 291: statement (line 1755)
DEALLOCATE p152664

-- Test 292: statement (line 1758)
PREPARE p152664 (BOOL, DECIMAL, UNKNOWN) AS SELECT IF($1, $2, $3) IS NOT NAN

-- Test 293: query (line 1761)
EXECUTE p152664(true, 4, NULL)

