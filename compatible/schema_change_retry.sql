-- PostgreSQL compatible tests from schema_change_retry
--
-- CockroachDB includes automatic transaction retries and exposes retry-related
-- knobs (cockroach_restart savepoints, refresh span limits). PostgreSQL does
-- not provide equivalent automatic retry semantics. This file records that gap.

SET client_min_messages = warning;

SELECT 'SKIPPED: CockroachDB schema-change retry semantics (cockroach_restart, refresh spans) are not supported in PostgreSQL.' AS info;

RESET client_min_messages;
