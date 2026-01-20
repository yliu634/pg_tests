-- PostgreSQL compatible tests from fk
--
-- The upstream CockroachDB test relies on cluster settings, cross-database
-- foreign keys, and other CRDB-only behaviors. This file exercises core
-- PostgreSQL foreign key behavior (CASCADE, DEFERRABLE, composite keys).

SET client_min_messages = warning;
DROP TABLE IF EXISTS child_comp;
DROP TABLE IF EXISTS parent_comp;
DROP TABLE IF EXISTS child_def;
DROP TABLE IF EXISTS parent_def;
DROP TABLE IF EXISTS child;
DROP TABLE IF EXISTS parent;
RESET client_min_messages;

-- Simple FK with ON DELETE CASCADE.
CREATE TABLE parent (p INT PRIMARY KEY);
CREATE TABLE child (c INT PRIMARY KEY, p INT REFERENCES parent(p) ON DELETE CASCADE);
INSERT INTO parent VALUES (1), (2);
INSERT INTO child VALUES (10, 1), (20, 2);
SELECT * FROM child ORDER BY c;
DELETE FROM parent WHERE p = 1;
SELECT * FROM child ORDER BY c;

-- DEFERRABLE FK: insert child before parent in a deferred transaction.
CREATE TABLE parent_def (p INT PRIMARY KEY);
CREATE TABLE child_def (
  c INT PRIMARY KEY,
  p INT REFERENCES parent_def(p) DEFERRABLE INITIALLY DEFERRED
);
BEGIN;
INSERT INTO child_def VALUES (1, 100);
INSERT INTO parent_def VALUES (100);
COMMIT;
SELECT * FROM child_def ORDER BY c;

-- Composite foreign key.
CREATE TABLE parent_comp (a INT, b INT, PRIMARY KEY (a, b));
CREATE TABLE child_comp (
  id INT PRIMARY KEY,
  a INT,
  b INT,
  FOREIGN KEY (a, b) REFERENCES parent_comp(a, b)
);
INSERT INTO parent_comp VALUES (1, 1);
INSERT INTO child_comp VALUES (1, 1, 1);
SELECT * FROM child_comp ORDER BY id;

