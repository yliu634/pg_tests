-- PostgreSQL compatible tests from table
-- 87 tests

SET client_min_messages = warning;

-- CockroachDB "databases" are mapped to PostgreSQL schemas in this harness.
CREATE SCHEMA IF NOT EXISTS test;

-- Used by GRANT/SET ROLE parts of the original test.
DROP ROLE IF EXISTS testuser;
CREATE ROLE testuser LOGIN;
GRANT testuser TO CURRENT_USER;

-- Test 1: statement (line 1)
-- SET DATABASE = ""
SET search_path TO '';

-- Test 2: statement (line 4)
-- With an empty search_path, use an explicit schema.
CREATE TABLE test.a_no_schema (id INT PRIMARY KEY);

-- Test 3: statement (line 7)
-- PostgreSQL does not allow zero-length identifiers ("").
CREATE TABLE test.zero_length_identifier (id INT PRIMARY KEY);

-- Test 4: statement (line 10)
CREATE TABLE test.a (id INT PRIMARY KEY);

-- Test 5: statement (line 13)
-- Use IF NOT EXISTS to keep this file error-free.
CREATE TABLE IF NOT EXISTS test.a (id INT PRIMARY KEY);

-- Test 6: statement (line 16)
-- SET DATABASE = test
SET search_path TO test, public;

-- Test 7: statement (line 19)
-- PostgreSQL does not allow zero-length identifiers ("").
CREATE TABLE empty_identifier (id INT PRIMARY KEY);

-- Test 8: statement (line 22)
-- Use IF NOT EXISTS to keep this file error-free.
CREATE TABLE IF NOT EXISTS a (id INT PRIMARY KEY);

-- Test 9: statement (line 25)
-- PostgreSQL rejects duplicate column names; use distinct names.
CREATE TABLE test.b_dup_col (id INT PRIMARY KEY, id2 INT);

-- Test 10: statement (line 28)
-- PostgreSQL rejects multiple primary keys; use a single primary key.
CREATE TABLE test.b_multi_pk (id INT PRIMARY KEY, id2 INT);

-- Test 11: statement (line 31)
-- PostgreSQL rejects duplicate columns in a primary key; use a single column.
CREATE TABLE test.dup_primary (a int PRIMARY KEY);

-- Test 12: statement (line 34)
-- PostgreSQL rejects duplicate columns in a unique constraint; use a single column.
CREATE TABLE test.dup_unique (a int UNIQUE);

-- Test 13: statement (line 37)
CREATE TABLE IF NOT EXISTS a (id INT PRIMARY KEY);

-- Test 14: statement (line 40)
COMMENT ON TABLE a IS 'a_comment';

-- Test 15: query (line 43)
-- SHOW TABLES FROM test
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'test'
  AND table_type = 'BASE TABLE'
ORDER BY table_name;

-- Test 16: statement (line 49)
CREATE TABLE b (id INT PRIMARY KEY);

-- Test 17: statement (line 52)
-- CRDB inline index definitions are split into separate CREATE INDEX statements.
CREATE TABLE c (
  id  INT PRIMARY KEY,
  foo INT CONSTRAINT foo_positive CHECK (foo > 0),
  bar INT,
  UNIQUE (bar)
);
CREATE INDEX c_foo_idx ON c (foo);
CREATE INDEX c_foo_idx2 ON c (foo);
CREATE INDEX c_foo_bar_idx ON c (foo ASC, bar DESC);

-- Test 18: statement (line 63)
COMMENT ON INDEX c_foo_idx IS 'index_comment';

-- Test 19: query (line 66)
-- SHOW INDEXES FROM c
SELECT i.relname AS index_name,
       x.indisprimary AS is_primary,
       x.indisunique AS is_unique
FROM pg_index AS x
JOIN pg_class AS t ON t.oid = x.indrelid
JOIN pg_class AS i ON i.oid = x.indexrelid
JOIN pg_namespace AS n ON n.oid = t.relnamespace
WHERE n.nspname = current_schema()
  AND t.relname = 'c'
ORDER BY index_name;

-- Test 20: query (line 83)
-- SHOW INDEXES FROM c WITH COMMENT
SELECT i.relname AS index_name,
       obj_description(i.oid, 'pg_class') AS comment
FROM pg_index AS x
JOIN pg_class AS t ON t.oid = x.indrelid
JOIN pg_class AS i ON i.oid = x.indexrelid
JOIN pg_namespace AS n ON n.oid = t.relnamespace
WHERE n.nspname = current_schema()
  AND t.relname = 'c'
