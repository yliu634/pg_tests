-- PostgreSQL compatible tests from select
-- 154 tests

SET client_min_messages = warning;

-- CockroachDB logic tests assume current database is `test`. Use a schema to
-- emulate that database so the file can run in a single PostgreSQL database.
DROP SCHEMA IF EXISTS test CASCADE;
CREATE SCHEMA test;
SET search_path = test, public;

-- Test 1: query (line 5)
SELECT 1;

-- Test 2: query (line 10)
SELECT NULL;

-- Test 3: query (line 15)
SELECT 1+1 AS two, 2+2 AS four;

-- Test 4: statement (line 23)
CREATE TABLE abc (a INT PRIMARY KEY, b INT, c INT);

-- Test 5: statement (line 26)
SELECT FROM abc;

-- Test 6: query (line 29)
-- PostgreSQL requires a boolean WHERE clause; CockroachDB logic tests sometimes
-- include non-boolean literals. Use TRUE to preserve "no filtering" semantics.
SELECT * FROM abc WHERE true;

-- statement ok
INSERT INTO abc VALUES (1, 2, 3);

-- query III colnames
SELECT * FROM abc;

-- Test 7: query (line 41)
SELECT NULL AS z, * FROM abc;

-- Test 8: query (line 48)
TABLE abc;

-- Test 9: query (line 53)
SELECT abc.* FROM abc;

-- query III colnames
SELECT * FROM abc WHERE NULL;

-- Test 10: query (line 61)
SELECT * FROM abc WHERE a = NULL;

-- Test 11: query (line 66)
SELECT *,* FROM abc;

-- Test 12: query (line 72)
SELECT a,a,a,a FROM abc;

-- Test 13: query (line 78)
SELECT a,c FROM abc;

-- Test 14: query (line 84)
SELECT a+b+c AS foo FROM abc;

-- Test 15: query (line 91)
SELECT * FROM abc WHERE a > 5 AND a < 5;

-- Test 16: query (line 96)
SELECT * FROM abc WHERE a > 5 AND a < 5 AND b>=100;

-- Test 17: statement (line 100)
INSERT INTO abc VALUES (0, 1, 2);

-- Test 18: query (line 103)
SELECT a,b FROM abc WHERE CASE WHEN a != 0 THEN b/a > 1.5 ELSE false END;

-- Test 19: statement (line 110)
CREATE TABLE kv (k CHAR PRIMARY KEY, v CHAR);

-- Test 20: statement (line 113)
INSERT INTO kv (k) VALUES ('a');

-- Test 21: query (line 116)
SELECT * FROM kv;

-- Test 22: query (line 121)
SELECT k,v FROM kv;

-- Test 23: query (line 126)
SELECT v||'foo' FROM kv;

-- Test 24: query (line 131)
SELECT lower(v) FROM kv;

-- Test 25: query (line 136)
SELECT k FROM kv;

-- Test 26: query (line 141)
SELECT kv.K,KV.v FROM kv;

-- Test 27: query (line 146)
SELECT kv.* FROM kv;

-- Test 28: query (line 152)
SELECT test.kv.* FROM kv;

-- Test 29: query (line 157)
-- PostgreSQL has no database qualification; map `test.public.kv` -> `test.kv`.
SELECT test.kv.* FROM kv;

-- Test 30: query (line 162)
SELECT test.kv.* FROM test.kv;

-- Test 31: query (line 167)
SELECT test.kv.* FROM test.kv;

-- Test 32: query (line 172)
SELECT foo.* FROM kv AS foo;

-- query error cannot use "\*" without a FROM clause
-- SELECT *;

-- query error "kv.*" cannot be aliased
-- SELECT kv.* AS foo FROM kv;

-- query error no data source matches pattern: bar.kv.\*
-- SELECT bar.kv.* FROM kv;

-- Don't panic with invalid names (#8024)
-- query error cannot subscript type tuple{char AS k, char AS v} because it is not an array
-- SELECT kv.*[1] FROM kv;

-- query T colnames
SELECT FOO.k FROM kv AS foo WHERE foo.k = 'a';

