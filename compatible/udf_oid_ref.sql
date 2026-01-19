-- PostgreSQL compatible tests from udf_oid_ref
-- 26 tests

-- Test 1: query (line 4)
SELECT [FUNCTION 1074]('hello,world', ',')

-- Test 2: statement (line 12)
INSERT INTO t1(a) VALUES (1)

-- Test 3: query (line 15)
SELECT * FROM t1

-- Test 4: statement (line 20)
INSERT INTO t1 VALUES (2, 'hello,new,world')

-- Test 5: statement (line 23)
CREATE INDEX idx ON t1([FUNCTION 1074](b,','))

-- Test 6: query (line 26)
SELECT * FROM t1@idx WHERE [FUNCTION 1074](b, ',') = ARRAY['hello','new','world']

-- Test 7: statement (line 33)
ALTER TABLE t1 ADD CONSTRAINT c_len CHECK ([FUNCTION 814](b) > 2)

-- Test 8: statement (line 36)
INSERT INTO t1 VALUES (3, 'a')

-- Test 9: statement (line 39)
CREATE FUNCTION f1() RETURNS INT LANGUAGE SQL AS $$ SELECT 1 $$

let $fn_oid
SELECT oid FROM pg_catalog.pg_proc WHERE proname = 'f1'

-- Test 10: query (line 45)
SELECT [FUNCTION $fn_oid]()

-- Test 11: query (line 56)
SELECT [FUNCTION $fn_oid]('hello world')

-- Test 12: statement (line 63)
SELECT [FUNCTION $fn_oid](123)

-- Test 13: query (line 70)
SELECT [FUNCTION $fn_oid]('hello world')

-- Test 14: statement (line 75)
CREATE SCHEMA sc1;

-- Test 15: query (line 81)
SELECT [FUNCTION $fn_oid]('hello world')

-- Test 16: statement (line 90)
SELECT [FUNCTION $fn_oid]('maybe')

-- Test 17: statement (line 95)
CREATE FUNCTION f_in_udf() RETURNS INT LANGUAGE SQL AS $$ SELECT 1 $$;

let $fn_oid
SELECT oid FROM pg_catalog.pg_proc WHERE proname = 'f_in_udf'

-- Test 18: statement (line 101)
CREATE FUNCTION f_using_udf() RETURNS INT LANGUAGE SQL AS $$ SELECT [FUNCTION $fn_oid]() $$;

-- Test 19: query (line 104)
SELECT f_using_udf()

-- Test 20: statement (line 111)
CREATE FUNCTION f_using_udf_2() RETURNS INT LANGUAGE SQL AS $$ SELECT [FUNCTION 814]('abc') $$;

-- Test 21: query (line 114)
SELECT f_using_udf_2();

-- Test 22: statement (line 121)
CREATE DATABASE db1

-- Test 23: statement (line 124)
USE db1

-- Test 24: statement (line 127)
CREATE FUNCTION f_cross_db() RETURNS INT LANGUAGE SQL AS $$ SELECT 321 $$;

let $fn_oid
SELECT oid FROM pg_catalog.pg_proc WHERE proname = 'f_cross_db'

-- Test 25: statement (line 133)
USE test

-- Test 26: query (line 136)
SELECT [FUNCTION $fn_oid]()

