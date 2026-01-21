-- PostgreSQL compatible tests from datetime
-- 319 tests

SET client_min_messages = warning;

-- Test 1: statement (line 2)
DROP TABLE IF EXISTS t, u, kv, m, ex, tz, topics, django_37, date_test, timestamps, timestamp_datestyle_parse, time_datestyle_parse, table_71776, t97643;

CREATE TABLE t (
  a TIMESTAMP PRIMARY KEY,
  b DATE,
  c INTERVAL,
  UNIQUE (b),
  UNIQUE (c)
);

-- Test 2: statement (line 14)
INSERT INTO t VALUES
  ('2015-08-30 03:34:45.34567', '2015-08-30', '34h2s'),
  ('2015-08-25 04:45:45.53453', '2015-08-25', '2h45m2s234ms'),
  ('2015-08-29 23:10:09.98763', '2015-08-29', '234h45m2s234ms');

-- Test 3: query (line 21)
SELECT b + '6 month'::interval from t order by a desc;

-- Test 4: query (line 28);
SELECT * FROM t WHERE a = '2015-08-25 04:45:45.53453+01:00'::timestamp;

-- Test 5: statement (line 34)
INSERT INTO t VALUES
  ('2015-08-30 03:34:45.34567-07:00', '2015-08-31', '35h2s');

-- Test 6: statement (line 39)
CREATE TABLE u (
  a BIGINT PRIMARY KEY,
  b TIMESTAMP,
  c TIMESTAMPTZ,
  d DATE,
  e INTERVAL
);

-- Test 7: statement (line 48)
INSERT INTO u VALUES
  (123, '2015-08-30 03:34:45.34567', '2015-08-30 03:34:45.34567', '2015-08-30', '34h2s'),
  (234, '2015-08-25 04:45:45.53453-02:00', '2015-08-25 04:45:45.53453-02:00', '2015-08-25', '2h45m2s234ms');

-- Test 8: statement (line 53)
SET TIME ZONE -5;

-- Test 9: query (line 56)
SELECT DATE '2000-01-01', DATE '2000-12-31', DATE '1993-05-16';

-- Test 10: statement (line 61)
INSERT INTO u VALUES
  (345, '2015-08-29 23:10:09.98763', '2015-08-29 23:10:09.98763', '2015-08-29', '234h45m2s234ms'),
  (456, '2015-08-29 23:10:09.98763 UTC', '2015-08-29 23:10:09.98763 UTC', '2015-08-29', '234h45m2s234ms');

-- Test 11: query (line 66);
SELECT * FROM u ORDER BY a;

-- Test 12: statement (line 74)
SET TIME ZONE UTC;

-- Test 13: query (line 77);
SELECT * FROM u ORDER BY a;

-- Test 14: statement (line 85)
SET TIME ZONE -5;

-- Test 15: query (line 88)
SELECT max(b), max(c), max(d), max(e) FROM u;

-- Test 16: query (line 93)
SELECT min(b), min(c), min(d), min(e) FROM u;

-- Test 17: query (line 98)
SELECT now() < now() + '1m'::interval, now() <= now() + '1m'::interval;

-- Test 18: query (line 103)
SELECT now() + '1m'::interval > now(), now() + '1m'::interval >= now();

-- Test 19: query (line 110)
SELECT 'epoch'::date, 'infinity'::date, '-infinity'::date;

-- Test 20: statement (line 117)
SELECT '0000-01-01 BC'::date;

-- Test 21: query (line 120)
SELECT '4714-11-24 BC'::date, '5874897-12-31'::date, '2000-01-01'::date, '0001-01-01'::date, '0001-12-13 BC'::date;

-- Test 22: statement (line 132)
SELECT '4714-11-24 BC'::date - 1;

-- Test 23: statement (line 135)
SELECT '5874897-12-31'::date + 1;

-- Test 24: query (line 143)
SELECT 'infinity'::date + 1, 'infinity'::date - 1, '-infinity'::date + 1, '-infinity'::date - 1;

-- Test 25: statement (line 148)
SELECT 'infinity'::date - 'infinity'::date;

-- Test 26: query (line 151)
SELECT '5874897-12-31'::date - '4714-11-24 BC'::date;

-- Test 27: query (line 158)
SELECT age('2001-04-10 22:06:45', '1957-06-13');

-- Test 28: query (line 163)
SELECT age('1957-06-13') - age(now(), '1957-06-13') = interval '0s';

-- Test 29: query (line 168)
select age('2017-12-10'::timestamptz, '2017-12-01'::timestamptz);

-- Test 30: query (line 173)
SELECT now() - timestamp '2015-06-13' > interval '100h';

-- Test 31: query (line 178)
SELECT now()::timestamp - now(), now() - now()::timestamp;

-- Test 32: query (line 183)
SELECT now() = now()::timestamp, now()::timestamp = now();

-- Test 33: query (line 188)
SELECT now()::timestamp < now(), now() < now()::timestamp;

-- Test 34: query (line 193)
SELECT now()::timestamp <= now(), now() <= now()::timestamp;

-- Test 35: query (line 198)
SELECT current_date - current_date = 0;

-- Test 36: query (line 203)
SELECT now() - current_timestamp = interval '0s';

-- Test 37: query (line 208)
SELECT now() - current_timestamp = interval '0s';

-- Test 38: query (line 213)
SELECT now() - statement_timestamp() < interval '10s';

-- Test 39: query (line 218)
SELECT clock_timestamp() - statement_timestamp() < interval '10s';

-- Test 40: query (line 223)
SELECT now() - transaction_timestamp() = interval '0s';

-- Test 41: statement (line 228)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- Test 42: statement (line 231)


-- Test 43: statement (line 234)
CREATE TABLE kv (
  k CHAR PRIMARY KEY,
  v TIMESTAMPTZ
);

-- Test 44: statement (line 240)
INSERT INTO kv (k,v) VALUES ('a', transaction_timestamp());

-- Test 45: query (line 243)
SELECT k FROM kv;

-- Test 46: query (line 248)
SELECT k FROM kv where v = transaction_timestamp();

-- Test 47: statement (line 253)
COMMIT TRANSACTION;

-- Test 48: statement (line 258)
RESET TIME ZONE;

-- Test 49: query (line 261)
SELECT
    d = tz, d = t, d = n
