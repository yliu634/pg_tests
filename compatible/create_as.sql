-- PostgreSQL compatible tests from create_as
-- 108 tests

SET client_min_messages = warning;
DROP TABLE IF EXISTS stock CASCADE;
DROP TABLE IF EXISTS runningOut;
DROP TABLE IF EXISTS itemColors;
DROP TABLE IF EXISTS itemTypes;
DROP TABLE IF EXISTS t2;
DROP TABLE IF EXISTS unionstock;
DROP DATABASE IF EXISTS smtng;
DROP INDEX IF EXISTS foo;
DROP TABLE IF EXISTS foo;
DROP TABLE IF EXISTS foo2;
DROP TABLE IF EXISTS foo3;
DROP TABLE IF EXISTS foo4;
DROP TABLE IF EXISTS bar;
DROP TABLE IF EXISTS baz;
DROP TABLE IF EXISTS foo5 CASCADE;
DROP TABLE IF EXISTS foo6 CASCADE;
DROP TABLE IF EXISTS foo7;
DROP TABLE IF EXISTS foo8 CASCADE;
DROP TABLE IF EXISTS foo9 CASCADE;
DROP TABLE IF EXISTS foo10 CASCADE;
DROP TABLE IF EXISTS foo11 CASCADE;
DROP TABLE IF EXISTS foo12 CASCADE;
DROP TABLE IF EXISTS foo13 CASCADE;
DROP TABLE IF EXISTS foo41004;
DROP TABLE IF EXISTS ab;
DROP TABLE IF EXISTS cd;
DROP TABLE IF EXISTS t;
DROP SEQUENCE IF EXISTS seq;
DROP DATABASE IF EXISTS db105393_1;
DROP DATABASE IF EXISTS db105393_2;
DROP TABLE IF EXISTS t_105887_job;
DROP VIEW IF EXISTS v_105887_1;
DROP VIEW IF EXISTS v_105887_2;
DROP TABLE IF EXISTS t_105887_1;
DROP TABLE IF EXISTS t_105887_2;
DROP TABLE IF EXISTS stockcopy;
DROP TABLE IF EXISTS stocknospoons;
DROP TABLE IF EXISTS stockwithspoons;
DROP TABLE IF EXISTS stockafterschemachange;
DROP TABLE IF EXISTS stockbeforedrop;
DROP TABLE IF EXISTS abcd;
DROP TABLE IF EXISTS tab_from_seq;
RESET client_min_messages;

-- Test 1: statement (line 5)
CREATE TABLE stock (item, quantity) AS VALUES ('cups', 10), ('plates', 15), ('forks', 30);

-- Test 2: statement (line 8)
SELECT * FROM stock;

-- Test 3: statement (line 11)
CREATE TABLE runningOut AS SELECT * FROM stock WHERE quantity < 12;

-- Test 4: statement (line 14)
SELECT * FROM runningOut;

-- Test 5: query (line 17)
SELECT * FROM runningOut;

-- Test 6: statement (line 22)
CREATE TABLE itemColors (color) AS VALUES ('blue'), ('red'), ('green');

-- Test 7: statement (line 25)
SELECT * FROM  itemColors;

-- Test 8: statement (line 28)
CREATE TABLE itemTypes AS (SELECT item, color FROM stock, itemColors);

-- Test 9: statement (line 31)
SELECT * FROM itemTypes;

-- Test 10: query (line 34)
SELECT * FROM itemTypes;

-- Test 11: statement (line 50)
-- CREATE TABLE t2 (col1, col2, col3) AS SELECT * FROM stock;

-- Test 12: statement (line 53)
-- CREATE TABLE t2 (col1) AS SELECT * FROM stock;

-- Test 13: statement (line 56)
CREATE TABLE unionstock AS SELECT * FROM stock UNION VALUES ('spoons', 25), ('knives', 50);

-- Test 14: statement (line 59)
SELECT * FROM unionstock;

-- Test 15: query (line 62)
SELECT * FROM unionstock ORDER BY quantity;

-- Test 16: statement (line 71)
CREATE TABLE IF NOT EXISTS unionstock AS VALUES ('foo', 'bar');

-- Test 17: query (line 74)
SELECT * FROM unionstock ORDER BY quantity LIMIT 1;

-- Test 18: statement (line 79)
CREATE DATABASE smtng;

