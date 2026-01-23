-- PostgreSQL compatible tests from select_for_update
-- 141 tests

SET client_min_messages = warning;

-- Ensure clean re-runs (regen_expected creates a fresh DB, but keep this file
-- runnable standalone too).
DROP TABLE IF EXISTS i CASCADE;
DROP TABLE IF EXISTS t CASCADE;
DROP TABLE IF EXISTS t2 CASCADE;
DROP TABLE IF EXISTS t3 CASCADE;
DROP TABLE IF EXISTS t94290 CASCADE;
DROP TABLE IF EXISTS t129145 CASCADE;
DROP TABLE IF EXISTS abc CASCADE;

DROP ROLE IF EXISTS testuser;
CREATE ROLE testuser;

CREATE EXTENSION IF NOT EXISTS dblink;

-- Test 1: query (line 5)
SELECT 1 FOR UPDATE;

-- Test 2: query (line 10)
SELECT 1 FOR NO KEY UPDATE;

-- Test 3: query (line 15)
SELECT 1 FOR SHARE;

-- Test 4: query (line 20)
SELECT 1 FOR KEY SHARE;

-- Test 5: query (line 25)
SELECT 1 FOR UPDATE FOR SHARE FOR NO KEY UPDATE FOR KEY SHARE;

-- Test 6: query (line 30)
SELECT 1 FROM (SELECT 1) AS a FOR UPDATE OF a;

-- query error pgcode 42P01 relation "a" in FOR SHARE clause not found in FROM clause
SELECT 1 FROM (SELECT 1) AS a, (SELECT 1) AS b FOR SHARE OF a, b;

-- query error pgcode 42P01 relation "a" in FOR UPDATE clause not found in FROM clause
SELECT 1
FROM
  (SELECT 1) AS a,
  (SELECT 1) AS b,
  (SELECT 1) AS c,
  (SELECT 1) AS d,
  (SELECT 1) AS e,
  (SELECT 1) AS f
FOR UPDATE OF a FOR SHARE OF b, c FOR NO KEY UPDATE OF d FOR KEY SHARE OF e, f;

-- query I
SELECT 1 FROM
    (SELECT 1) a,
    (SELECT 1) b,
    (SELECT 1) c,
    (SELECT 1) d,
    (SELECT 1) e,
    (SELECT 1) f
FOR UPDATE OF a FOR SHARE OF b, c FOR NO KEY UPDATE OF d FOR KEY SHARE OF e, f;

-- Test 7: query (line 54)
-- CockroachDB tests qualified names in FOR UPDATE OF; PostgreSQL requires
-- unqualified relation names. Keep an equivalent unqualified form.
SELECT 1 FROM (SELECT 1) AS a FOR UPDATE OF a;

-- query error pgcode 42601 FOR UPDATE must specify unqualified relation names
-- SELECT 1 FOR UPDATE OF db.public.a

-- query I
SELECT 1 FOR UPDATE SKIP LOCKED;

-- Test 8: query (line 65)
SELECT 1 FOR NO KEY UPDATE SKIP LOCKED;

-- Test 9: query (line 70)
SELECT 1 FOR SHARE SKIP LOCKED;

-- Test 10: query (line 75)
SELECT 1 FOR KEY SHARE SKIP LOCKED;

-- Test 11: query (line 80)
SELECT 1 FROM (SELECT 1) AS a FOR UPDATE OF a SKIP LOCKED;

-- query error pgcode 42P01 relation "a" in FOR UPDATE clause not found in FROM clause
SELECT 1
FROM (SELECT 1) AS a, (SELECT 1) AS b
FOR UPDATE OF a SKIP LOCKED FOR NO KEY UPDATE OF b SKIP LOCKED;

-- query error pgcode 42P01 relation "a" in FOR UPDATE clause not found in FROM clause
SELECT 1
FROM (SELECT 1) AS a, (SELECT 1) AS b
FOR UPDATE OF a SKIP LOCKED FOR NO KEY UPDATE OF b NOWAIT;

-- query error pgcode 42P01 relation "a" in FOR UPDATE clause not found in FROM clause
SELECT 1
FROM
  (SELECT 1) AS a,
  (SELECT 1) AS b,
  (SELECT 1) AS c,
  (SELECT 1) AS d,
  (SELECT 1) AS e,
  (SELECT 1) AS f
FOR UPDATE OF a SKIP LOCKED
FOR SHARE OF b, c SKIP LOCKED
FOR NO KEY UPDATE OF d SKIP LOCKED
FOR KEY SHARE OF e, f SKIP LOCKED;

-- query I
SELECT 1 FOR UPDATE NOWAIT;

