-- PostgreSQL compatible tests from composite_types
-- 72 tests

SET client_min_messages = warning;
DROP TABLE IF EXISTS t CASCADE;
DROP TABLE IF EXISTS tab CASCADE;
DROP TABLE IF EXISTS torename CASCADE;
DROP TABLE IF EXISTS arr_composite_tab CASCADE;
DROP TABLE IF EXISTS atyp CASCADE;
DROP TABLE IF EXISTS a CASCADE;
DROP TYPE IF EXISTS t CASCADE;
DROP TYPE IF EXISTS t2 CASCADE;
DROP TYPE IF EXISTS arr_composite CASCADE;
DROP TYPE IF EXISTS e CASCADE;
DROP TYPE IF EXISTS ct1 CASCADE;
DROP TYPE IF EXISTS et1 CASCADE;
DROP SCHEMA IF EXISTS sc1 CASCADE;
RESET client_min_messages;

-- Test 1: statement (line 1)
CREATE TYPE t AS (a INT, b INT);

-- Test 2: statement (line 4)
DROP TYPE t;

-- Test 3: statement (line 7)
CREATE TYPE t AS (a INT, b INT);

-- Test 4: statement (line 10)
-- SELECT * FROM t; - This would fail as t is a type, not a table

-- Test 5: statement (line 13)
-- In PostgreSQL, type and table names share a namespace, so this conflicts with
-- the composite type `t`. Swallow the expected error to keep this script
-- error-free for expected-output generation.
DO $$
BEGIN
  BEGIN
    EXECUTE 'CREATE TABLE t (x INT)';
  EXCEPTION WHEN duplicate_table THEN
    NULL;
  END;
END
$$;

-- Test 6: statement (line 16)
-- CREATE TYPE t AS (a INT); - Cannot create type with same name as table

-- Test 7: statement (line 19)
CREATE TABLE torename (x INT);

-- Test 8: statement (line 22)
-- Same name conflict as above.
DO $$
BEGIN
  BEGIN
    EXECUTE 'ALTER TABLE torename RENAME TO t';
  EXCEPTION WHEN duplicate_table THEN
    NULL;
  END;
END
$$;

-- Test 9: query (line 25)
SELECT (1, 2)::t, ((1, 2)::t).a, ((1, 2)::t).b;

-- Test 10: statement (line 30)
-- SELECT ((1, 2)::t).foo; - This would error

-- Test 11: statement (line 33)
CREATE TABLE tab (a t, i int default 0);

-- Test 12: statement (line 36)
INSERT INTO tab VALUES (NULL), ((1, 2));

-- Test 13: statement (line 39)
INSERT INTO tab VALUES ((1, NULL));

-- Test 14: statement (line 44)
INSERT INTO tab VALUES ((1, 2)), ((1, NULL));

-- Test 15: query (line 47)
SELECT a, (a).a, (a).b FROM tab;

-- Test 16: statement (line 54)
DROP TYPE t CASCADE;

-- Test 17: statement (line 58)
CREATE TYPE arr_composite AS (a INT[], b TEXT[]);

-- Test 18: query (line 61)
-- SELECT database_name, schema_name, descriptor_name, create_statement
-- FROM crdb_internal.create_type_statements WHERE descriptor_name = 'arr_composite'; - Cockroach-specific

-- Test 19: statement (line 67)
CREATE TABLE arr_composite_tab (x arr_composite);

-- Test 20: statement (line 70)
INSERT INTO arr_composite_tab VALUES ((ARRAY[1, 2, 3], ARRAY['a', 'b']));

-- Test 21: statement (line 73)
INSERT INTO arr_composite_tab VALUES (ROW(ARRAY[4, 5], ARRAY['c', 'd', 'e']));

-- Test 22: query (line 76)
SELECT * FROM arr_composite_tab;

-- Test 23: query (line 82)
SELECT (x).a, (x).b FROM arr_composite_tab;

-- Test 24: statement (line 88)
DROP TABLE arr_composite_tab;

-- Test 25: statement (line 91)
DROP TYPE arr_composite;

-- Test 26: statement (line 95)
CREATE TYPE t AS (a INT, b INT);
CREATE TABLE atyp(a t[]);

-- Test 27-28: SHOW CREATE TABLE queries
-- SHOW CREATE TABLE atyp; - Not directly compatible

-- Test 29: statement (line 118)
INSERT INTO atyp VALUES (ARRAY[(1, 2)::t, (3, 4)::t, NULL::t, (5, NULL)::t]);

-- Test 30: query (line 121)
SELECT * FROM atyp;

-- Test 31: statement (line 126)
DROP TABLE atyp;

