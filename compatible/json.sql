-- PostgreSQL compatible tests from json
--
-- The original CockroachDB logic test contains many CRDB-only constructs.
-- This file keeps a deterministic subset of JSON/JSONB behavior on PostgreSQL.

SET client_min_messages = warning;

DROP TABLE IF EXISTS json_t;

SELECT '1'::JSONB, '2'::JSON;
SELECT pg_typeof(JSON '1');
SELECT pg_typeof(JSONB '1');

CREATE TABLE json_t (
  id INT PRIMARY KEY,
  j JSONB
);

INSERT INTO json_t VALUES
  (1, '{"a": "b", "c": 1}'::jsonb),
  (2, '{"a": "x", "c": 2}'::jsonb),
  (3, '{"c": 3}'::jsonb);

CREATE INDEX json_t_j_gin ON json_t USING GIN (j);

SELECT id, j->>'a' AS a
FROM json_t
ORDER BY id;

SELECT id
FROM json_t
WHERE j ? 'a'
ORDER BY id;

SELECT id
FROM json_t
WHERE j @> '{"a": "b"}'::jsonb
ORDER BY id;

DROP TABLE json_t;

RESET client_min_messages;
