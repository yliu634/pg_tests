-- PostgreSQL compatible tests from show_var
-- 7 tests

SET client_min_messages = warning;

-- Test 1: statement (line 2)
SET search_path = public, public, a, b, c;

-- Test 2: query (line 5)
SHOW search_path;

-- Test 3: statement (line 13)


-- Test 4: query (line 15)
SHOW max_connections;

-- Test 5: statement (line 20)
-- CockroachDB cluster setting (no PostgreSQL equivalent).
-- SET CLUSTER SETTING server.max_connections_per_gateway = 2;

-- Test 6: query (line 23)
SHOW max_connections;

-- Test 7: statement (line 29)
\set ON_ERROR_STOP 0
SET max_connections = 2;
\set ON_ERROR_STOP 1

RESET client_min_messages;