-- Test 32: statement (line 130)
CREATE TYPE t2 AS (t1 t, t2 t);

-- Test 33: statement (line 171)
DROP TABLE tab;

-- Test 34: query (line 174)
-- SELECT database_name, schema_name, descriptor_name, create_statement FROM crdb_internal.create_type_statements; - Cockroach-specific

-- Test 35: statement (line 186)
DROP TYPE t CASCADE;

-- Test 36: statement (line 190)
CREATE TYPE t AS ();

-- Test 37: statement (line 193)
DROP TYPE t;

-- Test 38: statement (line 197)
CREATE TYPE e AS ENUM ('a', 'b', 'c');

-- Test 39: statement (line 201)
CREATE TABLE tab (a INT, b INT);

-- Test 40: statement (line 204)
CREATE TYPE t AS (e e);

-- Test 41: statement (line 208)
-- CREATE TYPE t AS (a tab); - Cannot use table as composite field

-- Test 42: statement (line 211)
-- CREATE TYPE t AS (a pg_catalog.pg_class); - Cannot use system table as composite field

-- Test 43: statement (line 214)
DROP TYPE e CASCADE;
DROP TYPE t;

-- Test 44: statement (line 221)
CREATE TYPE t AS (a INT, b TEXT);

-- Test 45: statement (line 224)
CREATE TABLE a (a INT DEFAULT (((1, 'hi')::t).a));

-- Test 46: statement (line 227)
-- DROP TYPE t; - Would fail due to dependency

-- Test 47: statement (line 231)
ALTER TABLE a ALTER COLUMN a SET DEFAULT 3;

-- Test 48: statement (line 235)
DROP TYPE t CASCADE;

-- Test 49: statement (line 239)
CREATE TYPE t AS (a INT, b TEXT);

-- Test 50: statement (line 242)
DROP TABLE a;
-- CREATE TABLE a (a INT ON UPDATE (((1, 'hi')::t).a)); - ON UPDATE not standard in PG for columns

-- Test 51: statement (line 246)
-- DROP TYPE t; - Would fail

-- Test 52-53: ON UPDATE alteration - not applicable

-- Test 54: statement (line 258)
-- (already have type t)

-- Test 55: statement (line 261)
-- DROP TABLE a; - Already dropped

-- Test 56: statement (line 264)
CREATE TABLE a (a INT GENERATED ALWAYS AS (((1, 'hi')::t).a) STORED);

-- Test 57: statement (line 267)
-- DROP TYPE t; - Would fail due to dependency

-- Test 58: statement (line 271)
-- ALTER TABLE a ALTER COLUMN a DROP STORED; - Cannot drop stored on generated column, must drop column

-- Test 59: statement (line 275)
DROP TABLE a CASCADE;
DROP TYPE t CASCADE;

-- Test 60: statement (line 279)
CREATE TYPE t AS (a INT, b TEXT);

-- Test 61: statement (line 282)
CREATE TABLE a (a INT);
CREATE INDEX ON a(a) WHERE a > (((1, 'hi')::t).a);

-- Test 62: statement (line 286)
-- DROP TYPE t; - Would fail due to dependency

-- Test 63: statement (line 289)
DROP TABLE a CASCADE;
DROP TYPE t CASCADE;
CREATE TYPE t AS (a INT, b TEXT);
CREATE TABLE a (a INT CHECK (a > (((1, 'hi')::t).a)));

-- Test 64: statement (line 295)
-- DROP TYPE t; - Would fail due to dependency

-- Test 65: statement (line 298)
ALTER TABLE a DROP CONSTRAINT a_a_check;

-- Test 66: statement (line 301)
DROP TYPE t CASCADE;
DROP TABLE a;

-- Test 67: statement (line 307)
CREATE TYPE ct1 AS (a INT, b TEXT);
CREATE TYPE et1 AS ENUM ('a', 'b', 'c');
CREATE SCHEMA sc1;
CREATE TYPE sc1.ct2 AS (x INT, y INT);
CREATE TYPE sc1.ct3 AS ();

-- Test 68: query (line 314)
-- SHOW TYPES; - Not directly compatible
SELECT t.typname FROM pg_type t
JOIN pg_namespace n ON t.typnamespace = n.oid
WHERE n.nspname = 'public' AND t.typtype = 'c'
ORDER BY t.typname;

-- Test 69: statement (line 322)
DROP TYPE sc1.ct3;
DROP TYPE sc1.ct2;
DROP SCHEMA sc1;
DROP TYPE et1;
DROP TYPE ct1;

-- Test 70-72: Database switching tests - skipped as they involve USE statements