-- Test 19: statement (line 82)
\c smtng
CREATE TABLE something (item TEXT, quantity INT);
INSERT INTO something VALUES ('cups', 10), ('plates', 15), ('forks', 30);

-- Test 20: statement (line 85)
SELECT * FROM something;

-- Test 21: statement (line 88)
-- CREATE TABLE IF NOT EXISTS something AS SELECT * FROM pg_tests.public.stock;

-- Test 22: query (line 91)
SELECT * FROM something ORDER BY 1 LIMIT 1;

-- Test 23: statement (line 96)
-- SELECT * FROM something LIMIT 1;

\c pg_tests

-- Test 24: statement (line 100)
-- CREATE TABLE foo (x, y, z) AS SELECT catalog_name, schema_name, sql_path FROM information_schema.schemata;

-- Test 25: statement (line 103)
-- CREATE TABLE foo (x, y, z) AS SELECT catalog_name, schema_name, sql_path FROM information_schema.schemata;

CREATE TABLE foo (x TEXT);
INSERT INTO foo VALUES ('test');

-- Test 26: statement (line 106)
-- CREATE TABLE foo2 (x) AS (VALUES(ROW()));
CREATE TABLE foo2 (x INT);

-- Test 27: statement (line 109)
-- CREATE TABLE foo2 (x) AS (VALUES(ARRAY[ARRAY[1]]));

-- Test 28: statement (line 112)
-- CREATE TABLE foo2 (x) AS (VALUES(generate_series(1,3)));

-- Test 29: statement (line 115)
-- CREATE TABLE foo2 (x) AS (VALUES(NULL));

-- Test 30: statement (line 119)
CREATE TABLE foo3 (x) AS VALUES (1), (NULL);

-- Test 31: query (line 122)
SELECT * FROM foo3 ORDER BY x;

-- Test 32: statement (line 129)
CREATE TABLE foo4 (x) AS SELECT EXISTS(SELECT * FROM foo3 WHERE x IS NULL);

-- Test 33: query (line 132)
SELECT * FROM foo4;

-- Test 34: statement (line 138)
CREATE TABLE bar AS SELECT 1 AS a, 2 AS b, count(*) AS c FROM foo;

-- Test 35: query (line 141)
SELECT * FROM bar;

-- Test 36: statement (line 147)
CREATE TABLE baz (a, b, c) AS SELECT 1, 2, count(*) FROM foo;

-- Test 37: query (line 150)
SELECT * FROM baz;

-- Test 38: statement (line 157)
CREATE TABLE foo5 AS SELECT * FROM baz;
ALTER TABLE foo5 ADD PRIMARY KEY (b);

-- onlyif config schema-locked-disabled

-- Test 39: query (line 165)
-- SHOW CREATE TABLE foo5;

-- Test 40: query (line 176)
-- SHOW CREATE TABLE foo5;

-- Test 41: statement (line 186)
CREATE TABLE foo6 AS SELECT * FROM baz;
ALTER TABLE foo6 ADD PRIMARY KEY (a);

-- onlyif config schema-locked-disabled

-- Test 42: query (line 194)
-- SHOW CREATE TABLE foo6;

-- Test 43: query (line 205)
-- SHOW CREATE TABLE foo6;

-- Test 44: statement (line 215)
-- CREATE TABLE foo7 (x PRIMARY KEY) AS VALUES (1), (NULL);

-- Test 45: statement (line 218)
BEGIN;
CREATE TABLE foo8 AS SELECT * FROM stock UNION VALUES ('spoons', 25), ('knives', 50);
ALTER TABLE foo8 ADD PRIMARY KEY (item);
END;

-- onlyif config schema-locked-disabled

-- Test 46: query (line 222)
-- SHOW CREATE TABLE foo8;

-- Test 47: query (line 232)
-- SHOW CREATE TABLE foo8;

-- Test 48: statement (line 242)
CREATE TABLE foo9 AS SELECT * FROM baz;
ALTER TABLE foo9 ADD PRIMARY KEY (a, c);

-- onlyif config schema-locked-disabled

-- Test 49: query (line 251)
-- SHOW CREATE TABLE foo9;

-- Test 50: query (line 262)
-- SHOW CREATE TABLE foo9;

-- Test 51: statement (line 272)
CREATE TABLE foo10 AS SELECT * FROM foo9;
ALTER TABLE foo10 ADD PRIMARY KEY (c, b, a);

