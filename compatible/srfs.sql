-- PostgreSQL compatible tests from srfs
-- 165 tests

-- Many cases below are expected to error; let psql continue.
\set ON_ERROR_STOP 0

SET client_min_messages = warning;

-- Minimal shims used by this test file.
CREATE SCHEMA crdb_internal;
CREATE OR REPLACE FUNCTION crdb_internal.unary_table() RETURNS INT
LANGUAGE sql AS $$
  SELECT 1;
$$;

-- CockroachDB exposes isnan(); PostgreSQL doesn't. Provide a minimal shim.
CREATE OR REPLACE FUNCTION isnan(double precision) RETURNS boolean
LANGUAGE sql IMMUTABLE AS $$
  SELECT $1 <> $1;
$$;

CREATE TABLE t (x TEXT);
CREATE TABLE u (x TEXT);

-- Test 1: query (line 4)
SELECT * FROM generate_series(1, NULL);

-- Test 2: query (line 8)
SELECT * FROM generate_series(1, 3);

-- Test 3: query (line 16)
SELECT * FROM generate_series('2017-11-11 00:00:00'::TIMESTAMP, '2017-11-11 03:00:00'::TIMESTAMP, '1 hour');

-- Test 4: query (line 25)
SELECT * FROM generate_series('2017-11-11 03:00:00'::TIMESTAMP, '2017-11-11 00:00:00'::TIMESTAMP, '-1 hour');

-- Test 5: query (line 34)
SELECT * FROM generate_series('2017-11-11 03:00:00'::TIMESTAMP, '2017-11-15 00:00:00'::TIMESTAMP, '1 day');

-- Test 6: query (line 43)
SELECT * FROM generate_series('2017-01-15 03:00:00'::TIMESTAMP, '2017-12-15 00:00:00'::TIMESTAMP, '1 month');

-- Test 7: query (line 61)
SELECT * FROM generate_series('2016-01-31 03:00:00'::TIMESTAMP, '2016-12-31 00:00:00'::TIMESTAMP, '1 month');

-- Test 8: query (line 79)
SELECT * FROM generate_series('2016-01-31 03:00:00'::TIMESTAMP, '2016-12-31 00:00:00'::TIMESTAMP, '2 month');

-- Test 9: query (line 91)
SELECT * FROM generate_series('2016-01-30 22:00:00'::TIMESTAMP, '2016-12-31 00:00:00'::TIMESTAMP, '1 month 1 day 1 hour');

-- Test 10: query (line 107)
SELECT * FROM generate_series('1996-02-29 22:00:00'::TIMESTAMP, '2004-03-01 00:00:00'::TIMESTAMP, '4 year');

-- Test 11: query (line 115)
SELECT * FROM generate_series('2017-11-11 00:00:00'::TIMESTAMP, '2017-11-11 03:00:00'::TIMESTAMP, '-1 hour');

-- Test 12: query (line 120)
SELECT * FROM generate_series(1, 2) AS g1(a), generate_series(1, 2) AS g2(b);

-- Test 13: query (line 129)
SELECT * FROM generate_series(3, 1, -1);

-- Test 14: query (line 137)
SELECT * FROM generate_series(3, 1);

-- Test 15: query (line 142)
SELECT * FROM generate_series(1, 3, 0);

-- query I colnames,nosort
SELECT * FROM PG_CATALOG.generate_series(1, 3);

-- Test 16: query (line 153)
SELECT * FROM generate_series(1, 1) AS c(x);

-- Test 17: query (line 159)
SELECT * FROM generate_series(1, 1) WITH ORDINALITY;

-- Test 18: query (line 165)
SELECT * FROM generate_series(1, 1) WITH ORDINALITY AS c(x, y);

-- Test 19: query (line 171)
SELECT * FROM (VALUES (1)) LIMIT generate_series(1, 3);

-- query I colnames,nosort
SELECT generate_series(1, 2);

-- Test 20: query (line 183)
SELECT generate_series(1, 2), generate_series(3, 4);

-- Test 21: query (line 190)
SELECT generate_series(1, 2), generate_series(3, 4);

