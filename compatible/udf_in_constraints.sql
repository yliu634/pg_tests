-- PostgreSQL compatible tests from udf_in_constraints
--
-- This file adapts the CockroachDB logic-test coverage for UDF dependencies in:
-- - CHECK constraints
--
-- In PostgreSQL, dependencies are tracked via pg_depend and will prevent
-- dropping a function while a constraint depends on it.

\set ON_ERROR_STOP 1
SET client_min_messages = warning;

-- List check constraints on a table.
CREATE OR REPLACE FUNCTION get_checks(p_table regclass)
RETURNS TABLE(constraint_name text, constraint_def text)
LANGUAGE SQL
AS $$
  SELECT c.conname, pg_get_constraintdef(c.oid, true)
  FROM pg_constraint c
  WHERE c.conrelid = p_table::oid
    AND c.contype = 'c'
  ORDER BY 1;
$$;

-- List constraints that depend on a function.
CREATE OR REPLACE FUNCTION get_fn_depended_on_by(p_fn regprocedure)
RETURNS TABLE(dependent_table text, dependent_constraint text)
LANGUAGE SQL
AS $$
  SELECT con.conrelid::regclass::text, con.conname
  FROM pg_depend d
  JOIN pg_constraint con ON con.oid = d.objid
  WHERE d.classid = 'pg_constraint'::regclass
    AND d.refclassid = 'pg_proc'::regclass
    AND d.refobjid = p_fn
    AND d.deptype = 'n'
  ORDER BY 1, 2;
$$;

-- A function referenced by check constraints.
CREATE FUNCTION f1(a int) RETURNS int IMMUTABLE LANGUAGE SQL AS $$ SELECT a + 1 $$;

CREATE TABLE t1 (
  a int PRIMARY KEY,
  b int,
  CONSTRAINT chk_b CHECK (f1(b) > 1)
);

SELECT * FROM get_checks('t1'::regclass);
SELECT * FROM get_fn_depended_on_by('f1(int)'::regprocedure);

ALTER TABLE t1 ADD CONSTRAINT cka CHECK (f1(a) > 1);
ALTER TABLE t1 ADD CONSTRAINT ckb CHECK (f1(b) > 2) NOT VALID;

SELECT * FROM get_checks('t1'::regclass);
SELECT * FROM get_fn_depended_on_by('f1(int)'::regprocedure);

-- Dropping the function should error while constraints depend on it.
\set ON_ERROR_STOP 0
DROP FUNCTION f1(int);
\set ON_ERROR_STOP 1

ALTER TABLE t1 DROP CONSTRAINT cka;
SELECT * FROM get_fn_depended_on_by('f1(int)'::regprocedure);

ALTER TABLE t1 DROP CONSTRAINT ckb;
SELECT * FROM get_fn_depended_on_by('f1(int)'::regprocedure);

ALTER TABLE t1 DROP CONSTRAINT chk_b;
SELECT * FROM get_fn_depended_on_by('f1(int)'::regprocedure);

DROP FUNCTION f1(int);
DROP TABLE t1;

-- Schema-qualified function in constraint.
CREATE SCHEMA sc1;
CREATE FUNCTION sc1.f1(a int) RETURNS int IMMUTABLE LANGUAGE SQL AS $$ SELECT a + 1 $$;

CREATE TABLE t2 (
  a int PRIMARY KEY,
  b int,
  CONSTRAINT chk_sc1 CHECK (sc1.f1(b) > 1)
);

SELECT * FROM get_checks('t2'::regclass);
SELECT * FROM get_fn_depended_on_by('sc1.f1(int)'::regprocedure);

ALTER FUNCTION sc1.f1(int) RENAME TO f2;

SELECT * FROM get_checks('t2'::regclass);
SELECT * FROM get_fn_depended_on_by('sc1.f2(int)'::regprocedure);

\set ON_ERROR_STOP 0
DROP FUNCTION sc1.f2(int);
\set ON_ERROR_STOP 1

DROP TABLE t2;
DROP FUNCTION sc1.f2(int);
DROP SCHEMA sc1;

RESET client_min_messages;
