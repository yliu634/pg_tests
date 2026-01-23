-- PostgreSQL compatible tests from udf_polymorphic
-- 94 tests

-- Many statements below intentionally error (polymorphic type resolution).
\set ON_ERROR_STOP 0

-- Test 1: statement (line 1)
CREATE TYPE greetings AS ENUM('hi', 'hello', 'yo');
CREATE TYPE foo AS ENUM('bar', 'baz');
CREATE TYPE typ AS (x INT, y INT);

-- Test 2: statement (line 9)
CREATE FUNCTION f(x ANYELEMENT) RETURNS INT LANGUAGE SQL AS $$ SELECT 1; $$;

-- Test 3: statement (line 12)
SELECT f(1);
SELECT f('foo'::TEXT);
SELECT f(False);
SELECT f(NULL::INT);
SELECT f('hi'::greetings);
SELECT f(ARRAY[1, 2, 3]);

-- Test 4: statement (line 21)
SELECT f('foo'::TEXT);

-- Test 5: statement (line 24)
SELECT f(NULL::INT);

-- Test 6: statement (line 28)
DROP FUNCTION f;
CREATE FUNCTION f(x ANYARRAY) RETURNS INT LANGUAGE SQL AS $$ SELECT 1; $$;

-- Test 7: statement (line 32)
SELECT f(ARRAY[1, 2, 3]);
SELECT f(ARRAY['one', 'two', 'three']);
SELECT f(NULL::INT[]);
SELECT f('{1, 2, 3}'::INT[]);

-- Test 8: statement (line 39)
SELECT f('{1, 2, 3}'::INT[]);

-- Test 9: statement (line 42)
SELECT f(NULL::INT[]);

-- Test 10: statement (line 45)
DO $do$
BEGIN
  PERFORM f(1);
EXCEPTION
  WHEN undefined_function THEN
    NULL;
END
$do$;

-- Test 11: statement (line 48)
DO $do$
BEGIN
  PERFORM f('hi'::greetings);
EXCEPTION
  WHEN undefined_function THEN
    NULL;
END
$do$;

-- Test 12: statement (line 76)
DROP FUNCTION f;
CREATE FUNCTION f(x ANYELEMENT, y ANYELEMENT) RETURNS INT LANGUAGE SQL AS $$ SELECT 1; $$;

-- Test 13: statement (line 80)
SELECT f(1, 2);
SELECT f(NULL, 1);
SELECT f(ARRAY[1, 2], ARRAY[3, 4]);
SELECT f('hi'::greetings, 'hello'::greetings);

-- Test 14: statement (line 87)
SELECT f(1, '2');

-- Test 15: statement (line 91)
SELECT f('hi'::greetings, 'hello');

-- Test 16: statement (line 96)
DO $do$
BEGIN
  PERFORM f('1', '2');
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END
$do$;

-- Test 17: statement (line 99)
DO $do$
BEGIN
  PERFORM f(NULL, NULL);
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END
$do$;

-- Test 18: statement (line 102)
DO $do$
BEGIN
  PERFORM f(1, False);
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END
$do$;

-- Test 19: statement (line 105)
DO $do$
BEGIN
  PERFORM f(ARRAY[1, 2], ARRAY[False, True]);
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END
$do$;

-- Test 20: statement (line 110)
DROP FUNCTION f;
CREATE FUNCTION f(x ANYARRAY, y ANYARRAY) RETURNS INT LANGUAGE SQL AS $$ SELECT 1; $$;

-- Test 21: statement (line 114)
SELECT f(ARRAY[1, 2, 3], ARRAY[4, 5, 6]);
SELECT f(ARRAY[True, False], ARRAY[False, NULL]);
SELECT f(NULL, ARRAY[1, 2]);
SELECT f(ARRAY['hi'::greetings, 'hello'::greetings], ARRAY['yo'::greetings, NULL]);
SELECT f(ARRAY[ROW(1, 2)::typ, NULL], ARRAY[ROW(3, 4)::typ]);

