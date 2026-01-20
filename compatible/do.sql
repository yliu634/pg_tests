-- PostgreSQL compatible tests from do
-- 39 tests

SET client_min_messages = warning;
DROP TABLE IF EXISTS t;
DROP TABLE IF EXISTS seed;
DROP FUNCTION IF EXISTS f();
DROP FUNCTION IF EXISTS f(int);
DROP PROCEDURE IF EXISTS p();
RESET client_min_messages;

-- Test 1: statement (line 2)
CREATE TABLE t (x INT);

-- Test 2: statement (line 5)
CREATE FUNCTION f() RETURNS INT LANGUAGE PLpgSQL AS $$ BEGIN RAISE NOTICE 'f()'; RETURN 1; END $$;

-- Test 3: statement (line 8)
CREATE PROCEDURE p() LANGUAGE PLpgSQL AS $$ BEGIN RAISE NOTICE 'p()'; END $$;

-- Test 4: query (line 13)
DO $$ BEGIN RAISE NOTICE 'Hello, world!'; END $$;

-- Test 5: query (line 19)
DO $$ BEGIN IF (SELECT max(x) FROM t) > 3 THEN RETURN; END IF; RAISE NOTICE 'HERE'; RETURN; RAISE NOTICE 'STILL HERE'; END $$;

-- Test 6: query (line 25)
DO $$
  DECLARE
    x INT := 0;
  BEGIN
    FOR i IN 1..3 LOOP
      x := x + i;
      RAISE NOTICE 'i = %, x = %', i, x;
    END LOOP;
  END
$$;

-- Test 7: query (line 42)
DO $$
  BEGIN
    RAISE NOTICE 'f() returned: %', f();
    RAISE NOTICE 'calling p()';
    CALL p();
  END
$$;

-- Test 8: query (line 57)
DO $$ BEGIN RAISE NOTICE 'here'; DO $inner$ BEGIN RAISE NOTICE 'hello world!'; END $inner$; RAISE NOTICE 'still here'; END $$;

-- Test 9: query (line 65)
DO $$
  BEGIN
    INSERT INTO t VALUES (1);
    RAISE NOTICE 'outer block inserted 1: max=%', (SELECT max(x) FROM t);
    DO $inner$
      BEGIN
        RAISE NOTICE 'inner block: max=%', (SELECT max(x) FROM t);
        INSERT INTO t VALUES (2);
        RAISE NOTICE 'inner block inserted 2: max=%', (SELECT max(x) FROM t);
      END
    $inner$;
    RAISE NOTICE 'after inner block: max=%', (SELECT max(x) FROM t);
  END
$$;

-- Test 10: statement (line 86)
DO $$ BEGIN RETURN; END $$;

-- Test 11: statement (line 90)
WITH foo AS (SELECT f() AS x) SELECT 1;

-- Test 12: statement (line 93)
SELECT * FROM (SELECT f() AS x) AS t(x);

-- Test 13: statement (line 100)
DROP FUNCTION IF EXISTS f();
CREATE FUNCTION f() RETURNS INT LANGUAGE PLpgSQL AS $$
  BEGIN
    RAISE NOTICE 'here';
    BEGIN
      RAISE NOTICE 'Hello, world!';
    END;
    RAISE NOTICE 'still here';
    RETURN 0;
  END
$$;

-- Test 14: query (line 115)
SELECT f();

-- Test 15: statement (line 123)
DROP FUNCTION IF EXISTS f();
CREATE FUNCTION f() RETURNS INT LANGUAGE PLpgSQL AS $$
  BEGIN
    RAISE NOTICE 'here';
    BEGIN
      RAISE NOTICE 'outer';
      BEGIN
        RAISE NOTICE 'inner';
      END;
      RAISE NOTICE 'outer again';
    END;
    RAISE NOTICE 'still here';
    RETURN 0;
  END
$$;

-- Test 16: query (line 144)
SELECT f();

-- Test 17: statement (line 155)
DROP FUNCTION IF EXISTS f();

