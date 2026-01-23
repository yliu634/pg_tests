-- PostgreSQL compatible tests from distsql_stats
--
-- NOTE: The upstream CockroachDB logic-test file exercises CockroachDB-only
-- statistics/histogram surfaces (cluster settings, SHOW STATISTICS/HISTOGRAM,
-- injected stats, jobs, etc). PostgreSQL does not expose the same interfaces.
--
-- This PostgreSQL adaptation keeps the intent (validate basic stats + histogram
-- style summaries) using deterministic, SQL-only equivalents.

SET client_min_messages = warning;

-- Deterministic histogram buckets for an orderable column.
CREATE OR REPLACE FUNCTION pg_tests_make_histogram(
  p_table regclass,
  p_col text,
  p_buckets int
)
RETURNS TABLE(bucket int, lower_bound text, upper_bound text, n bigint)
LANGUAGE plpgsql
AS $$
BEGIN
  IF p_buckets <= 0 THEN
    RAISE EXCEPTION 'p_buckets must be > 0';
  END IF;

  RETURN QUERY EXECUTE format(
    'WITH ordered AS (
       SELECT %1$I AS v,
              ntile(%2$s) OVER (ORDER BY %1$I) AS bucket
       FROM %3$s
       WHERE %1$I IS NOT NULL
     )
     SELECT bucket,
            min(v)::text AS lower_bound,
            max(v)::text AS upper_bound,
            count(*)::bigint AS n
     FROM ordered
     GROUP BY bucket
     ORDER BY bucket',
    p_col,
    p_buckets,
    p_table::text
  );
END;
$$;

-- Mixed-type table: use exact aggregates as a deterministic "SHOW STATISTICS"
-- analogue.
CREATE TABLE data (
  a int,
  b int,
  c double precision,
  d numeric,
  e boolean,
  PRIMARY KEY (a, b, c, d)
);
CREATE INDEX c_idx ON data (c, d);

INSERT INTO data (a, b, c, d, e)
SELECT a, b, c::double precision, d::numeric, ((a + b + c + d) % 2 = 0)
FROM generate_series(1, 4) AS a(a),
     generate_series(1, 4) AS b(b),
     generate_series(1, 4) AS c(c),
     generate_series(1, 4) AS d(d);

SELECT 'data' AS table_name, 'a' AS column_name,
       count(*)::bigint AS row_count,
       count(DISTINCT a)::bigint AS distinct_count,
       count(*) FILTER (WHERE a IS NULL)::bigint AS null_count
FROM data
UNION ALL
SELECT 'data', 'b', count(*)::bigint, count(DISTINCT b)::bigint, count(*) FILTER (WHERE b IS NULL)::bigint FROM data
UNION ALL
SELECT 'data', 'c', count(*)::bigint, count(DISTINCT c)::bigint, count(*) FILTER (WHERE c IS NULL)::bigint FROM data
UNION ALL
SELECT 'data', 'd', count(*)::bigint, count(DISTINCT d)::bigint, count(*) FILTER (WHERE d IS NULL)::bigint FROM data
UNION ALL
SELECT 'data', 'e', count(*)::bigint, count(DISTINCT e)::bigint, count(*) FILTER (WHERE e IS NULL)::bigint FROM data
ORDER BY column_name;

-- Histogram bucket counts / bounds for `data.a`.
SELECT count(*) AS buckets FROM pg_tests_make_histogram('data'::regclass, 'a', 2);
SELECT * FROM pg_tests_make_histogram('data'::regclass, 'a', 2);

SELECT count(*) AS buckets FROM pg_tests_make_histogram('data'::regclass, 'a', 3);
SELECT * FROM pg_tests_make_histogram('data'::regclass, 'a', 3);

-- Larger table to exercise bucket sizing on larger N.
CREATE TABLE big (i int PRIMARY KEY);
INSERT INTO big SELECT generate_series(1, 20000);

SELECT count(*) AS buckets FROM pg_tests_make_histogram('big'::regclass, 'i', 10);
SELECT count(*) AS buckets FROM pg_tests_make_histogram('big'::regclass, 'i', 500);

-- "Injected" stats analogue: store deterministic overrides in a table.
CREATE TABLE pg_tests_injected_table_stats (
  table_name text PRIMARY KEY,
  injected_row_count bigint NOT NULL
);

INSERT INTO pg_tests_injected_table_stats(table_name, injected_row_count)
VALUES ('big', 100000);
SELECT table_name, injected_row_count
FROM pg_tests_injected_table_stats
ORDER BY table_name;

UPDATE pg_tests_injected_table_stats
SET injected_row_count = 1000000000
WHERE table_name = 'big';
SELECT table_name, injected_row_count
FROM pg_tests_injected_table_stats
ORDER BY table_name;

RESET client_min_messages;
