-- PostgreSQL compatible tests from interval
-- 112 tests

-- Test 1: statement (line 5)
CREATE TABLE interval_duration_type (
  id INTEGER PRIMARY KEY,
  regular INTERVAL,
  regular_precision INTERVAL(3),
  second INTERVAL SECOND,
  second_precision INTERVAL SECOND(3),
  minute INTERVAL MINUTE,
  minute_to_second_precision INTERVAL MINUTE TO SECOND(3)
);

-- Test 2: statement (line 16)
INSERT INTO interval_duration_type (id, regular, regular_precision, second, second_precision, minute, minute_to_second_precision) VALUES
  (1, '12:34:56.123456', '12:34:56.123456', '12:34:56.123456', '12:34:56.123456', '12:34:56.123456', '12:34:56.123456'),
  (2, '12:56.123456', '12:56.123456', '12:56.123456', '12:56.123456', '12:56.123456', '12:56.123456'),
  (3, '366 12:34:56.123456', '366 12:34:56.123456', '366 12:34:56.123456', '366 12:34:56.123456', '366 12:34:56.123456', '366 12:34:56.123456'),
  (4, '1-2 3.1', '1-2 3.1', '1-2 3.1', '1-2 3.1', '1-2 3.1', '1-2 3.1');

-- Test 3: query (line 23)
select * from interval_duration_type order by id asc;

-- Test 4: query (line 33)
SELECT extract(second from interval '10:55:01.456');

-- Test 5: query (line 38)
SELECT extract(minute from interval '10:55:01.456');

-- Test 6: query (line 43)
SELECT date_part('minute', interval '10:55:01.456');

-- Test 7: query (line 53)
SELECT interval '999' second;

-- Test 8: query (line 58)
SELECT interval '999' minute;

-- Test 9: query (line 63)
SELECT interval '999' hour;

-- Test 10: query (line 68)
SELECT interval '999' day;

-- Test 11: query (line 73)
SELECT interval '999' month;

-- Test 12: query (line 80)
SELECT interval '1' year;

-- Test 13: query (line 85)
SELECT interval '2' month;

-- Test 14: query (line 90)
SELECT interval '3' day;

-- Test 15: query (line 95)
SELECT interval '4' hour;

-- Test 16: query (line 100)
SELECT interval '5' minute;

-- Test 17: query (line 105)
SELECT interval '6' second;

-- Test 18: query (line 110)
SELECT interval '1' year to month;

-- Test 19: query (line 115)
SELECT interval '1-2' year to month;

-- Test 20: query (line 120)
SELECT interval '1 2' day to hour;

-- Test 21: query (line 125)
SELECT interval '1 2:03' day to hour;

-- Test 22: query (line 130)
SELECT interval '1 2:03:04' day to hour;

-- Test 23: query (line 135)
SELECT interval '1 2:00' day to minute;

-- query T
SELECT interval '1 2:03' day to minute;

-- Test 24: query (line 143)
SELECT interval '1 2:03:04' day to minute;

-- Test 25: query (line 148)
SELECT interval '1 2:00' day to second;

-- query T
SELECT interval '1 2:03' day to second;

-- Test 26: query (line 156)
SELECT interval '1 2:03:04' day to second;

-- Test 27: query (line 161)
SELECT interval '1 2:00' hour to minute;

-- query T
SELECT interval '1 2:03' hour to minute;

-- Test 28: query (line 169)
SELECT interval '1 2:03:04' hour to minute;

-- Test 29: query (line 174)
SELECT interval '1 2:00' hour to second;

-- query T
SELECT interval '1 2:03' hour to second;

-- Test 30: query (line 182)
SELECT interval '1 2:03:04' hour to second;

-- Test 31: query (line 187)
SELECT interval '1 2:00' minute to second;

-- query T
SELECT interval '1 2:03' minute to second;

-- Test 32: query (line 195)
SELECT interval '1 2:03:04' minute to second;

-- Test 33: query (line 200)
SELECT interval '1 +2:03' minute to second;

-- Test 34: query (line 205)
SELECT interval '1 +2:03:04' minute to second;

-- Test 35: query (line 210)
SELECT interval '1 -2:03' minute to second;

-- Test 36: query (line 215)
SELECT interval '1 -2:03:04' minute to second;

-- Test 37: query (line 220)
SELECT interval '123 11' day to hour;

-- Test 38: query (line 225)
SELECT interval '123' day;

-- query error could not parse "123 11" as type interval
-- SELECT interval '123 11';

-- not ok, redundant hh:mm fields
-- query error could not parse "123 2:03 -2:04" as type interval
-- SELECT interval '123 2:03 -2:04';

-- test syntaxes for restricted precision
-- query T
SELECT interval(0) '1 day 01:23:45.6789';

-- Test 39: query (line 241)
SELECT interval(2) '1 day 01:23:45.6789';

-- Test 40: query (line 246)
SELECT interval '12:34.5678' minute to second(2);

-- Test 41: query (line 251)
SELECT interval '1.234' second;

-- Test 42: query (line 256)
SELECT interval '1.234' second(2);

-- Test 43: query (line 261)
SELECT interval '1 00:00:02.345' day to second(2);