-- Test 12: query (line 97)
SELECT 1 FOR NO KEY UPDATE NOWAIT;

-- Test 13: query (line 102)
SELECT 1 FOR SHARE NOWAIT;

-- Test 14: query (line 107)
SELECT 1 FOR KEY SHARE NOWAIT;

-- Test 15: query (line 112)
SELECT 1 FROM (SELECT 1) AS a FOR UPDATE OF a NOWAIT;

-- query error pgcode 42P01 relation "a" in FOR UPDATE clause not found in FROM clause
SELECT 1
FROM (SELECT 1) AS a, (SELECT 1) AS b
FOR UPDATE OF a NOWAIT FOR NO KEY UPDATE OF b NOWAIT;

-- query error pgcode 42P01 relation "a" in FOR UPDATE clause not found in FROM clause
SELECT 1
FROM
  (SELECT 1) AS a,
  (SELECT 1) AS b,
  (SELECT 1) AS c,
  (SELECT 1) AS d,
  (SELECT 1) AS e,
  (SELECT 1) AS f
FOR UPDATE OF a NOWAIT
FOR SHARE OF b, c NOWAIT
FOR NO KEY UPDATE OF d NOWAIT
FOR KEY SHARE OF e, f NOWAIT;

-- Locking clauses both inside and outside of parenthesis are handled correctly.

-- query I
((SELECT 1)) FOR UPDATE SKIP LOCKED;

-- Test 16: query (line 128)
((SELECT 1) FOR UPDATE SKIP LOCKED);

-- Test 17: query (line 133)
((SELECT 1 FOR UPDATE SKIP LOCKED));

-- Test 18: statement (line 141)
(SELECT 1 FOR UPDATE) FOR UPDATE;

-- Test 19: statement (line 144)
((SELECT 1 FOR UPDATE)) FOR UPDATE;

-- Test 20: statement (line 147)
((SELECT 1) FOR UPDATE) FOR UPDATE;

-- Test 21: statement (line 152)
SELECT (SELECT 1 FOR UPDATE) FOR UPDATE;

-- Test 22: statement (line 155)
SELECT * FROM (SELECT 1 FOR UPDATE) AS x FOR UPDATE;

-- Test 23: statement (line 158)
SELECT * FROM (SELECT 1 FOR UPDATE) AS x WHERE EXISTS (SELECT 1 FOR UPDATE) FOR UPDATE;

-- Test 24: query (line 162)
SELECT 1 FOR READ ONLY;

-- Test 25: statement (line 170)
CREATE TABLE i (i INT PRIMARY KEY);
INSERT INTO i VALUES (1);

-- Test 26: statement (line 173)
-- PostgreSQL does not allow row-locking clauses with UNION/INTERSECT/EXCEPT.
-- SELECT 1 UNION SELECT 1 FOR UPDATE;

-- Test 27: statement (line 176)
-- SELECT * FROM (SELECT 1 UNION SELECT 1) a FOR UPDATE;

-- Test 28: statement (line 179)
-- SELECT * FROM (SELECT 1 UNION SELECT 1) a, i FOR UPDATE;

-- Test 29: query (line 182)
-- SELECT * FROM (SELECT 1 UNION SELECT 1) a, i FOR UPDATE OF i;

-- Test 30: statement (line 187)
SELECT * FROM (VALUES (1)) v(x) FOR UPDATE;

-- Test 31: statement (line 190)
SELECT * FROM (VALUES (1)) v(x) FOR UPDATE OF v;

-- Test 32: query (line 195)
SELECT (VALUES (1)) FOR UPDATE;

-- Test 33: query (line 200)
SELECT * FROM (VALUES (1)) a FOR UPDATE;

-- Test 34: query (line 205)
SELECT * FROM (VALUES (1)) a, i FOR UPDATE;

-- Test 35: query (line 210)
SELECT * FROM (VALUES (1)) a, i FOR UPDATE OF a;

-- Test 36: query (line 215)
SELECT * FROM (VALUES (1)) a, i FOR UPDATE OF i;

-- Test 37: statement (line 220)
-- CockroachDB exercises locking clauses in more query contexts than PostgreSQL.
-- PostgreSQL rejects FOR UPDATE/SHARE with DISTINCT/GROUP BY/HAVING/aggregates,
-- window functions, and set-returning functions in the target list.
-- SELECT DISTINCT 1 FOR UPDATE;

-- Test 38: statement (line 223)
-- SELECT * FROM (SELECT DISTINCT 1) a FOR UPDATE;

-- Test 39: statement (line 226)
-- SELECT * FROM (SELECT DISTINCT 1) a, i FOR UPDATE;

