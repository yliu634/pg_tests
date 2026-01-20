-- PostgreSQL compatible tests from routine_schema_change
--
-- CockroachDB-specific schema changer feature flags and EXPLAIN(DDL) are not
-- available in PostgreSQL. This reduced version simply creates and drops a
-- function and a procedure.

SET client_min_messages = warning;

DROP FUNCTION IF EXISTS f();
DROP PROCEDURE IF EXISTS p();

CREATE FUNCTION f() RETURNS INT LANGUAGE SQL AS $$ SELECT 1; $$;
SELECT f();

CREATE PROCEDURE p() LANGUAGE SQL AS $$ SELECT 1; $$;
CALL p();

DROP FUNCTION f();
DROP PROCEDURE p();

RESET client_min_messages;
