-- PostgreSQL compatible tests from function_lookup
-- 9 tests

-- Test 1: statement (line 1)
CREATE TABLE foo(x INT DEFAULT length(pg_typeof(1234))-1)

-- Test 2: statement (line 4)
CREATE TABLE bar(x INT, CHECK(pg_typeof(123) = 'bigint'))

-- Test 3: statement (line 7)
ALTER TABLE foo ALTER COLUMN x SET DEFAULT length(pg_typeof(123))

-- Test 4: statement (line 10)
ALTER TABLE foo ADD CONSTRAINT z CHECK(pg_typeof(123) = 'bigint')

-- Test 5: query (line 13)
SELECT pg_typeof(123)

-- Test 6: query (line 18)
SELECT count(*) FROM foo GROUP BY pg_typeof(x)

-- Test 7: query (line 22)
SELECT * FROM foo LIMIT length(pg_typeof(123))

-- Test 8: query (line 26)
SELECT * FROM foo WHERE pg_typeof(x) = 'bigint'

-- Test 9: query (line 30)
INSERT INTO foo(x) VALUES (42) RETURNING pg_typeof(x)