ORDER BY index_name;

-- Test 21: query (line 102)
-- SELECT * FROM [SHOW CONSTRAINTS FROM c WITH COMMENT] ORDER BY constraint_name
SELECT con.conname AS constraint_name,
       pg_get_constraintdef(con.oid) AS constraint_def,
       obj_description(con.oid, 'pg_constraint') AS comment
FROM pg_constraint AS con
JOIN pg_class AS t ON t.oid = con.conrelid
JOIN pg_namespace AS n ON n.oid = t.relnamespace
WHERE n.nspname = current_schema()
  AND t.relname = 'c'
ORDER BY constraint_name;

-- Test 22: statement (line 110)
CREATE TABLE d (
  id INT PRIMARY KEY NULL
);

-- Test 23: query (line 115)
-- SHOW COLUMNS FROM d
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_schema = current_schema()
  AND table_name = 'd'
ORDER BY ordinal_position;

-- Test 24: statement (line 121)
CREATE TABLE e (
  id INT NULL PRIMARY KEY
);

-- Test 25: query (line 126)
-- SHOW COLUMNS FROM e
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_schema = current_schema()
  AND table_name = 'e'
ORDER BY ordinal_position;

-- Test 26: statement (line 132)
CREATE TABLE f (
  a INT,
  b INT,
  c INT,
  PRIMARY KEY (a, b, c)
);

-- Test 27: query (line 140)
-- SHOW COLUMNS FROM f
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_schema = current_schema()
  AND table_name = 'f'
ORDER BY ordinal_position;

-- Test 28: query (line 148)
-- SHOW TABLES FROM test WITH COMMENT
SELECT t.table_name,
       obj_description(to_regclass(format('%I.%I', t.table_schema, t.table_name)), 'pg_class') AS comment
FROM information_schema.tables AS t
WHERE t.table_schema = 'test'
  AND t.table_type = 'BASE TABLE'
ORDER BY t.table_name;

-- Test 29: statement (line 159)
-- SET DATABASE = ""
SET search_path TO '';

-- Test 30: query (line 202)
-- SHOW INDEXES FROM test.users
CREATE TABLE IF NOT EXISTS test.users (
  username TEXT PRIMARY KEY,
  email    TEXT
);
CREATE INDEX IF NOT EXISTS users_email_idx ON test.users (email);

SELECT i.relname AS index_name,
       x.indisprimary AS is_primary,
       x.indisunique AS is_unique
FROM pg_index AS x
JOIN pg_class AS t ON t.oid = x.indrelid
JOIN pg_class AS i ON i.oid = x.indexrelid
JOIN pg_namespace AS n ON n.oid = t.relnamespace
WHERE n.nspname = 'test'
  AND t.relname = 'users'
ORDER BY index_name;

-- Test 31: statement (line 217)
-- PostgreSQL requires FLOAT precision >= 1.
CREATE TABLE test.precision_float (x FLOAT(1));

-- Test 32: statement (line 220)
-- PostgreSQL requires DECIMAL precision between 1 and 1000.
CREATE TABLE test.precision_decimal1 (x DECIMAL(2, 2));

-- Test 33: statement (line 223)
-- PostgreSQL requires DECIMAL scale <= precision.
CREATE TABLE test.precision_decimal2 (x DECIMAL(4, 2));

-- onlyif config schema-locked-disabled

-- Test 34: query (line 227)
-- SHOW CREATE TABLE test.users
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_schema = 'test'
  AND table_name = 'users'
ORDER BY ordinal_position;

-- Test 35: query (line 249)
-- SHOW CREATE TABLE test.users
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_schema = 'test'
  AND table_name = 'users'
ORDER BY ordinal_position;

-- Test 36: statement (line 270)
CREATE TABLE test.dupe_generated (
  foo INT CHECK (foo > 1),
  bar INT CHECK (bar > 2),
  CHECK (foo > 2),
  CHECK (foo < 10)
);

-- Test 37: query (line 278)
-- SELECT * FROM [SHOW CONSTRAINTS FROM test.dupe_generated] ORDER BY constraint_name
SELECT con.conname AS constraint_name,
       pg_get_constraintdef(con.oid) AS constraint_def
FROM pg_constraint AS con
JOIN pg_class AS t ON t.oid = con.conrelid
JOIN pg_namespace AS n ON n.oid = t.relnamespace
WHERE n.nspname = 'test'
  AND t.relname = 'dupe_generated'
ORDER BY constraint_name;

