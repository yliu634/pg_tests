-- PostgreSQL compatible tests from join
-- 170 tests

-- Test 1: statement (line 7)
CREATE TABLE onecolumn (x INT); INSERT INTO onecolumn(x) VALUES (44), (NULL), (42)

-- Test 2: query (line 10)
SELECT * FROM onecolumn AS a(x) CROSS JOIN onecolumn AS b(y)

-- Test 3: query (line 25)
SELECT x FROM onecolumn AS a, onecolumn AS b

query II colnames,rowsort
SELECT * FROM onecolumn AS a(x) JOIN onecolumn AS b(y) ON a.x = b.y

-- Test 4: query (line 35)
SELECT * FROM onecolumn AS a JOIN onecolumn as b USING(x) ORDER BY x

-- Test 5: query (line 42)
SELECT * FROM onecolumn AS a NATURAL JOIN onecolumn as b

-- Test 6: query (line 49)
SELECT * FROM onecolumn AS a(x) LEFT OUTER JOIN onecolumn AS b(y) ON a.x = b.y

-- Test 7: query (line 57)
SELECT * FROM onecolumn AS a LEFT OUTER JOIN onecolumn AS b USING(x) ORDER BY x

-- Test 8: query (line 67)
SELECT * FROM onecolumn AS a, onecolumn AS b ORDER BY x

query I colnames,rowsort
SELECT * FROM onecolumn AS a NATURAL LEFT OUTER JOIN onecolumn AS b

-- Test 9: query (line 78)
SELECT * FROM onecolumn AS a(x) RIGHT OUTER JOIN onecolumn AS b(y) ON a.x = b.y

-- Test 10: query (line 86)
SELECT * FROM onecolumn AS a RIGHT OUTER JOIN onecolumn AS b USING(x) ORDER BY x

-- Test 11: query (line 94)
SELECT * FROM onecolumn AS a NATURAL RIGHT OUTER JOIN onecolumn AS b

-- Test 12: statement (line 102)
CREATE TABLE onecolumn_w(w INT); INSERT INTO onecolumn_w(w) VALUES (42),(43)

-- Test 13: query (line 105)
SELECT * FROM onecolumn AS a NATURAL JOIN onecolumn_w as b

-- Test 14: statement (line 116)
CREATE TABLE othercolumn (x INT); INSERT INTO othercolumn(x) VALUES (43),(42),(16)

-- Test 15: query (line 119)
SELECT * FROM onecolumn AS a FULL OUTER JOIN othercolumn AS b ON a.x = b.x ORDER BY a.x,b.x

-- Test 16: query (line 129)
SELECT * FROM onecolumn AS a FULL OUTER JOIN othercolumn AS b USING(x) ORDER BY x

-- Test 17: query (line 141)
SELECT x AS s, a.x, b.x FROM onecolumn AS a FULL OUTER JOIN othercolumn AS b USING(x) ORDER BY s

-- Test 18: query (line 151)
SELECT * FROM onecolumn AS a NATURAL FULL OUTER JOIN othercolumn AS b ORDER BY x

-- Test 19: query (line 163)
SELECT * FROM (SELECT x FROM onecolumn ORDER BY x DESC) NATURAL JOIN (VALUES (42)) AS v(x) LIMIT 1

-- Test 20: statement (line 169)
CREATE TABLE empty (x INT)

-- Test 21: query (line 172)
SELECT * FROM onecolumn AS a(x) CROSS JOIN empty AS b(y)

-- Test 22: query (line 176)
SELECT * FROM empty AS a CROSS JOIN onecolumn AS b

-- Test 23: query (line 180)
SELECT * FROM onecolumn AS a(x) JOIN empty AS b(y) ON a.x = b.y

-- Test 24: query (line 184)
SELECT * FROM onecolumn AS a JOIN empty AS b USING(x)

-- Test 25: query (line 188)
SELECT * FROM empty AS a(x) JOIN onecolumn AS b(y) ON a.x = b.y

-- Test 26: query (line 192)
SELECT * FROM empty AS a JOIN onecolumn AS b USING(x)

