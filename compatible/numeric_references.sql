SET client_min_messages = warning;

-- PostgreSQL compatible tests from numeric_references
-- 44 tests
--
-- CockroachDB supports addressing objects by numeric IDs using bracket syntax
-- (e.g. SELECT * FROM [123]). PostgreSQL does not support that SQL surface area,
-- but it does expose numeric OIDs for objects and supports regclass casts for
-- name <-> OID round-trips. This file exercises those PG-native equivalents.

-- Test 1: statement (line 1)
DROP VIEW IF EXISTS view_ref CASCADE;
DROP TABLE IF EXISTS x CASCADE;
DROP SEQUENCE IF EXISTS seq;

CREATE TABLE x (
  a INT PRIMARY KEY,
  b INT,
  c INT
);
INSERT INTO x(a, b, c) VALUES (1, 10, 100), (2, 20, 200), (3, 30, 300);

-- Test 2: statement (line 4)
CREATE VIEW view_ref AS SELECT a, 1 AS one FROM x;

-- Test 3: statement (line 7)
CREATE SEQUENCE seq;

-- Test 4: query (line 13)
SELECT 'view_ref'::regclass::oid AS view_oid;

-- Test 5: query (line 16)
SELECT relname, relkind
FROM pg_catalog.pg_class
WHERE oid = 'view_ref'::regclass;

-- Test 6: query (line 23)
SELECT 'seq'::regclass::oid AS seq_oid;

-- Test 7: query (line 30)
SELECT relname, relkind
FROM pg_catalog.pg_class
WHERE oid = 'seq'::regclass;

-- Test 8: query (line 36)
SELECT 'x'::regclass::oid AS table_oid;

-- Test 9: query (line 42)
SELECT ('x'::regclass::oid)::regclass AS table_by_oid;

-- Test 10: query (line 47)
SELECT indexrelid::regclass::text AS index_name
FROM pg_catalog.pg_index
WHERE indrelid = 'x'::regclass
ORDER BY index_name;

RESET client_min_messages;