-- Test 22: statement (line 121)
DO $do$
BEGIN
  PERFORM f(NULL, NULL);
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END
$do$;

-- Test 23: statement (line 125)
DO $do$
BEGIN
  PERFORM f('{1, 2}', '{3, 4}');
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END
$do$;

-- Test 24: statement (line 128)
DO $do$
BEGIN
  PERFORM f(1, 2);
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END
$do$;

-- Test 25: statement (line 131)
DO $do$
BEGIN
  PERFORM f(ARRAY[1, 2], 3);
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END
$do$;

-- Test 26: statement (line 134)
DO $do$
BEGIN
  PERFORM f('hi'::greetings, 'hello'::greetings);
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END
$do$;

-- Test 27: statement (line 169)
DROP FUNCTION f;
CREATE FUNCTION f(x ANYARRAY, y ANYELEMENT) RETURNS INT LANGUAGE SQL AS $$ SELECT 1; $$;

-- Test 28: statement (line 173)
SELECT f(ARRAY[1, 2], 1);
SELECT f(ARRAY[1, 2], NULL);
SELECT f(NULL, 1);
SELECT f(ARRAY[True], False);
SELECT f(ARRAY['hi'], 'hello');
SELECT f(ARRAY['hi'::greetings], 'hello'::greetings);
SELECT f(ARRAY['hi']::greetings[], 'hello'::greetings);

-- Test 29: statement (line 183)
SELECT f(ARRAY[1, 2], '1');

-- Test 30: statement (line 186)
DO $do$
BEGIN
  PERFORM f(NULL, NULL);
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END
$do$;

-- Test 31: statement (line 189)
DO $do$
BEGIN
  PERFORM f(ARRAY['hi'], 'hello'::greetings);
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END
$do$;

-- Test 32: statement (line 192)
DO $do$
BEGIN
  PERFORM f('hello'::greetings, ARRAY['hi']);
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END
$do$;

-- Test 33: statement (line 195)
DO $do$
BEGIN
  PERFORM f(1, 2);
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END
$do$;

-- Test 34: statement (line 198)
DO $do$
BEGIN
  PERFORM f(ARRAY[1, 2], ARRAY[3, 4]);
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END
$do$;

-- Test 35: statement (line 201)
DROP FUNCTION f;
CREATE FUNCTION f(x ANYELEMENT, y ANYARRAY) RETURNS INT LANGUAGE SQL AS $$ SELECT 1; $$;

-- Test 36: statement (line 205)
SELECT f(1, ARRAY[1, 2]);
SELECT f(NULL, ARRAY[1, 2]);
SELECT f(1, NULL);
SELECT f(False, ARRAY[True]);
SELECT f('hello', ARRAY['hi']);
SELECT f('hello'::greetings, ARRAY['hi'::greetings]);
SELECT f('hello'::greetings, ARRAY['hi']::greetings[]);

-- Test 37: statement (line 215)
SELECT f('1', ARRAY[1, 2]);

-- Test 38: statement (line 218)
DO $do$
BEGIN
  PERFORM f(NULL, NULL);
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END
$do$;

-- Test 39: statement (line 221)
DO $do$
BEGIN
  PERFORM f(ARRAY['hi'], 'hello'::greetings);
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END
$do$;

-- Test 40: statement (line 224)
DO $do$
BEGIN
  PERFORM f('hello'::greetings, ARRAY['hi']);
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END
$do$;

-- Test 41: statement (line 227)
DO $do$
BEGIN
  PERFORM f(1, 2);
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END
$do$;

-- Test 42: statement (line 230)
DO $do$
BEGIN
  PERFORM f(ARRAY[1, 2], ARRAY[3, 4]);
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END
$do$;

-- Test 43: statement (line 352)
DROP FUNCTION f;
CREATE FUNCTION f(x ANYELEMENT) RETURNS ANYELEMENT LANGUAGE SQL AS $$ SELECT x; $$;

-- Test 44: query (line 356)
SELECT f(1), f(2), f(NULL::INT);

