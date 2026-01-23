-- PostgreSQL compatible tests from inspect
-- 145 tests

SET client_min_messages = warning;

-- CockroachDB's `INSPECT` statements and job tracking tables/functions
-- (`crdb_internal.*`) do not exist in PostgreSQL.
--
-- This file adapts the original intent by:
-- - Using `ANALYZE` as a lightweight stand-in for `INSPECT`.
-- - Maintaining a `last_inspect_job` table with similar columns, populated
--   from PostgreSQL catalogs (`pg_indexes`) after each ANALYZE.

DROP TABLE IF EXISTS last_inspect_job;
CREATE TABLE last_inspect_job (
  status     TEXT NOT NULL,
  num_checks INT  NOT NULL
);
INSERT INTO last_inspect_job(status, num_checks) VALUES ('complete', 0);

-- Provide a small compatibility shim for tests that referenced
-- `crdb_internal.datums_to_bytes(...)`.
CREATE SCHEMA IF NOT EXISTS crdb_internal;
CREATE OR REPLACE FUNCTION crdb_internal.datums_to_bytes(v anyelement) RETURNS bytea
LANGUAGE SQL IMMUTABLE AS $$
  SELECT convert_to($1::text, 'UTF8');
$$;

-- Helper pattern (inline): update the tracking row after an "inspect".
--   UPDATE last_inspect_job SET status='complete', num_checks=(...);

-- Test 1: statement (adapted)
DROP TABLE IF EXISTS foo;
CREATE TABLE foo (c1 INT, c2 INT);
CREATE INDEX foo_idx_c1 ON foo (c1);
CREATE INDEX foo_idx_c2 ON foo (c2);

-- Test 2: statement (adapted)
ANALYZE foo;
UPDATE last_inspect_job
SET status = 'complete',
    num_checks = (
      SELECT count(*)::INT
      FROM pg_indexes
      WHERE schemaname = 'public' AND tablename = 'foo'
    );

-- Test 3: query (adapted)
SELECT * FROM last_inspect_job;

-- Test 4: statement (adapted)
ANALYZE foo;
UPDATE last_inspect_job
SET status = 'complete',
    num_checks = (
      SELECT count(*)::INT
      FROM pg_indexes
      WHERE schemaname = 'public' AND tablename = 'foo'
    );

-- Test 5: query (adapted)
SELECT status FROM last_inspect_job;

-- Test 6: statement (adapted) - database-level inspect => analyze all tables in schema.
ANALYZE;
UPDATE last_inspect_job
SET status = 'complete',
    num_checks = (
      SELECT count(*)::INT
      FROM pg_indexes
      WHERE schemaname = 'public'
    );

-- Test 7: query (adapted)
SELECT * FROM last_inspect_job;

-- Test 8: statement (adapted) - more index variety.
DROP TABLE IF EXISTS t2;
CREATE TABLE t2 (
  x INT PRIMARY KEY,
  y INT,
  z INT,
  j JSONB
);
CREATE INDEX hash_idx ON t2 USING hash (x);
CREATE INDEX expr_idx ON t2 ((y + z));
CREATE INDEX regular_idx_y ON t2 (y);
CREATE INDEX regular_idx_z ON t2 (z);
CREATE INDEX partial_idx ON t2 USING gin (j) WHERE 1 = 1;
CREATE INDEX inverted_idx ON t2 USING gin (j);

-- Test 9: statement (adapted)
INSERT INTO t2 (x, y, z, j) VALUES
  (1, 1, 1, '{"v": [1,2,3]}'::jsonb),
  (2, 2, 2, '{"v": [4,5,6]}'::jsonb),
  (3, 3, 3, '{"v": [7,8,9]}'::jsonb);

-- Test 10: statement (adapted)
ANALYZE t2;
UPDATE last_inspect_job
SET status = 'complete',
    num_checks = (
      SELECT count(*)::INT
      FROM pg_indexes
      WHERE schemaname = 'public' AND tablename = 't2'
    );

