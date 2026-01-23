-- PostgreSQL compatible tests from insert
-- 169 tests

SET client_min_messages = warning;

CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Test 1: statement (line 4)
DROP TABLE IF EXISTS kv;
CREATE TABLE kv (
  k VARCHAR PRIMARY KEY,
  v VARCHAR,
  UNIQUE (v)
);

-- Test 2: statement (line 1)
INSERT INTO kv VALUES ('a', 'b');

-- Test 3: query (line 13)
SELECT * FROM kv ORDER BY k;

-- Test 4: statement (line 17)
INSERT INTO kv (k) VALUES ('A');

-- Test 5: statement (line 20)
INSERT INTO kv (k, v) VALUES ('aa', 'a');

-- Test 6: statement (line 23)
INSERT INTO kv (k) VALUES ('nil1');

-- Test 7: statement (line 26)
INSERT INTO kv (k) VALUES ('nil2');

-- Test 8: statement (line 29)
INSERT INTO kv VALUES ('nil3', NULL);

-- Test 9: statement (line 32)
INSERT INTO kv VALUES ('nil4', NULL);

-- Test 10: statement (line 35)
INSERT INTO kv (k, v) VALUES ('c', 'd'), ('e', 'f');

-- Test 11: query (line 38)
WITH ins AS (
  INSERT INTO kv (k, v) VALUES ('f', 'g'), ('g', '') RETURNING k, v
)
SELECT v || 'hello' FROM ins ORDER BY k;

-- Test 12: statement (line 44)
INSERT INTO kv VALUES ('h', 'h1');

-- Test 13: statement (line 47)
INSERT INTO kv VALUES ('i', 'i1');

-- Test 14: statement (line 50)
INSERT INTO kv VALUES ('j', 'j1');

-- Test 15: query (line 53)
SELECT * FROM kv ORDER BY k;

-- Test 16: statement (line 67)
DROP TABLE IF EXISTS kv2;
CREATE TABLE kv2 (
  k CHAR,
  v CHAR,
  UNIQUE (v),
  PRIMARY KEY (k, v)
);

-- Test 17: statement (line 75)
INSERT INTO kv2 VALUES ('a', 'b'), ('c', 'd'), ('e', 'f'), ('f', 'g');

-- Test 18: query (line 78)
SELECT * FROM kv2 ORDER BY k, v;

-- Test 19: statement (line 86)
DROP TABLE IF EXISTS kv3;
CREATE TABLE kv3 (
  k CHAR PRIMARY KEY,
  v CHAR NOT NULL
);

-- Test 20: statement (line 92)
INSERT INTO kv3 VALUES ('a', 'b');

-- Test 21: statement (line 95)
INSERT INTO kv3 VALUES ('b', 'c');

-- Test 22: statement (line 98)
INSERT INTO kv3 (k, v) VALUES ('c', 'd');

-- Test 23: query (line 101)
SELECT * FROM kv3 ORDER BY k;

-- Test 24: statement (line 105)
DROP TABLE IF EXISTS kv4;
CREATE TABLE kv4 (
  int INT PRIMARY KEY,
  bit BIT,
  bool BOOLEAN,
  char CHAR,
  float FLOAT
);

-- Test 25: statement (line 114)
INSERT INTO kv4 (int) VALUES (0);

-- Test 26: statement (line 117)
INSERT INTO kv4 (int) VALUES (1);

-- Test 27: statement (line 120)
INSERT INTO kv4 (int, bit) VALUES (2, B'1');

-- Test 28: statement (line 123)
INSERT INTO kv4 (int, bit) VALUES (3, B'0');

-- Test 29: statement (line 126)
INSERT INTO kv4 (int, bool) VALUES (4, true);

-- Test 30: statement (line 129)
INSERT INTO kv4 (int, bool) VALUES (5, false);

-- Test 31: statement (line 132)
INSERT INTO kv4 (int, char) VALUES (6, 'b');

-- Test 32: statement (line 135)
INSERT INTO kv4 (int, char) VALUES (7, 'c');

