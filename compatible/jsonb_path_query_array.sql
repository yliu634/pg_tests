-- PostgreSQL compatible tests from jsonb_path_query_array
-- 7 tests

-- Test 1: query (line 2)
SELECT jsonb_path_query_array('{}', '$');

-- Test 2: query (line 7)
SELECT jsonb_path_query_array('{"a": [1, 2, {"b": [4, 5]}, null, [true, false]]}', '$.a[*]');

-- Test 3: query (line 12)
SELECT jsonb_path_query_array('{"a": [[{"b": 1, "c": "hello"}, {"b": 2, "c": "world"}, {"b": 1, "c": "!"}], [{"b": 1, "c": "hello"}, {"b": 2, "c": "world"}, {"b": 1, "c": "!"}]]}', '$.a ? (@.b == 1)');

-- Test 4: query (line 17)
SELECT jsonb_path_query_array('{}', 'strict $.a', '{}', true);

-- Test 5: statement (line 22)
-- NOTE: PostgreSQL errors on strict missing paths when silent=false.
-- SELECT jsonb_path_query_array('{}', 'strict $.a', '{}', false);

-- Test 6: query (line 25)
SELECT jsonb_path_query_array('{}', '$.a', '{}', true);

-- Test 7: query (line 30)
SELECT jsonb_path_query_array('{}', '$.a', '{}', false);
