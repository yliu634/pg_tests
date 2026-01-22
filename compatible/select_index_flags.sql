-- PostgreSQL compatible tests from select_index_flags
-- 12 tests

-- Test 1: statement (line 1)
CREATE TABLE abcd (
  a INT PRIMARY KEY,
  b INT,
  c INT,
  d INT,
  UNIQUE (b, c, d)
);
CREATE INDEX abcd_b_idx ON abcd (b);
CREATE INDEX abcd_cd_idx ON abcd (c, d);

-- Test 2: statement (line 12)
INSERT INTO abcd VALUES
  (10, 11, 12, 13),
  (20, 21, 22, 23),
  (30, 31, 32, 33),
  (40, 41, 42, 43);

-- Test 3: query (line 16)
SELECT * FROM abcd WHERE a >= 20 AND a <= 30 ORDER BY a;

-- Test 4: query (line 23)
SELECT * FROM abcd WHERE a >= 20 AND a <= 30 ORDER BY a;

-- Test 5: query (line 37)
SELECT * FROM abcd WHERE a >= 20 AND a <= 30 ORDER BY a;

-- Test 6: query (line 51)
SELECT * FROM abcd WHERE a >= 20 AND a <= 30 ORDER BY a;

-- Test 7: query (line 58)
SELECT * FROM abcd WHERE a >= 20 AND a <= 30 ORDER BY a;

-- Test 8: query (line 65)
SELECT b FROM abcd WHERE a >= 20 AND a <= 30 ORDER BY b;

-- Test 9: query (line 72)
SELECT b FROM abcd WHERE c >= 20 AND c <= 30 ORDER BY b;

-- Test 10: query (line 78)
SELECT c, d FROM abcd WHERE c >= 20 AND c < 40 ORDER BY c, d;

-- Test 11: query (line 85)
SELECT c, d FROM abcd WHERE c >= 20 AND c < 40 ORDER BY c, d;

-- Test 12: query (line 92)
SELECT c, d FROM abcd WHERE c >= 20 AND c < 40 ORDER BY c, d;
