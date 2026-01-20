-- PostgreSQL compatible tests from target_names
-- 8 tests

-- Test 1: query (line 5)
SELECT *, a, a[0], (((((((((a))))))))), t COLLATE "en_US" FROM t

-- Test 2: query (line 11)
SELECT array_length(a, 1),
       nullif(a, a),
       row(1,2,3),
       coalesce(a,a),
       iferror(a, a),
       iserror(a),
       if(true, a, a),
       current_user
FROM t

-- Test 3: query (line 25)
SELECT 123, '123', 123.0, TRUE, FALSE, NULL

-- Test 4: query (line 39)
SELECT (pg_get_keywords()).word FROM t

-- Test 5: query (line 45)
SELECT array[1,2,3], array(select 1)

-- Test 6: query (line 52)
SELECT EXISTS(SELECT * FROM t)

-- Test 7: query (line 59)
SELECT CASE 1 WHEN 2 THEN 3 END,
       CASE 1 WHEN 2 THEN 3 ELSE a[0] END,
       CASE 1 WHEN 2 THEN 3 ELSE length(t) END,
       CASE 1 WHEN 2 THEN 3 ELSE (t||'a')::INT END,
       CASE 1 WHEN 2 THEN 3 ELSE 4 END
  FROM t

-- Test 8: query (line 70)
SELECT (SELECT 123 AS a),
       (VALUES (cos(1)::INT)),
       (SELECT cos(0)::INT)

