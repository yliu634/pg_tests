-- PostgreSQL compatible tests from udf_in_index
-- 45 tests

-- Test 1: statement (line 4)
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
)->'computeExpr' as compute_expr,
json_array_elements(
  crdb_internal.pb_to_json(
    'cockroach.sql.sqlbase.Descriptor',
    descriptor,
    false
  )->'table'->'columns'
)->'usesFunctionIds' as uses_fn_ids
FROM system.descriptor

-- Test 2: statement (line 31)
CREATE FUNCTION get_col_fn_ids(table_id INT) RETURNS SETOF v_col_fn_ids
LANGUAGE SQL
AS $$
  SELECT *
  FROM v_col_fn_ids
  WHERE id = table_id
$$;

-- Test 3: statement (line 40)
CREATE VIEW v_idx_fn_ids AS
SELECT
id,
(json_array_elements(
  crdb_internal.pb_to_json(
    'cockroach.sql.sqlbase.Descriptor',
    descriptor,
    false
  )->'table'->'indexes'
)->'id')::INT as idx_id,
json_array_elements(
  crdb_internal.pb_to_json(
    'cockroach.sql.sqlbase.Descriptor',
    descriptor,
    false
  )->'table'->'indexes'
)->'predicate' as predicate_expr
FROM system.descriptor

-- Test 4: statement (line 60)
CREATE FUNCTION get_idx_fn_ids(table_id INT) RETURNS SETOF v_idx_fn_ids
LANGUAGE SQL
AS $$
  SELECT *
  FROM v_idx_fn_ids
  WHERE id = table_id
$$;

-- Test 5: statement (line 69)
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

-- Test 6: statement (line 91)
CREATE FUNCTION test_tbl_f() RETURNS INT IMMUTABLE LANGUAGE SQL AS $$ SELECT 1 $$;

-- Test 7: statement (line 95)
CREATE TABLE test_tbl_t (a INT PRIMARY KEY, b INT, INDEX idx_b((1 + test_tbl_f())));

let $tbl_id
SELECT id FROM system.namespace WHERE name = 'test_tbl_t';

let $fn_id
SELECT oid::int - 100000 FROM pg_catalog.pg_proc WHERE proname = 'test_tbl_f';

-- Test 8: query (line 104)
SELECT * FROM get_col_fn_ids($tbl_id) ORDER BY 1, 2;

-- Test 9: query (line 112)
SELECT get_fn_depended_on_by($fn_id)

-- Test 10: statement (line 125)
CREATE INDEX t_idx ON test_tbl_t((2 + test_tbl_f()));

-- Test 11: query (line 128)
SELECT * FROM get_col_fn_ids($tbl_id) ORDER BY 1, 2;

-- Test 12: query (line 137)
SELECT get_fn_depended_on_by($fn_id)

-- Test 13: statement (line 151)
CREATE FUNCTION test_tbl_partial_f(b INT) RETURNS INT IMMUTABLE LANGUAGE SQL AS $$ SELECT b $$;

let $partial_fn_id
SELECT oid::int - 100000 FROM pg_catalog.pg_proc WHERE proname = 'test_tbl_partial_f';

-- Test 14: statement (line 157)
CREATE INDEX t_idx2 ON test_tbl_t(b) WHERE test_tbl_partial_f(b) > 0;

-- Test 15: query (line 160)
SELECT * FROM get_col_fn_ids($tbl_id) ORDER BY 1, 2;

-- Test 16: query (line 169)
SELECT * FROM get_idx_fn_ids($tbl_id) ORDER BY 1, 2;

-- Test 17: query (line 177)
SELECT get_fn_depended_on_by($partial_fn_id)

-- Test 18: statement (line 189)
INSERT INTO test_tbl_t VALUES (1, 1), (2, -2), (3, 3);

-- Test 19: query (line 193)
SELECT * FROM test_tbl_t@t_idx2 WHERE test_tbl_partial_f(b) > 0 ORDER BY 1, 2;

-- Test 20: statement (line 199)
SELECT * FROM test_tbl_t@t_idx2;

-- Test 21: statement (line 202)
DROP FUNCTION test_tbl_partial_f;

-- Test 22: statement (line 205)
DELETE FROM test_tbl_t WHERE true;

-- Test 23: statement (line 209)
CREATE INDEX t_idx3 ON test_tbl_t((b + test_tbl_f()));

-- Test 24: query (line 212)
SELECT * FROM get_col_fn_ids($tbl_id) ORDER BY 1, 2;

-- Test 25: query (line 222)
SELECT get_fn_depended_on_by($fn_id)

-- Test 26: statement (line 237)
CREATE INDEX t_idx4 ON test_tbl_t(test_tbl_f(), b, (test_tbl_f() + 1));

-- Test 27: query (line 240)
SELECT * FROM get_col_fn_ids($tbl_id) ORDER BY 1, 2;

-- Test 28: query (line 252)
SELECT get_fn_depended_on_by($fn_id)

-- Test 29: statement (line 269)
DROP INDEX t_idx;

-- Test 30: query (line 272)
SELECT * FROM get_col_fn_ids($tbl_id) ORDER BY 1, 2;

-- Test 31: query (line 283)
SELECT get_fn_depended_on_by($fn_id)

-- Test 32: statement (line 299)
DROP FUNCTION test_tbl_f;

-- Test 33: statement (line 303)
DROP INDEX t_idx2;

-- Test 34: query (line 306)
SELECT * FROM get_col_fn_ids($tbl_id) ORDER BY 1, 2;

-- Test 35: query (line 317)
SELECT get_fn_depended_on_by($fn_id)

-- Test 36: statement (line 332)
DROP INDEX t_idx3;

-- Test 37: query (line 335)
SELECT * FROM get_col_fn_ids($tbl_id) ORDER BY 1, 2;

-- Test 38: query (line 345)
SELECT get_fn_depended_on_by($fn_id)

-- Test 39: statement (line 359)
DROP INDEX t_idx4;

-- Test 40: query (line 362)
SELECT * FROM get_col_fn_ids($tbl_id) ORDER BY 1, 2;

-- Test 41: query (line 370)
SELECT get_fn_depended_on_by($fn_id)

-- Test 42: statement (line 382)
DROP INDEX idx_b;

-- Test 43: query (line 385)
SELECT * FROM get_col_fn_ids($tbl_id) ORDER BY 1, 2;

-- Test 44: query (line 392)
SELECT get_fn_depended_on_by($fn_id)

-- Test 45: statement (line 398)
DROP FUNCTION test_tbl_f;

