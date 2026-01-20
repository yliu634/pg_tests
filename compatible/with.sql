-- PostgreSQL compatible tests from with
-- 138 tests

-- Test 1: statement (line 1)
CREATE TABLE x(a) AS SELECT generate_series(1, 3)

-- Test 2: statement (line 4)
CREATE TABLE y(a) AS SELECT generate_series(2, 4)

-- Test 3: query (line 7)
WITH t AS (SELECT a FROM y WHERE a < 3)
  SELECT * FROM x NATURAL JOIN t

-- Test 4: query (line 13)
WITH t AS (SELECT * FROM y WHERE a < 3)
  SELECT * FROM x NATURAL JOIN t

-- Test 5: query (line 20)
WITH t(x) AS (SELECT a FROM x)
  SELECT * FROM y WHERE a IN (SELECT x FROM t)

-- Test 6: query (line 28)
SELECT * FROM x WHERE a IN
  (WITH t AS (SELECT * FROM y WHERE a < 3) SELECT * FROM t)

-- Test 7: query (line 35)
WITH t(b) AS (SELECT a FROM x) SELECT b, t.b FROM t

-- Test 8: query (line 42)
WITH t(a, b) AS (SELECT true a, false b)
  SELECT a, b FROM t

-- Test 9: query (line 48)
WITH t(b, a) AS (SELECT true a, false b)
  SELECT a, b FROM t

-- Test 10: statement (line 54)
SELECT (WITH foo AS (INSERT INTO y VALUES (1) RETURNING *) SELECT * FROM foo)

-- Test 11: statement (line 57)
WITH
    t AS (SELECT true),
    t AS (SELECT false)
SELECT * FROM t

-- Test 12: query (line 63)
WITH t(b, c) AS (SELECT a FROM x) SELECT b, t.b FROM t

-- # Ensure you can't reference the original table name
-- query error no data source matches prefix: x
WITH t AS (SELECT a FROM x) SELECT a, x.t FROM t

-- # Nested WITH, name shadowing
-- query I
WITH t(x) AS (WITH t(x) AS (SELECT 1) SELECT x * 10 FROM t) SELECT x + 2 FROM t

-- Test 13: query (line 78)
WITH t AS (SELECT * FROM x) INSERT INTO t VALUES (1)

-- query I rowsort
WITH t AS (SELECT a FROM x) INSERT INTO x SELECT a + 20 FROM t RETURNING *

-- Test 14: query (line 88)
SELECT * from x

-- Test 15: query (line 98)
WITH t AS (
    UPDATE x SET a = a * 100 RETURNING a
)
SELECT * FROM t

-- Test 16: query (line 111)
SELECT * from x

-- Test 17: query (line 121)
WITH t AS (
    DELETE FROM x RETURNING a
)
SELECT * FROM t

-- Test 18: query (line 134)
SELECT * from x

-- Test 19: query (line 139)
WITH t AS (
    INSERT INTO x(a) VALUES(0)
)
SELECT * FROM t

-- # however if there are no side effects, no errors are required.
-- query I
WITH t AS (SELECT 1) SELECT 2

-- Test 20: statement (line 153)
CREATE TABLE a(x INT);

-- Test 21: statement (line 156)
INSERT INTO a(x)
        (WITH b(z) AS (VALUES (1),(2),(3)) SELECT z+1 AS w FROM b)

-- Test 22: statement (line 160)
INSERT INTO a(x)
      (WITH a(z) AS (VALUES (1)) SELECT z+1 AS w FROM a);

-- Test 23: query (line 165)
(WITH woo AS (VALUES (1))
    (WITH waa AS (VALUES (2))
	   TABLE waa))


-- # When #24303 is fixed, the following query should fail with
-- # error "no such relation woo".
-- query error unimplemented: multiple WITH clauses in parentheses
(WITH woo AS (VALUES (1))
    (WITH waa AS (VALUES (2))
	   TABLE woo))

