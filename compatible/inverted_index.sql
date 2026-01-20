-- PostgreSQL compatible tests from inverted_index
--
-- CockroachDB's INVERTED INDEX maps most closely to PostgreSQL GIN indexes for
-- JSONB and array data.

SET client_min_messages = warning;

DROP TABLE IF EXISTS inv_idx_t;

CREATE TABLE inv_idx_t (
  id INT PRIMARY KEY,
  j JSONB,
  arr INT[]
);

CREATE INDEX inv_idx_t_j_gin ON inv_idx_t USING GIN (j);
CREATE INDEX inv_idx_t_arr_gin ON inv_idx_t USING GIN (arr);

INSERT INTO inv_idx_t VALUES
  (1, '{"a": 1, "b": 2}'::jsonb, ARRAY[1,2,3]),
  (2, '{"a": 2, "b": 3}'::jsonb, ARRAY[2,3]),
  (3, '[1,2,3]'::jsonb, ARRAY[3,4]);

SELECT id
FROM inv_idx_t
WHERE j @> '{"a": 1}'::jsonb
ORDER BY id;

SELECT id
FROM inv_idx_t
WHERE j ? 'b'
ORDER BY id;

SELECT id
FROM inv_idx_t
WHERE arr @> ARRAY[2]
ORDER BY id;

SELECT indexname
FROM pg_indexes
WHERE schemaname = 'public' AND tablename = 'inv_idx_t'
ORDER BY indexname;

DROP TABLE inv_idx_t;

RESET client_min_messages;
