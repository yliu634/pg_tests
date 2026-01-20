SET client_min_messages = warning;

-- PostgreSQL compatible tests from materialized_view
-- 69 tests

-- Test 1: statement (line 2)
DROP TABLE IF EXISTS t CASCADE;
DROP TABLE IF EXISTS t CASCADE;
CREATE TABLE t (x INT, y INT);
INSERT INTO t VALUES (1, 2), (3, 4), (5, 6);

-- Test 2: statement (line 6)
CREATE MATERIALIZED VIEW v AS SELECT x, y FROM t;

-- Test 3: query (line 10)
SELECT matviewname AS table_name
FROM pg_matviews
ORDER BY matviewname;

-- Test 4: query (line 15)
SELECT * FROM v;

-- Test 5: statement (line 23)
INSERT INTO t VALUES (7, 8);

-- Test 6: query (line 26)
SELECT * FROM v;

-- Test 7: statement (line 37)
REFRESH MATERIALIZED VIEW v;

-- Test 8: query (line 41)
SELECT * FROM v;

-- Test 9: query (line 50)
-- COMMENTED: CockroachDB-specific: SELECT count(*) FROM v WHERE crdb_internal_mvcc_timestamp > $orig_crdb_timestamp

-- Test 10: statement (line 56)
CREATE INDEX v_y_idx ON v (y);

-- Test 11: query (line 59)
SELECT y FROM v WHERE y > 4;

-- Test 12: statement (line 66)
INSERT INTO t VALUES (9, 10);

-- Test 13: statement (line 69)
REFRESH MATERIALIZED VIEW v;

-- Test 14: query (line 72)
SELECT y FROM v WHERE y > 4;

-- Test 15: statement (line 80)
DROP INDEX v_y_idx;

-- Test 16: query (line 83)
SELECT y FROM v WHERE y > 4;

-- Test 17: statement (line 91)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- Test 18: statement (line 94)
-- COMMENTED: CockroachDB-specific setting
-- SET LOCAL autocommit_before_ddl=off;

-- Test 19: statement (line 97)
REFRESH MATERIALIZED VIEW v;

-- Test 20: statement (line 100)
ROLLBACK;

-- Test 21: statement (line 103)
-- COMMENTED: PostgreSQL materialized views are not directly writable.
-- INSERT INTO v VALUES (1, 2);

-- Test 22: statement (line 106)
-- COMMENTED: PostgreSQL materialized views are not directly writable.
-- UPDATE v SET x = 1 WHERE y = 1;

-- Test 23: statement (line 109)
-- COMMENTED: PostgreSQL materialized views are not directly writable.
-- DELETE FROM v WHERE x = 1;

-- Test 24: statement (line 112)
-- COMMENTED: PostgreSQL materialized views are not directly writable.
-- TRUNCATE v;

-- Test 25: statement (line 117)
DROP TABLE IF EXISTS dup CASCADE;
DROP TABLE IF EXISTS dup CASCADE;
CREATE TABLE dup (x INT);

-- Test 26: statement (line 120)
CREATE MATERIALIZED VIEW v_dup AS SELECT x FROM dup;

-- Test 27: statement (line 123)
CREATE UNIQUE INDEX v_dup_x_uidx ON v_dup (x);

-- Test 28: statement (line 126)
INSERT INTO dup VALUES (1), (2);

-- Test 29: statement (line 129)
REFRESH MATERIALIZED VIEW v_dup;

-- Test 30: statement (line 133)
CREATE VIEW normal_view AS SELECT 1;
CREATE MATERIALIZED VIEW materialized_view AS SELECT 1;

-- Test 31: statement (line 137)
ALTER MATERIALIZED VIEW materialized_view RENAME TO materialized_view_newname;

-- Test 32: statement (line 140)
ALTER VIEW normal_view RENAME TO normal_view_newname;

-- Test 33: statement (line 143)
ALTER VIEW normal_view_newname SET SCHEMA public;

-- Test 34: statement (line 146)
ALTER MATERIALIZED VIEW materialized_view_newname SET SCHEMA public;

-- Test 35: statement (line 149)
DROP VIEW normal_view_newname;

-- Test 36: statement (line 152)
DROP MATERIALIZED VIEW materialized_view_newname;

-- Test 37: statement (line 157)
CREATE MATERIALIZED VIEW with_options AS SELECT 1;

-- Test 38: statement (line 160)
REFRESH MATERIALIZED VIEW with_options WITH DATA;

-- Test 39: query (line 163)
SELECT * FROM with_options;

-- Test 40: statement (line 168)
REFRESH MATERIALIZED VIEW with_options WITH NO DATA;

-- Test 41: query (line 171)
SELECT ispopulated FROM pg_matviews WHERE matviewname = 'with_options';

-- Regression test for null data in materialized views.
-- statement ok
DROP TABLE IF EXISTS t57108 CASCADE;
CREATE TABLE t57108 (id INT PRIMARY KEY, a INT);
INSERT INTO t57108 VALUES(1, 1), (2, NULL);
CREATE MATERIALIZED VIEW t57108_v AS SELECT t57108.a from t57108;

-- query I rowsort
SELECT * FROM t57108_v;

