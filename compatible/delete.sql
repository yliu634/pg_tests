-- PostgreSQL compatible tests from delete
-- 118 tests

-- Test 1: statement (line 2)
CREATE TABLE kv (
  k INT PRIMARY KEY,
  v INT,
  UNIQUE INDEX foo (v),
  INDEX bar (k, v)
)

-- Test 2: statement (line 10)
CREATE TABLE unindexed (
  k INT PRIMARY KEY,
  v INT
)

-- Test 3: statement (line 16)
INSERT INTO kv VALUES (1, 2), (3, 4), (5, 6), (7, 8)

-- Test 4: statement (line 19)
INSERT INTO unindexed VALUES (1, 2), (3, 4), (5, 6), (7, 8)

-- Test 5: query (line 22)
SELECT * FROM kv

-- Test 6: statement (line 30)
CREATE VIEW kview AS SELECT k,v FROM kv

-- Test 7: query (line 33)
SELECT * FROM kview

-- Test 8: statement (line 41)
DELETE FROM kview

-- Test 9: query (line 44)
SELECT * FROM kview

-- Test 10: statement (line 52)
DELETE FROM kv WHERE k=3 OR v=6

-- Test 11: query (line 55)
SELECT * FROM kv

-- Test 12: statement (line 62)
DELETE FROM kv WHERE k=5

-- Test 13: query (line 65)
DELETE FROM kv RETURNING k, v

-- Test 14: query (line 71)
SELECT * FROM kv

-- Test 15: statement (line 75)
DELETE FROM kv WHERE nonexistent = 1

-- Test 16: statement (line 78)
DELETE FROM unindexed WHERE k=3 OR v=6

-- Test 17: query (line 81)
SELECT * FROM unindexed

-- Test 18: query (line 87)
DELETE FROM unindexed RETURNING k, v

-- Test 19: query (line 93)
SELECT * FROM unindexed

-- Test 20: statement (line 97)
INSERT INTO unindexed VALUES (1, 2), (3, 4), (5, 6), (7, 8)

-- Test 21: query (line 100)
DELETE FROM unindexed WHERE k=3 or v=6 RETURNING *

-- Test 22: query (line 107)
DELETE FROM unindexed RETURNING unindexed.*

-- Test 23: statement (line 114)
INSERT INTO unindexed VALUES (1, 2), (3, 4), (5, 6), (7, 8)

-- Test 24: query (line 117)
SELECT k, v FROM unindexed

-- Test 25: statement (line 126)
DELETE FROM unindexed

-- Test 26: statement (line 130)
INSERT INTO unindexed VALUES (1, 2), (3, 4), (5, 6), (7, 8)

-- Test 27: statement (line 133)
DELETE FROM unindexed WHERE k >= 4 ORDER BY k LIMIT 1

-- Test 28: query (line 136)
SELECT k, v FROM unindexed

-- Test 29: statement (line 144)
DELETE FROM unindexed

-- Test 30: query (line 147)
SELECT k, v FROM unindexed

-- Test 31: statement (line 154)
INSERT INTO unindexed VALUES (1, 2), (3, 4), (5, 6), (7, 8)

-- Test 32: statement (line 157)
DELETE FROM ONLY unindexed WHERE k >= 4 ORDER BY k LIMIT 1

-- Test 33: query (line 160)
SELECT k, v FROM unindexed

-- Test 34: statement (line 168)
DELETE FROM unindexed * WHERE k >= 7

-- Test 35: query (line 171)
SELECT k, v FROM unindexed

-- Test 36: statement (line 178)
DELETE FROM ONLY unindexed * WHERE k <=3

-- Test 37: query (line 181)
SELECT k, v FROM unindexed

-- Test 38: statement (line 186)
CREATE TABLE indexed (id int primary key, value int, other int, index (value))

-- Test 39: statement (line 189)
DELETE FROM indexed WHERE value = 5

-- Test 40: statement (line 194)
INSERT INTO unindexed VALUES (1, 9), (8, 2), (3, 7), (6, 4)

-- Test 41: query (line 197)
DELETE FROM unindexed WHERE k > 1 AND v < 7 ORDER BY v DESC LIMIT 2 RETURNING v,k

-- Test 42: query (line 203)
DELETE FROM unindexed ORDER BY v LIMIT 2 RETURNING k,v

-- Test 43: statement (line 211)
INSERT INTO unindexed VALUES (1, 2), (3, 4), (5, 6), (7, 8)

