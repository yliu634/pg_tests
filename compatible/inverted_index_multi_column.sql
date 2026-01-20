-- PostgreSQL compatible tests from inverted_index_multi_column
-- 75 tests

-- Test 1: statement (line 6)
CREATE TABLE m_err (k INT PRIMARY KEY, a INT, b INT, geom GEOMETRY, INVERTED INDEX (a, b))

-- Test 2: statement (line 10)
CREATE TABLE m_err (k INT PRIMARY KEY, geom1 GEOMETRY , geom GEOMETRY, INVERTED INDEX (geom1, geom))

-- Test 3: statement (line 14)
CREATE TABLE l (k INT PRIMARY KEY, a INT, j JSON, INVERTED INDEX (a, j ASC))

-- Test 4: statement (line 17)
CREATE TABLE m_err (k INT PRIMARY KEY, a INT, j JSON, INVERTED INDEX (a, j DESC))

-- Test 5: statement (line 20)
CREATE TABLE m (k INT PRIMARY KEY, a INT, geom GEOMETRY, INVERTED INDEX (a, geom))

-- Test 6: statement (line 23)
CREATE TABLE n (k INT PRIMARY KEY, a INT, geom GEOMETRY);
CREATE INVERTED INDEX n ON n (a, geom);

-- Test 7: statement (line 27)
CREATE INVERTED INDEX ON n (a, geom DESC)

-- Test 8: statement (line 30)
CREATE INVERTED INDEX ON n (a ASC, geom)

statement
CREATE TABLE s (
  k INT PRIMARY KEY,
  a INT,
  geom GEOMETRY,
  INVERTED INDEX (a, geom) WITH (geometry_min_x=0),
  FAMILY (k),
  FAMILY (a),
  FAMILY (geom)
)

onlyif config schema-locked-disabled

-- Test 9: query (line 45)
SELECT create_statement FROM [SHOW CREATE TABLE s]

-- Test 10: query (line 60)
SELECT create_statement FROM [SHOW CREATE TABLE s]

-- Test 11: statement (line 75)
CREATE TABLE drop_j (
  a INT,
  b INT,
  j JSON,
  INVERTED INDEX (a, j),
  INVERTED INDEX (b, a, j),
  FAMILY (a, b, j)
);
ALTER TABLE drop_j DROP COLUMN j;

onlyif config schema-locked-disabled

-- Test 12: query (line 87)
SELECT create_statement FROM [SHOW CREATE TABLE drop_j]

-- Test 13: query (line 99)
SELECT create_statement FROM [SHOW CREATE TABLE drop_j]

-- Test 14: statement (line 111)
CREATE TABLE drop_a (
  a INT,
  b INT,
  j JSON,
  INVERTED INDEX (a, j),
  INVERTED INDEX (b, a, j),
  FAMILY (a, b, j)
);
ALTER TABLE drop_a DROP COLUMN a;

onlyif config schema-locked-disabled

-- Test 15: query (line 123)
SELECT create_statement FROM [SHOW CREATE TABLE drop_a]

-- Test 16: query (line 135)
SELECT create_statement FROM [SHOW CREATE TABLE drop_a]

-- Test 17: statement (line 147)
CREATE TABLE src (a INT, b INT, j JSON, INVERTED INDEX (a, j), INVERTED INDEX (a, b, j));
CREATE TABLE dst (LIKE src INCLUDING INDEXES);

onlyif config schema-locked-disabled

-- Test 18: query (line 152)
SELECT create_statement FROM [SHOW CREATE TABLE dst]

-- Test 19: query (line 166)
SELECT create_statement FROM [SHOW CREATE TABLE dst]

-- Test 20: statement (line 194)
INSERT INTO t VALUES
    (1, 'foo', '{"x": "y", "num": 1}'),
    (2, 'bar', '{"x": "y", "num": 2}'),
    (3, 'baz', '{"x": "y", "num": 3}')

-- Test 21: query (line 200)
SELECT * FROM t@idx WHERE i IN (1, 2, 3) AND s = 'foo' AND j @> '{"x": "y"}'