-- Test 33: query (line 194)
SELECT "foo"."v" FROM kv AS foo WHERE foo.k = 'a';

-- Test 34: statement (line 199)
CREATE TABLE kw ("from" INT PRIMARY KEY);

-- Test 35: statement (line 202)
INSERT INTO kw VALUES (1);

-- Test 36: query (line 205)
SELECT *, "from", kw."from" FROM kw;

-- Test 37: statement (line 213)
CREATE TABLE xyzw (
  x INT PRIMARY KEY,
  y INT,
  z INT,
  w INT
);
CREATE INDEX foo ON xyzw (z, y);

-- Test 38: statement (line 222)
INSERT INTO xyzw VALUES (4, 5, 6, 7), (1, 2, 3, 4);

-- Test 39: query (line 225)
-- PostgreSQL disallows LIMIT expressions with variables; use a scalar subquery.
SELECT * FROM xyzw LIMIT (SELECT max(x) FROM xyzw);

-- query error pq: column "y" does not exist
-- SELECT * FROM xyzw OFFSET 1 + y;

-- query error argument of LIMIT must be type int, not type decimal
-- SELECT * FROM xyzw LIMIT 3.3;

-- query IIII
SELECT * FROM xyzw ORDER BY 1 LIMIT '1';

-- Test 40: query (line 239)
SELECT * FROM xyzw OFFSET (1.5::int);

-- query error negative value for LIMIT
-- SELECT * FROM xyzw LIMIT -100;

-- query error negative value for OFFSET
-- SELECT * FROM xyzw OFFSET -100;

-- query error numeric constant out of int64 range
-- SELECT * FROM xyzw LIMIT 9223372036854775808;

-- query error numeric constant out of int64 range
-- SELECT * FROM xyzw OFFSET 9223372036854775808;

-- query IIII
SELECT * FROM xyzw ORDER BY x OFFSET (1 + 0.0)::int;

-- Test 41: query (line 259)
SELECT (x,y) FROM xyzw;

-- Test 42: query (line 265)
SELECT * FROM xyzw LIMIT 0;

-- Test 43: query (line 269)
SELECT * FROM xyzw ORDER BY x LIMIT 1;

-- Test 44: query (line 274)
SELECT * FROM xyzw ORDER BY x LIMIT 1 OFFSET 1;

-- Test 45: query (line 279)
SELECT * FROM xyzw ORDER BY y OFFSET 1;

-- Test 46: query (line 284)
SELECT * FROM xyzw ORDER BY y OFFSET 1 LIMIT 1;

-- Test 47: query (line 290)
SELECT * FROM xyzw LIMIT (random() * 0.0)::int OFFSET (random() * 0.0)::int;

-- Test 48: query (line 294)
SELECT (SELECT x FROM xyzw LIMIT 1) LIMIT 1;

-- query IIII
SELECT * FROM (SELECT * FROM xyzw LIMIT 5) OFFSET 5;

-- Test 49: query (line 301)
SELECT z, y FROM xyzw;

-- Test 50: query (line 307)
SELECT z FROM test.xyzw WHERE y = 5;

-- Test 51: query (line 312)
SELECT xyzw.y FROM test.xyzw WHERE z = 3;

-- Test 52: query (line 317)
-- CockroachDB-only error cases around table/index hints; omit on PostgreSQL.
-- SELECT z FROM test.unknown@foo WHERE y = 5;

-- query error pgcode 42704 index "unknown" not found
-- SELECT z FROM test.xyzw@unknown WHERE y = 5;

-- query error pgcode 42704 index [42] not found
-- SELECT z FROM test.xyzw@[42] WHERE y = 5;

-- query I
SELECT w FROM test.xyzw WHERE y = 5;

-- Test 53: statement (line 331)
CREATE TABLE boolean_table (
  id INTEGER PRIMARY KEY NOT NULL,
  value BOOLEAN
);

-- Test 54: statement (line 337)
INSERT INTO boolean_table (id, value) VALUES (1, NULL);

-- Test 55: query (line 340)
SELECT value FROM boolean_table;

-- Test 56: query (line 345)
SELECT CASE WHEN NULL THEN 1 ELSE 2 END;

