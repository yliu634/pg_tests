-- PostgreSQL compatible tests from jobs
--
-- CockroachDB exposes SHOW JOBS and crdb_internal.jobs. PostgreSQL does not
-- have an equivalent built-in job system; this file performs small deterministic
-- catalog checks instead.

SET client_min_messages = warning;

SELECT to_regclass('pg_catalog.pg_stat_activity') IS NOT NULL AS has_pg_stat_activity;

SELECT count(*) >= 1 AS has_self
FROM pg_stat_activity
WHERE pid = pg_backend_pid();

RESET client_min_messages;
