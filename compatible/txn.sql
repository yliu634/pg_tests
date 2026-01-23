-- PostgreSQL compatible tests from txn
-- 415 tests

-- This file contains many CockroachDB-specific transactional tests. Keep the
-- script running across expected errors while adapting to PostgreSQL.
SET client_min_messages = warning;
\set ON_ERROR_STOP 0

-- CockroachDB builtin stub: deterministic and PostgreSQL-friendly.
CREATE OR REPLACE FUNCTION cluster_logical_timestamp() RETURNS BIGINT
LANGUAGE SQL
AS $$
  SELECT 0::bigint;
$$;

-- Test 1: statement (line 3)
BEGIN TRANSACTION;

-- Test 2: statement (line 6)
CREATE TABLE kv (
  k VARCHAR PRIMARY KEY,
  v VARCHAR
);

-- Test 3: statement (line 12)
INSERT INTO kv (k,v) VALUES ('a', 'b');

-- Test 4: query (line 15)
SELECT * FROM kv;

-- Test 5: statement (line 20)
COMMIT TRANSACTION;

-- Test 6: statement (line 25)
BEGIN TRANSACTION;

-- Test 7: statement (line 28)
UPDATE kv SET v = 'c' WHERE k in ('a');

-- Test 8: query (line 31)
SELECT * FROM kv;

-- Test 9: statement (line 36)
COMMIT TRANSACTION;

-- Test 10: query (line 39)
SELECT * FROM kv;

-- Test 11: statement (line 46)
BEGIN TRANSACTION;

-- Test 12: statement (line 49)
UPDATE kv SET v = 'b' WHERE k in ('a');

-- Test 13: query (line 52)
SELECT * FROM kv;

-- Test 14: statement (line 57)
ROLLBACK TRANSACTION;

-- Test 15: query (line 60)
SELECT * FROM kv;

-- Test 16: statement (line 67)
BEGIN TRANSACTION; UPDATE kv SET v = 'b' WHERE k in ('a');

-- Test 17: query (line 70)
SELECT * FROM kv;

-- Test 18: query (line 75)
SELECT * FROM kv; COMMIT; BEGIN; UPDATE kv SET v = 'd' WHERE k in ('a');

-- Test 19: query (line 80)
SELECT * FROM kv; UPDATE kv SET v = 'c' WHERE k in ('a'); COMMIT;

-- Test 20: query (line 85)
SELECT * FROM kv;

-- Test 21: statement (line 92)
BEGIN;

-- Test 22: query (line 95)
SELECT count(*) FROM kv;

-- statement error pgcode 25P02 current transaction is aborted, commands ignored until end of transaction block
UPDATE kv SET v = 'b' WHERE k in ('a');

-- statement ok
ROLLBACK;

-- query TT
SELECT * FROM kv;

-- Test 23: statement (line 113)
BEGIN;

-- Test 24: statement (line 116)
INSERT INTO kv VALUES('unique_key', 'some value');
INSERT INTO kv VALUES('a2', 'c');
INSERT INTO kv VALUES('unique_key2', 'some value');
COMMIT;

-- Test 25: statement (line 123)
UPDATE kv SET v = 'b' WHERE k in ('a');

-- Test 26: statement (line 127)
UPDATE kv SET v = 'b' WHERE k in ('a');

-- Test 27: statement (line 131)
COMMIT;
INSERT INTO kv VALUES('x', 'y');

-- Test 28: query (line 135)
SELECT * FROM kv;

-- Test 29: statement (line 143)
BEGIN TRANSACTION;

-- Test 30: statement (line 146)
BEGIN TRANSACTION;

-- Test 31: statement (line 149)
ROLLBACK TRANSACTION;

-- Test 32: statement (line 154)
BEGIN TRANSACTION;

-- Test 33: statement (line 157)
UPDATE kv SET v = 'b' WHERE k in ('a');

-- Test 34: statement (line 160)
BEGIN TRANSACTION;

-- Test 35: statement (line 163)
SELECT * FROM kv;

-- Test 36: statement (line 166)
ROLLBACK TRANSACTION;

-- Test 37: statement (line 171)
BEGIN; COMMIT;

-- Test 38: statement (line 175)
BEGIN; END;

-- Test 39: statement (line 180)
SET crdb.autocommit_before_ddl = false;

-- Test 40: statement (line 183)
COMMIT TRANSACTION;

-- Test 41: statement (line 186)
ROLLBACK TRANSACTION;

-- Test 42: statement (line 191)
SET crdb.autocommit_before_ddl = true;

-- Test 43: statement (line 194)
COMMIT TRANSACTION;

-- Test 44: statement (line 197)
ROLLBACK TRANSACTION;

-- Test 45: statement (line 202)
SET crdb.autocommit_before_ddl = false;

-- Test 46: statement (line 205)
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

-- Test 47: statement (line 210)
SET crdb.autocommit_before_ddl = true;

-- Test 48: query (line 213)
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

-- Test 49: statement (line 219)
BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ; COMMIT;

-- onlyif config enterprise-configs

