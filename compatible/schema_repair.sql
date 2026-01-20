-- PostgreSQL compatible tests from schema_repair
--
-- CockroachDB exposes internal descriptor repair APIs (crdb_internal.*) for
-- recovering from catalog corruption. PostgreSQL does not expose equivalent SQL
-- interfaces for descriptor-level repair. This file records that gap.

SET client_min_messages = warning;

SELECT 'SKIPPED: CockroachDB schema repair via crdb_internal descriptor APIs is not supported in PostgreSQL.' AS info;

RESET client_min_messages;
