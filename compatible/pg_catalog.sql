SET client_min_messages = warning;

-- PostgreSQL compatible tests from pg_catalog
-- 100 tests
--
-- CockroachDB's pg_catalog surface differs from PostgreSQL in multiple places
-- (cross-database references, custom SHOW/SET database, etc). This file
-- exercises a small set of PostgreSQL pg_catalog queries that are commonly
-- used by clients.

-- Test 1: statement (setup objects)
DROP VIEW IF EXISTS v_cat CASCADE;
DROP TABLE IF EXISTS t_cat CASCADE;
CREATE TABLE t_cat (
  id INT PRIMARY KEY,
  val TEXT
);
INSERT INTO t_cat VALUES (1, 'a'), (2, 'b');
CREATE VIEW v_cat AS SELECT id FROM t_cat;

-- Test 2: query (pg_class)
SELECT relname, relkind
FROM pg_catalog.pg_class
WHERE relname IN ('t_cat', 'v_cat')
ORDER BY relname;

-- Test 3: query (pg_attribute)
SELECT attname, atttypid::regtype::text AS typ, attnotnull
FROM pg_catalog.pg_attribute
WHERE attrelid = 't_cat'::regclass
  AND attnum > 0 AND NOT attisdropped
ORDER BY attnum;

-- Test 4: query (pg_constraint)
SELECT conname, contype
FROM pg_catalog.pg_constraint
WHERE conrelid = 't_cat'::regclass
ORDER BY conname;

-- Test 5: query (pg_tables)
SELECT schemaname, tablename, tableowner
FROM pg_catalog.pg_tables
WHERE tablename = 't_cat';

-- Test 6: query (pg_views)
SELECT schemaname, viewname, viewowner
FROM pg_catalog.pg_views
WHERE viewname = 'v_cat';

RESET client_min_messages;

