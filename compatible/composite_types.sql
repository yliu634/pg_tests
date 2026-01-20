-- PostgreSQL compatible tests from composite_types
-- 72 tests

SET client_min_messages = warning;

-- Cleanup from prior runs (psql-friendly + idempotent).
DROP DATABASE IF EXISTS "CaseSensitiveDatabase";
DROP SCHEMA IF EXISTS sc1 CASCADE;
DROP TABLE IF EXISTS arr_composite_tab;
DROP TABLE IF EXISTS atyp;
DROP TABLE IF EXISTS tab;
DROP TABLE IF EXISTS a;
DROP TABLE IF EXISTS torename;
DROP TABLE IF EXISTS t_table;
DROP TABLE IF EXISTS t_renamed;
DROP TYPE IF EXISTS t2 CASCADE;
DROP TYPE IF EXISTS arr_composite CASCADE;
DROP TYPE IF EXISTS t CASCADE;
DROP TYPE IF EXISTS e CASCADE;

-- Test 1: statement (line 1)
CREATE TYPE t AS (a INT, b INT);

-- Test 2: statement (line 4)
DROP TYPE IF EXISTS t;

-- Test 3: statement (line 7)
CREATE TYPE t AS (a INT, b INT);

-- Test 4: statement (line 10)
SELECT (ROW(1, 2)::t).*;

-- Test 5: statement (line 13)
CREATE TABLE t_table (x INT);

-- Test 6: statement (line 16)
CREATE TYPE t_single AS (a INT);

-- Test 7: statement (line 19)
CREATE TABLE torename (x INT);

-- Test 8: statement (line 22)
ALTER TABLE torename RENAME TO t_renamed;

-- Test 9: query (line 25)
SELECT (1, 2)::t, ((1, 2)::t).a, ((1, 2)::t).b;

-- Test 10: statement (line 30)
SELECT ((1, 2)::t).a AS foo;

-- Test 11: statement (line 33)
DROP TABLE IF EXISTS tab;
CREATE TABLE tab (a t, i INT DEFAULT 0);

-- Test 12: statement (line 36)
INSERT INTO tab(a) VALUES (NULL), (ROW(1, 2)::t);

-- Test 13: statement (line 39)
INSERT INTO tab(a) VALUES (ROW(1, NULL)::t);

-- Test 14: statement (line 44)
INSERT INTO tab(a) VALUES (ROW(1, 2)::t), (ROW(1, NULL)::t);

-- Test 15: query (line 47)
SELECT a, (a).a, (a).b FROM tab;

-- Test 16: statement (line 54)
DROP TABLE IF EXISTS tab;

-- Test 17: statement (line 58)
CREATE TYPE arr_composite AS (a INT[], b TEXT[]);

-- Test 18: query (line 61)
SELECT
  current_database() AS database_name,
  n.nspname AS schema_name,
  t.typname AS descriptor_name,
  'CREATE TYPE '
    || quote_ident(n.nspname) || '.' || quote_ident(t.typname)
    || ' AS ('
    || string_agg(
      quote_ident(a.attname) || ' ' || pg_catalog.format_type(a.atttypid, a.atttypmod),
      ', ' ORDER BY a.attnum
    )
    || ')' AS create_statement
FROM pg_type AS t
JOIN pg_namespace AS n ON n.oid = t.typnamespace
JOIN pg_class AS c ON c.oid = t.typrelid AND c.relkind = 'c'
JOIN pg_attribute AS a ON a.attrelid = c.oid AND a.attnum > 0 AND NOT a.attisdropped
WHERE t.typname = 'arr_composite'
GROUP BY 1, 2, 3;

-- Test 19: statement (line 67)
DROP TABLE IF EXISTS arr_composite_tab;
CREATE TABLE arr_composite_tab (x arr_composite);

-- Test 20: statement (line 70)
INSERT INTO arr_composite_tab VALUES (ROW(ARRAY[1, 2, 3], ARRAY['a', 'b'])::arr_composite);

-- Test 21: statement (line 73)
INSERT INTO arr_composite_tab VALUES (ROW(ARRAY[4, 5], ARRAY['c', 'd', 'e'])::arr_composite);

-- Test 22: query (line 76)
SELECT * FROM arr_composite_tab;

-- Test 23: query (line 82)
SELECT (x).a, (x).b FROM arr_composite_tab;

-- Test 24: statement (line 88)
DROP TABLE IF EXISTS arr_composite_tab;

-- Test 25: statement (line 91)
DROP TYPE IF EXISTS arr_composite;

-- Test 26: statement (line 95)
DROP TABLE IF EXISTS atyp;
CREATE TABLE atyp(a t[]);

-- onlyif config schema-locked-disabled

-- Test 27: query (line 99)
SELECT
  a.attname AS column_name,
  pg_catalog.format_type(a.atttypid, a.atttypmod) AS data_type
FROM pg_attribute AS a
JOIN pg_class AS c ON c.oid = a.attrelid
JOIN pg_namespace AS n ON n.oid = c.relnamespace
WHERE n.nspname = current_schema()
  AND c.relname = 'atyp'
  AND a.attnum > 0
  AND NOT a.attisdropped
