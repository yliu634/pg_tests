-- PostgreSQL compatible tests from udf_schema_change
-- 110 tests

SET client_min_messages = warning;

-- Cleanup for repeatability.
DROP FUNCTION IF EXISTS f_test_alter_opt(integer);
DROP FUNCTION IF EXISTS f_test_alter_name(integer);
DROP FUNCTION IF EXISTS f_test_alter_name_same_in(integer);
DROP FUNCTION IF EXISTS f_test_alter_name_diff_in();
DROP FUNCTION IF EXISTS f_test_alter_name_new(integer);
DROP FUNCTION IF EXISTS f_test_alter_name_diff_in(integer);
DROP PROCEDURE IF EXISTS p(integer);

DROP FUNCTION IF EXISTS f_test_sc();
DROP FUNCTION IF EXISTS f_test_sc(integer);
DROP FUNCTION IF EXISTS test_alter_sc.f_test_sc();
DROP SCHEMA IF EXISTS test_alter_sc CASCADE;

DROP FUNCTION IF EXISTS f_udt_rewrite();
DROP TYPE IF EXISTS notmyworkday CASCADE;

DROP SCHEMA IF EXISTS sc2 CASCADE;
DROP SCHEMA IF EXISTS sc1_new CASCADE;
DROP SCHEMA IF EXISTS sc1 CASCADE;

DROP FUNCTION IF EXISTS f();
DROP SCHEMA IF EXISTS sc CASCADE;

DROP FUNCTION IF EXISTS f_rtbl();
DROP TABLE IF EXISTS t_alter;

-- Test 1: statement (line 2)
CREATE TYPE notmyworkday AS ENUM ('Monday', 'Tuesday');

-- Test 2: statement (line 8)
CREATE FUNCTION f_test_alter_opt(i INT) RETURNS INT
LANGUAGE SQL AS $$ SELECT 1 $$;

-- Test 3: query (line 11)
SELECT pg_get_functiondef('f_test_alter_opt(integer)'::regprocedure) AS create_statement;

-- Test 4: statement (line 25)
ALTER FUNCTION f_test_alter_opt(integer) IMMUTABLE;

-- Test 5: statement (line 28)
-- LEAKPROOF changes require superuser in PostgreSQL.
\set ON_ERROR_STOP 0
ALTER FUNCTION f_test_alter_opt(integer) STABLE LEAKPROOF;
\set ON_ERROR_STOP 1

-- Test 6: statement (line 31)
\set ON_ERROR_STOP 0
ALTER FUNCTION f_test_alter_opt(integer) IMMUTABLE LEAKPROOF STRICT;
\set ON_ERROR_STOP 1

-- Ensure STRICT is set (this is allowed without superuser).
ALTER FUNCTION f_test_alter_opt(integer) STRICT;

-- Test 7: query (line 34)
SELECT pg_get_functiondef('f_test_alter_opt(integer)'::regprocedure) AS create_statement;

-- Test 8: statement (line 52)
CREATE FUNCTION f_test_alter_name(i INT) RETURNS INT LANGUAGE SQL AS $$ SELECT 1 $$;

-- Test 9: statement (line 55)
CREATE FUNCTION f_test_alter_name_same_in(i INT) RETURNS INT LANGUAGE SQL AS $$ SELECT 1 $$;

-- Test 10: statement (line 58)
CREATE FUNCTION f_test_alter_name_diff_in() RETURNS INT LANGUAGE SQL AS $$ SELECT 1 $$;

-- Test 11: statement (line 61)
CREATE PROCEDURE p(i INT) LANGUAGE SQL AS $$ SELECT 1; $$;

-- Test 12: query (line 64)
SELECT pg_get_functiondef('f_test_alter_name(integer)'::regprocedure) AS create_statement;

-- Test 13: statement (line 78)
-- PostgreSQL errors on "rename to same name".
\set ON_ERROR_STOP 0
ALTER FUNCTION f_test_alter_name(integer) RENAME TO f_test_alter_name;
\set ON_ERROR_STOP 1

-- Test 14: statement (line 81)
-- Expected ERROR (name/signature collision):
\set ON_ERROR_STOP 0
ALTER FUNCTION f_test_alter_name(integer) RENAME TO f_test_alter_name_same_in;
\set ON_ERROR_STOP 1