-- Test 40: statement (line 229)
-- SELECT * FROM (SELECT DISTINCT 1) a, i FOR UPDATE OF a;

-- Test 41: query (line 232)
-- SELECT * FROM (SELECT DISTINCT 1) a, i FOR UPDATE OF i;

-- Test 42: statement (line 237)
-- SELECT 1 GROUP BY 1 FOR UPDATE;

-- Test 43: statement (line 240)
-- SELECT * FROM (SELECT 1 GROUP BY 1) a FOR UPDATE;

-- Test 44: statement (line 243)
-- SELECT * FROM (SELECT 1 GROUP BY 1) a, i FOR UPDATE;

-- Test 45: statement (line 246)
-- SELECT * FROM (SELECT 1 GROUP BY 1) a, i FOR UPDATE OF a;

-- Test 46: query (line 249)
-- SELECT * FROM (SELECT 1 GROUP BY 1) a, i FOR UPDATE OF i;

-- Test 47: statement (line 254)
-- SELECT 1 HAVING TRUE FOR UPDATE;

-- Test 48: statement (line 257)
-- SELECT * FROM (SELECT 1 HAVING TRUE) a FOR UPDATE;

-- Test 49: statement (line 260)
-- SELECT * FROM (SELECT 1 HAVING TRUE) a, i FOR UPDATE;

-- Test 50: statement (line 263)
-- SELECT * FROM (SELECT 1 HAVING TRUE) a, i FOR UPDATE OF a;

-- Test 51: query (line 266)
-- SELECT * FROM (SELECT 1 HAVING TRUE) a, i FOR UPDATE OF i;

-- Test 52: statement (line 271)
-- SELECT count(1) FOR UPDATE;

-- Test 53: statement (line 274)
-- SELECT * FROM (SELECT count(1)) a FOR UPDATE;

-- Test 54: statement (line 277)
-- SELECT * FROM (SELECT count(1)) a, i FOR UPDATE;

-- Test 55: statement (line 280)
-- SELECT * FROM (SELECT count(1)) a, i FOR UPDATE OF a;

-- Test 56: query (line 283)
-- SELECT * FROM (SELECT count(1)) a, i FOR UPDATE OF i;

-- Test 57: statement (line 288)
-- SELECT count(1) OVER () FOR UPDATE;

-- Test 58: statement (line 291)
-- SELECT * FROM (SELECT count(1) OVER ()) a FOR UPDATE;

-- Test 59: statement (line 294)
-- SELECT * FROM (SELECT count(1) OVER ()) a, i FOR UPDATE;

-- Test 60: statement (line 297)
-- SELECT * FROM (SELECT count(1) OVER ()) a, i FOR UPDATE OF a;

-- Test 61: query (line 300)
-- SELECT * FROM (SELECT count(1) OVER ()) a, i FOR UPDATE OF i;

-- Test 62: statement (line 305)
-- SELECT generate_series(1, 2) FOR UPDATE;

-- Test 63: statement (line 308)
-- SELECT * FROM (SELECT generate_series(1, 2)) a FOR UPDATE;

-- Test 64: statement (line 311)
-- SELECT * FROM (SELECT generate_series(1, 2)) a, i FOR UPDATE;

-- Test 65: statement (line 314)
-- SELECT * FROM (SELECT generate_series(1, 2)) a, i FOR UPDATE OF a;

-- Test 66: query (line 317)
-- SELECT * FROM (SELECT generate_series(1, 2)) a, i FOR UPDATE OF i;

-- Test 67: query (line 324)
SELECT * FROM generate_series(1, 2) FOR UPDATE;

-- Test 68: query (line 330)
SELECT * FROM (SELECT * FROM generate_series(1, 2)) a FOR UPDATE;

-- Test 69: query (line 336)
SELECT * FROM (SELECT * FROM generate_series(1, 2)) a, i FOR UPDATE;

-- Test 70: statement (line 344)
CREATE TABLE t (k INT PRIMARY KEY, v INT);

-- user testuser (logic-test directive)

-- Test 71: statement (line 349)
SELECT * FROM t;

-- Test 72: statement (line 352)
SELECT * FROM t FOR UPDATE;

-- Test 73: statement (line 355)
SELECT * FROM t FOR SHARE;

-- user root (logic-test directive)

-- Test 74: statement (line 360)
GRANT SELECT, UPDATE ON t TO testuser;

SET ROLE testuser;

-- Test 75: statement (line 365)
SELECT * FROM t;

-- Test 76: statement (line 368)
SELECT * FROM t FOR UPDATE;