FROM
    (
        SELECT
            current_date::DATE AS d,
            current_date::TIMESTAMPTZ::DATE AS tz,
            current_date::TIMESTAMP::DATE AS t,
            now()::DATE AS n
    ) subq;

-- Test 50: query (line 275)
SELECT now() - current_date::timestamptz < interval '24h10s';

-- Test 51: statement (line 280)
SET TIME ZONE 48;

-- Test 52: query (line 283)
SELECT now() - current_date::timestamptz < interval '24h10s';

-- Test 53: query (line 288)
SELECT
    d = tz, d = t, d = n
FROM
    (
        SELECT
            current_date::DATE AS d,
            current_date::TIMESTAMPTZ::DATE AS tz,
            current_date::TIMESTAMP::DATE AS t,
            now()::DATE AS n
    ) subq;

-- Test 54: statement (line 302)
RESET TIME ZONE;

-- Test 55: statement (line 309)
BEGIN;
INSERT INTO kv (k,v) VALUES ('b', transaction_timestamp());
SELECT * FROM kv;
INSERT INTO kv (k,v) VALUES ('c', transaction_timestamp());
SELECT * FROM kv;
INSERT INTO kv (k,v) VALUES ('d', current_timestamp);
SELECT * FROM kv;
INSERT INTO kv (k,v) VALUES ('e', current_timestamp);
SELECT * FROM kv;
INSERT INTO kv (k,v) VALUES ('f', now());
SELECT * FROM kv;
INSERT INTO kv (k,v) VALUES ('g', now());
SELECT * FROM kv;
INSERT INTO kv (k,v) VALUES ('h', statement_timestamp());
SELECT * FROM kv;
COMMIT;
SELECT * FROM kv;
BEGIN;
SELECT * FROM KV;
INSERT INTO kv (k,v) VALUES ('i', transaction_timestamp());
COMMIT;

-- Test 56: query (line 332)
SELECT count(DISTINCT (v)) FROM kv;

-- Test 57: statement (line 339)
DELETE FROM kv;

-- Test 58: statement (line 342)
BEGIN;
INSERT INTO kv (k,v) VALUES ('a', transaction_timestamp());
SELECT * FROM kv;

-- Test 59: statement (line 347)
INSERT INTO kv (k,v) VALUES ('b', transaction_timestamp());
SELECT * FROM kv;
COMMIT;

-- Test 60: statement (line 352)
BEGIN;
SELECT * FROM KV;
INSERT INTO kv (k,v) VALUES ('c', transaction_timestamp());
COMMIT;

-- Test 61: query (line 358)
SELECT count(DISTINCT (v)) FROM kv;

-- Test 62: statement (line 363)
DROP TABLE kv;

-- Test 63: statement (line 366)
CREATE TABLE kv (
   k INT PRIMARY KEY,
   v DECIMAL
);

-- Test 64: statement (line 374)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
INSERT INTO kv (k,v) VALUES (1, extract(epoch from now())::decimal * 1000000000);
SELECT * FROM kv;

-- Test 65: statement (line 379)
INSERT INTO kv (k,v) VALUES (2, extract(epoch from now())::decimal * 1000000000);
SELECT * FROM kv;
COMMIT;

-- Test 66: statement (line 384)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SELECT * FROM kv;
INSERT INTO kv (k,v) VALUES (3, extract(epoch from now())::decimal * 1000000000);
COMMIT;

-- Test 67: query (line 390)
SELECT count(DISTINCT (v)) FROM kv;

-- Test 68: statement (line 395)
DELETE FROM kv;

-- let 'serializable';
-- SHOW default_transaction_isolation;

-- Test 69: statement (line 401)
SET default_transaction_isolation = 'serializable';

-- Test 70: statement (line 404)
CREATE TABLE m (mints DECIMAL);

-- Test 71: statement (line 407)
INSERT INTO m VALUES (extract(epoch from now())::decimal * 1000000000);

-- Test 72: statement (line 411)
INSERT INTO kv (k,v) VALUES (1, extract(epoch from now())::decimal * 1000000000-(select mints from m));
SELECT * FROM kv;

-- Test 73: statement (line 415)
INSERT INTO kv (k,v) VALUES (2, extract(epoch from now())::decimal * 1000000000-(select mints from m));
SELECT * FROM kv;

-- Test 74: statement (line 419)
INSERT INTO kv (k,v) VALUES (3, extract(epoch from now())::decimal * 1000000000-(select mints from m));
SELECT * FROM kv;

-- Test 75: statement (line 423)
INSERT INTO kv (k,v) VALUES (4, extract(epoch from now())::decimal * 1000000000-(select mints from m));
SELECT * FROM kv;

-- Test 76: statement (line 427)
INSERT INTO kv (k,v) VALUES (5, extract(epoch from now())::decimal * 1000000000-(select mints from m));
SELECT * FROM kv;

-- Test 77: statement (line 431)
INSERT INTO kv (k,v) VALUES (6, extract(epoch from now())::decimal * 1000000000-(select mints from m));
SELECT * FROM kv;

-- Test 78: statement (line 435)
SET default_transaction_isolation = 'serializable';

-- Test 79: query (line 438)
SELECT k FROM kv ORDER BY v;

-- Test 80: statement (line 448)
SET TIME ZONE UTC;

CREATE TABLE ex (
  k INT PRIMARY KEY,
  element TEXT,
  input TEXT,
  extract_result NUMERIC,
  date_trunc_result TIMESTAMP
);

