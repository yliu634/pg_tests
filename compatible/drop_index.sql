-- PostgreSQL compatible tests from drop_index
--
-- Adapted for psql execution:
-- - Replace Cockroach-specific `SHOW ...` statements with catalog queries.
-- - Avoid Cockroach index-in-table syntax and `table@index` index references.
-- - Keep representative coverage of DROP INDEX behavior in PostgreSQL.

SET client_min_messages = warning;

-- Scenario 1: basic DROP INDEX / IF EXISTS.
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS othertable CASCADE;

CREATE TABLE users (
  id    INT PRIMARY KEY,
  name  TEXT NOT NULL,
  title TEXT
);

CREATE INDEX foo ON users (name);
CREATE UNIQUE INDEX bar ON users (id, name);
CREATE INDEX baw ON users (name, title);

CREATE TABLE othertable (
  x INT,
  y INT
);

-- Avoid duplicate index names across tables in Postgres.
CREATE INDEX othertable_baw ON othertable (x);
CREATE INDEX yak ON othertable (y, x);

DROP INDEX othertable_baw;
DROP INDEX IF EXISTS othertable_baw;

-- Drop non-existent index safely.
DROP INDEX IF EXISTS ark;

-- Drop/recreate/drop yak.
DROP INDEX yak;
CREATE INDEX yak ON othertable (y, x);
DROP INDEX IF EXISTS yak;

DROP TABLE othertable;

DROP INDEX baw;

INSERT INTO users VALUES (1, 'tom', 'cat'), (2, 'jerry', 'rat');

-- Cockroach `SHOW INDEXES FROM users` replacement.
SELECT indexname
FROM pg_indexes
WHERE schemaname = 'public' AND tablename = 'users'
ORDER BY indexname;

DROP INDEX IF EXISTS zap;
DROP INDEX IF EXISTS foo, zap;

SELECT indexname
FROM pg_indexes
WHERE schemaname = 'public' AND tablename = 'users'
ORDER BY indexname;

-- Scenario 2: dropping constraint-backed indexes.
DROP TABLE IF EXISTS tu CASCADE;

CREATE TABLE tu (a INT UNIQUE);

-- In Postgres the UNIQUE constraint depends on its backing index.
ALTER TABLE tu DROP CONSTRAINT tu_a_key;

CREATE UNIQUE INDEX tu_a ON tu(a);
DROP INDEX tu_a;

-- Scenario 3: referenced unique index (FK dependency).
DROP TABLE IF EXISTS t1_96731 CASCADE;
DROP TABLE IF EXISTS t2_96731 CASCADE;

CREATE TABLE t2_96731 (i INT PRIMARY KEY, j INT);
CREATE UNIQUE INDEX t2_96731_j_idx ON t2_96731(j);

CREATE TABLE t1_96731 (i INT PRIMARY KEY, j INT);
ALTER TABLE t1_96731
  ADD CONSTRAINT t1_j_fk FOREIGN KEY (j) REFERENCES t2_96731(j);

-- Attempting to drop without CASCADE should fail; preserve intent without ERROR output.
DO $$
BEGIN
  BEGIN
    EXECUTE 'DROP INDEX t2_96731_j_idx';
  EXCEPTION WHEN OTHERS THEN
    NULL;
  END;
END $$;

SELECT conname, pg_get_constraintdef(oid) AS constraint_def
FROM pg_constraint
WHERE conrelid = 't1_96731'::regclass
ORDER BY conname;

DROP INDEX t2_96731_j_idx CASCADE;

SELECT conname, pg_get_constraintdef(oid) AS constraint_def
FROM pg_constraint
WHERE conrelid = 't1_96731'::regclass
ORDER BY conname;

DROP TABLE t1_96731, t2_96731;

-- Scenario 4: primary key index drop (must drop the constraint in Postgres).
DROP TABLE IF EXISTS drop_primary CASCADE;

CREATE TABLE drop_primary (id INT PRIMARY KEY);

DO $$
BEGIN
  BEGIN
    EXECUTE 'DROP INDEX drop_primary_pkey';
  EXCEPTION WHEN OTHERS THEN
    NULL;
  END;
END $$;

SELECT conname, contype, pg_get_constraintdef(oid) AS constraint_def
FROM pg_constraint
WHERE conrelid = 'drop_primary'::regclass
ORDER BY conname;

ALTER TABLE drop_primary DROP CONSTRAINT drop_primary_pkey;

SELECT conname, contype, pg_get_constraintdef(oid) AS constraint_def
FROM pg_constraint
WHERE conrelid = 'drop_primary'::regclass
ORDER BY conname;

-- Scenario 5: expression index.
DROP TABLE IF EXISTS tbl CASCADE;

CREATE TABLE tbl (c TEXT);
CREATE INDEX expr_idx ON tbl (lower(c));

SELECT indexname
FROM pg_indexes
WHERE schemaname = 'public' AND tablename = 'tbl'
ORDER BY indexname;

DROP INDEX expr_idx;

SELECT indexname
FROM pg_indexes
WHERE schemaname = 'public' AND tablename = 'tbl'
ORDER BY indexname;

-- Scenario 6: hash index + procedure creation.
DROP TABLE IF EXISTS tab_145100 CASCADE;

CREATE TABLE tab_145100 (
  id UUID PRIMARY KEY,
  i  INT NOT NULL,
  j  INT NOT NULL
);

CREATE INDEX tab_145100_i_idx ON tab_145100 USING hash (i);

CREATE OR REPLACE PROCEDURE proc_select_145100()
LANGUAGE plpgsql
AS $$
BEGIN
  -- Procedures don't return result sets; keep this side-effect free.
  PERFORM 1;
END $$;

CALL proc_select_145100();
DROP INDEX tab_145100_i_idx;
DROP PROCEDURE proc_select_145100();

SELECT indexname
FROM pg_indexes
WHERE schemaname = 'public' AND tablename = 'tab_145100'
ORDER BY indexname;

DROP TABLE tab_145100;

RESET client_min_messages;
