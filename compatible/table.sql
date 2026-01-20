-- PostgreSQL compatible tests from table
-- Reduced subset: CockroachDB `SET DATABASE` and SHOW TABLES/INDEXES directives
-- are replaced with PostgreSQL catalog queries.

SET client_min_messages = warning;
DROP SCHEMA IF EXISTS test CASCADE;
RESET client_min_messages;

CREATE SCHEMA test;

CREATE TABLE test.a (id INT PRIMARY KEY);
COMMENT ON TABLE test.a IS 'a_comment';

-- SHOW TABLES FROM test
SELECT table_schema, table_name
FROM information_schema.tables
WHERE table_schema = 'test' AND table_type = 'BASE TABLE'
ORDER BY table_name;

CREATE TABLE test.c (
  id  INT PRIMARY KEY,
  foo INT CONSTRAINT foo_positive CHECK (foo > 0),
  bar INT
);

CREATE INDEX c_foo_idx ON test.c(foo);
CREATE INDEX c_foo_bar_idx ON test.c(foo ASC, bar DESC);
ALTER TABLE test.c ADD CONSTRAINT c_bar_unique UNIQUE (bar);

COMMENT ON INDEX test.c_foo_idx IS 'index_comment';

-- SHOW INDEXES FROM c
SELECT indexname, indexdef
FROM pg_indexes
WHERE schemaname = 'test' AND tablename = 'c'
ORDER BY indexname;

-- SHOW CONSTRAINTS FROM c
SELECT conname, contype
FROM pg_constraint
JOIN pg_class ON pg_constraint.conrelid = pg_class.oid
JOIN pg_namespace n ON n.oid = pg_class.relnamespace
WHERE n.nspname = 'test' AND pg_class.relname = 'c'
ORDER BY conname;

-- SHOW COLUMNS equivalents.
CREATE TABLE test.d (id INT PRIMARY KEY);
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_schema = 'test' AND table_name = 'd'
ORDER BY ordinal_position;

CREATE TABLE test.f (
  a INT,
  b INT,
  c INT,
  PRIMARY KEY (a, b, c)
);
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_schema = 'test' AND table_name = 'f'
ORDER BY ordinal_position;
