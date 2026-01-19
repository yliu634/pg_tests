-- PostgreSQL compatible tests from upsert
-- 294 tests

-- Test 1: statement (line 3)
CREATE TABLE ex(
  foo INT PRIMARY KEY,
  bar INT UNIQUE,
  baz INT
)

-- Test 2: statement (line 10)
INSERT INTO ex(foo,bar,baz) VALUES (1,1,1)

-- Test 3: statement (line 13)
INSERT INTO ex(foo,bar,baz) VALUES (1,1,1) ON CONFLICT DO NOTHING

-- Test 4: statement (line 16)
INSERT INTO ex(foo,bar,baz) VALUES (2,1,1) ON CONFLICT DO NOTHING

-- Test 5: statement (line 20)
INSERT INTO ex(foo,bar,baz) VALUES (1,2,1), (3,2,2), (6,6,2), (2,1,1) ON CONFLICT DO NOTHING

-- Test 6: query (line 23)
SELECT * from ex ORDER BY foo

-- Test 7: query (line 31)
INSERT INTO ex(foo,bar,baz) VALUES (4,3,1), (5,2,1) ON CONFLICT DO NOTHING RETURNING *

-- Test 8: statement (line 37)
CREATE TABLE ex2(
  a INT PRIMARY KEY,
  b INT UNIQUE,
  c INT,
  d INT,
  e INT,
  UNIQUE (c,d)
)

-- Test 9: statement (line 47)
INSERT INTO ex2(a,b,c,d,e) VALUES (0,0,0,0,0)

-- Test 10: statement (line 50)
INSERT INTO ex2(a,b,c,d,e) VALUES (1,0,1,1,0), (2,4,0,0,5) ON CONFLICT DO NOTHING

-- Test 11: statement (line 53)
INSERT INTO ex2(a,b,c,d,e) VALUES (3,4,5,6,7), (8,9,10,11,12), (13,14,15,16,17) ON CONFLICT DO NOTHING

-- Test 12: statement (line 56)
INSERT INTO ex2(a,b,c,d,e) VALUES (3,4,5,6,7), (8,9,10,11,12) ON CONFLICT DO NOTHING

-- Test 13: statement (line 59)
CREATE TABLE no_unique(
  a INT,
  b INT
)

-- Test 14: statement (line 65)
INSERT INTO no_unique(a,b) VALUES (1,2)

-- Test 15: statement (line 68)
INSERT INTO no_unique(a,b) VALUES (1,2) ON CONFLICT DO NOTHING

-- Test 16: statement (line 71)
INSERT INTO no_unique(a,b) VALUES (1,2), (1,3), (3,2) ON CONFLICT DO NOTHING

-- Test 17: query (line 74)
SELECT * from no_unique ORDER BY a, b

-- Test 18: statement (line 84)
INSERT INTO no_unique(a,b) VALUES (1,2), (1,2), (1,2) ON CONFLICT DO NOTHING

-- Test 19: statement (line 89)
CREATE TABLE kv (
  k INT PRIMARY KEY,
  v INT
)

-- Test 20: statement (line 95)
INSERT INTO kv VALUES (1, 1), (2, 2), (3, 3) ON CONFLICT (k) DO UPDATE SET v = excluded.v

-- Test 21: query (line 98)
SELECT * FROM kv ORDER BY (k, v)

-- Test 22: statement (line 105)
INSERT INTO kv VALUES (4, 4), (2, 5), (6, 6) ON CONFLICT (k) DO UPDATE SET v = 1, v = 1

-- Test 23: statement (line 108)
INSERT INTO kv VALUES (4, 4), (2, 5), (6, 6) ON CONFLICT (k) DO UPDATE SET v = excluded.v

-- Test 24: statement (line 111)
UPSERT INTO kv VALUES (7, 7), (3, 8), (9, 9)

-- Test 25: statement (line 114)
INSERT INTO kv VALUES (1, 10) ON CONFLICT (k) DO UPDATE SET v = (SELECT CAST(sum(k) AS INT) FROM kv)

-- Test 26: statement (line 117)
INSERT INTO kv VALUES (4, 10) ON CONFLICT (k) DO UPDATE SET v = v + 1

-- Test 27: statement (line 120)
INSERT INTO kv VALUES (4, 10) ON CONFLICT (k) DO UPDATE SET v = kv.v + 20

-- Test 28: statement (line 123)
INSERT INTO kv VALUES (2, 10) ON CONFLICT (k) DO UPDATE SET k = 3, v = 10

-- Test 29: statement (line 126)
INSERT INTO kv VALUES (9, 9) ON CONFLICT (k) DO UPDATE SET (k, v) = (excluded.k + 2, excluded.v + 3)

-- Test 30: statement (line 129)
UPSERT INTO kv VALUES (10, 10)

-- Test 31: statement (line 132)
UPSERT INTO kv VALUES (10, 11), (10, 12)

-- Test 32: query (line 135)
UPSERT INTO kv VALUES (11, 11), (10, 13) RETURNING k, v

-- Test 33: query (line 141)
UPSERT INTO kv VALUES (11) RETURNING k

