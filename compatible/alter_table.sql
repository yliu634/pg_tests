-- PostgreSQL compatible tests from alter_table
-- 1009 tests
--
-- NOTE:
-- The original CockroachDB logic test for alter_table contains many CRDB-only
-- statements (SHOW commands, crdb_internal jobs, schema changer gating) and
-- many statements that are expected to error. This PostgreSQL adaptation keeps
-- a focused subset that exercises core ALTER TABLE behavior without any ERROR
-- output when run via psql.

SET client_min_messages = warning;

-- Setup / cleanup to make the script re-runnable.
DROP TABLE IF EXISTS t_renamed CASCADE;
DROP TABLE IF EXISTS t CASCADE;
DROP TABLE IF EXISTS other CASCADE;

-- Test 1: statement (create referenced table)
CREATE TABLE other (
  b INT PRIMARY KEY
);

-- Test 2: statement
INSERT INTO other VALUES (9);

-- Test 3: statement (create base table)
CREATE TABLE t (
  a INT PRIMARY KEY,
  f INT REFERENCES other(b),
  CONSTRAINT check_a CHECK (a > 0)
);

-- CockroachDB allows inline secondary indexes; create the index separately.
CREATE INDEX t_f_idx ON t(f);

-- Test 4: statement
INSERT INTO t VALUES (1, 9);

-- Test 5: query (columns)
SELECT column_name,
       data_type,
       is_nullable,
       column_default
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name = 't'
ORDER BY ordinal_position;

-- Test 6: statement (add column)
ALTER TABLE t ADD COLUMN b INT;

-- Test 7: statement (add unique constraint)
ALTER TABLE t ADD CONSTRAINT t_b_unique UNIQUE (b);

-- Test 8: statement (populate and keep unique)
UPDATE t SET b = a;

-- Test 9: query (constraints)
SELECT constraint_name,
       constraint_type
FROM information_schema.table_constraints
WHERE table_schema = 'public'
  AND table_name = 't'
  AND constraint_name IN ('check_a', 't_b_unique', 't_f_fkey', 't_pkey')
ORDER BY constraint_type, constraint_name;

-- Test 10: statement (drop constraint)
ALTER TABLE t DROP CONSTRAINT t_b_unique;

-- Test 11: statement (add column with default and NOT NULL)
ALTER TABLE t ADD COLUMN c INT NOT NULL DEFAULT 42;

-- Test 12: query
SELECT a, f, b, c
FROM t
ORDER BY a;

-- Test 13: statement (relax column constraints)
ALTER TABLE t ALTER COLUMN c DROP DEFAULT;
ALTER TABLE t ALTER COLUMN c DROP NOT NULL;

-- Test 14: statement (NOT VALID + VALIDATE)
ALTER TABLE t ADD CONSTRAINT t_c_nonneg CHECK (c >= 0) NOT VALID;
ALTER TABLE t VALIDATE CONSTRAINT t_c_nonneg;

-- Test 15: statement (rename table)
ALTER TABLE t RENAME TO t_renamed;

-- Test 16: query (tables)
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
  AND table_name IN ('t', 't_renamed')
ORDER BY table_name;

-- Test 17: statement (rename column)
ALTER TABLE t_renamed RENAME COLUMN a TO a_id;

-- Test 18: query (columns after rename)
SELECT column_name,
       data_type
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name = 't_renamed'
ORDER BY ordinal_position;

-- Test 19: query (indexes)
SELECT indexname,
       indexdef
FROM pg_indexes
WHERE schemaname = 'public'
  AND tablename = 't_renamed'
ORDER BY indexname;

-- Cleanup.
DROP TABLE IF EXISTS t_renamed CASCADE;
DROP TABLE IF EXISTS other CASCADE;

RESET client_min_messages;
