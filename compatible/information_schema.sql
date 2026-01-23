-- PostgreSQL compatible tests from information_schema
--
-- This file was adapted for PostgreSQL execution via psql. The original
-- CockroachDB logic-test directives (query/statement/user/SET DATABASE/SHOW
-- variants) are not directly executable on PostgreSQL.

SET client_min_messages = warning;

-- Roles are cluster-global; schemas are per-database.
DROP SCHEMA IF EXISTS is_test CASCADE;
DROP ROLE IF EXISTS is_testuser;

CREATE ROLE is_testuser LOGIN;
CREATE SCHEMA is_test;

CREATE DOMAIN is_test.positive_int AS integer CHECK (VALUE > 0);
CREATE TYPE is_test.mood AS ENUM ('sad', 'ok', 'happy');

CREATE TABLE is_test.parent (
  id is_test.positive_int PRIMARY KEY,
  name text NOT NULL UNIQUE
);

CREATE TABLE is_test.child (
  id is_test.positive_int PRIMARY KEY,
  parent_id is_test.positive_int NOT NULL REFERENCES is_test.parent(id),
  tags text[]
);

CREATE SEQUENCE is_test.seq START WITH 10 INCREMENT BY 1;

CREATE VIEW is_test.v_child AS
SELECT c.id, p.name AS parent_name, c.tags
FROM is_test.child AS c
JOIN is_test.parent AS p ON p.id = c.parent_id;

CREATE FUNCTION is_test.f_add(a integer, b integer)
RETURNS integer
LANGUAGE sql
AS $$
  SELECT a + b;
$$;

INSERT INTO is_test.parent (id, name) VALUES (1, 'p1'), (2, 'p2');
INSERT INTO is_test.child (id, parent_id, tags) VALUES
  (10, 1, ARRAY['a', 'b']),
  (20, 2, ARRAY[]::text[]);

GRANT USAGE ON SCHEMA is_test TO is_testuser;
GRANT SELECT ON ALL TABLES IN SCHEMA is_test TO is_testuser;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA is_test TO is_testuser;
GRANT EXECUTE ON FUNCTION is_test.f_add(integer, integer) TO is_testuser;

SET ROLE is_testuser;

-- Schemata.
SELECT schema_name
FROM information_schema.schemata
WHERE schema_name IN ('information_schema', 'is_test')
ORDER BY schema_name;

-- Tables and views.
SELECT table_schema, table_name, table_type, is_insertable_into
FROM information_schema.tables
WHERE table_schema = 'is_test'
  AND table_name IN ('parent', 'child', 'v_child')
ORDER BY table_schema, table_name;

-- Columns.
SELECT table_name, ordinal_position, column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_schema = 'is_test'
  AND table_name IN ('parent', 'child')
ORDER BY table_name, ordinal_position;

-- Constraints.
SELECT tc.table_name, tc.constraint_name, tc.constraint_type, kcu.column_name
FROM information_schema.table_constraints AS tc
LEFT JOIN information_schema.key_column_usage AS kcu
  ON kcu.constraint_name = tc.constraint_name
  AND kcu.constraint_schema = tc.constraint_schema
  AND kcu.table_name = tc.table_name
WHERE tc.table_schema = 'is_test'
ORDER BY tc.table_name, tc.constraint_name, kcu.ordinal_position;

-- Sequences.
SELECT sequence_schema, sequence_name, data_type, start_value, increment
FROM information_schema.sequences
WHERE sequence_schema = 'is_test'
ORDER BY sequence_schema, sequence_name;

-- Views.
SELECT table_schema, table_name, is_updatable
FROM information_schema.views
WHERE table_schema = 'is_test'
ORDER BY table_schema, table_name;

-- Routines.
SELECT routine_schema, routine_name, routine_type, data_type
FROM information_schema.routines
WHERE routine_schema = 'is_test'
ORDER BY routine_schema, routine_name;

-- Parameters.
SELECT specific_name, ordinal_position, parameter_mode, data_type
FROM information_schema.parameters
WHERE specific_schema = 'is_test'
ORDER BY specific_name, ordinal_position;

-- User-defined types.
SELECT user_defined_type_schema, user_defined_type_name, data_type
FROM information_schema.user_defined_types
WHERE user_defined_type_schema = 'is_test'
ORDER BY user_defined_type_schema, user_defined_type_name;

-- Privileges.
SELECT grantee, table_schema, table_name, privilege_type
FROM information_schema.table_privileges
WHERE grantee = 'is_testuser'
  AND table_schema = 'is_test'
ORDER BY table_name, privilege_type;

RESET ROLE;

DROP SCHEMA is_test CASCADE;
DROP ROLE is_testuser;

RESET client_min_messages;
