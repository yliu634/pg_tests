-- PostgreSQL compatible tests from contention_event
-- NOTE: CockroachDB tracing tables/functions (crdb_internal.*) and transaction PRIORITY are not available in PostgreSQL.
-- This file is rewritten to exercise basic lock/contension introspection via pg_locks.

SET client_min_messages = warning;

DROP TABLE IF EXISTS kv;
CREATE TABLE kv (k TEXT PRIMARY KEY, v TEXT);
INSERT INTO kv (k, v) VALUES ('k', 'v');

-- Acquire a row lock and observe relation locks in pg_locks (single-session smoke test).
BEGIN;
UPDATE kv SET v = v WHERE k = 'k';
SELECT locktype, mode, granted
FROM pg_locks
WHERE relation = 'kv'::regclass
ORDER BY locktype, mode;
ROLLBACK;

RESET client_min_messages;
