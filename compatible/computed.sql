-- PostgreSQL compatible tests from computed
-- Simplified version focusing on generated columns (254 tests in original)

SET client_min_messages = warning;
DROP TABLE IF EXISTS with_no_column_refs CASCADE;
DROP TABLE IF EXISTS extra_parens CASCADE;
DROP TABLE IF EXISTS x CASCADE;
DROP TABLE IF EXISTS y CASCADE;
DROP TABLE IF EXISTS tab CASCADE;
DROP TABLE IF EXISTS tmp CASCADE;
DROP TABLE IF EXISTS p CASCADE;
DROP TABLE IF EXISTS c_update CASCADE;
DROP TABLE IF EXISTS c_delete_cascade CASCADE;
DROP TABLE IF EXISTS c_delete_set CASCADE;
DROP TABLE IF EXISTS tt CASCADE;
DROP TABLE IF EXISTS xx CASCADE;
DROP TABLE IF EXISTS yy CASCADE;
DROP TABLE IF EXISTS uu CASCADE;
DROP TABLE IF EXISTS aa CASCADE;
DROP TABLE IF EXISTS bb CASCADE;
DROP TABLE IF EXISTS error_check CASCADE;
DROP TABLE IF EXISTS t42418 CASCADE;
DROP TABLE IF EXISTS trewrite CASCADE;
DROP TABLE IF EXISTS trewrite_copy CASCADE;
DROP TABLE IF EXISTS trewrite2 CASCADE;
DROP TABLE IF EXISTS t69327 CASCADE;
DROP TABLE IF EXISTS t69665 CASCADE;
DROP TABLE IF EXISTS t75907 CASCADE;
DROP TABLE IF EXISTS t88128 CASCADE;
DROP TABLE IF EXISTS foooooo CASCADE;
DROP TABLE IF EXISTS t81698 CASCADE;
DROP TABLE IF EXISTS test_table CASCADE;
DROP TABLE IF EXISTS test_virtual CASCADE;
RESET client_min_messages;

-- Test 1: Simple generated column
CREATE TABLE with_no_column_refs (
  a INT,
  b INT,
  c INT GENERATED ALWAYS AS (3) STORED
);

-- Test 9: Cannot insert into generated column
-- INSERT INTO with_no_column_refs VALUES (1, 2, 3); - Would error

-- Test 13: Insert with explicit columns (omitting generated)
INSERT INTO with_no_column_refs (a, b) VALUES (1, 2);

-- Test 18: Query generated column
SELECT c FROM with_no_column_refs;

-- Test 19: Generated columns with references
CREATE TABLE x (
  a INT DEFAULT 3,
  b INT DEFAULT 7,
  c INT GENERATED ALWAYS AS (a) STORED,
  d INT GENERATED ALWAYS AS (a + b) STORED
);

-- Test 24: Insert with defaults
INSERT INTO x (a, b) VALUES (1, 2);

-- Test 25: Query generated columns
SELECT c, d FROM x;

-- Test 26: Delete
DELETE FROM x;

-- Test 28: Drop and recreate
DROP TABLE x;

-- Test 29: NOT NULL with generated
CREATE TABLE x (
  a INT NOT NULL,
  b INT,
  c INT GENERATED ALWAYS AS (a) STORED,
  d INT GENERATED ALWAYS AS (a + b) STORED
);

-- Test 30: Insert with NULL in nullable column
INSERT INTO x (a) VALUES (1);

-- Test 32: Query with NULL
SELECT c, d FROM x;

-- Test 33: Drop
DROP TABLE x;

-- Test 34: Generated with updates
CREATE TABLE x (
  a INT PRIMARY KEY,
  b INT,
  c INT GENERATED ALWAYS AS (b + 1) STORED,
  d INT GENERATED ALWAYS AS (b - 1) STORED
);

-- Test 35: Upsert
INSERT INTO x (a, b) VALUES (1, 1) ON CONFLICT (a) DO UPDATE SET b = excluded.b + 1;

-- Test 36: Query after upsert
SELECT c, d FROM x;

-- Test 41: Update
UPDATE x SET b = 3;

-- Test 42: Query after update
SELECT a, b, c FROM x;

-- Test 43: Update with generated column reference
UPDATE x SET b = c;

-- Test 44: Query
SELECT a, b, c FROM x;

-- Test 59: Drop table
DROP TABLE x;

-- Test 60: Cannot create generated as non-stored without STORED
-- CREATE TABLE y (a INT AS (3)); - PG requires GENERATED ALWAYS AS ... STORED

