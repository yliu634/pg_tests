-- PostgreSQL compatible tests from sequences
-- 580 tests

-- Test 1: statement (line 8)
SET CLUSTER SETTING sql.cross_db_sequence_owners.enabled = TRUE

-- Test 2: statement (line 11)
SET CLUSTER SETTING sql.cross_db_sequence_references.enabled = TRUE

-- Test 3: statement (line 15)
SET DATABASE = test

-- Test 4: statement (line 18)
CREATE SEQUENCE lastval_test

-- Test 5: statement (line 21)
CREATE SEQUENCE lastval_test_2 START WITH 10

-- Test 6: statement (line 24)
SELECT lastval()

-- Test 7: query (line 27)
SELECT nextval('lastval_test')

-- Test 8: query (line 32)
SELECT lastval()

-- Test 9: query (line 37)
SELECT nextval('lastval_test_2')

-- Test 10: query (line 42)
SELECT lastval()

-- Test 11: query (line 47)
SELECT nextval('lastval_test')

-- Test 12: query (line 52)
SELECT lastval()

-- Test 13: query (line 57)
SELECT nextval('lastval_test_2')

-- Test 14: query (line 62)
SELECT lastval()

-- Test 15: query (line 70)
SELECT nextval($lastval_test_id::regclass)

-- Test 16: query (line 75)
SELECT lastval()

-- Test 17: query (line 83)
SELECT nextval($lastval_test_2_id::regclass)

-- Test 18: query (line 88)
SELECT lastval()

-- Test 19: statement (line 95)
CREATE SEQUENCE foo

-- Test 20: statement (line 99)
CREATE SEQUENCE foo

-- Test 21: statement (line 102)
CREATE SEQUENCE IF NOT EXISTS foo

-- Test 22: statement (line 105)
CREATE SEQUENCE bar INCREMENT 5 MAXVALUE 1000 INCREMENT 2

-- Test 23: statement (line 109)
CREATE TABLE foo (k BYTES PRIMARY KEY, v BYTES)

-- Test 24: statement (line 113)
CREATE SEQUENCE zero_test INCREMENT 0

-- Test 25: statement (line 116)
CREATE SEQUENCE high_minvalue_test MINVALUE 5

-- Test 26: statement (line 121)
CREATE SEQUENCE limit_test MAXVALUE 10 START WITH 11

-- Test 27: statement (line 124)
CREATE SEQUENCE limit_test MINVALUE 10 START WITH 5

-- Test 28: statement (line 127)
CREATE SEQUENCE cycle_test CYCLE

-- Test 29: statement (line 130)
CREATE SEQUENCE ignored_options_test NO CYCLE

-- Test 30: statement (line 135)
CREATE SEQUENCE show_create_test

-- Test 31: query (line 138)
SELECT * FROM crdb_internal.create_statements WHERE descriptor_name = 'show_create_test'

-- Test 32: query (line 144)
SHOW CREATE SEQUENCE show_create_test

-- Test 33: statement (line 152)
INSERT INTO foo VALUES (1, 2, 3)

-- Test 34: statement (line 155)
UPDATE foo SET value = 5

-- Test 35: statement (line 158)
DELETE FROM foo

-- Test 36: statement (line 161)
TRUNCATE foo

-- Test 37: statement (line 165)
DROP TABLE foo

-- Test 38: statement (line 169)
CREATE SCHEMA other_schema

-- Test 39: statement (line 172)
CREATE SEQUENCE other_schema.seq

-- Test 40: query (line 177)
SHOW SEQUENCES

-- Test 41: statement (line 188)
CREATE DATABASE seqdb; USE seqdb; CREATE SEQUENCE otherseq; USE test

-- Test 42: query (line 191)
SHOW SEQUENCES FROM seqdb

-- Test 43: statement (line 198)
CREATE SEQUENCE select_test

-- Test 44: query (line 201)
SELECT * FROM select_test

-- Test 45: query (line 208)
SELECT last_value FROM select_test

-- Test 46: statement (line 213)
SELECT nextval('select_test')

-- Test 47: query (line 216)
SELECT last_value FROM select_test

-- Test 48: statement (line 222)
SELECT foo from select_test

-- Test 49: statement (line 227)
SELECT currval('foo')

-- Test 50: query (line 230)
SELECT nextval('foo')

-- Test 51: query (line 235)
SELECT nextval('foo')

-- Test 52: query (line 240)
SELECT currval('foo')

-- Test 53: query (line 248)
SELECT nextval($foo_id::regclass)

-- Test 54: query (line 253)
SELECT currval($foo_id::regclass)

-- Test 55: query (line 258)
SELECT pg_sequence_parameters('foo'::regclass::oid)

-- Test 56: statement (line 265)
CREATE SEQUENCE bar INCREMENT 5

-- Test 57: query (line 268)
SELECT nextval('bar')

-- Test 58: query (line 273)
SELECT nextval('bar')

-- Test 59: query (line 278)
SELECT pg_sequence_parameters('bar'::regclass::oid)

-- Test 60: statement (line 285)
CREATE SEQUENCE baz START 2 INCREMENT 5

-- Test 61: query (line 288)
SELECT nextval('baz')

-- Test 62: query (line 293)
SELECT nextval('baz')

-- Test 63: query (line 301)
SELECT nextval($baz_id::regclass)

-- Test 64: query (line 306)
SELECT pg_sequence_parameters('baz'::regclass::oid)

-- Test 65: statement (line 313)
CREATE SEQUENCE down_test INCREMENT BY -1 START -5

-- Test 66: query (line 316)
SELECT nextval('down_test')

-- Test 67: query (line 321)
SELECT nextval('down_test')

-- Test 68: query (line 329)
SELECT nextval($down_test_id::regclass)

-- Test 69: query (line 334)
SELECT pg_sequence_parameters('down_test'::regclass::oid)

-- Test 70: statement (line 342)
CREATE SEQUENCE spécial

-- Test 71: query (line 345)
SELECT nextval('spécial')

-- Test 72: statement (line 352)
CREATE TABLE kv (k bytes primary key, v bytes)

-- Test 73: statement (line 355)
SELECT nextval('kv')

-- Test 74: statement (line 359)
SELECT nextval('@#%@!324234')

-- Test 75: statement (line 364)
CREATE DATABASE other_db

-- Test 76: statement (line 367)
SET DATABASE = other_db

-- Test 77: statement (line 370)
CREATE SEQUENCE other_db_test

-- Test 78: statement (line 373)
SET DATABASE = test

-- Test 79: statement (line 378)
CREATE DATABASE foo

-- Test 80: statement (line 381)
CREATE DATABASE bar

-- Test 81: statement (line 384)
CREATE SEQUENCE foo.x

-- Test 82: statement (line 387)
SET DATABASE = bar

-- Test 83: query (line 390)
SELECT nextval('foo.x')

-- Test 84: query (line 395)
SELECT nextval('other_db.other_db_test')

-- Test 85: statement (line 402)
SET DATABASE = test

-- Test 86: statement (line 405)
CREATE SEQUENCE setval_test

