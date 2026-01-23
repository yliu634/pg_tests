-- PostgreSQL compatible tests from postgresjoin
-- 101 tests

-- Test 1: statement (line 5)
CREATE TABLE J1_TBL ( i integer, j integer, t text );

-- Test 2: statement (line 8)
CREATE TABLE J2_TBL ( i integer, k integer );

-- Test 3: statement (line 11)
INSERT INTO J1_TBL VALUES (1, 4, 'one');

-- Test 4: statement (line 14)
INSERT INTO J1_TBL VALUES (2, 3, 'two');

-- Test 5: statement (line 17)
INSERT INTO J1_TBL VALUES (3, 2, 'three');

-- Test 6: statement (line 20)
INSERT INTO J1_TBL VALUES (4, 1, 'four');

-- Test 7: statement (line 23)
INSERT INTO J1_TBL VALUES (5, 0, 'five');

-- Test 8: statement (line 26)
INSERT INTO J1_TBL VALUES (6, 6, 'six');

-- Test 9: statement (line 29)
INSERT INTO J1_TBL VALUES (7, 7, 'seven');

-- Test 10: statement (line 32)
INSERT INTO J1_TBL VALUES (8, 8, 'eight');

-- Test 11: statement (line 35)
INSERT INTO J1_TBL VALUES (0, NULL, 'zero');

-- Test 12: statement (line 38)
INSERT INTO J1_TBL VALUES (NULL, NULL, 'null');

-- Test 13: statement (line 41)
INSERT INTO J1_TBL VALUES (NULL, 0, 'zero');

-- Test 14: statement (line 44)
INSERT INTO J2_TBL VALUES (1, -1);

-- Test 15: statement (line 47)
INSERT INTO J2_TBL VALUES (2, 2);

-- Test 16: statement (line 50)
INSERT INTO J2_TBL VALUES (3, -3);

-- Test 17: statement (line 53)
INSERT INTO J2_TBL VALUES (2, 4);

-- Test 18: statement (line 56)
INSERT INTO J2_TBL VALUES (5, -5);

-- Test 19: statement (line 59)
INSERT INTO J2_TBL VALUES (5, -5);

-- Test 20: statement (line 62)
INSERT INTO J2_TBL VALUES (0, NULL);

-- Test 21: statement (line 65)
INSERT INTO J2_TBL VALUES (NULL, NULL);

-- Test 22: statement (line 68)
INSERT INTO J2_TBL VALUES (NULL, 0);

-- Test 23: query (line 71)
SELECT 'x' AS "xxx", * FROM J1_TBL AS tx;

-- Test 24: query (line 86)
SELECT 'x' AS "xxx", * FROM J1_TBL tx;

-- Test 25: query (line 101)
SELECT 'x' AS "xxx", * FROM J1_TBL AS t1 (a, b, c);

-- Test 26: query (line 116)
SELECT 'x' AS "xxx", * FROM J1_TBL t1 (a, b, c);

-- Test 27: query (line 131)
SELECT 'x' AS "xxx", * FROM J1_TBL t1 (a, b, c), J2_TBL t2 (d, e);

-- Test 28: query (line 234)
SELECT 'x' AS "xxx", t1.a, t2.e FROM J1_TBL t1 (a, b, c), J2_TBL t2 (d, e) WHERE t1.a = t2.d;

-- Test 29: query (line 245)
SELECT 'x' AS "xxx", * FROM J1_TBL CROSS JOIN J2_TBL;

-- Test 30: statement (line 348)
-- Qualify `i` to avoid ambiguous column reference.
SELECT 'x' AS "xxx", J1_TBL.i, k, t FROM J1_TBL CROSS JOIN J2_TBL;

-- Test 31: query (line 351)
SELECT 'x' AS "xxx", t1.i, k, t FROM J1_TBL t1 CROSS JOIN J2_TBL t2;

-- Test 32: query (line 454)
SELECT 'x' AS "xxx", ii, tt, kk FROM (J1_TBL CROSS JOIN J2_TBL) AS tx (ii, jj, tt, ii2, kk);

-- Test 33: query (line 557)
SELECT 'x' AS "xxx", tx.ii, tx.jj, tx.kk FROM (J1_TBL t1 (a, b, c) CROSS JOIN J2_TBL t2 (d, e)) AS tx (ii, jj, tt, ii2, kk);

-- Test 34: query (line 660)
SELECT 'x' AS "xxx", * FROM J1_TBL CROSS JOIN J2_TBL a CROSS JOIN J2_TBL b;

-- Test 35: query (line 1555)
SELECT 'x' AS "xxx", * FROM J1_TBL INNER JOIN J2_TBL USING (i);

-- Test 36: query (line 1566)
SELECT 'x' AS "xxx", * FROM J1_TBL JOIN J2_TBL USING (i);

