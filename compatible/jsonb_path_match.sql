-- PostgreSQL compatible tests from jsonb_path_match
-- 6 tests

-- Test 1: query (line 1)
SELECT jsonb_path_match('{}', '1 + 1 == 2');

-- Test 2: query (line 6)
SELECT jsonb_path_match('{}', '"abc" starts with "b"');

-- Test 3: query (line 11)
SELECT jsonb_path_match('{}', 'strict $', '{}', true);

-- Test 4: statement (line 16)
SELECT jsonb_path_match('{}', 'strict $', '{}', false);

-- Test 5: query (line 19)
SELECT jsonb_path_match('{}', '$', '{}', true);

-- Test 6: statement (line 24)
SELECT jsonb_path_match('{}', '$', '{}', false);

