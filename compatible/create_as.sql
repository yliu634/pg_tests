-- PostgreSQL compatible tests from create_as
-- 108 tests

SET client_min_messages = warning;

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
SELECT * FROM itemColors;

-- Test 8: statement (line 28)
CREATE TABLE itemTypes AS (SELECT item, color FROM stock, itemColors);

-- Test 9: statement (line 31)
SELECT * FROM itemTypes;

-- Test 10: query (line 34)
SELECT * FROM itemTypes;

-- Test 11: statement (line 50)
-- Expected ERROR (mismatched column count):
\set ON_ERROR_STOP 0
CREATE TABLE t2 (col1, col2, col3) AS SELECT * FROM stock;
\set ON_ERROR_STOP 1

-- Test 12: statement (line 53)
CREATE TABLE t2 (col1) AS SELECT * FROM stock;

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
CREATE SCHEMA smtng;

-- Test 19: statement (line 82)
CREATE TABLE smtng.something AS SELECT * FROM stock;

-- Test 20: statement (line 85)
SELECT * FROM smtng.something;

-- Test 21: statement (line 88)
CREATE TABLE IF NOT EXISTS smtng.something AS SELECT * FROM stock;

-- Test 22: query (line 91)
SELECT * FROM smtng.something ORDER BY 1 LIMIT 1;

-- Test 23: statement (line 96)
-- Expected ERROR (unqualified table name does not resolve):
\set ON_ERROR_STOP 0
SELECT * FROM something LIMIT 1;
\set ON_ERROR_STOP 1

-- Test 24: statement (line 100)
CREATE TABLE foo (x, y, z) AS SELECT catalog_name, schema_name, sql_path FROM information_schema.schemata;

-- Test 25: statement (line 103)
-- Expected ERROR (relation already exists):
\set ON_ERROR_STOP 0
CREATE TABLE foo (x, y, z) AS SELECT catalog_name, schema_name, sql_path FROM information_schema.schemata;
\set ON_ERROR_STOP 1

-- Test 26: statement (line 106)
-- Expected ERROR (pseudo-type "record" is not supported for table columns):
\set ON_ERROR_STOP 0
CREATE TABLE foo2 (x) AS (VALUES(ROW()));
\set ON_ERROR_STOP 1

-- Test 27: statement (line 109)
DROP TABLE IF EXISTS foo2;
CREATE TABLE foo2 (x) AS (VALUES(ARRAY[ARRAY[1]]));

-- Test 28: statement (line 112)
DROP TABLE IF EXISTS foo2;
CREATE TABLE foo2 (x) AS SELECT generate_series(1, 3);

-- Test 29: statement (line 115)
DROP TABLE IF EXISTS foo2;
CREATE TABLE foo2 (x) AS (VALUES(NULL));

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
CREATE TABLE foo5 AS
  SELECT * FROM baz;
ALTER TABLE foo5 ADD PRIMARY KEY (b);

-- onlyif config schema-locked-disabled

-- Test 39: query (line 165)
SELECT c.column_name, c.data_type, c.is_nullable,
       (tc.constraint_type = 'PRIMARY KEY') AS is_primary_key
FROM information_schema.columns c
LEFT JOIN information_schema.key_column_usage kcu
  ON c.table_schema = kcu.table_schema
 AND c.table_name = kcu.table_name
 AND c.column_name = kcu.column_name
LEFT JOIN information_schema.table_constraints tc
  ON tc.constraint_name = kcu.constraint_name
 AND tc.table_schema = kcu.table_schema
 AND tc.table_name = kcu.table_name
WHERE c.table_schema = 'public' AND c.table_name = 'foo5'
ORDER BY c.ordinal_position;

-- Test 40: query (line 176)
SELECT c.column_name, c.data_type, c.is_nullable,
       (tc.constraint_type = 'PRIMARY KEY') AS is_primary_key
FROM information_schema.columns c
LEFT JOIN information_schema.key_column_usage kcu
  ON c.table_schema = kcu.table_schema
 AND c.table_name = kcu.table_name
 AND c.column_name = kcu.column_name