-- Test 81: statement (line 460)
INSERT INTO ex VALUES
  (1,  'year',         '2001-04-10 12:04:59',              2001,              '2001-01-01 00:00:00'),
  (2,  'year',         '2016-02-10 19:46:33.306157519',    2016,              '2016-01-01 00:00:00'),
  (3,  'years',        '2016-02-10 19:46:33.306157519',    2016,              '2016-01-01 00:00:00'),
  (4,  'quarter',      '2001-04-10 12:04:59',              2,                 '2001-04-01 00:00:00'),
  (5,  'quarter',      '2016-02-10 19:46:33.306157519',    1,                 '2016-01-01 00:00:00'),
  (6,  'quarter',      '2016-05-10 19:46:33.306157519',    2,                 '2016-04-01 00:00:00'),
  (7,  'quarter',      '2016-09-09 19:46:33.306157519',    3,                 '2016-07-01 00:00:00'),
  (8,  'quarter',      '2016-10-10 19:46:33.306157519',    4,                 '2016-10-01 00:00:00'),
  (9,  'month',        '2001-04-10 12:04:59',              4,                 '2001-04-01 00:00:00'),
  (10, 'month',        '2016-02-10 19:46:33.306157519',    2,                 '2016-02-01 00:00:00'),
  (11, 'months',       '2016-02-10 19:46:33.306157519',    2,                 '2016-02-01 00:00:00'),
  (12, 'week',         '2001-04-10 12:04:59',              15,                '2001-04-09 00:00:00'),
  (13, 'weeks',        '2001-01-05 12:04:59',              1,                 '2001-01-01 00:00:00'),
  (14, 'day',          '2001-04-10 12:04:59',              10,                '2001-04-10 00:00:00'),
  (15, 'day',          '2016-02-10 19:46:33.306157519',    10,                '2016-02-10 00:00:00'),
  (16, 'days',         '2016-02-10 19:46:33.306157519',    10,                '2016-02-10 00:00:00'),
  (17, 'dayofweek',    '2001-04-10 12:04:59',              2,                 null),
  (18, 'dow',          '2001-04-12 12:04:59',              4,                 null),
  (19, 'dayofyear',    '2001-04-10 12:04:59',              100,               null),
  (20, 'doy',          '2001-04-12 12:04:59',              102,               null),
  (21, 'epoch',        '1970-01-02 00:00:01.000001',       86401.000001,      null),
  (22, 'epoch',        '1970-01-02 00:00:01.000001-04',    100801.000001,     null),
  (23, 'epoch',        '2001-04-10 12:04:59',              986904299,         null),
  (24, 'hour',         '2001-04-10 12:04:59',              12,                '2001-04-10 12:00:00'),
  (25, 'hour',         '2016-02-10 19:46:33.306157519',    19,                '2016-02-10 19:00:00'),
  (26, 'hour',         '2016-02-10 19:46:33.306157519-04', 23,                '2016-02-10 19:00:00-04'),
  (27, 'hours',        '2016-02-10 19:46:33.306157519',    19,                '2016-02-10 19:00:00'),
  (28, 'hours',        '2016-02-10 19:46:33.306157519-04', 23,                '2016-02-10 19:00:00-04'),
  (29, 'minute',       '2001-04-10 12:04:59',              4,                 '2001-04-10 12:04:00'),
  (30, 'minute',       '2016-02-10 19:46:33.306157519',    46,                '2016-02-10 19:46:00'),
  (31, 'minutes',      '2016-02-10 19:46:33.306157519',    46,                '2016-02-10 19:46:00'),
  (32, 'second',       '2001-04-10 12:04:59.234',          59.234,            '2001-04-10 12:04:59'),
  (33, 'second',       '2016-02-10 19:46:33.306157519',    33.306158,         '2016-02-10 19:46:33'),
  (34, 'seconds',      '2016-02-10 19:46:33.306157519',    33.306158,         '2016-02-10 19:46:33'),
  (35, 'millisecond',  '2001-04-10 12:04:59.234567',       59234.567,         '2001-04-10 12:04:59.234'),
  (36, 'millisecond',  '2016-02-10 19:46:33.306157519',    33306.158,         '2016-02-10 19:46:33.306'),
  (37, 'milliseconds', '2016-02-10 19:46:33.306157519',    33306.158,         '2016-02-10 19:46:33.306'),
  (38, 'microsecond',  '2001-04-10 12:04:59.34565423',     59345654,          '2001-04-10 12:04:59.345654'),
  (39, 'microsecond',  '2016-02-10 19:46:33.306157519',    33306158,          '2016-02-10 19:46:33.306158'),
  (40, 'microseconds', '2016-02-10 19:46:33.306157519',    33306158,          '2016-02-10 19:46:33.306158'),
  (41, 'isodow',       '2001-04-10 12:04:59',              2,                 null),
  (42, 'isodow',       '2001-04-08 12:04:59',              7,                 null),
  (43, 'isoyear',      '2007-12-31 12:04:59',              2008,              null),
  (44, 'isoyear',      '2008-01-01 12:04:59',              2008,              null),
  (45, 'decade',       '2001-04-10 12:04:59',              200,               '2000-01-01 00:00:00'),
  (46, 'decade',       '2016-02-10 19:46:33.306157519 BC', -202,              '2021-01-01 00:00:00 BC'),
  (47, 'century',      '2016-02-10 19:46:33.306157519',    21,                '2001-01-01 00:00:00'),
  (48, 'century',      '0004-02-10 19:46:33.306157519 BC', -1,                '0100-01-01 00:00:00 BC'),
  (49, 'millennium',   '2016-02-10 19:46:33.306157519',    3,                 '2001-01-01 00:00:00'),
  (50, 'millennium',   '1004-02-10 19:46:33.306157519 BC', -2,                '2000-01-01 00:00:00 BC'),
  (51, 'julian',       '4714-11-24 BC',                     0,                null),
  (52, 'julian',       '2016-02-10 19:46:33.306157519',    2457429.823996599, null);

-- Test 82: query (line 515)
SELECT k, extract(element, input::timestamp) = extract_result, date_part(element, input::timestamp) = extract_result, extract(element, input::timestamp) FROM ex ORDER BY k;

-- Test 83: query (line 571)
SELECT extract(nansecond from '2001-04-10 12:04:59.34565423'::timestamp);

-- query error unknown unit "nanosecond";
SELECT INTERVAL '1 nanosecond';

-- query error unknown unit "ns";
SELECT INTERVAL '1 ns';

-- query IBR;
SELECT k, extract(element, input::timestamptz) = extract_result, extract(element, input::timestamptz) FROM ex ORDER BY k;

-- Test 84: query (line 636)
SELECT extract(nansecond from '2001-04-10 12:04:59.34565423'::timestamptz);

-- query R;
SELECT extract(hour from '2016-02-10 19:46:33.306157519-04'::timestamptz);

-- Test 85: query (line 644)
SELECT extract(hours from '2016-02-10 19:46:33.306157519-04'::timestamptz);

-- Test 86: query (line 819)
SELECT '2015-08-25 05:45:45.53453'::timestamp;

-- Test 87: query (line 824)
SELECT '2015-08-25 05:45:45.53453'::timestamp;

-- Test 88: statement (line 829)
SET TIME ZONE 'Europe/Rome';

