-- PostgreSQL compatible tests from distinct
-- This file is rewritten to cover DISTINCT behavior in PostgreSQL.

SET client_min_messages = warning;

DROP TABLE IF EXISTS t_distinct;
CREATE TABLE t_distinct (a INT, b INT);
INSERT INTO t_distinct (a, b) VALUES (1, 10), (1, 10), (1, 20), (2, 10), (2, 10);

SELECT DISTINCT a FROM t_distinct ORDER BY a;
SELECT DISTINCT a, b FROM t_distinct ORDER BY a, b;

RESET client_min_messages;
