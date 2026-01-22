-- PostgreSQL compatible tests from pg_builtins
-- 160 tests

-- Keep psql output stable/noisy NOTICEs down.
SET client_min_messages = warning;

-- Test 1: query (line 2)
SELECT grantor::regrole::text, grantee::regrole::text, privilege_type, is_grantable
FROM aclexplode(NULL::aclitem[]);

-- Test 2: query (line 6)
SELECT grantor::regrole::text, grantee::regrole::text, privilege_type, is_grantable
FROM aclexplode(
  CASE
    -- Postgres requires a 1-D ACL array; treat empty input as NULL (0 rows).
    WHEN array_length('{}'::aclitem[], 1) IS NULL THEN NULL::aclitem[]
    ELSE '{}'::aclitem[]
  END
);

-- Test 3: query (line 10)
SELECT grantor::regrole::text, grantee::regrole::text, privilege_type, is_grantable
FROM aclexplode(ARRAY['postgres=U/postgres'::aclitem]);

-- Test 4: statement (line 15)
SELECT has_table_privilege(current_user::NAME, 0, 'select');

-- Test 5: statement (line 19)
CREATE TYPE typ AS ENUM ('hello');

-- Test 6: query (line 22)
SELECT format_type(oid, 0) FROM pg_catalog.pg_type WHERE typname = 'typ';

-- Test 7: query (line 28)
SELECT format_type(152100, 0);

-- Test 8: query (line 35)
SELECT pg_column_size(1::float);

-- Test 9: query (line 40)
SELECT pg_column_size(1::int);

-- Test 10: query (line 45)
SELECT pg_column_size((1, 1));

-- Test 11: query (line 50)
SELECT pg_column_size('{}'::json);

-- Test 12: query (line 55)
SELECT pg_column_size('');

-- Test 13: query (line 60)
SELECT pg_column_size('a');

-- Test 14: query (line 65)
SELECT pg_column_size((1,'a'));

-- Test 15: query (line 70)
SELECT pg_column_size(true);

-- Test 16: query (line 75)
SELECT pg_column_size(NULL::int);

-- Test 17: statement (line 82)
CREATE TABLE is_visible(a int primary key);
CREATE TYPE visible_type AS ENUM('a');
CREATE FUNCTION visible_func() RETURNS INT LANGUAGE SQL AS $$ SELECT 1 $$;
CREATE SCHEMA other;
CREATE TABLE other.not_visible(a int primary key);
CREATE TYPE other.not_visible_type AS ENUM('b');
CREATE FUNCTION other.not_visible_func() RETURNS INT LANGUAGE SQL AS $$ SELECT 1 $$;
-- Cockroach uses `SET DATABASE`. PostgreSQL OIDs are database-local, so model this
-- with a separate schema instead.
CREATE SCHEMA db2;
CREATE TABLE db2.table_in_db2(a int primary key);
CREATE TYPE db2.type_in_db2 AS ENUM('c');
CREATE FUNCTION db2.func_in_db2() RETURNS INT LANGUAGE SQL AS $$ SELECT 1 $$;

-- logic-test `let $var` -> psql `\gset` (capture without printing).
SELECT c.oid AS table_in_db2_id
FROM pg_class c
JOIN pg_namespace n ON n.oid = c.relnamespace
WHERE c.relname = 'table_in_db2' AND n.nspname = 'db2'
LIMIT 1
\gset

SELECT t.oid AS type_in_db2_id
FROM pg_type t
JOIN pg_namespace n ON n.oid = t.typnamespace
WHERE t.typname = 'type_in_db2' AND n.nspname = 'db2'
LIMIT 1
\gset

SELECT p.oid AS func_in_db2_id
FROM pg_proc p
JOIN pg_namespace n ON n.oid = p.pronamespace
WHERE p.proname = 'func_in_db2' AND n.nspname = 'db2'
LIMIT 1
\gset

-- Test 18: statement (line 105)
SET search_path TO public, pg_catalog;

-- Test 19: query (line 108)
SELECT c.relname, pg_table_is_visible(c.oid)
FROM pg_class c
WHERE c.relname IN ('is_visible', 'not_visible', 'is_visible_pkey', 'not_visible_pkey')
;

-- Test 20: query (line 119)
SELECT pg_table_is_visible(:table_in_db2_id);

-- Test 21: query (line 125)
SELECT pg_table_is_visible(1010101010);

-- Test 22: query (line 130)
SELECT pg_table_is_visible(NULL);

