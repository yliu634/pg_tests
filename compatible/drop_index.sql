-- PostgreSQL compatible tests from drop_index
--
-- CockroachDB has table@index syntax, schema changer settings, and internal
-- catalogs not present in PostgreSQL. This file exercises DROP INDEX behavior
-- using pg_catalog queries.

SET client_min_messages = warning;
DROP TABLE IF EXISTS drop_index_test CASCADE;
DROP SCHEMA IF EXISTS drop_index_schema CASCADE;
RESET client_min_messages;

CREATE TABLE drop_index_test (a INT, b INT, c TEXT);
INSERT INTO drop_index_test VALUES
  (1, 1, 'x'),
  (2, 2, 'y'),
  (3, 3, 'z');

CREATE INDEX drop_index_test_a_idx ON drop_index_test(a);
CREATE UNIQUE INDEX drop_index_test_b_idx ON drop_index_test(b);
CREATE INDEX drop_index_test_expr_idx ON drop_index_test((lower(c)));

SELECT schemaname, tablename, indexname
FROM pg_indexes
WHERE schemaname = 'public' AND tablename = 'drop_index_test'
ORDER BY indexname;

DROP INDEX drop_index_test_expr_idx;

SELECT schemaname, tablename, indexname
FROM pg_indexes
WHERE schemaname = 'public' AND tablename = 'drop_index_test'
ORDER BY indexname;

-- Schema-qualified index.
CREATE SCHEMA drop_index_schema;
CREATE TABLE drop_index_schema.t (a INT);
CREATE INDEX t_a_idx ON drop_index_schema.t(a);

SELECT schemaname, tablename, indexname
FROM pg_indexes
WHERE schemaname = 'drop_index_schema'
ORDER BY indexname;

DROP INDEX drop_index_schema.t_a_idx;

SELECT schemaname, tablename, indexname
FROM pg_indexes
WHERE schemaname = 'drop_index_schema'
ORDER BY indexname;

-- IF EXISTS should be a no-op.
DROP INDEX IF EXISTS drop_index_schema.t_a_idx;

DROP TABLE drop_index_test;
DROP SCHEMA drop_index_schema CASCADE;