-- Test 27: query (line 196)
SELECT * FROM onecolumn AS a(x) LEFT OUTER JOIN empty AS b(y) ON a.x = b.y ORDER BY a.x

-- Test 28: query (line 204)
SELECT * FROM onecolumn AS a LEFT OUTER JOIN empty AS b USING(x) ORDER BY x

-- Test 29: query (line 212)
SELECT * FROM empty AS a(x) LEFT OUTER JOIN onecolumn AS b(y) ON a.x = b.y

-- Test 30: query (line 216)
SELECT * FROM empty AS a LEFT OUTER JOIN onecolumn AS b USING(x)

-- Test 31: query (line 220)
SELECT * FROM onecolumn AS a(x) RIGHT OUTER JOIN empty AS b(y) ON a.x = b.y

-- Test 32: query (line 224)
SELECT * FROM onecolumn AS a RIGHT OUTER JOIN empty AS b USING(x)

-- Test 33: query (line 228)
SELECT * FROM empty AS a(x) FULL OUTER JOIN onecolumn AS b(y) ON a.x = b.y ORDER BY b.y

-- Test 34: query (line 236)
SELECT * FROM empty AS a FULL OUTER JOIN onecolumn AS b USING(x) ORDER BY x

-- Test 35: query (line 244)
SELECT * FROM onecolumn AS a(x) FULL OUTER JOIN empty AS b(y) ON a.x = b.y ORDER BY a.x

-- Test 36: query (line 252)
SELECT * FROM onecolumn AS a FULL OUTER JOIN empty AS b USING(x) ORDER BY x

-- Test 37: query (line 260)
SELECT * FROM empty AS a(x) FULL OUTER JOIN onecolumn AS b(y) ON a.x = b.y ORDER BY b.y

-- Test 38: query (line 268)
SELECT * FROM empty AS a FULL OUTER JOIN onecolumn AS b USING(x) ORDER BY x

-- Test 39: statement (line 276)
CREATE TABLE twocolumn (x INT, y INT); INSERT INTO twocolumn(x, y) VALUES (44,51), (NULL,52), (42,53), (45,45)

-- Test 40: query (line 280)
SELECT * FROM onecolumn NATURAL JOIN twocolumn

-- Test 41: query (line 287)
SELECT * FROM twocolumn AS a JOIN twocolumn AS b ON a.x = a.y

-- Test 42: query (line 296)
SELECT o.x, t.y FROM onecolumn o INNER JOIN twocolumn t ON (o.x=t.x AND t.y=53)

-- Test 43: query (line 302)
SELECT o.x, t.y FROM onecolumn o LEFT OUTER JOIN twocolumn t ON (o.x=t.x AND t.y=53)

-- Test 44: query (line 309)
SELECT o.x, t.y FROM onecolumn o LEFT OUTER JOIN twocolumn t ON (o.x=t.x AND o.x=44)

-- Test 45: query (line 316)
SELECT o.x, t.y FROM onecolumn o LEFT OUTER JOIN twocolumn t ON (o.x=t.x AND t.x=44)

-- Test 46: query (line 324)
SELECT * FROM (SELECT x, 2 two FROM onecolumn) NATURAL FULL JOIN (SELECT x, y+1 plus1 FROM twocolumn)

-- Test 47: statement (line 335)
CREATE TABLE a (i int); INSERT INTO a VALUES (1), (2), (3)

-- Test 48: statement (line 338)
CREATE TABLE b (i int, b bool); INSERT INTO b VALUES (2, true), (3, true), (4, false)

-- Test 49: query (line 341)
SELECT * FROM a INNER JOIN b ON a.i = b.i

-- Test 50: query (line 347)
SELECT * FROM a LEFT OUTER JOIN b ON a.i = b.i

-- Test 51: query (line 354)
SELECT * FROM a RIGHT OUTER JOIN b ON a.i = b.i

-- Test 52: query (line 361)
SELECT * FROM a FULL OUTER JOIN b ON a.i = b.i

-- Test 53: query (line 370)
SELECT * FROM a FULL OUTER JOIN b ON (a.i = b.i and a.i>2) ORDER BY a.i, b.i

