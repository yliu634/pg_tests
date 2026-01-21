-- PostgreSQL compatible tests from order_by
-- 85 tests

\set ON_ERROR_STOP 1

-- Test 1: statement (line 1)
CREATE TABLE t (
  a INT PRIMARY KEY,
  b INT,
  c BOOLEAN
);

-- Test 2: statement (line 8)
INSERT INTO t VALUES (1, 9, true), (2, 8, false), (3, 7, NULL);

-- Test 3: query (line 11)
SELECT c FROM t ORDER BY c;

-- Test 4: query (line 20)
SELECT c FROM t ORDER BY c;

-- Test 5: query (line 27)
SELECT c FROM t ORDER BY c DESC;

-- Test 6: query (line 34)
SELECT a, b FROM t ORDER BY b;

-- Test 7: query (line 41)
SELECT a, b FROM t ORDER BY b DESC;

-- Test 8: query (line 48)
SELECT a FROM t ORDER BY 1 DESC;

-- Test 9: query (line 55)
SELECT a, b FROM t ORDER BY b DESC LIMIT 2;

-- Test 10: query (line 61)
SELECT DISTINCT c, b FROM t ORDER BY b DESC LIMIT 2;

-- Test 11: query (line 67)
SELECT a AS foo, b FROM t ORDER BY foo DESC;

-- Test 12: query (line 75)
-- Expected error: ORDER BY "foo" is ambiguous (two different output columns share the name).
\set ON_ERROR_STOP 0
SELECT a AS foo, b AS foo FROM t ORDER BY foo;
\set ON_ERROR_STOP 1

-- Check that no ambiguity is reported if the ORDER BY name refers
-- to two or more equivalent renders (special case in SQL92).
-- query II
SELECT a AS foo, (a) AS foo FROM t ORDER BY foo LIMIT 1;

-- Test 13: query (line 85)
SELECT a AS "foo.bar", b FROM t ORDER BY "foo.bar" DESC;

-- Test 14: query (line 92)
SELECT a AS foo, b FROM t ORDER BY a DESC;

-- Test 15: query (line 99)
SELECT b FROM t ORDER BY a DESC;

-- Test 16: statement (line 106)
INSERT INTO t (a, b) VALUES (4, 7), (5, 7);

-- Test 17: query (line 109)
SELECT a, b FROM t WHERE b = 7 ORDER BY b, a;

-- Test 18: query (line 116)
SELECT a, b FROM t ORDER BY b, a DESC;

-- Test 19: query (line 125)
SELECT a, b, a+b AS ab FROM t WHERE b = 7 ORDER BY ab DESC, a;

-- Test 20: query (line 132)
SELECT a FROM t ORDER BY a+b DESC, a;

-- Test 21: query (line 141)
SELECT a FROM t ORDER BY (((a)));

-- Test 22: query (line 150)
(((SELECT a FROM t))) ORDER BY a DESC LIMIT 4;

-- Test 23: query (line 158)
(((SELECT a FROM t ORDER BY a DESC LIMIT 4)));

-- Test 24: query (line 166)
((SELECT a FROM t)) ORDER BY a;

-- query error expected b to be of type bool, found type int
\set ON_ERROR_STOP 0
SELECT CASE a WHEN 1 THEN b ELSE c END as val FROM t ORDER BY val;
\set ON_ERROR_STOP 1

-- query error pgcode 42P10 ORDER BY position 0 is not in select list
\set ON_ERROR_STOP 0
SELECT * FROM t ORDER BY 0;
\set ON_ERROR_STOP 1

-- query error pgcode 42601 non-integer constant in ORDER BY: true
\set ON_ERROR_STOP 0
SELECT * FROM t ORDER BY true;
\set ON_ERROR_STOP 1

-- query error pgcode 42601 non-integer constant in ORDER BY: 'a'
\set ON_ERROR_STOP 0
SELECT * FROM t ORDER BY 'a';
\set ON_ERROR_STOP 1

-- query error pgcode 42601 non-integer constant in ORDER BY: 2\.5
\set ON_ERROR_STOP 0
SELECT * FROM t ORDER BY 2.5;
\set ON_ERROR_STOP 1

-- query error column "foo" does not exist
\set ON_ERROR_STOP 0
SELECT * FROM t ORDER BY foo;
\set ON_ERROR_STOP 1

