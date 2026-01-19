-- PostgreSQL compatible tests from exclude_data_from_backup
-- 12 tests

-- Test 1: statement (line 1)
CREATE TABLE t(x INT PRIMARY KEY)

-- Test 2: query (line 4)
SELECT id FROM system.namespace WHERE name='t';

-- Test 3: query (line 14)
SHOW CREATE TABLE t

-- Test 4: query (line 23)
SHOW CREATE TABLE t

-- Test 5: query (line 35)
SHOW CREATE TABLE t

-- Test 6: query (line 44)
SHOW CREATE TABLE t

-- Test 7: statement (line 56)
CREATE TEMPORARY TABLE temp1()

-- Test 8: statement (line 63)
CREATE TABLE t2(x INT REFERENCES t(x) ON DELETE CASCADE);

-- Test 9: query (line 74)
SHOW CREATE TABLE t2

-- Test 10: query (line 85)
SHOW CREATE TABLE t2

-- Test 11: query (line 100)
SHOW CREATE TABLE t2

-- Test 12: query (line 111)
SHOW CREATE TABLE t2