-- Test 54: statement (line 380)
INSERT INTO b VALUES (3, false)

-- Test 55: query (line 383)
SELECT * FROM a RIGHT OUTER JOIN b ON a.i=b.i ORDER BY b.i, b.b

-- Test 56: query (line 391)
SELECT * FROM a FULL OUTER JOIN b ON a.i=b.i ORDER BY b.i, b.b

-- Test 57: query (line 402)
SELECT * FROM (onecolumn CROSS JOIN twocolumn JOIN onecolumn AS a(b) ON a.b=twocolumn.x JOIN twocolumn AS c(d,e) ON a.b=c.d AND c.d=onecolumn.x) ORDER BY 1 LIMIT 1

-- Test 58: query (line 409)
SELECT * FROM onecolumn JOIN twocolumn ON twocolumn.x = onecolumn.x AND onecolumn.x IN (SELECT x FROM twocolumn WHERE y >= 52)

-- Test 59: query (line 416)
SELECT * FROM onecolumn JOIN (VALUES (41),(42),(43)) AS a(x) USING(x)

-- Test 60: query (line 422)
SELECT * FROM onecolumn JOIN (SELECT x + 2 AS x FROM onecolumn) USING(x)

-- Test 61: query (line 429)
SELECT * FROM (twocolumn AS a JOIN twocolumn AS b USING(x) JOIN twocolumn AS c USING(x)) ORDER BY x LIMIT 1

-- Test 62: query (line 435)
SELECT a.x AS s, b.x, c.x, a.y, b.y, c.y FROM (twocolumn AS a JOIN twocolumn AS b USING(x) JOIN twocolumn AS c USING(x)) ORDER BY s

-- Test 63: query (line 443)
SELECT * FROM (onecolumn AS a JOIN onecolumn AS b USING(y))

query error pgcode 42701 column name "x" appears more than once in USING clause
SELECT * FROM (onecolumn AS a JOIN onecolumn AS b USING(x, x))

statement ok
CREATE TABLE othertype (x TEXT)

query error pgcode 42804 JOIN/USING types.*cannot be matched
SELECT * FROM (onecolumn AS a JOIN othertype AS b USING(x))

query error pgcode 42712 source name "onecolumn" specified more than once \(missing AS clause\)
SELECT * FROM (onecolumn JOIN onecolumn USING(x))

query error pgcode 42712 source name "onecolumn" specified more than once \(missing AS clause\)
SELECT * FROM (onecolumn JOIN twocolumn USING(x) JOIN onecolumn USING(x))

# Check that star expansion works across anonymous sources.
query II rowsort
SELECT * FROM (SELECT * FROM onecolumn), (SELECT * FROM onecolumn)

-- Test 64: query (line 476)
SELECT x FROM (onecolumn JOIN othercolumn USING (x)) JOIN (onecolumn AS a JOIN othercolumn AS b USING(x)) USING(x)

-- Test 65: query (line 482)
SELECT x FROM (SELECT * FROM onecolumn), (SELECT * FROM onecolumn)

query error column reference "x" is ambiguous \(candidates: a\.x, b\.x\)
SELECT * FROM (onecolumn AS a JOIN onecolumn AS b ON x > 32)

query error column "a.y" does not exist
SELECT * FROM (onecolumn AS a JOIN onecolumn AS b ON a.y > y)

statement ok
CREATE TABLE s(x INT); INSERT INTO s(x) VALUES (1),(2),(3),(4),(5),(6),(7),(8),(9),(10)

# Ensure that large cross-joins are optimized somehow (#10633)
statement ok
CREATE TABLE customers(id INT PRIMARY KEY NOT NULL); CREATE TABLE orders(id INT, cust INT REFERENCES customers(id))

