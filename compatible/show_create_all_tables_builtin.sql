-- PostgreSQL compatible tests from show_create_all_tables_builtin
-- 64 tests

SET client_min_messages = warning;

CREATE SCHEMA IF NOT EXISTS crdb_internal;

-- Best-effort Postgres equivalent: dump the requested "database" namespace
-- (a schema + any nested schemas named <db>__*), using pg_dump.
CREATE OR REPLACE FUNCTION crdb_internal.show_create_all_tables(dbname TEXT)
RETURNS SETOF TEXT
LANGUAGE plpgsql AS $$
DECLARE
  schema_rec RECORD;
  schema_args TEXT := '';
  cmd TEXT;
BEGIN
  FOR schema_rec IN
    SELECT nspname
    FROM pg_namespace
    WHERE nspname = dbname OR nspname LIKE dbname || '__%'
    ORDER BY nspname
  LOOP
    -- pg_dump schema selectors are patterns; always pass SQL-identifier-quoted
    -- names so special characters (like embedded double quotes) match.
    schema_args := schema_args || ' --schema=' || quote_literal(quote_ident(schema_rec.nspname));
  END LOOP;

  IF schema_args = '' THEN
    RAISE EXCEPTION 'schema group \"%\" not found', dbname;
  END IF;

  cmd :=
    'pg_dump -h /var/run/postgresql -U postgres' ||
    ' --schema-only --quote-all-identifiers' ||
    ' --no-owner --no-privileges' ||
    schema_args || ' ' || quote_literal(current_database());

  DROP TABLE IF EXISTS pg_temp._show_create_all_tables_out;
  CREATE TEMP TABLE pg_temp._show_create_all_tables_out(line TEXT);

  EXECUTE format('COPY pg_temp._show_create_all_tables_out FROM PROGRAM %L', cmd);

  RETURN QUERY SELECT line FROM pg_temp._show_create_all_tables_out;
END;
$$;

-- Test 1: statement (line 3)
\set ON_ERROR_STOP 0
SELECT crdb_internal.show_create_all_tables('d');
\set ON_ERROR_STOP 1

-- Test 2: statement (line 6)
DROP SCHEMA IF EXISTS d CASCADE;
CREATE SCHEMA d;
-- CockroachDB database-level privilege; schema is the closest mapping.
-- REVOKE USAGE ON SCHEMA d FROM PUBLIC;

-- Test 3: query (line 10)
SELECT crdb_internal.show_create_all_tables('d');

-- Test 4: statement (line 14)
CREATE TABLE d.parent (
    x INT,
    y INT,
    z INT,
    UNIQUE (x, y, z),
    UNIQUE (x)
);

-- Test 5: statement (line 24)
CREATE TABLE d.full_test (
    x INT,
    y INT,
    z INT,
    FOREIGN KEY (x, y, z) REFERENCES d.parent (x, y, z) MATCH FULL ON DELETE CASCADE ON UPDATE CASCADE,
    UNIQUE (x)
  );

-- Test 6: statement (line 34)
ALTER TABLE d.full_test ADD CONSTRAINT test_fk FOREIGN KEY (x) REFERENCES d.parent (x) ON DELETE CASCADE;

-- Test 7: statement (line 37)
CREATE VIEW d.vx AS SELECT 1;

-- Test 8: statement (line 40)
CREATE SEQUENCE d.s;

-- Test 9: query (line 47)
SELECT crdb_internal.show_create_all_tables('d');

-- Test 10: query (line 80)
SELECT crdb_internal.show_create_all_tables('d');

-- Test 11: query (line 115)
SELECT crdb_internal.show_create_all_tables('d');

-- Test 12: statement (line 121)
-- CockroachDB database-level privilege; schema is the closest mapping.
-- GRANT CREATE ON SCHEMA d TO testuser;

-- Test 13: query (line 129)
SELECT crdb_internal.show_create_all_tables('d');

-- Test 14: query (line 162)
SELECT crdb_internal.show_create_all_tables('d');

-- Test 15: statement (line 197)
DROP SCHEMA IF EXISTS temp_test CASCADE;
CREATE SCHEMA temp_test;

