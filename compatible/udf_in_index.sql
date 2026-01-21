-- PostgreSQL compatible tests from udf_in_index
--
-- This file adapts the CockroachDB logic-test coverage for UDF dependencies in:
-- - expression indexes
-- - partial index predicates
--
-- In PostgreSQL, dependencies are tracked via pg_depend and will prevent
-- dropping a function while an index depends on it.

SET client_min_messages = warning;

-- Keep manual reruns tidy (regen_expected runs in a fresh DB already).
DROP TABLE IF EXISTS test_tbl_t CASCADE;
DROP FUNCTION IF EXISTS test_tbl_f();
DROP FUNCTION IF EXISTS test_tbl_partial_f(int);

-- List indexes on a table along with any expression / predicate.
CREATE OR REPLACE VIEW v_table_indexes AS
SELECT
  i.indrelid,
  c.relname AS index_name,
  pg_get_expr(i.indexprs, i.indrelid) AS index_exprs,
  pg_get_expr(i.indpred, i.indrelid) AS predicate
FROM pg_index i
JOIN pg_class c ON c.oid = i.indexrelid
WHERE c.relkind = 'i';

CREATE OR REPLACE FUNCTION get_table_indexes(p_table regclass)
RETURNS TABLE(index_name text, index_exprs text, predicate text)
LANGUAGE SQL
AS $$
  SELECT index_name, index_exprs, predicate
  FROM v_table_indexes
  WHERE indrelid = p_table::oid
  ORDER BY 1;
$$;

-- List index dependencies for a function.
CREATE OR REPLACE FUNCTION get_fn_depended_on_by(p_fn regproc)
RETURNS TABLE(dependent_index text)
LANGUAGE SQL
AS $$
  SELECT c.relname
  FROM pg_depend d
  JOIN pg_class c ON c.oid = d.objid
  WHERE d.classid = 'pg_class'::regclass
    AND c.relkind = 'i'
    AND d.refclassid = 'pg_proc'::regclass
    AND d.refobjid = p_fn::oid
    AND d.deptype = 'n'
  ORDER BY 1;
$$;

-- Expression index depends on an immutable SQL UDF.
CREATE FUNCTION test_tbl_f() RETURNS int IMMUTABLE LANGUAGE SQL AS $$ SELECT 1 $$;

CREATE TABLE test_tbl_t (
  a int PRIMARY KEY,
  b int
);

CREATE INDEX idx_b ON test_tbl_t ((1 + test_tbl_f()));

SELECT * FROM get_table_indexes('test_tbl_t'::regclass);
SELECT * FROM get_fn_depended_on_by('test_tbl_f'::regproc);

CREATE INDEX t_idx ON test_tbl_t ((2 + test_tbl_f()));

SELECT * FROM get_table_indexes('test_tbl_t'::regclass);
SELECT * FROM get_fn_depended_on_by('test_tbl_f'::regproc);

-- Partial index predicate depends on its own UDF too.
CREATE FUNCTION test_tbl_partial_f(b int) RETURNS int IMMUTABLE LANGUAGE SQL AS $$ SELECT b $$;
CREATE INDEX t_idx2 ON test_tbl_t (b) WHERE test_tbl_partial_f(b) > 0;

SELECT * FROM get_table_indexes('test_tbl_t'::regclass);
SELECT * FROM get_fn_depended_on_by('test_tbl_partial_f'::regproc);

INSERT INTO test_tbl_t VALUES (1, 1), (2, -2), (3, 3);
SELECT * FROM test_tbl_t WHERE test_tbl_partial_f(b) > 0 ORDER BY 1, 2;

-- Dropping a function used by a partial index should error while the index exists.
\set ON_ERROR_STOP 0
DROP FUNCTION test_tbl_partial_f(int);
\set ON_ERROR_STOP 1

SELECT * FROM get_fn_depended_on_by('test_tbl_partial_f'::regproc);

DELETE FROM test_tbl_t WHERE true;

-- More expression indexes referencing test_tbl_f.
CREATE INDEX t_idx3 ON test_tbl_t ((b + test_tbl_f()));
CREATE INDEX t_idx4 ON test_tbl_t (test_tbl_f(), b, (test_tbl_f() + 1));

SELECT * FROM get_fn_depended_on_by('test_tbl_f'::regproc);

-- Dropping test_tbl_f should error until all dependent indexes are removed.
\set ON_ERROR_STOP 0
DROP FUNCTION test_tbl_f();
\set ON_ERROR_STOP 1

DROP INDEX t_idx;
SELECT * FROM get_fn_depended_on_by('test_tbl_f'::regproc);

DROP INDEX t_idx2;
SELECT * FROM get_fn_depended_on_by('test_tbl_partial_f'::regproc);

DROP INDEX t_idx3;
SELECT * FROM get_fn_depended_on_by('test_tbl_f'::regproc);

DROP INDEX t_idx4;
SELECT * FROM get_fn_depended_on_by('test_tbl_f'::regproc);

DROP INDEX idx_b;
SELECT * FROM get_fn_depended_on_by('test_tbl_f'::regproc);

DROP FUNCTION test_tbl_partial_f(int);
DROP FUNCTION test_tbl_f();

RESET client_min_messages;