-- Test 33: statement (line 138)
INSERT INTO kv4 (int, char) VALUES (8, 'a');

-- Test 34: statement (line 141)
INSERT INTO kv4 (int, float) VALUES (9, 1::INT);

-- Test 35: statement (line 144)
INSERT INTO kv4 (int, float) VALUES (10, 2.3);

-- Test 36: query (line 147)
SELECT * FROM kv4 ORDER BY int;

-- Test 37: statement (line 158)
DROP TABLE IF EXISTS kv5;
CREATE TABLE kv5 (
  k CHAR PRIMARY KEY,
  v CHAR,
  UNIQUE (v, k)
);

-- Test 38: statement (line 165)
INSERT INTO kv5 VALUES ('a', NULL);

-- Test 39: statement (line 168)
INSERT INTO kv5 VALUES ('b', DEFAULT), ('c', DEFAULT);

-- Test 40: query (line 171)
SELECT v, k FROM kv5 ORDER BY v NULLS LAST, k;

-- Test 41: statement (line 176)
INSERT INTO kv SELECT 'x', 'x1';

-- Test 42: statement (line 179)
INSERT INTO kv (k) SELECT 'y';

-- Test 43: statement (line 182)
INSERT INTO kv5 (k, v) SELECT 'd', 'd';

-- Test 44: statement (line 187)
INSERT INTO kv VALUES ('z', 'z1');

-- Test 45: statement (line 190)
INSERT INTO kv (k) VALUES ('w');

-- Test 46: statement (line 193)
INSERT INTO kv5 (k, v) VALUES ('e', DEFAULT);

-- Test 47: statement (line 196)
DROP TABLE IF EXISTS return_t;
CREATE TABLE return_t (a INT DEFAULT 3, b INT);

-- Test 48: query (line 199)
INSERT INTO return_t (a) VALUES (default), (8) RETURNING a, 2, a + 4;

-- Test 49: query (line 205)
INSERT INTO return_t (b) VALUES (default), (8) RETURNING a, a + 4, b;

-- Test 50: query (line 212)
INSERT INTO return_t VALUES (default, NULL) RETURNING a, b;

-- Test 51: query (line 218)
INSERT INTO return_t VALUES (default, NULL) RETURNING a, b AS c, 4 AS d;

-- Test 52: query (line 225)
INSERT INTO return_t VALUES (default, NULL) RETURNING a;

-- Test 53: statement (line 231)
INSERT INTO return_t VALUES (default, NULL) RETURNING ctid IS NOT NULL;

-- Test 54: query (line 234)
INSERT INTO return_t (a) VALUES (default) RETURNING b;

-- Test 55: query (line 240)
INSERT INTO return_t (b) VALUES (1) RETURNING *, a + 1;

-- Test 56: query (line 245)
INSERT INTO return_t VALUES (default, NULL) RETURNING *;

-- Test 57: query (line 251)
INSERT INTO return_t VALUES (1, 2), (3, 4) RETURNING a, b;

-- Test 58: query (line 258)
INSERT INTO return_t VALUES (1, 2), (3, 4) RETURNING *;

-- Test 59: query (line 266)
INSERT INTO return_t VALUES (1, NULL) RETURNING *;

-- Test 60: query (line 272)
INSERT INTO return_t (a) VALUES (1) RETURNING *;

-- Test 61: statement (line 278)
INSERT INTO return_t VALUES (1, 2), (3, 4) RETURNING return_t.* AS x;

-- Test 62: query (line 281)
INSERT INTO return_t VALUES (1, 2), (3, 4) RETURNING return_t.*, a + b AS c;

-- Test 63: statement (line 289)
INSERT INTO return_t AS r VALUES (5, 6);

-- Test 64: statement (line 297)
INSERT INTO return_t VALUES (5, 6) RETURNING a;

-- Test 65: statement (line 300)
-- CockroachDB-only tuple indexing syntax; no direct PostgreSQL equivalent.
-- INSERT INTO return_t VALUES (1, 2) RETURNING x.*[1];