-- Test 15: statement (line 84)
-- Expected ERROR (procedure name - keep function namespace clean for later steps):
\set ON_ERROR_STOP 0
ALTER FUNCTION f_test_alter_name(integer) RENAME TO p;
\set ON_ERROR_STOP 1

-- Test 16: statement (line 87)
-- Expected ERROR (trying to ALTER PROCEDURE a function):
\set ON_ERROR_STOP 0
ALTER PROCEDURE f_test_alter_name(integer) RENAME TO f_test_alter_name_new;
\set ON_ERROR_STOP 1

-- Test 17: statement (line 90)
ALTER FUNCTION f_test_alter_name(integer) RENAME TO f_test_alter_name_new;

-- Test 18: statement (line 93)
-- Expected ERROR (old name no longer exists):
\set ON_ERROR_STOP 0
SELECT pg_get_functiondef('f_test_alter_name(integer)'::regprocedure) AS create_statement;
\set ON_ERROR_STOP 1

-- Test 19: query (line 96)
SELECT pg_get_functiondef('f_test_alter_name_new(integer)'::regprocedure) AS create_statement;

-- Test 20: statement (line 110)
ALTER FUNCTION f_test_alter_name_new(integer) RENAME TO f_test_alter_name_diff_in;

-- Test 21: statement (line 113)
-- Expected ERROR (name no longer exists after rename):
\set ON_ERROR_STOP 0
SELECT pg_get_functiondef('f_test_alter_name_new(integer)'::regprocedure) AS create_statement;
\set ON_ERROR_STOP 1

-- Test 22: query (line 116)
-- Both overloads: f_test_alter_name_diff_in() and f_test_alter_name_diff_in(integer).
SELECT pg_get_functiondef(p.oid) AS create_statement
FROM pg_proc AS p
JOIN pg_namespace AS n ON n.oid = p.pronamespace
WHERE p.proname = 'f_test_alter_name_diff_in'
  AND p.prokind = 'f'
  AND n.nspname = 'public'
ORDER BY 1;

-- Test 23: statement (line 140)
DROP PROCEDURE p(integer);

-- Test 24: statement (line 147)
CREATE FUNCTION f_test_sc() RETURNS INT LANGUAGE SQL AS $$ SELECT 1 $$;
CREATE FUNCTION f_test_sc(i INT) RETURNS INT LANGUAGE SQL AS $$ SELECT 2 $$;
CREATE SCHEMA test_alter_sc;
CREATE FUNCTION test_alter_sc.f_test_sc() RETURNS INT LANGUAGE SQL AS $$ SELECT 3 $$;

-- Test 25: query (line 174)
SELECT n.nspname AS schema, p.proname, pg_get_function_identity_arguments(p.oid) AS args
FROM pg_proc AS p
JOIN pg_namespace AS n ON n.oid = p.pronamespace
WHERE p.proname = 'f_test_sc' AND p.prokind = 'f'
ORDER BY schema, args;

-- Test 26: query (line 183)
-- CRDB internal descriptor queries are not available; use pg_proc/pg_namespace instead (above).

-- Test 27: statement (line 206)
-- Expected ERROR (moving into pg_catalog requires superuser):
\set ON_ERROR_STOP 0
ALTER FUNCTION f_test_sc() SET SCHEMA pg_catalog;
\set ON_ERROR_STOP 1

-- Test 28: statement (line 209)
-- Expected ERROR (conflicts with existing test_alter_sc.f_test_sc()):
\set ON_ERROR_STOP 0
ALTER FUNCTION f_test_sc() SET SCHEMA test_alter_sc;
\set ON_ERROR_STOP 1

-- Test 29: statement (line 212)
-- Expected ERROR (trying to ALTER PROCEDURE a function):
\set ON_ERROR_STOP 0
ALTER PROCEDURE f_test_sc(integer) SET SCHEMA test_alter_sc;
\set ON_ERROR_STOP 1

-- Test 30: statement (line 216)
ALTER FUNCTION f_test_sc(integer) SET SCHEMA test_alter_sc;

-- Test 31: query (line 219)
SELECT n.nspname AS schema, p.proname, pg_get_function_identity_arguments(p.oid) AS args
FROM pg_proc AS p
JOIN pg_namespace AS n ON n.oid = p.pronamespace
WHERE p.proname = 'f_test_sc' AND p.prokind = 'f'
ORDER BY schema, args;

