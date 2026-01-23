-- PostgreSQL compatible tests from virtual_columns
-- NOTE: PostgreSQL does not support CockroachDB-style VIRTUAL computed columns.
-- This file runs a PostgreSQL-focused subset using STORED generated columns.
-- The original CockroachDB logic-test content is preserved below (commented out).

SET client_min_messages = warning;
DROP TABLE IF EXISTS inv CASCADE;
DROP TABLE IF EXISTS sc CASCADE;
DROP TABLE IF EXISTS uniq_partial CASCADE;
DROP TABLE IF EXISTS t_idx CASCADE;
DROP TABLE IF EXISTS t CASCADE;
RESET client_min_messages;

-- Basic generated column (STORED).
CREATE TABLE t (
  a INT PRIMARY KEY,
  b INT,
  v INT GENERATED ALWAYS AS (a + b) STORED
);

INSERT INTO t (a, b) VALUES (1, 1), (2, 2);
SELECT * FROM t ORDER BY a;

-- Cannot insert explicit value into a generated column.
\set ON_ERROR_STOP 0
INSERT INTO t (a, b, v) VALUES (3, 3, 0);
\set ON_ERROR_STOP 1

UPDATE t SET b = b + 10 WHERE a = 1;
SELECT * FROM t ORDER BY a;

-- Upsert updates base columns; generated recomputes.
INSERT INTO t (a, b) VALUES (2, 20) ON CONFLICT (a) DO UPDATE SET b = excluded.b;
SELECT * FROM t ORDER BY a;

CREATE INDEX t_v_idx ON t(v);
SELECT a FROM t WHERE v = 11 ORDER BY a;

-- Multiple generated columns + uniqueness.
CREATE TABLE t_idx (
  a INT PRIMARY KEY,
  b INT,
  c INT,
  v INT GENERATED ALWAYS AS (a + b) STORED,
  w INT GENERATED ALWAYS AS (c + 1) STORED,
  UNIQUE (w)
);

INSERT INTO t_idx (a, b, c) VALUES
  (1, 1, 1),
  (2, 8, 2),
  (3, 3, 3),
  (4, 6, 4);
SELECT a, b, c, v, w FROM t_idx ORDER BY a;

CREATE INDEX t_idx_v_idx ON t_idx(v);

-- Partial unique index on a generated column.
CREATE TABLE uniq_partial (
  a INT PRIMARY KEY,
  b INT,
  v INT GENERATED ALWAYS AS (a + b) STORED
);
CREATE UNIQUE INDEX uniq_partial_v_idx ON uniq_partial(v) WHERE b > 10;

INSERT INTO uniq_partial (a, b) VALUES (1, 10), (2, 20), (3, 21);
\set ON_ERROR_STOP 0
INSERT INTO uniq_partial (a, b) VALUES (4, 18);
\set ON_ERROR_STOP 1
SELECT * FROM uniq_partial ORDER BY a;

-- Generated columns added via ALTER TABLE.
CREATE TABLE sc (a INT PRIMARY KEY, b INT);
INSERT INTO sc VALUES (1, 10), (2, 20), (3, 30);
ALTER TABLE sc ADD COLUMN v INT GENERATED ALWAYS AS (a + b) STORED;
SELECT * FROM sc ORDER BY a;

-- JSON generated column (use jsonb for @>).
CREATE TABLE inv (
  k INT PRIMARY KEY,
  j jsonb,
  jv jsonb GENERATED ALWAYS AS (j->'a') STORED
);

INSERT INTO inv (k, j) VALUES
  (1, '{"a": {"b": "c"}}'),
  (2, '{"a": {"b": "d"}}'),
  (3, '{"x": 1}');

SELECT k, jv FROM inv ORDER BY k;
SELECT k FROM inv WHERE jv @> '{"b":"c"}' ORDER BY k;

DROP TABLE inv;
DROP TABLE sc;
DROP TABLE uniq_partial;
DROP TABLE t_idx;
DROP TABLE t;

