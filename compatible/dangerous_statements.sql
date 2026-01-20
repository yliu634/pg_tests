-- PostgreSQL compatible tests from dangerous_statements
-- NOTE: CockroachDB settings like sql_safe_updates and SET database are not supported by PostgreSQL.
-- This file is adapted to keep the core UPDATE/DELETE/locking statement shapes.

SET client_min_messages = warning;

DROP TABLE IF EXISTS foo;
CREATE TABLE foo (x INT, y INT DEFAULT 0);
INSERT INTO foo (x) VALUES (1), (2), (3);

-- UPDATE variants.
UPDATE foo SET x = 3 WHERE x = 2;
UPDATE foo SET x = 4 WHERE ctid IN (SELECT ctid FROM foo ORDER BY x LIMIT 1);

-- DELETE variants.
DELETE FROM foo WHERE x = 2;
DELETE FROM foo WHERE ctid IN (SELECT ctid FROM foo ORDER BY x LIMIT 1);

-- Locking statements (should run even if the table is empty).
SELECT * FROM foo FOR UPDATE;
SELECT * FROM foo FOR SHARE OF foo SKIP LOCKED;
SELECT * FROM foo WHERE x = 2 FOR UPDATE;
SELECT * FROM foo ORDER BY x LIMIT 1 FOR UPDATE;

SELECT * FROM (SELECT * FROM foo) AS sub FOR UPDATE;
SELECT * FROM (SELECT * FROM foo WHERE x = 2) AS sub FOR UPDATE;
SELECT * FROM (SELECT * FROM foo WHERE x = 2) AS sub FOR UPDATE;
SELECT * FROM (SELECT * FROM (SELECT * FROM foo) AS s WHERE x = 2) AS sub FOR UPDATE;

SELECT * FROM (SELECT * FROM foo FOR UPDATE) AS m WHERE x = 2 FOR UPDATE;
SELECT * FROM (SELECT * FROM foo WHERE x = 2 FOR UPDATE) AS m, (SELECT * FROM foo) AS n FOR SHARE;
SELECT * FROM (SELECT * FROM foo FOR SHARE) AS m, (SELECT * FROM foo) AS n WHERE m.x = n.x;
SELECT * FROM (SELECT * FROM (SELECT * FROM foo) AS s WHERE x > 1) AS sub WHERE x > 2 FOR UPDATE;

ALTER TABLE foo DROP COLUMN x;

RESET client_min_messages;