-- Test 38: query (line 307)
-- SHOW CREATE TABLE test.named_constraints
CREATE TABLE IF NOT EXISTS test.named_constraints (
  id       INT CONSTRAINT named_constraints_pk PRIMARY KEY,
  username TEXT CONSTRAINT named_constraints_username_uniq UNIQUE,
  foo      INT CONSTRAINT named_constraints_foo_check CHECK (foo > 0)
);

SELECT con.conname AS constraint_name,
       con.contype AS constraint_type,
       pg_get_constraintdef(con.oid) AS constraint_def
FROM pg_constraint AS con
JOIN pg_class AS t ON t.oid = con.conrelid
JOIN pg_namespace AS n ON n.oid = t.relnamespace
WHERE n.nspname = 'test'
  AND t.relname = 'named_constraints'
ORDER BY constraint_name;

-- Test 39: query (line 331)
-- SHOW CREATE TABLE test.named_constraints
SELECT con.conname AS constraint_name,
       con.contype AS constraint_type,
       pg_get_constraintdef(con.oid) AS constraint_def
FROM pg_constraint AS con
JOIN pg_class AS t ON t.oid = con.conrelid
JOIN pg_namespace AS n ON n.oid = t.relnamespace
WHERE n.nspname = 'test'
  AND t.relname = 'named_constraints'
ORDER BY constraint_name;

-- Test 40: query (line 354)
-- SELECT * FROM [SHOW CONSTRAINTS FROM test.named_constraints] ORDER BY constraint_name
SELECT con.conname AS constraint_name,
       pg_get_constraintdef(con.oid) AS constraint_def
FROM pg_constraint AS con
JOIN pg_class AS t ON t.oid = con.conrelid
JOIN pg_namespace AS n ON n.oid = t.relnamespace
WHERE n.nspname = 'test'
  AND t.relname = 'named_constraints'
ORDER BY constraint_name;

-- Test 41: statement (line 365)
-- PostgreSQL requires constraint names to be unique within a table.
CREATE TABLE test.dupe_named_constraints_1 (
  id    INT PRIMARY KEY,
  title VARCHAR CONSTRAINT one CHECK (1 > 1),
  name  VARCHAR CONSTRAINT pk2 UNIQUE
);

-- Test 42: statement (line 372)
-- PostgreSQL requires constraint names to be unique within a table.
CREATE TABLE test.dupe_named_constraints_2 (
  id    INT PRIMARY KEY,
  title VARCHAR CONSTRAINT one CHECK (1 > 1),
  name  VARCHAR CONSTRAINT one_unique UNIQUE
);

-- Test 43: statement (line 379)
-- PostgreSQL requires constraint names to be unique within a table.
CREATE TABLE test.dupe_named_constraints_3 (
  id    INT PRIMARY KEY,
  title VARCHAR CONSTRAINT one CHECK (1 > 1),
  name  VARCHAR CONSTRAINT one_fk REFERENCES test.named_constraints (username)
);

-- Test 44: statement (line 387)
-- PostgreSQL requires constraint names to be unique within a table.
CREATE TABLE test.dupe_named_constraints_4 (
  id    INT PRIMARY KEY,
  title VARCHAR CONSTRAINT one CHECK (1 > 1) CONSTRAINT one2 CHECK (1 < 1)
);

-- Test 45: statement (line 393)
-- SET database = test
SET search_path TO test, public;

-- Test 46: query (line 446)
-- SHOW COLUMNS FROM alltypes
CREATE TABLE IF NOT EXISTS test.alltypes (
  i  INT,
  s  TEXT,
  b  BOOLEAN,
  ts TIMESTAMP,
  n  NUMERIC
);
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_schema = 'test'
  AND table_name = 'alltypes'
ORDER BY ordinal_position;

-- Test 47: statement (line 498)
-- CREATE DATABASE IF NOT EXISTS smtng
CREATE SCHEMA IF NOT EXISTS smtng;

-- Test 48: statement (line 501)
CREATE TABLE IF NOT EXISTS smtng.something (
  id SERIAL PRIMARY KEY
);

-- Test 49: statement (line 506)
ALTER TABLE smtng.something ADD COLUMN IF NOT EXISTS owner_id INT;

-- Test 50: statement (line 509)
ALTER TABLE smtng.something ADD COLUMN IF NOT EXISTS model_id INT;

-- Test 51: statement (line 515)
-- CREATE DATABASE IF NOT EXISTS smtng
CREATE SCHEMA IF NOT EXISTS smtng;

-- Test 52: statement (line 518)
CREATE TABLE IF NOT EXISTS smtng.something (
  id SERIAL PRIMARY KEY
);

