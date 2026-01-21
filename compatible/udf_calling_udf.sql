-- PostgreSQL compatible tests from udf_calling_udf
-- 46 tests

\set ON_ERROR_STOP 1
SET client_min_messages = warning;

-- Helper UDFs used by the dependency/ALTER FUNCTION tests.
CREATE FUNCTION lower_hello() RETURNS TEXT LANGUAGE SQL BEGIN ATOMIC
  SELECT 'hello'::TEXT;
END;

CREATE FUNCTION upper_hello() RETURNS TEXT LANGUAGE SQL BEGIN ATOMIC
  SELECT upper(lower_hello());
END;

CREATE FUNCTION concat_hello() RETURNS TEXT LANGUAGE SQL BEGIN ATOMIC
  SELECT lower_hello() || lower_hello();
END;

CREATE FUNCTION nested_udf_for_from() RETURNS TEXT LANGUAGE SQL BEGIN ATOMIC
  SELECT concat_hello();
END;

-- Test 1: query (line 13)
SELECT upper_hello(), nested_udf_for_from(), lower_hello(), concat_hello();

-- Test 2: statement (line 19)
CREATE FUNCTION udfCall(i INT) RETURNS INT LANGUAGE SQL BEGIN ATOMIC
  SELECT 100 + i;
END;
CREATE FUNCTION udfCallNest(i INT, j INT) RETURNS INT LANGUAGE SQL BEGIN ATOMIC
  SELECT udfCall(i) + j;
END;
CREATE FUNCTION udfCallNest_2(i INT, j INT) RETURNS INT LANGUAGE SQL BEGIN ATOMIC
  SELECT udfCall(i) + udfCall(j) + udfCallNest(i, j);
END;
CREATE FUNCTION udfCallNest_3(i INT, j INT) RETURNS INT LANGUAGE SQL BEGIN ATOMIC
  SELECT udfCall(j) + udfCallNest(i, j) + udfCallNest_2(i, j) + 1
  FROM udfCallNest_2(i, j);
END;

-- Test 3: query (line 25)
SELECT * FROM udfCallNest_3(1, 2);

-- Test 4: query (line 31)
SELECT
  src_p.proname AS "from",
  dst_p.proname AS "to"
FROM pg_depend AS d
JOIN pg_proc AS src_p ON d.objid = src_p.oid
JOIN pg_proc AS dst_p ON d.refobjid = dst_p.oid
WHERE d.classid = 'pg_proc'::regclass
  AND d.refclassid = 'pg_proc'::regclass
  AND src_p.pronamespace = 'public'::regnamespace
  AND dst_p.pronamespace = 'public'::regnamespace
  AND src_p.proname IN (
    'udfcall', 'udfcallnest', 'udfcallnest_2', 'udfcallnest_3',
    'upper_hello', 'lower_hello', 'concat_hello', 'nested_udf_for_from'
  )
  AND dst_p.proname IN (
    'udfcall', 'udfcallnest', 'udfcallnest_2', 'udfcallnest_3',
    'upper_hello', 'lower_hello', 'concat_hello', 'nested_udf_for_from'
  )
ORDER BY 1, 2;

-- Test 5: statement (line 58)
ALTER FUNCTION lower_hello() RENAME TO lower_hello_new;

-- Test 6: statement (line 61)
CREATE SCHEMA sc2;

-- Test 7: statement (line 65)
ALTER FUNCTION lower_hello_new() SET SCHEMA sc2;

-- Test 8: statement (line 68)
CREATE FUNCTION f() RETURNS INT LANGUAGE SQL BEGIN ATOMIC
  SELECT 1;
END;

-- Test 9: statement (line 73)
CREATE FUNCTION g() RETURNS INT LANGUAGE SQL BEGIN ATOMIC
  SELECT f();
END;

-- Test 10: statement (line 79)
CREATE OR REPLACE FUNCTION f() RETURNS INT LANGUAGE SQL BEGIN ATOMIC
  SELECT g();
END;

-- Test 11: statement (line 84)
DROP FUNCTION f() CASCADE;
DROP FUNCTION IF EXISTS g();

-- Test 12: statement (line 88)
CREATE TABLE ab (
  a INT PRIMARY KEY,
  b INT
);

-- Test 13: statement (line 94)
CREATE FUNCTION ins_ab(new_a INT, new_b INT) RETURNS INT LANGUAGE SQL BEGIN ATOMIC
  INSERT INTO ab VALUES (new_a, new_b) RETURNING a;
END;

-- Test 14: statement (line 99)
CREATE FUNCTION ins(new_a INT) RETURNS INT LANGUAGE SQL BEGIN ATOMIC
  SELECT ins_ab(new_a, new_a * 10);
  SELECT b FROM ab WHERE a = new_a;
END;

-- Test 15: query (line 105)
SELECT ins(i) FROM generate_series(1, 3) g(i);