-- Test 67: Cannot use volatile functions
-- CREATE TABLE y (a TIMESTAMP GENERATED ALWAYS AS (now()) STORED); - Would error in strict mode

-- Test 68: Timestamp conversion
CREATE TABLE y (
  a TIMESTAMPTZ,
  b TIMESTAMP GENERATED ALWAYS AS (a::TIMESTAMP) STORED
);
DROP TABLE y;

-- Test 69: Timestamp arithmetic
CREATE TABLE y (
  a TIMESTAMPTZ,
  b INTERVAL,
  c TIMESTAMPTZ GENERATED ALWAYS AS (a + b) STORED
);
DROP TABLE y;

-- Test 73: Cannot have DEFAULT on generated column
-- CREATE TABLE y (a INT GENERATED ALWAYS AS (3) STORED DEFAULT 4); - Would error

-- Test 77: Foreign keys with generated columns
CREATE TABLE x (a INT PRIMARY KEY);
CREATE TABLE y (
  r INT GENERATED ALWAYS AS (1) STORED REFERENCES x (a)
);
DROP TABLE y;
DROP TABLE x;

-- Test 93: Add generated column
CREATE TABLE tt (i BIGINT GENERATED ALWAYS AS (1) STORED);
ALTER TABLE tt ADD COLUMN c BIGINT GENERATED ALWAYS AS (i) STORED;
DROP TABLE tt;

-- Test 127: JSON expressions
CREATE TABLE x (
  k INT PRIMARY KEY,
  a JSON,
  b TEXT GENERATED ALWAYS AS (a->>'q') STORED
);
CREATE INDEX ON x(b);

-- Test 130: Insert JSON
INSERT INTO x (k, a) VALUES (1, '{"q":"xyz"}'), (2, '{"q":"abc"}');

-- Test 131: Query JSON generated
SELECT k, b FROM x ORDER BY b;

-- Test 134: Drop
DROP TABLE x;

-- Test 144: Array generation
CREATE TABLE x (
  a INT,
  b INT,
  c INT,
  d INT[] GENERATED ALWAYS AS (ARRAY[a, b, c]) STORED
);

-- Test 145: Insert for array
INSERT INTO x (a, b, c) VALUES (1, 2, 3);

-- Test 146: Query array
SELECT d FROM x;

DROP TABLE x;

-- Test 169: Column rename with generated
CREATE TABLE x (
  a INT,
  b INT GENERATED ALWAYS AS (a) STORED
);

-- Test 170: Rename column
ALTER TABLE x RENAME COLUMN a TO c;

DROP TABLE x;

-- Test 174: Information schema
CREATE TABLE x (
  a INT,
  b INT GENERATED ALWAYS AS (a * 2) STORED
);

-- Test 175: Check generation expression in information_schema
SELECT generation_expression FROM information_schema.columns
WHERE table_name = 'x' and column_name = 'b';

-- Test 177: Insert
INSERT INTO x VALUES (3);

-- Test 178: Add generated column with NOT NULL
ALTER TABLE x ADD COLUMN c INT NOT NULL GENERATED ALWAYS AS (a + 4) STORED;

-- Test 183: Insert after alter
INSERT INTO x VALUES (6);

-- Test 184: Query all
SELECT * FROM x ORDER BY a;

DROP TABLE x;

-- Test 206: GENERATED ALWAYS syntax
CREATE TABLE t42418 (x INT GENERATED ALWAYS AS (1) STORED);
ALTER TABLE t42418 ADD COLUMN y INT GENERATED ALWAYS AS (1) STORED;
DROP TABLE t42418;

-- Test 227: JSONB boolean expression
CREATE TABLE t75907 (j JSONB);
INSERT INTO t75907 VALUES ('{"a": 1}');
ALTER TABLE t75907 ADD COLUMN c BOOL GENERATED ALWAYS AS (j->'b' = '1') STORED;
SELECT j, c, j->'b' = '1' AS expected_c FROM t75907;
DROP TABLE t75907;

-- Test 231: Generated column operations that should fail
CREATE TABLE foooooo (
    id INT PRIMARY KEY,
    x INT NOT NULL,
    y INT NOT NULL,
    gen INT GENERATED ALWAYS AS (x + y) STORED
);

-- Cannot set DEFAULT on generated column
-- ALTER TABLE foooooo ALTER COLUMN gen SET DEFAULT 1; - Would error

DROP TABLE foooooo;