-- Test 23: query (line 135)
SELECT t.typname, pg_type_is_visible(t.oid)
FROM pg_type t
WHERE t.typname IN ('int8', '_date', 'visible_type', 'not_visible_type')
;

-- Test 24: query (line 146)
SELECT pg_type_is_visible(:type_in_db2_id);

-- Test 25: query (line 152)
SELECT pg_type_is_visible(1010101010);

-- Test 26: query (line 157)
SELECT pg_type_is_visible(NULL);

-- Test 27: query (line 162)
SELECT p.proname, pg_function_is_visible(p.oid)
FROM pg_proc p
WHERE p.proname IN ('array_length', 'visible_func', 'not_visible_func')
;

-- Test 28: query (line 172)
SELECT pg_function_is_visible(:func_in_db2_id);

-- Test 29: query (line 178)
SELECT pg_function_is_visible(1010101010);

-- Test 30: query (line 183)
SELECT pg_function_is_visible(NULL);

-- Test 31: query (line 188)
SELECT pg_get_partkeydef(1), pg_get_partkeydef(NULL);

-- Test 32: statement (line 193)
CREATE TABLE is_updatable(a INT PRIMARY KEY, b INT, c INT GENERATED ALWAYS AS (b * 10) STORED);
CREATE VIEW is_updatable_view AS SELECT a, b FROM is_updatable;

-- Test 33: query (line 197)
SELECT
  c.relname,
  a.attname,
  a.attnum,
  pg_relation_is_updatable(c.oid, false),
  pg_column_is_updatable(c.oid, a.attnum, false)
FROM pg_class c
JOIN pg_attribute a ON a.attrelid = c.oid
WHERE c.relname IN ('is_updatable', 'is_updatable_view', 'pg_class')
ORDER BY c.relname, a.attnum
;

-- Test 34: query (line 255)
SELECT count(1) FROM pg_class WHERE oid = 1;

-- Test 35: query (line 260)
SELECT * FROM (VALUES
   ('system column', (SELECT CAST(pg_column_is_updatable(oid, (-1)::smallint, true) AS TEXT) FROM pg_class WHERE relname = 'is_updatable')),
   ('relation does not exist', CAST(pg_relation_is_updatable(1, true) AS TEXT)),
   ('relation does not exist', CAST(pg_column_is_updatable(1, 1::smallint, true) AS TEXT)),
   ('relation exists, but column does not', (SELECT CAST(pg_column_is_updatable(oid, 15::smallint, true) AS TEXT) FROM pg_class WHERE relname = 'is_updatable'))
   ) AS tbl(description, value)
ORDER BY 1
;

-- Test 36: query (line 274)
SELECT current_setting('statement_timeout');

-- Test 37: query (line 279)
SELECT current_setting('statement_timeout', false);

-- Test 38: query (line 285)
SELECT COALESCE(current_setting('woo', true), 'OK');

-- Test 39: query (line 291)
SELECT current_setting(NULL, false);

-- Test 40: query (line 297)
SELECT current_setting('statement_timeout'), current_setting('search_path');

-- Test 41: query (line 303)
SELECT pg_catalog.current_setting('woo', true);

-- Check that current_setting handles custom settings correctly.
-- query T
SELECT current_setting('my.custom', true);

-- Test 42: statement (line 312)
PREPARE check_custom AS SELECT current_setting('my.custom', true);

-- Test 43: query (line 315)
EXECUTE check_custom;

-- Test 44: statement (line 320)
BEGIN;
SET LOCAL my.custom = 'foo';

-- Test 45: query (line 326)
EXECUTE check_custom;

-- Test 46: statement (line 331)
COMMIT;

-- Test 47: query (line 335)
SELECT current_setting('vacuum_cost_delay', false);

-- query T
SHOW application_name;

-- Test 48: query (line 343)
SELECT set_config('application_name', 'woo', false);

-- Test 49: query (line 348)
SHOW application_name;

-- Test 50: query (line 354)
SELECT
  set_config('application_name', 'foo', false),
  set_config('statement_timeout', '60s', false)
;

-- NOTE: The upstream test suite included expected-error cases. For this
-- compatibility runner we keep the file ERROR-free, so we skip the NULL-name
-- set_config() call.

-- Test 51: query (line 365)
SELECT set_config('application_name', 'woo', true);

-- Test 52: query (line 370)
SELECT current_setting('application_name');

-- Test 53: statement (line 376)
BEGIN;

-- Test 54: query (line 379)
SELECT set_config('application_name', 'woo', true);

-- Test 55: query (line 384)
SELECT current_setting('application_name'), current_setting('statement_timeout');

