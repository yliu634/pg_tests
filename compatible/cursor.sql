-- PostgreSQL compatible tests from cursor
-- 206 tests

-- Test 1: statement (line 2)
-- CockroachDB-specific setting, removing
-- SET autocommit_before_ddl = false;

-- Test 2: statement (line 5)
CLOSE ALL;

-- Test 3: statement (line 8)
SET client_min_messages = warning;
DROP TABLE IF EXISTS a;
RESET client_min_messages;

CREATE TABLE a (a INT PRIMARY KEY, b INT);
INSERT INTO a VALUES (1, 2), (2, 3);

-- Test 4: statement (line 12)
DECLARE foo CURSOR FOR SELECT * FROM a;

-- Test 5: statement (line 15)
SELECT 1; DECLARE foo CURSOR FOR SELECT * FROM a;

-- Test 6: statement (line 18)
CLOSE foo;

-- Test 7: statement (line 21)
FETCH 2 foo;

-- Test 8: statement (line 24)
BEGIN;

-- Test 9: statement (line 27)
FETCH 2 foo;

-- Test 10: statement (line 30)
ROLLBACK;
BEGIN;

-- Test 11: statement (line 34)
DECLARE foo CURSOR FOR SELECT * FROM a ORDER BY a;

-- Test 12: query (line 37)
FETCH 1 foo;

-- Test 13: query (line 42)
FETCH 1 foo;

-- Test 14: query (line 47)
FETCH 2 foo;

-- Test 15: statement (line 51)
CLOSE foo;

-- Test 16: statement (line 54)
COMMIT;
BEGIN;
DECLARE foo CURSOR FOR SELECT * FROM a ORDER BY a;

-- Test 17: query (line 59)
FETCH 1 foo;

-- Test 18: statement (line 64)
CLOSE foo;

-- Test 19: statement (line 67)
FETCH 2 foo;

-- Test 20: statement (line 70)
ROLLBACK;
BEGIN;
DECLARE foo CURSOR FOR SELECT * FROM a ORDER BY a;

-- Test 21: query (line 75)
FETCH 1 foo;

-- Test 22: statement (line 80)
CLOSE ALL;

-- Test 23: statement (line 83)
FETCH 2 foo;

-- Test 24: statement (line 86)
ROLLBACK;

-- Test 25: statement (line 89)
BEGIN;
CLOSE foo;

-- Test 26: statement (line 93)
ROLLBACK;
BEGIN;
DECLARE foo CURSOR FOR SELECT * FROM a ORDER BY a;

-- Test 27: statement (line 102)
INSERT INTO a VALUES(3, 4);

-- Test 28: query (line 105)
FETCH 3 foo;

-- Test 29: statement (line 111)
CLOSE foo;
DECLARE foo CURSOR FOR SELECT * FROM a ORDER BY a;

-- Test 30: query (line 115)
FETCH 3 foo;

-- Test 31: statement (line 122)
COMMIT;

-- Test 32: statement (line 131)
SET client_min_messages = warning;
DROP TABLE IF EXISTS big;
RESET client_min_messages;

CREATE TABLE big (a INT PRIMARY KEY, b TEXT);
INSERT INTO big SELECT g, repeat('a', 1024 * 1024) FROM generate_series(1,11) g;

-- Test 33: statement (line 134)
BEGIN;
INSERT INTO big VALUES(100,'blargh');
DECLARE foo CURSOR FOR SELECT * FROM big ORDER BY a;
INSERT INTO big VALUES(101,'argh');

-- Test 34: query (line 140)
FETCH RELATIVE 12 foo;

-- Test 35: query (line 147)
SELECT * FROM big WHERE a > 100;

-- Test 36: statement (line 154)
INSERT INTO big VALUES(102,'argh2');

-- Test 37: query (line 159)
SELECT * FROM big WHERE a > 100 ORDER BY a;

-- Test 38: query (line 167)
FETCH 1 foo;

-- Test 39: statement (line 171)
COMMIT;

-- Test 40: query (line 176)
SELECT * FROM big WHERE a > 100 ORDER BY a;

-- Test 41: statement (line 183)
BEGIN;
DECLARE foo CURSOR FOR SELECT * FROM a ORDER BY a;

-- Test 42: query (line 187)
FETCH ALL foo;

-- Test 43: query (line 194)
FETCH ALL foo;

-- Test 44: statement (line 198)
CLOSE foo;
DECLARE foo CURSOR FOR SELECT * FROM a ORDER BY a;

