-- PostgreSQL compatible tests from udf_schema_change
-- 110 tests

-- Test 1: statement (line 2)
CREATE TYPE notmyworkday AS ENUM ('Monday', 'Tuesday');

-- Test 2: statement (line 8)
CREATE FUNCTION f_test_alter_opt(INT) RETURNS INT LANGUAGE SQL AS $$ SELECT 1 $$;

-- Test 3: query (line 11)
SELECT create_statement FROM [SHOW CREATE FUNCTION f_test_alter_opt];

-- Test 4: statement (line 25)
ALTER FUNCTION f_test_alter_opt IMMUTABLE IMMUTABLE

-- Test 5: statement (line 28)
ALTER FUNCTION f_test_alter_opt STABLE LEAKPROOF

-- Test 6: statement (line 31)
ALTER FUNCTION f_test_alter_opt IMMUTABLE LEAKPROOF STRICT;

-- Test 7: query (line 34)
SELECT create_statement FROM [SHOW CREATE FUNCTION f_test_alter_opt];

-- Test 8: statement (line 52)
CREATE FUNCTION f_test_alter_name(INT) RETURNS INT LANGUAGE SQL AS $$ SELECT 1 $$;

-- Test 9: statement (line 55)
CREATE FUNCTION f_test_alter_name_same_in(INT) RETURNS INT LANGUAGE SQL AS $$ SELECT 1 $$;

-- Test 10: statement (line 58)
CREATE FUNCTION f_test_alter_name_diff_in() RETURNS INT LANGUAGE SQL AS $$ SELECT 1 $$;

-- Test 11: statement (line 61)
CREATE PROCEDURE p(INT) LANGUAGE SQL AS 'SELECT 1'

-- Test 12: query (line 64)
SELECT create_statement FROM [SHOW CREATE FUNCTION f_test_alter_name];

-- Test 13: statement (line 78)
ALTER FUNCTION f_test_alter_name RENAME TO f_test_alter_name

-- Test 14: statement (line 81)
ALTER FUNCTION f_test_alter_name RENAME TO f_test_alter_name_same_in

-- Test 15: statement (line 84)
ALTER FUNCTION f_test_alter_name RENAME TO p

-- Test 16: statement (line 87)
ALTER PROCEDURE f_test_alter_name RENAME TO f_test_alter_name_new

-- Test 17: statement (line 90)
ALTER FUNCTION f_test_alter_name RENAME TO f_test_alter_name_new

-- Test 18: statement (line 93)
SELECT create_statement FROM [SHOW CREATE FUNCTION f_test_alter_name];

-- Test 19: query (line 96)
SELECT create_statement FROM [SHOW CREATE FUNCTION f_test_alter_name_new];

-- Test 20: statement (line 110)
ALTER FUNCTION f_test_alter_name_new RENAME to f_test_alter_name_diff_in

-- Test 21: statement (line 113)
SELECT create_statement FROM [SHOW CREATE FUNCTION f_test_alter_name_new];

-- Test 22: query (line 116)
SELECT create_statement FROM [SHOW CREATE FUNCTION f_test_alter_name_diff_in] ORDER BY 1

-- Test 23: statement (line 140)
DROP PROCEDURE p

-- Test 24: statement (line 147)
CREATE FUNCTION f_test_sc() RETURNS INT LANGUAGE SQL AS $$ SELECT 1 $$;
CREATE FUNCTION f_test_sc(INT) RETURNS INT LANGUAGE SQL AS $$ SELECT 2 $$;
CREATE SCHEMA test_alter_sc;
CREATE FUNCTION test_alter_sc.f_test_sc() RETURNS INT LANGUAGE SQL AS $$ SELECT 3 $$;

-- Test 25: query (line 174)
SELECT oid, proname, prosrc
FROM pg_catalog.pg_proc WHERE proname IN ('f_test_sc')
ORDER BY oid