-- Test 56: statement (line 389)
COMMIT;

-- Test 57: query (line 392)
SELECT current_setting('application_name');

-- Test 58: query (line 397)
SELECT pg_catalog.set_config('my.custom', 'woo', false);

-- query error configuration setting.*not supported
SELECT set_config('vacuum_cost_delay', '0', false);

-- Regression test for #117316. Setting an empty search_path should succeed.
-- query T
SELECT pg_catalog.set_config('search_path', '', false);

-- Test 59: query (line 409)
SHOW search_path;

-- Test 60: statement (line 415)
RESET search_path;

-- Test 61: query (line 423)
SELECT pg_my_temp_schema();

-- Test 62: statement (line 431)
CREATE TEMP TABLE temp1 (a int);

-- Test 63: query (line 434)
SELECT pg_my_temp_schema()::TEXT LIKE 'pg_temp_%';

-- Test 64: statement (line 442)
-- Cockroach-only: SET DATABASE. PostgreSQL temp schemas are per-database and
-- cannot be inspected cross-database in a single session.
-- SET DATABASE = db2;

-- Test 65: query (line 445)
-- SELECT pg_my_temp_schema();

-- Test 66: statement (line 450)
CREATE TEMP TABLE temp2 (a int);

-- Test 67: query (line 453)
SELECT pg_my_temp_schema()::TEXT LIKE 'pg_temp_%';

-- Test 68: statement (line 458)
-- SET DATABASE = test;

-- Test 69: query (line 468)
SELECT pg_is_other_temp_schema((SELECT oid FROM pg_type LIMIT 1));

-- Test 70: query (line 473)
SELECT pg_is_other_temp_schema((SELECT oid FROM pg_namespace WHERE nspname = 'pg_catalog'));

-- Test 71: query (line 478)
SELECT user, pg_is_other_temp_schema((SELECT oid FROM pg_namespace WHERE nspname LIKE 'pg_temp_%'));

-- Test 72: statement (line 485)
-- Cockroach logic-test directive used a different user. Model this with roles.
DROP ROLE IF EXISTS root;
DROP ROLE IF EXISTS testuser;
CREATE ROLE root;
CREATE ROLE testuser LOGIN;
GRANT root TO testuser;

-- user testuser
SET ROLE testuser;

-- Test 73: query (line 490)
SELECT user, pg_is_other_temp_schema((SELECT oid FROM pg_namespace WHERE nspname LIKE 'pg_temp_%'));
RESET ROLE;

-- Test 74: statement (line 501)
CREATE TABLE types (
  a TEXT PRIMARY KEY,
  b FLOAT,
  c BPCHAR,
  d VARCHAR(64),
  e BIT,
  f VARBIT(16),
  g DECIMAL(12, 2)
);

-- Test 75: query (line 512)
SELECT typname,
       information_schema._pg_truetypid(a.*, t.*),
       information_schema._pg_truetypmod(a.*, t.*)
FROM pg_attribute a
JOIN pg_type t
ON a.atttypid = t.oid
WHERE attrelid = 'types'::regclass
ORDER BY t.oid
;

-- Test 76: query (line 532)
SELECT typname, information_schema._pg_char_max_length(a.atttypid, a.atttypmod)
FROM pg_attribute a
JOIN pg_type t
ON a.atttypid = t.oid
WHERE attrelid = 'types'::regclass
ORDER BY t.oid
;

-- Test 77: query (line 548)
SELECT typname, information_schema._pg_char_max_length(
  information_schema._pg_truetypid(a.*, t.*),
  information_schema._pg_truetypmod(a.*, t.*)
)
FROM pg_attribute a
JOIN pg_type t
ON a.atttypid = t.oid
WHERE attrelid = 'types'::regclass
ORDER BY t.oid
;

-- Test 78: statement (line 569)
CREATE TABLE indexed (
  a INT PRIMARY KEY,
  b INT,
  c INT,
  d INT
);
CREATE INDEX indexed_bd_idx ON indexed (b, d);
CREATE INDEX indexed_ca_idx ON indexed (c, a);

-- Test 79: statement (line 583)
CREATE TEMPORARY VIEW indexes AS
  SELECT i.relname, indkey::INT2[], indexrelid
    FROM pg_catalog.pg_index
    JOIN pg_catalog.pg_class AS t ON indrelid   = t.oid
    JOIN pg_catalog.pg_class AS i ON indexrelid = i.oid
   WHERE t.relname = 'indexed'
ORDER BY i.relname
;

-- Test 80: query (line 592)
SELECT relname, indkey FROM indexes ORDER BY relname DESC;