-- Test 34: query (line 146)
UPSERT INTO kv VALUES (11, 12) RETURNING v

-- Test 35: statement (line 151)
INSERT INTO kv VALUES (13, 13), (7, 8) ON CONFLICT (k) DO NOTHING RETURNING *

-- Test 36: statement (line 154)
INSERT INTO kv VALUES (13, 13), (7, 8) ON CONFLICT DO NOTHING

-- Test 37: statement (line 157)
INSERT INTO kv VALUES (14, 14), (13, 15) ON CONFLICT (k) DO UPDATE SET v = excluded.v + 1

-- Test 38: statement (line 160)
INSERT INTO kv VALUES (15, 15), (14, 16) ON CONFLICT (k) DO UPDATE SET k = excluded.k * 10

-- Test 39: statement (line 163)
INSERT INTO kv VALUES (16, 16), (15, 17) ON CONFLICT (k) DO UPDATE SET k = excluded.k * 10, v = excluded.v

-- Test 40: query (line 166)
SELECT * FROM kv ORDER BY (k, v)

-- Test 41: query (line 182)
UPSERT INTO kv(k) VALUES (6), (8) RETURNING k,v

-- Test 42: query (line 188)
INSERT INTO kv VALUES (10, 10), (11, 11) ON CONFLICT (k) DO UPDATE SET v = excluded.v RETURNING *

-- Test 43: query (line 194)
INSERT INTO kv VALUES (10, 2), (11, 3) ON CONFLICT (k) DO UPDATE SET v = excluded.v + kv.v RETURNING *

-- Test 44: query (line 200)
INSERT INTO kv VALUES (10, 14), (15, 15) ON CONFLICT (k) DO NOTHING RETURNING *

-- Test 45: statement (line 205)
CREATE TABLE abc (
  a INT,
  b INT,
  c INT DEFAULT 7,
  PRIMARY KEY (a, b),
  INDEX y (b),
  UNIQUE INDEX z (c)
)

-- Test 46: statement (line 215)
UPSERT INTO abc (a, c) VALUES (1, 1)

-- Test 47: statement (line 218)
UPSERT INTO abc (b, c) VALUES (1, 1)

-- Test 48: statement (line 221)
INSERT INTO abc VALUES (1, 2, 3)

-- Test 49: statement (line 224)
INSERT INTO abc VALUES (1, 2, 3) ON CONFLICT (c) DO UPDATE SET a = 4

-- Test 50: query (line 227)
SELECT * FROM abc

-- Test 51: statement (line 232)
INSERT INTO abc VALUES (1, 2, 3) ON CONFLICT (c) DO UPDATE SET b = 5

-- Test 52: statement (line 235)
INSERT INTO abc VALUES (1, 2, 3) ON CONFLICT (c) DO UPDATE SET c = 6

-- Test 53: query (line 238)
SELECT * FROM abc

-- Test 54: statement (line 243)
INSERT INTO abc (a, b) VALUES (1, 2) ON CONFLICT (a, b) DO UPDATE SET a = 1, b = 2

-- Test 55: statement (line 246)
INSERT INTO abc (a, b) VALUES (4, 5) ON CONFLICT (a, b) DO UPDATE SET a = 7, b = 8

-- Test 56: query (line 249)
SELECT * FROM abc ORDER BY (a, b, c)

-- Test 57: statement (line 255)
DELETE FROM abc where a = 1

-- Test 58: statement (line 258)
UPSERT INTO abc VALUES (1, 2)

-- Test 59: query (line 261)
SELECT * FROM abc ORDER BY (a, b, c)

-- Test 60: statement (line 267)
UPSERT INTO abc VALUES (1, 2, 5)

-- Test 61: query (line 270)
SELECT * FROM abc ORDER BY (a, b, c)

-- Test 62: statement (line 276)
UPSERT INTO abc VALUES (1, 2)

-- Test 63: query (line 279)
SELECT * FROM abc ORDER BY (a, b, c)

-- Test 64: statement (line 285)
DELETE FROM abc where a = 1

-- Test 65: statement (line 288)
INSERT INTO abc VALUES (7, 8, 9) ON CONFLICT (a, b) DO UPDATE SET c = DEFAULT

-- Test 66: query (line 291)
SELECT * FROM abc ORDER BY (a, b, c)

-- Test 67: statement (line 296)
CREATE TABLE excluded (a INT PRIMARY KEY, b INT)

-- Test 68: statement (line 299)
INSERT INTO excluded VALUES (1, 1) ON CONFLICT (a) DO UPDATE SET b = excluded.b

-- Test 69: statement (line 303)
CREATE TABLE upsert_returning (a INT PRIMARY KEY, b INT, c INT, d INT DEFAULT -1)

-- Test 70: statement (line 306)
INSERT INTO upsert_returning VALUES (1, 1, NULL)

-- Test 71: query (line 310)
INSERT INTO upsert_returning (a, c) VALUES (1, 1), (2, 2) ON CONFLICT (a) DO UPDATE SET c = excluded.c RETURNING *

