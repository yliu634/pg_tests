-- PostgreSQL compatible tests from distinct_on
-- 51 tests

-- Test 1: statement (line 1)
CREATE TABLE xyz (
  x INT,
  y INT,
  z INT,
  pk1 INT,
  pk2 INT,
  PRIMARY KEY (pk1, pk2)
)

-- Test 2: statement (line 11)
INSERT INTO xyz VALUES
  (1, 1, NULL, 1, 1),
  (1, 1, 2, 2, 2),
  (1, 1, 2, 3, 3),
  (1, 2, 1, 4, 4),
  (2, 2, 3, 5, 5),
  (4, 5, 6, 6, 6),
  (4, 1, 6, 7, 7)

-- Test 3: statement (line 29)
INSERT INTO abc VALUES
  ('1', '1', '1'),
  ('1', '1', '2'),
  ('1', '2', '2')

-- Test 4: query (line 41)
SELECT DISTINCT ON (x, y, z) x, y, z FROM xyz

-- Test 5: query (line 51)
SELECT DISTINCT ON (y, x, z) x FROM xyz

-- Test 6: query (line 61)
SELECT DISTINCT ON (z, y, x) z FROM xyz

-- Test 7: query (line 71)
SELECT DISTINCT ON (b, c, a) a, c, b FROM abc

-- Test 8: query (line 78)
SELECT DISTINCT ON (b, c, a) a FROM abc

-- Test 9: query (line 86)
SELECT DISTINCT ON (c, a, b) b FROM abc ORDER BY b

-- Test 10: query (line 96)
SELECT DISTINCT ON (x, y) y, x FROM xyz

-- Test 11: query (line 105)
SELECT DISTINCT ON (y, x) x FROM xyz

-- Test 12: query (line 114)
SELECT DISTINCT ON (x, y) y FROM xyz

-- Test 13: query (line 123)
SELECT DISTINCT ON (a, c) a, b FROM abc ORDER BY a, c, b

-- Test 14: query (line 130)
SELECT DISTINCT ON (c, a) b, c, a FROM abc ORDER BY c, a, b DESC

-- Test 15: query (line 139)
SELECT DISTINCT ON (y) y FROM xyz

-- Test 16: query (line 146)
SELECT DISTINCT ON (c) a FROM abc

-- Test 17: query (line 152)
SELECT DISTINCT ON (b) b FROM abc

-- Test 18: query (line 159)
SELECT DISTINCT ON (a) a, b, c FROM abc ORDER BY a, b, c

-- Test 19: query (line 164)
SELECT DISTINCT ON (a) a, c FROM abc ORDER BY a, c DESC, b

-- Test 20: statement (line 173)
SELECT DISTINCT ON (x) x, y, z FROM xyz ORDER BY y

-- Test 21: statement (line 176)
SELECT DISTINCT ON (y) x, y, z FROM xyz ORDER BY x, y

-- Test 22: statement (line 179)
SELECT DISTINCT ON (y, z) x, y, z FROM xyz ORDER BY x

-- Test 23: query (line 182)
SELECT DISTINCT ON (x) x FROM xyz ORDER BY x DESC

-- Test 24: query (line 191)
SELECT DISTINCT ON (x, z) y, z, x FROM xyz WHERE (x,y,z) != (4, 1, 6) ORDER BY z

-- Test 25: query (line 200)
SELECT DISTINCT ON (x) y, z, x FROM xyz ORDER BY x ASC, z DESC, y DESC

-- Test 26: query (line 209)
SELECT (SELECT DISTINCT ON (a) a FROM abc ORDER BY a, b||'foo') || 'bar';

-- Test 27: statement (line 218)
SELECT DISTINCT ON(max(x)) y FROM xyz

-- Test 28: statement (line 221)
SELECT DISTINCT ON(max(x), z) min(y) FROM xyz

-- Test 29: query (line 224)
SELECT DISTINCT ON (max(x)) min(y) FROM xyz

-- Test 30: query (line 229)
SELECT DISTINCT ON (min(x)) max(y) FROM xyz

-- Test 31: query (line 234)
SELECT DISTINCT ON(min(a), max(b), min(c)) max(c) FROM abc

-- Test 32: statement (line 243)
SELECT DISTINCT ON (x) min(x) FROM xyz GROUP BY y

-- Test 33: query (line 246)
SELECT DISTINCT ON(y) min(x) FROM xyz GROUP BY y

-- Test 34: query (line 253)
SELECT DISTINCT ON(min(x)) min(x) FROM xyz GROUP BY y HAVING min(x) = 1

-- Test 35: query (line 262)
SELECT DISTINCT ON(row_number() OVER(ORDER BY (pk1, pk2))) y FROM xyz

-- Test 36: query (line 273)
SELECT DISTINCT ON(row_number() OVER(ORDER BY (pk1, pk2))) y FROM xyz ORDER BY row_number() OVER(ORDER BY (pk1, pk2)) DESC

-- Test 37: statement (line 288)
SELECT DISTINCT ON (2) x FROM xyz

-- Test 38: query (line 291)
SELECT DISTINCT ON (1) x FROM xyz

-- Test 39: query (line 298)
SELECT DISTINCT ON (1,2,3) x, y, z FROM xyz

-- Test 40: query (line 315)
SELECT y FROM (SELECT DISTINCT ON(y) x AS y, y AS x FROM xyz)

-- Test 41: query (line 323)
SELECT DISTINCT ON(x) x AS y FROM xyz

-- Test 42: query (line 334)
SELECT DISTINCT ON(((x)), (x, y)) x, y FROM xyz

-- Test 43: query (line 348)
SELECT DISTINCT ON(pk1, pk2, x, y) x, y, z FROM xyz ORDER BY x, y

-- Test 44: query (line 363)
SELECT DISTINCT ON (x, y, z) pk1 FROM (SELECT * FROM xyz WHERE x >= 2) ORDER BY x

-- Test 45: query (line 371)
SELECT DISTINCT ON (x) x, y FROM xyz WHERE x = 1 ORDER BY x, y

-- Test 46: query (line 376)
SELECT count(*) FROM (SELECT DISTINCT ON (x) x, y FROM xyz WHERE x = 1 ORDER BY x, y)

-- Test 47: statement (line 382)
CREATE TABLE author (
  id INT PRIMARY KEY,
  name TEXT,
  genre TEXT
);
INSERT INTO author VALUES
  (1, 'Alice', 'Action'),
  (2, 'Bob', 'Biography'),
  (3, 'Carol', 'Crime'),
  (4, 'Dave', 'Action'),
  (5, 'Eve', 'Crime'),
  (6, 'Bart', null);

-- Test 48: query (line 396)
SELECT
  DISTINCT ON ("genre") genre
FROM
  "public"."author"
ORDER BY
  "genre" ASC NULLS LAST

-- Test 49: statement (line 410)
CREATE TABLE t1 (id int, str text);
CREATE TABLE t2 (id int, num int);
INSERT INTO t1 VALUES (1, 'hello'), (2, NULL);
INSERT INTO t2 VALUES (1, 1), (2, 2), (NULL, NULL)

-- Test 50: query (line 416)
SELECT
DISTINCT ON (t2.id)
t2.*
FROM t1, t2
ORDER BY t2.id DESC NULLS FIRST

-- Test 51: query (line 427)
SELECT
DISTINCT ON (t2.id)
t2.*
FROM t1, t2
ORDER BY t2.id ASC NULLS LAST