-- Test 66: statement (line 303)
-- CockroachDB-only tuple indexing syntax; no direct PostgreSQL equivalent.
-- INSERT INTO return_t VALUES (1, 2) RETURNING x[1];

-- Test 67: statement (line 306)
DROP VIEW IF EXISTS kview;
DROP TABLE IF EXISTS kview_base;
CREATE TABLE kview_base (column1 TEXT, column2 TEXT);
INSERT INTO kview_base VALUES ('a', 'b'), ('c', 'd');
CREATE VIEW kview AS SELECT column1, column2 FROM kview_base;

CREATE OR REPLACE FUNCTION kview_insert_trigger() RETURNS trigger
LANGUAGE plpgsql AS $$
BEGIN
  INSERT INTO kview_base(column1, column2) VALUES (NEW.column1, NEW.column2);
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS kview_insert ON kview;
CREATE TRIGGER kview_insert INSTEAD OF INSERT ON kview
FOR EACH ROW EXECUTE FUNCTION kview_insert_trigger();

-- Test 68: query (line 309)
SELECT * FROM kview ORDER BY column1, column2;

-- Test 69: statement (line 315)
INSERT INTO kview VALUES ('e', 'f');

-- Test 70: query (line 318)
SELECT * FROM kview ORDER BY column1, column2;

-- Test 71: statement (line 324)
DROP TABLE IF EXISTS abc;
CREATE TABLE abc (
  a INT,
  b INT,
  c INT,
  PRIMARY KEY (a, b)
);
CREATE INDEX abc_a_idx ON abc (a);

-- Test 72: statement (line 333)
INSERT INTO abc VALUES (1, 2, 10);

-- Test 73: statement (line 338)
INSERT INTO abc VALUES (1, 3, 20);

-- Test 74: statement (line 341)
DROP TABLE IF EXISTS decimal;
CREATE TABLE decimal (
  a DECIMAL PRIMARY KEY
);

-- Test 75: statement (line 346)
INSERT INTO decimal VALUES (4);

-- Test 76: statement (line 351)
DROP TABLE IF EXISTS blindcput;
CREATE TABLE blindcput (
  x INT,
  v INT,
  PRIMARY KEY (x)
);

-- Test 77: statement (line 360)
INSERT INTO blindcput VALUES (1, 1), (2, 2), (3, 3), (4, 4), (5, 5);

-- Test 78: statement (line 363)
DROP TABLE IF EXISTS nocols;
CREATE TABLE nocols ();

-- Test 79: statement (line 366)
INSERT INTO nocols DEFAULT VALUES;

-- Test 80: statement (line 369)
INSERT INTO kv (k) VALUES ('hello');

-- Test 81: statement (line 372)
INSERT INTO kv (k) VALUES ('hello2');

-- Test 82: statement (line 375)
INSERT INTO kv (k, v) VALUES ('hello3', 'hello_v');

-- Test 83: statement (line 380)
DROP TABLE IF EXISTS insert_t;
CREATE TABLE insert_t (x INT, v INT DEFAULT 0);

-- Test 84: statement (line 383)
DROP TABLE IF EXISTS select_t;
CREATE TABLE select_t (x INT, v INT);

-- Test 85: statement (line 386)
INSERT INTO select_t VALUES (1, 9), (8, 2), (3, 7), (6, 4);

-- Test 86: query (line 390)
INSERT INTO insert_t
SELECT x, v FROM select_t ORDER BY v DESC LIMIT 3
RETURNING x, v;

-- Test 87: statement (line 399)
-- CockroachDB-only table storage parameter.
-- ALTER TABLE insert_t SET (schema_locked=false);

-- Test 88: statement (line 402)
TRUNCATE TABLE insert_t;

-- Test 89: statement (line 405)
-- CockroachDB-only table storage parameter.
-- ALTER TABLE insert_t RESET (schema_locked);

-- Test 90: statement (line 408)
INSERT INTO insert_t SELECT * FROM select_t LIMIT 1;

-- Test 91: query (line 411)
SELECT * FROM insert_t ORDER BY x, v;

