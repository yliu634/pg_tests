-- PostgreSQL compatible tests from procedure
--
-- The upstream CockroachDB logic-test file mixes Cockroach system tables and
-- negative cases (procedures used as expressions). This reduced version
-- exercises core PostgreSQL procedures and CALL semantics without errors.

SET client_min_messages = warning;

DROP TABLE IF EXISTS t;
DROP SEQUENCE IF EXISTS s;
DROP PROCEDURE IF EXISTS p();
DROP PROCEDURE IF EXISTS t_update(INT, INT);

CREATE SEQUENCE s;

CREATE PROCEDURE p() LANGUAGE SQL AS $$
  SELECT nextval('s');
$$;

CALL p();
SELECT currval('s') AS s_currval;

CREATE TABLE t (k INT PRIMARY KEY, v INT);
INSERT INTO t VALUES (1, 10);

CREATE PROCEDURE t_update(k_arg INT, v_arg INT) LANGUAGE SQL AS $$
  UPDATE t SET v = v_arg WHERE k = k_arg;
$$;

CALL t_update(1, 11);
SELECT * FROM t ORDER BY k;

DROP PROCEDURE p();
DROP PROCEDURE t_update(INT, INT);
DROP TABLE t;
DROP SEQUENCE s;

RESET client_min_messages;
