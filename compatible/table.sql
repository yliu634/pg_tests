-- PostgreSQL compatible tests from table
-- 87 tests

-- Test 1: statement (line 1)
SET DATABASE = ""

-- Test 2: statement (line 4)
CREATE TABLE a (id INT PRIMARY KEY)

-- Test 3: statement (line 7)
CREATE TABLE test."" (id INT PRIMARY KEY)

-- Test 4: statement (line 10)
CREATE TABLE test.a (id INT PRIMARY KEY)

-- Test 5: statement (line 13)
CREATE TABLE test.a (id INT PRIMARY KEY)

-- Test 6: statement (line 16)
SET DATABASE = test

-- Test 7: statement (line 19)
CREATE TABLE "" (id INT PRIMARY KEY)

-- Test 8: statement (line 22)
CREATE TABLE a (id INT PRIMARY KEY)

-- Test 9: statement (line 25)
CREATE TABLE b (id INT PRIMARY KEY, id INT)

-- Test 10: statement (line 28)
CREATE TABLE b (id INT PRIMARY KEY, id2 INT PRIMARY KEY)

-- Test 11: statement (line 31)
CREATE TABLE dup_primary (a int, primary key (a,a))

-- Test 12: statement (line 34)
CREATE TABLE dup_unique (a int, unique (a,a))

-- Test 13: statement (line 37)
CREATE TABLE IF NOT EXISTS a (id INT PRIMARY KEY)

-- Test 14: statement (line 40)
COMMENT ON TABLE a IS 'a_comment'

-- Test 15: query (line 43)
SHOW TABLES FROM test

-- Test 16: statement (line 49)
CREATE TABLE b (id INT PRIMARY KEY)

-- Test 17: statement (line 52)
CREATE TABLE c (
  id INT PRIMARY KEY,
  foo INT CONSTRAINT foo_positive CHECK (foo > 0),
  bar INT,
  INDEX c_foo_idx (foo),
  INDEX (foo),
  INDEX c_foo_bar_idx (foo ASC, bar DESC),
  UNIQUE (bar)
)

-- Test 18: statement (line 63)
COMMENT ON INDEX c_foo_idx IS 'index_comment'

-- Test 19: query (line 66)
SHOW INDEXES FROM c

-- Test 20: query (line 83)
SHOW INDEXES FROM c WITH COMMENT

-- Test 21: query (line 102)
SELECT * FROM [SHOW CONSTRAINTS FROM c WITH COMMENT] ORDER BY constraint_name

-- Test 22: statement (line 110)
CREATE TABLE d (
  id    INT PRIMARY KEY NULL
)

-- Test 23: query (line 115)
SHOW COLUMNS FROM d

-- Test 24: statement (line 121)
CREATE TABLE e (
  id    INT NULL PRIMARY KEY
)

-- Test 25: query (line 126)
SHOW COLUMNS FROM e

-- Test 26: statement (line 132)
CREATE TABLE f (
  a INT,
  b INT,
  c INT,
  PRIMARY KEY (a, b, c)
)

-- Test 27: query (line 140)
SHOW COLUMNS FROM f

-- Test 28: query (line 148)
SHOW TABLES FROM test WITH COMMENT

-- Test 29: statement (line 159)
SET DATABASE = ""

-- Test 30: query (line 202)
SHOW INDEXES FROM test.users

-- Test 31: statement (line 217)
CREATE TABLE test.precision (x FLOAT(0))

-- Test 32: statement (line 220)
CREATE TABLE test.precision (x DECIMAL(0, 2))

-- Test 33: statement (line 223)
CREATE TABLE test.precision (x DECIMAL(2, 4))

onlyif config schema-locked-disabled

-- Test 34: query (line 227)
SHOW CREATE TABLE test.users

-- Test 35: query (line 249)
SHOW CREATE TABLE test.users

-- Test 36: statement (line 270)
CREATE TABLE test.dupe_generated (
  foo INT CHECK (foo > 1),
  bar INT CHECK (bar > 2),
  CHECK (foo > 2),
  CHECK (foo < 10)
)

-- Test 37: query (line 278)
SELECT * FROM [SHOW CONSTRAINTS FROM test.dupe_generated] ORDER BY constraint_name

-- Test 38: query (line 307)
SHOW CREATE TABLE test.named_constraints

-- Test 39: query (line 331)
SHOW CREATE TABLE test.named_constraints

-- Test 40: query (line 354)
SELECT * FROM [SHOW CONSTRAINTS FROM test.named_constraints] ORDER BY constraint_name

-- Test 41: statement (line 365)
CREATE TABLE test.dupe_named_constraints (
  id        INT CONSTRAINT pk PRIMARY KEY,
  title     VARCHAR CONSTRAINT one CHECK (1>1),
  name      VARCHAR CONSTRAINT pk UNIQUE
)

-- Test 42: statement (line 372)
CREATE TABLE test.dupe_named_constraints (
  id        INT CONSTRAINT pk PRIMARY KEY,
  title     VARCHAR CONSTRAINT one CHECK (1>1),
  name      VARCHAR CONSTRAINT one UNIQUE
)

-- Test 43: statement (line 379)
CREATE TABLE test.dupe_named_constraints (
  id        INT CONSTRAINT pk PRIMARY KEY,
  title     VARCHAR CONSTRAINT one CHECK (1>1),
  name      VARCHAR CONSTRAINT one REFERENCES test.named_constraints (username),
  INDEX (name)
)