-- Test 92: statement (line 416)
-- CockroachDB-only table storage parameter.
-- ALTER TABLE insert_t SET (schema_locked=false);

-- Test 93: statement (line 419)
TRUNCATE TABLE insert_t;

-- Test 94: statement (line 422)
-- CockroachDB-only table storage parameter.
-- ALTER TABLE insert_t RESET (schema_locked);

-- Test 95: statement (line 425)
INSERT INTO insert_t SELECT * FROM select_t LIMIT 1;

-- Test 96: query (line 428)
SELECT * FROM insert_t ORDER BY x, v;

-- Test 97: statement (line 433)
INSERT INTO insert_t
SELECT * FROM (VALUES (1, 1), (2, 2)) AS t(x, v)
LIMIT 1;

-- Test 98: statement (line 436)
INSERT INTO insert_t
SELECT * FROM (VALUES (1, 1), (2, 2)) AS t(x, v)
ORDER BY v;

-- Test 99: statement (line 439)
INSERT INTO insert_t (x, v) VALUES (11, DEFAULT), (12, 3);

-- Test 100: statement (line 442)
INSERT INTO insert_t (x, v) VALUES (13, DEFAULT) RETURNING *;

-- Test 101: statement (line 447)
DROP TABLE IF EXISTS bytes_t;
CREATE TABLE bytes_t (
  b BYTEA PRIMARY KEY
);

-- Test 102: statement (line 452)
INSERT INTO bytes_t VALUES ('byte'::bytea);

-- Test 103: statement (line 460)
DROP TABLE IF EXISTS string_t;
CREATE TABLE string_t (s TEXT);
INSERT INTO string_t VALUES ('str');

-- Test 104: query (line 512)
DROP TABLE IF EXISTS sw;
CREATE TABLE sw (
  a  TEXT,
  b  TEXT,
  c  INT,
  d  TEXT,
  e  TEXT,
  f  TEXT,
  g  TEXT,
  ac TEXT COLLATE "C",
  bc TEXT COLLATE "C",
  cc TEXT COLLATE "C",
  dc TEXT COLLATE "C",
  ec TEXT COLLATE "C",
  fc TEXT COLLATE "C"
);

SELECT column_name, collation_name
FROM information_schema.columns
WHERE table_schema = 'public' AND table_name = 'sw'
ORDER BY ordinal_position;

-- Test 105: statement (line 533)
INSERT INTO sw VALUES (
  'a', 'b', 1, 'd', 'e', 'f', 'g',
  'A' COLLATE "C", 'B' COLLATE "C", 'C' COLLATE "C",
  'D' COLLATE "C", 'E' COLLATE "C", 'F' COLLATE "C"
);

-- Test 106: statement (line 538)
INSERT INTO sw VALUES (
  '', '', 0, '', '', '', '',
  '' COLLATE "C", '' COLLATE "C", '' COLLATE "C",
  '' COLLATE "C", '' COLLATE "C", '' COLLATE "C"
);

-- Test 107: statement (line 543)
INSERT INTO sw(a) VALUES ('ab');

-- Test 108: statement (line 546)
INSERT INTO sw(ac) VALUES ('ab' COLLATE "C");

-- Test 109: statement (line 549)
INSERT INTO sw (b, c, d, e, f, g, bc, cc, dc, ec, fc) VALUES (
  'b22', 22, 'd22', 'e22', 'f22', 'g22',
  'B22' COLLATE "C", 'C22' COLLATE "C", 'D22' COLLATE "C",
  'E22' COLLATE "C", 'F22' COLLATE "C"
);

-- Test 110: statement (line 554)
INSERT INTO sw(b) VALUES ('abcd');

-- Test 111: statement (line 557)
INSERT INTO sw(bc) VALUES ('abcd' COLLATE "C");

-- Test 112: statement (line 560)
INSERT INTO sw(d) VALUES ('abcd');

-- Test 113: statement (line 563)
INSERT INTO sw(dc) VALUES ('abcd' COLLATE "C");

-- Test 114: statement (line 566)
INSERT INTO sw(f) VALUES ('abcd');

