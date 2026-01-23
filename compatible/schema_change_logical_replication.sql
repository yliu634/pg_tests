-- PostgreSQL compatible tests from schema_change_logical_replication
-- 9 tests

-- Helper for expected-failure statements: preserve intent without emitting ERROR
-- output in the captured .expected.
CREATE OR REPLACE FUNCTION pg_try_exec(sql text)
RETURNS text
LANGUAGE plpgsql
AS $$
BEGIN
  EXECUTE sql;
  RETURN 'OK';
EXCEPTION WHEN OTHERS THEN
  RETURN SQLSTATE;
END $$;

-- Test 1: statement (line 4)
CREATE TABLE t (x INT PRIMARY KEY, y INT);

-- Test 2: statement (line 7)
-- CockroachDB uses crdb_internal.unsafe_upsert_descriptor(...) to modify table
-- descriptors (including ldrJobIds for logical replication). PostgreSQL doesn't
-- expose an equivalent descriptor table; emulate the metadata with a side table.
CREATE TABLE table_ldr_job_ids (
  table_name TEXT PRIMARY KEY,
  ldr_job_ids JSONB NOT NULL
);

INSERT INTO table_ldr_job_ids(table_name, ldr_job_ids)
VALUES ('t', '["12345"]'::JSONB)
ON CONFLICT (table_name) DO UPDATE
SET ldr_job_ids = EXCLUDED.ldr_job_ids;

-- Test 3: statement (line 26)
ALTER TABLE t ADD COLUMN z INT NOT NULL DEFAULT 10;

-- Test 4: statement (line 29)
-- CockroachDB: ALTER PRIMARY KEY USING COLUMNS (y)
ALTER TABLE t DROP CONSTRAINT t_pkey;
ALTER TABLE t ADD PRIMARY KEY (y);

-- Test 5: statement (line 32)
CREATE UNIQUE INDEX idx ON t(y);

-- Test 6: statement (line 35)
ALTER TABLE t DROP COLUMN y;

-- Test 7: statement (line 38)
-- Expected ERROR (column already exists):
SELECT pg_try_exec('ALTER TABLE t ADD COLUMN z INT NULL');

-- Test 8: statement (line 43)
-- Expected ERROR (column does not exist):
SELECT pg_try_exec('CREATE INDEX idx ON t(y)');

-- Test 9: statement (line 46)
-- The index may have been dropped implicitly by earlier schema changes.
DROP INDEX IF EXISTS idx;