-- query error no data source matches prefix: a
\set ON_ERROR_STOP 0
SELECT a FROM t ORDER BY a.b;
\set ON_ERROR_STOP 1

-- query IT
SELECT generate_series, ARRAY[generate_series] FROM generate_series(1, 1) ORDER BY 1;

-- Test 25: query (line 195)
SELECT generate_series, ARRAY[generate_series] FROM generate_series(1, 1) ORDER BY generate_series;

-- Test 26: query (line 200)
SELECT generate_series, ARRAY[generate_series] FROM generate_series(1, 1) ORDER BY -generate_series;

-- Test 27: statement (line 205)
CREATE TABLE abc (
  a INT,
  b INT,
  c INT,
  d VARCHAR,
  PRIMARY KEY (a, b, c)
);
CREATE UNIQUE INDEX abc_bc ON abc (b, c);
CREATE INDEX abc_ba ON abc (b, a);

-- Test 28: statement (line 218)
INSERT INTO abc VALUES (1, 2, 3, 'one'), (4, 5, 6, 'Two');

-- Test 29: query (line 221)
SELECT d FROM abc ORDER BY lower(d);

-- Test 30: query (line 227)
SELECT a FROM abc ORDER BY a DESC;

-- Test 31: query (line 233)
SELECT a FROM abc ORDER BY a DESC LIMIT 1;

-- Test 32: query (line 238)
SELECT a FROM abc ORDER BY a DESC OFFSET 1;

-- Test 33: statement (line 246)
CREATE TABLE bar (id INT PRIMARY KEY, baz INT);
INSERT INTO bar VALUES (0, NULL), (1, NULL);

-- Test 34: query (line 253)
SELECT * FROM bar ORDER BY baz, id;

-- Test 35: statement (line 259)
CREATE TABLE abcd (
  a INT PRIMARY KEY,
  b INT,
  c INT,
  d INT
);
CREATE INDEX abcd_abc_idx ON abcd (a, b, c);

-- Test 36: statement (line 268)
INSERT INTO abcd VALUES (1, 4, 2, 3), (2, 3, 4, 1), (3, 2, 1, 2), (4, 4, 1, 1);

-- Test 37: query (line 276)
SELECT a+b FROM abcd ORDER BY d;

-- Test 38: query (line 284)
SELECT b+d FROM abcd ORDER BY a, d;

-- Test 39: statement (line 292)
CREATE TABLE nan (id INT PRIMARY KEY, x REAL);

-- Test 40: statement (line 295)
INSERT INTO nan VALUES (1, 'NaN'), (2, -1), (3, 1), (4, 'NaN');

-- Test 41: query (line 298)
SELECT x FROM nan ORDER BY x;

-- Test 42: statement (line 324)
CREATE TABLE store (id INT PRIMARY KEY, baz INT, extra INT);
INSERT INTO store VALUES (0, NULL, 10), (1, NULL, 5);

-- Test 43: query (line 329)
SELECT * FROM store ORDER BY baz, extra;

-- Test 44: statement (line 340)
CREATE TABLE kv(k INT PRIMARY KEY, v INT); CREATE INDEX foo ON kv(v DESC);

-- Test 45: statement (line 344)
SELECT * FROM kv AS a, kv AS b ORDER BY a.k, b.k;

-- Test 46: statement (line 350)
SELECT k FROM (SELECT i, i FROM generate_series(1,10) g(i)) AS kv(k,v) ORDER BY k;

-- Test 47: statement (line 353)
CREATE TABLE unrelated(x INT);
\set ON_ERROR_STOP 0
SELECT * FROM unrelated ORDER BY kv.k;
\set ON_ERROR_STOP 1

-- Test 48: statement (line 357)
PREPARE a AS SELECT * FROM kv ORDER BY k;

-- Test 49: statement (line 360)
SELECT avg(k) OVER (ORDER BY k) FROM kv;

-- Test 50: statement (line 363)
INSERT INTO kv VALUES (1, 1), (2, 1), (3, 1), (4, 1), (5, 1);

-- Test 51: query (line 366)
SELECT k FROM kv ORDER BY v DESC, k;

-- Test 52: statement (line 375)
CREATE TABLE abc2 (
  a INT,
  b INT,
  c INT,
  PRIMARY KEY (a, b)
);
CREATE UNIQUE INDEX abc2_bc ON abc2 (b, c);
CREATE INDEX abc2_ba ON abc2 (b, a);

