-- PostgreSQL compatible tests from udf_in_table
-- 101 tests

-- Test 1: statement (line 3)
CREATE FUNCTION f1() RETURNS INT IMMUTABLE LANGUAGE SQL AS $$ SELECT 1 $$;

-- Test 2: statement (line 6)
CREATE VIEW v_col_fn_ids AS
SELECT
id,
(json_array_elements(
  crdb_internal.pb_to_json(
    'cockroach.sql.sqlbase.Descriptor',
    descriptor,
    false
  )->'table'->'columns'
)->'id')::INT as col_id,
json_array_elements(
  crdb_internal.pb_to_json(
    'cockroach.sql.sqlbase.Descriptor',
    descriptor,
    false
  )->'table'->'columns'
)->'defaultExpr' as default_expr,
json_array_elements(
  crdb_internal.pb_to_json(
    'cockroach.sql.sqlbase.Descriptor',
    descriptor,
    false
  )->'table'->'columns'
)->'onUpdateExpr' as on_update_expr,
json_array_elements(
  crdb_internal.pb_to_json(
    'cockroach.sql.sqlbase.Descriptor',
    descriptor,
    false
  )->'table'->'columns'
)->'computeExpr' as compute_expr,
json_array_elements(
  crdb_internal.pb_to_json(
    'cockroach.sql.sqlbase.Descriptor',
    descriptor,
    false
  )->'table'->'columns'
)->'usesFunctionIds' as uses_fn_ids
FROM system.descriptor

-- Test 3: statement (line 47)
CREATE FUNCTION get_col_fn_ids(table_id INT) RETURNS SETOF v_col_fn_ids
LANGUAGE SQL
AS $$
  SELECT *
  FROM v_col_fn_ids
  WHERE id = table_id
$$;

-- Test 4: statement (line 56)
CREATE VIEW v_fn_depended_on_by AS
SELECT
     id,
     jsonb_pretty(
       crdb_internal.pb_to_json(
         'cockroach.sql.sqlbase.Descriptor',
         descriptor,
         false
       )->'function'->'dependedOnBy'
     ) as depended_on_by
FROM system.descriptor

-- Test 5: statement (line 80)
CREATE TABLE t1(
  a INT PRIMARY KEY,
  b INT DEFAULT f1(),
  c INT,
  d INT NULL ON UPDATE public.f1(),
  e INT,
  FAMILY fam_0 (a, b, c, d, e)
);

let $tbl_id
SELECT id FROM system.namespace WHERE name = 't1';

-- Test 6: query (line 93)
SELECT * FROM get_col_fn_ids($tbl_id) ORDER BY 1, 2;

-- Test 7: query (line 104)
SELECT create_statement FROM [SHOW CREATE TABLE t1];

-- Test 8: query (line 121)
SELECT get_fn_depended_on_by($fn_id)

-- Test 9: statement (line 135)
ALTER TABLE t1 ALTER COLUMN c SET DEFAULT f1();

-- Test 10: query (line 138)
SELECT * FROM get_col_fn_ids($tbl_id) ORDER BY 1, 2;

-- Test 11: query (line 149)
SELECT create_statement FROM [SHOW CREATE TABLE t1];

-- Test 12: query (line 163)
SELECT create_statement FROM [SHOW CREATE TABLE t1];

-- Test 13: query (line 176)
SELECT get_fn_depended_on_by($fn_id)

-- Test 14: statement (line 191)
ALTER TABLE t1 ALTER COLUMN e SET ON UPDATE f1();

-- Test 15: query (line 194)
SELECT * FROM get_col_fn_ids($tbl_id) ORDER BY 1, 2;

-- Test 16: query (line 205)
SELECT create_statement FROM [SHOW CREATE TABLE t1];

-- Test 17: statement (line 219)
ALTER TABLE t1 ALTER COLUMN c SET DEFAULT NULL;

-- Test 18: query (line 222)
SELECT * FROM get_col_fn_ids($tbl_id) ORDER BY 1, 2;

-- Test 19: query (line 232)
SELECT get_fn_depended_on_by($fn_id)

-- Test 20: statement (line 247)
ALTER TABLE t1 ALTER COLUMN e SET ON UPDATE NULL;

-- Test 21: query (line 250)
SELECT * FROM get_col_fn_ids($tbl_id) ORDER BY 1, 2;

-- Test 22: query (line 260)
SELECT get_fn_depended_on_by($fn_id)

-- Test 23: statement (line 274)
ALTER TABLE t1 ALTER COLUMN b DROP DEFAULT;

-- Test 24: query (line 277)
SELECT * FROM get_col_fn_ids($tbl_id) ORDER BY 1, 2;

-- Test 25: query (line 287)
SELECT get_fn_depended_on_by($fn_id)

-- Test 26: statement (line 300)
ALTER TABLE t1 ALTER COLUMN d DROP ON UPDATE;

-- Test 27: query (line 303)
SELECT * FROM get_col_fn_ids($tbl_id) ORDER BY 1, 2;

-- Test 28: query (line 313)
SELECT get_fn_depended_on_by($fn_id)

