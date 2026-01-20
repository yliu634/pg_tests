-- PostgreSQL compatible tests from constrained_stats
-- NOTE: CockroachDB constrained stats + crdb_internal are not available in PostgreSQL.
-- This file is rewritten to validate PostgreSQL statistics on a table with a partial index.

SET client_min_messages = warning;

DROP TABLE IF EXISTS partial_indexes;

CREATE TABLE partial_indexes (
  a INT,
  b INT,
  c INT
);

INSERT INTO partial_indexes (a, b, c)
SELECT gs, gs % 5, gs % 3
FROM generate_series(1, 50) AS gs;

DROP INDEX IF EXISTS partial_indexes_a_partial;
CREATE INDEX partial_indexes_a_partial ON partial_indexes (a) WHERE b > 0;

ANALYZE partial_indexes;

-- Basic pg_stats visibility.
SELECT tablename, attname, null_frac, n_distinct
FROM pg_stats
WHERE schemaname = current_schema()
  AND tablename = 'partial_indexes'
ORDER BY attname;

-- Show the partial-index predicate and columns.
SELECT
  c.relname AS index_name,
  pg_get_indexdef(i.indexrelid) AS index_def,
  pg_get_expr(i.indpred, i.indrelid) AS index_predicate
FROM pg_index AS i
JOIN pg_class AS c ON c.oid = i.indexrelid
JOIN pg_class AS t ON t.oid = i.indrelid
JOIN pg_namespace AS n ON n.oid = t.relnamespace
WHERE n.nspname = current_schema()
  AND t.relname = 'partial_indexes'
ORDER BY index_name;

RESET client_min_messages;
