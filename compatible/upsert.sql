-- PostgreSQL-compatible tests adapted from CockroachDB's upsert logic tests.
--
-- NOTE: CockroachDB's `UPSERT` is not standard SQL. PostgreSQL uses
-- `INSERT ... ON CONFLICT ... DO UPDATE`.
--
-- This file is aggressively simplified to a minimal, runnable set of UPSERT
-- behaviors that translate cleanly to PostgreSQL.

-- Basic UPSERT on primary key.
CREATE TABLE kv (
  k INT PRIMARY KEY,
  v INT
);

INSERT INTO kv(k, v) VALUES (1, 1), (2, 2);

-- UPSERT updating an existing row.
INSERT INTO kv(k, v) VALUES (1, 10)
ON CONFLICT (k) DO UPDATE SET v = EXCLUDED.v;

-- UPSERT inserting a new row.
INSERT INTO kv(k, v) VALUES (3, 3)
ON CONFLICT (k) DO UPDATE SET v = EXCLUDED.v;

SELECT * FROM kv ORDER BY k;

-- Multi-row UPSERT (mix insert + update) with an expression using the current row.
INSERT INTO kv(k, v) VALUES (2, 20), (4, 4)
ON CONFLICT (k) DO UPDATE SET v = kv.v + EXCLUDED.v;

SELECT * FROM kv ORDER BY k;

-- UPSERT with RETURNING; use a CTE for deterministic ordering.
WITH up AS (
  INSERT INTO kv(k, v) VALUES (1, 111), (5, 5)
  ON CONFLICT (k) DO UPDATE SET v = EXCLUDED.v
  RETURNING k, v
)
SELECT * FROM up ORDER BY k;

-- UPSERT using a UNIQUE constraint as the conflict target.
CREATE TABLE by_unique (
  id INT PRIMARY KEY,
  u INT UNIQUE,
  v INT
);

INSERT INTO by_unique VALUES (1, 10, 100);

INSERT INTO by_unique VALUES (2, 10, 200)
ON CONFLICT (u) DO UPDATE SET v = EXCLUDED.v;

SELECT * FROM by_unique ORDER BY id;

-- UPSERT using a composite UNIQUE constraint as the conflict target.
CREATE TABLE by_unique_comp (
  id INT PRIMARY KEY,
  a INT,
  b INT,
  v INT,
  UNIQUE (a, b)
);

INSERT INTO by_unique_comp VALUES (1, 1, 2, 100);

INSERT INTO by_unique_comp VALUES (2, 1, 2, 200)
ON CONFLICT (a, b) DO UPDATE SET v = EXCLUDED.v;

SELECT * FROM by_unique_comp ORDER BY id;