-- Test 115: statement (line 569)
INSERT INTO sw(fc) VALUES ('abcd' COLLATE "C");

-- Test 116: statement (line 574)
DROP TABLE IF EXISTS ct;
CREATE TABLE ct (
  x INT,
  derived INT GENERATED ALWAYS AS (x + 1) STORED
);

-- Test 117: statement (line 577)
INSERT INTO ct(x) SELECT c FROM sw;

-- Test 118: statement (line 588)
DROP TABLE IF EXISTS tn;
CREATE TABLE tn(x INT NULL CHECK(x IS NOT NULL), y CHAR(4) CHECK(length(y) < 4));

-- Test 119: statement (line 591)
INSERT INTO tn(x) VALUES (1);

-- Test 120: statement (line 594)
INSERT INTO tn(x, y) VALUES (2, 'abc');

-- Test 121: statement (line 598)
DROP TABLE IF EXISTS tn2;
CREATE TABLE tn2(x INT NOT NULL CHECK(x IS NOT NULL), y CHAR(3) CHECK(length(y) < 4));

-- Test 122: statement (line 601)
INSERT INTO tn2(x) VALUES (1);

-- Test 123: statement (line 604)
INSERT INTO tn2(x, y) VALUES (123, 'abc');

-- Test 124: statement (line 611)
DROP TABLE IF EXISTS derived;
DROP TABLE IF EXISTS src;
CREATE TABLE src(x VARCHAR PRIMARY KEY);
INSERT INTO src(x) VALUES ('abc'), ('xyz');
CREATE TABLE derived(
  x CHAR(3) REFERENCES src(x),
  y VARCHAR CHECK(length(y) < 4) REFERENCES src(x)
);

-- Test 125: statement (line 618)
INSERT INTO derived(x) VALUES ('xyz');

-- Test 126: statement (line 621)
INSERT INTO derived(x) VALUES ('abc');

-- Test 127: statement (line 624)
INSERT INTO derived(y) VALUES ('abc');

-- Test 128: statement (line 629)
DROP TABLE IF EXISTS t29494;
CREATE TABLE t29494(x INT);

-- Test 129: statement (line 632)
INSERT INTO t29494 VALUES (12);

-- Test 130: statement (line 635)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
ALTER TABLE t29494 ADD COLUMN y INT NOT NULL DEFAULT 123;

-- Test 131: query (line 641)
SELECT column_name, is_nullable, column_default
FROM information_schema.columns
WHERE table_schema = 'public' AND table_name = 't29494'
ORDER BY ordinal_position;

-- Test 132: statement (line 651)
INSERT INTO t29494(x) VALUES (123) RETURNING y;

-- Test 133: statement (line 654)
ROLLBACK;

-- Test 134: statement (line 657)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
ALTER TABLE t29494 ADD COLUMN y INT NOT NULL DEFAULT 123;

-- Test 135: query (line 662)
INSERT INTO t29494(x) VALUES (123) RETURNING *;

-- Test 136: statement (line 667)
COMMIT;

-- Setup for t32759 transaction DDL tests.
DROP TABLE IF EXISTS t32759;
CREATE TABLE t32759(x INT, y TEXT, z INT);
INSERT INTO t32759 VALUES (1, 'b', 1);

-- Test 137: statement (line 678)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
ALTER TABLE t32759 DROP COLUMN y;

-- Test 138: query (line 684)
SELECT column_name
FROM information_schema.columns
WHERE table_schema = 'public' AND table_name = 't32759'
ORDER BY ordinal_position;

-- Test 139: statement (line 695)
INSERT INTO t32759(x, z) VALUES (2, 2);

-- Test 140: statement (line 698)
ROLLBACK;

-- Test 141: statement (line 701)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
ALTER TABLE t32759 DROP COLUMN y;

-- Test 142: query (line 706)
INSERT INTO t32759(x, z) VALUES (1, 4) RETURNING *;

-- Test 143: statement (line 712)
COMMIT;