-- Test 57: statement (line 350)
INSERT INTO abc VALUES (42, NULL, NULL);

-- Test 58: query (line 353)
SELECT 0 * b, b % 1, 0 % b from abc;

-- Test 59: statement (line 362)
CREATE TABLE MaxIntTest (a BIGINT PRIMARY KEY);

-- Test 60: statement (line 365)
INSERT INTO MaxIntTest VALUES (9223372036854775807);

-- Test 61: query (line 368)
SELECT a FROM MaxIntTest WHERE a = 9223372036854775807;

-- Test 62: query (line 373)
PREPARE select_int_param(int) AS SELECT $1::int;
EXECUTE select_int_param(1);
DEALLOCATE select_int_param;

-- Regression tests for #22670.
-- query B
SELECT 1 IN (1, 2);

-- Test 63: query (line 382)
SELECT NULL IN (1, 2);

-- Test 64: query (line 387)
SELECT 1 IN (1, NULL);

-- Test 65: query (line 392)
SELECT 1 IN (NULL, 2);

-- Test 66: query (line 399)
SELECT NULL IN ((1, 1));

-- Test 67: query (line 404)
SELECT (1, NULL) IN ((1, 1));

-- Test 68: query (line 409)
SELECT (2, NULL) IN ((1, 1));

-- Test 69: query (line 414)
-- PostgreSQL has no empty tuple literal `()` and cannot compare ROW() of zero
-- length. Skip these CockroachDB-specific cases.
-- SELECT () IN (1,2);

-- query error unsupported comparison operator: .* expected tuple (1, 2) to have a length of 0
-- SELECT () IN ((1,2));

-- query B
-- SELECT () IN (());

-- Test 70: query (line 436)
SELECT (1, 1) IN ((2, NULL));

-- Test 71: query (line 442)
SELECT NULL IN (SELECT * FROM (VALUES (1)) AS t(a));

-- Test 72: query (line 447)
SELECT (1, NULL) IN (SELECT * FROM (VALUES (1, 1)) AS t(a, b));

-- Test 73: query (line 472)
SELECT (NULL, 1) IN (SELECT * FROM (VALUES (1, 1)) AS t(a, b));

-- Test 74: query (line 477)
SELECT (NULL, 2) IN (SELECT * FROM (VALUES (1, 1)) AS t(a, b));

-- Test 75: query (line 482)
SELECT (NULL, NULL) IN (SELECT * FROM (VALUES (1, 1)) AS t(a, b));

-- Test 76: query (line 487)
SELECT NULL NOT IN (SELECT * FROM (VALUES (1)) AS t(a));

-- Test 77: query (line 512)
SELECT (2, NULL) NOT IN (SELECT * FROM (VALUES (1, 1)) AS t(a, b));

-- Test 78: query (line 517)
SELECT (NULL, 1) NOT IN (SELECT * FROM (VALUES (1, 1)) AS t(a, b));

-- Test 79: query (line 522)
SELECT (NULL, 2) NOT IN (SELECT * FROM (VALUES (1, 1)) AS t(a, b));

-- Test 80: query (line 527)
SELECT (NULL, NULL) NOT IN (SELECT * FROM (VALUES (1, 1)) AS t(a, b));

-- Test 81: query (line 533)
SELECT NULL IN (SELECT * FROM (VALUES (1)) AS t(a) WHERE a > 1);

-- Test 82: query (line 538)
SELECT (1, NULL) IN (SELECT * FROM (VALUES (1, 1)) AS t(a, b) WHERE a > 1);

-- Test 83: query (line 543)
SELECT (NULL, 1) IN (SELECT * FROM (VALUES (1, 1)) AS t(a, b) WHERE a > 1);

-- Test 84: query (line 548)
SELECT (NULL, NULL) IN (SELECT * FROM (VALUES (1, 1)) AS t(a, b) WHERE a > 1);

-- Test 85: query (line 553)
SELECT NULL NOT IN (SELECT * FROM (VALUES (1)) AS t(a) WHERE a > 1);

-- Test 86: query (line 558)
SELECT (1, NULL) NOT IN (SELECT * FROM (VALUES (1, 1)) AS t(a, b) WHERE a > 1);