query TTTTTTTTIIITTI
SELECT     NULL::text  AS pktable_cat,
       pkn.nspname AS pktable_schem,
       pkc.relname AS pktable_name,
       pka.attname AS pkcolumn_name,
       NULL::text  AS fktable_cat,
       fkn.nspname AS fktable_schem,
       fkc.relname AS fktable_name,
       fka.attname AS fkcolumn_name,
       pos.n       AS key_seq,
       CASE con.confupdtype
            WHEN 'c' THEN 0
            WHEN 'n' THEN 2
            WHEN 'd' THEN 4
            WHEN 'r' THEN 1
            WHEN 'a' THEN 3
            ELSE NULL
       END AS update_rule,
       CASE con.confdeltype
            WHEN 'c' THEN 0
            WHEN 'n' THEN 2
            WHEN 'd' THEN 4
            WHEN 'r' THEN 1
            WHEN 'a' THEN 3
            ELSE NULL
       END          AS delete_rule,
       con.conname  AS fk_name,
       pkic.relname AS pk_name,
       CASE
            WHEN con.condeferrable
            AND      con.condeferred THEN 5
            WHEN con.condeferrable THEN 6
            ELSE 7
       END AS deferrability
  FROM     pg_catalog.pg_namespace pkn,
       pg_catalog.pg_class pkc,
       pg_catalog.pg_attribute pka,
       pg_catalog.pg_namespace fkn,
       pg_catalog.pg_class fkc,
       pg_catalog.pg_attribute fka,
       pg_catalog.pg_constraint con,
       pg_catalog.generate_series(1, 32) pos(n),
       pg_catalog.pg_depend dep,
       pg_catalog.pg_class pkic
  WHERE    pkn.oid = pkc.relnamespace
  AND      pkc.oid = pka.attrelid
  AND      pka.attnum = con.confkey[pos.n]
  AND      con.confrelid = pkc.oid
  AND      fkn.oid = fkc.relnamespace
  AND      fkc.oid = fka.attrelid
  AND      fka.attnum = con.conkey[pos.n]
  AND      con.conrelid = fkc.oid
  AND      con.contype = 'f'
  AND      con.oid = dep.objid
  AND      pkic.oid = dep.refobjid
  AND      pkic.relkind = 'i'
  AND      fkn.nspname = 'public'
  AND      fkc.relname = 'orders'
  ORDER BY pkn.nspname,
       pkc.relname,
       con.conname,
       pos.n

-- Test 66: statement (line 566)
CREATE TABLE square (n INT PRIMARY KEY, sq INT)

-- Test 67: statement (line 569)
INSERT INTO square VALUES (1,1), (2,4), (3,9), (4,16), (5,25), (6,36)

-- Test 68: statement (line 572)
CREATE TABLE pairs (a INT, b INT)

-- Test 69: statement (line 575)
INSERT INTO pairs VALUES (1,1), (1,2), (1,3), (1,4), (1,5), (1,6), (2,3), (2,4), (2,5), (2,6), (3,4), (3,5), (3,6), (4,5), (4,6)

-- Test 70: query (line 578)
SELECT * FROM pairs, square WHERE pairs.b = square.n

-- Test 71: query (line 597)
SELECT * FROM pairs, square WHERE pairs.a + pairs.b = square.sq

-- Test 72: query (line 604)
SELECT a, b, n, sq FROM (SELECT a, b, a * b / 2 AS div, n, sq FROM pairs, square) WHERE div = sq

-- Test 73: query (line 611)
SELECT * FROM pairs FULL OUTER JOIN square ON pairs.a + pairs.b = square.sq

-- Test 74: query (line 634)
SELECT * FROM pairs FULL OUTER JOIN square ON pairs.a + pairs.b = square.sq WHERE pairs.b%2 <> square.sq%2

-- Test 75: query (line 642)
SELECT *
  FROM (SELECT * FROM pairs LEFT JOIN square ON b = sq AND a > 1 AND n < 6)
 WHERE b > 1 AND (n IS NULL OR n > 1) AND (n IS NULL OR a  < sq)

-- Test 76: query (line 662)
SELECT *
  FROM (SELECT * FROM pairs RIGHT JOIN square ON b = sq AND a > 1 AND n < 6)
 WHERE (a IS NULL OR a > 2) AND n > 1 AND (a IS NULL OR a < sq)

