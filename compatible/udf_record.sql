-- PostgreSQL compatible tests from udf_record
-- 127 tests

SET client_min_messages = warning;

-- Test 1: statement (line 1)
CREATE TABLE t (a INT PRIMARY KEY, b INT);
INSERT INTO t VALUES (1, 5), (2, 6), (3, 7);

-- Capture the runner-created database name so we can connect back after hopping DBs.
SELECT current_database() AS orig_db \gset

-- Test 2: statement (line 5)
CREATE FUNCTION f_one() RETURNS RECORD AS
$$
  SELECT 1;
$$ LANGUAGE SQL;

-- Test 3: query (line 11)
SELECT f_one();

-- Test 4: statement (line 16)
\set ON_ERROR_STOP 0
SELECT * FROM f_one();
\set ON_ERROR_STOP 1

-- Test 5: query (line 19)
SELECT * FROM f_one() AS foo (a INT);

-- Test 6: statement (line 24)
CREATE FUNCTION f_const() RETURNS RECORD AS
$$
  SELECT 1, 2.0, 'welcome roacher', '2021-07-12 09:02:10-08:00'::TIMESTAMPTZ;
$$ LANGUAGE SQL;

-- Test 7: query (line 30)
SELECT f_const();

-- Test 8: statement (line 35)
CREATE FUNCTION f_arr() RETURNS RECORD STABLE AS
$$
  SELECT ARRAY[1, 2, 3];
$$ LANGUAGE SQL;

-- Test 9: query (line 41)
SELECT f_arr();

-- Test 10: statement (line 46)
CREATE FUNCTION f_tuple() RETURNS RECORD AS
$$
  SELECT (4, 5, (6, 7, 8));
$$ LANGUAGE SQL;

-- Test 11: query (line 52)
SELECT f_tuple();

-- Test 12: statement (line 57)
CREATE FUNCTION f_multituple() RETURNS RECORD AS
$$
  SELECT (1, 2), (3, 4);
$$ LANGUAGE SQL;

-- Test 13: query (line 63)
SELECT f_multituple();

-- Test 14: statement (line 68)
CREATE FUNCTION f_table() RETURNS RECORD AS
$$
  SELECT * FROM t ORDER BY a LIMIT 1;
$$ LANGUAGE SQL;

-- Test 15: query (line 74)
SELECT pg_get_functiondef('f_table'::regproc::oid);

-- Test 16: query (line 88)
SELECT f_table();

-- Test 17: statement (line 93)
CREATE FUNCTION f_multitable() RETURNS RECORD STABLE AS
$$
  SELECT t1.*, t2.* FROM t as t1 JOIN t as t2 on t1.a = t2.a ORDER BY t1.a LIMIT 1;
$$ LANGUAGE SQL;

-- Test 18: query (line 99)
SELECT f_multitable();

-- Test 19: statement (line 104)
CREATE FUNCTION f_setof() RETURNS SETOF RECORD AS
$$
  SELECT a, b FROM t
$$ LANGUAGE SQL;

-- Test 20: query (line 110)
SELECT f_setof();

-- Test 21: statement (line 117)
CREATE FUNCTION f_row() RETURNS RECORD IMMUTABLE LEAKPROOF LANGUAGE SQL AS 'SELECT ROW(1.1)';

-- Test 22: query (line 120)
SELECT f_row();

-- Test 23: statement (line 125)
ALTER TABLE t ADD COLUMN c INT DEFAULT 0;

-- Test 24: query (line 128)
SELECT f_table();

-- Test 25: statement (line 136)
DROP DATABASE IF EXISTS "interesting⨄DbName";
CREATE DATABASE "interesting⨄DbName";
\set QUIET on
\c "interesting⨄DbName"
\set QUIET off
CREATE TABLE t1 (c1 int);

-- Test 26: statement (line 141)
CREATE FUNCTION f() RETURNS INT VOLATILE LANGUAGE SQL AS
$$
  SELECT * FROM t1;
