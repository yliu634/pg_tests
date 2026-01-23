-- PostgreSQL compatible tests from inverted_join_json_array
-- 60 tests

SET client_min_messages = warning;

-- Test 1: statement (line 3)
CREATE TABLE json_tab (
  a INT PRIMARY KEY,
  b JSONB
);

-- Test 2: statement (line 9)
CREATE INDEX json_tab_b_gin ON json_tab USING GIN (b);

-- Test 3: statement (line 12)
CREATE TABLE array_tab (
  a INT PRIMARY KEY,
  b INT[]
);

-- Test 4: statement (line 18)
CREATE INDEX array_tab_b_gin ON array_tab USING GIN (b);

-- Test 5: statement (line 21)
INSERT INTO json_tab VALUES
  (1, '{"a": "b"}'),
  (2, '[1,2,3,4, "foo"]'),
  (3, '{"a": {"b": "c"}}'),
  (4, '{"a": {"b": [1]}}'),
  (5, '{"a": {"b": [1, [2]]}}'),
  (6, '{"a": {"b": [[2]]}}'),
  (7, '{"a": "b", "c": "d"}'),
  (8, '{"a": {"b":true}}'),
  (9, '{"a": {"b":false}}'),
  (10, '"a"'),
  (11, 'null'),
  (12, 'true'),
  (13, 'false'),
  (14, '1'),
  (15, '1.23'),
  (16, '[{"a": {"b": [1, [2]]}}, "d"]'),
  (17, '{}'),
  (18, '[]'),
  (19, '["a", "a"]'),
  (20, '[{"a": "a"}, {"a": "a"}]'),
  (21, '[[[["a"]]], [[["a"]]]]'),
  (22, '[1,2,3,1]'),
  (23, '{"a": 123.123}'),
  (24, '{"a": 123.123000}'),
  (25, '{"a": [{}]}'),
  (26, '[[], {}]'),
  (27, '[true, false, null, 1.23, "a"]'),
  (28, '{"a": {}}'),
  (29, NULL),
  (30, '{"a": []}'),
  (31, '{"a": {"b": "c", "d": "e"}, "f": "g"}'),
  (32, '{"a": [1]}'),
  (33, '[1, "bar"]'),
  (34, '{"a": 1}'),
  (35, '[1]'),
  (36, '[2]'),
  (37, '[[1]]'),
  (38, '[[2]]'),
  (39, '["a"]'),
  (40, '{"a": [[]]}'),
  (41, '[[1, 2]]'),
  (42, '[[1], [2]]'),
  (43, '[{"a": "b", "c": "d"}]'),
  (44, '[{"a": "b"}, {"c": "d"}]'),
  (45, '{"a": "a"}'),
  (46, '{"a": "c"}');

-- Test 6: query (line 71)
SELECT * FROM json_tab AS j1, json_tab AS j2 WHERE j1.b @> j2.b ORDER BY j1.a, j2.a;

-- Test 7: query (line 201)
SELECT * FROM json_tab AS j1 CROSS JOIN json_tab AS j2 WHERE j1.b @> j2.b ORDER BY j1.a, j2.a;

-- Test 8: query (line 332)
SELECT * FROM
(SELECT j1.a, j2.a FROM json_tab AS j1, json_tab AS j2 WHERE j1.b @> j2.b) AS inv_join(a1, a2)
FULL OUTER JOIN
(SELECT j1.a, j2.a FROM json_tab AS j1, json_tab AS j2 WHERE j1.b @> j2.b) AS cross_join(a1, a2)
ON inv_join.a1 = cross_join.a1 AND inv_join.a2 = cross_join.a2
WHERE inv_join.a1 IS NULL OR cross_join.a1 IS NULL;

-- Test 9: query (line 342)
SELECT * FROM json_tab AS j1, json_tab AS j2 WHERE j1.b <@ j2.b ORDER BY j1.a, j2.a;

-- Test 10: query (line 472)
SELECT * FROM json_tab AS j1 CROSS JOIN json_tab AS j2 WHERE j1.b <@ j2.b ORDER BY j1.a, j2.a;

-- Test 11: query (line 603)
SELECT * FROM
(SELECT j1.a, j2.a FROM json_tab AS j1, json_tab AS j2 WHERE j1.b <@ j2.b) AS inv_join(a1, a2)
FULL OUTER JOIN
(SELECT j1.a, j2.a FROM json_tab AS j1, json_tab AS j2 WHERE j1.b <@ j2.b) AS cross_join(a1, a2)
ON inv_join.a1 = cross_join.a1 AND inv_join.a2 = cross_join.a2
WHERE inv_join.a1 IS NULL OR cross_join.a1 IS NULL;

