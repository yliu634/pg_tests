-- PostgreSQL compatible tests from case_sensitive_names
-- 63 tests

SET client_min_messages = warning;

-- In CockroachDB these tests cover case sensitivity of DATABASE/TABLE/INDEX
-- names and various SHOW commands. PostgreSQL's semantics differ, so we
-- exercise the closest equivalent behavior using schemas, quoted identifiers,
-- and catalog/introspection queries.

-- Schema names (unquoted identifiers fold to lower-case in PG).
DROP SCHEMA IF EXISTS d CASCADE;
DROP SCHEMA IF EXISTS "E" CASCADE;
CREATE SCHEMA d;
CREATE SCHEMA "E";

-- Initially empty.
SELECT table_schema, table_name
FROM information_schema.tables
WHERE table_schema IN ('d', 'E') AND table_type = 'BASE TABLE'
ORDER BY 1, 2;

-- Table names: a vs "A" are distinct in PostgreSQL.
DROP TABLE IF EXISTS d.a;
DROP TABLE IF EXISTS d."A";
CREATE TABLE d.a (x INT);
CREATE TABLE d."A" (x INT);
INSERT INTO d.a VALUES (1);
INSERT INTO d."A" VALUES (2);

SELECT table_schema, table_name
FROM information_schema.tables
WHERE table_schema = 'd' AND table_type = 'BASE TABLE'
ORDER BY 1, 2;

SELECT * FROM d.a ORDER BY x;
SELECT * FROM d."A" ORDER BY x;

-- Column names: y vs "Y" are distinct; unquoted references fold to lower-case.
-- Use a unique table name to avoid collisions with other tests.
DROP TABLE IF EXISTS csn_foo CASCADE;
CREATE TABLE csn_foo (x INT, y INT, "Y" INT);
INSERT INTO csn_foo (x, y, "Y") VALUES (1, 10, 20);

SELECT x, X, y, Y, "Y" FROM csn_foo;
SELECT "Y" FROM csn_foo;

-- Views: csn_xv (unquoted) vs "CSN_XV" (quoted).
DROP VIEW IF EXISTS csn_xv;
DROP VIEW IF EXISTS "CSN_XV";
CREATE VIEW csn_xv AS SELECT x, "Y" FROM csn_foo;
CREATE VIEW "CSN_XV" AS SELECT x, "Y" FROM csn_foo;

SELECT 'csn_xv' AS view_name, pg_get_viewdef(to_regclass('csn_xv'), true) AS def;
SELECT 'CSN_XV' AS view_name, pg_get_viewdef(to_regclass('\"CSN_XV\"'), true) AS def;

-- Index names: i vs "I" are distinct in PostgreSQL.
DROP TABLE IF EXISTS csn_idx_test CASCADE;
CREATE TABLE csn_idx_test (x INT, y INT);
CREATE INDEX csn_i ON csn_idx_test (x);
CREATE INDEX "CSN_I" ON csn_idx_test (y);

SELECT indexname
FROM pg_indexes
WHERE tablename = 'csn_idx_test'
ORDER BY indexname;

-- Unicode identifiers: PostgreSQL preserves code points; it does not perform
-- Unicode normalization on identifiers (so these two names are distinct).
DROP TABLE IF EXISTS Amelie;
CREATE TABLE Amelie("Amélie" INT, "Amélie" INT);
INSERT INTO Amelie VALUES (1, 2);

SELECT column_name
FROM information_schema.columns
WHERE table_name = 'amelie'
ORDER BY ordinal_position;

-- Function names are case-insensitive.
SELECT LENGTH('abc') AS len, length('abc') AS len2;

RESET client_min_messages;