-- Test 87: query (line 563)
SELECT (NULL, 1) NOT IN (SELECT * FROM (VALUES (1, 1)) AS t(a, b) WHERE a > 1);

-- Test 88: query (line 568)
SELECT (NULL, NULL) NOT IN (SELECT * FROM (VALUES (1, 1)) AS t(a, b) WHERE a > 1);

-- Test 89: statement (line 573)
CREATE TABLE a (x INT PRIMARY KEY, y INT);

-- Test 90: statement (line 576)
INSERT INTO a VALUES (1, 10), (2, 20), (3, 30);

-- Test 91: query (line 579)
SELECT * FROM a WHERE x > 1;

-- Test 92: query (line 585)
SELECT * FROM a WHERE y > 1;

-- Test 93: query (line 592)
SELECT * FROM a WHERE x > 1 AND x < 3;

-- Test 94: query (line 597)
SELECT * FROM a WHERE x > 1 AND y < 30;

-- Test 95: query (line 602)
SELECT x + 1 FROM a;

-- Test 96: query (line 609)
SELECT x, x + 1, y, y + 1, x + y FROM a;

-- Test 97: query (line 616)
SELECT u + v FROM (SELECT x + 3, y + 10 FROM a) AS foo(u, v);

-- Test 98: query (line 623)
SELECT x, x, y, x FROM a;

-- Test 99: query (line 630)
SELECT x + 1, x + y FROM a WHERE x + y > 20;

-- Test 100: statement (line 639)
-- CockroachDB exposes a hidden rowid column; model it explicitly for Postgres.
CREATE TABLE b (
  x INT,
  y INT,
  rowid BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY
);
INSERT INTO b (x, y) VALUES (1, 10), (2, 20), (3, 30);

-- Test 101: query (line 643)
SELECT * FROM b;

-- Test 102: query (line 650)
SELECT x FROM b WHERE rowid > 0;

-- Test 103: query (line 657)
SELECT x FROM b WHERE b.rowid > 0;

-- Test 104: query (line 671)
CREATE TABLE c (str TEXT);
INSERT INTO c VALUES ('moo');
SELECT * FROM c WHERE str >= 'moo';

-- Test 105: statement (line 685)
CREATE TABLE nocols(x INT); ALTER TABLE nocols DROP COLUMN x;

-- Test 106: query (line 688)
SELECT 1, * FROM nocols;

-- Test 107: statement (line 696)
CREATE TABLE wide (id INT4 NOT NULL, a INT4, b VARCHAR(255), c INT4, d VARCHAR(255), e VARCHAR(255), f INT4, g VARCHAR(255), h VARCHAR(255), i VARCHAR(255), j VARCHAR(255), k INT4,
                   l FLOAT4, m FLOAT8, n INT2, PRIMARY KEY (id));

-- Test 108: statement (line 700)
INSERT INTO wide(id, n) VALUES(0, 10);

-- Test 109: query (line 703)
SELECT * FROM wide;

-- Test 110: statement (line 710)
CREATE TABLE t44203(c0 BOOL);

-- Test 111: statement (line 713)
INSERT INTO t44203(c0) VALUES (false);

-- Test 112: statement (line 716)
CREATE VIEW v44203(c0) AS SELECT c0 FROM t44203 WHERE t44203.c0 OFFSET NULL;

-- Test 113: query (line 719)
SELECT * FROM v44203 WHERE current_user != '';

-- Test 114: statement (line 724)
CREATE TABLE t44132(
  c0 BOOL UNIQUE,
  c1 INT GENERATED ALWAYS AS (NULL::int) STORED
);

-- Test 115: statement (line 727)
INSERT INTO t44132 (c0) VALUES (true);

-- Test 116: query (line 730)
SELECT * FROM t44132 WHERE c0;

-- Test 117: statement (line 736)
CREATE TABLE t_disallow_scans(a INT, b INT);
CREATE INDEX b_idx ON t_disallow_scans(b);
CREATE INDEX b_partial ON t_disallow_scans(b) WHERE a > 0;

