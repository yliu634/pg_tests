-- PostgreSQL compatible tests from zigzag_join
-- 76 tests

-- Test 1: query (line 11)
SELECT n,a,b FROM a WHERE a = 4 AND b = 1

-- Test 2: query (line 16)
SELECT n,a,b FROM a WHERE a = 5 AND b = 2

-- Test 3: query (line 21)
SELECT * FROM a WHERE a = 4 AND b = 1

-- Test 4: query (line 26)
SELECT * FROM a WHERE a = 4 AND b = 2

-- Test 5: query (line 30)
SELECT * FROM a WHERE a = 5 AND b = 2 AND c = 'foo'

-- Test 6: query (line 37)
SELECT n,a,b FROM a@{NO_ZIGZAG_JOIN} WHERE a = 4 AND b = 1

-- Test 7: statement (line 42)
SET enable_zigzag_join = false

-- Test 8: query (line 45)
SELECT n,a,b FROM a WHERE a = 4 AND b = 1

-- Test 9: query (line 50)
SELECT n,a,b FROM a WHERE a = 5 AND b = 2

-- Test 10: statement (line 55)
SET enable_zigzag_join = true

-- Test 11: statement (line 59)
DROP INDEX a@a_idx;
DROP INDEX a@b_idx;

-- Test 12: statement (line 63)
CREATE INDEX c_idx ON a(c);
CREATE INDEX a_idx ON a(a);
CREATE INDEX b_idx ON a(b);

-- Test 13: statement (line 68)
SELECT n,a,b FROM a WHERE a = 4 AND b = 1;

-- Test 14: statement (line 73)
SELECT n FROM a WHERE b = 1 AND (((a < 1) AND (a > 1)) OR (a >= 2 AND a <= 2))

-- Test 15: statement (line 78)
CREATE TABLE t71655 (
    k INT PRIMARY KEY,
    a INT,
    b INT,
    c INT,
    d INT NOT NULL,
    INDEX ac (a, c),
    INDEX bc (b, c)
);
INSERT INTO t71655 VALUES (1, 10, 20, NULL, 11);
INSERT INTO t71655 VALUES (2, 10, 20, NULL, 12)

-- Test 16: query (line 93)
SELECT k FROM t71655 WHERE a = 10 AND b = 20

-- Test 17: statement (line 99)
CREATE INDEX ad ON t71655 (a, d);
CREATE INDEX bd ON t71655 (b, d)

-- Test 18: query (line 105)
SELECT k FROM t71655 WHERE a = 10 AND b = 20

-- Test 19: statement (line 115)
CREATE TABLE d (
  a INT PRIMARY KEY,
  b JSONB
)

-- Test 20: statement (line 121)
CREATE INVERTED INDEX foo_inv ON d(b)

-- Test 21: statement (line 124)
SHOW INDEX FROM d

-- Test 22: statement (line 127)
INSERT INTO d VALUES(1, '{"a": "b"}')

-- Test 23: statement (line 130)
INSERT INTO d VALUES(2, '[1,2,3,4, "foo"]')

-- Test 24: statement (line 133)
INSERT INTO d VALUES(3, '{"a": {"b": "c"}}')

-- Test 25: statement (line 136)
INSERT INTO d VALUES(4, '{"a": {"b": [1]}}')

-- Test 26: statement (line 139)
INSERT INTO d VALUES(5, '{"a": {"b": [1, [2]]}}')

-- Test 27: statement (line 142)
INSERT INTO d VALUES(6, '{"a": {"b": [[2]]}}')

-- Test 28: statement (line 145)
INSERT INTO d VALUES(7, '{"a": "b", "c": "d"}')

-- Test 29: statement (line 148)
INSERT INTO d VALUES(8, '{"a": {"b":true}}')

-- Test 30: statement (line 151)
INSERT INTO d VALUES(9, '{"a": {"b":false}}')

-- Test 31: statement (line 154)
INSERT INTO d VALUES(10, '"a"')

-- Test 32: statement (line 157)
INSERT INTO d VALUES(11, 'null')

-- Test 33: statement (line 160)
INSERT INTO d VALUES(12, 'true')

-- Test 34: statement (line 163)
INSERT INTO d VALUES(13, 'false')

-- Test 35: statement (line 166)
INSERT INTO d VALUES(14, '1')

-- Test 36: statement (line 169)
INSERT INTO d VALUES(15, '1.23')

-- Test 37: statement (line 172)
INSERT INTO d VALUES(16, '[{"a": {"b": [1, [2]]}}, "d"]')

-- Test 38: statement (line 175)
INSERT INTO d VALUES(17, '{}')

-- Test 39: statement (line 178)
INSERT INTO d VALUES(18, '[]')

-- Test 40: statement (line 181)
INSERT INTO d VALUES (29,  NULL)

-- Test 41: statement (line 184)
INSERT INTO d VALUES (30,  '{"a": []}')

-- Test 42: statement (line 187)
INSERT INTO d VALUES (31,  '{"a": {"b": "c", "d": "e"}, "f": "g"}')

-- Test 43: statement (line 190)
ANALYZE d;

-- Test 44: query (line 195)
SELECT * from d where b @> '{"a": {"b": "c"}, "f": "g"}'

