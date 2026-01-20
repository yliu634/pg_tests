SET client_min_messages = warning;

-- PostgreSQL compatible tests from namespace
-- 25 tests
--
-- The original CockroachDB test exercises database+schema resolution via
-- Cockroach-only constructs (SET database, SHOW TABLES FROM <db>, and three-part
-- names like db.schema.table). PostgreSQL uses schemas and search_path instead.

-- Test 1: statement (line 2)
DROP SCHEMA IF EXISTS ns1 CASCADE;
DROP SCHEMA IF EXISTS ns2 CASCADE;
CREATE SCHEMA ns1;
CREATE SCHEMA ns2;

-- Test 2: statement (line 5)
DROP TABLE IF EXISTS public.t CASCADE;
DROP TABLE IF EXISTS ns1.t CASCADE;
CREATE TABLE public.t(a INT);
CREATE TABLE ns1.t(a INT);
INSERT INTO public.t VALUES (1);
INSERT INTO ns1.t VALUES (2);

-- Test 3: query (line 9)
SELECT table_schema, table_name
FROM information_schema.tables
WHERE table_schema IN ('public', 'ns1') AND table_name = 't'
ORDER BY table_schema, table_name;

-- Test 4: query (line 16)
SET search_path = ns1, public;
SELECT a FROM t ORDER BY a;

-- Test 5: query (line 23)
SET search_path = public, ns1;
SELECT a FROM t ORDER BY a;

-- Test 6: query (line 26)
SELECT current_schema() AS current_schema;

-- Test 7: query (line 31)
SELECT typname FROM pg_catalog.pg_type WHERE typname = 'date';

-- Test 8: statement (line 34)
DROP TABLE IF EXISTS a CASCADE;
CREATE TABLE a(a INT PRIMARY KEY);

-- Test 9: statement (line 38)
ALTER INDEX a_pkey RENAME TO a_pk;

-- Test 10: statement (line 44)
ALTER INDEX a_pk RENAME TO a_pk2;

-- Test 11: statement (line 47)
ALTER INDEX public.a_pk2 RENAME TO a_pk3;

-- Test 12: statement (line 50)
-- search_path can include unknown schemas; resolution uses the first existing entry.
SET search_path = invalid, public;
SELECT 1;

RESET client_min_messages;

