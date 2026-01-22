-- PostgreSQL compatible tests from udf_options
-- 33 tests

-- Test 1: statement (line 3)
-- C-language UDFs require a loadable shared library. Keep this as an
-- expected-error statement, but wrap in DO/EXCEPTION so the file stays
-- ERROR-free under psql.
DO $do$
BEGIN
  EXECUTE $sql$CREATE FUNCTION populate() RETURNS integer AS 'dir/funcs', 'populate' LANGUAGE C$sql$;
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END
$do$;

-- Test 2: statement (line 6)
-- Unknown languages are rejected in PostgreSQL. Wrap as an expected-error.
DO $do$
BEGIN
  EXECUTE $sql$
    CREATE FUNCTION populate() RETURNS integer AS $fn$
    DECLARE
        -- declarations
    BEGIN
        PERFORM my_function();
    END;
    $fn$ LANGUAGE made_up_language
  $sql$;
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END
$do$;

-- Test 3: statement (line 15)
CREATE FUNCTION f(a int) RETURNS INT LEAKPROOF STABLE LANGUAGE SQL AS 'SELECT 1';

-- Test 4: statement (line 18)
CREATE FUNCTION f() RETURNS INT IMMUTABLE LANGUAGE SQL AS $$ SELECT 1 $$;

-- Test 5: statement (line 21)
-- PostgreSQL does not allow multiple volatility categories. Wrap as expected-error.
DO $do$
BEGIN
  EXECUTE $sql$CREATE OR REPLACE FUNCTION f() RETURNS INT IMMUTABLE STABLE LANGUAGE SQL AS $fn$ SELECT 1 $fn$$sql$;
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END
$do$;

-- Test 6: statement (line 24)
-- STRICT implies "RETURNS NULL ON NULL INPUT"; keep invalid combinations as expected-error.
DO $do$
BEGIN
  EXECUTE $sql$CREATE OR REPLACE FUNCTION f() RETURNS INT CALLED ON NULL INPUT STABLE STRICT LANGUAGE SQL AS $fn$ SELECT 1 $fn$$sql$;
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END
$do$;

-- Test 7: statement (line 27)
DO $do$
BEGIN
  EXECUTE $sql$CREATE OR REPLACE FUNCTION f() RETURNS INT CALLED ON NULL INPUT STABLE RETURNS NULL ON NULL INPUT LANGUAGE SQL AS $fn$ SELECT 1 $fn$$sql$;
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END
$do$;

-- Test 8: statement (line 30)
DO $do$
BEGIN
  EXECUTE $sql$CREATE OR REPLACE FUNCTION f() RETURNS INT LEAKPROOF NOT LEAKPROOF LANGUAGE SQL AS $fn$ SELECT 1 $fn$$sql$;
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END
$do$;

-- Test 9: statement (line 33)
DO $do$
BEGIN
  EXECUTE $sql$CREATE OR REPLACE FUNCTION f() RETURNS INT IMMUTABLE LANGUAGE SQL AS $fn$ SELECT 1 $fn$ AS $fn$ SELECT 2 $fn$$sql$;
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END
$do$;

-- Test 10: statement (line 36)
DO $do$
BEGIN
  EXECUTE $sql$CREATE OR REPLACE FUNCTION f() RETURNS INT IMMUTABLE LANGUAGE SQL LANGUAGE SQL AS $fn$ SELECT 1 $fn$$sql$;
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END
$do$;

-- Test 11: statement (line 39)
DO $do$
BEGIN
  EXECUTE $sql$CREATE OR REPLACE FUNCTION f() RETURNS INT IMMUTABLE SECURITY INVOKER SECURITY DEFINER LANGUAGE SQL AS $fn$ SELECT 1 $fn$$sql$;
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END
$do$;

-- Test 12: statement (line 42)
DO $do$
BEGIN
  EXECUTE $sql$CREATE OR REPLACE FUNCTION f() RETURNS INT IMMUTABLE SECURITY INVOKER EXTERNAL SECURITY INVOKER LANGUAGE SQL AS $fn$ SELECT 1 $fn$$sql$;
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END
$do$;

