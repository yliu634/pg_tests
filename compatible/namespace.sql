-- PostgreSQL compatible tests from namespace
-- 25 tests

-- NOTE: This file is derived from CockroachDB's namespace tests and includes
-- Cockroach-specific multi-database syntax (db.schema.table), SET database, and
-- SHOW TABLES commands that are not portable to PostgreSQL in this workspace.
-- We exercise the closest PostgreSQL equivalents (schemas + search_path) below.
-- The original content is preserved (commented out) at the end for reference.
SET client_min_messages = warning;

DROP SCHEMA IF EXISTS ns_test CASCADE;
DROP SCHEMA IF EXISTS ns_shadow CASCADE;
CREATE SCHEMA ns_test;
CREATE SCHEMA ns_shadow;

-- Basic table in public schema (simulates default database + schema).
DROP TABLE IF EXISTS a;
CREATE TABLE a(a INT PRIMARY KEY);
INSERT INTO a VALUES (1);

-- Table in an alternate schema.
CREATE TABLE ns_test.t(a INT PRIMARY KEY);
INSERT INTO ns_test.t VALUES (10);

-- "SHOW TABLES FROM <schema>": use pg_tables / information_schema instead.
SELECT schemaname, tablename
FROM pg_catalog.pg_tables
WHERE schemaname IN ('public', 'ns_test')
ORDER BY 1, 2;

-- "SET database": approximate by switching search_path.
SET search_path TO ns_test, public, pg_catalog;
SELECT current_schema() AS current_schema;

SELECT tablename
FROM pg_catalog.pg_tables
WHERE schemaname = current_schema()
ORDER BY 1;

-- Demonstrate search_path shadowing: a user table named like a system catalog.
SET search_path TO ns_shadow, pg_catalog;
CREATE TABLE pg_type(x INT);
INSERT INTO pg_type VALUES (42);
SELECT x FROM pg_type ORDER BY x;

SET search_path TO pg_catalog, ns_shadow;
SELECT typname FROM pg_type WHERE typname = 'date';

-- Index renames with schema-qualified names and schema moves.
RESET search_path;
ALTER INDEX a_pkey RENAME TO a_pk;
ALTER INDEX public.a_pk RENAME TO a_pk2;
ALTER TABLE a SET SCHEMA ns_test;
ALTER INDEX ns_test.a_pk2 RENAME TO a_pk3;
ALTER TABLE ns_test.a SET SCHEMA public;
ALTER INDEX public.a_pk3 RENAME TO a_pk4;

DROP SCHEMA ns_test CASCADE;
DROP SCHEMA ns_shadow CASCADE;

RESET client_min_messages;

/*

-- Test 1: statement (line 2)
CREATE TABLE a(a INT)

-- Test 2: statement (line 5)
CREATE DATABASE public; CREATE TABLE public.public.t(a INT)

-- Test 3: query (line 9)
SHOW TABLES FROM public

-- Test 4: query (line 16)
SHOW TABLES FROM public.public

-- Test 5: statement (line 23)
SET database = public

-- Test 6: query (line 26)
SHOW TABLES

-- Test 7: statement (line 31)
SET database = test

-- Test 8: statement (line 34)
DROP DATABASE public

-- Test 9: query (line 38)
SELECT typname FROM pg_type WHERE typname = 'date'

-- Test 10: statement (line 44)
SET search_path=public,pg_catalog

-- Test 11: statement (line 47)
CREATE TABLE pg_type(x INT); INSERT INTO pg_type VALUES(42)

-- Test 12: query (line 50)
SELECT x FROM pg_type

-- Test 13: query (line 57)
SET database = ''; SELECT * FROM pg_type

# Go to different database, check name still resolves to default.
query T
CREATE DATABASE foo; SET database = foo; SELECT typname FROM pg_type WHERE typname = 'date'

-- Test 14: query (line 67)
SET database = test; SET search_path = pg_catalog,public; SELECT typname FROM pg_type WHERE typname = 'date'

-- Test 15: query (line 74)
SET search_path = public,pg_catalog; SELECT x FROM pg_type

-- Test 16: statement (line 79)
DROP TABLE pg_type; RESET search_path; SET database = test

-- Test 17: statement (line 83)
ALTER INDEX a_pkey RENAME TO a_pk

-- Test 18: statement (line 87)
ALTER INDEX public.a_pk RENAME TO a_pk2

-- Test 19: statement (line 91)
ALTER INDEX test.a_pk2 RENAME TO a_pk3

-- Test 20: statement (line 94)
CREATE DATABASE public; CREATE TABLE public.public.t(a INT)

-- Test 21: statement (line 98)
ALTER INDEX public.t_pkey RENAME TO t_pk

-- Test 22: statement (line 102)
ALTER INDEX public.public.t_pkey RENAME TO t_pk

-- Test 23: statement (line 106)
SET search_path = invalid

-- Test 24: statement (line 109)
ALTER INDEX a_pk3 RENAME TO a_pk4

-- Test 25: statement (line 113)
ALTER INDEX public.a_pk3 RENAME TO a_pk4

*/
