-- PostgreSQL compatible tests from udf_regressions
-- 101 tests

-- Test 1: statement (line 6)
CREATE FUNCTION f93083() RETURNS INT LANGUAGE SQL AS '';

-- Test 2: query (line 9)
SELECT f93083()

-- Test 3: statement (line 19)
CREATE TYPE e_93314 AS ENUM ('a', 'b');
CREATE TABLE t_93314 (i INT, e e_93314);
INSERT INTO t_93314 VALUES (1, 'a');

-- Test 4: statement (line 24)
CREATE OR REPLACE FUNCTION f_93314 () RETURNS t_93314 AS
$$
  SELECT i, e
  FROM t_93314
  ORDER BY i
  LIMIT 1;
$$ LANGUAGE SQL;

-- Test 5: query (line 33)
SELECT f_93314();

-- Test 6: statement (line 38)
CREATE TABLE t_93314_alias (i INT, e _e_93314);
INSERT INTO t_93314_alias VALUES (1, ARRAY['a', 'b']::_e_93314);

-- Test 7: statement (line 42)
CREATE OR REPLACE FUNCTION f_93314_alias () RETURNS t_93314_alias AS
$$
  SELECT i, e
  FROM t_93314_alias
  ORDER BY i
  LIMIT 1;
$$ LANGUAGE SQL;

-- Test 8: query (line 51)
SELECT f_93314_alias();

-- Test 9: statement (line 56)
CREATE TYPE comp_93314 AS (a INT, b INT);
CREATE TABLE t_93314_comp (a INT, c comp_93314, FAMILY (a, c));

-- Test 10: statement (line 60)
INSERT INTO t_93314_comp VALUES (1, (2,3));

-- Test 11: statement (line 63)
CREATE FUNCTION f_93314_comp() RETURNS comp_93314 AS
$$
  SELECT (1, 2);
$$ LANGUAGE SQL;

-- Test 12: query (line 69)
SELECT f_93314_comp()

-- Test 13: statement (line 74)
CREATE FUNCTION f_93314_comp_t() RETURNS t_93314_comp AS
$$
  SELECT a, c FROM t_93314_comp LIMIT 1;
$$ LANGUAGE SQL;

-- Test 14: query (line 80)
SELECT f_93314_comp_t()

-- Test 15: query (line 85)
SELECT oid, proname, pronamespace, proowner, prolang, proleakproof, proisstrict, proretset, provolatile, pronargs, prorettype, proargtypes, proargmodes, proargnames, prosrc
FROM pg_catalog.pg_proc WHERE proname IN ('f_93314', 'f_93314_alias', 'f_93314_comp', 'f_93314_comp_t')
ORDER BY oid;

-- Test 16: statement (line 97)
CREATE FUNCTION f95240(i INT) RETURNS INT STRICT LANGUAGE SQL AS 'SELECT 33';
CREATE TABLE t95240 (a INT);
INSERT INTO t95240 VALUES (1), (NULL)

-- Test 17: query (line 102)
SELECT f95240(a) FROM t95240

-- Test 18: query (line 109)
EXPLAIN CREATE FUNCTION f() RETURNS INT LANGUAGE SQL AS 'SELECT 1'

-- Test 19: statement (line 118)
CREATE FUNCTION f96326() RETURNS INT LANGUAGE SQL IMMUTABLE STRICT AS 'SELECT 1';

-- Test 20: query (line 121)
SELECT f96326();

-- Test 21: statement (line 130)
CREATE FUNCTION f_95364() RETURNS INT LANGUAGE SQL AS $$ SELECT 1 $$;

let $dropped_fn_id
SELECT function_id FROM crdb_internal.create_function_statements WHERE function_name = 'f_95364';

-- Test 22: query (line 136)
SELECT count(descriptor) FROM system.descriptor WHERE id = $dropped_fn_id;

-- Test 23: statement (line 141)
DROP FUNCTION f_95364;

-- Test 24: query (line 144)
SELECT count(descriptor) FROM system.descriptor WHERE id = $dropped_fn_id;

-- Test 25: statement (line 149)
CREATE DATABASE db_95364;

-- Test 26: statement (line 152)
USE db_95364;

-- Test 27: statement (line 155)
CREATE FUNCTION f_95364_2() RETURNS INT LANGUAGE SQL AS $$ SELECT 1 $$;

let $dropped_fn_id
SELECT function_id FROM crdb_internal.create_function_statements WHERE function_name = 'f_95364_2';

-- Test 28: query (line 161)
SELECT count(descriptor) FROM system.descriptor WHERE id = $dropped_fn_id;

-- Test 29: statement (line 166)
USE test;

-- Test 30: statement (line 169)
DROP DATABASE db_95364 CASCADE;

-- Test 31: query (line 172)
SELECT count(descriptor) FROM system.descriptor WHERE id = $dropped_fn_id;

-- Test 32: statement (line 177)
USE test;