-- Test 45: query (line 202)
FETCH FORWARD ALL foo;

-- Test 46: query (line 209)
FETCH FORWARD ALL foo;

-- Test 47: statement (line 213)
COMMIT;
INSERT INTO a SELECT g,g+1 FROM generate_series(4, 100) g(g);
BEGIN;
DECLARE foo CURSOR FOR SELECT * FROM a ORDER BY a;

-- Test 48: query (line 219)
FETCH 0 foo;

-- Test 49: query (line 223)
FETCH ABSOLUTE 0 foo;

-- Test 50: query (line 227)
FETCH FIRST foo;

-- Test 51: query (line 232)
FETCH FIRST foo;

-- Test 52: query (line 237)
FETCH NEXT foo;

-- Test 53: query (line 242)
FETCH NEXT foo;

-- Test 54: query (line 247)
FETCH FORWARD 3 foo;

-- Test 55: query (line 254)
FETCH FORWARD 3 foo;

-- Test 56: query (line 261)
FETCH RELATIVE 3 foo;

-- Test 57: query (line 266)
FETCH FORWARD foo;

-- Test 58: query (line 271)
FETCH ABSOLUTE 13 foo;

-- Test 59: query (line 276)
FETCH ABSOLUTE 14 foo;

-- Test 60: query (line 281)
FETCH ABSOLUTE 14 foo;

-- Test 61: query (line 286)
FETCH ABSOLUTE 16 foo;

-- Test 62: query (line 291)
FETCH ABSOLUTE 100 foo;

-- Test 63: query (line 296)
FETCH ABSOLUTE 101 foo;

-- Test 64: query (line 300)
FETCH ABSOLUTE 102 foo;

-- Test 65: statement (line 304)
COMMIT;

-- Test 66: statement (line 311)
BEGIN; DECLARE foo CURSOR FOR SELECT * FROM a ORDER BY a;
FETCH -1 foo;

-- Test 67: statement (line 315)
ROLLBACK; BEGIN; DECLARE foo CURSOR FOR SELECT * FROM a ORDER BY a;
FETCH BACKWARD 1 foo;

-- Test 68: statement (line 319)
ROLLBACK; BEGIN; DECLARE foo CURSOR FOR SELECT * FROM a ORDER BY a;
FETCH FORWARD -1 foo;

-- Test 69: statement (line 323)
ROLLBACK; BEGIN; DECLARE foo CURSOR FOR SELECT * FROM a ORDER BY a;
FETCH LAST foo;

-- Test 70: statement (line 327)
ROLLBACK; BEGIN; DECLARE foo CURSOR FOR SELECT * FROM a ORDER BY a;
FETCH LAST foo;

-- Test 71: statement (line 331)
ROLLBACK; BEGIN; DECLARE foo CURSOR FOR SELECT * FROM a ORDER BY a;
FETCH 10 foo;
FETCH ABSOLUTE 9 foo;

-- Test 72: statement (line 336)
ROLLBACK; BEGIN; DECLARE foo CURSOR FOR SELECT * FROM a ORDER BY a;
FETCH 10 foo;
FETCH RELATIVE -1 foo;

-- Test 73: statement (line 341)
ROLLBACK; BEGIN; DECLARE foo CURSOR FOR SELECT * FROM a ORDER BY a;
FETCH 10 foo;
FETCH FIRST foo;

-- Test 74: statement (line 346)
ROLLBACK; BEGIN; DECLARE foo CURSOR FOR SELECT * FROM a ORDER BY a;
FETCH ABSOLUTE -1 foo;

-- Test 75: statement (line 350)
ROLLBACK; BEGIN; DECLARE foo CURSOR FOR SELECT * FROM a ORDER BY a;
FETCH PRIOR foo;

-- Test 76: statement (line 354)
ROLLBACK; BEGIN; DECLARE foo CURSOR FOR SELECT * FROM a ORDER BY a;
FETCH BACKWARD ALL foo;

-- Test 77: statement (line 360)
ROLLBACK; BEGIN; DECLARE foo CURSOR FOR SELECT * FROM a ORDER BY a;
MOVE -1 foo;

-- Test 78: statement (line 364)
ROLLBACK; BEGIN; DECLARE foo CURSOR FOR SELECT * FROM a ORDER BY a;
MOVE BACKWARD 1 foo;

-- Test 79: statement (line 368)
ROLLBACK; BEGIN; DECLARE foo CURSOR FOR SELECT * FROM a ORDER BY a;
MOVE FORWARD -1 foo;