-- Test 72: query (line 317)
INSERT INTO upsert_returning (a, c) VALUES (1, 1), (3, 3) ON CONFLICT (a) DO NOTHING RETURNING *

-- Test 73: query (line 323)
UPSERT INTO upsert_returning (a, c) VALUES (1, 10), (3, 30) RETURNING *

-- Test 74: query (line 330)
SELECT b FROM upsert_returning WHERE a = 1

-- Test 75: query (line 335)
INSERT INTO upsert_returning (a, b) VALUES (1, 1) ON CONFLICT (a) DO UPDATE SET b = excluded.b + upsert_returning.b + 1 RETURNING b

-- Test 76: query (line 341)
UPSERT INTO upsert_returning (a, b) VALUES (1, 2), (2, 3), (4, 3) RETURNING a+b+d

-- Test 77: query (line 349)
UPSERT INTO upsert_returning VALUES (1, 2, 3, 4), (5, 6, 7, 8) RETURNING *

-- Test 78: statement (line 356)
BEGIN

-- Test 79: query (line 359)
upsert INTO upsert_returning VALUES (1, 5, 4, 3), (6, 5, 4, 3) RETURNING *

-- Test 80: statement (line 365)
COMMIT

-- Test 81: query (line 369)
SELECT a FROM [UPSERT INTO upsert_returning VALUES (7) RETURNING a] UNION VALUES (8)

-- Test 82: statement (line 379)
INSERT INTO issue_6710 (a, b) VALUES (1, 'foo'), (2, 'bar')

-- Test 83: statement (line 382)
UPSERT INTO issue_6710 (a, b) VALUES (1, 'test1'), (2, 'test2')

-- Test 84: query (line 385)
SELECT a, b from issue_6710

-- Test 85: statement (line 391)
CREATE TABLE issue_13962 (a INT PRIMARY KEY, b INT, c INT)

-- Test 86: statement (line 394)
INSERT INTO issue_13962 VALUES (1, 1, 1)

-- Test 87: statement (line 397)
INSERT INTO issue_13962 VALUES (1, 2, 2) ON CONFLICT (a) DO UPDATE SET b = excluded.b

-- Test 88: query (line 400)
SELECT * FROM issue_13962

-- Test 89: statement (line 405)
CREATE TABLE issue_14052 (a INT PRIMARY KEY, b INT, c INT)

-- Test 90: statement (line 408)
INSERT INTO issue_14052 (a, b) VALUES (1, 1), (2, 2)

-- Test 91: statement (line 411)
UPSERT INTO issue_14052 (a, c) (SELECT a, b from issue_14052)

-- Test 92: statement (line 414)
CREATE TABLE issue_14052_2 (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  createdAt INT,
  updatedAt INT
)

-- Test 93: statement (line 422)
INSERT INTO issue_14052_2 (id, name, createdAt, updatedAt) VALUES
  (1, 'original', 1, 1)

-- Test 94: statement (line 427)
INSERT INTO issue_14052_2 (id, name, createdAt, updatedAt) VALUES
  (1, 'UPDATED', 2, 2)
ON CONFLICT (id) DO UPDATE
  SET id = excluded.id, name = excluded.name, updatedAt = excluded.updatedAt

-- Test 95: query (line 433)
SELECT * FROM issue_14052_2;

-- Test 96: statement (line 438)
INSERT INTO issue_14052_2 (id, name, createdAt, updatedAt) VALUES
  (1, 'FOO', 3, 3)
ON CONFLICT (id) DO UPDATE
  SET id = excluded.id, name = excluded.name, name = excluded.name, name = excluded.name

-- Test 97: statement (line 445)
INSERT INTO issue_14052_2 (id, name, createdAt, updatedAt) VALUES
  (1, 'BAR', 4, 5)
ON CONFLICT (id) DO UPDATE
  SET name = excluded.name, createdAt = excluded.updatedAt, updatedAt = excluded.updatedAt

-- Test 98: query (line 451)
SELECT * FROM issue_14052_2;

-- Test 99: statement (line 458)
CREATE TABLE issue_16873 (col int PRIMARY KEY, date TIMESTAMP);

-- Test 100: statement (line 463)
INSERT INTO issue_16873 VALUES (1,clock_timestamp())
ON CONFLICT (col) DO UPDATE SET date = clock_timestamp() WHERE issue_16873.col = 1;

-- Test 101: statement (line 467)
INSERT INTO issue_16873 VALUES (1,clock_timestamp())
ON CONFLICT (col) DO UPDATE SET date = clock_timestamp() WHERE issue_16873.col = 1;

-- Test 102: statement (line 472)
CREATE TABLE issue_17339 (a int primary key, b int);

-- Test 103: statement (line 475)
INSERT INTO issue_17339 VALUES (1, 1), (2, 0);

-- Test 104: statement (line 478)
INSERT INTO issue_17339 VALUES (1, 0), (2, 2)
ON CONFLICT (a) DO UPDATE SET b = excluded.b WHERE excluded.b > issue_17339.b;

-- Test 105: query (line 482)
SELECT * FROM issue_17339 ORDER BY a;