-- Test 44: query (line 214)
SELECT count(*) FROM [DELETE FROM unindexed LIMIT 2 RETURNING v]

-- Test 45: query (line 219)
SELECT count(*) FROM [DELETE FROM unindexed LIMIT 1 RETURNING v]

-- Test 46: query (line 224)
SELECT count(*) FROM [DELETE FROM unindexed LIMIT 5 RETURNING v]

-- Test 47: statement (line 231)
CREATE TABLE t29494(x INT PRIMARY KEY) WITH (schema_locked=false); INSERT INTO t29494 VALUES (12)

-- Test 48: statement (line 234)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl=off;
ALTER TABLE t29494 ADD COLUMN y INT NOT NULL DEFAULT 123

-- Test 49: query (line 240)
SELECT create_statement FROM [SHOW CREATE t29494]

-- Test 50: statement (line 249)
DELETE FROM t29494 RETURNING y

-- Test 51: statement (line 252)
ROLLBACK

-- Test 52: statement (line 255)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl=off;
ALTER TABLE t29494 ADD COLUMN y INT NOT NULL DEFAULT 123

-- Test 53: query (line 260)
DELETE FROM t29494 RETURNING *

-- Test 54: statement (line 265)
COMMIT

-- Test 55: statement (line 270)
CREATE TABLE t33361(x INT PRIMARY KEY, y INT UNIQUE, z INT) WITH (schema_locked=false); INSERT INTO t33361 VALUES (1, 2, 3)

-- Test 56: statement (line 273)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl=off;
ALTER TABLE t33361 DROP COLUMN y

-- Test 57: statement (line 278)
DELETE FROM t33361 RETURNING y

-- Test 58: statement (line 281)
ROLLBACK

-- Test 59: statement (line 284)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
ALTER TABLE t33361 DROP COLUMN y

-- Test 60: query (line 288)
DELETE FROM t33361 RETURNING *

-- Test 61: statement (line 293)
COMMIT

-- Test 62: statement (line 297)
CREATE TABLE family (
    x INT PRIMARY KEY,
    y INT,
    FAMILY (x),
    FAMILY (y)
);
INSERT INTO family VALUES (1, 1), (2, 2), (3, 3)

-- Test 63: statement (line 306)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
ALTER TABLE family ADD COLUMN z INT CREATE FAMILY

-- Test 64: statement (line 310)
DELETE FROM family WHERE x=2

-- Test 65: statement (line 313)
COMMIT

-- Test 66: query (line 316)
SELECT x, y, z FROM family

-- Test 67: statement (line 323)
CREATE TABLE a (a INT PRIMARY KEY)

-- Test 68: statement (line 326)
INSERT INTO a SELECT generate_series(1,5)

-- Test 69: statement (line 329)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;


let $ts
SELECT cluster_logical_timestamp()

-- Test 70: statement (line 336)
COMMIT

-- Test 71: statement (line 339)
DELETE FROM a WHERE a <= 3

-- Test 72: query (line 342)
SELECT * FROM a

-- Test 73: statement (line 381)
CREATE TABLE u_d (
  a INT,
  b INT
)

-- Test 74: statement (line 387)
INSERT INTO u_a VALUES (1, 'a', 10), (2, 'b', 20), (3, 'c', 30), (4, 'd', 40)

-- Test 75: statement (line 390)
INSERT INTO u_b VALUES (10, 'a'), (20, 'b'), (30, 'c'), (40, 'd')

-- Test 76: statement (line 393)
INSERT INTO u_c VALUES (1, 'a', 10), (2, 'b', 50), (3, 'c', 50), (4, 'd', 40)

-- Test 77: statement (line 397)
DELETE FROM u_a USING u_b WHERE c = u_b.a AND u_b.b = 'd'

-- Test 78: query (line 400)
SELECT * FROM u_a;

-- Test 79: statement (line 408)
INSERT INTO u_a VALUES (5, 'd', 5), (6, 'e', 6)

-- Test 80: statement (line 411)
DELETE FROM u_a USING u_a u_a2 WHERE u_a.a = u_a2.c

-- Test 81: query (line 414)
SELECT * FROM u_a;

-- Test 82: statement (line 423)
INSERT INTO u_c VALUES (30, 'a', 1)

-- Test 83: statement (line 426)
DELETE FROM u_a USING u_b, u_c WHERE u_a.c = u_b.a AND u_a.c = u_c.a

-- Test 84: query (line 429)
SELECT * FROM u_a;

