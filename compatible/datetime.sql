-- PostgreSQL compatible tests from datetime
-- NOTE: CockroachDB datetime tests include CRDB-specific settings and functions.
-- This file is rewritten to cover core PostgreSQL date/time behavior.

SET client_min_messages = warning;

SELECT current_date AS current_date;
SELECT current_time(0) AS current_time_0;
SELECT current_timestamp(0) AS current_timestamp_0;

-- Time zone conversions.
SELECT (timestamp '2020-01-01 12:34:56' AT TIME ZONE 'UTC') AS ts_utc;
SELECT (timestamptz '2020-01-01 12:34:56+00' AT TIME ZONE 'America/Los_Angeles') AS ts_la;

-- Interval arithmetic.
SELECT timestamp '2020-01-01 00:00:00' + interval '1 day 2 hours' AS ts_plus_interval;
SELECT interval '3 days' - interval '5 hours' AS interval_diff;

-- Truncation + extract.
SELECT date_trunc('hour', timestamptz '2020-01-01 12:34:56+00') AS trunc_hour;
SELECT extract(epoch FROM interval '1 minute') AS epoch_from_interval;

RESET client_min_messages;
