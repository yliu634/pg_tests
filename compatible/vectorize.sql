-- PostgreSQL compatible tests from vectorize
-- 191 tests

-- The upstream logic tests rely on some pre-created tables. Create minimal
-- equivalents for isolated PostgreSQL runs.
SET client_min_messages = warning;
DROP TABLE IF EXISTS a, b, builtin_test, t38959, t38959_2, t_39540, t_39827, t_40227, t_42816, t40732, t43429, t44133_0, t44133_1, t44624, t45481, t64793, t66706, t68040 CASCADE;
RESET client_min_messages;

CREATE TABLE a (a INT, b INT, c INT4, PRIMARY KEY (a, b));
INSERT INTO a SELECT g/2, g, g FROM generate_series(0, 2000) AS g(g);

CREATE TABLE b (a INT, b INT);
INSERT INTO b VALUES (1, 1), (2, 1), (3, 2), (4, 2), (5, 3);

CREATE TABLE builtin_test (x TEXT, y INT);
INSERT INTO builtin_test VALUES ('abcdef', 3), ('hello', 2);

CREATE TABLE t38959 (a INT, c INT);
INSERT INTO t38959 VALUES (1, 10), (2, 20);

CREATE TABLE t38959_2 (x INT, y INT, z DECIMAL);
INSERT INTO t38959_2 VALUES (1, 2, 3.0), (5, 2, 3.0), (7, 0, 1.0);

CREATE TABLE t_39540 (_decimal NUMERIC, _bool BOOL);
INSERT INTO t_39540 VALUES (1.0, false);

CREATE TABLE t_39827 (a INT);
INSERT INTO t_39827 VALUES (1), (2), (3);

CREATE TABLE t_40227 (a INT);
INSERT INTO t_40227 VALUES (1);

CREATE TABLE t_42816 (a INT);
INSERT INTO t_42816 SELECT g FROM generate_series(0, 2000) AS g(g);

CREATE TABLE t40732 (_int8 BIGINT, _float8 DOUBLE PRECISION, _bool BOOL);
INSERT INTO t40732 VALUES (1, 1.0, false), (1, 1.0, true);

CREATE TABLE t43429 (i INT, s TEXT);
INSERT INTO t43429 VALUES (1, 'a'), (1, 'b'), (2, 'c');

CREATE TABLE t44133_0 (c0 TEXT);
CREATE TABLE t44133_1 (c0 TEXT);
INSERT INTO t44133_0 VALUES ('a');
INSERT INTO t44133_1 VALUES (NULL), ('');

CREATE TABLE t44624 (c0 INT, c1 INT);
INSERT INTO t44624 VALUES (1, NULL), (2, 1), (3, NULL);

CREATE TABLE t45481 (a INT, b INT, d INT, e INT, f INT, g INT);
INSERT INTO t45481 VALUES (1, 1, 1, 1, 1, 1), (2, 1, 1, 1, 1, 1), (3, 2, 1, 1, 1, 1);

CREATE TABLE t64793 (_bool BOOL, _string TEXT);
INSERT INTO t64793 VALUES (true, 'foo'), (false, 'bar');

CREATE TABLE t66706 (a INT, b TEXT);
CREATE INDEX u ON t66706 (b);

CREATE TABLE t68040 (c TEXT);
INSERT INTO t68040 VALUES ('a\\b'), ('abc');

-- Test 1: query (line 23)
SELECT a, CASE WHEN a = 0 THEN 0 WHEN a = 1 THEN 3 ELSE 5 END FROM a ORDER BY 1, 2 LIMIT 6;

-- Test 2: query (line 33)
SELECT a, CASE a WHEN 0 THEN 0 WHEN 1 THEN 3 ELSE 5 END FROM a ORDER BY 1, 2 LIMIT 6;

-- Test 3: statement (line 44)
CREATE TABLE t40574(pk INTEGER PRIMARY KEY, col0 INTEGER, col1 FLOAT, col2 TEXT, col3 INTEGER, col4 FLOAT, col5 TEXT);

-- Test 4: query (line 47)
SELECT pk FROM t40574 WHERE (col0 > 9 AND (col1 <= 6.38 OR col0 =5) AND (col0 = 7 OR col4 = 7));

-- Test 5: query (line 52)
SELECT b, b = 0 OR b = 2 FROM a WHERE b < 4;