-- Test 89: query (line 832)
SELECT '2015-08-25 05:45:45.53453 CET'::timestamptz WHERE false;

-- statement ok;
SET TIME ZONE +1;

-- query error unimplemented: timestamp abbreviations not supported;
SELECT '2015-08-25 05:45:45.53453 CET'::timestamptz WHERE false;

-- query T;
SELECT '2015-08-25 05:45:45.53453'::timestamp;

-- Test 90: query (line 846)
SELECT '2015-08-25 05:45:45.53453'::timestamptz;

-- Test 91: query (line 851)
SELECT '2015-08-25 05:45:45-01:00'::timestamp;

-- Test 92: query (line 856)
SELECT '2015-08-25 05:45:45-01:00'::timestamp::timestamptz;

-- Test 93: query (line 861)
SELECT '2015-08-25 05:45:45-01:00'::timestamptz::timestamp;

-- Test 94: query (line 866)
SELECT '2015-08-25 05:45:45-01:00'::timestamptz;

-- Test 95: statement (line 872)
SET TIMEZONE = +2;

-- Test 96: query (line 875)
SELECT '2015-08-25 05:45:45.53453 CET'::timestamptz WHERE false;

-- query T;
SELECT '2015-08-25 05:45:45.53453'::timestamp;

-- Test 97: query (line 883)
SELECT '2015-08-25 05:45:45.53453'::timestamptz;

-- Test 98: query (line 888)
SELECT '2015-08-25 05:45:45-01:00'::timestamp;

-- Test 99: query (line 893)
SELECT '2015-08-25 05:45:45-01:00'::timestamp::timestamptz;

-- Test 100: query (line 898)
SELECT '2015-08-25 05:45:45-01:00'::timestamptz::timestamp;

-- Test 101: query (line 903)
SELECT '2015-08-25 05:45:45-01:00'::timestamptz;

-- Test 102: statement (line 908)
SET TIME ZONE -5;

-- Test 103: query (line 911)
SELECT '2015-08-24 23:45:45.53453'::timestamp;

-- Test 104: query (line 916)
SELECT '2015-08-24 23:45:45.53453'::timestamptz;

-- Test 105: query (line 921)
SELECT '2015-08-24 23:45:45.53453 UTC'::timestamp;

-- Test 106: query (line 926)
SELECT '2015-08-24 23:45:45.53453 UTC'::timestamptz;

-- Test 107: query (line 931)
SELECT '2015-08-24 23:45:45.53453-02:00'::timestamp;

-- Test 108: query (line 936)
SELECT '2015-08-24 23:45:45.53453-02:00'::timestamptz;

-- Test 109: query (line 941)
SELECT '2015-08-24 23:45:45.53453-05:00'::timestamptz;

-- Test 110: query (line 946)
SELECT '2015-08-24 23:45:45.534 -02:00'::timestamp;

-- Test 111: query (line 951)
SELECT '2015-08-24 23:45:45.534 -02:00'::timestamptz;

-- Test 112: query (line 956)
SELECT '2015-08-25 05:45:45-01:00'::timestamp::timestamptz;

-- Test 113: query (line 961)
SELECT '2015-08-25 05:45:45-01:00'::timestamptz::timestamp;

-- Test 114: statement (line 967)
SET TIME ZONE 'America/New_York';

-- Test 115: query (line 970)
SELECT '2015-08-25 05:45:45-01:00'::timestamp::timestamptz;

-- Test 116: query (line 975)
SELECT '2015-08-25 05:45:45-01:00'::timestamptz::timestamp;

-- Test 117: statement (line 981)
SET TIME ZONE 'foobar';

-- Test 118: statement (line 984)
SET TIME ZONE default;

-- Test 119: query (line 987)
SELECT '2015-08-24 21:45:45.53453'::timestamptz;

-- Test 120: statement (line 992)
SET TIME ZONE local;

-- Test 121: query (line 995)
SELECT '2015-08-24 21:45:45.53453'::timestamptz;

-- Test 122: statement (line 1000)
SET TIME ZONE 'DEFAULT';

-- Test 123: query (line 1003)
SELECT '2015-08-24 21:45:45.53453'::timestamptz;

-- Test 124: statement (line 1008)
SET TIME ZONE '';

-- Test 125: query (line 1011)
SELECT '2015-08-24 21:45:45.53453'::timestamptz;

-- Test 126: statement (line 1017)
SET TIME ZONE INTERVAL '-7h';

-- Test 127: query (line 1020)
SELECT '2015-08-24 21:45:45.53453'::timestamp;

-- Test 128: query (line 1025)
SELECT '2015-08-24 21:45:45.53453'::timestamptz;

-- Test 129: statement (line 1030)
SET TIME ZONE -7.5;

-- Test 130: query (line 1033)
SELECT '2015-08-24 21:45:45.53453'::timestamp;

-- Test 131: query (line 1038)
SELECT '2015-08-24 21:45:45.53453'::timestamptz;

-- Test 132: query (line 1043)
SELECT '2015-08-24 21:45:45.53453 UTC'::timestamptz;

-- Test 133: statement (line 1048)
SET TIME ZONE LOCAL;

-- Test 134: query (line 1051)
SELECT '2015-08-25 04:45:45.53453'::timestamp;

-- Test 135: statement (line 1056)
SET TIME ZONE DEFAULT;

-- Test 136: query (line 1059)
SELECT '2015-08-25 04:45:45.53453'::timestamp;

-- Test 137: statement (line 1065)
SET TIME ZONE 'UTC';

-- Test 138: query (line 1070)
SELECT b, b::date, c, c::date FROM u WHERE a = 123;

-- Test 139: query (line 1075)
SELECT d::timestamp FROM u WHERE a = 123;

-- Test 140: statement (line 1080)
SET TIME ZONE -5;

-- Test 141: query (line 1083)
SELECT b, b::date, c, c::date FROM u WHERE a = 123;

-- Test 142: query (line 1088)
SELECT d::timestamp FROM u WHERE a = 123;

-- Test 143: statement (line 1093)
SET TIME ZONE UTC;

-- Test 144: statement (line 1097)
CREATE TABLE tz (
  a INT PRIMARY KEY,
  b TIMESTAMP,
  c TIMESTAMPTZ,
  d TIMESTAMPTZ
);

-- Test 145: query (line 1106)
SELECT column_name, data_type FROM information_schema.columns WHERE table_name = 'tz' ORDER BY ordinal_position;

