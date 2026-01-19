-- PostgreSQL compatible tests from bpchar
-- 6 tests

-- Test 1: query (line 1)
SELECT 'foo'::BPCHAR

-- Test 2: statement (line 6)
CREATE TABLE t (c BPCHAR PRIMARY KEY, FAMILY (c))

-- Test 3: statement (line 9)
INSERT INTO t VALUES ('foo'), ('ba'), ('c'), ('foobarbaz')

-- Test 4: query (line 12)
SELECT c FROM t

-- Test 5: query (line 21)
SELECT create_statement FROM [SHOW CREATE TABLE t]

-- Test 6: query (line 31)
SELECT create_statement FROM [SHOW CREATE TABLE t]