-- Test 32: query (line 242)
SELECT pg_get_functiondef('public.f_test_sc()'::regprocedure) AS create_statement;

-- Test 33: statement (line 268)
-- Expected ERROR (function no longer in public after SET SCHEMA):
\set ON_ERROR_STOP 0
ALTER FUNCTION f_test_sc(integer) SET SCHEMA test_alter_sc;
\set ON_ERROR_STOP 1

-- Test 34: query (line 271)
SELECT pg_get_functiondef('test_alter_sc.f_test_sc(integer)'::regprocedure) AS create_statement;

-- Test 35: query (line 294)
SELECT pg_get_functiondef('test_alter_sc.f_test_sc()'::regprocedure) AS create_statement;

-- Test 36: query (line 308)
SELECT pg_get_functiondef('test_alter_sc.f_test_sc()'::regprocedure) AS create_statement;

-- Test 37: statement (line 337)
-- Use plpgsql + implicit cast so the function survives enum type renames.
CREATE FUNCTION f_udt_rewrite() RETURNS notmyworkday
LANGUAGE plpgsql AS $$
BEGIN
  RETURN 'Monday';
END
$$;

-- Test 38: query (line 340)
SELECT pg_get_functiondef('f_udt_rewrite()'::regprocedure) AS create_statement;

-- Test 39: query (line 354)
SELECT f_udt_rewrite();

-- Test 40: statement (line 359)
ALTER TYPE notmyworkday RENAME TO notmyworkday_new;

-- Test 41: query (line 362)
SELECT f_udt_rewrite();

-- Test 42: statement (line 367)
ALTER TYPE notmyworkday_new RENAME TO notmyworkday;

-- Test 43: query (line 370)
SELECT f_udt_rewrite();

-- Database rename sections from CRDB are not representable in PG-within-a-single-DB harness.
-- Instead, exercise schema/type/table/sequence renames which are supported in PostgreSQL.

-- Test 44+: schema rename with objects referenced by functions.
CREATE SCHEMA sc1;
CREATE SCHEMA sc2;
CREATE TYPE sc1.workday AS ENUM ('Mon');
CREATE FUNCTION sc1.f_type() RETURNS sc1.workday
LANGUAGE plpgsql AS $$
BEGIN
  RETURN 'Mon';
END
$$;

CREATE FUNCTION sc2.f_type() RETURNS sc1.workday
LANGUAGE plpgsql AS $$
BEGIN
  RETURN 'Mon';
END
$$;

-- Before rename.
SELECT sc1.f_type();
SELECT sc2.f_type();

-- Rename schema sc1 -> sc1_new (moves the type, table, sequence, and functions in sc1).
ALTER SCHEMA sc1 RENAME TO sc1_new;

-- Expected ERROR (old schema name no longer exists):
\set ON_ERROR_STOP 0
SELECT sc1.f_type();
\set ON_ERROR_STOP 1

-- After rename.
SELECT sc1_new.f_type();
SELECT sc2.f_type();

-- Composite return type changes.
CREATE TABLE t_alter (
  a INT PRIMARY KEY,
  b TEXT,
  c INT
);

CREATE FUNCTION f_rtbl() RETURNS t_alter LANGUAGE SQL AS $$
  SELECT 1, 'foobar', 2
$$;

SELECT f_rtbl();

-- Drop a column from the table type; the function's result no longer matches.
ALTER TABLE t_alter DROP COLUMN c;
\set ON_ERROR_STOP 0
SELECT f_rtbl();
\set ON_ERROR_STOP 1

-- Restore the column and verify the function works again.
ALTER TABLE t_alter ADD COLUMN c INT;
SELECT f_rtbl();

-- Add a new column; a 3-column function cannot return the 4-column row type.
ALTER TABLE t_alter ADD COLUMN d INT;
\set ON_ERROR_STOP 0
CREATE OR REPLACE FUNCTION f_rtbl() RETURNS t_alter LANGUAGE SQL AS $$
  SELECT 1, 'foobar', 2
$$;
\set ON_ERROR_STOP 1

CREATE OR REPLACE FUNCTION f_rtbl() RETURNS t_alter LANGUAGE SQL AS $$
  SELECT 1, 'foobar', 2, 3
$$;

SELECT f_rtbl();

RESET client_min_messages;
