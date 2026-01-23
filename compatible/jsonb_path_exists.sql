-- PostgreSQL compatible tests from jsonb_path_exists
-- 8 tests

-- Test 1: query (line 2)
SELECT jsonb_path_exists('{}', '$');

-- Test 2: query (line 7)
SELECT jsonb_path_exists('{}', '$.a');

-- Test 3: statement (line 12)
\set ON_ERROR_STOP 0
SELECT jsonb_path_exists('{"a": null}', 'strict $.a');
\set ON_ERROR_STOP 1

-- Test 4: query (line 15)
SELECT jsonb_path_exists('{"a": "b"}', '$.a');

-- Test 5: query (line 20)
SELECT jsonb_path_exists('{"A": "b"}', '$.a');

-- Test 6: query (line 25)
SELECT jsonb_path_exists('[{"a": 1}]', 'false');

-- Test 7: query (line 30)
SELECT jsonb_path_exists('[{"a": 1}, {"a": 2}, 3]', 'lax $[*].a', '{}', false);

-- Test 8: query (line 35)
SELECT jsonb_path_exists('[{"a": 1}, {"a": 2}, 3]', 'lax $[*].a', '{}', true);
