-- PostgreSQL compatible tests from timetz
-- 99 tests

-- Test 1: statement (line 8)
CREATE TABLE timetz_test (a TIMETZ PRIMARY KEY, b TIMETZ, c INT)

-- Test 2: statement (line 11)
INSERT INTO timetz_test VALUES
  ('11:00:00+0', '12:00:00+1', 1),
  ('12:00:00+1', '10:00:00-1', 2),
  ('13:00:00+2', '15:00:00-6', 3),
  ('14:00:00+3', '24:00:00-1559', 4),
  ('15:00:00+3', '15:00:00+3', 5)

-- Test 3: query (line 21)
SELECT '24:00:00-1559'::timetz > '23:59:59-1559'::timetz;

-- Test 4: statement (line 75)
SET TIME ZONE -5

-- Test 5: query (line 78)
SELECT '11:00+03:00'::timetz::time

-- Test 6: query (line 84)
SELECT '11:00'::time::timetz

-- Test 7: query (line 90)
SELECT '2001-01-01 11:00+04:00'::timestamptz::timetz

-- Test 8: statement (line 95)
SET TIME ZONE UTC

-- Test 9: statement (line 109)
CREATE TABLE current_time_test (
  id INTEGER PRIMARY KEY,
  a TIMETZ(3) DEFAULT CURRENT_TIME,
  b TIMETZ DEFAULT CURRENT_TIME
)

-- Test 10: statement (line 116)
INSERT INTO current_time_test (id) VALUES (1)

-- Test 11: statement (line 119)
INSERT INTO current_time_test (id, a, b) VALUES
  (2, current_time, current_time),
  (3, current_time, current_time(3))

-- Test 12: statement (line 132)
set time zone +4

-- Test 13: query (line 135)
select current_time() + current_timestamp()::date = current_timestamp()

-- Test 14: statement (line 140)
set time zone UTC

-- Test 15: query (line 145)
select '1:00:00.001':::TIMETZ(7)

statement ok
CREATE TABLE timetz_precision_test (
  id integer PRIMARY KEY,
  t TIMETZ(5)
)

statement ok
INSERT INTO timetz_precision_test VALUES
  (1,'12:00:00.123456+03:00'),
  (2,'12:00:00.12345+03:00'),
  (3,'12:00:00.1234+03:00'),
  (4,'12:00:00.123+03:00'),
  (5,'12:00:00.12+03:00'),
  (6,'12:00:00.1+03:00'),
  (7,'12:00:00+03:00')

query IT
SELECT * FROM timetz_precision_test ORDER BY id ASC

-- Test 16: query (line 175)
select column_name, data_type FROM [SHOW COLUMNS FROM timetz_precision_test] ORDER BY column_name

-- Test 17: statement (line 181)
ALTER TABLE timetz_precision_test ALTER COLUMN t TYPE timetz(6)

-- Test 18: statement (line 184)
INSERT INTO timetz_precision_test VALUES
  (100,'12:00:00.123456+03:00')

-- Test 19: query (line 188)
SELECT * FROM timetz_precision_test ORDER BY id ASC

-- Test 20: query (line 200)
select column_name, data_type FROM [SHOW COLUMNS FROM timetz_precision_test] ORDER BY column_name

-- Test 21: query (line 214)
SELECT '2001-01-01 01:24:00+3'::timetz

-- Test 22: statement (line 222)
SET TIME ZONE -3

-- Test 23: query (line 225)
SELECT '11:00+5'::timetz = '11:00+5'::timetz

-- Test 24: query (line 230)
SELECT '11:00-3'::timetz = '11:00'::time

-- Test 25: query (line 235)
SELECT '11:00-2'::timetz < '11:00'::time

-- Test 26: statement (line 240)
SET TIME ZONE UTC

-- Test 27: query (line 246)
SELECT '12:00:00':::TIMETZ;

-- Test 28: query (line 251)
SELECT '12:00:00.456':::TIMETZ;

-- Test 29: query (line 256)
SELECT '12:00:00.456789':::TIMETZ;

-- Test 30: query (line 261)
SELECT '12:00:00.456789+00':::TIMETZ;

-- Test 31: query (line 266)
SELECT '12:00:00.456789-07':::TIMETZ;

-- Test 32: query (line 271)
SELECT '23:59:59.999999-10':::TIMETZ;

-- Test 33: query (line 276)
SELECT '24:00:00':::TIMETZ;

-- Test 34: query (line 281)
SELECT TIMETZ '12:00:00-07';

