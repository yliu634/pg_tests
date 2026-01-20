-- PostgreSQL compatible tests from distsql_automatic_partial_stats
-- NOTE: CockroachDB automatic partial stats + DistSQL are not applicable to PostgreSQL.
-- This file is rewritten to run ANALYZE and query pg_stats.

SET client_min_messages = warning;

DROP TABLE IF EXISTS aps_tbl;
CREATE TABLE aps_tbl (a INT, b INT);
INSERT INTO aps_tbl (a, b)
SELECT gs, gs % 4 FROM generate_series(1, 100) AS gs;

DROP INDEX IF EXISTS aps_tbl_a_partial;
CREATE INDEX aps_tbl_a_partial ON aps_tbl (a) WHERE b = 1;

ANALYZE aps_tbl;

SELECT tablename, attname, n_distinct, most_common_vals
FROM pg_stats
WHERE schemaname = current_schema()
  AND tablename = 'aps_tbl'
ORDER BY attname;

RESET client_min_messages;