-- query T
SELECT interval '1 2:03' day to second(2);

-- Test 44: query (line 269)
SELECT interval '1 2:03.4567' day to second(2);

-- Test 45: query (line 274)
SELECT interval '1 2:03:04.5678' day to second(2);

-- Test 46: query (line 279)
SELECT interval '1:00:02.345' hour to second(2);

-- query T
SELECT interval '1 2:03.45678' hour to second(2);

-- Test 47: query (line 287)
SELECT interval '1 2:03:04.5678' hour to second(2);

-- Test 48: query (line 292)
SELECT interval '1:02.3456' minute to second(2);

-- query T
SELECT interval '1 2:03.5678' minute to second(2);

-- Test 49: query (line 300)
SELECT interval '1 2:03:04.5678' minute to second(2);

-- Test 50: query (line 308)
SELECT interval '1:02.123456';

-- Test 51: query (line 313)
SELECT interval '-1:02.123456';

-- Test 52: query (line 320)
SELECT interval '1-2 3' year;

-- Test 53: query (line 325)
SELECT interval '1-2 3' day;

-- Test 54: query (line 330)
SELECT interval '2.1 00:';

-- Test 55: query (line 335)
SELECT interval ' 5  ' year;

-- Test 56: statement (line 343)
CREATE TABLE regression_44774 (
  a interval(3) DEFAULT '1:2:3.123456'
);

-- Test 57: statement (line 348)
INSERT INTO regression_44774 VALUES (default), ('4:5:6.123456');

-- Test 58: query (line 351)
SELECT a FROM regression_44774 ORDER BY a;

-- Test 59: statement (line 357)
UPDATE regression_44774
SET a = '13:14:15.123456'::interval + '1 sec'::interval
WHERE 1 = 1;

-- Test 60: query (line 362)
SELECT a FROM regression_44774 ORDER BY a;

-- Test 61: statement (line 368)
DROP TABLE regression_44774;

-- Test 62: query (line 374)
-- SELECT INTERVAL '10000000000000000000000000000000000 year';

-- query T nosort
SELECT i / 2 FROM ( VALUES
  ('0 days 0.253000 seconds'::interval),
  (INTERVAL '0.000001'::interval),
  (INTERVAL '0.000002'::interval),
  (INTERVAL '0.000003'::interval),
  (INTERVAL '0.000004'::interval),
  (INTERVAL '0.000005'::interval),
  (INTERVAL '0.000006'::interval),
  (INTERVAL '0.000007'::interval),
  (INTERVAL '0.000008'::interval),
  (INTERVAL '0.000009'::interval)
) regression_66118(i);

-- Test 63: statement (line 404)
SET intervalstyle = 'iso_8601';

-- Test 64: statement (line 407)
SET intervalstyle = 'sql_standard';

-- Test 65: statement (line 410)
SET intervalstyle = DEFAULT;

-- Test 66: statement (line 423)
create table intervals ( pk INT PRIMARY KEY, i INTERVAL );

-- Test 67: statement (line 426)
INSERT INTO intervals VALUES
  (1, '-2 years -11 mons 1 days 04:05:06.123'),
  (2, '1 day 04:06:08.123'),
  (3, '2 years 11 mons -2 days +03:25:45.678');

-- Test 68: query (line 432)
SELECT '-2 years 11 months 1 day 01:02:03'::interval;

-- Test 69: statement (line 437)
create table interval_parsing ( pk INT PRIMARY KEY, i TEXT );

-- Test 70: statement (line 440)
INSERT INTO interval_parsing VALUES
  (1, '-10 years 22 months 1 day 01:02:03'),
  (2, '-10 years -22 months 1 day 01:02:03'),
  (3, '-10 years 22 months -1 day 01:02:03'),
  (4, '-10 years 22 months -1 day -01:02:03');

-- Test 71: query (line 447)
SELECT i FROM intervals ORDER BY pk;

-- Test 72: query (line 454)
-- CockroachDB includes helper functions like `to_char_with_style` and `parse_interval`.
-- In PostgreSQL, the closest equivalent is to set `intervalstyle` and render with `::text`.
SET intervalstyle = 'postgres';
SELECT i::text AS pg FROM intervals ORDER BY pk;
SET intervalstyle = 'iso_8601';
SELECT i::text AS iso FROM intervals ORDER BY pk;
SET intervalstyle = 'sql_standard';
SELECT i::text AS sql_std FROM intervals ORDER BY pk;
RESET intervalstyle;

-- Test 73: query (line 481)
SELECT array_to_string(array_agg(i ORDER BY pk), ' ') FROM intervals;

-- Test 74: query (line 498)
SELECT ROW(i) FROM intervals ORDER BY pk;

-- Test 75: query (line 505)
SELECT row_to_json(intervals) FROM intervals ORDER BY pk;

-- Test 76: query (line 512)
SELECT i, i::INTERVAL FROM interval_parsing ORDER BY pk;

-- Test 77: statement (line 520)
SET intervalstyle = 'iso_8601';

-- Test 78: query (line 523)
SELECT '-2 years 11 months 1 day 01:02:03'::interval;

