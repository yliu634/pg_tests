-- PostgreSQL compatible tests from show_var
-- 7 tests

-- Test 1: statement (line 2)
SET search_path = public, public, a, b, c

-- Test 2: query (line 5)
SHOW search_path;

-- Test 3: statement (line 13)


-- Test 4: query (line 15)
SHOW max_connections;

-- Test 5: statement (line 20)
SET CLUSTER SETTING server.max_connections_per_gateway = 2;

-- Test 6: query (line 23)
SHOW max_connections;

-- Test 7: statement (line 29)
SET max_connections = 2;