-- Test 37: query (line 1577)
SELECT 'x' AS "xxx", * FROM J1_TBL t1 (a, b, c) JOIN J2_TBL t2 (a, d) USING (a) ORDER BY a, d;

-- Test 38: query (line 1588)
SELECT 'x' AS "xxx", * FROM J1_TBL t1 (a, b, c) JOIN J2_TBL t2 (a, b) USING (b) ORDER BY b, t1.a;

-- Test 39: query (line 1596)
SELECT 'x' AS "xxx", * FROM J1_TBL NATURAL JOIN J2_TBL;

-- Test 40: query (line 1607)
SELECT 'x' AS "xxx", * FROM J1_TBL t1 (a, b, c) NATURAL JOIN J2_TBL t2 (a, d);

-- Test 41: query (line 1618)
SELECT 'x' AS "xxx", * FROM J1_TBL t1 (a, b, c) NATURAL JOIN J2_TBL t2 (d, a);

-- Test 42: query (line 1625)
SELECT 'x' AS "xxx", * FROM J1_TBL t1 (a, b) NATURAL JOIN J2_TBL t2 (a);

-- Test 43: query (line 1636)
SELECT 'x' AS "xxx", * FROM J1_TBL JOIN J2_TBL ON (J1_TBL.i = J2_TBL.i);

-- Test 44: query (line 1647)
SELECT 'x' AS "xxx", * FROM J1_TBL JOIN J2_TBL ON (J1_TBL.i = J2_TBL.k);

-- Test 45: query (line 1654)
SELECT 'x' AS "xxx", * FROM J1_TBL JOIN J2_TBL ON (J1_TBL.i <= J2_TBL.k);

-- Test 46: query (line 1667)
SELECT 'x' AS "xxx", * FROM J1_TBL LEFT OUTER JOIN J2_TBL USING (i) ORDER BY i, k, t;

-- Test 47: query (line 1684)
SELECT 'x' AS "xxx", * FROM J1_TBL LEFT JOIN J2_TBL USING (i) ORDER BY i, k, t;

-- Test 48: query (line 1701)
SELECT 'x' AS "xxx", * FROM J1_TBL RIGHT OUTER JOIN J2_TBL USING (i);

-- Test 49: query (line 1714)
SELECT 'x' AS "xxx", * FROM J1_TBL RIGHT JOIN J2_TBL USING (i);

-- Test 50: query (line 1727)
SELECT 'x' AS "xxx", * FROM J1_TBL FULL OUTER JOIN J2_TBL USING (i) ORDER BY i, k, t;

-- Test 51: query (line 1746)
SELECT 'x' AS "xxx", * FROM J1_TBL FULL JOIN J2_TBL USING (i) ORDER BY i, k, t;

-- Test 52: query (line 1765)
SELECT 'x' AS "xxx", * FROM J1_TBL LEFT JOIN J2_TBL USING (i) WHERE (k = 1);

-- Test 53: query (line 1769)
SELECT 'x' AS "xxx", * FROM J1_TBL LEFT JOIN J2_TBL USING (i) WHERE (i = 1);

-- Test 54: statement (line 1774)
CREATE TABLE t1 (name TEXT, n INTEGER);

-- Test 55: statement (line 1777)
CREATE TABLE t2 (name TEXT, n INTEGER);

-- Test 56: statement (line 1780)
CREATE TABLE t3 (name TEXT, n INTEGER);

-- Test 57: statement (line 1783)
INSERT INTO t1 VALUES ( 'bb', 11 );

-- Test 58: statement (line 1786)
INSERT INTO t2 VALUES ( 'bb', 12 );

-- Test 59: statement (line 1789)
INSERT INTO t2 VALUES ( 'cc', 22 );

-- Test 60: statement (line 1792)
INSERT INTO t2 VALUES ( 'ee', 42 );

-- Test 61: statement (line 1795)
INSERT INTO t3 VALUES ( 'bb', 13 );

-- Test 62: statement (line 1798)
INSERT INTO t3 VALUES ( 'cc', 23 );

-- Test 63: statement (line 1801)
INSERT INTO t3 VALUES ( 'dd', 33 );

-- Test 64: query (line 1804)
SELECT * FROM t1 FULL JOIN t2 USING (name) FULL JOIN t3 USING (name);

-- Test 65: query (line 1812)
SELECT * FROM (SELECT * FROM t2) as s2 INNER JOIN (SELECT * FROM t3) s3 USING (name);

-- Test 66: query (line 1818)
SELECT * FROM (SELECT * FROM t2) as s2 LEFT JOIN (SELECT * FROM t3) s3 USING (name);

-- Test 67: query (line 1825)
SELECT * FROM (SELECT * FROM t2) as s2 FULL JOIN (SELECT * FROM t3) s3 USING (name);