-- Test 87: query (line 408)
SELECT nextval('setval_test')

-- Test 88: query (line 413)
SELECT nextval('setval_test')

-- Test 89: query (line 418)
SELECT setval('setval_test', 10, false)

-- Test 90: query (line 425)
SELECT currval('setval_test')

-- Test 91: query (line 430)
SELECT lastval()

-- Test 92: query (line 435)
SELECT nextval('setval_test')

-- Test 93: query (line 440)
SELECT currval('setval_test')

-- Test 94: query (line 445)
SELECT lastval()

-- Test 95: query (line 453)
SELECT setval($setval_test_id::regclass, 20, true)

-- Test 96: query (line 459)
SELECT currval($setval_test_id::regclass)

-- Test 97: query (line 464)
SELECT lastval()

-- Test 98: query (line 469)
SELECT nextval($setval_test_id::regclass)

-- Test 99: statement (line 476)
CREATE SEQUENCE setval_bounds_test MINVALUE 5 MAXVALUE 10

-- Test 100: query (line 479)
SELECT nextval('setval_bounds_test')

-- Test 101: statement (line 484)
SELECT setval('setval_bounds_test', 11)

-- Test 102: statement (line 487)
SELECT setval('setval_bounds_test', 0)

-- Test 103: statement (line 492)
SELECT nextval('nonexistent_seq')

-- Test 104: statement (line 497)
CREATE SEQUENCE setval_is_called_test

-- Test 105: query (line 500)
SELECT setval('setval_is_called_test', 10, false)

-- Test 106: query (line 505)
SELECT nextval('setval_is_called_test')

-- Test 107: query (line 510)
SELECT nextval('setval_is_called_test')

-- Test 108: query (line 515)
SELECT setval('setval_is_called_test', 20, true)

-- Test 109: query (line 520)
SELECT nextval('setval_is_called_test')

-- Test 110: query (line 525)
SELECT nextval('setval_is_called_test')

-- Test 111: query (line 533)
SELECT setval($setval_is_called_test_id::regclass, 30, false)

-- Test 112: query (line 538)
SELECT nextval($setval_is_called_test_id::regclass)

-- Test 113: query (line 543)
SELECT nextval($setval_is_called_test_id::regclass)

-- Test 114: query (line 548)
SELECT setval($setval_is_called_test_id::regclass, 30, true)

-- Test 115: query (line 553)
SELECT nextval($setval_is_called_test_id::regclass)

-- Test 116: query (line 558)
SELECT nextval($setval_is_called_test_id::regclass)

-- Test 117: statement (line 565)
CREATE SEQUENCE setval_minval_test MINVALUE 10

-- Test 118: query (line 568)
SELECT nextval('setval_minval_test')

-- Test 119: query (line 573)
SELECT nextval('setval_minval_test')

-- Test 120: query (line 578)
SELECT setval('setval_minval_test', 10, false)

-- Test 121: query (line 583)
SELECT nextval('setval_minval_test')

-- Test 122: query (line 588)
SELECT setval('setval_minval_test', 10, true)

-- Test 123: query (line 593)
SELECT nextval('setval_minval_test')

-- Test 124: statement (line 600)
CREATE SEQUENCE limit_test MAXVALUE 10 START WITH 9

-- Test 125: query (line 603)
SELECT nextval('limit_test')

-- Test 126: query (line 608)
SELECT nextval('limit_test')

-- Test 127: statement (line 613)
SELECT nextval('limit_test')

let $limit_test_id
SELECT 'limit_test'::regclass::int

-- Test 128: statement (line 619)
SELECT nextval($limit_test_id::regclass)

-- Test 129: query (line 622)
SELECT currval('limit_test')

-- Test 130: statement (line 627)
CREATE SEQUENCE downward_limit_test INCREMENT BY -1 MINVALUE -10 START WITH -10

-- Test 131: query (line 630)
SELECT nextval('downward_limit_test')

-- Test 132: statement (line 635)
SELECT nextval('downward_limit_test')

-- Test 133: statement (line 640)
CREATE SEQUENCE overflow_test START WITH 9223372036854775807

-- Test 134: query (line 643)
SELECT nextval('overflow_test')

-- Test 135: statement (line 648)
SELECT nextval('overflow_test')

-- Test 136: statement (line 651)
CREATE SEQUENCE underflow_test MINVALUE -9223372036854775808 START WITH -9223372036854775808 INCREMENT -1

-- Test 137: query (line 654)
SELECT nextval('underflow_test')

-- Test 138: statement (line 659)
SELECT nextval('underflow_test')

-- Test 139: statement (line 666)
CREATE SEQUENCE blog_posts_id_seq

-- Test 140: statement (line 669)
CREATE TABLE blog_posts (id INT PRIMARY KEY DEFAULT nextval('blog_posts_id_seq'), title text)

-- Test 141: statement (line 672)
INSERT INTO blog_posts (title) values ('foo')

-- Test 142: statement (line 675)
INSERT INTO blog_posts (title) values ('bar')

-- Test 143: query (line 678)
SELECT id FROM blog_posts ORDER BY id

-- Test 144: statement (line 689)
BEGIN

-- Test 145: statement (line 692)
INSERT INTO blog_posts (title) VALUES ('par_test_1') RETURNING NOTHING

-- Test 146: statement (line 695)
INSERT INTO blog_posts (title) VALUES ('par_test_2') RETURNING NOTHING

-- Test 147: statement (line 698)
INSERT INTO blog_posts (title) VALUES ('par_test_3') RETURNING NOTHING

-- Test 148: query (line 701)
SELECT lastval()

-- Test 149: statement (line 706)
COMMIT

-- Test 150: statement (line 713)
CREATE SEQUENCE txn_test_seq;

-- Test 151: statement (line 716)
CREATE TABLE txn_test (id INT PRIMARY KEY DEFAULT nextval('txn_test_seq'), something text)

-- Test 152: statement (line 719)
INSERT INTO txn_test (something) VALUES ('foo')

-- Test 153: statement (line 722)
BEGIN

-- Test 154: statement (line 725)
INSERT INTO txn_test (something) VALUES ('bar')

-- Test 155: statement (line 728)
ROLLBACK

-- Test 156: statement (line 731)
INSERT INTO txn_test (something) VALUES ('baz')

-- Test 157: query (line 734)
SELECT * FROM txn_test

-- Test 158: statement (line 742)
CREATE SEQUENCE drop_prevention_test

-- Test 159: statement (line 745)
CREATE TABLE drop_prevention_test_tbl (id INT PRIMARY KEY DEFAULT nextval('drop_prevention_test'))

-- Test 160: statement (line 748)
DROP SEQUENCE drop_prevention_test

-- Test 161: statement (line 753)
CREATE TABLE seq_using_table (id INT PRIMARY KEY DEFAULT nxtvl('foo'))

-- Test 162: statement (line 758)
CREATE SEQUENCE drop_col_test_seq

-- Test 163: statement (line 761)
CREATE TABLE drop_col_test_tbl (id INT PRIMARY KEY, foo INT DEFAULT nextval('drop_col_test_seq'))