-- Test 29: statement (line 319)
ALTER TABLE t1 ALTER COLUMN b SET DEFAULT f1();

-- Test 30: statement (line 322)
ALTER TABLE t1 ALTER COLUMN d SET ON UPDATE f1();

-- Test 31: query (line 325)
SELECT get_fn_depended_on_by($fn_id)

-- Test 32: statement (line 339)
ALTER TABLE t1 ALTER COLUMN c SET DEFAULT f1();

-- Test 33: query (line 342)
SELECT * FROM get_col_fn_ids($tbl_id) ORDER BY 1, 2;

-- Test 34: query (line 352)
SELECT get_fn_depended_on_by($fn_id)

-- Test 35: statement (line 366)
ALTER TABLE t1 DROP COLUMN c;

-- Test 36: query (line 369)
SELECT * FROM get_col_fn_ids($tbl_id) ORDER BY 1, 2;

-- Test 37: query (line 378)
SELECT get_fn_depended_on_by($fn_id)

-- Test 38: statement (line 393)
ALTER TABLE t1 ADD COLUMN f int AS (f1()) VIRTUAL;

-- Test 39: statement (line 396)
ALTER TABLE t1 ADD COLUMN g int DEFAULT (f1());

-- Test 40: statement (line 399)
ALTER TABLE t1 ADD COLUMN h int ON UPDATE (f1());

-- Test 41: query (line 402)
SELECT * FROM get_col_fn_ids($tbl_id) ORDER BY 1, 2;

-- Test 42: query (line 414)
SELECT get_fn_depended_on_by($fn_id)

-- Test 43: statement (line 431)
ALTER TABLE t1 ALTER COLUMN b SET DEFAULT f1();

-- Test 44: query (line 434)
SELECT * FROM get_col_fn_ids($tbl_id) ORDER BY 1, 2;

-- Test 45: query (line 446)
SELECT get_fn_depended_on_by($fn_id)

-- Test 46: statement (line 462)
DROP TABLE t1;

-- Test 47: query (line 465)
SELECT get_fn_depended_on_by($fn_id)

-- Test 48: statement (line 473)
CREATE TABLE t1(
  a INT PRIMARY KEY,
  b INT DEFAULT f1(),
  FAMILY fam_0 (a, b)
);
CREATE TABLE t2(
  a INT PRIMARY KEY,
  b INT DEFAULT f1(),
  FAMILY fam_0 (a, b)
);

-- Test 49: query (line 485)
SELECT get_fn_depended_on_by($fn_id)

-- Test 50: statement (line 503)
DROP TABLE t1;
DROp TABLE t2;

-- Test 51: query (line 507)
SELECT get_fn_depended_on_by($fn_id)

-- Test 52: statement (line 513)
CREATE FUNCTION f2() RETURNS INT LANGUAGE SQL AS $$ SELECT 1 $$;

let $fn_id_2
SELECT oid::int - 100000 FROM pg_catalog.pg_proc WHERE proname = 'f2';

-- Test 53: statement (line 519)
CREATE TABLE t1(
  a INT PRIMARY KEY,
  b INT DEFAULT f1(),
  c INT ON UPDATE f2(),
  FAMILY fam_0 (a, b, c)
);

-- Test 54: query (line 527)
SELECT get_fn_depended_on_by($fn_id)

-- Test 55: query (line 539)
SELECT get_fn_depended_on_by($fn_id_2)

-- Test 56: statement (line 551)
DROP TABLE t1;

-- Test 57: query (line 554)
SELECT get_fn_depended_on_by($fn_id)

-- Test 58: query (line 559)
SELECT get_fn_depended_on_by($fn_id_2)

-- Test 59: statement (line 565)
CREATE TABLE t1(
  a INT PRIMARY KEY,
  b INT DEFAULT f1(),
  FAMILY fam_0 (a, b)
);
CREATE TABLE t2(
  a INT PRIMARY KEY,
  b INT DEFAULT f1(),
  FAMILY fam_0 (a, b)
);

-- Test 60: statement (line 577)
DROP FUNCTION f1;

-- Test 61: statement (line 580)
ALTER TABLE t1 ALTER COLUMN b SET DEFAULT NULL;
ALTER TABLE t2 ALTER COLUMN b SET DEFAULT NULL;

-- Test 62: statement (line 584)
DROP FUNCTION f1;
DROP TABLE t1;
DROP TABLE t2;

-- Test 63: statement (line 590)
BEGIN;
CREATE FUNCTION f1() RETURNS INT LANGUAGE SQL AS $$ SELECT 1 $$;
CREATE TABLE t1(
  a INT PRIMARY KEY,
  b INT DEFAULT f1(),
  FAMILY fam_0 (a, b)
);
END;

let $tbl_id
SELECT id FROM system.namespace WHERE name = 't1';

let $fn_id
SELECT oid::int - 100000 FROM pg_catalog.pg_proc WHERE proname = 'f1';

-- Test 64: query (line 606)
SELECT * FROM get_col_fn_ids($tbl_id) ORDER BY 1, 2;

-- Test 65: query (line 613)
SELECT get_fn_depended_on_by($fn_id);

