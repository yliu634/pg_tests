-- PostgreSQL compatible tests from timestamp
-- 129 tests

-- Test 1: query (line 2)
SELECT '2000-05-05 10:00:00+03'::TIMESTAMP;

-- Test 2: statement (line 7)
CREATE TABLE a (a int); INSERT INTO a VALUES(1);

-- Test 3: query (line 13)
SELECT '2000-05-05 10:00:00+03'::TIMESTAMP FROM a;

-- Test 4: query (line 18)
select '2001-1-18 1:00:00.001-8'::TIMESTAMPTZ;

-- Test 5: statement (line 26)
SET TIME ZONE 'PST8PDT';

-- Test 6: query (line 29)
SELECT TIMESTAMP '2001-02-16 20:38:40' AT TIME ZONE 'MST', timezone('MST', TIMESTAMP '2001-02-16 20:38:40');

-- Test 7: query (line 34)
SELECT TIMESTAMP WITH TIME ZONE '2001-02-16 20:38:40-05' AT TIME ZONE 'MST', timezone('MST', TIMESTAMP WITH TIME ZONE '2001-02-16 20:38:40-05');

-- Test 8: query (line 39)
SELECT TIMESTAMP '2001-02-16 20:38:40' AT TIME ZONE 'MST', timezone('MST', TIMESTAMP '2001-02-16 20:38:40');

-- Test 9: query (line 47)
select '2001-1-18 1:00:00.001'::TIMESTAMP(7);

-- query error precision 7 out of range
select '2001-1-18 1:00:00.001'::TIMESTAMPTZ(7);

-- query T
select '2001-1-18 1:00:00.001'::TIMESTAMP(0);

-- Test 10: query (line 58)
select '2001-1-18 1:00:00.001'::TIMESTAMP(6);

-- Test 11: query (line 63)
select '2001-1-18 1:00:00.001'::TIMESTAMP;

-- Test 12: query (line 68)
select '2001-1-18 1:00:00.001-8'::TIMESTAMPTZ(0);

-- Test 13: query (line 73)
select '2001-1-18 1:00:00.001-8'::TIMESTAMPTZ(6);

-- Test 14: query (line 78)
select current_timestamp(3) - current_timestamp <= '1ms'::interval;

-- Test 15: statement (line 83)
CREATE TABLE timestamp_test (
  id integer PRIMARY KEY,
  t TIMESTAMP(5),
  ttz TIMESTAMPTZ(4)
);

-- Test 16: statement (line 90)
INSERT INTO timestamp_test VALUES
  (1, '2001-01-01 12:00:00.123456', '2001-01-01 12:00:00.123456+4'),
  (2, '2001-01-01 12:00:00.12345', '2001-01-01 12:00:00.12345+4'),
  (3, '2001-01-01 12:00:00.1234', '2001-01-01 12:00:00.1234+4'),
  (4, '2001-01-01 12:00:00.123', '2001-01-01 12:00:00.123+4'),
  (5, '2001-01-01 12:00:00.12', '2001-01-01 12:00:00.12+4'),
  (6, '2001-01-01 12:00:00.1', '2001-01-01 12:00:00.1+4'),
  (7, '2001-01-01 12:00:00', '2001-01-01 12:00:00+4');

-- Test 17: query (line 100)
SELECT * FROM timestamp_test ORDER BY id ASC;

-- Test 18: query (line 111)
select column_name, data_type FROM information_schema.columns WHERE table_schema = current_schema() AND table_name = 'timestamp_test' ORDER BY column_name;

-- Test 19: query (line 118)
SELECT id, t::timestamp(0), t::timestamp(3), ttz::timestamptz(0), ttz::timestamptz(3) FROM timestamp_test ORDER BY id;

-- Test 20: statement (line 130)
ALTER TABLE timestamp_test ALTER COLUMN t TYPE timestamp;

-- Test 21: statement (line 133)
ALTER TABLE timestamp_test ALTER COLUMN ttz TYPE timestamptz(5);