-- Test 12: query (line 613)
SELECT j1.*, j2.* FROM json_tab AS j2 JOIN json_tab AS j1
ON j1.b @> j2.b AND j1.b @> '{"a": {}}' AND j2.a < 20
ORDER BY j1.a, j2.a;

-- Test 13: query (line 637)
SELECT * FROM json_tab AS j1 CROSS JOIN json_tab AS j2
WHERE j1.b @> j2.b AND j1.b @> '{"a": {}}' AND j2.a < 20
ORDER BY j1.a, j2.a;

-- Test 14: query (line 662)
SELECT * FROM
(
  SELECT j1.a, j2.a FROM json_tab AS j2 JOIN json_tab AS j1
  ON j1.b @> j2.b AND j1.b @> '{"a": {}}' AND j2.a < 20
) AS inv_join(a1, a2)
FULL OUTER JOIN
(
  SELECT j1.a, j2.a FROM json_tab AS j1, json_tab AS j2
  WHERE j1.b @> j2.b AND j1.b @> '{"a": {}}' AND j2.a < 20
) AS cross_join(a1, a2)
ON inv_join.a1 = cross_join.a1 AND inv_join.a2 = cross_join.a2
WHERE inv_join.a1 IS NULL OR cross_join.a1 IS NULL;

-- Test 15: query (line 678)
SELECT j1.*, j2.* FROM json_tab AS j2 JOIN json_tab AS j1
ON j1.b <@ j2.b AND j1.b <@ '{"a": {}}' AND j2.a < 20
ORDER BY j1.a, j2.a;

-- Test 16: query (line 700)
SELECT * FROM json_tab AS j1 CROSS JOIN json_tab AS j2
WHERE j1.b <@ j2.b AND j1.b <@ '{"a": {}}' AND j2.a < 20
ORDER BY j1.a, j2.a;

-- Test 17: query (line 723)
SELECT * FROM
(
  SELECT j1.a, j2.a FROM json_tab AS j2 JOIN json_tab AS j1
  ON j1.b <@ j2.b AND j1.b <@ '{"a": {}}' AND j2.a < 20
) AS inv_join(a1, a2)
FULL OUTER JOIN
(
  SELECT j1.a, j2.a FROM json_tab AS j1, json_tab AS j2
  WHERE j1.b <@ j2.b AND j1.b <@ '{"a": {}}' AND j2.a < 20
) AS cross_join(a1, a2)
ON inv_join.a1 = cross_join.a1 AND inv_join.a2 = cross_join.a2
WHERE inv_join.a1 IS NULL OR cross_join.a1 IS NULL;

-- Test 18: query (line 739)
SELECT j1.*, j2.* FROM json_tab AS j2 LEFT JOIN json_tab AS j1
ON j1.b @> j2.b AND j1.b @> '{"a": {}}' AND j2.a < 20
ORDER BY j1.a, j2.a;

-- Test 19: query (line 802)
SELECT j1.*, j2.* FROM json_tab AS j2 LEFT JOIN json_tab AS j1
ON j1.b <@ j2.b AND j1.b <@ '{"a": {}}' AND j2.a < 20
ORDER BY j1.a, j2.a;

-- Test 20: query (line 861)
SELECT * FROM json_tab AS j2 WHERE EXISTS (
  SELECT * FROM json_tab AS j1
  WHERE j1.b @> j2.b AND j2.a < 20
)
ORDER BY j2.a;

-- Test 21: query (line 889)
SELECT * FROM json_tab AS j2 WHERE EXISTS (
  SELECT * FROM json_tab AS j1
  WHERE j1.b <@ j2.b AND j2.a < 20
)
ORDER BY j2.a;

-- Test 22: query (line 917)
SELECT * FROM json_tab AS j2 WHERE NOT EXISTS (
  SELECT * FROM json_tab AS j1
  WHERE j1.b @> j2.b AND j2.a < 20
)
ORDER BY j2.a;

-- Test 23: query (line 953)
SELECT * FROM json_tab AS j2 WHERE NOT EXISTS (
  SELECT * FROM json_tab AS j1
  WHERE j1.b <@ j2.b AND j2.a < 20
)
ORDER BY j2.a;

-- Test 24: statement (line 988)
INSERT INTO array_tab VALUES
  (1, '{}'),
  (2, '{1}'),
  (3, '{2}'),
  (4, '{1, 2}'),
  (5, '{1, 3}'),
  (6, '{1, 2, 3, 4}'),
  (7, ARRAY[NULL]::INT[]),
  (8, NULL);

-- Test 25: query (line 1000)
SELECT * FROM array_tab AS a1, array_tab AS a2 WHERE a1.b @> a2.b ORDER BY a1.a, a2.a;

