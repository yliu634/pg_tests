-- PostgreSQL compatible tests from show_create_all_tables
-- 55 tests

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
DROP SCHEMA IF EXISTS d CASCADE;
CREATE SCHEMA d;

-- Test 2: statement (line 6)
-- CockroachDB-only setting.
-- SET create_table_with_schema_locked=false;

-- Test 3: statement (line 9)
SET search_path TO d, public;

-- Test 4: query (line 12)
SELECT crdb_internal.show_create_all_tables('d');

-- Test 5: statement (line 17)
CREATE TABLE d.parent (
    x INT,
    y INT,
    z INT,
    UNIQUE (x, y, z),
    UNIQUE (x)
);

-- Test 6: statement (line 27)
CREATE TABLE d.full_test (
    x INT,
    y INT,
    z INT,
    FOREIGN KEY (x, y, z) REFERENCES d.parent (x, y, z) MATCH FULL ON DELETE CASCADE ON UPDATE CASCADE,
    UNIQUE (x)
  );

-- Test 7: statement (line 37)
ALTER TABLE d.full_test ADD CONSTRAINT test_fk FOREIGN KEY (x) REFERENCES d.parent (x) ON DELETE CASCADE;

-- Test 8: statement (line 40)
CREATE VIEW d.vx AS SELECT 1;

-- Test 9: statement (line 43)
CREATE SEQUENCE d.s;

-- Test 10: query (line 49)
SELECT crdb_internal.show_create_all_tables('d');

-- Test 11: query (line 85)
SELECT crdb_internal.show_create_all_tables('d');

-- Test 12: statement (line 92)
-- CockroachDB database-level privilege; schema is the closest mapping.
-- GRANT CREATE ON SCHEMA d TO testuser;

-- Test 13: query (line 99)
SELECT crdb_internal.show_create_all_tables('d');

-- Test 14: statement (line 135)
DROP SCHEMA IF EXISTS temp_test CASCADE;
CREATE SCHEMA temp_test;

-- Test 15: statement (line 138)
SET search_path TO temp_test, public;

-- Test 16: statement (line 144)
CREATE TEMPORARY TABLE t();

-- Test 17: query (line 147)
SELECT crdb_internal.show_create_all_tables('temp_test');

-- Test 18: statement (line 152)
-- CockroachDB-only setting.
-- SET autocommit_before_ddl = false;

-- Test 19: statement (line 156)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
DROP SCHEMA IF EXISTS test_fk_order CASCADE;
CREATE SCHEMA test_fk_order;
SET search_path TO test_fk_order, public;
-- B -> A
CREATE TABLE b (i int PRIMARY KEY);

-- Test 20: statement (line 163)
CREATE TABLE a (i int REFERENCES b);

-- Test 21: statement (line 166)
INSERT INTO b VALUES (1);
INSERT INTO a VALUES (1);
-- Test multiple tables to make sure transitive deps are sorted correctly.
-- E -> D -> C
-- G -> F -> D -> C
CREATE TABLE g (i int PRIMARY KEY);
CREATE TABLE f (i int PRIMARY KEY, g int REFERENCES g);
CREATE TABLE e (i int PRIMARY KEY);
CREATE TABLE d (i int PRIMARY KEY, e int REFERENCES e, f int REFERENCES f);

-- Test 22: statement (line 177)
CREATE TABLE c (i int REFERENCES d);

-- Test 23: statement (line 180)
-- Test a table that uses a sequence to make sure the sequence is dumped first.
CREATE SEQUENCE s;
CREATE TABLE s_tbl (id INT PRIMARY KEY DEFAULT nextval('s'::regclass), v INT);
COMMIT;

-- Test 24: statement (line 186)
-- CockroachDB-only setting.
-- RESET autocommit_before_ddl;

-- Test 25: query (line 190)
SELECT crdb_internal.show_create_all_tables('test_fk_order');

-- Test 26: statement (line 249)
DROP SCHEMA IF EXISTS test_cycle CASCADE;
CREATE SCHEMA test_cycle;

-- Test 27: statement (line 252)
SET search_path TO test_cycle, public;

-- Test 28: statement (line 255)
CREATE TABLE loop_a (
  id INT PRIMARY KEY,
  b_id INT
);
CREATE INDEX loop_a_b_id_idx ON loop_a (b_id);

-- Test 29: statement (line 263)
CREATE TABLE loop_b (
  id INT PRIMARY KEY,
  a_id INT REFERENCES loop_a ON DELETE CASCADE
);

-- Test 30: statement (line 270)
ALTER TABLE loop_a ADD CONSTRAINT b_id_delete_constraint
FOREIGN KEY (b_id) REFERENCES loop_b (id) ON DELETE CASCADE;

