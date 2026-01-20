-- PostgreSQL compatible tests from inv_stats
--
-- CockroachDB uses INVERTED INDEX and SHOW HISTOGRAM. PostgreSQL uses GIN/GiST
-- indexes and catalog views for statistics.

SET client_min_messages = warning;

CREATE EXTENSION IF NOT EXISTS postgis;

DROP STATISTICS IF EXISTS inv_stats_s;
DROP TABLE IF EXISTS inv_stats_t;

CREATE TABLE inv_stats_t (
  j JSONB,
  g geometry
);

INSERT INTO inv_stats_t(j, g) VALUES
  ('{"test": "some", "other": {"nested": true, "foo": 3}}'::jsonb,
   ST_GeomFromText('POLYGON((0 0,0 1,1 1,1 0,0 0))', 4326)),
  ('{"test": "other"}'::jsonb,
   ST_GeomFromText('POINT(1 1)', 4326));

CREATE INDEX inv_stats_t_j_gin ON inv_stats_t USING GIN (j);
CREATE INDEX inv_stats_t_g_gist ON inv_stats_t USING GIST (g);

CREATE STATISTICS inv_stats_s (ndistinct) ON (j->>'test'), (j->>'other') FROM inv_stats_t;
ANALYZE inv_stats_t;

SELECT stxname, stxkind
FROM pg_statistic_ext
WHERE stxname = 'inv_stats_s';

SELECT indexname, indexdef
FROM pg_indexes
WHERE schemaname = 'public' AND tablename = 'inv_stats_t'
ORDER BY indexname;

-- Cleanup.
DROP STATISTICS inv_stats_s;
DROP TABLE inv_stats_t;

RESET client_min_messages;
