-- PostgreSQL compatible tests from zero
-- 17 tests

-- Test 1: statement (line 5)
CREATE TABLE i (i int, v int)

-- Test 2: statement (line 8)
INSERT INTO i VALUES
  (1, 0),
  (2, -0),
  (3, 0::int),
  (4, -0::int),
  (5, '0'::int),
  (6, '-0'::int)

-- Test 3: query (line 17)
select * FROM i ORDER BY i

-- Test 4: query (line 27)
SELECT 0, -0, 0::int, -0::int, '0'::int, '-0'::int

-- Test 5: statement (line 34)
CREATE TABLE f (i int, v float)

-- Test 6: statement (line 37)
INSERT INTO f VALUES
  (1, 0.0),
  (2, -0.0),
  (3, 0.00::float),
  (4, -0.00::float),
  (5, (-0.000)::float),
  (6, 0::float),
  (7, -0::float),
  (8, '0.0000'::float),
  (9, '-0.0000'::float),
  (10, 0),
  (11, -0)

-- Test 7: query (line 51)
select * FROM f ORDER BY i

-- Test 8: query (line 66)
SELECT 0.0::float as a,
      -0.0::float as b,
      0.00::float as c,
     -0.00::float as d,
  (-0.000)::float as e,
                0 as f,
               -0 as g,
         0::float as h,
        -0::float as i,
  '0.0000'::float as j,
 '-0.0000'::float as k

-- Test 9: query (line 84)
SELECT 0.0::decimal as a,
      -0.0::decimal as b,
      0.00::decimal as c,
     -0.00::decimal as d,
  (-0.000)::decimal as e,
         0::decimal as f,
        -0::decimal as g,
  '0.0000'::decimal as h,
 '-0.0000'::decimal as i

-- Test 10: statement (line 98)
CREATE TABLE d (i INT, v DECIMAL)

-- Test 11: statement (line 101)
INSERT INTO d VALUES
  (1, 0.0),
  (2, -0.0),
  (3, 0.00::decimal),
  (4, -0.00::decimal),
  (5, (-0.000)::decimal),
  (6, 0::decimal),
  (7, -0::decimal),
  (8, '0.0000'::decimal),
  (9, '-0.0000'::decimal),
  (10, 0),
  (11, -0)

-- Test 12: query (line 115)
select * FROM d ORDER BY i

-- Test 13: statement (line 130)
CREATE TABLE didx (i INT, v DECIMAL);
CREATE INDEX vidx ON didx (v)

-- Test 14: statement (line 133)
INSERT INTO didx VALUES
  (1, 0.0),
  (2, -0.0),
  (3, 0.00::decimal),
  (4, -0.00::decimal),
  (5, (-0.000)::decimal),
  (6, 0::decimal),
  (7, -0::decimal),
  (8, '0.0000'::decimal),
  (9, '-0.0000'::decimal),
  (10, 0),
  (11, -0)

-- Test 15: query (line 147)
SELECT v FROM didx ORDER BY v

-- Test 16: query (line 162)
SELECT - -0.00::decimal, - - -0.00::decimal, - - -0.00, - -0.00

-- Test 17: query (line 179)
SELECT * FROM (VALUES (-0.0::DECIMAL), (-0::DECIMAL), (0::DECIMAL), (-0.00::DECIMAL)) ORDER BY 1