-- Test 22: statement (line 202)
INSERT INTO t VALUES ('cat');

-- Test 23: statement (line 205)
INSERT INTO u VALUES ('bird');

-- Test 24: query (line 208)
SELECT t.*, u.*, generate_series(1,2), generate_series(3, 4) FROM t, u;

-- Test 25: query (line 215)
SELECT t.*, u.*, a.*, b.* FROM t, u, generate_series(1, 2) AS a, generate_series(3, 4) AS b;

-- Test 26: query (line 224)
SELECT 3 + x AS r FROM generate_series(1,2) AS a(x);

-- Test 27: query (line 231)
SELECT 3 + generate_series(1,2) AS r;

-- Test 28: query (line 238)
SELECT 3 + (3 * generate_series(1,3)) AS r;

-- Test 29: statement (line 248)
CREATE TABLE ordered_t(x INT PRIMARY KEY);
  INSERT INTO ordered_t VALUES (0), (1);

-- Test 30: query (line 252)
SELECT x, generate_series(3, x, -1) FROM ordered_t ORDER BY 1, 2;

-- Test 31: statement (line 266)
SELECT * FROM unnest(NULL::int[]);

-- Test 32: statement (line 269)
SELECT unnest(NULL::int[]);

-- Test 33: query (line 272)
SELECT * from unnest(ARRAY[1,2]);

-- Test 34: query (line 279)
SELECT unnest(ARRAY[1,2]), unnest(ARRAY['a', 'b']);

-- Test 35: query (line 285)
SELECT unnest(ARRAY[3,4]) - 2 AS r;

-- Test 36: query (line 292)
SELECT 1 + generate_series(0, 1) AS r, unnest(ARRAY[2, 4]) - 1 AS t;

-- Test 37: query (line 299)
SELECT 1 + generate_series(0, 1), unnest(ARRAY[2, 4]) - 1;

-- Test 38: query (line 305)
SELECT ascii(unnest(ARRAY['a', 'b', 'c']));

-- Test 39: query (line 316)
SELECT generate_series(generate_series(1, 3), 3);

-- query I rowsort
SELECT generate_series(1, 3) + generate_series(1, 3);

-- Test 40: query (line 326)
SELECT generate_series(1, 3) FROM t WHERE generate_series > 3;

-- Regressions for #15900: ensure that null parameters to generate_series don't
-- cause issues.

-- query T colnames
SELECT * from generate_series(1, (select * from generate_series(1, 0)));

-- Test 41: query (line 339)
SELECT unnest(current_schemas(isnan((round(3.4, (SELECT generate_series(1, 0))))::float8)));

-- Test 42: query (line 344)
SELECT information_schema._pg_expandarray(current_schemas(isnan((round(3.4, (SELECT generate_series(1, 0))))::float8)));

-- Test 43: query (line 350)
SELECT generate_series(9223372036854775807::int, -9223372036854775807::int, -9223372036854775807::int);

-- Test 44: query (line 361)
SELECT * FROM pg_get_keywords() WHERE word IN ('alter', 'and', 'between', 'cross') ORDER BY word;

-- Test 45: query (line 372)
SELECT a.*, b.*, c.* FROM generate_series(1,1) a, unnest(ARRAY[1]) b, pg_get_keywords() c LIMIT 0;

-- Test 46: query (line 379)
SELECT * FROM (SELECT * FROM generate_series(1, 2)) AS a;

-- Test 47: query (line 386)
SELECT * FROM (SELECT unnest(ARRAY[1])) AS tablealias;

-- Test 48: query (line 392)
SELECT * FROM (SELECT unnest(ARRAY[1]) AS colalias) AS tablealias;

-- Test 49: query (line 398)
SELECT * FROM
  (SELECT unnest(ARRAY[1]) AS filter_id2) AS uq
JOIN
  (SELECT unnest(ARRAY[1]) AS filter_id) AS ab
ON uq.filter_id2 = ab.filter_id;

-- Test 50: query (line 408)
SELECT 'a' AS a, pg_get_keywords(), 'c' AS c LIMIT 1;

