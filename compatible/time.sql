-- PostgreSQL compatible tests from time
-- 97 tests

-- Test 1: query (line 6)
SELECT '12:00:00':::TIME;

-- Test 2: query (line 11)
SELECT '12:00:00.456':::TIME;

-- Test 3: query (line 16)
SELECT '00:00:00':::TIME;

-- Test 4: query (line 21)
SELECT '23:59:59.999999':::TIME;

-- Test 5: statement (line 36)
SELECT '124:00'::TIME;

-- Test 6: statement (line 39)
SELECT '24:00:01'::TIME;

-- Test 7: statement (line 42)
SELECT '24:00:00.001'::TIME;

-- Test 8: query (line 47)
SELECT '12:00:00-08:00':::TIME;

-- Test 9: query (line 52)
SELECT TIME '12:00:00';

-- Test 10: query (line 59)
SELECT '12:00:00'::TIME;

-- Test 11: query (line 69)
SELECT '12:00:00' COLLATE de::TIME;

-- Test 12: query (line 74)
SELECT '2017-01-01 12:00:00':::TIMESTAMP::TIME;

-- Test 13: query (line 79)
SELECT '2017-01-01 12:00:00-05':::TIMESTAMPTZ::TIME;

-- Test 14: query (line 84)
SELECT '12h':::INTERVAL::TIME;

-- Test 15: query (line 89)
SELECT '12:00:00':::TIME::INTERVAL;

-- Test 16: query (line 101)
SELECT '12:00:00':::TIME = '12:00:00':::TIME

-- Test 17: query (line 106)
SELECT '12:00:00':::TIME = '12:00:00.000000':::TIME

-- Test 18: query (line 111)
SELECT '12:00:00':::TIME = '12:00:00.000001':::TIME

-- Test 19: query (line 116)
SELECT '12:00:00':::TIME < '12:00:00.000001':::TIME

-- Test 20: query (line 121)
SELECT '12:00:00':::TIME < '12:00:00':::TIME

-- Test 21: query (line 126)
SELECT '12:00:00':::TIME < '11:59:59.999999':::TIME

-- Test 22: query (line 131)
SELECT '12:00:00':::TIME > '11:59:59.999999':::TIME

-- Test 23: query (line 136)
SELECT '12:00:00':::TIME > '12:00:00':::TIME

-- Test 24: query (line 141)
SELECT '12:00:00':::TIME > '12:00:00.000001':::TIME

-- Test 25: query (line 146)
SELECT '12:00:00':::TIME <= '12:00:00':::TIME

-- Test 26: query (line 151)
SELECT '12:00:00':::TIME >= '12:00:00':::TIME

-- Test 27: query (line 156)
SELECT '12:00:00':::TIME IN ('12:00:00');

-- Test 28: query (line 161)
SELECT '12:00:00':::TIME IN ('00:00:00');

-- Test 29: query (line 168)
SELECT '12:00:00':::TIME + '1s':::INTERVAL

-- Test 30: query (line 173)
SELECT '23:59:59':::TIME + '1s':::INTERVAL

-- Test 31: query (line 178)
SELECT '12:00:00':::TIME + '1d':::INTERVAL

-- Test 32: query (line 183)
SELECT '1s':::INTERVAL + '12:00:00':::TIME

-- Test 33: query (line 188)
SELECT '12:00:00':::TIME - '1s':::INTERVAL

-- Test 34: query (line 193)
SELECT '00:00:00':::TIME - '1s':::INTERVAL

-- Test 35: query (line 198)
SELECT '12:00:00':::TIME - '1d':::INTERVAL

-- Test 36: query (line 203)
SELECT '12:00:00':::TIME - '11:59:59':::TIME

-- Test 37: query (line 208)
SELECT '11:59:59':::TIME - '12:00:00':::TIME

-- Test 38: query (line 213)
SELECT '2017-01-01':::DATE + '12:00:00':::TIME