-- Test 68: query (line 1833)
SELECT * FROM (SELECT name, n as s2_n, 2 as s2_2 FROM t2) as s2 NATURAL INNER JOIN (SELECT name, n as s3_n, 3 as s3_2 FROM t3) s3;

-- Test 69: query (line 1839)
SELECT * FROM (SELECT name, n as s2_n, 2 as s2_2 FROM t2) as s2 NATURAL LEFT JOIN (SELECT name, n as s3_n, 3 as s3_2 FROM t3) s3;

-- Test 70: query (line 1846)
SELECT * FROM (SELECT name, n as s2_n, 2 as s2_2 FROM t2) as s2 NATURAL FULL JOIN (SELECT name, n as s3_n, 3 as s3_2 FROM t3) s3;

-- Test 71: query (line 1854)
SELECT * FROM (SELECT name, n as s1_n, 1 as s1_1 FROM t1) as s1 NATURAL INNER JOIN (SELECT name, n as s2_n, 2 as s2_2 FROM t2) as s2 NATURAL INNER JOIN (SELECT name, n as s3_n, 3 as s3_2 FROM t3) s3;

-- Test 72: query (line 1859)
SELECT * FROM (SELECT name, n as s1_n, 1 as s1_1 FROM t1) as s1 NATURAL FULL JOIN (SELECT name, n as s2_n, 2 as s2_2 FROM t2) as s2 NATURAL FULL JOIN (SELECT name, n as s3_n, 3 as s3_2 FROM t3) s3;

-- Test 73: query (line 1867)
SELECT * FROM (SELECT name, n as s1_n FROM t1) as s1 NATURAL FULL JOIN (SELECT * FROM (SELECT name, n as s2_n FROM t2) as s2 NATURAL FULL JOIN (SELECT name, n as s3_n FROM t3) as s3 ) ss2;

-- Test 74: query (line 1875)
SELECT * FROM (SELECT name, n as s1_n FROM t1) as s1 NATURAL FULL JOIN (SELECT * FROM (SELECT name, n as s2_n, 2 as s2_2 FROM t2) as s2 NATURAL FULL JOIN (SELECT name, n as s3_n FROM t3) as s3 ) ss2;

-- Test 75: statement (line 1883)
create table xt (x1 int, x2 int);

-- Test 76: statement (line 1886)
insert into xt values (1,11);

-- Test 77: statement (line 1889)
insert into xt values (2,22);

-- Test 78: statement (line 1892)
insert into xt values (3,null);

-- Test 79: statement (line 1895)
insert into xt values (4,44);

-- Test 80: statement (line 1898)
insert into xt values (5,null);

-- Test 81: statement (line 1901)
create table yt (y1 int, y2 int);

-- Test 82: statement (line 1904)
insert into yt values (1,111);

-- Test 83: statement (line 1907)
insert into yt values (2,222);

-- Test 84: statement (line 1910)
insert into yt values (3,333);

-- Test 85: statement (line 1913)
insert into yt values (4,null);

-- Test 86: statement (line 1916)
select * from xt left join yt on (x1 = y1 and x2 is not null);

-- Test 87: statement (line 1919)
select * from xt left join yt on (x1 = y1 and y2 is not null);

-- Test 88: statement (line 1922)
select * from (xt left join yt on (x1 = y1)) left join xt xx(xx1,xx2) on (x1 = xx1);

-- Test 89: statement (line 1925)
select * from (xt left join yt on (x1 = y1)) left join xt xx(xx1,xx2) on (x1 = xx1 and x2 is not null);

-- Test 90: statement (line 1928)
select * from (xt left join yt on (x1 = y1)) left join xt xx(xx1,xx2) on (x1 = xx1 and y2 is not null);

-- Test 91: statement (line 1931)
select * from (xt left join yt on (x1 = y1)) left join xt xx(xx1,xx2) on (x1 = xx1 and xx2 is not null);

-- Test 92: statement (line 1934)
select * from (xt left join yt on (x1 = y1)) left join xt xx(xx1,xx2) on (x1 = xx1) where (x2 is not null);

-- Test 93: statement (line 1937)
select * from (xt left join yt on (x1 = y1)) left join xt xx(xx1,xx2) on (x1 = xx1) where (y2 is not null);

-- Test 94: statement (line 1940)
select * from (xt left join yt on (x1 = y1)) left join xt xx(xx1,xx2) on (x1 = xx1) where (xx2 is not null);

-- Test 95: statement (line 1943)
DROP TABLE t1;

-- Test 96: statement (line 1946)
DROP TABLE t2;

-- Test 97: statement (line 1949)
DROP TABLE t3;

-- Test 98: statement (line 1952)
DROP TABLE xt;

-- Test 99: statement (line 1955)
DROP TABLE yt;

-- Test 100: statement (line 1958)
DROP TABLE J1_TBL;

-- Test 101: statement (line 1961)
DROP TABLE J2_TBL;
