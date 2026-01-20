-- PostgreSQL compatible tests from information_schema
--
-- CockroachDB logic tests for information_schema include many CRDB-only knobs.
-- This file keeps a small deterministic set of information_schema checks.

SET client_min_messages = warning;

DROP VIEW IF EXISTS is_view;
DROP TABLE IF EXISTS is_table;
DROP SEQUENCE IF EXISTS is_seq;
DROP TYPE IF EXISTS is_enum;
DROP DOMAIN IF EXISTS is_domain;
DROP FUNCTION IF EXISTS is_fn(int);

CREATE TABLE is_table (
  id INT PRIMARY KEY,
  name TEXT,
  created_at TIMESTAMPTZ
);

CREATE VIEW is_view AS
SELECT id, name FROM is_table;

CREATE SEQUENCE is_seq START 1;

CREATE TYPE is_enum AS ENUM ('a', 'b');

CREATE DOMAIN is_domain AS TEXT CHECK (VALUE <> '');

CREATE FUNCTION is_fn(x INT)
RETURNS INT
LANGUAGE SQL
AS $$
  SELECT x + 1;
$$;

-- information_schema.tables includes both tables and views.
SELECT table_name, table_type
FROM information_schema.tables
WHERE table_schema = 'public'
  AND table_name IN ('is_table', 'is_view')
ORDER BY table_name;

SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'public' AND table_name = 'is_table'
ORDER BY ordinal_position;

SELECT routine_name, routine_type, data_type
FROM information_schema.routines
WHERE routine_schema = 'public' AND routine_name = 'is_fn'
ORDER BY routine_name;

SELECT constraint_name, constraint_type
FROM information_schema.table_constraints
WHERE table_schema = 'public' AND table_name = 'is_table'
  AND constraint_type IN ('PRIMARY KEY', 'FOREIGN KEY')
ORDER BY constraint_name;

SELECT sequence_name, data_type
FROM information_schema.sequences
WHERE sequence_schema = 'public' AND sequence_name = 'is_seq';

SELECT domain_name, data_type
FROM information_schema.domains
WHERE domain_schema = 'public' AND domain_name = 'is_domain';

SELECT t.typname AS type_name
FROM pg_type t
JOIN pg_namespace n ON n.oid = t.typnamespace
WHERE n.nspname = 'public' AND t.typname = 'is_enum';

-- Cleanup.
DROP VIEW is_view;
DROP TABLE is_table;
DROP SEQUENCE is_seq;
DROP TYPE is_enum;
DROP DOMAIN is_domain;
DROP FUNCTION is_fn(int);

RESET client_min_messages;
