-- PostgreSQL compatible tests from json_index
--
-- CockroachDB's JSON inverted index maps to PostgreSQL GIN indexes on JSONB.

SET client_min_messages = warning;

DROP TABLE IF EXISTS json_idx_t;

CREATE TABLE json_idx_t (
  id INT PRIMARY KEY,
  j JSONB
);

CREATE INDEX json_idx_t_j_gin ON json_idx_t USING GIN (j);

INSERT INTO json_idx_t VALUES
  (1, '{"a": 1, "b": 2}'::jsonb),
  (2, '{"a": 2, "b": 3}'::jsonb),
  (3, '{"a": 1, "c": {"d": 4}}'::jsonb);

SELECT id
FROM json_idx_t
WHERE j @> '{"a": 1}'::jsonb
ORDER BY id;

SELECT id
FROM json_idx_t
WHERE j @> '{"c": {"d": 4}}'::jsonb
ORDER BY id;

SELECT indexname
FROM pg_indexes
WHERE schemaname = 'public' AND tablename = 'json_idx_t'
ORDER BY indexname;

DROP TABLE json_idx_t;

RESET client_min_messages;