-- Test 26: query (line 1026)
SELECT * FROM array_tab AS a2
JOIN array_tab AS a1
ON a1.b && a2.b AND a2.a > 1 AND a2.a < 7
ORDER BY a1.a, a2.a;

-- Test 27: statement (line 1054)
CREATE TABLE array_tab_not_idx (
  a INT PRIMARY KEY,
  b INT[]
);

-- Test 28: statement (line 1060)
INSERT INTO array_tab_not_idx VALUES
  (1, '{}'),
  (2, '{1}'),
  (3, '{2}'),
  (4, '{1, 2}'),
  (5, '{1, 3}'),
  (6, '{1, 2, 5}'),
  (7, ARRAY[NULL]::INT[]),
  (8, NULL);

-- Test 29: query (line 1073)
SELECT * FROM array_tab_not_idx AS a2
JOIN array_tab AS a1
ON a2.b && a1.b AND a2.a > 1 AND a2.a < 7
ORDER BY a1.a, a2.a;

-- Test 30: statement (line 1105)
SELECT * FROM array_tab AS a2
JOIN array_tab AS a1
ON a1.b && a2.b
ORDER BY a1.a, a2.a;

-- Test 31: query (line 1112)
SELECT * FROM array_tab AS a1 CROSS JOIN array_tab AS a2 WHERE a1.b @> a2.b ORDER BY a1.a, a2.a;

-- Test 32: query (line 1137)
SELECT * FROM
(SELECT a1.a, a2.a FROM array_tab AS a1, array_tab AS a2 WHERE a1.b @> a2.b) AS inv_join(a1, a2)
FULL OUTER JOIN
(SELECT a1.a, a2.a FROM array_tab AS a1, array_tab AS a2 WHERE a1.b @> a2.b) AS cross_join(a1, a2)
ON inv_join.a1 = cross_join.a1 AND inv_join.a2 = cross_join.a2
WHERE inv_join.a1 IS NULL OR cross_join.a1 IS NULL;

-- Test 33: query (line 1147)
SELECT * FROM array_tab AS a1, array_tab AS a2 WHERE a1.b <@ a2.b ORDER BY a1.a, a2.a;

-- Test 34: query (line 1171)
SELECT * FROM array_tab AS a1 CROSS JOIN array_tab AS a2 WHERE a1.b <@ a2.b ORDER BY a1.a, a2.a;

-- Test 35: query (line 1196)
SELECT * FROM
(SELECT a1.a, a2.a FROM array_tab AS a1, array_tab AS a2 WHERE a1.b <@ a2.b) AS inv_join(a1, a2)
FULL OUTER JOIN
(SELECT a1.a, a2.a FROM array_tab AS a1, array_tab AS a2 WHERE a1.b <@ a2.b) AS cross_join(a1, a2)
ON inv_join.a1 = cross_join.a1 AND inv_join.a2 = cross_join.a2
WHERE inv_join.a1 IS NULL OR cross_join.a1 IS NULL;

-- Test 36: query (line 1206)
SELECT a1.*, a2.* FROM array_tab AS a2
JOIN array_tab AS a1
ON a1.b @> a2.b AND a1.b @> '{1}' AND a2.a < 5
ORDER BY a1.a, a2.a;

-- Test 37: query (line 1226)
SELECT * FROM array_tab AS a1 CROSS JOIN array_tab AS a2
WHERE a1.b @> a2.b AND a1.b @> '{1}' AND a2.a < 5
ORDER BY a1.a, a2.a;

-- Test 38: query (line 1246)
SELECT * FROM
(
  SELECT a1.a, a2.a FROM array_tab AS a2
  JOIN array_tab AS a1
  ON a1.b @> a2.b AND a1.b @> '{1}' AND a2.a < 5
) AS inv_join(a1, a2)
FULL OUTER JOIN
(
  SELECT a1.a, a2.a FROM array_tab AS a1, array_tab AS a2
  WHERE a1.b @> a2.b AND a1.b @> '{1}' AND a2.a < 5
) AS cross_join(a1, a2)
ON inv_join.a1 = cross_join.a1 AND inv_join.a2 = cross_join.a2
WHERE inv_join.a1 IS NULL OR cross_join.a1 IS NULL;

-- Test 39: query (line 1263)
SELECT a1.*, a2.* FROM array_tab AS a2
JOIN array_tab AS a1
ON a1.b <@ a2.b AND a1.b <@ '{1}' AND a2.a < 5
ORDER BY a1.a, a2.a;

-- Test 40: query (line 1277)
SELECT * FROM array_tab AS a1 CROSS JOIN array_tab AS a2
WHERE a1.b <@ a2.b AND a1.b <@ '{1}' AND a2.a < 5
ORDER BY a1.a, a2.a;