$$;

-- Test 27: query (line 147)
SELECT pg_get_functiondef('f'::regproc::oid);

-- Test 28: statement (line 162)
\set QUIET on
\c :orig_db
\set QUIET off
DROP DATABASE "interesting⨄DbName";

-- Test 29: statement (line 169)
CREATE FUNCTION f_tup() RETURNS RECORD AS
$$
  SELECT ROW(1, 2, 3);
$$ LANGUAGE SQL;

-- Test 30: query (line 175)
SELECT f_tup();

-- Test 31: statement (line 180)
\set ON_ERROR_STOP 0
SELECT * FROM f_tup();
\set ON_ERROR_STOP 1

-- Test 32: query (line 183)
SELECT * FROM f_tup() as foo(a int, b int, c int);

-- Test 33: statement (line 189)
CREATE FUNCTION f_col() RETURNS RECORD AS
$$
  SELECT 1, 2, 3;
$$ LANGUAGE SQL;

-- Test 34: query (line 195)
SELECT f_col();

-- Test 35: query (line 200)
SELECT * FROM f_col() as foo(a int, b int, c int);

-- Test 36: query (line 206)
SELECT * FROM (VALUES (f_col())) as foo;

-- Test 37: statement (line 211)
CREATE TABLE t_imp (a INT PRIMARY KEY, b INT);
INSERT INTO t_imp VALUES (1, 10), (2, 4), (3, 32);

-- Test 38: statement (line 215)
CREATE FUNCTION f_imp() RETURNS t_imp AS
$$
  SELECT * FROM t_imp ORDER BY a LIMIT 1;
$$ LANGUAGE SQL;

-- Test 39: query (line 221)
SELECT * FROM f_imp();

-- Test 40: statement (line 227)
CREATE TYPE udt AS ENUM ('a', 'b', 'c');

-- Test 41: statement (line 230)
CREATE FUNCTION f_udt() RETURNS udt AS
$$
  SELECT 'a'::udt;
$$ LANGUAGE SQL;

-- Test 42: query (line 236)
SELECT * FROM f_udt();

-- Test 43: statement (line 241)
CREATE FUNCTION f_udt_record() RETURNS RECORD AS
$$
  SELECT 'a'::udt;
$$ LANGUAGE SQL;

-- Test 44: query (line 247)
SELECT * FROM f_udt();

-- Test 45: query (line 252)
SELECT * FROM f_setof() AS foo(a INT, b INT);

-- Test 46: statement (line 259)
CREATE FUNCTION f_setof_imp() RETURNS SETOF t_imp STABLE AS
$$
  SELECT * FROM t_imp;
$$ LANGUAGE SQL;

-- Test 47: query (line 265)
SELECT * FROM f_setof_imp();

-- Test 48: statement (line 272)
CREATE FUNCTION f_strict() RETURNS RECORD STRICT AS
$$
  SELECT 1, 2, 3;
$$ LANGUAGE SQL;

-- Test 49: query (line 278)
SELECT * FROM f_strict() AS foo(a INT, b INT, c INT);

-- Test 50: statement (line 283)
CREATE FUNCTION f_setof_strict() RETURNS SETOF RECORD STRICT STABLE AS
$$
  SELECT * FROM t_imp;
$$ LANGUAGE SQL;

-- Test 51: query (line 289)
SELECT * FROM f_setof_strict() AS foo(a INT, b INT);

-- Test 52: statement (line 296)
CREATE FUNCTION f_strict_arg(IN a INT, IN b INT) RETURNS RECORD STRICT STABLE AS
$$
  SELECT a, b;
$$ LANGUAGE SQL;

-- Test 53: query (line 302)
SELECT * FROM f_strict_arg(1,2) AS foo(a INT, b INT);

-- Test 54: query (line 308)
SELECT * FROM f_strict_arg(NULL, 2) AS foo(a INT, b INT);