-- Test 22: query (line 205)
SELECT * FROM t@idx WHERE i = 1 AND s IN ('foo', 'bar') AND j @> '{"x": "y"}'

-- Test 23: query (line 210)
SELECT * FROM t@idx WHERE i IN (1, 2, 3) AND s IN ('foo', 'bar') AND j @> '{"num": 1}'

-- Test 24: query (line 215)
SELECT * FROM t@idx WHERE i IN (1, 2, 3) AND s IN ('foo', 'baz') AND j @> '{"x": "y"}' ORDER BY i

-- Test 25: statement (line 222)
DELETE FROM t WHERE i = 3

-- Test 26: query (line 225)
SELECT * FROM t@idx WHERE i IN (1, 2, 3) AND s IN ('foo', 'baz') AND j @> '{"x": "y"}'

-- Test 27: statement (line 231)
UPDATE t SET j = '{"x": "y", "num": 10}' WHERE i = 1

-- Test 28: query (line 234)
SELECT * FROM t@idx WHERE i IN (1, 2, 3) AND s = 'foo' AND j @> '{"num": 10}'

-- Test 29: statement (line 240)
UPDATE t SET i = 10 WHERE i = 1;
UPDATE t SET s = 'bar' WHERE i = 2;

-- Test 30: query (line 244)
SELECT * FROM t@idx WHERE i IN (2, 10) AND s IN ('foo', 'bar') AND j @> '{"x": "y"}' ORDER BY i

-- Test 31: statement (line 251)
UPSERT INTO t VALUES (3, 'bar', '{"x": "y", "num": 3}')

-- Test 32: query (line 254)
SELECT * FROM t@idx WHERE i IN (1, 2, 3) AND s = 'bar' AND j @> '{"x": "y"}' ORDER BY i

-- Test 33: statement (line 261)
UPSERT INTO t VALUES (3, 'bar', '{"x": "y", "num": 4}')

-- Test 34: query (line 264)
SELECT * FROM t@idx WHERE i IN (1, 2, 3) AND s = 'bar' AND j @> '{"num": 4}'

-- Test 35: statement (line 270)
SELECT * FROM t@idx WHERE i = 1 AND j @> '{"num": 2}'

-- Test 36: statement (line 273)
SELECT * FROM t@idx WHERE s = 'foo' AND j @> '{"num": 2}'

-- Test 37: statement (line 281)
INSERT INTO backfill_a VALUES
    (1, 'foo', '[7]'),
    (2, 'bar', '[7, 0, 7]'),
    (3, 'baz', '{"a": "b"}'),
    (4, 'baz', '["a", "b"]')

-- Test 38: statement (line 288)
CREATE INVERTED INDEX idx ON backfill_a (i, s, j)

-- Test 39: query (line 291)
SELECT * FROM backfill_a@idx WHERE i = 1 AND s = 'foo' AND j @> '7'::JSON

-- Test 40: query (line 296)
SELECT * FROM backfill_a@idx WHERE i IN (1, 2, 3, 4) AND s IN ('foo', 'bar', 'baz') AND j @> '7'::JSON ORDER BY i

-- Test 41: query (line 302)
SELECT * FROM backfill_a@idx WHERE i IN (3, 4) AND s = 'baz' AND j @> '{"a": "b"}'::JSON

-- Test 42: statement (line 309)
SET autocommit_before_ddl = false

-- Test 43: statement (line 312)
BEGIN

-- Test 44: statement (line 318)
INSERT INTO backfill_b VALUES
    (1, 'foo', '[7]'),
    (2, 'bar', '[7, 0, 7]'),
    (3, 'baz', '{"a": "b"}')

-- Test 45: statement (line 324)
CREATE INVERTED INDEX idx ON backfill_b (i, s, j)

-- Test 46: statement (line 327)
COMMIT

-- Test 47: statement (line 330)
RESET autocommit_before_ddl

-- Test 48: query (line 333)
SELECT * FROM backfill_b@idx WHERE i IN (1, 2, 3, 4) AND s = 'bar' AND j @> '7'::JSON

