-- PostgreSQL compatible tests from set_local
-- 118 tests

-- Test 1: statement (line 3)
CREATE TABLE tbl (
  ttz TIMESTAMPTZ,
  ival INTERVAL
);
INSERT INTO tbl VALUES
  ('2020-08-25 15:16:17.123456', '1 day 15:16:17.123456'::interval);

-- Test 2: query (line 11)
SET LOCAL TIME ZONE '+6';

-- Test 3: query (line 16)
SELECT 1; SET LOCAL TIME ZONE '+6';

-- Test 4: statement (line 22)
BEGIN;
SET LOCAL TIME ZONE 'America/Los_Angeles';
SET IntervalStyle = 'iso_8601';

-- Test 5: query (line 27)
SHOW TIME ZONE;

-- Test 6: query (line 32)
SHOW INTERVALSTYLE;

-- Test 7: query (line 37)
SELECT * FROM tbl;

-- Test 8: statement (line 44)
ROLLBACK;

-- Test 9: query (line 47)
SHOW TIME ZONE;

-- Test 10: query (line 52)
SHOW INTERVALSTYLE;

-- Test 11: query (line 57)
SELECT * FROM tbl;

-- Test 12: statement (line 64)
BEGIN;

-- Test 13: query (line 67)
SHOW TIME ZONE;

-- Test 14: query (line 72)
SHOW INTERVALSTYLE;

-- Test 15: query (line 77)
SELECT * FROM tbl;

-- Test 16: statement (line 82)
SET LOCAL TIME ZONE 'America/New_York';
SET IntervalStyle = 'postgres';

-- Test 17: query (line 86)
SHOW TIME ZONE;

-- Test 18: query (line 91)
SHOW INTERVALSTYLE;

-- Test 19: query (line 96)
SELECT * FROM tbl;

-- Test 20: statement (line 101)
COMMIT;

-- Test 21: query (line 104)
SHOW TIME ZONE;

-- Test 22: query (line 109)
SHOW INTERVALSTYLE;

-- Test 23: query (line 114)
SELECT * FROM tbl;

-- Test 24: statement (line 120)
BEGIN;
SET LOCAL IntervalStyle = 'sql_standard';

-- Test 25: query (line 124)
SHOW INTERVALSTYLE;

-- Test 26: query (line 129)
SELECT * FROM tbl;

-- Test 27: statement (line 134)
-- Skipped: conversion placeholder (was intentionally invalid in the source test).

-- Test 28: statement (line 137)
SET LOCAL IntervalStyle = 'postgres';

-- Test 29: statement (line 140)
ROLLBACK;

-- Test 30: query (line 143)
SHOW INTERVALSTYLE;

-- Test 31: query (line 148)
SELECT * FROM tbl;

-- Test 32: statement (line 153)
BEGIN;
SET LOCAL IntervalStyle = 'sql_standard';

-- Test 33: query (line 157)
SHOW INTERVALSTYLE;

-- Test 34: query (line 162)
SELECT * FROM tbl;

-- Test 35: statement (line 167)
-- Skipped: conversion placeholder (was intentionally invalid in the source test).

-- Test 36: statement (line 170)
SET LOCAL IntervalStyle = 'postgres';

-- Test 37: statement (line 173)
COMMIT;

-- Test 38: query (line 176)
SHOW INTERVALSTYLE;

-- Test 39: query (line 181)
SELECT * FROM tbl;

-- Test 40: statement (line 189)
BEGIN;
SET LOCAL TIME ZONE -10;

-- Test 41: query (line 193)
SELECT * FROM tbl;

-- Test 42: statement (line 198)
SAVEPOINT s1;
SET LOCAL TIME ZONE -11;

-- Test 43: query (line 202)
SELECT * FROM tbl;

-- Test 44: statement (line 207)
SAVEPOINT s2;
SET INTERVALSTYLE = 'sql_standard';
SET LOCAL TIME ZONE -12;

-- Test 45: query (line 212)
SELECT * FROM tbl;

-- Test 46: statement (line 217)
COMMIT;

-- Test 47: query (line 220)
SELECT * FROM tbl;

-- Test 48: statement (line 225)
BEGIN;
SET LOCAL TIME ZONE -10;

-- Test 49: query (line 229)
SELECT * FROM tbl;

-- Test 50: statement (line 234)
SAVEPOINT s1;
SET LOCAL TIME ZONE -11;

-- Test 51: query (line 238)
SELECT * FROM tbl;

-- Test 52: statement (line 243)
SAVEPOINT s2;
SET INTERVALSTYLE = 'postgres';
SET LOCAL TIME ZONE -12;

-- Test 53: query (line 248)
SELECT * FROM tbl;

-- Test 54: statement (line 253)
ROLLBACK;

-- Test 55: query (line 256)
SELECT * FROM tbl;

-- Test 56: statement (line 263)
BEGIN;

-- Test 57: query (line 266)
SELECT * FROM tbl;

-- Test 58: statement (line 271)
SET LOCAL TIME ZONE -1;
SAVEPOINT s1;

-- Test 59: query (line 275)
SELECT * FROM tbl;

-- Test 60: statement (line 280)
SET LOCAL TIME ZONE -2;
SAVEPOINT s2;

-- Test 61: query (line 284)
SELECT * FROM tbl;

-- Test 62: statement (line 289)
SET INTERVALSTYLE = 'postgres';
SET LOCAL TIME ZONE -3;
SAVEPOINT s3;