-- Test 6: query (line 61)
SELECT b FROM a WHERE b = 0 OR b = 2;

-- Test 7: query (line 68)
SELECT b FROM a WHERE b = 0 OR 1/NULLIF(b, 0) = 1;

-- Test 8: statement (line 74)
CREATE TABLE bools (b BOOL, i INT, PRIMARY KEY (b, i)); INSERT INTO bools VALUES (true, 0), (false, 1), (true, 2), (false, 3);
CREATE TABLE nulls (a INT, b INT);
INSERT INTO nulls VALUES (NULL, NULL), (NULL, 1), (1, NULL), (1, 1);

-- Test 9: query (line 79)
SELECT count(*) FROM a;

-- Test 10: query (line 84)
SELECT count(*) FROM (SELECT DISTINCT a FROM a);

-- Test 11: query (line 89)
SELECT * FROM a ORDER BY 1, 2 LIMIT 10;

-- Test 12: query (line 103)
SELECT DISTINCT(a), b FROM a ORDER BY 1, 2 LIMIT 10;

-- Test 13: query (line 118)
SELECT b FROM a WHERE b < 3;

-- Test 14: query (line 126)
SELECT c, c > 1 FROM a LIMIT 3;

-- Test 15: query (line 134)
SELECT a FROM nulls WHERE a < 2;

-- Test 16: query (line 140)
SELECT a, b FROM nulls WHERE a <= b;

-- Test 17: query (line 147)
SELECT a, b FROM a WHERE a * 2 < b ORDER BY 1, 2 LIMIT 5;

-- Test 18: query (line 157)
SELECT b + 1 FROM a WHERE b < 3;

-- Test 19: query (line 165)
SELECT b + 1 FROM nulls;

-- Test 20: query (line 173)
SELECT a, b, a + b FROM nulls;

-- Test 21: query (line 182)
SELECT a, b, (a + 1) * (b + 2) FROM a WHERE a < 3;

-- Test 22: query (line 192)
SELECT (a + 1.0::DECIMAL)::INT FROM a LIMIT 1;

-- Test 23: query (line 198)
SELECT 5 - a FROM a ORDER BY 1 DESC LIMIT 3;

-- Test 24: query (line 206)
SELECT 5, a FROM a ORDER BY 2 LIMIT 3;

-- Test 25: query (line 215)
SELECT * FROM bools WHERE b;

-- Test 26: statement (line 222)
CREATE TABLE intdecfloat (a INT, b DECIMAL, c INT4, d INT2, e FLOAT8);
INSERT INTO intdecfloat VALUES (1, 2.0, 3, 4, 3.5);

-- Test 27: query (line 226)
SELECT (a + b)::INT FROM intdecfloat;

-- Test 28: query (line 231)
SELECT b > a, e < b FROM intdecfloat;

-- Test 29: query (line 236)
SELECT a, b FROM intdecfloat WHERE a < b;

-- Test 30: query (line 241)
SELECT a+b, a+c, b+c, b+d, c+d FROM intdecfloat;

-- Test 31: query (line 246)
SELECT a-b, a-c, b-c, b-d, c-d FROM intdecfloat;

-- Test 32: query (line 251)
SELECT a*b, a*c, b*c, b*d, c*d FROM intdecfloat;

-- Test 33: query (line 256)
SELECT a/b, a/c, b/c, b/d, c/d FROM intdecfloat;

-- Test 34: statement (line 262)
CREATE table decimals (a DECIMAL, b DECIMAL);
INSERT INTO decimals VALUES(123.0E200, 12.3);

-- Test 35: query (line 266)
SELECT a*b FROM decimals;

-- Test 36: query (line 271)
SELECT a/b FROM decimals;

-- Test 37: query (line 276)
SELECT a+b FROM decimals;

-- Test 38: query (line 281)
SELECT a-b FROM decimals;

-- Test 39: query (line 287)
SELECT a, b, a < 2 AND b > 0 AND a * b != 3, a < 2 AND b < 2 FROM a WHERE a < 2 AND b > 0 AND a * b != 3;

-- Test 40: query (line 293)
SELECT a, b, a < b AND NULL, a > b AND NULL, NULL OR a < b, NULL OR a > b, NULL AND NULL, NULL OR NULL FROM a WHERE a = 0;

-- Test 41: query (line 307)
SELECT sum(a), b FROM b GROUP BY b;

