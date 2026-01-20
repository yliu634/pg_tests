-- PostgreSQL compatible tests from subquery
-- Reduced subset: CRDB logic-test directives and CRDB-only features removed.

SET client_min_messages = warning;
DROP TABLE IF EXISTS abc CASCADE;
DROP TABLE IF EXISTS xyz CASCADE;
RESET client_min_messages;

CREATE TABLE abc (a INT, b INT, c INT);
INSERT INTO abc VALUES
  (1, 10, 100),
  (2, 20, 200),
  (3, 30, 300);

-- Scalar subquery.
SELECT (SELECT 1) AS one;

-- IN (subquery).
SELECT 1 IN (SELECT a FROM abc) AS in_abc;

-- Row comparison with a subquery.
SELECT (1, 10) = (SELECT a, b FROM abc WHERE a = 1) AS row_eq;

-- EXISTS.
SELECT EXISTS (SELECT 1 FROM abc WHERE a = 2) AS exists_a2;

-- ANY with a subquery.
SELECT 2 = ANY (SELECT a FROM abc) AS any_a2;

-- Correlated subquery (deterministic ordering).
SELECT
  a,
  (SELECT max(b) FROM abc x WHERE x.a <= abc.a) AS max_b_le_a
FROM abc
ORDER BY a;

CREATE TABLE xyz (x INT PRIMARY KEY, y INT);

INSERT INTO xyz(x, y)
SELECT a, b
FROM abc
WHERE a IN (SELECT a FROM abc WHERE a >= 2);

SELECT * FROM xyz ORDER BY x;

UPDATE xyz
SET y = (SELECT b FROM abc WHERE abc.a = xyz.x)
WHERE x = 3;

SELECT * FROM xyz ORDER BY x;
