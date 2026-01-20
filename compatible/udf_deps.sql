-- PostgreSQL compatible tests from udf_deps
-- Reduced subset: CockroachDB schema-changer dependency behavior (and UPSERT)
-- does not map directly to PostgreSQL. Demonstrate a simple function/table
-- evolution workflow without errors.

SET client_min_messages = warning;
DROP TABLE IF EXISTS t CASCADE;
DROP FUNCTION IF EXISTS sel();
RESET client_min_messages;

CREATE TABLE t (
  a INT PRIMARY KEY,
  b INT
);
INSERT INTO t VALUES (1, 10);

CREATE FUNCTION sel() RETURNS TABLE(a INT, b INT)
LANGUAGE SQL
AS $$
  SELECT a, b FROM t;
$$;

SELECT * FROM sel();

ALTER TABLE t RENAME COLUMN b TO b2;
DROP FUNCTION sel();

CREATE FUNCTION sel() RETURNS TABLE(a INT, b2 INT)
LANGUAGE SQL
AS $$
  SELECT a, b2 FROM t;
$$;

SELECT * FROM sel();
