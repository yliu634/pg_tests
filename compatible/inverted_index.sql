-- PostgreSQL compatible tests from inverted_index
-- 358 tests

SET client_min_messages = warning;
CREATE EXTENSION IF NOT EXISTS btree_gin;
CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE EXTENSION IF NOT EXISTS pg_trgm;
CREATE EXTENSION IF NOT EXISTS postgis;

-- Test 1: statement (line 3)
DROP TABLE IF EXISTS t CASCADE;
CREATE TABLE t (
  a INT PRIMARY KEY,
  b INT,
  c INT
);

-- Test 2: statement (line 12)
INSERT INTO t VALUES (1,1,1);

-- Test 3: statement (line 15)
CREATE INDEX foo ON t (b);

-- Test 4: statement (line 18)
CREATE INDEX foo_inv ON t USING GIN (b);

-- Test 5: statement (line 21)
CREATE INDEX foo_inv2 ON t USING GIN (b);

-- Test 6: statement (line 24)
CREATE UNIQUE INDEX foo_inv_unique ON t (b);

-- Test 7: statement (line 27)
DROP TABLE IF EXISTS c CASCADE;
CREATE TABLE c (
  id INT PRIMARY KEY,
  foo JSONB,
  "bAr" JSONB,
  "qUuX" JSONB
);
-- CockroachDB uses INVERTED INDEX; PostgreSQL uses GIN for JSONB containment.
CREATE INDEX c_foo_gin ON c USING GIN (foo);
CREATE INDEX c_bAr_gin ON c USING GIN ("bAr");

-- onlyif config schema-locked-disabled

-- Test 8: query (line 39)
SELECT indexdef FROM pg_indexes WHERE schemaname = 'public' AND tablename = 'c' ORDER BY indexname;

-- Test 9: query (line 53)
SELECT indexdef FROM pg_indexes WHERE schemaname = 'public' AND tablename = 'c' ORDER BY indexname;

-- Test 10: statement (line 67)
CREATE INDEX ON c USING GIN (foo jsonb_ops);

-- Test 11: statement (line 70)
CREATE INDEX ON c USING GIN(foo jsonb_ops);

-- Test 12: statement (line 73)
CREATE INDEX ON c USING GIN(foo jsonb_path_ops);

-- Test 13: statement (line 76)
CREATE INDEX ON c USING GIN(foo jsonb_ops);

-- Test 14: statement (line 79)
CREATE INDEX ON c USING GIN(foo jsonb_ops);

-- Test 15: statement (line 82)
CREATE INDEX ON c USING GIN (foo);

-- Test 16: statement (line 85)
CREATE INDEX ON c USING GIN (foo);

-- Test 17: statement (line 90)
CREATE INDEX ON c USING GIN ("qUuX");

-- Test 18: statement (line 93)
CREATE TABLE d_int (
  id INT PRIMARY KEY,
  foo INT
);
CREATE INDEX d_int_foo_gin ON d_int USING GIN (foo);

-- Test 19: statement (line 100)
CREATE TABLE d_json_desc (
  foo JSONB
);
CREATE INDEX d_json_desc_foo_gin ON d_json_desc USING GIN (foo);

-- Test 20: statement (line 106)
CREATE TABLE d_asc (
  foo JSONB
);
CREATE INDEX d_asc_foo_gin ON d_asc USING GIN (foo);

-- Test 21: statement (line 112)
CREATE TABLE t1 (id1 INT PRIMARY KEY, id2 INT, id3 INT);

-- Test 22: statement (line 115)
CREATE INDEX c_gin ON t1 USING GIN (id2);

-- Test 23: statement (line 118)
CREATE INDEX c_inv_gin ON t1 USING GIN (id2);

-- Test 24: statement (line 121)
CREATE UNIQUE INDEX foo_inv2_unique ON t (b);

-- Test 25: statement (line 124)
CREATE TABLE d (
  a INT PRIMARY KEY,
  b JSONB
);

-- Test 26: statement (line 130)
CREATE INDEX d_foo_inv ON d USING GIN (b);

-- Test 27: statement (line 133)
SELECT indexdef FROM pg_indexes WHERE schemaname = 'public' AND tablename = 'd' ORDER BY indexname;

-- Test 28: statement (line 136)
INSERT INTO d VALUES(1, '{"a": "b"}');

-- Test 29: statement (line 139)
INSERT INTO d VALUES(2, '[1,2,3,4, "foo"]');

-- Test 30: statement (line 142)
INSERT INTO d VALUES(3, '{"a": {"b": "c"}}');

-- Test 31: statement (line 145)
INSERT INTO d VALUES(4, '{"a": {"b": [1]}}');

-- Test 32: statement (line 148)
INSERT INTO d VALUES(5, '{"a": {"b": [1, [2]]}}');

-- Test 33: statement (line 151)
INSERT INTO d VALUES(6, '{"a": {"b": [[2]]}}');

-- Test 34: statement (line 154)
INSERT INTO d VALUES(7, '{"a": "b", "c": "d"}');

-- Test 35: statement (line 157)
INSERT INTO d VALUES(8, '{"a": {"b":true}}');

-- Test 36: statement (line 160)
INSERT INTO d VALUES(9, '{"a": {"b":false}}');

-- Test 37: statement (line 163)
INSERT INTO d VALUES(10, '"a"');

-- Test 38: statement (line 166)
INSERT INTO d VALUES(11, 'null');

-- Test 39: statement (line 169)
INSERT INTO d VALUES(12, 'true');

-- Test 40: statement (line 172)
INSERT INTO d VALUES(13, 'false');

-- Test 41: statement (line 175)
INSERT INTO d VALUES(14, '1');

-- Test 42: statement (line 178)
INSERT INTO d VALUES(15, '1.23');

-- Test 43: statement (line 181)
INSERT INTO d VALUES(16, '[{"a": {"b": [1, [2]]}}, "d"]');

-- Test 44: statement (line 184)
INSERT INTO d VALUES(17, '{}');

-- Test 45: statement (line 187)
INSERT INTO d VALUES(18, '[]');

-- Test 46: statement (line 190)
INSERT INTO d VALUES (29,  NULL);

-- Test 47: statement (line 193)
INSERT INTO d VALUES (30,  '{"a": []}');

-- Test 48: statement (line 196)
INSERT INTO d VALUES (31,  '{"a": {"b": "c", "d": "e"}, "f": "g"}');

-- Test 49: query (line 199)
SELECT * FROM d WHERE b @> NULL ORDER BY a;

-- Test 50: query (line 203)
SELECT * FROM d WHERE b @> (NULL::JSONB) ORDER BY a;

-- Test 51: query (line 207)
SELECT * FROM d WHERE b @>'{"a": "b"}' ORDER BY a;

-- Test 52: query (line 213)
SELECT * FROM d WHERE b @> '{"a": {"b": [1]}}' ORDER BY a;

-- Test 53: query (line 219)
SELECT * FROM d WHERE b @> '{"a": {"b": [[2]]}}' ORDER BY a;

