-- PostgreSQL compatible tests from bytes
-- 9 tests

SET client_min_messages = warning;
SET bytea_output = escape;
DEALLOCATE ALL;

-- Test 1: query (line 2)
SHOW bytea_output;

-- Test 2: query (line 17)
SELECT decode('5c78', 'hex')::bytea;

-- Test 3: query (line 69)
SELECT decode('5c78', 'hex')::bytea;

-- Test 4: statement (line 106)
SET bytea_output = hex;

-- Test 5: statement (line 138)
SET bytea_output = escape;

-- Test 6: statement (line 146)
DROP TABLE IF EXISTS t;

-- Test 7: query (line 159)
PREPARE r1(text) AS SELECT $1::bytea;
EXECUTE r1('abc');
DEALLOCATE r1;

-- Test 8: statement (line 164)
DROP TABLE IF EXISTS regression_71444;
CREATE TABLE regression_71444 (col bytea[]);
INSERT INTO regression_71444 VALUES ('{"a"}'), ('{"b", "c"}');

-- Test 9: query (line 168)
SELECT * FROM regression_71444 WHERE col = '{"a"}' ORDER BY 1;

RESET client_min_messages;
