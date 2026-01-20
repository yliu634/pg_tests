-- PostgreSQL compatible tests from distinct_on
-- This file is rewritten to cover DISTINCT ON behavior in PostgreSQL.

SET client_min_messages = warning;

DROP TABLE IF EXISTS t_distinct_on;
CREATE TABLE t_distinct_on (a INT, b INT, c TEXT);
INSERT INTO t_distinct_on (a, b, c) VALUES
  (1, 10, 'x'),
  (1, 20, 'y'),
  (1, 20, 'z'),
  (2, 5, 'p'),
  (2, 7, 'q');

-- Pick the highest b per a.
SELECT DISTINCT ON (a) a, b, c
FROM t_distinct_on
ORDER BY a, b DESC, c;

RESET client_min_messages;
