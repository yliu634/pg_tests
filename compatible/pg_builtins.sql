SET client_min_messages = warning;

-- PostgreSQL compatible tests from pg_builtins
-- 100 tests
--
-- The CockroachDB suite mixes Cockroach-only features with PostgreSQL builtin
-- expectations. This PG-adapted version exercises a small, stable set of
-- PostgreSQL builtins that are commonly used by clients.

-- Test 1: query
SELECT current_database() AS db, current_schema() AS schema;

-- Test 2: query
SELECT current_user AS current_user, session_user AS session_user;

-- Test 3: query
SELECT version() LIKE 'PostgreSQL%' AS is_postgres;

-- Test 4: query
SELECT pg_backend_pid() > 0 AS has_pid;

-- Test 5: query
SELECT current_setting('server_version') AS server_version;

-- Test 6: query
SELECT format('hello %s', 'world') AS formatted;

-- Test 7: query
SELECT to_char(TIMESTAMP '2000-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS') AS ts_fmt;

-- Test 8: query
SELECT array_length(ARRAY[1,2,3], 1) AS arr_len;

RESET client_min_messages;