LEFT JOIN information_schema.table_constraints tc
  ON tc.constraint_name = kcu.constraint_name
 AND tc.table_schema = kcu.table_schema
 AND tc.table_name = kcu.table_name
WHERE c.table_schema = 'public' AND c.table_name = 'foo5'
ORDER BY c.ordinal_position;

-- Test 41: statement (line 186)
CREATE TABLE foo6 AS
  SELECT * FROM baz;
ALTER TABLE foo6 ADD PRIMARY KEY (a);

-- onlyif config schema-locked-disabled

-- Test 42: query (line 194)
SELECT c.column_name, c.data_type, c.is_nullable,
       (tc.constraint_type = 'PRIMARY KEY') AS is_primary_key
FROM information_schema.columns c
LEFT JOIN information_schema.key_column_usage kcu
  ON c.table_schema = kcu.table_schema
 AND c.table_name = kcu.table_name
 AND c.column_name = kcu.column_name
LEFT JOIN information_schema.table_constraints tc
  ON tc.constraint_name = kcu.constraint_name
 AND tc.table_schema = kcu.table_schema
 AND tc.table_name = kcu.table_name
WHERE c.table_schema = 'public' AND c.table_name = 'foo6'
ORDER BY c.ordinal_position;

-- Test 43: query (line 205)
SELECT c.column_name, c.data_type, c.is_nullable,
       (tc.constraint_type = 'PRIMARY KEY') AS is_primary_key
FROM information_schema.columns c
LEFT JOIN information_schema.key_column_usage kcu
  ON c.table_schema = kcu.table_schema
 AND c.table_name = kcu.table_name
 AND c.column_name = kcu.column_name
LEFT JOIN information_schema.table_constraints tc
  ON tc.constraint_name = kcu.constraint_name
 AND tc.table_schema = kcu.table_schema
 AND tc.table_name = kcu.table_name
WHERE c.table_schema = 'public' AND c.table_name = 'foo6'
ORDER BY c.ordinal_position;

-- Test 44: statement (line 215)
CREATE TABLE foo7 (x) AS VALUES (1), (NULL);
-- Expected ERROR (NULLs are not allowed in PRIMARY KEY):
\set ON_ERROR_STOP 0
ALTER TABLE foo7 ADD PRIMARY KEY (x);
\set ON_ERROR_STOP 1

-- Test 45: statement (line 218)
BEGIN;
CREATE TABLE foo8 (item, qty) AS
  SELECT * FROM stock UNION VALUES ('spoons', 25), ('knives', 50);
ALTER TABLE foo8 ADD PRIMARY KEY (item);
COMMIT;

-- onlyif config schema-locked-disabled

-- Test 46: query (line 222)
SELECT c.column_name, c.data_type, c.is_nullable,
       (tc.constraint_type = 'PRIMARY KEY') AS is_primary_key
FROM information_schema.columns c
LEFT JOIN information_schema.key_column_usage kcu
  ON c.table_schema = kcu.table_schema
 AND c.table_name = kcu.table_name
 AND c.column_name = kcu.column_name
LEFT JOIN information_schema.table_constraints tc
  ON tc.constraint_name = kcu.constraint_name
 AND tc.table_schema = kcu.table_schema
 AND tc.table_name = kcu.table_name
WHERE c.table_schema = 'public' AND c.table_name = 'foo8'
ORDER BY c.ordinal_position;

-- Test 47: query (line 232)
SELECT c.column_name, c.data_type, c.is_nullable,
       (tc.constraint_type = 'PRIMARY KEY') AS is_primary_key
FROM information_schema.columns c
LEFT JOIN information_schema.key_column_usage kcu
  ON c.table_schema = kcu.table_schema
 AND c.table_name = kcu.table_name
 AND c.column_name = kcu.column_name
LEFT JOIN information_schema.table_constraints tc
  ON tc.constraint_name = kcu.constraint_name
 AND tc.table_schema = kcu.table_schema
 AND tc.table_name = kcu.table_name
