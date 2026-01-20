-- PostgreSQL compatible tests from collatedstring_uniqueindex1
-- 12 tests

SET client_min_messages = warning;
CREATE COLLATION IF NOT EXISTS da (provider = icu, locale = 'da');

DROP TABLE IF EXISTS t;
CREATE TABLE t (
  a text COLLATE da,
  b int,
  c boolean
);

-- Test 1: statement (line 14)
INSERT INTO t VALUES
  ('A' COLLATE da, 1, TRUE),
  ('A' COLLATE da, 2, NULL),
  ('a' COLLATE da, 2, FALSE),
  ('a' COLLATE da, 3, TRUE),
  ('B' COLLATE da, 3, NULL),
  ('b' COLLATE da, 4, FALSE),
  ('ü' COLLATE da, 6, TRUE),
  ('ü' COLLATE da, 5, NULL),
  ('x' COLLATE da, 5, FALSE);

-- Test 2: statement (line 26)
CREATE UNIQUE INDEX ON t (b, a);

-- Test 3: query (line 29)
SELECT a, b FROM t ORDER BY a, b;

-- Test 4: query (line 42)
SELECT b, a FROM t ORDER BY b, a;

-- Test 5: query (line 55)
SELECT COUNT (a) FROM t WHERE a = ('a' COLLATE da);

-- Test 6: query (line 60)
SELECT COUNT (a) FROM t WHERE a = ('y' COLLATE da);

-- Test 7: query (line 65)
SELECT COUNT (a) FROM t WHERE a > ('a' COLLATE da) AND a < ('c' COLLATE da);

-- Test 8: query (line 75)
SELECT a, b FROM t ORDER BY a, b;

-- Test 9: query (line 88)
SELECT b, a FROM t ORDER BY b, a;

-- Test 10: statement (line 103)
DELETE FROM t WHERE a > ('a' COLLATE da) AND a < ('c' COLLATE da);

-- Test 11: query (line 106)
SELECT a, b FROM t ORDER BY a, b;

-- Test 12: query (line 117)
SELECT b, a FROM t ORDER BY b, a;

RESET client_min_messages;
