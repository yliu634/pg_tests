-- PostgreSQL compatible tests from views
-- 395 tests

-- Many statements below are expected to error (permission checks, duplicate/invalid view definitions).
\set ON_ERROR_STOP 0

-- CockroachDB logic tests assume current database is `test`. Use schemas to emulate
-- databases so the file can run in a single PostgreSQL database.
SET client_min_messages = warning;
DROP SCHEMA IF EXISTS test CASCADE;
DROP SCHEMA IF EXISTS test2 CASCADE;
DROP SCHEMA IF EXISTS db1 CASCADE;
DROP SCHEMA IF EXISTS db1_sc2 CASCADE;
DROP SCHEMA IF EXISTS db2 CASCADE;
DROP SCHEMA IF EXISTS rename_sc1 CASCADE;
DROP SCHEMA IF EXISTS tdb_seq_select CASCADE;
DROP SCHEMA IF EXISTS tdb_seq_select_new CASCADE;
DROP SCHEMA IF EXISTS db106602a CASCADE;
DROP SCHEMA IF EXISTS db106602b CASCADE;

DROP ROLE IF EXISTS testuser;
CREATE ROLE testuser LOGIN;
GRANT testuser TO postgres;
RESET client_min_messages;

CREATE SCHEMA test;
SET search_path = test, public;

-- Test 1: statement (line 3)
-- SET CLUSTER SETTING sql.cross_db_views.enabled = TRUE

-- Test 2: statement (line 6)
CREATE TABLE t (a INT PRIMARY KEY, b INT);
CREATE TABLE u (a INT PRIMARY KEY, b INT);

-- let $t_id
-- CockroachDB-only system table.
-- SELECT id FROM system.namespace WHERE name='t';

-- Test 3: statement (line 13)
INSERT INTO t VALUES (1, 99), (2, 98), (3, 97);

-- Test 4: statement (line 16)
CREATE VIEW v1 AS SELECT a, b FROM t;

-- Test 5: statement (line 19)
CREATE VIEW v1 AS SELECT a, b FROM t;

-- Test 6: statement (line 22)
CREATE VIEW t AS SELECT a, b FROM t;

-- Test 7: statement (line 25)
CREATE VIEW IF NOT EXISTS v2 (x, y) AS SELECT a, b FROM t;

-- Test 8: statement (line 29)
CREATE VIEW IF NOT EXISTS v2 AS SELECT b, a FROM v1;

-- Test 9: statement (line 32)
CREATE VIEW v3 (x) AS SELECT a, b FROM t;

-- Test 10: statement (line 35)
CREATE VIEW v4 (x, y, z) AS SELECT a, b FROM t;

-- Test 11: statement (line 38)
CREATE VIEW v5 AS SELECT a, b FROM dne;

-- Test 12: statement (line 41)
CREATE VIEW v6 (x, y) AS SELECT a, b FROM v1;

-- Test 13: statement (line 44)
CREATE VIEW v7 (x, y) AS SELECT a, b FROM v1 ORDER BY a DESC LIMIT 2;

-- Test 14: statement (line 47)
CREATE VIEW err AS SELECT j FROM t;

-- Test 15: statement (line 50)
CREATE VIEW err AS SELECT a FROM t WHERE a = j;

-- Test 16: query (line 53)
SELECT * FROM v1;

-- Test 17: query (line 61)
SELECT * FROM v2;

-- Test 18: query (line 69)
SELECT * FROM v6;

-- Test 19: query (line 77)
SELECT * FROM v7;

-- Test 20: query (line 84)
SELECT * FROM v7 ORDER BY x LIMIT 1;

-- Test 21: query (line 90)
SELECT * FROM v2 ORDER BY x DESC LIMIT 1;

-- Test 22: query (line 95)
SELECT x FROM v2;

-- Test 23: query (line 102)
SELECT y FROM v2;

-- Test 24: query (line 109)
SELECT x FROM v7;

-- Test 25: query (line 115)
SELECT x FROM v7 ORDER BY x LIMIT 1;

-- Test 26: query (line 120)
SELECT y FROM v7;

-- Test 27: query (line 126)
SELECT y FROM v7 ORDER BY x LIMIT 1;

-- Test 28: query (line 131)
SELECT * FROM v1 AS v1 INNER JOIN v2 AS v2 ON v1.a = v2.x;

-- Test 29: statement (line 138)
CREATE SCHEMA IF NOT EXISTS test2;

-- Test 30: statement (line 141)
SET search_path = test2, public;

-- Test 31: query (line 149)
SELECT 'CREATE VIEW t1 AS ' || pg_get_viewdef('t1'::regclass, true) AS create_statement;

-- Test 32: query (line 157)
SELECT 'CREATE VIEW t1 AS ' || pg_get_viewdef('t1'::regclass, true) AS create_statement;

-- Test 33: query (line 165)
SELECT 'CREATE VIEW t2 AS ' || pg_get_viewdef('t2'::regclass, true) AS create_statement;

-- Test 34: query (line 173)
SELECT 'CREATE VIEW t2 AS ' || pg_get_viewdef('t2'::regclass, true) AS create_statement;

-- Test 35: query (line 181)
SELECT * FROM test.v1;

-- Test 36: query (line 189)
SELECT * FROM test.v2;

-- Test 37: query (line 197)
SELECT * FROM test.v6;

-- Test 38: query (line 205)
SELECT * FROM test.v7;

-- Test 39: query (line 212)
SELECT * FROM test.v7 ORDER BY x LIMIT 1;

-- Test 40: statement (line 218)
CREATE VIEW v1 AS SELECT x, y FROM test.v2;

-- Test 41: statement (line 221)
SET search_path = test, public;

-- Test 42: query (line 224)
SELECT * FROM test2.v1;

-- Test 43: query (line 232)
SELECT 'CREATE VIEW v1 AS ' || pg_get_viewdef('v1'::regclass, true) AS create_statement;

-- Test 44: query (line 240)
SELECT 'CREATE VIEW v2 AS ' || pg_get_viewdef('v2'::regclass, true) AS create_statement;

-- Test 45: query (line 248)
SELECT 'CREATE VIEW v6 AS ' || pg_get_viewdef('v6'::regclass, true) AS create_statement;