-- Test 54: query (line 225)
SELECT * FROM d WHERE b @> '{"a": {"b": true}}' ORDER BY a;

-- Test 55: query (line 230)
SELECT * FROM d WHERE b @> '{"a": {"b": [[2]]}}' ORDER BY a;

-- Test 56: query (line 236)
SELECT * FROM d WHERE b @>'[1]' ORDER BY a;

-- Test 57: query (line 241)
SELECT * FROM d WHERE b @>'[{"a": {"b": [1]}}]' ORDER BY a;

-- Test 58: statement (line 246)
DELETE FROM d WHERE a=1;

-- Test 59: query (line 249)
SELECT * FROM d WHERE b @>'{"a": "b"}' ORDER BY a;

-- Test 60: query (line 257)
PREPARE query(text, jsonb) AS SELECT * FROM d WHERE b -> $1 = $2 ORDER BY a;
EXECUTE query ('a', '"b"');

-- Test 61: statement (line 262)
DELETE FROM d WHERE a=6;

-- Test 62: query (line 265)
SELECT * FROM d WHERE b @> '{"a": {"b": [[2]]}}' ORDER BY a;

-- Test 63: query (line 270)
SELECT * FROM d WHERE b @> '"a"' ORDER BY a;

-- Test 64: query (line 275)
SELECT * FROM d WHERE b @> 'null' ORDER BY a;

-- Test 65: query (line 280)
SELECT * FROM d WHERE b @> 'true' ORDER BY a;

-- Test 66: query (line 285)
SELECT * FROM d WHERE b @> 'false' ORDER BY a;

-- Test 67: query (line 290)
SELECT * FROM d WHERE b @> '1' ORDER BY a;

-- Test 68: query (line 296)
SELECT * FROM d WHERE b @> '1.23' ORDER BY a;

-- Test 69: query (line 301)
SELECT * FROM d WHERE b @> '{}' ORDER BY a;

-- Test 70: query (line 314)
SELECT * FROM d WHERE b @> '[]' ORDER BY a;

-- Test 71: statement (line 321)
INSERT INTO d VALUES (19, '["a", "a"]');

-- Test 72: query (line 324)
SELECT * FROM d WHERE b @> '["a"]' ORDER BY a;

-- Test 73: statement (line 329)
INSERT INTO d VALUES (20, '[{"a": "a"}, {"a": "a"}]');

-- Test 74: query (line 332)
SELECT * FROM d WHERE b @> '[{"a": "a"}]' ORDER BY a;

-- Test 75: statement (line 337)
INSERT INTO d VALUES (21,  '[[[["a"]]], [[["a"]]]]');

-- Test 76: query (line 340)
SELECT * FROM d WHERE b @> '[[[["a"]]]]' ORDER BY a;

-- Test 77: statement (line 345)
INSERT INTO d VALUES (22,  '[1,2,3,1]');

-- Test 78: query (line 348)
SELECT * FROM d WHERE b @> '[[[["a"]]]]' ORDER BY a;

-- Test 79: query (line 353)
SELECT * FROM d WHERE b->'a' = '"b"';

-- Test 80: statement (line 358)
INSERT INTO d VALUES (23,  '{"a": 123.123}');

-- Test 81: statement (line 361)
INSERT INTO d VALUES (24,  '{"a": 123.123000}');

-- Test 82: query (line 364)
SELECT * FROM d WHERE b @> '{"a": 123.123}' ORDER BY a;

-- Test 83: query (line 370)
SELECT * FROM d WHERE b @> '{"a": 123.123000}' ORDER BY a;

-- Test 84: statement (line 376)
INSERT INTO d VALUES (25,  '{"a": [{}]}');

-- Test 85: statement (line 379)
INSERT INTO d VALUES (26,  '[[], {}]');

-- Test 86: query (line 382)
SELECT * FROM d WHERE b @> '{"a": [{}]}' ORDER BY a;

-- Test 87: query (line 388)
SELECT * FROM d WHERE b @> '{"a": []}' ORDER BY a;

-- Test 88: query (line 394)
SELECT * FROM d WHERE b @> '[{}]' ORDER BY a;

-- Test 89: query (line 401)
SELECT * FROM d WHERE b @> '[[]]' ORDER BY a;

-- Test 90: statement (line 407)
INSERT INTO d VALUES (27,  '[true, false, null, 1.23, "a"]');

-- Test 91: query (line 410)
SELECT * FROM d WHERE b @> 'true' ORDER BY a;

-- Test 92: query (line 416)
SELECT * FROM d WHERE b @> 'false' ORDER BY a;

-- Test 93: query (line 422)
SELECT * FROM d WHERE b @> '1.23' ORDER BY a;

-- Test 94: query (line 428)
SELECT * FROM d WHERE b @> '"a"' ORDER BY a;

-- Test 95: query (line 435)
SELECT * FROM d WHERE b IS NULL;

-- Test 96: query (line 440)
SELECT * FROM d WHERE b = NULL;

-- Test 97: query (line 444)
SELECT * FROM d WHERE b @> NULL;

-- Test 98: query (line 448)
SELECT * FROM d WHERE b @> 'null' ORDER BY a;

-- Test 99: query (line 454)
SELECT * FROM d WHERE b @> '{"a": {}}' ORDER BY a;

-- Test 100: query (line 464)
SELECT * FROM d WHERE b @> '{"a": []}' ORDER BY a;

-- Test 101: query (line 472)
SELECT * FROM d WHERE b @> '{"a": {"b": "c"}, "f": "g"}';

-- Test 102: query (line 477)
SELECT * FROM d WHERE b @> '{"a": {"b": "c", "d": "e"}, "f": "g"}';

-- Test 103: query (line 482)
SELECT * FROM d WHERE b @> '{"c": "d", "a": "b"}';

-- Test 104: query (line 487)
SELECT * FROM d WHERE b @> '{"c": "d", "a": "b", "f": "g"}';

-- Test 105: query (line 491)
SELECT * FROM d WHERE b @> '{"a": "b", "c": "e"}';

-- Test 106: query (line 495)
SELECT * FROM d WHERE b @> '{"a": "e", "c": "d"}';

-- Test 107: query (line 499)
SELECT * FROM d WHERE b @> '["d", {"a": {"b": [1]}}]';

-- Test 108: query (line 504)
SELECT * FROM d WHERE b @> '["d", {"a": {"b": [[2]]}}]';

-- Test 109: query (line 509)
SELECT * FROM d WHERE b @> '[{"a": {"b": [[2]]}}, "d"]';

-- Test 110: query (line 515)
SELECT * FROM d WHERE b @> '[1, 2]' ORDER BY a;

-- Test 111: query (line 522)
SELECT a FROM d WHERE b @> '[1]' AND b @> '[2]' ORDER BY a;

-- Test 112: statement (line 528)
INSERT INTO d VALUES (32, '[[1, 2]]');
INSERT INTO d VALUES (33, '[[1], [2]]');

-- Test 113: query (line 533)
SELECT * FROM d WHERE b @> '[[1, 2]]' ORDER BY a;

