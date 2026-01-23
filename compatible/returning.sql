-- PostgreSQL compatible tests from returning
-- 4 tests

-- Test 1: statement (line 1)
CREATE TABLE a (a int, b int);

-- Test 2: query (line 6)
INSERT INTO a AS alias VALUES(1, 2) RETURNING alias.a, alias.b;

-- Test 3: query (line 11)
UPDATE a AS alias SET b = 1 RETURNING alias.a, alias.b;

-- Test 4: query (line 17)
UPDATE a AS alias SET b = 1 RETURNING alias.a, alias.b;

-- query II
DELETE FROM a AS alias RETURNING alias.a, alias.b;