-- Test 33: statement (line 180)
CREATE SCHEMA sc_95364;

-- Test 34: statement (line 183)
CREATE FUNCTION sc_95364.f_95364_3() RETURNS INT LANGUAGE SQL AS $$ SELECT 1 $$;

let $dropped_fn_id
SELECT function_id FROM crdb_internal.create_function_statements WHERE function_name = 'f_95364_3';

-- Test 35: query (line 189)
SELECT count(descriptor) FROM system.descriptor WHERE id = $dropped_fn_id;

-- Test 36: statement (line 194)
DROP SCHEMA sc_95364 CASCADE;

-- Test 37: query (line 197)
SELECT count(descriptor) FROM system.descriptor WHERE id = $dropped_fn_id;

-- Test 38: statement (line 208)
CREATE FUNCTION f_94146(i INT2) RETURNS INT STRICT LANGUAGE SQL AS 'SELECT 2';
CREATE FUNCTION f_94146(i INT4) RETURNS INT STRICT LANGUAGE SQL AS 'SELECT 4';
CREATE FUNCTION f_94146(i INT8) RETURNS INT STRICT LANGUAGE SQL AS 'SELECT 8';

-- Test 39: query (line 213)
SELECT f_94146(1::INT8)

-- Test 40: query (line 218)
SELECT f_94146(1::INT4)

-- Test 41: query (line 223)
SELECT f_94146(1::INT2)

-- Test 42: statement (line 232)
CREATE FUNCTION f_97130() RETURNS INT LANGUAGE SQL AS $$ SELECT 1 $$;

let $pre_search_path
SHOW search_path

-- Test 43: statement (line 238)
SET search_path = public,public

-- Test 44: statement (line 241)
SELECT f_97130();

-- Test 45: statement (line 244)
SET search_path = $pre_search_path

-- Test 46: statement (line 252)
CREATE FUNCTION abs(val INT) RETURNS INT
CALLED ON NULL INPUT
LANGUAGE SQL
AS $$ SELECT val+100 $$;

-- Test 47: query (line 258)
SELECT abs(-1)

-- Test 48: query (line 263)
SELECT public.abs(-1)

-- Test 49: statement (line 273)
CREATE FUNCTION f_97854 (i INT) RETURNS CHAR LANGUAGE SQL AS $$ SELECT 'i' $$;
CREATE FUNCTION f_97854 (f FLOAT) RETURNS CHAR LANGUAGE SQL AS $$ SELECT 'f' $$;

-- Test 50: statement (line 278)
SELECT f_97854(1.0)

-- Test 51: statement (line 287)
CREATE TABLE t93861(x INT);
INSERT INTO t93861 VALUES (1), (2), (NULL);
CREATE FUNCTION f93861_scalar (i INT) RETURNS INT CALLED ON NULL INPUT
  LANGUAGE SQL AS $$ SELECT 1 $$;
CREATE FUNCTION f93861_strict_scalar (i INT) RETURNS INT STRICT
  LANGUAGE SQL AS $$ SELECT 1 $$;
CREATE FUNCTION f93861_setof (i INT) RETURNS SETOF INT CALLED ON NULL INPUT
  LANGUAGE SQL AS $$ SELECT * FROM generate_series(1, 3) $$;
CREATE FUNCTION f93861_strict_setof (i INT) RETURNS SETOF INT STRICT
  LANGUAGE SQL AS $$ SELECT * FROM generate_series(1, 3) $$;

-- Test 52: query (line 299)
SELECT x, f93861_scalar(x), f93861_strict_scalar(x) FROM t93861;

-- Test 53: query (line 306)
SELECT x, f93861_setof(x) FROM t93861;

-- Test 54: query (line 319)
SELECT x, f93861_strict_setof(x) FROM t93861;

-- Test 55: statement (line 335)
CREATE FUNCTION fn(a INT) RETURNS INT LANGUAGE SQL AS 'SELECT a';

-- Test 56: query (line 338)
SELECT fn(1);

-- Test 57: statement (line 343)
DROP FUNCTION fn;

-- Test 58: statement (line 346)
SELECT fn(1);

-- Test 59: statement (line 355)
CREATE FUNCTION fn(a INT) RETURNS INT LANGUAGE SQL AS 'SELECT a';

-- Test 60: query (line 358)
SELECT fn(1);

-- Test 61: statement (line 363)
CREATE DATABASE d;
USE d;

-- Test 62: statement (line 367)
SELECT fn(1);

-- Test 63: statement (line 370)
USE test;

-- Test 64: statement (line 373)
DROP DATABASE d CASCADE;
DROP FUNCTION fn;

-- Test 65: statement (line 378)
CREATE FUNCTION f100923() RETURNS BOOL STABLE LANGUAGE SQL AS ''

-- Test 66: query (line 381)
SELECT f100923() FROM (VALUES (10), (20)) v(i)