-- Test 16: statement (line 200)
SET search_path TO temp_test, public;

-- Test 17: statement (line 206)
CREATE TEMPORARY TABLE t();

-- Test 18: query (line 209)
SELECT crdb_internal.show_create_all_tables('temp_test');

-- Test 19: statement (line 213)
-- CockroachDB-only setting.
-- SET autocommit_before_ddl = false;

-- Test 20: statement (line 217)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
DROP SCHEMA IF EXISTS test_fk_order CASCADE;
CREATE SCHEMA test_fk_order;
SET search_path TO test_fk_order, public;
-- B -> A
CREATE TABLE b (i int PRIMARY KEY);

-- Test 21: statement (line 224)
CREATE TABLE a (i int REFERENCES b);

-- Test 22: statement (line 227)
INSERT INTO b VALUES (1);
INSERT INTO a VALUES (1);
-- Test multiple tables to make sure transitive deps are sorted correctly.
-- E -> D -> C
-- G -> F -> D -> C
CREATE TABLE g (i int PRIMARY KEY);
CREATE TABLE f (i int PRIMARY KEY, g int REFERENCES g);
CREATE TABLE e (i int PRIMARY KEY);
CREATE TABLE d (i int PRIMARY KEY, e int REFERENCES e, f int REFERENCES f);

-- Test 23: statement (line 238)
CREATE TABLE c (i int REFERENCES d);

-- Test 24: statement (line 241)
-- Test a table that uses a sequence to make sure the sequence is dumped first.
CREATE SEQUENCE s;
CREATE TABLE s_tbl (id INT PRIMARY KEY DEFAULT nextval('s'::regclass), v INT);
COMMIT;

-- Test 25: statement (line 247)
-- CockroachDB-only setting.
-- RESET autocommit_before_ddl;

-- Test 26: query (line 252)
SELECT crdb_internal.show_create_all_tables('test_fk_order');

-- Test 27: query (line 310)
SELECT crdb_internal.show_create_all_tables('test_fk_order');

-- Test 28: statement (line 368)
DROP SCHEMA IF EXISTS test_cycle CASCADE;
CREATE SCHEMA test_cycle;

-- Test 29: statement (line 371)
SET search_path TO test_cycle, public;

-- Test 30: statement (line 374)
CREATE TABLE loop_a (
  id INT PRIMARY KEY,
  b_id INT
);
CREATE INDEX loop_a_b_id_idx ON loop_a (b_id);

-- Test 31: statement (line 382)
CREATE TABLE loop_b (
  id INT PRIMARY KEY,
  a_id INT REFERENCES loop_a ON DELETE CASCADE
);

-- Test 32: statement (line 389)
ALTER TABLE loop_a ADD CONSTRAINT b_id_delete_constraint
FOREIGN KEY (b_id) REFERENCES loop_b (id) ON DELETE CASCADE;

-- skipif config schema-locked-disabled

-- Test 33: query (line 394)
SELECT crdb_internal.show_create_all_tables('test_cycle');

-- Test 34: query (line 417)
SELECT crdb_internal.show_create_all_tables('test_cycle');

-- Test 35: statement (line 440)
DROP SCHEMA IF EXISTS test_primary_key CASCADE;
CREATE SCHEMA test_primary_key;

-- Test 36: statement (line 443)
CREATE TABLE test_primary_key.t (
	i int,
	CONSTRAINT pk_name PRIMARY KEY (i)
);

-- skipif config schema-locked-disabled

-- Test 37: query (line 450)
SELECT crdb_internal.show_create_all_tables('test_primary_key');

-- Test 38: query (line 459)
SELECT crdb_internal.show_create_all_tables('test_primary_key');

-- Test 39: statement (line 468)
DROP SCHEMA IF EXISTS test_computed_column CASCADE;
CREATE SCHEMA test_computed_column;
CREATE TABLE test_computed_column.t (
	a INT PRIMARY KEY,
	b INT GENERATED ALWAYS AS (a + 1) STORED
);

-- skipif config schema-locked-disabled

-- Test 40: query (line 477)
SELECT crdb_internal.show_create_all_tables('test_computed_column');

