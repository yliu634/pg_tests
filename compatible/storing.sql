-- PostgreSQL compatible tests from storing
-- 39 tests

SET client_min_messages = warning;
DROP TABLE IF EXISTS t CASCADE;
DROP TABLE IF EXISTS t30984 CASCADE;
DROP TABLE IF EXISTS t30984_u CASCADE;
DROP TABLE IF EXISTS t30984_pk CASCADE;
DROP TABLE IF EXISTS t14601 CASCADE;
DROP TABLE IF EXISTS t14601a CASCADE;
DROP TABLE IF EXISTS a CASCADE;
RESET client_min_messages;

-- Test 1: statement (line 1)
CREATE TABLE t (
  a INT PRIMARY KEY,
  b INT,
  c INT,
  d INT
);

-- CockroachDB STORING -> PostgreSQL INCLUDE, and inline index definitions are
-- expressed as separate CREATE INDEX statements.
CREATE INDEX b_idx ON t (b) INCLUDE (c, d);
CREATE UNIQUE INDEX c_idx ON t (c) INCLUDE (b, d);

-- Test 2: query (line 11)
SELECT indexname, indexdef
FROM pg_indexes
WHERE schemaname = 'public' AND tablename = 't'
ORDER BY indexname;

-- Test 3: statement (line 28)
INSERT INTO t VALUES (1, 2, 3, 4);

-- Test 4: query (line 31)
SELECT a, b, c, d FROM t ORDER BY a;

-- Test 5: query (line 36)
SELECT a, b, c, d FROM t ORDER BY a;

-- Test 6: statement (line 43)
CREATE INDEX d_idx ON t (d) INCLUDE (b);

-- Test 7: query (line 46)
SELECT a, b, d FROM t ORDER BY a;

-- Test 8: statement (line 51)
-- CockroachDB validates STORING rules differently; avoid deliberate errors in PG.
-- CREATE INDEX error ON t (d) INCLUDE (d);

-- Test 9: statement (line 54)
-- CREATE INDEX error ON t (d) INCLUDE (a);

-- Test 10: statement (line 57)
CREATE TABLE t30984 (
  a INT PRIMARY KEY,
  b INT,
  c INT
);
CREATE INDEX b_idx_t30984 ON t30984 (b) INCLUDE (c, a);

-- Test 11: statement (line 65)
CREATE TABLE t30984_u (
  a INT PRIMARY KEY,
  b INT,
  c INT
);
CREATE UNIQUE INDEX b_idx_t30984_u ON t30984_u (b) INCLUDE (c, a);

-- Test 12: statement (line 73)
CREATE TABLE t30984_pk (
  a INT,
  b INT,
  c INT,
  d INT,
  PRIMARY KEY (a, d),
  UNIQUE (b)
);
CREATE UNIQUE INDEX b_idx_t30984_pk ON t30984_pk (b) INCLUDE (c, d);

-- Test 13: statement (line 83)
CREATE UNIQUE INDEX a_idx ON t (a) INCLUDE (b);

-- Test 14: statement (line 91)
CREATE TABLE t14601 (a TEXT PRIMARY KEY, b BOOL);
CREATE INDEX i14601 ON t14601 (a) INCLUDE (b);

-- Test 15: statement (line 94)
INSERT INTO t14601 VALUES
  ('a', FALSE),
  ('b', FALSE),
  ('c', FALSE)
;

-- Test 16: statement (line 100)
DELETE FROM t14601 WHERE a > 'a' AND a < 'c';

-- Test 17: query (line 103)
SELECT a FROM t14601 ORDER BY a;

-- Test 18: statement (line 109)
DROP INDEX i14601;

-- Test 19: query (line 112)
SELECT a FROM t14601 ORDER BY a;

-- Test 20: statement (line 130)
CREATE TABLE t14601a (a TEXT PRIMARY KEY, b BOOL, c INT);
CREATE INDEX i14601a ON t14601a (a) INCLUDE (b, c);

-- Test 21: statement (line 133)
INSERT INTO t14601a VALUES
  ('a', FALSE, 1),
  ('b', TRUE, 2),
  ('c', FALSE, 3)
;

-- Test 22: statement (line 139)
UPDATE t14601a SET b = NOT b WHERE a > 'a' AND a < 'c';

-- Test 23: query (line 142)
SELECT a, b FROM t14601a ORDER BY a;

-- Test 24: statement (line 149)
DROP INDEX i14601a;

-- Test 25: query (line 152)
SELECT a, b FROM t14601a ORDER BY a;

-- Test 26: statement (line 159)
DELETE FROM t14601a;

-- Test 27: statement (line 162)
CREATE UNIQUE INDEX i14601a ON t14601a (a) INCLUDE (b);

-- Test 28: statement (line 165)
INSERT INTO t14601a (a, b) VALUES
  ('a', FALSE),
  ('b', TRUE),
  ('c', FALSE)
;

-- Test 29: statement (line 171)
UPDATE t14601a SET b = NOT b WHERE a > 'a' AND a < 'c';

-- Test 30: query (line 174)
SELECT a, b FROM t14601a ORDER BY a;

-- Test 31: statement (line 181)
DROP INDEX i14601a CASCADE;

-- Test 32: query (line 184)
SELECT a, b FROM t14601a ORDER BY a;

-- Test 33: statement (line 192)
INSERT INTO t (a) VALUES (2);

-- Test 34: statement (line 195)
INSERT INTO t (a) VALUES (3);

-- Test 35: statement (line 201)
CREATE TABLE a(a INT, b INT, c INT, PRIMARY KEY(a, b));

-- Test 36: statement (line 204)
CREATE UNIQUE INDEX foo ON a(a) INCLUDE (c);

-- Test 37: statement (line 207)
INSERT INTO a VALUES(1,2,3);

-- Test 38: statement (line 210)
CREATE UNIQUE INDEX ON a(a) INCLUDE (c);

-- Test 39: query (line 213)
SELECT * FROM a ORDER BY a, b;