-- Test 63: query (line 294)
SELECT * FROM tbl;

-- Test 64: statement (line 299)
ROLLBACK TO SAVEPOINT s3;

-- Test 65: query (line 302)
SELECT * FROM tbl;

-- Test 66: statement (line 307)
ROLLBACK TO SAVEPOINT s2;

-- Test 67: query (line 310)
SELECT * FROM tbl;

-- Test 68: statement (line 315)
ROLLBACK TO SAVEPOINT s1;

-- Test 69: query (line 318)
SELECT * FROM tbl;

-- Test 70: statement (line 323)
SET LOCAL TIME ZONE -2;
SAVEPOINT s2;
SET LOCAL TIME ZONE -3;
SAVEPOINT s3;

-- Test 71: query (line 329)
SELECT * FROM tbl;

-- Test 72: statement (line 334)
ROLLBACK TO SAVEPOINT s1;

-- Test 73: query (line 337)
SELECT * FROM tbl;

-- Test 74: statement (line 342)
COMMIT;

-- Test 75: query (line 345)
SELECT * FROM tbl;

-- Test 76: statement (line 352)
BEGIN;
SET LOCAL TIME ZONE -1; SAVEPOINT s1;
SET LOCAL TIME ZONE -2; SAVEPOINT s2;
SET LOCAL TIME ZONE -3; SAVEPOINT s3;

-- Test 77: query (line 358)
SELECT * FROM tbl;

-- Test 78: statement (line 363)
-- Skipped: conversion placeholder (was intentionally invalid in the source test).

-- Test 79: statement (line 366)
ROLLBACK TO SAVEPOINT s3;

-- Test 80: query (line 369)
SELECT * FROM tbl;

-- Test 81: statement (line 374)
-- Skipped: conversion placeholder (was intentionally invalid in the source test).

-- Test 82: statement (line 377)
ROLLBACK TO SAVEPOINT s1;

-- Test 83: query (line 380)
SELECT * FROM tbl;

-- Test 84: statement (line 385)
COMMIT;

-- Test 85: query (line 388)
SELECT * FROM tbl;

-- Test 86: statement (line 395)
BEGIN;
SET LOCAL TIME ZONE -1; SAVEPOINT s1;
SET LOCAL TIME ZONE -2; SAVEPOINT s2;
SET LOCAL TIME ZONE -3; SAVEPOINT s3;

-- Test 87: query (line 401)
SELECT * FROM tbl;

-- Test 88: statement (line 406)
RELEASE SAVEPOINT s1;

-- Test 89: query (line 409)
SELECT * FROM tbl;

-- Test 90: statement (line 414)
SET LOCAL TIME ZONE -1; SAVEPOINT s1;
SET LOCAL TIME ZONE -2; SAVEPOINT s2;
SET LOCAL TIME ZONE -3; SAVEPOINT s3;

-- Test 91: statement (line 419)
RELEASE SAVEPOINT s2;

-- Test 92: query (line 422)
SELECT * FROM tbl;

-- Test 93: statement (line 427)
ROLLBACK TO SAVEPOINT s1;

-- Test 94: query (line 430)
SELECT * FROM tbl;

-- Test 95: statement (line 435)
COMMIT;

-- Test 96: query (line 438)
SELECT * FROM tbl;

-- Test 97: statement (line 445)
BEGIN;
SET LOCAL application_name = 'my name is sasha fierce';

-- Test 98: query (line 449)
SHOW application_name;

-- Test 99: query (line 454)
-- Skipped: Cockroach-only view (`crdb_internal.node_sessions`).

-- Test 100: statement (line 460)
ROLLBACK;

-- Test 101: query (line 463)
SHOW application_name;

-- Test 102: query (line 468)
-- Skipped: Cockroach-only view (`crdb_internal.node_sessions`).

-- Test 103: statement (line 476)
-- Skipped: Postgres cannot `SET LOCAL database` / `SHOW DATABASE` like CockroachDB.
-- CREATE DATABASE alt_db;

-- Test 104: statement (line 479)
-- BEGIN;
-- SET LOCAL database = 'alt_db';

-- Test 105: query (line 483)
-- SHOW DATABASE;

-- Test 106: statement (line 488)
-- ROLLBACK;

-- Test 107: query (line 491)
-- SHOW DATABASE;

-- Test 108: statement (line 497)
BEGIN;
SAVEPOINT cockroach_restart;
SET LOCAL TIME ZONE -1;

-- Test 109: query (line 502)
SELECT * FROM tbl;

-- Test 110: statement (line 507)
RELEASE SAVEPOINT cockroach_restart;
COMMIT;

-- Test 111: query (line 511)
SELECT * FROM tbl;

-- Test 112: statement (line 517)
SET custom_option.local_setting = 'abc';
SET custom_option.session_setting = 'abc';

-- Test 113: statement (line 521)
BEGIN;
SET LOCAL custom_option.local_setting = 'def';
SET custom_option.session_setting = 'def';

-- Test 114: query (line 526)
SHOW custom_option.local_setting;

-- Test 115: query (line 531)
SHOW custom_option.session_setting;

-- Test 116: statement (line 536)
COMMIT;

-- Test 117: query (line 539)
SHOW custom_option.local_setting;

-- Test 118: query (line 544)
SHOW custom_option.session_setting;
