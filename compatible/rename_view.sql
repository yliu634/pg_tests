-- PostgreSQL compatible tests from rename_view
--
-- The upstream CockroachDB logic-test file uses Cockroach-only features
-- (cross-db views, `SHOW TABLES`, `SHOW GRANTS`, `SET DATABASE`). This reduced
-- version tests ALTER VIEW ... RENAME TO in PostgreSQL.

SET client_min_messages = warning;

DROP VIEW IF EXISTS v;
DROP VIEW IF EXISTS new_v;
DROP TABLE IF EXISTS kv;

CREATE TABLE kv (
  k INT PRIMARY KEY,
  v INT
);

INSERT INTO kv VALUES (1, 2), (3, 4);

CREATE VIEW v AS SELECT k, v FROM kv;
SELECT * FROM v ORDER BY k;

ALTER VIEW v RENAME TO new_v;
SELECT * FROM new_v ORDER BY k;

ALTER VIEW new_v RENAME TO v;
SELECT * FROM v ORDER BY k;

DROP VIEW v;
DROP TABLE kv;

RESET client_min_messages;