-- Test 42: statement (line 190)
REFRESH MATERIALIZED VIEW with_options WITH NO DATA;

-- COMMENTED: Logic test directive: user root

-- Test 43: statement (line 195)
-- COMMENTED: CockroachDB role management; not applicable to PostgreSQL.
-- GRANT root TO testuser;

-- COMMENTED: Logic test directive: user testuser

-- Test 44: statement (line 202)
REFRESH MATERIALIZED VIEW with_options WITH NO DATA;

-- Test 45: statement (line 205)
-- COMMENTED: CockroachDB role management; not applicable to PostgreSQL.
-- REVOKE root FROM testuser;

-- COMMENTED: Logic test directive: user root

-- Test 46: statement (line 210)
-- COMMENTED: CockroachDB role/database permissions; not applicable to PostgreSQL.
-- GRANT CREATE ON DATABASE test TO testuser;

-- Test 47: statement (line 213)
-- COMMENTED: CockroachDB role management; not applicable to PostgreSQL.
-- ALTER MATERIALIZED VIEW with_options OWNER TO testuser;

-- Test 48: statement (line 217)
REFRESH MATERIALIZED VIEW with_options WITH NO DATA;

-- COMMENTED: Logic test directive: user testuser

-- Test 49: statement (line 223)
REFRESH MATERIALIZED VIEW with_options WITH NO DATA;

-- Test 50: statement (line 227)
CREATE SEQUENCE seq;
CREATE MATERIALIZED VIEW view_from_seq AS (SELECT nextval('seq'));

-- Test 51: query (line 231)
SELECT * FROM view_from_seq;

-- Test 52: statement (line 239)
BEGIN;

-- COMMENTED: Logic test directive: user root

-- Test 53: statement (line 244)
-- COMMENTED: CockroachDB internal table.
-- SELECT * FROM system.descriptor;

-- COMMENTED: Logic test directive: user testuser

-- Test 54: statement (line 249)
CREATE SEQUENCE seq_2;
CREATE MATERIALIZED VIEW view_from_seq_2 AS (SELECT nextval('seq_2'));
COMMIT;

-- Test 55: statement (line 259)
DROP TABLE IF EXISTS tab_as_of CASCADE;
DROP TABLE IF EXISTS tab_as_of CASCADE;
CREATE TABLE tab_as_of (a INT PRIMARY KEY, b INT, c INT);
INSERT INTO tab_as_of VALUES (0, 0);

-- COMMENTED: Logic test directive: let $ts_before_drop_b
SELECT now();

-- Test 56: statement (line 266)
ALTER TABLE tab_as_of DROP COLUMN b;

-- COMMENTED: Logic test directive: let $ts_before_insert_1
SELECT now();

-- Test 57: statement (line 272)
INSERT INTO tab_as_of VALUES (1);

-- Test 58: query (line 281)
-- COMMENTED: CockroachDB AS OF SYSTEM TIME materialized view tests are not available in PostgreSQL.
-- SELECT a FROM mat_view_as_of ORDER BY a;

-- Test 59: statement (line 289)
INSERT INTO tab_as_of VALUES (2);

-- Test 60: statement (line 299)
INSERT INTO tab_as_of VALUES (3);

-- Test 61: query (line 305)
-- COMMENTED: CockroachDB AS OF SYSTEM TIME materialized view tests are not available in PostgreSQL.
-- SELECT a FROM mat_view_as_of ORDER BY a;

-- Test 62: query (line 314)
-- COMMENTED: CockroachDB AS OF SYSTEM TIME materialized view tests are not available in PostgreSQL.
-- SELECT a FROM mat_view_as_of ORDER BY a;

-- Test 63: query (line 324)
-- COMMENTED: CockroachDB AS OF SYSTEM TIME materialized view tests are not available in PostgreSQL.
-- SELECT a FROM mat_view_as_of ORDER BY a;

-- Test 64: statement (line 330)
ALTER TABLE tab_as_of DROP COLUMN c;

-- COMMENTED: Logic test directive: let $ts_after_drop_c
SELECT now();

-- Test 65: query (line 339)
-- COMMENTED: CockroachDB AS OF SYSTEM TIME materialized view tests are not available in PostgreSQL.
-- SELECT a FROM mat_view_as_of ORDER BY a;

-- Test 66: statement (line 353)
-- COMMENTED: CockroachDB AS OF SYSTEM TIME materialized view tests are not available in PostgreSQL.
-- SELECT a FROM mat_view_as_of_no_data ORDER BY a;

-- Test 67: query (line 359)
-- COMMENTED: CockroachDB AS OF SYSTEM TIME materialized view tests are not available in PostgreSQL.
-- SELECT a FROM mat_view_as_of_no_data ORDER BY a;

-- Test 68: query (line 370)
-- COMMENTED: CockroachDB AS OF SYSTEM TIME materialized view tests are not available in PostgreSQL.
-- SELECT a FROM mat_view_as_of_no_data ORDER BY a;

-- Test 69: query (line 377)
-- COMMENTED: CockroachDB AS OF SYSTEM TIME materialized view tests are not available in PostgreSQL.
-- SELECT a FROM mat_view_as_of_no_data ORDER BY a;



RESET client_min_messages;