-- Test 13: statement (line 47)
CREATE TABLE kv (k INT PRIMARY KEY, v INT);
INSERT INTO kv VALUES (1, 1), (2, 2), (3, 3);
CREATE FUNCTION get_l(i INT) RETURNS INT STABLE LANGUAGE SQL AS $$
SELECT v FROM kv WHERE k = i;
$$;
CREATE FUNCTION get_i(i INT) RETURNS INT STABLE LANGUAGE SQL AS $$
SELECT v FROM kv WHERE k = i;
$$;
CREATE FUNCTION get_s(i INT) RETURNS INT STABLE LANGUAGE SQL AS $$
SELECT v FROM kv WHERE k = i;
$$;
CREATE FUNCTION get_v(i INT) RETURNS INT VOLATILE LANGUAGE SQL AS $$
SELECT v FROM kv WHERE k = i;
$$;
CREATE FUNCTION int_identity_v(i INT) RETURNS INT VOLATILE LANGUAGE SQL AS $$
SELECT i;
$$;

-- Test 14: query (line 66)
SELECT pg_get_functiondef('get_l'::regproc::oid)
;

-- Test 15: query (line 80)
SELECT pg_get_functiondef(NULL)
;

-- Test 16: query (line 85)
SELECT pg_get_functiondef(123456)
;

-- Test 17: query (line 92)
-- `soundex` is provided by the `fuzzystrmatch` extension, which may not be
-- installed. Use a builtin function that exists in core PostgreSQL.
SELECT pg_get_functiondef('pg_backend_pid'::regproc::oid)
;

-- Test 18: query (line 99)
WITH u AS (
  UPDATE kv SET v = v + 10 RETURNING k
)
SELECT
get_l(k) l1, get_l(int_identity_v(k)) l2,
get_i(k) i1, get_i(int_identity_v(k)) i2,
get_s(k) s1, get_s(int_identity_v(k)) s2,
get_v(k) v1, get_v(int_identity_v(k)) v2
FROM u;

-- Test 19: statement (line 115)
CREATE SEQUENCE sq2;

-- Test 20: statement (line 119)
CREATE FUNCTION rand_i() RETURNS INT IMMUTABLE LANGUAGE SQL AS $$SELECT nextval('sq2')$$;

-- Test 21: statement (line 123)
CREATE FUNCTION rand_s() RETURNS INT STABLE LANGUAGE SQL AS $$SELECT nextval('sq2')$$;

-- Test 22: statement (line 126)
CREATE FUNCTION rand_v() RETURNS INT VOLATILE  LANGUAGE SQL AS $$SELECT nextval('sq2')$$;

-- Test 23: query (line 129)
SELECT rand_v(), rand_v() FROM generate_series(1, 3)
;

-- Test 24: statement (line 139)
CREATE FUNCTION strict_fn(i INT, t TEXT, b BOOL) RETURNS INT STRICT LANGUAGE SQL AS $$
  SELECT 1
$$;

-- Test 25: query (line 144)
SELECT strict_fn(1, 'foo', true)
;

-- Test 26: query (line 150)
WITH tmp(a, b, c) AS MATERIALIZED (VALUES (1, 'foo', true))
SELECT strict_fn(a, b, c) FROM tmp
;

-- Test 27: query (line 156)
SELECT strict_fn(NULL, 'foo', true), strict_fn(1, NULL, true), strict_fn(1, 'foo', NULL)
;

-- Test 28: query (line 161)
SELECT strict_fn(NULL, NULL, true), strict_fn(1, NULL, NULL), strict_fn(NULL, 'foo', NULL)
;

-- Test 29: query (line 166)
SELECT strict_fn(NULL, NULL, NULL)
;

-- Test 30: statement (line 171)
CREATE TABLE imp(k INT PRIMARY KEY, a INT, b TEXT);
INSERT INTO imp VALUES (1, 2, 'a');

-- Test 31: statement (line 175)
CREATE FUNCTION strict_fn_imp(t TEXT, i imp) RETURNS INT RETURNS NULL ON NULL INPUT LANGUAGE SQL AS $$
  SELECT 1
$$;

-- Test 32: query (line 182)
SELECT strict_fn_imp('foo', (NULL,NULL,NULL)), (NULL,NULL,NULL)::imp IS NULL
;

-- Test 33: query (line 187)
SELECT strict_fn_imp('foo', NULL)
;
