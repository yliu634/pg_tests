-- PostgreSQL compatible tests from rename_table
--
-- The upstream CockroachDB logic-test file uses Cockroach-only features
-- (`USE`, `SHOW TABLES`, cross-database table names). This reduced version
-- exercises PostgreSQL ALTER TABLE ... RENAME TO and dependency updates.

SET client_min_messages = warning;

DROP VIEW IF EXISTS v;
DROP TABLE IF EXISTS kv;
DROP TABLE IF EXISTS new_kv;

CREATE TABLE kv (
  k INT PRIMARY KEY,
  v INT
);

INSERT INTO kv VALUES (1, 2), (3, 4);
SELECT * FROM kv ORDER BY k;

ALTER TABLE kv RENAME TO new_kv;
SELECT * FROM new_kv ORDER BY k;

CREATE VIEW v AS SELECT k, v FROM new_kv;
SELECT * FROM v ORDER BY k;

-- Rename back; dependent views are updated by PostgreSQL.
ALTER TABLE new_kv RENAME TO kv;
SELECT * FROM v ORDER BY k;

DROP VIEW v;
DROP TABLE kv;

RESET client_min_messages;
