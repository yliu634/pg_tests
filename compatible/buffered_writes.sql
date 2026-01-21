-- PostgreSQL compatible tests from buffered_writes
-- 127 tests

SET client_min_messages = warning;

-- Ensure clean re-runs.
DROP TABLE IF EXISTS t1, t2, t3, t4, uvw, large, t5, t6, t7 CASCADE;
DROP ROLE IF EXISTS testuser;
CREATE ROLE testuser;

-- Test 1: statement (line 3)
-- CRDB setting; in PG treat as a custom GUC (no-op).
SET kv.transaction_buffered_writes_enabled = true;

-- Test 2: statement (line 10)
-- CRDB-only syntax; rewrite as a custom GUC so the test runs.
SET kv.transaction.write_buffering.max_buffer_size = '2KiB';

-- Test 3: statement (line 13)
CREATE TABLE t1 (pk int primary key, v int);

-- Test 4: statement (line 18)
INSERT INTO t1 VALUES (1,1);

-- Test 5: statement (line 21)
BEGIN;

-- Test 6: statement (line 24)
DELETE FROM t1 WHERE pk = 1;

-- Test 7: statement (line 27)
DELETE FROM t1 WHERE pk = 3;

-- Test 8: statement (line 30)
COMMIT;

-- Test 9: statement (line 35)
INSERT INTO t1 VALUES (1,1);

-- Test 10: statement (line 38)
BEGIN;

-- Test 11: statement (line 41)
DELETE FROM t1 WHERE pk = 1;

-- Test 12: statement (line 46)
DELETE FROM t1 WHERE pk = 1;

-- Test 13: statement (line 49)
COMMIT;

-- Test 14: statement (line 54)
BEGIN;

-- Test 15: statement (line 57)
INSERT INTO t1 VALUES (1,1);

-- Test 16: statement (line 60)
DELETE FROM t1 WHERE pk = 1;

-- Test 17: statement (line 65)
DELETE FROM t1 WHERE pk = 1;

-- Test 18: statement (line 68)
COMMIT;

-- Test 19: statement (line 73)
INSERT INTO t1 VALUES (1,1);

-- Test 20: statement (line 76)
BEGIN;

-- Test 21: statement (line 79)
DELETE FROM t1 WHERE pk = 1;

-- Test 22: statement (line 82)
INSERT INTO t1 VALUES (1,1);

-- Test 23: statement (line 85)
COMMIT;

-- Test 24: query (line 88)
SELECT * FROM t1 ORDER BY pk;

-- Test 25: statement (line 93)
CREATE TABLE t2 (k INT PRIMARY KEY);

-- Test 26: statement (line 96)
BEGIN;

-- Test 27: statement (line 99)
INSERT INTO t2 VALUES (1), (1) ON CONFLICT DO NOTHING;

-- Test 28: statement (line 102)
ROLLBACK;

-- Test 29: statement (line 105)
BEGIN;

-- Test 30: statement (line 108)
INSERT INTO t2 VALUES (1);

-- Test 31: statement (line 111)
INSERT INTO t2 VALUES (1) ON CONFLICT DO NOTHING;

-- Test 32: statement (line 114)
ROLLBACK;

-- Test 33: statement (line 117)
BEGIN;

-- Test 34: statement (line 120)
INSERT INTO t2 VALUES (1);

-- Test 35: statement (line 123)
DELETE FROM t2 WHERE k = 1;

-- Test 36: statement (line 126)
INSERT INTO t2 VALUES (1);

-- Test 37: statement (line 129)
COMMIT;

-- Test 38: query (line 132)
SELECT * FROM t2 ORDER BY k;

-- Test 39: statement (line 140)
CREATE TABLE t3 (k INT PRIMARY KEY);

-- Test 40: statement (line 143)
INSERT INTO t3 VALUES (1);

-- Test 41: statement (line 146)
BEGIN;

-- Test 42: statement (line 149)
INSERT INTO t3 VALUES (2);

-- Test 43: statement (line 152)
DELETE FROM t3 WHERE k = 3;

-- Test 44: statement (line 155)
DELETE FROM t3 WHERE k < 10 AND k > 0;

-- Test 45: statement (line 158)
COMMIT;

-- Test 46: query (line 161)
SELECT count(*) FROM t3;

