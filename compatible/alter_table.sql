-- PostgreSQL compatible tests from alter_table
-- NOTE: This is a PostgreSQL-focused port. CockroachDB-specific schema changer and
-- config directives are not applicable. The goal is to exercise common ALTER TABLE
-- operations under PostgreSQL.

SET client_min_messages = warning;

-- Cleanup from prior runs.
DROP TABLE IF EXISTS t CASCADE;
DROP TABLE IF EXISTS t_renamed CASCADE;

-- Test 1: Create and inspect a base table.
CREATE TABLE t (
  a INT PRIMARY KEY,
  b TEXT
);
INSERT INTO t VALUES (1, 'one'), (2, 'two');

SELECT * FROM t ORDER BY a;

-- Test 2: ADD COLUMN with DEFAULT.
ALTER TABLE t ADD COLUMN c INT DEFAULT 10;
SELECT * FROM t ORDER BY a;

-- Test 3: RENAME COLUMN.
ALTER TABLE t RENAME COLUMN b TO b2;
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'public' AND table_name = 't'
ORDER BY ordinal_position;

-- Test 4: ALTER COLUMN TYPE using a cast.
ALTER TABLE t ALTER COLUMN c TYPE BIGINT;
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'public' AND table_name = 't'
ORDER BY ordinal_position;

-- Test 5: DROP COLUMN.
ALTER TABLE t DROP COLUMN c;
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'public' AND table_name = 't'
ORDER BY ordinal_position;

-- Test 6: ADD/DROP CHECK constraint.
ALTER TABLE t ADD CONSTRAINT t_a_positive CHECK (a > 0);
SELECT conname, pg_get_constraintdef(oid) AS def
FROM pg_constraint
WHERE conrelid = 't'::regclass AND contype = 'c'
ORDER BY conname;

ALTER TABLE t DROP CONSTRAINT t_a_positive;
SELECT conname, pg_get_constraintdef(oid) AS def
FROM pg_constraint
WHERE conrelid = 't'::regclass AND contype = 'c'
ORDER BY conname;

-- Test 7: RENAME TABLE.
ALTER TABLE t RENAME TO t_renamed;
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public' AND table_name IN ('t', 't_renamed')
ORDER BY table_name;

-- Cleanup.
DROP TABLE IF EXISTS t_renamed CASCADE;

RESET client_min_messages;