-- Test 77: statement (line 674)
CREATE TABLE t1 (col1 INT, x INT, col2 INT, y INT)

-- Test 78: statement (line 677)
CREATE TABLE t2 (col3 INT, y INT, x INT, col4 INT)

-- Test 79: statement (line 680)
INSERT INTO t1 VALUES (10, 1, 11, 1), (20, 2, 21, 1), (30, 3, 31, 1)

-- Test 80: statement (line 683)
INSERT INTO t2 VALUES (100, 1, 1, 101), (200, 1, 201, 2), (400, 1, 401, 4)

-- Test 81: query (line 686)
SELECT * FROM t1 JOIN t2 USING(x)

-- Test 82: query (line 691)
SELECT * FROM t1 NATURAL JOIN t2

-- Test 83: query (line 696)
SELECT * FROM t1 JOIN t2 ON t2.x=t1.x

-- Test 84: query (line 701)
SELECT * FROM t1 FULL OUTER JOIN t2 USING(x)

-- Test 85: query (line 710)
SELECT * FROM t1 NATURAL FULL OUTER JOIN t2

-- Test 86: query (line 719)
SELECT * FROM t1 FULL OUTER JOIN t2 ON t1.x=t2.x

-- Test 87: query (line 728)
SELECT t2.x, t1.x, x FROM t1 JOIN t2 USING(x)

-- Test 88: query (line 733)
SELECT t2.x, t1.x, x FROM t1 FULL OUTER JOIN t2 USING(x)

-- Test 89: query (line 743)
SELECT x FROM t1 NATURAL JOIN (SELECT * FROM t2)

-- Test 90: statement (line 749)
CREATE TABLE pkBA (a INT, b INT, c INT, d INT, PRIMARY KEY(b,a))

-- Test 91: statement (line 752)
CREATE TABLE pkBC (a INT, b INT, c INT, d INT, PRIMARY KEY(b,c))

-- Test 92: statement (line 755)
CREATE TABLE pkBAC (a INT, b INT, c INT, d INT, PRIMARY KEY(b,a,c))

-- Test 93: statement (line 758)
CREATE TABLE pkBAD (a INT, b INT, c INT, d INT, PRIMARY KEY(b,a,d))

-- Test 94: statement (line 765)
INSERT INTO str1 VALUES (1, 'a' COLLATE en_u_ks_level1), (2, 'A' COLLATE en_u_ks_level1), (3, 'c' COLLATE en_u_ks_level1), (4, 'D' COLLATE en_u_ks_level1)

-- Test 95: statement (line 771)
INSERT INTO str2 VALUES (1, 'A' COLLATE en_u_ks_level1), (2, 'B' COLLATE en_u_ks_level1), (3, 'C' COLLATE en_u_ks_level1), (4, 'E' COLLATE en_u_ks_level1)

-- Test 96: query (line 774)
SELECT s, str1.s, str2.s FROM str1 INNER JOIN str2 USING(s)

-- Test 97: query (line 781)
SELECT s, str1.s, str2.s FROM str1 LEFT OUTER JOIN str2 USING(s)

-- Test 98: query (line 789)
SELECT s, str1.s, str2.s FROM str1 RIGHT OUTER JOIN str2 USING(s)

-- Test 99: query (line 798)
SELECT s, str1.s, str2.s FROM str1 FULL OUTER JOIN str2 USING(s)

-- Test 100: statement (line 809)
CREATE TABLE xyu (x INT, y INT, u INT, PRIMARY KEY(x,y,u))

-- Test 101: statement (line 812)
INSERT INTO xyu VALUES (0, 0, 0), (1, 1, 1), (3, 1, 31), (3, 2, 32), (4, 4, 44)

-- Test 102: statement (line 815)
CREATE TABLE xyv (x INT, y INT, v INT, PRIMARY KEY(x,y,v))

-- Test 103: statement (line 818)
INSERT INTO xyv VALUES (1, 1, 1), (2, 2, 2), (3, 1, 31), (3, 3, 33), (5, 5, 55)

-- Test 104: query (line 821)
SELECT * FROM xyu INNER JOIN xyv USING(x, y) WHERE x > 2