-- Test 114: statement (line 538)
CREATE TABLE users (
  profile_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  last_updated TIMESTAMP DEFAULT now(),
  user_profile JSONB
);

-- Test 115: statement (line 545)
INSERT INTO users (user_profile) VALUES  ('{"first_name": "Lola", "last_name": "Dog", "location": "NYC", "online" : true, "friends" : 547}'),
                                         ('{"first_name": "Ernie", "status": "Looking for treats", "location" : "Brooklyn"}');

-- Test 116: statement (line 549)
CREATE INDEX dogs ON users USING GIN (user_profile);

-- Test 117: statement (line 552)
SELECT count(*) FROM users;

-- Test 118: query (line 555)
SELECT user_profile FROM users WHERE user_profile @> '{"first_name":"Lola"}';

-- Test 119: query (line 560)
SELECT user_profile FROM users WHERE user_profile @> '{"first_name":"Ernie"}';

-- Test 120: statement (line 565)
DROP TABLE IF EXISTS update_test;
CREATE TABLE update_test (i INT PRIMARY KEY, j JSONB);
CREATE INDEX update_test_j_gin ON update_test USING GIN (j);

-- Test 121: statement (line 568)
INSERT INTO update_test VALUES (1, '0');

-- Test 122: query (line 571)
SELECT * FROM update_test WHERE j @> '0';

-- Test 123: statement (line 576)
UPDATE update_test SET j = '{"a":"b", "c":"d"}' WHERE i = 1;

-- Test 124: query (line 579)
SELECT * FROM update_test WHERE j @> '0';

-- Test 125: query (line 583)
SELECT * FROM update_test WHERE j @> '{"a":"b"}';

-- Test 126: statement (line 588)
INSERT INTO update_test VALUES (2, '{"longKey1":"longValue1", "longKey2":"longValue2"}');

-- Test 127: statement (line 591)
UPDATE update_test SET j = ('"shortValue"') WHERE i = 2;

-- Test 128: query (line 594)
SELECT * FROM update_test WHERE j @> '"shortValue"';

-- Test 129: query (line 599)
SELECT * FROM update_test WHERE j @> '{"longKey1":"longValue1"}';

-- Test 130: query (line 603)
SELECT * FROM update_test WHERE j @> '{"longKey2":"longValue2"}';

-- Test 131: statement (line 607)
UPDATE update_test SET (i, j) = (10, '{"longKey1":"longValue1", "longKey2":"longValue2"}') WHERE i = 2;

-- Test 132: statement (line 610)
UPDATE update_test SET j = '{"a":"b", "a":"b"}' WHERE i = 1;

-- Test 133: statement (line 613)
UPDATE update_test SET (i, j) = (2, '["a", "a"]') WHERE i = 10;

-- Test 134: statement (line 616)
INSERT INTO update_test VALUES (3, '["a", "b", "c"]');

-- Test 135: query (line 619)
SELECT * FROM update_test WHERE j @> '["a"]' ORDER BY i;

-- Test 136: statement (line 625)
UPDATE update_test SET j = '["b", "c", "e"]' WHERE i = 3;

-- Test 137: query (line 628)
SELECT * FROM update_test WHERE j @> '["a"]' ORDER BY i;

-- Test 138: query (line 633)
SELECT * FROM update_test WHERE j @> '["b"]' ORDER BY i;

-- Test 139: statement (line 639)
INSERT INTO update_test VALUES (4, '["a", "b"]');

-- Test 140: statement (line 642)
UPDATE update_test SET j = '["b", "a"]' WHERE i = 4;

-- Test 141: query (line 645)
SELECT * FROM update_test WHERE j @> '["a"]' ORDER BY i;

-- Test 142: query (line 651)
SELECT * FROM update_test WHERE j @> '["b"]' ORDER BY i;

-- Test 143: statement (line 657)
INSERT INTO update_test VALUES (4, '["a", "b"]')
ON CONFLICT (i) DO UPDATE SET j = EXCLUDED.j;

-- Test 144: query (line 660)
SELECT * FROM update_test WHERE j @> '["a"]' ORDER BY i;

-- Test 145: query (line 666)
SELECT * FROM update_test WHERE j @> '["b"]' ORDER BY i;

-- Test 146: statement (line 673)
INSERT INTO update_test VALUES (3, '["c", "e", "f"]')
ON CONFLICT (i) DO UPDATE SET j = EXCLUDED.j;

-- Test 147: query (line 676)
SELECT * FROM update_test WHERE j @> '["c"]' ORDER BY i;

-- Test 148: statement (line 681)
DROP TABLE IF EXISTS del_cascade_test;
CREATE TABLE del_cascade_test (
  delete_cascade INT NOT NULL REFERENCES update_test ON DELETE CASCADE ON UPDATE CASCADE,
  j JSONB
);
CREATE INDEX del_cascade_test_j_gin ON del_cascade_test USING GIN (j);

-- Test 149: statement (line 689)
DROP TABLE IF EXISTS update_cascade_test;
CREATE TABLE update_cascade_test (
  update_cascade INT NOT NULL REFERENCES update_test ON UPDATE CASCADE,
  j JSONB
);
CREATE INDEX update_cascade_test_j_gin ON update_cascade_test USING GIN (j);

-- Test 150: statement (line 696)
INSERT INTO del_cascade_test(delete_cascade, j) VALUES (1, '["a", "b"]'), (2, '{"a":"b", "c":"d"}'), (3, '["b", "c"]');

-- Test 151: query (line 700)
SELECT * FROM del_cascade_test ORDER BY delete_cascade;

-- Test 152: statement (line 707)
DELETE FROM update_test WHERE j @> '["c"]';

-- Test 153: query (line 710)
SELECT * FROM del_cascade_test ORDER BY delete_cascade;

-- Test 154: query (line 716)
SELECT * FROM del_cascade_test ORDER BY delete_cascade;

-- Test 155: statement (line 722)
INSERT INTO update_test VALUES (3, '["a", "b", "c"]');

-- Test 156: statement (line 725)
INSERT INTO update_cascade_test(update_cascade, j) VALUES (1, '["a", "b"]'), (2, '{"a":"b", "c":"d"}'), (3, '["b", "c"]');

-- Test 157: query (line 728)
SELECT * FROM update_cascade_test ORDER BY update_cascade;

-- Test 158: statement (line 735)
UPDATE update_test SET (i,j)  = (5, '{"a":"b", "a":"b"}') WHERE i = 1;

-- Test 159: statement (line 738)
DROP TABLE del_cascade_test;

-- Test 160: statement (line 741)
UPDATE update_test SET (i,j)  = (5, '{"a":"b", "a":"b"}') WHERE i = 1;

-- Test 161: query (line 744)
SELECT * FROM update_cascade_test ORDER BY update_cascade;

-- Test 162: statement (line 753)
DROP TABLE IF EXISTS table_with_nulls;
CREATE TABLE table_with_nulls (a JSONB);

-- Test 163: statement (line 756)
INSERT INTO table_with_nulls VALUES (NULL);

-- Test 164: statement (line 759)
CREATE INDEX table_with_nulls_a_gin ON table_with_nulls USING GIN (a);

