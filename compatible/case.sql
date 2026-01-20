-- PostgreSQL compatible tests from case
-- 21 tests

-- Test 1: statement (line 6)
CREATE TABLE xy (x INT PRIMARY KEY, y INT)

-- Test 2: statement (line 9)
INSERT INTO a VALUES (1, 1, 1, 'foo', '{"x": "one"}');
INSERT INTO xy VALUES (1, 2);

-- Test 3: statement (line 13)
SELECT CASE WHEN f = (SELECT 1 // 0 FROM xy WHERE x = i) THEN 100 ELSE 200 END FROM a;

-- Test 4: query (line 16)
SELECT CASE WHEN f = 0 THEN (SELECT 1 // 0 FROM xy WHERE x = i) ELSE 200 END FROM a;

-- Test 5: statement (line 21)
SELECT CASE WHEN f = 1 THEN (SELECT 1 // 0 FROM xy WHERE x = i) ELSE 200 END FROM a;

-- Test 6: query (line 24)
SELECT CASE WHEN f = 1 THEN 100 ELSE (SELECT 1 // 0 FROM xy WHERE x = i) END FROM a;

-- Test 7: statement (line 29)
SELECT CASE WHEN f = 0 THEN 100 ELSE (SELECT 1 // 0 FROM xy WHERE x = i) END FROM a;

-- Test 8: query (line 36)
SELECT CASE WHEN f = 1
  THEN (SELECT y FROM xy WHERE x = i)
  ELSE (SELECT 1 // 0 FROM xy WHERE x = i) END
FROM a;

-- Test 9: statement (line 44)
SELECT CASE WHEN f = 0
  THEN (SELECT y FROM xy WHERE x = i)
  ELSE (SELECT 1 // 0 FROM xy WHERE x = i) END
FROM a;

-- Test 10: query (line 56)
SELECT CASE WHEN true THEN 'foo'::TEXT ELSE 'b'::CHAR END

-- Test 11: query (line 61)
SELECT COALESCE(NULL::CHAR, 'bar'::CHAR(2))

-- Test 12: query (line 66)
SELECT IF(false, 'foo'::CHAR, 'bar'::CHAR(2))

-- Test 13: query (line 71)
SELECT CASE WHEN false THEN 'b'::CHAR ELSE 'foo'::TEXT END

-- Test 14: query (line 76)
SELECT (CASE WHEN false THEN 'b'::CHAR ELSE 'foo'::TEXT END)::CHAR

-- Test 15: query (line 81)
SELECT (CASE WHEN false THEN 'b'::CHAR ELSE 'foo'::TEXT END)::BPCHAR

-- Test 16: query (line 86)
SELECT CASE WHEN true THEN 1.2345::DECIMAL(5, 4) ELSE NULL::DECIMAL(10, 2) END

-- Test 17: query (line 91)
SELECT CASE WHEN false THEN NULL::DECIMAL(10, 2) ELSE 1.2345::DECIMAL(5, 4) END

-- Test 18: query (line 102)
SELECT (t2.c).foo FROM (
    SELECT CASE WHEN foo IS NULL THEN NULL ELSE t.* END
    FROM (VALUES (1, 'a'), (3, 'b')) AS t(foo, bar)
) AS t2(c)

-- Test 19: query (line 111)
SELECT to_jsonb(CASE WHEN foo IS NULL THEN NULL ELSE t.* END)
FROM (VALUES (1, 'a'), (3, 'b')) AS t(foo, bar)

-- Test 20: statement (line 118)
CREATE TABLE t136167 (id UUID PRIMARY KEY, s TEXT)

-- Test 21: query (line 124)
SELECT to_jsonb(CASE WHEN t.s IS NULL THEN NULL ELSE t.* END) FROM t136167 AS t

