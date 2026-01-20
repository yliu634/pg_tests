-- PostgreSQL compatible tests from distsql_event_log
-- NOTE: CockroachDB event log tables are not available in PostgreSQL.
-- This file is rewritten to use a simple table as an "event log" placeholder.

SET client_min_messages = warning;

DROP TABLE IF EXISTS event_log;
CREATE TABLE event_log (ts TIMESTAMPTZ DEFAULT now(), msg TEXT);
INSERT INTO event_log (msg) VALUES ('one'), ('two');

SELECT msg, ts IS NOT NULL AS ts_nonnull
FROM event_log
ORDER BY msg;

RESET client_min_messages;
