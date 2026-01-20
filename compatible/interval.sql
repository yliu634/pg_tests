-- PostgreSQL compatible tests from interval
--
-- The original CockroachDB logic test includes CRDB-only parsing rules and
-- expected error cases. This file keeps deterministic PostgreSQL interval
-- behavior checks.

SET client_min_messages = warning;
SET TIME ZONE 'UTC';

DROP TABLE IF EXISTS interval_test;

CREATE TABLE interval_test (id INT PRIMARY KEY, i INTERVAL);
INSERT INTO interval_test VALUES
  (1, INTERVAL '1 day'),
  (2, INTERVAL '2 hours'),
  (3, INTERVAL '1 day 2 hours 3 minutes'),
  (4, INTERVAL '0 seconds'),
  (5, INTERVAL '1 week');

SELECT id, extract(epoch from i)::bigint AS seconds
FROM interval_test
ORDER BY id;

SELECT extract(epoch from (INTERVAL '1 day' + INTERVAL '2 hours'))::bigint AS sum_seconds;

SELECT date_trunc('hour', TIMESTAMP '2000-01-01 01:23:45') AS truncated;

DROP TABLE interval_test;

RESET TIME ZONE;
RESET client_min_messages;