-- Test 106: statement (line 488)
INSERT INTO issue_17339 VALUES (1, 0), (2, 1)
ON CONFLICT (a) DO UPDATE SET b = excluded.b WHERE TRUE;

-- Test 107: query (line 492)
SELECT * FROM issue_17339 ORDER BY a;

-- Test 108: statement (line 505)
CREATE TABLE tu (a INT PRIMARY KEY, b INT, c INT, d INT, FAMILY (a), FAMILY (b), FAMILY (c,d));
  INSERT INTO tu VALUES (1, 2, 3, 4)

-- Test 109: statement (line 509)
UPSERT INTO tu VALUES (1, NULL, NULL, NULL)

-- Test 110: query (line 512)
SELECT * FROM tu

-- Test 111: statement (line 519)
CREATE TABLE ab(
    a INT PRIMARY KEY,
    b INT, CHECK (b < 1)
)

-- Test 112: statement (line 525)
INSERT INTO ab(a, b) VALUES (1, 0);

-- Test 113: statement (line 528)
INSERT INTO ab(a, b) VALUES (1, 0) ON CONFLICT(a) DO UPDATE SET b=12312313;

-- Test 114: statement (line 531)
INSERT INTO ab(a, b) VALUES (1, 0) ON CONFLICT(a) DO UPDATE SET b=-1;

-- Test 115: statement (line 534)
CREATE TABLE abc_check(
    a INT PRIMARY KEY,
    b INT,
    c INT,
    CHECK (b < 1),
    CHECK (c > 1)
)

-- Test 116: statement (line 543)
INSERT INTO abc_check(a, b, c) VALUES (1, 0, 2);

-- Test 117: statement (line 546)
INSERT INTO abc_check(a, b, c) VALUES (1, 0, 2) ON CONFLICT(a) DO UPDATE SET b=12312313;

-- Test 118: statement (line 549)
INSERT INTO abc_check(a, b, c) VALUES (1, 0, 2) ON CONFLICT(a) DO UPDATE SET (b, c) = (1, 1);

-- Test 119: statement (line 552)
INSERT INTO abc_check(a, b, c) VALUES (1, 0, 2) ON CONFLICT(a) DO UPDATE SET (b, c) = (-1, 1);

-- Test 120: statement (line 555)
INSERT INTO abc_check(a, b, c) VALUES (2, 0, 3);

-- Test 121: statement (line 558)
INSERT INTO abc_check(c, a, b) VALUES (3, 2, 0) ON CONFLICT(a) DO UPDATE SET b=12312313;

-- Test 122: statement (line 561)
INSERT INTO abc_check(a, c) VALUES (2, 3) ON CONFLICT(a) DO UPDATE SET b=12312313;

-- Test 123: statement (line 564)
INSERT INTO abc_check(a, c) VALUES (2, 3) ON CONFLICT(a) DO UPDATE SET c=1;

-- Test 124: statement (line 567)
INSERT INTO abc_check(c, a) VALUES (3, 2) ON CONFLICT(a) DO UPDATE SET c=1;

-- Test 125: statement (line 570)
INSERT INTO abc_check(c, a) VALUES (3, 2) ON CONFLICT(a) DO UPDATE SET b=123123123;

-- Test 126: statement (line 573)
INSERT INTO abc_check(c, a) VALUES (3, 2) ON CONFLICT(a) DO UPDATE SET b=123123123;

-- Test 127: query (line 584)
UPSERT INTO example (value) VALUES ('foo') RETURNING id > 0

-- Test 128: statement (line 589)
DROP TABLE example

-- Test 129: statement (line 600)
CREATE TABLE tn(x INT NULL CHECK(x IS NOT NULL), y CHAR(4) CHECK(length(y) < 4));

-- Test 130: statement (line 603)
UPSERT INTO tn(x) VALUES (NULL)

-- Test 131: statement (line 606)
UPSERT INTO tn(y) VALUES ('abcd')

-- Test 132: statement (line 610)
CREATE TABLE tn2(x INT NOT NULL CHECK(x IS NOT NULL), y CHAR(3) CHECK(length(y) < 4));

-- Test 133: statement (line 613)
UPSERT INTO tn2(x) VALUES (NULL)

-- Test 134: statement (line 616)
UPSERT INTO tn2(x, y) VALUES (123, 'abcd')

-- Test 135: statement (line 621)
CREATE TABLE t29494(x INT) WITH (schema_locked=false);

-- Test 136: statement (line 624)
INSERT INTO t29494 VALUES (12)

-- Test 137: statement (line 627)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl = false;
ALTER TABLE t29494 ADD COLUMN y INT NOT NULL DEFAULT 123

-- Test 138: query (line 633)
SELECT create_statement FROM [SHOW CREATE t29494]

-- Test 139: statement (line 643)
UPSERT INTO t29494(x) VALUES (123) RETURNING y

-- Test 140: statement (line 647)
ROLLBACK;
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl = false;
ALTER TABLE t29494 ADD COLUMN y INT NOT NULL DEFAULT 123