/*
-- Test 1: statement (line 3)
CREATE TABLE t (
  a INT PRIMARY KEY,
  b INT,
  v INT AS (a+b) VIRTUAL,
  FAMILY (a, b, v)
)

-- Test 2: statement (line 11)
CREATE TABLE t (
  a INT PRIMARY KEY,
  b INT,
  v INT AS (a+b) VIRTUAL,
  FAMILY (a),
  FAMILY (b),
  FAMILY (v)
)

-- Test 3: statement (line 21)
CREATE TABLE t (
  a INT PRIMARY KEY,
  b INT,
  v INT AS (a+b) VIRTUAL,
  INDEX (b) STORING (v)
)

-- Test 4: statement (line 29)
CREATE TABLE t (
  a INT PRIMARY KEY,
  b INT,
  v INT AS (a+b) VIRTUAL
)

-- Test 5: statement (line 36)
ALTER TABLE t ALTER COLUMN v DROP STORED

-- Test 6: statement (line 39)
INSERT INTO t VALUES (1, 1)

-- Test 7: statement (line 42)
INSERT INTO t(a,b) VALUES (2, 2)

-- Test 8: statement (line 45)
INSERT INTO t(a,b,v) VALUES (2, 2, 0)

-- Test 9: statement (line 48)
INSERT INTO t VALUES (2, 2, 0)

-- Test 10: query (line 52)
SELECT * FROM t

-- Test 11: statement (line 59)
DELETE FROM t WHERE a > 0

-- Test 12: statement (line 62)
INSERT INTO t VALUES (1, 10), (2, 20), (3, 30), (4, 40)

-- Test 13: query (line 65)
DELETE FROM t WHERE a = 1 RETURNING v

-- Test 14: query (line 70)
SELECT * FROM t

-- Test 15: statement (line 78)
DELETE FROM t WHERE v = 33

-- Test 16: query (line 81)
SELECT * FROM t

-- Test 17: statement (line 88)
UPDATE t SET v=1

-- Test 18: statement (line 91)
UPDATE t SET a=a+1

-- Test 19: query (line 94)
SELECT * FROM t

-- Test 20: query (line 101)
UPDATE t SET b=b+1 WHERE v=45 RETURNING a,b,v

-- Test 21: statement (line 108)
CREATE TABLE t_idx (
  a INT PRIMARY KEY,
  b INT,
  c INT,
  v INT AS (a+b) VIRTUAL,
  w INT AS (c+1) VIRTUAL,
  INDEX (v),
  UNIQUE (w)
)

-- Test 22: statement (line 119)
INSERT INTO t_idx VALUES (1, 1, 1), (2, 8, 2), (3, 3, 3), (4, 6, 4), (5, 0, 5)

-- Test 23: statement (line 122)
INSERT INTO t_idx VALUES (10, 10, 1)

-- Test 24: query (line 127)
SELECT a FROM t_idx WHERE a+b=10

-- Test 25: query (line 133)
SELECT a FROM t_idx WHERE v=10

-- Test 26: query (line 139)
SELECT a FROM t_idx WHERE w IN (4,6)

-- Test 27: query (line 146)
SELECT v, x FROM (VALUES (1), (2), (10), (5)) AS u(x) INNER LOOKUP JOIN t_idx@t_idx_v_idx ON u.x = t_idx.v

-- Test 28: query (line 155)
SELECT a, b, v, x FROM (VALUES (1), (2), (10), (5)) AS u(x) INNER LOOKUP JOIN t_idx@t_idx_v_idx ON u.x = t_idx.v

-- Test 29: statement (line 163)
DELETE FROM t_idx WHERE v = 6

-- Test 30: query (line 166)
SELECT * FROM t_idx

-- Test 31: statement (line 175)
DELETE FROM t_idx WHERE a+b = 10

-- Test 32: query (line 178)
SELECT * FROM t_idx

-- Test 33: statement (line 186)
UPDATE t_idx SET a=a+1

-- Test 34: query (line 189)
SELECT * FROM t_idx

-- Test 35: query (line 196)
SELECT a FROM t_idx WHERE v=3

-- Test 36: query (line 201)
SELECT a FROM t_idx WHERE w=2

-- Test 37: statement (line 207)
UPDATE t_idx SET b=b+1

-- Test 38: query (line 210)
SELECT * FROM t_idx

-- Test 39: query (line 217)
SELECT a FROM t_idx WHERE v=4

-- Test 40: query (line 222)
SELECT a FROM t_idx WHERE w=2

-- Test 41: statement (line 228)
UPDATE t_idx SET c=c+1

-- Test 42: query (line 231)
SELECT * FROM t_idx

-- Test 43: query (line 238)
SELECT a FROM t_idx WHERE v=4

-- Test 44: query (line 243)
SELECT a FROM t_idx WHERE w=3

-- Test 45: statement (line 248)
UPDATE t_idx SET c=6 WHERE a=2

-- Test 46: query (line 252)
UPDATE t_idx SET a=a+1 RETURNING a,v,w

-- Test 47: query (line 259)
UPDATE t_idx SET b=b+1 RETURNING w

-- Test 48: statement (line 268)
ALTER TABLE t SET (schema_locked=false)

-- Test 49: statement (line 271)
TRUNCATE t

-- Test 50: statement (line 274)
ALTER TABLE t RESET (schema_locked)

-- Test 51: statement (line 277)
UPSERT INTO t(a,b,v) VALUES (1, 1, 1)

-- Test 52: statement (line 280)
UPSERT INTO t VALUES (1, 1, 1)

-- Test 53: statement (line 283)
UPSERT INTO t VALUES (1, 10), (2, 20), (3, 30), (4, 40)

-- Test 54: query (line 286)
SELECT * FROM t

-- Test 55: query (line 295)
UPSERT INTO t VALUES (3, 31), (5, 50) RETURNING v

-- Test 56: query (line 302)
INSERT INTO t VALUES (5, 51), (6, 60) ON CONFLICT DO NOTHING RETURNING v

-- Test 57: query (line 308)
SELECT * FROM t

-- Test 58: statement (line 319)
INSERT INTO t VALUES (4, 100), (6, 100), (7, 100) ON CONFLICT (a) DO UPDATE SET b = t.v

-- Test 59: query (line 322)
SELECT * FROM t

-- Test 60: statement (line 334)
INSERT INTO t VALUES (2, 100), (5, 100), (8, 100) ON CONFLICT (a) DO UPDATE SET b = excluded.v

-- Test 61: query (line 337)
SELECT * FROM t

-- Test 62: statement (line 353)
ALTER TABLE t_idx SET (schema_locked=false)

-- Test 63: statement (line 356)
TRUNCATE t_idx

-- Test 64: statement (line 359)
ALTER TABLE t_idx RESET (schema_locked)

-- Test 65: statement (line 362)
UPSERT INTO t_idx(a,b,v) VALUES (1, 1, 1)

-- Test 66: statement (line 365)
UPSERT INTO t_idx VALUES (1, 1, 1, 1)

-- Test 67: statement (line 368)
UPSERT INTO t_idx VALUES (1, 10, 100), (2, 20, 200), (3, 30, 300), (4, 40, 400)

-- Test 68: query (line 371)
SELECT * FROM t_idx

-- Test 69: query (line 380)
UPSERT INTO t_idx VALUES (3, 31, 301), (5, 50, 500) RETURNING a, v, w

-- Test 70: query (line 388)
INSERT INTO t_idx VALUES (4, 41, 301), (6, 60, 600), (7, 70, 100) ON CONFLICT DO NOTHING RETURNING w

-- Test 71: query (line 394)
SELECT * FROM t_idx

-- Test 72: statement (line 406)
INSERT INTO t_idx VALUES (1, 80, 900) ON CONFLICT (w) DO NOTHING

-- Test 73: statement (line 410)
INSERT INTO t_idx VALUES (8, 80, 100) ON CONFLICT (a) DO NOTHING

-- Test 74: statement (line 414)
INSERT INTO t_idx VALUES (4, 10, 100), (6, 10, 100), (7, 70, 700) ON CONFLICT (a) DO UPDATE SET c = 0

-- Test 75: query (line 417)
INSERT INTO t_idx VALUES (4, 10, 100), (6, 10, 100), (7, 70, 700) ON CONFLICT (a) DO UPDATE SET c = t_idx.w RETURNING a, b, c, v, w

-- Test 76: query (line 425)
SELECT * FROM t_idx

-- Test 77: statement (line 437)
INSERT INTO t_idx VALUES (8, 80, 800), (10, 100, 700) ON CONFLICT (w) DO UPDATE SET a = excluded.a, c = excluded.v

-- Test 78: query (line 440)
SELECT * FROM t_idx

-- Test 79: statement (line 454)
CREATE TABLE fk (
  a INT PRIMARY KEY,
  b INT,
  c INT,
  u INT UNIQUE AS (b+c) VIRTUAL
)

-- Test 80: statement (line 462)
CREATE TABLE fk2 (
  p INT PRIMARY KEY,
  c INT REFERENCES fk(u)
)

-- Test 81: statement (line 468)
CREATE TABLE fk2 (
  p INT PRIMARY KEY,
  c INT AS (p+1) VIRTUAL REFERENCES fk(a)
)

-- Test 82: statement (line 474)
CREATE TABLE fk2 (
  p INT PRIMARY KEY,
  q INT,
  r INT,
  CONSTRAINT fk FOREIGN KEY (q,r) REFERENCES fk(a,u)
)

-- Test 83: statement (line 482)
CREATE TABLE fk2 (
  x INT PRIMARY KEY,
  y INT,
  v INT AS (x+y) VIRTUAL
)

-- Test 84: statement (line 489)
ALTER TABLE fk2 ADD CONSTRAINT foo FOREIGN KEY (x) REFERENCES fk(u)

-- Test 85: statement (line 492)
ALTER TABLE fk2 ADD CONSTRAINT foo FOREIGN KEY (v) REFERENCES fk(a)

-- Test 86: statement (line 498)
CREATE TABLE n (
  a INT PRIMARY KEY,
  b INT,
  v INT NOT NULL AS (a+b) VIRTUAL
)

-- Test 87: statement (line 505)
INSERT INTO n VALUES (1, NULL)

-- Test 88: statement (line 508)
INSERT INTO n VALUES (1, 1), (2, 2)

-- Test 89: statement (line 511)
UPDATE n SET b = NULL WHERE a > 0

-- Test 90: statement (line 514)
UPSERT INTO n VALUES (1, NULL)

-- Test 91: statement (line 517)
UPSERT INTO n VALUES (3, NULL)

-- Test 92: statement (line 520)
INSERT INTO n VALUES (1, NULL) ON CONFLICT DO NOTHING

-- Test 93: statement (line 523)
INSERT INTO n VALUES (3, NULL) ON CONFLICT DO NOTHING

-- Test 94: statement (line 526)
INSERT INTO n VALUES (1, 10) ON CONFLICT (a) DO UPDATE SET b = NULL

-- Test 95: statement (line 529)
INSERT INTO n VALUES (3, NULL) ON CONFLICT (a) DO UPDATE SET b = NULL

-- Test 96: statement (line 535)
CREATE TABLE t_check (
  a INT PRIMARY KEY,
  b INT,
  v INT AS (a+b) VIRTUAL CHECK (v >= 10),
  w INT AS (a*b) VIRTUAL,
  CHECK (v < w)
)

-- Test 97: statement (line 544)
INSERT INTO t_check VALUES (1,1), (5,5)

-- Test 98: statement (line 547)
INSERT INTO t_check VALUES (5,5), (6,6)

-- Test 99: statement (line 550)
UPDATE t_check SET b=b-1

-- Test 100: statement (line 553)
UPDATE t_check SET b=b+1

-- Test 101: query (line 556)
SELECT * FROM t_check

-- Test 102: statement (line 563)
UPSERT INTO t_check VALUES (5, 2), (8, 8)

-- Test 103: statement (line 566)
UPSERT INTO t_check VALUES (5, 10), (8, 1)

-- Test 104: statement (line 569)
UPSERT INTO t_check VALUES (5, 10), (8, 8)

-- Test 105: query (line 572)
SELECT * FROM t_check

-- Test 106: statement (line 580)
INSERT INTO t_check VALUES (5, 1) ON CONFLICT (a) DO UPDATE SET b=3

-- Test 107: statement (line 583)
INSERT INTO t_check VALUES (5, 1) ON CONFLICT (a) DO UPDATE SET b=5

-- Test 108: query (line 586)
SELECT * FROM t_check

-- Test 109: statement (line 597)
CREATE TABLE uniq_simple (
  a INT PRIMARY KEY,
  b INT,
  v INT UNIQUE AS (a+b) VIRTUAL
)

-- Test 110: statement (line 604)
INSERT INTO uniq_simple VALUES (1, 10), (2, 20)

-- Test 111: statement (line 607)
INSERT INTO uniq_simple VALUES (3, 8)

-- Test 112: statement (line 610)
UPDATE uniq_simple SET b=b+11 WHERE a < 2

-- Test 113: statement (line 613)
UPSERT INTO uniq_simple VALUES (2, 30), (5, 6)

-- Test 114: statement (line 616)
INSERT INTO uniq_simple VALUES (5, 6) ON CONFLICT (v) DO UPDATE SET b=15

-- Test 115: query (line 619)
SELECT * FROM uniq_simple

-- Test 116: statement (line 626)
CREATE TABLE uniq_partial (
  a INT PRIMARY KEY,
  b INT,
  v INT AS (a+b) VIRTUAL,
  UNIQUE INDEX (v) WHERE b > 10
)

-- Test 117: statement (line 634)
INSERT INTO uniq_partial VALUES (1, 10), (2, 20)

-- Test 118: statement (line 637)
INSERT INTO uniq_partial VALUES (3, 19)

-- Test 119: statement (line 640)
INSERT INTO uniq_partial VALUES (4, 7)

-- Test 120: query (line 643)
SELECT * FROM uniq_partial

-- Test 121: statement (line 651)
UPDATE uniq_partial SET b = 30-a

-- Test 122: statement (line 654)
UPDATE uniq_partial SET b = 10-a

-- Test 123: query (line 657)
SELECT * FROM uniq_partial

-- Test 124: statement (line 665)
UPSERT INTO uniq_partial VALUES (3, 7), (20, 20)

-- Test 125: statement (line 668)
UPSERT INTO uniq_partial VALUES (15, 25)

-- Test 126: statement (line 671)
CREATE TABLE uniq_partial_pred (
  a INT PRIMARY KEY,
  b INT,
  c INT,
  v INT AS (a+b) VIRTUAL,
  UNIQUE INDEX (c) WHERE v > 10
)

-- Test 127: statement (line 680)
INSERT INTO uniq_partial_pred VALUES (1, 1, 1), (2, 4, 2), (3, 3, 2), (10, 10, 1)

-- Test 128: statement (line 683)
INSERT INTO uniq_partial_pred VALUES (11, 9, 1)

-- Test 129: statement (line 686)
UPDATE uniq_partial_pred SET b=20-a

-- Test 130: statement (line 689)
UPDATE uniq_partial_pred SET b=10-a

-- Test 131: statement (line 692)
CREATE TABLE uniq_partial_multi (
  a INT PRIMARY KEY,
  b INT,
  c INT,
  v INT AS (a+b) VIRTUAL,
  UNIQUE INDEX (c, v) WHERE (v > 10)
)

-- Test 132: statement (line 701)
INSERT INTO uniq_partial_multi VALUES (1, 1, 1), (2, 4, 2), (3, 3, 2), (10, 10, 1)

-- Test 133: statement (line 704)
INSERT INTO uniq_partial_multi VALUES (15, 5, 1)

-- Test 134: statement (line 707)
UPSERT INTO uniq_partial_multi VALUES (4, 2, 2)

-- Test 135: statement (line 710)
UPSERT INTO uniq_partial_multi VALUES (4, 16, 1)

-- Test 136: statement (line 716)
CREATE TABLE uniq_no_index (
  a INT PRIMARY KEY,
  b INT,
  v INT AS (a+b) VIRTUAL,
  UNIQUE WITHOUT INDEX (v)
)

skipif config #126592 weak-iso-level-configs

-- Test 137: statement (line 725)
INSERT INTO uniq_no_index VALUES (1, 10), (2, 20)

skipif config #126592 weak-iso-level-configs

-- Test 138: statement (line 729)
INSERT INTO uniq_no_index VALUES (3, 8)

skipif config #126592 weak-iso-level-configs

-- Test 139: statement (line 733)
UPDATE uniq_no_index SET b=b+11 WHERE a < 2

skipif config #126592 weak-iso-level-configs

-- Test 140: statement (line 737)
UPSERT INTO uniq_no_index VALUES (2, 30), (5, 6)

skipif config #126592 weak-iso-level-configs

-- Test 141: statement (line 741)
INSERT INTO uniq_no_index VALUES (5, 6) ON CONFLICT (v) DO UPDATE SET b=15

skipif config #126592 weak-iso-level-configs

-- Test 142: query (line 745)
SELECT * FROM uniq_no_index

-- Test 143: statement (line 752)
CREATE TABLE uniq_no_index_multi (
  a INT PRIMARY KEY,
  b INT,
  c INT,
  v INT AS (a+b) VIRTUAL,
  UNIQUE WITHOUT INDEX (v, c)
)

skipif config #126592 weak-iso-level-configs

-- Test 144: statement (line 762)
INSERT INTO uniq_no_index_multi VALUES (1, 1, 1), (2, 4, 2), (3, 3, 3)

skipif config #126592 weak-iso-level-configs

-- Test 145: statement (line 766)
INSERT INTO uniq_no_index_multi VALUES (4, 2, 2)

skipif config #126592 weak-iso-level-configs

-- Test 146: statement (line 770)
UPDATE uniq_no_index_multi SET c=2 WHERE a=3

skipif config #126592 weak-iso-level-configs

-- Test 147: statement (line 774)
UPSERT INTO uniq_no_index_multi VALUES (3, 3, 10)

skipif config #126592 weak-iso-level-configs

-- Test 148: statement (line 778)
UPSERT INTO uniq_no_index_multi VALUES (3, 3, 2)

-- Test 149: statement (line 786)
CREATE TABLE sc (a INT PRIMARY KEY, b INT)

-- Test 150: statement (line 789)
INSERT INTO sc VALUES (1, 10), (2, 20), (3, 30);

-- Test 151: statement (line 792)
ALTER TABLE sc ADD COLUMN v INT AS (a+b) VIRTUAL

-- Test 152: query (line 795)
SELECT * FROM sc

-- Test 153: statement (line 803)
ALTER TABLE sc ADD COLUMN x INT AS (a+1) VIRTUAL, ADD COLUMN y INT AS (b+1) VIRTUAL, ADD COLUMN z INT AS (a+b) VIRTUAL

-- Test 154: query (line 806)
SELECT * FROM sc

-- Test 155: statement (line 814)
ALTER TABLE sc ADD COLUMN u INT AS (a+v) VIRTUAL

-- Test 156: statement (line 817)
ALTER TABLE sc DROP COLUMN z

-- Test 157: query (line 820)
SELECT * FROM sc

-- Test 158: statement (line 828)
ALTER TABLE sc DROP COLUMN x, DROP COLUMN y

-- Test 159: query (line 831)
SELECT * FROM sc

-- Test 160: statement (line 840)
ALTER TABLE sc SET (schema_locked = false);

-- Test 161: statement (line 844)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl = false;

-- Test 162: statement (line 848)
ALTER TABLE sc ADD COLUMN w1 INT AS (a*b) VIRTUAL

-- Test 163: statement (line 851)
ALTER TABLE sc ADD COLUMN w2 INT AS (b*2) VIRTUAL

-- Test 164: statement (line 854)
COMMIT

skipif config schema-locked-disabled

-- Test 165: statement (line 858)
ALTER TABLE sc SET (schema_locked = true);

-- Test 166: query (line 861)
SELECT * FROM sc

-- Test 167: statement (line 869)
ALTER TABLE sc DROP COLUMN w1, DROP COLUMN w2

-- Test 168: query (line 872)
SELECT * FROM sc

-- Test 169: statement (line 881)
CREATE INDEX v_idx ON sc(v)

-- Test 170: query (line 884)
SELECT a FROM sc@v_idx

-- Test 171: query (line 891)
SELECT a FROM sc WHERE v>20 AND v<40

-- Test 172: statement (line 897)
DROP INDEX v_idx

-- Test 173: statement (line 900)
ALTER TABLE sc DROP COLUMN v

skipif config schema-locked-disabled

-- Test 174: statement (line 904)
ALTER TABLE sc SET (schema_locked = false);

-- Test 175: statement (line 908)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl = false;

-- Test 176: statement (line 912)
ALTER TABLE sc ADD COLUMN v INT AS (a+b) VIRTUAL

-- Test 177: statement (line 915)
CREATE INDEX v_idx ON sc(v)

-- Test 178: statement (line 918)
END

skipif config schema-locked-disabled

-- Test 179: statement (line 922)
ALTER TABLE sc SET (schema_locked = true);

-- Test 180: query (line 925)
SELECT a FROM sc@v_idx

-- Test 181: statement (line 932)
DROP INDEX v_idx

-- Test 182: statement (line 935)
ALTER TABLE sc DROP COLUMN v

skipif config schema-locked-disabled

-- Test 183: statement (line 939)
ALTER TABLE sc SET (schema_locked = false);

-- Test 184: statement (line 944)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl = false;

-- Test 185: statement (line 948)
ALTER TABLE sc ADD COLUMN v INT AS (a+b) VIRTUAL

-- Test 186: statement (line 951)
CREATE INDEX partial_idx ON sc(b) WHERE v > 20

-- Test 187: statement (line 954)
END

skipif config schema-locked-disabled

-- Test 188: statement (line 958)
ALTER TABLE sc SET (schema_locked = true);

-- Test 189: statement (line 961)
ALTER TABLE sc ADD COLUMN v INT AS (a+b) VIRTUAL

-- Test 190: statement (line 965)
CREATE INDEX v_partial_idx ON sc(v) WHERE v > 20

-- Test 191: query (line 968)
SELECT a FROM sc@v_partial_idx WHERE v > 20

-- Test 192: statement (line 974)
INSERT INTO sc VALUES (10, 10), (11, 9)

-- Test 193: query (line 977)
SELECT * FROM sc

-- Test 194: statement (line 988)
CREATE UNIQUE INDEX v_partial_idx2 ON sc(v) WHERE v > 10

-- Test 195: statement (line 992)
ALTER TABLE sc ADD CONSTRAINT c CHECK (v < 30)

-- Test 196: statement (line 995)
ALTER TABLE sc ADD CONSTRAINT c CHECK (v < 40)

-- Test 197: statement (line 998)
UPDATE sc SET b=b+10

-- Test 198: statement (line 1002)
ALTER TABLE sc ADD COLUMN w INT AS (a*b) VIRTUAL CHECK (w < 100)

-- Test 199: statement (line 1005)
ALTER TABLE sc ADD COLUMN w INT AS (a*b) VIRTUAL CHECK (w <= 100)

-- Test 200: statement (line 1008)
INSERT INTO sc VALUES (20, 20)

-- Test 201: statement (line 1014)
CREATE TABLE inv (
  k INT PRIMARY KEY,
  i INT,
  j JSON,
  iv INT AS (i + 10) VIRTUAL,
  jv JSON AS (j->'a') VIRTUAL,
  INVERTED INDEX jv_idx (jv),
  INVERTED INDEX i_jv_idx (i, jv),
  INVERTED INDEX iv_j_idx (iv, j),
  INVERTED INDEX iv_jv_idx (iv, jv)
)

-- Test 202: statement (line 1027)
INSERT INTO inv VALUES
  (1, 10, NULL),
  (2, 10, '1'),
  (3, 10, '"a"'),
  (4, 10, 'true'),
  (5, 10, 'null'),
  (6, 10, '{}'),
  (7, 10, '[]'),
  (8, 10, '{"a": "b"}'),
  (9, 10, '{"a": "b", "c": "d"}'),
  (10, 10, '{"a": {}, "b": "c"}'),
  (11, 10, '{"a": {"b": "c"}, "d": "e"}'),
  (12, 10, '{"a": {"b": "c", "d": "e"}}'),
  (13, 10, '{"a": [], "d": "e"}'),
  (14, 10, '{"a": ["b", "c"], "d": "e"}'),
  (15, 10, '["a"]'),
  (16, 10, '["a", "b", "c"]'),
  (17, 10, '[{"a": "b"}, "c"]')

-- Test 203: statement (line 1047)
INSERT INTO inv
SELECT k+17, 20, j FROM inv

-- Test 204: query (line 1051)
SELECT k, jv FROM inv@jv_idx WHERE jv @> '{"b": "c"}' ORDER BY k

-- Test 205: query (line 1059)
SELECT k, jv FROM inv@jv_idx WHERE jv->'b' = '"c"' ORDER BY k

-- Test 206: query (line 1067)
SELECT k, jv FROM inv@jv_idx WHERE jv @> '"b"' ORDER BY k

-- Test 207: query (line 1077)
SELECT k, i, jv FROM inv@i_jv_idx WHERE i IN (10, 20, 30) AND jv @> '{"b": "c"}' ORDER BY k

-- Test 208: query (line 1085)
SELECT k, i, jv FROM inv@i_jv_idx WHERE i = 20 AND jv @> '{"b": "c"}' ORDER BY k

-- Test 209: query (line 1091)
SELECT k, iv, j FROM inv@iv_j_idx WHERE iv IN (10, 20, 30) AND j @> '{"b": "c"}' ORDER BY k

-- Test 210: query (line 1097)
SELECT k, iv, j FROM inv@iv_j_idx WHERE iv = 20 AND j @> '{"b": "c"}' ORDER BY k

-- Test 211: query (line 1102)
SELECT k, iv, jv FROM inv@iv_jv_idx WHERE iv IN (10, 20, 30) AND jv @> '{"b": "c"}' ORDER BY k

-- Test 212: query (line 1110)
SELECT k, iv, jv FROM inv@iv_jv_idx WHERE iv = 20 AND jv @> '{"b": "c"}' ORDER BY k

-- Test 213: statement (line 1120)
CREATE TABLE t_ref (i INT PRIMARY KEY) WITH (schema_locked = false);

onlyif config local-legacy-schema-changer

-- Test 214: statement (line 1124)
ALTER TABLE t_ref ADD COLUMN j INT NOT NULL DEFAULT 42,
   ADD COLUMN k INT AS (i+j) VIRTUAL;

onlyif config local-legacy-schema-changer

-- Test 215: statement (line 1129)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
    SET LOCAL autocommit_before_ddl = false;
    ALTER TABLE t_ref ADD COLUMN j INT NOT NULL DEFAULT 42;
    ALTER TABLE t_ref ADD COLUMN k INT NOT NULL DEFAULT 42;
    ALTER TABLE t_ref ADD COLUMN l INT AS (i+j+k) VIRTUAL;
COMMIT;

-- Test 216: statement (line 1137)
ROLLBACK;

-- Test 217: statement (line 1142)
ALTER TABLE t_ref ADD COLUMN j INT NOT NULL DEFAULT 42,
   ADD COLUMN k INT AS (i+j) VIRTUAL;

-- Test 218: statement (line 1149)
DROP TABLE t_ref;

-- Test 219: statement (line 1152)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
    SET LOCAL autocommit_before_ddl = false;
    CREATE TABLE t_ref (i INT PRIMARY KEY);
    ALTER TABLE t_ref ADD COLUMN j INT NOT NULL DEFAULT 42;
    ALTER TABLE t_ref ADD COLUMN k INT AS (i+j) VIRTUAL;
COMMIT;

-- Test 220: statement (line 1160)
DROP TABLE t_ref;

-- Test 221: statement (line 1166)
CREATE TABLE p (p INT PRIMARY KEY)

-- Test 222: statement (line 1169)
CREATE TABLE c_update (
  p_cascade INT REFERENCES p (p) ON UPDATE CASCADE,
  p_default INT DEFAULT 0 REFERENCES p (p) ON UPDATE SET DEFAULT,
  p_null INT REFERENCES p (p) ON UPDATE SET NULL,
  v_cascade INT AS (p_cascade + 100) VIRTUAL,
  v_default INT AS (p_default) VIRTUAL,
  v_null INT AS (p_null + 100) VIRTUAL
)

-- Test 223: statement (line 1179)
CREATE TABLE c_delete_cascade (
  p_cascade INT REFERENCES p (p) ON DELETE CASCADE,
  v_cascade INT AS (p_cascade + 100) VIRTUAL
)

-- Test 224: statement (line 1185)
CREATE TABLE c_delete_set (
  p_default INT DEFAULT 0 REFERENCES p (p) ON DELETE SET DEFAULT,
  p_null INT REFERENCES p (p) ON DELETE SET NULL,
  v_default INT AS (p_default) VIRTUAL,
  v_null INT AS (p_null + 100) VIRTUAL
)

-- Test 225: statement (line 1193)
INSERT INTO p VALUES (0), (1), (2), (3)

-- Test 226: statement (line 1196)
INSERT INTO c_update VALUES (1, 1, 1), (2, 2, 2)

-- Test 227: statement (line 1199)
UPDATE p SET p = 10 WHERE p = 1

-- Test 228: query (line 1202)
SELECT * FROM c_update

-- Test 229: statement (line 1209)
INSERT INTO c_delete_cascade VALUES (2), (3);
INSERT INTO c_delete_set VALUES (2, 2), (3, 3);

-- Test 230: statement (line 1213)
DELETE FROM p WHERE p = 3

-- Test 231: query (line 1216)
SELECT * FROM c_delete_cascade

-- Test 232: query (line 1222)
SELECT * FROM c_delete_set

-- Test 233: statement (line 1231)
CREATE TABLE t63167_a (a INT, v INT AS (a + 1) VIRTUAL);
CREATE TABLE t63167_b (LIKE t63167_a INCLUDING ALL);

onlyif config schema-locked-disabled

-- Test 234: query (line 1236)
SELECT create_statement FROM [SHOW CREATE TABLE t63167_b]

-- Test 235: query (line 1247)
SELECT create_statement FROM [SHOW CREATE TABLE t63167_b]

-- Test 236: statement (line 1260)
CREATE TABLE t_65915 (i INT PRIMARY KEY, j INT AS (i + 1) VIRTUAL NOT NULL);
INSERT INTO t_65915 VALUES (1)

-- Test 237: statement (line 1264)
ALTER TABLE t_65915 ADD COLUMN k INT DEFAULT 42;

-- Test 238: query (line 1267)
SELECT * FROM t_65915;

-- Test 239: statement (line 1272)
DROP TABLE t_65915

-- Test 240: statement (line 1284)
INSERT INTO t67528 (s) VALUES ('')

-- Test 241: statement (line 1287)
CREATE INDEX ON t67528 (v DESC)

-- Test 242: statement (line 1302)
INSERT INTO t73372 (i, s) VALUES (0, 'foo')

-- Test 243: statement (line 1305)
ALTER TABLE t73372 ALTER PRIMARY KEY USING COLUMNS (s, i)

-- Test 244: query (line 1308)
SELECT * FROM t73372

-- Test 245: statement (line 1315)
CREATE TABLE t75147 (
  a INT,
  b INT,
  c INT,
  v1 INT AS (c) VIRTUAL,
  v2 INT AS (c) VIRTUAL,
  PRIMARY KEY (b, v1, v2),
  INDEX (a)
);

-- Test 246: statement (line 1326)
SELECT 'foo'
FROM t75147 AS t1
JOIN t75147 AS t2 ON
  t1.v2 = t2.v2
  AND t1.v1 = t2.v1
  AND t1.b = t2.b
JOIN t75147 AS t3 ON t1.a = t3.a;

-- Test 247: statement (line 1340)
CREATE TABLE virtual_pk (
  a INT,
  b INT,
  c INT,
  v1 INT AS (c) VIRTUAL,
  v2 INT AS (c) VIRTUAL,
  PRIMARY KEY (b, v1, v2),
  INDEX (a)
);

-- Test 248: statement (line 1351)
INSERT INTO virtual_pk(a, b, c) values (1, 2, 3), (4, 5, 6);

-- Test 249: statement (line 1354)
ALTER TABLE virtual_pk ADD COLUMN d INT NOT NULL DEFAULT 42;

-- Test 250: statement (line 1357)
ALTER TABLE virtual_pk DROP COLUMN d;

skipif config schema-locked-disabled

-- Test 251: statement (line 1361)
ALTER TABLE virtual_pk SET (schema_locked = false)

-- Test 252: statement (line 1366)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl = false;
SET LOCAL use_declarative_schema_changer = off;
ALTER TABLE virtual_pk ADD COLUMN d INT NOT NULL DEFAULT 42;
COMMIT;

-- Test 253: statement (line 1373)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl = false;
SET LOCAL use_declarative_schema_changer = off;
ALTER TABLE virtual_pk DROP COLUMN d;
COMMIT;

skipif config schema-locked-disabled

-- Test 254: statement (line 1381)
ALTER TABLE virtual_pk SET (schema_locked = true)

-- Test 255: statement (line 1389)
CREATE TABLE t_added (i INT PRIMARY KEY);
INSERT INTO t_added VALUES (1);

-- Test 256: statement (line 1393)
ALTER TABLE t_added ADD COLUMN i4n INT4 GENERATED ALWAYS AS (NULL) VIRTUAL;

-- Test 257: statement (line 1396)
ALTER TABLE t_added ADD COLUMN dn DECIMAL(5, 2) GENERATED ALWAYS AS (NULL) VIRTUAL;

-- Test 258: statement (line 1399)
ALTER TABLE t_added ADD COLUMN d DECIMAL(5, 2) GENERATED ALWAYS AS (123.1::DECIMAL) VIRTUAL;

-- Test 259: statement (line 1402)
ALTER TABLE t_added ADD COLUMN i4 INT4 GENERATED ALWAYS AS (4) VIRTUAL;

-- Test 260: statement (line 1405)
ALTER TABLE t_added ADD COLUMN i2 INT2 GENERATED ALWAYS AS (2) VIRTUAL;

-- Test 261: query (line 1422)
SELECT create_statement FROM [SHOW CREATE TABLE t_added]

-- Test 262: query (line 1436)
SELECT create_statement FROM [SHOW CREATE TABLE t_added]

-- Test 263: statement (line 1449)
DROP TABLE t_added

-- Test 264: statement (line 1457)
CREATE TABLE t81675 (i INT);
INSERT INTO t81675 VALUES (1), (2), (NULL)

-- Test 265: statement (line 1461)
ALTER TABLE t81675 ADD COLUMN j INT GENERATED ALWAYS AS (i+1) VIRTUAL;

-- Test 266: statement (line 1464)
ALTER TABLE t81675 DROP COLUMN j;

-- Test 267: statement (line 1467)
ALTER TABLE t81675 ADD COLUMN j INT GENERATED ALWAYS AS (i+1) VIRTUAL NOT NULL;

-- Test 268: statement (line 1470)
DROP TABLE t81675;

-- Test 269: query (line 1488)
SELECT * FROM t91817a

-- Test 270: statement (line 1493)
CREATE TABLE t91817b (
  k INT2 PRIMARY KEY,
  v INT2 GENERATED ALWAYS AS (k + 1) VIRTUAL
);
INSERT INTO t91817b VALUES (0)

-- Test 271: query (line 1501)
SELECT var_pop(v::INT8) OVER ()
FROM t91817b
GROUP BY k, v
HAVING every(true)
*/
