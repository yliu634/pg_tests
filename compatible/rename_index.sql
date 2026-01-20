-- PostgreSQL compatible tests from rename_index
--
-- The upstream CockroachDB logic-test file uses Cockroach-only index syntax
-- (inline indexes, `table@index`, `SHOW INDEXES`). This reduced version tests
-- PostgreSQL ALTER INDEX ... RENAME and inspects pg_indexes.

SET client_min_messages = warning;

DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id    INT PRIMARY KEY,
  name  TEXT NOT NULL,
  title TEXT
);

CREATE INDEX users_foo_idx ON users(name);
CREATE UNIQUE INDEX users_bar_idx ON users(id, name);

INSERT INTO users VALUES (1, 'tom', 'cat'), (2, 'jerry', 'rat');

SELECT indexname
  FROM pg_indexes
 WHERE schemaname = 'public' AND tablename = 'users'
 ORDER BY indexname;

ALTER INDEX users_foo_idx RENAME TO users_foo_new;

SELECT indexname
  FROM pg_indexes
 WHERE schemaname = 'public' AND tablename = 'users'
 ORDER BY indexname;

BEGIN;
ALTER INDEX users_foo_new RENAME TO users_foo_idx;
COMMIT;

SELECT indexname
  FROM pg_indexes
 WHERE schemaname = 'public' AND tablename = 'users'
 ORDER BY indexname;

DROP TABLE users;

RESET client_min_messages;