-- statement ok
CREATE TABLE lim(x) AS SELECT 0

-- # This is an oddity in PostgreSQL: even though the WITH clause
-- # occurs in the inside parentheses, the scope of the alias `lim`
-- # extends to the outer parentheses.
-- query I
((WITH lim(x) AS (SELECT 1) SELECT 123)
 LIMIT (
    SELECT x FROM lim -- intuitively this should refer to the real table lim defined above
                      -- and use LIMIT 0;
                      -- however, postgres flattens the inner WITH and outer LIMIT
                      -- at the same scope so the limit becomes 1.
 ))

-- Test 24: statement (line 196)
DROP TABLE lim

-- Test 25: query (line 199)
((WITH lim(x) AS (SELECT 1) SELECT 123) LIMIT (SELECT x FROM lim))

-- Test 26: statement (line 206)
CREATE TABLE ab (a INT PRIMARY KEY, b INT)

-- Test 27: statement (line 209)
INSERT INTO ab VALUES (1, 2), (3, 4), (5, 6)

-- Test 28: query (line 212)
WITH a AS (SELECT a FROM ab ORDER BY b) SELECT * FROM a

-- Test 29: statement (line 219)
CREATE TABLE x2(a) AS SELECT generate_series(1, 3)

-- Test 30: statement (line 222)
CREATE TABLE y2(b) AS SELECT generate_series(2, 4)

-- Test 31: query (line 226)
WITH t AS (SELECT b FROM y2) SELECT * FROM t JOIN t AS q ON true

-- Test 32: query (line 239)
WITH
    one AS (SELECT a AS u FROM x2),
    two AS (SELECT b AS v FROM (SELECT b FROM y2 UNION ALL SELECT u FROM one))
SELECT
    *
FROM
    one JOIN two ON u = v

-- Test 33: statement (line 255)
CREATE TABLE z (c INT PRIMARY KEY);

-- Test 34: query (line 258)
WITH foo AS (INSERT INTO z VALUES (10) RETURNING 1) SELECT 2

-- Test 35: query (line 263)
SELECT * FROM z

-- Test 36: query (line 268)
WITH foo AS (UPDATE z SET c = 20 RETURNING 1) SELECT 3

-- Test 37: query (line 273)
SELECT * FROM z

-- Test 38: query (line 278)
WITH foo AS (DELETE FROM z RETURNING 1) SELECT 4

-- Test 39: query (line 283)
SELECT count(*) FROM z

-- Test 40: statement (line 290)
CREATE TABLE engineer (
    fellow BOOL NOT NULL, id INT4 NOT NULL, companyname VARCHAR(255) NOT NULL,
    PRIMARY KEY (id, companyname)
)

-- Test 41: statement (line 296)
PREPARE x (INT4, VARCHAR, INT4, VARCHAR) AS
  WITH ht_engineer (id, companyname) AS (
    SELECT id, companyname FROM (VALUES ($1, $2), ($3, $4)) AS ht (id, companyname)
  )
DELETE FROM engineer WHERE (id, companyname) IN (SELECT id, companyname FROM ht_engineer)

-- Test 42: statement (line 303)
EXECUTE x (1, 'fo', 2, 'bar')

-- Test 43: statement (line 306)
PREPARE z(int) AS WITH foo AS (SELECT * FROM x2 WHERE a = $1) SELECT * FROM foo

-- Test 44: query (line 309)
EXECUTE z(1)

-- Test 45: query (line 314)
EXECUTE z(2)

-- Test 46: query (line 319)
EXECUTE z(3)

-- Test 47: statement (line 326)
PREPARE z2(int) AS WITH foo AS (SELECT * FROM x WHERE a = $1) SELECT * FROM x2 ORDER BY a

-- Test 48: query (line 329)
EXECUTE z2(1)

-- Test 49: statement (line 336)
PREPARE z3(int) AS WITH foo AS (SELECT $1) SELECT * FROM foo

-- Test 50: query (line 339)
EXECUTE z3(3)