-- Test 47: statement (line 174)
CREATE TABLE t4 (k INT PRIMARY KEY, v INT);

-- Test 48: statement (line 177)
CREATE INDEX idx ON t4 (v);

-- Test 49: statement (line 180)
BEGIN;
INSERT INTO t4 VALUES(1, 100), (2, 200), (3, 300);
SAVEPOINT s1;
INSERT INTO t4 VALUES(4, 400), (5, 500), (6, 600);

-- Test 50: query (line 186)
SELECT * FROM t4 ORDER BY k;

-- Test 51: statement (line 196)
SAVEPOINT s2;
INSERT INTO t4 VALUES(7, 700), (8, 800), (9, 900);

-- Test 52: query (line 200)
SELECT * FROM t4 ORDER BY k;

-- Test 53: statement (line 214)
DELETE FROM t4 WHERE k = 1;

-- Test 54: statement (line 217)
DELETE FROM t4 WHERE k = 2;

-- Test 55: statement (line 220)
DELETE FROM t4 WHERE k = 3;

-- Test 56: query (line 223)
SELECT * FROM t4 ORDER BY k;

-- Test 57: statement (line 233)
ROLLBACK TO SAVEPOINT s2;

-- Test 58: query (line 236)
SELECT * FROM t4 ORDER BY k;

-- Test 59: statement (line 246)
ROLLBACK TO SAVEPOINT s1;

-- Test 60: query (line 249)
SELECT * FROM t4 ORDER BY k;

-- Test 61: statement (line 256)
COMMIT;

-- Test 62: query (line 259)
SELECT * FROM t4 ORDER BY k;

-- Test 63: statement (line 269)
EXPLAIN (COSTS OFF) SELECT 1;

-- Test 64: statement (line 272)
EXPLAIN (ANALYZE, COSTS OFF, TIMING OFF, SUMMARY OFF) SELECT 1;

-- Test 65: statement (line 278)
-- CRDB-only internal column; stub with NULL.
SELECT k, NULL::bigint AS crdb_internal_origin_id FROM t4 WHERE k = 1;

-- Test 66: statement (line 282)
SELECT k, NULL::bigint AS crdb_internal_origin_id FROM t4 ORDER BY k;

-- Test 67: statement (line 286)
SELECT k, NULL::bigint AS crdb_internal_origin_id FROM t4 ORDER BY k DESC;

-- Test 68: statement (line 289)
CREATE TABLE uvw (
  u INT,
  v INT,
  w INT
);

-- Test 69: statement (line 296)
BEGIN;
INSERT INTO uvw SELECT u, v, w FROM
  generate_series(0, 3) AS u,
  generate_series(0, 3) AS v,
  generate_series(0, 3) AS w;

-- Test 70: query (line 303)
SELECT count(*) FROM uvw;

-- Test 71: statement (line 308)
COMMIT;

-- Test 72: statement (line 311)
DROP TABLE uvw;

-- Test 73: statement (line 314)
CREATE TABLE uvw (
  u INT,
  v INT,
  w INT
);
CREATE INDEX uvw_idx ON uvw (u, v, w);

-- Test 74: statement (line 322)
BEGIN;
INSERT INTO uvw SELECT u, v, w FROM
  generate_series(0, 3) AS u,
  generate_series(0, 3) AS v,
  generate_series(0, 3) AS w;
UPDATE uvw SET u = NULL WHERE u = 0;
UPDATE uvw SET v = NULL WHERE v = 0;
UPDATE uvw SET w = NULL WHERE w = 0;

-- Test 75: query (line 332)
SELECT * FROM uvw ORDER BY u, v, w;

-- Test 76: statement (line 401)
COMMIT;

-- Test 77: query (line 404)
SELECT count(*) FROM uvw;

-- Test 78: statement (line 417)
SET kv.closed_timestamp.target_duration = '99999s';

RESET ROLE;

-- Test 79: statement (line 424)
DROP TABLE IF EXISTS large;
CREATE TABLE large (
  k int PRIMARY KEY,
  blob text
);
INSERT INTO large (k, blob)
SELECT i * 100, repeat('a', 1024)
FROM generate_series(1, 4) AS g(i);

-- Test 80: statement (line 427)
BEGIN;

-- Test 81: statement (line 430)
INSERT INTO large SELECT 11 + i * 100, 'b' FROM generate_series(1, 4) AS g(i);