-- Test 42: statement (line 315)
CREATE TABLE c (a INT, b INT, c INT, d INT, PRIMARY KEY (a, c));
CREATE INDEX sec ON c (b);
CREATE TABLE d (a INT, b INT, PRIMARY KEY (b, a));
INSERT INTO c VALUES (1, 1, 1, 0), (2, 1, 2, 0);
INSERT INTO d VALUES (1, 1), (1, 2);

-- Test 43: statement (line 321)
-- CockroachDB-only: statistics injection is not supported in PostgreSQL.
-- ALTER TABLE c INJECT STATISTICS '...';

-- Test 44: query (line 332)
-- CockroachDB-only: EXPLAIN (VEC) table-valued form is not supported in PostgreSQL.
-- SELECT count(*) > 0 FROM [EXPLAIN (VEC) SELECT c.a FROM c JOIN d ON d.b = c.b] WHERE info LIKE '%rowexec.joinReader%';

-- Test 45: query (line 338)
SELECT c.a FROM c JOIN d ON d.b = c.b;

-- Test 46: query (line 345)
SELECT c.d FROM c;

-- Test 47: query (line 353)
SELECT c.d FROM c JOIN d ON d.b = c.b;

-- Test 48: query (line 360)
SELECT
  a_tbl.*,
  row_number() OVER (ORDER BY a_tbl.a, a_tbl.b) AS ordinality
FROM a AS a_tbl
WHERE a_tbl.a > 1
ORDER BY a_tbl.a, a_tbl.b
LIMIT 6;

-- Test 49: query (line 373)
SELECT c.a FROM c INNER JOIN c AS s ON c.b = s.b;

-- Test 50: statement (line 383)
CREATE TABLE e (x TEXT);
INSERT INTO e VALUES ('abc'), ('xyz'), (NULL);

-- Test 51: query (line 387)
SELECT * FROM e WHERE x LIKE '';

-- Test 52: query (line 391)
SELECT * FROM e WHERE x NOT LIKE '' ORDER BY 1;

-- Test 53: query (line 397)
SELECT * FROM e WHERE x LIKE '%' ORDER BY 1;

-- Test 54: query (line 403)
SELECT * FROM e WHERE x NOT LIKE '%';

-- Test 55: query (line 407)
SELECT * FROM e WHERE x LIKE 'ab%';

-- Test 56: query (line 412)
SELECT * FROM e WHERE x NOT LIKE 'ab%';

-- Test 57: query (line 417)
SELECT * FROM e WHERE x LIKE '%bc';

-- Test 58: query (line 422)
SELECT * FROM e WHERE x NOT LIKE '%bc';

-- Test 59: query (line 427)
SELECT * FROM e WHERE x LIKE '%b%';

-- Test 60: query (line 432)
SELECT * FROM e WHERE x NOT LIKE '%b%';

-- Test 61: query (line 437)
SELECT * FROM e WHERE x LIKE 'a%c';

-- Test 62: query (line 442)
SELECT * FROM e WHERE x NOT LIKE 'a%c';

-- Test 63: query (line 447)
SELECT x, x LIKE '%', x NOT LIKE '%', x LIKE 'ab%', x NOT LIKE 'ab%', x LIKE '%bc', x NOT LIKE '%bc', x LIKE '%b%', x NOT LIKE '%b%', x LIKE 'a%c', x NOT LIKE 'a%c' FROM e ORDER BY x;

-- Test 64: statement (line 456)
CREATE TABLE composite (d DECIMAL);
CREATE INDEX d_idx ON composite (d);
INSERT INTO composite VALUES (NULL), (1), (1.0), (1.00);

-- Test 65: query (line 460)
SELECT d FROM composite;

-- Test 66: query (line 468)
SELECT d FROM composite;

-- Test 67: statement (line 476)
-- RESET vectorize

-- Test 68: query (line 480)
SELECT ARRAY(SELECT 1) FROM a LIMIT 1;

-- Test 69: statement (line 489)
CREATE TABLE t38754 (a OID PRIMARY KEY);
INSERT INTO t38754 VALUES (1);

-- Test 70: query (line 493)
SELECT * FROM t38754;

-- Test 71: query (line 499)
SELECT a/b FROM a WHERE b = 2;

-- Test 72: query (line 505)
SELECT b FROM a WHERE b < 0.5;

