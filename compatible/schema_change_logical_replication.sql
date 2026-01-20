-- PostgreSQL compatible tests from schema_change_logical_replication
--
-- The upstream CockroachDB logic-test file mutates internal descriptors to
-- simulate logical replication metadata. PostgreSQL logical replication uses a
-- different architecture (publications/subscriptions) and does not expose
-- similar descriptor tables. This file records that gap without errors.

SET client_min_messages = warning;

SELECT 'SKIPPED: CockroachDB descriptor-based logical replication schema changes are not applicable to PostgreSQL.' AS info;

RESET client_min_messages;