-- Test 46: query (line 256)
SELECT 'CREATE VIEW v7 AS ' || pg_get_viewdef('v7'::regclass, true) AS create_statement;

-- Test 47: query (line 264)
SELECT 'CREATE VIEW v7 AS ' || pg_get_viewdef('v7'::regclass, true) AS create_statement;

-- Test 48: query (line 272)
SELECT 'CREATE VIEW test2.v1 AS ' || pg_get_viewdef('test2.v1'::regclass, true) AS create_statement;

-- Test 49: statement (line 280)
GRANT SELECT ON t TO testuser;

SET ROLE testuser;

-- Test 50: query (line 285)
SELECT * FROM t;

-- Test 51: query (line 292)
SELECT * FROM v1;

-- query error user testuser does not have SELECT privilege on relation v6
SELECT * FROM v6;

-- query error user testuser has no privileges on relation v1
SELECT 'CREATE VIEW v1 AS ' || pg_get_viewdef('v1'::regclass, true) AS create_statement;

RESET ROLE;

-- statement ok
REVOKE SELECT ON t FROM testuser;

-- statement ok
GRANT SELECT ON v1 TO testuser;

SET ROLE testuser;

-- query error user testuser does not have SELECT privilege on relation t
SELECT * FROM t;

-- query II rowsort
SELECT * FROM v1;

-- Test 52: query (line 321)
SELECT * FROM v6;

-- query TT
SELECT 'CREATE VIEW v1 AS ' || pg_get_viewdef('v1'::regclass, true) AS create_statement;

-- Test 53: statement (line 334)
REVOKE SELECT ON v1 FROM testuser;

-- Test 54: statement (line 337)
GRANT SELECT ON v6 TO testuser;

SET ROLE testuser;

-- Test 55: query (line 342)
SELECT * FROM t;

-- query error user testuser does not have SELECT privilege on relation v1
SELECT * FROM v1;

-- query II rowsort
SELECT * FROM v6;

-- Test 56: statement (line 358)
CREATE VIEW num_ref_view AS SELECT a, b FROM t;

-- Test 57: statement (line 361)
GRANT SELECT ON num_ref_view TO testuser;

SET ROLE testuser;

-- Test 58: query (line 366)
SELECT * FROM num_ref_view;

-- Test 59: statement (line 375)
DROP VIEW num_ref_view;

-- Test 60: statement (line 378)
DROP TABLE v1;

-- Test 61: statement (line 381)
DROP VIEW t;

-- Test 62: statement (line 384)
DROP VIEW v1;

-- Test 63: statement (line 387)
DROP VIEW v2;

-- Test 64: statement (line 390)
DROP VIEW test2.v1;

-- Test 65: statement (line 393)
DROP VIEW v7;

-- Test 66: statement (line 396)
DROP VIEW v6;

-- Test 67: statement (line 399)
DROP VIEW v2;

-- Test 68: statement (line 402)
DROP VIEW v1;

-- Test 69: statement (line 405)
DROP VIEW v1;

-- Test 70: statement (line 409)
CREATE VIEW virt1 AS SELECT table_schema FROM information_schema.columns;

-- Test 71: statement (line 412)
DROP VIEW virt1;

-- Test 72: statement (line 416)
-- CockroachDB-only system table.
-- CREATE VIEW virt2 AS SELECT range_id, lease_holder FROM crdb_internal.ranges;

-- Test 73: statement (line 419)
DROP VIEW virt2;

-- Test 74: statement (line 422)
CREATE VIEW star1 AS SELECT * FROM t;

-- Test 75: statement (line 425)
CREATE VIEW star2 AS SELECT t.* FROM t;

-- Test 76: statement (line 430)
CREATE VIEW star3 AS SELECT a FROM t ORDER BY t.*;

-- Test 77: statement (line 435)
CREATE VIEW star4 AS SELECT count(1) FROM t GROUP BY t.*;

-- Test 78: statement (line 438)
CREATE VIEW star5 AS SELECT alias.* FROM t AS alias;

-- Test 79: statement (line 441)
CREATE VIEW star6 AS TABLE t;

-- Test 80: statement (line 444)
CREATE VIEW star7 AS SELECT a FROM (SELECT * FROM t);

-- Test 81: statement (line 447)
CREATE VIEW star8 AS SELECT a FROM t WHERE NOT a IN (SELECT a FROM (SELECT * FROM t));

-- Test 82: statement (line 450)
CREATE VIEW star9 AS SELECT a FROM t GROUP BY a HAVING a IN (SELECT a FROM (SELECT * FROM t));

-- Test 83: statement (line 454)
CREATE VIEW star10 AS SELECT t1.*, t2.a FROM t AS t1 JOIN t AS t2 ON t1.a = t2.a;

-- Test 84: statement (line 457)
CREATE VIEW star10 AS SELECT t1.*, t2.a AS a2 FROM t AS t1 JOIN t AS t2 ON t1.a = t2.a;

-- Test 85: statement (line 461)
CREATE VIEW star11 AS SELECT t1.a, t2.* FROM t AS t1 JOIN t AS t2 ON t1.a = t2.a;

-- Test 86: statement (line 464)
CREATE VIEW star11 AS SELECT t1.a AS a1, t2.* FROM t AS t1 JOIN t AS t2 ON t1.a = t2.a;

-- Test 87: statement (line 468)
CREATE VIEW star12 AS SELECT t1.*, t2.* FROM t AS t1 JOIN t AS t2 ON t1.a = t2.a;

-- Test 88: statement (line 472)
CREATE VIEW star13 AS SELECT * FROM t AS t1 JOIN t AS t2 ON t1.a = t2.a;

-- Test 89: statement (line 475)
CREATE VIEW star14 AS SELECT t1.a, t2.a AS a2 FROM (SELECT * FROM t) AS t1 JOIN t AS t2 ON t1.a = t2.a;

-- Test 90: statement (line 478)
CREATE VIEW star15 AS SELECT t1.a, t2.a AS a2 FROM t AS t1 JOIN (SELECT * FROM t) AS t2 ON t1.a = t2.a;

