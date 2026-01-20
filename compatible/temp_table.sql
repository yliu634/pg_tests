-- PostgreSQL compatible tests from temp_table
-- Reduced subset: remove CockroachDB cross-database settings/USE directives and
-- focus on PostgreSQL temporary table behavior.

SET client_min_messages = warning;
DROP TABLE IF EXISTS public.table_a CASCADE;
DROP TABLE IF EXISTS permanent_table CASCADE;
RESET client_min_messages;

-- Basic temp table creation and catalog visibility.
CREATE TEMP TABLE tbl (a INT);
SELECT schemaname LIKE 'pg_temp%' AS is_temp_schema, tablename
FROM pg_tables
WHERE tablename = 'tbl';

DROP TABLE tbl;

-- Temp tables with FK between them.
CREATE TEMP TABLE temp_table_test (a TIMETZ PRIMARY KEY) ON COMMIT PRESERVE ROWS;
CREATE TEMP TABLE temp_table_ref (a TIMETZ PRIMARY KEY);
ALTER TABLE temp_table_ref
  ADD CONSTRAINT fk_temp FOREIGN KEY (a) REFERENCES temp_table_test(a);

SELECT table_name, table_schema
FROM information_schema.tables
WHERE table_name IN ('temp_table_test', 'temp_table_ref') AND table_schema LIKE 'pg_temp_%'
ORDER BY table_name;

DROP TABLE temp_table_ref;
DROP TABLE temp_table_test;

-- Temp table shadowing a permanent table of the same name.
CREATE TABLE public.table_a (a INT);
CREATE TEMP TABLE table_a (a INT);

INSERT INTO table_a VALUES (2);
INSERT INTO public.table_a VALUES (3);

SELECT * FROM table_a ORDER BY a;
SELECT * FROM public.table_a ORDER BY a;

DROP TABLE table_a;
DROP TABLE public.table_a;

-- Temp view on a permanent table.
CREATE TABLE permanent_table(a INT);
INSERT INTO permanent_table VALUES (1);
CREATE TEMP VIEW view_on_permanent AS SELECT a FROM permanent_table;
SELECT * FROM pg_temp.view_on_permanent ORDER BY a;
DROP VIEW view_on_permanent;
DROP TABLE permanent_table;
