-- PostgreSQL compatible tests from json_index
-- 55 tests

SET client_min_messages = warning;

-- Test 1: statement (line 3)
CREATE TABLE t (x JSONB PRIMARY KEY);

-- Test 2: statement (line 7)
INSERT INTO t VALUES
  ('"a"'::JSONB),
  ('"b"'::JSONB),
  ('"aa"'::JSONB),
  ('"abcdefghi"'::JSONB),
  ('100'::JSONB),
  ('1'::JSONB),
  ('{"a": "b"}'),
  ('[]');

-- Test 3: query (line 19)
SELECT x FROM t ORDER BY x;

-- Test 4: statement (line 33)
\set ON_ERROR_STOP 0
INSERT INTO t VALUES
  ('"a"'::JSONB)
ON CONFLICT DO NOTHING;
\set ON_ERROR_STOP 1

-- Test 5: query (line 37)
SELECT x FROM t ORDER BY x;

-- Test 6: query (line 50)
SELECT x FROM t WHERE x = '"a"';

-- Test 7: query (line 55)
SELECT x FROM t WHERE x = '"aa"';

-- Test 8: query (line 60)
SELECT x FROM t WHERE x = '100';

-- Test 9: query (line 65)
SELECT x FROM t WHERE x = '12';

-- Test 10: query (line 69)
SELECT x FROM t WHERE x = '{"a": "b"}';

-- Test 11: query (line 75)
SELECT x FROM t WHERE x > '1' ORDER BY x;

-- Test 12: query (line 81)
SELECT x FROM t WHERE x < '1' ORDER BY x;

-- Test 13: query (line 91)
SELECT x FROM t WHERE x > '1' OR x < '1' ORDER BY x;

-- Test 14: query (line 102)
SELECT x FROM t WHERE x > '1' AND x < '1' ORDER BY x;

-- Test 15: query (line 107)
SELECT x FROM t WHERE x > '1' OR x < '1' ORDER BY x DESC;

-- Test 16: statement (line 119)
INSERT INTO t VALUES
  ('true'),
  ('false'),
  ('null'),
  ('"aaaaaaayouube"'),
  ('"testing spaces"'),
  ('"Testing Punctuation?!."');

-- Test 17: query (line 128)
SELECT x FROM t ORDER BY x;

-- Test 18: query (line 146)
SELECT x FROM t WHERE x > 'true' ORDER BY x;

-- Test 19: query (line 151)
SELECT x FROM t WHERE x < 'false' ORDER BY x;

-- Test 20: statement (line 167)
DROP TABLE IF EXISTS t;
CREATE TABLE t (x JSONB PRIMARY KEY);

-- Test 21: statement (line 171)
INSERT INTO t VALUES
  ('[]'),
  ('[null]'),
  ('[1]'),
  ('[null, null, false, true, "a", 1]'),
  ('[{"a":"b"}]'),
  ('[{"a":"b", "c": [1, 2, 3, 4, 5]}]');

-- Test 22: query (line 180)
SELECT x FROM t ORDER BY x;

-- Test 23: query (line 190)
SELECT x FROM t WHERE x = '[1]' ORDER BY x;

-- Test 24: query (line 195)
SELECT x FROM t WHERE x >= '[1]' ORDER BY x;

-- Test 25: query (line 203)
SELECT x FROM t WHERE x <= '[1]' ORDER BY x;

-- Test 26: query (line 210)
SELECT x FROM t WHERE x >= '[1]' AND x <= '{"a": "b"}' ORDER BY x;

-- Test 27: statement (line 219)
INSERT INTO t VALUES
  ('[1, [2, 3]]'),
  ('[1, [2, [3, [4]]]]');

-- Test 28: query (line 224)
SELECT x FROM t WHERE x = '[1, [2, 3]]' ORDER BY x;

-- Test 29: query (line 229)
SELECT x FROM t WHERE x = '[1, [2, [3, [4]]]]' ORDER BY x;

-- Test 30: query (line 235)
SELECT x FROM t ORDER BY x;

-- Test 31: query (line 248)
SELECT x FROM t WHERE x < '[1, [2, [3, [4]]]]' ORDER BY x;

-- Test 32: statement (line 259)
DROP TABLE IF EXISTS t;
CREATE TABLE t (x JSONB PRIMARY KEY);

