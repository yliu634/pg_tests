-- PostgreSQL compatible tests from temp_table
-- 141 tests

-- Test 1: statement (line 3)
-- CockroachDB-only: SET CLUSTER SETTING sql.cross_db_views.enabled = TRUE;

-- Test 2: statement (line 6)
CREATE TEMP TABLE a_temp(a INT PRIMARY KEY);

-- Test 3: statement (line 14)
CREATE TEMP TABLE tbl (a int);
SELECT pg_my_temp_schema() AS temp_schema_oid \gset

-- Test 4: query (line 17)
SELECT
  table_name,
  CASE table_type WHEN 'BASE TABLE' THEN 'table' WHEN 'VIEW' THEN 'view' ELSE lower(table_type) END AS type
FROM information_schema.tables
WHERE table_schema = 'public' OR table_schema LIKE 'pg_temp_%'
ORDER BY table_name;

-- Test 5: query (line 26)
SELECT nspname LIKE 'pg_temp%' FROM pg_namespace WHERE oid = :temp_schema_oid;

-- Test 6: statement (line 31)
DROP TABLE tbl;

-- Test 7: statement (line 36)
CREATE TEMP TABLE temp_table_test (a timetz PRIMARY KEY) ON COMMIT PRESERVE ROWS;

-- Test 8: statement (line 39)
CREATE TEMP TABLE temp_table_ref (a timetz PRIMARY KEY);

-- Test 9: statement (line 42)
ALTER TABLE temp_table_ref ADD CONSTRAINT fk_temp FOREIGN KEY (a) REFERENCES temp_table_test(a);

-- Test 10: query (line 45)
SELECT table_name, table_type FROM information_schema.tables WHERE table_name = 'temp_table_test' AND table_schema LIKE 'pg_temp_%';

-- Test 11: query (line 51)
SELECT count(1) FROM pg_namespace WHERE nspname LIKE 'pg_temp_%';

-- Test 12: query (line 56)
SELECT table_name
FROM information_schema.tables
WHERE table_schema LIKE 'pg_temp_%'
ORDER BY table_name;

-- Test 13: statement (line 62)
DROP TABLE temp_table_ref CASCADE;
DROP TABLE temp_table_test CASCADE;

-- Test 14: statement (line 68)
CREATE TEMP TABLE a (a int PRIMARY KEY);

-- Test 15: statement (line 71)
CREATE TEMP TABLE b (c int NOT NULL PRIMARY KEY, FOREIGN KEY (c) REFERENCES a ON UPDATE SET NULL);

-- Test 16: statement (line 74)
DROP TABLE b;
CREATE TEMP TABLE b (c int DEFAULT NULL PRIMARY KEY, FOREIGN KEY (c) REFERENCES a ON UPDATE SET DEFAULT);

-- Test 17: statement (line 77)
DROP TABLE b;
DROP TABLE a;

-- Test 18: statement (line 83)
BEGIN;
CREATE TABLE table_a (a int); CREATE TEMP TABLE table_a (a int);
INSERT INTO table_a VALUES (1); INSERT INTO pg_temp.table_a VALUES (2); INSERT INTO public.table_a VALUES (3);
COMMIT;

-- Test 19: query (line 89)
SELECT * FROM pg_temp.table_a ORDER BY a;

-- Test 20: query (line 95)
SELECT * FROM public.table_a ORDER BY a;

-- Test 21: statement (line 100)
DROP TABLE pg_temp.table_a;
DROP TABLE public.table_a;

/*
-- Test 22: statement (line 106)
CREATE DATABASE bob; USE bob; CREATE TEMP TABLE a(a int); USE defaultdb

-- Test 23: statement (line 109)
SET sql_safe_updates = true

-- Test 24: statement (line 112)
DROP DATABASE bob

-- Test 25: statement (line 115)
CREATE TEMP VIEW a_view AS SELECT a FROM bob.pg_temp.a

-- Test 26: statement (line 118)
ALTER DATABASE bob RENAME TO alice

-- Test 27: statement (line 121)
DROP VIEW a_view; ALTER DATABASE bob RENAME TO alice

-- Test 28: statement (line 124)
DROP DATABASE alice CASCADE
*/