-- Test 26: query (line 183)
WITH fns AS (
            SELECT crdb_internal.pb_to_json(
                    'cockroach.sql.sqlbase.Descriptor',
                    descriptor,
                    false
                   )->'function' AS fn
              FROM system.descriptor
             WHERE id
                   IN (
                        $public_f_test_sc,
                        $public_f_test_sc_int,
                        $test_alter_sc_f_test_sc
                    )
           )
SELECT fn->>'id' AS id, fn->'parentSchemaId'
  FROM fns
  ORDER BY id;

-- Test 27: statement (line 206)
ALTER FUNCTION f_test_sc() SET SCHEMA pg_catalog;

-- Test 28: statement (line 209)
ALTER FUNCTION f_test_sc() SET SCHEMA test_alter_sc;

-- Test 29: statement (line 212)
ALTER PROCEDURE f_test_sc(INT) SET SCHEMA test_alter_sc;

-- Test 30: statement (line 216)
ALTER FUNCTION f_test_sc(INT) SET SCHEMA public;

-- Test 31: query (line 219)
WITH fns AS (
            SELECT crdb_internal.pb_to_json(
                    'cockroach.sql.sqlbase.Descriptor',
                    descriptor,
                    false
                   )->'function' AS fn
              FROM system.descriptor
             WHERE id
                   IN (
                        $public_f_test_sc,
                        $public_f_test_sc_int,
                        $test_alter_sc_f_test_sc
                    )
           )
SELECT fn->>'id' AS id, fn->'parentSchemaId'
  FROM fns
  ORDER BY id;

-- Test 32: query (line 242)
SELECT create_statement FROM [SHOW CREATE FUNCTION public.f_test_sc] ORDER BY 1

-- Test 33: statement (line 268)
ALTER FUNCTION f_test_sc(INT) SET SCHEMA test_alter_sc;

-- Test 34: query (line 271)
WITH fns AS (
            SELECT crdb_internal.pb_to_json(
                    'cockroach.sql.sqlbase.Descriptor',
                    descriptor,
                    false
                   )->'function' AS fn
              FROM system.descriptor
             WHERE id
                   IN (
                        $public_f_test_sc,
                        $public_f_test_sc_int,
                        $test_alter_sc_f_test_sc
                    )
           )
SELECT fn->>'id' AS id, fn->'parentSchemaId'
  FROM fns
  ORDER BY id;

-- Test 35: query (line 294)
SELECT create_statement FROM [SHOW CREATE FUNCTION public.f_test_sc];

-- Test 36: query (line 308)
SELECT create_statement FROM [SHOW CREATE FUNCTION test_alter_sc.f_test_sc] ORDER BY 1

-- Test 37: statement (line 337)
CREATE FUNCTION f_udt_rewrite() RETURNS notmyworkday LANGUAGE SQL AS $$ SELECT 'Monday':: notmyworkday $$;

-- Test 38: query (line 340)
SELECT create_statement FROM [SHOW CREATE FUNCTION f_udt_rewrite];

-- Test 39: query (line 354)
SELECT f_udt_rewrite()

-- Test 40: statement (line 359)
ALTER TYPE notmyworkday RENAME TO notmyworkday_new;

-- Test 41: query (line 362)
SELECT f_udt_rewrite()

-- Test 42: statement (line 367)
ALTER TYPE notmyworkday_new RENAME TO notmyworkday;

-- Test 43: query (line 370)
SELECT f_udt_rewrite()

-- Test 44: statement (line 380)
CREATE DATABASE rename_db1;
SET DATABASE = rename_db1;

-- Test 45: statement (line 384)
CREATE SCHEMA sc1;
CREATE SCHEMA sc2;
CREATE TYPE sc1.workday AS ENUM ('Mon');
CREATE TABLE sc1.tbl(a INT PRIMARY KEY);
CREATE SEQUENCE sc1.sq;

