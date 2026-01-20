-- PostgreSQL compatible tests from gen_test_objects
--
-- CockroachDB's `crdb_internal.generate_test_objects(...)` is not available in
-- PostgreSQL. This adapted test creates a small, deterministic set of schemas
-- and objects and then verifies them via information_schema queries.

SET client_min_messages = warning;
DROP SCHEMA IF EXISTS gto_1 CASCADE;
DROP SCHEMA IF EXISTS gto_2 CASCADE;
DROP SCHEMA IF EXISTS gto_other CASCADE;
RESET client_min_messages;

CREATE SCHEMA gto_1;
CREATE SCHEMA gto_2;
CREATE SCHEMA gto_other;

CREATE TABLE gto_1.base (
  id int PRIMARY KEY,
  v text NOT NULL
);

CREATE TABLE gto_1.child (LIKE gto_1.base INCLUDING ALL);
ALTER TABLE gto_1.child ADD COLUMN extra int;

CREATE TABLE gto_2.t (
  id serial PRIMARY KEY,
  payload text
);

-- "Generated counts" style output, scoped to our own schemas.
SELECT jsonb_build_object(
  'schemas', (
    SELECT count(*) FROM information_schema.schemata WHERE schema_name LIKE 'gto_%'
  ),
  'tables', (
    SELECT count(*)
    FROM information_schema.tables
    WHERE table_schema LIKE 'gto_%'
      AND table_type = 'BASE TABLE'
  ),
  'columns', (
    SELECT count(*) FROM information_schema.columns WHERE table_schema LIKE 'gto_%'
  )
) AS generated_counts;

SELECT schema_name
FROM information_schema.schemata
WHERE schema_name LIKE 'gto_%'
ORDER BY schema_name;

SELECT table_schema, table_name
FROM information_schema.tables
WHERE table_schema LIKE 'gto_%'
  AND table_type = 'BASE TABLE'
ORDER BY table_schema, table_name;

SELECT table_schema, table_name, column_name, data_type
FROM information_schema.columns
WHERE table_schema LIKE 'gto_%'
ORDER BY table_schema, table_name, ordinal_position;

SELECT table_schema, table_name, constraint_name
FROM information_schema.table_constraints
WHERE table_schema LIKE 'gto_%'
  AND constraint_type = 'PRIMARY KEY'
ORDER BY table_schema, table_name, constraint_name;

-- search_path behavior: if an earlier schema doesn't exist, the next one wins.
SET search_path = invalidschema, gto_other, public;
CREATE TABLE foo_in_search_path (x int);
RESET search_path;

SELECT table_schema, table_name
FROM information_schema.tables
WHERE table_name = 'foo_in_search_path'
ORDER BY table_schema, table_name;

SET client_min_messages = warning;
DROP SCHEMA IF EXISTS gto_1 CASCADE;
DROP SCHEMA IF EXISTS gto_2 CASCADE;
DROP SCHEMA IF EXISTS gto_other CASCADE;
RESET client_min_messages;
