-- PostgreSQL compatible tests from strict_ddl_atomicity
-- 16 tests

-- Test 1: statement (line 4)
SET client_min_messages = warning;

-- CockroachDB setting (no PostgreSQL equivalent):
-- SET autocommit_before_ddl=off;

DROP TABLE IF EXISTS unrelated;
DROP TABLE IF EXISTS testing;
CREATE TABLE testing (k INT PRIMARY KEY, v TEXT);
INSERT INTO testing (k, v) VALUES (1, 'a'), (2, 'b'), (3, 'a'), (4, 'b');
CREATE TABLE unrelated(x INT);

-- Test 2: statement (line 13)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- Test 3: statement (line 16)
SAVEPOINT ddl_sp;
-- Expected ERROR (duplicate key values prevent unique constraint creation):
\set ON_ERROR_STOP 0
ALTER TABLE testing ADD CONSTRAINT "unique_values" UNIQUE(v);
\set ON_ERROR_STOP 1
ROLLBACK TO SAVEPOINT ddl_sp;
RELEASE SAVEPOINT ddl_sp;

-- Test 4: statement (line 19)
INSERT INTO testing (k,v) VALUES (5, 'c');
INSERT INTO unrelated(x) VALUES (1);

-- Test 5: statement (line 24)
COMMIT;

-- Test 6: query (line 28)
SELECT * FROM testing ORDER BY k;

-- Test 7: query (line 38)
SELECT * FROM unrelated ORDER BY x;

-- Test 8: statement (line 43)
DELETE FROM testing WHERE k = 5;

-- Test 9: statement (line 47)
-- CockroachDB setting (no PostgreSQL equivalent):
-- SET strict_ddl_atomicity = true

-- Test 10: statement (line 50)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- Test 11: statement (line 53)
-- Expected ERROR (duplicate key values prevent unique constraint creation):
\set ON_ERROR_STOP 0
ALTER TABLE testing ADD CONSTRAINT "unique_values" UNIQUE(v);
\set ON_ERROR_STOP 1

-- Test 12: statement (line 56)
ROLLBACK;

-- Test 13: statement (line 59)
-- SET autocommit_before_ddl = false

-- skipif config weak-iso-level-configs

-- Test 14: statement (line 63)
\set ON_ERROR_STOP 0
SELECT 1; ALTER TABLE testing ADD CONSTRAINT "unique_values" UNIQUE(v);
\set ON_ERROR_STOP 1

-- onlyif config weak-iso-level-configs

-- Test 15: statement (line 67)
-- SELECT 1; ALTER TABLE testing ADD CONSTRAINT "unique_values" UNIQUE(v)

-- Test 16: statement (line 70)
-- RESET autocommit_before_ddl

RESET client_min_messages;
