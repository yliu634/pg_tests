-- PostgreSQL compatible tests from export
-- 8 tests

-- Test 1: statement (line 4)
CREATE TABLE t (k PRIMARY KEY) AS SELECT 1;

-- Test 2: statement (line 7)
WITH cte AS (EXPORT INTO CSV 'nodelocal://1/export1/' FROM SELECT * FROM t) SELECT filename FROM cte;

-- Test 3: statement (line 10)
WITH cte AS (EXPORT INTO PARQUET 'nodelocal://1/export1/' FROM SELECT * FROM t) SELECT filename FROM cte;

-- Test 4: query (line 13)
WITH cte AS (EXPORT INTO CSV 'nodelocal://1/export1/' FROM SELECT * FROM t) SELECT filename FROM cte;

-- Test 5: statement (line 21)
CREATE TABLE t115290 (
  id INT PRIMARY KEY,
  a INT NOT NULL,
  b INT
);

-- Test 6: statement (line 28)
EXPORT INTO PARQUET 'nodelocal://1/export1/' FROM SELECT b FROM t115290 ORDER BY a;

-- Test 7: statement (line 37)
WITH cte(filename, rows, bytes) AS (
  EXPORT INTO CSV 'nodelocal://1/export1/' FROM SELECT * FROM t
)
INSERT INTO records (format, filename, rows, bytes) SELECT 'CSV', * FROM cte;

-- Test 8: statement (line 43)
WITH cte(filename, rows, bytes) AS (
  EXPORT INTO PARQUET 'nodelocal://1/export1/' FROM SELECT * FROM t
)
INSERT INTO records (format, filename, rows, bytes) SELECT 'PARQUET', * FROM cte;

