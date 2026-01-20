-- PostgreSQL compatible tests from expression_index
--
-- CockroachDB supports INVERTED/VECTOR indexes and other features not present
-- in PostgreSQL. This file exercises PostgreSQL expression indexes.

SET client_min_messages = warning;
DROP TABLE IF EXISTS expr_idx_t;
RESET client_min_messages;

CREATE TABLE expr_idx_t (
  id INT PRIMARY KEY,
  a INT,
  b INT,
  c TEXT,
  j JSONB
);

INSERT INTO expr_idx_t VALUES
  (1, 1, 10, 'Hello', '{"k":"v1"}'),
  (2, 2, 20, 'hello', '{"k":"v2"}'),
  (3, 3, 30, 'world', '{"k":"v3"}');

CREATE INDEX expr_idx_sum_idx ON expr_idx_t ((a + b));
CREATE INDEX expr_idx_lower_c_idx ON expr_idx_t ((lower(c)));
CREATE INDEX expr_idx_json_k_idx ON expr_idx_t (((j->>'k')));

SELECT indexname, indexdef
FROM pg_indexes
WHERE schemaname = 'public' AND tablename = 'expr_idx_t'
ORDER BY indexname;

SELECT id FROM expr_idx_t WHERE a + b = 22 ORDER BY id;
SELECT id FROM expr_idx_t WHERE lower(c) = 'hello' ORDER BY id;
SELECT id FROM expr_idx_t WHERE j->>'k' = 'v2' ORDER BY id;