-- Test 164: statement (line 764)
ALTER TABLE drop_col_test_tbl DROP COLUMN foo

-- Test 165: statement (line 767)
DROP SEQUENCE drop_col_test_seq

-- Test 166: statement (line 772)
CREATE TABLE add_col_test_tbl (id INT PRIMARY KEY)

-- Test 167: statement (line 775)
CREATE SEQUENCE add_col_test_seq

-- Test 168: statement (line 778)
ALTER TABLE add_col_test_tbl ADD COLUMN foo INT DEFAULT nextval('add_col_test_seq')

-- Test 169: statement (line 781)
DROP SEQUENCE add_col_test_seq

-- Test 170: statement (line 786)
CREATE TABLE set_default_test_tbl (id INT PRIMARY KEY, foo INT)

-- Test 171: statement (line 789)
CREATE SEQUENCE set_default_test_seq

-- Test 172: statement (line 792)
ALTER TABLE set_default_test_tbl ALTER COLUMN foo SET DEFAULT nextval('set_default_test_seq')

-- Test 173: statement (line 795)
DROP SEQUENCE set_default_test_seq

-- Test 174: statement (line 801)
CREATE SEQUENCE initial_seq

-- Test 175: statement (line 804)
CREATE SEQUENCE changed_to_seq

-- Test 176: statement (line 807)
CREATE TABLE set_default_test (id INT PRIMARY KEY DEFAULT nextval('initial_seq'))

-- Test 177: statement (line 810)
DROP SEQUENCE initial_seq

-- Test 178: statement (line 813)
ALTER TABLE set_default_test ALTER COLUMN id SET DEFAULT nextval('changed_to_seq')

-- Test 179: statement (line 816)
DROP SEQUENCE initial_seq

-- Test 180: statement (line 819)
DROP SEQUENCE changed_to_seq

-- Test 181: statement (line 824)
CREATE SEQUENCE drop_default_test_seq

-- Test 182: statement (line 827)
CREATE TABLE drop_default_test_tbl (id INT PRIMARY KEY DEFAULT nextval('drop_default_test_seq'))

-- Test 183: statement (line 830)
ALTER TABLE drop_default_test_tbl ALTER COLUMN id DROP DEFAULT

-- Test 184: statement (line 833)
DROP SEQUENCE drop_default_test_seq

-- Test 185: statement (line 838)
CREATE SEQUENCE drop_default_test_seq_2

-- Test 186: statement (line 841)
ALTER TABLE drop_default_test_tbl ALTER COLUMN id SET DEFAULT nextval('drop_default_test_seq_2')

-- Test 187: statement (line 846)
CREATE SEQUENCE multiple_seq_test1

-- Test 188: statement (line 849)
CREATE SEQUENCE multiple_seq_test2

-- Test 189: statement (line 852)
CREATE TABLE multiple_seq_test_tbl (
  id INT PRIMARY KEY DEFAULT nextval('multiple_seq_test1') + nextval('multiple_seq_test2')
)

-- Test 190: statement (line 857)
DROP SEQUENCE multiple_seq_test1

-- Test 191: statement (line 860)
DROP SEQUENCE multiple_seq_test2

-- Test 192: statement (line 864)
ALTER TABLE multiple_seq_test_tbl ALTER COLUMN id SET DEFAULT unique_rowid()

-- Test 193: statement (line 867)
DROP SEQUENCE multiple_seq_test1

-- Test 194: statement (line 870)
DROP SEQUENCE multiple_seq_test2

-- Test 195: statement (line 875)
CREATE SEQUENCE multiple_usage_test_1

-- Test 196: statement (line 878)
CREATE SEQUENCE multiple_usage_test_2

-- Test 197: statement (line 881)
CREATE TABLE multiple_usage_test_tbl (
  id INT PRIMARY KEY DEFAULT nextval('multiple_usage_test_1'),
  other_id INT DEFAULT nextval('multiple_usage_test_2')
)

-- Test 198: statement (line 889)
DROP SEQUENCE multiple_usage_test_1

-- Test 199: statement (line 892)
ALTER TABLE multiple_usage_test_tbl ALTER COLUMN id DROP DEFAULT

-- Test 200: statement (line 895)
DROP SEQUENCE multiple_usage_test_1

-- Test 201: statement (line 900)
DROP SEQUENCE multiple_usage_test_2

-- Test 202: statement (line 903)
ALTER TABLE multiple_usage_test_tbl ALTER COLUMN other_id DROP DEFAULT

-- Test 203: statement (line 906)
DROP SEQUENCE multiple_usage_test_2

-- Test 204: statement (line 911)
CREATE SEQUENCE drop_test

-- Test 205: statement (line 914)
CREATE TABLE drop_test_tbl (id INT PRIMARY KEY DEFAULT nextval('drop_test'))

-- Test 206: statement (line 917)
DROP SEQUENCE drop_test

-- Test 207: statement (line 920)
DROP TABLE drop_test_tbl

-- Test 208: statement (line 923)
DROP SEQUENCE drop_test

-- Test 209: statement (line 931)
CREATE SEQUENCE priv_test

-- Test 210: statement (line 934)
CREATE DATABASE another_db;

-- Test 211: statement (line 937)
CREATE SCHEMA another_db.seq_schema_allow;
CREATE SCHEMA another_db.seq_schema_deny;

-- Test 212: statement (line 941)
GRANT CREATE ON SCHEMA another_db.seq_schema_allow TO testuser

user testuser

-- Test 213: statement (line 946)
CREATE SEQUENCE another_db.seq_schema_allow.seq;

-- Test 214: statement (line 949)
CREATE SEQUENCE another_db.seq_schema_deny.seq;

-- Test 215: statement (line 952)
SELECT * FROM priv_test

-- Test 216: statement (line 955)
SELECT nextval('priv_test')

-- Test 217: statement (line 958)
SELECT setval('priv_test', 5)

user root

-- Test 218: query (line 964)
SELECT last_value FROM priv_test

-- Test 219: statement (line 969)
GRANT UPDATE, SELECT ON priv_test TO testuser

user testuser

-- Test 220: query (line 976)
SELECT nextval('priv_test')

-- Test 221: statement (line 981)
SELECT setval('priv_test', 5, true)

-- Test 222: query (line 984)
SELECT last_value FROM priv_test

-- Test 223: statement (line 993)
CREATE SEQUENCE sv VIRTUAL

-- Test 224: query (line 996)
SELECT create_statement FROM [SHOW CREATE SEQUENCE sv]

-- Test 225: statement (line 1001)
CREATE TABLE svals(x INT)

-- Test 226: statement (line 1004)
BEGIN;
  INSERT INTO svals VALUES(nextval('sv'));
  INSERT INTO svals VALUES(lastval());
  INSERT INTO svals VALUES(currval('sv'));
END

-- Test 227: query (line 1012)
SELECT count(DISTINCT x) FROM svals

-- Test 228: query (line 1024)
SELECT message FROM [SHOW KV TRACE FOR SESSION]

-- Test 229: statement (line 1029)
DROP SEQUENCE sv

-- Test 230: statement (line 1035)
SET statement_timeout = 10