-- Test 141: statement (line 653)
INSERT INTO t29494(x) VALUES (123) ON CONFLICT(rowid) DO UPDATE SET x = 400 RETURNING y

-- Test 142: statement (line 656)
ROLLBACK

-- Test 143: statement (line 659)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl = false;
ALTER TABLE t29494 ADD COLUMN y INT NOT NULL DEFAULT 123

-- Test 144: query (line 664)
UPSERT INTO t29494(x) VALUES (12) RETURNING *

-- Test 145: query (line 669)
UPSERT INTO t29494(x) VALUES (123) RETURNING *

-- Test 146: query (line 674)
INSERT INTO t29494(x) VALUES (123) ON CONFLICT(rowid) DO UPDATE SET x = 400 RETURNING *

-- Test 147: statement (line 679)
COMMIT

-- Test 148: statement (line 684)
CREATE TABLE tc(x INT PRIMARY KEY, y INT AS (x+1) STORED)

-- Test 149: statement (line 687)
INSERT INTO tc(x) VALUES (1) ON CONFLICT(x) DO UPDATE SET y = 123

-- Test 150: statement (line 690)
UPSERT INTO tc(x,y) VALUES (1,2)

-- Test 151: statement (line 693)
UPSERT INTO tc VALUES (1,2)

-- Test 152: statement (line 698)
CREATE TABLE t29497(x INT PRIMARY KEY) WITH (schema_locked=false);

-- Test 153: statement (line 701)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl = false;
ALTER TABLE t29497 ADD COLUMN y INT NOT NULL DEFAULT 123

-- Test 154: statement (line 706)
UPSERT INTO t29497 VALUES (1, 2)

-- Test 155: statement (line 709)
ROLLBACK;

-- Test 156: statement (line 712)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl = false;
ALTER TABLE t29497 ADD COLUMN y INT NOT NULL DEFAULT 123

-- Test 157: statement (line 717)
INSERT INTO t29497(x) VALUES (1) ON CONFLICT (x) DO UPDATE SET y = 456

-- Test 158: statement (line 720)
ROLLBACK

-- Test 159: statement (line 725)
ALTER TABLE tc SET (schema_locked=false);

-- Test 160: statement (line 728)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl = false;
ALTER TABLE tc DROP COLUMN y

-- Test 161: query (line 733)
UPSERT INTO tc VALUES (1), (2) RETURNING *

-- Test 162: statement (line 740)
COMMIT

-- Test 163: statement (line 743)
ALTER TABLE tc SET (schema_locked=true);

-- Test 164: statement (line 748)
CREATE TABLE t32762(x INT, y INT, UNIQUE (x,y), CONSTRAINT y_not_null CHECK (y IS NOT NULL))

-- Test 165: statement (line 751)
INSERT INTO t32762(x,y) VALUES (1,2) ON CONFLICT (x,y) DO UPDATE SET x = t32762.x;

-- Test 166: statement (line 754)
INSERT INTO t32762(x,y) VALUES (1,2) ON CONFLICT (x,y) DO UPDATE SET x = t32762.x

-- Test 167: statement (line 759)
CREATE TABLE ex33313(foo INT PRIMARY KEY, bar INT UNIQUE, baz INT);
  INSERT INTO ex33313 VALUES (1,1,1);

-- Test 168: statement (line 763)
INSERT INTO ex33313(foo,bar,baz) VALUES (1,2,1), (3,2,2) ON CONFLICT DO NOTHING;

-- Test 169: query (line 766)
SELECT * FROM ex33313 ORDER BY foo

-- Test 170: statement (line 775)
CREATE TABLE indexed (
  a DECIMAL PRIMARY KEY,
  b DECIMAL,
  c DECIMAL DEFAULT(10.0),
  d DECIMAL AS (a + c) STORED,
  UNIQUE INDEX secondary (d, b),
  CHECK (c > 0)
)

-- Test 171: statement (line 785)
INSERT INTO indexed VALUES (1, 1, 1); INSERT INTO indexed VALUES (2, 2, 2)

-- Test 172: statement (line 789)
UPSERT INTO indexed VALUES (1.0)

-- Test 173: query (line 792)
SELECT * FROM indexed@secondary ORDER BY d, b

-- Test 174: statement (line 801)
UPSERT INTO indexed (a, b, c) VALUES (1.0, 1.0, 1.0)

-- Test 175: query (line 804)
SELECT * FROM indexed@secondary ORDER BY d, b

-- Test 176: statement (line 813)
UPSERT INTO indexed (c, a) VALUES (2, 1)

-- Test 177: query (line 816)
SELECT * FROM indexed@secondary ORDER BY d, b

-- Test 178: query (line 824)
SELECT * FROM indexed@indexed_pkey ORDER BY a

-- Test 179: statement (line 832)
DROP INDEX indexed@secondary CASCADE

-- Test 180: statement (line 836)
UPSERT INTO indexed VALUES (1, 1)

-- Test 181: query (line 839)
SELECT * FROM indexed

-- Test 182: statement (line 847)
UPSERT INTO indexed (a, b, c) SELECT 1, 2, 3