-- Test 35: query (line 288)
SELECT '12:00:00-07'::TIMETZ;

-- Test 36: query (line 303)
SELECT '09:00:00.456-07' COLLATE de::TIMETZ;

-- Test 37: query (line 308)
SELECT '2017-01-01 12:00:00-07':::TIMESTAMPTZ::TIMETZ;

-- Test 38: query (line 313)
SELECT '12:00:00-07':::TIME::TIMETZ;

-- Test 39: query (line 323)
select '11:00:00-07:00'::TIMETZ::TIME;

-- Test 40: query (line 328)
select '11:00:00-07:00'::TIMETZ::TIMETZ;

-- Test 41: query (line 335)
select '12:00:00+00':::TIMETZ = '12:00:00+00':::TIMETZ

-- Test 42: query (line 340)
select '12:00:00-06':::TIMETZ = '12:00:00-07':::TIMETZ

-- Test 43: query (line 345)
select '12:00:00+00':::TIMETZ >= '12:00:00+00':::TIMETZ

-- Test 44: query (line 350)
select '12:00:00+00':::TIMETZ <= '12:00:00+00':::TIMETZ

-- Test 45: query (line 355)
SELECT '12:00:00+01:00':::TIMETZ < '11:59:59.999999+00':::TIMETZ

-- Test 46: query (line 360)
SELECT '12:00:00+01:00':::TIMETZ < '11:59:59.999999+02':::TIMETZ

-- Test 47: query (line 365)
SELECT '12:00:00+01:00':::TIMETZ > '11:59:59.999999+02':::TIMETZ

-- Test 48: query (line 370)
SELECT '23:00:01-01:00':::TIMETZ > '00:00:01+00:00':::TIMETZ

-- Test 49: query (line 375)
SELECT '23:00:01-06:00':::TIMETZ > '00:00:01-04:00':::TIMETZ

-- Test 50: query (line 380)
SELECT '07:00:01-06:00':::TIMETZ > '23:00:01-04:00':::TIMETZ

-- Test 51: query (line 385)
SELECT '12:00:00-05':::TIMETZ IN ('12:00:00');

-- Test 52: query (line 390)
SELECT '12:00:00-05':::TIMETZ IN ('12:00:00-05');

-- Test 53: query (line 395)
SELECT '12:00:00-05':::TIMETZ IN ('12:00:00-07');

-- Test 54: query (line 400)
SELECT '12:00:00-05':::TIMETZ IN ('11:00:00-06');

-- Test 55: query (line 407)
SELECT '12:00:00-01':::TIMETZ + '1s':::INTERVAL

-- Test 56: query (line 412)
SELECT '23:59:59+00':::TIMETZ + '1s':::INTERVAL

-- Test 57: query (line 417)
SELECT '23:59:59+00':::TIMETZ + '4m':::INTERVAL

-- Test 58: query (line 422)
SELECT '12:00:00-07':::TIMETZ + '1d':::INTERVAL

-- Test 59: query (line 427)
SELECT '1s':::INTERVAL + '12:00:00+03':::TIMETZ

-- Test 60: query (line 432)
SELECT '12:00:00-07':::TIMETZ - '1s':::INTERVAL

-- Test 61: query (line 437)
SELECT '12:00:00-07':::TIMETZ - '1d':::INTERVAL

-- Test 62: query (line 442)
SELECT '01:00:00-07':::TIMETZ - '9h':::INTERVAL

-- Test 63: query (line 447)
SELECT '2017-01-01':::DATE + '12:00:00-03':::TIMETZ

-- Test 64: query (line 452)
SELECT '12:00:00+03':::TIMETZ + '2017-01-01':::DATE

-- Test 65: statement (line 459)
CREATE TABLE timetzs (t timetz PRIMARY KEY)

-- Test 66: statement (line 462)
INSERT INTO timetzs VALUES
  ('00:00:00-07'),
  ('00:00:00.000001+06'),
  ('11:59:59.999999+10'),
  ('12:00:00-05'),
  ('12:00:00.000001-05'),
  ('23:59:59.999999+00')

-- Test 67: query (line 471)
SELECT * FROM timetzs ORDER BY t

-- Test 68: statement (line 481)
CREATE TABLE tzarrays (timetzs TIMETZ[])

-- Test 69: statement (line 484)
INSERT INTO tzarrays VALUES
  (ARRAY[]),
  (ARRAY['00:00:00-07']),
  (ARRAY['00:00:00-07', '12:00:00.000001-07']),
  ('{13:00:00-07}'::TIMETZ[])

