-- PostgreSQL compatible tests from inverted_join_multi_column
--
-- CockroachDB supports inverted joins with multi-column inverted indexes. In
-- PostgreSQL we use a multi-column GIN index (btree_gin + JSONB) and a regular
-- join predicate on JSONB containment.

SET client_min_messages = warning;

CREATE EXTENSION IF NOT EXISTS btree_gin;

DROP TABLE IF EXISTS inv_j1;
DROP TABLE IF EXISTS inv_j2;

CREATE TABLE inv_j1 (
  k INT PRIMARY KEY,
  j JSONB
);

CREATE TABLE inv_j2 (
  i INT,
  s TEXT,
  j JSONB
);

CREATE INDEX inv_j2_idx ON inv_j2 USING GIN (i, s, j);

INSERT INTO inv_j1 VALUES
  (1, '{"a": 1}'::jsonb),
  (2, '{"b": 2}'::jsonb),
  (3, '{"a": 1, "b": 2}'::jsonb);

INSERT INTO inv_j2 VALUES
  (10, 'foo', '{"a": 1, "b": 2}'::jsonb),
  (10, 'bar', '{"a": 1}'::jsonb),
  (20, 'foo', '{"b": 2}'::jsonb),
  (30, 'baz', '{"a": 1, "b": 2, "c": 3}'::jsonb);

SELECT j1.k, j2.i, j2.s
FROM inv_j1 AS j1
JOIN inv_j2 AS j2 ON j2.j @> j1.j
WHERE j2.i IN (10, 20)
  AND j2.s IN ('foo', 'bar')
ORDER BY 1, 2, 3;

DROP TABLE inv_j2;
DROP TABLE inv_j1;

RESET client_min_messages;
