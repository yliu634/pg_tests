-- PostgreSQL compatible tests from timetz
-- Reduced subset: remove CockroachDB-only cast syntax (:::), logic-test
-- directives, and non-deterministic CURRENT_TIME tests.

SET TIME ZONE 'UTC';

CREATE TABLE timetz_test (a TIMETZ PRIMARY KEY, b TIMETZ, c INT);
INSERT INTO timetz_test VALUES
  ('11:00:00+00', '12:00:00+01', 1),
  ('12:00:00+01', '10:00:00-01', 2);

SELECT '12:00:00+00'::timetz > '11:59:59+00'::timetz;

SET TIME ZONE '-05';
SELECT '11:00+03:00'::timetz::time;
SELECT '11:00'::time::timetz;
SELECT TIMESTAMPTZ '2001-01-01 11:00+04:00'::timetz;

SET TIME ZONE 'UTC';
SELECT '12:00:00'::timetz;
SELECT '12:00:00.456+00'::timetz;
SELECT TIMETZ '12:00:00-07';

SELECT '11:00:00-07:00'::timetz::time;
SELECT '12:00:00+00'::timetz = '12:00:00+00'::timetz;
