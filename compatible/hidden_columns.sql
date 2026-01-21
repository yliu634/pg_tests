-- PostgreSQL compatible tests from hidden_columns
-- 26 tests

SET client_min_messages = warning;
DROP TABLE IF EXISTS t6, t5, t4, t3, t2, t1, kv, t CASCADE;

-- Test 1: statement (line 1)
-- CockroachDB `NOT VISIBLE` (hidden columns) is not supported in PostgreSQL.
-- For PostgreSQL, treat hidden columns as normal columns.
CREATE TABLE t (x INT);

-- Test 2: statement (line 4)
CREATE TABLE kv (
    k INT PRIMARY KEY,
    v INT
  );

-- Test 3: statement (line 12)
INSERT INTO t(x) VALUES (123);

-- Test 4: statement (line 15)
INSERT INTO kv(k,v) VALUES (123,456);

-- Test 5: statement (line 20)
INSERT INTO t VALUES (123);

-- Test 6: statement (line 23)
INSERT INTO kv VALUES (111, 222);

-- Test 7: query (line 29)
-- PostgreSQL does not support `SHOW CREATE TABLE`; introspect via information_schema.
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name = 't'
ORDER BY ordinal_position;

-- Test 8: query (line 39)
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name = 't'
ORDER BY ordinal_position;

-- Test 9: query (line 50)
SELECT 42, * FROM t;

-- Test 10: query (line 55)
SELECT 42, * FROM kv;

-- Test 11: query (line 62)
SELECT 42, x FROM t;

-- Test 12: statement (line 69)
ALTER TABLE kv RENAME COLUMN v to x;

-- Test 13: query (line 72)
SELECT x FROM t;

-- Test 14: statement (line 79)
CREATE INDEX ON kv(x);

-- Test 15: statement (line 84)
ALTER TABLE kv DROP COLUMN x;

-- Test 16: statement (line 87)
-- Expected ERROR after dropping the column.
\set ON_ERROR_STOP 0
SELECT x FROM kv;
\set ON_ERROR_STOP 1

-- Test 17: statement (line 92)
CREATE TABLE t1(
  a INT,
  b INT,
  c INT,
  CONSTRAINT t1_pkey PRIMARY KEY (b)
);
CREATE TABLE t2(
  b INT,
  c INT,
  d INT,
  CONSTRAINT t2_pkey PRIMARY KEY (d)
);
CREATE TABLE t5(
  b INT,
  c INT,
  d INT,
  CONSTRAINT t5_pkey PRIMARY KEY (d),
  CONSTRAINT t5_b_fkey FOREIGN KEY (b) REFERENCES t1(b)
);

-- Test 18: query (line 97)
SELECT tc.constraint_name, tc.constraint_type, kcu.column_name
FROM information_schema.table_constraints AS tc
LEFT JOIN information_schema.key_column_usage AS kcu
  ON tc.constraint_schema = kcu.constraint_schema
 AND tc.constraint_name = kcu.constraint_name
WHERE tc.table_schema = 'public'
  AND tc.table_name = 't2'
  AND tc.constraint_type <> 'CHECK'
ORDER BY tc.constraint_name, kcu.ordinal_position;

-- Test 19: statement (line 102)
-- PostgreSQL requires an explicit referenced column list.
ALTER TABLE t2 ADD FOREIGN KEY (b) REFERENCES t2(d);

-- Test 20: query (line 105)
SELECT
  tc.constraint_name,
  tc.constraint_type,
  kcu.column_name,
  ccu.table_name AS foreign_table_name,
  ccu.column_name AS foreign_column_name
FROM information_schema.table_constraints AS tc
LEFT JOIN information_schema.key_column_usage AS kcu
  ON tc.constraint_schema = kcu.constraint_schema
 AND tc.constraint_name = kcu.constraint_name
LEFT JOIN information_schema.referential_constraints AS rc
  ON tc.constraint_schema = rc.constraint_schema
 AND tc.constraint_name = rc.constraint_name
LEFT JOIN information_schema.constraint_column_usage AS ccu
  ON rc.unique_constraint_schema = ccu.constraint_schema
 AND rc.unique_constraint_name = ccu.constraint_name
WHERE tc.table_schema = 'public'
  AND tc.table_name = 't2'
  AND tc.constraint_type <> 'CHECK'
ORDER BY tc.constraint_name, kcu.ordinal_position;