-- Test 118: statement (line 739)
SELECT * FROM t_disallow_scans;

-- Test 119: statement (line 743)
SELECT * FROM t_disallow_scans;

-- Test 120: statement (line 752)
SELECT * FROM t_disallow_scans WHERE a > 0;

-- Test 121: statement (line 762)
SELECT * FROM t_disallow_scans;

-- Test 122: statement (line 771)
SELECT * FROM t_disallow_scans WHERE a > 0;

-- Test 123: statement (line 781)
-- CockroachDB-only session setting.
-- SET disallow_full_table_scans = true;

-- Test 124: statement (line 785)
SELECT * FROM t_disallow_scans;

-- Test 125: statement (line 788)
SELECT * FROM t_disallow_scans;

-- Test 126: statement (line 792)
SELECT * FROM t_disallow_scans WHERE a > 0;

-- Test 127: statement (line 797)
-- CockroachDB-only session setting.
-- SET large_full_scan_rows = 0;

-- Test 128: statement (line 800)
-- CockroachDB-only: ALTER TABLE ... INJECT STATISTICS.
-- ALTER TABLE t_disallow_scans INJECT STATISTICS '[
--   {
--     "columns": ["rowid"],
--     "created_at": "2021-09-15 19:38:46.017315",
--     "distinct_count": 3,
--     "null_count": 0,
--     "row_count": 3
--   },
--   {
--     "columns": ["b"],
--     "created_at": "2021-09-15 19:38:46.017315",
--     "distinct_count": 1,
--     "null_count": 0,
--     "row_count": 3
--   },
--   {
--     "columns": ["a"],
--     "created_at": "2021-09-15 19:38:46.017315",
--     "distinct_count": 3,
--     "null_count": 0,
--     "row_count": 3
--   }
-- ]';

-- Test 129: statement (line 825)
SELECT * FROM t_disallow_scans;

-- Test 130: statement (line 828)
SELECT * FROM t_disallow_scans;

-- Test 131: statement (line 832)
SELECT * FROM pg_class;

-- Test 132: statement (line 835)
-- CockroachDB-only system table.
-- SELECT * FROM crdb_internal.node_build_info;

-- Test 133: statement (line 839)
-- CockroachDB-only session setting.
-- SET large_full_scan_rows = 4;

-- Test 134: statement (line 844)
SELECT * FROM t_disallow_scans;

-- Test 135: statement (line 847)
SELECT * FROM t_disallow_scans;

-- Test 136: statement (line 850)
-- CockroachDB-only session setting.
-- SET large_full_scan_rows = 2;

-- Test 137: statement (line 853)
SELECT * FROM t_disallow_scans;

-- Test 138: statement (line 856)
SELECT * FROM t_disallow_scans;

-- Test 139: statement (line 859)
-- CockroachDB-only session setting.
-- SET large_full_scan_rows = 3;

-- Test 140: statement (line 862)
SELECT * FROM t_disallow_scans;

-- Test 141: statement (line 866)
-- CockroachDB-only session settings.
-- SET disallow_full_table_scans = false;
-- RESET large_full_scan_rows;

-- Test 142: statement (line 871)
SELECT * FROM pg_catalog.pg_attrdef WHERE (adnum = 1 AND adrelid = 1) OR (adbin = 'foo' AND adrelid = 2);

-- Test 143: statement (line 875)
CREATE TABLE t(a INT, b INT);

-- Test 144: statement (line 878)
INSERT INTO t values(10, 20);

-- Test 145: query (line 881)
SELECT -488 AS OF FROM t;

-- Test 146: query (line 887)
SELECT -488 OF FROM t;

-- Test 147: statement (line 895)
CREATE TABLE trm (
    id UUID NOT NULL,
    trid UUID NOT NULL,
    ts12 TIMESTAMP NOT NULL
);
INSERT INTO trm VALUES('5ebfedee-0dcf-41e6-a315-5fa0b51b9882',
                       '5ebfedee-0dcf-41e6-a315-5fa0b51b9882',
                       '1999-12-31 23:59:59');