-- Test 29: statement (line 130)
CREATE TABLE permanent_table(a int);
CREATE TEMP TABLE temp_table(a int);

-- Test 30: statement (line 133)
INSERT INTO permanent_table VALUES (1);
INSERT INTO temp_table VALUES (2);

-- Test 31: statement (line 136)
CREATE TEMP VIEW view_on_permanent AS SELECT a FROM permanent_table;

-- Test 32: query (line 139)
SELECT * from pg_temp.view_on_permanent;

-- Test 33: statement (line 144)
CREATE TEMP VIEW view_on_temp AS SELECT a FROM temp_table;

-- Test 34: query (line 147)
SELECT * from pg_temp.view_on_temp;

-- Test 35: query (line 155)
CREATE TEMP VIEW upgrade_temp_view AS SELECT a FROM temp_table;

-- Test 36: statement (line 161)
DROP VIEW upgrade_temp_view;
CREATE TEMP VIEW upgrade_temp_view AS SELECT a FROM temp_table;

-- Test 37: query (line 165)
SELECT * from pg_temp.upgrade_temp_view;

-- Test 38: statement (line 170)
DROP VIEW view_on_temp;
DROP VIEW view_on_permanent;
DROP VIEW upgrade_temp_view;

-- Test 39: statement (line 173)
DROP TABLE permanent_table;
DROP TABLE temp_table;

-- Test 40: statement (line 179)
CREATE TEMP SEQUENCE temp_seq;
CREATE TABLE a (a int DEFAULT nextval('temp_seq'));

-- Test 41: statement (line 182)
INSERT INTO a VALUES (default), (default), (100);

-- Test 42: query (line 185)
SELECT * FROM a ORDER BY a;

-- Test 43: statement (line 193)
CREATE TABLE perm_table(a int DEFAULT nextval('pg_temp.temp_seq'));

-- Test 44: statement (line 196)
INSERT INTO perm_table VALUES (default), (default), (101);

-- Test 45: query (line 199)
SELECT * FROM perm_table ORDER BY a;

-- Test 46: statement (line 206)
ALTER TABLE a ALTER COLUMN a DROP DEFAULT;

-- Test 47: statement (line 209)
ALTER TABLE perm_table ALTER COLUMN a DROP DEFAULT;
DROP SEQUENCE IF EXISTS pg_temp.temp_seq;

-- Test 48: statement (line 213)
-- CockroachDB-only: SET serial_normalization='sql_sequence'

-- Test 49: statement (line 216)
CREATE TEMP TABLE ref_temp_table (a SERIAL);

-- Test 50: query (line 219)
SELECT nextval('pg_temp.ref_temp_table_a_seq');

-- Test 51: statement (line 224)
DROP TABLE perm_table;
DROP TABLE ref_temp_table;

-- Test 52: statement (line 227)
DROP SEQUENCE IF EXISTS pg_temp.temp_seq;
DROP TABLE a;

-- Test 53: query (line 230)
-- CockroachDB-only: crdb_internal.tables

-- Test 54: statement (line 236)
-- CockroachDB-only: SET serial_normalization='rowid'

-- Test 55: statement (line 241)
-- CockroachDB-only (ON COMMIT applies to TEMP tables in PostgreSQL): CREATE TABLE a (a int) ON COMMIT PRESERVE ROWS

-- Test 56: statement (line 246)
CREATE TEMP TABLE regression_47030(c0 INT); INSERT INTO regression_47030 VALUES (1);

-- Test 57: query (line 249)
SELECT * FROM regression_47030;

-- Test 58: statement (line 254)
TRUNCATE regression_47030;

-- Test 59: statement (line 257)
INSERT INTO regression_47030 VALUES (2);