-- Test 91: statement (line 481)
CREATE VIEW star16 AS SELECT t1.a, t2.a AS a2 FROM t AS t1 JOIN t AS t2 ON t1.a IN (SELECT a FROM (SELECT * FROM t));

-- Test 92: statement (line 485)
CREATE VIEW star17 AS SELECT * FROM (SELECT a FROM t) t1 JOIN (SELECT a FROM u) t2 ON true;

-- Test 93: statement (line 489)
CREATE VIEW star17 AS SELECT * FROM (SELECT a FROM t) JOIN (SELECT a FROM u) ON true;

-- Test 94: statement (line 492)
CREATE VIEW star17 AS SELECT * FROM (SELECT a FROM t) JOIN (SELECT b FROM u) ON true;

-- Test 95: statement (line 495)
CREATE VIEW star18 AS SELECT * FROM (SELECT * FROM (SELECT a FROM t));

-- Test 96: statement (line 498)
CREATE VIEW star19 AS SELECT a FROM (SELECT * FROM (SELECT a FROM t));

-- Test 97: statement (line 504)
ALTER TABLE t ADD COLUMN c INT;

-- Test 98: statement (line 507)
ALTER TABLE t DROP COLUMN b;

-- Test 99: statement (line 511)
ALTER TABLE t RENAME COLUMN b TO d;

-- Test 100: query (line 514)
-- CockroachDB-only system table.
-- SELECT descriptor_name, create_statement FROM crdb_internal.create_statements WHERE descriptor_name LIKE 'star%' ORDER BY 1;

-- Test 101: statement (line 629)
DROP VIEW star1;
DROP VIEW star2;
DROP VIEW star3;
DROP VIEW star4;
DROP VIEW star5;
DROP VIEW star6;
DROP VIEW star7;
DROP VIEW star8;
DROP VIEW star9;
DROP VIEW star10;
DROP VIEW star11;
DROP VIEW star14;
DROP VIEW star15;
DROP VIEW star16;
DROP VIEW star17;
DROP VIEW star18;
DROP VIEW star19;
DROP VIEW star20;

-- Test 102: statement (line 649)
CREATE VIEW s1 AS SELECT count(*) FROM t;

-- Test 103: statement (line 652)
CREATE VIEW s2 AS SELECT a FROM t WHERE a IN (SELECT count(*) FROM t);

-- Test 104: statement (line 655)
CREATE VIEW s3 AS SELECT a, count(*) FROM t GROUP BY a;

-- Test 105: statement (line 658)
CREATE VIEW s4 AS SELECT a, count(*) FROM t GROUP BY a HAVING a > (SELECT count(*) FROM t);

-- Test 106: statement (line 661)
DROP VIEW s4;

-- Test 107: statement (line 664)
DROP VIEW s3;

-- Test 108: statement (line 667)
DROP VIEW s2;

-- Test 109: statement (line 670)
DROP VIEW s1;

-- Test 110: statement (line 673)
DROP TABLE t; DROP TABLE u;

-- Test 111: statement (line 677)
CREATE VIEW foo AS SELECT catalog_name, schema_name, sql_path FROM information_schema.schemata;

-- Test 112: statement (line 680)
CREATE VIEW foo AS SELECT catalog_name, schema_name, sql_path FROM information_schema.schemata;

-- Test 113: statement (line 684)
CREATE TABLE t (d DATE, t TIMESTAMP);

-- Test 114: statement (line 687)
CREATE VIEW dt AS SELECT d, t FROM t WHERE d > DATE '1988-11-12' AND t < TIMESTAMP '2017-01-01';

-- Test 115: query (line 690)
SELECT 'CREATE VIEW dt AS ' || pg_get_viewdef('dt'::regclass, true) AS create_statement;

-- Test 116: query (line 698)
SELECT 'CREATE VIEW dt AS ' || pg_get_viewdef('dt'::regclass, true) AS create_statement;

-- Test 117: statement (line 711)
SELECT * FROM dt;

-- Test 118: statement (line 714)
CREATE VIEW dt2 AS SELECT d, t FROM t WHERE d > d + INTERVAL '10h';

-- Test 119: query (line 717)
SELECT 'CREATE VIEW dt2 AS ' || pg_get_viewdef('dt2'::regclass, true) AS create_statement;

-- Test 120: query (line 725)
SELECT 'CREATE VIEW dt2 AS ' || pg_get_viewdef('dt2'::regclass, true) AS create_statement;

-- Test 121: statement (line 733)
SELECT * FROM dt2;

-- Test 122: statement (line 736)
DROP TABLE t CASCADE;

-- Test 123: statement (line 739)
CREATE TABLE t (a INT[]);

-- Test 124: statement (line 742)
INSERT INTO t VALUES (array[1,2,3]);

-- Test 125: statement (line 745)
CREATE VIEW b AS SELECT a[1] FROM t;

-- Test 126: query (line 748)
SELECT * FROM b;

-- Test 127: statement (line 753)
DROP TABLE t CASCADE;

-- Test 128: statement (line 756)
CREATE VIEW arr(a) AS SELECT ARRAY[3];

-- Test 129: query (line 759)
SELECT *, a[1] FROM arr;

-- Test 130: statement (line 766)
CREATE TABLE t15951 (a int, b int);

-- Test 131: statement (line 769)
CREATE VIEW Caps15951 AS SELECT a, b FROM t15951;

-- Test 132: statement (line 772)
INSERT INTO t15951 VALUES (1, 1), (1, 2), (1, 3), (2, 2), (2, 3), (3, 3);

-- Test 133: query (line 775)
SELECT sum (Caps15951. a) FROM Caps15951 GROUP BY b ORDER BY b;

-- Test 134: query (line 782)
SELECT sum ("caps15951". a) FROM "caps15951" GROUP BY b ORDER BY b;

-- Test 135: statement (line 789)
CREATE VIEW "QuotedCaps15951" AS SELECT a, b FROM t15951;

-- Test 136: query (line 792)
SELECT sum ("QuotedCaps15951". a) FROM "QuotedCaps15951" GROUP BY b ORDER BY b;

-- Test 137: statement (line 801)
CREATE VIEW w AS WITH a AS (SELECT 1 AS x) SELECT x FROM a;

