-- PostgreSQL compatible tests from rename_column
--
-- The upstream CockroachDB logic-test file contains many Cockroach-only
-- features (inline indexes, SHOW commands, schema_locked, vectorize, ALTER
-- PRIMARY KEY). This reduced version exercises PostgreSQL column renames and
-- dependency updates (views/indexes) without errors.

SET client_min_messages = warning;

DROP VIEW IF EXISTS v1;
DROP VIEW IF EXISTS v2;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
  uid INT PRIMARY KEY,
  name TEXT NOT NULL,
  title TEXT
);

CREATE INDEX users_name_idx ON users(name);
CREATE UNIQUE INDEX users_uid_name_uq ON users(uid, name);

INSERT INTO users VALUES (1, 'tom', 'cat'), (2, 'jerry', 'rat');

ALTER TABLE users RENAME COLUMN uid TO id;
ALTER TABLE users RENAME COLUMN name TO username;
ALTER TABLE users RENAME COLUMN title TO species;

SELECT * FROM users ORDER BY id;

CREATE VIEW v1 AS SELECT id FROM users WHERE username = 'tom';
SELECT * FROM v1;

-- Rename back; dependent views are updated by PostgreSQL.
ALTER TABLE users RENAME COLUMN id TO uid;
ALTER TABLE users RENAME COLUMN username TO name;
ALTER TABLE users RENAME COLUMN species TO title;

CREATE VIEW v2 AS SELECT uid FROM users;
SELECT * FROM v2 ORDER BY uid;

DROP VIEW v1;
DROP VIEW v2;
DROP TABLE users;

RESET client_min_messages;
