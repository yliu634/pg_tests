-- PostgreSQL compatible tests from record
--
-- CockroachDB's upstream logic-test version mixes directives and Cockroach-only
-- DDL features. This reduced version exercises PostgreSQL composite/record
-- behavior using table row types.

SET client_min_messages = warning;

DROP TABLE IF EXISTS a;
CREATE TABLE a(a INT PRIMARY KEY, b TEXT);
INSERT INTO a VALUES (1, '2');

-- Selecting a table alias as a composite and accessing its fields.
SELECT t, (t).a, (t).b FROM a AS t;

-- Casting a row literal to the table's composite type.
SELECT ROW(1, 'foo')::a AS rec, (ROW(1, 'foo')::a).b AS b;

-- Arrays of composite values.
SELECT ARRAY[ROW(1, 'foo')::a, ROW(2, 'bar')::a] AS arr;
SELECT pg_typeof(ARRAY[ROW(1, 'foo')::a]) AS arr_type;

-- Composite input format from text.
SELECT '(1,2)'::a;

DROP TABLE a;

RESET client_min_messages;