-- Test 50: query (line 223)
BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- Test 51: query (line 228)
BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- Test 52: statement (line 233)
COMMIT;

-- Test 53: statement (line 236)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE; COMMIT;

-- Test 54: statement (line 239)
BEGIN TRANSACTION; SET TRANSACTION ISOLATION LEVEL REPEATABLE READ; COMMIT;

-- Test 55: statement (line 242)
BEGIN TRANSACTION; SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; COMMIT;

-- Test 56: statement (line 245)
BEGIN TRANSACTION;

-- onlyif config enterprise-configs

-- Test 57: query (line 249)
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- Test 58: query (line 254)
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- Test 59: statement (line 259)
COMMIT;

-- Test 60: statement (line 264)
BEGIN TRANSACTION;

-- Test 61: statement (line 267)
UPDATE kv SET v = 'b' WHERE k in ('a');

-- onlyif config enterprise-configs
-- skipif config weak-iso-level-configs

-- Test 62: statement (line 272)
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- onlyif config weak-iso-level-configs

-- Test 63: statement (line 276)
-- SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- Test 64: statement (line 279)
ROLLBACK;

-- Test 65: statement (line 282)
BEGIN TRANSACTION;

-- Test 66: statement (line 285)
SELECT * FROM kv LIMIT 1;

-- onlyif config enterprise-configs
-- skipif config weak-iso-level-configs

-- Test 67: statement (line 290)
SET transaction_isolation = 'READ COMMITTED';

-- onlyif config weak-iso-level-configs

-- Test 68: statement (line 294)
-- SET transaction_isolation = 'SERIALIZABLE';

-- Test 69: statement (line 297)
ROLLBACK;

-- Test 70: statement (line 300)
-- SET CLUSTER SETTING sql.txn.read_committed_isolation.enabled = false;

-- Test 71: statement (line 303)
-- SET CLUSTER SETTING sql.txn.repeatable_read_isolation.enabled = false;

-- Test 72: statement (line 309)
BEGIN TRANSACTION;

-- Test 73: query (line 312)
SHOW TRANSACTION ISOLATION LEVEL;

-- Test 74: query (line 317)
SHOW transaction_isolation;

-- Test 75: statement (line 323)
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- Test 76: query (line 326)
SHOW TRANSACTION ISOLATION LEVEL;

-- Test 77: statement (line 332)
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

-- Test 78: query (line 335)
SHOW TRANSACTION ISOLATION LEVEL;

-- Test 79: query (line 340)
SHOW transaction_isolation;

-- Test 80: statement (line 345)
COMMIT;

-- Test 81: statement (line 348)
BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- Test 82: query (line 351)
SHOW TRANSACTION ISOLATION LEVEL;

-- Test 83: statement (line 356)
COMMIT;

-- Test 84: statement (line 362)
SET default_transaction_isolation = 'read committed';

-- Test 85: query (line 365)
SHOW default_transaction_isolation;

-- Test 86: statement (line 370)
SET SESSION CHARACTERISTICS AS TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- Test 87: query (line 373)
SHOW DEFAULT_TRANSACTION_ISOLATION;

-- Test 88: statement (line 378)
-- SET CLUSTER SETTING sql.txn.repeatable_read_isolation.enabled = true;

-- Test 89: statement (line 383)
SET default_transaction_isolation = 'read committed';

-- onlyif config enterprise-configs

-- Test 90: query (line 387)
SHOW default_transaction_isolation;

-- Test 91: query (line 393)
SHOW default_transaction_isolation;

-- Test 92: statement (line 398)
SET SESSION CHARACTERISTICS AS TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- onlyif config enterprise-configs

-- Test 93: query (line 402)
SHOW DEFAULT_TRANSACTION_ISOLATION;

-- Test 94: query (line 408)
SHOW DEFAULT_TRANSACTION_ISOLATION;

-- Test 95: statement (line 414)
BEGIN;

-- Test 96: statement (line 417)
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

-- onlyif config enterprise-configs

-- Test 97: query (line 421)
SHOW TRANSACTION ISOLATION LEVEL;

-- Test 98: query (line 427)
SHOW transaction_isolation;

-- Test 99: query (line 433)
SHOW TRANSACTION ISOLATION LEVEL;

-- Test 100: query (line 439)
SHOW transaction_isolation;

-- Test 101: statement (line 444)
COMMIT;

-- Test 102: statement (line 448)
-- SET transaction_isolation = 'this is made up';

-- Test 103: statement (line 453)
BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;

-- onlyif config enterprise-configs

-- Test 104: query (line 457)
SHOW TRANSACTION ISOLATION LEVEL;

-- Test 105: query (line 463)
SHOW TRANSACTION ISOLATION LEVEL;

-- Test 106: statement (line 468)
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- Test 107: query (line 471)
SHOW TRANSACTION ISOLATION LEVEL;

-- Test 108: statement (line 476)
COMMIT;

-- Test 109: statement (line 479)
-- SET CLUSTER SETTING sql.txn.repeatable_read_isolation.enabled = false;

