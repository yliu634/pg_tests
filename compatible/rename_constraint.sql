-- PostgreSQL compatible tests from rename_constraint
-- 22 tests

SET client_min_messages = warning;

CREATE OR REPLACE FUNCTION pg_show_constraints(tab regclass)
RETURNS TABLE(conname text, contype text, condef text)
LANGUAGE sql
AS $$
  SELECT
    c.conname::text,
    c.contype::text,
    pg_catalog.pg_get_constraintdef(c.oid) AS condef
  FROM pg_catalog.pg_constraint c
  WHERE c.conrelid = tab
  ORDER BY c.conname;
$$;

-- Test 1: statement (line 1)
CREATE TABLE t (
  x INT, y INT,
  CONSTRAINT cu UNIQUE (x),
  CONSTRAINT cc CHECK (x > 10),
  CONSTRAINT cf FOREIGN KEY (x) REFERENCES t(x)
  -- CockroachDB column-family syntax removed for PostgreSQL.
  -- FAMILY "primary" (x, y, rowid)
);

-- onlyif config schema-locked-disabled

-- Test 2: query (line 11)
SELECT * FROM pg_show_constraints('public.t'::regclass);

-- Test 3: query (line 25)
SELECT * FROM pg_show_constraints('public.t'::regclass);

-- Test 4: query (line 38)
SELECT conname, contype
FROM pg_catalog.pg_constraint
WHERE conrelid = 'public.t'::regclass
ORDER BY conname;

-- Test 5: statement (line 48)
ALTER TABLE t RENAME CONSTRAINT cu TO cu2;
ALTER TABLE t RENAME CONSTRAINT cf TO cf2;
ALTER TABLE t RENAME CONSTRAINT cc TO cc2;

-- onlyif config schema-locked-disabled

-- Test 6: query (line 54)
SELECT * FROM pg_show_constraints('public.t'::regclass);

-- Test 7: query (line 68)
SELECT * FROM pg_show_constraints('public.t'::regclass);

-- Test 8: query (line 81)
SELECT conname, contype
FROM pg_catalog.pg_constraint
WHERE conrelid = 'public.t'::regclass
ORDER BY conname;

-- Test 9: statement (line 92)
-- Expected ERROR (target constraint name already exists):
\set ON_ERROR_STOP 0
ALTER TABLE t RENAME CONSTRAINT cu2 TO cf2;
\set ON_ERROR_STOP 1

-- Test 10: statement (line 95)
-- Expected ERROR (target constraint name already exists):
\set ON_ERROR_STOP 0
ALTER TABLE t RENAME CONSTRAINT cu2 TO cc2;
\set ON_ERROR_STOP 1

-- Test 11: statement (line 98)
-- Expected ERROR (target constraint name already exists):
\set ON_ERROR_STOP 0
ALTER TABLE t RENAME CONSTRAINT cf2 TO cu2;
\set ON_ERROR_STOP 1

-- Test 12: statement (line 101)
-- Expected ERROR (target constraint name already exists):
\set ON_ERROR_STOP 0
ALTER TABLE t RENAME CONSTRAINT cf2 TO cc2;
\set ON_ERROR_STOP 1

-- Test 13: statement (line 104)
-- Expected ERROR (target constraint name already exists):
\set ON_ERROR_STOP 0
ALTER TABLE t RENAME CONSTRAINT cc2 TO cf2;
\set ON_ERROR_STOP 1

-- Test 14: statement (line 107)
-- Expected ERROR (target constraint name already exists):
\set ON_ERROR_STOP 0
ALTER TABLE t RENAME CONSTRAINT cc2 TO cu2;
\set ON_ERROR_STOP 1

-- Test 15: statement (line 112)
ALTER TABLE t RENAME CONSTRAINT cu2 TO cu3;
ALTER TABLE t RENAME CONSTRAINT cc2 TO cc3;
ALTER TABLE t RENAME CONSTRAINT cf2 TO cf3;
ALTER TABLE t RENAME CONSTRAINT cu3 TO cu4;
ALTER TABLE t RENAME CONSTRAINT cc3 TO cc4;
ALTER TABLE t RENAME CONSTRAINT cf3 TO cf4;

-- onlyif config schema-locked-disabled

-- Test 16: query (line 121)
SELECT * FROM pg_show_constraints('public.t'::regclass);

-- Test 17: query (line 135)
SELECT * FROM pg_show_constraints('public.t'::regclass);

-- Test 18: query (line 148)
SELECT conname, contype
FROM pg_catalog.pg_constraint
WHERE conrelid = 'public.t'::regclass
ORDER BY conname;

-- Test 19: statement (line 157)
-- CockroachDB creates an implicit primary key on a hidden rowid column; model that explicitly.
CREATE TABLE implicit (a int, b int, rowid bigserial PRIMARY KEY);

-- Test 20: statement (line 160)
ALTER TABLE implicit RENAME CONSTRAINT implicit_pkey TO something_else;

-- Test 21: query (line 163)
SELECT * FROM pg_show_constraints('public.implicit'::regclass);

-- Test 22: statement (line 169)
-- Expected ERROR (constraint name already exists):
\set ON_ERROR_STOP 0
ALTER TABLE implicit ADD CONSTRAINT something_else CHECK (b > 0);
\set ON_ERROR_STOP 1

RESET client_min_messages;