-- Test 67: statement (line 392)
CREATE FUNCTION f_101253() RETURNS RECORD VOLATILE NOT LEAKPROOF LANGUAGE SQL AS $$
  SELECT * FROM (VALUES (e'\x1b'), ('y$$sFV'), (e'\x06'));
$$;

-- Test 68: statement (line 397)
CREATE FUNCTION f_101253() RETURNS RECORD VOLATILE NOT LEAKPROOF LANGUAGE SQL AS $func$
  SELECT * FROM (VALUES (e'\x1b'), ('y$$sFV'), (e'\x06'));
$func$;

-- Test 69: statement (line 409)
CREATE FUNCTION f100915(i INT) RETURNS BOOL STABLE LANGUAGE SQL AS $$
  SELECT i = 0 OR i = 10
$$

-- Test 70: query (line 414)
SELECT f100915((SELECT y FROM (VALUES (10), (20)) y(y) WHERE x=y)) FROM (VALUES (10), (20)) x(x)

-- Test 71: query (line 420)
SELECT f100915(20-(SELECT y FROM (VALUES (10), (20)) y(y) WHERE x=y)) FROM (VALUES (10), (20)) x(x)

-- Test 72: statement (line 430)
CREATE SEQUENCE sq_103869;

-- Test 73: statement (line 433)
CREATE FUNCTION f_103869(sq REGCLASS) RETURNS INT
LANGUAGE SQL
AS $$
    SELECT setval(sq, 1);
$$;

-- Test 74: query (line 440)
SELECT f_103869('sq_103869'::REGCLASS);

-- Test 75: query (line 452)
SELECT f_103869('sq_103869')

-- Test 76: query (line 471)
SELECT json_agg(r) FROM (
  SELECT i, s
  FROM t104927
) AS r

-- Test 77: statement (line 479)
CREATE FUNCTION f104927() RETURNS TEXT LANGUAGE SQL AS $$
  SELECT json_agg(r) FROM (
    SELECT i, s
    FROM t104927
  ) AS r
$$

-- Test 78: query (line 488)
SELECT f104927()

-- Test 79: statement (line 501)
CREATE TABLE tab104242 (a INT);

-- Test 80: statement (line 504)
CREATE TYPE typ104242 AS ENUM ('foo');

-- Test 81: statement (line 507)
CREATE FUNCTION func104242() RETURNS INT LANGUAGE SQL AS $$
  SELECT 1 FROM tab104242 WHERE NULL::typ104242 IN ()
$$;

-- Test 82: query (line 512)
SELECT create_statement FROM [SHOW CREATE FUNCTION func104242]

-- Test 83: statement (line 526)
CREATE FUNCTION func104242_not_null() RETURNS INT LANGUAGE SQL AS $$
  SELECT 1 FROM tab104242 WHERE 'foo'::typ104242 IN ()
$$;

-- Test 84: query (line 531)
SELECT create_statement FROM [SHOW CREATE FUNCTION func104242_not_null]

-- Test 85: statement (line 552)
CREATE TYPE e105259 AS ENUM ('foo');

-- Test 86: statement (line 555)
CREATE FUNCTION f() RETURNS VOID LANGUAGE SQL AS $$
  SELECT (SELECT 'foo')::e105259;
  SELECT NULL;
$$

-- Test 87: statement (line 561)
CREATE FUNCTION f() RETURNS VOID LANGUAGE SQL AS $$
  SELECT (
    CASE WHEN true THEN (SELECT 'foo') ELSE NULL END
  )::e105259;
  SELECT NULL;
$$

-- Test 88: statement (line 576)
CREATE OR REPLACE FUNCTION f108297() RETURNS VOID LANGUAGE SQL AS 'SELECT 1'

-- Test 89: query (line 579)
SELECT f108297()

-- Test 90: statement (line 584)
CREATE OR REPLACE FUNCTION f108297() RETURNS VOID LANGUAGE SQL AS $$
  SELECT 1, 'foo', NULL
$$

-- Test 91: query (line 589)
SELECT f108297()

-- Test 92: statement (line 594)
CREATE SEQUENCE s108297

-- Test 93: statement (line 597)
CREATE OR REPLACE FUNCTION f108297() RETURNS VOID LANGUAGE SQL AS $$
  SELECT nextval('s108297')
$$

-- Test 94: query (line 602)
SELECT f108297()

-- Test 95: query (line 609)
SELECT nextval('s108297')

-- Test 96: statement (line 620)
CREATE FUNCTION now() RETURNS TIMESTAMP STABLE LANGUAGE SQL AS $$ SELECT TIMESTAMP '1999-12-31 23:59:59.999999'; $$;

-- Test 97: query (line 623)
SELECT now() > '2024-06-21 19:04:25.625514+00'

-- Test 98: statement (line 628)
SET search_path = public, pg_catalog

-- Test 99: query (line 631)
SELECT public.now()

-- Test 100: query (line 636)
SELECT now()

-- Test 101: query (line 641)
SELECT now() > '2024-06-21 19:04:25.625514+00'

