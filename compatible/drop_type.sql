-- PostgreSQL compatible tests from drop_type
--
-- CockroachDB settings/directives (sql_safe_updates, skipif/onlyif, etc.) do
-- not map to PG when running via psql. This file focuses on DROP TYPE behavior
-- and dependency handling in PostgreSQL.

SET client_min_messages = warning;
DROP TABLE IF EXISTS drop_type_tab CASCADE;
DROP TYPE IF EXISTS drop_type_enum CASCADE;
DROP TYPE IF EXISTS drop_type_composite CASCADE;
DROP FUNCTION IF EXISTS drop_type_f(drop_type_composite);
RESET client_min_messages;

-- Enum type used by a table.
CREATE TYPE drop_type_enum AS ENUM ('a', 'b');
CREATE TABLE drop_type_tab (id INT, e drop_type_enum);
INSERT INTO drop_type_tab VALUES (1, 'a');
SELECT e FROM drop_type_tab ORDER BY id;

-- Drop the type CASCADE; the dependent table should be dropped.
DROP TYPE drop_type_enum CASCADE;
SELECT to_regclass('drop_type_tab') AS tab_after_drop;
SELECT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'drop_type_enum') AS enum_still_there;

-- Composite type used by a function.
CREATE TYPE drop_type_composite AS (x INT, y INT);
CREATE FUNCTION drop_type_f(v drop_type_composite) RETURNS INT LANGUAGE SQL AS $$ SELECT v.x + v.y $$;
SELECT drop_type_f(ROW(1, 2)::drop_type_composite);

-- Dropping the type CASCADE removes dependent objects (function).
DROP TYPE drop_type_composite CASCADE;
SELECT EXISTS (SELECT 1 FROM pg_proc WHERE proname = 'drop_type_f') AS func_still_there;