-- Test 31: query (line 274)
SELECT crdb_internal.show_create_all_tables('test_cycle');

-- Test 32: statement (line 298)
DROP SCHEMA IF EXISTS test_primary_key CASCADE;
CREATE SCHEMA test_primary_key;

-- Test 33: statement (line 301)
SET search_path TO test_primary_key, public;

-- Test 34: statement (line 304)
CREATE TABLE test_primary_key.t (
	i int,
	CONSTRAINT pk_name PRIMARY KEY (i)
);

-- Test 35: query (line 310)
SELECT crdb_internal.show_create_all_tables('test_primary_key');

-- Test 36: statement (line 320)
DROP SCHEMA IF EXISTS test_computed_column CASCADE;
CREATE SCHEMA test_computed_column;
SET search_path TO test_computed_column, public;
CREATE TABLE test_computed_column.t (
	a INT PRIMARY KEY,
	b INT GENERATED ALWAYS AS (a + 1) STORED
);

-- Test 37: query (line 329)
SELECT crdb_internal.show_create_all_tables('test_computed_column');

-- Test 38: statement (line 342)
DROP SCHEMA IF EXISTS test_escaping CASCADE;
CREATE SCHEMA test_escaping;
SET search_path TO test_escaping, public;

-- Test 39: statement (line 346)
CREATE TABLE test_escaping.";" (";" int);
CREATE INDEX ON test_escaping.";" (";");

-- Test 40: statement (line 349)
INSERT INTO test_escaping.";" VALUES (1);

-- Test 41: query (line 352)
SELECT crdb_internal.show_create_all_tables('test_escaping');

-- Test 42: statement (line 365)
DROP SCHEMA IF EXISTS test_comment CASCADE;
CREATE SCHEMA test_comment;
SET search_path TO test_comment, public;
CREATE TABLE test_comment."t   t" ("x'" INT PRIMARY KEY);
COMMENT ON TABLE test_comment."t   t" IS 'has '' quotes';
COMMENT ON INDEX test_comment."t   t_pkey" IS 'has '' more '' quotes';
COMMENT ON COLUMN test_comment."t   t"."x'" IS 'i '' just '' love '' quotes';
COMMENT ON CONSTRAINT "t   t_pkey" ON test_comment."t   t" IS 'new constraint comment';

-- Test 43: query (line 375)
SELECT crdb_internal.show_create_all_tables('test_comment');

-- Test 44: statement (line 389)
DROP SCHEMA IF EXISTS test_schema CASCADE;
DROP SCHEMA IF EXISTS test_schema__sc1 CASCADE;
DROP SCHEMA IF EXISTS test_schema__sc2 CASCADE;
CREATE SCHEMA test_schema;
CREATE SCHEMA test_schema__sc1;
CREATE SCHEMA test_schema__sc2;

-- Test 45: statement (line 395)
CREATE TABLE test_schema__sc1.t (x int);

-- Test 46: statement (line 398)
CREATE TABLE test_schema__sc2.t (x int);

-- Test 47: query (line 401)
SELECT crdb_internal.show_create_all_tables('test_schema');

-- Test 48: statement (line 417)
DROP SCHEMA IF EXISTS test_sequence CASCADE;
CREATE SCHEMA test_sequence;
SET search_path TO test_sequence, public;
CREATE SEQUENCE s1 INCREMENT BY 123;

-- Test 49: query (line 422)
SELECT crdb_internal.show_create_all_tables('test_sequence');

-- Test 50: statement (line 429)
DROP SCHEMA IF EXISTS type_test CASCADE;
CREATE SCHEMA type_test;
SET search_path TO type_test, public;
CREATE TYPE test AS ENUM ('a');

-- Test 51: statement (line 434)
CREATE TABLE t(x test);

-- Test 52: query (line 437)
SELECT crdb_internal.show_create_all_tables('type_test');

-- Test 53: query (line 453)
SELECT crdb_internal.show_create_all_tables('type_test');

-- Test 54: statement (line 470)
DROP SCHEMA IF EXISTS "d-d" CASCADE;
CREATE SCHEMA "d-d";
SET search_path TO "d-d", public;
CREATE TABLE t();
SELECT crdb_internal.show_create_all_tables('d-d');

-- Test 55: statement (line 477)
DROP SCHEMA IF EXISTS "a""bc" CASCADE;
CREATE SCHEMA "a""bc";
SET search_path TO "a""bc", public;
CREATE TABLE t();
SELECT crdb_internal.show_create_all_tables('a"bc');

RESET client_min_messages;