-- Test 110: statement (line 482)
-- SET CLUSTER SETTING sql.txn.read_committed_isolation.enabled = true;

-- Test 111: statement (line 485)
BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- onlyif config enterprise-configs

-- Test 112: query (line 489)
SHOW TRANSACTION ISOLATION LEVEL;

-- Test 113: query (line 495)
SHOW TRANSACTION ISOLATION LEVEL;

-- Test 114: statement (line 500)
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- Test 115: query (line 503)
SHOW TRANSACTION ISOLATION LEVEL;

-- Test 116: statement (line 509)
SET transaction_isolation = 'READ COMMITTED';

-- onlyif config enterprise-configs

-- Test 117: query (line 513)
SHOW TRANSACTION ISOLATION LEVEL;

-- Test 118: query (line 519)
SHOW TRANSACTION ISOLATION LEVEL;

-- Test 119: query (line 525)
SHOW transaction_isolation;

-- Test 120: query (line 531)
SHOW transaction_isolation;

-- Test 121: statement (line 536)
COMMIT;

-- Test 122: statement (line 541)
SET crdb.autocommit_before_ddl = false;

-- Test 123: statement (line 544)
-- SET TRANSACTION PRIORITY LOW;

-- Test 124: statement (line 547)
SET crdb.autocommit_before_ddl = true;

-- Test 125: query (line 550)
-- SET TRANSACTION PRIORITY LOW;

-- Test 126: statement (line 556)
-- BEGIN TRANSACTION PRIORITY LOW; COMMIT;

-- Test 127: statement (line 559)
-- BEGIN TRANSACTION PRIORITY NORMAL; COMMIT;

-- Test 128: statement (line 562)
-- BEGIN TRANSACTION PRIORITY HIGH; COMMIT;

-- Test 129: statement (line 565)
-- BEGIN TRANSACTION; SET TRANSACTION PRIORITY LOW; COMMIT;

-- Test 130: statement (line 568)
-- BEGIN TRANSACTION; SET TRANSACTION PRIORITY NORMAL; COMMIT;

-- Test 131: statement (line 571)
-- BEGIN TRANSACTION; SET TRANSACTION PRIORITY HIGH; COMMIT;

-- Test 132: statement (line 576)
BEGIN TRANSACTION;

-- Test 133: statement (line 579)
UPDATE kv SET v = 'b' WHERE k in ('a');

-- Test 134: statement (line 582)
-- SET TRANSACTION PRIORITY HIGH;

-- Test 135: statement (line 585)
ROLLBACK;

-- Test 136: statement (line 588)
BEGIN TRANSACTION;

-- Test 137: statement (line 591)
UPDATE kv SET v = 'b' WHERE k in ('a');

-- Test 138: statement (line 594)
-- SET TRANSACTION PRIORITY HIGH;

-- Test 139: statement (line 597)
ROLLBACK;

-- Test 140: statement (line 602)
BEGIN TRANSACTION;

-- Test 141: query (line 605)
-- SHOW TRANSACTION PRIORITY;

-- Test 142: statement (line 610)
-- SET TRANSACTION PRIORITY HIGH;

-- Test 143: query (line 613)
-- SHOW TRANSACTION PRIORITY;

-- Test 144: statement (line 618)
COMMIT;

-- Test 145: statement (line 623)
-- BEGIN TRANSACTION PRIORITY LOW;

-- Test 146: query (line 626)
-- SHOW TRANSACTION PRIORITY;

-- Test 147: statement (line 631)
-- SET TRANSACTION PRIORITY NORMAL;

-- Test 148: query (line 634)
-- SHOW TRANSACTION PRIORITY;

-- Test 149: statement (line 639)
COMMIT;

-- Test 150: query (line 644)
-- SHOW DEFAULT_TRANSACTION_PRIORITY;

-- Test 151: query (line 649)
-- SHOW TRANSACTION PRIORITY;

-- Test 152: statement (line 654)
-- SET DEFAULT_TRANSACTION_PRIORITY TO 'LOW';

-- Test 153: query (line 657)
-- SHOW DEFAULT_TRANSACTION_PRIORITY;

-- Test 154: query (line 662)
-- SHOW TRANSACTION PRIORITY;

-- Test 155: statement (line 667)
-- SET DEFAULT_TRANSACTION_PRIORITY TO 'NORMAL';

-- Test 156: query (line 670)
-- SHOW DEFAULT_TRANSACTION_PRIORITY;

-- Test 157: query (line 675)
-- SHOW TRANSACTION PRIORITY;

-- Test 158: statement (line 680)
-- SET DEFAULT_TRANSACTION_PRIORITY TO 'HIGH';

-- Test 159: query (line 683)
-- SHOW DEFAULT_TRANSACTION_PRIORITY;

-- Test 160: query (line 688)
-- SHOW TRANSACTION PRIORITY;

-- Test 161: statement (line 693)
-- SET SESSION CHARACTERISTICS AS TRANSACTION PRIORITY LOW;

-- Test 162: query (line 696)
-- SHOW DEFAULT_TRANSACTION_PRIORITY;