-- Test 33: statement (line 263)
INSERT INTO t VALUES
  ('{}'),
  ('{"a": 1}'),
  ('{"a": "sh", "b": 1}'),
  ('{"a": ["1"]}'),
  ('{"a": [{"b":"c"}]}'),
  ('{"c": true, "d": null, "newkey": "newvalue"}'),
  ('{"e": {"f": {"g": 1}}, "f": [1, 2, 3]}'),
  ('{ "aa": 1, "c": 1}'),
  ('{"b": 1, "d": 1}');

-- Test 34: query (line 276)
SELECT x FROM t ORDER BY x;

-- Test 35: query (line 289)
SELECT x FROM t WHERE x >= '{}' ORDER BY x;

-- Test 36: query (line 302)
SELECT x FROM t WHERE x < '{}' ORDER BY x;

-- Test 37: query (line 306)
SELECT x FROM t WHERE x = '{"e": {"f": {"g": 1}}, "f": [1, 2, 3]}' ORDER BY x;

-- Test 38: statement (line 312)
DROP TABLE t;
CREATE TABLE t (x JSONB);
INSERT INTO t VALUES
  ('{}'),
  ('[]'),
  ('true'),
  ('false'),
  ('null'),
  ('"crdb"'),
  ('[1, 2, 3]'),
  ('1'),
  ('{"a": "b", "c": "d"}'),
  (NULL);

-- Test 39: query (line 328)
SELECT x FROM t ORDER BY x;

-- Test 40: query (line 342)
SELECT x FROM t ORDER BY x DESC;

-- Test 41: query (line 357)
SELECT x FROM t WHERE x IS NOT NULL ORDER BY x;

-- Test 42: statement (line 372)
CREATE TABLE tjson(rowid BIGSERIAL PRIMARY KEY, x JSONB);
INSERT INTO tjson(x) VALUES
  ('1.250'),
  ('1.0'),
  ('1.000'),
  ('1.111111'),
  ('10'),
  ('[1, 2.0, 1.21, 1.00]'),
  ('{"a": [1, 1.1], "b": 1.0000, "c": 10.0}');

-- Test 43: query (line 384)
SELECT x FROM tjson ORDER BY x, rowid;

-- Test 44: statement (line 396)
CREATE TABLE y(x JSONB PRIMARY KEY);
INSERT INTO y VALUES
  ('1.00'),
  ('1.250'),
  ('10'),
  ('[1, 2.0, 1.21, 1.00]'),
  ('{"a": [1, 1.1], "b": 1.0000, "c": 10.0}');

-- Test 45: query (line 406)
SELECT x FROM y ORDER BY x;

-- Test 46: statement (line 416)
\set ON_ERROR_STOP 0
INSERT INTO y VALUES
  ('1.0000')
ON CONFLICT DO NOTHING;
\set ON_ERROR_STOP 1

-- Test 47: statement (line 421)
DROP TABLE t;
CREATE TABLE t (x JSONB);

-- Test 48: statement (line 425)
CREATE INDEX i ON t(x DESC)
;

-- Test 49: statement (line 428)
INSERT INTO t VALUES
  ('{}'),
  ('[]'),
  ('true'),
  ('false'),
  ('null'),
  ('"crdb"'),
  ('[1, 2, 3]'),
  ('1'),
  ('{"a": "b", "c": "d"}'),
  ('[null]'),
  ('[1]'),
  ('[null, null, false, true, "a", 1]'),
  ('[{"a":"b"}]'),
  ('[{"a":"b", "c": [1, 2, 3, 4, 5]}]');

-- Test 50: query (line 445)
SELECT x FROM t ORDER BY x;

-- Test 51: statement (line 465)
DROP TABLE IF EXISTS t1, t2 CASCADE;
CREATE TABLE t1 (x JSONB PRIMARY KEY);
CREATE TABLE t2 (x JSONB PRIMARY KEY);
INSERT INTO t1 VALUES
  ('[1, [2, 3]]'),
  ('[1, [2, [3, [4]]]]');
INSERT INTO t2 VALUES
  ('[1, [2, 3]]'),
  ('{}'),
  ('[1, [2, 4]]');

-- Test 52: query (line 478)
SELECT t1.x FROM t1 INNER JOIN t2 ON t1.x = t2.x;

-- Test 53: query (line 483)
SELECT t1.x FROM t1 INNER JOIN t2 ON t1.x = t2.x;

-- Test 54: statement (line 489)
CREATE TABLE t101356 (j JSONB PRIMARY KEY, i1 INT, i2 INT);
CREATE INDEX t101356_i1_idx ON t101356(i1);
INSERT INTO t101356 VALUES ('1'::JSON, 1, 1);

-- Test 55: query (line 495)
SELECT * FROM t101356 WHERE i1 = 1;

RESET client_min_messages;
