-- PostgreSQL compatible tests from errors
-- 7 tests

-- This file is an "errors" test: all statements are expected to error.
\set ON_ERROR_STOP 0

-- Test 1: statement (line 1)
ALTER TABLE fake1 DROP COLUMN a;

-- Test 2: statement (line 4)
CREATE INDEX i ON fake2 (a);

-- Test 3: statement (line 7)
-- CockroachDB index drop syntax: <table>@<index>.
DROP INDEX i;

-- Test 4: statement (line 10)
DROP TABLE fake4;

-- Test 5: statement (line 13)
-- PostgreSQL has no SHOW COLUMNS; reference the table to trigger the same
-- "relation does not exist" class of error.
SELECT * FROM fake5 LIMIT 0;

-- Test 6: statement (line 16)
INSERT INTO fake6 VALUES (1, 2);

-- Test 7: statement (line 19)
SELECT * FROM fake7;

\set ON_ERROR_STOP 1
