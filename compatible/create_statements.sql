-- PostgreSQL compatible tests from create_statements
-- NOTE: CockroachDB crdb_internal.create_statements and SHOW CREATE TABLE are not available in PostgreSQL.
-- This file is rewritten to introspect object definitions via PostgreSQL catalogs.

SET client_min_messages = warning;

DROP TABLE IF EXISTS c CASCADE;
DROP TABLE IF EXISTS t CASCADE;
DROP TABLE IF EXISTS unlogged_tbl CASCADE;

CREATE TABLE t (
  a INT PRIMARY KEY
);

CREATE TABLE c (
  a INT NOT NULL,
  b INT,
  CONSTRAINT c_a_fk FOREIGN KEY (a) REFERENCES t(a)
);

CREATE INDEX c_a_b_idx ON c (a ASC, b ASC);

COMMENT ON TABLE c IS 'table';
COMMENT ON COLUMN c.a IS 'column';
COMMENT ON INDEX c_a_b_idx IS 'index';

-- Introspect index and constraint definitions.
SELECT indexname, indexdef
FROM pg_indexes
WHERE schemaname = current_schema()
  AND tablename = 'c'
ORDER BY indexname;

SELECT conname, pg_get_constraintdef(oid) AS condef
FROM pg_constraint
WHERE conrelid = 'c'::regclass
ORDER BY conname;

-- Introspect comments.
SELECT obj_description('c'::regclass, 'pg_class') AS table_comment;
SELECT col_description('c'::regclass, 1) AS column_a_comment;

-- UNLOGGED tables.
CREATE UNLOGGED TABLE unlogged_tbl (col INT PRIMARY KEY);
SELECT relname, relpersistence
FROM pg_class
WHERE oid = 'unlogged_tbl'::regclass;

-- Storage parameters (valid PostgreSQL values).
DROP TABLE IF EXISTS a CASCADE;
CREATE TABLE a (b INT) WITH (fillfactor = 80, autovacuum_enabled = off);
CREATE INDEX a_idx ON a(b) WITH (fillfactor = 50);
SELECT relname, reloptions
FROM pg_class
WHERE relname IN ('a', 'a_idx')
ORDER BY relname;

DROP TABLE IF EXISTS a CASCADE;

RESET client_min_messages;
