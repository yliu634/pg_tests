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
DO $$
BEGIN
  -- `max_connections` is a postmaster-level setting; attempting to change it at
  -- runtime errors in PostgreSQL. Catch and ignore to keep this script
  -- error-free for expected-output generation.
  BEGIN
    EXECUTE 'SET max_connections = 2';
  EXCEPTION WHEN OTHERS THEN
    NULL;
  END;
END
$$;

RESET client_min_messages;
