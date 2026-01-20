-- PostgreSQL compatible tests from enums
--
-- CockroachDB's enum tests include logic-test directives and intentional error
-- cases. For this PostgreSQL runner we keep a smaller set of enum behaviors
-- that executes cleanly.

SET client_min_messages = warning;
DROP TABLE IF EXISTS enums_greeting_table;
DROP TABLE IF EXISTS enums_t1;
DROP TABLE IF EXISTS enums_t2;
DROP TABLE IF EXISTS enums_agg;
DROP TYPE IF EXISTS enums_greeting CASCADE;
DROP TYPE IF EXISTS enums_dbs CASCADE;
RESET client_min_messages;

CREATE TYPE enums_greeting AS ENUM ('hello', 'howdy', 'hi');
CREATE TYPE enums_dbs AS ENUM ('postgres', 'mysql', 'spanner', 'cockroach');

-- Basic casts.
SELECT 'hello'::enums_greeting, 'howdy'::enums_greeting, 'hi'::enums_greeting;

-- Ordering/comparison semantics (enum order is declaration order).
SELECT
  'hello'::enums_greeting < 'howdy'::enums_greeting AS hello_lt_howdy,
  'howdy'::enums_greeting < 'hi'::enums_greeting AS howdy_lt_hi,
  'hi'::enums_greeting > 'hello'::enums_greeting AS hi_gt_hello,
  NULL::enums_greeting IS NULL AS null_is_null;

-- enum_first/last/range.
SELECT enum_first('mysql'::enums_dbs), enum_last('spanner'::enums_dbs);
SELECT enum_range(NULL::enums_dbs) AS full_range;
SELECT enum_range('postgres'::enums_dbs, 'spanner'::enums_dbs) AS sub_range;

-- Roundtrip enum values through a table.
CREATE TABLE enums_greeting_table (x1 enums_greeting, x2 enums_greeting);
INSERT INTO enums_greeting_table VALUES ('hi', 'hello'), ('hello', 'howdy');
SELECT x1, x2 FROM enums_greeting_table ORDER BY x1, x2;

-- Index and join on enum values.
CREATE TABLE enums_t1 (x enums_greeting);
CREATE TABLE enums_t2 (x enums_greeting);
CREATE INDEX enums_t1_x_idx ON enums_t1(x);
CREATE INDEX enums_t2_x_idx ON enums_t2(x);
INSERT INTO enums_t1 VALUES ('hello'), ('hi');
INSERT INTO enums_t2 VALUES ('hello'), ('hello'), ('howdy'), ('hi');

SELECT enums_t1.x AS t1_x, enums_t2.x AS t2_x
FROM enums_t1
JOIN enums_t2 ON enums_t1.x = enums_t2.x
ORDER BY enums_t1.x, enums_t2.x;

SELECT DISTINCT x FROM enums_t2 ORDER BY x DESC;

-- Aggregates/group-by over enums.
CREATE TABLE enums_agg (x enums_greeting, y int);
INSERT INTO enums_agg VALUES
  ('hello', 1),
  ('hello', 3),
  ('howdy', 5),
  ('howdy', 0),
  ('hi', 10);

SELECT x, max(y) AS max_y, sum(y) AS sum_y, min(y) AS min_y
FROM enums_agg
GROUP BY x
ORDER BY x;

SELECT max(x) AS max_x, min(x) AS min_x FROM enums_agg;

-- Clean up (keep file repeatable in a shared test database).
DROP TABLE enums_greeting_table;
DROP TABLE enums_t1;
DROP TABLE enums_t2;
DROP TABLE enums_agg;
DROP TYPE enums_greeting;
DROP TYPE enums_dbs;