-- Test 16: query (line 112)
SELECT ins(5), ins(6) FROM (VALUES (1)) v(i) WHERE i < ins(4);

-- Test 17: query (line 117)
SELECT * FROM ab;

-- Test 18: statement (line 127)
\set ON_ERROR_STOP 0
SELECT ins(4);
\set ON_ERROR_STOP 1

-- skipif config local-legacy-schema-changer

-- Test 19: statement (line 131)
\set ON_ERROR_STOP 0
DROP TABLE ab;
\set ON_ERROR_STOP 1

-- onlyif config local-legacy-schema-changer

-- Test 20: statement (line 135)
-- DROP TABLE ab;

-- Test 21: statement (line 138)
\set ON_ERROR_STOP 0
DROP FUNCTION ins_ab;
\set ON_ERROR_STOP 1

-- Test 22: statement (line 141)
DROP FUNCTION ins;
DROP FUNCTION ins_ab;
DROP TABLE ab;

-- Test 23: statement (line 146)
CREATE FUNCTION identity1(n INT) RETURNS INT LANGUAGE SQL BEGIN ATOMIC
  SELECT n;
END;

-- Test 24: statement (line 151)
CREATE FUNCTION identity2(n INT) RETURNS INT LANGUAGE SQL BEGIN ATOMIC
  SELECT identity1(n);
END;

-- Test 25: query (line 156)
SELECT identity2(11);

-- Test 26: statement (line 161)
DROP FUNCTION identity2;
DROP FUNCTION identity1;

-- Test 27: statement (line 165)
CREATE FUNCTION self_cycle(a INT, b INT) RETURNS INT LANGUAGE SQL BEGIN ATOMIC
  SELECT a + b;
END;

-- Test 28: statement (line 170)
CREATE OR REPLACE FUNCTION self_cycle(a INT, b INT) RETURNS INT LANGUAGE SQL BEGIN ATOMIC
  SELECT self_cycle(a, b);
END;

-- Test 29: statement (line 173)
CREATE OR REPLACE FUNCTION self_cycle(a INT = 1, b INT = 2) RETURNS INT LANGUAGE SQL BEGIN ATOMIC
  SELECT a + b;
END;

-- Test 30: statement (line 176)
CREATE OR REPLACE FUNCTION self_cycle(a INT = 1, b INT = self_cycle(1)) RETURNS INT LANGUAGE SQL BEGIN ATOMIC
  SELECT a + b;
END;

-- Test 31: statement (line 179)
DROP FUNCTION self_cycle;

-- Test 32: statement (line 183)
CREATE TYPE typ AS (x INT, y INT);

-- Test 33: statement (line 186)
CREATE FUNCTION f_nested(a INT) RETURNS typ LANGUAGE SQL BEGIN ATOMIC
  SELECT a * 2;
  SELECT ROW(1, 2)::typ;
END;

-- Test 34: statement (line 192)
CREATE FUNCTION f(a INT) RETURNS INT LANGUAGE SQL BEGIN ATOMIC
  SELECT (f_nested(a)).y;
END;

-- Test 35: query (line 197)
SELECT f(2);

-- Test 36: query (line 202)
SELECT * FROM f(2);

-- Test 37: statement (line 207)
CREATE FUNCTION f1(a INT = 1) RETURNS INT LANGUAGE SQL BEGIN ATOMIC
  SELECT a;
END;
CREATE FUNCTION f2(b INT = f1()) RETURNS INT LANGUAGE SQL BEGIN ATOMIC
  SELECT b;
END;

-- Test 38: statement (line 211)
CREATE OR REPLACE FUNCTION f1(a INT = f2()) RETURNS INT LANGUAGE SQL BEGIN ATOMIC
  SELECT a;
END;

-- Test 39: statement (line 214)
\set ON_ERROR_STOP 0
DROP FUNCTION f2;
DROP FUNCTION f1;
\set ON_ERROR_STOP 1

-- Test 40: statement (line 222)
CREATE FUNCTION "fooBAR"() RETURNS INT LANGUAGE SQL BEGIN ATOMIC
  SELECT 1;
END;

-- Test 41: statement (line 225)
CREATE FUNCTION f131354() RETURNS INT LANGUAGE SQL BEGIN ATOMIC
  SELECT "fooBAR"();
END;

-- Test 42: statement (line 228)
CREATE PROCEDURE p131354() LANGUAGE SQL AS $$ SELECT "fooBAR"(); $$;

-- Test 43: query (line 231)
SELECT f131354();

-- Test 44: statement (line 236)
CALL p131354();

-- Test 45: query (line 239)
SELECT pg_get_functiondef('f131354()'::regprocedure) AS create_statement;

-- Test 46: query (line 253)
SELECT pg_get_functiondef('p131354()'::regprocedure) AS create_statement;

RESET client_min_messages;
