SET client_min_messages = warning;

-- PostgreSQL compatible tests from ordinal_references
-- 11 tests

-- Test 1: statement (line 1)
-- COMMENTED: CockroachDB-only session setting.
-- SET allow_ordinal_column_references=true;

-- Test 2: statement (line 4)
DROP TABLE IF EXISTS foo CASCADE;
CREATE TABLE foo(a INT, b CHAR);

-- Test 3: query (line 7)
INSERT INTO foo(a, b) VALUES (1,'c'), (2,'b'), (3,'a') RETURNING a;

-- Test 4: query (line 14)
-- COMMENTED: CockroachDB-only ordinal reference syntax (@N); PostgreSQL does not expose rowid.
-- SELECT @0 FROM foo;
SELECT a FROM foo ORDER BY a;

-- COMMENTED: Logic test directive: query error invalid column ordinal
-- SELECT @42 FROM foo;

-- query TI rowsort
SELECT b, a FROM foo ORDER BY 1, 2;

-- Test 5: query (line 28)
SELECT b, a FROM foo ORDER BY 1;

-- Test 6: query (line 36)
SELECT b, a FROM foo ORDER BY a;

-- Test 7: query (line 43)
SELECT b, a FROM foo ORDER BY (a % 2), a;

-- Test 8: statement (line 50)
INSERT INTO foo(a, b) VALUES (4, 'c'), (5, 'c'), (6, 'c');

-- Test 9: query (line 53)
SELECT sum(a) AS s FROM foo GROUP BY a ORDER BY s;

-- Test 10: query (line 63)
SELECT sum(a) AS s FROM foo GROUP BY b ORDER BY s;

-- Test 11: statement (line 70)
INSERT INTO foo(a, b) VALUES (7, 'd');



RESET client_min_messages;