-- Test 21: statement (line 113)
CREATE TABLE t3(
  a INT,
  b INT NOT NULL,
  c INT,
  CONSTRAINT t3_pkey PRIMARY KEY (c)
);
CREATE TABLE t4(
  c INT,
  d INT,
  e INT NOT NULL,
  CONSTRAINT t4_pkey PRIMARY KEY (d)
);
CREATE TABLE t6(
  c INT,
  d INT,
  e INT NOT NULL,
  CONSTRAINT t6_pkey PRIMARY KEY (d),
  CONSTRAINT t6_c_fkey FOREIGN KEY (c) REFERENCES t3(c)
);

-- Test 22: statement (line 120)
-- CockroachDB `ALTER PRIMARY KEY USING COLUMNS(...)` is not supported in PG.
-- Approximate by changing the PK to (b) while preserving uniqueness on (c)
-- so existing FKs keep working.
ALTER TABLE t6 DROP CONSTRAINT t6_c_fkey;
ALTER TABLE t3 DROP CONSTRAINT t3_pkey;
ALTER TABLE t3 ADD CONSTRAINT t3_c_key UNIQUE (c);
ALTER TABLE t3 ADD CONSTRAINT t3_pkey PRIMARY KEY (b);
ALTER TABLE t6 ADD CONSTRAINT t6_c_fkey FOREIGN KEY (c) REFERENCES t3(c);

-- Test 23: query (line 123)
SELECT
  tc.constraint_name,
  tc.constraint_type,
  kcu.column_name,
  ccu.table_name AS foreign_table_name,
  ccu.column_name AS foreign_column_name
FROM information_schema.table_constraints AS tc
LEFT JOIN information_schema.key_column_usage AS kcu
  ON tc.constraint_schema = kcu.constraint_schema
 AND tc.constraint_name = kcu.constraint_name
LEFT JOIN information_schema.referential_constraints AS rc
  ON tc.constraint_schema = rc.constraint_schema
 AND tc.constraint_name = rc.constraint_name
LEFT JOIN information_schema.constraint_column_usage AS ccu
  ON rc.unique_constraint_schema = ccu.constraint_schema
 AND rc.unique_constraint_name = ccu.constraint_name
WHERE tc.table_schema = 'public'
  AND tc.table_name = 't3'
  AND tc.constraint_type <> 'CHECK'
ORDER BY tc.constraint_name, kcu.ordinal_position;

-- Test 24: query (line 129)
SELECT
  tc.constraint_name,
  tc.constraint_type,
  kcu.column_name,
  ccu.table_name AS foreign_table_name,
  ccu.column_name AS foreign_column_name
FROM information_schema.table_constraints AS tc
LEFT JOIN information_schema.key_column_usage AS kcu
  ON tc.constraint_schema = kcu.constraint_schema
 AND tc.constraint_name = kcu.constraint_name
LEFT JOIN information_schema.referential_constraints AS rc
  ON tc.constraint_schema = rc.constraint_schema
 AND tc.constraint_name = rc.constraint_name
LEFT JOIN information_schema.constraint_column_usage AS ccu
  ON rc.unique_constraint_schema = ccu.constraint_schema
 AND rc.unique_constraint_name = ccu.constraint_name
WHERE tc.table_schema = 'public'
  AND tc.table_name = 't4'
  AND tc.constraint_type <> 'CHECK'
ORDER BY tc.constraint_name, kcu.ordinal_position;

-- Test 25: statement (line 134)
ALTER TABLE t4 DROP CONSTRAINT t4_pkey;
ALTER TABLE t4 ADD CONSTRAINT t4_d_key UNIQUE (d);
ALTER TABLE t4 ADD CONSTRAINT t4_pkey PRIMARY KEY (e);

-- Test 26: query (line 137)
SELECT
  tc.constraint_name,
  tc.constraint_type,
  kcu.column_name,
  ccu.table_name AS foreign_table_name,
  ccu.column_name AS foreign_column_name
FROM information_schema.table_constraints AS tc
LEFT JOIN information_schema.key_column_usage AS kcu
  ON tc.constraint_schema = kcu.constraint_schema
 AND tc.constraint_name = kcu.constraint_name
LEFT JOIN information_schema.referential_constraints AS rc
  ON tc.constraint_schema = rc.constraint_schema
 AND tc.constraint_name = rc.constraint_name
LEFT JOIN information_schema.constraint_column_usage AS ccu
  ON rc.unique_constraint_schema = ccu.constraint_schema
 AND rc.unique_constraint_name = ccu.constraint_name
WHERE tc.table_schema = 'public'
  AND tc.table_name = 't4'
  AND tc.constraint_type <> 'CHECK'
ORDER BY tc.constraint_name, kcu.ordinal_position;

RESET client_min_messages;
