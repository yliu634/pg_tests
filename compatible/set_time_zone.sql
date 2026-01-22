-- PostgreSQL compatible tests from set_time_zone
-- 59 tests

\set ON_ERROR_STOP 1
SET client_min_messages = warning;

-- Test 1: statement (line 1)
SET TIME ZONE 0;

-- Test 2: query (line 4)
SHOW TIME ZONE;

-- Test 3: query (line 9)
SELECT TIME '05:40:00'::TIMETZ;

-- Test 4: statement (line 14)
SET TIME ZONE 10;

-- Test 5: query (line 17)
SHOW TIME ZONE;

-- Test 6: query (line 22)
SELECT TIME '05:40:00'::TIMETZ;

-- Test 7: statement (line 27)
SET TIME ZONE -10;

-- Test 8: query (line 30)
SHOW TIME ZONE;

-- Test 9: query (line 35)
SELECT TIME '05:40:00'::TIMETZ;

-- Test 10: statement (line 40)
SET TIME ZONE '10';

-- Test 11: query (line 43)
SHOW TIME ZONE;

-- Test 12: query (line 48)
SELECT TIME '05:40:00'::TIMETZ;

-- Test 13: statement (line 53)
SET TIME ZONE '+10';

-- Test 14: query (line 56)
SHOW TIME ZONE;

-- Test 15: query (line 61)
SELECT TIME '05:40:00'::TIMETZ;

-- Test 16: statement (line 66)
SET TIME ZONE '-10';

-- Test 17: query (line 69)
SHOW TIME ZONE;

-- Test 18: query (line 74)
SELECT TIME '05:40:00'::TIMETZ;

-- Test 19: statement (line 79)
SET TIME ZONE '+10.5';

-- Test 20: query (line 82)
SHOW TIME ZONE;

-- Test 21: query (line 87)
SELECT TIME '05:40:00'::TIMETZ;

-- Test 22: statement (line 92)
SET TIME ZONE '-10.5';

-- Test 23: query (line 95)
SHOW TIME ZONE;

-- Test 24: query (line 100)
SELECT TIME '05:40:00'::TIMETZ;

-- Test 25: statement (line 105)
SET TIME ZONE '+10.555';

-- Test 26: query (line 108)
SHOW TIME ZONE;

-- Test 27: query (line 113)
SELECT TIME '05:40:00'::TIMETZ;

-- Test 28: statement (line 118)
SET TIME ZONE '-10.555';

-- Test 29: query (line 121)
SHOW TIME ZONE;

-- Test 30: query (line 126)
SELECT TIME '05:40:00'::TIMETZ;

-- Test 31: statement (line 131)
SET TIME ZONE '     +10';

-- Test 32: query (line 134)
SHOW TIME ZONE;

-- Test 33: query (line 139)
SELECT TIME '05:40:00'::TIMETZ;

-- Test 34: statement (line 144)
SET TIME ZONE '     -10';

-- Test 35: query (line 147)
SHOW TIME ZONE;

-- Test 36: query (line 152)
SELECT TIME '05:40:00'::TIMETZ;

-- Test 37: statement (line 157)
SET TIME ZONE 'GMT+3';

-- Test 38: query (line 160)
SHOW TIME ZONE;

-- Test 39: query (line 165)
SELECT TIME '05:40:00'::TIMETZ;

-- Test 40: statement (line 170)
SET TIME ZONE 'GMT-3';

-- Test 41: query (line 173)
SHOW TIME ZONE;

-- Test 42: query (line 178)
SELECT TIME '05:40:00'::TIMETZ;

-- Test 43: statement (line 183)
SET TIME ZONE 'UTC+3';

-- Test 44: query (line 186)
SHOW TIME ZONE;

-- Test 45: query (line 191)
SELECT TIME '05:40:00'::TIMETZ;

-- Test 46: statement (line 196)
SET TIME ZONE 'UTC-3';

-- Test 47: query (line 199)
SHOW TIME ZONE;

-- Test 48: query (line 204)
SELECT TIME '05:40:00'::TIMETZ;

-- Test 49: statement (line 209)
SET TIME ZONE 'Asia/Tokyo';

-- Test 50: query (line 212)
SHOW TIME ZONE;

-- Test 51: query (line 217)
SELECT TIME '05:40:00'::TIMETZ;

-- Test 52: statement (line 222)
SET TIME ZONE 'UTC';

-- Test 53: query (line 225)
SHOW TIME ZONE;

-- Test 54: query (line 230)
SELECT TIME '05:40:00'::TIMETZ;

-- Test 55: statement (line 235)
SET TIME ZONE '14';

-- Test 56: statement (line 238)
SET TIME ZONE '-14';

-- Test 57: statement (line 241)
SET TIME ZONE INTERVAL '-5 hours';

-- Test 58: statement (line 244)
SET TIME ZONE INTERVAL '5 hours';

-- Test 59: statement (line 247)
SET TIME ZONE INTERVAL '-5 hours';

RESET client_min_messages;