-- Test 45: query (line 200)
SELECT * from d where b @> '{"a": {"b": "c", "d": "e"}, "f": "g"}'

-- Test 46: query (line 205)
SELECT * from d where b @> '{"c": "d", "a": "b"}'

-- Test 47: query (line 210)
SELECT * from d where b @> '{"c": "d", "a": "b", "f": "g"}'

-- Test 48: query (line 214)
SELECT * from d where b @> '{"a": "b", "c": "e"}'

-- Test 49: query (line 218)
SELECT * from d where b @> '{"a": "e", "c": "d"}'

-- Test 50: query (line 222)
SELECT * from d where b @> '["d", {"a": {"b": [1]}}]'

-- Test 51: query (line 227)
SELECT * from d where b @> '["d", {"a": {"b": [[2]]}}]'

-- Test 52: query (line 232)
SELECT * from d where b @> '[{"a": {"b": [[2]]}}, "d"]'

-- Test 53: statement (line 240)
SELECT * FROM a@{FORCE_ZIGZAG=foo} WHERE a = 3 AND b = 7

-- Test 54: statement (line 244)
SELECT * FROM a@{FORCE_ZIGZAG=a_idx,FORCE_ZIGZAG=c_idx} WHERE a = 3 AND b = 7

-- Test 55: statement (line 248)
SELECT * FROM a@{FORCE_ZIGZAG=a_idx,FORCE_ZIGZAG=b_idx} WHERE a = 3

-- Test 56: statement (line 252)
SELECT * FROM a@{FORCE_ZIGZAG=a_idx,FORCE_ZIGZAG=bc_idx} WHERE a = 3 AND b = 7

-- Test 57: statement (line 256)
SELECT * FROM a@{FORCE_ZIGZAG} WHERE a = 3 AND b = 7

-- Test 58: statement (line 260)
SELECT * FROM a@{FORCE_ZIGZAG,FORCE_ZIGZAG=a_idx} WHERE a = 3 AND b = 7

-- Test 59: statement (line 264)
SELECT * FROM a@{FORCE_ZIGZAG=a_idx,FORCE_ZIGZAG=a_idx} WHERE a = 3 AND b = 7

-- Test 60: statement (line 268)
SELECT * FROM a@{FORCE_ZIGZAG=a_idx,FORCE_ZIGZAG=b_idx} WHERE a = 3 AND b = 7

-- Test 61: statement (line 271)
DROP INDEX a@c_idx

-- Test 62: statement (line 275)
SELECT * FROM a@{FORCE_ZIGZAG} WHERE a = 3 AND c = 'foo'

-- Test 63: statement (line 279)
SELECT * FROM a@{FORCE_ZIGZAG=[1],FORCE_ZIGZAG=[1]} WHERE a = 3 AND b = 7

-- Test 64: query (line 284)
WITH indexes AS (
    SELECT json_array_elements(crdb_internal.pb_to_json('cockroach.sql.sqlbase.Descriptor', descriptor)->'table'->'indexes') AS idx
    FROM system.descriptor AS d
    JOIN system.namespace AS n
    ON d.id = n.id
    WHERE n.name = 'a'
)
SELECT idx->>'name', idx->>'id' FROM indexes

-- Test 65: statement (line 299)
SELECT * FROM a@{FORCE_ZIGZAG=[7],FORCE_ZIGZAG=[9]} WHERE a = 3 AND b = 7

-- Test 66: statement (line 303)
SELECT * FROM a@{FORCE_ZIGZAG=[7],FORCE_ZIGZAG=b_idx} WHERE a = 3 AND b = 7

-- Test 67: statement (line 307)
SELECT * FROM a@{FORCE_ZIGZAG=[7],FORCE_ZIGZAG=a_idx} WHERE a = 3 AND b = 7

-- Test 68: statement (line 310)
SELECT * FROM a@{FORCE_ZIGZAG,NO_ZIGZAG_JOIN} WHERE a = 3 AND b = 7

-- Test 69: statement (line 315)
CREATE TABLE t71093 (a INT, b INT, c INT, d INT, INDEX a_idx(a) STORING (b), INDEX c_idx(c) STORING (d));
INSERT INTO t71093 VALUES (0, 1, 2, 3)

-- Test 70: query (line 320)
SELECT count(*) FROM t71093 WHERE a = 0 AND b = 1 AND c = 2

-- Test 71: query (line 326)
SELECT count(*) FROM t71093 WHERE a = 0 AND c = 2 AND d = 3

-- Test 72: query (line 332)
SELECT count(*) FROM t71093 WHERE a = 0 AND b = 1 AND c = 2 AND d = 3

-- Test 73: statement (line 339)
CREATE TABLE t71271(a INT, b INT, c INT, d INT, INDEX (c), INDEX (d))

-- Test 74: statement (line 342)
SELECT d FROM t71271 WHERE c = 3 AND d = 4

-- Test 75: statement (line 347)
CREATE TABLE t97090 (
  c INT NOT NULL,
  l INT NOT NULL,
  r INT NOT NULL,
  INDEX (l ASC, c DESC),
  INDEX (r ASC, c ASC)
);
INSERT INTO t97090 VALUES (1, 1, -1), (2, 1, -2)

-- Test 76: query (line 358)
SELECT * FROM t97090 WHERE l = 1 AND r = -1

