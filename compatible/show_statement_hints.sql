-- PostgreSQL compatible tests from show_statement_hints
-- 45 tests

SET client_min_messages = warning;

-- CockroachDB statement hints and `SHOW STATEMENT HINTS` don't exist in
-- PostgreSQL. Provide a minimal emulation that is stable for expected-output
-- generation.
CREATE SCHEMA IF NOT EXISTS system;
CREATE SCHEMA IF NOT EXISTS crdb_internal;

DROP TABLE IF EXISTS system.statement_hints;
CREATE TABLE system.statement_hints (
  row_id BIGSERIAL PRIMARY KEY,
  fingerprint TEXT NOT NULL,
  hint_type TEXT NOT NULL,
  details TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT TIMESTAMPTZ '2000-01-01 00:00:00+00'
);

CREATE OR REPLACE FUNCTION public.pg_normalize_sql(sql TEXT)
RETURNS TEXT
LANGUAGE sql
IMMUTABLE
AS $$
  WITH s AS (
    SELECT lower(trim(sql)) AS v
  ),
  no_semicolon AS (
    SELECT regexp_replace(v, E';\\s*$', '', 'g') AS v FROM s
  ),
  squashed_ws AS (
    SELECT regexp_replace(v, E'\\s+', ' ', 'g') AS v FROM no_semicolon
  ),
  normalize_alias AS (
    -- Normalize optional AS in table aliases: FROM t AS a == FROM t a.
    SELECT regexp_replace(
             regexp_replace(v, E'(\\bfrom\\s+\\S+)\\s+as\\s+(\\w+)', E'\\1 \\2', 'g'),
             E'(\\bjoin\\s+\\S+)\\s+as\\s+(\\w+)', E'\\1 \\2', 'g'
           ) AS v
    FROM squashed_ws
  ),
  placeholders AS (
    SELECT regexp_replace(v, E'\\$[0-9]+', '_', 'g') AS v FROM normalize_alias
  ),
  numbers AS (
    SELECT regexp_replace(v, E'\\b[0-9]+\\b', '_', 'g') AS v FROM placeholders
  )
  SELECT v FROM numbers;
$$;

CREATE OR REPLACE FUNCTION crdb_internal.inject_hint(original_sql TEXT, hinted_sql TEXT)
RETURNS BOOL
LANGUAGE plpgsql
AS $$
BEGIN
  INSERT INTO system.statement_hints(fingerprint, hint_type, details)
  VALUES (public.pg_normalize_sql(original_sql), 'hint', hinted_sql);
  RETURN true;
END
$$;

CREATE OR REPLACE FUNCTION public.pg_show_statement_hints_for(query TEXT, with_details BOOL DEFAULT false)
RETURNS TABLE (fingerprint TEXT, hint_type TEXT, details TEXT, created_at TIMESTAMPTZ, row_id BIGINT)
LANGUAGE sql
STABLE
AS $$
  SELECT
    h.fingerprint,
    h.hint_type,
    CASE WHEN with_details THEN h.details ELSE NULL END AS details,
    h.created_at,
    h.row_id
  FROM system.statement_hints AS h
  WHERE h.fingerprint = public.pg_normalize_sql(query)
  ORDER BY h.created_at DESC, h.row_id DESC;
$$;

-- Cleanup from prior runs in this database.
DROP TABLE IF EXISTS xy;
DROP TABLE IF EXISTS ab;
DROP TABLE IF EXISTS queries;
DEALLOCATE ALL;

-- Test 1: statement (line 4)
CREATE TABLE xy (x INT PRIMARY KEY, y INT);
CREATE INDEX xy_y_idx ON xy (y);

-- Test 2: statement (line 7)
CREATE TABLE ab (a INT PRIMARY KEY, b INT);
CREATE INDEX ab_b_idx ON ab (b);

-- Test 3: statement (line 11)
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'testuser2') THEN
    CREATE ROLE testuser2 LOGIN;
  END IF;
END
$$;

-- Test 4: statement (line 17)
SELECT * FROM public.pg_show_statement_hints_for('SELECT * FROM xy WHERE y = 10');

