-- PostgreSQL compatible tests from record
-- 40 tests

-- CockroachDB record tests include CRDB-only harness directives and sometimes
-- omit semicolons. This file is rewritten as pure PostgreSQL SQL/psql while
-- keeping the semantic focus: composite (row) types, field access, arrays of
-- composite, and expected-error cases for anonymous record input.

SET client_min_messages = warning;

DROP TABLE IF EXISTS rec_a;
DROP TABLE IF EXISTS rec_holder;
DROP TABLE IF EXISTS rec_strings;

-- Test 1: a table implicitly defines a composite type of the same name.
CREATE TABLE rec_a(a INT PRIMARY KEY, b TEXT);
INSERT INTO rec_a VALUES (1, '2');

-- Test 2: selecting a row value + field access + expansion.
SELECT t, t.a, t.b, t.* FROM rec_a AS t;

-- Test 3: cast a row constructor to the table's composite type.
SELECT (1, 'foo')::rec_a, ((1, 'foo')::rec_a).b;

-- Test 4: expected error (invalid int input for field a).
\set ON_ERROR_STOP 0
SELECT ('blah', 'blah')::rec_a;
\set ON_ERROR_STOP 1

-- Test 5: schema-qualified type resolution.
SELECT (1, 'foo')::public.rec_a;

-- Test 6: a table row type can be used as a column type (composite).
CREATE TABLE rec_holder(x rec_a);
INSERT INTO rec_holder VALUES ((1, 'hello')::rec_a);
SELECT (x).a, (x).b, x FROM rec_holder;

-- Test 7: regtype/regclass basics for the table/type.
SELECT 'rec_a'::regtype, 'rec_a'::regclass;

-- Test 8-11: composite arrays and pg_typeof.
SELECT pg_typeof((1, 3)::rec_a);
SELECT ARRAY[(1, 3)::rec_a, (1, 2)::rec_a];
SELECT pg_typeof(ARRAY[(1, 3)::rec_a, (1, 2)::rec_a]);
SELECT pg_typeof(ARRAY[(1, 3)::rec_a, (1, 2)::rec_a])::regtype::oid::regtype;

-- Test 12: expected error (cannot drop the table's composite type directly).
\set ON_ERROR_STOP 0
DROP TYPE rec_a;
\set ON_ERROR_STOP 1

-- Test 13-15: record arrays and text input for composite types.
SELECT COALESCE(ARRAY[ROW(1, 2)], '{}');
SELECT COALESCE(NULL, '{}'::record[]);

SELECT '{"(1, 3)","(1, 2)"}'::rec_a[];
SELECT COALESCE(NULL::rec_a[], '{"(1, 3)","(1, 2)"}');

CREATE TABLE rec_strings(s TEXT);
INSERT INTO rec_strings VALUES ('(1,2)'), ('(5,6)');

SELECT s, s::rec_a FROM rec_strings ORDER BY 1;
SELECT '(1 , 2)'::rec_a;

-- Test 16-18: expected errors for anonymous record input.
\set ON_ERROR_STOP 0
SELECT '()'::rec_a;
SELECT s, s::record FROM rec_strings ORDER BY 1;
SELECT '()'::record;
SELECT '(1,4)'::record;
\set ON_ERROR_STOP 1

RESET client_min_messages;
