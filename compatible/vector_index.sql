-- PostgreSQL compatible tests from vector_index
-- Aggressively adapted from CockroachDB vector index tests.
--
-- Notes:
-- - CockroachDB `VECTOR` and `VECTOR INDEX` syntax is not supported by PostgreSQL.
-- - The `pgvector` extension is not available in this environment, so this file
--   is a minimal, runnable stub that still exercises index creation and queries
--   over an array-backed "vector" representation.

CREATE TABLE simple (
  a INT PRIMARY KEY,
  vec REAL[] NOT NULL
);

INSERT INTO simple (a, vec) VALUES
  (1, ARRAY[1.0, 0.0, 0.0]::REAL[]),
  (2, ARRAY[0.0, 1.0, 0.0]::REAL[]),
  (3, ARRAY[1.0, 1.0, 0.0]::REAL[]),
  (4, ARRAY[0.5, 0.5, 0.5]::REAL[]);

-- Array containment can be indexed with GIN.
CREATE INDEX simple_vec_gin_idx ON simple USING gin (vec);

-- Expression index over the first component.
CREATE INDEX simple_vec1_idx ON simple ((vec[1]));

SELECT a, vec FROM simple ORDER BY a;

-- Contains element 1.0
SELECT a FROM simple WHERE vec @> ARRAY[1.0]::REAL[] ORDER BY a;

-- First component equals 1.0
SELECT a FROM simple WHERE vec[1] = 1.0 ORDER BY a;