-- Test 44: statement (line 387)
CREATE TABLE test.dupe_named_constraints (
  id        INT CONSTRAINT pk PRIMARY KEY,
  title     VARCHAR CONSTRAINT one CHECK (1>1) CONSTRAINT one CHECK (1<1)
)

-- Test 45: statement (line 393)
SET database = test

-- Test 46: query (line 446)
SHOW COLUMNS FROM alltypes

-- Test 47: statement (line 498)
CREATE DATABASE IF NOT EXISTS smtng

-- Test 48: statement (line 501)
CREATE TABLE IF NOT EXISTS smtng.something (
ID SERIAL PRIMARY KEY
)

-- Test 49: statement (line 506)
ALTER TABLE smtng.something ADD COLUMN IF NOT EXISTS OWNER_ID INT

-- Test 50: statement (line 509)
ALTER TABLE smtng.something ADD COLUMN IF NOT EXISTS MODEL_ID INT

-- Test 51: statement (line 515)
CREATE DATABASE IF NOT EXISTS smtng

-- Test 52: statement (line 518)
CREATE TABLE IF NOT EXISTS smtng.something (
ID SERIAL PRIMARY KEY
)

-- Test 53: statement (line 523)
ALTER TABLE smtng.something ADD COLUMN IF NOT EXISTS OWNER_ID INT

-- Test 54: statement (line 526)
ALTER TABLE smtng.something ADD COLUMN IF NOT EXISTS MODEL_ID INT

-- Test 55: statement (line 533)
CREATE TABLE test.empty ()

-- Test 56: statement (line 536)
SELECT * FROM test.empty

-- Test 57: statement (line 540)
CREATE TABLE test.null_default (
  ts timestamp NULL DEFAULT NULL
)

onlyif config schema-locked-disabled

-- Test 58: query (line 546)
SHOW CREATE TABLE test.null_default

-- Test 59: query (line 556)
SHOW CREATE TABLE test.null_default

-- Test 60: statement (line 566)
CREATE TABLE test.t1 (a DECIMAL DEFAULT (DECIMAL 'blah'));

-- Test 61: statement (line 569)
create table test.t1 (c decimal default if(false, 1, 'blah'::decimal));

-- Test 62: statement (line 572)
CREATE DATABASE a; CREATE TABLE a.c(d INT); INSERT INTO a.public.c(d) VALUES (1)

-- Test 63: query (line 575)
SELECT a.public.c.d FROM a.public.c

-- Test 64: statement (line 580)
CREATE TABLE t0 (a INT)

-- Test 65: statement (line 583)
GRANT ALL ON t0 to testuser

-- Test 66: statement (line 586)
CREATE DATABASE rowtest

-- Test 67: statement (line 589)
GRANT ALL ON DATABASE rowtest TO testuser

user testuser

-- Test 68: statement (line 594)
SET DATABASE = rowtest

-- Test 69: statement (line 597)
CREATE TABLE t1 (a INT)

-- Test 70: statement (line 600)
INSERT INTO t1 SELECT a FROM generate_series(1, 1024) AS a(a)

-- Test 71: query (line 604)
SHOW TABLES

-- Test 72: query (line 613)
select table_name, estimated_row_count from crdb_internal.table_row_statistics
  WHERE table_id < 1000 OR table_name = 'table_row_statistics';

-- Test 73: statement (line 620)
ANALYZE t1

-- Test 74: query (line 623)
SELECT estimated_row_count FROM [SHOW TABLES] where table_name = 't1'

-- Test 75: statement (line 628)
DELETE FROM rowtest.t1 WHERE a > 1000;

-- Test 76: statement (line 631)
ANALYZE rowtest.t1

-- Test 77: query (line 634)
SELECT estimated_row_count FROM [SHOW TABLES from rowtest] where table_name = 't1'

-- Test 78: statement (line 643)
BEGIN;
CREATE TABLE tblmodified (price INT8, quantity INT8);
ALTER TABLE tblmodified ADD CONSTRAINT quan_check CHECK (quantity > 0);
ALTER TABLE tblmodified ADD CONSTRAINT pr_check CHECK (price > 0);

-- Test 79: query (line 650)
SELECT conname,
       pg_get_constraintdef(c.oid) AS constraintdef,
       c.convalidated AS valid
  FROM pg_constraint AS c JOIN pg_class AS t ON c.conrelid = t.oid
 WHERE c.contype = 'c' AND t.relname = 'tblmodified' ORDER BY conname ASC;

-- Test 80: statement (line 661)
ALTER TABLE tblmodified DROP CONSTRAINT quan_check;

-- Test 81: query (line 666)
SELECT conname,
       pg_get_constraintdef(c.oid) AS constraintdef,
       c.convalidated AS valid
  FROM pg_constraint AS c JOIN pg_class AS t ON c.conrelid = t.oid
 WHERE c.contype = 'c' AND t.relname = 'tblmodified' ORDER BY conname ASC;

-- Test 82: statement (line 675)
COMMIT;

-- Test 83: statement (line 681)
CREATE TABLE t (k INT PRIMARY KEY)

-- Test 84: statement (line 684)
INSERT INTO t SELECT generate_series(0, 9)

-- Test 85: statement (line 687)
ANALYZE t

-- Test 86: statement (line 690)
CREATE STATISTICS partial FROM t USING EXTREMES

-- Test 87: query (line 693)
SELECT estimated_row_count FROM crdb_internal.table_row_statistics WHERE table_name = 't'