-- Test 80: statement (line 372)
ROLLBACK; BEGIN; DECLARE foo CURSOR FOR SELECT * FROM a ORDER BY a;
MOVE LAST foo;

-- Test 81: statement (line 376)
ROLLBACK; BEGIN; DECLARE foo CURSOR FOR SELECT * FROM a ORDER BY a;
MOVE LAST foo;

-- Test 82: statement (line 380)
ROLLBACK; BEGIN; DECLARE foo CURSOR FOR SELECT * FROM a ORDER BY a;
MOVE 10 foo;
MOVE ABSOLUTE 9 foo;

-- Test 83: statement (line 385)
ROLLBACK; BEGIN; DECLARE foo CURSOR FOR SELECT * FROM a ORDER BY a;
MOVE 10 foo;
MOVE RELATIVE -1 foo;

-- Test 84: statement (line 390)
ROLLBACK; BEGIN; DECLARE foo CURSOR FOR SELECT * FROM a ORDER BY a;
MOVE 10 foo;
MOVE FIRST foo;

-- Test 85: statement (line 395)
ROLLBACK; BEGIN; DECLARE foo CURSOR FOR SELECT * FROM a ORDER BY a;
MOVE ABSOLUTE -1 foo;

-- Test 86: statement (line 399)
ROLLBACK; BEGIN; DECLARE foo CURSOR FOR SELECT * FROM a ORDER BY a;
MOVE PRIOR foo;

-- Test 87: statement (line 403)
ROLLBACK; BEGIN; DECLARE foo CURSOR FOR SELECT * FROM a ORDER BY a;
MOVE BACKWARD ALL foo;

-- Test 88: statement (line 407)
ROLLBACK;

-- Test 89: statement (line 411)
BEGIN;
DECLARE foo CURSOR FOR SELECT * FROM a ORDER BY a;

-- Test 90: query (line 415)
FETCH 1 foo;

-- Test 91: statement (line 420)
MOVE 1 foo;

-- Test 92: query (line 423)
FETCH 1 foo;

-- Test 93: statement (line 428)
MOVE 10 foo;

-- Test 94: query (line 431)
FETCH 1 foo;

-- Test 95: statement (line 436)
ROLLBACK;
BEGIN;
DECLARE foo CURSOR FOR SELECT * FROM a ORDER BY a;

-- Test 96: statement (line 441)
MOVE 0 foo;

-- Test 97: statement (line 444)
MOVE FIRST foo;

-- Test 98: query (line 447)
FETCH FIRST foo;

-- Test 99: statement (line 452)
MOVE FIRST foo;

-- Test 100: statement (line 455)
MOVE NEXT foo;

-- Test 101: query (line 458)
FETCH 1 foo;

-- Test 102: statement (line 463)
MOVE FORWARD 3 foo;

-- Test 103: query (line 466)
FETCH 1 foo;

-- Test 104: statement (line 471)
MOVE RELATIVE 3 foo;

-- Test 105: query (line 474)
FETCH 1 foo;

-- Test 106: statement (line 479)
MOVE FORWARD foo;

-- Test 107: query (line 482)
FETCH 1 foo;

-- Test 108: statement (line 487)
MOVE ABSOLUTE 15 foo;

-- Test 109: statement (line 490)
MOVE ABSOLUTE 15 foo;

-- Test 110: query (line 493)
FETCH 1 foo;

-- Test 111: statement (line 498)
MOVE ABSOLUTE 100 foo;

-- Test 112: query (line 501)
FETCH 1 foo;

-- Test 113: statement (line 505)
ROLLBACK;

-- Test 114: query (line 509)
SELECT * FROM pg_catalog.pg_cursors;

-- Test 115: statement (line 514)
BEGIN; DECLARE foo CURSOR FOR SELECT * FROM a ORDER BY a;

-- Test 116: query (line 517)
SELECT name, statement, is_scrollable, is_holdable, is_binary, now() - creation_time < '1 second'::interval FROM pg_catalog.pg_cursors;

-- Test 117: statement (line 522)
DECLARE bar CURSOR FOR SELECT 1,2,3;

-- Test 118: query (line 525)
SELECT statement FROM pg_catalog.pg_cursors;

-- Test 119: statement (line 531)
CLOSE foo;

-- Test 120: query (line 534)
SELECT name, statement, is_scrollable, is_holdable, is_binary FROM pg_catalog.pg_cursors;