-- Test 51: statement (line 344)
PREPARE z4(int) AS WITH foo AS (SELECT $1), bar AS (SELECT * FROM foo) SELECT * FROM bar

-- Test 52: query (line 347)
EXECUTE z4(3)

-- Test 53: statement (line 352)
PREPARE z5(int, int) AS WITH foo AS (SELECT $1), bar AS (SELECT $2) (SELECT * FROM foo) UNION ALL (SELECT * FROM bar)

-- Test 54: query (line 355)
EXECUTE z5(3, 5)

-- Test 55: statement (line 361)
PREPARE z6(int) AS
    SELECT * FROM
    (VALUES (1), (2)) v(x),
    LATERAL (SELECT * FROM
      (WITH foo AS (SELECT $1 + x) SELECT * FROM foo)
    )

-- Test 56: query (line 369)
EXECUTE z6(3)

-- Test 57: query (line 376)
WITH RECURSIVE t(n) AS (
    VALUES (1)
  UNION ALL
    SELECT n+1 FROM t WHERE n < 100
)
SELECT sum(n) FROM t

-- Test 58: query (line 388)
WITH RECURSIVE t(n) AS (
    VALUES (1)
  UNION
    SELECT n+y FROM t, (VALUES (1), (2)) AS v(y) WHERE n < 99
)
SELECT sum(n) FROM t

-- Test 59: query (line 399)
WITH RECURSIVE cte(a, b) AS (
    SELECT 0, 0
  UNION ALL
    SELECT a+1, b+10 FROM cte WHERE a < 5
) SELECT * FROM cte;

-- Test 60: query (line 414)
WITH RECURSIVE cte(a, b) AS (
    SELECT 0, 1
  UNION ALL
    SELECT a+1, a+1 FROM cte WHERE a < 5
) SELECT * FROM cte;

-- Test 61: query (line 430)
WITH RECURSIVE points AS (
  SELECT i::float * 0.05 AS r, j::float * 0.05 AS c
  FROM generate_series(-20, 20) AS a (i), generate_series(-40, 20) AS b (j)
), iterations AS (
     SELECT r,
            c,
            0.0::float AS zr,
            0.0::float AS zc,
            0 AS iteration
     FROM points
   UNION ALL
     SELECT r,
            c,
            zr*zr - zc*zc + c AS zr,
            2*zr*zc + r AS zc,
            iteration+1 AS iteration
     FROM iterations WHERE zr*zr + zc*zc < 4 AND iteration < 20
), final_iteration AS (
  SELECT * FROM iterations WHERE iteration = 20
), marked_points AS (
   SELECT r,
          c,
          (CASE WHEN EXISTS (SELECT 1 FROM final_iteration i WHERE p.r = i.r AND p.c = i.c)
                THEN 'oo' ELSE '··' END) AS marker FROM points p
), lines AS (
   SELECT r, string_agg(marker, '' ORDER BY c ASC) AS r_text
   FROM marked_points
   GROUP BY r
) SELECT string_agg(r_text, E'\n' ORDER BY r DESC) FROM lines

-- Test 62: query (line 503)
WITH RECURSIVE points AS (
  SELECT i::float * 0.05 AS r, j::float * 0.05 AS c
  FROM generate_series(-20, 20) AS a (i), generate_series(-30, 30) AS b (j)
), iterations AS (
   SELECT r, c, c::float AS zr, r::float AS zc, 0 AS iteration FROM points
   UNION ALL
   SELECT r, c, zr*zr - zc*zc + 1 - 1.61803398875 AS zr, 2*zr*zc AS zc, iteration+1 AS iteration
   FROM iterations WHERE zr*zr + zc*zc < 4 AND iteration < 20
), final_iteration AS (
  SELECT * FROM iterations WHERE iteration = 20
), marked_points AS (
   SELECT r, c, (CASE WHEN EXISTS (SELECT 1 FROM final_iteration i WHERE p.r = i.r AND p.c = i.c)
                  THEN 'oo'
                  ELSE '··'
                  END) AS marker
   FROM points p
), rows AS (
   SELECT r, string_agg(marker, '' ORDER BY c ASC) AS r_text
   FROM marked_points
   GROUP BY r
) SELECT string_agg(r_text, E'\n' ORDER BY r DESC) FROM rows

