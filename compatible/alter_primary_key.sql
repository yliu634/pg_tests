-- PostgreSQL compatible tests from alter_primary_key
-- 427 tests

SET client_min_messages = warning;

-- PostgreSQL does not support CockroachDB's `ALTER PRIMARY KEY USING COLUMNS`.
-- Use DROP CONSTRAINT / ADD PRIMARY KEY to exercise similar behavior.

-- Isolate objects for easy cleanup and deterministic re-runs.
DROP SCHEMA IF EXISTS alter_primary_key CASCADE;
CREATE SCHEMA alter_primary_key;
SET search_path = alter_primary_key, public;

-- Test 1: statement
CREATE TABLE t (
  x INT PRIMARY KEY,
  y INT NOT NULL,
  z INT NOT NULL,
  w INT
);

-- Test 2: statement
INSERT INTO t VALUES (1, 2, 3, 4), (5, 6, 7, 8);

-- Test 3: query
SELECT * FROM t ORDER BY x;

-- Test 4: statement
ALTER TABLE t DROP CONSTRAINT t_pkey;
ALTER TABLE t ADD PRIMARY KEY (y, z);

-- Test 5: query
SELECT * FROM t ORDER BY y, z;

-- Test 6: statement
INSERT INTO t VALUES (9, 10, 11, 12);

-- Test 7: statement
UPDATE t SET x = 2 WHERE z = 7;

-- Test 8: query
SELECT * FROM t ORDER BY y, z;

-- Test 9: query
SELECT conname,
       pg_get_constraintdef(oid) AS def
FROM pg_constraint
WHERE conrelid = 't'::regclass AND contype = 'p'
ORDER BY conname;

-- Test 10: statement
ALTER TABLE t ADD COLUMN rowid BIGINT GENERATED ALWAYS AS IDENTITY;
ALTER TABLE t DROP CONSTRAINT t_pkey;
ALTER TABLE t ADD PRIMARY KEY (rowid);

-- Test 11: query
SELECT rowid, x, y, z, w FROM t ORDER BY rowid;

-- Test 12: statement
CREATE TABLE t_composite (x INT PRIMARY KEY, y NUMERIC NOT NULL);

-- Test 13: statement
INSERT INTO t_composite VALUES (1, 1.0), (2, 1.001);

-- Test 14: statement
ALTER TABLE t_composite DROP CONSTRAINT t_composite_pkey;
ALTER TABLE t_composite ADD PRIMARY KEY (y);

-- Test 15: query
SELECT * FROM t_composite ORDER BY y;

-- Test 16: statement
CREATE TABLE fk2 (x INT PRIMARY KEY);
CREATE TABLE fk1 (x INT NOT NULL);
ALTER TABLE fk1 ADD CONSTRAINT fk FOREIGN KEY (x) REFERENCES fk2(x);

-- Test 17: statement
INSERT INTO fk2 VALUES (1), (2), (3);
INSERT INTO fk1 VALUES (1), (2), (3);

-- Test 18: statement
-- Mimic an "alter primary key" that requires rebuilding dependent FKs.
ALTER TABLE fk2 DROP CONSTRAINT fk2_pkey CASCADE;
ALTER TABLE fk2 ADD PRIMARY KEY (x);
ALTER TABLE fk1 ADD CONSTRAINT fk FOREIGN KEY (x) REFERENCES fk2(x);

-- Test 19: query
SELECT conrelid::regclass AS table_name,
       conname,
       pg_get_constraintdef(oid) AS def
FROM pg_constraint
WHERE conrelid IN ('fk1'::regclass, 'fk2'::regclass)
ORDER BY conrelid::regclass::text, conname;

-- Cleanup.
RESET search_path;
DROP SCHEMA IF EXISTS alter_primary_key CASCADE;

RESET client_min_messages;
