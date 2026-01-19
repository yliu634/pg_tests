-- PostgreSQL compatible tests from strict_ddl_atomicity
-- 16 tests

-- Test 1: statement (line 4)
SET autocommit_before_ddl=off;

-- Test 2: statement (line 13)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- Test 3: statement (line 16)
ALTER TABLE testing ADD CONSTRAINT "unique_values" UNIQUE(v)

-- Test 4: statement (line 19)
INSERT INTO testing (k,v) VALUES (5, 'c');
INSERT INTO unrelated(x) VALUES (1);

-- Test 5: statement (line 24)
COMMIT

-- Test 6: query (line 28)
SELECT * FROM testing

-- Test 7: query (line 38)
SELECT * FROM unrelated

-- Test 8: statement (line 43)
DELETE FROM testing WHERE k = 5

-- Test 9: statement (line 47)
SET strict_ddl_atomicity = true

-- Test 10: statement (line 50)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- Test 11: statement (line 53)
ALTER TABLE testing ADD CONSTRAINT "unique_values" UNIQUE(v)

-- Test 12: statement (line 56)
ROLLBACK

-- Test 13: statement (line 59)
SET autocommit_before_ddl = false

skipif config weak-iso-level-configs

-- Test 14: statement (line 63)
SELECT 1; ALTER TABLE testing ADD CONSTRAINT "unique_values" UNIQUE(v)

onlyif config weak-iso-level-configs

-- Test 15: statement (line 67)
SELECT 1; ALTER TABLE testing ADD CONSTRAINT "unique_values" UNIQUE(v)

-- Test 16: statement (line 70)
RESET autocommit_before_ddl

