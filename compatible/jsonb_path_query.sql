-- PostgreSQL compatible tests from jsonb_path_query
--
-- The original CockroachDB logic test is very large and includes strict-mode
-- error cases. This file keeps a deterministic subset of jsonb_path_query()
-- behavior on PostgreSQL.

SET client_min_messages = warning;

DROP TABLE IF EXISTS json_path_t;

CREATE TABLE json_path_t (data JSONB);
INSERT INTO json_path_t VALUES
  ('{"a": {"aa": {"aaa": "s1", "aab": 123, "aaf": [1, 2, 3]}}, "c": [{"ca": "s5"}, {"ca": "s6"}, 1, true], "d": 123.45}'::jsonb);

SELECT jsonb_path_query(data, '$') FROM json_path_t;
SELECT jsonb_path_query(data, '$.a.aa.aaa') FROM json_path_t;
SELECT jsonb_path_query(data, '$.a.aa.aab') FROM json_path_t;
SELECT jsonb_path_query(data, '$.c[*].ca') FROM json_path_t;

SELECT q
FROM json_path_t, LATERAL jsonb_path_query(data, '$.a.aa.aaf[*]') AS q
ORDER BY q::text;

DROP TABLE json_path_t;

RESET client_min_messages;