-- Test 49: statement (line 340)
CREATE TABLE backfill_c (i INT, j JSON)

-- Test 50: statement (line 343)
INSERT INTO backfill_c VALUES
    (1, '[7]'),
    (2, '[7, 0, 7]'),
    (3, '{"a": "b"}')

-- Test 51: statement (line 349)
BEGIN

-- Test 52: statement (line 355)
CREATE INVERTED INDEX idx ON backfill_c (i, s, j)

-- Test 53: statement (line 358)
COMMIT

-- Test 54: query (line 361)
SELECT * FROM backfill_c@idx WHERE i IN (1, 2, 3, 4) AND s IS NULL AND j @> '7'::JSON ORDER BY i

-- Test 55: statement (line 369)
CREATE TYPE enum AS ENUM ('foo', 'bar', 'baz')

-- Test 56: statement (line 372)
CREATE TABLE backfill_d (i INT, s enum, j JSON)

-- Test 57: statement (line 375)
INSERT INTO backfill_d VALUES
    (1, 'foo', '[7]'),
    (2, 'bar', '[7, 0, 7]'),
    (3, 'baz', '{"a": "b"}')

-- Test 58: statement (line 381)
CREATE INVERTED INDEX idx ON backfill_d (i, s, j)

-- Test 59: query (line 384)
SELECT * FROM backfill_d@idx WHERE i IN (1, 2, 3, 4) AND s = 'bar' AND j @> '7'::JSON

-- Test 60: statement (line 391)
CREATE TABLE d (
  id INT PRIMARY KEY,
  foo JSONB,
  bar JSONB,
  INVERTED INDEX idx (foo, bar)
);

-- Test 61: statement (line 400)
INSERT into d VALUES
    (1, '"foo"', '[7]'),
    (2, '"bar"', '[7, 0, 7]'),
    (3, '"baz"', '{"a": "b"}'),
    (4, '"foo"', '[7, 8, 9, 10]'),
    (5, '"foo"', '[[0], [7, 8, 9, 10]]')

-- Test 62: query (line 408)
SELECT id, foo, bar FROM d@idx where foo = '"foo"' AND bar->0 = '7' ORDER BY id

-- Test 63: query (line 414)
SELECT id, foo, bar FROM d@idx where foo = '"foo"' AND bar->1 = '0' ORDER BY id

-- Test 64: query (line 418)
SELECT id, foo, bar FROM d@idx where foo = '"foo"' AND bar->1 = '8' ORDER BY id

-- Test 65: query (line 423)
SELECT id, foo, bar FROM d@idx where foo = '"foo"' AND bar->0 @> '[0]' ORDER BY id

-- Test 66: query (line 428)
SELECT id, foo, bar FROM d@idx where foo = '"foo"' AND bar->0 <@ '[0]' ORDER BY id

-- Test 67: statement (line 434)
DELETE FROM d WHERE  id = 5

-- Test 68: query (line 437)
SELECT id, foo, bar FROM d@idx where foo = '"foo"' AND bar->0 <@ '[0]' ORDER BY id

-- Test 69: statement (line 442)
UPDATE d SET foo = '"updated"' WHERE id = 2

-- Test 70: query (line 445)
SELECT id, foo, bar FROM d@idx where foo = '"updated"' AND bar->0 @> '7' ORDER BY id

-- Test 71: statement (line 452)
DROP INDEX d@idx

-- Test 72: statement (line 455)
INSERT into d VALUES
    (6, '"backfilling"', '[[0], [1], 2, 3]'),
    (7, '"q"', '[[0], [1], [2], []]'),
    (8, '"backfilling"', '[[0], [1], [2], []]')

-- Test 73: statement (line 462)
CREATE INVERTED INDEX idx on d (foo, bar)

-- Test 74: query (line 465)
SELECT id, foo, bar FROM d@idx where foo = '"backfilling"' AND bar->2 @> '2' ORDER BY id

-- Test 75: query (line 471)
SELECT id, foo, bar FROM d@idx where foo = '"foo"' AND bar->0 = '7' ORDER BY id

