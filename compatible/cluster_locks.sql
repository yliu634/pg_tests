-- PostgreSQL compatible tests from cluster_locks
--
-- NOTE: The upstream CockroachDB test relies on Cockroach-only cluster settings,
-- crdb_internal.{cluster_locks,cluster_queries}, and multi-session logic-test
-- directives (user/let/awaitstatement). PostgreSQL has no direct equivalent.
--
-- This PG adaptation validates that row locks taken by SELECT ... FOR UPDATE and
-- SELECT ... FOR SHARE are visible via pg_locks, and that they are released on
-- COMMIT/ROLLBACK.

SET client_min_messages = warning;

DROP TABLE IF EXISTS t2;
DROP TABLE IF EXISTS t;

CREATE TABLE t (
  k TEXT PRIMARY KEY,
  v TEXT
);

CREATE TABLE t2 (
  k TEXT PRIMARY KEY,
  v TEXT
);

INSERT INTO t VALUES
  ('a', 'val1'),
  ('b', 'val2'),
  ('c', 'val3');

INSERT INTO t2 VALUES
  ('a', 'val1'),
  ('b', 'val2');

-- Serializable row locks (FOR UPDATE).
SET default_transaction_isolation = 'serializable';

BEGIN;
SHOW transaction_isolation;

SELECT * FROM t WHERE k IN ('a', 'b') FOR UPDATE;

-- Relation-level locks held by this backend.
SELECT locktype, relation::regclass AS relation, mode, granted
FROM pg_locks
WHERE pid = pg_backend_pid()
  AND relation IN ('t'::regclass, 't2'::regclass)
ORDER BY relation, locktype, mode;

-- Tuple locks held on t (one row per locked tuple).
SELECT locktype, relation::regclass AS relation, page, tuple, mode, granted
FROM pg_locks
WHERE pid = pg_backend_pid()
  AND locktype = 'tuple'
  AND relation = 't'::regclass
ORDER BY page, tuple, mode;

COMMIT;

-- After COMMIT, locks on user tables should be released.
SELECT count(*) AS locks_after_commit
FROM pg_locks
WHERE pid = pg_backend_pid()
  AND relation IN ('t'::regclass, 't2'::regclass);

-- Read committed shared locks (FOR SHARE) and release on ROLLBACK.
BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;
SHOW transaction_isolation;

SELECT * FROM t2 WHERE k = 'a' FOR SHARE;

SELECT locktype, relation::regclass AS relation, page, tuple, mode, granted
FROM pg_locks
WHERE pid = pg_backend_pid()
  AND locktype = 'tuple'
  AND relation = 't2'::regclass
ORDER BY page, tuple, mode;

ROLLBACK;

SELECT count(*) AS locks_after_rollback
FROM pg_locks
WHERE pid = pg_backend_pid()
  AND relation IN ('t'::regclass, 't2'::regclass);

RESET client_min_messages;
