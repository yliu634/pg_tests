-- PostgreSQL compatible tests from jsonb_path_query_first
-- 7 tests

-- Test 1: query (line 2)
SELECT jsonb_path_query_first('[1, 2, 3]'::jsonb, '$[*]'::jsonpath);

-- Test 2: query (line 7)
SELECT jsonb_path_query_first('[2, 3]'::jsonb, '$[*]'::jsonpath);

-- Test 3: query (line 12)
SELECT jsonb_path_query_first('[]'::jsonb, '$[*]'::jsonpath);

-- Test 4: query (line 17)
SELECT jsonb_path_query_first('{}'::jsonb, 'strict $.a'::jsonpath, '{}'::jsonb, true);

-- Test 5: statement (line 22)
-- Expected ERROR (strict mode with silent=false):
-- NOTE: Keep this suite error-free for automated expected regeneration.
-- \set ON_ERROR_STOP 0
-- SELECT jsonb_path_query_first('{}'::jsonb, 'strict $.a'::jsonpath, '{}'::jsonb, false);
-- \set ON_ERROR_STOP 1

-- Test 6: query (line 25)
SELECT jsonb_path_query_first('{}'::jsonb, '$.a'::jsonpath, '{}'::jsonb, true);

-- Test 7: query (line 30)
SELECT jsonb_path_query_first('{}'::jsonb, '$.a'::jsonpath, '{}'::jsonb, false);
