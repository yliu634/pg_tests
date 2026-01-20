SET client_min_messages = warning;

-- PostgreSQL compatible tests from ordinality
-- 18 tests
--
-- CockroachDB supports WITH ORDINALITY on more FROM sources than PostgreSQL.
-- In PostgreSQL, similar results can be obtained with row_number().

-- Test 1: query (line 1)
SELECT name, row_number() OVER () AS i
FROM (VALUES ('a'), ('b')) AS x(name);

-- Test 2: query (line 8)
SELECT row_number() OVER () AS ordinality
FROM (VALUES ('a'), ('b')) AS x(name);

-- Test 3: statement (line 15)
DROP TABLE IF EXISTS foo CASCADE;
CREATE TABLE foo (x CHAR PRIMARY KEY);
INSERT INTO foo(x) VALUES ('a'), ('b');

-- Test 4: query (line 18)
SELECT x, row_number() OVER (ORDER BY x) AS ordinality
FROM foo
ORDER BY x;

-- Test 5: query (line 24)
SELECT x, ordinality
FROM (
  SELECT x, row_number() OVER (ORDER BY x) AS ordinality
  FROM foo
) AS s
ORDER BY x
LIMIT 1;

-- Test 6: query (line 29)
SELECT max(ordinality)
FROM (
  SELECT row_number() OVER (ORDER BY x) AS ordinality
  FROM foo
) AS s;

-- Test 7: query (line 34)
WITH a AS (
  SELECT x, row_number() OVER (ORDER BY x) AS ordinality FROM foo
),
b AS (
  SELECT x, row_number() OVER (ORDER BY x) AS ordinality FROM foo
)
SELECT * FROM a, b;

-- Test 8: query (line 42)
SELECT y, row_number() OVER (ORDER BY y) AS ordinality
FROM (SELECT x||x AS y FROM foo) AS s
ORDER BY y;

-- Test 9: query (line 48)
WITH a AS (
  SELECT x, row_number() OVER (ORDER BY x) AS ordinality FROM foo
),
b AS (
  SELECT x, row_number() OVER (ORDER BY x) AS ordinality FROM foo
)
SELECT a.x, a.ordinality * 2 AS ord2, b.ordinality AS ord_b
FROM a
JOIN b USING (x)
ORDER BY a.x;

-- Test 10: query (line 54)
SELECT x, ordinality
FROM (
  SELECT x, row_number() OVER (ORDER BY x DESC) AS ordinality
  FROM foo
) AS s
ORDER BY x DESC
LIMIT 1;

-- Test 11: query (line 59)
SELECT x, ordinality
FROM (
  SELECT x, row_number() OVER (ORDER BY x) AS ordinality
  FROM foo
) AS s
ORDER BY x DESC
LIMIT 1;

-- Test 12: query (line 64)
SELECT x, ordinality
FROM (
  SELECT x, row_number() OVER (ORDER BY x) AS ordinality
  FROM foo
) AS s
ORDER BY ordinality DESC
LIMIT 1;

-- Test 13: statement (line 69)
INSERT INTO foo(x) VALUES ('c');

-- Test 14: query (line 72)
SELECT x, ordinality
FROM (
  SELECT x, row_number() OVER (ORDER BY x) AS ordinality
  FROM foo
) AS s
WHERE x > 'a'
ORDER BY x;

-- Test 15: query (line 78)
SELECT x, ordinality
FROM (
  SELECT x, row_number() OVER (ORDER BY x) AS ordinality
  FROM foo
) AS s
WHERE ordinality > 1
ORDER BY ordinality DESC;

-- Test 16: query (line 84)
SELECT x, row_number() OVER (ORDER BY x) AS ordinality
FROM foo
WHERE x > 'a'
ORDER BY x;

-- Test 17: query (line 90)
SELECT ordinality = row_number() OVER (ORDER BY x) AS matches
FROM (
  SELECT x, row_number() OVER (ORDER BY x) AS ordinality
  FROM foo
) AS s
ORDER BY x;

-- Test 18: query (line 102)
SELECT x, row_number() OVER (ORDER BY x) AS ordinality
FROM (SELECT * FROM foo ORDER BY x LIMIT 1) AS s;

RESET client_min_messages;