-- Test 5: statement (line 20)
SELECT * FROM public.pg_show_statement_hints_for('SELECT * FROM xy WHERE y = 10', true);

-- user root

-- Test 6: statement (line 25)
-- CockroachDB-only: GRANT SYSTEM VIEWCLUSTERMETADATA TO testuser2;

-- Test 7: query (line 31)
SELECT * FROM public.pg_show_statement_hints_for('SELECT * FROM xy WHERE y = 10');

-- Test 8: query (line 36)
SELECT * FROM public.pg_show_statement_hints_for('SELECT * FROM xy WHERE y = 10', true);

-- Test 9: query (line 44)
SELECT * FROM public.pg_show_statement_hints_for('SELECT * FROM xy WHERE y = 10');

-- Test 10: query (line 49)
SELECT * FROM public.pg_show_statement_hints_for('SELECT * FROM xy WHERE y = 10', true);

-- Test 11: statement (line 54)
SELECT crdb_internal.inject_hint(
  'SELECT * FROM xy WHERE y = _',
  'SELECT * FROM xy@xy_y_idx WHERE y = _'
);

-- Test 12: query (line 62)
SELECT fingerprint, hint_type
FROM public.pg_show_statement_hints_for('SELECT * FROM xy WHERE y = 10');

-- Test 13: query (line 70)
SELECT fingerprint, hint_type, details
FROM public.pg_show_statement_hints_for('SELECT * FROM xy WHERE y = 10', true);

-- Test 14: query (line 78)
SELECT fingerprint, hint_type, details
FROM public.pg_show_statement_hints_for('SELECT * FROM xy WHERE y = $1', true);

-- Test 15: statement (line 85)
SELECT crdb_internal.inject_hint(
  'WITH cte AS (SELECT * FROM xy WHERE y = _) SELECT * FROM cte',
  'WITH cte AS (SELECT * FROM xy@xy_y_idx WHERE y = _) SELECT * FROM cte'
);

-- Test 16: query (line 91)
SELECT fingerprint, hint_type, details
FROM public.pg_show_statement_hints_for('WITH cte AS (SELECT * FROM xy WHERE y = 10) SELECT * FROM cte', true)
ORDER BY created_at DESC, row_id DESC;

-- Test 17: query (line 100)
SELECT * FROM public.pg_show_statement_hints_for('SELECT * FROM nonexistent WHERE x = 1');

-- Test 18: statement (line 105)
SELECT crdb_internal.inject_hint(
  'SELECT * FROM xy WHERE y = _',
  'SELECT * FROM xy@primary WHERE y = _'
);

-- Test 19: query (line 111)
SELECT count(*)
FROM public.pg_show_statement_hints_for('SELECT * FROM xy WHERE y = 10');

-- Test 20: query (line 116)
SELECT fingerprint, hint_type
FROM public.pg_show_statement_hints_for('SELECT * FROM xy WHERE y = 10')
ORDER BY created_at DESC, row_id DESC;

-- Test 21: query (line 124)
SELECT fingerprint, hint_type, details
FROM public.pg_show_statement_hints_for('SELECT * FROM xy WHERE y = 10', true)
ORDER BY created_at DESC, row_id DESC;

-- Test 22: query (line 134)
SELECT (
  SELECT count(*)
  FROM public.pg_show_statement_hints_for('SELECT * FROM xy WHERE y = 10')
);

-- Test 23: query (line 140)
SELECT * FROM public.pg_show_statement_hints_for('EXPLAIN SELECT * FROM xy WHERE y = 10');

-- Test 24: query (line 145)
SELECT * FROM public.pg_show_statement_hints_for('EXPLAIN ANALYZE SELECT * FROM xy WHERE y = 10');

-- Test 25: query (line 150)
SELECT * FROM public.pg_show_statement_hints_for('COPY (SELECT * FROM xy WHERE y = 10) TO STDOUT CSV');

-- Test 26: query (line 155)
SELECT * FROM public.pg_show_statement_hints_for('PREPARE p AS SELECT * FROM xy WHERE y = $1');

-- Test 27: statement (line 160)
PREPARE p AS SELECT * FROM xy WHERE y = $1;