-- Test 63: query (line 569)
WITH RECURSIVE cte(a, b) AS (
    VALUES (2, 2), (1, 1), (1, 2), (1, 1), (1, 3), (1, 2), (2, 2)
  UNION
    SELECT a+10, b+10 FROM cte WHERE a < 20
) SELECT * FROM cte;

-- Test 64: query (line 590)
WITH RECURSIVE cte(a, b) AS (
    VALUES (1, 1), (1, 2), (2, 2)
  UNION
    SELECT 4-a, 4-a FROM cte
) SELECT * FROM cte;

-- Test 65: query (line 603)
WITH RECURSIVE cte(a, b) AS (
    VALUES (1, 1), (1, 2), (2, 2)
  UNION
    SELECT (a+i) % 4, (b+1-i) % 4 FROM cte, (VALUES (0), (1)) AS v(i)
) SELECT * FROM cte;

-- Test 66: query (line 629)
WITH RECURSIVE x(a) AS (
    VALUES ('a'), ('b')
  UNION ALL
    (WITH z AS (SELECT * FROM x)
      SELECT z.a || z1.a AS a FROM z CROSS JOIN z AS z1 WHERE length(z.a) < 3
    )
)
SELECT * FROM x

-- Test 67: statement (line 663)
PREPARE
  ctestmt
AS
  (WITH RECURSIVE cte (x) AS (VALUES (1) UNION ALL SELECT x + $1 FROM cte WHERE x < 50) SELECT * FROM cte)

-- Test 68: query (line 669)
EXECUTE ctestmt (10)

-- Test 69: statement (line 680)
DROP TABLE IF EXISTS ab

-- Test 70: statement (line 683)
CREATE TABLE ab (a INT PRIMARY KEY, b INT)

-- Test 71: statement (line 686)
INSERT INTO ab VALUES (1,1)

-- Test 72: query (line 689)
WITH
  cte1 AS MATERIALIZED (SELECT a FROM ab WHERE a = b)
SELECT * FROM
  (
    WITH RECURSIVE
      cte2 (x) AS (SELECT 1 UNION ALL SELECT x + a FROM cte2, cte1 WHERE x < 10)
    SELECT * FROM cte2
  )

-- Test 73: statement (line 711)
CREATE TABLE xy (x INT, y INT);
INSERT INTO xy VALUES (1,1),(1,2),(2,1),(2,2);

-- Test 74: query (line 715)
WITH cte AS (SELECT x*10+y FROM xy ORDER BY x+y LIMIT 3) SELECT * FROM cte

-- Test 75: statement (line 723)
CREATE TABLE graph_node (
  id VARCHAR(16) PRIMARY KEY,
  parent VARCHAR(16)
)

-- Test 76: statement (line 729)
INSERT INTO graph_node (id, parent) VALUES
  ('A', null),
  ('B', 'A'),
  ('C', 'B'),
  ('D', 'C')

-- Test 77: query (line 737)
WITH RECURSIVE nodes AS (
  SELECT 'A' AS id
  UNION ALL
  SELECT graph_node.id FROM graph_node JOIN nodes ON graph_node.parent = nodes.id
)
SELECT * FROM nodes

-- # The recursive query seed column types must match the output columns types.
-- query error pgcode 42804 recursive query \"foo\" column 1 has type int in non-recursive term but type decimal overall
WITH RECURSIVE foo(i) AS
    (SELECT i FROM (VALUES(1),(2)) t(i)
    UNION ALL
    SELECT (i+1)::numeric(10,0) FROM foo WHERE i < 10)
SELECT * FROM foo

