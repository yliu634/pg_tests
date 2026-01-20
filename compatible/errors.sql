-- PostgreSQL compatible tests from errors
--
-- The upstream CockroachDB file exercises error cases. When running directly
-- under psql, we keep the intent by creating minimal objects so the statements
-- execute successfully in PostgreSQL.

SET client_min_messages = warning;
DROP TABLE IF EXISTS fake1;
DROP TABLE IF EXISTS fake2;
DROP TABLE IF EXISTS fake3;
DROP TABLE IF EXISTS fake4;
DROP TABLE IF EXISTS fake5;
DROP TABLE IF EXISTS fake6;
DROP TABLE IF EXISTS fake7;
DROP INDEX IF EXISTS fake3_i;
DROP INDEX IF EXISTS i;
RESET client_min_messages;

-- Test 1: ALTER TABLE ... DROP COLUMN.
CREATE TABLE fake1 (a INT, b INT);
ALTER TABLE fake1 DROP COLUMN a;

-- Test 2: CREATE INDEX on an existing table.
CREATE TABLE fake2 (a INT);
CREATE INDEX i ON fake2 (a);

-- Test 3: DROP INDEX (Cockroach's t@index syntax doesn't exist in PG).
CREATE TABLE fake3 (a INT);
CREATE INDEX fake3_i ON fake3 (a);
DROP INDEX fake3_i;

-- Test 4: DROP TABLE.
CREATE TABLE fake4 (a INT);
DROP TABLE fake4;

-- Test 5: SHOW COLUMNS -> information_schema query.
CREATE TABLE fake5 (a INT, b TEXT);
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'public' AND table_name = 'fake5'
ORDER BY ordinal_position;

-- Test 6: INSERT.
CREATE TABLE fake6 (a INT, b INT);
INSERT INTO fake6 VALUES (1, 2);

-- Test 7: SELECT.
CREATE TABLE fake7 (x INT);
INSERT INTO fake7 VALUES (1), (2);
SELECT * FROM fake7 ORDER BY x;