INSERT INTO trm VALUES('5ebfedee-0dcf-41e6-a315-5fa0b51b9883',
                       '5ebfedee-0dcf-41e6-a315-5fa0b51b9883',
                       '1999-12-31 23:59:58');
INSERT INTO trm VALUES('5ebfedee-0dcf-41e6-a315-5fa0b51b9882',
                       '5ebfedee-0dcf-41e6-a315-5fa0b51b9882',
                       '1999-11-30 23:59:59');
INSERT INTO trm VALUES('5ebfedee-0dcf-41e6-a315-5fa0b51b9883',
                       '5ebfedee-0dcf-41e6-a315-5fa0b51b9883',
                       '1999-11-30 23:59:58');
INSERT INTO trm VALUES('5ebfedee-0dcf-41e6-a315-5fa0b51b9884',
                       '5ebfedee-0dcf-41e6-a315-5fa0b51b9884',
                       '1999-11-30 23:59:57');

-- Test 148: statement (line 929)
CREATE TABLE trtab4 (
    id UUID NOT NULL,
    trid UUID NOT NULL,
    dec1 DECIMAL(19,2) NOT NULL
);
INSERT INTO trtab4 VALUES('5ebfedee-0dcf-41e6-a315-5fa0b51b9882', '5ebfedee-0dcf-41e6-a315-5fa0b51b9882', 1.0);
INSERT INTO trtab4 VALUES('5ebfedee-0dcf-41e6-a315-5fa0b51b9883', '5ebfedee-0dcf-41e6-a315-5fa0b51b9883', 2.0);
INSERT INTO trtab4 VALUES('5ebfedee-0dcf-41e6-a315-5fa0b51b9884', '5ebfedee-0dcf-41e6-a315-5fa0b51b9884', 3.0);

CREATE TABLE trrec (
    id UUID NOT NULL,
    trid UUID NOT NULL,
    str16 TEXT NOT NULL
);
INSERT INTO trrec VALUES
    ('5ebfedee-0dcf-41e6-a315-5fa0b51b9882', '5ebfedee-0dcf-41e6-a315-5fa0b51b9882', '12345'),
    ('5ebfedee-0dcf-41e6-a315-5fa0b51b9883', '5ebfedee-0dcf-41e6-a315-5fa0b51b9883', '12345');

-- Test 149: query (line 939)
WITH
  with2
    AS (
      SELECT
        tq.trid, tq.dec1
      FROM
        trrec AS r INNER JOIN trtab4 AS tq ON r.id = tq.trid AND r.str16 = '12345'
    )
SELECT tr.id, tr.trid, val3.ts12
FROM
  trrec AS tr
  INNER JOIN LATERAL (
      SELECT  q.dec1 FROM with2 AS q WHERE tr.id = q.trid
    ) AS q ON true
  INNER JOIN LATERAL (
      SELECT
        m.ts12
      FROM trm AS m WHERE tr.id = m.trid
      ORDER BY m.ts12 ASC
      LIMIT 1
    ) AS val3 ON true
WHERE
  tr.str16 = '12345'
ORDER BY 1 DESC
;

-- Test 150: statement (line 971)
CREATE TABLE t102864 (c INT4);
INSERT INTO t102864 (c) VALUES (0);

-- Test 151: query (line 975)
SELECT c FROM t102864 WHERE c IN (0, 862827606027206657::INT8);

-- Test 152: statement (line 982)
CREATE TABLE t146637 (
    a INT NOT NULL,
    b TEXT NOT NULL,
    c TEXT NOT NULL,
    PRIMARY KEY (a, b)
);

-- Test 153: statement (line 991)
INSERT INTO t146637 VALUES
    (0, 'foo', 'bar'),
    (0, 'foo2', 'bar2'),
    (0, 'foo3', 'bar3'),
    (100, 'foo', 'bar'),
    (100, 'foo2', 'bar2'),
    (100, 'foo3', 'bar3'),
    (2, 'foo4', 'bar4'),
    (2, 'foo5', 'bar5');

-- retry

-- Test 154: query (line 1006)
SELECT * FROM t146637 WHERE (a = 0 OR a = 100) AND b = 'foo' ORDER BY a DESC LIMIT 1;