-- Test 146: statement (line 1114)
INSERT INTO tz VALUES
  (1, timestamp '2015-08-30 03:34:45', timestamptz '2015-08-30 03:34:45',  timestamptz '2015-08-30 03:34:45'),
  (2, timestamp '2015-08-30 03:34:45+01:00', timestamptz '2015-08-30 03:34:45+01:00',  timestamptz '2015-08-30 03:34:45');

-- Test 147: statement (line 1119)
SET TIME ZONE -2;

-- Test 148: query (line 1122)
SELECT a, b, c FROM tz ORDER BY a;

-- Test 149: query (line 1128)
SELECT b + interval '1m', interval '1m' + b, c + interval '1m', interval '1m' + c FROM tz WHERE a = 1;

-- Test 150: query (line 1133)
SELECT a FROM tz WHERE c = d;

-- Test 151: query (line 1138)
SELECT a FROM tz WHERE c <= d;

-- Test 152: query (line 1144)
SELECT a FROM tz WHERE c < d;

-- Test 153: query (line 1150)
SELECT a FROM tz WHERE b = c::timestamp;

-- Test 154: query (line 1154)
SELECT a FROM tz WHERE c = d::timestamp;

-- Test 155: statement (line 1160)
SET TIME ZONE 'UTC';

-- Test 156: statement (line 1163)
SET TIME ZONE -5;

-- Test 157: query (line 1166)
SHOW TIME ZONE;

-- Test 158: statement (line 1171)
SET TIME ZONE '+04:00';

-- Test 159: query (line 1174)
SELECT '2015-08-24 21:45:45.53453'::timestamptz;

-- Test 160: statement (line 1179)
SET TIME ZONE '-04:00';

-- Test 161: query (line 1182)
SELECT '2015-08-24 21:45:45.53453'::timestamptz;

-- Test 162: statement (line 1188)
SET TIMEZONE TO '+05:00';

-- Test 163: query (line 1191)
SELECT '2015-08-24 21:45:45.53453'::timestamptz;

-- Test 164: statement (line 1196)
SET TIMEZONE TO '-05:00';

-- Test 165: query (line 1199)
SELECT '2015-08-24 21:45:45.53453'::timestamptz;

-- Test 166: statement (line 1204)
SET TIME ZONE 0;

-- Test 167: query (line 1207)
SHOW TIME ZONE;

-- Test 168: query (line 1212)
SELECT DATE '1999-01-01' + INTERVAL '4 minutes';

-- Test 169: query (line 1217)
SELECT INTERVAL '4 minutes' + DATE '1999-01-01';

-- Test 170: query (line 1222)
SELECT DATE '1999-01-01' - INTERVAL '4 minutes';

-- Test 171: query (line 1227)
SELECT DATE '1999-01-02' < TIMESTAMPTZ '1999-01-01';

-- Test 172: query (line 1232)
SELECT DATE '1999-01-02' < TIMESTAMP '1999-01-01';

-- Test 173: query (line 1237)
SELECT DATE '1999-01-02' <= TIMESTAMPTZ '1999-01-01';

-- Test 174: query (line 1242)
SELECT DATE '1999-01-02' <= TIMESTAMP '1999-01-01';

-- Test 175: query (line 1247)
SELECT DATE '1999-01-02' <= TIMESTAMPTZ '1999-01-02';

-- Test 176: query (line 1252)
SELECT DATE '1999-01-02' <= TIMESTAMP '1999-01-02';

-- Test 177: query (line 1257)
SELECT DATE '1999-01-02' > TIMESTAMPTZ '1999-01-01';

-- Test 178: query (line 1262)
SELECT DATE '1999-01-02' > TIMESTAMP '1999-01-01';

-- Test 179: query (line 1267)
SELECT DATE '1999-01-02' >= TIMESTAMPTZ '1999-01-01';

-- Test 180: query (line 1272)
SELECT DATE '1999-01-02' >= TIMESTAMP '1999-01-01';

-- Test 181: query (line 1277)
SELECT DATE '1999-01-02' = TIMESTAMPTZ '1999-01-01';

-- Test 182: query (line 1282)
SELECT DATE '1999-01-01' = TIMESTAMP '1999-01-01';

-- Test 183: query (line 1288)
SELECT INTERVAL '5', INTERVAL '5' SECOND, INTERVAL '5' MINUTE TO SECOND, INTERVAL '5' HOUR TO SECOND, INTERVAL '5' DAY TO SECOND;

-- Test 184: query (line 1293)
SELECT INTERVAL '5' MINUTE, INTERVAL '5' HOUR TO MINUTE, INTERVAL '5' DAY TO MINUTE;

-- Test 185: query (line 1298)
SELECT INTERVAL '5' HOUR, INTERVAL '5' DAY TO HOUR;

-- Test 186: query (line 1303)
SELECT INTERVAL '5' DAY;

-- Test 187: query (line 1308)
SELECT INTERVAL '5' MONTH, INTERVAL '5' YEAR TO MONTH;

-- Test 188: query (line 1313)
SELECT INTERVAL '5' YEAR;

-- Test 189: query (line 1319)
SELECT INTERVAL '1-2 3 4:5:6' SECOND, INTERVAL '1-2 3 4:5:6' MINUTE TO SECOND, INTERVAL '1-2 3 4:5:6' HOUR TO SECOND, INTERVAL '1-2 3 4:5:6' DAY TO SECOND;

-- Test 190: query (line 1324)
SELECT INTERVAL '1-2 3 4:5:6' MINUTE, INTERVAL '1-2 3 4:5:6' HOUR TO MINUTE, INTERVAL '1-2 3 4:5:6' DAY TO MINUTE;

-- Test 191: query (line 1329)
SELECT INTERVAL '1-2 3 4:5:6' HOUR, INTERVAL '1-2 3 4:5:6' DAY TO HOUR;

-- Test 192: query (line 1334)
SELECT INTERVAL '1-2 3 4:5:6' DAY;

-- Test 193: query (line 1339)
SELECT INTERVAL '1-2 3 4:5:6' MONTH, INTERVAL '1-2 3 4:5:6' YEAR TO MONTH;

-- Test 194: query (line 1344)
SELECT INTERVAL '1-2 3 4:5:6' YEAR;

-- Test 195: statement (line 1353)
CREATE TABLE topics (
  ts TIMESTAMP,
  tstz TIMESTAMPTZ,
  "date" DATE
);

