-- PostgreSQL compatible tests from schema_locked
--
-- CockroachDB supports a `schema_locked` table storage parameter and related
-- cluster settings. PostgreSQL has no equivalent concept. This file records the
-- incompatibility without producing psql errors.

SET client_min_messages = warning;

SELECT 'SKIPPED: schema_locked storage parameter is CockroachDB-specific.' AS info;

RESET client_min_messages;