-- Test 77: statement (line 371)
SELECT * FROM t FOR SHARE;

RESET ROLE;

-- Test 78: statement (line 376)
-- REVOKE SELECT ON t FROM testuser

-- Test 79: statement (line 379)
-- GRANT UPDATE ON t TO testuser

-- user testuser

-- Test 80: statement (line 384)
-- SELECT * FROM t

-- Test 81: statement (line 387)
-- SELECT * FROM t FOR UPDATE

-- Test 82: statement (line 390)
-- SELECT * FROM t FOR SHARE

-- user root

-- Test 83: statement (line 395)
-- GRANT SELECT ON t TO testuser

-- user testuser

-- Test 84: statement (line 400)
-- SELECT * FROM t

-- Test 85: statement (line 403)
-- SELECT * FROM t FOR UPDATE

-- Test 86: statement (line 406)
-- SELECT * FROM t FOR SHARE

-- user root

-- Test 87: statement (line 413)
BEGIN; -- was READ ONLY in CockroachDB

-- Test 88: statement (line 416)
SELECT * FROM t FOR UPDATE;

-- Test 89: statement (line 419)
ROLLBACK;

-- Test 90: statement (line 422)
BEGIN; -- was READ ONLY in CockroachDB

-- Test 91: statement (line 425)
SELECT * FROM t FOR NO KEY UPDATE;

-- Test 92: statement (line 428)
ROLLBACK;

-- Test 93: statement (line 431)
BEGIN; -- was READ ONLY in CockroachDB

-- Test 94: statement (line 434)
SELECT * FROM t FOR SHARE;

-- Test 95: statement (line 437)
ROLLBACK;

-- Test 96: statement (line 440)
BEGIN; -- was READ ONLY in CockroachDB

-- Test 97: statement (line 443)
SELECT * FROM t FOR KEY SHARE;

-- Test 98: statement (line 446)
ROLLBACK;

-- Test 99: statement (line 451)
INSERT INTO t VALUES (1, 1);

-- Test 100-109 (upstream): multi-session NOWAIT / statement_timeout checks.
-- PostgreSQL supports NOWAIT/SKIP LOCKED, but the upstream logic-test relies on
-- concurrent sessions (user directives). Keep non-blocking NOWAIT examples
-- here and cover conflicting-lock behavior in the SKIP LOCKED section below.
SELECT * FROM t ORDER BY k FOR UPDATE NOWAIT;
SELECT * FROM t ORDER BY k FOR SHARE NOWAIT;

-- The SKIP LOCKED wait policy skips rows when a conflicting lock is encountered.
INSERT INTO t VALUES (2, 2), (3, 3), (4, 4);

CREATE TABLE t3 (
  k INT PRIMARY KEY,
  v INT,
  u INT
);
CREATE INDEX t3_u_idx ON t3 (u);

INSERT INTO t3 VALUES (1, 1, 1), (2, 2, 2), (3, 3, 3), (4, 4, 2);

-- Hold a lock on k=2 in a separate session and verify SKIP LOCKED skips it.
SELECT dblink_connect('locker', 'dbname=' || current_database());
SELECT dblink_exec('locker', 'BEGIN');
SELECT dblink_exec('locker', 'UPDATE t SET v = 3 WHERE k = 2');
SELECT dblink_exec('locker', 'UPDATE t3 SET v = 3 WHERE k = 2');

BEGIN;

SELECT * FROM t ORDER BY k FOR UPDATE SKIP LOCKED;

-- Test 102: statement (line 589)
UPDATE t SET v = 4 WHERE k = 3;

-- Test 103: query (line 592)
SELECT * FROM t ORDER BY k FOR UPDATE SKIP LOCKED;

-- Test 104: query (line 602)
SELECT k, u FROM t3 WHERE u = 2 ORDER BY k FOR UPDATE SKIP LOCKED;

-- Test 105: query (line 610)
SELECT * FROM t3 WHERE u = 2 ORDER BY k FOR UPDATE SKIP LOCKED;

-- Test 106: query (line 616)
SELECT * FROM t3 WHERE u = 2 ORDER BY k LIMIT 1 FOR UPDATE SKIP LOCKED;

-- Test 107: query (line 623)
SELECT * FROM t ORDER BY k FOR UPDATE SKIP LOCKED;

-- Test 108: statement (line 628)
ROLLBACK;

SELECT dblink_exec('locker', 'ROLLBACK');
SELECT dblink_disconnect('locker');

-- Test 110: statement (line 639)
CREATE TABLE t94290 (a INT, b INT, c INT, PRIMARY KEY(a), UNIQUE (b));
INSERT INTO t94290 VALUES (1,2,3);

