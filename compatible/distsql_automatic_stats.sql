-- PostgreSQL compatible tests from distsql_automatic_stats
-- NOTE: CockroachDB automatic stats + DistSQL are not applicable to PostgreSQL.
-- This file is rewritten to run ANALYZE and inspect pg_stats.

SET client_min_messages = warning;

DROP TABLE IF EXISTS as_tbl;
CREATE TABLE as_tbl (a INT, b TEXT);
INSERT INTO as_tbl (a, b)
SELECT gs, CASE WHEN gs % 2 = 0 THEN 'even' ELSE 'odd' END
FROM generate_series(1, 50) AS gs;

ANALYZE as_tbl;

SELECT tablename, attname, n_distinct
FROM pg_stats
WHERE schemaname = current_schema()
  AND tablename = 'as_tbl'
ORDER BY attname;

RESET client_min_messages;