-- Test 18: statement (line 158)
CREATE FUNCTION f() RETURNS INT LANGUAGE PLpgSQL AS $$
  DECLARE
    x INT := 100;
  BEGIN
    BEGIN
      RAISE NOTICE 'x: %', x;
    END;
    RETURN 0;
  END
$$;

-- Test 19: statement (line 172)
CREATE OR REPLACE FUNCTION f() RETURNS INT LANGUAGE PLpgSQL AS $$
  DECLARE
    x INT := 100;
  BEGIN
    RAISE NOTICE 'x := % before block', x;
    DECLARE
      x INT := 300;
    BEGIN
      RAISE NOTICE 'x := % in block', x;
    END;
    RAISE NOTICE 'x := % after block', x;
    RETURN 0;
  END
$$;

-- Test 20: query (line 190)
SELECT f();

-- Test 21: statement (line 201)
DROP FUNCTION IF EXISTS f();
CREATE FUNCTION f() RETURNS INT LANGUAGE PLpgSQL AS $$
BEGIN
  RAISE NOTICE 'Hello, world!';
  RETURN 100;
END
$$;

-- Test 22: query (line 208)
SELECT f();

-- Test 23: statement (line 213)
DROP FUNCTION IF EXISTS f();
CREATE FUNCTION f() RETURNS INT LANGUAGE PLpgSQL AS $$
BEGIN
  RAISE NOTICE 'outer';
  BEGIN
    RAISE NOTICE 'inner';
  END;
  RAISE NOTICE 'outer again';
  RETURN 100;
END
$$;

-- Test 24: query (line 226)
SELECT f();

-- Test 25: statement (line 233)
DROP FUNCTION IF EXISTS f();

-- Test 26: statement (line 237)
CREATE FUNCTION f(x INT) RETURNS INT LANGUAGE PLpgSQL AS $$
BEGIN
  RAISE NOTICE 'x: %', x;
  RETURN x;
END
$$;

-- Test 27: statement (line 243)
CREATE OR REPLACE FUNCTION f(x INT) RETURNS INT LANGUAGE PLpgSQL AS $$
BEGIN
  DECLARE
    x INT := 200;
  BEGIN
    RAISE NOTICE 'x: %', x;
  END;
  RETURN x;
END
$$;

-- Test 28: query (line 249)
SELECT f(100);

-- Test 29: statement (line 254)
DROP FUNCTION IF EXISTS f();

-- Test 30: statement (line 259)
CREATE FUNCTION f() RETURNS INT LANGUAGE PLpgSQL AS $$
DECLARE
  x INT := 200;
BEGIN
  RAISE NOTICE 'x: %', x;
  RETURN x;
END
$$;

-- Test 31: statement (line 264)
DROP PROCEDURE IF EXISTS p();
CREATE PROCEDURE p() LANGUAGE PLpgSQL AS $$
BEGIN
  RAISE NOTICE 'Hello, world!';
END
$$;

-- Test 32: query (line 270)
CALL p();

-- Test 33: statement (line 279)
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'mood') THEN
    CREATE TYPE mood AS ENUM ('happy', 'sad', 'neutral');
  END IF;
END
$$;

-- Test 34: statement (line 292)
DO $$
DECLARE
  foo INT;
BEGIN
END;
$$;

-- Test 35: statement (line 300)
DO $$
DECLARE
  foo INT[];
BEGIN
END;
$$;

-- Test 36: statement (line 310)
CREATE TABLE seed (_int8 INT8, _float8 FLOAT8);

-- Test 37: statement (line 313)
INSERT INTO seed DEFAULT VALUES;

-- Test 38: statement (line 316)
CREATE INDEX on seed (_int8, _float8);

-- Test 39: statement (line 322)
DO $$
BEGIN
  UPDATE seed SET _int8 = 1;
  -- Cockroach's index-table access (t@index) and crdb_internal columns don't exist in PG.
  PERFORM _float8, _int8 FROM seed ORDER BY _int8, _float8;
END;
$$;
