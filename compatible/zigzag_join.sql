-- PostgreSQL compatible tests from zigzag_join
-- 76 tests

SET client_min_messages = warning;

-- PostgreSQL setup: CockroachDB zigzag join + index hint syntax doesn't exist in PostgreSQL.
-- Provide minimal schema/data so the queries can run end-to-end and deterministically.
CREATE TABLE a (
  n INT PRIMARY KEY,
  a INT,
  b INT,
  c TEXT
);

INSERT INTO a (n, a, b, c) VALUES
  (1, 4, 1, 'bar'),
  (2, 4, 2, 'bar'),
  (3, 5, 2, 'foo'),
  (4, 2, 1, 'baz'),
  (5, 3, 7, 'foo');

-- Pre-create indexes referenced later in the test.
CREATE INDEX a_idx ON a(a);
CREATE INDEX b_idx ON a(b);

-- Test 1: query (line 11)
SELECT n,a,b FROM a WHERE a = 4 AND b = 1 ORDER BY n;

-- Test 2: query (line 16)
SELECT n,a,b FROM a WHERE a = 5 AND b = 2 ORDER BY n;

-- Test 3: query (line 21)
SELECT * FROM a WHERE a = 4 AND b = 1 ORDER BY n;

-- Test 4: query (line 26)
SELECT * FROM a WHERE a = 4 AND b = 2 ORDER BY n;

-- Test 5: query (line 30)
SELECT * FROM a WHERE a = 5 AND b = 2 AND c = 'foo' ORDER BY n;

-- Test 6: query (line 37)
-- CockroachDB-only table hint: a@{NO_ZIGZAG_JOIN}
SELECT n,a,b FROM a WHERE a = 4 AND b = 1 ORDER BY n;

-- Test 7: statement (line 42)
-- CockroachDB-only: SET enable_zigzag_join = false;

-- Test 8: query (line 45)
SELECT n,a,b FROM a WHERE a = 4 AND b = 1 ORDER BY n;

-- Test 9: query (line 50)
SELECT n,a,b FROM a WHERE a = 5 AND b = 2 ORDER BY n;

-- Test 10: statement (line 55)
-- CockroachDB-only: SET enable_zigzag_join = true;

-- Test 11: statement (line 59)
DROP INDEX IF EXISTS a_idx;
DROP INDEX IF EXISTS b_idx;

-- Test 12: statement (line 63)
CREATE INDEX c_idx ON a(c);
CREATE INDEX a_idx ON a(a);
CREATE INDEX b_idx ON a(b);

-- Test 13: statement (line 68)
SELECT n,a,b FROM a WHERE a = 4 AND b = 1 ORDER BY n;

-- Test 14: statement (line 73)
SELECT n
FROM a
WHERE b = 1
  AND (((a < 1) AND (a > 1)) OR (a >= 2 AND a <= 2))
ORDER BY n;

-- Test 15: statement (line 78)
CREATE TABLE t71655 (
  k INT PRIMARY KEY,
  a INT,
  b INT,
  c INT,
  d INT NOT NULL
);
CREATE INDEX t71655_ac_idx ON t71655 (a, c);
CREATE INDEX t71655_bc_idx ON t71655 (b, c);
INSERT INTO t71655 VALUES (1, 10, 20, NULL, 11);
INSERT INTO t71655 VALUES (2, 10, 20, NULL, 12);

-- Test 16: query (line 93)
SELECT k FROM t71655 WHERE a = 10 AND b = 20 ORDER BY k;

-- Test 17: statement (line 99)
CREATE INDEX ad ON t71655 (a, d);
CREATE INDEX bd ON t71655 (b, d);

-- Test 18: query (line 105)
SELECT k FROM t71655 WHERE a = 10 AND b = 20 ORDER BY k;

-- Test 19: statement (line 115)
CREATE TABLE d (
  a INT PRIMARY KEY,
  b JSONB
);

-- Test 20: statement (line 121)
-- CockroachDB inverted index on JSONB ≈ PostgreSQL GIN index.
CREATE INDEX foo_inv ON d USING gin (b);

-- Test 21: statement (line 124)
SELECT indexname
FROM pg_indexes
WHERE schemaname = current_schema()
  AND tablename = 'd'
ORDER BY indexname;

-- Test 22: statement (line 127)
INSERT INTO d VALUES (1, '{"a": "b"}');