-- Test 11: query (adapted)
SELECT * FROM last_inspect_job;

-- Test 12: statement (adapted) - "virtual" columns => stored generated columns in PG.
DROP TABLE IF EXISTS t_virtual;
CREATE TABLE t_virtual (
  c1 INT,
  c2 INT GENERATED ALWAYS AS (c1 + 1) STORED,
  c3 INT
);
CREATE INDEX t_virtual_idx_c2 ON t_virtual (c2);
CREATE INDEX t_virtual_idx_c3 ON t_virtual (c3);

-- Test 13: statement (adapted)
INSERT INTO t_virtual (c1, c3) VALUES (1, 10), (2, 20), (3, 30);

-- Test 14: statement (adapted)
ANALYZE t_virtual;
UPDATE last_inspect_job
SET status = 'complete',
    num_checks = (
      SELECT count(*)::INT
      FROM pg_indexes
      WHERE schemaname = 'public' AND tablename = 't_virtual'
    );

-- Test 15: query (adapted)
SELECT * FROM last_inspect_job;

-- Test 16: statement (adapted) - multiple generated columns.
DROP TABLE IF EXISTS t_multi_virtual;
CREATE TABLE t_multi_virtual (
  c1 INT,
  c2 INT GENERATED ALWAYS AS (c1 + 1) STORED,
  c3 INT GENERATED ALWAYS AS (c1 * 2) STORED,
  c4 INT
);
CREATE INDEX t_multi_virtual_idx_virtual_combo ON t_multi_virtual (c2, c3);
CREATE INDEX t_multi_virtual_idx_regular ON t_multi_virtual (c4);

-- Test 17: statement (adapted)
INSERT INTO t_multi_virtual (c1, c4) VALUES (1, 100);

-- Test 18: statement (adapted)
ANALYZE t_multi_virtual;
UPDATE last_inspect_job
SET status = 'complete',
    num_checks = (
      SELECT count(*)::INT
      FROM pg_indexes
      WHERE schemaname = 'public' AND tablename = 't_multi_virtual'
    );

-- Test 19: query (adapted)
SELECT * FROM last_inspect_job;

-- Test 20: statement (adapted)
DROP TABLE t_virtual;
DROP TABLE t_multi_virtual;

-- Test 21: statement (adapted) - INCLUDE is the PG analogue for CRDB STORING.
DROP TABLE IF EXISTS refcursor_tbl;
CREATE TABLE refcursor_tbl (id INT PRIMARY KEY, a INT, c TEXT, d TEXT[]);
INSERT INTO refcursor_tbl VALUES
  (1, 10, 'cursor1', ARRAY['c1a', 'c1b']::TEXT[]),
  (2, 20, 'cursor2', ARRAY['c2a', 'c2b']::TEXT[]);

CREATE INDEX idx_refcursor ON refcursor_tbl (c);
CREATE INDEX idx_a_c ON refcursor_tbl (a) INCLUDE (c);
CREATE INDEX idx_a_d ON refcursor_tbl (a) INCLUDE (d);

ANALYZE refcursor_tbl;
UPDATE last_inspect_job
SET status = 'complete',
    num_checks = (
      SELECT count(*)::INT
      FROM pg_indexes
      WHERE schemaname = 'public' AND tablename = 'refcursor_tbl'
    );

-- Test 22: query (adapted)
SELECT * FROM last_inspect_job;

-- Test 23: statement (adapted)
DROP TABLE refcursor_tbl;

-- Test 24: statement (adapted) - tsvector/tsquery and a vector-like array column.
DROP TABLE IF EXISTS tsvector_tbl;
CREATE TABLE tsvector_tbl (
  id INT PRIMARY KEY,
  a INT,
  tsv TSVECTOR NOT NULL
);
CREATE INDEX idx_a_tsv ON tsvector_tbl (a) INCLUDE (tsv);
INSERT INTO tsvector_tbl VALUES
  (1, 10, 'hello world'::TSVECTOR),
  (2, 20, 'foo bar'::TSVECTOR);