-- Test 144: statement (line 717)
DROP TABLE IF EXISTS xy;
DROP TABLE IF EXISTS ab;
CREATE TABLE xy(x INT PRIMARY KEY, y INT);
CREATE TABLE ab(a INT PRIMARY KEY, b INT);
INSERT INTO ab VALUES (1, 1), (2, 2);

-- Test 145: query (line 722)
INSERT INTO xy (x, y)
SELECT a, b FROM ab ORDER BY -b LIMIT 10
RETURNING *;

-- Test 146: statement (line 728)
DROP TABLE xy;
DROP TABLE ab;

-- Test 147: statement (line 733)
DROP TABLE IF EXISTS t35611;
CREATE TABLE t35611(a INT PRIMARY KEY, CHECK (a > 0));

-- Test 148: statement (line 736)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
ALTER TABLE t35611 ADD COLUMN b INT;

-- Test 149: statement (line 741)
INSERT INTO t35611 (a) VALUES (1);

-- Test 150: statement (line 744)
COMMIT;

-- Test 151: statement (line 752)
DROP TABLE IF EXISTS t35364;
CREATE TABLE t35364(x DECIMAL(1,0) CHECK (x = 0));

-- Test 152: statement (line 755)
INSERT INTO t35364(x) VALUES (0.1);

-- Test 153: query (line 758)
SELECT x FROM t35364;

-- Test 154: statement (line 763)
DROP TABLE t35364;

-- Test 155: statement (line 767)
DROP TABLE IF EXISTS generated_as_id_t;
CREATE TABLE generated_as_id_t (
  a INT UNIQUE,
  b INT GENERATED ALWAYS AS IDENTITY,
  c INT GENERATED BY DEFAULT AS IDENTITY
);

-- Test 156: statement (line 774)
INSERT INTO generated_as_id_t (a) VALUES (1), (2), (3);

-- Test 157: query (line 777)
SELECT * FROM generated_as_id_t ORDER BY a;

-- Test 158: statement (line 784)
INSERT INTO generated_as_id_t (a, b) OVERRIDING SYSTEM VALUE VALUES (4, 10);

-- Test 159: statement (line 787)
INSERT INTO generated_as_id_t (a, c) VALUES (5, 10);

-- Test 160: query (line 790)
SELECT * FROM generated_as_id_t ORDER BY a;

-- Test 161: statement (line 799)
DROP TABLE IF EXISTS gen_as_id_seqopt;
CREATE TABLE gen_as_id_seqopt (
  a INT UNIQUE,
  b INT GENERATED ALWAYS AS IDENTITY (START 2 INCREMENT 3),
  c INT GENERATED BY DEFAULT AS IDENTITY (START 3 INCREMENT 4)
);

-- Test 162: statement (line 806)
INSERT INTO gen_as_id_seqopt (a) VALUES (7), (8), (9);

-- Test 163: query (line 809)
SELECT * FROM gen_as_id_seqopt ORDER BY a;

-- Test 164: statement (line 816)
INSERT INTO gen_as_id_seqopt (a, b) OVERRIDING SYSTEM VALUE VALUES (10, 2);

-- Test 165: query (line 819)
SELECT * FROM gen_as_id_seqopt ORDER BY a;

-- Test 166: statement (line 826)
INSERT INTO gen_as_id_seqopt (a, c) VALUES (11, 2);

-- Test 167: query (line 829)
SELECT * FROM gen_as_id_seqopt ORDER BY a;

-- Test 168: statement (line 839)
DROP TABLE IF EXISTS t74795;
CREATE TABLE t74795 (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  account_id TEXT NOT NULL,
  deletion_request_id TEXT,
  UNIQUE NULLS NOT DISTINCT (account_id, deletion_request_id)
);
INSERT INTO t74795 (account_id)
VALUES ('foo'), ('foo'), ('foo')
ON CONFLICT (account_id, deletion_request_id) DO NOTHING;

-- Test 169: query (line 854)
SELECT account_id, deletion_request_id FROM t74795 ORDER BY account_id, deletion_request_id;

RESET client_min_messages;