-- Test 163: query (line 701)
-- SHOW TRANSACTION PRIORITY;

-- Test 164: statement (line 706)
-- SET SESSION CHARACTERISTICS AS TRANSACTION PRIORITY NORMAL;

-- Test 165: query (line 709)
-- SHOW DEFAULT_TRANSACTION_PRIORITY;

-- Test 166: query (line 714)
-- SHOW TRANSACTION PRIORITY;

-- Test 167: statement (line 719)
-- SET SESSION CHARACTERISTICS AS TRANSACTION PRIORITY HIGH;

-- Test 168: query (line 722)
-- SHOW DEFAULT_TRANSACTION_PRIORITY;

-- Test 169: query (line 727)
-- SHOW TRANSACTION PRIORITY;

-- Test 170: statement (line 734)
BEGIN;

-- Test 171: query (line 737)
-- SHOW TRANSACTION PRIORITY;

-- Test 172: statement (line 742)
COMMIT;

-- Test 173: statement (line 747)
-- BEGIN TRANSACTION PRIORITY LOW;

-- Test 174: query (line 750)
-- SHOW TRANSACTION PRIORITY;

-- Test 175: statement (line 755)
COMMIT;

-- Test 176: statement (line 760)
BEGIN;

-- Test 177: query (line 763)
-- SHOW TRANSACTION PRIORITY;

-- Test 178: statement (line 768)
-- SET TRANSACTION PRIORITY LOW;

-- Test 179: query (line 771)
-- SHOW TRANSACTION PRIORITY;

-- Test 180: statement (line 776)
COMMIT;

-- Test 181: statement (line 779)
-- RESET DEFAULT_TRANSACTION_PRIORITY;

-- Test 182: query (line 782)
-- SHOW DEFAULT_TRANSACTION_PRIORITY;

-- Test 183: statement (line 789)
-- BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ, PRIORITY LOW; COMMIT;

-- Test 184: statement (line 792)
-- BEGIN TRANSACTION PRIORITY LOW, ISOLATION LEVEL REPEATABLE READ; COMMIT;

-- Test 185: statement (line 797)
-- BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ, PRIORITY LOW;

-- Test 186: query (line 800)
SHOW TRANSACTION ISOLATION LEVEL;

-- Test 187: query (line 805)
-- SHOW TRANSACTION PRIORITY;

-- Test 188: statement (line 810)
-- SET TRANSACTION ISOLATION LEVEL SERIALIZABLE, PRIORITY HIGH;

-- Test 189: query (line 813)
SHOW TRANSACTION ISOLATION LEVEL;

-- Test 190: query (line 818)
-- SHOW TRANSACTION PRIORITY;

-- Test 191: statement (line 823)
-- SET TRANSACTION PRIORITY NORMAL, ISOLATION LEVEL REPEATABLE READ;

-- Test 192: query (line 826)
SHOW TRANSACTION ISOLATION LEVEL;

-- Test 193: query (line 831)
-- SHOW TRANSACTION PRIORITY;

-- Test 194: statement (line 836)
COMMIT;

-- Test 195: statement (line 839)
-- SET CLUSTER SETTING sql.txn.repeatable_read_isolation.enabled = true;

-- Test 196: statement (line 842)
-- BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ, PRIORITY LOW;

-- onlyif config enterprise-configs

-- Test 197: query (line 846)
SHOW TRANSACTION ISOLATION LEVEL;

-- Test 198: query (line 851)
-- SHOW TRANSACTION PRIORITY;

-- Test 199: statement (line 856)
-- SET TRANSACTION ISOLATION LEVEL SERIALIZABLE, PRIORITY HIGH;

-- Test 200: query (line 859)
SHOW TRANSACTION ISOLATION LEVEL;

-- Test 201: query (line 864)
-- SHOW TRANSACTION PRIORITY;

-- Test 202: statement (line 869)
COMMIT;

-- Test 203: query (line 875)
SET SESSION CHARACTERISTICS AS TRANSACTION ISOLATION LEVEL REPEATABLE READ;

-- Test 204: query (line 880)
SET SESSION CHARACTERISTICS AS TRANSACTION ISOLATION LEVEL REPEATABLE READ;

-- Test 205: statement (line 885)
SET SESSION CHARACTERISTICS AS TRANSACTION ISOLATION LEVEL REPEATABLE READ;

-- onlyif config enterprise-configs

-- Test 206: query (line 889)
SHOW DEFAULT_TRANSACTION_ISOLATION;

-- Test 207: query (line 895)
SHOW DEFAULT_TRANSACTION_ISOLATION;

-- Test 208: statement (line 900)
-- SET CLUSTER SETTING sql.txn.repeatable_read_isolation.enabled = false;

-- Test 209: statement (line 903)
SET SESSION CHARACTERISTICS AS TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- onlyif config enterprise-configs

-- Test 210: query (line 907)
SHOW DEFAULT_TRANSACTION_ISOLATION;

-- Test 211: query (line 913)
SHOW DEFAULT_TRANSACTION_ISOLATION;