-- Test 85: query (line 437)
DELETE FROM u_a USING u_b WHERE u_a.c = u_b.a RETURNING u_b.a, u_b.b, u_a.a, u_a.b;

-- Test 86: query (line 444)
SELECT * FROM u_a;

-- Test 87: statement (line 448)
INSERT INTO u_a VALUES (1, 'a', 10), (2, 'b', 20), (3, 'c', 30), (4, 'd', 40);

-- Test 88: query (line 452)
DELETE FROM u_a USING u_c WHERE u_a.c = u_c.c RETURNING *;

-- Test 89: statement (line 461)
ALTER TABLE u_a SET (schema_locked=false)

-- Test 90: statement (line 464)
TRUNCATE u_a

-- Test 91: statement (line 467)
ALTER TABLE u_a RESET (schema_locked)

-- Test 92: statement (line 470)
INSERT INTO u_a VALUES (1, 'a', 5), (2, 'b', 10), (3, 'c', 15), (4, 'd', 20), (5, 'd', 25), (6, 'd', 30), (7, 'd', 35), (8, 'd', 40), (9, 'd', 45)

-- Test 93: statement (line 477)
DELETE FROM u_a AS foo USING u_b AS bar WHERE bar.a > foo.c ORDER BY bar.a DESC LIMIT 3 RETURNING *;

-- Test 94: query (line 482)
DELETE FROM u_a AS foo USING u_b AS bar WHERE bar.a > foo.c ORDER BY foo.a DESC LIMIT 3 RETURNING foo.*;

-- Test 95: query (line 489)
SELECT * FROM u_a;

-- Test 96: statement (line 499)
INSERT INTO u_d VALUES (1, 10), (2, 20), (3, 30), (4, 40)

-- Test 97: query (line 502)
SELECT * FROM u_b;

-- Test 98: query (line 510)
SELECT * FROM u_c;

-- Test 99: statement (line 521)
DELETE FROM u_a USING u_b, LATERAL (SELECT u_c.a, u_c.b, u_c.c FROM u_c WHERE u_b.b = u_c.b) AS other WHERE other.c = 1 AND u_a.c = 45

-- Test 100: query (line 524)
SELECT * FROM u_a

-- Test 101: statement (line 535)
CREATE TABLE pindex (
  a DECIMAL(10, 2),
  INDEX (a) WHERE a > 3
)

-- Test 102: statement (line 541)
INSERT INTO pindex VALUES (1.0), (2.0), (3.0), (4.0), (5.0), (8.0)

-- Test 103: statement (line 544)
DELETE FROM pindex USING (VALUES (5.0), (6.0)) v(b) WHERE pindex.a = v.b

-- Test 104: query (line 547)
SELECT * FROM pindex;

-- Test 105: query (line 556)
SELECT a FROM pindex@pindex_a_idx WHERE a > 3

-- Test 106: statement (line 562)
DELETE FROM pindex USING (VALUES (2.0), (4.0)) v(b) WHERE pindex.a = v.b RETURNING v.b

-- Test 107: query (line 565)
SELECT * FROM pindex;

-- Test 108: query (line 572)
SELECT a FROM pindex@pindex_a_idx WHERE a > 3

-- Test 109: statement (line 579)
CREATE TABLE t99630a (a INT, INDEX idx (a) WHERE a > 0);
CREATE TABLE t99630b (b BOOL);
INSERT INTO t99630a VALUES (11);
INSERT INTO t99630b VALUES (false);

-- Test 110: query (line 585)
DELETE FROM t99630a USING t99630b RETURNING b

-- Test 111: query (line 590)
SELECT a FROM t99630a@idx WHERE a > 0

-- Test 112: statement (line 597)
CREATE TABLE t107634 (a INT)

-- Test 113: statement (line 600)
DELETE FROM t107634 ORDER BY sum(a) LIMIT 1;

-- Test 114: statement (line 609)
CREATE TABLE t108166 (a INT)

-- Test 115: statement (line 612)
DELETE FROM t108166 ORDER BY COALESCE(sum(a), 1) LIMIT 1;

-- Test 116: statement (line 621)
CREATE TABLE t (
  k INT PRIMARY KEY,
  c INT,
  FAMILY (k),
  FAMILY (c)
);

-- Test 117: statement (line 629)
INSERT INTO t SELECT i, NULL FROM generate_series(1, 599) AS g(i);
INSERT INTO t VALUES (600, 2);

-- Test 118: statement (line 633)
DELETE FROM t WHERE k > 0 AND k < 1000;