-- Test 196: statement (line 1360)
INSERT INTO topics VALUES (
  '2017-12-05 04:04:04.913231+00:00',
  '2017-12-05 04:04:04.913231+00:00',
  '2017-12-05 04:04:04.913231+00:00'
);

-- Test 197: query (line 1367)
SELECT date_trunc('month', ts) AS date_trunc_month_created_at FROM "topics";

-- Test 198: query (line 1372)
SELECT date_trunc('month', tstz) AS date_trunc_month_created_at FROM "topics";

-- Test 199: query (line 1377)
SELECT date_trunc('month', "date") AS date_trunc_month_created_at FROM "topics";

-- Test 200: query (line 1385)
select date_trunc('day', '2011-01-01 22:30:00'::date);

-- Test 201: query (line 1390)
select date_trunc('day', '2011-01-01 22:30:00+01:00'::timestamptz);

-- Test 202: statement (line 1395)
SET TIME ZONE 'Africa/Nairobi';

-- Test 203: query (line 1398)
select date_trunc('day', '2011-01-01 22:30:00'::date);

-- Test 204: query (line 1403)
select date_trunc('day', '2011-01-02 01:30:00'::timestamp);

-- Test 205: query (line 1408)
select date_trunc('day', '2011-01-01 22:30:00+01:00'::timestamptz);

-- Test 206: statement (line 1413)
SET TIME ZONE -5;

-- Test 207: query (line 1416)
select date_trunc('day', '2011-01-02 01:30:00'::date), pg_typeof(date_trunc('day', '2011-01-02 01:30:00'::date));

-- Test 208: query (line 1421)
select date_trunc('day', '2011-01-02 01:30:00'::timestamp), pg_typeof(date_trunc('day', '2011-01-02 01:30:00'::timestamp));

-- Test 209: query (line 1426)
select date_trunc('day', '2011-01-02 01:30:00+00:00'::timestamptz), pg_typeof(date_trunc('day', '2011-01-02 01:30:00+00:00'::timestamptz));

-- Test 210: statement (line 1431)
SET TIME ZONE 0;

-- Test 211: statement (line 1436)
SET TIME ZONE 'UTC';

-- Test 212: statement (line 1439)
CREATE TABLE django_37 (a TIMESTAMPTZ);
INSERT INTO django_37 VALUES ('2018-09-28T12:42:10.234567-05:00'::TIMESTAMPTZ);

-- Test 213: query (line 1442)
SELECT a::TIME FROM django_37;

-- Test 214: statement (line 1447)
SET TIME ZONE 'America/Chicago';

-- Test 215: query (line 1450)
SELECT a::TIME FROM django_37;

-- Test 216: statement (line 1461)
SELECT '-56325279622-12-26'::DATE;

-- Test 217: statement (line 1464)
SELECT '-5632-12-26'::DATE;

-- Test 218: query (line 1467)
SELECT '-563-12-26'::DATE;

-- Test 219: query (line 1472)
SELECT '6-12-26 BC'::DATE;

-- Test 220: query (line 1477)
SELECT '5-12-26 BC'::DATE;

-- Test 221: statement (line 1486)
WITH
    w (c) AS (VALUES (NULL), (NULL))
SELECT
    '1971-03-18'::DATE + 300866802885581286
FROM
    w
ORDER BY
    c;

-- Test 222: statement (line 1496)
SELECT
    '1971-03-18'::DATE + 300866802885581286;

-- Test 223: statement (line 1504)
SELECT 7133080445639580613::INT8 + '1977-11-03'::DATE;

-- Test 224: statement (line 1507)
SELECT '-239852040018-04-28'::DATE;

-- Test 225: statement (line 1510)
SELECT(7133080445639580613::INT8 + '1977-11-03'::DATE) = '-239852040018-04-28'::DATE;

-- Test 226: query (line 1515)
SELECT
    i,
    i / 2::INT8,
    i * 2::INT8,
    i / 2::FLOAT8,
    i * 2::FLOAT8,
    i / .2362::FLOAT8,
    i * .2362::FLOAT8
FROM
    (
        VALUES
            ('1 day'::INTERVAL),
            ('1 month'::INTERVAL),
            ('1 hour'::INTERVAL),
            ('1 month 2 days 4 hours'::INTERVAL)
    ) AS v (i)
ORDER BY
    i;

-- Test 227: query (line 1544)
SET timezone = 'utc'; SHOW timezone;

-- Test 228: statement (line 1551)
SET TIME ZONE -5;

-- Test 229: query (line 1555)
select extract(day from '2019-01-15'::date) as final;

-- Test 230: query (line 1562)
select ('2019-01-15'::date + '16:17:18'::time), pg_typeof('2019-01-15'::date + '16:17:18'::time);

-- Test 231: query (line 1567)
select ('16:17:18'::time + '2019-01-15'::date), pg_typeof(('16:17:18'::time + '2019-01-15'::date));

-- Test 232: query (line 1572)
select ('2019-01-15'::date + '1 hour'::interval), pg_typeof('2019-01-15'::date + '1 hour'::interval);

-- Test 233: query (line 1577)
select ('1 hour'::interval + '2019-01-15'::date), pg_typeof('1 hour'::interval + '2019-01-15'::date);

-- Test 234: query (line 1582)
select ('2019-01-15'::date - '16:17:18'::time), pg_typeof('2019-01-15'::date - '16:17:18'::time);

-- Test 235: query (line 1587)
select ('2019-01-15'::date - '1 hour'::interval), pg_typeof('2019-01-15'::date - '1 hour'::interval);

-- Test 236: query (line 1592)
select '2019-01-01'::date > '2019-01-01 00:00:00+00'::timestamptz;

-- Test 237: query (line 1597)
select '2019-01-01 00:00:00+00'::timestamptz < '2019-01-01'::date;

-- Test 238: query (line 1602)
select '2019-01-01'::date = '2019-01-01 00:00:00'::timestamp;

-- Test 239: query (line 1607)
select '2019-01-01 00:00:00'::timestamp = '2019-01-01'::date;

-- Test 240: query (line 1612)
select '2019-01-01'::date = '2019-01-01'::date;

-- Test 241: statement (line 1619)
SET TIME ZONE 0;

-- Test 242: statement (line 1622)
CREATE TABLE date_test (date_val date, time_val time, interval_val interval);