-- Test 22: statement (line 136)
INSERT INTO timestamp_test VALUES
  (100, '2001-01-01 12:00:00.123456', '2001-01-01 12:00:00.123456+4');

-- Test 23: query (line 140)
SELECT * FROM timestamp_test ORDER BY id ASC;

-- Test 24: query (line 152)
select column_name, data_type FROM information_schema.columns WHERE table_schema = current_schema() AND table_name = 'timestamp_test' ORDER BY column_name;

-- Test 25: statement (line 161)
SET TIME ZONE -5;

-- Test 26: query (line 164)
SELECT '2001-01-01'::date = '2001-01-01 00:00:00'::timestamp;

-- Test 27: query (line 169)
SELECT '2001-01-01'::date = '2001-01-01 00:00:00-5'::timestamptz;

-- Test 28: query (line 174)
SELECT '2001-01-01 00:00:00'::timestamp = '2001-01-01 01:00:00-4'::timestamptz;

-- Test 29: statement (line 181)
SET TIME ZONE -3;

-- Test 30: query (line 184)
SELECT extract(hour FROM '2001-01-01 13:00:00+01'::timestamptz);

-- Test 31: query (line 189)
SELECT extract(hour FROM '2001-01-01 13:00:00'::timestamp);

-- Test 32: query (line 194)
SELECT extract(timezone FROM '2001-01-01 13:00:00+01:15'::timestamptz);

-- Test 33: statement (line 199)
SET TIME ZONE +3;

-- Test 34: query (line 202)
SELECT extract(hour FROM '2001-01-01 13:00:00+01'::timestamptz);

-- Test 35: query (line 207)
SELECT extract(hour FROM '2001-01-01 13:00:00'::timestamp);

-- Test 36: query (line 212)
SELECT extract(timezone FROM '2001-01-01 13:00:00+01:15'::timestamptz);

-- Test 37: statement (line 219)
SET TIME ZONE 'GMT+1';

-- Test 38: query (line 222)
SELECT '2001-01-01 00:00:00'::TIMESTAMP::TIMESTAMPTZ;

-- Test 39: statement (line 227)
SET TIME ZONE '+1:00';

-- Test 40: query (line 230)
SELECT '2001-01-01 00:00:00'::TIMESTAMP::TIMESTAMPTZ;

-- Test 41: statement (line 239)
set time zone +3;

-- Test 42: statement (line 242)
create table current_timestamp_test (a timestamp, b timestamptz);

-- Test 43: statement (line 245)
insert into current_timestamp_test values (current_timestamp, current_timestamp);

-- Test 44: statement (line 248)
set time zone 0;

-- Test 45: query (line 253)
select * from current_timestamp_test WHERE a - interval '3h' <> b;

-- Test 46: query (line 259)
select pg_typeof(localtimestamp), pg_typeof(current_timestamp), pg_typeof(localtimestamp(3)), pg_typeof(current_timestamp(3));

-- Test 47: query (line 264)
select localtimestamp(3) - localtimestamp <= '1ms'::interval;

-- Test 48: statement (line 273)
SET TIME ZONE 'America/Chicago';

-- Test 49: query (line 276)
SELECT '1882-05-23T00:00:00-05:51'::timestamptz::text;

-- Test 50: query (line 281)
SELECT '2011-03-13'::date = '2011-03-13'::timestamp;

-- Test 51: query (line 286)
SELECT '2011-03-13'::date = '2011-03-13'::timestamptz;

-- Test 52: query (line 291)
SELECT '2011-03-13'::timestamp = '2011-03-13'::timestamptz;

-- Test 53: query (line 296)
SELECT '2011-03-14'::date = '2011-03-14'::timestamp;

-- Test 54: query (line 301)
SELECT '2011-03-14'::date = '2011-03-14'::timestamptz;

-- Test 55: query (line 306)
SELECT '2011-03-14'::timestamp = '2011-03-14'::timestamptz;

-- Test 56: statement (line 311)
SET TIME ZONE INTERVAL '-00:10:15';

