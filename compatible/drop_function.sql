-- PostgreSQL compatible tests from drop_function
--
-- CockroachDB has SHOW CREATE FUNCTION, custom settings, and logic-test
-- directives that do not run under plain psql. This file exercises common
-- DROP FUNCTION cases using PG-native catalog queries.

SET client_min_messages = warning;
DROP SCHEMA IF EXISTS sc1 CASCADE;
DROP SCHEMA IF EXISTS altschema CASCADE;
DROP TABLE IF EXISTS t1_with_b_2_ref;
DROP TYPE IF EXISTS t114677 CASCADE;
DROP TYPE IF EXISTS t114677_2 CASCADE;
DROP FUNCTION IF EXISTS f_test_drop();
DROP FUNCTION IF EXISTS f_test_drop(int);
DROP FUNCTION IF EXISTS f_called_by_b();
DROP FUNCTION IF EXISTS f_called_by_b2();
DROP FUNCTION IF EXISTS f_b();
DROP FUNCTION IF EXISTS f142886(varchar);
RESET client_min_messages;

-- Overloads + schema-qualified functions.
CREATE FUNCTION f_test_drop() RETURNS INT LANGUAGE SQL AS $$ SELECT 1 $$;
CREATE FUNCTION f_test_drop(int) RETURNS INT LANGUAGE SQL AS $$ SELECT 1 $$;

CREATE SCHEMA sc1;
CREATE FUNCTION sc1.f_test_drop(int) RETURNS INT LANGUAGE SQL AS $$ SELECT 1 $$;

-- "SHOW CREATE FUNCTION" equivalent via pg_catalog.
SELECT pg_get_functiondef(p.oid) AS create_statement
FROM pg_proc p
JOIN pg_namespace n ON n.oid = p.pronamespace
WHERE n.nspname = 'public' AND p.proname = 'f_test_drop'
ORDER BY 1;

SELECT pg_get_functiondef(p.oid) AS create_statement
FROM pg_proc p
JOIN pg_namespace n ON n.oid = p.pronamespace
WHERE n.nspname = 'sc1' AND p.proname = 'f_test_drop'
ORDER BY 1;

-- Drop a specific overload.
DROP FUNCTION f_test_drop(int);

SELECT pg_get_functiondef(p.oid) AS create_statement
FROM pg_proc p
JOIN pg_namespace n ON n.oid = p.pronamespace
WHERE n.nspname = 'public' AND p.proname = 'f_test_drop'
ORDER BY 1;

-- Dropping the schema removes its functions.
DROP SCHEMA sc1 CASCADE;

-- Composite-type overloads.
CREATE TYPE t114677 AS (x INT, y INT);
CREATE TYPE t114677_2 AS (a INT, b INT);

CREATE FUNCTION f114677(v t114677) RETURNS INT LANGUAGE SQL AS $$ SELECT 0 $$;
CREATE FUNCTION f114677(v t114677_2) RETURNS INT LANGUAGE SQL AS $$ SELECT 1 $$;

SELECT pg_get_functiondef(p.oid) AS create_statement
FROM pg_proc p
JOIN pg_namespace n ON n.oid = p.pronamespace
WHERE n.nspname = 'public' AND p.proname = 'f114677'
ORDER BY 1;

DROP FUNCTION f114677(t114677);
DROP FUNCTION f114677(t114677_2);

SELECT pg_get_functiondef(p.oid) AS create_statement
FROM pg_proc p
JOIN pg_namespace n ON n.oid = p.pronamespace
WHERE n.nspname = 'public' AND p.proname = 'f114677'
ORDER BY 1;

DROP TYPE t114677;
DROP TYPE t114677_2;

-- Dependency via table default + check, plus ALTER FUNCTION SET SCHEMA.
CREATE FUNCTION f_called_by_b() RETURNS INT LANGUAGE SQL AS $$ SELECT 1 $$;
CREATE FUNCTION f_called_by_b2() RETURNS INT LANGUAGE SQL AS $$ SELECT 1 + f_called_by_b() $$;

CREATE SCHEMA altschema;
ALTER FUNCTION f_called_by_b() SET SCHEMA altschema;

CREATE TABLE t1_with_b_2_ref(
  j INT DEFAULT altschema.f_called_by_b() CHECK (altschema.f_called_by_b() > 0)
);

SELECT column_name, column_default
FROM information_schema.columns
WHERE table_schema = 'public' AND table_name = 't1_with_b_2_ref'
ORDER BY ordinal_position;

DROP TABLE t1_with_b_2_ref;
DROP FUNCTION f_called_by_b2();
DROP SCHEMA altschema CASCADE;

-- Simple drop-by-signature example.
CREATE FUNCTION f142886(p VARCHAR(10)) RETURNS INT LANGUAGE SQL AS $$ SELECT 0 $$;
DROP FUNCTION f142886(VARCHAR);

-- Clean up.
DROP FUNCTION f_test_drop();

