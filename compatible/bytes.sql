-- PostgreSQL compatible tests from bytes
-- 9 tests

-- Test 1: query (line 2)
SHOW bytea_output

-- Test 2: query (line 17)
SELECT b'\x5c\x78':::BYTES

-- Test 3: query (line 69)
SELECT b'\x5c\x78':::BYTES

-- Test 4: statement (line 106)
set bytea_output = hex

-- Test 5: statement (line 138)
set bytea_output = escape

-- Test 6: statement (line 146)
DROP TABLE t

-- Test 7: query (line 159)
EXECUTE r1('abc')

-- Test 8: statement (line 164)
create table regression_71444 (col bytes[]);
insert into regression_71444 VALUES ('{"a"}'), ('{"b", "c"}')

-- Test 9: query (line 168)
SELECT * FROM regression_71444 WHERE col = '{"a"}'

