-- PostgreSQL compatible tests from procedure_deps
--
-- The upstream CockroachDB logic-test file validates many schema-change +
-- procedure dependency edge cases. This reduced version keeps a simple
-- dependency: a procedure that inserts into a table.

SET client_min_messages = warning;

DROP TABLE IF EXISTS t;
DROP PROCEDURE IF EXISTS ins();

CREATE TABLE t (a INT PRIMARY KEY, b INT);

CREATE PROCEDURE ins() LANGUAGE SQL AS $$
  INSERT INTO t(a, b) VALUES (1, 10);
$$;

CALL ins();
SELECT * FROM t ORDER BY a;

DROP PROCEDURE ins();
DROP TABLE t;

RESET client_min_messages;