-- Test 183: query (line 850)
SELECT * FROM indexed

-- Test 184: query (line 859)
UPSERT INTO indexed (c, a) VALUES (2.0, 1.0) RETURNING *

-- Test 185: query (line 864)
SELECT * FROM indexed

-- Test 186: statement (line 871)
DROP TABLE indexed

-- Test 187: statement (line 876)
CREATE TABLE test35040(a INT PRIMARY KEY, b INT NOT NULL, c INT2)

-- Test 188: statement (line 879)
INSERT INTO test35040(a,b) VALUES(0,0) ON CONFLICT(a) DO UPDATE SET b = NULL

-- Test 189: statement (line 882)
INSERT INTO test35040(a,b) VALUES(0,0) ON CONFLICT(a) DO UPDATE SET b = NULL

-- Test 190: statement (line 885)
INSERT INTO test35040(a,b) VALUES (0,1) ON CONFLICT(a) DO UPDATE SET c = 111111111;

-- Test 191: statement (line 888)
DROP TABLE test35040

-- Test 192: statement (line 896)
CREATE TABLE t35364(x INT PRIMARY KEY, y DECIMAL(10,1) CHECK(y >= 8.0), UNIQUE INDEX (y))

-- Test 193: statement (line 899)
INSERT INTO t35364(x, y) VALUES (1, 10.2)

-- Test 194: statement (line 905)
INSERT INTO t35364(x, y) VALUES (2, 10.18) ON CONFLICT (y) DO UPDATE SET y=7.95

-- Test 195: query (line 908)
SELECT * FROM t35364

-- Test 196: statement (line 913)
DROP TABLE t35364

-- Test 197: statement (line 917)
CREATE TABLE t35364(
    x DECIMAL(10,0) CHECK (x >= 0) PRIMARY KEY,
    y DECIMAL(10,0) CHECK (y >= 0)
)

-- Test 198: statement (line 923)
UPSERT INTO t35364 (x) VALUES (-0.1)

-- Test 199: query (line 926)
SELECT * FROM t35364

-- Test 200: statement (line 931)
UPSERT INTO t35364 (x, y) VALUES (-0.2, -0.3)

-- Test 201: query (line 934)
SELECT * FROM t35364

-- Test 202: statement (line 939)
UPSERT INTO t35364 (x, y) VALUES (1.5, 2.5)

-- Test 203: query (line 942)
SELECT * FROM t35364

-- Test 204: statement (line 948)
INSERT INTO t35364 (x) VALUES (1.5) ON CONFLICT (x) DO UPDATE SET x=2.5, y=3.5

-- Test 205: query (line 951)
SELECT * FROM t35364

-- Test 206: statement (line 960)
CREATE TABLE table35970 (
    a DECIMAL(10,1) PRIMARY KEY,
    b DECIMAL(10,1),
    c DECIMAL(10,0),
    FAMILY fam0 (a, b),
    FAMILY fam1 (c)
)

-- Test 207: query (line 969)
UPSERT INTO table35970 (a) VALUES (1.5) RETURNING b

-- Test 208: query (line 974)
INSERT INTO table35970 VALUES (1.5, 1.5, NULL)
ON CONFLICT (a)
DO UPDATE SET c = table35970.a+1
RETURNING b

-- Test 209: statement (line 987)
CREATE TABLE table38627 (a INT PRIMARY KEY, b INT) WITH (schema_locked=false); INSERT INTO table38627 VALUES(1,1)

-- Test 210: statement (line 990)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl = false;
ALTER TABLE table38627 ADD COLUMN c INT NOT NULL DEFAULT 5

-- Test 211: statement (line 995)
UPSERT INTO table38627 SELECT * FROM table38627 WHERE a=1

-- Test 212: query (line 998)
SELECT * from table38627

-- Test 213: statement (line 1003)
COMMIT

-- Test 214: query (line 1006)
SELECT * from table38627

-- Test 215: statement (line 1014)
CREATE TABLE t44466 (c0 INT PRIMARY KEY, c1 BOOL, c2 INT UNIQUE)

-- Test 216: statement (line 1017)
INSERT INTO t44466 (c0) VALUES (0)

-- Test 217: statement (line 1020)
UPSERT INTO t44466 (c2, c0) VALUES (0, 0), (1, 0)

-- Test 218: statement (line 1023)
DROP TABLE t44466

-- Test 219: statement (line 1029)
CREATE TABLE t46395(c0 INT UNIQUE DEFAULT 0, c1 INT);

-- Test 220: statement (line 1032)
INSERT INTO t46395(c1) VALUES (0), (1) ON CONFLICT (c0) DO NOTHING;

-- Test 221: statement (line 1035)
DROP TABLE t46395

-- Test 222: statement (line 1042)
CREATE TABLE tdup (x INT PRIMARY KEY, y INT, z INT)

-- Test 223: statement (line 1045)
INSERT INTO tdup VALUES (1, 1, 1)

-- Test 224: statement (line 1048)
INSERT INTO tdup VALUES (1, 2, 1), (1, 3, 1) ON CONFLICT (x) DO UPDATE SET z=1

