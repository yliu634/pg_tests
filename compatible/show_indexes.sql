-- PostgreSQL compatible tests from show_indexes
-- 4 tests

SET client_min_messages = warning;

DROP TABLE IF EXISTS t1 CASCADE;
DROP TABLE IF EXISTS t2 CASCADE;

-- Test 1: statement (line 1)
CREATE TABLE t1 (
  a INT,
  b INT,
  c INT,
  d INT,
  PRIMARY KEY (a, b)
);

CREATE INDEX c_idx ON t1 (c ASC);
CREATE UNIQUE INDEX d_b_idx ON t1 (d ASC, b ASC);
CREATE INDEX expr_idx ON t1 ((a+b), c);

-- Test 2: query (line 13)
WITH idx AS (
  SELECT
    i.indexrelid,
    c.relname AS index_name,
    i.indisprimary,
    i.indisunique,
    i.indnatts
  FROM pg_index i
  JOIN pg_class c ON c.oid = i.indexrelid
  WHERE i.indrelid = 't1'::regclass
),
cols AS (
  SELECT
    idx.index_name,
    s.n AS seq_in_index,
    pg_get_indexdef(idx.indexrelid, s.n, true) AS column_name,
    idx.indisprimary AS is_primary,
    idx.indisunique AS is_unique
  FROM idx
  JOIN generate_series(1, idx.indnatts) AS s(n) ON true
)
SELECT *
FROM cols
ORDER BY index_name, seq_in_index;

-- Test 3: statement (line 32)
CREATE TABLE t2 (
  a INT,
  b INT,
  c INT,
  d INT,
  e INT,
  PRIMARY KEY (c, b, a)
);

CREATE INDEX a_e_c_idx ON t2 (a ASC, e ASC, c ASC);
CREATE UNIQUE INDEX b_d_idx ON t2 (b ASC, d ASC);
CREATE UNIQUE INDEX c_e_d_a_idx ON t2 (c ASC, e ASC, d ASC, a ASC);
CREATE INDEX d_idx ON t2 (d ASC);

-- Test 4: query (line 46)
WITH idx AS (
  SELECT
    i.indexrelid,
    c.relname AS index_name,
    i.indisprimary,
    i.indisunique,
    i.indnatts
  FROM pg_index i
  JOIN pg_class c ON c.oid = i.indexrelid
  WHERE i.indrelid = 't2'::regclass
),
cols AS (
  SELECT
    idx.index_name,
    s.n AS seq_in_index,
    pg_get_indexdef(idx.indexrelid, s.n, true) AS column_name,
    idx.indisprimary AS is_primary,
    idx.indisunique AS is_unique
  FROM idx
  JOIN generate_series(1, idx.indnatts) AS s(n) ON true
)
SELECT *
FROM cols
ORDER BY index_name, seq_in_index;

RESET client_min_messages;
