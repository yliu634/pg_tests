-- PostgreSQL compatible tests from truncate
-- Reduced subset: remove CockroachDB table hints, schema_locked settings, and
-- CRDB SHOW ... output. Focus on PostgreSQL TRUNCATE behavior.

SET client_min_messages = warning;
DROP VIEW IF EXISTS kview;
DROP TABLE IF EXISTS kv CASCADE;
DROP TABLE IF EXISTS selfref CASCADE;
DROP TABLE IF EXISTS tt CASCADE;
DROP TABLE IF EXISTS t CASCADE;
RESET client_min_messages;

CREATE TABLE kv (
  k INT PRIMARY KEY,
  v INT
);

INSERT INTO kv VALUES (1, 2), (3, 4), (5, 6), (7, 8);

CREATE VIEW kview AS SELECT k, v FROM kv;

SELECT * FROM kview ORDER BY k;

TRUNCATE TABLE kv;

SELECT * FROM kv;
SELECT * FROM kview;

-- Self-referential FK + TRUNCATE.
CREATE TABLE selfref (
  y INT PRIMARY KEY,
  z INT REFERENCES selfref(y)
);

INSERT INTO selfref VALUES (1, NULL);
TRUNCATE TABLE selfref;
SELECT * FROM selfref;

-- EXPLAIN TRUNCATE.
CREATE TABLE tt AS SELECT 'foo'::text AS x;
-- PostgreSQL does not support EXPLAIN TRUNCATE; keep the TRUNCATE itself.
TRUNCATE TABLE tt;
SELECT * FROM tt;

-- Comments survive TRUNCATE.
CREATE TABLE t (x INT, y INT, z INT);
CREATE INDEX i2 ON t(y);

COMMENT ON COLUMN t.x IS $$'hi'); DROP TABLE t;$$;
COMMENT ON COLUMN t.z IS $$comm"en"t2$$;
COMMENT ON INDEX i2 IS $$comm'ent3$$;

TRUNCATE TABLE t;

SELECT attname AS column_name, col_description('t'::regclass, attnum) AS comment
FROM pg_attribute
WHERE attrelid = 't'::regclass AND attnum > 0 AND NOT attisdropped
ORDER BY attnum;

SELECT obj_description('i2'::regclass, 'pg_class') AS index_comment;
