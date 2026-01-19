-- PostgreSQL compatible tests from udf_calling_udf
-- 46 tests

-- Test 1: query (line 13)
SELECT upper_hello(), nested_udf_for_from(), lower_hello(), concat_hello()

-- Test 2: statement (line 19)
CREATE FUNCTION udfCall(i int) RETURNS INT LANGUAGE SQL AS 'SELECT 100+i';
CREATE FUNCTION udfCallNest(i int, j int) RETURNS INT LANGUAGE SQL AS 'SELECT udfCall(i) + j';
CREATE FUNCTION udfCallNest_2(i int, j int) RETURNS INT LANGUAGE SQL AS 'SELECT udfCall(i) + udfCall(j) + udfCallNest(i, j)';
CREATE FUNCTION udfCallNest_3(i int, j int) RETURNS INT  LANGUAGE SQL AS 'SELECT  udfCall(j) + udfCallNest(i, j) + udfCallNest_2(i, j) + 1 FROM udfCallNest_2(i, j)';

-- Test 3: query (line 25)
SELECT * FROM udfCallNest_3(1, 2)

-- Test 4: query (line 31)
SELECT
	src_p.proname as from, dst_p.proname as to
FROM
	pg_depend AS d, pg_proc AS src_p, pg_proc AS dst_p
WHERE
	d.classid = 'pg_catalog.pg_proc'::REGCLASS::INT8
	AND d.refclassid = 'pg_catalog.pg_proc'::REGCLASS::INT8
	AND d.objid = src_p.oid
	AND d.refobjid = dst_p.oid;

-- Test 5: statement (line 58)
ALTER FUNCTION lower_hello rename to lower_hello_new

-- Test 6: statement (line 61)
CREATE SCHEMA sc2;

-- Test 7: statement (line 65)
ALTER FUNCTION lower_hello SET SCHEMA sc2;

-- Test 8: statement (line 68)
CREATE FUNCTION f() RETURNS INT LANGUAGE SQL AS $$
  SELECT 1;
$$

-- Test 9: statement (line 73)
CREATE FUNCTION g() RETURNS INT LANGUAGE SQL AS $$
  SELECT f();
$$

-- Test 10: statement (line 79)
CREATE OR REPLACE FUNCTION f() RETURNS INT LANGUAGE SQL AS $$
  SELECT g();
$$

-- Test 11: statement (line 84)
DROP FUNCTION g();
DROP FUNCTION f();

-- Test 12: statement (line 88)
CREATE TABLE ab (
  a INT PRIMARY KEY,
  b INT
)

-- Test 13: statement (line 94)
CREATE FUNCTION ins_ab(new_a INT, new_b INT) RETURNS INT LANGUAGE SQL AS $$
  INSERT INTO ab VALUES (new_a, new_b) RETURNING a;
$$

-- Test 14: statement (line 99)
CREATE FUNCTION ins(new_a INT) RETURNS INT LANGUAGE SQL AS $$
  SELECT ins_ab(new_a, new_a * 10);
  SELECT b FROM ab WHERE a = new_a;
$$

-- Test 15: query (line 105)
SELECT ins(i) FROM generate_series(1, 3) g(i)

-- Test 16: query (line 112)
SELECT ins(5), ins(6) FROM (VALUES (1)) v(i) WHERE i < ins(4)

-- Test 17: query (line 117)
SELECT * FROM ab

-- Test 18: statement (line 127)
SELECT ins(4)

skipif config local-legacy-schema-changer

-- Test 19: statement (line 131)
DROP TABLE ab

onlyif config local-legacy-schema-changer

-- Test 20: statement (line 135)
DROP TABLE ab

-- Test 21: statement (line 138)
DROP FUNCTION ins_ab

-- Test 22: statement (line 141)
DROP FUNCTION ins;
DROP FUNCTION ins_ab;
DROP TABLE ab;

-- Test 23: statement (line 146)
CREATE FUNCTION identity1(n INT) RETURNS INT LANGUAGE SQL AS $$
  SELECT n;
$$

-- Test 24: statement (line 151)
CREATE FUNCTION identity2(n INT) RETURNS INT LANGUAGE SQL AS $$
  SELECT identity1(n);
$$

-- Test 25: query (line 156)
SELECT identity2(11)

-- Test 26: statement (line 161)
DROP FUNCTION identity2;
DROP FUNCTION identity1;

-- Test 27: statement (line 165)
CREATE FUNCTION self_cycle(a INT, b INT) RETURNS INT LANGUAGE SQL AS $$ SELECT a + b; $$;

-- Test 28: statement (line 170)
CREATE OR REPLACE FUNCTION self_cycle(a INT, b INT) RETURNS INT LANGUAGE SQL AS $$ SELECT self_cycle(a, b); $$;

-- Test 29: statement (line 173)
CREATE OR REPLACE FUNCTION self_cycle(a INT = 1, b INT = 2) RETURNS INT LANGUAGE SQL AS $$ SELECT a + b; $$;

-- Test 30: statement (line 176)
CREATE OR REPLACE FUNCTION self_cycle(a INT = 1, b INT = self_cycle(1)) RETURNS INT LANGUAGE SQL AS $$ SELECT a + b; $$;

-- Test 31: statement (line 179)
DROP FUNCTION self_cycle;

-- Test 32: statement (line 183)
CREATE TYPE typ AS (x INT, y INT);

-- Test 33: statement (line 186)
CREATE FUNCTION f_nested(a INT) RETURNS typ AS $$
  SELECT a * 2;
  SELECT ROW(1, 2)::typ;
$$ LANGUAGE SQL;

-- Test 34: statement (line 192)
CREATE FUNCTION f(a INT) RETURNS INT AS $$
  SELECT (f_nested(a)).y;
$$ LANGUAGE SQL;

-- Test 35: query (line 197)
SELECT f(2);

-- Test 36: query (line 202)
SELECT * FROM f(2);

-- Test 37: statement (line 207)
CREATE FUNCTION f1(a INT = 1) RETURNS INT LANGUAGE SQL AS $$ SELECT a; $$;
CREATE FUNCTION f2(b INT = f1()) RETURNS INT LANGUAGE SQL AS $$ SELECT b; $$;

-- Test 38: statement (line 211)
CREATE OR REPLACE FUNCTION f1(a INT = f2()) RETURNS INT LANGUAGE SQL AS $$ SELECT a; $$;

-- Test 39: statement (line 214)
DROP FUNCTION f2;
DROP FUNCTION f1;

-- Test 40: statement (line 222)
CREATE FUNCTION "fooBAR"() RETURNS INT LANGUAGE SQL AS $$ SELECT 1; $$;

-- Test 41: statement (line 225)
CREATE FUNCTION f131354() RETURNS INT LANGUAGE SQL AS $$ SELECT "fooBAR"(); $$;

-- Test 42: statement (line 228)
CREATE PROCEDURE p131354() LANGUAGE SQL AS $$ SELECT "fooBAR"(); $$;

-- Test 43: query (line 231)
SELECT f131354();

-- Test 44: statement (line 236)
CALL p131354();

-- Test 45: query (line 239)
SELECT create_statement FROM [SHOW CREATE FUNCTION f131354];

-- Test 46: query (line 253)
SELECT create_statement FROM [SHOW CREATE PROCEDURE p131354];

