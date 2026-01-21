-- PostgreSQL compatible tests from udf_oid_ref
-- 26 tests

SET client_min_messages = warning;

-- Cockroach supports calling a function by OID via `[FUNCTION <oid>](...)`.
-- PostgreSQL does not, so we emulate "call by OID" for INT-returning funcs.
DROP FUNCTION IF EXISTS crdb_call_int(oid, VARIADIC text[]);
CREATE FUNCTION crdb_call_int(fn_oid oid, VARIADIC args text[])
RETURNS INT
LANGUAGE plpgsql
AS $$
DECLARE
  proc_nsp text;
  proc_name text;
  arg_oids oid[];
  nargs int;
  provided int;
  sql text;
  i int;
  result int;
BEGIN
  IF args IS NULL THEN
    args := ARRAY[]::text[];
  END IF;

  SELECT n.nspname, p.proname, p.proargtypes::oid[]
    INTO proc_nsp, proc_name, arg_oids
  FROM pg_proc p
  JOIN pg_namespace n ON n.oid = p.pronamespace
  WHERE p.oid = fn_oid;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'function with oid % not found', fn_oid;
  END IF;

  IF arg_oids IS NULL THEN
    arg_oids := ARRAY[]::oid[];
  END IF;

  nargs := coalesce(array_length(arg_oids, 1), 0);
  provided := coalesce(array_length(args, 1), 0);
  IF provided <> nargs THEN
    RAISE EXCEPTION 'function %.% expects % argument(s) but got %',
      proc_nsp, proc_name, nargs, provided;
  END IF;

  sql := format('SELECT %I.%I(', proc_nsp, proc_name);
  FOR i IN 1..nargs LOOP
    IF i > 1 THEN
      sql := sql || ', ';
    END IF;
    sql := sql || format('%s::%s', quote_literal(args[i]), format_type(arg_oids[i], NULL));
  END LOOP;
  sql := sql || ')::int';

  EXECUTE sql INTO result;
  RETURN result;
END;
$$;

DROP FUNCTION IF EXISTS crdb_call_int(oid);
CREATE FUNCTION crdb_call_int(fn_oid oid)
RETURNS INT
LANGUAGE SQL
AS $$
  SELECT public.crdb_call_int(fn_oid, VARIADIC ARRAY[]::text[]);
$$;

DROP SCHEMA IF EXISTS test CASCADE;
DROP SCHEMA IF EXISTS db1 CASCADE;
DROP SCHEMA IF EXISTS sc1 CASCADE;
CREATE SCHEMA test;
SET search_path = test, public;

DROP TABLE IF EXISTS t1;
CREATE TABLE t1 (a INT PRIMARY KEY, b TEXT);

-- Test 1: query (line 4)
SELECT string_to_array('hello,world', ',');

-- Test 2: statement (line 12)
INSERT INTO t1(a) VALUES (1);

-- Test 3: query (line 15)
SELECT * FROM t1 ORDER BY a;

-- Test 4: statement (line 20)
INSERT INTO t1 VALUES (2, 'hello,new,world');

-- Test 5: statement (line 23)
CREATE INDEX idx ON t1 ((string_to_array(b, ',')));

-- Test 6: query (line 26)
SELECT * FROM t1 WHERE string_to_array(b, ',') = ARRAY['hello','new','world'] ORDER BY a;

-- Test 7: statement (line 33)
ALTER TABLE t1 ADD CONSTRAINT c_len CHECK (length(b) > 2);

-- Test 8: statement (line 36)
\set ON_ERROR_STOP 0
INSERT INTO t1 VALUES (3, 'a');
\set ON_ERROR_STOP 1

-- Test 9: statement (line 39)
DROP FUNCTION IF EXISTS f1();
CREATE FUNCTION f1() RETURNS INT LANGUAGE SQL AS $$ SELECT 1 $$;

SELECT 'f1()'::regprocedure::oid AS fn_oid \gset

-- Test 10: query (line 45)
SELECT crdb_call_int(:fn_oid::oid);

-- Test 11: query (line 56)
\set ON_ERROR_STOP 0
SELECT crdb_call_int(:fn_oid::oid, 'hello world');
\set ON_ERROR_STOP 1

-- Test 12: statement (line 63)
\set ON_ERROR_STOP 0
SELECT crdb_call_int(:fn_oid::oid, 123::text);
\set ON_ERROR_STOP 1

-- Test 13: query (line 70)
\set ON_ERROR_STOP 0
SELECT crdb_call_int(:fn_oid::oid, 'hello world');
\set ON_ERROR_STOP 1

-- Test 14: statement (line 75)
CREATE SCHEMA sc1;

-- Test 15: query (line 81)
\set ON_ERROR_STOP 0
SELECT crdb_call_int(:fn_oid::oid, 'hello world');
\set ON_ERROR_STOP 1

-- Test 16: statement (line 90)
\set ON_ERROR_STOP 0
SELECT crdb_call_int(:fn_oid::oid, 'maybe');
\set ON_ERROR_STOP 1

-- Test 17: statement (line 95)
DROP FUNCTION IF EXISTS f_in_udf();
CREATE FUNCTION f_in_udf() RETURNS INT LANGUAGE SQL AS $$ SELECT 1 $$;

SELECT 'f_in_udf()'::regprocedure::oid AS fn_oid \gset

-- Test 18: statement (line 101)
DROP FUNCTION IF EXISTS f_using_udf();
CREATE FUNCTION f_using_udf() RETURNS INT LANGUAGE SQL AS $$ SELECT public.crdb_call_int('test.f_in_udf()'::regprocedure::oid) $$;

-- Test 19: query (line 104)
SELECT f_using_udf();

-- Test 20: statement (line 111)
DROP FUNCTION IF EXISTS f_using_udf_2();
CREATE FUNCTION f_using_udf_2() RETURNS INT LANGUAGE SQL AS $$ SELECT length('abc') $$;

-- Test 21: query (line 114)
SELECT f_using_udf_2();

-- Test 22: statement (line 121)
CREATE SCHEMA db1;

-- Test 23: statement (line 124)
SET search_path = db1, public;

-- Test 24: statement (line 127)
DROP FUNCTION IF EXISTS f_cross_db();
CREATE FUNCTION f_cross_db() RETURNS INT LANGUAGE SQL AS $$ SELECT 321 $$;

SELECT 'db1.f_cross_db()'::regprocedure::oid AS fn_oid \gset

-- Test 25: statement (line 133)
SET search_path = test, public;

-- Test 26: query (line 136)
SELECT crdb_call_int(:fn_oid::oid);

RESET search_path;
RESET client_min_messages;