-- Test 39: query (line 218)
SELECT '12:00:00':::TIME + '2017-01-01':::DATE

-- Test 40: query (line 223)
SELECT '2017-01-01':::DATE - '12:00:00':::TIME

-- Test 41: statement (line 230)
CREATE TABLE times (t time PRIMARY KEY)

-- Test 42: statement (line 233)
INSERT INTO times VALUES
  ('00:00:00'),
  ('00:00:00.000001'),
  ('11:59:59.999999'),
  ('12:00:00'),
  ('12:00:00.000001'),
  ('23:59:59.999999')

-- Test 43: query (line 242)
SELECT * FROM times ORDER BY t

-- Test 44: statement (line 252)
CREATE TABLE arrays (times TIME[])

-- Test 45: statement (line 255)
INSERT INTO arrays VALUES
  (ARRAY[]),
  (ARRAY['00:00:00']),
  (ARRAY['00:00:00', '12:00:00.000001']),
  ('{13:00:00}'::TIME[])

-- Test 46: query (line 262)
SELECT * FROM arrays

-- Test 47: query (line 272)
SELECT date_trunc('hour', time '12:01:02.345678')

-- Test 48: query (line 277)
SELECT date_trunc('minute', time '12:01:02.345678')

-- Test 49: query (line 282)
SELECT date_trunc('second', time '12:01:02.345678')

-- Test 50: query (line 287)
SELECT date_trunc('millisecond', time '12:01:02.345678')

-- Test 51: query (line 292)
SELECT date_trunc('microsecond', time '12:01:02.345678')

-- Test 52: query (line 297)
SELECT date_trunc('day', time '12:01:02.345')

query R
SELECT extract(hour from time '12:01:02.345678')

-- Test 53: query (line 305)
SELECT extract(minute from time '12:01:02.345678')

-- Test 54: query (line 310)
SELECT extract(second from time '12:01:02.345678')

-- Test 55: query (line 315)
SELECT extract(millisecond from time '12:01:02.345678')

-- Test 56: query (line 320)
SELECT extract(microsecond from time '12:01:02.345678')

-- Test 57: query (line 325)
SELECT extract(epoch from time '12:00:00')

-- Test 58: query (line 330)
SELECT extract(day from time '12:00:00')

query R
SELECT extract('microsecond' from time '12:01:02.345678')

-- Test 59: query (line 338)
SELECT extract('EPOCH' from time '12:00:00')

-- Test 60: query (line 343)
SELECT extract('day' from time '12:00:00')

query error pgcode 22023 unsupported timespan: day
SELECT extract('DAY' from time '12:00:00')

subtest precision_tests

query error precision 7 out of range
select '1:00:00.001':::TIME(7)

statement ok
CREATE TABLE time_precision_test (
  id integer PRIMARY KEY,
  t TIME(5)
)

statement ok
INSERT INTO time_precision_test VALUES
  (1,'12:00:00.123456+03:00'),
  (2,'12:00:00.12345+03:00'),
  (3,'12:00:00.1234+03:00'),
  (4,'12:00:00.123+03:00'),
  (5,'12:00:00.12+03:00'),
  (6,'12:00:00.1+03:00'),
  (7,'12:00:00+03:00')

query IT
SELECT * FROM time_precision_test ORDER BY id ASC

-- Test 61: query (line 381)
select column_name, data_type FROM [SHOW COLUMNS FROM time_precision_test] ORDER BY column_name

-- Test 62: statement (line 387)
ALTER TABLE time_precision_test ALTER COLUMN t TYPE time(6)

-- Test 63: statement (line 390)
INSERT INTO time_precision_test VALUES
  (100,'12:00:00.123456+03:00')

-- Test 64: query (line 394)
SELECT * FROM time_precision_test ORDER BY id ASC

-- Test 65: query (line 406)
select column_name, data_type FROM [SHOW COLUMNS FROM time_precision_test] ORDER BY column_name

-- Test 66: query (line 414)
select localtime(3) - localtime <= '1ms'::interval