-- Test 53: statement (line 385)
INSERT INTO abc2 VALUES (2, 30, 400), (1, 30, 500), (3, 30, 300);

-- Test 54: query (line 388)
SELECT a, b, c FROM abc2 ORDER BY a, b;

-- Test 55: query (line 395)
SELECT a, b, c FROM abc2 ORDER BY a DESC, b DESC;

-- Test 56: query (line 402)
SELECT a, b, c FROM abc2 ORDER BY b, c;

-- Test 57: query (line 409)
SELECT a, b, c FROM abc2 ORDER BY b DESC, c DESC;

-- Test 58: query (line 416)
SELECT a, b, c FROM abc2 ORDER BY b, a;

-- Test 59: query (line 423)
SELECT a, b, c FROM abc2 ORDER BY b DESC, a DESC;

-- Test 60: statement (line 430)
SELECT a, b, c FROM abc2 AS x ORDER BY x.b, x.c;

-- Test 61: statement (line 433)
SELECT a, b, c FROM abc2 AS x ORDER BY x.b, x.c;

-- Test 62: query (line 437)
-- CockroachDB-specific introspection table; PostgreSQL has no equivalent.
-- SELECT usage_count > 0 FROM crdb_internal.feature_usage WHERE feature_name = 'sql.plan.opt.node.sort';

-- Test 63: statement (line 447)
CREATE TABLE xy(x INT, y INT);

-- Test 64: statement (line 450)
INSERT INTO xy VALUES (2, NULL), (NULL, 6), (2, 5), (4, 8);

-- Test 65: query (line 453)
SELECT x, y FROM xy ORDER BY y NULLS FIRST;

-- Test 66: query (line 461)
SELECT x, y FROM xy ORDER BY y NULLS LAST;

-- Test 67: query (line 469)
SELECT x, y FROM xy ORDER BY y DESC NULLS FIRST;

-- Test 68: query (line 477)
SELECT x, y FROM xy ORDER BY y DESC NULLS LAST;

-- Test 69: statement (line 485)
CREATE INDEX y_idx ON xy(y);

-- Test 70: query (line 488)
SELECT x, y FROM xy ORDER BY y NULLS LAST;

-- Test 71: statement (line 496)
INSERT INTO xy VALUES (NULL, NULL);

-- Test 72: query (line 499)
SELECT x, y FROM xy ORDER BY x NULLS FIRST, y NULLS LAST;

-- Test 73: query (line 508)
SELECT x, y FROM xy ORDER BY x NULLS LAST, y DESC NULLS FIRST;

-- Test 74: statement (line 519)
-- CockroachDB-only session setting; PostgreSQL already defaults to NULLS LAST
-- for ASC and NULLS FIRST for DESC.
-- SET null_ordered_last = true;

-- Test 75: query (line 522)
SELECT x, y FROM xy ORDER BY x, y;

-- Test 76: query (line 531)
SELECT x, y FROM xy ORDER BY x, y DESC NULLS FIRST;

-- Test 77: query (line 540)
SELECT x, y FROM xy ORDER BY x NULLS LAST, y DESC NULLS FIRST;

-- Test 78: query (line 549)
SELECT x, y FROM xy ORDER BY x NULLS FIRST, y DESC NULLS LAST;

-- Test 79: query (line 558)
SELECT x, y FROM xy ORDER BY x NULLS FIRST, y DESC;

-- Test 80: query (line 567)
SELECT x, y FROM xy ORDER BY x NULLS FIRST, y DESC NULLS FIRST;

-- Test 81: query (line 587)
WITH t (x, y) AS (
  VALUES
    ((1, 1), 1),
    ((NULL::RECORD), 2),
    ((1, NULL::INT), 3),
    ((NULL::INT, NULL::INT), 4)
)
SELECT *
FROM t
ORDER BY x;

-- Test 82: statement (line 604)
-- RESET null_ordered_last;

-- Test 83: statement (line 608)
CREATE TABLE t106678 (a INT, b INT);
INSERT INTO t106678 VALUES (2, 0), (1, 100), (2, 0), (3, 20), (1, -1);

-- Test 84: query (line 613)
SELECT a, b FROM (SELECT a, b FROM t106678 ORDER BY a LIMIT 3) ORDER BY a, b;

-- Test 85: query (line 621)
SELECT a, b FROM (SELECT a, b FROM t106678 ORDER BY a LIMIT 3) ORDER BY a, b LIMIT 1;
