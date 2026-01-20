-- PostgreSQL compatible tests from jsonb_path_query_first
-- 7 tests

-- Test 1: query (line 2)
SELECT jsonb_path_query_first('[1, 2, 3]', '$[*]');

-- Test 2: query (line 7)
SELECT jsonb_path_query_first('[2, 3]', '$[*]');

-- Test 3: query (line 12)
SELECT jsonb_path_query_first('[]', '$[*]');

-- Test 4: query (line 17)
SELECT jsonb_path_query_first('{"a": null}', 'strict $.a', '{}', true);

-- Test 5: statement (line 22)
SELECT jsonb_path_query_first('{"a": null}', 'strict $.a', '{}', false);

-- Test 6: query (line 25)
SELECT jsonb_path_query_first('{}', '$.a', '{}', true);

-- Test 7: query (line 30)
SELECT jsonb_path_query_first('{}', '$.a', '{}', false);