-- Test 57: query (line 314)
SELECT '1882-05-23T00:00:00-05:51'::timestamptz::text;

-- Test 58: statement (line 319)
SET TIME ZONE 0;

-- Test 59: statement (line 325)
CREATE TABLE regression_44774 (
  a timestamp(3) DEFAULT '1970-02-03 12:13:14.123456',
  b timestamptz(3) DEFAULT '1970-02-03 12:13:14.123456'
);

-- Test 60: statement (line 331)
INSERT INTO regression_44774 VALUES (default, default), ('2020-02-05 19:21:57.261286', '2020-02-05 19:21:57.261286');

-- Test 61: query (line 334)
SELECT a, b FROM regression_44774 ORDER BY a;

-- Test 62: statement (line 340)
UPDATE regression_44774
SET a = '1970-03-04 13:14:15.123456'::timestamp + '1 sec'::interval, b = '1970-03-04 13:14:15.123456'::timestamptz + '1 sec'::interval
WHERE 1 = 1;

-- Test 63: query (line 345)
SELECT a, b FROM regression_44774 ORDER BY a;

-- Test 64: statement (line 351)
DROP TABLE regression_44774;

-- Test 65: statement (line 357)
SET TIME ZONE 'America/Chicago';

-- Test 66: query (line 360)
WITH a(a) AS ( VALUES
  ('2010-11-06 23:59:00'::timestamptz + '24 hours'::interval), -- no offset specified
  ('2010-11-06 23:59:00'::timestamptz + '1 day'::interval),
  ('2010-11-06 23:59:00'::timestamptz + '1 month'::interval),
  ('2010-11-07 23:59:00'::timestamptz - '24 hours'::interval),
  ('2010-11-07 23:59:00'::timestamptz - '1 day'::interval),
  ('2010-11-07 23:59:00'::timestamptz - '1 month'::interval),
  ('2010-11-06 23:59:00-05'::timestamptz + '24 hours'::interval), -- offset at time zone
  ('2010-11-06 23:59:00-05'::timestamptz + '1 day'::interval),
  ('2010-11-06 23:59:00-05'::timestamptz + '1 month'::interval),
  ('2010-11-07 23:59:00-06'::timestamptz - '24 hours'::interval),
  ('2010-11-07 23:59:00-06'::timestamptz - '1 day'::interval),
  ('2010-11-07 23:59:00-06'::timestamptz - '1 month'::interval),
  ('2010-11-06 23:59:00-04'::timestamptz + '24 hours'::interval), -- different offset
  ('2010-11-06 23:59:00-04'::timestamptz + '1 day'::interval),
  ('2010-11-06 23:59:00-04'::timestamptz + '1 month'::interval),
  ('2010-11-07 23:59:00-04'::timestamptz - '24 hours'::interval),
  ('2010-11-07 23:59:00-04'::timestamptz - '1 day'::interval),
  ('2010-11-07 23:59:00-04'::timestamptz - '1 month'::interval)
) select * from a;

-- Test 67: statement (line 401)
CREATE TABLE example (a timestamptz);

-- Test 68: statement (line 404)
INSERT INTO example VALUES
  ('2010-11-06 23:59:00'),
  ('2010-11-07 23:59:00');

-- Test 69: statement (line 422)
DROP TABLE example;

-- Test 70: statement (line 425)
SET TIME ZONE 0;

-- Test 71: statement (line 430)
CREATE TABLE regression_46973(c0 TIMESTAMP UNIQUE, c1 TIMESTAMPTZ UNIQUE);

-- Test 72: statement (line 433)
INSERT INTO regression_46973 VALUES ('1970-01-01 00:00:00', '1970-01-01 00:00:00');

-- Test 73: statement (line 436)
SELECT * FROM regression_46973 WHERE '-infinity'::TIMESTAMP!=regression_46973.c0;

-- Test 74: statement (line 439)
SELECT * FROM regression_46973 WHERE '-infinity'::TIMESTAMPTZ!=regression_46973.c1;

-- Test 75: statement (line 442)
SELECT '294276-12-31 23:59:59.999999'::TIMESTAMP(0);

