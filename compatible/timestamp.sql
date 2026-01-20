-- PostgreSQL compatible tests from timestamp
-- Reduced subset: remove CockroachDB-only cast syntax (:::), logic-test
-- directives, and CRDB SHOW COLUMNS syntax.

SET TIME ZONE 'UTC';

-- Basic literals.
SELECT TIMESTAMP '2000-05-05 10:00:00';
SELECT TIMESTAMPTZ '2000-05-05 10:00:00+03';

-- AT TIME ZONE / timezone() examples.
SELECT
  TIMESTAMP '2001-02-16 20:38:40' AT TIME ZONE '-07' AS at_tz,
  timezone('-07', TIMESTAMP '2001-02-16 20:38:40') AS timezone_fn;

CREATE TABLE timestamp_test (
  id  INT PRIMARY KEY,
  t   TIMESTAMP(5),
  ttz TIMESTAMPTZ(4)
);

INSERT INTO timestamp_test VALUES
  (1, '2001-01-01 12:00:00.123456', '2001-01-01 12:00:00.123456+04'),
  (2, '2001-01-01 12:00:00.12345',  '2001-01-01 12:00:00.12345+04'),
  (3, '2001-01-01 12:00:00.1',      '2001-01-01 12:00:00.1+04'),
  (4, '2001-01-01 12:00:00',        '2001-01-01 12:00:00+04');

SELECT * FROM timestamp_test ORDER BY id;

-- SHOW COLUMNS equivalent.
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'public' AND table_name = 'timestamp_test'
ORDER BY column_name;

SELECT id,
       t::timestamp(0) AS t_0,
       t::timestamp(3) AS t_3,
       ttz::timestamptz(0) AS ttz_0,
       ttz::timestamptz(3) AS ttz_3
FROM timestamp_test
ORDER BY id;

SET TIME ZONE '-05';

SELECT '2001-01-01'::date = '2001-01-01 00:00:00'::timestamp;

SELECT extract(hour FROM TIMESTAMPTZ '2001-01-01 13:00:00+01');
SELECT extract(timezone FROM TIMESTAMPTZ '2001-01-01 13:00:00+01:15');