-- Test 55: query (line 314)
SELECT * FROM (SELECT f_strict_arg(1, 2));

-- Test 56: statement (line 319)
CREATE FUNCTION f_strict_arg_setof(IN a INT, IN b INT) RETURNS SETOF RECORD STRICT AS
$$
  SELECT a, b FROM generate_series(1,3);
$$ LANGUAGE SQL;

-- Test 57: query (line 325)
SELECT * FROM f_strict_arg_setof(1,2) AS foo(a INT, b INT);

-- Test 58: query (line 334)
SELECT * FROM f_strict_arg_setof(NULL,2) AS foo(a INT, b INT);

-- Test 59: statement (line 339)
CREATE TABLE n (a INT PRIMARY KEY, b INT);
INSERT INTO n VALUES (1, 5), (2, NULL);

-- Test 60: query (line 343)
WITH narg AS (SELECT b AS input FROM n WHERE a = 2) SELECT * FROM narg, f_strict_arg(narg.input, 2) AS foo(a INT, b INT);

-- Test 61: query (line 349)
WITH narg AS (SELECT b AS input FROM n WHERE a = 2) SELECT * FROM narg, f_strict_arg_SETOF(narg.input, 2) AS foo(a INT, b INT);

-- Test 62: statement (line 354)
CREATE FUNCTION f_arg(IN a INT8, IN b INT8) RETURNS RECORD AS
$$
  SELECT a, b;
$$ LANGUAGE SQL;

-- Test 63: query (line 360)
SELECT * FROM f_arg(1,2) AS foo(a INT, b INT);

-- Test 64: statement (line 371)
CREATE FUNCTION f_amb_setof(a INT8, b INT8) RETURNS SETOF RECORD STRICT AS
$$
  SELECT a, b;
$$ LANGUAGE SQL;

-- Test 65: statement (line 384)
SELECT f_amb_setof(1, NULL);

-- Test 66: statement (line 387)
SELECT * FROM f_amb_setof(1, NULL) as foo(a int, b int);

-- Test 67: statement (line 390)
CREATE FUNCTION f_amb(a INT, b INT) RETURNS RECORD STRICT AS
$$
  SELECT a, b;
$$ LANGUAGE SQL;

-- Test 68: statement (line 403)
SELECT f_amb(1, NULL);

-- Test 69: statement (line 408)
SELECT * FROM f_amb(1, NULL) as foo(a int, b int);

-- Test 70: statement (line 415)
CREATE OR REPLACE FUNCTION f_102718()
	RETURNS RECORD
	IMMUTABLE
	LANGUAGE SQL
	AS $$
SELECT ROW('a')
$$;

-- Test 71: query (line 424)
SELECT
	*
FROM
	(VALUES (f_102718())) AS t1 (a),
	(VALUES ('foo'), ('bar')) AS t2 (b)
ORDER BY
	t1.a DESC NULLS FIRST;

-- Test 72: statement (line 441)
CREATE TABLE imp(k INT PRIMARY KEY, a INT, b TEXT);
INSERT INTO imp VALUES (1, 2, 'a');

-- Test 73: statement (line 445)
CREATE FUNCTION imp_const_tup() RETURNS imp LANGUAGE SQL AS $$
  SELECT (11, 22, 'b')
$$;

-- Test 74: query (line 450)
SELECT imp_const_tup(), (11,22,'b')::imp = imp_const_tup(), pg_typeof(imp_const_tup());

-- Test 75: statement (line 455)
CREATE FUNCTION imp_const_cast() RETURNS imp LANGUAGE SQL AS $$
  SELECT (11, 22, 'b')::imp
$$;

-- Test 76: query (line 460)
SELECT imp_const_cast(), (11,22,'b')::imp = imp_const_cast(), pg_typeof(imp_const_cast());