-- Test 212: statement (line 918)
SET SESSION CHARACTERISTICS AS TRANSACTION ISOLATION LEVEL REPEATABLE READ;

-- Test 213: query (line 921)
SHOW DEFAULT_TRANSACTION_ISOLATION;

-- Test 214: statement (line 926)
-- SET SESSION CHARACTERISTICS AS TRANSACTION ISOLATION LEVEL SNAPSHOT;

-- Test 215: query (line 929)
SHOW DEFAULT_TRANSACTION_ISOLATION;

-- Test 216: query (line 935)
SHOW TRANSACTION ISOLATION LEVEL;

-- Test 217: statement (line 940)
SET SESSION CHARACTERISTICS AS TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- onlyif config enterprise-configs

-- Test 218: query (line 944)
SHOW DEFAULT_TRANSACTION_ISOLATION;

-- Test 219: query (line 951)
SHOW TRANSACTION ISOLATION LEVEL;

-- Test 220: statement (line 956)
SET SESSION CHARACTERISTICS AS TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- Test 221: query (line 959)
SHOW DEFAULT_TRANSACTION_ISOLATION;

-- Test 222: statement (line 964)
SET default_transaction_isolation = 'read uncommitted';

-- onlyif config enterprise-configs

-- Test 223: query (line 968)
SHOW default_transaction_isolation;

-- Test 224: query (line 974)
SHOW default_transaction_isolation;

-- Test 225: query (line 980)
SET default_transaction_isolation = 'read committed';

-- Test 226: query (line 985)
SET default_transaction_isolation = 'read committed';

-- Test 227: query (line 991)
SHOW default_transaction_isolation;

-- Test 228: query (line 997)
SHOW default_transaction_isolation;

-- Test 229: statement (line 1002)
-- SET CLUSTER SETTING sql.txn.repeatable_read_isolation.enabled = true;

-- Test 230: statement (line 1007)
-- SET default_transaction_isolation = 'snapshot';

-- onlyif config enterprise-configs

-- Test 231: query (line 1011)
SHOW default_transaction_isolation;

-- Test 232: query (line 1017)
SHOW default_transaction_isolation;

-- Test 233: statement (line 1022)
SET DEFAULT_TRANSACTION_ISOLATION TO 'REPEATABLE READ';

-- onlyif config enterprise-configs

-- Test 234: query (line 1026)
SHOW DEFAULT_TRANSACTION_ISOLATION;

-- Test 235: query (line 1032)
SHOW default_transaction_isolation;

-- Test 236: statement (line 1037)
-- SET CLUSTER SETTING sql.txn.repeatable_read_isolation.enabled = false;

-- Test 237: statement (line 1042)
SET default_transaction_isolation = 'repeatable read';

-- Test 238: query (line 1045)
SHOW default_transaction_isolation;

-- Test 239: statement (line 1050)
SET DEFAULT_TRANSACTION_ISOLATION TO 'REPEATABLE READ';

-- Test 240: query (line 1053)
SHOW DEFAULT_TRANSACTION_ISOLATION;

-- Test 241: statement (line 1060)
BEGIN;

-- Test 242: query (line 1063)
SHOW TRANSACTION ISOLATION LEVEL;

-- Test 243: statement (line 1068)
COMMIT;

-- Test 244: statement (line 1073)
BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- onlyif config enterprise-configs

-- Test 245: query (line 1077)
SHOW TRANSACTION ISOLATION LEVEL;

-- Test 246: statement (line 1082)
COMMIT;

-- Test 247: statement (line 1087)
BEGIN TRANSACTION;

-- Test 248: statement (line 1090)
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

-- Test 249: query (line 1093)
SHOW TRANSACTION ISOLATION LEVEL;

-- Test 250: statement (line 1098)
-- SET TRANSACTION PRIORITY HIGH;

-- Test 251: query (line 1101)
SHOW TRANSACTION ISOLATION LEVEL;

-- Test 252: statement (line 1106)
COMMIT;

-- Test 253: statement (line 1109)
RESET DEFAULT_TRANSACTION_ISOLATION;

-- skipif config weak-iso-level-configs

-- Test 254: query (line 1113)
SHOW DEFAULT_TRANSACTION_ISOLATION;

-- Test 255: query (line 1119)
SHOW DEFAULT_TRANSACTION_ISOLATION;

-- Test 256: query (line 1126)
-- SHOW TRANSACTION STATUS;

-- Test 257: statement (line 1131)
BEGIN;

-- Test 258: query (line 1134)
-- SHOW TRANSACTION STATUS;

-- Test 259: statement (line 1139)
COMMIT;

-- Test 260: query (line 1142)
-- SHOW TRANSACTION STATUS;

-- Test 261: statement (line 1147)
BEGIN;

-- Test 262: query (line 1150)
-- SELECT a FROM t.b;

-- query T
-- SHOW TRANSACTION STATUS;

-- Test 263: statement (line 1158)
ROLLBACK;

-- Test 264: query (line 1161)
-- SHOW TRANSACTION STATUS;

