SET client_min_messages = warning;

-- PostgreSQL compatible tests from new_schema_changer
-- Deterministic, error-free subset of schema changes in PG.

DROP TABLE IF EXISTS nsc_foo CASCADE;
CREATE TABLE nsc_foo (i INT PRIMARY KEY);

ALTER TABLE nsc_foo ADD COLUMN j INT;
INSERT INTO nsc_foo(i, j) VALUES (1, 10);
SELECT * FROM nsc_foo ORDER BY i;

ALTER TABLE nsc_foo ADD COLUMN k INT DEFAULT 5;
INSERT INTO nsc_foo(i, j) VALUES (2, 20);
SELECT * FROM nsc_foo ORDER BY i;

-- Generated column (stored).
DROP TABLE IF EXISTS gen CASCADE;
CREATE TABLE gen (
  i INT PRIMARY KEY,
  j INT GENERATED ALWAYS AS (i + 1) STORED
);
INSERT INTO gen(i) VALUES (1), (2);
SELECT * FROM gen ORDER BY i;

-- Transactional DDL.
BEGIN;
ALTER TABLE nsc_foo ADD COLUMN m INT;
ROLLBACK;
SELECT column_name
FROM information_schema.columns
WHERE table_name = 'nsc_foo'
ORDER BY ordinal_position;

-- Sequence default.
DROP SEQUENCE IF EXISTS nsc_sq1 CASCADE;
CREATE SEQUENCE nsc_sq1;
DROP TABLE IF EXISTS nsc_blog_posts CASCADE;
CREATE TABLE nsc_blog_posts (id INT PRIMARY KEY, val INT DEFAULT nextval('nsc_sq1'), title TEXT);
INSERT INTO nsc_blog_posts(id, title) VALUES (1, 'one'), (2, 'two');
SELECT id, val, title FROM nsc_blog_posts ORDER BY id;

-- Enum type and view dependency.
DROP VIEW IF EXISTS nsc_v CASCADE;
DROP TYPE IF EXISTS nsc_typ CASCADE;
CREATE TYPE nsc_typ AS ENUM ('a', 'b');
CREATE VIEW nsc_v AS SELECT 'a'::nsc_typ AS t;
SELECT * FROM nsc_v;
DROP VIEW nsc_v;
DROP TYPE nsc_typ;

-- Schema-qualified objects.
CREATE SCHEMA IF NOT EXISTS defaultdb;
DROP TABLE IF EXISTS defaultdb.shipments CASCADE;
CREATE TABLE defaultdb.shipments (id INT PRIMARY KEY, status TEXT);
INSERT INTO defaultdb.shipments VALUES (1, 'pending');
SELECT * FROM defaultdb.shipments ORDER BY id;

RESET client_min_messages;