-- Test 51: query (line 414)
SELECT 'a' AS a, pg_get_keywords() AS b, 'c' AS c LIMIT 1;

-- Test 52: query (line 422)
SELECT 'a' AS a, crdb_internal.unary_table() AS b, 'c' AS c LIMIT 1;

-- Test 53: query (line 431)
SELECT * FROM upper('abc');

-- Test 54: query (line 439)
SELECT * FROM current_schema() WITH ORDINALITY AS a(b);

-- Test 55: query (line 447)
SELECT information_schema._pg_expandarray();

-- query error pq: unknown signature: information_schema._pg_expandarray()
SELECT * FROM information_schema._pg_expandarray();

-- query error pq: information_schema\._pg_expandarray\(\): cannot determine type of empty array\. Consider casting to the desired type, for example ARRAY\[\]::int\[\]
SELECT information_schema._pg_expandarray(ARRAY[]);

-- query error pq: information_schema\._pg_expandarray\(\): cannot determine type of empty array\. Consider casting to the desired type, for example ARRAY\[\]::int\[\]
SELECT * FROM information_schema._pg_expandarray(ARRAY[]);

-- statement error could not determine polymorphic type
SELECT * FROM information_schema._pg_expandarray(NULL);

-- statement error could not determine polymorphic type
SELECT information_schema._pg_expandarray(NULL);

-- query I colnames
SELECT information_schema._pg_expandarray(ARRAY[]::int[]);

-- Test 56: query (line 470)
SELECT * FROM information_schema._pg_expandarray(ARRAY[]::int[]);

-- Test 57: query (line 475)
SELECT information_schema._pg_expandarray(ARRAY[100]);

-- Test 58: query (line 481)
SELECT * FROM information_schema._pg_expandarray(ARRAY[100]);

-- Test 59: query (line 487)
SELECT information_schema._pg_expandarray(ARRAY[2, 1]);

-- Test 60: query (line 494)
SELECT * FROM information_schema._pg_expandarray(ARRAY[2, 1]);

-- Test 61: query (line 501)
SELECT information_schema._pg_expandarray(ARRAY[3, 2, 1]);

-- Test 62: query (line 509)
SELECT * FROM information_schema._pg_expandarray(ARRAY[3, 2, 1]);

-- Test 63: query (line 517)
SELECT information_schema._pg_expandarray(ARRAY['a']);

-- Test 64: query (line 523)
SELECT * FROM information_schema._pg_expandarray(ARRAY['a']);

-- Test 65: query (line 529)
SELECT information_schema._pg_expandarray(ARRAY['b', 'a']);

-- Test 66: query (line 536)
SELECT * FROM information_schema._pg_expandarray(ARRAY['b', 'a']);

-- Test 67: query (line 543)
SELECT information_schema._pg_expandarray(ARRAY['c', 'b', 'a']);

-- Test 68: query (line 551)
SELECT * FROM information_schema._pg_expandarray(ARRAY['c', 'b', 'a']);

-- Test 69: query (line 601)
SELECT (information_schema._pg_expandarray(ARRAY['c', 'b', 'a'])).x;

-- Test 70: query (line 609)
SELECT (information_schema._pg_expandarray(ARRAY['c', 'b', 'a'])).n;

-- Test 71: query (line 617)
SELECT (information_schema._pg_expandarray(ARRAY['c', 'b', 'a'])).other;

-- query T colnames,nosort
SELECT temp.x from information_schema._pg_expandarray(array['c','b','a']) AS temp;

-- Test 72: query (line 628)
SELECT temp.n from information_schema._pg_expandarray(array['c','b','a']) AS temp;

-- Test 73: query (line 636)
SELECT temp.other from information_schema._pg_expandarray(array['c','b','a']) AS temp;

-- query TI colnames,nosort
SELECT temp.* from information_schema._pg_expandarray(array['c','b','a']) AS temp;

-- Test 74: query (line 647)
SELECT * from information_schema._pg_expandarray(array['c','b','a']) AS temp;

-- Test 75: query (line 655)
SELECT (i.keys).n FROM (SELECT information_schema._pg_expandarray(ARRAY[3,2,1]) AS keys) AS i;