ORDER BY a.attnum;

-- Test 28: query (line 109)
SELECT
  a.attname AS column_name,
  pg_catalog.format_type(a.atttypid, a.atttypmod) AS data_type
FROM pg_attribute AS a
JOIN pg_class AS c ON c.oid = a.attrelid
JOIN pg_namespace AS n ON n.oid = c.relnamespace
WHERE n.nspname = current_schema()
  AND c.relname = 'atyp'
  AND a.attnum > 0
  AND NOT a.attisdropped
ORDER BY a.attnum;

-- Test 29: statement (line 118)
INSERT INTO atyp VALUES (ARRAY[ROW(1, 2)::t, ROW(3, 4)::t, NULL::t, ROW(5, NULL)::t]);

-- Test 30: query (line 121)
SELECT * FROM atyp;

-- Test 31: statement (line 126)
DROP TABLE IF EXISTS atyp;

-- Test 32: statement (line 130)
DROP TYPE IF EXISTS t2;
CREATE TYPE t2 AS (t1 t, t2 t);

-- Test 33: statement (line 171)
DROP TABLE IF EXISTS tab;

-- Test 34: query (line 174)
SELECT
  current_database() AS database_name,
  n.nspname AS schema_name,
  t.typname AS descriptor_name,
  CASE
    WHEN t.typtype = 'c' AND c.relkind = 'c' THEN
      'CREATE TYPE '
        || quote_ident(n.nspname) || '.' || quote_ident(t.typname)
        || ' AS ('
        || (
          SELECT string_agg(
            quote_ident(a.attname) || ' ' || pg_catalog.format_type(a.atttypid, a.atttypmod),
            ', ' ORDER BY a.attnum
          )
          FROM pg_attribute AS a
          WHERE a.attrelid = c.oid AND a.attnum > 0 AND NOT a.attisdropped
        )
        || ')'
    WHEN t.typtype = 'e' THEN
      'CREATE TYPE '
        || quote_ident(n.nspname) || '.' || quote_ident(t.typname)
        || ' AS ENUM ('
        || (
          SELECT string_agg(quote_literal(e.enumlabel), ', ' ORDER BY e.enumsortorder)
          FROM pg_enum AS e
          WHERE e.enumtypid = t.oid
        )
        || ')'
    ELSE NULL
  END AS create_statement
FROM pg_type AS t
JOIN pg_namespace AS n ON n.oid = t.typnamespace
LEFT JOIN pg_class AS c ON c.oid = t.typrelid
WHERE n.nspname = 'public'
  AND t.typname IN ('t', 't2', 't_single')
ORDER BY schema_name, descriptor_name;

-- Test 35: statement (line 186)
DROP TYPE IF EXISTS t2;
DROP TYPE IF EXISTS t;
DROP TYPE IF EXISTS t_single;

-- Test 36: statement (line 190)
CREATE TYPE t AS ();

-- Test 37: statement (line 193)
DROP TYPE IF EXISTS t;

-- Test 38: statement (line 197)
CREATE TYPE e AS ENUM ('a', 'b', 'c');

-- Test 39: statement (line 201)
DROP TABLE IF EXISTS tab;
CREATE TABLE tab (a INT, b INT);

-- Test 40: statement (line 204)
DROP TYPE IF EXISTS t;
CREATE TYPE t AS (e e);

-- Test 41: statement (line 208)
DROP TYPE IF EXISTS t;
CREATE TYPE t AS (a tab);

-- Test 42: statement (line 211)
DROP TYPE IF EXISTS t;
CREATE TYPE t AS (a pg_catalog.pg_class);

-- Test 43: statement (line 214)
DROP TYPE IF EXISTS t;
DROP TYPE IF EXISTS e;

-- Test 44: statement (line 221)
CREATE TYPE t AS (a INT, b TEXT);

-- Test 45: statement (line 224)
DROP TABLE IF EXISTS a;
CREATE TABLE a (a INT DEFAULT (((1, 'hi')::t).a));

-- Test 46: statement (line 227)
-- Drop the type only after removing default dependencies.

-- skipif config local-legacy-schema-changer

-- Test 47: statement (line 231)
ALTER TABLE a ALTER COLUMN a SET DEFAULT 3;
DROP TYPE IF EXISTS t;

-- skipif config local-legacy-schema-changer

-- Test 48: statement (line 235)
DROP TYPE IF EXISTS t;

-- skipif config local-legacy-schema-changer

-- Test 49: statement (line 239)
CREATE TYPE t AS (a INT, b TEXT);

-- Test 50: statement (line 242)
DROP TABLE IF EXISTS a;
CREATE TABLE a (a INT);
CREATE OR REPLACE FUNCTION a_on_update_set_a() RETURNS trigger
LANGUAGE plpgsql AS $$
BEGIN
  NEW.a := (((1, 'hi')::t).a);
  RETURN NEW;
END
$$;
DROP TRIGGER IF EXISTS a_on_update ON a;
CREATE TRIGGER a_on_update
BEFORE UPDATE ON a
FOR EACH ROW
EXECUTE FUNCTION a_on_update_set_a();