-- Test 41: query (line 1291)
SELECT * FROM
(
  SELECT a1.a, a2.a FROM array_tab AS a2
  JOIN array_tab AS a1
  ON a1.b <@ a2.b AND a1.b <@ '{1}' AND a2.a < 5
) AS inv_join(a1, a2)
FULL OUTER JOIN
(
  SELECT a1.a, a2.a FROM array_tab AS a1, array_tab AS a2
  WHERE a1.b <@ a2.b AND a1.b <@ '{1}' AND a2.a < 5
) AS cross_join(a1, a2)
ON inv_join.a1 = cross_join.a1 AND inv_join.a2 = cross_join.a2
WHERE inv_join.a1 IS NULL OR cross_join.a1 IS NULL;

-- Test 42: query (line 1308)
SELECT a1.*, a2.* FROM array_tab AS a2
LEFT JOIN array_tab AS a1
ON a1.b @> a2.b AND a1.b @> '{1}' AND a2.a < 5
ORDER BY a1.a, a2.a;

-- Test 43: query (line 1332)
SELECT a1.*, a2.* FROM array_tab AS a2
LEFT JOIN array_tab AS a1
ON a1.b <@ a2.b AND a1.b <@ '{1}' AND a2.a < 5
ORDER BY a1.a, a2.a;

-- Test 44: query (line 1350)
SELECT a2.* FROM array_tab AS a2 WHERE EXISTS (
  SELECT * FROM array_tab AS a1
  WHERE a1.b @> a2.b
)
ORDER BY a2.a;

-- Test 45: query (line 1365)
SELECT a2.* FROM array_tab AS a2 WHERE EXISTS (
  SELECT * FROM array_tab AS a1
  WHERE a1.b <@ a2.b
)
ORDER BY a2.a;

-- Test 46: query (line 1381)
SELECT a2.* FROM array_tab AS a2 WHERE NOT EXISTS (
  SELECT * FROM array_tab AS a1
  WHERE a1.b @> a2.b
)
ORDER BY a2.a;

-- Test 47: query (line 1392)
SELECT a2.* FROM array_tab AS a2 WHERE NOT EXISTS (
  SELECT * FROM array_tab AS a1
  WHERE a1.b <@ a2.b
)
ORDER BY a2.a;

-- Test 48: statement (line 1401)
CREATE TABLE j1 (
  k INT PRIMARY KEY,
  j JSONB
);

-- Test 49: statement (line 1407)
INSERT INTO j1 VALUES (1, '{"a": "b"}');

-- Test 50: statement (line 1410)
CREATE TABLE j2 (
  k INT PRIMARY KEY,
  j JSONB
);

-- Test 51: statement (line 1417)
INSERT INTO j2 VALUES (1, '{"a": "b"}');

-- Test 52: query (line 1422)
SELECT j1.*, j2.*
FROM j1 LEFT JOIN j2
  ON j2.j @> j1.j AND j2.j = '"foo"'
ORDER BY j1.k, j2.k;

-- Test 53: query (line 1430)
SELECT * FROM json_tab AS j2 JOIN json_tab AS j1
ON j1.b ? (j2.b ->> 'a') ORDER BY j1.a, j2.a;

-- Test 54: query (line 1459)
SELECT * FROM json_tab AS j2 JOIN json_tab AS j1
ON j1.b @> j2.b AND j1.b ? (j2.b ->> 'a') ORDER BY j1.a, j2.a;

-- Test 55: statement (line 1465)
CREATE TABLE text_array_tab (
  a INT PRIMARY KEY,
  b TEXT[]
);

-- Test 56: statement (line 1471)
INSERT INTO text_array_tab VALUES
  (1, '{}'),
  (2, '{a}'),
  (3, '{a, b}'),
  (4, '{a, c}'),
  (5, '{a, b, c}'),
  (6, '{1}'),
  (7, NULL);

-- Test 57: statement (line 1482)
SELECT * FROM json_tab AS j JOIN text_array_tab AS t
ON j.b ?| t.b ORDER BY t.a, j.a;

-- Test 58: query (line 1486)
SELECT * FROM text_array_tab AS t JOIN json_tab AS j
ON j.b ?| t.b ORDER BY t.a, j.a;

-- Test 59: statement (line 1584)
SELECT * FROM json_tab AS j JOIN text_array_tab AS t
ON j.b ?& t.b ORDER BY j.a;

-- Test 60: query (line 1588)
SELECT * FROM text_array_tab AS t JOIN json_tab AS j
ON j.b ?& t.b ORDER BY j.a;


RESET client_min_messages;