-- Test 76: query (line 663)
SELECT (i.keys).* FROM (SELECT information_schema._pg_expandarray(ARRAY[3,2,1]) AS keys) AS i;

-- Test 77: query (line 671)
SELECT ((i.keys).*, 123) FROM (SELECT information_schema._pg_expandarray(ARRAY[3,2,1]) AS keys) AS i;

-- Test 78: query (line 682)
SELECT * FROM generate_subscripts(ARRAY[3,2,1], 1);

-- Test 79: query (line 690)
SELECT * FROM generate_subscripts(ARRAY[3,2,1], 1);

-- Test 80: query (line 698)
SELECT * FROM generate_subscripts(ARRAY[3,2,1], 1, false);

-- Test 81: query (line 706)
SELECT * FROM generate_subscripts(ARRAY[3,2,1], 1, true);

-- Test 82: query (line 714)
SELECT generate_subscripts('{NULL,1,NULL,2}'::int[], 1) AS s;

-- Test 83: query (line 723)
SELECT generate_subscripts('{NULL,1,NULL,2}'::int[], 1, true) AS s;

-- Test 84: query (line 734)
SELECT * FROM generate_subscripts(ARRAY[3,2,1], 2);

-- Test 85: query (line 739)
SELECT * FROM generate_subscripts(ARRAY[3,2,1], 2, false);

-- Test 86: query (line 744)
SELECT * FROM generate_subscripts(ARRAY[3,2,1], 2, true);

-- Test 87: query (line 749)
SELECT * FROM generate_subscripts(ARRAY[3,2,1], 0);

-- Test 88: query (line 754)
SELECT * FROM generate_subscripts(ARRAY[3,2,1], 0, false);

-- Test 89: query (line 759)
SELECT * FROM generate_subscripts(ARRAY[3,2,1], 0, true);

-- Test 90: query (line 764)
SELECT * FROM generate_subscripts(ARRAY[3,2,1], -1);

-- Test 91: query (line 769)
SELECT * FROM generate_subscripts(ARRAY[3,2,1], -1, false);

-- Test 92: query (line 774)
SELECT * FROM generate_subscripts(ARRAY[3,2,1], -1, true);

-- Test 93: query (line 780)
SELECT * FROM generate_subscripts(ARRAY[]::int[], 1);

-- Test 94: query (line 785)
SELECT * FROM generate_subscripts(ARRAY[]::int[], 1);

-- Test 95: query (line 795)
SELECT * FROM generate_subscripts(ARRAY[]::bool[], 1, true);

-- Test 96: query (line 800)
SELECT * FROM generate_subscripts(ARRAY[]::int[], 0);

-- Test 97: query (line 810)
SELECT * FROM generate_subscripts(ARRAY[]::bool[], 2, true);

-- Test 98: query (line 816)
SELECT * FROM generate_subscripts(ARRAY[100], 1);

-- Test 99: query (line 822)
SELECT * FROM generate_subscripts(ARRAY[100], 1);

-- Test 100: query (line 828)
SELECT * FROM generate_subscripts(ARRAY['b'], 1, false);

-- Test 101: query (line 834)
SELECT * FROM generate_subscripts(ARRAY[true], 1, true);

-- Test 102: query (line 842)
SELECT * FROM t ORDER BY generate_series(1, 3);

-- query error set-returning functions are not allowed in WHERE
SELECT * FROM t WHERE generate_series(1, 3) < 3;

-- query error set-returning functions are not allowed in HAVING
SELECT * FROM t HAVING generate_series(1, 3) < 3;

-- query error set-returning functions are not allowed in LIMIT
SELECT * FROM t LIMIT generate_series(1, 3);

-- query error set-returning functions are not allowed in OFFSET
SELECT * FROM t OFFSET generate_series(1, 3);

-- query error set-returning functions are not allowed in VALUES
VALUES (generate_series(1,3));

-- statement error set-returning functions are not allowed in DEFAULT
CREATE TABLE uu (x INT DEFAULT generate_series(1, 3));