-- Test 231: statement (line 1038)
select * from generate_series(1,10000000) where generate_series = 0;

-- Test 232: statement (line 1042)
SET statement_timeout = 0

-- Test 233: statement (line 1048)
SET sql_safe_updates = false

-- Test 234: statement (line 1051)
CREATE SEQUENCE seq;

-- Test 235: statement (line 1054)
CREATE TABLE abc(a INT DEFAULT nextval('seq'), b INT default nextval('seq'), c int)

-- Test 236: statement (line 1057)
DROP SEQUENCE seq;

-- Test 237: statement (line 1060)
ALTER TABLE abc DROP COLUMN b;

-- Test 238: statement (line 1063)
DROP SEQUENCE seq;

-- Test 239: statement (line 1066)
ALTER TABLE abc DROP COLUMN a;

-- Test 240: statement (line 1069)
DROP SEQUENCE seq;

-- Test 241: statement (line 1076)
CREATE TABLE owner(owner_col INT)

-- Test 242: statement (line 1079)
CREATE SEQUENCE owned_seq OWNED BY owner.owner_col

-- Test 243: query (line 1082)
SELECT seqclass.relname AS sequence_name,
       depclass.relname AS table_name,
       attrib.attname   as column_name
FROM   pg_class AS seqclass
       JOIN pg_depend AS dep
         ON seqclass.oid = dep.objid
       JOIN pg_class AS depclass
         ON dep.refobjid = depclass.oid
       JOIN pg_attribute AS attrib
         ON attrib.attnum = dep.refobjsubid
              AND attrib.attrelid = dep.refobjid
WHERE seqclass.relkind = 'S';

-- Test 244: statement (line 1100)
ALTER SEQUENCE owned_seq OWNED BY NONE

-- Test 245: statement (line 1103)
SELECT seqclass.relname AS sequence_name,
       depclass.relname AS table_name,
       attrib.attname   as column_name
FROM   pg_class AS seqclass
       JOIN pg_depend AS dep
         ON seqclass.oid = dep.objid
       JOIN pg_class AS depclass
         ON dep.refobjid = depclass.oid
       JOIN pg_attribute AS attrib
         ON attrib.attnum = dep.refobjsubid
              AND attrib.attrelid = dep.refobjid
WHERE seqclass.relkind = 'S';

-- Test 246: statement (line 1118)
DROP TABLE owner

-- Test 247: statement (line 1121)
DROP SEQUENCE owned_seq

-- Test 248: statement (line 1126)
CREATE SEQUENCE owned_seq;

-- Test 249: statement (line 1129)
CREATE TABLE a(a INT DEFAULT nextval('owned_seq'));

-- Test 250: statement (line 1132)
ALTER SEQUENCE owned_seq OWNED BY a.a;

-- Test 251: statement (line 1135)
DROP TABLE a;

-- Test 252: statement (line 1138)
DROP SEQUENCE owned_seq;

-- Test 253: statement (line 1145)
CREATE SEQUENCE owned_seq;

-- Test 254: statement (line 1148)
CREATE TABLE ab(a INT DEFAULT nextval('owned_seq'), b INT DEFAULT nextval('owned_seq'));

-- Test 255: statement (line 1151)
ALTER SEQUENCE owned_seq OWNED BY ab.a;

skipif config local-legacy-schema-changer

-- Test 256: statement (line 1155)
ALTER TABLE ab DROP COLUMN a;

onlyif config local-legacy-schema-changer

-- Test 257: statement (line 1159)
ALTER TABLE ab DROP COLUMN a;

-- Test 258: statement (line 1162)
DROP TABLE ab

-- Test 259: statement (line 1165)
DROP SEQUENCE owned_seq;

-- Test 260: statement (line 1171)
CREATE TABLE a(a INT);

-- Test 261: statement (line 1174)
CREATE TABLE b(b INT);

-- Test 262: statement (line 1177)
CREATE SEQUENCE seq OWNED BY a.a;

-- Test 263: statement (line 1180)
ALTER SEQUENCE seq OWNED BY a.a;

-- Test 264: statement (line 1183)
ALTER SEQUENCE seq OWNED BY b.b;

-- Test 265: statement (line 1186)
DROP TABLE a;

-- Test 266: statement (line 1189)
ALTER SEQUENCE seq OWNED BY NONE;

-- Test 267: statement (line 1192)
DROP TABLE b;

-- Test 268: statement (line 1195)
DROP SEQUENCE seq;

-- Test 269: statement (line 1202)
CREATE TABLE a(a INT);

-- Test 270: statement (line 1205)
CREATE SEQUENCE seq OWNED BY a.a;

-- Test 271: statement (line 1208)
CREATE TABLE b(b INT DEFAULT nextval('seq'));

-- Test 272: statement (line 1211)
DROP TABLE a

skipif config local-legacy-schema-changer

-- Test 273: statement (line 1215)
ALTER TABLE a DROP COLUMN a;

onlyif config local-legacy-schema-changer

-- Test 274: statement (line 1219)
ALTER TABLE a DROP COLUMN a;

-- Test 275: statement (line 1222)
DROP TABLE b;

-- Test 276: statement (line 1225)
DROP TABLE a;

-- Test 277: statement (line 1231)
CREATE SEQUENCE currval_dep_test;
CREATE TABLE c(a INT DEFAULT(currval('currval_dep_test')))

-- Test 278: statement (line 1235)
DROP SEQUENCE currval_dep_test

-- Test 279: statement (line 1240)
CREATE TABLE t_50649(a INT PRIMARY KEY)

-- Test 280: statement (line 1243)
CREATE SEQUENCE seq_50649 OWNED BY t_50649.a

-- Test 281: statement (line 1246)
DROP SEQUENCE seq_50649

-- Test 282: statement (line 1249)
DROP TABLE t_50649

-- Test 283: statement (line 1254)
CREATE DATABASE db_50712

-- Test 284: statement (line 1257)
CREATE TABLE db_50712.t_50712(a INT PRIMARY KEY)

-- Test 285: statement (line 1260)
CREATE SEQUENCE db_50712.seq_50712 OWNED BY db_50712.t_50712.a

-- Test 286: statement (line 1263)
DROP DATABASE db_50712 CASCADE

-- Test 287: statement (line 1269)
CREATE DATABASE db_50712

-- Test 288: statement (line 1272)
CREATE TABLE db_50712.a_50712(a INT PRIMARY KEY)

-- Test 289: statement (line 1275)
CREATE SEQUENCE db_50712.seq_50712 OWNED BY db_50712.a_50712.a

-- Test 290: statement (line 1278)
DROP DATABASE db_50712 CASCADE

-- Test 291: statement (line 1282)
CREATE DATABASE db_50712

-- Test 292: statement (line 1285)
SET DATABASE = db_50712

-- Test 293: statement (line 1288)
CREATE TABLE a_50712(a INT PRIMARY KEY)

-- Test 294: statement (line 1291)
CREATE SEQUENCE seq_50712 OWNED BY a_50712.a

-- Test 295: statement (line 1294)
DROP DATABASE db_50712