-- Test 138: query (line 804)
SELECT 'CREATE VIEW w AS ' || pg_get_viewdef('w'::regclass, true) AS create_statement;

-- Test 139: query (line 811)
SELECT 'CREATE VIEW w AS ' || pg_get_viewdef('w'::regclass, true) AS create_statement;

-- Test 140: statement (line 818)
CREATE VIEW w2 AS WITH t AS (SELECT x FROM w) SELECT x FROM t;

-- Test 141: query (line 821)
SELECT 'CREATE VIEW w2 AS ' || pg_get_viewdef('w2'::regclass, true) AS create_statement;

-- Test 142: statement (line 828)
CREATE VIEW w3 AS (WITH t AS (SELECT x FROM w) SELECT x FROM t);

-- Test 143: query (line 831)
SELECT 'CREATE VIEW w3 AS ' || pg_get_viewdef('w3'::regclass, true) AS create_statement;

-- Test 144: statement (line 838)
CREATE TABLE ab (a INT PRIMARY KEY, b INT);

-- Test 145: statement (line 841)
INSERT INTO ab VALUES (100, 100);
CREATE VIEW crud_view AS SELECT a, b FROM ab WHERE a = 100 AND b = 100;

-- Test 146: statement (line 844)
CREATE TABLE cd (c INT PRIMARY KEY, b INT);

-- Test 147: statement (line 847)
INSERT INTO ab VALUES (1, 1), (2, 2), (3, 3);

-- Test 148: statement (line 850)
INSERT INTO cd VALUES (2, 2), (3, 3), (4, 4);

-- Test 149: statement (line 854)
CREATE VIEW v1 AS SELECT a, b, EXISTS(SELECT c FROM cd WHERE cd.c=ab.a) FROM ab;

-- Test 150: query (line 857)
SELECT * FROM v1;

-- Test 151: statement (line 866)
CREATE TABLE a47704 (foo UUID);
CREATE TABLE b47704 (foo UUID);

-- Test 152: statement (line 870)
CREATE VIEW v47704 AS
  SELECT first_value(a47704.foo) OVER (PARTITION BY a47704.foo ORDER BY a47704.foo)
  FROM a47704 JOIN b47704 ON a47704.foo = b47704.foo;

-- Test 153: query (line 877)
SELECT 'CREATE VIEW v47704 AS ' || pg_get_viewdef('v47704'::regclass, true) AS create_statement;

-- Test 154: statement (line 887)
SELECT * FROM v47704;

-- Test 155: statement (line 894)
DROP TABLE IF EXISTS t, t2;
CREATE TABLE t (x INT);
INSERT INTO t VALUES (1), (2);
CREATE TABLE t2 (x INT);
INSERT INTO t2 VALUES (3), (4);

-- Test 156: statement (line 903)
CREATE OR REPLACE VIEW t AS VALUES (1);

-- Test 157: statement (line 906)
CREATE OR REPLACE VIEW tview AS SELECT x AS x, x+1 AS x1, x+2 AS x2 FROM t;

-- Test 158: statement (line 911)
CREATE OR REPLACE VIEW tview AS SELECT x AS x, x+1 AS x1 FROM t;

-- Test 159: statement (line 914)
CREATE OR REPLACE VIEW tview AS SELECT x AS xy, x+1 AS x1, x+2 AS x2 FROM t;

-- Test 160: statement (line 920)
CREATE OR REPLACE VIEW tview AS SELECT x AS x, x+1 AS x1, x+2 AS x2, x+3 AS x3 FROM t;

-- Test 161: query (line 923)
SELECT * FROM tview;

-- Test 162: statement (line 930)
CREATE OR REPLACE VIEW tview AS SELECT x AS x, x+1 AS x1, x+2 AS x2, x+3 AS x3 FROM t2;

-- Test 163: query (line 933)
SELECT * FROM tview;

-- Test 164: statement (line 940)
DROP TABLE t;

-- Test 165: statement (line 944)
DROP TABLE t2;

-- Test 166: statement (line 949)
CREATE INDEX i ON t2 (x);
CREATE INDEX i2 ON t2 (x);

-- Test 167: statement (line 953)
CREATE OR REPLACE VIEW tview AS SELECT x AS x, x+1 AS x1, x+2 AS x2, x+3 AS x3 FROM t2@i;

-- Test 168: statement (line 956)
DROP INDEX t2@i;

-- Test 169: statement (line 960)
CREATE OR REPLACE VIEW tview AS SELECT x AS x, x+1 AS x1, x+2 AS x2, x+3 AS x3 FROM t2@i2;
DROP INDEX t2@i;

-- Test 170: statement (line 965)
DROP INDEX t2@i2;

-- Test 171: statement (line 969)
GRANT CREATE ON SCHEMA test TO testuser;
GRANT CREATE, SELECT ON TABLE tview, t2 TO testuser;

SET ROLE testuser;

-- Test 172: statement (line 975)
CREATE OR REPLACE VIEW tview AS SELECT x AS x, x+1 AS x1, x+2 AS x2, x+3 AS x3 FROM t2;

-- Test 173: statement (line 981)
GRANT DROP ON TABLE tview TO testuser;

SET ROLE testuser;

-- Test 174: statement (line 986)
CREATE OR REPLACE VIEW tview AS SELECT x AS x, x+1 AS x1, x+2 AS x2, x+3 AS x3 FROM t2;

RESET ROLE;

-- Test 175: statement (line 996)
DROP TABLE ab CASCADE;

-- Test 176: statement (line 999)
CREATE TABLE ab (a INT, b INT);
CREATE VIEW vab (x) AS SELECT ab.a FROM ab, ab AS ab2;

-- Test 177: statement (line 1003)
ALTER TABLE ab DROP COLUMN b;

-- Test 178: statement (line 1006)
ALTER TABLE ab DROP COLUMN a;

-- Test 179: statement (line 1009)
CREATE TABLE abc (a INT, b INT, c INT);
CREATE VIEW vabc AS SELECT abc.a, abc2.b, abc3.c FROM abc, abc AS abc2, abc AS abc3;

-- Test 180: statement (line 1014)
ALTER TABLE abc DROP COLUMN a;

-- Test 181: statement (line 1017)
ALTER TABLE abc DROP COLUMN b;