-- statement error set-returning functions are not allowed in CHECK
CREATE TABLE uu (x INT CHECK (generate_series(1, 3) < 3));

-- statement error generate_series\(\): set-returning functions are not allowed in STORED COMPUTED COLUMN
CREATE TABLE uu (x INT GENERATED ALWAYS AS (generate_series(1, 3)) STORED);

-- subtest correlated_srf;

-- Initially this table will have 3 columns:
-- x, y, rowid
-- statement ok
CREATE TABLE vals (x INT, y INT);
CREATE INDEX woo ON vals(x, y);

-- statement ok
ALTER TABLE vals DROP COLUMN y cascade;

-- Once the second column is and added dropped this table will have the format:
-- x, rowid, y
-- statement ok
ALTER TABLE vals ADD COLUMN y int;

-- statement ok
CREATE INDEX woo ON vals(x,y);

-- statement ok
INSERT INTO vals VALUES (3, 4), (NULL, NULL), (5, 6);

-- query III colnames
SELECT x, generate_series(1,x), generate_series(1,2) FROM vals ORDER BY 1,2,3;

-- Test 103: query (line 907)
SELECT generate_series(1,x) FROM vals;

-- Test 104: query (line 922)
SELECT count(*) FROM (SELECT generate_series(1,x) FROM vals);

-- Test 105: query (line 927)
SELECT relname, unnest(indkey) FROM pg_class, pg_index WHERE pg_class.oid = pg_index.indrelid ORDER BY relname, unnest;

-- Test 106: query (line 939)
SELECT relname, information_schema._pg_expandarray(indkey) FROM pg_class, pg_index WHERE pg_class.oid = pg_index.indrelid ORDER BY relname, indexrelid, x, n;

-- Test 107: statement (line 963)
CREATE TABLE j(x INT PRIMARY KEY, y JSON);
  INSERT INTO j VALUES
     (1, '{"a":123,"b":456}'),
     (2, '{"c":111,"d":222}');

-- Test 108: query (line 969)
SELECT x, y->>json_object_keys(y) FROM j;

-- Test 109: query (line 979)
SELECT tbl, idx, (i.keys).n
  FROM (SELECT ct.relname AS tbl, ct2.relname AS idx, information_schema._pg_expandarray(indkey) AS keys
          FROM pg_index ix
          JOIN pg_class ct ON ix.indrelid = ct.oid AND ct.relname = 'vals'
	  JOIN pg_class ct2 ON ix.indexrelid = ct2.oid) AS i
ORDER BY 1,2,3;

-- Test 110: query (line 995)
SELECT   a.attname, a.atttypid, atttypmod
    FROM pg_catalog.pg_class ct
    JOIN pg_catalog.pg_attribute a ON (ct.oid = a.attrelid)
    JOIN pg_catalog.pg_namespace n ON (ct.relnamespace = n.oid)
    JOIN (
      SELECT i.indexrelid, i.indrelid, i.indisprimary,
             information_schema._pg_expandarray(i.indkey) AS keys
        FROM pg_catalog.pg_index i
        ) i ON (a.attnum = (i.keys).x AND a.attrelid = i.indrelid)
   WHERE true
     AND n.nspname = 'public'
     AND ct.relname = 'j'
     AND i.indisprimary
ORDER BY a.attnum;

-- Test 111: query (line 1017)
SELECT NULL AS TABLE_CAT,
       n.nspname AS TABLE_SCHEM,
       ct.relname AS TABLE_NAME,
       a.attname AS COLUMN_NAME,
       (i.keys).n AS KEY_SEQ,
       ci.relname AS PK_NAME
    FROM pg_catalog.pg_class ct
    JOIN pg_catalog.pg_attribute a ON (ct.oid = a.attrelid)
    JOIN pg_catalog.pg_namespace n ON (ct.relnamespace = n.oid)
    JOIN (SELECT i.indexrelid,
                 i.indrelid,
             i.indisprimary,
             information_schema._pg_expandarray(i.indkey) AS keys
        FROM pg_catalog.pg_index i) i ON (a.attnum = (i.keys).x AND a.attrelid = i.indrelid)
    JOIN pg_catalog.pg_class ci ON (ci.oid = i.indexrelid)
   WHERE true AND ct.relname = 'j' AND i.indisprimary
