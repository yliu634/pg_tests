-- PostgreSQL compatible tests from show_create
-- 43 tests

SET client_min_messages = warning;

-- Minimal SHOW CREATE helper for PostgreSQL: surface table metadata in a stable way.
CREATE OR REPLACE FUNCTION pg_show_create_table(
  tab regclass,
  redact boolean,
  ignore_foreign_keys boolean
)
RETURNS TABLE(kind text, name text, detail text)
LANGUAGE sql
AS $$
  WITH
  cols AS (
    SELECT
      'column'::text AS kind,
      a.attname::text AS name,
      pg_catalog.format_type(a.atttypid, a.atttypmod)
        || CASE WHEN a.attnotnull THEN ' NOT NULL' ELSE '' END AS detail
    FROM pg_catalog.pg_attribute a
    WHERE a.attrelid = tab AND a.attnum > 0 AND NOT a.attisdropped
  ),
  cons AS (
    SELECT
      'constraint'::text AS kind,
      c.conname::text AS name,
      pg_catalog.pg_get_constraintdef(c.oid) AS detail
    FROM pg_catalog.pg_constraint c
    WHERE c.conrelid = tab
      AND (NOT ignore_foreign_keys OR c.contype <> 'f')
  ),
  idx AS (
    SELECT
      'index'::text AS kind,
      i.relname::text AS name,
      pg_catalog.pg_get_indexdef(i.oid) AS detail
    FROM pg_catalog.pg_index x
    JOIN pg_catalog.pg_class i ON i.oid = x.indexrelid
    WHERE x.indrelid = tab
  ),
  comments AS (
    SELECT
      'comment'::text AS kind,
      'table'::text AS name,
      CASE WHEN redact THEN '<redacted>' ELSE pg_catalog.obj_description(tab, 'pg_class') END AS detail
    WHERE pg_catalog.obj_description(tab, 'pg_class') IS NOT NULL
    UNION ALL
    SELECT
      'comment',
      ('column ' || a.attname)::text,
      CASE WHEN redact THEN '<redacted>' ELSE pg_catalog.col_description(tab, a.attnum) END
    FROM pg_catalog.pg_attribute a
    WHERE a.attrelid = tab
      AND a.attnum > 0
      AND NOT a.attisdropped
      AND pg_catalog.col_description(tab, a.attnum) IS NOT NULL
    UNION ALL
    SELECT
      'comment',
      ('index ' || i.relname)::text,
      CASE WHEN redact THEN '<redacted>' ELSE pg_catalog.obj_description(i.oid, 'pg_class') END
    FROM pg_catalog.pg_index x
    JOIN pg_catalog.pg_class i ON i.oid = x.indexrelid
    WHERE x.indrelid = tab
      AND pg_catalog.obj_description(i.oid, 'pg_class') IS NOT NULL
  )
  SELECT kind, name, detail
  FROM (
    SELECT * FROM cols
    UNION ALL SELECT * FROM cons
    UNION ALL SELECT * FROM idx
    UNION ALL SELECT * FROM comments
  ) s
  ORDER BY kind, name;
$$;

-- Test 1: statement (line 6)
CREATE TABLE c (
  a INT NOT NULL,
  b INT,
  CONSTRAINT unique_a_b UNIQUE (a, b)
);
CREATE INDEX c_a_b_idx ON c (a, b);
-- PostgreSQL models partial uniqueness via a partial unique index (not a constraint).
CREATE UNIQUE INDEX unique_a_partial ON c (a) WHERE b > 0;

-- Test 2: statement (line 17)
COMMENT ON TABLE c IS 'table';

-- Test 3: statement (line 20)
COMMENT ON COLUMN c.a IS 'column';

-- Test 4: statement (line 23)
COMMENT ON INDEX c_a_b_idx IS 'index';

-- Test 5: statement (line 26)
CREATE TABLE d (d INT PRIMARY KEY);

-- onlyif config schema-locked-disabled

-- Test 6: query (line 30)
SELECT * FROM pg_show_create_table('public.c'::regclass, false, false);

-- Test 7: query (line 50)
SELECT * FROM pg_show_create_table('public.c'::regclass, false, false);

-- Test 8: statement (line 69)
ALTER TABLE c ADD CONSTRAINT check_b CHECK (b IN (1, 2, 3)) NOT VALID;
ALTER TABLE c ADD CONSTRAINT fk_a FOREIGN KEY (a) REFERENCES d (d) NOT VALID;
ALTER TABLE c ADD CONSTRAINT unique_a UNIQUE (a);
-- PostgreSQL doesn't support NOT VALID on UNIQUE constraints; also partial UNIQUE constraints
-- are modeled as partial unique indexes (not constraints).
ALTER TABLE c ADD CONSTRAINT unique_b UNIQUE (b);
CREATE UNIQUE INDEX unique_b_partial ON c (b) WHERE a > 0;

-- onlyif config schema-locked-disabled

-- Test 9: query (line 77)
SELECT * FROM pg_show_create_table('public.c'::regclass, false, false);

-- Test 10: query (line 101)
SELECT * FROM pg_show_create_table('public.c'::regclass, false, false);

-- Test 11: statement (line 124)
ALTER TABLE c VALIDATE CONSTRAINT check_b;
ALTER TABLE c VALIDATE CONSTRAINT fk_a;
\set ON_ERROR_STOP 0
ALTER TABLE c VALIDATE CONSTRAINT unique_b;
ALTER TABLE c VALIDATE CONSTRAINT unique_a_b;
ALTER TABLE c VALIDATE CONSTRAINT unique_b_partial;
\set ON_ERROR_STOP 1

