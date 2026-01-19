-- PostgreSQL compatible tests from distsql_srfs
-- 7 tests

-- Test 1: statement (line 1)
CREATE TABLE data (a INT PRIMARY KEY)

-- Test 2: statement (line 4)
INSERT INTO data SELECT generate_series(0, 9)

-- Test 3: query (line 8)
SELECT a, generate_series(a, a + 1) FROM data ORDER BY 1, 2

-- Test 4: query (line 33)
SELECT a, b FROM (SELECT a, generate_series(1, 3) AS b FROM data) WHERE a < 4 AND b = 3

-- Test 5: query (line 42)
SELECT a, generate_series(1, 2), generate_series(1, 4) FROM data WHERE a < 2 ORDER BY 1, 2, 3

-- Test 6: statement (line 54)
CREATE TABLE groups(
  id SERIAL,
  data jsonb,
  primary key (id)
)

-- Test 7: query (line 61)
SELECT g.data->>'name' AS group_name, jsonb_array_elements(g.data->'members') FROM groups g;