-- Test 23: statement (line 130)
INSERT INTO d VALUES (2, '[1,2,3,4, "foo"]');

-- Test 24: statement (line 133)
INSERT INTO d VALUES (3, '{"a": {"b": "c"}}');

-- Test 25: statement (line 136)
INSERT INTO d VALUES (4, '{"a": {"b": [1]}}');

-- Test 26: statement (line 139)
INSERT INTO d VALUES (5, '{"a": {"b": [1, [2]]}}');

-- Test 27: statement (line 142)
INSERT INTO d VALUES (6, '{"a": {"b": [[2]]}}');

-- Test 28: statement (line 145)
INSERT INTO d VALUES (7, '{"a": "b", "c": "d"}');

-- Test 29: statement (line 148)
INSERT INTO d VALUES (8, '{"a": {"b":true}}');

-- Test 30: statement (line 151)
INSERT INTO d VALUES (9, '{"a": {"b":false}}');

-- Test 31: statement (line 154)
INSERT INTO d VALUES (10, '"a"');

-- Test 32: statement (line 157)
INSERT INTO d VALUES (11, 'null');

-- Test 33: statement (line 160)
INSERT INTO d VALUES (12, 'true');

-- Test 34: statement (line 163)
INSERT INTO d VALUES (13, 'false');

-- Test 35: statement (line 166)
INSERT INTO d VALUES (14, '1');

-- Test 36: statement (line 169)
INSERT INTO d VALUES (15, '1.23');

-- Test 37: statement (line 172)
INSERT INTO d VALUES (16, '[{"a": {"b": [1, [2]]}}, "d"]');

-- Test 38: statement (line 175)
INSERT INTO d VALUES (17, '{}');

-- Test 39: statement (line 178)
INSERT INTO d VALUES (18, '[]');

-- Test 40: statement (line 181)
INSERT INTO d VALUES (29, NULL);

-- Test 41: statement (line 184)
INSERT INTO d VALUES (30, '{"a": []}');

-- Test 42: statement (line 187)
INSERT INTO d VALUES (31, '{"a": {"b": "c", "d": "e"}, "f": "g"}');

-- Test 43: statement (line 190)
ANALYZE d;

-- Test 44: query (line 195)
SELECT * from d where b @> '{"a": {"b": "c"}, "f": "g"}' ORDER BY a;

-- Test 45: query (line 200)
SELECT * from d where b @> '{"a": {"b": "c", "d": "e"}, "f": "g"}' ORDER BY a;

-- Test 46: query (line 205)
SELECT * from d where b @> '{"c": "d", "a": "b"}' ORDER BY a;

-- Test 47: query (line 210)
SELECT * from d where b @> '{"c": "d", "a": "b", "f": "g"}' ORDER BY a;

-- Test 48: query (line 214)
SELECT * from d where b @> '{"a": "b", "c": "e"}' ORDER BY a;

-- Test 49: query (line 218)
SELECT * from d where b @> '{"a": "e", "c": "d"}' ORDER BY a;

-- Test 50: query (line 222)
SELECT * from d where b @> '["d", {"a": {"b": [1]}}]' ORDER BY a;

-- Test 51: query (line 227)
SELECT * from d where b @> '["d", {"a": {"b": [[2]]}}]' ORDER BY a;

-- Test 52: query (line 232)
SELECT * from d where b @> '[{"a": {"b": [[2]]}}, "d"]' ORDER BY a;

-- Test 53: statement (line 240)
-- CockroachDB-only table hint: a@{FORCE_ZIGZAG=foo}
SELECT * FROM a WHERE a = 3 AND b = 7 ORDER BY n;

-- Test 54: statement (line 244)
-- CockroachDB-only table hint: a@{FORCE_ZIGZAG=a_idx,FORCE_ZIGZAG=c_idx}
SELECT * FROM a WHERE a = 3 AND b = 7 ORDER BY n;

-- Test 55: statement (line 248)
-- CockroachDB-only table hint: a@{FORCE_ZIGZAG=a_idx,FORCE_ZIGZAG=b_idx}
SELECT * FROM a WHERE a = 3 ORDER BY n;

-- Test 56: statement (line 252)
-- CockroachDB-only table hint: a@{FORCE_ZIGZAG=a_idx,FORCE_ZIGZAG=bc_idx}
SELECT * FROM a WHERE a = 3 AND b = 7 ORDER BY n;