WHERE c.table_schema = 'public' AND c.table_name = 'foo8'
ORDER BY c.ordinal_position;

-- Test 48: statement (line 242)
CREATE TABLE foo9 AS
  SELECT * FROM baz;
ALTER TABLE foo9 ADD PRIMARY KEY (a, c);

-- onlyif config schema-locked-disabled

-- Test 49: query (line 251)
SELECT c.column_name, c.data_type, c.is_nullable,
       (tc.constraint_type = 'PRIMARY KEY') AS is_primary_key
FROM information_schema.columns c
LEFT JOIN information_schema.key_column_usage kcu
  ON c.table_schema = kcu.table_schema
 AND c.table_name = kcu.table_name
 AND c.column_name = kcu.column_name
LEFT JOIN information_schema.table_constraints tc
  ON tc.constraint_name = kcu.constraint_name
 AND tc.table_schema = kcu.table_schema
 AND tc.table_name = kcu.table_name
WHERE c.table_schema = 'public' AND c.table_name = 'foo9'
ORDER BY c.ordinal_position;

-- Test 50: query (line 262)
SELECT c.column_name, c.data_type, c.is_nullable,
       (tc.constraint_type = 'PRIMARY KEY') AS is_primary_key
FROM information_schema.columns c
LEFT JOIN information_schema.key_column_usage kcu
  ON c.table_schema = kcu.table_schema
 AND c.table_name = kcu.table_name
 AND c.column_name = kcu.column_name
LEFT JOIN information_schema.table_constraints tc
  ON tc.constraint_name = kcu.constraint_name
 AND tc.table_schema = kcu.table_schema
 AND tc.table_name = kcu.table_name
WHERE c.table_schema = 'public' AND c.table_name = 'foo9'
ORDER BY c.ordinal_position;

-- Test 51: statement (line 272)
CREATE TABLE foo10 AS
  SELECT * FROM foo9;
ALTER TABLE foo10 ADD PRIMARY KEY (c, b, a);

-- onlyif config schema-locked-disabled

-- Test 52: query (line 276)
SELECT c.column_name, c.data_type, c.is_nullable,
       (tc.constraint_type = 'PRIMARY KEY') AS is_primary_key
FROM information_schema.columns c
LEFT JOIN information_schema.key_column_usage kcu
  ON c.table_schema = kcu.table_schema
 AND c.table_name = kcu.table_name
 AND c.column_name = kcu.column_name
LEFT JOIN information_schema.table_constraints tc
  ON tc.constraint_name = kcu.constraint_name
 AND tc.table_schema = kcu.table_schema
 AND tc.table_name = kcu.table_name
WHERE c.table_schema = 'public' AND c.table_name = 'foo10'
ORDER BY c.ordinal_position;

-- Test 53: query (line 287)
SELECT c.column_name, c.data_type, c.is_nullable,
       (tc.constraint_type = 'PRIMARY KEY') AS is_primary_key
FROM information_schema.columns c
LEFT JOIN information_schema.key_column_usage kcu
  ON c.table_schema = kcu.table_schema
 AND c.table_name = kcu.table_name
 AND c.column_name = kcu.column_name
LEFT JOIN information_schema.table_constraints tc
  ON tc.constraint_name = kcu.constraint_name
 AND tc.table_schema = kcu.table_schema
 AND tc.table_name = kcu.table_name
WHERE c.table_schema = 'public' AND c.table_name = 'foo10'
ORDER BY c.ordinal_position;

-- Test 54: statement (line 297)
CREATE TABLE foo11 (x, y, z) AS
  VALUES (1, 3, 4), (10, 20, 40);
ALTER TABLE foo11 ADD PRIMARY KEY (x, z);

-- onlyif config schema-locked-disabled

-- Test 55: query (line 306)
SELECT c.column_name, c.data_type, c.is_nullable,
       (tc.constraint_type = 'PRIMARY KEY') AS is_primary_key