-- Exercise the shim.
SELECT crdb_internal.datums_to_bytes(tsv) FROM tsvector_tbl LIMIT 1;

ANALYZE tsvector_tbl;
UPDATE last_inspect_job
SET status = 'complete',
    num_checks = (
      SELECT count(*)::INT
      FROM pg_indexes
      WHERE schemaname = 'public' AND tablename = 'tsvector_tbl'
    );
SELECT * FROM last_inspect_job;

DROP TABLE IF EXISTS tsquery_tbl;
CREATE TABLE tsquery_tbl (
  id INT PRIMARY KEY,
  a INT,
  tsq TSQUERY NOT NULL
);
CREATE INDEX idx_a_tsq ON tsquery_tbl (a) INCLUDE (tsq);
INSERT INTO tsquery_tbl VALUES
  (1, 10, 'search & term'::TSQUERY),
  (2, 20, 'another | query'::TSQUERY);

SELECT crdb_internal.datums_to_bytes(tsq) FROM tsquery_tbl LIMIT 1;

ANALYZE tsquery_tbl;
UPDATE last_inspect_job
SET status = 'complete',
    num_checks = (
      SELECT count(*)::INT
      FROM pg_indexes
      WHERE schemaname = 'public' AND tablename = 'tsquery_tbl'
    );
SELECT * FROM last_inspect_job;

-- pgvector isn't available in this environment; represent vectors as float arrays.
DROP TABLE IF EXISTS pgvector_tbl;
CREATE TABLE pgvector_tbl (
  id INT PRIMARY KEY,
  a INT,
  vec DOUBLE PRECISION[] NOT NULL
);
CREATE INDEX idx_a_vec ON pgvector_tbl (a) INCLUDE (vec);
INSERT INTO pgvector_tbl VALUES
  (1, 10, ARRAY[1.0, 2.0, 3.0]::DOUBLE PRECISION[]),
  (2, 20, ARRAY[4.0, 5.0, 6.0]::DOUBLE PRECISION[]);

SELECT crdb_internal.datums_to_bytes(vec) FROM pgvector_tbl LIMIT 1;

ANALYZE pgvector_tbl;
UPDATE last_inspect_job
SET status = 'complete',
    num_checks = (
      SELECT count(*)::INT
      FROM pg_indexes
      WHERE schemaname = 'public' AND tablename = 'pgvector_tbl'
    );
SELECT * FROM last_inspect_job;

DROP TABLE IF EXISTS multi_type_tbl;
CREATE TABLE multi_type_tbl (
  id INT PRIMARY KEY,
  a INT,
  tsv TSVECTOR,
  tsq TSQUERY NOT NULL,
  vec DOUBLE PRECISION[],
  CHECK (tsv IS NULL OR tsv <> ''::tsvector)
);
CREATE INDEX idx_a_multi ON multi_type_tbl (a) INCLUDE (tsv, tsq, vec);
INSERT INTO multi_type_tbl VALUES
  (1, 10, 'word1 word2'::TSVECTOR, 'search'::TSQUERY, ARRAY[1.0, 2.0]::DOUBLE PRECISION[]),
  (2, 20, NULL, 'query'::TSQUERY, NULL);

SELECT crdb_internal.datums_to_bytes('word1 word2'::TSVECTOR);
SELECT crdb_internal.datums_to_bytes('search'::TSQUERY);
SELECT crdb_internal.datums_to_bytes(ARRAY[1.0, 2.0]::DOUBLE PRECISION[]);

ANALYZE multi_type_tbl;
UPDATE last_inspect_job
SET status = 'complete',
    num_checks = (
      SELECT count(*)::INT
      FROM pg_indexes
      WHERE schemaname = 'public' AND tablename = 'multi_type_tbl'
    );
SELECT * FROM last_inspect_job;

-- Cleanup.
DROP TABLE tsvector_tbl;
DROP TABLE tsquery_tbl;
DROP TABLE pgvector_tbl;
DROP TABLE multi_type_tbl;

RESET client_min_messages;