-- Test 265: statement (line 1167)
BEGIN;SAVEPOINT cockroach_restart;

-- Test 266: statement (line 1170)
RELEASE SAVEPOINT cockroach_restart;

-- Test 267: query (line 1173)
-- SHOW TRANSACTION STATUS;

-- Test 268: statement (line 1178)
COMMIT;

-- Test 269: statement (line 1184)
BEGIN TRANSACTION; SAVEPOINT cockroach_restart; SELECT 1;

-- skipif config local-read-committed

-- Test 270: query (line 1188)
-- SELECT crdb_internal.force_retry('1h':::INTERVAL);

-- onlyif config local-read-committed
-- query error pgcode 40001 pq: restart transaction: read committed retry limit exceeded; set by max_retries_for_read_committed=100: TransactionRetryWithProtoRefreshError: forced by crdb_internal.force_retry\(\)
-- SELECT crdb_internal.force_retry('1h':::INTERVAL);

-- query T
-- SHOW TRANSACTION STATUS;

-- Test 271: statement (line 1200)
ROLLBACK TO SAVEPOINT cockroach_restart;

-- Test 272: query (line 1203)
-- SHOW TRANSACTION STATUS;

-- Test 273: statement (line 1208)
COMMIT;

-- Test 274: statement (line 1214)
-- CREATE SEQUENCE s;

-- Test 275: statement (line 1217)
BEGIN TRANSACTION;
-- SELECT IF(nextval('s')<3, crdb_internal.force_retry('1h':::INTERVAL), 0);

-- Test 276: query (line 1222)
-- SELECT currval('s');

-- Test 277: statement (line 1227)
ROLLBACK;

-- Test 278: statement (line 1230)
-- DROP SEQUENCE s;

-- Test 279: statement (line 1235)
-- CREATE SEQUENCE s;

-- Test 280: statement (line 1238)
BEGIN TRANSACTION;

-- Test 281: statement (line 1241)
SELECT 1;
-- SELECT IF(nextval('s')<3, crdb_internal.force_retry('1h':::INTERVAL), 0);

-- Test 282: query (line 1246)
-- SELECT currval('s');

-- Test 283: statement (line 1251)
ROLLBACK;

-- Test 284: statement (line 1254)
-- DROP SEQUENCE s;

-- Test 285: statement (line 1260)
-- CREATE SEQUENCE s;

-- Test 286: statement (line 1263)
BEGIN TRANSACTION;
  SAVEPOINT cockroach_restart;
-- SET TRANSACTION PRIORITY HIGH;
  -- SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

-- Test 287: statement (line 1269)
-- SELECT IF(nextval('s')<3, crdb_internal.force_retry('1h':::INTERVAL), 0);

-- Test 288: query (line 1273)
-- SELECT currval('s');

-- Test 289: query (line 1278)
SHOW TRANSACTION ISOLATION LEVEL;

-- Test 290: query (line 1283)
-- SHOW TRANSACTION PRIORITY;

-- Test 291: statement (line 1288)
ROLLBACK;

-- Test 292: statement (line 1291)
-- DROP SEQUENCE s;

-- Test 293: statement (line 1295)
-- CREATE SEQUENCE s;

-- Test 294: statement (line 1298)
BEGIN TRANSACTION;

-- Test 295: statement (line 1301)
SAVEPOINT cockroach_restart;

-- Test 296: statement (line 1304)
-- SELECT IF(nextval('s')<3, crdb_internal.force_retry('1h':::INTERVAL), 0);

-- Test 297: query (line 1308)
-- SELECT currval('s');

-- Test 298: statement (line 1313)
ROLLBACK;

-- Test 299: statement (line 1316)
-- DROP SEQUENCE s;

-- Test 300: statement (line 1321)
-- CREATE SEQUENCE s;

-- Test 301: statement (line 1324)
BEGIN TRANSACTION;
  SAVEPOINT cockroach_restart;
  SELECT 1;

-- skipif config local-read-committed

-- Test 302: query (line 1330)
-- SELECT crdb_internal.force_retry('1h':::INTERVAL);

-- onlyif config local-read-committed
-- query error pgcode 40001 pq: restart transaction: read committed retry limit exceeded; set by max_retries_for_read_committed=100: TransactionRetryWithProtoRefreshError: forced by crdb_internal.force_retry\(\)
-- SELECT crdb_internal.force_retry('1h':::INTERVAL);

-- statement ok
ROLLBACK TO SAVEPOINT COCKROACH_RESTART;

-- This is the automatic retry we care about.
-- statement ok
-- SELECT IF(nextval('s')<3, crdb_internal.force_retry('1h':::INTERVAL), 0);

-- Demonstrate that the txn was indeed retried.
-- query I
-- SELECT currval('s');

-- Test 303: statement (line 1350)
ROLLBACK;

-- Test 304: statement (line 1353)
-- DROP SEQUENCE s;

-- Test 305: statement (line 1359)
BEGIN;

-- Test 306: query (line 1362)
SHOW transaction_read_only;

-- Test 307: statement (line 1367)
-- SET TRANSACTION READ ONLY;

