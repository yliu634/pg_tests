-- PostgreSQL compatible tests from rename_atomic
-- 32 tests

-- CockroachDB's rename-atomic tests use CRDB-only settings (autocommit_before_ddl)
-- and database-rename behavior that PostgreSQL does not support.
--
-- This rewrite keeps the semantic focus for PostgreSQL: schema and view renames
-- are transactional and can be committed/rolled back atomically.

SET client_min_messages = warning;

-- Clean slate.
DROP SCHEMA IF EXISTS db CASCADE;
DROP SCHEMA IF EXISTS db_new CASCADE;
DROP SCHEMA IF EXISTS db_old CASCADE;
DROP SCHEMA IF EXISTS db_sc CASCADE;

DROP SCHEMA IF EXISTS sc CASCADE;
DROP SCHEMA IF EXISTS sc_new CASCADE;
DROP SCHEMA IF EXISTS sc_old CASCADE;

DROP VIEW IF EXISTS v;
DROP VIEW IF EXISTS v_new;
DROP VIEW IF EXISTS v_old;

-- Test 1-9: (database rename in CRDB) simulated with schema renames in PG.
CREATE SCHEMA db;
CREATE SCHEMA db_new;

BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
ALTER SCHEMA db RENAME TO db_old;
ALTER SCHEMA db_new RENAME TO db;
CREATE SCHEMA db_new_sc;
ROLLBACK;

SELECT schema_name
FROM information_schema.schemata
WHERE schema_name IN ('db', 'db_new', 'db_old', 'db_new_sc')
ORDER BY schema_name;

BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
ALTER SCHEMA db RENAME TO db_old;
ALTER SCHEMA db_new RENAME TO db;
CREATE SCHEMA db_sc;
COMMIT;

SELECT schema_name
FROM information_schema.schemata
WHERE schema_name IN ('db', 'db_new', 'db_old', 'db_sc')
ORDER BY schema_name;

-- Clean up simulated DB schemas.
DROP SCHEMA db_sc;
DROP SCHEMA db_old;
DROP SCHEMA db;

-- Test 10-17: schema rename + rollback/commit.
CREATE SCHEMA sc;
CREATE SCHEMA sc_new;

BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
ALTER SCHEMA sc RENAME TO sc_old;
ALTER SCHEMA sc_new RENAME TO sc;
CREATE VIEW sc.v AS SELECT 1;
ROLLBACK;

SELECT schema_name
FROM information_schema.schemata
WHERE schema_name IN ('sc', 'sc_new', 'sc_old')
ORDER BY schema_name;

BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
ALTER SCHEMA sc RENAME TO sc_old;
ALTER SCHEMA sc_new RENAME TO sc;
CREATE VIEW sc.v AS SELECT 1;
COMMIT;

SELECT schema_name
FROM information_schema.schemata
WHERE schema_name IN ('sc', 'sc_new', 'sc_old')
ORDER BY schema_name;

-- Test 18-29: view rename behavior.
CREATE VIEW v AS SELECT 1;
CREATE VIEW v_new AS SELECT 2;

SELECT * FROM v;

BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
ALTER VIEW v RENAME TO v_old;
ALTER VIEW v_new RENAME TO v;
SELECT * FROM v;
COMMIT;

SELECT * FROM v;

BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
DROP VIEW v;
ALTER VIEW v_old RENAME TO v;
SELECT * FROM v;
COMMIT;

SELECT * FROM v;

BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
ALTER VIEW v RENAME TO v_old;
CREATE VIEW v AS SELECT 1;
COMMIT;

BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
DROP VIEW v;
CREATE VIEW v AS SELECT 1;
COMMIT;

-- Test 30-31: schema DDL inside a transaction.
CREATE SCHEMA sc93002;

BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SELECT table_name FROM information_schema.tables WHERE table_schema = 'sc93002' ORDER BY table_name;
CREATE TABLE sc93002.t(a INT);
DROP SCHEMA sc93002 CASCADE;
COMMIT;

SELECT schema_name
FROM information_schema.schemata
WHERE schema_name = 'sc93002';

-- Test 32: cleanup.
DROP VIEW IF EXISTS v;
DROP VIEW IF EXISTS v_old;
DROP SCHEMA IF EXISTS sc_old CASCADE;
DROP SCHEMA IF EXISTS sc CASCADE;

RESET client_min_messages;
