-- PostgreSQL compatible tests from show_completions
-- 15 tests

SET client_min_messages = warning;

CREATE SCHEMA IF NOT EXISTS crdb_internal;

-- CockroachDB has SHOW COMPLETIONS AT OFFSET ... FOR <sql>. PostgreSQL does not
-- expose SQL-shell completion from SQL, but pg_get_keywords() provides a stable
-- keyword list. Approximate "completions" by returning keywords matching the
-- word fragment at the cursor position.
CREATE OR REPLACE FUNCTION crdb_internal.show_completions_at_offset(off INT, input TEXT)
RETURNS TABLE(completion TEXT)
LANGUAGE sql
AS $$
  WITH
    clipped AS (
      SELECT lower(substring(input from 1 for greatest(off, 0))) AS s
    ),
    trimmed AS (
      SELECT regexp_replace(s, '[[:space:]]+$', '') AS s FROM clipped
    ),
    prefix AS (
      SELECT COALESCE((regexp_match(s, '([[:alpha:]_]+)$'))[1], '') AS p FROM trimmed
    )
  SELECT k.word AS completion
  FROM prefix, pg_get_keywords() AS k
  WHERE prefix.p <> ''
    AND k.word LIKE prefix.p || '%'
  ORDER BY completion;
$$;

-- Test 1: query (line 3)
SELECT * FROM crdb_internal.show_completions_at_offset(5, 'creat');

-- Test 2: query (line 11)
SELECT * FROM crdb_internal.show_completions_at_offset(5, 'creat') ORDER BY completion;

-- Test 3: query (line 23)
SELECT completion FROM crdb_internal.show_completions_at_offset(5, 'creat') ORDER BY completion;

-- Test 4: query (line 31)
SELECT completion FROM crdb_internal.show_completions_at_offset(5, 'CREAT') ORDER BY completion;

-- Test 5: query (line 39)
SELECT completion FROM crdb_internal.show_completions_at_offset(10, 'SHOW CREAT') ORDER BY completion;

-- Test 6: query (line 47)
SELECT completion FROM crdb_internal.show_completions_at_offset(10, 'show creat') ORDER BY completion;

-- Test 7: query (line 59)
SELECT count(*) > 0 FROM crdb_internal.show_completions_at_offset(6, 'creat ');

-- Test 8: query (line 68)
SELECT completion FROM crdb_internal.show_completions_at_offset(3, 'sel') ORDER BY completion;

-- Test 9: query (line 77)
SELECT completion FROM crdb_internal.show_completions_at_offset(3, 'create ta') ORDER BY completion;

-- Test 10: query (line 89)
SELECT completion FROM crdb_internal.show_completions_at_offset(2, 'select') ORDER BY completion;

-- Test 11: query (line 98)
SELECT completion FROM crdb_internal.show_completions_at_offset(2, '你好，我的名字是鲍勃 SELECT') ORDER BY completion;

-- Test 12: query (line 102)
SELECT completion FROM crdb_internal.show_completions_at_offset(11, '你好，我的名字是鲍勃 SELECT') ORDER BY completion;

-- Test 13: query (line 106)
SELECT completion FROM crdb_internal.show_completions_at_offset(33, '你好，我的名字是鲍勃 SELECT') ORDER BY completion;

-- Test 14: query (line 111)
SELECT completion FROM crdb_internal.show_completions_at_offset(25, '😋😋😋 😋😋😋') ORDER BY completion;

-- Test 15: query (line 115)
SELECT completion FROM crdb_internal.show_completions_at_offset(9, 'Jalapeño') ORDER BY completion;

RESET client_min_messages;