-- Test 165: statement (line 762)
DROP TABLE table_with_nulls;

-- Test 166: statement (line 765)
DROP TABLE c;

-- Test 167: statement (line 770)
DROP TABLE IF EXISTS f;
CREATE TABLE f (
  k INT PRIMARY KEY,
  j JSONB
);
CREATE INDEX f_j_gin ON f USING GIN (j);

-- Test 168: statement (line 777)
INSERT INTO f VALUES
  (0, '{"a": 1}'),
  (1, '{"a": 10}'),
  (2, '{"b": 2}'),
  (3, '{"b": 2, "a": 1}'),
  (4, '{"a": 1, "c": 3}'),
  (5, '{"a": [1, 2]}'),
  (6, '{"a": {"b": 1}}'),
  (7, '{"a": {"b": 1, "d": 2}}'),
  (8, '{"a": {"d": 2}}'),
  (9, '{"a": {"b": [1, 2]}}'),
  (10, '{"a": {"b": {"c": 1}}}'),
  (11, '{"a": {"b": {"c": 1, "d": 2}}}'),
  (12, '{"a": {"b": {"d": 2}}}'),
  (13, '{"a": {"b": {"c": [1, 2]}}}'),
  (14, '{"a": {"b": {"c": [1, 2, 3]}}}'),
  (15, '{"a": []}'),
  (16, '{"a": {}}'),
  (17, '{"a": {"b": "c"}}'),
  (18, '{"a": {"b": ["c", "d", "e"]}}'),
  (19, '{"a": ["b", "c", "d", "e"]}'),
  (20, '{"a": ["b", "e", "c", "d"]}'),
  (21, '{"z": {"a": "b", "c": "d"}}'),
  (22, '{"z": {"a": "b", "c": "d", "e": "f"}}'),
  (23, '{"a": "b", "x": ["c", "d", "e"]}'),
  (24, '{"a": "b", "c": [{"d": 1}, {"e": 2}]}'),
  (25, '{"a": {"b": "c", "d": "e"}}'),
  (26, '{"a": {"b": "c"}, "d": "e"}'),
  (27, '[1, 2, {"b": "c"}]'),
  (28, '[{"a": {"b": "c"}}, "d", "e"]'),
  (29, '{"a": null}'),
  (30, '{"a": [1, 2, null]}'),
  (31, 'null'),
  (32, '{}'),
  (33, '[]'),
  (34, '{"a": {"b": []}}'),
  (35, '["a"]'),
  (36, '[[]]'),
  (37, '[{"a": [0, "b"]}, null, 1]'),
  (38, '[[0, 1, 2], {"b": "c"}]'),
  (39, '[[0, [1, 2]]]'),
  (40, '[[0, 1, 2]]'),
  (41, '[[{"a": {"b": []}}]]'),
  (42, '{"a": "a"}'),
  (43, '[[0, 1, 2], [0, 1, 2], "s"]');

-- Test 169: query (line 827)
SELECT j FROM f WHERE j = '[[0, 1, 2]]' ORDER BY k;

-- Test 170: query (line 832)
SELECT j FROM f WHERE j = '{"a": "a"}' ORDER BY k;

-- Test 171: query (line 837)
SELECT j FROM f WHERE j = '{"b": 2, "a": 1}' ORDER BY k;

-- Test 172: query (line 842)
SELECT j FROM f WHERE j = '{"a": {"b": "c"}, "d": "e"}' ORDER BY k;

-- Test 173: query (line 847)
SELECT j FROM f WHERE j = 'null' ORDER BY k;

-- Test 174: query (line 852)
SELECT j FROM f WHERE j = '[]' ORDER BY k;

-- Test 175: query (line 857)
SELECT j FROM f WHERE j = '{}' ORDER BY k;

-- Test 176: query (line 862)
SELECT j FROM f WHERE j = '1' ORDER BY k;

-- Test 177: query (line 866)
SELECT j FROM f WHERE j = '[[]]' ORDER BY k;

-- Test 178: query (line 871)
SELECT j FROM f WHERE j = '[[0, 1, 2], [0, 1, 2], "s"]' ORDER BY k;

-- Test 179: query (line 879)
SELECT j FROM f WHERE j IN ('{}', '[]', 'null') ORDER BY k;

-- Test 180: query (line 886)
SELECT j FROM f WHERE j IN ('[1]') ORDER BY k;

-- Test 181: query (line 890)
SELECT j FROM f WHERE j IN ('{"a": "b", "x": ["c", "d", "e"]}', '{}') ORDER BY k;

-- Test 182: query (line 896)
SELECT j FROM f WHERE j IN ('{"a": []}', '{"a": {}}') ORDER BY k;

-- Test 183: query (line 902)
SELECT j FROM f WHERE j IN ('{"a": [1, 2, null]}', '[[]]', '[[{"a": {"b": []}}]]')
ORDER BY k;

-- Test 184: query (line 910)
SELECT j FROM f WHERE j->0 @> '[0, 1, 2, 3]' ORDER BY k;

-- Test 185: query (line 914)
SELECT j FROM f WHERE j->0 @> '[0]' ORDER BY k;

-- Test 186: query (line 923)
SELECT j FROM f WHERE j->0->1 @> '[1, 2, 3]' ORDER BY k;

-- Test 187: query (line 927)
SELECT j FROM f WHERE j->0->1 @> '[1, 2]' ORDER BY k;

-- Test 188: query (line 932)
SELECT j FROM f WHERE j->0 @> '{"a": {}}' ORDER BY k;

-- Test 189: query (line 937)
SELECT j FROM f WHERE j->0 @> '{"a": {"b": "c"}}' ORDER BY k;

-- Test 190: query (line 942)
SELECT j FROM f WHERE j->0->1 @> '{"a": {"b": []}}' ORDER BY k;

-- Test 191: query (line 946)
SELECT j FROM f WHERE j->0->0 @> '{"a": {"b": []}}' ORDER BY k;

-- Test 192: query (line 951)
SELECT j FROM f WHERE j->'a'->0 @> '1' ORDER BY k;

-- Test 193: query (line 957)
SELECT j FROM f WHERE j->0->'a' @> '{"b": "c"}' ORDER BY k;

-- Test 194: query (line 962)
SELECT j FROM f WHERE j->0 <@ '[1, 2, 3]' ORDER BY k;

-- Test 195: query (line 968)
SELECT j FROM f WHERE j->1 <@ '[1, 2, 3]' ORDER BY k;

-- Test 196: query (line 973)
SELECT j FROM f WHERE j->0->0 <@ '[1, 2, 3]' ORDER BY k;

-- Test 197: query (line 977)
SELECT j FROM f WHERE j->2 <@ '["d", "e"]' ORDER BY k;

-- Test 198: query (line 982)
SELECT j FROM f WHERE j->0 <@ '{"a": {"b": "c"}}' ORDER BY k;

-- Test 199: query (line 987)
SELECT j FROM f WHERE j->0 <@ '["a", "b"]' ORDER BY k;

