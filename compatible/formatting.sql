-- PostgreSQL compatible tests from formatting
-- 8 tests

-- Test 1: statement (line 8)
INSERT INTO test_table (col1, col2, col3) VALUES ('r1c1', 'r1
c2', 'r1c3'), ('r2c1', 'r2
c2', 'r2c3'), ('r3c1', 'r3
c2', 'r3c3');

-- Test 2: statement (line 14)
CREATE VIEW test_table_view (col1, col2) AS
SELECT col1, col2 FROM test_table

-- Test 3: query (line 18)
SHOW CREATE test_table_view

-- Test 4: query (line 26)
SELECT * FROM test_table
ORDER BY col1

-- Test 5: query (line 34)
SELECT col1, col2 FROM test_table
ORDER BY col1

-- Test 6: query (line 45)
SELECT col2 FROM test_table
ORDER BY col1

-- Test 7: query (line 56)
SELECT col2, col1, col3 FROM test_table
ORDER BY col1

-- Test 8: query (line 64)
SELECT '"abc\n123"'::JSON