-- Test 121: statement (line 539)
ROLLBACK;

-- Test 122: query (line 542)
SELECT name, statement, is_scrollable, is_holdable, is_binary FROM pg_catalog.pg_cursors;

-- Test 123: statement (line 546)
BEGIN; DECLARE bar CURSOR FOR SELECT 1,2,3;

-- Test 124: query (line 549)
SELECT name, statement, is_scrollable, is_holdable, is_binary FROM pg_catalog.pg_cursors;

-- Test 125: statement (line 554)
COMMIT;

-- skipif config schema-locked-disabled

-- Test 126: statement (line 558)
-- CockroachDB-specific setting, commenting out
-- ALTER TABLE a SET (schema_locked=false);

-- Test 127: query (line 561)
SELECT name, statement, is_scrollable, is_holdable, is_binary FROM pg_catalog.pg_cursors;

-- Test 128: statement (line 566)
BEGIN;
DECLARE foo CURSOR FOR WITH x AS (INSERT INTO a VALUES (1, 2) RETURNING a) SELECT * FROM x;

-- Test 129: statement (line 572)
ROLLBACK;
BEGIN;
DECLARE foo CURSOR FOR SELECT * FROM doesntexist;

-- Test 130: statement (line 577)
ROLLBACK;
BEGIN;

-- Test 131: statement (line 582)
DECLARE foo CURSOR FOR SELECT teeth FROM a;

-- Test 132: statement (line 588)
ROLLBACK;
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
DECLARE foo CURSOR FOR SELECT 1;
FETCH foo;

-- Test 133: statement (line 594)
ALTER TABLE a ADD COLUMN c INT;

-- Test 134: statement (line 597)
ROLLBACK;
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
DECLARE foo CURSOR FOR SELECT 1;
CLOSE foo;

-- Test 135: statement (line 605)
ALTER TABLE a ADD COLUMN c INT;

-- Test 136: statement (line 608)
COMMIT;

-- Test 137: statement (line 611)
BEGIN;

-- Test 138: statement (line 614)
DECLARE "a"" b'c" CURSOR FOR SELECT 1;

-- Test 139: query (line 617)
FETCH 1 "a"" b'c";

-- Test 140: statement (line 622)
CLOSE "a"" b'c";
DECLARE "a b" CURSOR FOR SELECT 2;

-- Test 141: query (line 626)
FETCH 1 "a b";

-- Test 142: statement (line 631)
CLOSE "a b";
DECLARE "a\b" CURSOR FOR SELECT 3;

-- Test 143: query (line 635)
FETCH 1 "a\b";

-- Test 144: statement (line 640)
CLOSE "a\b";

-- Test 145: query (line 643)
FETCH 1 a b;

-- statement ok
COMMIT;

-- skipif config schema-locked-disabled
-- statement ok
-- ALTER TABLE a SET (schema_locked=true);

-- # Test holdable cursors.
-- subtest holdable

-- statement ok
SET client_min_messages = warning;
DROP TABLE IF EXISTS t;
RESET client_min_messages;

CREATE TABLE t (x INT PRIMARY KEY, y INT);
INSERT INTO t (SELECT t, t%7 FROM generate_series(1, 10) g(t));

-- # A holdable cursor can be declared in an implicit transaction.
-- statement ok
DECLARE foo CURSOR WITH HOLD FOR SELECT 1;

-- query I
FETCH 1 foo;

-- Test 146: statement (line 671)
CLOSE foo;

-- Test 147: statement (line 674)
BEGIN;

-- Test 148: statement (line 677)
DECLARE foo CURSOR WITH HOLD FOR SELECT 1;

-- Test 149: statement (line 680)
DECLARE bar CURSOR WITH HOLD FOR SELECT 2;

-- Test 150: query (line 683)
FETCH 1 foo;

-- Test 151: statement (line 688)
CLOSE foo;

-- Test 152: statement (line 691)
COMMIT;

-- Test 153: query (line 694)
FETCH 1 bar;

-- Test 154: statement (line 699)
CLOSE bar;

-- Test 155: statement (line 702)
BEGIN;

-- Test 156: statement (line 705)
DECLARE foo CURSOR WITH HOLD FOR SELECT * FROM generate_series(1, 10);

-- Test 157: statement (line 708)
COMMIT;

-- Test 158: query (line 711)
FETCH 2 foo;

-- Test 159: statement (line 717)
BEGIN;

-- Test 160: statement (line 720)
DECLARE bar CURSOR WITH HOLD FOR SELECT 1;