FROM information_schema.columns c
LEFT JOIN information_schema.key_column_usage kcu
  ON c.table_schema = kcu.table_schema
 AND c.table_name = kcu.table_name
 AND c.column_name = kcu.column_name
LEFT JOIN information_schema.table_constraints tc
  ON tc.constraint_name = kcu.constraint_name
 AND tc.table_schema = kcu.table_schema
 AND tc.table_name = kcu.table_name
WHERE c.table_schema = 'public' AND c.table_name = 'foo11'
ORDER BY c.ordinal_position;

-- Test 56: query (line 317)
SELECT c.column_name, c.data_type, c.is_nullable,
       (tc.constraint_type = 'PRIMARY KEY') AS is_primary_key
FROM information_schema.columns c
LEFT JOIN information_schema.key_column_usage kcu
  ON c.table_schema = kcu.table_schema
 AND c.table_name = kcu.table_name
 AND c.column_name = kcu.column_name
LEFT JOIN information_schema.table_constraints tc
  ON tc.constraint_name = kcu.constraint_name
 AND tc.table_schema = kcu.table_schema
 AND tc.table_name = kcu.table_name
WHERE c.table_schema = 'public' AND c.table_name = 'foo11'
ORDER BY c.ordinal_position;

-- Test 57: statement (line 327)
-- Expected ERROR (multiple PRIMARY KEY constraints):
\set ON_ERROR_STOP 0
CREATE TABLE foo12 (x INT PRIMARY KEY, y INT, PRIMARY KEY (y));
\set ON_ERROR_STOP 1

-- Test 58: statement (line 331)
CREATE TABLE abcd(
  a INT PRIMARY KEY,
  b INT,
  c INT,
  d INT
);

-- Test 59: statement (line 340)
CREATE TABLE foo12 AS SELECT * FROM abcd;
ALTER TABLE foo12 ADD PRIMARY KEY (a);

-- onlyif config schema-locked-disabled

-- Test 60: query (line 344)
SELECT c.column_name, c.data_type, c.is_nullable,
       (tc.constraint_type = 'PRIMARY KEY') AS is_primary_key
FROM information_schema.columns c
LEFT JOIN information_schema.key_column_usage kcu
  ON c.table_schema = kcu.table_schema
 AND c.table_name = kcu.table_name
 AND c.column_name = kcu.column_name
LEFT JOIN information_schema.table_constraints tc
  ON tc.constraint_name = kcu.constraint_name
 AND tc.table_schema = kcu.table_schema
 AND tc.table_name = kcu.table_name
WHERE c.table_schema = 'public' AND c.table_name = 'foo12'
ORDER BY c.ordinal_position;

-- Test 61: query (line 358)
SELECT c.column_name, c.data_type, c.is_nullable,
       (tc.constraint_type = 'PRIMARY KEY') AS is_primary_key
FROM information_schema.columns c
LEFT JOIN information_schema.key_column_usage kcu
  ON c.table_schema = kcu.table_schema
 AND c.table_name = kcu.table_name
 AND c.column_name = kcu.column_name
LEFT JOIN information_schema.table_constraints tc
  ON tc.constraint_name = kcu.constraint_name
 AND tc.table_schema = kcu.table_schema
 AND tc.table_name = kcu.table_name
WHERE c.table_schema = 'public' AND c.table_name = 'foo12'
ORDER BY c.ordinal_position;

-- Test 62: statement (line 372)
CREATE TABLE foo13 AS SELECT * FROM abcd;
ALTER TABLE foo13 ADD PRIMARY KEY (a, b);

-- onlyif config schema-locked-disabled

-- Test 63: query (line 376)
SELECT c.column_name, c.data_type, c.is_nullable,
       (tc.constraint_type = 'PRIMARY KEY') AS is_primary_key
FROM information_schema.columns c
LEFT JOIN information_schema.key_column_usage kcu
  ON c.table_schema = kcu.table_schema
 AND c.table_name = kcu.table_name
 AND c.column_name = kcu.column_name
