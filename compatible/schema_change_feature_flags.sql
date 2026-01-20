-- PostgreSQL compatible tests from schema_change_feature_flags
--
-- CockroachDB exposes schema-change feature flags via cluster settings (e.g.
-- feature.schema_change.enabled) and multi-region DDL. PostgreSQL has no
-- equivalent feature-flag mechanism. This file records that gap without
-- emitting errors.

SET client_min_messages = warning;

SELECT 'SKIPPED: CockroachDB schema-change feature flags and multi-region DDL are not supported in PostgreSQL.' AS info;

RESET client_min_messages;
