-- PostgreSQL compatible tests from udf_in_constraints
-- Reduced subset: CockroachDB descriptor introspection, SHOW CREATE TABLE, and
-- schema-locking settings are removed. Validate IMMUTABLE UDF usage inside
-- CHECK constraints, and show that function renames are reflected when
-- deparsing constraint definitions.

SET client_min_messages = warning;
DROP TABLE IF EXISTS t1 CASCADE;
DROP FUNCTION IF EXISTS f1(int);
DROP FUNCTION IF EXISTS f2(int);
RESET client_min_messages;

CREATE FUNCTION f1(a INT) RETURNS INT
LANGUAGE SQL
IMMUTABLE
AS $$ SELECT a + 1 $$;

CREATE TABLE t1 (
  a INT PRIMARY KEY,
  b INT,
  CONSTRAINT check_b CHECK (f1(b) > 1),
  CONSTRAINT check_a CHECK (f1(a) > 1)
);

INSERT INTO t1 VALUES (2, 1), (3, 10);

SELECT conname, pg_get_constraintdef(oid) AS condef
FROM pg_constraint
WHERE conrelid = 't1'::regclass AND contype = 'c'
ORDER BY conname;

ALTER FUNCTION f1(int) RENAME TO f2;

SELECT conname, pg_get_constraintdef(oid) AS condef
FROM pg_constraint
WHERE conrelid = 't1'::regclass AND contype = 'c'
ORDER BY conname;

SELECT pg_get_functiondef('f2(int)'::regprocedure);
