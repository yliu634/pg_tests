-- PostgreSQL compatible tests from txn
-- Reduced subset: remove CockroachDB logic-test directives and error-expecting
-- cases; validate basic PostgreSQL transaction semantics.

SET client_min_messages = warning;
DROP TABLE IF EXISTS kv CASCADE;
RESET client_min_messages;

CREATE TABLE kv (
  k TEXT PRIMARY KEY,
  v TEXT
);

INSERT INTO kv(k, v) VALUES ('a', 'b');
SELECT * FROM kv ORDER BY k;

BEGIN;
UPDATE kv SET v = 'c' WHERE k = 'a';
SELECT * FROM kv ORDER BY k;
ROLLBACK;

SELECT * FROM kv ORDER BY k;

BEGIN;
UPDATE kv SET v = 'd' WHERE k = 'a';
COMMIT;

SELECT * FROM kv ORDER BY k;

-- Savepoint behavior.
BEGIN;
SAVEPOINT s1;
UPDATE kv SET v = 'e' WHERE k = 'a';
SELECT * FROM kv ORDER BY k;
ROLLBACK TO SAVEPOINT s1;
SELECT * FROM kv ORDER BY k;
COMMIT;

SELECT * FROM kv ORDER BY k;
