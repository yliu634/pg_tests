-- PostgreSQL compatible tests from show_create_all_tables
-- 55 tests

-- Test 1: statement (line 3)
CREATE DATABASE d

-- Test 2: statement (line 6)
SET create_table_with_schema_locked=false

-- Test 3: statement (line 9)
USE d

-- Test 4: query (line 12)
SHOW CREATE ALL TABLES

-- Test 5: statement (line 17)
CREATE TABLE d.parent (
    x INT,
    y INT,
    z INT,
    UNIQUE (x, y, z),
    FAMILY f1 (x, y, z),
    UNIQUE (x)
);

-- Test 6: statement (line 27)
CREATE TABLE d.full_test (
    x INT,
    y INT,
    z INT,
    FOREIGN KEY (x, y, z) REFERENCES d.parent (x, y, z) MATCH FULL ON DELETE CASCADE ON UPDATE CASCADE,
    FAMILY f1 (x, y, z),
    UNIQUE (x)
  );

-- Test 7: statement (line 37)
ALTER TABLE d.full_test ADD CONSTRAINT test_fk FOREIGN KEY (x) REFERENCES d.parent (x) ON DELETE CASCADE

-- Test 8: statement (line 40)
CREATE VIEW d.vx AS SELECT 1

-- Test 9: statement (line 43)
CREATE SEQUENCE d.s

-- Test 10: query (line 49)
SHOW CREATE ALL TABLES

-- Test 11: query (line 85)
SHOW CREATE ALL TABLES

-- Test 12: statement (line 92)
GRANT CREATE on DATABASE d TO testuser

-- Test 13: query (line 99)
SHOW CREATE ALL TABLES

-- Test 14: statement (line 135)
CREATE DATABASE temp_test

-- Test 15: statement (line 138)
USE temp_test

-- Test 16: statement (line 144)
CREATE TEMPORARY TABLE t()

-- Test 17: query (line 147)
SHOW CREATE ALL TABLES

-- Test 18: statement (line 152)
SET autocommit_before_ddl = false

-- Test 19: statement (line 156)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
CREATE DATABASE test_fk_order;
USE test_fk_order;
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
CREATE TABLE f (i int PRIMARY KEY, g int REFERENCES g, FAMILY f1 (i, g));
CREATE TABLE e (i int PRIMARY KEY);
CREATE TABLE d (i int PRIMARY KEY, e int REFERENCES e, f int REFERENCES f, FAMILY f1 (i, e, f));

-- Test 22: statement (line 177)
CREATE TABLE c (i int REFERENCES d);

-- Test 23: statement (line 180)
-- Test a table that uses a sequence to make sure the sequence is dumped first.
CREATE SEQUENCE s;
CREATE TABLE s_tbl (id INT PRIMARY KEY DEFAULT nextval('s'), v INT,  FAMILY f1 (id, v));
COMMIT;

-- Test 24: statement (line 186)
RESET autocommit_before_ddl

-- Test 25: query (line 190)
SHOW CREATE ALL TABLES

-- Test 26: statement (line 249)
CREATE DATABASE test_cycle;

-- Test 27: statement (line 252)
USE test_cycle;

-- Test 28: statement (line 255)
CREATE TABLE loop_a (
  id INT PRIMARY KEY,
  b_id INT,
  INDEX(b_id),
  FAMILY f1 (id, b_id)
);

-- Test 29: statement (line 263)
CREATE TABLE loop_b (
  id INT PRIMARY KEY,
  a_id INT REFERENCES loop_a ON DELETE CASCADE,
  FAMILY f1 (id, a_id)
);

-- Test 30: statement (line 270)
ALTER TABLE loop_a ADD CONSTRAINT b_id_delete_constraint
FOREIGN KEY (b_id) REFERENCES loop_b (id) ON DELETE CASCADE;

-- Test 31: query (line 274)
SHOW CREATE ALL TABLES

-- Test 32: statement (line 298)
CREATE DATABASE test_primary_key;

-- Test 33: statement (line 301)
USE test_primary_key;

-- Test 34: statement (line 304)
CREATE TABLE test_primary_key.t (
	i int,
	CONSTRAINT pk_name PRIMARY KEY (i)
);

-- Test 35: query (line 310)
SHOW CREATE ALL TABLES

-- Test 36: statement (line 320)
CREATE DATABASE test_computed_column;
USE test_computed_column;
CREATE TABLE test_computed_column.t (
	a INT PRIMARY KEY,
	b INT AS (a + 1) STORED,
	FAMILY f1 (a, b)
);

-- Test 37: query (line 329)
SHOW CREATE ALL TABLES

-- Test 38: statement (line 342)
CREATE DATABASE test_escaping;
USE test_escaping;

-- Test 39: statement (line 346)
CREATE TABLE test_escaping.";" (";" int, index (";"));

-- Test 40: statement (line 349)
INSERT INTO test_escaping.";" VALUES (1);

-- Test 41: query (line 352)
SHOW CREATE ALL TABLES

-- Test 42: statement (line 365)
CREATE DATABASE test_comment;
USE test_comment;
CREATE TABLE test_comment."t   t" ("x'" INT PRIMARY KEY);
COMMENT ON TABLE test_comment."t   t" IS 'has '' quotes';
COMMENT ON INDEX test_comment."t   t"@"t   t_pkey" IS 'has '' more '' quotes';
COMMENT ON COLUMN test_comment."t   t"."x'" IS 'i '' just '' love '' quotes';
COMMENT ON CONSTRAINT "t   t_pkey" ON test_comment."t   t" IS 'new constraint comment';

-- Test 43: query (line 375)
SHOW CREATE ALL TABLES

-- Test 44: statement (line 389)
CREATE DATABASE test_schema;
USE test_schema;
CREATE SCHEMA sc1;
CREATE SCHEMA sc2;

-- Test 45: statement (line 395)
CREATE TABLE sc1.t (x int);

-- Test 46: statement (line 398)
CREATE TABLE sc2.t (x int);

-- Test 47: query (line 401)
SHOW CREATE ALL TABLES

-- Test 48: statement (line 417)
CREATE DATABASE test_sequence;
USE test_sequence;
CREATE SEQUENCE s1 INCREMENT 123;

-- Test 49: query (line 422)
SHOW CREATE ALL TABLES

-- Test 50: statement (line 429)
CREATE DATABASE type_test;
USE type_test;
CREATE TYPE test AS enum();

-- Test 51: statement (line 434)
CREATE TABLE t(x test);

-- Test 52: query (line 437)
SHOW CREATE ALL TABLES

-- Test 53: query (line 453)
SHOW CREATE ALL TABLES

-- Test 54: statement (line 470)
CREATE DATABASE "d-d";
USE "d-d";
CREATE TABLE t();
SHOW CREATE ALL TABLES;

-- Test 55: statement (line 477)
CREATE DATABASE "a""bc";
USE "a""bc";
CREATE TABLE t();
SHOW CREATE ALL SCHEMAS;