-- Test 82: query (line 434)
SELECT k FROM large ORDER BY k;

-- Test 83: query (line 447)
SELECT k FROM large ORDER BY k DESC;

-- Test 84: statement (line 459)
COMMIT;

-- Test 85: statement (line 464)
CREATE TABLE t5 (pk int primary key, v int);

-- Test 86: statement (line 467)
BEGIN;

-- Test 87: statement (line 470)
INSERT INTO t5 VALUES (1,1);

-- Test 88: statement (line 473)
SAVEPOINT rollback_target;

-- Test 89: statement (line 476)
UPDATE t5 SET v = 2 WHERE pk = 1;

-- Test 90: statement (line 480)
DELETE FROM t5 WHERE pk > 5;

-- Test 91: statement (line 483)
ROLLBACK TO rollback_target;

-- Test 92: statement (line 486)
COMMIT;

-- Test 93: query (line 489)
SELECT pk, v FROM t5 WHERE pk = 1 ORDER BY pk;

-- Test 94: statement (line 496)
CREATE TABLE t6 (pk INT PRIMARY KEY, v INT);
CREATE INDEX t6_v_idx ON t6 (v);
CREATE INDEX t6_v_plus_5_idx ON t6 ((v + 5));

-- Test 95: statement (line 499)
BEGIN;

-- Test 96: statement (line 505)
INSERT INTO t6 VALUES (1,1);

-- Test 97: statement (line 520)
COMMIT;

-- Test 98: statement (line 525)
CREATE TABLE t7 (pk int primary key, v int);

-- Test 99: statement (line 528)
BEGIN;

-- Test 100: statement (line 531)
INSERT INTO t7 VALUES (3,1);

-- Test 101: statement (line 534)
SAVEPOINT rollback_target_1;

-- Test 102: statement (line 537)
UPDATE t7 SET v = 2 WHERE pk = 3;

-- Test 103: statement (line 540)
SAVEPOINT rollback_target_2;

-- Test 104: statement (line 543)
UPDATE t7 SET v = 3 WHERE pk = 3;

-- Test 105: statement (line 547)
DELETE FROM t7 WHERE pk > 5;

-- Test 106: statement (line 550)
ROLLBACK TO rollback_target_2;

-- Test 107: statement (line 553)
COMMIT;

-- Test 108: query (line 556)
SELECT pk, v FROM t7 WHERE pk = 3 ORDER BY pk;

-- Test 109: statement (line 563)
BEGIN;

-- Test 110: statement (line 566)
INSERT INTO t7 VALUES (4,1);

-- Test 111: statement (line 569)
SAVEPOINT rollback_target_1;

-- Test 112: statement (line 572)
UPDATE t7 SET v = 2 WHERE pk = 4;

-- Test 113: statement (line 575)
SAVEPOINT rollback_target_2;

-- Test 114: statement (line 578)
UPDATE t7 SET v = 3 WHERE pk = 4;

-- Test 115: statement (line 581)
ROLLBACK TO rollback_target_2;

-- Test 116: statement (line 585)
DELETE FROM t7 WHERE pk > 5;

-- Test 117: statement (line 588)
COMMIT;

-- Test 118: query (line 591)
SELECT pk, v FROM t7 WHERE pk = 4 ORDER BY pk;

-- Test 119: statement (line 599)
-- CRDB-only setting; treat as a custom GUC (no-op).
SET enable.durable_locking_for_serializable = true;

-- Test 120: statement (line 602)
GRANT ALL ON t7 TO testuser;

-- Test 121: statement (line 605)
-- CRDB-only system privilege.
-- GRANT SYSTEM MODIFYCLUSTERSETTING TO testuser

-- Test 122: statement (line 608)
BEGIN;

-- Test 123: statement (line 611)
INSERT INTO t7 VALUES (5,1);

SET ROLE testuser;

-- Test 124: statement (line 616)
SET kv.transaction.write_buffering.max_buffer_size = '1';

RESET ROLE;

-- Test 125: statement (line 621)
SELECT * from t7 FOR UPDATE SKIP LOCKED;

-- Test 126: statement (line 624)
COMMIT;

-- Test 127: statement (line 627)
RESET enable.durable_locking_for_serializable;

RESET client_min_messages;
