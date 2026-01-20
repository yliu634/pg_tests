-- PostgreSQL compatible tests from inverted_join_json_array
--
-- CockroachDB has INVERTED JOIN syntax; PostgreSQL uses standard joins with
-- JSONB/array containment operators backed by GIN indexes.

SET client_min_messages = warning;

DROP TABLE IF EXISTS json_tab;
DROP TABLE IF EXISTS array_tab;

CREATE TABLE json_tab (
  a INT PRIMARY KEY,
  b JSONB
);
CREATE INDEX json_tab_b_gin ON json_tab USING GIN (b);

INSERT INTO json_tab VALUES
  (1, '{"a": 1, "b": 2}'::jsonb),
  (2, '{"a": 1}'::jsonb),
  (3, '{"b": 2}'::jsonb),
  (4, '{"a": 1, "b": 2, "c": 3}'::jsonb);

SELECT j1.a AS a1, j2.a AS a2
FROM json_tab j1
JOIN json_tab j2 ON j1.b @> j2.b
ORDER BY 1, 2;

SELECT j1.a AS a1, j2.a AS a2
FROM json_tab j1
JOIN json_tab j2 ON j1.b <@ j2.b
ORDER BY 1, 2;

CREATE TABLE array_tab (
  a INT PRIMARY KEY,
  b INT[]
);
CREATE INDEX array_tab_b_gin ON array_tab USING GIN (b);

INSERT INTO array_tab VALUES
  (1, ARRAY[1,2,3]),
  (2, ARRAY[1]),
  (3, ARRAY[2,3]),
  (4, ARRAY[]::int[]);

SELECT t1.a AS a1, t2.a AS a2
FROM array_tab t1
JOIN array_tab t2 ON t1.b @> t2.b
ORDER BY 1, 2;

DROP TABLE array_tab;
DROP TABLE json_tab;

RESET client_min_messages;
