-- PostgreSQL compatible tests from crdb_internal
-- NOTE: CockroachDB internal schemas (crdb_internal, system) and logic-test directives
-- (statement/query error, let, rowsort, etc) are not supported by PostgreSQL.
-- This file is rewritten to provide a small, deterministic smoke test over pg_catalog.

SET client_min_messages = warning;

DROP SCHEMA IF EXISTS crdb_internal_smoke CASCADE;
CREATE SCHEMA crdb_internal_smoke;

CREATE TABLE crdb_internal_smoke.foo (x INT, y TEXT);
INSERT INTO crdb_internal_smoke.foo (x, y) VALUES (1, 'a'), (2, 'b');

-- Basic relation/catalog presence.
SELECT n.nspname AS schema_name, c.relname AS relname, c.relkind
FROM pg_class AS c
JOIN pg_namespace AS n ON n.oid = c.relnamespace
WHERE n.nspname = 'crdb_internal_smoke'
ORDER BY c.relname;

-- Column metadata.
SELECT a.attname, pg_catalog.format_type(a.atttypid, a.atttypmod) AS data_type
FROM pg_attribute AS a
WHERE a.attrelid = 'crdb_internal_smoke.foo'::regclass
  AND a.attnum > 0
  AND NOT a.attisdropped
ORDER BY a.attnum;

-- Verify data round-trip.
SELECT * FROM crdb_internal_smoke.foo ORDER BY x;

DROP SCHEMA crdb_internal_smoke CASCADE;

RESET client_min_messages;