-- Test 60: query (line 260)
SELECT * FROM regression_47030;

/*
-- Test 61: statement (line 268)
CREATE TEMP TABLE regression_48233(a int)

-- Test 62: statement (line 271)
ALTER TABLE regression_48233 RENAME TO reg_48233

-- Test 63: query (line 274)
SELECT * FROM system.namespace WHERE name LIKE '%48233'

-- Test 64: statement (line 279)
ALTER TABLE reg_48233 RENAME TO public.reg_48233

-- Test 65: statement (line 282)
CREATE TABLE persistent_48233(a int)

-- Test 66: statement (line 285)
ALTER TABLE persistent_48233 RENAME TO pg_temp.pers_48233

-- Test 67: query (line 290)
SELECT schema_name FROM information_schema.schemata WHERE crdb_is_user_defined = 'YES'

-- Test 68: statement (line 296)
CREATE DATABASE second_db

-- Test 69: statement (line 299)
USE second_db

-- Test 70: statement (line 302)
CREATE TEMP TABLE a(a INT)

-- Test 71: statement (line 305)
USE test

-- Test 72: statement (line 308)
CREATE TEMP VIEW a_view AS SELECT a FROM second_db.pg_temp.a

-- Test 73: statement (line 311)
grant testuser to root

-- Test 74: statement (line 314)
ALTER TABLE second_db.pg_temp.a OWNER TO testuser

-- Test 75: statement (line 322)
CREATE DATABASE to_drop;
ALTER DATABASE to_drop OWNER TO testuser;

user testuser

-- Test 76: statement (line 332)
CREATE TABLE not_temp (i INT PRIMARY KEY);
CREATE TEMPORARY TABLE testuser_tmp (i INT PRIMARY KEY);
CREATE TEMPORARY VIEW tempuser_view AS SELECT i FROM testuser_tmp;
USE test

user root

-- Test 77: statement (line 340)
USE to_drop;

-- Test 78: statement (line 343)
CREATE TEMPORARY TABLE root_temp (i INT PRIMARY KEY);

let $before_drop
SELECT now()

-- Test 79: statement (line 349)
USE test;

-- Test 80: statement (line 352)
DROP DATABASE to_drop CASCADE

-- Test 81: query (line 355)
SELECT regexp_replace(
            json_array_elements_text(
                (info::JSONB)->'DroppedSchemaObjects'
            ),
            'pg_temp_[^.]+.',
            'pg_temp.'
         ) AS name
    FROM system.eventlog
   WHERE "timestamp" > '$before_drop'
ORDER BY name DESC;

-- Test 82: statement (line 374)
ALTER ROLE testuser WITH CREATEDB;

user testuser

-- Test 83: statement (line 379)
CREATE DATABASE to_drop

-- Test 84: statement (line 382)
USE to_drop

-- Test 85: statement (line 385)
CREATE TEMPORARY TABLE t (i INT PRIMARY KEY);

-- Test 86: statement (line 388)
SELECT * FROM pg_temp.t

-- Test 87: statement (line 391)
DISCARD TEMP

-- Test 88: statement (line 394)
SELECT * FROM pg_temp.t

-- Test 89: statement (line 397)
USE defaultdb;

-- Test 90: statement (line 400)
DROP DATABASE to_drop CASCADE;

-- Test 91: statement (line 403)
CREATE DATABASE to_drop

-- Test 92: statement (line 406)
CREATE TEMPORARY TABLE t (i INT PRIMARY KEY);

-- Test 93: statement (line 409)
SELECT * FROM pg_temp.t

-- Test 94: statement (line 412)
USE defaultdb;

-- Test 95: statement (line 415)
DROP DATABASE to_drop CASCADE;

-- Test 96: statement (line 424)
USE defaultdb;

-- Test 97: statement (line 427)
CREATE TEMPORARY TABLE from_other_session(i INT PRIMARY KEY)

user root

-- Test 98: statement (line 432)
USE defaultdb

-- Test 99: query (line 435)
SELECT c.relname, a.attname FROM pg_attribute a
INNER LOOKUP JOIN pg_class c ON c.oid = a.attrelid
WHERE c.relname = 'from_other_session'

-- Test 100: statement (line 450)
CREATE DATABASE database_108751

-- Test 101: statement (line 453)
USE database_108751

-- Test 102: statement (line 459)
CREATE TABLE t_108751 (x int)

-- Test 103: statement (line 462)
CREATE TEMP VIEW t_108751_view (x) AS SELECT x FROM t_108751

let $t_108751_view_id
SELECT id FROM system.namespace WHERE name = 't_108751_view'

user root nodeidx=0 newsession

-- Test 104: statement (line 470)
USE database_108751

-- Test 105: query (line 476)
SELECT descriptor FROM system.descriptor WHERE id = $t_108751_view_id

-- Test 106: statement (line 480)
DROP DATABASE database_108751 CASCADE

-- Test 107: statement (line 488)
CREATE DATABASE database_142780

-- Test 108: statement (line 491)
USE database_142780

-- Test 109: statement (line 497)
CREATE TYPE pg_temp.temp_type AS (a int, b int);

-- Test 110: statement (line 501)
CREATE TEMP TABLE temp_table_142780 (a int primary key, b int);

-- Test 111: statement (line 504)
CREATE TYPE pg_temp.temp_type AS (a int, b int);

-- Test 112: statement (line 507)
RESET database

-- Test 113: statement (line 510)
DROP DATABASE database_142780

-- Test 114: statement (line 518)
CREATE DATABASE database_145438

-- Test 115: statement (line 521)
USE database_145438

-- Test 116: statement (line 527)
CREATE VIEW pg_temp.temp_view AS SELECT 1;

-- Test 117: query (line 530)
SELECT * FROM pg_temp.temp_view

-- Test 118: statement (line 535)
CREATE TEMP VIEW public.bad_temp_view AS SELECT 1;

-- Test 119: statement (line 538)
RESET database

-- Test 120: statement (line 541)
DROP DATABASE database_145438

-- Test 121: statement (line 549)
CREATE DATABASE database_145438

-- Test 122: statement (line 552)
USE database_145438

-- Test 123: statement (line 558)
CREATE SEQUENCE pg_temp.temp_seq;

-- Test 124: query (line 561)
SELECT nextval('pg_temp.temp_seq');

-- Test 125: statement (line 566)
CREATE TEMP SEQUENCE public.bad_temp_seq;

-- Test 126: statement (line 569)
RESET database

-- Test 127: statement (line 572)
DROP DATABASE database_145438

-- Test 128: statement (line 580)
CREATE DATABASE database_142783

-- Test 129: statement (line 583)
USE database_142783

-- Test 130: statement (line 589)
CREATE FUNCTION pg_temp.temp_func() RETURNS int AS $$SELECT 1$$ LANGUAGE SQL;

-- Test 131: statement (line 593)
CREATE TEMP TABLE temp_table_142783 (a int primary key);

-- Test 132: statement (line 596)
CREATE FUNCTION pg_temp.temp_func() RETURNS int AS $$SELECT 1$$ LANGUAGE SQL;

-- Test 133: statement (line 599)
RESET database

-- Test 134: statement (line 602)
DROP DATABASE database_142783
*/

-- Test 135: statement (line 610)
-- CockroachDB-only: USE defaultdb;

-- Test 136: statement (line 613)
create type my_enum as enum ('value1', 'value2');

-- Test 137: statement (line 616)
create temporary table tmp_table (id int primary key);

-- Test 138: statement (line 619)
insert into tmp_table values (1), (2), (3);

-- Test 139: statement (line 622)
ALTER TYPE my_enum ADD VALUE 'value3';

-- Test 140: statement (line 625)
DROP TYPE my_enum;

-- Test 141: statement (line 628)
DROP TABLE tmp_table;