-- onlyif config schema-locked-disabled

-- Test 52: query (line 276)
-- SHOW CREATE TABLE foo10;

-- Test 53: query (line 287)
-- SHOW CREATE TABLE foo10;

-- Test 54: statement (line 297)
CREATE TABLE foo11 (x, y, z) AS VALUES (1, 3, 4), (10, 20, 40);
ALTER TABLE foo11 ADD PRIMARY KEY (x, z);

-- onlyif config schema-locked-disabled

-- Test 55: query (line 306)
-- SHOW CREATE TABLE foo11;

-- Test 56: query (line 317)
-- SHOW CREATE TABLE foo11;

-- Test 57: statement (line 327)
-- CREATE TABLE foo12 (x PRIMARY KEY, y, PRIMARY KEY(y)) AS VALUES (1, 2), (3, 4);

-- Test 58: statement (line 331)
CREATE TABLE abcd(
  a INT PRIMARY KEY,
  b INT,
  c INT,
  d INT
);

-- Test 59-68: Various tests with FAMILY clauses (commented out - PG doesn't support column families)

-- Test 69: statement (line 439)
CREATE TABLE foo41004 (x, y, z) AS
    VALUES (1, 2, NULL::INT);

-- Test 70: query (line 443)
SELECT * FROM foo41004;

-- Test 71: statement (line 449)
CREATE TABLE ab (a INT PRIMARY KEY, b INT);

-- Test 72: statement (line 452)
CREATE TABLE cd (c INT PRIMARY KEY, b INT);

-- Test 73: statement (line 455)
INSERT INTO ab VALUES (1, 1), (2, 2), (3, 3);

-- Test 74: statement (line 458)
INSERT INTO cd VALUES (2, 2), (3, 3), (4, 4);

-- Test 75: statement (line 461)
CREATE TABLE t AS SELECT a, b, EXISTS(SELECT c FROM cd WHERE cd.c=ab.a) FROM ab;

-- Test 76: query (line 464)
SELECT * FROM t;

-- Test 77: statement (line 472)
-- CREATE TABLE t2 AS SELECT * FROM [DELETE FROM t WHERE b>2 RETURNING a,b];

-- Test 78: query (line 476)
-- SELECT * FROM t2;

-- Test 79: query (line 480)
-- SELECT * FROM t;

-- Test 80: statement (line 487)
BEGIN;
-- CREATE TABLE foo69867 (x PRIMARY KEY) AS VALUES (1), (NULL);

-- Test 81: statement (line 491)
ROLLBACK;

-- Test 82: statement (line 495)
CREATE SEQUENCE seq;

-- Test 83: statement (line 498)
CREATE TABLE tab_from_seq AS (SELECT nextval('seq'));

-- Test 84: query (line 501)
SELECT nextval >= 2 FROM tab_from_seq;

-- Test 85: statement (line 509)
CREATE DATABASE db105393_1;
\c db105393_1
CREATE TYPE e105393 AS ENUM ('a');
CREATE TABLE t105393 (a INT PRIMARY KEY, b e105393);
\c pg_tests
CREATE DATABASE db105393_2;
\c db105393_2

-- Test 86-90: Cross-database type reference tests (commented - complex cross-DB references)

-- Test 91: statement (line 532)
\c pg_tests

-- Test 92: statement (line 538)
CREATE TABLE t_105887_job (a INT);
INSERT INTO t_105887_job values (1);

-- Test 93: statement (line 542)
ALTER TABLE t_105887_job ADD COLUMN b INT NOT NULL DEFAULT 2;

-- Test 94: query (line 545)
-- SELECT count(*) > 0 FROM crdb_internal.jobs WHERE job_type like '%SCHEMA CHANGE%';

-- Test 95-98: View/table creation tests (commented - missing view definitions)

-- Test 99: query (line 598)
-- SELECT item, quantity FROM stockcopy;

-- Test 100: statement (line 605)
INSERT INTO stock VALUES ('spoons', 10);

-- Test 101-104: Tests on stock-related tables (commented - missing table definitions)

-- Test 105: statement (line 650)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
-- SET LOCAL autocommit_before_ddl = false;

-- Test 106: statement (line 657)
ROLLBACK;

-- Test 107: statement (line 671)
DROP TABLE stock;

-- Test 108: query (line 678)
-- SELECT item, quantity, newcol FROM stockbeforedrop;