-- Test 225: statement (line 1052)
CREATE UNIQUE INDEX ON tdup (y)

-- Test 226: statement (line 1055)
INSERT INTO tdup VALUES (1, 2, 1), (1, 3, 1) ON CONFLICT (x) DO UPDATE SET z=1

-- Test 227: statement (line 1059)
INSERT INTO tdup VALUES (2, 2, 2), (3, 2, 2) ON CONFLICT (x) DO UPDATE SET z=1

-- Test 228: statement (line 1062)
DROP TABLE tdup

-- Test 229: statement (line 1068)
CREATE TABLE tdup (x INT PRIMARY KEY, y INT, z INT, UNIQUE (y, z))

-- Test 230: statement (line 1071)
INSERT INTO tdup VALUES (1, 1, 1)

-- Test 231: statement (line 1074)
INSERT INTO tdup VALUES (2, 2, 2), (3, 2, 2) ON CONFLICT (z, y) DO UPDATE SET z=1

-- Test 232: statement (line 1078)
INSERT INTO tdup
VALUES (2, 2, NULL), (3, 2, NULL), (4, NULL, NULL), (5, NULL, NULL)
ON CONFLICT (z, y) DO UPDATE SET z=1

-- Test 233: query (line 1083)
SELECT * FROM tdup

-- Test 234: query (line 1092)
SELECT * FROM tdup@tdup_y_z_key

-- Test 235: statement (line 1102)
INSERT INTO tdup VALUES (6, 1, 1), (7, 1, 2) ON CONFLICT (y, z) DO UPDATE SET z=2

-- Test 236: statement (line 1106)
INSERT INTO tdup SELECT 6, 2, z FROM tdup WHERE z=1
ON CONFLICT (y, z) DO UPDATE SET z=2

-- Test 237: query (line 1110)
SELECT * FROM tdup

-- Test 238: statement (line 1121)
INSERT INTO tdup SELECT 6, 2, z FROM tdup WHERE z=1
ON CONFLICT (y, z) DO UPDATE SET z=2

-- Test 239: statement (line 1126)
INSERT INTO tdup SELECT x+100, y, y+1 FROM tdup WHERE z IS NULL
ON CONFLICT (y, z) DO UPDATE SET z=3

-- Test 240: statement (line 1130)
DROP TABLE tdup

-- Test 241: statement (line 1138)
CREATE TABLE target (a INT PRIMARY KEY, b INT, c INT, UNIQUE (b, c))

-- Test 242: statement (line 1141)
CREATE TABLE source (x INT PRIMARY KEY, y INT, z INT, INDEX (y, z))

-- Test 243: statement (line 1144)
INSERT INTO source
VALUES (1, 1, 1), (2, 1, 1), (3, 1, NULL), (4, 1, NULL), (5, NULL, NULL), (6, NULL, NULL)

-- Test 244: statement (line 1150)
INSERT INTO target SELECT x, y, z FROM source ON CONFLICT (b, c) DO UPDATE SET b=5

-- Test 245: statement (line 1154)
INSERT INTO target SELECT x, y, z FROM source WHERE (y IS NULL OR y > 0) AND x <> 1
ON CONFLICT (b, c) DO UPDATE SET b=5

-- Test 246: query (line 1158)
SELECT * FROM target

-- Test 247: query (line 1167)
SELECT * FROM target@target_b_c_key

-- Test 248: statement (line 1176)
DROP TABLE source

-- Test 249: statement (line 1179)
DROP TABLE target

-- Test 250: statement (line 1185)
CREATE TABLE target (x INT PRIMARY KEY, y INT, z INT, UNIQUE (y, z))

-- Test 251: statement (line 1188)
CREATE TABLE source (a INT, b INT, c INT)

-- Test 252: statement (line 1193)
INSERT INTO source
VALUES
    (1, 1, 2),
    (1, 2, 1),
    (1, 2, 2),
    (2, 3, 3),
    (4, 1, NULL),
    (5, 1, NULL),
    (6, NULL, NULL),
    (7, NULL, NULL)

-- Test 253: statement (line 1205)
INSERT INTO target SELECT * FROM source ON CONFLICT DO NOTHING

-- Test 254: query (line 1208)
SELECT * FROM target

-- Test 255: statement (line 1218)
INSERT INTO target SELECT 8, y, z FROM (VALUES (2, 2), (2, 3)) s(y, z)
ON CONFLICT (x) DO NOTHING

-- Test 256: query (line 1222)
SELECT * FROM target

-- Test 257: statement (line 1233)
DROP TABLE source

-- Test 258: statement (line 1236)
DROP TABLE target

-- Test 259: statement (line 1248)
INSERT INTO uniq VALUES ('x1', 'y1', 'z1');

-- Test 260: statement (line 1255)
INSERT INTO uniq VALUES ('x2', 'y1', 'z2'), ('x2', 'y2', 'z2'), ('x2', 'y2', 'z2')
ON CONFLICT DO NOTHING

