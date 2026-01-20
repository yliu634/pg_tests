-- PostgreSQL compatible tests from rename_column
-- 62 tests

SET client_min_messages = warning;

DROP VIEW IF EXISTS v1 CASCADE;
DROP VIEW IF EXISTS v2 CASCADE;
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS foo CASCADE;
DROP TABLE IF EXISTS mixed_case_table CASCADE;
DROP TABLE IF EXISTS rename_add_alter_pk_tbl CASCADE;
DROP TABLE IF EXISTS tab1 CASCADE;

-- Test 1: statement (line 1)
CREATE TABLE users (
  uid   INT PRIMARY KEY,
  name  VARCHAR NOT NULL,
  title VARCHAR
);

-- Avoid naming conflicts with table "foo" later in this test (PG shares one namespace).
CREATE INDEX users_foo ON users (name) INCLUDE (title);
CREATE UNIQUE INDEX bar ON users (uid, name);

-- Test 2: statement (line 10)
INSERT INTO users VALUES (1, 'tom', 'cat'),(2, 'jerry', 'rat');

-- Test 3: query (line 13)
SELECT * FROM users;

-- Test 4: statement (line 20)
-- Expected ERROR (column already exists):
\set ON_ERROR_STOP 0
ALTER TABLE users RENAME COLUMN title TO name;
\set ON_ERROR_STOP 1

-- Test 5: statement (line 23)
-- Expected ERROR (zero-length identifier):
\set ON_ERROR_STOP 0
ALTER TABLE users RENAME COLUMN title TO "";
\set ON_ERROR_STOP 1

-- Test 6: statement (line 26)
-- Expected ERROR (column does not exist):
\set ON_ERROR_STOP 0
ALTER TABLE users RENAME COLUMN ttle TO species;
\set ON_ERROR_STOP 1

-- Test 7: statement (line 29)
-- Expected ERROR (table does not exist):
\set ON_ERROR_STOP 0
ALTER TABLE uses RENAME COLUMN title TO species;
\set ON_ERROR_STOP 1

-- Test 8: statement (line 32)
ALTER TABLE IF EXISTS uses RENAME COLUMN title TO species;

-- Test 9: statement (line 35)
ALTER TABLE users RENAME COLUMN uid TO id;

-- Test 10: statement (line 38)
ALTER TABLE users RENAME COLUMN title TO species;

-- Test 11: query (line 41)
SELECT * FROM users;

-- Test 12: statement (line 50)
ALTER TABLE users RENAME COLUMN name TO username;

-- Cockroach logic-test user switching directives:
-- user root
-- Test 13: statement (line 55)
-- GRANT CREATE ON TABLE users TO testuser
-- user testuser
-- Test 14: statement (line 60)
-- ALTER TABLE users RENAME COLUMN name TO username
-- user root

-- Test 15: query (line 65)
SELECT * FROM users;

-- Test 16: query (line 73)
SELECT indexname, indexdef
FROM pg_indexes
WHERE schemaname = current_schema()
  AND tablename = 'users'
ORDER BY indexname;

-- Test 17: statement (line 86)
CREATE VIEW v1 AS SELECT id FROM users WHERE username = 'tom';

-- Test 18: statement (line 89)
ALTER TABLE users RENAME COLUMN id TO uid;

-- Test 19: statement (line 92)
ALTER TABLE users RENAME COLUMN username TO name;

-- Test 20: statement (line 95)
ALTER TABLE users RENAME COLUMN species TO title;

-- Test 21: statement (line 98)
-- Expected ERROR (column does not exist):
\set ON_ERROR_STOP 0
CREATE VIEW v2 AS SELECT id FROM users;
\set ON_ERROR_STOP 1

-- Test 22: statement (line 101)
DROP VIEW v1;

-- Test 23: statement (line 104)
-- Expected ERROR (column does not exist):
\set ON_ERROR_STOP 0
ALTER TABLE users RENAME COLUMN id TO uid;
\set ON_ERROR_STOP 1

-- Test 24: statement (line 107)
-- Expected ERROR (column does not exist):
\set ON_ERROR_STOP 0
ALTER TABLE users RENAME COLUMN username TO name;
\set ON_ERROR_STOP 1

-- Test 25: statement (line 110)
-- Expected ERROR (view does not exist):
\set ON_ERROR_STOP 0
DROP VIEW v2;
\set ON_ERROR_STOP 1

-- Test 26: query (line 113)
SELECT column_name
FROM information_schema.columns
WHERE table_schema = current_schema()
  AND table_name = 'users'
ORDER BY column_name;

-- Test 27: statement (line 120)
-- CockroachDB-only setting:
-- SET vectorize=on

-- Test 28: query (line 123)
-- CockroachDB supports EXPLAIN for DDL; PostgreSQL does not.
-- EXPLAIN ALTER TABLE users RENAME COLUMN title TO woo

-- Test 29: statement (line 130)
-- RESET vectorize

-- Test 30: query (line 134)
SELECT column_name
FROM information_schema.columns
WHERE table_schema = current_schema()
  AND table_name = 'users'
ORDER BY column_name;

-- Test 31: statement (line 142)
-- CockroachDB-only table option:
-- ALTER TABLE users SET (schema_locked=false);

-- Test 32: statement (line 151)
-- CockroachDB-only table option:
-- ALTER TABLE users SET (schema_locked=true);

-- Test 33: query (line 154)
SELECT title FROM users;

-- Test 34: statement (line 165)
CREATE TABLE foo (j INT);