-- Test 200: query (line 993)
SELECT j FROM f WHERE j->0 <@ '"a"' ORDER BY k;

-- Test 201: query (line 998)
SELECT j FROM f WHERE j->0 <@ '1' ORDER BY k;

-- Test 202: query (line 1003)
SELECT j FROM f WHERE j->0 = '[]' ORDER BY k;

-- Test 203: query (line 1008)
SELECT j FROM f WHERE j->0 = '"a"' ORDER BY k;

-- Test 204: query (line 1013)
SELECT j FROM f WHERE j->0 = '"d"' ORDER BY k;

-- Test 205: query (line 1017)
SELECT j FROM f WHERE j->0 = '[0, 1, 2, 3]' ORDER BY k;

-- Test 206: query (line 1021)
SELECT j FROM f WHERE j->1 = '"d"' ORDER BY k;

-- Test 207: query (line 1026)
SELECT j FROM f WHERE j->2 = '"e"' ORDER BY k;

-- Test 208: query (line 1032)
SELECT j FROM f WHERE j->0->1 = '[1, 2]' ORDER BY k;

-- Test 209: query (line 1037)
SELECT j FROM f WHERE j->0 = '{"a": {"b": "c"}}' ORDER BY k;

-- Test 210: query (line 1042)
SELECT j FROM f WHERE j->'a'->0 = '1' ORDER BY k;

-- Test 211: query (line 1048)
SELECT j FROM f WHERE j->'a'->2 = 'null' ORDER BY k;

-- Test 212: query (line 1053)
SELECT j FROM f WHERE j->0->'a'->0 = '0' ORDER BY k;

-- Test 213: query (line 1058)
SELECT j FROM f WHERE j->0->'a'->1 = '"b"' ORDER BY k;

-- Test 214: query (line 1063)
SELECT j FROM f WHERE j->0->0 = '0' ORDER BY k;

-- Test 215: query (line 1071)
SELECT j FROM f WHERE j->0->1 = '[1, 2]' ORDER BY k;

-- Test 216: query (line 1076)
SELECT j FROM f WHERE j->0->0 = '0' AND j->0->1 = '[1, 2]' ORDER BY k;

-- Test 217: query (line 1081)
SELECT j FROM f WHERE j->'a' = '1' ORDER BY k;

-- Test 218: query (line 1088)
SELECT j FROM f WHERE j->'a' = '1' OR j->'b' = '2' ORDER BY k;

-- Test 219: query (line 1096)
SELECT j FROM f WHERE j->'a' = '1' OR j @> '{"b": 2}' ORDER BY k;

-- Test 220: query (line 1104)
SELECT j FROM f WHERE j->'a'->'b' = '1' ORDER BY k;

-- Test 221: query (line 1110)
SELECT j FROM f WHERE j->'a'->'b'->'c' = '1' ORDER BY k;

-- Test 222: query (line 1116)
SELECT j FROM f WHERE j->'a' = '[]' ORDER BY k;

-- Test 223: query (line 1121)
SELECT j FROM f WHERE j->'a' = '{}' ORDER BY k;

-- Test 224: query (line 1126)
SELECT j FROM f WHERE j->'a' = '["b"]' ORDER BY k;

-- Test 225: query (line 1130)
SELECT j FROM f WHERE j->'a' = '"b"' ORDER BY k;

-- Test 226: query (line 1136)
SELECT j FROM f WHERE j->'a' = '{"b": "c"}' ORDER BY k;

-- Test 227: query (line 1142)
SELECT j FROM f WHERE j->'a'->'b'->'c' = '[1, 2]' ORDER BY k;

-- Test 228: query (line 1147)
SELECT j FROM f WHERE j->'z' = '{"a": "b", "c": "d"}' ORDER BY k;

-- Test 229: query (line 1152)
SELECT j FROM f WHERE j->'a' = '["b", "c", "d", "e"]' ORDER BY k;

-- Test 230: query (line 1157)
SELECT j FROM f WHERE j->'a' = '["b", "c", "d", "e"]' OR  j->'a' = '["b", "e", "c", "d"]' ORDER BY k;

-- Test 231: query (line 1163)
SELECT j FROM f WHERE j->'a' = '{"b": ["c", "d", "e"]}' ORDER BY k;

-- Test 232: query (line 1168)
SELECT j FROM f WHERE j->'a'->'b' = '["c", "d", "e"]' ORDER BY k;

-- Test 233: query (line 1173)
SELECT j FROM f WHERE j->'z'->'c' = '"d"' ORDER BY k;

-- Test 234: query (line 1179)
SELECT j FROM f WHERE j->'z' = '{"c": "d"}' ORDER BY k;

-- Test 235: query (line 1183)
SELECT j FROM f WHERE j->'a' = '"b"' AND j->'c' = '[{"d": 1}]' ORDER BY k;

-- Test 236: query (line 1187)
SELECT j FROM f WHERE j->'a' = '"b"' AND j->'c' = '[{"d": 1}, {"e": 2}]' ORDER BY k;

-- Test 237: query (line 1193)
SELECT j FROM f WHERE j->'a' @> '"b"' ORDER BY k;

-- Test 238: query (line 1201)
SELECT j FROM f WHERE j->'a' <@ '"b"' ORDER BY k;

-- Test 239: query (line 1207)
SELECT j FROM f WHERE j->'a' @> 'null' ORDER BY k;

-- Test 240: query (line 1213)
SELECT j FROM f WHERE j->'a' <@ 'null' ORDER BY k;

-- Test 241: query (line 1218)
SELECT j FROM f WHERE j->'a' <@ '[]' ORDER BY k;

-- Test 242: query (line 1223)
SELECT j FROM f WHERE j->'a' <@ '{}' ORDER BY k;

-- Test 243: query (line 1228)
SELECT j FROM f WHERE j->'a' @> '[]' ORDER BY k;

-- Test 244: query (line 1237)
SELECT j FROM f WHERE j->'a' @> '{}' ORDER BY k;

-- Test 245: query (line 1256)
SELECT j FROM f WHERE j->'a' <@ '{"b": [1, 2]}' ORDER BY k;

-- Test 246: query (line 1263)
SELECT j FROM f WHERE j->'a' <@ '{"b": {"c": [1, 2]}}' ORDER BY k;

-- Test 247: query (line 1269)
SELECT j FROM f WHERE j->'a' @> '{"b": ["c"]}' ORDER BY k;

-- Test 248: query (line 1274)
SELECT j FROM f WHERE j->'c' @> '[{"d": 1}]' ORDER BY k;

-- Test 249: query (line 1281)
SELECT j FROM f WHERE j->'a'->'b' <@ '1' ORDER BY k;

-- Test 250: query (line 1287)
SELECT j FROM f WHERE j->'a'->'b' @> '1' ORDER BY k;

-- Test 251: query (line 1294)
SELECT j FROM f WHERE j->'a'->'b' @> '[1, 2]' ORDER BY k;

-- Test 252: query (line 1299)
SELECT j FROM f WHERE j->'a'->'b' <@ '[1, 2]' ORDER BY k;

