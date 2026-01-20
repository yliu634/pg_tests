-- PostgreSQL compatible tests from time
-- Reduced subset: remove CockroachDB-only cast syntax (:::), collations that may
-- not exist, and invalid time literals that raise ERROR in PostgreSQL.

-- Basic parsing.
SELECT '12:00:00'::TIME;
SELECT '12:00:00.456'::TIME;
SELECT '00:00:00'::TIME;
SELECT '23:59:59.999999'::TIME;

-- Conversions.
SELECT TIMESTAMP '2017-01-01 12:00:00'::TIME;
SELECT TIMESTAMPTZ '2017-01-01 12:00:00-05'::TIME;
SELECT INTERVAL '12 hours'::TIME;
SELECT '12:00:00'::TIME::INTERVAL;

-- Comparisons.
SELECT '12:00:00'::TIME = '12:00:00'::TIME;
SELECT '12:00:00'::TIME = '12:00:00.000001'::TIME;
SELECT '12:00:00'::TIME < '12:00:00.000001'::TIME;
SELECT '12:00:00'::TIME > '11:59:59.999999'::TIME;
SELECT '12:00:00'::TIME IN ('12:00:00');

-- Arithmetic with intervals.
SELECT '12:00:00'::TIME + INTERVAL '1 second';
SELECT '23:59:59'::TIME + INTERVAL '1 second';
SELECT '12:00:00'::TIME - INTERVAL '1 second';
SELECT '00:00:00'::TIME - INTERVAL '1 second';
SELECT '12:00:00'::TIME - '11:59:59'::TIME;

-- Date + time yields timestamp.
SELECT DATE '2017-01-01' + TIME '12:00:00';
