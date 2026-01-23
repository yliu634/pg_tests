-- PostgreSQL compatible tests from distsql_crdb_internal
-- 5 tests

-- Test 1: statement (line 3)
CREATE TABLE data (a INT, b INT, c FLOAT, d DECIMAL, PRIMARY KEY (a, b, c, d));

-- Test 2: statement (line 17)
INSERT INTO data SELECT a, b, c::FLOAT, d::DECIMAL FROM
   generate_series(1, 10) AS a(a),
   generate_series(1, 10) AS b(b),
   generate_series(1, 10) AS c(c),
   generate_series(1, 10) AS d(d);

-- Test 3: statement (line 45)
CREATE TABLE smalldata (a INT, PRIMARY KEY (a));

-- Test 4: statement (line 48)
INSERT INTO smalldata VALUES (1), (2), (3);

-- Test 5: query (line 51)
-- CockroachDB's `crdb_internal.reset_sql_stats()` isn't available in PostgreSQL.
-- Provide a small shim with equivalent "reset stats then return true" behavior.
CREATE SCHEMA IF NOT EXISTS crdb_internal;
CREATE OR REPLACE FUNCTION crdb_internal.reset_sql_stats()
RETURNS boolean
LANGUAGE SQL
VOLATILE
AS $$ SELECT pg_stat_reset() IS NOT NULL; $$;

SELECT a, count(*) AS cnt
FROM smalldata
GROUP BY a
HAVING crdb_internal.reset_sql_stats()
ORDER BY a;
