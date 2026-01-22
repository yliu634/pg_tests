-- PostgreSQL compatible tests from truncate
-- 55 tests

-- Test 1: statement (line 2)
CREATE TABLE kv (
  k INT PRIMARY KEY,
  v INT
);

-- Test 2: statement (line 8)
INSERT INTO kv VALUES (1, 2), (3, 4), (5, 6), (7, 8);

-- Test 3: query (line 11)
SELECT * FROM kv ORDER BY k;

-- Test 4: statement (line 19)
CREATE VIEW kview AS SELECT k,v FROM kv;

-- Test 5: query (line 22)
SELECT * FROM kview ORDER BY k;

-- Test 6: statement (line 30)
TRUNCATE TABLE kv;

-- Test 7: query (line 33)
SELECT * FROM kview ORDER BY k;

-- Test 8: statement (line 41)
TRUNCATE TABLE kv;

-- Test 9: query (line 44)
SELECT * FROM kv ORDER BY k;

-- Test 10: query (line 48)
SELECT * FROM kview ORDER BY k;

-- Test 11: statement (line 58)
CREATE TABLE selfref (
  y INT PRIMARY KEY,
  Z INT REFERENCES selfref (y)
);

-- Test 12: statement (line 64)
TRUNCATE table selfref;

-- Test 13: statement (line 67)
INSERT INTO selfref VALUES (1, NULL);

-- Test 14: statement (line 70)
DROP TABLE selfref;

-- Test 15: statement (line 75)
CREATE SEQUENCE foo;

-- Test 16: statement (line 86)
CREATE TABLE bar (x int);
TRUNCATE bar;

-- Test 17: statement (line 89)
DROP TABLE bar;

-- Test 18: statement (line 94)
CREATE TABLE t0(c0 INT UNIQUE CHECK(true));

-- Test 19: statement (line 97)
INSERT INTO t0 VALUES (0),(1),(2);

-- Test 20: statement (line 105)
create function get_min_t0() RETURNS INT LANGUAGE SQL AS $$ SELECT c0 FROM t0 ORDER BY c0 LIMIT 1; $$;

CREATE VIEW v0 AS SELECT * FROM t0;

-- Test 21: query (line 108)
SELECT * FROM v0 ORDER BY c0;

-- Test 22: query (line 115)
SELECT get_min_t0();

-- Test 23: statement (line 120)
ALTER TABLE t0 SET (autovacuum_enabled = false);

-- Test 24: statement (line 124)
TRUNCATE TABLE t0;

-- Test 25: statement (line 127)
ALTER TABLE t0 RESET (autovacuum_enabled);

-- Test 26: query (line 130)
SELECT * FROM v0 ORDER BY c0;

-- Test 27: query (line 134)
SELECT get_min_t0();

-- Test 28: statement (line 140)
ALTER TABLE t0 DROP CONSTRAINT t0_c0_key;

-- Test 29: statement (line 143)
DROP INDEX IF EXISTS t0_c0_key CASCADE;

-- Test 30: statement (line 147)
SELECT * FROM v0;

-- Test 31: statement (line 151)
SELECT get_min_t0();

-- Test 32: statement (line 154)
DROP TABLE t0 CASCADE;

-- Test 33: statement (line 159)
CREATE TABLE tt AS SELECT 'foo';

-- Test 34: statement (line 162)
SET enable_seqscan = off;

-- Test 35: query (line 165)
EXPLAIN (COSTS OFF) DELETE FROM tt;

-- Test 36: statement (line 172)
RESET enable_seqscan;

-- Test 37: query (line 176)
SELECT * FROM tt;

-- Test 38: statement (line 184)
CREATE TABLE t (
  x INT,
  y INT,
  z INT
);
CREATE INDEX i1 ON t (x);
CREATE INDEX i2 ON t (y);
CREATE INDEX i3 ON t (z);
COMMENT ON COLUMN t.x IS '''hi''); DROP TABLE t;';
COMMENT ON COLUMN t.z IS 'comm"en"t2';
COMMENT ON INDEX i2 IS 'comm''ent3';

-- Test 39: statement (line 197)
TRUNCATE t;

-- Test 40: query (line 200)
SELECT
  a.attname AS column_name,
  pgd.description AS comment
FROM pg_catalog.pg_attribute a
JOIN pg_catalog.pg_class c ON c.oid = a.attrelid
JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
LEFT JOIN pg_catalog.pg_description pgd
  ON pgd.objoid = a.attrelid
  AND pgd.objsubid = a.attnum
WHERE c.relname = 't'
  AND n.nspname = 'public'
  AND a.attnum > 0
  AND NOT a.attisdropped
ORDER BY column_name;

-- Test 41: query (line 209)
SELECT
  c2.relname AS index_name,
  d.description AS comment
FROM pg_catalog.pg_class c
JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
JOIN pg_catalog.pg_index i ON i.indrelid = c.oid
JOIN pg_catalog.pg_class c2 ON c2.oid = i.indexrelid
LEFT JOIN pg_catalog.pg_description d ON d.objoid = c2.oid AND d.objsubid = 0
WHERE c.relname = 't'
  AND n.nspname = 'public'
ORDER BY index_name;

-- Test 42: statement (line 219)
DROP TABLE t;

-- Test 43: statement (line 222)
CREATE TABLE t (x INT, y INT, z INT);

-- Test 44: statement (line 225)
ALTER TABLE t DROP COLUMN y;

-- Test 45: statement (line 228)
ALTER TABLE t ADD COLUMN y INT;

-- Test 46: statement (line 231)
ALTER TABLE t DROP COLUMN y;

-- Test 47: statement (line 234)
ALTER TABLE t ADD COLUMN y INT;

-- Test 48: statement (line 237)
CREATE INDEX i ON t (x);

-- Test 49: statement (line 240)
DROP INDEX i;

-- Test 50: statement (line 243)
CREATE INDEX i ON t (x);

-- Test 51: statement (line 246)
DROP INDEX i;

-- Test 52: statement (line 249)
CREATE INDEX i ON t (x);

-- Test 53: statement (line 252)
COMMENT ON COLUMN t.y IS 'hello1';
COMMENT ON INDEX i IS 'hello2';

-- Test 54: query (line 256)
SELECT
  a.attname AS column_name,
  pgd.description AS comment
FROM pg_catalog.pg_attribute a
JOIN pg_catalog.pg_class c ON c.oid = a.attrelid
JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
LEFT JOIN pg_catalog.pg_description pgd
  ON pgd.objoid = a.attrelid
  AND pgd.objsubid = a.attnum
WHERE c.relname = 't'
  AND n.nspname = 'public'
  AND a.attnum > 0
  AND NOT a.attisdropped
ORDER BY column_name;

-- Test 55: query (line 264)
SELECT
  c2.relname AS index_name,
  d.description AS comment
FROM pg_catalog.pg_class c
JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
JOIN pg_catalog.pg_index i ON i.indrelid = c.oid
JOIN pg_catalog.pg_class c2 ON c2.oid = i.indexrelid
LEFT JOIN pg_catalog.pg_description d ON d.objoid = c2.oid AND d.objsubid = 0
WHERE c.relname = 't'
  AND n.nspname = 'public'
ORDER BY index_name;