-- Test 73: statement (line 516)
-- CockroachDB-only: INSPECT TABLE is not supported in PostgreSQL.
-- INSPECT TABLE t38626;

-- Test 74: query (line 524)
-- CockroachDB-only system table.
-- SELECT "hashedPassword" FROM system.users LIMIT 1;

-- Test 75: query (line 529)
-- CockroachDB-only system table.
-- SELECT * FROM system.namespace LIMIT 1;

-- Test 76: statement (line 536)
CREATE TABLE t38753 (x INT PRIMARY KEY, y INT UNIQUE);
INSERT INTO t38753 VALUES (0, NULL);

-- Test 77: query (line 539)
SELECT * FROM t38753 ORDER BY y;

-- Test 78: query (line 545)
SELECT count(*), count(*) + 1, count(*) > 4, count(*) + 1 > 4 FROM b;

-- Test 79: query (line 550)
SELECT * FROM (SELECT count(*) AS x FROM b) WHERE x > 0;

-- Test 80: statement (line 556)
CREATE TABLE t38908 (x INT);
INSERT INTO t38908 VALUES (1);

-- Test 81: query (line 560)
SELECT * FROM t38908 WHERE x IN (1, 2);

-- Test 82: query (line 566)
SELECT 0, 1 + 2, 3 * 4 FROM a HAVING true;

-- Test 83: query (line 576)
SELECT substring(x, 1, y) FROM builtin_test;

-- Test 84: query (line 582)
SELECT substring(x, 1, abs(y)) FROM builtin_test;

-- Test 85: statement (line 589)
-- PostgreSQL errors on negative substring lengths; return empty string instead.
SELECT substring(x, 0, 0) FROM builtin_test;

-- Test 86: query (line 593)
SELECT substring(x, -1::INT2, 3::INT4) FROM builtin_test;

-- Test 87: query (line 599)
SELECT abs(y) FROM builtin_test;

-- Test 88: statement (line 605)
CREATE TABLE extract_test (x DATE);
INSERT INTO extract_test VALUES ('2017-01-01');

-- Test 89: query (line 609)
SELECT EXTRACT(YEAR FROM x) FROM extract_test;

-- Test 90: statement (line 614)
-- RESET vectorize

-- Test 91: statement (line 623)
CREATE TABLE t38937 (_int2) AS SELECT 1::INT2;

-- Test 92: query (line 626)
SELECT sum(_int2) FROM t38937;

-- Test 93: query (line 645)
SELECT * FROM t38959;

-- Test 94: query (line 658)
SELECT min(x) FROM t38959_2 WHERE (y, z) = (2, 3.0);

-- Test 95: statement (line 667)
CREATE TABLE empty (a INT PRIMARY KEY, b FLOAT);

-- Test 96: query (line 671)
SELECT count(*), count(a), sum(a), min(a), max(a), sum(b), avg(b) FROM empty;

-- Test 97: query (line 677)
SELECT count(*), count(a), sum(a), min(a), max(a), sum(b), avg(b) FROM empty GROUP BY a;

-- Test 98: statement (line 682)
CREATE TABLE t_38995 (a INT PRIMARY KEY);
INSERT INTO t_38995 VALUES (1), (2), (3);

-- Test 99: query (line 686)
SELECT
  t_38995.a,
  row_number() OVER (ORDER BY t_38995.a) * 2 AS ordinality_times2
FROM t_38995
ORDER BY t_38995.a;

-- Test 100: query (line 698)
SELECT a FROM t_39827 ORDER BY a LIMIT 2;

-- Test 101: statement (line 710)
SELECT '' FROM t_40227 AS t1 JOIN t_40227 AS t2 ON true;

-- Test 102: statement (line 714)
CREATE TABLE t39417 (x int8);
INSERT INTO t39417 VALUES (10);

-- Test 103: query (line 718)
select x/1 from t39417;

-- Test 104: query (line 733)
SELECT
	tab_426212._decimal - tab_426216._decimal
FROM
	t_39540 AS tab_426212,
	t_39540 AS tab_426214,
	t_39540
	RIGHT JOIN t_39540 AS tab_426216 ON true
ORDER BY
	tab_426214._bool ASC;

-- Test 105: statement (line 747)
CREATE TABLE t40372_1 (
  a INT,
  b INT,
  c FLOAT,
  d FLOAT
);
INSERT INTO t40372_1 VALUES
  (1, 1, 1, 1),
  (2, 2, 2, 2),
  (3, 3, 3, 3);