-- Test 243: statement (line 1625)
INSERT INTO date_test VALUES ('2019-01-15'::date, '16:17:18'::time, '1 hour'::interval);

-- Test 244: statement (line 1628)
SET TIME ZONE -5;

-- Test 245: query (line 1631)
select (date_test.date_val + date_test.time_val), pg_typeof(date_test.date_val + date_test.time_val) from date_test;

-- Test 246: query (line 1636)
select (date_test.time_val + date_test.date_val), pg_typeof((date_test.time_val + date_test.date_val)) from date_test;

-- Test 247: query (line 1641)
select (date_test.date_val + date_test.interval_val), pg_typeof(date_test.date_val + date_test.interval_val) from date_test;

-- Test 248: query (line 1646)
select (date_test.interval_val + date_test.date_val), pg_typeof(date_test.interval_val + date_test.date_val) from date_test;

-- Test 249: query (line 1651)
select (date_test.date_val - date_test.time_val), pg_typeof(date_test.date_val - date_test.time_val) from date_test;

-- Test 250: query (line 1656)
select (date_test.date_val - date_test.interval_val), pg_typeof(date_test.date_val - date_test.interval_val) from date_test;

-- Test 251: query (line 1661)
select count(1) from date_test where date_test.date_val > '2019-01-15 00:00:00+00'::timestamptz;

-- Test 252: query (line 1666)
select count(1) from date_test where '2019-01-15 00:00:00+00'::timestamptz < date_test.date_val;

-- Test 253: query (line 1671)
select count(1) from date_test where '2019-01-15 00:00:00'::timestamp = date_test.date_val;

-- Test 254: query (line 1676)
select count(1) from date_test where date_test.date_val = '2019-01-15 00:00:00'::timestamp;

-- Test 255: query (line 1681)
select count(1) from date_test where date_test.date_val = '2019-01-15'::date;

-- Test 256: statement (line 1686)
SET TIME ZONE +5;

-- Test 257: query (line 1689)
select count(1) from date_test where date_test.date_val < '2019-01-15 00:00:00+00'::timestamptz;

-- Test 258: query (line 1694)
select count(1) from date_test where '2019-01-15 00:00:00+00'::timestamptz > date_test.date_val;

-- Test 259: query (line 1699)
select count(1) from date_test where date_test.date_val = '2019-01-15 00:00:00'::timestamp;

-- Test 260: query (line 1704)
select count(1) from date_test where date_test.date_val = '2019-01-15'::date;

-- Test 261: statement (line 1709)
SET TIME ZONE 0;

-- Test 262: query (line 1714)
SELECT 'infinity'::timestamp, '-infinity'::timestamptz;

CREATE TABLE timestamps (s TIMESTAMPTZ);

-- Test 263: query (line 1723)
INSERT INTO timestamps VALUES ('tomorrow');

-- statement ok;
INSERT INTO timestamps VALUES ('2020-01-02 01:02:03'), ('2015-08-25 04:45:45.53453+01:00'), (NULL);

-- query TT colnames;
SELECT * FROM timestamps ORDER BY s;

-- Test 264: statement (line 1737)
SET TIME ZONE 'America/New_York';

-- Test 265: statement (line 1741)
INSERT INTO timestamps VALUES ('2020-01-02 01:02:03'), ('2015-08-25 04:45:45.53453+01:00'), (NULL);

-- Test 266: query (line 1744);
SELECT * FROM timestamps ORDER BY s;

-- Test 267: statement (line 1755)
RESET TIME ZONE;

-- Test 268: query (line 1760)
SELECT ((SELECT '-infinity'::DATE)) < '2021-04-21'::TIMESTAMP;

-- Test 269: statement (line 1768)
set datestyle = 'dmy';

-- Test 270: statement (line 1771)
set datestyle = 'ymd';

-- Test 271: statement (line 1774)
reset datestyle;

-- Test 272: statement (line 1807)
set datestyle = 'dmy';

-- Test 273: query (line 1810)
SELECT '05-07-2020'::date;

-- Test 274: query (line 1815)
SELECT
  t::timestamptz,;
  t::timestamp,;
  t::timetz,;
  t::time,;
  t::date;
FROM ( VALUES
  ('2020-09-15 15:17:19.123'),
  ('15-09-2020 15:17:19.123'),
  ('03-04-95 15:16:19.123'),
  ('09-05-2020 15:17:19.123')
) tbl(t)
ORDER BY 1;

-- Test 275: statement (line 1835)
set datestyle = 'ymd';

-- Test 276: statement (line 1838)
SELECT '05-07-2020'::date;

-- Test 277: query (line 1841)
SELECT
  t::timestamptz,;
  t::timestamp,;
  t::timetz,;
  t::time,;
  t::date;
FROM ( VALUES
  ('2020-09-15 15:17:19.123'),
  ('95-03-04 15:16:19.123')
) tbl(t)
ORDER BY 1;

-- Test 278: statement (line 1857)
set datestyle = 'mdy';

-- Test 279: query (line 1860)
SELECT '05-07-2020'::date;

-- Test 280: query (line 1865)
SELECT
  t::timestamptz,;
  t::timestamp,;
  t::timetz,;
  t::time,;
  t::date;
FROM ( VALUES
  ('2020-09-15 15:17:19.123'),
  ('09-15-2020 15:17:19.123'),
  ('03-04-95 15:16:19.123'),
  ('09-05-2020 15:17:19.123')
) tbl(t)
ORDER BY 1;

-- Test 281: statement (line 1885)
SELECT parse_timestamp('01-02-2020 01:02:03', 'postgres');

-- Test 282: query (line 1888)
SELECT parse_timestamp('foo');

-- query error relative timestamps are not supported;
SELECT parse_timestamp('now');

-- query error relative timestamps are not supported;
SELECT parse_timestamp('tomorrow');

-- query error relative timestamps are not supported;
SELECT parse_timestamp('now', 'mdy');

-- statement error only ISO style is supported;
SELECT to_char_with_style(now()::timestamp, 'postgres');

-- query TT;
SELECT
  to_char('2020-01-02 01:02:03'::timestamp),
  to_char_with_style('2020-01-02 01:02:03'::timestamp, 'DMY');

CREATE TABLE timestamp_datestyle_parse (pk INT PRIMARY KEY, s TEXT);