-- Test 253: query (line 1307)
SELECT j FROM f WHERE j->'a'->'b' @> '"c"' ORDER BY k;

-- Test 254: query (line 1316)
SELECT j FROM f WHERE '"b"'::JSONB <@ (j->'a') ORDER BY k;

-- Test 255: query (line 1324)
SELECT j FROM f WHERE '[1, 2]'::JSONB <@ (j->'a'->'b') ORDER BY k;

-- Test 256: query (line 1329)
SELECT j FROM f WHERE '{"b": {"c": [1, 2]}}'::JSONB <@ (j->'a') ORDER BY k;

-- Test 257: query (line 1336)
SELECT j FROM f WHERE (j->'a') @> '"b"'::JSONB AND '["c"]'::JSONB <@ (j->'a') ORDER BY k;

-- Test 258: query (line 1342)
SELECT j FROM f WHERE j->'a' <@ '{"b": [1, 2]}' AND j->'a'->'b' @> '[1]' ORDER BY k;

-- Test 259: query (line 1347)
SELECT j FROM f
WHERE (j->'a') @> '"b"'::JSONB
  AND (j->'a') <@ '["b", "c", "d", "e"]'::JSONB
ORDER BY k;

-- Test 260: query (line 1355)
SELECT j FROM f
WHERE (j->'a') @> '{"d": 2}'::JSONB
  AND '[1, 2]'::JSONB @> (j->'a'->'b')
ORDER BY k;

-- Test 261: query (line 1361)
SELECT j FROM f
WHERE (j->'a') @> '[1, 2]'::JSONB
   OR (j->'a'->'b') @> '[1, 2]'::JSONB
ORDER BY k;

-- Test 262: query (line 1368)
SELECT j FROM f
WHERE (j->'a') @> '"b"'::JSONB
   OR (j->'a'->'b') <@ '[1, 2]'::JSONB
ORDER BY k;

-- Test 263: query (line 1380)
SELECT j FROM f
WHERE (j->'a'->'b') <@ '{"c": [1, 2], "d": 2}'::JSONB
   OR (j->'a'->'b') <@ '["c", "d", "e", 1, 2, 3]'::JSONB
ORDER BY k;

-- Test 264: query (line 1395)
SELECT j FROM f WHERE j->'a' IN ('1', '2', '3') ORDER BY k;

-- Test 265: query (line 1402)
SELECT j FROM f WHERE j->'a' IN ('"a"') ORDER BY k;

-- Test 266: query (line 1407)
SELECT j FROM f WHERE j->'a' IN ('"a"', 'null') ORDER BY k;

-- Test 267: query (line 1413)
SELECT j FROM f WHERE j->'a' IN ('{"b": "c"}', '{"c": "d"}') ORDER BY k;

-- Test 268: query (line 1419)
SELECT j FROM f WHERE j->'a' IN ('{"b": "c"}', '"a"') ORDER BY k;

-- Test 269: query (line 1426)
SELECT j FROM f WHERE j->'a' IN ('[1, 2]', '"a"') ORDER BY k;

-- Test 270: query (line 1432)
SELECT j FROM f WHERE j->0 IN ('1', '2', '3') ORDER BY k;

-- Test 271: query (line 1437)
SELECT j FROM f WHERE j->1 IN ('1', '2', '3') ORDER BY k;

-- Test 272: query (line 1442)
SELECT j FROM f WHERE j->0 IN ('1', '2', '3', '"d"') AND j->1 IN
 ('"e"', '"d"') ORDER BY k;

-- Test 273: query (line 1447)
SELECT j FROM f WHERE j->0 IN ('1', '2', '3', '"d"') OR j->1 IN
 ('"e"', '"d"') ORDER BY k;

-- Test 274: query (line 1454)
SELECT j FROM f WHERE j->0 IN ('{"a": {"b": "c"}}', '{"a": [0, "b"]}') ORDER BY k;

-- Test 275: query (line 1460)
SELECT j FROM f WHERE j->0 IN ('{"a": {"b": "c"}}', '[]') ORDER BY k;

-- Test 276: query (line 1466)
SELECT j FROM f WHERE j->0 IN ('[0, [1, 2]]', '[0, 1, 2]') ORDER BY k;

-- Test 277: query (line 1476)
SELECT j FROM f WHERE j @> '{"a": "c"}' AND (j @> '{"a": "b"}' OR j @> '{"a": "c"}');

-- Test 278: statement (line 1482)
DROP TABLE IF EXISTS e;
CREATE TABLE e (k INT PRIMARY KEY, j JSONB);
CREATE INDEX e_j_gin ON e USING GIN (j);

-- Test 279: statement (line 1485)
INSERT INTO e VALUES
  (0, '{"a": "b"}'),
  (1, '{"a": {}, "b": null}'),
  (2, '{"a": [], "b": 2, "c": 3}'),
  (3, '{"b": {"a": "c"}}'),
  (4, '["a", "b"]'),
  (5, '["b", "a", "c"]'),
  (6, '["a"]'),
  (7, '["aargh"]'),
  (8, '"a"'),
  (9, '[]'),
  (10, '3'),
  (11, NULL),
  (12, 'null'),
  (13, 'true'),
  (14, '{"aargh": 3, "b": 2, "c": 3}');

-- Test 280: query (line 1503)
SELECT j FROM e WHERE j ? 'a' ORDER BY k;

-- Test 281: query (line 1515)
SELECT j FROM e WHERE j ? 'aargh' OR j->'b' @> '{"a": "c"}' ORDER BY k;

-- Test 282: query (line 1522)
SELECT j FROM e WHERE j ?& ARRAY['a', 'b'] ORDER BY k;

-- Test 283: query (line 1530)
SELECT j FROM e WHERE j ?| ARRAY['a', 'b'] ORDER BY k;

-- Test 284: statement (line 1555)
DROP TABLE IF EXISTS c;
CREATE TABLE c (
  id INT PRIMARY KEY,
  foo INT[],
  bar TEXT[]
);
CREATE INDEX ON c USING GIN (foo array_ops);

-- Test 285: statement (line 1558)
CREATE INDEX blorp ON c USING GIN (foo array_ops);

-- Test 286: statement (line 1561)
DROP INDEX blorp;

-- Test 287: statement (line 1564)
INSERT INTO c VALUES(0, NULL, NULL);

-- Test 288: statement (line 1567)
INSERT INTO c VALUES(1, ARRAY[]::INT[], ARRAY['foo', 'bar', 'baz']);

-- Test 289: statement (line 1570)
CREATE INDEX ON c USING GIN (bar);

-- onlyif config schema-locked-disabled

-- Test 290: query (line 1574)
SELECT indexdef FROM pg_indexes WHERE schemaname = 'public' AND tablename = 'c' ORDER BY indexname;

-- Test 291: query (line 1587)
SELECT indexdef FROM pg_indexes WHERE schemaname = 'public' AND tablename = 'c' ORDER BY indexname;

-- Test 292: query (line 1599)
SELECT * FROM c WHERE bar @> ARRAY['foo'];

