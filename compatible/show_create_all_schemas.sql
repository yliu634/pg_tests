-- PostgreSQL compatible tests from show_create_all_schemas
-- 13 tests

SET client_min_messages = warning;

CREATE SCHEMA IF NOT EXISTS crdb_internal;

-- CockroachDB's SHOW CREATE ALL SCHEMAS is database-scoped. PostgreSQL does not
-- have nested schema namespaces per database, so we emulate a Cockroach
-- "database" as a schema group:
--   - <dbname>      (represents db.public)
--   - <dbname>__*   (represents db.<schema>)
CREATE OR REPLACE FUNCTION crdb_internal.show_create_all_schemas(dbname TEXT)
RETURNS SETOF TEXT
LANGUAGE plpgsql AS $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_namespace
    WHERE nspname = dbname OR nspname LIKE dbname || '__%'
  ) THEN
    RAISE EXCEPTION 'schema group \"%\" not found', dbname;
  END IF;

  RETURN QUERY
  WITH schemas AS (
    SELECT oid, nspname
    FROM pg_namespace
    WHERE nspname = dbname OR nspname LIKE dbname || '__%'
    ORDER BY nspname
  )
  SELECT stmt
  FROM (
    SELECT
      1 AS ord,
      nspname,
      'CREATE SCHEMA ' || quote_ident(nspname) || ';' AS stmt
    FROM schemas
    UNION ALL
    SELECT
      2 AS ord,
      nspname,
      'COMMENT ON SCHEMA ' || quote_ident(nspname) || ' IS ' ||
        quote_literal(obj_description(oid, 'pg_namespace')) || ';'
    FROM schemas
    WHERE obj_description(oid, 'pg_namespace') IS NOT NULL
  ) s
  ORDER BY ord, nspname;
END;
$$;

-- Test 1: statement (line 3)
DROP SCHEMA IF EXISTS d CASCADE;
DROP SCHEMA IF EXISTS d__test CASCADE;
DROP SCHEMA IF EXISTS d__test2 CASCADE;
CREATE SCHEMA d;

-- Test 2: statement (line 6)
SET search_path TO d, public;

-- Test 3: query (line 9)
SELECT crdb_internal.show_create_all_schemas('d');

-- Test 4: statement (line 15)
CREATE SCHEMA d__test;

-- Test 5: query (line 18)
SELECT crdb_internal.show_create_all_schemas('d');

-- Test 6: statement (line 25)
CREATE SCHEMA d__test2;

-- Test 7: query (line 28)
SELECT crdb_internal.show_create_all_schemas('d');

-- Test 8: statement (line 36)
DROP SCHEMA d__test;

-- Test 9: query (line 39)
SELECT crdb_internal.show_create_all_schemas('d');

-- Test 10: statement (line 46)
COMMENT ON SCHEMA d IS 'test comment';

-- Test 11: query (line 49)
SELECT crdb_internal.show_create_all_schemas('d');

-- Test 12: statement (line 58)
DROP SCHEMA IF EXISTS "d-d" CASCADE;
CREATE SCHEMA "d-d";
SELECT crdb_internal.show_create_all_schemas('d-d');

-- Test 13: statement (line 64)
DROP SCHEMA IF EXISTS "a""bc" CASCADE;
CREATE SCHEMA "a""bc";
SELECT crdb_internal.show_create_all_schemas('a"bc');

RESET client_min_messages;