ORDER BY table_name, pk_name, key_seq;

-- Test 112: query (line 1096)
SELECT unnest(ARRAY[(1,2),(3,4)]);

-- Test 113: query (line 1103)
SELECT (unnest(ARRAY[(1,2),(3,4)])).*;

-- Test 114: query (line 1110)
SELECT * FROM unnest(ARRAY[(1,2),(3,4)]) AS t(a int, b int);

-- Test 115: query (line 1117)
SELECT t.* FROM unnest(ARRAY[(1,2),(3,4)]) AS t(a int, b int);

-- Test 116: query (line 1127)
SELECT * FROM unnest(ARRAY[1,2], ARRAY['a','b']) AS t(i, s);

-- Test 117: query (line 1133)
SELECT * FROM unnest(ARRAY[1,2], ARRAY['a'], ARRAY[1.1, 2.2, 3.3]) AS t(i, s, f);

-- Test 118: query (line 1140)
SELECT * FROM unnest(ARRAY[1,2], ARRAY['a', 'b']);

-- Test 119: query (line 1147)
SELECT * FROM unnest(ARRAY[1,2], ARRAY['a'], ARRAY[1.1, 2.2, 3.3]);

-- Test 120: query (line 1155)
SELECT * FROM unnest(array[1,2], array[3,4,5]) AS t(a, b);

-- Test 121: query (line 1163)
SELECT unnest(ARRAY[1,2,3]) FROM unnest(ARRAY[4,5,6]);

-- Test 122: query (line 1176)
SELECT unnest(ARRAY[NULL,2,3]) FROM unnest(ARRAY[NULL,NULL,NULL]);

-- Test 123: query (line 1189)
SELECT unnest(ARRAY[1,2,NULL]) FROM unnest(ARRAY[NULL,NULL,NULL]);

-- Test 124: query (line 1202)
SELECT unnest(ARRAY[NULL,NULL,NULL]) FROM unnest(ARRAY[NULL,NULL,NULL]);

-- Test 125: statement (line 1215)
CREATE TABLE xy (x INT PRIMARY KEY, y INT);

-- Test 126: statement (line 1218)
INSERT INTO xy VALUES (1,1), (2,2), (3,4), (4,8), (5,NULL);

-- Test 127: query (line 1221)
SELECT * FROM xy WHERE x IN (SELECT unnest(ARRAY[NULL,x]));

-- Test 128: query (line 1230)
SELECT * FROM xy
WHERE EXISTS
(SELECT t
  FROM unnest(ARRAY[NULL,2,NULL,4,5,x])
  AS f(t)
  WHERE t=y
);

-- Test 129: query (line 1243)
SELECT unnest(ARRAY[1,2,3,4]), unnest(ARRAY['one','two']);

-- Test 130: query (line 1251)
SELECT unnest(ARRAY[1,2,3::varbit(3)]);

-- query error expected 2 to be of type varbit, found type int
SELECT unnest(ARRAY[NULL,2,3::varbit(3)]);

-- query error pq: could not determine polymorphic type
SELECT unnest(NULL, NULL);

-- query error pq: could not determine polymorphic type
SELECT unnest(ARRAY[1,2], NULL);

-- query error pq: could not determine polymorphic type
SELECT * FROM unnest(NULL, NULL);

-- query error pq: column reference "unnest" is ambiguous
SELECT unnest FROM unnest(array[1,2], array[3,4,5]);

-- Regression test for #58438 - handle the case when unnest outputs a tuple with
-- labels. The unnest should not panic.
-- statement ok
CREATE TABLE t58438(a INT, b INT);

-- statement ok
INSERT INTO t58438 VALUES (1, 2), (3, 4), (5, 6);

-- query T rowsort
SELECT unnest(ARRAY[t58438.*]) FROM t58438;

-- Test 131: query (line 1284)
SELECT (x).* FROM (SELECT unnest(ARRAY[t58438.*]) FROM t58438) v(x);