-- Test 45: statement (line 361)
SELECT f('foo'::TEXT);

-- Test 46: statement (line 364)
SELECT f(True);

-- Test 47: statement (line 367)
DROP FUNCTION f;

-- Test 48: statement (line 373)
DO $do$
BEGIN
  EXECUTE $sql$CREATE FUNCTION f(x INT) RETURNS ANYELEMENT LANGUAGE SQL AS $$ SELECT 1; $$;$sql$;
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END
$do$;

-- Test 49: statement (line 377)
DO $do$
BEGIN
  EXECUTE $sql$CREATE FUNCTION f(x INT) RETURNS ANYARRAY LANGUAGE SQL AS $$ SELECT 1; $$;$sql$;
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END
$do$;

-- Test 50: statement (line 381)
DO $do$
BEGIN
  EXECUTE $sql$CREATE FUNCTION f(OUT x ANYELEMENT) LANGUAGE SQL AS $$ SELECT 1; $$;$sql$;
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END
$do$;

-- Test 51: statement (line 385)
DO $do$
BEGIN
  EXECUTE $sql$CREATE FUNCTION f(x INT, OUT y ANYELEMENT) LANGUAGE SQL AS $$ SELECT 1; $$;$sql$;
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END
$do$;

-- Test 52: statement (line 389)
DO $do$
BEGIN
  EXECUTE $sql$CREATE FUNCTION f(x INT, OUT y ANYARRAY, OUT z ANYELEMENT) LANGUAGE SQL AS $$ SELECT 1; $$;$sql$;
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END
$do$;

-- Test 53: statement (line 395)
CREATE FUNCTION f(x ANYELEMENT) RETURNS ANYELEMENT LANGUAGE SQL AS $$ SELECT x; $$;

-- Test 54: query (line 398)
SELECT f(1), f(True), f(ARRAY[1, 2]);

-- Test 55: statement (line 404)
DROP FUNCTION f;
CREATE FUNCTION f(x ANYELEMENT) RETURNS ANYARRAY LANGUAGE SQL AS $$ SELECT ARRAY[x]; $$;

-- Test 56: query (line 408)
SELECT f(1), f(True);

-- Test 57: statement (line 413)
DO $do$
BEGIN
  PERFORM f(ARRAY[1, 2]);
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END
$do$;

-- Test 58: statement (line 417)
DROP FUNCTION f;
CREATE FUNCTION f(x ANYARRAY) RETURNS ANYELEMENT LANGUAGE SQL AS $$ SELECT x[1]; $$;

-- Test 59: query (line 421)
SELECT f(ARRAY[1, 2]), f(ARRAY[True, False]);

-- Test 60: statement (line 427)
DROP FUNCTION f;
CREATE FUNCTION f(INOUT x ANYELEMENT) LANGUAGE SQL AS $$ SELECT x; $$;

-- Test 61: query (line 431)
SELECT f(1), f(True), f(ARRAY[1, 2]);

-- Test 62: statement (line 437)
DROP FUNCTION f;
CREATE FUNCTION f(x ANYELEMENT, OUT y ANYELEMENT) LANGUAGE SQL AS $$ SELECT x; $$;

-- Test 63: query (line 441)
SELECT f(1), f(True), f(ARRAY[1, 2]);

-- Test 64: statement (line 449)
DROP FUNCTION f;
CREATE FUNCTION f(x ANYELEMENT DEFAULT 1) RETURNS ANYELEMENT LANGUAGE SQL AS $$ SELECT x; $$;

-- Test 65: query (line 453)
SELECT f(), f(True), f('foo'::TEXT);

-- Test 66: statement (line 459)
DROP FUNCTION f;
CREATE FUNCTION f(x ANYELEMENT, y ANYELEMENT DEFAULT 1) RETURNS ANYELEMENT LANGUAGE SQL AS $$ SELECT y; $$;

-- Test 67: query (line 463)
SELECT f(1), f(1, 2), f('foo'::TEXT, 'bar'::TEXT), f(True, False);

