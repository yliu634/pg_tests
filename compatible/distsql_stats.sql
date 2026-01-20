-- PostgreSQL compatible tests from distsql_stats
-- NOTE: CockroachDB DistSQL statistics tables are not available in PostgreSQL.
-- This file is rewritten to run ANALYZE and inspect pg_stats.

SET client_min_messages = warning;

DROP TABLE IF EXISTS stats_tbl;
CREATE TABLE stats_tbl (a INT, b INT);
INSERT INTO stats_tbl (a, b)
SELECT gs, gs % 10 FROM generate_series(1, 200) AS gs;

ANALYZE stats_tbl;

SELECT attname, n_distinct, most_common_freqs
FROM pg_stats
WHERE schemaname = current_schema()
  AND tablename = 'stats_tbl'
ORDER BY attname;

EXPLAIN (COSTS OFF)
SELECT * FROM stats_tbl WHERE a = 42;

RESET client_min_messages;
