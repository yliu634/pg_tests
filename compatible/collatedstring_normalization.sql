-- PostgreSQL compatible tests from collatedstring_normalization
-- 5 tests

-- Test 1: statement (line 8)
INSERT INTO t VALUES (b'Ame\xcc\x81lie' COLLATE fr)

-- Test 2: query (line 12)
SELECT a FROM t WHERE a = (b'Am\xc3\xa9lie' COLLATE fr)

-- Test 3: statement (line 17)
DELETE FROM t

-- Test 4: statement (line 21)
INSERT INTO t VALUES (b'Am\xc3\xa9lie' COLLATE fr)

-- Test 5: query (line 25)
SELECT a FROM t WHERE a = (b'Ame\xcc\x81lie' COLLATE fr)