-- Test 41: query (line 488)
SELECT crdb_internal.show_create_all_tables('test_computed_column');

-- Test 42: statement (line 500)
DROP SCHEMA IF EXISTS test_escaping CASCADE;
CREATE SCHEMA test_escaping;

-- Test 43: statement (line 503)
CREATE TABLE test_escaping.";" (";" int);
CREATE INDEX ON test_escaping.";" (";");

-- Test 44: statement (line 506)
INSERT INTO test_escaping.";" VALUES (1);

-- skipif config schema-locked-disabled

-- Test 45: query (line 510)
SELECT crdb_internal.show_create_all_tables('test_escaping');

-- Test 46: query (line 521)
SELECT crdb_internal.show_create_all_tables('test_escaping');

-- Test 47: statement (line 533)
DROP SCHEMA IF EXISTS test_comment CASCADE;
CREATE SCHEMA test_comment;
CREATE TABLE test_comment."t   t" ("x'" INT PRIMARY KEY);
COMMENT ON TABLE test_comment."t   t" IS 'has '' quotes';
COMMENT ON INDEX test_comment."t   t_pkey" IS 'has '' more '' quotes';
COMMENT ON COLUMN test_comment."t   t"."x'" IS 'i '' just '' love '' quotes';

-- skipif config schema-locked-disabled

-- Test 48: query (line 541)
SELECT crdb_internal.show_create_all_tables('test_comment');

-- Test 49: query (line 553)
SELECT crdb_internal.show_create_all_tables('test_comment');

-- Test 50: statement (line 565)
DROP SCHEMA IF EXISTS test_schema CASCADE;
DROP SCHEMA IF EXISTS test_schema__sc1 CASCADE;
DROP SCHEMA IF EXISTS test_schema__sc2 CASCADE;
CREATE SCHEMA test_schema;
CREATE SCHEMA test_schema__sc1;
CREATE SCHEMA test_schema__sc2;

-- Test 51: statement (line 571)
CREATE TABLE test_schema__sc1.t (x int);

-- Test 52: statement (line 574)
CREATE TABLE test_schema__sc2.t (x int);

-- skipif config schema-locked-disabled

-- Test 53: query (line 578)
SELECT crdb_internal.show_create_all_tables('test_schema');

-- Test 54: query (line 593)
SELECT crdb_internal.show_create_all_tables('test_schema');

-- Test 55: statement (line 608)
DROP SCHEMA IF EXISTS test_sequence CASCADE;
CREATE SCHEMA test_sequence;
SET search_path TO test_sequence, public;
CREATE SEQUENCE s1 INCREMENT BY 123;

-- Test 56: query (line 613)
SELECT crdb_internal.show_create_all_tables('test_sequence');

-- Test 57: statement (line 620)
-- USE test_schema;

-- skipif config schema-locked-disabled

-- Test 58: query (line 624)
BEGIN;
SELECT crdb_internal.show_create_all_tables('test_schema');

-- Test 59: query (line 640)
-- already in a transaction block
SELECT crdb_internal.show_create_all_tables('test_schema');

-- Test 60: query (line 656)
COMMIT;
BEGIN;
SELECT * FROM test_schema__sc1.t;
SELECT crdb_internal.show_create_all_tables('test_schema');

-- Test 61: query (line 674)
COMMIT;
BEGIN;
SELECT * FROM test_schema__sc1.t;
SELECT crdb_internal.show_create_all_tables('test_schema');

-- Test 62: statement (line 691)
COMMIT;

-- Test 63: statement (line 710)
DROP SCHEMA IF EXISTS "d-d" CASCADE;
CREATE SCHEMA "d-d";
SET search_path TO "d-d", public;
CREATE TABLE t();
SELECT crdb_internal.show_create_all_tables('d-d');

-- Test 64: statement (line 717)
DROP SCHEMA IF EXISTS "a""bc" CASCADE;
CREATE SCHEMA "a""bc";
SET search_path TO "a""bc", public;
CREATE TABLE t();
SELECT crdb_internal.show_create_all_tables('a"bc');
