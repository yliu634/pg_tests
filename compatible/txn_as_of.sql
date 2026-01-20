-- PostgreSQL compatible tests from txn_as_of
-- Reduced subset: CockroachDB AS OF SYSTEM TIME and retry-specific patterns are
-- not directly applicable to PostgreSQL; validate savepoint behavior instead.

SET client_min_messages = warning;
DROP TABLE IF EXISTS t CASCADE;
RESET client_min_messages;

CREATE TABLE t (i INT);

BEGIN;
INSERT INTO t VALUES (2);
SAVEPOINT s1;
INSERT INTO t VALUES (3);
ROLLBACK TO SAVEPOINT s1;
COMMIT;

SELECT * FROM t ORDER BY i;
