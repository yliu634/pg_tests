-- PostgreSQL compatible tests from fuzzystrmatch
-- 20 tests

-- Test 1: statement (line 1)
CREATE TABLE fuzzystrmatch_table(
  id int primary key,
  a text,
  b text
)

-- Test 2: statement (line 8)
INSERT INTO fuzzystrmatch_table VALUES
  (1, 'apple', 'banana'),
  (2, '', 'pear'),
  (3, '😄', '🐯'),
  (4, null, 'a'),
  (5, 'a', null),
  (6, null, null),
  (7, 'apple', 'apple'),
  (8, 'a', 'abcd'),
  (9, '', ''),
  (10, '', 'abc'),
  (11, 'xyz', ''),
  (12, 'extensive', 'exhaustive'),
  (13, '🌞', 'a')

-- Test 3: statement (line 24)
SELECT levenshtein(lpad('', 256, 'x'), '')

-- Test 4: statement (line 27)
SELECT levenshtein(lpad('', 256, 'x'), '', 2, 3, 4)

-- Test 5: query (line 30)
SELECT a, b, levenshtein(a, b), levenshtein(a, b, 2, 3, 4) FROM fuzzystrmatch_table ORDER BY id

-- Test 6: statement (line 47)
SELECT levenshtein_less_equal(lpad('', 256, 'x'), '', 4)

-- Test 7: statement (line 50)
SELECT levenshtein_less_equal(lpad('', 256, 'x'), '', 4, 2, 3, 4)

-- Test 8: statement (line 53)
SELECT levenshtein_less_equal(repeat('🌞', 256), '', 4)

-- Test 9: statement (line 56)
SELECT levenshtein_less_equal('', repeat('🌞', 256), 4)

-- Test 10: query (line 59)
SELECT a, b, levenshtein_less_equal(a, b, 3), levenshtein_less_equal(a, b, 2, 3, 4, 12) FROM fuzzystrmatch_table ORDER BY id

-- Test 11: query (line 77)
SELECT levenshtein_less_equal('extensive', 'exhaustive', 2)

-- Test 12: query (line 82)
SELECT levenshtein_less_equal('extensive', 'exhaustive', 4)

-- Test 13: query (line 88)
SELECT levenshtein_less_equal('extensive', 'exhaustive', -1)

-- Test 14: query (line 93)
SELECT soundex('hello world!')

-- Test 15: query (line 98)
SELECT soundex('Anne'), soundex('Ann'), difference('Anne', 'Ann');

-- Test 16: query (line 103)
SELECT soundex('Anne'), soundex('Andrew'), difference('Anne', 'Andrew');

-- Test 17: query (line 108)
SELECT soundex('Anne'), soundex('Margaret'), difference('Anne', 'Margaret');

-- Test 18: query (line 113)
SELECT soundex('Anne'), soundex(NULL), difference('Anne', NULL), difference(NULL, 'Bob');

-- Test 19: query (line 118)
SELECT metaphone('GUMBO', 4), metaphone(NULL, 4);

-- Test 20: query (line 123)
SELECT metaphone('Night', 4), metaphone('Knight', 4), metaphone('Knives', 4);