-- Test 28: query (line 164)
SELECT * FROM public.pg_show_statement_hints_for('EXECUTE p');

-- Test 29: statement (line 171)
SELECT crdb_internal.inject_hint(
  'CREATE INDEX ON xy (y)',
  'CREATE INDEX ON xy (y)'
);

-- Test 30: query (line 177)
SELECT fingerprint, hint_type
FROM public.pg_show_statement_hints_for('CREATE INDEX ON xy (y)')
ORDER BY created_at DESC, row_id DESC;

-- Test 31: statement (line 186)
SELECT crdb_internal.inject_hint(
  'SELECT * FROM ab WHERE a = _',
  'SELECT * FROM ab@primary WHERE a = _'
);

-- Test 32: query (line 192)
SELECT fingerprint, hint_type
FROM public.pg_show_statement_hints_for('SELECT * FROM ab WHERE a = 1;')
ORDER BY created_at DESC, row_id DESC;

-- Test 33: query (line 201)
SELECT fingerprint, hint_type
FROM public.pg_show_statement_hints_for($$ SELECT * FROM ab WHERE a = 1; $$)
ORDER BY created_at DESC, row_id DESC;

-- Test 34: statement (line 210)
PREPARE show_hints_stmt(TEXT) AS
SELECT fingerprint, hint_type
FROM public.pg_show_statement_hints_for($1)
ORDER BY created_at DESC, row_id DESC;

-- Test 35: query (line 214)
EXECUTE show_hints_stmt('SELECT * FROM ab WHERE a = 1');

-- Test 36: query (line 221)
SELECT fingerprint, hint_type
FROM public.pg_show_statement_hints_for('select * from ab where a = 1')
ORDER BY created_at DESC, row_id DESC;

-- Test 37: query (line 230)
SELECT fingerprint, hint_type
FROM public.pg_show_statement_hints_for('SeLeCt * FrOm ab WhErE a = 1')
ORDER BY created_at DESC, row_id DESC;

-- Test 38: query (line 239)
SELECT fingerprint, hint_type
FROM public.pg_show_statement_hints_for('  SELECT   *   FROM   ab   WHERE   a   =   1  ')
ORDER BY created_at DESC, row_id DESC;

-- Test 39: statement (line 248)
SELECT crdb_internal.inject_hint(
  'SELECT * FROM ab AS t WHERE t.a = _',
  'SELECT * FROM ab@primary t WHERE t.a = _'
);

-- Test 40: query (line 255)
SELECT fingerprint, hint_type
FROM public.pg_show_statement_hints_for('SELECT * FROM ab AS t WHERE t.a = 1')
ORDER BY created_at DESC, row_id DESC;

-- Test 41: query (line 264)
SELECT fingerprint, hint_type
FROM public.pg_show_statement_hints_for('SELECT * FROM ab t WHERE t.a = 1')
ORDER BY created_at DESC, row_id DESC;

-- Test 42: statement (line 277)
CREATE TEMP TABLE queries(q TEXT);
INSERT INTO queries(q) VALUES ('SELECT * FROM ab WHERE a = 1');

SELECT fingerprint, hint_type
FROM queries, LATERAL (SELECT * FROM public.pg_show_statement_hints_for(q)) AS hints
ORDER BY created_at DESC, row_id DESC;

-- Test 43: statement (line 283)
SELECT fingerprint, hint_type
FROM queries, LATERAL (
  WITH foo AS MATERIALIZED (SELECT * FROM public.pg_show_statement_hints_for(q))
  SELECT * FROM foo
) AS hints
ORDER BY created_at DESC, row_id DESC;

-- Test 44: statement (line 289)
SELECT fingerprint, hint_type
FROM public.pg_show_statement_hints_for(upper('select * from ab where a = 1'))
ORDER BY created_at DESC, row_id DESC;

-- Test 45: statement (line 295)
SELECT fingerprint, hint_type
FROM public.pg_show_statement_hints_for('SELECT * FROM ' || 'ab WHERE a = 1')
ORDER BY created_at DESC, row_id DESC;

RESET client_min_messages;