-- Test 57: statement (line 256)
-- CockroachDB-only table hint: a@{FORCE_ZIGZAG}
SELECT * FROM a WHERE a = 3 AND b = 7 ORDER BY n;

-- Test 58: statement (line 260)
-- CockroachDB-only table hint: a@{FORCE_ZIGZAG,FORCE_ZIGZAG=a_idx}
SELECT * FROM a WHERE a = 3 AND b = 7 ORDER BY n;

-- Test 59: statement (line 264)
-- CockroachDB-only table hint: a@{FORCE_ZIGZAG=a_idx,FORCE_ZIGZAG=a_idx}
SELECT * FROM a WHERE a = 3 AND b = 7 ORDER BY n;

-- Test 60: statement (line 268)
-- CockroachDB-only table hint: a@{FORCE_ZIGZAG=a_idx,FORCE_ZIGZAG=b_idx}
SELECT * FROM a WHERE a = 3 AND b = 7 ORDER BY n;

-- Test 61: statement (line 271)
DROP INDEX IF EXISTS c_idx;

-- Test 62: statement (line 275)
-- CockroachDB-only table hint: a@{FORCE_ZIGZAG}
SELECT * FROM a WHERE a = 3 AND c = 'foo' ORDER BY n;

-- Test 63: statement (line 279)
-- CockroachDB-only table hint: a@{FORCE_ZIGZAG=[1],FORCE_ZIGZAG=[1]}
SELECT * FROM a WHERE a = 3 AND b = 7 ORDER BY n;

-- Test 64: query (line 284)
SELECT indexname, indexdef
FROM pg_indexes
WHERE schemaname = current_schema()
  AND tablename = 'a'
ORDER BY indexname;

-- Test 65: statement (line 299)
-- CockroachDB-only table hint: a@{FORCE_ZIGZAG=[7],FORCE_ZIGZAG=[9]}
SELECT * FROM a WHERE a = 3 AND b = 7 ORDER BY n;

-- Test 66: statement (line 303)
-- CockroachDB-only table hint: a@{FORCE_ZIGZAG=[7],FORCE_ZIGZAG=b_idx}
SELECT * FROM a WHERE a = 3 AND b = 7 ORDER BY n;

-- Test 67: statement (line 307)
-- CockroachDB-only table hint: a@{FORCE_ZIGZAG=[7],FORCE_ZIGZAG=a_idx}
SELECT * FROM a WHERE a = 3 AND b = 7 ORDER BY n;

-- Test 68: statement (line 310)
-- CockroachDB-only table hint: a@{FORCE_ZIGZAG,NO_ZIGZAG_JOIN}
SELECT * FROM a WHERE a = 3 AND b = 7 ORDER BY n;

-- Test 69: statement (line 315)
CREATE TABLE t71093 (a INT, b INT, c INT, d INT);
CREATE INDEX t71093_a_idx ON t71093 (a) INCLUDE (b);
CREATE INDEX t71093_c_idx ON t71093 (c) INCLUDE (d);
INSERT INTO t71093 VALUES (0, 1, 2, 3);

-- Test 70: query (line 320)
SELECT count(*) FROM t71093 WHERE a = 0 AND b = 1 AND c = 2;

-- Test 71: query (line 326)
SELECT count(*) FROM t71093 WHERE a = 0 AND c = 2 AND d = 3;

-- Test 72: query (line 332)
SELECT count(*) FROM t71093 WHERE a = 0 AND b = 1 AND c = 2 AND d = 3;

-- Test 73: statement (line 339)
CREATE TABLE t71271(a INT, b INT, c INT, d INT);
CREATE INDEX t71271_c_idx ON t71271 (c);
CREATE INDEX t71271_d_idx ON t71271 (d);
INSERT INTO t71271 VALUES (1, 2, 3, 4);

-- Test 74: statement (line 342)
SELECT d FROM t71271 WHERE c = 3 AND d = 4;

-- Test 75: statement (line 347)
CREATE TABLE t97090 (
  c INT NOT NULL,
  l INT NOT NULL,
  r INT NOT NULL
);
CREATE INDEX t97090_l_c_desc_idx ON t97090 (l ASC, c DESC);
CREATE INDEX t97090_r_c_asc_idx ON t97090 (r ASC, c ASC);
INSERT INTO t97090 VALUES (1, 1, -1), (2, 1, -2);

-- Test 76: query (line 358)
SELECT * FROM t97090 WHERE l = 1 AND r = -1;

RESET client_min_messages;