-- Test 296: statement (line 1297)
SET DATABASE = test

-- Test 297: statement (line 1304)
CREATE DATABASE db_50712

-- Test 298: statement (line 1307)
CREATE TABLE db_50712.t_50712(a INT PRIMARY KEY)

-- Test 299: statement (line 1310)
CREATE SEQUENCE seq_50712 OWNED BY db_50712.t_50712.a

-- Test 300: statement (line 1313)
DROP DATABASE db_50712 CASCADE

-- Test 301: query (line 1316)
SELECT count(*) FROM system.namespace WHERE name LIKE 'seq_50712'

-- Test 302: statement (line 1325)
CREATE DATABASE db_50712

-- Test 303: statement (line 1328)
CREATE TABLE t_50712(a INT PRIMARY KEY)

-- Test 304: statement (line 1331)
CREATE SEQUENCE db_50712.seq_50712 OWNED BY t_50712.a

-- Test 305: statement (line 1334)
DROP DATABASE db_50712 CASCADE

-- Test 306: statement (line 1337)
DROP TABLE t_50712

-- Test 307: statement (line 1347)
CREATE TABLE t_50711(a int, b int)

-- Test 308: statement (line 1350)
CREATE SEQUENCE seq_50711 owned by t_50711.a

-- Test 309: statement (line 1353)
ALTER SEQUENCE seq_50711 owned by t_50711.b

-- Test 310: statement (line 1356)
ALTER SEQUENCE seq_50711 owned by t_50711.a

-- Test 311: statement (line 1359)
DROP SEQUENCE seq_50711

-- Test 312: statement (line 1362)
DROP TABLE t_50711

-- Test 313: statement (line 1365)
CREATE TABLE t_50711(a int, b int)

-- Test 314: statement (line 1368)
CREATE SEQUENCE seq_50711 owned by t_50711.a

-- Test 315: statement (line 1371)
ALTER SEQUENCE seq_50711 owned by t_50711.b

-- Test 316: statement (line 1374)
ALTER SEQUENCE seq_50711 owned by t_50711.a

-- Test 317: statement (line 1377)
DROP SEQUENCE seq_50711

-- Test 318: statement (line 1380)
ALTER TABLE t_50711 DROP COLUMN a

-- Test 319: statement (line 1383)
ALTER TABLE t_50711 DROP COLUMN b

-- Test 320: statement (line 1388)
SET CLUSTER SETTING sql.cross_db_sequence_owners.enabled = FALSE

-- Test 321: statement (line 1391)
CREATE DATABASE db1

-- Test 322: statement (line 1394)
CREATE DATABASE db2

-- Test 323: statement (line 1397)
CREATE TABLE db1.t (a INT)

-- Test 324: statement (line 1400)
CREATE SEQUENCE db1.seq OWNED BY db1.t.a

-- Test 325: statement (line 1403)
CREATE SEQUENCE db2.seq OWNED BY db1.t.a

-- Test 326: statement (line 1406)
CREATE TABLE db2.t (a INT)

-- Test 327: statement (line 1409)
CREATE SEQUENCE db2.seq OWNED BY db2.t.a

-- Test 328: statement (line 1412)
ALTER SEQUENCE db2.seq OWNED BY db1.t.a

-- Test 329: statement (line 1415)
SET CLUSTER SETTING sql.cross_db_sequence_owners.enabled = TRUE

-- Test 330: statement (line 1418)
ALTER SEQUENCE db2.seq OWNED BY db1.t.a

-- Test 331: statement (line 1421)
CREATE SEQUENCE db2.seq2 OWNED BY db1.t.a

-- Test 332: statement (line 1424)
ALTER SEQUENCE db2.seq2 OWNED BY doesntexist

-- Test 333: statement (line 1431)
CREATE TABLE t (i SERIAL PRIMARY KEY)

let $t_id
SELECT 't'::regclass::int

-- Test 334: statement (line 1437)
SELECT nextval($t_id::regclass)

-- Test 335: statement (line 1440)
SELECT setval($t_id::regclass, 30, false)

-- Test 336: statement (line 1443)
SELECT currval($t_id::regclass)

-- Test 337: statement (line 1446)
CREATE VIEW v AS (SELECT i FROM t)

let $v_id
SELECT 'v'::regclass::int

-- Test 338: statement (line 1452)
SELECT nextval($v_id::regclass)

-- Test 339: statement (line 1455)
SELECT setval($v_id::regclass, 30, false)

-- Test 340: statement (line 1458)
SELECT currval($v_id::regclass)

-- Test 341: statement (line 1461)
CREATE SCHEMA sc

let $sc_id
SELECT id FROM system.namespace WHERE name='sc'

-- Test 342: statement (line 1467)
SELECT nextval($sc_id::regclass)

-- Test 343: statement (line 1470)
SELECT setval($sc_id::regclass, 30, false)

-- Test 344: statement (line 1473)
SELECT currval($sc_id::regclass)

-- Test 345: statement (line 1476)
CREATE DATABASE db

let $db_id
SELECT id FROM system.namespace WHERE name='db'

-- Test 346: statement (line 1482)
SELECT nextval($db_id::regclass)

-- Test 347: statement (line 1485)
SELECT setval($db_id::regclass, 30, false)

-- Test 348: statement (line 1488)
SELECT currval($db_id::regclass)

-- Test 349: statement (line 1491)
CREATE TYPE e AS ENUM ('foo', 'bar')

let $e_id
SELECT id FROM system.namespace WHERE name='e'

-- Test 350: statement (line 1497)
SELECT nextval($e_id::regclass)

-- Test 351: statement (line 1500)
SELECT setval($e_id::regclass, 30, false)

-- Test 352: statement (line 1503)
SELECT currval($e_id::regclass)

-- Test 353: statement (line 1506)
SELECT nextval(12345::regclass) # Bogus ID

-- Test 354: statement (line 1509)
SELECT setval(12345::regclass, 30, false) # Bogus ID

-- Test 355: statement (line 1512)
SELECT currval(12345::regclass) # Bogus ID

-- Test 356: statement (line 1517)
CREATE SEQUENCE cache_test CACHE -1

-- Test 357: statement (line 1520)
CREATE SEQUENCE cache_test CACHE 0

-- Test 358: statement (line 1523)
CREATE SEQUENCE cache_test CACHE 10 INCREMENT 1

-- Test 359: query (line 1526)
SHOW CREATE SEQUENCE cache_test

-- Test 360: query (line 1534)
SELECT nextval('cache_test')

-- Test 361: query (line 1540)
SELECT lastval()

-- Test 362: query (line 1545)
SELECT currval('cache_test')

-- Test 363: query (line 1550)
SELECT last_value FROM cache_test

-- Test 364: statement (line 1555)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- Test 365: statement (line 1558)
SET LOCAL autocommit_before_ddl=off;

-- Test 366: statement (line 1561)
ALTER SEQUENCE cache_test INCREMENT 5

-- Test 367: query (line 1565)
SELECT nextval('cache_test')

-- Test 368: statement (line 1571)
ABORT

-- Test 369: query (line 1575)
SELECT last_value FROM cache_test

