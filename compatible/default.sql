-- PostgreSQL compatible tests from default
-- 34 tests

SET client_min_messages = warning;

-- Test 1: statement (line 1)
\set ON_ERROR_STOP 0
CREATE TABLE t (a INT PRIMARY KEY DEFAULT false);
\set ON_ERROR_STOP 1

-- Test 2: statement (line 4)
\set ON_ERROR_STOP 0
CREATE TABLE t (a INT PRIMARY KEY DEFAULT (SELECT 1));
\set ON_ERROR_STOP 1

-- Test 3: statement (line 7)
\set ON_ERROR_STOP 0
CREATE TABLE t (a INT PRIMARY KEY DEFAULT b);
\set ON_ERROR_STOP 1

-- Test 4: statement (line 11)
DROP TABLE IF EXISTS null_default;
CREATE TABLE null_default (ts TIMESTAMP PRIMARY KEY NULL DEFAULT NULL);

-- Test 5: statement (line 15)
\set ON_ERROR_STOP 0
CREATE TABLE bad (a INT DEFAULT count(1));
\set ON_ERROR_STOP 1

-- Test 6: statement (line 19)
\set ON_ERROR_STOP 0
CREATE TABLE bad (a INT DEFAULT count(1) OVER ());
\set ON_ERROR_STOP 1

-- Test 7: statement (line 22)
DROP TABLE IF EXISTS t;
CREATE TABLE t (
  a INT PRIMARY KEY DEFAULT 42,
  b TIMESTAMP DEFAULT now(),
  c FLOAT DEFAULT random(),
  d DATE DEFAULT now()
);

-- Test 8: query (line 30)
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name = 't'
ORDER BY ordinal_position;

-- Test 9: statement (line 39)
COMMENT ON COLUMN t.a IS 'a';

-- Test 10: query (line 42)
SELECT c.column_name,
       c.data_type,
       c.is_nullable,
       c.column_default,
       col_description('t'::regclass, c.ordinal_position) AS comment
FROM information_schema.columns AS c
WHERE c.table_schema = 'public'
  AND c.table_name = 't'
ORDER BY c.ordinal_position;

-- Test 11: statement (line 51)
INSERT INTO t VALUES (DEFAULT, DEFAULT, DEFAULT, DEFAULT);

-- Test 12: query (line 54)
SELECT a, b <= now(), c >= 0.0, d <= now() FROM t;

-- Test 13: statement (line 60)
-- CockroachDB-only table setting.
-- ALTER TABLE t SET (schema_locked=false);

-- Test 14: statement (line 63)
TRUNCATE TABLE t;

-- Test 15: statement (line 66)
-- CockroachDB-only table setting.
-- ALTER TABLE t RESET (schema_locked);

-- Test 16: statement (line 69)
INSERT INTO t DEFAULT VALUES;

-- Test 17: query (line 72)
SELECT a, b <= now(), c >= 0.0, d <= now() FROM t;

-- Test 18: statement (line 77)
INSERT INTO t (a) VALUES (1);

-- Test 19: query (line 80)
SELECT a, b <= now(), c >= 0.0, d <= now() FROM t WHERE a = 1;

-- Test 20: statement (line 85)
INSERT INTO t (a) VALUES (2);

-- Test 21: query (line 88)
SELECT a, b <= now(), c >= 0.0, d <= now() FROM t WHERE a = 2;

-- Test 22: statement (line 93)
UPDATE t SET (b, c) = ('2015-09-18 00:00:00', -1.0);

-- Test 23: statement (line 96)
UPDATE t SET b = DEFAULT WHERE a = 1;

-- Test 24: query (line 99)
SELECT a, b <= now(), c = -1.0, d <= now() FROM t WHERE a = 1;

-- Test 25: statement (line 104)
UPDATE t SET (b, c) = (DEFAULT, DEFAULT) WHERE a = 2;

-- Test 26: query (line 107)
SELECT a, b <= now(), c >= 0.0, d <= now() FROM t WHERE a = 2;

-- Test 27: statement (line 112)
UPDATE t SET b = DEFAULT, c = DEFAULT, d = DEFAULT;

-- Test 28: statement (line 115)
UPDATE t SET (b, c, d) = (DEFAULT, DEFAULT, DEFAULT);

-- Test 29: statement (line 119)
DROP TABLE IF EXISTS v;
CREATE TABLE v (
  a INT PRIMARY KEY,
  b TIMESTAMP NULL DEFAULT NULL,
  c INT
);

-- Test 30: statement (line 126)
UPDATE v SET a = DEFAULT;

-- Test 31: statement (line 129)
UPDATE v SET (a, c) = (DEFAULT, DEFAULT);

-- Test 32: query (line 132)
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name = 'v'
ORDER BY ordinal_position;

-- Test 33: statement (line 145)
DROP TABLE IF EXISTS t34901;
CREATE TABLE t34901 (a TEXT);
INSERT INTO t34901 VALUES ('a');

-- Test 34: query (line 151)
SELECT * FROM t34901;

RESET client_min_messages;
