-- PostgreSQL compatible tests from new_schema_changer
-- 368 tests
--
-- PG-NOT-SUPPORTED: This file exercises CockroachDB's declarative schema changer
-- and cross-database DDL semantics that do not exist in PostgreSQL.
--
-- The original CockroachDB-derived SQL is preserved below for reference, but is
-- not executed under PostgreSQL.

SET client_min_messages = warning;

SELECT
  'skipped: new_schema_changer requires CockroachDB declarative schema changer and cross-database DDL semantics'
    AS notice;

RESET client_min_messages;

/*
-- PostgreSQL compatible tests from new_schema_changer
-- 368 tests

SET client_min_messages = warning;
\set ON_ERROR_STOP 0

-- Test 1: statement (line 7)
-- SET use_declarative_schema_changer = 'on'

-- Test 2: statement (line 10)
CREATE TABLE foo (i INT PRIMARY KEY);

-- Test 3: statement (line 13)
-- EXPLAIN (DDL) ALTER TABLE foo ADD COLUMN j INT

-- Test 4: statement (line 16)
-- SET use_declarative_schema_changer = 'unsafe'

-- Test 5: statement (line 19)
ALTER TABLE foo ADD COLUMN j INT;

-- Test 6: statement (line 22)
INSERT INTO foo VALUES (1, 1);

-- Test 7: query (line 25)
SELECT * FROM foo;

-- Test 8: statement (line 30)
DROP TABLE foo;

-- Test 9: statement (line 35)
CREATE TABLE foo (i INT PRIMARY KEY);

-- Test 10: statement (line 38)
-- SET use_declarative_schema_changer = 'unsafe_always'

-- Test 11: statement (line 41)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- Test 12: statement (line 44)
ALTER TABLE foo ADD COLUMN j INT;

-- Test 13: statement (line 47)
ALTER TABLE foo ADD COLUMN k INT;

-- Test 14: statement (line 50)
COMMIT;

-- Test 15: statement (line 53)
INSERT INTO foo VALUES (1, 2, 3);

-- Test 16: query (line 56)
SELECT * FROM foo;

-- Test 17: statement (line 61)
-- SET use_declarative_schema_changer = 'unsafe'

-- Test 18: statement (line 64)
DROP TABLE foo;

-- Test 19: statement (line 69)
CREATE TABLE foo (i INT PRIMARY KEY);

-- Test 20: statement (line 72)
INSERT INTO foo(i) VALUES (0);

-- Test 21: query (line 75)
SELECT * FROM foo;

-- Test 22: statement (line 80)
ALTER TABLE foo ADD COLUMN j INT DEFAULT 1;

-- Test 23: statement (line 83)
INSERT INTO foo VALUES (1, 1);

-- Test 24: statement (line 86)
INSERT INTO foo(i) VALUES (2);

-- Test 25: query (line 89)
SELECT * FROM foo;

-- Test 26: statement (line 96)
DROP TABLE foo;

-- Test 27: statement (line 101)
CREATE TABLE foo (i INT PRIMARY KEY);

-- Test 28: statement (line 104)
INSERT INTO foo VALUES (0);

-- Test 29: statement (line 107)
ALTER TABLE foo ADD COLUMN j INT AS (i+1) STORED;

-- Test 30: statement (line 110)
INSERT INTO foo(i) VALUES (1);

-- Test 31: query (line 113)
SELECT * FROM foo;

-- Test 32: statement (line 119)
DROP TABLE foo;

-- Test 33: statement (line 124)
CREATE TABLE foo (i INT PRIMARY KEY);

-- Test 34: statement (line 127)
ALTER TABLE foo ADD COLUMN j INT CREATE FAMILY f2;

-- Test 35: statement (line 130)
ALTER TABLE foo ADD COLUMN k INT FAMILY f2;

-- Test 36: statement (line 133)
INSERT INTO foo VALUES (1, 2, 3);

-- Test 37: query (line 136)
SELECT * FROM foo;

-- Test 38: statement (line 141)
DROP TABLE foo;

-- Test 39: statement (line 146)
CREATE TABLE foo (i INT PRIMARY KEY);
CREATE TABLE bar (j INT PRIMARY KEY);

-- Test 40: statement (line 150)
-- SET use_declarative_schema_changer = 'unsafe_always'

-- Test 41: statement (line 153)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- Test 42: statement (line 156)
ALTER TABLE foo ADD COLUMN a INT;

-- Test 43: statement (line 159)
ALTER TABLE bar ADD COLUMN b INT;

-- Test 44: statement (line 162)
COMMIT;

-- Test 45: statement (line 165)
INSERT INTO foo VALUES (1, 2);

-- Test 46: query (line 168)
SELECT * FROM foo;

-- Test 47: statement (line 174)
INSERT INTO bar VALUES (3, 4);

-- Test 48: query (line 177)
SELECT * FROM bar;

-- Test 49: statement (line 183)
-- SET use_declarative_schema_changer = 'unsafe'

-- Test 50: statement (line 186)
DROP TABLE foo, bar;

-- Test 51: statement (line 190)
CREATE SEQUENCE sq1;

-- Test 52: statement (line 193)
CREATE TABLE blog_posts (id INT PRIMARY KEY, val int DEFAULT nextval('sq1'), title text);

-- Test 53: statement (line 196)
CREATE TABLE blog_posts2 (id INT PRIMARY KEY, val int DEFAULT nextval('sq1'), title text);

-- Test 54: statement (line 200)
-- EXPLAIN (DDL) DROP SEQUENCE sq1;

-- Test 55: statement (line 203)
-- EXPLAIN (DDL) DROP SEQUENCE sq1 CASCADE;

-- Test 56: statement (line 207)
DROP SEQUENCE IF EXISTS doesnotexist, sq1 CASCADE;

-- Test 57: statement (line 211)
DROP TABLE blog_posts;

-- Test 58: statement (line 214)
DROP TABLE blog_posts2;

-- Test 59: statement (line 220)
CREATE TYPE typ AS ENUM('a');

-- Test 60: statement (line 226)
DROP TYPE typ;

-- Test 61: statement (line 229)
DROP VIEW v;

-- Test 62: statement (line 232)
CREATE VIEW v AS (WITH r AS (SELECT 'a'::typ < 'a'::typ AS k) SELECT k FROM r);

-- Test 63: statement (line 235)
DROP TYPE typ;

-- Test 64: statement (line 238)
DROP VIEW v;

-- Test 65: statement (line 244)
CREATE VIEW v AS (SELECT i FROM t);

-- Test 66: statement (line 248)
DROP TYPE typ;

-- Test 67: statement (line 251)
CREATE VIEW v_dep AS (SELECT k FROM t);

-- Test 68: statement (line 255)
DROP TYPE typ;

-- Test 69: statement (line 258)
CREATE TYPE typ2 AS ENUM('a');

-- Test 70: statement (line 264)
DROP TYPE typ2;

-- Test 71: statement (line 267)
CREATE OR REPLACE VIEW v3 AS (SELECT 'a' AS k);

-- Test 72: statement (line 270)
DROP TYPE typ2;

-- Test 73: statement (line 273)
CREATE TYPE typ2 AS ENUM('a');

-- Test 74: statement (line 279)
DROP TYPE typ2;

-- Test 75: statement (line 282)
ALTER TYPE typ2 RENAME TO typ3;

-- Test 76: statement (line 285)
DROP TYPE typ3;

-- Test 77: statement (line 288)
CREATE TYPE typ4 AS ENUM('a');

-- Test 78: statement (line 291)
CREATE TABLE t4 (i INT, j typ4);

-- Test 79: statement (line 294)
CREATE VIEW v4 AS (SELECT i FROM t4);

-- Test 80: statement (line 298)
DROP TYPE typ4;

-- Test 81: statement (line 301)
ALTER TABLE t4 DROP COLUMN j;

-- Test 82: statement (line 304)
DROP TYPE typ4;

-- Test 83: statement (line 307)
CREATE TYPE typ4 AS ENUM('a');

-- Test 84: statement (line 310)
ALTER TABLE t4 ADD COLUMN j typ4;

-- Test 85: statement (line 313)
CREATE VIEW v4_dep AS (SELECT j FROM t4);

-- Test 86: statement (line 317)
DROP type typ4;

-- Test 87: statement (line 320)
CREATE TYPE typ5 AS ENUM('a');

-- Test 88: statement (line 327)
CREATE VIEW v5 AS (SELECT i FROM t5);

-- Test 89: statement (line 330)
DROP TYPE typ5;

-- Test 90: statement (line 333)
CREATE VIEW v5_dep AS (SELECT j FROM t5);

-- Test 91: statement (line 337)
DROP TYPE typ5;

-- Test 92: statement (line 340)
CREATE VIEW v6 AS (SELECT j FROM v4_dep);

-- Test 93: statement (line 344)
DROP TYPE typ4;

-- Test 94: statement (line 347)
CREATE TYPE typ6 AS ENUM('a');
CREATE TABLE t6 (i INT, k typ6);
CREATE INDEX idx ON t6 (i) WHERE k < 'a'::typ6;

-- Test 95: statement (line 352)
CREATE VIEW v7 AS (SELECT i FROM t6);

-- Test 96: statement (line 356)
DROP TYPE typ6;

-- Test 97: statement (line 359)
CREATE VIEW v7_dep AS (SELECT i FROM t6@idx WHERE k < 'a'::typ6);

-- Test 98: statement (line 363)
DROP TYPE typ6;

-- Test 99: statement (line 369)
CREATE TABLE t1 (id INT PRIMARY KEY, name varchar(256));

-- Test 100: statement (line 372)
CREATE VIEW v1Dep AS (SELECT name FROM t1);

-- Test 101: statement (line 375)
CREATE VIEW v2Dep AS (SELECT name AS N1, name AS N2 FROM v1Dep);

-- Test 102: statement (line 378)
CREATE VIEW v3Dep AS (SELECT name, n1 FROM v1Dep, v2Dep);

-- Test 103: statement (line 381)
CREATE VIEW v4Dep AS (SELECT n2, n1 FROM v2Dep);

-- Test 104: statement (line 384)
-- EXPLAIN (DDL) DROP VIEW v1Dep CASCADE;

-- Test 105: statement (line 387)
DROP VIEW v1Dep RESTRICT;

-- Test 106: statement (line 390)
DROP MATERIALIZED VIEW v1Dep;

-- Test 107: statement (line 393)
DROP VIEW v1Dep CASCADE;

-- Test 108: statement (line 396)
SELECT * FROM v4Dep;

-- Test 109: statement (line 399)
SELECT * FROM v3Dep;

-- Test 110: statement (line 402)
SELECT * FROM v2Dep;

-- Test 111: statement (line 405)
SELECT * FROM v1Dep;

-- Test 112: statement (line 408)
CREATE MATERIALIZED VIEW mv AS SELECT name FROM t1;

-- Test 113: statement (line 411)
DROP VIEW mv;

-- Test 114: statement (line 414)
DROP MATERIALIZED VIEW mv;

-- Test 115: statement (line 420)
CREATE TABLE IF NOT EXISTS defaultdb.orders (
    id INT PRIMARY KEY,
    customer INT UNIQUE NOT NULL REFERENCES defaultdb.customers (id),
    orderTotal DECIMAL(9,2),
    INDEX (customer)
  );

-- Test 116: statement (line 428)
CREATE SEQUENCE defaultdb.sq2;

-- Test 117: statement (line 442)
DROP TABLE defaultdb.customers;

-- Test 118: statement (line 445)
CREATE SEQUENCE defaultdb.sq1 OWNED BY defaultdb.shipments.carrier;

-- Test 119: statement (line 448)
CREATE TABLE defaultdb.sq1dep (
	rand_col INT8 DEFAULT nextval('defaultdb.sq1')
);

-- Test 120: statement (line 453)
DROP TABLE defaultdb.shipments;

-- Test 121: statement (line 456)
DROP TABLE defaultdb.sq1dep;
DROP TABLE defaultdb.shipments;

-- Test 122: statement (line 471)
CREATE VIEW defaultdb.v1 as (select customer_id, carrier from defaultdb.shipments);

-- Test 123: statement (line 474)
DROP TABLE defaultdb.shipments;

-- Test 124: statement (line 477)
DROP TABLE defaultdb.shipments CASCADE;

-- Test 125: statement (line 482)
DROP TABLE defaultdb.customers CASCADE;

-- Test 126: statement (line 488)
-- SET use_declarative_schema_changer = 'unsafe_always'

-- Test 127: statement (line 491)
-- SET use_declarative_schema_changer = 'unsafe'

-- Test 128: statement (line 495)
CREATE TYPE typ8 AS ENUM ('hello');
DROP TYPE typ8;

-- Test 129: statement (line 499)
CREATE TYPE typ8 AS ENUM ('hello');

-- Test 130: statement (line 504)
CREATE TABLE t8 (x typ8);

-- Test 131: statement (line 507)
DROP TYPE typ8;

-- Test 132: statement (line 511)
ALTER TABLE t8 ADD COLUMN y typ8;

-- Test 133: statement (line 514)
DROP TYPE typ8;

-- Test 134: statement (line 518)
ALTER TABLE t8 DROP COLUMN x;

-- Test 135: statement (line 521)
DROP TYPE typ8;

-- Test 136: statement (line 525)
ALTER TABLE t8 DROP COLUMN y;

-- Test 137: statement (line 528)
DROP TYPE typ8;

-- Test 138: statement (line 532)
CREATE TYPE typ8 AS ENUM ('hello');
ALTER TABLE t8 ADD COLUMN x typ8[];

-- Test 139: statement (line 536)
DROP TYPE typ8;

-- Test 140: statement (line 539)
ALTER TABLE t8 DROP COLUMN x;

-- Test 141: statement (line 542)
DROP TYPE typ8;

-- Test 142: statement (line 547)
CREATE TYPE defaultdb.typ AS ENUM('a');

-- Test 143: statement (line 550)
CREATE TABLE defaultdb.ttyp (id INT PRIMARY KEY, name varchar(256), x defaultdb.typ);

-- Test 144: statement (line 553)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- Test 145: statement (line 556)
DROP TABLE defaultdb.ttyp;

-- Test 146: statement (line 559)
DROP TYPE defaultdb.typ;

-- Test 147: query (line 566)
SELECT count(*)
  FROM information_schema.tables
 WHERE table_schema = 'public'
   AND table_name LIKE '%typ%';

-- Test 148: query (line 574)
SELECT name, state
     FROM crdb_internal.tables
    WHERE schema_name = 'public'
      AND name LIKE '%typ%'
 ORDER BY name;

-- Test 149: statement (line 583)
COMMIT;

-- Test 150: statement (line 589)
CREATE DATABASE db1;

-- Test 151: statement (line 592)
CREATE SCHEMA db1.sc1;

-- Test 152: statement (line 595)
CREATE SEQUENCE db1.sc1.sq1;

-- Test 153: statement (line 598)
CREATE TABLE db1.sc1.t1 (id INT PRIMARY KEY, name varchar(256), val int DEFAULT nextval('db1.sc1.sq1'));

-- Test 154: statement (line 601)
CREATE VIEW db1.sc1.v1 AS (SELECT name FROM db1.sc1.t1);

-- Test 155: statement (line 604)
CREATE VIEW db1.sc1.v2 AS (SELECT name AS n1, name AS n2 FROM db1.sc1.v1);

-- Test 156: statement (line 607)
CREATE VIEW db1.sc1.v3 AS (SELECT name, n1 FROM db1.sc1.v1, db1.sc1.v2);

-- Test 157: statement (line 610)
CREATE VIEW db1.sc1.v4 AS (SELECT n2, n1 FROM db1.sc1.v2);

-- Test 158: statement (line 613)
CREATE TYPE db1.sc1.typ AS ENUM('a');

-- Test 159: statement (line 619)
CREATE SCHEMA sc2;

-- Test 160: statement (line 622)
CREATE TYPE sc2.typ AS ENUM('a');

-- Test 161: statement (line 629)
DROP SCHEMA db1.sc1 CASCADE;

-- Test 162: statement (line 632)
DROP SCHEMA sc2 CASCADE;

-- Test 163: statement (line 635)
DROP DATABASE db1 CASCADE;

-- Test 164: statement (line 641)
CREATE ROLE test_set_role;

-- Test 165: statement (line 644)
CREATE DATABASE db1;

-- Test 166: statement (line 647)
ALTER ROLE test_set_role SET application_name = 'a';
ALTER ROLE test_set_role IN DATABASE db1 SET application_name = 'b';
ALTER ROLE ALL IN DATABASE db1 SET application_name = 'c';
ALTER ROLE ALL SET application_name = 'd';
ALTER ROLE test_set_role SET custom_option.setting = 'e';

-- Test 167: statement (line 654)
CREATE SCHEMA db1.sc1;

-- Test 168: statement (line 657)
CREATE SEQUENCE db1.public.sq1;

-- Test 169: statement (line 660)
CREATE SEQUENCE db1.sc1.sq1;

-- Test 170: statement (line 663)
CREATE TABLE db1.sc1.t1 (id INT PRIMARY KEY, name varchar(256), val int DEFAULT nextval('db1.sc1.sq1'));

-- Test 171: statement (line 666)
CREATE TABLE db1.public.t1 (id INT PRIMARY KEY, name varchar(256), val int DEFAULT nextval('db1.public.sq1'));

-- Test 172: statement (line 669)
CREATE VIEW db1.sc1.v1 AS (SELECT name FROM db1.sc1.t1);

-- Test 173: statement (line 672)
CREATE VIEW db1.sc1.v2 AS (SELECT name AS n1, name AS n2 FROM db1.sc1.v1);

-- Test 174: statement (line 675)
CREATE VIEW db1.sc1.v3 AS (SELECT name, n1 FROM db1.sc1.v1, db1.sc1.v2);

-- Test 175: statement (line 678)
CREATE VIEW db1.sc1.v4 AS (SELECT n2, n1 FROM db1.sc1.v2);

-- Test 176: statement (line 681)
CREATE INDEX tmp_idx ON db1.sc1.t1(name);

-- Test 177: statement (line 684)
use db1;

-- Test 178: statement (line 687)
COMMENT ON DATABASE db1 IS 'BLAH';
COMMENT ON SCHEMA sc1 IS 'BLAH2';
COMMENT ON TABLE db1.sc1.t1 IS 'BLAH3';
COMMENT ON COLUMN db1.sc1.t1.id IS 'BLAH4';
COMMENT ON INDEX db1.sc1.tmp_idx IS 'BLAH5';
use test;

-- Test 179: statement (line 695)
CREATE TYPE db1.sc1.typ AS ENUM('a');

-- Test 180: statement (line 701)
CREATE SCHEMA sc2;

-- Test 181: statement (line 704)
CREATE TYPE sc2.typ AS ENUM('a');

-- Test 182: query (line 712)
SELECT comment FROM system.comments ORDER BY comment ASC;

-- Test 183: query (line 723)
SELECT name, role_name, settings
    FROM system.database_role_settings
         LEFT JOIN system.namespace AS ns ON database_id = ns.id
ORDER BY name, role_name;

-- Test 184: statement (line 735)
DROP SCHEMA db1.sc1;

-- Test 185: statement (line 738)
DROP DATABASE db1 RESTRICT;

-- Test 186: statement (line 741)
-- SET use_declarative_schema_changer = 'unsafe_always'

-- Test 187: statement (line 746)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- Test 188: statement (line 749)
SET LOCAL autocommit_before_ddl=off;

-- Test 189: statement (line 752)
DROP DATABASE db1 CASCADE;

-- Test 190: statement (line 755)
SELECT * from db1.sc1.v1;

-- Test 191: statement (line 758)
ROLLBACK;

-- Test 192: statement (line 761)
SELECT * from db1.sc1.v1;

-- Test 193: statement (line 764)
SELECT * from db1.sc1.t1;

-- Test 194: statement (line 767)
SELECT * from db1.sc1.sq1;

-- Test 195: statement (line 773)
-- SET use_declarative_schema_changer = 'unsafe'

let $db1_id
SELECT id FROM system.namespace WHERE name = 'db1' AND "parentID" = 0 LIMIT 1;

-- Test 196: statement (line 785)
DROP DATABASE db1 CASCADE;

-- Test 197: statement (line 788)
DROP SCHEMA sc2 CASCADE;

-- Test 198: query (line 792)
SELECT comment FROM system.comments ORDER BY comment ASC;

-- Test 199: query (line 797)
SELECT database_id, role_name, settings FROM system.database_role_settings ORDER BY 1, 2;

-- Test 200: query (line 813)
select $desc_count_pre_drop-$desc_count_post_drop;

-- Test 201: statement (line 819)
CREATE TABLE trewrite(k INT PRIMARY KEY, ts TIMESTAMPTZ, FAMILY (k,ts));

-- Test 202: query (line 832)
SELECT create_statement FROM [SHOW CREATE TABLE trewrite];

-- Test 203: query (line 844)
SELECT create_statement FROM [SHOW CREATE TABLE trewrite];

-- Test 204: statement (line 857)
CREATE TABLE tIndex (
  a INT PRIMARY KEY,
  b INT,
  FAMILY (a),
  FAMILY (b)
);

-- Test 205: statement (line 865)
INSERT INTO tIndex VALUES (1,1);

user root;

-- Test 206: statement (line 870)
CREATE INDEX foo ON tIndex (b);

-- Test 207: statement (line 873)
CREATE INDEX foo ON tIndex (a);

-- Test 208: statement (line 876)
CREATE INDEX bar ON tIndex (c);

-- Test 209: statement (line 879)
CREATE INDEX bar ON tIndex (b, b);

-- Test 210: statement (line 882)
CREATE INDEX bar ON tIndex ((a+b));

-- Test 211: statement (line 885)
CREATE INDEX bar2 ON tIndex (abs(b));

-- Test 212: statement (line 888)
CREATE UNIQUE INDEX bar3 ON tIndex (abs(b));

-- Test 213: statement (line 891)
CREATE INVERTED INDEX bar4 ON tIndex ((ARRAY[a,b]));

-- Test 214: statement (line 894)
CREATE TABLE tIndx2 (a INT PRIMARY KEY, b INT, INDEX ((a+b)));

-- Test 215: statement (line 897)
CREATE TABLE tIndx3 (a INT PRIMARY KEY, b INT, INVERTED INDEX ((ARRAY[a,b])));

-- Test 216: query (line 900)
SHOW INDEXES FROM tIndex;

-- Test 217: statement (line 917)
INSERT INTO tIndex VALUES (2,1);

-- Test 218: statement (line 920)
INSERT INTO tIndex VALUES (20000,10000);

-- Test 219: query (line 927)
SHOW INDEXES FROM tIndex;

-- Test 220: statement (line 946)
DROP TABLE tIndex;

-- Test 221: statement (line 949)
CREATE TABLE tIndx (
  a INT PRIMARY KEY,
  b INT,
  c INT
);

-- Test 222: statement (line 956)
INSERT INTO tIndx VALUES (1,1,1), (2,2,2);

-- Test 223: statement (line 959)
CREATE INDEX b_desc ON tIndx (b DESC);

-- Test 224: statement (line 962)
CREATE INDEX b_asc ON tIndx (b ASC, c DESC);

-- Test 225: query (line 965)
SHOW INDEXES FROM tIndx;

-- Test 226: statement (line 978)
CREATE INDEX fail ON foo (b DESC);

-- Test 227: statement (line 981)
CREATE VIEW vIndx AS SELECT a,b FROM tIndx;

-- Test 228: statement (line 984)
CREATE INDEX failview ON vIndx (b DESC);

-- Test 229: statement (line 987)
CREATE TABLE privs (a INT PRIMARY KEY, b INT);

user testuser;

skipif config local-legacy-schema-changer;

-- Test 230: statement (line 993)
CREATE INDEX foo ON privs (b);

onlyif config local-legacy-schema-changer;

-- Test 231: statement (line 997)
CREATE INDEX foo ON privs (b);

user root;

-- Test 232: query (line 1002)
SHOW INDEXES FROM privs;

-- Test 233: statement (line 1009)
GRANT CREATE ON privs TO testuser;

user testuser;

-- Test 234: statement (line 1014)
CREATE INDEX foo ON privs (b);

-- Test 235: query (line 1017)
SHOW INDEXES FROM privs;

-- Test 236: statement (line 1028)
CREATE TABLE telemetry (
  x INT PRIMARY KEY,
  y INT,
  z JSONB
);

-- Test 237: statement (line 1039)
CREATE TABLE create_idx_drop_column (c0 INT PRIMARY KEY, c1 INT);

-- Test 238: statement (line 1042)
begin; ALTER TABLE create_idx_drop_column DROP COLUMN c1;

-- Test 239: statement (line 1045)
CREATE INDEX idx_create_idx_drop_column ON create_idx_drop_column (c1);

-- Test 240: statement (line 1048)
ROLLBACK;

-- Test 241: statement (line 1051)
DROP TABLE create_idx_drop_column;

-- Test 242: statement (line 1058)
CREATE TABLE t1dr(name varchar(256));

-- Test 243: statement (line 1061)
CREATE VIEW v1dr as (select name from t1dr);

-- Test 244: statement (line 1064)
CREATE SEQUENCE s1dr;

-- Test 245: statement (line 1067)
DROP VIEW t1dr;

-- Test 246: statement (line 1070)
DROP SEQUENCE t1dr;

-- Test 247: statement (line 1073)
DROP TABLE v1dr;

-- Test 248: statement (line 1076)
DROP SEQUENCE v1dr;

-- Test 249: statement (line 1079)
DROP VIEW s1dr;

-- Test 250: statement (line 1082)
DROP TABLE s1dr;

-- Test 251: statement (line 1088)
-- SET use_declarative_schema_changer = 'unsafe'

-- Test 252: statement (line 1091)
set sql_safe_updates=false;

-- Test 253: statement (line 1094)
CREATE TABLE t1ev(name varchar(256));

-- Test 254: statement (line 1097)
CREATE TABLE t2ev(name varchar(256));

-- Test 255: statement (line 1100)
CREATE VIEW v1ev AS (SELECT name FROM t1ev);

-- Test 256: statement (line 1103)
CREATE VIEW v2ev AS (SELECT name FROM t2ev);

-- Test 257: statement (line 1106)
CREATE VIEW v4ev AS (SELECT name FROM V1EV);

-- Test 258: statement (line 1109)
CREATE VIEW v3ev AS (SELECT name FROM V2EV);

-- Test 259: statement (line 1112)
DELETE FROM system.eventlog;

-- Test 260: statement (line 1115)
DROP VIEW v1ev CASCADE;

-- Test 261: query (line 1118)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp' - 'LatencyNanos'
FROM system.eventlog
ORDER BY "timestamp", info DESC;

-- Test 262: statement (line 1127)
SELECT 1 / coalesce((info::JSONB->'LatencyNanos')::INT, 0) FROM system.eventlog
WHERE "eventType" = 'finish_schema_change';

-- Test 263: statement (line 1131)
CREATE VIEW v1ev AS (SELECT name FROM T1EV);

-- Test 264: statement (line 1134)
CREATE VIEW v4ev AS (SELECT name FROM V1EV);

-- Test 265: statement (line 1137)
DELETE FROM system.eventlog;

-- Test 266: statement (line 1140)
DROP TABLE t1ev,t2ev CASCADE;

-- Test 267: query (line 1143)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp' - 'LatencyNanos'
FROM system.eventlog
ORDER BY timestamp, info DESC;

-- Test 268: statement (line 1153)
CREATE TABLE fooev (i INT PRIMARY KEY);

-- Test 269: statement (line 1156)
DELETE FROM system.eventlog;

-- Test 270: statement (line 1159)
ALTER TABLE fooev ADD COLUMN j INT;

-- Test 271: query (line 1162)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp' - 'LatencyNanos'
FROM system.eventlog
ORDER BY timestamp, info DESC;

-- Test 272: statement (line 1175)
CREATE DATABASE "'db1-a'";

-- Test 273: statement (line 1178)
CREATE SCHEMA "'db1-a'".sc1;

-- Test 274: statement (line 1181)
CREATE SCHEMA "'db1-a'".sc2;

-- Test 275: statement (line 1184)
CREATE DATABASE db2;

-- Test 276: statement (line 1187)
CREATE SCHEMA db2.sc3;

-- Test 277: statement (line 1192)
CREATE TABLE "'db1-a'"."'t1-esc'"(name int);

-- Test 278: statement (line 1195)
CREATE INDEX "'t1-esc-index'" ON "'db1-a'"."'t1-esc'"(name);

-- Test 279: statement (line 1198)
CREATE INDEX "'t1-esc-index'" ON "'db1-a'"."'t1-esc'"(name);

-- Test 280: statement (line 1201)
delete from system.eventlog;

-- Test 281: statement (line 1204)
DROP DATABASE "'db1-a'" cascade;

-- Test 282: statement (line 1207)
DROP DATABASE db2 cascade;

-- Test 283: query (line 1210)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp' - 'LatencyNanos'
FROM system.eventlog
ORDER BY timestamp, info DESC;

-- Test 284: statement (line 1224)
CREATE TABLE multi_t1 (name INTEGER PRIMARY KEY);
CREATE TABLE multi_t2 (name INTEGER, other INTEGER, FOREIGN KEY (other) REFERENCES multi_t1(name));
CREATE VIEW multi_v1 AS (SELECT name FROM multi_t1);
CREATE VIEW multi_v2 AS (SELECT name FROM multi_v1);

-- Test 285: statement (line 1230)
CREATE SEQUENCE multi_sq1;

-- Test 286: statement (line 1233)
DROP VIEW multi_v1, multi_v2;

-- Test 287: statement (line 1236)
DROP TABLE multi_t1,multi_t2;

-- Test 288: statement (line 1239)
DROP SEQUENCE multi_sq1, multi_sq1;

-- Test 289: statement (line 1245)
CREATE SEQUENCE sqbf1;

-- Test 290: statement (line 1248)
CREATE TABLE sbt1 (test INT not null, value INT not null DEFAULT nextval('sqbf1'));

-- Test 291: statement (line 1251)
CREATE VIEW sbv1 AS SELECT  nextval('sqbf1');

-- Test 292: statement (line 1254)
INSERT into sbt1 VALUES(1);

-- Test 293: statement (line 1257)
select * from sbv1;

-- Test 294: statement (line 1260)
DROP SEQUENCE sqbf1 CASCADE;

-- Test 295: statement (line 1264)
INSERT into sbt1 VALUES(1);

-- Test 296: statement (line 1268)
select * from sbv1;

-- Test 297: statement (line 1272)
CREATE TABLE IF NOT EXISTS defaultdb.orders (
    id INT PRIMARY KEY,
    customer INT UNIQUE NOT NULL REFERENCES defaultdb.customers (id),
    orderTotal DECIMAL(9,2),
    INDEX (customer)
  );

-- Test 298: statement (line 1304)
DROP TABLE defaultdb.shipments CASCADE;

-- Test 299: statement (line 1311)
CREATE TABLE const (a INT, b INT,
CONSTRAINT id_unique UNIQUE (a),
CONSTRAINT b_unique UNIQUE (b)
);

-- Test 300: statement (line 1317)
DROP TABLE const;

-- Test 301: statement (line 1326)
CREATE SCHEMA scdrop1;
CREATE SCHEMA scdrop2;
CREATE SCHEMA scdrop3;
CREATE TABLE scdrop1.scdrop1_t1 (x INT);
CREATE TABLE scdrop1.scdrop1_t2 (x INT);
CREATE TABLE scdrop2.scdrop2_t1 (x INT);
CREATE VIEW scdrop2.scdrop2_v1 AS SELECT x FROM scdrop1.scdrop1_t1;
CREATE VIEW scdrop3.scdrop3_v1 AS SELECT x FROM scdrop2.scdrop2_v1;

-- Test 302: statement (line 1336)
DROP SCHEMA scdrop1, scdrop2, scdrop3 CASCADE;

-- Test 303: statement (line 1343)
CREATE TABLE seqowner(name int);

-- Test 304: statement (line 1346)
CREATE SEQUENCE seqowned OWNED BY seqowner.name;

-- Test 305: statement (line 1349)
DROP SEQUENCE seqowned;

-- Test 306: statement (line 1353)
DROP TABLE seqowner;

-- Test 307: statement (line 1372)
DROP TYPE d_tc;

-- Test 308: statement (line 1375)
DROP TABLE ttc1;

-- Test 309: statement (line 1378)
DROP TYPE d_tc;

-- Test 310: statement (line 1381)
DROP TABLE ttc2;

-- Test 311: statement (line 1384)
DROP TYPE d_tc;

-- Test 312: statement (line 1387)
DROP TABLE ttc3;

-- Test 313: statement (line 1390)
DROP TYPE d_tc;

-- Test 314: statement (line 1395)
DROP DATABASE "";

-- Test 315: statement (line 1402)
CREATE SCHEMA sc1;

-- Test 316: statement (line 1405)
CREATE DATABASE db1;

user testuser;

-- Test 317: statement (line 1410)
-- SET use_declarative_schema_changer = 'on'

-- Test 318: statement (line 1413)
DROP SCHEMA sc1;

-- Test 319: statement (line 1416)
DROP DATABASE db1;

-- Test 320: statement (line 1424)
CREATE UNIQUE INDEX idx ON parent (v);

-- Test 321: statement (line 1427)
CREATE VIEW child AS SELECT count(*) FROM parent@idx;

-- Test 322: statement (line 1430)
-- SET use_declarative_schema_changer = 'unsafe'

-- Test 323: statement (line 1433)
DROP INDEX parent@idx;

-- Test 324: statement (line 1436)
-- EXPLAIN (DDL) DROP INDEX parent@idx CASCADE;

-- Test 325: statement (line 1439)
-- SET use_declarative_schema_changer = 'on'

-- Test 326: statement (line 1446)
DROP DATABASE test CASCADE;

-- Test 327: statement (line 1449)
CREATE DATABASE test;
USE test;

-- Test 328: statement (line 1455)
CREATE TABLE t (i INT PRIMARY KEY);
INSERT INTO t VALUES (1), (2), (3);

-- Test 329: statement (line 1459)
-- SET use_declarative_schema_changer = 'unsafe_always';

-- Test 330: statement (line 1462)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- Test 331: statement (line 1465)
ALTER TABLE t ADD COLUMN k INT AS (i + 3) STORED NOT NULL UNIQUE;
ALTER TABLE t ADD COLUMN j INT DEFAULT 42;

-- Test 332: statement (line 1469)
COMMIT;

onlyif config schema-locked-disabled;

-- Test 333: query (line 1473)
SELECT create_statement FROM [SHOW CREATE TABLE t];

-- Test 334: query (line 1485)
SELECT create_statement FROM [SHOW CREATE TABLE t];

-- Test 335: query (line 1496)
SELECT * FROM t;

-- Test 336: statement (line 1505)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- Test 337: statement (line 1508)
CREATE SCHEMA sc;

-- Test 338: query (line 1511)
SHOW SCHEMAS;

-- Test 339: statement (line 1521)
DROP SCHEMA sc;

-- Test 340: query (line 1524)
SHOW SCHEMAS;

-- Test 341: statement (line 1533)
COMMIT;

-- Test 342: statement (line 1540)
-- SET use_declarative_schema_changer = 'on'

-- Test 343: statement (line 1543)
SET CLUSTER SETTING sql.schema.force_declarative_statements='!ALTER TABLE';

-- Test 344: statement (line 1546)
CREATE TABLE stmt_ctrl(n int primary key) WITH (schema_locked = false);

-- Test 345: statement (line 1549)
-- EXPLAIN (DDL) ALTER TABLE stmt_ctrl ADD COLUMN j BOOL

-- Test 346: statement (line 1552)
ALTER TABLE stmt_ctrl ADD COLUMN fallback_works BOOL;

-- Test 347: statement (line 1555)
SET CLUSTER SETTING sql.schema.force_declarative_statements='!CREATE SCHEMA';

-- Test 348: statement (line 1559)
-- EXPLAIN (DDL) CREATE SCHEMA schema1

-- Test 349: statement (line 1562)
SET CLUSTER SETTING sql.schema.force_declarative_statements='+CREATE SCHEMA';

-- Test 350: statement (line 1565)
-- EXPLAIN (DDL) CREATE SCHEMA sc1

-- Test 351: statement (line 1570)
SET CLUSTER SETTING sql.schema.force_declarative_statements='!ALTER TABLE ADD COLUMN';

-- Test 352: statement (line 1573)
CREATE TABLE stmt_ctrl_sub(n int primary key) WITH (schema_locked = false);

-- Test 353: statement (line 1577)
-- EXPLAIN (DDL) ALTER TABLE stmt_ctrl_sub ADD COLUMN disabled_col BOOL

-- Test 354: statement (line 1581)
ALTER TABLE stmt_ctrl_sub ADD COLUMN to_drop BOOL;

-- Test 355: statement (line 1584)
-- EXPLAIN (DDL) ALTER TABLE stmt_ctrl_sub DROP COLUMN to_drop

-- Test 356: statement (line 1588)
SET CLUSTER SETTING sql.schema.force_declarative_statements='!ALTER TABLE, +ALTER TABLE DROP COLUMN';

-- Test 357: statement (line 1592)
-- EXPLAIN (DDL) ALTER TABLE stmt_ctrl_sub ADD COLUMN still_disabled BOOL

-- Test 358: statement (line 1596)
ALTER TABLE stmt_ctrl_sub ADD COLUMN another_to_drop BOOL;

-- Test 359: statement (line 1599)
-- EXPLAIN (DDL) ALTER TABLE stmt_ctrl_sub DROP COLUMN another_to_drop

-- Test 360: statement (line 1603)
SET CLUSTER SETTING sql.schema.force_declarative_statements='!ALTER TABLE ADD COLUMN';

-- Test 361: statement (line 1607)
-- EXPLAIN (DDL) ALTER TABLE stmt_ctrl_sub ADD COLUMN mixed_col BOOL, DROP COLUMN another_to_drop

-- Test 362: statement (line 1611)
SET CLUSTER SETTING sql.schema.force_declarative_statements='!ALTER TABLE NONEXISTENT CMD';

-- Test 363: statement (line 1615)
SET CLUSTER SETTING sql.schema.force_declarative_statements='';

-- Test 364: statement (line 1618)
DROP TABLE stmt_ctrl_sub;

-- Test 365: statement (line 1626)
CREATE TABLE multiple_pk_attempt(n INT PRIMARY KEY, j INT);

let $use_decl_sc;
-- SHOW use_declarative_schema_changer

-- Test 366: statement (line 1632)
-- SET use_declarative_schema_changer = 'unsafe_always'

-- Test 367: statement (line 1635)
ALTER TABLE multiple_pk_attempt ADD PRIMARY KEY (j);

-- Test 368: statement (line 1638)
-- SET use_declarative_schema_changer = $use_decl_sc
*/