CREATE TABLE t40372_2 (
  a INT,
  b FLOAT,
  c FLOAT,
  d INT
);
INSERT INTO t40372_2 VALUES
  (1, 1, 1, 1),
  (2, 2, 2, 2),
  (3, 3, 3, 3);

-- Test 106: query (line 769)
SELECT * FROM t40372_1 NATURAL JOIN t40372_2;

-- Test 107: statement (line 777)
CREATE TABLE tnull(a INT, b INT);
INSERT INTO tnull VALUES(NULL, 238);

-- Test 108: query (line 781)
SELECT a FROM tnull WHERE (a<=b OR a>=b);

-- Test 109: statement (line 787)
CREATE TABLE t1(a INTEGER, b INTEGER, c INTEGER);
INSERT INTO t1 VALUES(NULL,2,1);

-- Test 110: query (line 793)
SELECT CASE WHEN a <= b THEN 1 ELSE 2 END
  FROM t1
 WHERE (a > b - 2 AND a < b + 2) OR (c > a AND c < b);

-- Test 111: statement (line 800)
CREATE TABLE t_case_null (x INT);
INSERT INTO t_case_null VALUES (0);

-- Test 112: query (line 804)
SELECT CASE WHEN x = 0 THEN 0 ELSE NULL END FROM t_case_null;

-- Test 113: query (line 809)
SELECT CASE x WHEN 0 THEN 0 ELSE NULL END FROM t_case_null;

-- Test 114: query (line 814)
SELECT CASE WHEN x = 0 THEN NULL ELSE 0 END FROM t_case_null;

-- Test 115: query (line 819)
SELECT CASE x WHEN 0 THEN NULL ELSE 0 END FROM t_case_null;

-- Test 116: query (line 824)
SELECT CASE WHEN x = 1 THEN 1 ELSE NULL END FROM t_case_null;

-- Test 117: query (line 829)
SELECT CASE x WHEN 1 THEN 1 ELSE NULL END FROM t_case_null;

-- Test 118: query (line 834)
SELECT * FROM t_case_null WHERE NULL AND NULL;

-- Test 119: query (line 838)
SELECT * FROM t_case_null WHERE NULL AND x = 0;

-- Test 120: query (line 842)
SELECT * FROM t_case_null WHERE x = 0 AND NULL;

-- Test 121: query (line 863)
SELECT *
FROM (
  SELECT tab_1541._int8 AS col_2976
  FROM t40732 AS tab_1538
  CROSS JOIN t40732 AS tab_1539
  JOIN t40732 AS tab_1540
    ON tab_1539._float8 = tab_1540._float8
   AND tab_1538._float8 = tab_1540._float8
  JOIN t40732 AS tab_1541
    ON tab_1540._int8 = tab_1541._int8,
       t40732 AS tab_1542
  WHERE tab_1542._bool > tab_1540._bool
) AS sub
ORDER BY col_2976;

-- Test 122: query (line 886)
-- CockroachDB-only system table.
-- SELECT feature_name FROM crdb_internal.feature_usage WHERE feature_name='sql.exec.query.is-vectorized' AND usage_count > 0;

-- Test 123: query (line 892)
SELECT a, a IS NULL, a IS NOT NULL, b, b IS NOT DISTINCT FROM NULL, b IS DISTINCT FROM NULL FROM nulls;

-- Test 124: query (line 901)
SELECT a, b FROM nulls WHERE a IS NULL;

-- Test 125: query (line 907)
SELECT a, b FROM nulls WHERE a IS NOT NULL;

-- Test 126: query (line 913)
SELECT a, b FROM nulls WHERE a IS NOT DISTINCT FROM NULL;

-- Test 127: query (line 919)
SELECT a, b FROM nulls WHERE a IS DISTINCT FROM NULL;

-- Test 128: query (line 925)
SELECT
	a,
	b,
	CASE
	WHEN a IS NOT NULL AND b IS NULL THEN 0
	WHEN a IS NULL THEN 1
	WHEN b IS NOT NULL THEN 2
	END
FROM
	nulls;

-- Test 129: query (line 949)
SELECT * FROM t_42816 ORDER BY a OFFSET 1020 LIMIT 10;