-- Test 46: statement (line 391)
CREATE FUNCTION sc1.f_tbl() RETURNS INT LANGUAGE SQL AS $$ SELECT a FROM sc1.tbl $$;
CREATE FUNCTION sc1.f_type() RETURNS sc1.workday LANGUAGE SQL AS $$ SELECT 'Mon'::sc1.workday $$;
CREATE FUNCTION sc1.f_seq() RETURNS INT LANGUAGE SQL AS $$ SELECT nextval('sc1.sq') $$;
CREATE FUNCTION sc2.f_tbl() RETURNS INT LANGUAGE SQL AS $$ SELECT a FROM sc1.tbl $$;
CREATE FUNCTION sc2.f_type() RETURNS sc1.workday LANGUAGE SQL AS $$ SELECT 'Mon'::sc1.workday $$;
CREATE FUNCTION sc2.f_seq() RETURNS INT LANGUAGE SQL AS $$ SELECT nextval('sc1.sq') $$;

-- Test 47: query (line 399)
SELECT sc1.f_type()

-- Test 48: query (line 404)
SELECT sc1.f_seq()

-- Test 49: query (line 409)
SELECT sc2.f_type()

-- Test 50: query (line 414)
SELECT sc2.f_seq()

-- Test 51: statement (line 419)
ALTER DATABASE rename_db1 RENAME TO rename_db2;

-- Test 52: statement (line 422)
DROP FUNCTION sc1.f_tbl()

-- Test 53: statement (line 425)
ALTER DATABASE rename_db1 RENAME TO rename_db2;

-- Test 54: statement (line 428)
DROP FUNCTION sc2.f_tbl()

-- Test 55: statement (line 431)
ALTER DATABASE rename_db1 RENAME TO rename_db2;
USE rename_db2;

-- Test 56: query (line 436)
SELECT sc1.f_type()

-- Test 57: query (line 441)
SELECT sc1.f_seq()

-- Test 58: query (line 446)
SELECT sc2.f_type()

-- Test 59: query (line 451)
SELECT sc2.f_seq()

-- Test 60: statement (line 456)
SET DATABASE = test

-- Test 61: statement (line 459)
CREATE DATABASE rename_sc1;
SET DATABASE = rename_sc1;

-- Test 62: statement (line 463)
CREATE SCHEMA sc1;
CREATE SCHEMA sc2;
CREATE TYPE sc1.workday AS ENUM ('Mon');
CREATE TABLE sc1.tbl(a INT PRIMARY KEY);
CREATE SEQUENCE sc1.sq;

-- Test 63: statement (line 470)
CREATE FUNCTION sc1.f_tbl() RETURNS INT LANGUAGE SQL AS $$ SELECT a FROM sc1.tbl $$;
CREATE FUNCTION sc1.f_type() RETURNS sc1.workday LANGUAGE SQL AS $$ SELECT 'Mon'::sc1.workday $$;
CREATE FUNCTION sc1.f_seq() RETURNS INT LANGUAGE SQL AS $$ SELECT nextval('sc1.sq') $$;
CREATE FUNCTION sc2.f_tbl() RETURNS INT LANGUAGE SQL AS $$ SELECT a FROM sc1.tbl $$;
CREATE FUNCTION sc2.f_type() RETURNS sc1.workday LANGUAGE SQL AS $$ SELECT 'Mon'::sc1.workday $$;
CREATE FUNCTION sc2.f_seq() RETURNS INT LANGUAGE SQL AS $$ SELECT nextval('sc1.sq') $$;

-- Test 64: query (line 478)
SELECT sc1.f_type()

-- Test 65: query (line 483)
SELECT sc1.f_seq()

-- Test 66: query (line 488)
SELECT sc2.f_type()

-- Test 67: query (line 493)
SELECT sc2.f_seq()

-- Test 68: statement (line 498)
ALTER SCHEMA sc1 RENAME TO sc1_new

-- Test 69: statement (line 501)
DROP FUNCTION sc1.f_tbl()

-- Test 70: statement (line 504)
ALTER SCHEMA sc1 RENAME TO sc1_new

-- Test 71: statement (line 507)
DROP FUNCTION sc2.f_tbl()

-- Test 72: statement (line 510)
ALTER SCHEMA sc1 RENAME TO sc1_new