-- Test 261: query (line 1259)
SELECT * FROM uniq

-- Test 262: statement (line 1266)
CREATE TABLE target (x INT PRIMARY KEY, y INT, z INT, UNIQUE (y, z))

-- Test 263: statement (line 1269)
CREATE TABLE source (a INT, b INT, c INT)

-- Test 264: statement (line 1272)
INSERT INTO source VALUES (1, 1, 2), (1, 2, 1)

-- Test 265: statement (line 1275)
INSERT INTO target SELECT * FROM source ORDER BY rowid ON CONFLICT DO NOTHING

-- Test 266: statement (line 1279)
CREATE TABLE generated_as_id_t (
  a INT UNIQUE,
  b INT GENERATED ALWAYS AS IDENTITY,
  c INT GENERATED BY DEFAULT AS IDENTITY
)

-- Test 267: statement (line 1286)
INSERT INTO generated_as_id_t (a) VALUES (1), (2), (3)

-- Test 268: statement (line 1289)
INSERT INTO generated_as_id_t (a, b) VALUES (1, 10) ON CONFLICT DO NOTHING

-- Test 269: statement (line 1292)
INSERT INTO generated_as_id_t (a, b) VALUES (1, 10) ON CONFLICT (a) DO UPDATE SET b=DEFAULT

-- Test 270: statement (line 1295)
INSERT INTO generated_as_id_t (a, c) VALUES (1, 10) ON CONFLICT DO NOTHING

-- Test 271: query (line 1302)
SELECT a,
         b - b_min + 1 AS b,
         c - c_min + 1 AS c
    FROM generated_as_id_t,
         (
              SELECT b AS b_min,
                     c AS c_min
                FROM generated_as_id_t
            ORDER BY a ASC
               LIMIT 1
         )
ORDER BY a

-- Test 272: statement (line 1323)
INSERT INTO generated_as_id_t (a) VALUES (1) ON CONFLICT (a) DO UPDATE SET b=DEFAULT;

-- Test 273: query (line 1334)
SELECT a,
         b - b_row2 AS b,
         c - c_row2 AS c
    FROM generated_as_id_t,
         (
              SELECT b AS b_row2,
                     c AS c_row2
                FROM generated_as_id_t
            ORDER BY b
               LIMIT 1
         )
ORDER BY a

-- Test 274: statement (line 1357)
CREATE TABLE arbiter_index (a INT, b INT, c INT, PRIMARY KEY (a, b), UNIQUE (c))

-- Test 275: statement (line 1360)
INSERT INTO arbiter_index VALUES (1,2,3)
ON CONFLICT ON CONSTRAINT arbiter_index_pkey DO NOTHING

-- Test 276: statement (line 1364)
INSERT INTO arbiter_index VALUES(1,2,3)
ON CONFLICT ON CONSTRAINT arbiter_index_pkey DO NOTHING

-- Test 277: statement (line 1368)
INSERT INTO arbiter_index VALUES(2,2,3)
ON CONFLICT ON CONSTRAINT arbiter_index_c_key DO UPDATE SET c=10

-- Test 278: query (line 1372)
SELECT * FROM arbiter_index

-- Test 279: statement (line 1381)
CREATE TABLE t133146 (
  id INT PRIMARY KEY,
  a INT NOT NULL,
  b INT
)

-- Test 280: statement (line 1388)
INSERT INTO t133146 (id, a, b) VALUES (1, 2, 3)

-- Test 281: statement (line 1393)
UPSERT INTO t133146 (id, b) VALUES (1, 30)

-- Test 282: query (line 1396)
SELECT * FROM t133146

-- Test 283: statement (line 1401)
INSERT INTO t133146 (id, b) VALUES (1, 40) ON CONFLICT (id) DO UPDATE SET b = 40

-- Test 284: query (line 1404)
SELECT * FROM t133146

-- Test 285: statement (line 1409)
UPSERT INTO t133146 (id, a) VALUES (1, NULL)

-- Test 286: statement (line 1412)
INSERT INTO t133146 (id, b) VALUES (1, 50) ON CONFLICT (id) DO UPDATE SET a = NULL

-- Test 287: statement (line 1415)
CREATE TABLE t133146b (
  a INT,
  b INT NOT NULL,
  id INT PRIMARY KEY
)

-- Test 288: statement (line 1422)
INSERT INTO t133146b (id, a, b) VALUES (1, 2, 3)

-- Test 289: statement (line 1425)
UPSERT INTO t133146b (id, b) VALUES (1, 30)

-- Test 290: query (line 1428)
SELECT * FROM t133146b

-- Test 291: statement (line 1433)
INSERT INTO t133146b (id, b) VALUES (1, 40) ON CONFLICT (id) DO UPDATE SET b = 40

-- Test 292: query (line 1436)
SELECT * FROM t133146b

-- Test 293: statement (line 1441)
UPSERT INTO t133146b (id, b) VALUES (1, NULL)

-- Test 294: statement (line 1444)
INSERT INTO t133146b (id, a) VALUES (1, 20) ON CONFLICT (id) DO UPDATE SET b = NULL