-- Test 161: statement (line 723)
ROLLBACK;

-- Test 162: query (line 728)
SELECT name FROM pg_cursors;

-- Test 163: query (line 733)
FETCH 2 foo;

-- Test 164: statement (line 739)
CLOSE foo;

-- Test 165: statement (line 743)
DECLARE foo CURSOR WITH HOLD FOR SELECT * FROM t ORDER BY x;

-- Test 166: query (line 746)
FETCH 3 foo;

-- Test 167: statement (line 754)
BEGIN;
DECLARE bar CURSOR WITH HOLD FOR SELECT * FROM t ORDER BY x;

-- Test 168: query (line 758)
FETCH 3 bar;

-- Test 169: statement (line 765)
COMMIT;

-- Test 170: query (line 768)
FETCH 3 bar;

-- Test 171: query (line 776)
FETCH 3 foo;

-- Test 172: statement (line 784)
CLOSE ALL;

-- Test 173: query (line 787)
SELECT name FROM pg_cursors;

-- Test 174: statement (line 792)
BEGIN;

-- Test 175: statement (line 795)
DECLARE foo CURSOR WITH HOLD FOR SELECT 1;

-- Test 176: statement (line 798)
PREPARE TRANSACTION 'read-only';

-- Test 177: query (line 801)
SELECT name FROM pg_cursors;

-- Test 178: statement (line 805)
BEGIN;

-- Test 179: statement (line 808)
DECLARE foo CURSOR WITH HOLD FOR SELECT 1;

-- Test 180: statement (line 811)
CLOSE foo;

-- Test 181: statement (line 814)
PREPARE TRANSACTION 'read-only';

-- Test 182: statement (line 817)
COMMIT PREPARED 'read-only';

-- Test 183: statement (line 821)
DECLARE foo CURSOR WITH HOLD FOR SELECT * FROM t FOR UPDATE;

-- Test 184: statement (line 824)
DROP TABLE t;

-- Test 185: statement (line 833)
BEGIN;
-- CockroachDB-specific table, commenting out
-- declare a cursor for select * from crdb_internal.gossip_network;
-- FETCH 1 FROM a;
COMMIT;

-- Test 186: statement (line 844)
-- CockroachDB-specific setting
-- SET declare_cursor_statement_timeout_enabled = false;
BEGIN;
SET statement_timeout = '1s';
DECLARE a CURSOR FOR SELECT * FROM ( VALUES (1), (2) ) t(id);

-- Test 187: statement (line 851)
select pg_sleep(0.7);

-- Test 188: query (line 854)
FETCH 1 FROM a;

-- Test 189: statement (line 859)
select pg_sleep(0.7);

-- Test 190: query (line 862)
FETCH 1 FROM a;

-- Test 191: statement (line 867)
SET statement_timeout = 0;
COMMIT;

-- Test 192: statement (line 871)
-- CockroachDB-specific setting
-- RESET autocommit_before_ddl;

-- Test 193: statement (line 880)
DECLARE foo CURSOR WITH HOLD FOR SELECT 1 / 0;

-- Test 194: statement (line 883)
DECLARE curs CURSOR WITH HOLD FOR SELECT 100;

-- Test 195: statement (line 886)
BEGIN;

-- Test 196: statement (line 889)
DECLARE foo CURSOR FOR SELECT 1;

-- Test 197: statement (line 892)
DECLARE bar CURSOR WITH HOLD FOR SELECT 2;

-- Test 198: statement (line 895)
DECLARE baz CURSOR WITH HOLD FOR SELECT 1 / 0;

-- Test 199: statement (line 898)
DECLARE bar2 CURSOR WITH HOLD FOR SELECT 3;

-- Test 200: statement (line 901)
INSERT INTO a VALUES (-1, -2);

-- Test 201: statement (line 904)
COMMIT;

-- Test 202: query (line 908)
SELECT name FROM pg_cursors;

-- Test 203: query (line 914)
SELECT * FROM a ORDER BY a LIMIT 1;

-- Test 204: statement (line 919)
CLOSE curs;

-- Test 205: statement (line 928)
SET client_min_messages = warning;
DROP TABLE IF EXISTS empty;
RESET client_min_messages;

CREATE TABLE empty (k INT PRIMARY KEY);

-- Test 206: statement (line 931)
BEGIN;
DECLARE foo CURSOR WITH HOLD FOR SELECT * FROM empty;
COMMIT;
