-- PostgreSQL compatible tests from udf_in_index
-- Reduced subset: CockroachDB descriptor introspection, @index hints, and
-- inline INDEX definitions are removed. Validate IMMUTABLE UDF usage in index
-- expressions and partial indexes, and show dependency tracking via catalogs.

SET client_min_messages = warning;
DROP TABLE IF EXISTS test_tbl_t CASCADE;
DROP FUNCTION IF EXISTS test_tbl_f();
DROP FUNCTION IF EXISTS test_tbl_partial_f(int);
DROP INDEX IF EXISTS t_idx_expr;
DROP INDEX IF EXISTS t_idx_partial;
RESET client_min_messages;

CREATE FUNCTION test_tbl_f() RETURNS INT
LANGUAGE SQL
IMMUTABLE
AS $$ SELECT 1 $$;

CREATE FUNCTION test_tbl_partial_f(b INT) RETURNS INT
LANGUAGE SQL
IMMUTABLE
AS $$ SELECT b $$;

CREATE TABLE test_tbl_t (
  a INT PRIMARY KEY,
  b INT
);

INSERT INTO test_tbl_t VALUES (1, 1), (2, -2), (3, 3);

CREATE INDEX t_idx_expr ON test_tbl_t ((b + test_tbl_f()));
CREATE INDEX t_idx_partial ON test_tbl_t (b) WHERE test_tbl_partial_f(b) > 0;

SELECT indexname, indexdef
FROM pg_indexes
WHERE schemaname = 'public' AND tablename = 'test_tbl_t'
ORDER BY indexname;

-- Demonstrate that both indexes depend on their referenced functions.
SELECT i.relname AS index_name, p.proname AS function_name
FROM pg_depend d
JOIN pg_class i ON i.oid = d.objid
JOIN pg_proc p ON p.oid = d.refobjid
WHERE d.classid = 'pg_class'::regclass
  AND d.refclassid = 'pg_proc'::regclass
  AND i.relname IN ('t_idx_expr', 't_idx_partial')
  AND p.pronamespace = 'public'::regnamespace
  AND p.proname IN ('test_tbl_f', 'test_tbl_partial_f')
ORDER BY 1, 2;

SELECT * FROM test_tbl_t WHERE test_tbl_partial_f(b) > 0 ORDER BY a;
