-- PostgreSQL compatible tests from show_create_all_tables_builtin
-- 64 tests

-- Test 1: statement (line 3)
SELECT crdb_internal.show_create_all_tables('d')

-- Test 2: statement (line 6)
CREATE DATABASE d;
REVOKE CONNECT ON DATABASE d FROM public

-- Test 3: query (line 10)
SELECT crdb_internal.show_create_all_tables('d')

-- Test 4: statement (line 14)
CREATE TABLE d.parent (
    x INT,
    y INT,
    z INT,
    UNIQUE (x, y, z),
    FAMILY f1 (x, y, z),
    UNIQUE (x)
);

-- Test 5: statement (line 24)
CREATE TABLE d.full_test (
    x INT,
    y INT,
    z INT,
    FOREIGN KEY (x, y, z) REFERENCES d.parent (x, y, z) MATCH FULL ON DELETE CASCADE ON UPDATE CASCADE,
    FAMILY f1 (x, y, z),
    UNIQUE (x)
  );

-- Test 6: statement (line 34)
ALTER TABLE d.full_test ADD CONSTRAINT test_fk FOREIGN KEY (x) REFERENCES d.parent (x) ON DELETE CASCADE

-- Test 7: statement (line 37)
CREATE VIEW d.vx AS SELECT 1

-- Test 8: statement (line 40)
CREATE SEQUENCE d.s

-- Test 9: query (line 47)
SELECT crdb_internal.show_create_all_tables('d')

-- Test 10: query (line 80)
SELECT crdb_internal.show_create_all_tables('d')

-- Test 11: query (line 115)
SELECT crdb_internal.show_create_all_tables('d')

-- Test 12: statement (line 121)
GRANT CREATE on DATABASE d TO testuser

-- Test 13: query (line 129)
SELECT crdb_internal.show_create_all_tables('d')

-- Test 14: query (line 162)
SELECT crdb_internal.show_create_all_tables('d')

-- Test 15: statement (line 197)
CREATE DATABASE temp_test

-- Test 16: statement (line 200)
USE temp_test

-- Test 17: statement (line 206)
CREATE TEMPORARY TABLE t()

-- Test 18: query (line 209)
SELECT crdb_internal.show_create_all_tables('temp_test')

-- Test 19: statement (line 213)
SET autocommit_before_ddl = false

-- Test 20: statement (line 217)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
CREATE DATABASE test_fk_order;
USE test_fk_order;
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
CREATE TABLE f (i int PRIMARY KEY, g int REFERENCES g, FAMILY f1 (i, g));
CREATE TABLE e (i int PRIMARY KEY);
CREATE TABLE d (i int PRIMARY KEY, e int REFERENCES e, f int REFERENCES f, FAMILY f1 (i, e, f));

-- Test 23: statement (line 238)
CREATE TABLE c (i int REFERENCES d);

-- Test 24: statement (line 241)
-- Test a table that uses a sequence to make sure the sequence is dumped first.
CREATE SEQUENCE s;
CREATE TABLE s_tbl (id INT PRIMARY KEY DEFAULT nextval('s'), v INT,  FAMILY f1 (id, v));
COMMIT;

-- Test 25: statement (line 247)
RESET autocommit_before_ddl

-- Test 26: query (line 252)
SELECT crdb_internal.show_create_all_tables('test_fk_order')

-- Test 27: query (line 310)
SELECT crdb_internal.show_create_all_tables('test_fk_order')

-- Test 28: statement (line 368)
CREATE DATABASE test_cycle;

-- Test 29: statement (line 371)
USE test_cycle;

-- Test 30: statement (line 374)
CREATE TABLE loop_a (
  id INT PRIMARY KEY,
  b_id INT,
  INDEX(b_id),
  FAMILY f1 (id, b_id)
);

-- Test 31: statement (line 382)
CREATE TABLE loop_b (
  id INT PRIMARY KEY,
  a_id INT REFERENCES loop_a ON DELETE CASCADE,
  FAMILY f1 (id, a_id)
);

-- Test 32: statement (line 389)
ALTER TABLE loop_a ADD CONSTRAINT b_id_delete_constraint
FOREIGN KEY (b_id) REFERENCES loop_b (id) ON DELETE CASCADE;

skipif config schema-locked-disabled