-- Test 308: query (line 1370)
SHOW transaction_read_only;

-- Test 309: statement (line 1375)
-- SET TRANSACTION READ WRITE;

-- Test 310: query (line 1378)
SHOW transaction_read_only;

-- Test 311: statement (line 1383)
SET transaction_read_only = true;

-- Test 312: query (line 1386)
SHOW transaction_read_only;

-- Test 313: statement (line 1391)
SET transaction_read_only = false;

-- Test 314: query (line 1394)
SHOW transaction_read_only;

-- Test 315: statement (line 1399)
-- SET TRANSACTION READ ONLY, READ WRITE;

-- Test 316: statement (line 1402)
ROLLBACK;

-- Test 317: statement (line 1405)
BEGIN READ WRITE;

-- Test 318: query (line 1408)
SHOW transaction_read_only;

-- Test 319: statement (line 1413)
COMMIT;

-- Test 320: statement (line 1416)
BEGIN READ ONLY;

-- Test 321: query (line 1419)
SHOW transaction_read_only;

-- Test 322: statement (line 1424)
COMMIT;

-- Test 323: query (line 1428)
SHOW default_transaction_read_only;

-- Test 324: statement (line 1433)
SET default_transaction_read_only = true;

-- Test 325: query (line 1436)
SHOW default_transaction_read_only;

-- Test 326: statement (line 1441)
SET SESSION CHARACTERISTICS AS TRANSACTION READ WRITE;

-- Test 327: query (line 1444)
SHOW default_transaction_read_only;

-- Test 328: statement (line 1449)
SET SESSION CHARACTERISTICS AS TRANSACTION READ ONLY;

-- Test 329: query (line 1452)
SHOW default_transaction_read_only;

-- Reset session default to allow subsequent writes.
SET SESSION CHARACTERISTICS AS TRANSACTION READ WRITE;

-- Test 330: statement (line 1457)
BEGIN;

-- Test 331: statement (line 1460)
SAVEPOINT cockroach_restart;

-- Test 332: query (line 1463)
SHOW transaction_read_only;

-- Test 333: statement (line 1469)
-- SET TRANSACTION READ WRITE;

-- Test 334: query (line 1472)
SHOW transaction_read_only;

-- Test 335: statement (line 1479)
ROLLBACK TO SAVEPOINT cockroach_restart;

-- Test 336: query (line 1482)
SHOW transaction_read_only;

-- Test 337: statement (line 1487)
COMMIT;

-- Test 338: statement (line 1491)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE READ WRITE;

-- Test 339: statement (line 1494)
SET LOCAL crdb.autocommit_before_ddl = false;

-- Test 340: statement (line 1497)
CREATE SEQUENCE a;

-- Test 341: statement (line 1500)
COMMIT;

-- Test 342: statement (line 1503)
CREATE TABLE tab (a int);

-- Test 343: statement (line 1507)
-- EXPLAIN CREATE TABLE tab (a int);

-- Test 344: statement (line 1510)
INSERT INTO kv (k, v) VALUES ('foo', 'foo');

-- Test 345: statement (line 1514)
-- EXPLAIN INSERT INTO kv VALUES('foo');

-- Test 346: statement (line 1517)
-- EXPLAIN (OPT) INSERT INTO kv VALUES('foo');

-- Test 347: statement (line 1520)
-- EXPLAIN (DISTSQL) INSERT INTO kv VALUES('foo');

-- skipif config local-vec-off fakedist-vec-off

-- Test 348: statement (line 1524)
-- EXPLAIN (VEC) INSERT INTO kv VALUES('foo');

-- Test 349: statement (line 1527)
-- EXPLAIN (GIST) INSERT INTO kv VALUES('foo');

-- Test 350: statement (line 1531)
-- EXPLAIN ANALYZE INSERT INTO kv VALUES('foo');

-- Test 351: statement (line 1534)
UPDATE kv SET v = 'foo';

-- Test 352: statement (line 1537)
INSERT INTO kv (k, v) VALUES ('foo', 'foo') ON CONFLICT (k) DO UPDATE SET v = EXCLUDED.v;

-- Test 353: statement (line 1540)
DELETE FROM kv;

-- Test 354: statement (line 1543)
SELECT * FROM kv FOR UPDATE;

-- Test 355: statement (line 1546)
SELECT * FROM kv FOR SHARE;

-- Test 356: statement (line 1549)
SELECT nextval('a');

-- Test 357: statement (line 1553)
-- EXPLAIN SELECT nextval('a');

-- Test 358: statement (line 1556)
SELECT currval('a');

-- Test 359: statement (line 1559)
SELECT setval('a', 2);

-- Test 360: statement (line 1562)
-- CREATE ROLE my_user;

-- Test 361: statement (line 1565)
-- ALTER ROLE testuser SET default_int_size = 4;

-- Test 362: statement (line 1569)
-- EXPLAIN ALTER ROLE testuser SET default_int_size = 4;

-- Test 363: statement (line 1572)
-- DROP ROLE testuser;

