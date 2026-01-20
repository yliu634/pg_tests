-- PostgreSQL compatible tests from json_builtins
--
-- The original CockroachDB logic test contains many CRDB-only extensions.
-- This file keeps a deterministic subset of PostgreSQL JSON/JSONB builtins.

SET client_min_messages = warning;

SELECT json_typeof('{"a": 1}'::json) AS json_type,
       jsonb_typeof('{"a": 1}'::jsonb) AS jsonb_type;

SELECT to_json(ARRAY[1, 2, 3]) AS j_array,
       to_jsonb(ARRAY['a', 'b']) AS jb_array;

SELECT json_build_object('a', 1, 'b', 'x') AS obj,
       jsonb_build_array(1, 'x', true) AS arr;

SELECT key, value
FROM json_each_text('{"a": "b", "c": "d"}'::json)
ORDER BY key;

RESET client_min_messages;