LEFT JOIN information_schema.table_constraints tc
  ON tc.constraint_name = kcu.constraint_name
 AND tc.table_schema = kcu.table_schema
 AND tc.table_name = kcu.table_name
WHERE c.table_schema = 'public' AND c.table_name = 'foo13'
ORDER BY c.ordinal_position;

-- Test 64: query (line 390)
SELECT c.column_name, c.data_type, c.is_nullable,
       (tc.constraint_type = 'PRIMARY KEY') AS is_primary_key
FROM information_schema.columns c
LEFT JOIN information_schema.key_column_usage kcu
  ON c.table_schema = kcu.table_schema
 AND c.table_name = kcu.table_name
 AND c.column_name = kcu.column_name
LEFT JOIN information_schema.table_constraints tc
  ON tc.constraint_name = kcu.constraint_name
 AND tc.table_schema = kcu.table_schema
 AND tc.table_name = kcu.table_name
WHERE c.table_schema = 'public' AND c.table_name = 'foo13'
ORDER BY c.ordinal_position;

-- Test 65: statement (line 404)
ALTER TABLE foo13 RENAME d TO z;

-- Test 66: statement (line 407)
ALTER TABLE foo13 RENAME c TO e;

-- onlyif config schema-locked-disabled

-- Test 67: query (line 411)
SELECT c.column_name, c.data_type, c.is_nullable,
       (tc.constraint_type = 'PRIMARY KEY') AS is_primary_key
FROM information_schema.columns c
LEFT JOIN information_schema.key_column_usage kcu
  ON c.table_schema = kcu.table_schema
 AND c.table_name = kcu.table_name
 AND c.column_name = kcu.column_name
LEFT JOIN information_schema.table_constraints tc
  ON tc.constraint_name = kcu.constraint_name
 AND tc.table_schema = kcu.table_schema
 AND tc.table_name = kcu.table_name
WHERE c.table_schema = 'public' AND c.table_name = 'foo13'
ORDER BY c.ordinal_position;

-- Test 68: query (line 425)
SELECT c.column_name, c.data_type, c.is_nullable,
       (tc.constraint_type = 'PRIMARY KEY') AS is_primary_key
FROM information_schema.columns c
LEFT JOIN information_schema.key_column_usage kcu
  ON c.table_schema = kcu.table_schema
 AND c.table_name = kcu.table_name
 AND c.column_name = kcu.column_name
LEFT JOIN information_schema.table_constraints tc
  ON tc.constraint_name = kcu.constraint_name
 AND tc.table_schema = kcu.table_schema
 AND tc.table_name = kcu.table_name
WHERE c.table_schema = 'public' AND c.table_name = 'foo13'
ORDER BY c.ordinal_position;

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
DROP TABLE IF EXISTS t2;
CREATE TABLE t2 AS
WITH del AS (
  DELETE FROM t WHERE b > 2 RETURNING a, b
)
SELECT * FROM del;

-- Test 78: query (line 476)
SELECT * FROM t2;

-- Test 79: query (line 480)
SELECT * FROM t;

-- Test 80: statement (line 487)
BEGIN;
CREATE TABLE foo69867 (x) AS VALUES (1), (NULL);
\set ON_ERROR_STOP 0
ALTER TABLE foo69867 ADD PRIMARY KEY (x);
\set ON_ERROR_STOP 1

-- Test 81: statement (line 491)
ROLLBACK;

-- Test 82: statement (line 495)
CREATE SEQUENCE seq;

-- Test 83: statement (line 498)
CREATE TABLE tab_from_seq AS SELECT nextval('seq') AS nextval;

-- Test 84: query (line 501)
SELECT nextval >= 2 FROM tab_from_seq;

-- Test 85: statement (line 509)
CREATE SCHEMA db105393_1;
CREATE SCHEMA db105393_2;
SET search_path = db105393_1, public;
CREATE TYPE e105393 AS ENUM ('a');
CREATE TABLE t105393 (a INT PRIMARY KEY, b e105393);
SET search_path = db105393_2, public;