-- Test 370: query (line 1581)
SELECT nextval('cache_test')

-- Test 371: query (line 1586)
SELECT last_value FROM cache_test

-- Test 372: statement (line 1591)
DROP SEQUENCE cache_test

-- Test 373: statement (line 1596)
CREATE SEQUENCE cached_upper_bound_test MAXVALUE 4 START WITH 2 CACHE 5 INCREMENT BY 2;

-- Test 374: query (line 1603)
SELECT nextval('cached_upper_bound_test');

-- Test 375: query (line 1608)
SELECT nextval('cached_upper_bound_test');

-- Test 376: query (line 1613)
SELECT last_value FROM cached_upper_bound_test;

-- Test 377: statement (line 1622)
SELECT nextval('cached_upper_bound_test');

-- Test 378: statement (line 1625)
SELECT nextval('cached_upper_bound_test');

-- Test 379: query (line 1628)
SELECT lastval();

-- Test 380: query (line 1633)
SELECT currval('cached_upper_bound_test');

-- Test 381: query (line 1638)
SELECT last_value FROM cached_upper_bound_test;

-- Test 382: statement (line 1646)
ALTER SEQUENCE cached_upper_bound_test MAXVALUE 100;

-- Test 383: query (line 1649)
SELECT last_value FROM cached_upper_bound_test;

-- Test 384: query (line 1657)
SELECT nextval('cached_upper_bound_test');

-- Test 385: query (line 1662)
SELECT last_value FROM cached_upper_bound_test;

-- Test 386: query (line 1667)
SELECT lastval();

-- Test 387: query (line 1672)
SELECT currval('cached_upper_bound_test');

-- Test 388: statement (line 1677)
drop sequence cached_upper_bound_test;

-- Test 389: statement (line 1683)
CREATE SEQUENCE cached_lower_bound_test MINVALUE -4 START WITH -2 CACHE 5 INCREMENT BY -2;

-- Test 390: query (line 1686)
SELECT nextval('cached_lower_bound_test');

-- Test 391: query (line 1692)
SELECT nextval('cached_lower_bound_test');

-- Test 392: query (line 1697)
SELECT last_value FROM cached_lower_bound_test;

-- Test 393: statement (line 1702)
SELECT nextval('cached_lower_bound_test');

-- Test 394: statement (line 1705)
SELECT nextval('cached_lower_bound_test');

-- Test 395: query (line 1708)
SELECT last_value FROM cached_lower_bound_test;

-- Test 396: statement (line 1713)
ALTER SEQUENCE cached_lower_bound_test MINVALUE -100;

-- Test 397: query (line 1716)
SELECT last_value FROM cached_lower_bound_test;

-- Test 398: query (line 1721)
SELECT nextval('cached_lower_bound_test');

-- Test 399: query (line 1726)
SELECT last_value FROM cached_lower_bound_test;

-- Test 400: statement (line 1731)
DROP SEQUENCE cached_lower_bound_test;

-- Test 401: statement (line 1737)
CREATE SEQUENCE cached_lower_bound_test_2 MINVALUE -2 MAXVALUE 2 START WITH 2 CACHE 5 INCREMENT BY -2;

-- Test 402: query (line 1740)
SELECT nextval('cached_lower_bound_test_2');

-- Test 403: query (line 1745)
SELECT nextval('cached_lower_bound_test_2');

-- Test 404: query (line 1750)
SELECT nextval('cached_lower_bound_test_2');

-- Test 405: query (line 1755)
SELECT last_value FROM cached_lower_bound_test_2;

-- Test 406: statement (line 1760)
SELECT nextval('cached_lower_bound_test_2');

-- Test 407: statement (line 1763)
SELECT nextval('cached_lower_bound_test_2');

-- Test 408: query (line 1766)
SELECT last_value FROM cached_lower_bound_test_2;

-- Test 409: statement (line 1771)
ALTER SEQUENCE cached_lower_bound_test_2 MINVALUE -100;

-- Test 410: query (line 1774)
SELECT last_value FROM cached_lower_bound_test_2;

-- Test 411: query (line 1779)
SELECT nextval('cached_lower_bound_test_2');

-- Test 412: query (line 1784)
SELECT last_value FROM cached_lower_bound_test_2;

-- Test 413: statement (line 1789)
DROP SEQUENCE cached_lower_bound_test_2;

-- Test 414: statement (line 1795)
CREATE DATABASE db3;

-- Test 415: statement (line 1798)
CREATE SEQUENCE db3.s;

-- Test 416: statement (line 1801)
CREATE TABLE tDb3Ref (i INT PRIMARY KEY DEFAULT (nextval('db3.s')));

-- Test 417: query (line 1804)
SELECT * FROM "".crdb_internal.cross_db_references ORDER BY 3

-- Test 418: statement (line 1812)
SELECT currval('')

-- Test 419: statement (line 1815)
SET CLUSTER SETTING sql.cross_db_sequence_references.enabled = FALSE

-- Test 420: statement (line 1819)
CREATE DATABASE db4;

-- Test 421: statement (line 1822)
CREATE SEQUENCE db4.s;

-- Test 422: statement (line 1825)
CREATE TABLE tDb4Ref (i INT PRIMARY KEY DEFAULT (nextval('db4.s')));

-- Test 423: statement (line 1833)
CREATE SEQUENCE seq71135 PER SESSION CACHE 100

-- Test 424: query (line 1836)
SELECT nextval('seq71135')

-- Test 425: query (line 1841)
SELECT setval('seq71135', 200, true)

-- Test 426: query (line 1846)
SELECT lastval()

-- Test 427: query (line 1851)
SELECT currval('seq71135')

-- Test 428: query (line 1856)
SELECT nextval('seq71135')

-- Test 429: query (line 1862)
SELECT setval('seq71135'::regclass::oid, 500)

-- Test 430: query (line 1867)
SELECT lastval()

-- Test 431: query (line 1872)
SELECT currval('seq71135')

-- Test 432: query (line 1877)
SELECT nextval('seq71135')

-- Test 433: statement (line 1887)
CREATE SEQUENCE seq_txn

-- Test 434: statement (line 1893)
BEGIN

-- Test 435: query (line 1896)
SELECT setval('seq_txn', 600, true)

-- Test 436: statement (line 1901)
ROLLBACK

-- Test 437: query (line 1904)
SELECT nextval('seq_txn')

-- Test 438: statement (line 1909)
BEGIN

-- Test 439: query (line 1912)
SELECT setval('seq_txn', 610, true)

-- Test 440: query (line 1917)
SELECT nextval('seq_txn')

-- Test 441: statement (line 1922)
ROLLBACK

-- Test 442: query (line 1925)
SELECT nextval('seq_txn')

-- Test 443: statement (line 1931)
CREATE SEQUENCE s63147

-- Test 444: statement (line 1934)
CREATE TABLE t63147 (a INT PRIMARY KEY)

-- Test 445: statement (line 1937)
INSERT INTO t63147 (a) VALUES (1), (2)

-- Test 446: statement (line 1940)
ALTER TABLE t63147 ADD b INT DEFAULT nextval('s63147')

