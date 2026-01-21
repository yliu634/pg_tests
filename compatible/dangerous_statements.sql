-- PostgreSQL compatible tests from dangerous_statements
-- 22 tests

-- Test 1: statement (line 1)
CREATE TABLE foo(x INT);

-- Test 2: statement (line 4)
-- CockroachDB/MySQL compatibility setting; not supported in PostgreSQL.
-- SET sql_safe_updates = true;

-- Test 3: statement (line 7)
UPDATE foo SET x = 3;

-- Test 4: statement (line 10)
UPDATE foo SET x = 3 WHERE x = 2;

-- Test 5: statement (line 13)
WITH target AS (
  SELECT ctid FROM foo ORDER BY x LIMIT 1
)
UPDATE foo SET x = 3
WHERE ctid IN (SELECT ctid FROM target);

-- Test 6: statement (line 16)
DELETE FROM foo;

-- Test 7: statement (line 19)
DELETE FROM foo WHERE x = 2;

-- Test 8: statement (line 22)
WITH target AS (
  SELECT ctid FROM foo ORDER BY x LIMIT 1
)
DELETE FROM foo
WHERE ctid IN (SELECT ctid FROM target);

-- Test 9: statement (line 25)
SELECT * FROM foo FOR UPDATE;

-- Test 10: statement (line 28)
SELECT * FROM foo FOR SHARE OF foo SKIP LOCKED;

-- Test 11: statement (line 31)
SELECT * FROM foo WHERE x = 2 FOR UPDATE;

-- Test 12: statement (line 34)
SELECT * FROM foo ORDER BY x LIMIT 1 FOR UPDATE;

-- Test 13: statement (line 37)
(SELECT * FROM foo) FOR UPDATE;

-- Test 14: statement (line 40)
(SELECT * FROM foo WHERE x = 2) FOR UPDATE;

-- Test 15: statement (line 43)
SELECT * FROM (SELECT * FROM foo WHERE x = 2) AS sub FOR UPDATE;

-- Test 16: statement (line 46)
SELECT * FROM (SELECT * FROM (SELECT * FROM foo) AS sub0 WHERE x = 2) AS sub1 FOR UPDATE;

-- Test 17: statement (line 49)
SELECT * FROM (SELECT * FROM foo FOR UPDATE) AS sub WHERE x = 2 FOR UPDATE;

-- Test 18: statement (line 52)
SELECT * FROM (SELECT * FROM foo WHERE x = 2 FOR UPDATE) m, (SELECT * FROM foo) n FOR SHARE;

-- Test 19: statement (line 55)
SELECT * FROM (SELECT * FROM foo FOR SHARE) m, (SELECT * FROM foo) n WHERE m.x = n.x;

-- Test 20: statement (line 58)
SELECT * FROM (SELECT * FROM (SELECT * FROM foo) AS sub0 WHERE x > 1) AS sub1 WHERE x > 2 FOR UPDATE;

-- Test 21: statement (line 61)
ALTER TABLE foo DROP COLUMN x;

-- Test 22: statement (line 64)
-- CockroachDB `SET database` is not supported in PostgreSQL.
-- SET database = '';
