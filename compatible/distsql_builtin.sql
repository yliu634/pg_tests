-- PostgreSQL compatible tests from distsql_builtin
-- NOTE: CockroachDB DistSQL builtins differ; this file is a small PostgreSQL builtin smoke test.

SELECT abs(-3) AS abs_val, upper('abc') AS upper_val, length('hello') AS len;
