-- PostgreSQL compatible tests from reset
-- 25 tests

-- Helper: run a statement that is expected to error without emitting psql ERROR output.
-- Returns true if the statement errored, false otherwise.
CREATE OR REPLACE FUNCTION pg_temp.expect_error(sql text) RETURNS boolean
LANGUAGE plpgsql
AS $$
BEGIN
  EXECUTE sql;
  RETURN false;
EXCEPTION WHEN OTHERS THEN
  RETURN true;
END;
$$;

-- Test 1: statement (line 2)
SET client_min_messages = warning;
SELECT pg_temp.expect_error($sql$RESET FOO$sql$);

-- Test 2: statement (line 5)
SET search_path = foo;

-- Test 3: query (line 8)
SHOW search_path;

-- Test 4: statement (line 13)
RESET search_path;

-- Test 5: query (line 16)
SHOW search_path;

-- Test 6: statement (line 21)
SELECT pg_temp.expect_error($sql$RESET server_version$sql$);

-- Test 7: statement (line 24)
SELECT pg_temp.expect_error($sql$RESET server_version_num$sql$);

-- Test 8: statement (line 29)
SET search_path = foo;

-- Test 9: query (line 32)
SHOW search_path;

-- Test 10: statement (line 37)
RESET search_path;

-- Test 11: query (line 40)
SHOW search_path;

-- Test 12: statement (line 45)
RESET client_encoding;
SELECT pg_temp.expect_error($sql$RESET NAMES$sql$);

-- Test 13: query (line 48)
SET timezone = 'Europe/Amsterdam';
SHOW timezone;

-- Test 14: query (line 53)
RESET timezone;
SHOW timezone;

-- Test 15: query (line 58)
SET time zone 'Europe/Amsterdam';
SHOW TIME ZONE;

-- Test 16: query (line 63)
RESET time zone;
SHOW TIME ZONE;

-- Test 17: statement (line 70)
BEGIN TRANSACTION READ ONLY;

-- Test 18: query (line 73)
SHOW transaction_read_only;

-- Test 19: statement (line 78)
RESET ALL;

-- Test 20: query (line 81)
SHOW transaction_read_only;

-- Test 21: statement (line 86)
COMMIT;

-- Test 22: statement (line 91)
SELECT pg_temp.expect_error($sql$SET default_transaction_use_follower_reads = on$sql$);

-- Test 23: query (line 94)
SELECT pg_temp.expect_error($sql$SHOW default_transaction_use_follower_reads$sql$);

-- Test 24: statement (line 99)
RESET ALL;

-- Test 25: query (line 102)
SELECT pg_temp.expect_error($sql$SHOW default_transaction_use_follower_reads$sql$);

RESET client_min_messages;