-- Test 79: query (line 528)
SELECT i FROM intervals ORDER BY pk;

-- Test 80: query (line 535)
SELECT array_to_string(array_agg(i ORDER BY pk), ' ') FROM intervals;

-- Test 81: query (line 552)
SELECT ROW(i) FROM intervals ORDER BY pk;

-- Test 82: query (line 559)
SELECT row_to_json(intervals) FROM intervals ORDER BY pk;

-- Test 83: query (line 566)
SELECT i, i::INTERVAL FROM interval_parsing ORDER BY pk;

-- Test 84: statement (line 574)
SET intervalstyle = 'sql_standard';

-- Test 85: query (line 577)
SELECT '-2 years 11 months 1 day 01:02:03'::interval;

-- Test 86: query (line 582)
SELECT i FROM intervals ORDER BY pk;

-- Test 87: query (line 589)
SELECT array_to_string(array_agg(i ORDER BY pk), ' ') FROM intervals;

-- Test 88: query (line 606)
SELECT ROW(i) FROM intervals ORDER BY pk;

-- Test 89: query (line 613)
SELECT row_to_json(intervals) FROM intervals ORDER BY pk;

-- Test 90: query (line 620)
SELECT i, i::INTERVAL FROM interval_parsing ORDER BY pk;

-- Test 91: statement (line 629)
CREATE TABLE intvl_tbl (id SERIAL, d1 INTERVAL);
INSERT INTO intvl_tbl (d1) VALUES
  ('355 months 40 days 123:45:12'),
  ('-400 months -30 days -100:12:13');

-- Test 92: query (line 635)
SELECT to_char(d1, 'Y,YYY YYYY YYY YY Y CC Q MM WW DDD DD J')
   FROM intvl_tbl ORDER BY id;

-- Test 93: query (line 642)
SELECT to_char(d1, 'FMY,YYY FMYYYY FMYYY FMYY FMY FMCC FMQ FMMM FMWW FMDDD FMDD FMJ')
   FROM intvl_tbl ORDER BY id;

-- Test 94: query (line 649)
SELECT to_char(d1, 'HH HH12 HH24 MI SS SSSS')
   FROM intvl_tbl ORDER BY id;

-- Test 95: query (line 656)
SELECT to_char(d1, E'"HH:MI:SS is" HH:MI:SS "\\"text between quote marks\\""')
   FROM intvl_tbl ORDER BY id;

-- Test 96: query (line 663)
SELECT to_char(d1, 'HH24--text--MI--text--SS')
   FROM intvl_tbl ORDER BY id;

-- Test 97: query (line 670)
SELECT to_char(d1, 'YYYYTH YYYYth Jth')
   FROM intvl_tbl ORDER BY id;

-- Test 98: statement (line 679)
CREATE TABLE intervalstyle_in_index (
  a INT8 PRIMARY KEY,
  b INTERVAL
);
CREATE INDEX idx ON intervalstyle_in_index (b) WHERE b > interval 'P3Y';

-- Test 99: query (line 685)
SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename = 'intervalstyle_in_index'
AND indexname = 'idx';

-- Test 100: statement (line 693)
SET intervalstyle = 'iso_8601';

-- Test 101: query (line 696)
SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename = 'intervalstyle_in_index'
AND indexname = 'idx';

-- Test 102: statement (line 705)
SET intervalstyle = 'postgres';

-- Test 103: statement (line 708)
-- SELECT date_trunc('invalid', interval '1 month');

-- Test 104: statement (line 711)
-- SELECT date_trunc('week', interval '1 month');

-- Test 105: statement (line 714)
-- SELECT date_trunc('weeks', interval '1 month');

-- Test 106: query (line 717)
SELECT timespan, date_trunc(timespan, interval '1111 year 4 month 1 day 1 hour 1 minute 1 second 1 millisecond 1 microsecond')
FROM (VALUES
  ('millennia'),
  ('millennium'),
  ('millenniums'),
  ('century'),
  ('centuries'),
  ('decade'),
  ('decades'),
  ('quarter'),
  ('month'),
  ('months'),
  ('day'),
  ('days'),
  ('hour'),
  ('hours'),
  ('minute'),
  ('minutes'),
  ('second'),
  ('seconds'),
  ('millisecond'),
  ('milliseconds'),
  ('microsecond'),
  ('microseconds'))
AS t(timespan);

-- Test 107: statement (line 769)
CREATE TABLE t83756 (i INTERVAL PRIMARY KEY);

-- Test 108: statement (line 773)
INSERT INTO t83756 VALUES ('106751 days 23:47:16.854775');
INSERT INTO t83756 VALUES ('-106751 days -23:47:16.854775');

-- Test 109: statement (line 781)
INSERT INTO t83756 VALUES ('106751 days 23:47:16.854776');

-- Test 110: statement (line 784)
INSERT INTO t83756 VALUES ('-106751 days -23:47:16.854776');

-- Test 111: statement (line 790)
INSERT INTO t83756 VALUES ('-3558 months 106752 days');

-- Test 112: statement (line 793)
INSERT INTO t83756 VALUES ('3558 months -106752 days');
