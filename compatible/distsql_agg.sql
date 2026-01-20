-- PostgreSQL compatible tests from distsql_agg
-- NOTE: CockroachDB DistSQL is not applicable to PostgreSQL.
-- This file is rewritten to exercise PostgreSQL aggregates.

SET client_min_messages = warning;

DROP TABLE IF EXISTS agg_tbl;
CREATE TABLE agg_tbl (k INT, v INT);
INSERT INTO agg_tbl (k, v) VALUES
  (1, 10), (1, 20), (2, 5), (2, NULL), (3, 7);

SELECT count(*) AS total_rows, count(v) AS nonnull_v, sum(v) AS sum_v, avg(v) AS avg_v
FROM agg_tbl;

SELECT k, count(*) AS n, sum(v) AS sum_v
FROM agg_tbl
GROUP BY k
ORDER BY k;

EXPLAIN (COSTS OFF)
SELECT k, sum(v) FROM agg_tbl GROUP BY k;

RESET client_min_messages;
