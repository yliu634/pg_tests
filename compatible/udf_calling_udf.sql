-- PostgreSQL compatible tests from udf_calling_udf
-- Reduced subset: remove CockroachDB SHOW CREATE directives and complex cyclic
-- dependency cases. Validate a function calling a function and a procedure.

SET client_min_messages = warning;
DROP SCHEMA IF EXISTS sc2 CASCADE;
DROP FUNCTION IF EXISTS udfcall(int);
DROP FUNCTION IF EXISTS udfcallnest(int,int);
DROP FUNCTION IF EXISTS "fooBAR"();
DROP FUNCTION IF EXISTS f131354();
DROP PROCEDURE IF EXISTS p131354();
RESET client_min_messages;

CREATE FUNCTION udfCall(i int) RETURNS INT
LANGUAGE SQL
AS $$ SELECT 100 + i $$;

CREATE FUNCTION udfCallNest(i int, j int) RETURNS INT
LANGUAGE SQL
AS $$ SELECT udfCall(i) + j $$;

SELECT udfCallNest(1, 2) AS nested;

CREATE SCHEMA sc2;
ALTER FUNCTION udfCallNest(int, int) SET SCHEMA sc2;

SELECT sc2.udfCallNest(1, 2) AS nested_in_schema;

CREATE FUNCTION "fooBAR"() RETURNS INT LANGUAGE SQL AS $$ SELECT 1 $$;
CREATE FUNCTION f131354() RETURNS INT LANGUAGE SQL AS $$ SELECT "fooBAR"() $$;
CREATE PROCEDURE p131354() LANGUAGE SQL AS $$ SELECT "fooBAR"() $$;

SELECT f131354();
CALL p131354();

SELECT pg_get_functiondef('f131354()'::regprocedure);
SELECT pg_get_functiondef('p131354()'::regprocedure);
