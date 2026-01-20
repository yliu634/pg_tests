-- PostgreSQL compatible tests from row_level_ttl
--
-- CockroachDB supports Row-Level TTL via table storage parameters like
-- `ttl_expire_after` and internal job management helpers. PostgreSQL has no
-- built-in row TTL feature. This file records that gap without producing
-- execution errors.

SET client_min_messages = warning;

SELECT 'SKIPPED: row-level TTL (ttl_expire_after/ttl_expiration_expression) is CockroachDB-specific.' AS info;

RESET client_min_messages;
