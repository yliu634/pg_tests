-- PostgreSQL compatible tests from rows_from
-- 10 tests

-- Test 1: query (line 1)
SELECT * FROM ROWS FROM (generate_series(1,2), generate_series(4,8));

-- Test 2: query (line 11)
SELECT * FROM ROWS FROM (generate_series(1,4), generate_series(4,5));

-- Test 3: query (line 20)
SELECT * FROM ROWS FROM (generate_series(1,0), generate_series(1,0));

-- Test 4: query (line 25)
SELECT * FROM ROWS FROM (generate_series(1,0), generate_series(1,1));

-- Test 5: query (line 31)
SELECT * FROM ROWS FROM (
  generate_series(1,2),
  unnest(ARRAY[greatest(1,2,3,4), greatest(1,2,3,4)])
);

-- Test 6: query (line 38)
SELECT * FROM ROWS FROM (generate_series(1,2), unnest(ARRAY[current_user, current_user]));

-- Test 7: query (line 45)
SELECT * FROM ROWS FROM (unnest(ARRAY[current_user, current_user]), generate_series(1,2));

-- Test 8: query (line 52)
SELECT * FROM ROWS FROM (unnest(ARRAY[current_user, current_user]), unnest(ARRAY[current_user, current_user]));

-- Test 9: query (line 58)
SELECT * FROM ROWS FROM (information_schema._pg_expandarray(array[4,5,6]), generate_series(10,15));

-- Test 10: statement (line 71)
SELECT * FROM ROWS FROM (
  generate_series((SELECT length(word) FROM pg_get_keywords() ORDER BY word LIMIT 1), 10)
);
