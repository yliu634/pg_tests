SET client_min_messages = warning;

-- PostgreSQL compatible tests from ordinality
-- 18 tests

-- Test 1: query (line 1)
SELECT * FROM (VALUES ('a'), ('b')) WITH ORDINALITY AS x(name, i);

-- Test 2: query (line 8)
SELECT ordinality FROM (VALUES ('a'), ('b')) WITH ORDINALITY;

-- Test 3: statement (line 15)
DROP TABLE IF EXISTS foo CASCADE;
CREATE TABLE foo (x CHAR PRIMARY KEY); INSERT INTO foo(x) VALUES ('a'), ('b');

-- Test 4: query (line 18)
SELECT * FROM foo WITH ORDINALITY;

-- Test 5: query (line 24)
SELECT * FROM foo WITH ORDINALITY LIMIT 1;

-- Test 6: query (line 29)
SELECT max(ordinality) FROM foo WITH ORDINALITY;

-- Test 7: query (line 34)
SELECT * FROM foo WITH ORDINALITY AS a, foo WITH ORDINALITY AS b;

-- Test 8: query (line 42)
SELECT * FROM (SELECT x||x FROM foo) WITH ORDINALITY;

-- Test 9: query (line 48)
SELECT * FROM (SELECT x, ordinality*2 FROM foo WITH ORDINALITY AS a) JOIN foo WITH ORDINALITY AS b USING(x);

-- Test 10: query (line 54)
SELECT * FROM (SELECT * FROM foo ORDER BY x DESC) WITH ORDINALITY LIMIT 1;

-- Test 11: query (line 59)
SELECT * FROM (SELECT * FROM foo ORDER BY x) WITH ORDINALITY ORDER BY x DESC LIMIT 1;

-- Test 12: query (line 64)
SELECT * FROM (SELECT * FROM foo ORDER BY x) WITH ORDINALITY ORDER BY ordinality DESC LIMIT 1;

-- Test 13: statement (line 69)
INSERT INTO foo(x) VALUES ('c');

-- Test 14: query (line 72)
SELECT * FROM foo WITH ORDINALITY WHERE x > 'a';

-- Test 15: query (line 78)
SELECT * FROM foo WITH ORDINALITY WHERE ordinality > 1 ORDER BY ordinality DESC;

-- Test 16: query (line 84)
SELECT * FROM (SELECT * FROM foo WHERE x > 'a') WITH ORDINALITY;

-- Test 17: query (line 90)
SELECT ordinality = row_number() OVER () FROM foo WITH ORDINALITY;

-- Test 18: query (line 102)
SELECT * FROM (SELECT * FROM foo LIMIT 1) WITH ORDINALITY;



RESET client_min_messages;