-- Test 67: query (line 419)
select pg_typeof(localtime), pg_typeof(current_time), pg_typeof(localtime(3)), pg_typeof(current_time(3))

-- Test 68: query (line 432)
SELECT '2001-01-01 01:24:00'::time

-- Test 69: statement (line 439)
CREATE TABLE current_time_test (
  id INTEGER PRIMARY KEY,
  a TIME(3) DEFAULT CURRENT_TIME,
  b TIME DEFAULT CURRENT_TIME
)

-- Test 70: statement (line 446)
INSERT INTO current_time_test (id) VALUES (1)

-- Test 71: statement (line 449)
INSERT INTO current_time_test (id, a, b) VALUES
  (2, current_time, current_time),
  (3, current_time, current_time(3)),
  (4, localtime, localtime(3))

-- Test 72: statement (line 463)
set time zone +3

-- Test 73: statement (line 466)
create table current_time_tzset_test (id integer, a time, b time)

-- Test 74: statement (line 469)
insert into current_time_tzset_test (id, a) values (1, current_time), (2, localtime)

-- Test 75: statement (line 472)
set time zone 0

-- Test 76: statement (line 475)
update current_time_tzset_test set b = current_time where id = 1

-- Test 77: statement (line 478)
update current_time_tzset_test set b = localtime where id = 2

-- Test 78: query (line 485)
select id from current_time_tzset_test WHERE
  ((a - b) BETWEEN interval '2hr 59m' and interval '3h') OR
  ((a - b) BETWEEN interval '-21hr -1m' and interval '-21hr')
ORDER BY id ASC

-- Test 79: statement (line 497)
CREATE TABLE regression_44774 (
  a time(3) DEFAULT '12:13:14.123456'
)

-- Test 80: statement (line 502)
INSERT INTO regression_44774 VALUES (default), ('19:21:57.261286')

-- Test 81: query (line 505)
SELECT a FROM regression_44774 ORDER BY a

-- Test 82: statement (line 511)
UPDATE regression_44774
SET a = '13:14:15.123456'::time + '1 sec'::interval
WHERE 1 = 1

-- Test 83: query (line 516)
SELECT a FROM regression_44774 ORDER BY a

-- Test 84: statement (line 522)
DROP TABLE regression_44774

-- Test 85: statement (line 527)
CREATE TABLE regression_46973 (a TIME UNIQUE)

-- Test 86: statement (line 530)
INSERT INTO regression_46973 VALUES ('23:59:59.999999'), ('24:00')

-- Test 87: query (line 533)
SELECT * FROM regression_46973 WHERE a != '23:59:59.999999'

-- Test 88: query (line 538)
SELECT * FROM regression_46973 WHERE a != '24:00'

-- Test 89: statement (line 543)
DROP TABLE regression_46973

-- Test 90: statement (line 548)
CREATE TABLE t88128 (t TIME)

-- Test 91: statement (line 551)
INSERT INTO t88128 VALUES ('20:00:00')

-- Test 92: query (line 557)
SELECT t - '05:00:00'::INTERVAL < '23:59:00'::TIME FROM t88128

-- Test 93: query (line 565)
SELECT t - '-2:00:00'::INTERVAL > '01:00:00'::TIME FROM t88128

-- Test 94: query (line 573)
SELECT t + '02:00:00'::INTERVAL > '01:00:00'::TIME FROM t88128

-- Test 95: query (line 581)
SELECT t + '-18:00:00'::INTERVAL < '07:00:00'::TIME FROM t88128

-- Test 96: query (line 590)
SELECT '00:01:40.01+09:00:00' < (col::TIMETZ + '-83 years -1 mons -38 days -10:32:23.707137')
FROM (VALUES ('03:16:01.252182+01:49:00')) v(col);

-- Test 97: query (line 596)
SELECT t::TIME + '-11 hrs'::INTERVAL > '01:00'::TIME
FROM (VALUES ('03:00')) v(t)

