-- PostgreSQL compatible tests from select_table_alias
-- 15 tests

-- Test 1: statement (line 3)
CREATE TABLE abc (a INT PRIMARY KEY, b INT, c INT)

-- Test 2: statement (line 6)
INSERT INTO abc VALUES (1, 2, 3), (4, 5, 6)

-- Test 3: query (line 12)
SELECT * FROM abc

-- Test 4: query (line 19)
SELECT * FROM abc AS foo

-- Test 5: query (line 26)
SELECT * FROM abc AS foo (foo1)

-- Test 6: query (line 33)
SELECT * FROM abc AS foo (foo1, foo2)

-- Test 7: query (line 40)
SELECT * FROM abc AS foo (foo1, foo2, foo3)

-- Test 8: query (line 50)
SELECT foo1, foo.foo1, b, foo.c FROM abc AS foo (foo1)

-- Test 9: query (line 57)
SELECT * FROM abc AS foo (foo1, foo2) WHERE foo.foo1 = 1

-- Test 10: query (line 63)
SELECT * FROM abc AS foo (foo1, foo2) WHERE foo.foo2 = 2

-- Test 11: query (line 69)
SELECT * FROM abc AS foo (foo1, foo2) WHERE foo.c = 6

-- Test 12: query (line 78)
SELECT abc.foo1 FROM abc AS foo (foo1)

query error no data source matches prefix: abc
SELECT abc.b FROM abc AS foo (foo1)

query error column "foo.a" does not exist
SELECT foo.a FROM abc AS foo (foo1)


# Verify error for too many column aliases.

query error pgcode 42P10 source "foo" has 3 columns available but 4 columns specified
SELECT * FROM abc AS foo (foo1, foo2, foo3, foo4)


# Verify that implicit columns don't interfere with aliasing.

statement ok
CREATE TABLE ab (a INT, b INT)

statement ok
INSERT INTO ab VALUES (1, 2), (1, 3), (2, 5)

query II colnames,rowsort
SELECT * FROM ab AS foo (foo1, foo2)

-- Test 13: statement (line 110)
SELECT rowid, foo.rowid FROM ab AS foo (foo1, foo2)

-- Test 14: query (line 113)
SELECT ab.rowid FROM ab AS foo (foo1)

query error source "foo" has 2 columns available but 3 columns specified
SELECT * FROM ab AS foo (foo1, foo2, foo3)

query T colnames
SELECT * FROM to_english(3) AS x

-- Test 15: query (line 125)
TABLE ROWS FROM (to_english(3)) AS x;