-- # Tests with correlated CTEs.
-- statement ok
INSERT INTO x SELECT generate_series(1, 3)

-- query II rowsort
SELECT y.a, (
  WITH foo AS MATERIALIZED (SELECT x.a FROM x WHERE x.a = y.a)
  SELECT * FROM foo
) FROM y

-- Test 78: query (line 767)
SELECT * FROM
  (VALUES (1), (2), (10)) AS v(x),
  LATERAL (WITH foo AS MATERIALIZED (SELECT a FROM y WHERE y.a <= x) SELECT * FROM foo)

-- Test 79: statement (line 782)
CREATE TABLE r (i INT PRIMARY KEY);
CREATE TABLE s (i INT PRIMARY KEY);
INSERT INTO r VALUES (0)

-- Test 80: query (line 788)
WITH
  t AS (INSERT INTO r VALUES (1) RETURNING i),
  u AS (INSERT INTO s SELECT * FROM r RETURNING i)
SELECT i FROM s

-- Test 81: query (line 795)
SELECT i FROM r

-- Test 82: query (line 801)
SELECT i FROM s

-- Test 83: query (line 807)
WITH
  t AS (DELETE FROM r WHERE i IN (SELECT i FROM s) RETURNING i),
  u AS (DELETE FROM s WHERE i IN (SELECT i FROM t) RETURNING i)
SELECT i FROM r WHERE i IN (SELECT i FROM s)

-- Test 84: query (line 815)
SELECT i FROM r

-- Test 85: query (line 820)
SELECT i FROM s

-- Test 86: query (line 827)
WITH
  t AS (UPSERT INTO r VALUES (0), (1) RETURNING i),
  u AS (UPSERT INTO s SELECT * FROM t RETURNING i)
SELECT i FROM r UNION ALL SELECT i FROM t

-- Test 87: query (line 837)
SELECT i FROM r

-- Test 88: query (line 843)
SELECT i FROM s

-- Test 89: query (line 850)
WITH
  t AS (UPDATE r SET i = i + 2 RETURNING i),
  u AS (UPDATE s SET i = -r.i FROM r WHERE s.i < r.i RETURNING s.i)
SELECT i FROM u

-- Test 90: query (line 858)
SELECT i FROM r

-- Test 91: query (line 864)
SELECT i FROM s

-- Test 92: query (line 872)
WITH
  t AS (INSERT INTO r SELECT i FROM s ON CONFLICT (i) DO UPDATE SET i = r.i + 2 RETURNING r.i),
  u AS (INSERT INTO s SELECT i FROM t ON CONFLICT (i) DO UPDATE SET i = s.i - 2 RETURNING s.i)
SELECT * FROM r, u

-- Test 93: query (line 883)
SELECT i FROM r

-- Test 94: query (line 891)
SELECT i FROM s

-- Test 95: statement (line 901)
CREATE TABLE t (i INT PRIMARY KEY, j INT, INDEX (j));
INSERT INTO t VALUES (0, 0)

-- Test 96: query (line 906)
WITH
  u AS (INSERT INTO t VALUES (1, 1) RETURNING *)
INSERT INTO t SELECT i + 1, j + 1 FROM u RETURNING *

-- Test 97: query (line 913)
SELECT * FROM t

-- Test 98: statement (line 924)
SET CLUSTER SETTING sql.multiple_modifications_of_table.enabled = true

-- Test 99: query (line 929)
WITH
  u AS (DELETE FROM t WHERE i = 0 RETURNING *)
DELETE FROM t WHERE i IN (SELECT i + 1 FROM u) RETURNING *

-- Test 100: query (line 936)
SELECT * FROM t

-- Test 101: query (line 943)
WITH
  u AS (UPSERT INTO t VALUES (2, 3), (4, 5) RETURNING *)
UPSERT INTO t SELECT i + 4, j + 4 FROM u RETURNING *

-- Test 102: query (line 951)
SELECT * FROM t