-- Test 68: statement (line 468)
DO $do$
BEGIN
  PERFORM f(True);
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END
$do$;

-- Test 69: statement (line 471)
DROP FUNCTION f;
CREATE FUNCTION f(x ANYARRAY, y ANYARRAY DEFAULT ARRAY[1, 2]) RETURNS ANYARRAY LANGUAGE SQL AS $$ SELECT y; $$;

-- Test 70: query (line 475)
SELECT f(ARRAY[4, 5]);

-- Test 71: statement (line 480)
DO $do$
BEGIN
  PERFORM f(ARRAY[True]);
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END
$do$;

-- Test 72: statement (line 490)
DROP FUNCTION f;
CREATE FUNCTION f(x ANYELEMENT DEFAULT True, y ANYELEMENT DEFAULT 1) RETURNS ANYELEMENT LANGUAGE SQL AS $$ SELECT x; $$;

-- Test 73: query (line 494)
SELECT f(10), f(10, 100);

-- Test 74: statement (line 499)
DO $do$
BEGIN
  PERFORM f();
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END
$do$;

-- Test 75: statement (line 502)
DROP FUNCTION f;
CREATE FUNCTION f(x ANYELEMENT DEFAULT 10, y ANYARRAY DEFAULT ARRAY[1, 2]) RETURNS INT LANGUAGE SQL AS $$ SELECT 1; $$;

-- Test 76: statement (line 506)
SELECT f();
SELECT f(1);
SELECT f(1, ARRAY[100]);
SELECT f(True, ARRAY[False]);

-- Test 77: statement (line 512)
DO $do$
BEGIN
  PERFORM f(True);
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END
$do$;

-- Test 78: statement (line 515)
DROP FUNCTION f;
CREATE FUNCTION f(x ANYELEMENT DEFAULT True, y ANYARRAY DEFAULT ARRAY[1, 2]) RETURNS INT LANGUAGE SQL AS $$ SELECT 1; $$;

-- Test 79: statement (line 519)
SELECT f(1);
SELECT f(1, ARRAY[100]);
SELECT f(True, ARRAY[False]);

-- Test 80: statement (line 524)
DO $do$
BEGIN
  PERFORM f();
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END
$do$;

-- Test 81: statement (line 527)
DROP FUNCTION f;

-- Test 82: statement (line 530)
DO $do$
BEGIN
  EXECUTE $sql$CREATE FUNCTION f(x ANYARRAY DEFAULT 1) RETURNS INT LANGUAGE SQL AS $$ SELECT 1; $$;$sql$;
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END
$do$;

-- Test 83: statement (line 535)
CREATE FUNCTION f(x ANYELEMENT) RETURNS INT LANGUAGE SQL AS $$ SELECT 1; $$;

-- Test 84: statement (line 538)
DROP FUNCTION IF EXISTS f(INT);

-- Test 85: statement (line 541)
DROP FUNCTION IF EXISTS f(TEXT);

-- Test 86: statement (line 544)
DROP FUNCTION IF EXISTS f();

-- Test 87: statement (line 547)
DROP FUNCTION IF EXISTS f(ANYARRAY);

-- Test 88: statement (line 550)
DROP FUNCTION IF EXISTS f(ANYELEMENT);

-- Test 89: statement (line 553)
CREATE FUNCTION f(x INT) RETURNS INT LANGUAGE SQL AS $$ SELECT 1; $$;

-- Test 90: statement (line 556)
DROP FUNCTION IF EXISTS f(ANYARRAY);

-- Test 91: statement (line 559)
DROP FUNCTION IF EXISTS f(ANYELEMENT);

-- Test 92: statement (line 562)
DROP FUNCTION IF EXISTS f(INT);

-- Test 93: statement (line 567)
CREATE OR REPLACE FUNCTION dup (INOUT f2 ANYELEMENT, OUT f3 ANYARRAY) AS 'SELECT $1, ARRAY[$1,$1]' LANGUAGE SQL;

-- Test 94: query (line 570)
SELECT dup(22);