-- Test 105: query (line 826)
SELECT * FROM xyu LEFT OUTER JOIN xyv USING(x, y) WHERE x > 2

-- Test 106: query (line 833)
SELECT * FROM xyu RIGHT OUTER JOIN xyv USING(x, y) WHERE x > 2

-- Test 107: query (line 840)
SELECT * FROM xyu FULL OUTER JOIN xyv USING(x, y) WHERE x > 2

-- Test 108: query (line 849)
SELECT * FROM xyu INNER JOIN xyv ON xyu.x = xyv.x AND xyu.y = xyv.y WHERE xyu.x = 1 AND xyu.y < 10

-- Test 109: query (line 854)
SELECT * FROM xyu INNER JOIN xyv ON xyu.x = xyv.x AND xyu.y = xyv.y AND xyu.x = 1 AND xyu.y < 10

-- Test 110: query (line 859)
SELECT * FROM xyu LEFT OUTER JOIN xyv ON xyu.x = xyv.x AND xyu.y = xyv.y AND xyu.x = 1 AND xyu.y < 10

-- Test 111: query (line 868)
SELECT * FROM xyu RIGHT OUTER JOIN xyv ON xyu.x = xyv.x AND xyu.y = xyv.y AND xyu.x = 1 AND xyu.y < 10

-- Test 112: query (line 880)
SELECT * FROM (SELECT * FROM xyu ORDER BY x, y) AS xyu LEFT OUTER JOIN (SELECT * FROM xyv ORDER BY x, y) AS xyv USING(x, y) WHERE x > 2

-- Test 113: query (line 887)
SELECT * FROM (SELECT * FROM xyu ORDER BY x, y) AS xyu RIGHT OUTER JOIN (SELECT * FROM xyv ORDER BY x, y) AS xyv USING(x, y) WHERE x > 2

-- Test 114: query (line 894)
SELECT * FROM (SELECT * FROM xyu ORDER BY x, y) AS xyu FULL OUTER JOIN (SELECT * FROM xyv ORDER BY x, y) AS xyv USING(x, y) WHERE x > 2

-- Test 115: query (line 903)
SELECT * FROM (SELECT * FROM xyu ORDER BY x, y) AS xyu LEFT OUTER JOIN (SELECT * FROM xyv ORDER BY x, y) AS xyv ON xyu.x = xyv.x AND xyu.y = xyv.y AND xyu.x = 1 AND xyu.y < 10

-- Test 116: query (line 912)
SELECT * FROM xyu RIGHT OUTER JOIN (SELECT * FROM xyv ORDER BY x, y) AS xyv ON xyu.x = xyv.x AND xyu.y = xyv.y AND xyu.x = 1 AND xyu.y < 10

-- Test 117: statement (line 924)
CREATE TABLE l (a INT PRIMARY KEY, b1 INT)

-- Test 118: statement (line 927)
CREATE TABLE r (a INT PRIMARY KEY, b2 INT)

-- Test 119: statement (line 930)
INSERT INTO l VALUES (1, 1), (2, 1), (3, 1)

-- Test 120: statement (line 933)
INSERT INTO r VALUES (2, 1), (3, 1), (4, 1)

-- Test 121: query (line 936)
SELECT * FROM l LEFT OUTER JOIN r USING(a) WHERE a = 1

-- Test 122: query (line 941)
SELECT * FROM l LEFT OUTER JOIN r USING(a) WHERE a = 2

-- Test 123: query (line 946)
SELECT * FROM l RIGHT OUTER JOIN r USING(a) WHERE a = 3

-- Test 124: query (line 951)
SELECT * FROM l RIGHT OUTER JOIN r USING(a) WHERE a = 4

-- Test 125: statement (line 958)
CREATE TABLE foo (
  a INT,
  b INT,
  c FLOAT,
  d FLOAT
)

-- Test 126: statement (line 966)
INSERT INTO foo VALUES
  (1, 1, 1, 1),
  (2, 2, 2, 2),
  (3, 3, 3, 3)