-- Test 103: query (line 961)
WITH
  u AS (UPDATE t SET j = j + 1 WHERE i = 2 RETURNING *)
UPDATE t SET j = 99 FROM u WHERE t.i != u.i RETURNING *

-- Test 104: query (line 970)
SELECT * FROM t

-- Test 105: query (line 980)
WITH
  u AS (INSERT INTO t SELECT i, j - 1 FROM t ON CONFLICT (i) DO UPDATE SET j = 100 RETURNING *)
INSERT INTO t SELECT sum_int(i), sum_int(j) FROM u ON CONFLICT (i) DO UPDATE SET j = 1 RETURNING *

-- Test 106: query (line 987)
SELECT * FROM t

-- Test 107: statement (line 996)
RESET CLUSTER SETTING sql.multiple_modifications_of_table.enabled

-- Test 108: statement (line 1000)
SET enable_multiple_modifications_of_table = true

-- Test 109: query (line 1004)
WITH
  u1 AS (UPDATE t SET j = j - 40 WHERE i < 20 RETURNING *),
  u2 AS (UPDATE t SET j = j + 40 WHERE i >= 20 RETURNING *)
TABLE u1 UNION ALL TABLE u2

-- Test 110: statement (line 1016)
RESET enable_multiple_modifications_of_table

-- Test 111: statement (line 1023)
CREATE TABLE u (i INT PRIMARY KEY, j INT, INDEX (j));
INSERT INTO u VALUES (0, 0)

-- Test 112: query (line 1028)
WITH
  v AS (INSERT INTO u VALUES (1, 1) RETURNING *)
INSERT INTO u SELECT * FROM v

-- query II
SELECT i, j FROM u@u_pkey

-- Test 113: query (line 1038)
SELECT i, j FROM u@u_j_idx

-- Test 114: query (line 1045)
WITH
  v AS (UPSERT INTO u VALUES (0, 1) RETURNING *),
  w AS (UPSERT INTO u SELECT i, j + 1 FROM v RETURNING *)
SELECT * FROM w

-- query II
SELECT i, j FROM u@u_pkey

-- Test 115: query (line 1056)
SELECT i, j FROM u@u_j_idx

-- Test 116: query (line 1064)
WITH
  v AS (UPDATE u SET j = 3 WHERE i = 0 RETURNING *),
  w AS (UPDATE u SET j = 4 WHERE i = 0 RETURNING *)
SELECT * FROM u

-- query II
SELECT i, j FROM u@u_pkey

-- Test 117: query (line 1075)
SELECT i, j FROM u@u_j_idx

-- Test 118: query (line 1083)
WITH
  v AS (UPDATE u SET j = 5 WHERE i = 0 RETURNING *),
  w AS (UPDATE u SET j = v.j + 1 FROM v WHERE u.i = v.i RETURNING *)
SELECT * FROM w

-- query II
SELECT i, j FROM u@u_pkey

-- Test 119: query (line 1094)
SELECT i, j FROM u@u_j_idx

-- Test 120: query (line 1101)
WITH
  v AS (INSERT INTO u VALUES (0, 42), (1, 42) ON CONFLICT (i) DO UPDATE SET j = 52 RETURNING *)
INSERT INTO u SELECT i, j + 1 FROM v ON CONFLICT (i) DO UPDATE SET j = v.j + 100 RETURNING *

-- query II
SELECT i, j FROM u@u_pkey

-- Test 121: query (line 1111)
SELECT i, j FROM u@u_j_idx

-- Test 122: query (line 1118)
WITH
  v AS (DELETE FROM u ORDER BY i LIMIT 1 RETURNING *),
  w AS (DELETE FROM u ORDER BY i LIMIT 2 RETURNING *)
SELECT * FROM w

-- query II
SELECT i, j FROM u@u_pkey

-- Test 123: query (line 1129)
SELECT i, j FROM u@u_j_idx

-- Test 124: statement (line 1136)
CREATE TABLE ints (n BIGINT, INDEX (n));

