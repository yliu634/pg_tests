-- PostgreSQL compatible tests from save_table
--
-- CockroachDB has a `save_tables_prefix` debugging feature that materializes
-- intermediate results for query plans. PostgreSQL does not provide an
-- equivalent. This reduced version creates two tables and runs a couple of
-- joins deterministically.

SET client_min_messages = warning;

DROP TABLE IF EXISTS t;
DROP TABLE IF EXISTS u;

CREATE TABLE t (k INT PRIMARY KEY, str TEXT);
CREATE TABLE u (key INT PRIMARY KEY, val TEXT);

INSERT INTO t SELECT i, 't_' || i::text FROM generate_series(1, 5) AS g(i);
INSERT INTO u SELECT i, 'u_' || i::text FROM generate_series(2, 10) AS g(i);

SELECT * FROM t ORDER BY k;
SELECT * FROM u ORDER BY key;

SELECT u.key, t.str
  FROM t
  JOIN u ON t.k = u.key
 WHERE t.k >= 3
 ORDER BY u.key;

SELECT u.key, t.str
  FROM t
  JOIN u ON t.k = u.key
 WHERE u.val LIKE 'u_%'
 ORDER BY u.key;

DROP TABLE t;
DROP TABLE u;

RESET client_min_messages;