-- skipif config local-legacy-schema-changer

-- Test 12: statement (line 132)
\set ON_ERROR_STOP 0
ALTER TABLE c VALIDATE CONSTRAINT unique_a;
\set ON_ERROR_STOP 1

-- Test 13: statement (line 138)
-- Expected ERROR (UNIQUE constraints cannot be VALIDATE'd in PostgreSQL):
\set ON_ERROR_STOP 0
ALTER TABLE c VALIDATE CONSTRAINT unique_a;
\set ON_ERROR_STOP 1

-- onlyif config schema-locked-disabled

-- Test 14: query (line 142)
SELECT * FROM pg_show_create_table('public.c'::regclass, false, false);

-- Test 15: query (line 166)
SELECT * FROM pg_show_create_table('public.c'::regclass, false, false);

-- Test 16: query (line 190)
SELECT * FROM pg_show_create_table('public.c'::regclass, true, false);

-- Test 17: query (line 214)
SELECT * FROM pg_show_create_table('public.c'::regclass, true, false);

-- Test 18: query (line 238)
SELECT * FROM pg_show_create_table('public.c'::regclass, false, true);

-- Test 19: query (line 261)
SELECT * FROM pg_show_create_table('public.c'::regclass, false, true);

-- Test 20: statement (line 289)
CREATE TABLE t (c INT);

-- Test 21: statement (line 292)
COMMENT ON COLUMN t.c IS 'first comment';

-- onlyif config schema-locked-disabled

-- Test 22: query (line 296)
SELECT * FROM pg_show_create_table('public.t'::regclass, false, false);

-- Test 23: query (line 307)
SELECT * FROM pg_show_create_table('public.t'::regclass, false, false);

-- Test 24: statement (line 321)
ALTER TABLE t ALTER COLUMN c TYPE character varying;

-- skipif config local-legacy-schema-changer
-- onlyif config schema-locked-disabled

-- Test 25: query (line 326)
SELECT * FROM pg_show_create_table('public.t'::regclass, false, false);

-- Test 26: query (line 338)
SELECT * FROM pg_show_create_table('public.t'::regclass, false, false);

-- Test 27: query (line 350)
SELECT * FROM pg_show_create_table('public.t'::regclass, true, false);

-- Test 28: query (line 362)
SELECT * FROM pg_show_create_table('public.t'::regclass, true, false);

-- Test 29: query (line 381)
CREATE TABLE t1 (a INT PRIMARY KEY, b INT, c INT);
CREATE INDEX t1_b_idx ON t1 (b);
CREATE UNIQUE INDEX t1_c_idx ON t1 (c);

SELECT
  i.relname AS index_name,
  pg_catalog.pg_get_indexdef(i.oid) AS create_statement
FROM pg_catalog.pg_index x
JOIN pg_catalog.pg_class i ON i.oid = x.indexrelid
WHERE x.indrelid = 'public.t1'::regclass
ORDER BY index_name;

-- Test 30: query (line 388)
SELECT
  i.relname AS index_name,
  pg_catalog.pg_get_indexdef(i.oid) AS create_statement
FROM pg_catalog.pg_index x
JOIN pg_catalog.pg_class i ON i.oid = x.indexrelid
WHERE x.indrelid = 'public.t1'::regclass
  AND NOT x.indisprimary
ORDER BY index_name;

-- Test 31: statement (line 394)
-- Expected ERROR (table does not exist):
\set ON_ERROR_STOP 0
SELECT 'nonexistent'::regclass;
\set ON_ERROR_STOP 1

-- Test 32: statement (line 397)
-- Expected ERROR (table does not exist):
\set ON_ERROR_STOP 0
SELECT 'nonexistent'::regclass;
\set ON_ERROR_STOP 1

-- Test 33: statement (line 402)
CREATE SCHEMA SC1;

-- Test 34: statement (line 405)
CREATE SCHEMA SC2;

-- Test 35: statement (line 408)
CREATE TYPE SC1.COMP1 AS (A INT, B TEXT);

-- Test 36: statement (line 411)
CREATE TYPE SC2.COMP1 AS (C SMALLINT, D BOOL);

-- Test 37: statement (line 414)
CREATE TABLE T_WITH_COMPS (
  C1 INT PRIMARY KEY,
  SC1 SC1.COMP1,
  SC2 SC2.COMP1
);

-- onlyif config schema-locked-disabled

-- Test 38: query (line 418)
SELECT * FROM pg_show_create_table('public.t_with_comps'::regclass, false, false);

-- Test 39: query (line 430)
SELECT * FROM pg_show_create_table('public.t_with_comps'::regclass, false, false);

-- Test 40: statement (line 441)
DROP TABLE T_WITH_COMPS;
DROP TYPE SC1.COMP1;
DROP TYPE SC2.COMP1;
DROP SCHEMA SC1;
DROP SCHEMA SC2;

-- Test 41: statement (line 453)
CREATE EXTENSION IF NOT EXISTS pg_trgm;
CREATE TABLE roaches (x tsvector, y text);
CREATE INDEX ON roaches USING GIN (x, y gin_trgm_ops);

-- onlyif config schema-locked-disabled

-- Test 42: query (line 457)
SELECT * FROM pg_show_create_table('public.roaches'::regclass, false, false);

-- Test 43: query (line 470)
SELECT * FROM pg_show_create_table('public.roaches'::regclass, false, false);

RESET client_min_messages;