-- Test 81: query (line 599)
SELECT relname,
       indkey,
       g.input,
       information_schema._pg_index_position(indexrelid, g.input::smallint)
FROM indexes
CROSS JOIN LATERAL generate_series(1, 4) AS g(input)
ORDER BY relname DESC, input
;

-- Test 82: statement (line 623)
CREATE TABLE numeric (
  a SMALLINT,
  b INT4,
  c BIGINT,
  d FLOAT(1),
  e FLOAT4,
  f FLOAT8,
  g FLOAT(40),
  h FLOAT,
  i DECIMAL(12,2),
  j DECIMAL(4,4)
);

-- Test 83: query (line 637)
SELECT a.attname,
       t.typname,
       information_schema._pg_numeric_precision(a.atttypid,a.atttypmod),
       information_schema._pg_numeric_precision_radix(a.atttypid,a.atttypmod),
       information_schema._pg_numeric_scale(a.atttypid,a.atttypmod)
FROM pg_attribute a
JOIN pg_type t
ON a.atttypid = t.oid
WHERE a.attrelid = 'numeric'::regclass
ORDER BY a.attname
;

-- Test 84: statement (line 661)
-- PostgreSQL rejects NULL array elements here; keep the test non-erroring.
SELECT * FROM pg_options_to_table(array['b', 'a']::text[]);

-- Test 85: query (line 664)
SELECT * FROM pg_options_to_table(array[]::text[]);

-- Test 86: query (line 669)
SELECT * FROM pg_options_to_table(array['a', 'b=c', '=d', 'e=f=g']::text[]);

-- Test 87: query (line 678)
SELECT * FROM pg_options_to_table(null);

-- Test 88: query (line 683)
SELECT * FROM pg_options_to_table('{a, b=c, =d, e=f=g}');

-- Test 89: statement (line 693)
CREATE TYPE test_type AS ENUM ('open', 'closed', 'inactive');

-- Test 90: statement (line 696)
DROP ROLE IF EXISTS test_role;
CREATE ROLE test_role LOGIN;

-- Test 91: statement (line 699)
CREATE TABLE t1 (a int);

-- Test 92: query (line 702)
SELECT to_regclass('pg_roles');

-- Test 93: query (line 707)
SELECT to_regclass('4294967230');

-- Test 94: query (line 712)
SELECT to_regclass('0 ');

-- Test 95: query (line 717)
SELECT to_regclass(' -123 ');

-- Test 96: query (line 722)
SELECT to_regclass('pg_policy');

-- Test 97: query (line 727)
SELECT to_regclass('t1');

-- Test 98: query (line 732)
SELECT to_regnamespace('crdb_internal');

-- Test 99: query (line 737)
SELECT to_regnamespace('public');

-- Test 100: query (line 742)
SELECT to_regnamespace('1330834471');

-- Test 101: query (line 747)
SELECT to_regnamespace(' 1330834471');

-- Test 102: query (line 752)
SELECT to_regnamespace('0 ');

-- Test 103: query (line 757)
SELECT to_regnamespace('-1234 ');

-- Test 104: query (line 762)
SELECT to_regproc('_st_contains');

-- Test 105: query (line 767)
SELECT to_regproc('version');

-- Test 106: query (line 772)
SELECT to_regproc('bit_in');

-- Test 107: query (line 777)
SELECT to_regprocedure('bit_in');

-- Test 108: query (line 782)
SELECT to_regprocedure('bit_in(int)');

-- Test 109: query (line 787)
SELECT to_regprocedure('version');

-- Test 110: query (line 792)
SELECT to_regprocedure('version()');

-- Test 111: query (line 797)
SELECT to_regprocedure('961893967');

-- Test 112: query (line 802)
SELECT to_regprocedure('0');

-- Test 113: query (line 807)
SELECT to_regprocedure('-2');

-- Test 114: query (line 812)
SELECT to_regrole('admin');

-- Test 115: query (line 817)
SELECT to_regrole('test_role');

-- Test 116: query (line 822)
SELECT to_regrole('foo');

-- Test 117: query (line 827)
SELECT to_regrole('1546506610');

-- Test 118: query (line 832)
SELECT to_regrole('0');

-- Test 119: query (line 837)
SELECT to_regrole('-2');

-- Test 120: query (line 842)
SELECT to_regtype('interval');

-- Test 121: query (line 847)
SELECT to_regtype('integer');

-- Test 122: query (line 852)
SELECT to_regtype('int_4');

-- Test 123: query (line 862)
SELECT to_regtype('1186');