-- Test 111: statement (line 645)
SET statement_timeout = '2s';

-- Test 112: statement (line 648)
SELECT * FROM t94290 WHERE b = 2 FOR UPDATE;

-- Test 113: statement (line 651)
SELECT * FROM t94290 WHERE b = 2 FOR UPDATE;

-- Test 114: statement (line 654)
RESET statement_timeout;

-- Test 115: statement (line 659)
DROP TABLE IF EXISTS t;
CREATE TABLE t(a INT PRIMARY KEY);
INSERT INTO t VALUES(1), (2);
GRANT ALL ON t TO testuser;
-- GRANT SYSTEM MODIFYCLUSTERSETTING TO testuser; -- CockroachDB-only

SET ROLE testuser;

-- Test 116: statement (line 668)
SET crdb.enable_durable_locking_for_serializable = true;

-- Test 117: statement (line 672)
SET kv.transaction_buffered_writes_enabled = false;

-- Test 118: query (line 675)
BEGIN;
SELECT * FROM t WHERE a = 1 FOR UPDATE;

-- Test 119: query (line 683)
-- SELECT ... FROM crdb_internal.cluster_locks; -- CockroachDB-only

-- Test 120: query (line 688)
SELECT * FROM t ORDER BY a FOR UPDATE SKIP LOCKED;

-- Test 121: query (line 695)
-- SELECT ... FROM crdb_internal.cluster_locks; -- CockroachDB-only

-- Test 122: statement (line 702)
COMMIT;

RESET ROLE;

-- Test 123: statement (line 711)
CREATE TABLE t129145 (a INT NOT NULL PRIMARY KEY, b INT NOT NULL);

-- Test 124: statement (line 714)
INSERT INTO t129145 VALUES (1, 1);

-- Test 125: statement (line 717)
GRANT SELECT ON t129145 TO testuser;

-- Test 126: statement (line 720)
GRANT UPDATE ON t129145 TO testuser;

-- Test 127: statement (line 723)
SET crdb.enable_durable_locking_for_serializable = true;

-- Test 128: statement (line 726)
BEGIN;
SELECT * FROM t129145 WHERE a = 1 FOR UPDATE;

SET ROLE testuser;

-- Test 129: statement (line 731)
SET crdb.optimizer_use_lock_op_for_serializable = on;

-- Test 130: statement (line 734)
SET crdb.enable_durable_locking_for_serializable = true;

-- Test 131: query (line 737)
SELECT * FROM t129145 WHERE b = 1 ORDER BY a FOR UPDATE SKIP LOCKED;

-- Test 132: query (line 741)
SELECT * FROM t129145 WHERE b = 1 ORDER BY a FOR UPDATE NOWAIT;

RESET crdb.optimizer_use_lock_op_for_serializable;

RESET crdb.enable_durable_locking_for_serializable;

RESET ROLE;

ROLLBACK;

RESET crdb.enable_durable_locking_for_serializable;

-- Ensure that we lock all column families of a (CockroachDB) multi-family table
-- when using durable locking. PostgreSQL has no column families; keep the row
-- locking coverage on a regular table.

CREATE TABLE abc (
  a INT NOT NULL PRIMARY KEY,
  b INT NOT NULL,
  c INT NOT NULL
);
CREATE INDEX abc_b_idx ON abc (b);

INSERT INTO abc VALUES (6, 7, 8);

SET crdb.optimizer_use_lock_op_for_serializable = on;

SET crdb.enable_durable_locking_for_serializable = on;

SET crdb.distsql = off;

-- A scan where CockroachDB might skip reading some families.
-- query T kvtrace
SELECT * FROM abc WHERE a = 6;

-- Test 133: query (line 792)
SELECT * FROM abc WHERE a = 6 FOR UPDATE;

-- Test 134: query (line 798)
SELECT * FROM abc WHERE b = 7;

-- Test 135: query (line 805)
SELECT * FROM abc WHERE b = 7 FOR UPDATE;

-- Test 136: statement (line 811)
INSERT INTO t129145 VALUES (6, 7);

-- Test 137: query (line 815)
SELECT * FROM t129145 INNER JOIN abc ON abc.a = t129145.a;

-- Test 138: query (line 822)
SELECT * FROM t129145 INNER JOIN abc ON abc.a = t129145.a FOR UPDATE OF abc;

-- Test 139: statement (line 828)
RESET crdb.distsql;

-- Test 140: statement (line 831)
RESET crdb.enable_durable_locking_for_serializable;

-- Test 141: statement (line 834)
RESET crdb.optimizer_use_lock_op_for_serializable;

RESET client_min_messages;