-- Test 130: statement (line 960)
CREATE TABLE t42994 (a INT PRIMARY KEY, b BIT);
CREATE INDEX t42994_i ON t42994 (a, b);
INSERT INTO t42994 VALUES (1, 1::BIT);

-- Test 131: query (line 964)
SELECT a FROM t42994;

-- Test 132: statement (line 969)
CREATE TABLE t42994_2 (a BIT PRIMARY KEY, b INT UNIQUE);
INSERT INTO t42994_2 VALUES (1::BIT, NULL);

-- Test 133: query (line 973)
SELECT b FROM t42994_2;

-- Test 134: query (line 983)
SELECT max(s) FROM t43429 GROUP BY i ORDER BY 1;

-- Test 135: statement (line 989)
CREATE TABLE t43550(a INT2 PRIMARY KEY); INSERT INTO t43550 VALUES (1);

-- Test 136: query (line 992)
SELECT CASE WHEN a = 0 THEN a ELSE 1::INT8 END FROM t43550;

-- Test 137: query (line 997)
SELECT CASE a WHEN 0 THEN a ELSE 1::INT8 END FROM t43550;

-- Test 138: statement (line 1003)
CREATE TABLE t43855(o OID, r REGPROCEDURE);

-- Test 139: query (line 1006)
SELECT CASE WHEN o = 0 THEN 0::OID ELSE r END FROM t43855;

-- Test 140: query (line 1010)
SELECT CASE o WHEN 0 THEN 0::OID ELSE r END FROM t43855;

-- Test 141: query (line 1016)
SELECT max(c) FROM a;

-- Test 142: statement (line 1025)
SELECT * FROM t44133_0, t44133_1 WHERE t44133_0.c0 NOT BETWEEN t44133_1.c0 AND '' AND (t44133_1.c0 IS NULL);

-- Test 143: statement (line 1029)
CREATE TABLE t44304(c0 INT); INSERT INTO t44304 VALUES (0);

-- Test 144: query (line 1032)
SELECT * FROM t44304 WHERE (CASE WHEN t44304.c0 > 0 THEN NULL::BOOL END);

-- Test 145: query (line 1040)
SELECT * FROM t44624 ORDER BY CASE WHEN c1 IS NULL THEN c0 WHEN true THEN c0 END;

-- Test 146: statement (line 1047)
CREATE TABLE t44726(c0 INT); INSERT INTO t44726(c0) VALUES (0);

-- Test 147: query (line 1050)
SELECT * FROM t44726 WHERE 0 > t44726.c0;

-- Test 148: statement (line 1056)
-- PostgreSQL does not define min/max over BYTEA directly; compare via hex text.
CREATE TABLE t44822(c0 BYTEA); CREATE VIEW v0(c0) AS SELECT min(encode(t44822.c0, 'hex')) FROM t44822;

-- Test 149: query (line 1059)
SELECT * FROM v0 WHERE v0.c0 NOT BETWEEN v0.c0 AND v0.c0;

-- Test 150: statement (line 1065)
CREATE TABLE t44935 (x decimal); INSERT INTO t44935 VALUES (1.0), (1.00);

-- Test 151: query (line 1068)
SELECT count(*) FROM (SELECT DISTINCT x FROM t44935);

-- Test 152: query (line 1084)
SELECT b, d, e, f, g, sum(a) FROM t45481 GROUP BY b, d, e, f, g ORDER BY b, d, e, f, g;

-- Test 153: statement (line 1138)
CREATE TABLE mixed_type_a (a INT, b TIMESTAMPTZ);
CREATE TABLE mixed_type_b (a INT, b INTERVAL, c TIMESTAMP);
INSERT INTO mixed_type_a VALUES (0, 'epoch'::TIMESTAMPTZ);
INSERT INTO mixed_type_b VALUES (0, INTERVAL '0 days', 'epoch'::TIMESTAMP);

-- Test 154: query (line 1144)
SELECT b > now() - interval '1 day'  FROM mixed_type_a;

-- Test 155: statement (line 1149)
SELECT * FROM mixed_type_a AS a INNER JOIN mixed_type_b AS b ON a.a = b.a AND a.b < (now() - b.b);

-- Test 156: statement (line 1152)
SELECT * FROM mixed_type_a AS a JOIN mixed_type_b AS b ON a.a = b.a AND a.b < (now() - b.b);