-- Test 70: query (line 491)
SELECT * FROM tzarrays

-- Test 71: query (line 501)
SELECT extract(hour from timetz '12:01:02.345678-07')

-- Test 72: query (line 506)
SELECT extract(minute from timetz '12:01:02.345678+03')

-- Test 73: query (line 511)
SELECT extract(second from timetz '12:01:02.345678-06')

-- Test 74: query (line 516)
SELECT extract(millisecond from timetz '12:01:02.345678+00')

-- Test 75: query (line 521)
SELECT extract(microsecond from timetz '12:01:02.345678-05')

-- Test 76: query (line 526)
SELECT extract(epoch from timetz '12:00:00+04')

-- Test 77: statement (line 534)
CREATE TABLE TIMETZ_TBL (id serial primary key, f1 time(2) with time zone)

-- Test 78: statement (line 538)
INSERT INTO TIMETZ_TBL (f1) VALUES ('00:01-07')

-- Test 79: statement (line 541)
INSERT INTO TIMETZ_TBL (f1) VALUES ('01:00-07')

-- Test 80: statement (line 544)
INSERT INTO TIMETZ_TBL (f1) VALUES ('02:03-07')

-- Test 81: statement (line 547)
INSERT INTO TIMETZ_TBL (f1) VALUES ('07:07-05')

-- Test 82: statement (line 550)
INSERT INTO TIMETZ_TBL (f1) VALUES ('08:08-04')

-- Test 83: statement (line 553)
INSERT INTO TIMETZ_TBL (f1) VALUES ('11:59-07')

-- Test 84: statement (line 556)
INSERT INTO TIMETZ_TBL (f1) VALUES ('12:00-07')

-- Test 85: statement (line 559)
INSERT INTO TIMETZ_TBL (f1) VALUES ('12:01-07')

-- Test 86: statement (line 562)
INSERT INTO TIMETZ_TBL (f1) VALUES ('23:59-07')

-- Test 87: statement (line 565)
INSERT INTO TIMETZ_TBL (f1) VALUES ('11:59:59.99 PM-07')

-- Test 88: statement (line 568)
INSERT INTO TIMETZ_TBL (f1) VALUES ('2003-03-07 15:36:39 America/New_York')

-- Test 89: statement (line 571)
INSERT INTO TIMETZ_TBL (f1) VALUES ('2003-07-07 15:36:39 America/New_York')

-- Test 90: query (line 641)
SELECT f1 + time with time zone '00:01' AS "Illegal" FROM TIMETZ_TBL ORDER BY id

# check default types and expressions get truncated on insert / update.
subtest regression_44774

statement ok
CREATE TABLE regression_44774 (
  a timetz(3) DEFAULT '12:13:14.123456'
)

statement ok
INSERT INTO regression_44774 VALUES (default), ('19:21:57.261286')

query T
SELECT a FROM regression_44774 ORDER BY a

-- Test 91: statement (line 661)
UPDATE regression_44774
SET a = '13:14:15.123456'::timetz + '1 sec'::interval
WHERE 1 = 1

-- Test 92: query (line 666)
SELECT a FROM regression_44774 ORDER BY a

-- Test 93: statement (line 672)
DROP TABLE regression_44774

-- Test 94: statement (line 679)
CREATE TABLE regression_74912 (t1 TIMETZ PRIMARY KEY, t2 TIMETZ);
INSERT INTO regression_74912 VALUES
  ('05:00:00.000001', '05:00:00.000001'),
  ('07:00:00.000001+02:00:00', '07:00:00.000001+02:00:00'),
  ('09:00:00.000001+04:00:00', '09:00:00.000001+04:00:00'),
  ('20:59:00.000001+15:59:00', '20:59:00.000001+15:59:00');

-- Test 95: query (line 687)
SELECT count(*) FROM regression_74912@{NO_FULL_SCAN} WHERE t1 > '05:00:00';

-- Test 96: query (line 692)
SELECT count(*) FROM regression_74912@{NO_FULL_SCAN} WHERE t1 < '05:00:00.000001';

-- Test 97: query (line 697)
SELECT count(*) FROM regression_74912 WHERE t2 > '05:00:00';

-- Test 98: query (line 702)
SELECT count(*) FROM regression_74912 WHERE t2 < '05:00:00.000001';

-- Test 99: statement (line 707)
DROP TABLE regression_74912

