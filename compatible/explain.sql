-- PostgreSQL compatible tests from explain
--
-- CockroachDB has EXPLAIN (DISTSQL), table hints (t@[...]), and [EXPLAIN ...]
-- result tables that do not exist in PostgreSQL. This file exercises EXPLAIN
-- with a few representative queries.

SET client_min_messages = warning;
DROP TABLE IF EXISTS t;
DROP TABLE IF EXISTS t88037;
RESET client_min_messages;

CREATE TABLE t (a INT PRIMARY KEY);
INSERT INTO t VALUES (1), (2), (3);

-- Window aggregate.
EXPLAIN (COSTS false) SELECT avg(a) OVER () FROM t;

-- Window frame with a constant offset (PG does not allow subqueries as frame offsets).
EXPLAIN (COSTS false)
SELECT avg(a) OVER (ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) FROM t;

CREATE TABLE t88037 AS
SELECT g, (g % 2 = 1) AS _bool, ('0.0.0.0'::INET + g) AS _inet
FROM generate_series(1, 5) AS g;

EXPLAIN (COSTS false)
SELECT NULL AS col_1372
FROM t88037 AS tab_489
WHERE tab_489._bool
ORDER BY tab_489._inet, tab_489._bool ASC
LIMIT 92;