-- Test 447: query (line 1943)
SELECT count(*) FROM crdb_internal.invalid_objects;

-- Test 448: statement (line 1948)
DROP TABLE t63147

-- Test 449: statement (line 1951)
CREATE TABLE t63147 (a INT PRIMARY KEY, b INT DEFAULT (nextval('s63147')))

-- Test 450: statement (line 1954)
CREATE VIEW v63147 AS SELECT nextval('s63147') FROM t63147

-- Test 451: query (line 1957)
SELECT count(*) FROM crdb_internal.invalid_objects;

-- Test 452: statement (line 1962)
ALTER TABLE t63147 DROP COLUMN b CASCADE

-- Test 453: query (line 1965)
SELECT count(*) FROM crdb_internal.invalid_objects;

-- Test 454: statement (line 1971)
CREATE SEQUENCE seqas_0 AS smallint

-- Test 455: statement (line 1974)
CREATE SEQUENCE seqas_1 AS int4

-- Test 456: statement (line 1977)
CREATE SEQUENCE seqas_2 AS bigint

-- Test 457: statement (line 1980)
CREATE SEQUENCE public.seqas_3 AS int2 START WITH -4 INCREMENT BY -3

-- Test 458: query (line 1983)
SHOW CREATE SEQUENCE seqas_3

-- Test 459: statement (line 1989)
CREATE SEQUENCE seqas_4 AS integer

-- Test 460: query (line 1992)
SHOW CREATE SEQUENCE seqas_4

-- Test 461: statement (line 1998)
CREATE SEQUENCE seqas_5 AS int8

-- Test 462: statement (line 2001)
CREATE SEQUENCE public.seqas_6 AS smallint MAXVALUE 2000000

-- Test 463: statement (line 2004)
CREATE SEQUENCE public.seqas_7 AS smallint MINVALUE -2000000

-- Test 464: statement (line 2007)
CREATE SEQUENCE seqas_8 as int4 INCREMENT BY -1 MINVALUE -9999999999999999;

-- Test 465: statement (line 2010)
SET default_int_size=4

-- Test 466: statement (line 2013)
CREATE SEQUENCE seqas_9 AS integer

-- Test 467: query (line 2016)
SHOW CREATE SEQUENCE seqas_9

-- Test 468: statement (line 2022)
ALTER SEQUENCE seqas_9 AS smallint

-- Test 469: query (line 2025)
SHOW CREATE SEQUENCE seqas_9

-- Test 470: statement (line 2031)
CREATE SEQUENCE seqas_10
AS integer
START WITH 1
INCREMENT BY 1
MAXVALUE 9001
CACHE 1

-- Test 471: query (line 2039)
SHOW CREATE SEQUENCE seqas_10

-- Test 472: statement (line 2045)
CREATE SEQUENCE seqas_11 AS integer
				START WITH 2
				INCREMENT BY 1
				MINVALUE 0
				MAXVALUE 234567
				CACHE 1

-- Test 473: query (line 2053)
SELECT create_statement FROM [SHOW CREATE SEQUENCE seqas_11]

-- Test 474: statement (line 2058)
CREATE SEQUENCE seqas_12 AS smallint
  START WITH -4
  INCREMENT BY -3

-- Test 475: query (line 2063)
SELECT create_statement FROM [SHOW CREATE SEQUENCE seqas_12]

-- Test 476: statement (line 2068)
CREATE SEQUENCE seqas_13
  AS integer
  START WITH 1
  INCREMENT BY 1
  MAXVALUE 9001
  CACHE 1

-- Test 477: query (line 2076)
SELECT create_statement FROM [SHOW CREATE SEQUENCE seqas_13]

-- Test 478: statement (line 2081)
CREATE SEQUENCE seq_error AS smallint
  START WITH 45678
  INCREMENT BY 1

-- Test 479: statement (line 2093)
CREATE SEQUENCE seqas_error
  AS smallint
  START WITH 1
  INCREMENT BY 1
  MINVALUE -1000000
  CACHE 1

-- Test 480: statement (line 2101)
CREATE SEQUENCE seqas_error
  AS smallint
  START WITH 1
  INCREMENT BY 1
  MAXVALUE 123456
  CACHE 1

-- Test 481: statement (line 2116)
BEGIN

-- Test 482: statement (line 2119)
CREATE SEQUENCE nextval_txn_seq

-- Test 483: query (line 2122)
SELECT nextval('nextval_txn_seq')

-- Test 484: statement (line 2127)
END

-- Test 485: query (line 2130)
SELECT nextval('nextval_txn_seq')

-- Test 486: statement (line 2136)
BEGIN

-- Test 487: statement (line 2139)
CREATE SEQUENCE setval_txn_nextval_seq

-- Test 488: query (line 2142)
SELECT setval('setval_txn_nextval_seq', 2)

-- Test 489: statement (line 2147)
END

-- Test 490: query (line 2150)
SELECT nextval('setval_txn_nextval_seq')

-- Test 491: statement (line 2156)
BEGIN

-- Test 492: statement (line 2159)
CREATE SEQUENCE setval_nextval_txn_seq

-- Test 493: query (line 2162)
SELECT setval('setval_nextval_txn_seq', 2)

-- Test 494: query (line 2167)
SELECT nextval('setval_nextval_txn_seq')

-- Test 495: statement (line 2172)
END

-- Test 496: statement (line 2176)
BEGIN

-- Test 497: statement (line 2179)
CREATE SEQUENCE setval_txn_currval_seq

-- Test 498: query (line 2182)
SELECT setval('setval_txn_currval_seq', 1)

-- Test 499: statement (line 2187)
END

-- Test 500: query (line 2190)
SELECT currval('setval_txn_currval_seq')

-- Test 501: statement (line 2196)
BEGIN

-- Test 502: statement (line 2199)
CREATE SEQUENCE setval_currval_txn_seq

-- Test 503: query (line 2202)
SELECT setval('setval_currval_txn_seq', 1)

-- Test 504: query (line 2207)
SELECT currval('setval_currval_txn_seq')

-- Test 505: statement (line 2212)
END

-- Test 506: statement (line 2216)
BEGIN

-- Test 507: statement (line 2219)
CREATE SEQUENCE setval_txn_lastval_seq

-- Test 508: query (line 2222)
SELECT setval('setval_txn_lastval_seq', 101)

-- Test 509: statement (line 2227)
END

-- Test 510: query (line 2230)
SELECT lastval()

-- Test 511: statement (line 2236)
BEGIN

-- Test 512: statement (line 2239)
CREATE SEQUENCE setval_lastval_txn_seq

-- Test 513: query (line 2242)
SELECT setval('setval_lastval_txn_seq', 202)

-- Test 514: query (line 2247)
SELECT lastval()

-- Test 515: statement (line 2252)
END

-- Test 516: statement (line 2257)
CREATE SEQUENCE restart_seq START WITH 50 RESTART 100

-- Test 517: query (line 2260)
SELECT nextval('restart_seq')

-- Test 518: query (line 2265)
SELECT nextval('restart_seq')