-- Test 66: statement (line 625)
BEGIN;
DROP TABLE t1;
DROP FUNCTION f1;
END;

-- Test 67: statement (line 632)
CREATE TABLE t1 (
  a INT PRIMARY KEY,
  b INT,
  FAMILY fam_0 (a, b)
);

-- Test 68: statement (line 639)
CREATE FUNCTION f1() RETURNS INT LANGUAGE SQL AS $$ SELECT 1 $$;
ALTER TABLE t1 ALTER COLUMN b SET DEFAULT f1();

let $tbl_id
SELECT id FROM system.namespace WHERE name = 't1';

let $fn_id
SELECT oid::int - 100000 FROM pg_catalog.pg_proc WHERE proname = 'f1';

-- Test 69: query (line 649)
SELECT * FROM get_col_fn_ids($tbl_id) ORDER BY 1, 2;

-- Test 70: query (line 656)
SELECT get_fn_depended_on_by($fn_id);

-- Test 71: statement (line 669)
SET use_declarative_schema_changer = 'unsafe_always';

-- Test 72: statement (line 672)
BEGIN;
ALTER TABLE t1 DROP COLUMN b;
DROP FUNCTION f1;
END;

skipif config local-legacy-schema-changer

-- Test 73: statement (line 679)
SET use_declarative_schema_changer = 'on';

-- Test 74: statement (line 683)
DROP TABLE t1;

-- Test 75: statement (line 686)
CREATE FUNCTION f1() RETURNS INT LANGUAGE SQL AS $$ SELECT 1 $$;
CREATE TABLE t1 (
  a INT PRIMARY KEY,
  b INT DEFAULT f1(),
  FAMILY fam_0 (a, b)
);

-- Test 76: statement (line 694)
INSERT INTO t1 VALUES (1), (2)

-- Test 77: query (line 697)
SELECT * FROM t1 ORDER BY a;

-- Test 78: statement (line 704)
ALTER FUNCTION f1() RENAME TO f1_new;

skipif config schema-locked-disabled

-- Test 79: query (line 708)
SELECT create_statement FROM [SHOW CREATE TABLE t1]

-- Test 80: query (line 719)
SELECT create_statement FROM [SHOW CREATE TABLE t1]

-- Test 81: statement (line 729)
INSERT INTO t1 VALUES (3)

-- Test 82: query (line 732)
SELECT * FROM t1 ORDER BY a;

-- Test 83: statement (line 740)
CREATE FUNCTION f_compute(x INT) RETURNS INT LANGUAGE SQL AS $$ SELECT x * 2 $$ IMMUTABLE;

-- Test 84: statement (line 743)
CREATE TABLE t_computed(
  a INT PRIMARY KEY,
  b INT,
  c INT AS (f_compute(a)) STORED,
  d INT AS (f_compute(b)) VIRTUAL
);

let $tbl_computed_id
SELECT id FROM system.namespace WHERE name = 't_computed';

-- Test 85: query (line 755)
SELECT * FROM get_col_fn_ids($tbl_computed_id) ORDER BY 1, 2;

-- Test 86: query (line 768)
SELECT get_fn_depended_on_by($fn_compute_id)

-- Test 87: statement (line 782)
ALTER TABLE t_computed DROP COLUMN c;

-- Test 88: query (line 785)
SELECT * FROM get_col_fn_ids($tbl_computed_id) ORDER BY 1, 2;

-- Test 89: query (line 793)
SELECT get_fn_depended_on_by($fn_compute_id)

-- Test 90: statement (line 806)
DROP TABLE t_computed;

-- Test 91: query (line 809)
SELECT get_fn_depended_on_by($fn_compute_id)

-- Test 92: statement (line 815)
CREATE FUNCTION f_add(x INT, y INT) RETURNS INT LANGUAGE SQL AS $$ SELECT x + y $$ IMMUTABLE;

-- Test 93: statement (line 818)
CREATE TABLE t_multi_fn(
  a INT PRIMARY KEY,
  b INT,
  c INT AS (f_compute(a) + f_add(a, b)) STORED
);

-- Test 94: statement (line 826)
INSERT INTO t_multi_fn (a, b) VALUES (1, 2), (3, 4), (5, 6);

-- Test 95: query (line 829)
SELECT * FROM t_multi_fn ORDER BY a;

-- Test 96: query (line 843)
SELECT * FROM get_col_fn_ids($tbl_multi_fn_id) ORDER BY 1, 2;

-- Test 97: query (line 851)
SELECT get_fn_depended_on_by($fn_compute_id)

-- Test 98: query (line 863)
SELECT get_fn_depended_on_by($fn_add_id)

-- Test 99: statement (line 875)
DROP TABLE t_multi_fn;

-- Test 100: statement (line 879)
CREATE TABLE t_circle(a INT PRIMARY KEY, b INT);
CREATE FUNCTION f_circle() RETURNS INT LANGUAGE SQL AS $$ SELECT a FROM t_circle $$;

-- Test 101: statement (line 883)
ALTER TABLE t_circle ALTER COLUMN b SET DEFAULT f_circle();