-- Test 182: statement (line 1020)
ALTER TABLE abc DROP COLUMN c;

-- Test 183: statement (line 1024)
CREATE TABLE toreg();
CREATE VIEW vregclass AS SELECT 'toreg'::regclass;

-- Test 184: statement (line 1028)
DROP TABLE toreg;

-- Test 185: statement (line 1031)
DROP VIEW vregclass;

-- Test 186: statement (line 1034)
CREATE VIEW vregclass AS SELECT x FROM (SELECT CAST('toreg' AS regclass) AS x);

-- Test 187: statement (line 1037)
DROP TABLE toreg;

-- Test 188: statement (line 1040)
DROP VIEW vregclass;

-- Test 189: statement (line 1043)
CREATE SEQUENCE s_reg;
CREATE VIEW vregclass AS SELECT x FROM (SELECT 's_reg'::REGCLASS AS x) AS t;

-- Test 190: statement (line 1047)
DROP SEQUENCE s_reg;

-- Test 191: statement (line 1052)
DROP VIEW vregclass;

-- Test 192: statement (line 1055)
CREATE VIEW vregclass AS SELECT x::regclass FROM (SELECT 's_reg' AS x);
DROP SEQUENCE s_reg;

-- Test 193: statement (line 1059)
DROP VIEW vregclass;

-- Test 194: statement (line 1062)
CREATE VIEW vregclass AS SELECT x::regclass FROM (SELECT 'does_not_exist' AS x);

-- Test 195: statement (line 1065)
SELECT * FROM vregclass;

-- Test 196: statement (line 1068)
DROP VIEW vregclass;

-- Test 197: statement (line 1071)
CREATE table tregclass();

-- Test 198: statement (line 1074)
CREATE VIEW vregclass AS SELECT 1 FROM (SELECT 1) AS foo WHERE 'tregclass'::regclass = 'tregclass'::regclass;

-- Test 199: statement (line 1077)
DROP TABLE tregclass;

-- Test 200: statement (line 1084)
-- SET CLUSTER SETTING sql.cross_db_views.enabled = FALSE

-- Test 201: statement (line 1087)
CREATE SCHEMA IF NOT EXISTS db1;

-- Test 202: statement (line 1090)
CREATE SCHEMA IF NOT EXISTS db2;

-- Test 203: statement (line 1093)
SET search_path = db1, public;

-- Test 204: statement (line 1096)
CREATE TABLE ab (a INT, b INT);

-- Test 205: statement (line 1099)
CREATE VIEW v1 AS SELECT a+b FROM ab;

-- Test 206: statement (line 1102)
CREATE VIEW db1.v2 AS SELECT a+b FROM db1.ab;

-- Test 207: statement (line 1105)
CREATE VIEW db2.v AS SELECT a+b FROM db1.ab;

-- Test 208: statement (line 1108)
CREATE VIEW db2.replace AS SELECT 1;

-- Test 209: statement (line 1111)
CREATE OR REPLACE VIEW db2.replace AS SELECT a+b FROM db1.ab;

-- Test 210: statement (line 1114)
CREATE SEQUENCE db2.seq;

-- Test 211: statement (line 1117)
CREATE VIEW v2 AS SELECT last_value FROM db2.seq;

-- Test 212: statement (line 1121)
CREATE SCHEMA db1_sc2;

-- Test 213: statement (line 1124)
CREATE VIEW db1_sc2.v AS SELECT a+b FROM db1.ab;

-- Test 214: statement (line 1127)
CREATE TABLE db1_sc2.cd (c INT, d INT);

-- Test 215: statement (line 1130)
CREATE VIEW db1.v3 AS SELECT a+b+c+d FROM db1.ab, db1_sc2.cd;

-- Test 216: statement (line 1135)
-- CockroachDB-only system table.
-- CREATE VIEW sys AS SELECT id FROM system.descriptor;

-- Test 217: statement (line 1138)
-- CockroachDB-only system table.
-- CREATE VIEW sys2 AS SELECT id, a+b FROM system.descriptor, ab;

-- Test 218: statement (line 1141)
SET search_path = db2, public;

-- Test 219: statement (line 1144)
CREATE TABLE cd (c INT, d INT);

-- Test 220: statement (line 1147)
CREATE VIEW v AS SELECT a+b+c+d FROM cd, db1.ab;

-- Test 221: statement (line 1150)
-- SET CLUSTER SETTING sql.cross_db_views.enabled = TRUE

-- Test 222: statement (line 1153)
CREATE VIEW db2.v1 AS SELECT a+b FROM db1.ab;

-- Test 223: statement (line 1156)
CREATE VIEW db2.v2 AS SELECT a+b+c+d FROM cd, db1.ab;

-- Test 224: statement (line 1161)
SET search_path = DB1, public;

-- Test 225: statement (line 1164)
CREATE SEQUENCE SQ1;

-- Test 226: statement (line 1167)
CREATE TYPE status AS ENUM ('open', 'closed', 'inactive');

-- Test 227: statement (line 1170)
CREATE TABLE tval (val int primary key);

-- Test 228: statement (line 1173)
CREATE VIEW rv as select val from tval;

-- Test 229: statement (line 1176)
SET search_path = DB2, public;

-- Test 230: statement (line 1180)
CREATE VIEW vm as (select cast('open' as db1.status) from db1.tval as t);

-- Test 231: statement (line 1184)
CREATE VIEW db1.vm as (select cast('open' as db1.status) from db1.tval as t);

-- Test 232: statement (line 1187)
CREATE TYPE db2.status AS ENUM ('open', 'closed', 'inactive');

-- Test 233: statement (line 1190)
CREATE VIEW vm as (select s.last_value, t.val as a, v.val as b, cast('open' as db2.status) from db1.tval as t, db1.sq1 as s, db1.rv as v);

-- Test 234: query (line 1193)
-- CockroachDB-only system table.
-- select * from "".crdb_internal.cross_db_references order by object_database, object_schema, object_name, referenced_object_database, referenced_object_schema, referenced_object_name desc;

-- Test 235: statement (line 1208)
CREATE TYPE typ AS ENUM('a');

-- Test 236: statement (line 1214)
DROP TYPE typ;

