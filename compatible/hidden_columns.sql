-- PostgreSQL compatible tests from hidden_columns
--
-- CockroachDB supports "NOT VISIBLE" columns and SHOW CONSTRAINTS; PostgreSQL
-- does not. This file validates similar catalog/introspection behavior using
-- information_schema.

SET client_min_messages = warning;

DROP TABLE IF EXISTS hc_t CASCADE;
DROP TABLE IF EXISTS hc_kv CASCADE;
DROP TABLE IF EXISTS hc_t1 CASCADE;
DROP TABLE IF EXISTS hc_t2 CASCADE;
DROP TABLE IF EXISTS hc_t5 CASCADE;
DROP TABLE IF EXISTS hc_t3 CASCADE;
DROP TABLE IF EXISTS hc_t4 CASCADE;
DROP TABLE IF EXISTS hc_t6 CASCADE;

CREATE TABLE hc_t (x INT);
CREATE TABLE hc_kv (k INT PRIMARY KEY, v INT);

INSERT INTO hc_t(x) VALUES (123);
INSERT INTO hc_kv(k, v) VALUES (123, 456);

SELECT 42, * FROM hc_t;
SELECT 42, * FROM hc_kv;

-- Basic DDL changes.
ALTER TABLE hc_kv RENAME COLUMN v TO x;
CREATE INDEX ON hc_kv(x);
ALTER TABLE hc_kv DROP COLUMN x;

SELECT column_name
FROM information_schema.columns
WHERE table_schema = 'public' AND table_name = 'hc_kv'
ORDER BY ordinal_position;

-- Constraint introspection.
CREATE TABLE hc_t1(a INT, b INT, c INT, PRIMARY KEY(b));
CREATE TABLE hc_t2(b INT, c INT, d INT, PRIMARY KEY(d));
CREATE TABLE hc_t5(b INT, c INT, d INT, PRIMARY KEY(d), FOREIGN KEY(b) REFERENCES hc_t1(b));

SELECT constraint_name, constraint_type
FROM information_schema.table_constraints
WHERE table_schema = 'public' AND table_name = 'hc_t2'
  AND constraint_type IN ('PRIMARY KEY', 'FOREIGN KEY')
ORDER BY constraint_name;

ALTER TABLE hc_t2 ADD CONSTRAINT hc_t2_b_fkey FOREIGN KEY (b) REFERENCES hc_t1(b);

SELECT constraint_name, constraint_type
FROM information_schema.table_constraints
WHERE table_schema = 'public' AND table_name = 'hc_t2'
  AND constraint_type IN ('PRIMARY KEY', 'FOREIGN KEY')
ORDER BY constraint_name;

-- Primary key change (drop + recreate).
CREATE TABLE hc_t3(a INT, b INT NOT NULL, c INT, PRIMARY KEY(c));
CREATE TABLE hc_t4(c INT, d INT, e INT NOT NULL, PRIMARY KEY(d));

ALTER TABLE hc_t3 DROP CONSTRAINT hc_t3_pkey;
ALTER TABLE hc_t3 ADD PRIMARY KEY (b);

SELECT constraint_name, constraint_type
FROM information_schema.table_constraints
WHERE table_schema = 'public' AND table_name = 'hc_t3'
  AND constraint_type IN ('PRIMARY KEY', 'FOREIGN KEY')
ORDER BY constraint_name;

ALTER TABLE hc_t4 DROP CONSTRAINT hc_t4_pkey;
ALTER TABLE hc_t4 ADD PRIMARY KEY (e);

SELECT constraint_name, constraint_type
FROM information_schema.table_constraints
WHERE table_schema = 'public' AND table_name = 'hc_t4'
  AND constraint_type IN ('PRIMARY KEY', 'FOREIGN KEY')
ORDER BY constraint_name;

-- A foreign key referencing the new primary key.
CREATE TABLE hc_t6(b INT, d INT, e INT NOT NULL, PRIMARY KEY(d), FOREIGN KEY(b) REFERENCES hc_t3(b));

-- Cleanup.
DROP TABLE hc_t6;
DROP TABLE hc_t5;
DROP TABLE hc_t2;
DROP TABLE hc_t1;
DROP TABLE hc_t4;
DROP TABLE hc_t3;
DROP TABLE hc_kv;
DROP TABLE hc_t;

RESET client_min_messages;