-- Test 364: statement (line 1575)
-- SET CLUSTER SETTING sql.auth.change_own_password.enabled = true;

-- Test 365: statement (line 1578)
-- GRANT admin TO testuser;

-- Test 366: statement (line 1581)
-- REVOKE admin FROM testuser;

-- Test 367: statement (line 1584)
-- GRANT CONNECT ON DATABASE test TO testuser;

-- Test 368: statement (line 1591)
SET intervalstyle = 'postgres';

-- Test 369: statement (line 1594)
-- SET SESSION CHARACTERISTICS AS TRANSACTION PRIORITY NORMAL;

-- Test 370: statement (line 1597)
SET SESSION AUTHORIZATION DEFAULT;

-- Test 371: statement (line 1600)
BEGIN;

-- Test 372: statement (line 1604)
DECLARE foo CURSOR FOR SELECT 1;

-- Test 373: statement (line 1607)
FETCH 1 FROM foo;

-- Test 374: statement (line 1610)
CLOSE foo;

-- Test 375: statement (line 1613)
COMMIT;

-- Test 376: query (line 1616)
-- SHOW TRANSACTION STATUS;

-- Test 377: statement (line 1621)
-- BEGIN READ WRITE, READ ONLY;

-- Test 378: statement (line 1624)
-- BEGIN PRIORITY LOW, PRIORITY HIGH;

-- Test 379: statement (line 1627)
-- BEGIN ISOLATION LEVEL SERIALIZABLE, ISOLATION LEVEL SERIALIZABLE;

-- Test 380: statement (line 1634)
BEGIN; SELECT 1;

-- skipif config local-read-committed

-- Test 381: statement (line 1679)
-- SET DEFAULT_TRANSACTION_USE_FOLLOWER_READS TO TRUE;

-- Test 382: statement (line 1689)
-- SET DEFAULT_TRANSACTION_USE_FOLLOWER_READS TO FALSE;

-- Test 383: query (line 1692)
-- SHOW DEFAULT_TRANSACTION_USE_FOLLOWER_READS;

-- Test 384: statement (line 1713)
-- SET DEFAULT_TRANSACTION_USE_FOLLOWER_READS TO FALSE;

-- Test 385: query (line 1716)
-- SHOW DEFAULT_TRANSACTION_USE_FOLLOWER_READS;

-- Test 386: statement (line 1723)
SET SESSION CHARACTERISTICS AS TRANSACTION NOT DEFERRABLE;

-- Test 387: statement (line 1726)
SET SESSION CHARACTERISTICS AS TRANSACTION DEFERRABLE;

-- Test 388: statement (line 1731)
SET intervalstyle = 'postgres';

-- Test 389: query (line 1745)
-- SELECT s FROM rewind_session_test ORDER BY s;

-- Test 390: query (line 1751)
SHOW intervalstyle;

-- Test 391: statement (line 1757)
-- ALTER TABLE rewind_session_test SET (schema_locked=false);

-- Test 392: statement (line 1760)
-- TRUNCATE rewind_session_test;

-- Test 393: statement (line 1763)
-- ALTER TABLE rewind_session_test RESET (schema_locked);

-- Test 394: statement (line 1766)
SET intervalstyle = 'postgres';

-- Test 395: query (line 1777)
-- SELECT s FROM rewind_session_test ORDER BY s;

-- Test 396: query (line 1783)
SHOW intervalstyle;

-- Test 397: query (line 1788)
-- SHOW default_transaction_quality_of_service;

-- Test 398: statement (line 1793)
-- SET default_transaction_quality_of_service=critical;

-- Test 399: query (line 1796)
-- SHOW default_transaction_quality_of_service;

-- Test 400: statement (line 1801)
-- SET default_transaction_quality_of_service=background;

-- Test 401: query (line 1804)
-- SHOW default_transaction_quality_of_service;

-- Test 402: statement (line 1809)
-- RESET default_transaction_quality_of_service;

-- Test 403: query (line 1812)
-- SHOW default_transaction_quality_of_service;

-- Test 404: statement (line 1817)
-- SET default_transaction_quality_of_service=ttl_low;

-- Test 405: statement (line 1820)
BEGIN;

-- Test 406: statement (line 1823)
-- SET LOCAL default_transaction_quality_of_service=background;

-- Test 407: query (line 1826)
-- SHOW default_transaction_quality_of_service;

-- Test 408: statement (line 1831)
END;

-- Test 409: query (line 1834)
-- SHOW default_transaction_quality_of_service;

-- Test 410: statement (line 1841)
-- SET CLUSTER SETTING sql.defaults.use_declarative_schema_changer = 'on';
-- SET CLUSTER SETTING sql.defaults.use_declarative_schema_changer = 'off';

-- Test 411: statement (line 1845)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SELECT cluster_logical_timestamp();

-- Test 412: statement (line 1849)
ROLLBACK;

-- Test 413: statement (line 1852)
BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- onlyif config enterprise-configs

-- Test 414: statement (line 1856)
SELECT cluster_logical_timestamp();

-- Test 415: statement (line 1859)
ROLLBACK;