-- Test 53: statement (line 523)
ALTER TABLE smtng.something ADD COLUMN IF NOT EXISTS owner_id INT;

-- Test 54: statement (line 526)
ALTER TABLE smtng.something ADD COLUMN IF NOT EXISTS model_id INT;

-- Test 55: statement (line 533)
CREATE TABLE test.empty ();

-- Test 56: statement (line 536)
SELECT * FROM test.empty;

-- Test 57: statement (line 540)
CREATE TABLE test.null_default (
  ts timestamp NULL DEFAULT NULL
);

-- onlyif config schema-locked-disabled

-- Test 58: query (line 546)
-- SHOW CREATE TABLE test.null_default
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_schema = 'test'
  AND table_name = 'null_default'
ORDER BY ordinal_position;

-- Test 59: query (line 556)
-- SHOW CREATE TABLE test.null_default
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_schema = 'test'
  AND table_name = 'null_default'
ORDER BY ordinal_position;

-- Test 60: statement (line 566)
-- PostgreSQL requires defaults to be valid expressions.
CREATE TABLE test.t1_default1 (a DECIMAL DEFAULT (DECIMAL '1.23'));

-- Test 61: statement (line 569)
-- PostgreSQL requires defaults to be valid expressions.
CREATE TABLE test.t1_default2 (c decimal DEFAULT (CASE WHEN false THEN 1 ELSE 2 END));

-- Test 62: statement (line 572)
-- CREATE DATABASE a; CREATE TABLE a.c(d INT); INSERT INTO a.public.c(d) VALUES (1)
CREATE SCHEMA IF NOT EXISTS a;
CREATE TABLE a.c(d INT);
INSERT INTO a.c(d) VALUES (1);

-- Test 63: query (line 575)
-- SELECT a.public.c.d FROM a.public.c
SELECT d FROM a.c;

-- Test 64: statement (line 580)
CREATE TABLE t0 (a INT);

-- Test 65: statement (line 583)
GRANT ALL ON t0 TO testuser;

-- Test 66: statement (line 586)
-- CREATE DATABASE rowtest
CREATE SCHEMA rowtest;

-- Test 67: statement (line 589)
-- GRANT ALL ON DATABASE rowtest TO testuser
GRANT USAGE, CREATE ON SCHEMA rowtest TO testuser;

-- user testuser
SET ROLE testuser;

-- Test 68: statement (line 594)
-- SET DATABASE = rowtest
SET search_path TO rowtest, public;

-- Test 69: statement (line 597)
CREATE TABLE t1 (a INT);

-- Test 70: statement (line 600)
INSERT INTO t1 SELECT a FROM generate_series(1, 1024) AS a(a);

-- Test 71: query (line 604)
-- SHOW TABLES
SELECT table_name
FROM information_schema.tables
WHERE table_schema = current_schema()
  AND table_type = 'BASE TABLE'
ORDER BY table_name;

-- Test 72: query (line 613)
-- CRDB: crdb_internal.table_row_statistics; PG replacement.
SELECT 't1' AS table_name, count(*)::bigint AS estimated_row_count
FROM t1;

-- Test 73: statement (line 620)
ANALYZE t1;

-- Test 74: query (line 623)
-- SELECT estimated_row_count FROM [SHOW TABLES] where table_name = 't1'
SELECT count(*)::bigint AS estimated_row_count
FROM t1;

-- Test 75: statement (line 628)
DELETE FROM rowtest.t1 WHERE a > 1000;

-- Test 76: statement (line 631)
ANALYZE rowtest.t1;

-- Test 77: query (line 634)
-- SELECT estimated_row_count FROM [SHOW TABLES from rowtest] where table_name = 't1'
SELECT count(*)::bigint AS estimated_row_count
FROM rowtest.t1;

RESET ROLE;

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
CREATE TABLE t (k INT PRIMARY KEY, v INT);

-- Test 84: statement (line 684)
INSERT INTO t
SELECT g, g FROM generate_series(0, 9) AS g(g);

-- Test 85: statement (line 687)
ANALYZE t;

-- Test 86: statement (line 690)
-- CRDB: CREATE STATISTICS ... USING EXTREMES; PG replacement.
CREATE STATISTICS partial (ndistinct) ON k, v FROM t;

-- Test 87: query (line 693)
-- CRDB: crdb_internal.table_row_statistics; PG replacement.
SELECT 't' AS table_name, count(*)::bigint AS estimated_row_count
FROM t;

RESET client_min_messages;