-- Test 33: query (line 394)
SELECT crdb_internal.show_create_all_tables('test_cycle')

-- Test 34: query (line 417)
SELECT crdb_internal.show_create_all_tables('test_cycle')

-- Test 35: statement (line 440)
CREATE DATABASE test_primary_key;

-- Test 36: statement (line 443)
CREATE TABLE test_primary_key.t (
	i int,
	CONSTRAINT pk_name PRIMARY KEY (i)
);

skipif config schema-locked-disabled

-- Test 37: query (line 450)
SELECT crdb_internal.show_create_all_tables('test_primary_key')

-- Test 38: query (line 459)
SELECT crdb_internal.show_create_all_tables('test_primary_key')

-- Test 39: statement (line 468)
CREATE DATABASE test_computed_column;
CREATE TABLE test_computed_column.t (
	a INT PRIMARY KEY,
	b INT AS (a + 1) STORED,
	FAMILY f1 (a, b)
);

skipif config schema-locked-disabled

-- Test 40: query (line 477)
SELECT crdb_internal.show_create_all_tables('test_computed_column')

-- Test 41: query (line 488)
SELECT crdb_internal.show_create_all_tables('test_computed_column')

-- Test 42: statement (line 500)
CREATE DATABASE test_escaping;

-- Test 43: statement (line 503)
CREATE TABLE test_escaping.";" (";" int, index (";"));

-- Test 44: statement (line 506)
INSERT INTO test_escaping.";" VALUES (1);

skipif config schema-locked-disabled

-- Test 45: query (line 510)
SELECT crdb_internal.show_create_all_tables('test_escaping')

-- Test 46: query (line 521)
SELECT crdb_internal.show_create_all_tables('test_escaping')

-- Test 47: statement (line 533)
CREATE DATABASE test_comment;
CREATE TABLE test_comment."t   t" ("x'" INT PRIMARY KEY);
COMMENT ON TABLE test_comment."t   t" IS 'has '' quotes';
COMMENT ON INDEX test_comment."t   t"@"t   t_pkey" IS 'has '' more '' quotes';
COMMENT ON COLUMN test_comment."t   t"."x'" IS 'i '' just '' love '' quotes';

skipif config schema-locked-disabled

-- Test 48: query (line 541)
SELECT crdb_internal.show_create_all_tables('test_comment')

-- Test 49: query (line 553)
SELECT crdb_internal.show_create_all_tables('test_comment')

-- Test 50: statement (line 565)
CREATE DATABASE test_schema;
USE test_schema;
CREATE SCHEMA sc1;
CREATE SCHEMA sc2;

-- Test 51: statement (line 571)
CREATE TABLE sc1.t (x int);

-- Test 52: statement (line 574)
CREATE TABLE sc2.t (x int);

skipif config schema-locked-disabled

-- Test 53: query (line 578)
SELECT crdb_internal.show_create_all_tables('test_schema')

-- Test 54: query (line 593)
SELECT crdb_internal.show_create_all_tables('test_schema')

-- Test 55: statement (line 608)
CREATE DATABASE test_sequence;
USE test_sequence;
CREATE SEQUENCE s1 INCREMENT 123;

-- Test 56: query (line 613)
SELECT crdb_internal.show_create_all_tables('test_sequence')

-- Test 57: statement (line 620)
USE test_schema;

skipif config schema-locked-disabled

-- Test 58: query (line 624)
BEGIN;
SELECT crdb_internal.show_create_all_tables('test_schema');

-- Test 59: query (line 640)
BEGIN;
SELECT crdb_internal.show_create_all_tables('test_schema');

-- Test 60: query (line 656)
COMMIT;
BEGIN;
SELECT * FROM sc1.t;
SELECT crdb_internal.show_create_all_tables('test_schema');

-- Test 61: query (line 674)
COMMIT;
BEGIN;
SELECT * FROM sc1.t;
SELECT crdb_internal.show_create_all_tables('test_schema');

-- Test 62: statement (line 691)
COMMIT

-- Test 63: statement (line 710)
CREATE DATABASE "d-d";
USE "d-d";
CREATE TABLE t();
SELECT crdb_internal.show_create_all_tables('d-d');

-- Test 64: statement (line 717)
CREATE DATABASE "a""bc";
USE "a""bc";
CREATE TABLE t();
SELECT crdb_internal.show_create_all_tables('a"bc');

