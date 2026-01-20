-- PostgreSQL compatible tests from generic
--
-- CockroachDB's original test file focused on generic vs custom plans for
-- prepared statements. PostgreSQL supports this via `plan_cache_mode`, so this
-- adapted test exercises PREPARE/EXECUTE with deterministic output.

SET client_min_messages = warning;
DROP TABLE IF EXISTS generic_t;
DROP TABLE IF EXISTS generic_c;
DROP TABLE IF EXISTS generic_g;
RESET client_min_messages;

CREATE TABLE generic_t (
  k int PRIMARY KEY,
  a int NOT NULL,
  b int NOT NULL,
  c int NOT NULL,
  s text NOT NULL
);

CREATE INDEX generic_t_abc_idx ON generic_t(a, b, c);
CREATE INDEX generic_t_s_idx ON generic_t(s);

INSERT INTO generic_t VALUES
  (1, 1, 2, 3, 'foo'),
  (2, 10, 20, 30, 'foobar'),
  (3, 33, 44, 55, 'bar');

CREATE TABLE generic_c (
  k int PRIMARY KEY,
  a int NOT NULL
);
CREATE INDEX generic_c_a_idx ON generic_c(a);

CREATE TABLE generic_g (
  k int PRIMARY KEY,
  a int NOT NULL,
  b int NOT NULL
);
CREATE INDEX generic_g_ab_idx ON generic_g(a, b);

INSERT INTO generic_c VALUES (1, 1), (2, 10), (3, 33);
INSERT INTO generic_g VALUES (1, 1, 2), (2, 10, 20), (3, 33, 44);

-- Parameterized statement.
PREPARE p_abc (int, int, int) AS
  SELECT k FROM generic_t WHERE a = $1 AND b = $2 AND c = $3 ORDER BY k;

SET plan_cache_mode = force_generic_plan;
EXPLAIN (COSTS false) EXECUTE p_abc(1, 2, 3);

SET plan_cache_mode = force_custom_plan;
EXPLAIN (COSTS false) EXECUTE p_abc(1, 2, 3);

SET plan_cache_mode = auto;
DEALLOCATE p_abc;

-- Join statement with parameters.
PREPARE p_join (int, int) AS
  SELECT t.k, c.k AS c_k, g.k AS g_k
  FROM generic_t t
  JOIN generic_c c ON t.k = c.a
  JOIN generic_g g ON c.k = g.a
  WHERE t.a = $1 AND t.c = $2
  ORDER BY 1, 2, 3;

EXPLAIN (COSTS false) EXECUTE p_join(1, 3);
EXECUTE p_join(1, 3);
DEALLOCATE p_join;

SET client_min_messages = warning;
DROP TABLE generic_t;
DROP TABLE generic_c;
DROP TABLE generic_g;
RESET client_min_messages;