-- Test 76: statement (line 445)
DROP TABLE regression_46973;

-- Test 77: query (line 450)
set time zone 'Europe/Berlin'; select extract(epoch from TIMESTAMP WITH TIME ZONE '2010-11-06 23:59:00-05:00');

-- Test 78: query (line 455)
set time zone 'UTC'; select extract(epoch from TIMESTAMP WITH TIME ZONE '2010-11-06 23:59:00-05:00');

-- Test 79: query (line 460)
SET TIME ZONE 'Europe/Berlin'; SELECT
  age(a::timestamptz, b::timestamptz),
  age(b::timestamptz, a::timestamptz),
  a::timestamptz - b::timestamptz,
  b::timestamptz - a::timestamptz,
  a::timestamp - b::timestamp,
  b::timestamp - a::timestamp
FROM (VALUES
  ('2020-05-06 11:12:13', '2015-06-07 13:14:15'),
  ('2020-05-06 15:00:00.112233', '2020-04-03 16:00:00.001122'),
  ('2020-02-29 00:02:05', '2019-02-28 18:19:01'),
  ('2020-02-29 00:02:05', '2020-01-28 18:19:01'),
  ('2020-02-29 00:02:05', '2020-03-28 18:19:01'),
  ('2021-02-27 00:02:05.333333', '2019-02-28 18:19:01.444444'),
  ('2021-02-27 00:02:05', '2021-01-28 18:19:01'),
  ('2021-02-27 00:02:05', '2021-03-28 18:19:01'),
  ('2020-02-28 00:02:05', '2020-02-28 18:19:01'),
  ('2020-06-30 11:11:11.111111', '2020-06-29 12:12:12.222222')
) regression_age_tests(a, b);

-- Test 80: query (line 492)
SET TIME ZONE 'AuStralIA/SyDNEY'; SELECT '2000-05-15 00:00:00'::timestamptz;

-- Test 81: query (line 497)
SET TIME ZONE 'Europe/Bucharest';
SELECT t FROM (VALUES
  ('2020-10-25 03:00+3'::TIMESTAMPTZ + '0 hour'::interval),
  ('2020-10-25 03:00+3'::TIMESTAMPTZ + '1 hour'::interval),
  ('2020-10-25 03:00+2'::TIMESTAMPTZ + '0 hour'::interval),
  ('2020-10-25 03:00+2'::TIMESTAMPTZ + '1 hour'::interval)
) interval_math_regression_64772(t);

-- Test 82: query (line 511)
SET TIME ZONE 'Europe/Bucharest';
SELECT date_trunc('day', t), date_trunc('hour', t) FROM (VALUES
  ('2020-10-25 03:00+03:00'::timestamptz),
  ('2020-10-25 03:00+02:00'::timestamptz)
) date_trunc_regression_64772(t);

-- Test 83: statement (line 523)
SET TIME ZONE 'UTC';

-- Test 84: query (line 527)
SELECT to_timestamp(1646906263.123456), to_timestamp(1646906263), to_timestamp('1646906263.123456');

-- Test 85: query (line 533)
SELECT to_timestamp('infinity'), to_timestamp('-infinity');

-- Test 86: query (line 539)
SELECT to_timestamp(NULL);

-- Test 87: statement (line 546)
CREATE TABLE t (t1 timestamptz, t2 timestamptz);
INSERT INTO t VALUES ('2022-01-01 00:00:00.000000+00:00', '2022-01-02 00:00:00.000000+00:00');

-- Test 88: query (line 550)
SELECT (t2 - t1) FROM t;

-- Test 89: statement (line 556)
CREATE TABLE TIMESTAMPTZ_TBL (id SERIAL, d1 timestamp(2) with time zone);
INSERT INTO TIMESTAMPTZ_TBL (d1) VALUES
  ('1997-06-10 17:32:01 -07:00'),
  ('2001-09-22T18:19:20');

