-- PostgreSQL compatible tests from reset
-- 25 tests

-- Test 1: statement (line 2)
RESET FOO

-- Test 2: statement (line 5)
SET SEARCH_PATH = foo

-- Test 3: query (line 8)
SHOW SEARCH_PATH

-- Test 4: statement (line 13)
RESET SEARCH_PATH

-- Test 5: query (line 16)
SHOW SEARCH_PATH

-- Test 6: statement (line 21)
RESET SERVER_VERSION

-- Test 7: statement (line 24)
RESET SERVER_VERSION_NUM

-- Test 8: statement (line 29)
SET search_path = foo

-- Test 9: query (line 32)
SHOW search_path

-- Test 10: statement (line 37)
RESET search_path

-- Test 11: query (line 40)
SHOW search_path

-- Test 12: statement (line 45)
RESET client_encoding; RESET NAMES

-- Test 13: query (line 48)
SET timezone = 'Europe/Amsterdam'; SHOW TIMEZONE

-- Test 14: query (line 53)
RESET timezone; SHOW TIMEZONE

-- Test 15: query (line 58)
SET time zone 'Europe/Amsterdam'; SHOW TIME ZONE

-- Test 16: query (line 63)
RESET time zone; SHOW TIME ZONE

-- Test 17: statement (line 70)
BEGIN TRANSACTION READ ONLY

-- Test 18: query (line 73)
SHOW transaction_read_only

-- Test 19: statement (line 78)
RESET ALL

-- Test 20: query (line 81)
SHOW transaction_read_only

-- Test 21: statement (line 86)
COMMIT

-- Test 22: statement (line 91)
SET default_transaction_use_follower_reads = on

-- Test 23: query (line 94)
SHOW default_transaction_use_follower_reads

-- Test 24: statement (line 99)
RESET ALL

-- Test 25: query (line 102)
SHOW default_transaction_use_follower_reads

