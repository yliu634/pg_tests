-- PostgreSQL compatible tests from collatedstring_uniqueindex2
-- 12 tests

-- Test 1: statement (line 14)
INSERT INTO t VALUES
  ('A' COLLATE de, 1, TRUE),
  ('A' COLLATE de, 2, NULL),
  ('a' COLLATE de, 2, FALSE),
  ('a' COLLATE de, 3, TRUE),
  ('B' COLLATE de, 3, NULL),
  ('b' COLLATE de, 4, FALSE),
  ('ü' COLLATE de, 6, TRUE),
  ('ü' COLLATE de, 5, NULL),
  ('x' COLLATE de, 5, FALSE)

-- Test 2: statement (line 26)
CREATE UNIQUE INDEX ON t (a, b)

-- Test 3: query (line 29)
SELECT a, b FROM t ORDER BY a, b

-- Test 4: query (line 42)
SELECT b, a FROM t ORDER BY b, a

-- Test 5: query (line 55)
SELECT COUNT (a) FROM t WHERE a = ('a' COLLATE de)

-- Test 6: query (line 60)
SELECT COUNT (a) FROM t WHERE a = ('y' COLLATE de)

-- Test 7: query (line 65)
SELECT COUNT (a) FROM t WHERE a > ('a' COLLATE de) AND a < ('c' COLLATE de)

-- Test 8: query (line 75)
SELECT a, b FROM t ORDER BY a, b

-- Test 9: query (line 88)
SELECT b, a FROM t ORDER BY b, a

-- Test 10: statement (line 103)
DELETE FROM t WHERE a > ('a' COLLATE de) AND a < ('c' COLLATE de)

-- Test 11: query (line 106)
SELECT a, b FROM t ORDER BY a, b

-- Test 12: query (line 113)
SELECT b, a FROM t ORDER BY b, a