-- Test 237: statement (line 1217)
DROP VIEW v;

-- Test 238: statement (line 1220)
CREATE VIEW v AS (WITH r AS (SELECT 'a'::typ < 'a'::typ AS k) SELECT k FROM r);

-- Test 239: statement (line 1223)
DROP TYPE typ;

-- Test 240: statement (line 1226)
DROP VIEW v;

-- Test 241: statement (line 1232)
CREATE VIEW v AS (SELECT i FROM t);

-- Test 242: statement (line 1236)
DROP TYPE typ;

-- Test 243: statement (line 1239)
CREATE VIEW v_dep AS (SELECT k FROM t);

-- Test 244: statement (line 1243)
DROP TYPE typ;

-- Test 245: statement (line 1246)
CREATE TYPE typ2 AS ENUM('a');

-- Test 246: statement (line 1252)
DROP TYPE typ2;

-- Test 247: statement (line 1255)
CREATE OR REPLACE VIEW v3 AS (SELECT 'a' AS k);

-- Test 248: statement (line 1258)
DROP TYPE typ2;

-- Test 249: statement (line 1261)
CREATE TYPE typ2 AS ENUM('a');

-- Test 250: statement (line 1267)
DROP TYPE typ2;

-- Test 251: statement (line 1270)
ALTER TYPE typ2 RENAME TO typ3;

-- Test 252: statement (line 1273)
DROP TYPE typ3;

-- Test 253: statement (line 1276)
CREATE TYPE typ4 AS ENUM('a');

-- Test 254: statement (line 1279)
CREATE TABLE t4 (i INT, j typ4);

-- Test 255: statement (line 1282)
CREATE VIEW v4 AS (SELECT i FROM t4);

-- Test 256: statement (line 1286)
DROP TYPE typ4;

-- Test 257: statement (line 1289)
ALTER TABLE t4 DROP COLUMN j;

-- Test 258: statement (line 1292)
DROP TYPE typ4;

-- Test 259: statement (line 1295)
CREATE TYPE typ4 AS ENUM('a');

-- Test 260: statement (line 1298)
ALTER TABLE t4 ADD COLUMN j typ4;

-- Test 261: statement (line 1301)
CREATE VIEW v4_dep AS (SELECT j FROM t4);

-- Test 262: statement (line 1305)
DROP type typ4;

-- Test 263: statement (line 1308)
CREATE TYPE typ5 AS ENUM('a');

-- Test 264: statement (line 1315)
CREATE VIEW v5 AS (SELECT i FROM t5);

-- Test 265: statement (line 1318)
DROP TYPE typ5;

-- Test 266: statement (line 1321)
CREATE VIEW v5_dep AS (SELECT j FROM t5);

-- Test 267: statement (line 1325)
DROP TYPE typ5;

-- Test 268: statement (line 1328)
CREATE VIEW v6 AS (SELECT j FROM v4_dep);

-- Test 269: statement (line 1332)
DROP TYPE typ4;

-- Test 270: statement (line 1335)
CREATE TYPE typ6 AS ENUM('a');
CREATE TABLE t6 (i INT, k typ6);
CREATE INDEX idx ON t6 (i) WHERE k < 'a'::typ6;

-- Test 271: statement (line 1340)
CREATE VIEW v7 AS (SELECT i FROM t6);

-- Test 272: statement (line 1344)
DROP TYPE typ6;

-- Test 273: statement (line 1347)
CREATE VIEW v7_dep AS (SELECT i FROM t6@idx WHERE k < 'a'::typ6);

-- Test 274: statement (line 1351)
DROP TYPE typ6;

-- Test 275: statement (line 1355)
CREATE SEQUENCE s;

-- Test 276: statement (line 1358)
CREATE VIEW v8 AS (SELECT last_value FROM s);

-- Test 277: statement (line 1361)
CREATE VIEW v9 AS (SELECT sequence_name FROM information_schema.sequences);

-- Test 278: statement (line 1368)
CREATE TYPE view_typ AS ENUM('a', 'b');

-- Test 279: statement (line 1371)
CREATE VIEW v10 AS SELECT 'a'::view_typ;

-- Test 280: statement (line 1374)
ALTER TYPE view_typ RENAME TO view_typ_new;

-- Test 281: query (line 1377)
SELECT 'CREATE VIEW v10 AS ' || pg_get_viewdef('v10'::regclass, true) AS create_statement;

-- Test 282: query (line 1384)
SELECT 'CREATE VIEW v10 AS ' || pg_get_viewdef('v10'::regclass, true) AS create_statement;

-- Test 283: query (line 1391)
SELECT * FROM v10;

-- Test 284: statement (line 1396)
CREATE VIEW v11 AS (SELECT 'a'::view_typ_new < 'a'::view_typ_new AS k);

-- Test 285: statement (line 1399)
ALTER TYPE view_typ_new RENAME TO view_typ;

-- Test 286: query (line 1402)
SELECT 'CREATE VIEW v11 AS ' || pg_get_viewdef('v11'::regclass, true) AS create_statement;

-- Test 287: query (line 1409)
SELECT 'CREATE VIEW v11 AS ' || pg_get_viewdef('v11'::regclass, true) AS create_statement;

-- Test 288: query (line 1416)
SELECT * FROM v11;

-- Test 289: statement (line 1421)
CREATE VIEW v12 AS (SELECT k FROM (SELECT 'a'::view_typ AS k));

-- Test 290: statement (line 1424)
ALTER TYPE view_typ RENAME TO view_type_new;

-- Test 291: query (line 1427)
SELECT 'CREATE VIEW v12 AS ' || pg_get_viewdef('v12'::regclass, true) AS create_statement;

-- Test 292: query (line 1434)
SELECT 'CREATE VIEW v12 AS ' || pg_get_viewdef('v12'::regclass, true) AS create_statement;

-- Test 293: query (line 1441)
SELECT * FROM v12;

-- Test 294: statement (line 1446)
CREATE VIEW v13 AS (SELECT 'a'::view_type_new AS k UNION SELECT 'b'::view_type_new);

-- Test 295: statement (line 1449)
ALTER TYPE view_type_new RENAME TO view_type;