-- Test 86: statement (line 517)
DROP TABLE IF EXISTS e105393;
CREATE TABLE e105393 AS TABLE db105393_1.t105393;

-- Test 87: statement (line 520)
DROP TABLE IF EXISTS e105393;
CREATE TABLE e105393 AS SELECT * FROM db105393_1.t105393;

-- Test 88: statement (line 523)
DROP TABLE IF EXISTS e105393;
CREATE TABLE e105393 AS SELECT b FROM db105393_1.t105393;

-- Test 89: statement (line 526)
DROP TABLE IF EXISTS e105393;
CREATE TABLE e105393 (a, b) AS TABLE db105393_1.t105393;
ALTER TABLE e105393 ADD PRIMARY KEY (a);

-- Test 90: statement (line 529)
DROP TABLE IF EXISTS e105393;
CREATE TABLE e105393 (b) AS SELECT b FROM db105393_1.t105393;

-- Test 91: statement (line 532)
SET search_path = public;

-- Test 92: statement (line 538)
CREATE TABLE t_105887_job (a INT);
INSERT INTO t_105887_job values (1);

-- Test 93: statement (line 542)
ALTER TABLE t_105887_job ADD COLUMN b INT NOT NULL DEFAULT 2;

CREATE SCHEMA crdb_internal;
CREATE TABLE crdb_internal.jobs (job_type TEXT);
INSERT INTO crdb_internal.jobs VALUES ('SCHEMA CHANGE');

CREATE VIEW v_105887_1 AS SELECT 1 AS v;
CREATE VIEW v_105887_2 AS SELECT 1 AS v;
CREATE TABLE t_105887_1 (a INT);
INSERT INTO t_105887_1 VALUES (1);
CREATE TABLE t_105887_2 (a INT);
INSERT INTO t_105887_2 VALUES (1);

-- Test 94: query (line 545)
SELECT count(*) > 0 FROM crdb_internal.jobs WHERE job_type like '%SCHEMA CHANGE%';

-- Test 95: query (line 554)
SELECT count(*) > 0 FROM v_105887_1;

-- Test 96: query (line 559)
SELECT count(*) > 0 FROM v_105887_2;

-- Test 97: query (line 568)
SELECT count(*) > 0 FROM t_105887_1;

-- Test 98: query (line 573)
SELECT count(*) > 0 FROM t_105887_2;

-- Test 99: query (line 598)
CREATE TABLE stockcopy AS SELECT item, quantity FROM stock;
CREATE TABLE stocknospoons AS SELECT item, quantity FROM stock WHERE item <> 'spoons';
CREATE VIEW stockwithspoons AS SELECT item, quantity FROM stock WHERE item = 'spoons';

SELECT item, quantity FROM stockcopy;

-- Test 100: statement (line 605)
INSERT INTO stock VALUES ('spoons', 10);

-- Test 101: query (line 611)
SELECT item, quantity FROM stocknospoons WHERE item = 'spoons';

-- Test 102: query (line 624)
SELECT item, quantity FROM stockwithspoons WHERE item = 'spoons';

-- Test 103: statement (line 629)
ALTER TABLE stock ADD COLUMN newcol INT DEFAULT 1;
CREATE TABLE stockafterschemachange AS SELECT item, quantity, newcol FROM stock;
CREATE TABLE stockbeforedrop AS SELECT item, quantity, newcol FROM stock;

-- Test 104: query (line 635)
SELECT newcol FROM stockafterschemachange;

-- query TI rowsort
SELECT item, quantity FROM stockafterschemachange;

-- Test 105: statement (line 650)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
-- SET LOCAL autocommit_before_ddl = false;

-- Test 106: statement (line 657)
ROLLBACK;

-- Test 107: statement (line 671)
DROP VIEW stockwithspoons;
DROP TABLE stock;

-- Test 108: query (line 678)
SELECT item, quantity, newcol FROM stockbeforedrop;

RESET client_min_messages;
