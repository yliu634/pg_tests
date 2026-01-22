-- PostgreSQL compatible tests from multi_statement
-- 14 tests

SET client_min_messages = warning;

-- Test 1: statement (line 6)
CREATE TABLE kv (
  k CHAR PRIMARY KEY,
  v CHAR
);

-- Test 2: query (line 12)
SELECT * FROM kv ORDER BY k;

-- Test 3: statement (line 16)
INSERT INTO kv (k,v) VALUES ('a', 'b'); INSERT INTO kv (k,v) VALUES ('c', 'd');

-- Test 4: query (line 19)
SELECT * FROM kv ORDER BY k;

-- Test 5: statement (line 27)
INSERT INTO kv (k,v) VALUES ('a', 'b') ON CONFLICT (k) DO NOTHING;
INSERT INTO kv (k,v) VALUES ('e', 'f');

-- Test 6: query (line 30)
SELECT * FROM kv ORDER BY k;

-- Test 7: statement (line 37)
INSERT INTO kv (k,v) VALUES ('g', 'h');
INSERT INTO kv (k,v) VALUES ('a', 'b') ON CONFLICT (k) DO NOTHING;

-- Test 8: query (line 40)
SELECT * FROM kv ORDER BY k;

-- Test 9: statement (line 47)
INSERT INTO kv (k,v) VALUES ('i', 'j'); INSERT INTO kv (k,v) VALUES ('k', 'l');

-- Test 10: query (line 50)
SELECT * FROM kv ORDER BY k;

-- Test 11: statement (line 56)
CREATE SCHEMA IF NOT EXISTS x;
CREATE TABLE IF NOT EXISTS x.y(a INT);
BEGIN; INSERT INTO x.y(a) VALUES (1); END;

-- Test 12: statement (line 59)
SELECT * FROM kv ORDER BY k; ROLLBACK;

-- Test 13: statement (line 62)
ROLLBACK;

-- Test 14: statement (line 65)
CREATE TABLE t(a INT);
BEGIN TRANSACTION; SELECT * FROM t ORDER BY a; INSERT INTO t(a) VALUES (1); COMMIT;
SELECT * FROM t ORDER BY a;

RESET client_min_messages;
