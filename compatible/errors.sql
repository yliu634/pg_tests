-- PostgreSQL compatible tests from errors
-- 7 tests

-- Test 1: statement (line 1)
ALTER TABLE fake1 DROP COLUMN a

-- Test 2: statement (line 4)
CREATE INDEX i ON fake2 (a)

-- Test 3: statement (line 7)
DROP INDEX fake3@i

-- Test 4: statement (line 10)
DROP TABLE fake4

-- Test 5: statement (line 13)
SHOW COLUMNS FROM fake5

-- Test 6: statement (line 16)
INSERT INTO fake6 VALUES (1, 2)

-- Test 7: statement (line 19)
SELECT * FROM fake7