-- Test 283: statement (line 1913)
INSERT INTO timestamp_datestyle_parse VALUES
  (1, '07-09-12 11:30:45.123'),
  (2, '07-09-12');

-- Test 284: query (line 1918)
SELECT
  parse_timestamp(s),
  parse_timestamp(s, 'iso,mdy'),
  parse_timestamp(s, 'iso,dmy'),
  parse_timestamp(s, 'iso,ymd')
FROM timestamp_datestyle_parse;
ORDER BY pk;

-- Test 285: statement (line 1930)
SELECT parse_date('01-02-2020 01:02:03', 'postgres');

-- Test 286: query (line 1933)
SELECT parse_date('now');

-- query error relative dates are not supported;
SELECT parse_date('tomorrow', 'iso,mdy');

-- query TTTT;
SELECT
  parse_date(s),
  parse_date(s, 'iso,mdy'),
  parse_date(s, 'iso,dmy'),
  parse_date(s, 'iso,ymd')
FROM timestamp_datestyle_parse;
ORDER BY pk;

-- Test 287: statement (line 1951)
SELECT to_char_with_style(now()::date, 'postgres');

-- Test 288: query (line 1954)
SELECT
  to_char('2020-01-02 01:02:03'::date),
  to_char('2020-01-02'::date, 'YYYY-MM-DD HH24:MI:SS.FF6'),
  to_char_with_style('2020-01-02 01:02:03'::date, 'DMY');

CREATE TABLE time_datestyle_parse (pk INT PRIMARY KEY, s TEXT);

-- Test 289: statement (line 1965)
INSERT INTO time_datestyle_parse VALUES
  (1, '2007-09-12 11:30:45.123+06'),
  (2, '2007-09-12 11:30:45.123+03');

-- Test 290: statement (line 1970)
SELECT parse_time('01-02-2020 01:02:03', 'postgres');

-- Test 291: query (line 1973)
SELECT
  parse_time(s),
  parse_time(s, 'iso,mdy'),
  parse_time(s, 'iso,dmy'),
  parse_time(s, 'iso,ymd')
FROM time_datestyle_parse;
ORDER BY pk;

-- Test 292: statement (line 1985)
SELECT parse_timetz('01-02-2020 01:02:03', 'postgres');

-- Test 293: query (line 1988)
SELECT
  parse_timetz(s),
  parse_timetz(s, 'iso,mdy'),
  parse_timetz(s, 'iso,dmy'),
  parse_timetz(s, 'iso,ymd')
FROM time_datestyle_parse;
ORDER BY pk;

-- Test 294: statement (line 2002)
SET intervalstyle = iso_8601;

-- Test 295: statement (line 2005)
CREATE TABLE table_71776 (interval_col interval DEFAULT 'P3Y');

-- Test 296: query (line 2008)
SELECT a.attname,
    format_type(a.atttypid, a.atttypmod),
    pg_get_expr(d.adbin, d.adrelid)
FROM pg_attribute a
    LEFT JOIN pg_attrdef d ON a.attrelid = d.adrelid AND a.attnum = d.adnum
WHERE a.attrelid = 'table_71776'::regclass
    AND a.attnum > 0
    AND NOT a.attisdropped
ORDER BY a.attnum;

-- Test 297: statement (line 2022)
SELECT * FROM ex WHERE () < '1970-01-02 00:00:01.000001-04';

-- Test 298: statement (line 2025)
SELECT * FROM ex WHERE ROW('1970-01-02 00:00:01.000001-04'::TIMESTAMPTZ) < '1970-01-02 00:00:01.000001-04';

-- Test 299: query (line 2028)
SELECT * FROM ex WHERE ROW('1970-01-03 00:00:01.000001-04'::TIMESTAMPTZ) < ROW('1970-01-02 00:00:01.000001-04');

-- Test 300: query (line 2040)
SELECT make_date(-2013, 7, 15);

-- Test 301: statement (line 2046)
SELECT make_date(0, 11, 11);

-- Test 302: query (line 2059)
SELECT make_timestamp(-2013, 7, 15, 8, 15, 23.5);

-- Test 303: query (line 2073)
select make_timestamp(1, 1, 1, 0, 0, 0);

-- Test 304: query (line 2078)
select make_timestamp(1, 1, 1, 0, 0, 0.1234);

-- Test 305: statement (line 2083)
SELECT make_timestamp(0, 7, 15, 8, 15, 23.5);

-- Test 306: statement (line 2090)
SET TIME ZONE 'EST';

-- Test 307: query (line 2093)
SELECT make_timestamptz(2013, 7, 15, 8, 15, 23.5);

-- Test 308: query (line 2099)
SELECT make_timestamptz(-2013, 7, 15, 8, 15, 23.5);

-- Test 309: query (line 2105)
SELECT make_timestamptz(2013, 7, 15, 8, 15, 23.5231231244234);

-- Test 310: query (line 2111)
SELECT make_timestamptz(2013, 7, 15, 8, 15, 23.5, 'America/New_York');

-- Test 311: query (line 2119)
select make_timestamptz(2020, 1, 1, 0, 0, 0, 'America/New_York');

-- Test 312: query (line 2124)
select make_timestamptz(2020, 1, 1, 0, 0, 0.1234, 'America/New_York');

-- Test 313: statement (line 2129)
SELECT make_timestamptz(0, 7, 15, 8, 15, 23.5);

-- Test 314: statement (line 2132)
SELECT make_timestamptz(0, 7, 15, 8, 15, 23.5, 'America/New_York');

-- Test 315: statement (line 2135)
SELECT make_timestamptz(0, 7, 15, 8, 15, 23.5, 'No');

-- Test 316: query (line 2142)
SELECT date_trunc('day', '2001-02-16 20:38:40+00'::timestamptz, 'Australia/Sydney');

-- Test 317: statement (line 2147)
SELECT date_trunc('day', '0-02-16 20:38:40+00'::timestamptz, 'Australia/Sydney');

-- Test 318: statement (line 2150)
SELECT date_trunc('day', '4-02-16 20:38:40+00'::timestamptz, 'No');

CREATE TABLE t97643 (
  a DATE PRIMARY KEY CHECK (a > '2000-01-01')
);

-- Test 319: query (line 2160)
SELECT conname as constraint_name, pg_get_constraintdef(oid) as details
FROM pg_constraint
WHERE conrelid = 't97643'::regclass;

RESET client_min_messages;