-- Test 77: statement (line 465)
CREATE FUNCTION imp_const() RETURNS imp LANGUAGE SQL AS $$
  SELECT 11 AS k, 22 AS a, 'b' AS b
$$;

-- Test 78: query (line 470)
SELECT imp_const(), (11,22,'b')::imp = imp_const(), pg_typeof(imp_const());

-- Test 79: statement (line 475)
CREATE FUNCTION imp_const_unnamed() RETURNS imp LANGUAGE SQL AS $$
  SELECT 11, 22, 'b'
$$;

-- Test 80: query (line 480)
SELECT imp_const_unnamed(), (11,22,'b')::imp = imp_const_unnamed(), pg_typeof(imp_const_unnamed());

-- Test 81: statement (line 485)
CREATE FUNCTION imp_tup() RETURNS imp LANGUAGE SQL AS $$
  SELECT (k, a, b) FROM imp
$$;

-- Test 82: query (line 492)
SELECT imp_tup(), (1,2,'a')::imp = imp_tup();

-- Test 83: statement (line 497)
CREATE FUNCTION imp() RETURNS imp LANGUAGE SQL AS $$
  SELECT k, a, b FROM imp
$$;

-- Test 84: query (line 504)
SELECT imp(), (1,2,'a')::imp = imp();

-- Test 85: statement (line 509)
CREATE FUNCTION imp_star() RETURNS imp LANGUAGE SQL AS $$
  SELECT * FROM imp
$$;

-- Test 86: query (line 516)
SELECT imp_star(), (1,2,'a')::imp = imp_star();

-- Test 87: statement (line 521)
INSERT INTO imp VALUES (100, 200, 'z');

-- Test 88: statement (line 524)
CREATE FUNCTION imp_tup_ordered() RETURNS imp LANGUAGE SQL AS $$
  SELECT (k, a, b) FROM imp ORDER BY b DESC
$$;

-- Test 89: query (line 531)
SELECT imp_tup_ordered(), (100,200,'z')::imp = imp_tup_ordered();

-- Test 90: statement (line 536)
CREATE FUNCTION imp_ordered() RETURNS imp LANGUAGE SQL AS $$
  SELECT k, a, b FROM imp ORDER BY b DESC
$$;

-- Test 91: query (line 543)
SELECT imp_ordered(), (100,200,'z')::imp = imp_ordered();

-- Test 92: statement (line 548)
CREATE FUNCTION imp_identity(i imp) RETURNS imp LANGUAGE SQL AS $$
  SELECT i
$$;

-- Test 93: query (line 553)
SELECT imp_identity((1,2,'a')), imp_identity((1,2,'a')::imp);

-- Test 94: statement (line 558)
CREATE FUNCTION imp_a(i imp) RETURNS INT LANGUAGE SQL AS $$
  SELECT (i).a
$$;

-- Test 95: query (line 563)
SELECT imp_a((1,2,'a')), imp_a((1,2,'a')::imp);

-- Test 96: statement (line 568)
CREATE FUNCTION imp_cast() RETURNS imp LANGUAGE SQL AS $$
  SELECT (1, 2, 3)
$$;

-- Test 97: query (line 573)
SELECT imp_cast(), (1,2,'3')::imp = imp_cast(), pg_typeof(imp_cast());

-- Test 98: statement (line 580)
\set ON_ERROR_STOP 0
CREATE FUNCTION err() RETURNS imp LANGUAGE SQL AS $$
  SELECT (1, 2)
$$;

-- Test 99: statement (line 585)
CREATE FUNCTION err() RETURNS imp LANGUAGE SQL AS $$
  SELECT k, a FROM imp
$$;

-- Test 100: statement (line 592)
CREATE FUNCTION err() RETURNS imp LANGUAGE SQL AS $$
  SELECT k, a, b::INT FROM imp
$$;

-- Test 101: statement (line 597)
CREATE FUNCTION err(i imp) RETURNS INT LANGUAGE SQL AS $$
  SELECT i