-- Test 90: query (line 562)
SELECT to_char(d1, 'DAY Day day DY Dy dy MONTH Month month MON Mon mon')
   FROM TIMESTAMPTZ_TBL ORDER BY id;

-- Test 91: query (line 569)
SELECT to_char(d1, 'FMDAY FMDay FMday FMMONTH FMMonth FMmonth')
   FROM TIMESTAMPTZ_TBL ORDER BY id;

-- Test 92: query (line 576)
SELECT to_char(d1, 'Y,YYY YYYY YYY YY Y CC Q MM WW DDD DD D J')
   FROM TIMESTAMPTZ_TBL ORDER BY id;

-- Test 93: query (line 583)
SELECT to_char(d1, 'FMY,YYY FMYYYY FMYYY FMYY FMY FMCC FMQ FMMM FMWW FMDDD FMDD FMD FMJ')
   FROM TIMESTAMPTZ_TBL ORDER BY id;

-- Test 94: query (line 590)
SELECT to_char(d1::timestamp, 'FMY,YYY FMYYYY FMYYY FMYY FMY FMCC FMQ FMMM FMWW FMDDD FMDD FMD FMJ')
   FROM TIMESTAMPTZ_TBL ORDER BY id;

-- Test 95: query (line 597)
SELECT to_char(d1, 'HH HH12 HH24 MI SS SSSS')
   FROM TIMESTAMPTZ_TBL ORDER BY id;

-- Test 96: query (line 604)
SELECT to_char(d1, E'"HH:MI:SS is" HH:MI:SS "\\"text between quote marks\\""')
   FROM TIMESTAMPTZ_TBL ORDER BY id;

-- Test 97: query (line 611)
SELECT to_char(d1, 'HH24--text--MI--text--SS')
   FROM TIMESTAMPTZ_TBL ORDER BY id;

-- Test 98: query (line 618)
SELECT to_char(d1, 'YYYYTH YYYYth Jth')
   FROM TIMESTAMPTZ_TBL ORDER BY id;

-- Test 99: query (line 625)
SELECT to_char(d1, 'YYYY A.D. YYYY a.d. YYYY bc HH:MI:SS P.M. HH:MI:SS p.m. HH:MI:SS pm')
   FROM TIMESTAMPTZ_TBL ORDER BY id;

-- Test 100: query (line 632)
SELECT to_char(d1, 'IYYY IYY IY I IW IDDD ID')
   FROM TIMESTAMPTZ_TBL ORDER BY id;

-- Test 101: query (line 639)
SELECT to_char(d1, 'FMIYYY FMIYY FMIY FMI FMIW FMIDDD FMID')
   FROM TIMESTAMPTZ_TBL ORDER BY id;

-- Test 102: query (line 646)
SELECT to_char(d, 'FF1 FF2 FF3 FF4 FF5 FF6  ff1 ff2 ff3 ff4 ff5 ff6  MS US')
   FROM (VALUES
       ('2018-11-02 12:34:56'::timestamptz),
       ('2018-11-02 12:34:56.78'::timestamptz),
       ('2018-11-02 12:34:56.78901'::timestamptz),
       ('2018-11-02 12:34:56.78901234'::timestamptz)
   ) d(d);

-- Test 103: query (line 660)
SET timezone = '00:00';
SELECT ARRAY[
  '2018-11-02 12:34:56.78901234'::timestamptz,
  '2018-11-02 12:34:56.78901234-07'::timestamptz
];

-- Test 104: query (line 669)
SET timezone = 'Australia/Sydney';
SELECT ARRAY[
  '2018-11-02 12:34:56.78901234'::timestamptz,
  '2018-11-02 12:34:56.78901234-07'::timestamptz
];

-- Test 105: query (line 678)
SET timezone = '00:00';
SELECT to_char(now(), 'OF') as of_t, to_char(now(), 'TZH:TZM') as "TZH:TZM";

-- Test 106: query (line 684)
SET timezone = '+02:00';
SELECT to_char(now(), 'OF') as of_t, to_char(now(), 'TZH:TZM') as "TZH:TZM";

