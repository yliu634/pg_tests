-- PostgreSQL compatible tests from discard
-- NOTE: CockroachDB session settings and SHOW commands differ from PostgreSQL.
-- This file is rewritten to cover basic PostgreSQL DISCARD behavior.

SET client_min_messages = warning;

-- Prepared statement lifecycle.
PREPARE s1 AS SELECT 1;
EXECUTE s1;
DEALLOCATE s1;

-- DISCARD commands (should succeed).
DISCARD PLANS;
DISCARD TEMP;
DISCARD ALL;

RESET client_min_messages;