-- Test 127: statement (line 972)
CREATE TABLE bar (
  a INT,
  b FLOAT,
  c FLOAT,
  d INT
)

-- Test 128: statement (line 980)
INSERT INTO bar VALUES
  (1, 1, 1, 1),
  (2, 2, 2, 2),
  (3, 3, 3, 3)

-- Test 129: query (line 986)
SELECT * FROM foo NATURAL JOIN bar

-- Test 130: query (line 993)
SELECT * FROM foo JOIN bar USING (b)

-- Test 131: query (line 1000)
SELECT * FROM foo JOIN bar USING (a, b)

-- Test 132: query (line 1007)
SELECT * FROM foo JOIN bar USING (a, b, c)

-- Test 133: query (line 1014)
SELECT * FROM foo JOIN bar ON foo.b = bar.b

-- Test 134: query (line 1021)
SELECT * FROM foo JOIN bar ON foo.a = bar.a AND foo.b = bar.b

-- Test 135: query (line 1028)
SELECT * FROM foo, bar WHERE foo.b = bar.b

-- Test 136: query (line 1035)
SELECT * FROM foo, bar WHERE foo.a = bar.a AND foo.b = bar.b

-- Test 137: query (line 1042)
SELECT * FROM foo JOIN bar USING (a, b) WHERE foo.c = bar.c AND foo.d = bar.d

-- Test 138: query (line 1050)
SELECT * FROM onecolumn AS a(x) RIGHT JOIN twocolumn ON false

-- Test 139: query (line 1060)
SELECT column1, column1+1
FROM
  (SELECT * FROM
    (VALUES (NULL, NULL)) AS t
      NATURAL FULL OUTER JOIN
    (VALUES (1, 1)) AS u)

-- Test 140: query (line 1072)
SELECT * FROM foo JOIN bar ON generate_series(0, 1) < 2

query error aggregate functions are not allowed in JOIN conditions
SELECT * FROM foo JOIN bar ON max(foo.c) < 2

# Regression test for #44029 (outer join on two single-row clauses, with two
# results).
query IIII
SELECT * FROM (VALUES (1, 2)) a(a1,a2) FULL JOIN (VALUES (3, 4)) b(b1,b2) ON a1=b1 ORDER BY a2

-- Test 141: statement (line 1087)
CREATE TABLE t44746_0(c0 INT)

-- Test 142: statement (line 1090)
CREATE TABLE t44746_1(c1 INT)

-- Test 143: statement (line 1094)
SELECT * FROM t44746_0 FULL JOIN t44746_1 ON (SUBSTRING('', ')') = '') = (c1 > 0)

-- Test 144: statement (line 1098)
DROP TABLE empty;

-- Test 145: statement (line 1101)
CREATE TABLE xy (x INT PRIMARY KEY, y INT);
CREATE TABLE fk_ref (r INT NOT NULL REFERENCES xy (x));
CREATE TABLE empty (v INT);

-- Test 146: statement (line 1106)
INSERT INTO xy (VALUES (1, 1));
INSERT INTO fk_ref (VALUES (1));

-- Test 147: query (line 1110)
SELECT * FROM fk_ref LEFT JOIN (SELECT * FROM xy INNER JOIN empty ON True) ON r = x

-- Test 148: statement (line 1115)
DROP TABLE empty;
DROP TABLE fk_ref;
DROP TABLE xy;

-- Test 149: statement (line 1120)
CREATE TABLE abcd (a INT, b INT, c INT, d INT)

-- Test 150: statement (line 1123)
INSERT INTO abcd VALUES (1, 1, 1, 1), (2, 2, 2, 2)

-- Test 151: statement (line 1126)
CREATE TABLE dxby (d INT, x INT, b INT, y INT)

-- Test 152: statement (line 1129)
INSERT INTO dxby VALUES (2, 2, 2, 2), (3, 3, 3, 3)

-- Test 153: query (line 1132)
SELECT * FROM abcd NATURAL FULL OUTER JOIN dxby

-- Test 154: query (line 1142)
SELECT abcd.*, dxby.* FROM abcd NATURAL FULL OUTER JOIN dxby