-- Test 132: statement (line 1293)
SET crdb.testing_optimizer_disable_rule_probability = 1.0;

-- Test 133: statement (line 1296)
CREATE TABLE t95615 (c1 INET PRIMARY KEY);

-- Test 134: statement (line 1299)
INSERT INTO t95615 VALUES ('192.168.0.1'::INET);

-- Test 135: query (line 1304)
SELECT * FROM t95615, LATERAL ROWS FROM (hostmask(c1), hostmask(c1)) WITH ORDINALITY;

-- Test 136: statement (line 1309)
CREATE FUNCTION f95615() RETURNS FLOAT IMMUTABLE LEAKPROOF LANGUAGE SQL AS 'SELECT 1.1';

-- Test 137: query (line 1314)
SELECT * FROM t95615, LATERAL ROWS FROM (f95615(), f95615()) WITH ORDINALITY;

-- Test 138: statement (line 1319)
RESET crdb.testing_optimizer_disable_rule_probability;

-- Test 139: statement (line 1323)
CREATE TABLE t95315 (c1 INT, c2 FLOAT);

-- Test 140: statement (line 1326)
INSERT INTO t95315 VALUES (1, 4.3), (2, 5.4), (3, 6), (4, 7);

-- Test 141: query (line 1332)
SELECT 1,c1,c2 FROM t95315 JOIN ROWS FROM (CAST(c1 AS INT), CAST(c2 AS INT)) USING (c1, c2) ORDER BY 1,2,3;

-- Test 142: statement (line 1342)
SELECT CASE generate_series(1, 3) WHEN 3 THEN 0 ELSE 1 END;

-- Test 143: statement (line 1345)
SELECT CASE WHEN true THEN generate_series(1, 3) ELSE 1 END;

-- Test 144: statement (line 1348)
SELECT CASE WHEN false THEN 1 ELSE generate_series(1, 3) END;

-- Test 145: statement (line 1351)
SELECT COALESCE(generate_series(1, 10));

-- Test 146: query (line 1355)
SELECT CASE WHEN true THEN (SELECT * FROM generate_series(1, 3) LIMIT 1) ELSE 1 END;

-- Test 147: query (line 1360)
SELECT COALESCE((SELECT * FROM generate_series(1, 3) LIMIT 1));

-- Test 148: query (line 1366)
SELECT CASE WHEN true THEN sum(x) ELSE 1 END FROM xy;

-- Test 149: query (line 1371)
SELECT COALESCE(sum(x)) FROM xy;

-- Test 150: query (line 1377)
SELECT CASE WHEN true THEN sum(x) OVER () ELSE 1 END FROM xy;

-- Test 151: query (line 1386)
SELECT COALESCE(sum(x) OVER ()) FROM xy;

-- Test 152: statement (line 1396)
SELECT CASE WHEN x > y THEN generate_series(1, 3) ELSE 0 END FROM xy;

-- Test 153: statement (line 1401)
SELECT COALESCE(1, generate_series(1, 2));

-- Test 154: query (line 1405)
SELECT NULLIF(generate_series(1, x), generate_series(1, 3)) from xy;

-- Test 155: statement (line 1429)
SELECT unnest('{}');

-- Test 156: statement (line 1432)
SELECT unnest('{}', '{}', '{}');

-- Test 157: statement (line 1435)
SELECT unnest(1);

-- Test 158: statement (line 1438)
SELECT unnest(1, 2, 3);

-- Test 159: statement (line 1441)
SELECT unnest(NULL::int[]);

-- Test 160: statement (line 1444)
SELECT unnest(NULL, NULL, NULL);

-- Test 161: statement (line 1448)
SELECT information_schema._pg_expandarray('{}');

-- Test 162: query (line 1451)
SELECT unnest('{1}'::int[], '{2}', '{3}');

-- Test 163: query (line 1456)
SELECT unnest('{1}'::int[], '{}', '{}');

-- Test 164: query (line 1461)
SELECT unnest('{1}', '{2}', '{3}'::int[]);

-- Test 165: query (line 1466)
SELECT unnest('{}', '{}', '{3}'::int[]);