-- Test 157: statement (line 1156)
CREATE TABLE t46183 (x INT PRIMARY KEY, y JSONB);
CREATE INDEX t46183_y_gin_idx ON t46183 USING gin (y);
INSERT INTO t46183 VALUES (1, '{"y": "hello"}');

-- Test 158: query (line 1160)
SELECT count(*) FROM t46183 WHERE y->'y' = to_jsonb('hello'::text);

-- Test 159: statement (line 1167)
CREATE TABLE t47715 (c0 DECIMAL PRIMARY KEY, c1 INT UNIQUE);
INSERT INTO t47715(c0) VALUES (1819487610);

-- Test 160: query (line 1171)
SELECT c0 FROM t47715 ORDER by c1;

-- Test 161: statement (line 1177)
CREATE TABLE mvcc (x INT PRIMARY KEY, y INT, z INT);
CREATE INDEX mvcc_i ON mvcc (z);
INSERT INTO mvcc VALUES (1, 2, 3);

-- Test 162: query (line 1181)
SELECT xmin IS NOT NULL FROM mvcc;

-- Test 163: query (line 1186)
SELECT xmin IS NOT NULL FROM mvcc;

-- Test 164: statement (line 1191)
-- RESET vectorize

-- Test 165: statement (line 1201)
CREATE TABLE t51841 (a) AS SELECT gen_random_uuid();

-- Test 166: statement (line 1204)
SELECT random() from t51841;

-- Test 167: statement (line 1214)
CREATE TYPE greeting AS ENUM ('hello');
CREATE TABLE greeting_table (x greeting);
EXPLAIN SELECT * FROM greeting_table;

-- Test 168: query (line 1232)
SELECT CASE WHEN _bool THEN _string ELSE _string END FROM t64793;

-- Test 169: statement (line 1244)
CREATE TABLE t67793 (_float4 FLOAT4, _float8 FLOAT8);
INSERT INTO t67793 VALUES (1, 2), (2, 1);

-- Test 170: query (line 1248)
SELECT t1._float8, t2._float4 FROM t67793 AS t1, t67793 AS t2 WHERE t1._float4 = t2._float8;

-- Test 171: query (line 1254)
SELECT _float4::FLOAT8, _float8::FLOAT4 FROM t67793;

-- Test 172: statement (line 1271)
INSERT INTO t66706 VALUES
  (NULL, 'bar'),
  (NULL, 'bar');

-- Test 173: query (line 1276)
SELECT b FROM t66706 WHERE NOT (b = 'foo');

-- Test 174: statement (line 1282)
-- RESET vectorize

-- Test 175: query (line 1293)
SELECT c FROM t68040 WHERE c LIKE '%\\%';

-- Test 176: statement (line 1307)
CREATE TABLE t68979 (
  a INT
);

-- Test 177: statement (line 1312)
INSERT INTO t68979 VALUES (0);

-- Test 178: query (line 1315)
SELECT 'b' IN ('b', (SELECT NULL FROM t68979), 'a') FROM t68979;

-- Test 179: statement (line 1320)
CREATE TABLE t63792 (c INT);
INSERT INTO t63792 VALUES (NULL), (1), (2);

-- Test 180: query (line 1324)
SELECT c, c = c FROM t63792;

-- Test 181: statement (line 1332)
CREATE TABLE ints (_int2 INT2, _int4 INT4, _int8 INT8);
INSERT INTO ints VALUES (1, 1, 1), (2, 2, 2);

-- Test 182: query (line 1336)
SELECT pg_typeof(_int2 - _int2) FROM ints LIMIT 1;

-- Test 183: query (line 1341)
SELECT _int2 * _int2 FROM ints WHERE _int4 + _int4 = _int8 + 2;

-- Test 184: statement (line 1346)
-- RESET vectorize

-- Test 185: statement (line 1353)
CREATE TABLE t152771 (i INT);

-- Test 186: statement (line 1356)
INSERT INTO t152771 VALUES (0);

-- Test 187: statement (line 1359)
SET plan_cache_mode = force_generic_plan;

-- Test 188: statement (line 1362)
PREPARE p(INT, INT, INT, INT) AS UPDATE t152771 SET i=($1-$2)+($3-$4);

-- Test 189: statement (line 1365)
EXECUTE p(NULL, 3, 33, NULL);

-- Test 190: statement (line 1368)
DEALLOCATE p;

-- Test 191: statement (line 1371)
RESET plan_cache_mode;