-- Test 155: query (line 1150)
SELECT abcd.*, dxby.* FROM abcd INNER JOIN dxby USING (d, b)

-- Test 156: statement (line 1158)
CREATE TABLE patient (id INT8 NOT NULL, site_id INT8, PRIMARY KEY (id));

-- Test 157: statement (line 1161)
CREATE TABLE site (id INT8 NOT NULL, PRIMARY KEY (id));

-- Test 158: statement (line 1164)
CREATE TABLE task (id INT8 NOT NULL, description VARCHAR(255), patient_id INT8, PRIMARY KEY (id));

-- Test 159: statement (line 1167)
ALTER TABLE IF EXISTS patient ADD CONSTRAINT fkhty4ykfvf29xscswwd63mgdoc FOREIGN KEY (site_id) REFERENCES site;

-- Test 160: statement (line 1170)
ALTER TABLE IF EXISTS task ADD CONSTRAINT fkkk2ow88d08vqxqyvvvmys1j2m FOREIGN KEY (patient_id) REFERENCES patient;

-- Test 161: statement (line 1173)
INSERT INTO site(id) VALUES (1);
INSERT INTO site(id) VALUES (2);
INSERT INTO site(id) VALUES (3);

-- Test 162: statement (line 1178)
INSERT INTO patient(site_id, id) VALUES (NULL, 4);
INSERT INTO patient(site_id, id) VALUES (1, 5);
INSERT INTO patient(site_id, id) VALUES (1, 6);
INSERT INTO patient(site_id, id) VALUES (2, 7);
INSERT INTO patient(site_id, id) VALUES (3, 8);

-- Test 163: statement (line 1185)
INSERT INTO task(description, patient_id, id) VALUES ('taskWithoutPatient', NULL, 9);
INSERT INTO task(description, patient_id, id) VALUES ('taskWithPatientWithoutSite', 4, 10);
INSERT INTO task(description, patient_id, id) VALUES ('taskWithPatient1WithValidSite1', 5, 11);
INSERT INTO task(description, patient_id, id) VALUES ('taskWithPatient2WithValidSite1', 6, 12);
INSERT INTO task(description, patient_id, id) VALUES ('taskWithPatient3WithValidSite2', 7, 13);
INSERT INTO task(description, patient_id, id) VALUES ('taskWithPatientWithInvalidSite', 8, 14);

-- Test 164: query (line 1193)
SELECT task0_.id AS id1_2_, task0_.description AS descript2_2_, task0_.patient_id AS patient_3_2_
FROM task AS task0_ WHERE EXISTS (
	SELECT task1_.id FROM task AS task1_
	LEFT JOIN patient AS patient2_
	ON task1_.patient_id = patient2_.id
	LEFT JOIN site AS site3_
	ON patient2_.site_id = site3_.id
	WHERE (task1_.id = task0_.id) AND ((patient2_.id IS NULL) OR (site3_.id IN (2, 1)))
);

-- Test 165: statement (line 1211)
CREATE TABLE t106371 (x INT NOT NULL, y INT NOT NULL);
INSERT INTO t106371 VALUES (1, 1), (1, 2);

-- Test 166: query (line 1215)
SELECT * FROM (SELECT * FROM t106371 ORDER BY y LIMIT 1) a
JOIN (SELECT DISTINCT ON (x) * FROM (SELECT * FROM t106371 WHERE y = 2)) b ON a.x = b.x;

-- Test 167: statement (line 1225)
SET autocommit_before_ddl = false

-- Test 168: statement (line 1228)
CREATE TABLE t107850a (
  d2 DECIMAL(10, 2) NOT NULL UNIQUE
);
CREATE TABLE t107850b (
  d0 DECIMAL(10, 0) NOT NULL REFERENCES t107850a (d2)
);
INSERT INTO t107850a VALUES (1.00);
INSERT INTO t107850b VALUES (1);

-- Test 169: query (line 1238)
SELECT d2 FROM t107850a JOIN t107850b ON d2 = d0

-- Test 170: statement (line 1243)
RESET autocommit_before_ddl

