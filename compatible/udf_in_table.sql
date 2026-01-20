-- PostgreSQL compatible tests from udf_in_table
-- Reduced subset: CockroachDB ON UPDATE expressions, VIRTUAL computed columns,
-- and descriptor introspection are removed. Validate functions used in column
-- defaults and generated columns, and show that renaming a function is
-- reflected when deparsing stored expressions.

SET client_min_messages = warning;
DROP TABLE IF EXISTS t1 CASCADE;
DROP FUNCTION IF EXISTS f1();
DROP FUNCTION IF EXISTS f2();
RESET client_min_messages;

CREATE FUNCTION f1() RETURNS INT
LANGUAGE SQL
IMMUTABLE
AS $$ SELECT 1 $$;

CREATE TABLE t1 (
  a INT PRIMARY KEY,
  b INT DEFAULT f1(),
  g INT GENERATED ALWAYS AS (a + f1()) STORED
);

INSERT INTO t1 (a) VALUES (10), (20);

SELECT * FROM t1 ORDER BY a;

SELECT a.attname, a.attgenerated, pg_get_expr(d.adbin, d.adrelid) AS expr
FROM pg_attribute a
LEFT JOIN pg_attrdef d ON d.adrelid = a.attrelid AND d.adnum = a.attnum
WHERE a.attrelid = 't1'::regclass
  AND a.attnum > 0
  AND NOT a.attisdropped
ORDER BY a.attname;

ALTER FUNCTION f1() RENAME TO f2;

INSERT INTO t1 (a) VALUES (30);

SELECT * FROM t1 ORDER BY a;

SELECT a.attname, a.attgenerated, pg_get_expr(d.adbin, d.adrelid) AS expr
FROM pg_attribute a
LEFT JOIN pg_attrdef d ON d.adrelid = a.attrelid AND d.adnum = a.attnum
WHERE a.attrelid = 't1'::regclass
  AND a.attnum > 0
  AND NOT a.attisdropped
ORDER BY a.attname;

SELECT pg_get_functiondef('f2()'::regprocedure);