-- Test 107: query (line 690)
SET timezone = '-13:00';
SELECT to_char(now(), 'OF') as of_t, to_char(now(), 'TZH:TZM') as "TZH:TZM";

-- Test 108: query (line 696)
SET timezone = '-00:30';
SELECT to_char(now(), 'OF') as of_t, to_char(now(), 'TZH:TZM') as "TZH:TZM";

-- Test 109: query (line 702)
SET timezone = '00:30';
SELECT to_char(now(), 'OF') as of_t, to_char(now(), 'TZH:TZM') as "TZH:TZM";

-- Test 110: query (line 708)
SET timezone = '-04:30';
SELECT to_char(now(), 'OF') as of_t, to_char(now(), 'TZH:TZM') as "TZH:TZM";

-- Test 111: query (line 714)
SET timezone = '04:30';
SELECT to_char(now(), 'OF') as of_t, to_char(now(), 'TZH:TZM') as "TZH:TZM";

-- Test 112: query (line 720)
SET timezone = '-04:15';
SELECT to_char(now(), 'OF') as of_t, to_char(now(), 'TZH:TZM') as "TZH:TZM";

-- Test 113: query (line 726)
SET timezone = '04:15';
SELECT to_char(now(), 'OF') as of_t, to_char(now(), 'TZH:TZM') as "TZH:TZM";

-- Test 114: query (line 732)
RESET timezone;
-- Check of, tzh, tzm with various zone offsets.
SET timezone = '00:00';
SELECT to_char(now(), 'of') as of_t, to_char(now(), 'tzh:tzm') as "tzh:tzm";

-- Test 115: query (line 740)
SET timezone = '+02:00';
SELECT to_char(now(), 'of') as of_t, to_char(now(), 'tzh:tzm') as "tzh:tzm";

-- Test 116: query (line 746)
SET timezone = '-13:00';
SELECT to_char(now(), 'of') as of_t, to_char(now(), 'tzh:tzm') as "tzh:tzm";

-- Test 117: query (line 752)
SET timezone = '-00:30';
SELECT to_char(now(), 'of') as of_t, to_char(now(), 'tzh:tzm') as "tzh:tzm";

-- Test 118: query (line 758)
SET timezone = '00:30';
SELECT to_char(now(), 'of') as of_t, to_char(now(), 'tzh:tzm') as "tzh:tzm";

-- Test 119: query (line 764)
SET timezone = '-04:30';
SELECT to_char(now(), 'of') as of_t, to_char(now(), 'tzh:tzm') as "tzh:tzm";

-- Test 120: query (line 770)
SET timezone = '04:30';
SELECT to_char(now(), 'of') as of_t, to_char(now(), 'tzh:tzm') as "tzh:tzm";

-- Test 121: query (line 776)
SET timezone = '-04:15';
SELECT to_char(now(), 'of') as of_t, to_char(now(), 'tzh:tzm') as "tzh:tzm";

-- Test 122: query (line 782)
SET timezone = '04:15';
SELECT to_char(now(), 'of') as of_t, to_char(now(), 'tzh:tzm') as "tzh:tzm";

-- Test 123: query (line 791)
SELECT 'infinity'::TIMESTAMP;

-- Test 124: query (line 796)
SELECT '-infinity'::TIMESTAMP;

-- Test 125: query (line 802)
SELECT 'infinity'::timestamp > '294276-12-31 23:59:59.999999'::timestamp;

-- Test 126: query (line 808)
SELECT '-infinity'::timestamp < '4714-11-24 00:00:00+00 BC'::timestamp;

-- Test 127: query (line 814)
SELECT 'infinity'::timestamp = 'infinity'::timestamp, '-infinity'::timestamp = '-infinity'::timestamp;

-- Test 128: query (line 820)
SELECT 'infinity'::timestamp + '1 second'::interval, 'infinity'::timestamp - '1 second'::interval;

-- Test 129: query (line 826)
SELECT '-infinity'::timestamp + '1 second'::interval, '-infinity'::timestamp - '1 second'::interval;
