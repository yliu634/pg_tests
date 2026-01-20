-- PostgreSQL compatible tests from hash_join
-- 40 tests

-- Test 1: statement (line 1)
CREATE TABLE  t1 (k INT PRIMARY KEY, v INT)

-- Test 2: statement (line 4)
INSERT INTO t1 VALUES (0, 4), (2, 1), (5, 4), (3, 4), (-1, -1)

-- Test 3: statement (line 7)
CREATE TABLE t2 (x INT PRIMARY KEY, y INT)

-- Test 4: statement (line 10)
INSERT INTO t2 VALUES (1, 3), (4, 6), (0, 5), (3, 2)

-- Test 5: statement (line 13)
CREATE TABLE a (k INT, v INT)

-- Test 6: statement (line 16)
INSERT INTO a VALUES (0, 1), (1, 2), (2, 0)

-- Test 7: statement (line 22)
INSERT INTO b VALUES (0, 1, 'a'), (2, 1, 'b'), (0, 2, 'c'), (0, 1, 'd')

-- Test 8: statement (line 28)
INSERT INTO c VALUES (1, 'a'), (1, 'b'), (2, 'c')

-- Test 9: query (line 31)
SELECT * FROM t1 INNER HASH JOIN t2 ON t1.k = t2.x ORDER BY 1

-- Test 10: query (line 37)
SELECT * FROM a AS a1 JOIN a AS a2 ON a1.k = a2.v ORDER BY 1

-- Test 11: query (line 44)
SELECT * FROM a AS a2 JOIN a AS a1 ON a1.k = a2.v ORDER BY 1

-- Test 12: query (line 51)
SELECT t2.y, t1.v FROM t1 INNER HASH JOIN t2 ON t1.k = t2.x ORDER BY 1 DESC

-- Test 13: query (line 57)
SELECT * FROM t1 JOIN t2 ON t1.v = t2.x ORDER BY 1

-- Test 14: query (line 65)
SELECT * FROM t1 LEFT JOIN t2 ON t1.v = t2.x ORDER BY 1

-- Test 15: query (line 74)
SELECT * FROM t1 RIGHT JOIN t2 ON t1.v = t2.x

-- Test 16: query (line 84)
SELECT * FROM t1 FULL JOIN t2 ON t1.v = t2.x

-- Test 17: query (line 95)
SELECT b.a, b.b, b.c FROM b JOIN a ON b.a = a.k AND a.v = b.b ORDER BY 3

-- Test 18: query (line 101)
SELECT b.a, b.c, c.a FROM b JOIN c ON b.b = c.a AND b.c = c.b ORDER BY 2

-- Test 19: statement (line 109)
CREATE TABLE empty (x INT)

-- Test 20: statement (line 112)
CREATE TABLE onecolumn (x INT); INSERT INTO onecolumn(x) VALUES (44), (NULL), (42)

-- Test 21: query (line 115)
SELECT * FROM empty AS a(x) FULL OUTER JOIN onecolumn AS b(y) ON a.x = b.y ORDER BY b.y

-- Test 22: statement (line 124)
CREATE TABLE t41407 AS
	SELECT
		g AS _float8,
		g % 0 = 0 AS _bool,
		g AS _decimal,
		g AS _string,
		g AS _bytes
	FROM
		generate_series(NULL, NULL) AS g;

-- Test 23: query (line 135)
SELECT
  tab_1688._bytes,
  tab_1688._float8,
  tab_1689._string,
  tab_1689._string,
  tab_1688._float8,
  tab_1688._float8,
  tab_1689._bool,
  tab_1690._decimal
FROM
  t41407 AS tab_1688
  JOIN t41407 AS tab_1689
    JOIN t41407 AS tab_1690 ON
        tab_1689._bool = tab_1690._bool ON
      tab_1688._float8 = tab_1690._float8
      AND tab_1688._bool = tab_1689._bool;

-- Test 24: statement (line 156)
CREATE TABLE t44207_0(c0 INT UNIQUE); CREATE TABLE t44207_1(c0 INT)

-- Test 25: statement (line 159)
INSERT INTO t44207_0(c0) VALUES (NULL), (NULL); INSERT INTO t44207_1(c0) VALUES (0)

-- Test 26: query (line 162)
SELECT * FROM t44207_0, t44207_1 WHERE t44207_0.c0 IS NULL

-- Test 27: statement (line 170)
CREATE TABLE t44547_0(c0 INT4); CREATE TABLE t44547_1(c0 INT8)

-- Test 28: statement (line 173)
INSERT INTO t44547_0(c0) VALUES(0); INSERT INTO t44547_1(c0) VALUES(0)

-- Test 29: query (line 177)
SELECT * FROM t44547_0 NATURAL JOIN t44547_1

-- Test 30: statement (line 182)
CREATE TABLE t44797_0(a FLOAT, b DECIMAL); CREATE TABLE t44797_1(c INT2, d INT4)

-- Test 31: statement (line 185)
INSERT INTO t44797_0 VALUES (1.0, 1.0), (2.0, 2.0); INSERT INTO t44797_1 VALUES (1, 1), (2, 2)

-- Test 32: query (line 190)
SELECT * FROM t44797_0 NATURAL JOIN t44797_1

-- Test 33: statement (line 198)
CREATE TABLE t44797_2(a FLOAT); CREATE TABLE t44797_3(b DECIMAL)

-- Test 34: statement (line 201)
INSERT INTO t44797_2 VALUES (1.0), (2.0); INSERT INTO t44797_3 VALUES (1.0), (2.0)

-- Test 35: query (line 204)
SELECT * FROM t44797_2 NATURAL JOIN t44797_3

-- Test 36: query (line 214)
SELECT * FROM t44797_2 WHERE EXISTS (SELECT * FROM t44797_2 AS l, t44797_3 AS r WHERE l.a = r.b)

-- Test 37: statement (line 221)
CREATE TABLE table57696(col_table TIME NOT NULL)

-- Test 38: statement (line 226)
SET distsql_workmem = '64MiB';

-- Test 39: statement (line 229)
WITH cte (col_cte) AS ( SELECT * FROM ( VALUES ( ( 'false':::JSONB, '1970-01-05 16:57:40.000665+00:00':::TIMESTAMPTZ ) ) ) EXCEPT ALL SELECT * FROM ( VALUES ( ( ' [ [[true], [], {}, "b", {}], {"a": []}, {"c": 2.05750813403415} ] ':::JSONB, '1970-01-10 05:23:26.000428+00:00':::TIMESTAMPTZ ) ) ) ) SELECT * FROM cte, table57696

-- Test 40: statement (line 232)
RESET distsql_workmem;

