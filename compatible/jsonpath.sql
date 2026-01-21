-- PostgreSQL compatible tests from jsonpath
-- 57 tests

-- Test 1: query (line 2)
SELECT pg_typeof(JSONPATH '$.a');

-- Test 2: query (line 7)
SELECT '$.a'::JSONPATH;

-- Test 3: statement (line 12)
CREATE TABLE a (j JSONPATH);

-- Test 4: statement (line 15)
\set ON_ERROR_STOP 0
CREATE TABLE a (j JSONPATH[]);
\set ON_ERROR_STOP 1

-- Test 5: statement (line 18)
CREATE TYPE typ AS (j JSONPATH);

-- Test 6: query (line 21)
SELECT '$'::JSONPATH;

-- Test 7: query (line 26)
SELECT 'strict $'::JSONPATH;

-- Test 8: query (line 32)
SELECT 'sTrict $'::JSONPATH;

-- Test 9: query (line 37)
SELECT 'lax $'::JSONPATH;

-- Test 10: query (line 43)
SELECT 'LaX $'::JSONPATH;

-- Test 11: query (line 48)
SELECT '$.a1[*]'::JSONPATH;

-- Test 12: query (line 53)
SELECT '$'::JSONPATH IS NULL;

-- Test 13: query (line 58)
SELECT '$'::JSONPATH IS NOT NULL;

-- Test 14: statement (line 63)
SELECT ('$'::JSONPATH)::text IS NOT DISTINCT FROM ('$'::JSONPATH)::text;

-- Test 15: statement (line 66)
SELECT ('$'::JSONPATH)::text IS DISTINCT FROM ('$'::JSONPATH)::text;

-- Test 16: query (line 69)
SELECT ('$'::JSONPATH)::text IS NOT DISTINCT FROM NULL;

-- Test 17: query (line 74)
SELECT ('$'::JSONPATH)::text IS DISTINCT FROM NULL;

-- Test 18: statement (line 79)
\set ON_ERROR_STOP 0
SELECT ''::JSONPATH;
\set ON_ERROR_STOP 1

-- Test 19: statement (line 82)
\set ON_ERROR_STOP 0
SELECT '$.1a[*]'::JSONPATH;
\set ON_ERROR_STOP 1

-- Test 20: query (line 85)
SELECT '$.abc[*].DEF.ghi[*]'::JSONPATH;

-- Test 21: query (line 90)
SELECT '$.ABC[*].DEF.GHI[*]'::JSONPATH;

-- Test 22: statement (line 95)
SELECT '$'::JSONPATH AS col ORDER BY ('$'::JSONPATH)::text DESC NULLS FIRST;

-- Test 23: statement (line 98)
SELECT '$'::JSONPATH AS col ORDER BY ('$'::JSONPATH)::text ASC;

-- Test 24: statement (line 101)
CREATE TABLE t (k INT PRIMARY KEY);

-- Test 25: statement (line 104)
INSERT INTO t VALUES (0);

-- Test 26: query (line 107)
SELECT bpchar('$."a1"[*]'::JSONPATH::JSONPATH)::BPCHAR FROM t ORDER BY 1 NULLS LAST;

-- Test 27: query (line 112)
SELECT bpchar('$.   abc    [*]'::JSONPATH::JSONPATH)::BPCHAR FROM t ORDER BY 1 NULLS LAST;

-- Test 28: query (line 117)
SELECT '$.a[*] ? (@.b == 1 && @.c != 1)'::JSONPATH;

-- Test 29: query (line 122)
SELECT '$.a[*] ? (@.b != 1)'::JSONPATH;

-- Test 30: query (line 127)
SELECT '$.a[*] ? (@.b < 1)'::JSONPATH;

-- Test 31: query (line 132)
SELECT '$.a[*] ? (@.b <= 1)'::JSONPATH;

-- Test 32: query (line 137)
SELECT '$.a[*] ? (@.b > 1)'::JSONPATH;

-- Test 33: query (line 142)
SELECT '$.a[*] ? (@.b >= 1)'::JSONPATH;

-- Test 34: query (line 147)
SELECT '$.a ? ($.b == 1)'::JSONPATH;

-- Test 35: query (line 152)
SELECT '$.a ? (@.b == 1).c ? (@.d == 2)'::JSONPATH;

-- Test 36: query (line 157)
SELECT '$.a?(@.b==1).c?(@.d==2)'::JSONPATH;

-- Test 37: query (line 162)
SELECT '$  .  a  ?  (  @  .  b  ==  1  )  .  c  ?  (  @  .  d  ==  2  )  '::JSONPATH;

-- Test 38: statement (line 167)
\set ON_ERROR_STOP 0
SELECT '$ ? (@ like_regex "(invalid pattern")'::JSONPATH;
\set ON_ERROR_STOP 1

-- Test 39: statement (line 170)
\set ON_ERROR_STOP 0
SELECT 'last'::JSONPATH;
\set ON_ERROR_STOP 1

-- Test 40: statement (line 173)
\set ON_ERROR_STOP 0
SELECT '@'::JSONPATH;
\set ON_ERROR_STOP 1

-- Test 41: statement (line 176)
SELECT '$.keyvalue()'::JSONPATH;

-- Test 42: statement (line 179)
\set ON_ERROR_STOP 0
SELECT '$.bigint()'::JSONPATH;
\set ON_ERROR_STOP 1

-- Test 43: statement (line 182)
\set ON_ERROR_STOP 0
SELECT '$.boolean()'::JSONPATH;
\set ON_ERROR_STOP 1

-- Test 44: statement (line 185)
\set ON_ERROR_STOP 0
SELECT '$.date()'::JSONPATH;
\set ON_ERROR_STOP 1

-- Test 45: statement (line 188)
\set ON_ERROR_STOP 0
SELECT '$.double()'::JSONPATH;
\set ON_ERROR_STOP 1

-- Test 46: statement (line 191)
\set ON_ERROR_STOP 0
SELECT '$.integer()'::JSONPATH;
\set ON_ERROR_STOP 1

-- Test 47: statement (line 194)
\set ON_ERROR_STOP 0
SELECT '$.number()'::JSONPATH;
\set ON_ERROR_STOP 1

-- Test 48: statement (line 197)
\set ON_ERROR_STOP 0
SELECT '$.string()'::JSONPATH;
\set ON_ERROR_STOP 1

-- Test 49: statement (line 200)
SELECT '$.**'::JSONPATH;

-- Test 50: statement (line 203)
\set ON_ERROR_STOP 0
SELECT '$.decimal()'::JSONPATH;
\set ON_ERROR_STOP 1

-- Test 51: statement (line 206)
\set ON_ERROR_STOP 0
SELECT '$.datetime()'::JSONPATH;
\set ON_ERROR_STOP 1

-- Test 52: statement (line 209)
\set ON_ERROR_STOP 0
SELECT '$.time()'::JSONPATH;
\set ON_ERROR_STOP 1

-- Test 53: statement (line 212)
\set ON_ERROR_STOP 0
SELECT '$.time_tz()'::JSONPATH;
\set ON_ERROR_STOP 1

-- Test 54: statement (line 215)
\set ON_ERROR_STOP 0
SELECT '$.timestamp()'::JSONPATH;
\set ON_ERROR_STOP 1

-- Test 55: statement (line 218)
\set ON_ERROR_STOP 0
SELECT '$.timestamp_tz()'::JSONPATH;
\set ON_ERROR_STOP 1

-- Test 56: query (line 221)
SELECT '$.*'::JSONPATH;

-- Test 57: query (line 228)
SELECT 'strIct $.STRIcT'::JSONPATH;