-- Test 293: query (line 1604)
SELECT * FROM c WHERE bar @> ARRAY['bar', 'baz'];

-- Test 294: query (line 1609)
SELECT * FROM c WHERE bar @> ARRAY['bar', 'qux'];

-- Test 295: statement (line 1613)
INSERT INTO c VALUES(2, NULL, NULL);

-- Test 296: statement (line 1616)
INSERT INTO c VALUES(3, ARRAY[0,1,NULL], ARRAY['a',NULL,'b',NULL]);

-- Test 297: statement (line 1619)
INSERT INTO c VALUES(4, ARRAY[1,2,3], ARRAY['b',NULL,'c']);

-- Test 298: statement (line 1622)
INSERT INTO c VALUES(5, ARRAY[]::INT[], ARRAY[NULL, NULL]::TEXT[]);

-- Test 299: statement (line 1626)
CREATE INDEX ON c USING GIN (foo);

-- Test 300: statement (line 1629)
CREATE INDEX ON c USING GIN (bar);

-- Test 301: query (line 1632)
SELECT * FROM c WHERE foo @> ARRAY[0];

-- Test 302: query (line 1637)
SELECT * FROM c WHERE foo @> ARRAY[0];

-- query ITT
SELECT * FROM c WHERE foo @> ARRAY[1] ORDER BY id;

-- Test 303: query (line 1648)
SELECT * FROM c WHERE foo @> ARRAY[NULL]::INT[];

-- Test 304: query (line 1652)
SELECT * FROM c WHERE bar @> ARRAY['a'];

-- Test 305: query (line 1657)
SELECT * FROM c WHERE bar @> ARRAY['b'] ORDER BY id;

-- Test 306: query (line 1663)
SELECT * FROM c WHERE bar @> ARRAY['c'];

-- Test 307: query (line 1668)
SELECT * FROM c WHERE bar @> ARRAY[]::TEXT[] ORDER BY id;

-- Test 308: query (line 1676)
SELECT * FROM c WHERE foo @> '{1, 2}' ORDER BY id;

-- Test 309: statement (line 1692)
DROP TABLE IF EXISTS cb;
CREATE TABLE cb (
  k INT PRIMARY KEY,
  numbers INT[],
  words TEXT[]
);
CREATE INDEX cb_numbers_gin ON cb USING GIN (numbers);
CREATE INDEX cb_words_gin ON cb USING GIN (words);

INSERT INTO cb VALUES
  (0, ARRAY[]::INT[], ARRAY[]::TEXT[]),
  (1, ARRAY[0], ARRAY[NULL]::TEXT[]),
  (2, ARRAY[1], ARRAY['cat']),
  (3, ARRAY[0,1], ARRAY['mouse']),
  (4, ARRAY[NULL]::INT[], ARRAY['cat', 'mouse']),
  (5, ARRAY[0,1,2], ARRAY['cat', NULL, 'mouse']),
  (6, ARRAY[3,4,5], ARRAY['rat']),
  (7, ARRAY[1,2,1], ARRAY['rat', NULL]),
  (8, ARRAY[0,1,NULL], ARRAY['']);

-- Test 310: query (line 1704)
SELECT numbers FROM cb WHERE numbers <@ ARRAY[]::INT[];

-- Test 311: query (line 1709)
SELECT numbers FROM cb WHERE numbers <@ ARRAY[1];

-- Test 312: query (line 1715)
SELECT numbers FROM cb WHERE numbers <@ ARRAY[0,1,2];

-- Test 313: query (line 1725)
SELECT numbers FROM cb WHERE numbers <@ ARRAY[1,2,3];

-- Test 314: query (line 1732)
SELECT numbers FROM cb WHERE numbers <@ ARRAY[0,1,NULL];

-- Test 315: query (line 1740)
SELECT numbers FROM cb WHERE numbers <@ ARRAY[NULL]::INT[];

-- Test 316: query (line 1762)
SELECT words FROM cb WHERE words <@ ARRAY['cat'];

-- Test 317: query (line 1769)
SELECT words FROM cb WHERE words <@ ARRAY['cat', 'mouse'];

-- Test 318: query (line 1777)
SELECT words FROM cb WHERE words <@ ARRAY['cat', 'mouse', NULL];

-- Test 319: query (line 1785)
SELECT words FROM cb WHERE words <@ ARRAY[NULL, 'rat'];

-- Test 320: statement (line 1793)
DROP TABLE IF EXISTS cb2;
CREATE TABLE cb2 (
  k INT PRIMARY KEY,
  j JSONB
);
CREATE INDEX cb2_j_gin ON cb2 USING GIN (j);

-- Test 321: statement (line 1800)
INSERT INTO cb2 VALUES
  (0, '{}'),
  (1, '[]'),
  (2, '1'),
  (3, '"a"'),
  (4, 'true'),
  (5, 'null'),
  (6, '{"a": "b"}'),
  (7, '{"a": {"b": "c", "d": "e"}}'),
  (8, '{"a": {"b": "c"}, "d": "e"}'),
  (9, '{"a": {"b": [1, 2]}}'),
  (10, '{"a": {"b": {"c": [1, 2, 3]}}}'),
  (11, '{"a": {"b": {"c": {"d": "e"}}}}'),
  (12, '{"a": {"b": {"d": 2}}}'),
  (13, '{"a": [{"b": {"c": [1, 2]}}]}'),
  (14, '{"b": {"c": [1, 2]}}'),
  (15, '{"a": []}'),
  (16, '{"a": {}}'),
  (17, '{"a": [[2]]}'),
  (18, '[[2]]'),
  (19, '[1, 2]'),
  (20, '[1, 2, 3]'),
  (21, '[{}]'),
  (22, '[{"a": "b"}]'),
  (23, '[{"a": "b", "c": ["d", "e"]}]'),
  (24, '[[1], [2]]'),
  (25, '[[1, 2]]'),
  (26, '["a", "b", "b"]'),
  (27, '[1, 2, {"b": "c"}]'),
  (28, '[{"a": {"b": "c"}}, "d", "e"]'),
  (29, '{"a": {"d": null}}'),
  (30, '{"d": null}'),
  (31, '[null]'),
  (32, '[[], null]'),
  (33, '[null, []]'),
  (34, '[null, {}]'),
  (35, '[[null]]'),
  (36, '[1, 2, null]');

-- Test 322: query (line 1840)
SELECT j FROM cb2 WHERE j <@ '{}' ORDER BY k;

-- Test 323: query (line 1845)
SELECT j FROM cb2 WHERE j <@ '[]' ORDER BY k;

-- Test 324: query (line 1850)
SELECT j FROM cb2 WHERE j <@ '1' ORDER BY k;

-- Test 325: query (line 1855)
SELECT j FROM cb2 WHERE j <@ '"a"' ORDER BY k;

-- Test 326: query (line 1860)
SELECT j FROM cb2 WHERE j <@ 'null' ORDER BY k;

-- Test 327: query (line 1865)
SELECT j FROM cb2 WHERE j <@ 'true' ORDER BY k;

