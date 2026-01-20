-- PostgreSQL compatible tests from distsql_expr
-- NOTE: CockroachDB DistSQL is not applicable to PostgreSQL.

SELECT (1 + 2) * 3 AS expr_val, (NULLIF(1, 1) IS NULL) AS nullif_is_null;