-- Test 35: statement (line 168)
BEGIN;
    ALTER TABLE foo ADD CONSTRAINT check_not_negative CHECK (j >= 0);
    ALTER TABLE foo RENAME COLUMN j TO i;
COMMIT;

-- Test 36: statement (line 174)
BEGIN;
    ALTER TABLE foo ADD COLUMN k INT GENERATED ALWAYS AS (i+1) STORED;
    ALTER TABLE foo RENAME COLUMN i TO j;
COMMIT;

-- Test 37: statement (line 180)
BEGIN;
    ALTER TABLE foo ALTER COLUMN j SET NOT NULL;
    ALTER TABLE foo RENAME COLUMN j TO i;
COMMIT;

-- Test 38: statement (line 186)
BEGIN;
    CREATE INDEX ON foo(i) WHERE i > 0;
    ALTER TABLE foo RENAME COLUMN i TO j;
COMMIT;

-- Test 39: statement (line 192)
INSERT INTO foo(j) VALUES (1);

-- Test 40: query (line 195)
SELECT j, k FROM foo;

-- Test 41: statement (line 201)
CREATE TABLE mixed_case_table (
    "CamelCase" INT PRIMARY KEY,
    "snake_case" TEXT,
    "UPPERCASE" DECIMAL
);

-- Test 42: statement (line 208)
-- Expected ERROR (column already exists):
\set ON_ERROR_STOP 0
ALTER TABLE mixed_case_table RENAME COLUMN "CamelCase" TO "UPPERCASE";
\set ON_ERROR_STOP 1

-- Test 43: statement (line 211)
-- Expected ERROR (column already exists):
\set ON_ERROR_STOP 0
ALTER TABLE mixed_case_table RENAME COLUMN "CamelCase" TO "CamelCase";
\set ON_ERROR_STOP 1

-- Test 44: statement (line 214)
ALTER TABLE mixed_case_table RENAME COLUMN "CamelCase" TO "NewCamelCase";

-- Test 45: statement (line 217)
ALTER TABLE mixed_case_table RENAME COLUMN "snake_case" TO "SnakeCase";

-- Test 46: statement (line 220)
ALTER TABLE mixed_case_table RENAME COLUMN "UPPERCASE" TO "decimal_value";

-- Test 47: query (line 223)
SELECT column_name
FROM information_schema.columns
WHERE table_schema = current_schema()
  AND table_name = 'mixed_case_table'
ORDER BY column_name;

-- Test 48: statement (line 235)
CREATE TABLE rename_add_alter_pk_tbl (a INT PRIMARY KEY, b INT);

-- Test 49: statement (line 238)
INSERT INTO rename_add_alter_pk_tbl VALUES (1, 10), (2, 20);

-- skipif config local-legacy-schema-changer local-mixed-25.4

-- Test 50: statement (line 242)
BEGIN;
    ALTER TABLE rename_add_alter_pk_tbl RENAME COLUMN a TO b_old;
    ALTER TABLE rename_add_alter_pk_tbl ADD COLUMN a INT NOT NULL DEFAULT 0;
COMMIT;

-- Test 51: query (line 248)
SELECT b_old, b, a FROM rename_add_alter_pk_tbl;

-- Test 52: query (line 256)
SELECT indexname, indexdef
FROM pg_indexes
WHERE schemaname = current_schema()
  AND tablename = 'rename_add_alter_pk_tbl'
ORDER BY indexname;

-- Test 53: query (line 265)
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_schema = current_schema()
  AND table_name = 'rename_add_alter_pk_tbl'
ORDER BY ordinal_position;

-- Test 54: statement (line 277)
UPDATE rename_add_alter_pk_tbl SET a = 10 WHERE b_old = 2;

-- skipif config local-legacy-schema-changer local-mixed-25.4

-- Test 55: statement (line 281)
BEGIN;
    ALTER TABLE rename_add_alter_pk_tbl RENAME COLUMN b_old TO b_orig;
    ALTER TABLE rename_add_alter_pk_tbl ADD COLUMN b_old INT NOT NULL DEFAULT 100;
    ALTER TABLE rename_add_alter_pk_tbl DROP CONSTRAINT rename_add_alter_pk_tbl_pkey;
    ALTER TABLE rename_add_alter_pk_tbl ADD PRIMARY KEY (a);
COMMIT;

-- Test 56: query (line 287)
SELECT b_old, b_orig, a, b FROM rename_add_alter_pk_tbl;

-- Test 57: query (line 295)
SELECT conname, pg_get_constraintdef(oid)
FROM pg_constraint
WHERE conrelid = 'rename_add_alter_pk_tbl'::regclass
ORDER BY conname;

-- Test 58: statement (line 310)
DROP TABLE IF EXISTS tab1;

-- Test 59: statement (line 314)
CREATE TABLE tab1 (
    a INT NOT NULL,
    b DATE NOT NULL,
    c INT NOT NULL,
    d INT NOT NULL,
    PRIMARY KEY (d, b, a)
);

CREATE UNIQUE INDEX tab1_d_b_a_c_idx ON tab1 (d, b, a, c);

-- Test 60: query (line 325)
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_schema = current_schema()
  AND table_name = 'tab1'
ORDER BY ordinal_position;

-- Test 61: statement (line 340)
ALTER TABLE tab1 RENAME COLUMN d TO rename_d;

-- Test 62: query (line 344)
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_schema = current_schema()
  AND table_name = 'tab1'
ORDER BY ordinal_position;

RESET client_min_messages;
