-- PostgreSQL compatible tests from drop_database
--
-- CockroachDB has cross-database object references (db.table), SHOW DATABASES,
-- and internal catalogs (crdb_internal/system.*) that do not exist in PG.
-- This file keeps the spirit of the test by exercising CREATE/DROP DATABASE
-- with a few representative names and object types.

SET client_min_messages = warning;
DROP DATABASE IF EXISTS "foo-bar";
DROP DATABASE IF EXISTS "foo bar";
DROP DATABASE IF EXISTS d1;
DROP DATABASE IF EXISTS d2;
DROP DATABASE IF EXISTS constraint_db;
DROP DATABASE IF EXISTS db50997;
DROP DATABASE IF EXISTS db_73323;
DROP DATABASE IF EXISTS db_51782;
DROP DATABASE IF EXISTS db_121808;
DROP ROLE IF EXISTS drop_db_owner;
RESET client_min_messages;

-- Quoted database name with hyphen.
CREATE DATABASE "foo-bar";
SELECT EXISTS(SELECT 1 FROM pg_database WHERE datname = 'foo-bar') AS foo_bar_exists;
\c "foo-bar"
CREATE TABLE t(x INT);
\c pg_tests
DROP DATABASE "foo-bar";
SELECT EXISTS(SELECT 1 FROM pg_database WHERE datname = 'foo-bar') AS foo_bar_exists_after_drop;

-- Quoted database name with space.
CREATE DATABASE "foo bar";
SELECT EXISTS(SELECT 1 FROM pg_database WHERE datname = 'foo bar') AS foo_space_exists;
DROP DATABASE "foo bar";
SELECT EXISTS(SELECT 1 FROM pg_database WHERE datname = 'foo bar') AS foo_space_exists_after_drop;

-- Multiple databases.
CREATE DATABASE d1;
CREATE DATABASE d2;
SELECT datname FROM pg_database WHERE datname IN ('d1', 'd2') ORDER BY datname;
DROP DATABASE d1;
DROP DATABASE d2;
SELECT datname FROM pg_database WHERE datname IN ('d1', 'd2') ORDER BY datname;

-- Drop a database containing tables with foreign key constraints.
CREATE DATABASE constraint_db;
\c constraint_db
CREATE TABLE t1 (
  p double precision PRIMARY KEY,
  a INT UNIQUE CHECK (a > 4),
  CONSTRAINT c2 CHECK (a < 99)
);
CREATE TABLE t2 (
  t1_id INT,
  CONSTRAINT fk FOREIGN KEY (t1_id) REFERENCES t1(a)
);
CREATE INDEX ON t2(t1_id);
\c pg_tests
DROP DATABASE constraint_db;
SELECT EXISTS(SELECT 1 FROM pg_database WHERE datname = 'constraint_db') AS constraint_db_exists_after_drop;

-- Drop a database containing sequences and tables.
CREATE DATABASE db50997;
\c db50997
CREATE SEQUENCE seq50997;
CREATE SEQUENCE useq50997;
CREATE TABLE t50997(a INT DEFAULT nextval('seq50997'));
CREATE TABLE t250997(a INT DEFAULT nextval('seq50997'));
\c pg_tests
DROP DATABASE db50997;
SELECT EXISTS(SELECT 1 FROM pg_database WHERE datname = 'db50997') AS db50997_exists_after_drop;

-- Drop a database containing tables and views.
CREATE DATABASE db_51782;
\c db_51782
CREATE TABLE t_51782(a INT, b INT);
CREATE VIEW v_51782 AS SELECT a, b FROM t_51782;
CREATE VIEW w_51782 AS SELECT a FROM v_51782;
\c pg_tests
DROP DATABASE db_51782;
SELECT EXISTS(SELECT 1 FROM pg_database WHERE datname = 'db_51782') AS db_51782_exists_after_drop;

-- Role-owned database creation.
CREATE ROLE drop_db_owner WITH CREATEDB LOGIN;
SET ROLE drop_db_owner;
CREATE DATABASE db_121808;
RESET ROLE;
DROP DATABASE db_121808;
SELECT EXISTS(SELECT 1 FROM pg_database WHERE datname = 'db_121808') AS db_121808_exists_after_drop;
DROP ROLE drop_db_owner;
