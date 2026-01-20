-- PostgreSQL compatible tests from inverted_index_multi_column
--
-- CockroachDB supports multi-column INVERTED INDEX. PostgreSQL can approximate
-- this with a multi-column GIN index using the btree_gin extension for scalar
-- columns.

SET client_min_messages = warning;

CREATE EXTENSION IF NOT EXISTS btree_gin;

DROP TABLE IF EXISTS inv_mc_t;

CREATE TABLE inv_mc_t (
  i INT PRIMARY KEY,
  s TEXT,
  j JSONB
);

CREATE INDEX inv_mc_idx ON inv_mc_t USING GIN (i, s, j);

INSERT INTO inv_mc_t VALUES
  (1, 'foo', '{"x": "y", "num": 1}'::jsonb),
  (2, 'bar', '{"x": "y", "num": 2}'::jsonb),
  (3, 'baz', '{"x": "y", "num": 3}'::jsonb);

SELECT i, s
FROM inv_mc_t
WHERE i IN (1, 2, 3) AND s = 'foo' AND j @> '{"x": "y"}'::jsonb
ORDER BY i;

UPDATE inv_mc_t SET j = '{"x": "y", "num": 10}'::jsonb WHERE i = 1;

SELECT i, s
FROM inv_mc_t
WHERE i IN (1, 2, 3) AND s IN ('foo', 'bar') AND j @> '{"num": 10}'::jsonb
ORDER BY i;

DELETE FROM inv_mc_t WHERE i = 3;

INSERT INTO inv_mc_t(i, s, j) VALUES (3, 'bar', '{"x": "y", "num": 4}'::jsonb)
ON CONFLICT (i) DO UPDATE SET s = EXCLUDED.s, j = EXCLUDED.j;

SELECT i, s
FROM inv_mc_t
WHERE i IN (1, 2, 3) AND s = 'bar' AND j @> '{"x": "y"}'::jsonb
ORDER BY i;

DROP TABLE inv_mc_t;

RESET client_min_messages;