-- Test 296: query (line 1452)
SELECT 'CREATE VIEW v13 AS ' || pg_get_viewdef('v13'::regclass, true) AS create_statement;

-- Test 297: query (line 1459)
SELECT 'CREATE VIEW v13 AS ' || pg_get_viewdef('v13'::regclass, true) AS create_statement;

-- Test 298: query (line 1466)
SELECT * FROM v13 ORDER BY k;

-- Test 299: statement (line 1472)
CREATE VIEW v14 AS (SELECT ARRAY['a'::view_type, 'b'::view_type]);

-- Test 300: statement (line 1475)
ALTER TYPE view_type RENAME TO view_type_new;

-- Test 301: query (line 1478)
SELECT 'CREATE VIEW v14 AS ' || pg_get_viewdef('v14'::regclass, true) AS create_statement;

-- Test 302: query (line 1485)
SELECT 'CREATE VIEW v14 AS ' || pg_get_viewdef('v14'::regclass, true) AS create_statement;

-- Test 303: query (line 1495)
SELECT * FROM v14;

-- Test 304: statement (line 1500)
CREATE VIEW v15 AS (SELECT ('{a, b}'::view_type_new[])[2] AS view_type_new);

-- Test 305: statement (line 1503)
ALTER TYPE view_type_new RENAME TO view_type;

-- Test 306: query (line 1506)
SELECT 'CREATE VIEW v15 AS ' || pg_get_viewdef('v15'::regclass, true) AS create_statement;

-- Test 307: query (line 1513)
SELECT 'CREATE VIEW v15 AS ' || pg_get_viewdef('v15'::regclass, true) AS create_statement;

-- Test 308: query (line 1524)
SELECT * FROM v15;

-- Test 309: statement (line 1531)
CREATE TABLE t1nest (id INT PRIMARY KEY, name varchar(2));

-- Test 310: statement (line 1534)
CREATE VIEW v1nest AS (SELECT name FROM t1nest);

-- Test 311: statement (line 1537)
CREATE VIEW v2nest AS (SELECT name AS n1, name AS n2 FROM v1nest);

-- Test 312: statement (line 1540)
CREATE VIEW v3nest AS (SELECT name, n1 FROM v1nest, v2nest);

-- Test 313: statement (line 1543)
DROP table t1nest CASCADE;

-- Test 314: query (line 1547)
-- CockroachDB-only system table.
-- SELECT ... FROM system.eventlog;

-- Test 315: statement (line 1567)
CREATE TABLE test_t1(a int);

-- Test 316: statement (line 1570)
CREATE MATERIALIZED VIEW li AS (SELECT 1 AS test_t1);

-- Test 317: query (line 1573)
SELECT 'CREATE VIEW li AS ' || pg_get_viewdef('li'::regclass, true) AS create_statement;

-- Test 318: statement (line 1581)
CREATE TABLE test_view (a INT PRIMARY KEY, b INT);

-- Test 319: statement (line 1584)
INSERT INTO test_view VALUES (1, 99), (2, 98), (3, 97);

-- Test 320: statement (line 1587)
CREATE MATERIALIZED VIEW mv1 AS SELECT a, b FROM test_view;

-- Test 321: query (line 1590)
SELECT * FROM mv1;

-- Test 322: statement (line 1598)
CREATE MATERIALIZED VIEW mv2 AS SELECT a, b FROM test_view WHERE b > 98 WITH NO DATA;

-- Test 323: query (line 1601)
SELECT * FROM mv2;

-- statement ok
REFRESH MATERIALIZED VIEW mv2;

-- query II colnames,rowsort
SELECT * from mv2;

-- Test 324: statement (line 1613)
DROP MATERIALIZED VIEW mv1;

-- Test 325: statement (line 1616)
DROP MATERIALIZED VIEW mv2;

-- Test 326: statement (line 1619)
CREATE VIEW view_with_null AS SELECT 1 AS a, null AS c;

-- Test 327: query (line 1622)
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_schema = current_schema() AND table_name = 'view_with_null'
ORDER BY ordinal_position;

-- Test 328: statement (line 1629)
CREATE MATERIALIZED VIEW materialized_view_with_null AS SELECT a, NULL AS b, b AS c FROM test_view;

-- Test 329: query (line 1632)
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_schema = current_schema() AND table_name = 'materialized_view_with_null'
ORDER BY ordinal_position;

-- Test 330: statement (line 1642)
CREATE SCHEMA sc_seq_qualified_name;
CREATE SEQUENCE sc_seq_qualified_name.sq;

-- Test 331: statement (line 1646)
CREATE VIEW v_seq_rewrite_quoted AS SELECT nextval('"sc_seq_qualified_name.sq"');

-- Test 332: statement (line 1649)
CREATE VIEW v_seq_rewrite AS SELECT nextval('sc_seq_qualified_name.sq');

-- Test 333: query (line 1652)
SELECT * FROM v_seq_rewrite;

-- Test 334: statement (line 1657)
CREATE VIEW v_seq_rewrite_quoted AS SELECT nextval('"sc_seq_qualified_name"."sq"');

-- Test 335: query (line 1660)
SELECT * FROM v_seq_rewrite_quoted;

-- Test 336: statement (line 1667)
CREATE SCHEMA IF NOT EXISTS rename_sc1;
SET search_path = rename_sc1, public;

-- Test 337: statement (line 1671)
CREATE SCHEMA sc1;
CREATE SCHEMA sc2;
CREATE TYPE sc1.workday AS ENUM ('Mon');
CREATE TABLE sc1.tbl(a INT PRIMARY KEY);
CREATE SEQUENCE sc1.sq;

-- Test 338: statement (line 1678)
CREATE VIEW sc1.v_tbl AS SELECT a FROM sc1.tbl;
CREATE VIEW sc1.v_type AS SELECT 'Mon'::sc1.workday;
CREATE VIEW sc1.v_seq AS SELECT nextval('sc1.sq');
CREATE VIEW sc2.v_tbl AS SELECT a FROM sc1.tbl;
CREATE VIEW sc2.v_type AS SELECT 'Mon'::sc1.workday;
CREATE VIEW sc2.v_seq AS SELECT nextval('sc1.sq');