-- Test 125: statement (line 1139)
INSERT INTO ints
VALUES (1), (1), (1), (2), (4), (4), (4), (4), (5), (5),
  (6), (7), (7), (7), (8), (9), (9), (9), (9), (9);

-- Test 126: query (line 1144)
WITH RECURSIVE temp (i) AS (
  (SELECT n FROM ints ORDER BY n ASC LIMIT 1)
UNION ALL (
  SELECT n FROM temp,
    LATERAL (
      SELECT n
      FROM ints
      WHERE n > i
      ORDER BY n ASC
      LIMIT 1
    ) sub
  )
)
SELECT count(*) FROM temp;

-- Test 127: query (line 1162)
WITH RECURSIVE temp (i) AS (
  (SELECT n FROM ints ORDER BY n ASC LIMIT 1)
UNION ALL (
  SELECT n FROM temp,
    LATERAL (
      SELECT n
      FROM ints
      WHERE n > i
      ORDER BY n ASC
      LIMIT 1
    ) sub
  )
)
SELECT * FROM temp;

-- Test 128: query (line 1188)
WITH RECURSIVE temp (i) AS (
  (SELECT n FROM ints ORDER BY n ASC LIMIT 1)
UNION ALL (
  SELECT n FROM temp,
    LATERAL (
      SELECT n
      FROM ints
      WHERE n > i
      ORDER BY n ASC
      LIMIT 1
    ) sub LIMIT 1
  )
)
SELECT count(*) FROM temp;

-- Test 129: query (line 1206)
WITH RECURSIVE temp (i) AS (
  (SELECT n FROM ints ORDER BY n ASC LIMIT 1)
UNION ALL (
  SELECT n FROM temp,
    LATERAL (
      SELECT n
      FROM ints
      WHERE n > i
      ORDER BY n ASC
      LIMIT 1
    ) sub LIMIT 1
  )
)
SELECT * FROM temp;

-- Test 130: statement (line 1233)
CREATE TABLE t95360 (a INT, b INT)

-- Test 131: statement (line 1239)
WITH insVals AS NOT MATERIALIZED (INSERT INTO t95360 VALUES (1, 10) RETURNING a)
SELECT * FROM (VALUES (1), (2), (3)) v(a)
WHERE EXISTS (SELECT * FROM insVals WHERE a = v.a UNION ALL SELECT a FROM (VALUES (4)) w(a) WHERE a = v.a)

-- Test 132: query (line 1244)
SELECT * FROM t95360

-- Test 133: query (line 1251)
WITH RECURSIVE
   x(id) AS
     (SELECT 1 UNION ALL SELECT id+1 FROM x WHERE id < 3 ),
   y(id) AS
     (SELECT * FROM x UNION ALL SELECT * FROM x)
 SELECT * FROM y

-- Test 134: statement (line 1266)
CREATE TABLE t93370 (i INT);
INSERT INTO t93370 VALUES (1), (2), (3)

-- Test 135: query (line 1270)
WITH RECURSIVE
   y(id) AS (SELECT * FROM t93370 UNION ALL SELECT * FROM t93370)
 SELECT * FROM y

-- Test 136: statement (line 1283)
CREATE TABLE t100561a (a INT);
CREATE TABLE t100561b (k INT PRIMARY KEY, b INT);
INSERT INTO t100561b VALUES (1, NULL)

-- Test 137: query (line 1289)
SELECT t3.c2, t3.c1 FROM (
  SELECT t2.b AS c1, t2.k AS c2 FROM t100561a t1 FULL OUTER JOIN t100561b t2 ON true
) AS t3, t100561b t2
WHERE t3.c2 = t2.k

-- Test 138: query (line 1299)
WITH t3(c1, c2) AS (
  SELECT t2.b AS c1, t2.k AS c2 FROM t100561a t1 FULL OUTER JOIN t100561b t2 ON true
)
SELECT t3.c2, t3.c1 FROM t3, t100561b t2
WHERE t3.c2 = t2.k

