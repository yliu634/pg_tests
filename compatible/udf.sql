-- PostgreSQL compatible tests from udf
-- Reduced subset: remove CockroachDB SHOW CREATE FUNCTION/USE directives and
-- error-expecting UDF definitions. Validate basic SQL-language functions.

SET client_min_messages = warning;
DROP TABLE IF EXISTS ab CASCADE;
DROP TYPE IF EXISTS notmyworkday;
DROP FUNCTION IF EXISTS a(int);
DROP FUNCTION IF EXISTS b(int);
DROP FUNCTION IF EXISTS c(int,int);
RESET client_min_messages;

CREATE TABLE ab (
  a INT PRIMARY KEY,
  b INT
);
INSERT INTO ab VALUES (1, 10), (2, 20);

CREATE TYPE notmyworkday AS ENUM ('Monday', 'Tuesday');

CREATE FUNCTION a(i INT) RETURNS INT
LANGUAGE SQL
AS $$ SELECT i $$;

CREATE FUNCTION b(i INT) RETURNS INT
LANGUAGE SQL
AS $$ SELECT b FROM ab WHERE a = i $$;

CREATE FUNCTION c(i INT, j INT) RETURNS INT
LANGUAGE SQL
AS $$ SELECT i - j $$;

SELECT a(5) AS a_5;
SELECT b(2) AS b_2;
SELECT c(10, 3) AS c_10_3;

-- Show function definition via PostgreSQL catalog.
SELECT pg_get_functiondef('a(int)'::regprocedure);