-- Test 519: statement (line 2271)
ALTER SEQUENCE restart_seq RESTART

-- Test 520: query (line 2274)
SELECT nextval('restart_seq')

-- Test 521: statement (line 2280)
BEGIN

-- Test 522: statement (line 2283)
CREATE SEQUENCE restart_txn_seq RESTART 100

-- Test 523: query (line 2286)
SELECT nextval('restart_txn_seq')

-- Test 524: statement (line 2291)
END

-- Test 525: statement (line 2297)
CREATE SEQUENCE customer_seq_check_cache_and_bounds_1 INCREMENT  BY 3  MINVALUE 6 MAXVALUE 10

-- Test 526: query (line 2300)
SELECT nextval('customer_seq_check_cache_and_bounds_1')

-- Test 527: query (line 2305)
SELECT nextval('customer_seq_check_cache_and_bounds_1')

-- Test 528: statement (line 2310)
SELECT nextval('customer_seq_check_cache_and_bounds_1')

-- Test 529: statement (line 2314)
CREATE SEQUENCE customer_seq_check_cache_and_bounds_2 MINVALUE -2 MAXVALUE 2 START WITH 1 CACHE 5 INCREMENT BY -2

-- Test 530: query (line 2317)
SELECT nextval('customer_seq_check_cache_and_bounds_2')

-- Test 531: query (line 2322)
SELECT nextval('customer_seq_check_cache_and_bounds_2')

-- Test 532: statement (line 2327)
SELECT nextval('customer_seq_check_cache_and_bounds_2')

-- Test 533: statement (line 2331)
CREATE SEQUENCE customer_seq_check_cache_and_bounds_3 INCREMENT  BY 3  MINVALUE 6 MAXVALUE 12

-- Test 534: query (line 2334)
SELECT nextval('customer_seq_check_cache_and_bounds_3')

-- Test 535: query (line 2339)
SELECT nextval('customer_seq_check_cache_and_bounds_3')

-- Test 536: query (line 2344)
SELECT nextval('customer_seq_check_cache_and_bounds_3')

-- Test 537: statement (line 2349)
SELECT nextval('customer_seq_check_cache_and_bounds_3')

-- Test 538: statement (line 2354)
CREATE SEQUENCE seq_test_last_value START WITH 2 INCREMENT BY 3

-- Test 539: query (line 2357)
SELECT pg_sequence_last_value('seq_test_last_value'::regclass)

-- Test 540: query (line 2362)
SELECT nextval('seq_test_last_value')

-- Test 541: query (line 2367)
SELECT pg_sequence_last_value('seq_test_last_value'::regclass)

-- Test 542: query (line 2372)
SELECT nextval('seq_test_last_value')

-- Test 543: query (line 2377)
SELECT pg_sequence_last_value('seq_test_last_value'::regclass)

-- Test 544: statement (line 2382)
CREATE SEQUENCE seq_test_last_value_cached START WITH 1 INCREMENT BY 2 CACHE 5

-- Test 545: query (line 2385)
SELECT pg_sequence_last_value('seq_test_last_value_cached'::regclass)

-- Test 546: query (line 2390)
SELECT nextval('seq_test_last_value_cached')

-- Test 547: query (line 2396)
SELECT pg_sequence_last_value('seq_test_last_value_cached'::regclass)

-- Test 548: query (line 2401)
SELECT nextval('seq_test_last_value_cached')

-- Test 549: query (line 2407)
SELECT pg_sequence_last_value('seq_test_last_value_cached'::regclass)

-- Test 550: statement (line 2412)
SELECT pg_sequence_last_value(123456)

-- Test 551: statement (line 2415)
SELECT pg_sequence_last_value('multiple_seq_test_tbl'::regclass)

-- Test 552: statement (line 2424)
CREATE SEQUENCE TIMESTAMPTZ . PRIMARY . IS;

-- Test 553: statement (line 2427)
CREATE SEQUENCE TIMESTAMPTZ . IS;

-- Test 554: statement (line 2434)
CREATE SEQUENCE s_106838 OWNED BY col;

-- Test 555: statement (line 2439)
SET serial_normalization = 'sql_sequence';
SET default_int_size=8;

-- Test 556: statement (line 2443)
CREATE TYPE t72820_i_seq AS enum ('a')

-- Test 557: statement (line 2446)
CREATE TABLE t72820 (i SERIAL PRIMARY KEY)

onlyif config schema-locked-disabled

-- Test 558: query (line 2450)
SELECT create_statement FROM [SHOW CREATE TABLE t72820]

-- Test 559: query (line 2459)
SELECT create_statement FROM [SHOW CREATE TABLE t72820]

-- Test 560: statement (line 2469)
CREATE SEQUENCE t72820_i_seq

onlyif config local-legacy-schema-changer

-- Test 561: statement (line 2473)
CREATE SEQUENCE t72820_i_seq

-- Test 562: statement (line 2476)
RESET serial_normalization;
RESET default_int_size;

-- Test 563: statement (line 2486)
CREATE SEQUENCE sq_119108;

-- Test 564: query (line 2489)
SELECT crdb_internal.pb_to_json('desc', descriptor)->'table'->'columns' FROM system.descriptor WHERE id = 'sq_119108'::REGCLASS::OID;

-- Test 565: statement (line 2499)
CREATE SEQUENCE geography

onlyif config local-legacy-schema-changer

-- Test 566: statement (line 2503)
CREATE SEQUENCE geometry

onlyif config local-legacy-schema-changer

-- Test 567: statement (line 2507)
CREATE SEQUENCE box2d

skipif config local-legacy-schema-changer

-- Test 568: statement (line 2511)
CREATE SEQUENCE geography

skipif config local-legacy-schema-changer

-- Test 569: statement (line 2515)
CREATE SEQUENCE geometry

skipif config local-legacy-schema-changer

-- Test 570: statement (line 2519)
CREATE SEQUENCE box2d

-- Test 571: statement (line 2526)
CREATE TEMP SEQUENCE temp_seq

-- Test 572: statement (line 2532)
CREATE TEMP SEQUENCE temp_seq

-- Test 573: query (line 2535)
SELECT substring(sequence_schema FOR 7), sequence_name FROM [SHOW SEQUENCES] WHERE sequence_name = 'temp_seq'

-- Test 574: statement (line 2545)
CREATE TABLE t_seq_owner (id BIGSERIAL NOT NULL);

-- Test 575: statement (line 2548)
CREATE SEQUENCE id_seq_owned OWNED BY t_seq_owner.id;

-- Test 576: statement (line 2551)
ALTER TABLE t_seq_owner ALTER COLUMN id SET DEFAULT nextval('id_seq_owned');

-- Test 577: query (line 2555)
SELECT count(*) FROM pg_sequences WHERE sequencename='id_seq_owned';

-- Test 578: statement (line 2561)
drop table t_seq_owner;

-- Test 579: query (line 2565)
SELECT count(*) FROM pg_sequences WHERE sequencename='id_seq_owned';

-- Test 580: query (line 2571)
SELECT count(*) FROM pg_tables WHERE tablename='t_seq_owner';