-- Test 328: query (line 1870)
SELECT j FROM cb2 WHERE j <@ '{"a": "b"}' ORDER BY k;

-- Test 329: query (line 1876)
SELECT j FROM cb2 WHERE j <@ '{"a": [1]}' ORDER BY k;

-- Test 330: query (line 1882)
SELECT j FROM cb2 WHERE j <@ '[null, 1, 2, 3, "d"]' ORDER BY k;

-- Test 331: query (line 1893)
SELECT j FROM cb2 WHERE j <@ '[[1, 2], null]' ORDER BY k;

-- Test 332: query (line 1905)
SELECT j FROM cb2 WHERE j <@ '{"a": {"b": [1, 2], "d": null}}' ORDER BY k;

-- Test 333: query (line 1913)
SELECT j FROM cb2 WHERE j <@ '[[1, 2, {"hello": 3}], {"a": "b"}]' ORDER BY k;

-- Test 334: query (line 1923)
SELECT j FROM cb2 WHERE j <@ '[{}, []]' ORDER BY k;

-- Test 335: query (line 1929)
SELECT j FROM cb2 WHERE j <@ '[{"a": "b"}, [1, 2]]' ORDER BY k;

-- Test 336: query (line 1939)
SELECT j FROM cb2 WHERE j <@ '[[1], [2]]' ORDER BY k;

-- Test 337: statement (line 1947)
DROP TABLE IF EXISTS table_desc_inverted_index;
CREATE TABLE table_desc_inverted_index (
  id INT PRIMARY KEY,
  last_accessed TIMESTAMP,
  testdata JSONB
);
CREATE INDEX table_desc_inverted_index_last_accessed_idx ON table_desc_inverted_index (last_accessed);
CREATE INDEX table_desc_inverted_index_testdata_gin ON table_desc_inverted_index USING GIN (testdata);

-- onlyif config schema-locked-disabled

-- Test 338: query (line 1958)
SELECT indexdef FROM pg_indexes WHERE schemaname = 'public' AND tablename = 'table_desc_inverted_index' ORDER BY indexname;

-- Test 339: query (line 1972)
SELECT indexdef FROM pg_indexes WHERE schemaname = 'public' AND tablename = 'table_desc_inverted_index' ORDER BY indexname;

-- Test 340: statement (line 1987)
DROP TABLE IF EXISTS cb;
CREATE TABLE cb (
  k INT PRIMARY KEY,
  numbers INT[],
  words TEXT[],
  primes INT[]
);
CREATE INDEX cb_numbers_gin ON cb USING GIN (numbers);
CREATE INDEX cb_words_gin ON cb USING GIN (words);
CREATE INDEX cb_primes_gin ON cb USING GIN (primes);

-- Test 341: statement (line 2001)
INSERT INTO cb VALUES
  (0, ARRAY[]::INT[], ARRAY[]::TEXT[], ARRAY[]::INT[]),
  (1, ARRAY[0], ARRAY[NULL, ''], ARRAY[2]),
  (2, ARRAY[1], ARRAY['cat'], ARRAY[3]),
  (3, ARRAY[0,1], ARRAY['mouse'], ARRAY[2,3]),
  (4, ARRAY[NULL]::INT[], ARRAY['cat', 'mouse'], ARRAY[2]),
  (5, ARRAY[0,1,2], ARRAY['cat', NULL, 'mouse'], ARRAY[2,3,5]),
  (6, ARRAY[3,4,5], ARRAY['rat'], ARRAY[2,3]),
  (7, ARRAY[1,2,1], ARRAY['rat', NULL, ''], ARRAY[2,3]),
  (8, ARRAY[0,1,NULL], ARRAY[''], ARRAY[7]),
  (9, NULL, NULL, NULL);

-- Test 342: query (line 2014)
SELECT numbers FROM cb WHERE numbers && ARRAY[]::INT[] ORDER BY numbers;

-- Test 343: query (line 2018)
SELECT numbers FROM cb WHERE numbers && ARRAY[NULL]::INT[] ORDER BY numbers;

-- Test 344: query (line 2022)
SELECT numbers FROM cb WHERE numbers && ARRAY[1,NULL]::INT[] ORDER BY numbers;

-- Test 345: query (line 2031)
SELECT numbers FROM cb WHERE numbers && ARRAY[0,1,2] ORDER BY numbers;

-- Test 346: query (line 2041)
SELECT numbers FROM cb WHERE numbers && ARRAY[5,4,3] ORDER BY numbers;

-- Test 347: query (line 2061)
SELECT words FROM cb WHERE words && ARRAY['cat'] ORDER BY words;

-- Test 348: query (line 2068)
SELECT words FROM cb WHERE words && ARRAY[NULL, 'cat', 'mouse'] ORDER BY words;

-- Test 349: query (line 2076)
SELECT words FROM cb WHERE words && ARRAY[NULL, 'rat'] ORDER BY words;

-- Test 350: query (line 2082)
SELECT primes FROM cb WHERE primes && numbers ORDER BY primes;

-- Test 351: statement (line 2090)
DROP TABLE IF EXISTS t84569;
CREATE TABLE t84569 (name_col NAME NOT NULL);
CREATE INDEX t84569_name_col_trgm_gin ON t84569 USING GIN ((name_col::TEXT) gin_trgm_ops);
INSERT INTO t84569 (name_col) VALUES ('X'::NAME);

-- Test 352: statement (line 2095)
DROP TABLE IF EXISTS t117979;
CREATE TABLE t117979 (id INT PRIMARY KEY, links TEXT[]);
CREATE INDEX idx_links ON t117979 USING GIN (links);
INSERT INTO t117979 (id, links) VALUES (1, '{str2,str3}');

-- Test 353: statement (line 2119)
DROP TABLE IF EXISTS t126444;
CREATE TABLE t126444 (b_c TEXT);
CREATE INDEX t126444_b_c_trgm_gin ON t126444 USING GIN (b_c gin_trgm_ops);

-- Test 354: statement (line 2124)
DROP TABLE IF EXISTS t151995;
CREATE TABLE t151995 (
  c0 INT PRIMARY KEY,
  c1 GEOMETRY
);
CREATE INDEX t151995_c1_gist ON t151995 USING GIST (c1);

-- Test 355: statement (line 2131)
INSERT INTO t151995 (c0, c1) VALUES (
        0,
        '010300004001000000040000004ED667271F45EEC180F702131A41A7C138EDC3641D46F041E9E58A67A768F0C1CBB3A399C439FEC1189C38E3BBDDEEC16074F4D5F0C7FA414CCB652363EC01429029CED0E787E1C14ED667271F45EEC180F702131A41A7C138EDC3641D46F041'::geometry
       );

-- Test 356: statement (line 2137)
ANALYZE t151995;

-- Test 357: statement (line 2142)
-- CockroachDB internal; no direct PostgreSQL equivalent.
-- SELECT crdb_internal.clear_table_stats_cache();

-- Test 358: statement (line 2145)
SELECT *
  FROM t151995 AS t1
  JOIN t151995 AS t2 ON ST_DWithin(t2.c1, t1.c1, 1e308);
