-- PostgreSQL compatible tests from void
-- 29 tests

-- Test 1: statement (line 1)
CREATE TABLE invalid_void_table(col void)

-- Test 2: query (line 4)
SELECT 'this will be ignored'::void

-- Test 3: query (line 11)
SELECT row_to_json((''::VOID, null))::JSONB AS col_12295

-- Test 4: query (line 16)
select row (''::void, 2::int)

-- Test 5: query (line 21)
select row ('':::void, 2::int)

-- Test 6: statement (line 26)
select row ('foo':::void, 2::int)

-- Test 7: query (line 29)
SELECT ('this will disappear too'::text)::void

-- Test 8: query (line 34)
SELECT ('gone'::void)::text

-- Test 9: query (line 39)
SELECT crdb_internal.void_func()

-- Test 10: query (line 49)
SELECT ''::VOID IS DISTINCT FROM NULL

-- Test 11: query (line 54)
SELECT ''::VOID IS DISTINCT FROM NULL::UNKNOWN

-- Test 12: statement (line 59)
SET vectorize=on

-- Test 13: query (line 63)
SELECT
  COALESCE(tab_115318.col_199168, NULL) AS col_199169
FROM
  (VALUES (''::VOID), (NULL), (NULL), (''::VOID)) AS tab_115318 (col_199168)
ORDER BY
  tab_115318.col_199168

-- Test 14: statement (line 78)
SELECT NULLIF(tab_115318.a, tab_115318.b) AS col_199169
FROM
  (VALUES (''::VOID, NULL), (NULL, NULL)) AS tab_115318 (a, b)
ORDER BY
  tab_115318.a;

-- Test 15: statement (line 85)
SELECT NULLIF(tab_115318.a, tab_115318.b) AS col_199169
FROM
  (VALUES (''::VOID, ''::VOID), (NULL, NULL)) AS tab_115318 (a, b)
ORDER BY
  tab_115318.col_199168;

-- Test 16: query (line 93)
SELECT
  COALESCE(tab_115318.col_199168, NULL) AS col_199169
FROM
  (VALUES ((NULL, 1)), (NULL)) AS tab_115318 (col_199168)
ORDER BY
  tab_115318.col_199168

-- Test 17: statement (line 104)
SET vectorize=off

-- Test 18: query (line 109)
SELECT
  COALESCE(tab_115318.col_199168, NULL) AS col_199169
FROM
  (VALUES (''::VOID), (NULL), (NULL), (''::VOID)) AS tab_115318 (col_199168)
ORDER BY
  tab_115318.col_199168

-- Test 19: statement (line 124)
SELECT NULLIF(tab_115318.a, tab_115318.b) AS col_199169
FROM
  (VALUES (''::VOID, NULL), (NULL, NULL)) AS tab_115318 (a, b)
ORDER BY
  tab_115318.a;

-- Test 20: statement (line 133)
SELECT NULLIF(tab_115318.a, tab_115318.b) AS col_199169
FROM
  (VALUES (''::VOID, ''::VOID), (NULL, NULL)) AS tab_115318 (a, b)
ORDER BY
  tab_115318.col_199168;

-- Test 21: query (line 143)
SELECT
  COALESCE(tab_115318.col_199168, NULL) AS col_199169
FROM
  (VALUES ((NULL, 1)), (NULL)) AS tab_115318 (col_199168)
ORDER BY
  tab_115318.col_199168

-- Test 22: statement (line 154)
RESET vectorize

-- Test 23: query (line 158)
WITH tab(x) AS (VALUES ('':::VOID)) SELECT x IS NULL FROM tab

-- Test 24: query (line 163)
WITH tab(x) AS (VALUES (NULL:::VOID)) SELECT x IS NULL FROM tab

-- Test 25: query (line 168)
WITH tab(x) AS (VALUES ('':::VOID)) SELECT x IS NOT NULL FROM tab

-- Test 26: query (line 173)
WITH tab(x) AS (VALUES (NULL:::VOID)) SELECT x IS NOT NULL FROM tab

-- Test 27: statement (line 179)
SELECT ARRAY[''::VOID]

-- Test 28: statement (line 182)
SELECT ARRAY[NULL::VOID]

-- Test 29: statement (line 188)
SELECT ARRAY[a::VOID] FROM t84224