$$;
\set ON_ERROR_STOP 1

-- Test 102: statement (line 605)
CREATE TYPE foo_typ AS (x INT, y INT);
CREATE TYPE bar_typ AS (x INT, y INT);

-- Test 103: statement (line 610)
CREATE FUNCTION f() RETURNS foo_typ LANGUAGE SQL AS $$ SELECT ROW(1, 2); $$;

-- Test 104: statement (line 613)
\set ON_ERROR_STOP 0
SELECT * FROM f() AS g(bar bar_typ);
\set ON_ERROR_STOP 1

-- Test 105: statement (line 617)
DROP FUNCTION f;

-- Test 106: statement (line 620)
CREATE FUNCTION f() RETURNS INT LANGUAGE SQL AS $$ SELECT 1; $$;

-- Test 107: statement (line 623)
\set ON_ERROR_STOP 0
SELECT * FROM f() AS g(bar FLOAT);
\set ON_ERROR_STOP 1

-- Test 108: statement (line 627)
DROP FUNCTION f;

-- Test 109: statement (line 630)
CREATE FUNCTION f(OUT x INT, OUT y INT) RETURNS RECORD LANGUAGE SQL AS $$ SELECT ROW(1, 2); $$;

-- Test 110: statement (line 633)
\set ON_ERROR_STOP 0
SELECT * FROM f() AS g(bar bar_typ);
\set ON_ERROR_STOP 1

-- Test 111: statement (line 638)
DROP FUNCTION f;

-- Test 112: statement (line 641)
CREATE FUNCTION f() RETURNS RECORD LANGUAGE SQL AS $$ SELECT ROW(1, 2); $$;

-- Test 113: statement (line 644)
\set ON_ERROR_STOP 0
SELECT * FROM f() AS g(bar INT);

-- Test 114: statement (line 647)
SELECT * FROM f() AS g(foo INT, bar INT, baz INT);
\set ON_ERROR_STOP 1

-- Test 115: statement (line 651)
DROP FUNCTION f;

-- Test 116: statement (line 654)
CREATE FUNCTION f() RETURNS RECORD LANGUAGE SQL AS $$ SELECT ROW(1, 2); $$;

-- Test 117: statement (line 657)
\set ON_ERROR_STOP 0
SELECT * FROM f();

-- Test 118: statement (line 661)
SELECT * FROM f() AS g(bar, baz);
\set ON_ERROR_STOP 1

-- Test 119: statement (line 666)
DROP FUNCTION f;

-- Test 120: statement (line 669)
CREATE FUNCTION f() RETURNS RECORD LANGUAGE SQL AS $$ SELECT True; $$;

-- Test 121: statement (line 672)
\set ON_ERROR_STOP 0
SELECT * FROM f() AS g(bar INT);
\set ON_ERROR_STOP 1

-- Test 122: statement (line 679)
CREATE FUNCTION f113186() RETURNS RECORD LANGUAGE SQL AS $$ SELECT 1.99; $$;

-- Test 123: query (line 682)
SELECT * FROM f113186() AS foo(x FLOAT);

-- Test 124: query (line 688)
SELECT * FROM f113186() AS foo(x INT);

-- Test 125: statement (line 694)
\set ON_ERROR_STOP 0
SELECT * FROM f113186() AS foo(x TIMESTAMP);
\set ON_ERROR_STOP 1

-- Test 126: statement (line 701)
CREATE FUNCTION array_to_set(ANYARRAY) RETURNS SETOF RECORD AS $$
  SELECT i AS "index", $1[i] AS "value" FROM generate_subscripts($1, 1) i;
$$ LANGUAGE SQL STRICT IMMUTABLE;

-- Test 127: query (line 706)
SELECT * FROM array_to_set(ARRAY['one', 'two']) AS t(f1 NUMERIC(4,2), f2 TEXT);