-- Test 124: query (line 867)
SELECT to_regtype('0');

-- Test 125: query (line 872)
-- NOTE: Avoid expected-error cases; use a non-existent but valid name.
SELECT to_regtype('no_such_type');

-- Test 126: query (line 877)
SELECT to_regtype('test_type');

-- Test 127: statement (line 886)
CREATE TABLE expr_idx_tbl (
  id TEXT PRIMARY KEY,
  json JSONB
);
CREATE INDEX expr_idx ON expr_idx_tbl (id, (json->>'bar'), (length(id)));

-- Test 128: query (line 889)
SELECT pg_get_indexdef('expr_idx'::regclass::oid);

-- Test 129: query (line 894)
SELECT k, pg_get_indexdef('expr_idx'::regclass::oid, k, true) FROM generate_series(0,4) k ORDER BY k;

-- Test 130: statement (line 906)
CREATE TABLE pg_indexes (i INT PRIMARY KEY);
CREATE TABLE pg_attribute (i INT PRIMARY KEY);

-- Test 131: statement (line 910)
SET search_path TO public,pg_catalog;

-- Test 132: statement (line 913)
SELECT i, pg_get_indexdef(0, 1, true) FROM pg_indexes;

-- Test 133: statement (line 916)
DROP TABLE pg_indexes;
DROP TABLE pg_attribute;
RESET search_path;

-- Test 134: statement (line 921)
CREATE SCHEMA system;
CREATE TABLE system.comments (i INT);

-- Test 135: statement (line 925)
SELECT col_description(0, 0);

-- statement
DROP TABLE system.comments;
DROP SCHEMA system;

-- Test 136: query (line 934)
select nameconcatoid('cat', 2);

-- Test 137: query (line 940)
select nameconcatoid(repeat('a', 58) || 'bbbbbbbbbb', 200);

-- Test 138: query (line 945)
select nameconcatoid(repeat('a', 58) || 'bbbbbbbbbb', 2);

-- Test 139: query (line 950)
select nameconcatoid(repeat('a', 62), 2), length(nameconcatoid(repeat('a', 62), 2));

-- Test 140: query (line 959)
SELECT information_schema._pg_char_octet_length(25, -1);

-- Test 141: query (line 964)
SELECT information_schema._pg_char_octet_length(25, NULL);

-- Test 142: statement (line 969)
CREATE TYPE u AS (ufoo char, ubar int);

-- Test 143: query (line 972)
SELECT a.attname,
       t.typname,
       information_schema._pg_char_octet_length(a.atttypid,a.atttypmod)
FROM pg_attribute a
JOIN pg_type t
ON a.atttypid = t.oid
WHERE a.attname = 'ufoo'
ORDER BY a.attname
;

-- Test 144: statement (line 985)
DROP TYPE u;

-- Test 145: query (line 992)
SELECT pg_encoding_max_length(6);

-- Test 146: query (line 997)
SELECT pg_encoding_max_length(1);

-- Test 147: query (line 1006)
select information_schema._pg_datetime_precision(1082, -1);

-- Test 148: query (line 1011)
select information_schema._pg_datetime_precision(1083, -1);

-- Test 149: query (line 1016)
select information_schema._pg_datetime_precision(1083, 5);

-- Test 150: query (line 1021)
select information_schema._pg_datetime_precision(1186, -1);

-- Test 151: query (line 1026)
select information_schema._pg_datetime_precision(1186, 5);

-- Test 152: query (line 1031)
select information_schema._pg_datetime_precision(1086, 5);

-- Test 153: query (line 1036)
select information_schema._pg_datetime_precision(1186, NULL);

-- Test 154: query (line 1045)
SELECT information_schema._pg_interval_type(1, 0);

-- Test 155: statement (line 1050)
CREATE TYPE u AS (ufoo interval, ubar interval HOUR TO MINUTE);

-- Test 156: query (line 1053)
SELECT a.attname,
       t.typname,
       information_schema._pg_interval_type(a.atttypid, a.atttypmod)
FROM pg_attribute a
JOIN pg_type t
ON a.atttypid = t.oid
WHERE a.attname IN ('ufoo', 'ubar')
ORDER BY a.attname
;

-- Test 157: statement (line 1071)
CREATE TABLE t144384 (c TEXT);

-- Test 158: statement (line 1074)
CREATE INDEX i144384 ON t144384(c);

-- Test 159: statement (line 1077)
INSERT INTO t144384 VALUES ('i144384');

-- Test 160: query (line 1080)
SELECT to_regclass(c) FROM t144384;
