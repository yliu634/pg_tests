-- PostgreSQL compatible tests from distsql_enum
-- 8 tests

-- Test 1: statement (line 4)
CREATE TYPE greeting AS ENUM ('hello')

-- Test 2: statement (line 7)
CREATE TABLE IF NOT EXISTS seed AS
	SELECT
		enum_range('hello'::greeting)[g] as _enum
	FROM
		generate_series(1, 1) AS g

-- Test 3: query (line 14)
WITH w (col)
				AS (
					SELECT
						*
					FROM
						(
							VALUES
								(
									((('hello':::greeting, 0), 0))
								)
						)
				)
		SELECT
			seed._enum, w.col
		FROM
			w, seed

-- Test 4: statement (line 35)
CREATE TABLE t1 (x INT PRIMARY KEY, y greeting); INSERT INTO t1(x, y) VALUES (0,'hello');
CREATE TABLE t2 (x INT PRIMARY KEY, y greeting); INSERT INTO t2(x, y) VALUES (0,'hello');

-- Test 5: statement (line 73)
SET direct_columnar_scans_enabled = false

-- Test 6: query (line 77)
EXPLAIN (VEC)
SELECT t1.x from t1 INNER LOOKUP JOIN t2 ON t1.x=t2.x WHERE t2.y='hello'

-- Test 7: query (line 97)
SELECT t1.x from t1 INNER LOOKUP JOIN t2 ON t1.x=t2.x WHERE t2.y='hello'

-- Test 8: statement (line 102)
RESET direct_columnar_scans_enabled

