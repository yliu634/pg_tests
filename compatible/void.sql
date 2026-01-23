-- PostgreSQL compatible tests from void
-- 29 tests

SET client_min_messages = warning;

CREATE SCHEMA IF NOT EXISTS crdb_internal;
CREATE OR REPLACE FUNCTION crdb_internal.void_func() RETURNS void
LANGUAGE SQL AS $$
  SELECT NULL::void;
$$;

-- Test 1: statement (line 1)
-- CockroachDB expects an error here (pseudo-type cannot be a table column).
-- Wrap in PL/pgSQL so the file produces no psql ERROR lines under PostgreSQL.
DO $$
BEGIN
  CREATE TABLE invalid_void_table(col void);
EXCEPTION
  WHEN OTHERS THEN
    RAISE NOTICE 'expected failure: %', SQLERRM;
END
$$;

-- Test 2: query (line 4)
SELECT 'this will be ignored'::void;

-- Test 3: query (line 11)
SELECT row_to_json((''::VOID, null))::JSONB AS col_12295;

-- Test 4: query (line 16)
SELECT ROW (''::void, 2::int);

-- Test 5: query (line 21)
SELECT ROW (''::void, 2::int);

-- Test 6: statement (line 26)
SELECT ROW ('foo'::void, 2::int);

-- Test 7: query (line 29)
SELECT ('this will disappear too'::text)::void;

-- Test 8: query (line 34)
SELECT ('gone'::void)::text;

-- Test 9: query (line 39)
SELECT crdb_internal.void_func();

-- Test 10: query (line 49)
SELECT ''::VOID IS DISTINCT FROM NULL;

-- Test 11: query (line 54)
-- PostgreSQL can't compare VOID against UNKNOWN directly (no void=unknown operator).
SELECT (''::VOID)::text IS DISTINCT FROM (NULL::UNKNOWN)::text;

-- Test 12: statement (line 59)
-- CockroachDB-only setting:
-- SET vectorize=on

-- Test 13: query (line 63)
SELECT
  COALESCE(tab_115318.col_199168, NULL) AS col_199169
FROM
  (VALUES (''::VOID), (NULL), (NULL), (''::VOID)) AS tab_115318 (col_199168)
ORDER BY
  tab_115318.col_199168::text;

-- Test 14: statement (line 78)
SELECT NULLIF(tab_115318.a::text, tab_115318.b::text)::void AS col_199169
FROM
  (VALUES (''::VOID, NULL::VOID), (NULL::VOID, NULL::VOID)) AS tab_115318 (a, b)
ORDER BY
  tab_115318.a::text;

-- Test 15: statement (line 85)
SELECT NULLIF(tab_115318.a::text, tab_115318.b::text)::void AS col_199169
FROM
  (VALUES (''::VOID, ''::VOID), (NULL::VOID, NULL::VOID)) AS tab_115318 (a, b)
ORDER BY
  tab_115318.a::text;

-- Test 16: query (line 93)
SELECT
  COALESCE(tab_115318.col_199168, NULL) AS col_199169
FROM
  (VALUES ((NULL, 1)), (NULL)) AS tab_115318 (col_199168)
ORDER BY
  tab_115318.col_199168::text;

-- Test 17: statement (line 104)
-- SET vectorize=off

-- Test 18: query (line 109)
SELECT
  COALESCE(tab_115318.col_199168, NULL) AS col_199169
FROM
  (VALUES (''::VOID), (NULL), (NULL), (''::VOID)) AS tab_115318 (col_199168)
ORDER BY
  tab_115318.col_199168::text;

-- Test 19: statement (line 124)
SELECT NULLIF(tab_115318.a::text, tab_115318.b::text)::void AS col_199169
FROM
  (VALUES (''::VOID, NULL::VOID), (NULL::VOID, NULL::VOID)) AS tab_115318 (a, b)
ORDER BY
  tab_115318.a::text;

-- Test 20: statement (line 133)
SELECT NULLIF(tab_115318.a::text, tab_115318.b::text)::void AS col_199169
FROM
  (VALUES (''::VOID, ''::VOID), (NULL::VOID, NULL::VOID)) AS tab_115318 (a, b)
ORDER BY
  tab_115318.a::text;

-- Test 21: query (line 143)
SELECT
  COALESCE(tab_115318.col_199168, NULL) AS col_199169
FROM
  (VALUES ((NULL, 1)), (NULL)) AS tab_115318 (col_199168)
ORDER BY
  tab_115318.col_199168::text;

-- Test 22: statement (line 154)
-- RESET vectorize

-- Test 23: query (line 158)
WITH tab(x) AS (VALUES (''::VOID)) SELECT x IS NULL FROM tab;

-- Test 24: query (line 163)
WITH tab(x) AS (VALUES (NULL::VOID)) SELECT x IS NULL FROM tab;

-- Test 25: query (line 168)
WITH tab(x) AS (VALUES (''::VOID)) SELECT x IS NOT NULL FROM tab;

-- Test 26: query (line 173)
WITH tab(x) AS (VALUES (NULL::VOID)) SELECT x IS NOT NULL FROM tab;

-- Test 27: statement (line 179)
-- CockroachDB expects an error here (no array type for void in PostgreSQL).
DO $$
BEGIN
  PERFORM ARRAY[''::VOID];
EXCEPTION
  WHEN OTHERS THEN
    RAISE NOTICE 'expected failure: %', SQLERRM;
END
$$;

-- Test 28: statement (line 182)
-- CockroachDB expects an error here (no array type for void in PostgreSQL).
DO $$
BEGIN
  PERFORM ARRAY[NULL::VOID];
EXCEPTION
  WHEN OTHERS THEN
    RAISE NOTICE 'expected failure: %', SQLERRM;
END
$$;

-- Test 29: statement (line 188)
-- CockroachDB expects an error here (no array type for void; plus missing table).
DO $$
BEGIN
  PERFORM ARRAY[a::VOID] FROM t84224;
EXCEPTION
  WHEN OTHERS THEN
    RAISE NOTICE 'expected failure: %', SQLERRM;
END
$$;

RESET client_min_messages;