-- Test 339: query (line 1686)
SELECT * FROM sc1.v_type;

-- Test 340: query (line 1691)
SELECT * FROM sc1.v_seq;

-- Test 341: query (line 1696)
SELECT * FROM sc2.v_type;

-- Test 342: query (line 1701)
SELECT * FROM sc2.v_seq;

-- Test 343: statement (line 1706)
ALTER SCHEMA sc1 RENAME TO sc1_new;

-- Test 344: statement (line 1709)
DROP VIEW sc1.v_tbl;

-- Test 345: statement (line 1712)
ALTER SCHEMA sc1 RENAME TO sc1_new;

-- Test 346: statement (line 1715)
DROP VIEW sc2.v_tbl;

-- Test 347: statement (line 1718)
ALTER SCHEMA sc1 RENAME TO sc1_new;

-- Test 348: query (line 1722)
SELECT * FROM sc1_new.v_type;

-- Test 349: query (line 1727)
SELECT * FROM sc1_new.v_seq;

-- Test 350: query (line 1732)
SELECT * FROM sc2.v_type;

-- Test 351: query (line 1737)
SELECT * FROM sc2.v_seq;

-- Test 352: statement (line 1742)
SET search_path = test, public;

-- Test 353: statement (line 1747)
CREATE SCHEMA IF NOT EXISTS tdb_seq_select;
SET search_path = tdb_seq_select, public;

-- Test 354: statement (line 1751)
CREATE SCHEMA sc;
CREATE SEQUENCE sc.sq;
CREATE VIEW v AS SELECT last_value FROM sc.sq;

-- Test 355: query (line 1756)
SELECT * FROM v;

-- Test 356: statement (line 1761)
ALTER SEQUENCE sc.sq RENAME TO sq_new;

-- Test 357: statement (line 1764)
SELECT * FROM v;

-- Test 358: statement (line 1767)
ALTER SEQUENCE sc.sq_new RENAME TO sq;
SELECT * FROM v;

-- Test 359: statement (line 1771)
ALTER SCHEMA sc RENAME TO sc_new;

-- Test 360: statement (line 1774)
SELECT * FROM v;

-- Test 361: statement (line 1777)
ALTER SCHEMA sc_new RENAME TO sc;
SELECT * FROM v;

-- Test 362: statement (line 1781)
ALTER SCHEMA tdb_seq_select RENAME TO tdb_seq_select_new;
SET search_path = tdb_seq_select_new, public;

-- Test 363: statement (line 1785)
SELECT * FROM v;

-- Test 364: statement (line 1788)
ALTER SCHEMA tdb_seq_select_new RENAME TO tdb_seq_select;
SET search_path = tdb_seq_select, public;
SELECT * FROM v;

-- Test 365: statement (line 1793)
SET search_path = test, public;

-- Test 366: statement (line 1800)
CREATE TABLE films (id int PRIMARY KEY, title text, kind text, classification CHAR(1));

-- Test 367: statement (line 1803)
CREATE VIEW comedies AS
    SELECT *
    FROM films
    WHERE kind = 'Comedy';

-- Test 368: statement (line 1809)
CREATE VIEW pg_comedies AS
    SELECT *
    FROM comedies
    WHERE classification = 'PG';

-- Test 369: statement (line 1822)
CREATE TABLE t (a INT PRIMARY KEY, b INT);

-- Test 370: statement (line 1825)
CREATE VIEW cd_v1 AS SELECT a, b FROM t;

-- Test 371: statement (line 1828)
CREATE VIEW cd_v2 AS SELECT a, b FROM cd_v1;

-- Test 372: statement (line 1833)
CREATE OR REPLACE VIEW cd_v1 AS SELECT a, b FROM cd_v2;

-- Test 373: statement (line 1836)
CREATE VIEW cd_v3 AS SELECT a, b FROM cd_v2;

-- Test 374: statement (line 1839)
SELECT * FROM cd_v3;

-- Test 375: statement (line 1842)
CREATE OR REPLACE VIEW cd_v1 AS SELECT a, b FROM cd_v3;

-- Test 376: statement (line 1845)
SELECT * FROM cd_v3;

-- Test 377: statement (line 1848)
DROP VIEW cd_v1;

-- Test 378: statement (line 1851)
DROP VIEW cd_v1 CASCADE;

-- Test 379: query (line 1867)
SELECT json_agg(r) FROM (
  SELECT i, s
  FROM t104927
) AS r;

-- Test 380: statement (line 1875)
CREATE VIEW v104927 AS SELECT json_agg(r) FROM (
  SELECT i, s
  FROM t104927
) AS r;

-- Test 381: query (line 1882)
SELECT * FROM v104927;

-- Test 382: statement (line 1893)
CREATE TYPE e105259 AS ENUM ('foo');

-- Test 383: statement (line 1896)
CREATE VIEW v AS
SELECT (SELECT 'foo')::e105259;

-- Test 384: statement (line 1900)
CREATE VIEW v AS
SELECT (
  CASE WHEN true THEN (SELECT 'foo') ELSE NULL END
)::e105259;

-- Test 385: statement (line 1912)
-- SET CLUSTER SETTING sql.cross_db_views.enabled = FALSE

-- Test 386: statement (line 1915)
CREATE SCHEMA IF NOT EXISTS db106602a;

-- Test 387: statement (line 1918)
CREATE SCHEMA IF NOT EXISTS db106602b;

-- Test 388: statement (line 1921)
SET search_path = db106602a, public;

-- Test 389: statement (line 1924)
CREATE TYPE e AS ENUM ('foo');

-- Test 390: statement (line 1927)
SET search_path = db106602b, public;

-- Test 391: statement (line 1930)
CREATE VIEW v AS (SELECT 1);

-- Test 392: statement (line 1933)
CREATE OR REPLACE VIEW v AS (SELECT 1 FROM (VALUES (1)) val(i) WHERE 'foo'::db106602a.e = 'foo'::db106602a.e);

-- Test 393: statement (line 1940)
CREATE VIEW v128535 AS SELECT json_to_tsvector();

-- Test 394: statement (line 1945)
SET allow_view_with_security_invoker_clause = on;

-- Test 395: query (line 1948)
show session allow_view_with_security_invoker_clause;