-- Test 73: statement (line 514)
SELECT sc1.f_type()

-- Test 74: statement (line 517)
SELECT sc1.f_seq()

-- Test 75: query (line 521)
SELECT sc1_new.f_type()

-- Test 76: query (line 526)
SELECT sc1_new.f_seq()

-- Test 77: query (line 531)
SELECT sc2.f_type()

-- Test 78: query (line 536)
SELECT sc2.f_seq()

-- Test 79: statement (line 541)
SET DATABASE = test

-- Test 80: statement (line 549)
CREATE DATABASE tdb_seq_select;
SET DATABASE = tdb_seq_select;

-- Test 81: statement (line 553)
CREATE SCHEMA sc;
CREATE SEQUENCE sc.sq;
CREATE FUNCTION f() RETURNS INT LANGUAGE SQL AS $$ SELECT last_value FROM sc.sq $$;

-- Test 82: query (line 558)
SELECT f()

-- Test 83: statement (line 563)
ALTER SEQUENCE sc.sq RENAME TO sq_new;

-- Test 84: statement (line 566)
SELECT f()

-- Test 85: statement (line 569)
ALTER SEQUENCE sc.sq_new RENAME TO sq;
SELECT f();

-- Test 86: statement (line 573)
ALTER SCHEMA sc RENAME TO sc_new;

-- Test 87: statement (line 576)
SELECT f()

-- Test 88: statement (line 579)
ALTER SCHEMA sc_new RENAME TO sc;
SELECT f()

-- Test 89: statement (line 583)
ALTER DATABASE tdb_seq_select RENAME TO tdb_seq_select_new;
SET DATABASE = tdb_seq_select_new;

-- Test 90: statement (line 587)
SELECT f()

-- Test 91: statement (line 590)
ALTER DATABASE tdb_seq_select_new RENAME TO tdb_seq_select;
SET DATABASE = tdb_seq_select;
SELECT f()

-- Test 92: statement (line 595)
SET DATABASE = test;

-- Test 93: statement (line 603)
CREATE TABLE t_alter (
  a INT PRIMARY KEY,
  b TEXT,
  c INT
)

-- Test 94: statement (line 610)
CREATE FUNCTION f_rtbl() RETURNS t_alter LANGUAGE SQL AS $$
  SELECT 1, 'foobar', 2
$$

-- Test 95: query (line 615)
SELECT f_rtbl();

-- Test 96: statement (line 620)
ALTER TABLE t_alter DROP COLUMN c;

-- Test 97: statement (line 623)
SELECT f_rtbl();

-- Test 98: statement (line 626)
ALTER TABLE t_alter ADD COLUMN c INT;

-- Test 99: query (line 629)
SELECT f_rtbl();

-- Test 100: statement (line 642)
ALTER TABLE t_alter ALTER c TYPE FLOAT;

skipif config local-legacy-schema-changer

-- Test 101: statement (line 646)
SELECT f_rtbl();

-- Test 102: statement (line 649)
ALTER TABLE t_alter ALTER c TYPE INT;

-- Test 103: query (line 652)
SELECT f_rtbl();

-- Test 104: statement (line 658)
ALTER TABLE t_alter ALTER b TYPE CHAR(3)

skipif config local-legacy-schema-changer

-- Test 105: statement (line 662)
SELECT f_rtbl();

skipif config local-legacy-schema-changer

-- Test 106: statement (line 666)
ALTER TABLE t_alter ALTER b TYPE TEXT

-- Test 107: statement (line 669)
ALTER TABLE t_alter ADD COLUMN d INT;

-- Test 108: statement (line 672)
CREATE OR REPLACE FUNCTION f_rtbl() RETURNS t_alter LANGUAGE SQL AS $$
  SELECT 1, 'foobar', 2
$$

-- Test 109: statement (line 677)
CREATE OR REPLACE FUNCTION f_rtbl() RETURNS t_alter LANGUAGE SQL AS $$
  SELECT 1, 'foobar', 2, 3
$$

-- Test 110: query (line 682)
SELECT f_rtbl();

