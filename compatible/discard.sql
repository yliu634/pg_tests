-- PostgreSQL compatible tests from discard
-- 72 tests

SET client_min_messages = warning;
DROP SEQUENCE IF EXISTS discard_seq_test CASCADE;
DROP SEQUENCE IF EXISTS discard_seq_test_2 CASCADE;
DROP SEQUENCE IF EXISTS S2 CASCADE;
DROP SEQUENCE IF EXISTS discard_seq CASCADE;
DROP SEQUENCE IF EXISTS discard_seq2 CASCADE;
RESET client_min_messages;

-- Test 1: statement (line 2)
SET SEARCH_PATH = foo;

-- Test 2: query (line 5)
SHOW SEARCH_PATH;

-- Test 3: statement (line 10)
DISCARD ALL;

-- Test 4: query (line 13)
SHOW SEARCH_PATH;

-- Test 5: query (line 18)
SET timezone = 'Europe/Amsterdam'; SHOW TIMEZONE;

-- Test 6: statement (line 23)
DISCARD ALL;

-- Test 7: query (line 26)
SHOW TIMEZONE;

-- Test 8: query (line 31)
SET TIME ZONE 'Europe/Amsterdam'; SHOW TIME ZONE;

-- Test 9: statement (line 36)
DISCARD ALL;

-- Test 10: query (line 39)
SHOW TIME ZONE;

-- Test 11: statement (line 44)
PREPARE a AS SELECT 1;

-- Test 12: statement (line 47)
DISCARD ALL;

-- Test 13: statement (line 50)
DEALLOCATE a;

-- Test 14: statement (line 53)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- Test 15: statement (line 56)
-- SET LOCAL autocommit_before_ddl=off;

-- Test 16: statement (line 59)
DISCARD ALL;

-- Test 17: statement (line 62)
ROLLBACK;

-- Test 18: statement (line 65)
CREATE SEQUENCE discard_seq_test START WITH 10;

-- Test 19: query (line 68)
SELECT nextval('discard_seq_test');

-- Test 20: query (line 73)
SELECT lastval();

-- Test 21: query (line 78)
SELECT currval('discard_seq_test');

-- Test 22: statement (line 83)
DISCARD SEQUENCES;

-- Test 23: statement (line 86)
SELECT lastval();

-- Test 24: statement (line 89)
SELECT currval('discard_seq_test');

-- Test 25: statement (line 92)
CREATE SEQUENCE discard_seq_test_2 START WITH 10;

-- Test 26: query (line 95)
SELECT nextval('discard_seq_test_2');

-- Test 27: statement (line 100)
DISCARD ALL;

-- Test 28: statement (line 103)
SELECT lastval();

-- Test 29: statement (line 106)
-- CREATE SEQUENCE S2 PER SESSION CACHE 10;
CREATE SEQUENCE S2 CACHE 10;

-- Test 30: query (line 109)
SELECT nextval('s2');

-- Test 31: statement (line 114)
DISCARD SEQUENCES;

-- Test 32: query (line 117)
SELECT nextval('s2');

-- Test 33: query (line 125)
-- SELECT count(*) FROM [SHOW SCHEMAS] WHERE schema_name LIKE 'pg_temp_%';
SELECT count(*) FROM information_schema.schemata WHERE schema_name LIKE 'pg_temp_%';

-- Test 34: statement (line 130)
DISCARD TEMP;

-- Test 35: query (line 133)
-- SELECT count(*) FROM [SHOW SCHEMAS] WHERE schema_name LIKE 'pg_temp_%';
SELECT count(*) FROM information_schema.schemata WHERE schema_name LIKE 'pg_temp_%';

-- Test 36: statement (line 138)
CREATE TEMP TABLE test (a int);

-- Test 37: statement (line 141)
CREATE TEMP TABLE test2 (a uuid);

-- Test 38: query (line 144)
-- SELECT table_name FROM [SHOW TABLES FROM pg_temp];
SELECT table_name FROM information_schema.tables WHERE table_schema LIKE 'pg_temp_%';

-- Test 39: statement (line 150)
DISCARD TEMP;

-- Test 40: query (line 153)
-- SELECT table_name FROM [SHOW TABLES FROM pg_temp];
SELECT table_name FROM information_schema.tables WHERE table_schema LIKE 'pg_temp_%';

-- Test 41: query (line 158)
-- SELECT count(*) FROM [SHOW SCHEMAS] WHERE schema_name LIKE 'pg_temp_%';
SELECT count(*) FROM information_schema.schemata WHERE schema_name LIKE 'pg_temp_%';

-- Test 42: statement (line 163)
UNLISTEN temp;

-- Test 43: query (line 168)
SET search_path = bar, public; SHOW search_path;

-- Test 44: query (line 173)
SET timezone = 'Europe/Amsterdam'; SHOW timezone;

-- Test 45: statement (line 178)
PREPARE a AS SELECT 1;

-- Test 46: statement (line 181)
CREATE SEQUENCE discard_seq START WITH 10;

-- Test 47: statement (line 184)
CREATE TEMP TABLE tempy (a int);

-- Test 48: query (line 187)
-- SELECT table_name FROM [SHOW TABLES FROM pg_temp];
SELECT table_name FROM information_schema.tables WHERE table_schema LIKE 'pg_temp_%';

-- Test 49: statement (line 192)
SET default_transaction_read_only = on;

-- Test 50: statement (line 195)
DROP TABLE tempy;

-- Test 51: statement (line 199)
DISCARD ALL;

-- Test 52: query (line 203)
SHOW default_transaction_read_only;

-- Test 53: query (line 208)
SHOW search_path;

-- Test 54: query (line 213)
SHOW timezone;

-- Test 55: statement (line 218)
DEALLOCATE a;

-- Test 56: statement (line 221)
SELECT currval('discard_seq');

-- Test 57: query (line 224)
-- SELECT table_name FROM [SHOW TABLES FROM pg_temp];
SELECT table_name FROM information_schema.tables WHERE table_schema LIKE 'pg_temp_%';

-- Test 58: query (line 230)
SET search_path = bar, public; SHOW search_path;

-- Test 59: query (line 235)
SET timezone = 'Europe/Amsterdam'; SHOW timezone;

-- Test 60: statement (line 240)
PREPARE a AS SELECT 1;

-- Test 61: statement (line 243)
CREATE SEQUENCE discard_seq2 START WITH 10;

-- Test 62: statement (line 249)
CREATE TEMP TABLE tempy (a int);

-- Test 63: query (line 252)
-- SELECT table_name FROM [SHOW TABLES FROM pg_temp];
SELECT table_name FROM information_schema.tables WHERE table_schema LIKE 'pg_temp_%';

-- Test 64: query (line 259)
SELECT pg_sleep(5);

-- Test 65: statement (line 264)
-- SET default_transaction_use_follower_reads = on;

-- Test 66: statement (line 268)
DISCARD ALL;

-- Test 67: query (line 272)
-- SHOW default_transaction_use_follower_reads;

-- Test 68: query (line 277)
SHOW search_path;

-- Test 69: query (line 282)
SHOW timezone;

-- Test 70: statement (line 287)
DEALLOCATE a;

-- Test 71: statement (line 290)
SELECT currval('discard_seq2');

-- Test 72: query (line 293)
-- SELECT table_name FROM [SHOW TABLES FROM pg_temp];
SELECT table_name FROM information_schema.tables WHERE table_schema LIKE 'pg_temp_%';