-- Test 51: statement (line 246)
-- Drop the type only after removing trigger dependencies.

-- skipif config local-legacy-schema-changer

-- Test 52: statement (line 250)
CREATE OR REPLACE FUNCTION a_on_update_set_a() RETURNS trigger
LANGUAGE plpgsql AS $$
BEGIN
  NEW.a := 3;
  RETURN NEW;
END
$$;

-- skipif config local-legacy-schema-changer

-- Test 53: statement (line 254)
DROP TRIGGER IF EXISTS a_on_update ON a;
DROP FUNCTION IF EXISTS a_on_update_set_a();
DROP TYPE IF EXISTS t;

-- skipif config local-legacy-schema-changer

-- Test 54: statement (line 258)
CREATE TYPE t AS (a INT, b TEXT);

-- Test 55: statement (line 261)
DROP TABLE IF EXISTS a;

-- Test 56: statement (line 264)
CREATE TABLE a (a INT GENERATED ALWAYS AS (((1, 'hi')::t).a) STORED);

-- Test 57: statement (line 267)
-- Drop the type only after removing generated-column dependencies.

-- skipif config local-legacy-schema-changer

-- Test 58: statement (line 271)
ALTER TABLE a ALTER COLUMN a DROP EXPRESSION;
DROP TYPE IF EXISTS t;

-- skipif config local-legacy-schema-changer

-- Test 59: statement (line 275)
DROP TYPE IF EXISTS t;

-- skipif config local-legacy-schema-changer

-- Test 60: statement (line 279)
CREATE TYPE t AS (a INT, b TEXT);

-- Test 61: statement (line 282)
DROP TABLE IF EXISTS a;
CREATE TABLE a (a INT);
DROP INDEX IF EXISTS a_a_idx;
CREATE INDEX a_a_idx ON a (a) WHERE a > (((1, 'hi')::t).a);

-- Test 62: statement (line 286)
DROP INDEX IF EXISTS a_a_idx;
DROP TYPE IF EXISTS t;

-- Test 63: statement (line 289)
DROP TABLE IF EXISTS a;
DROP TYPE IF EXISTS t;
CREATE TYPE t AS (a INT, b TEXT);
CREATE TABLE a (a INT, CONSTRAINT check_a CHECK (a > (((1, 'hi')::t).a)));

-- Test 64: statement (line 295)
-- Drop constraint before dropping the type to avoid dependency errors.

-- Test 65: statement (line 298)
ALTER TABLE a DROP CONSTRAINT check_a;

-- Test 66: statement (line 301)
DROP TABLE IF EXISTS a;
DROP TYPE IF EXISTS t;

-- Test 67: statement (line 307)
DROP TYPE IF EXISTS ct1;
DROP TYPE IF EXISTS et1;
DROP SCHEMA IF EXISTS sc1 CASCADE;
CREATE TYPE ct1 AS (a INT, b TEXT);
CREATE TYPE et1 AS ENUM ('a', 'b', 'c');
CREATE SCHEMA IF NOT EXISTS sc1;
CREATE TYPE sc1.ct2 AS (x INT, y INT);
CREATE TYPE sc1.ct3 AS ();

-- Test 68: query (line 314)
SELECT
  current_database() AS database_name,
  n.nspname AS schema_name,
  t.typname AS type_name,
  t.typtype
FROM pg_type AS t
JOIN pg_namespace AS n ON n.oid = t.typnamespace
WHERE (n.nspname = 'public' AND t.typname IN ('ct1', 'et1'))
   OR (n.nspname = 'sc1' AND t.typname IN ('ct2', 'ct3'))
ORDER BY schema_name, type_name;

-- Test 69: statement (line 322)
DROP TYPE IF EXISTS sc1.ct3;
DROP TYPE IF EXISTS sc1.ct2;
DROP SCHEMA IF EXISTS sc1;
DROP TYPE IF EXISTS et1;
DROP TYPE IF EXISTS ct1;

-- Test 70: statement (line 329)
DROP DATABASE IF EXISTS "CaseSensitiveDatabase";
CREATE DATABASE "CaseSensitiveDatabase";
\c "CaseSensitiveDatabase"
SET client_min_messages = warning;
DROP TYPE IF EXISTS ct4;
DROP TYPE IF EXISTS et5;
CREATE TYPE ct4 AS (a INT, b TEXT);
CREATE TYPE et5 AS ENUM ('a', 'b', 'c');

-- Test 71: query (line 335)
SELECT
  current_database() AS database_name,
  n.nspname AS schema_name,
  t.typname AS type_name,
  t.typtype
FROM pg_type AS t
JOIN pg_namespace AS n ON n.oid = t.typnamespace
WHERE n.nspname = 'public' AND t.typname IN ('ct4', 'et5')
ORDER BY schema_name, type_name;

-- Test 72: statement (line 341)
-- Need to disconnect before dropping the database.
\c pg_tests
SET client_min_messages = warning;
DROP DATABASE IF EXISTS "CaseSensitiveDatabase";

RESET client_min_messages;
