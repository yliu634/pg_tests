-- PostgreSQL compatible tests from txn_as_of
-- 51 tests

SET client_min_messages = warning;

-- Ensure deterministic output for now().
CREATE OR REPLACE FUNCTION now() RETURNS TIMESTAMP STABLE LANGUAGE SQL AS $$
  SELECT TIMESTAMP '1999-12-31 23:59:59.999999';
$$;
SET search_path = public, pg_catalog;

-- Setup
DROP TABLE IF EXISTS t;
CREATE TABLE t (i INT);
INSERT INTO t VALUES (2);

-- CockroachDB cluster setting; no PostgreSQL equivalent.
-- SET CLUSTER SETTING kv.gc_ttl.strict_enforcement.enabled = false;

SELECT * FROM t ORDER BY i;

INSERT INTO t VALUES (3);
INSERT INTO t VALUES (3);

SELECT * FROM t ORDER BY i;

-- Savepoint-based retry pattern (CockroachDB client convention).
BEGIN;
SAVEPOINT cockroach_restart;
SELECT * FROM (SELECT now());
ROLLBACK TO SAVEPOINT cockroach_restart;
SELECT * FROM (SELECT now());
RELEASE SAVEPOINT cockroach_restart;
COMMIT;

BEGIN;
SAVEPOINT cockroach_restart;
SELECT * FROM (SELECT now());
ROLLBACK TO SAVEPOINT cockroach_restart;
SELECT * FROM (SELECT now());
RELEASE SAVEPOINT cockroach_restart;
COMMIT;

BEGIN;
SAVEPOINT cockroach_restart;
-- Expected ERROR (division by zero):
\set ON_ERROR_STOP 0
SELECT 1/0;
\set ON_ERROR_STOP 1
ROLLBACK TO SAVEPOINT cockroach_restart;
SELECT * FROM (SELECT now());
RELEASE SAVEPOINT cockroach_restart;
COMMIT;

BEGIN;
ROLLBACK;

BEGIN;
ROLLBACK;

RESET search_path;
RESET client_min_messages;
