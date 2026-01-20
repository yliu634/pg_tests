-- PostgreSQL compatible tests from json
-- 173 tests

-- Test 1: query (line 5)
SELECT '1'::JSONB, '2'::JSON

-- Test 2: query (line 10)
SELECT pg_typeof(JSON '1')

-- Test 3: query (line 15)
SELECT pg_typeof(JSONB '1')

-- Test 4: query (line 20)
SELECT '1.00'::JSON

-- Test 5: statement (line 25)
SELECT '{'::JSON

-- Test 6: query (line 28)
SELECT '"hello"'::JSON

-- Test 7: query (line 33)
SELECT '"abc\n123"'::JSON

-- Test 8: query (line 38)
SELECT 'true'::JSON, 'false'::JSON, 'null'::JSON

-- Test 9: query (line 43)
SELECT '[]'::JSON

-- Test 10: query (line 48)
SELECT '[1, 2, 3]'::JSON

-- Test 11: query (line 53)
SELECT '[1, "hello", [[[true, false]]]]'::JSON

-- Test 12: query (line 58)
SELECT '[1, "hello", {"a": ["foo", {"b": 3}]}]'::JSON

-- Test 13: query (line 63)
SELECT '{}'::JSON

-- Test 14: query (line 68)
SELECT '{"a": "b", "c": "d"}'::JSON

-- Test 15: query (line 73)
SELECT '{"a": 1, "c": {"foo": "bar"}}'::JSON

-- Test 16: query (line 79)
SELECT '{"a": 1, "a": 2}'::JSON

-- Test 17: query (line 84)
SELECT NULL::JSON

-- Test 18: statement (line 89)
CREATE TABLE x (y JSONB[])

-- Test 19: statement (line 92)
CREATE TABLE foo (pk INT DEFAULT unique_rowid(), bar JSON)

-- Test 20: statement (line 95)
CREATE VIEW x AS SELECT array_agg(bar) FROM foo

-- Test 21: statement (line 98)
INSERT INTO foo(bar) VALUES
  ('{"a": "b"}'),
  ('[1, 2, 3]'),
  ('"hello"'),
  ('1.000'),
  ('true'),
  ('false'),
  (NULL),
  ('{"x": [1, 2, 3]}'),
  ('{"x": {"y": "z"}}')

-- Test 22: query (line 110)
SELECT bar FROM foo

-- Test 23: query (line 123)
SELECT bar FROM foo WHERE bar->>'a' = 'b'

-- Test 24: query (line 128)
SELECT bar FROM foo WHERE bar ? 'a'

-- Test 25: query (line 133)
VALUES (
  '"hello"'::JSONB   ? 'hello',
  '"hello"'::JSONB   ? 'goodbye',
  '"hello"'::JSONB   ? 'ello',
  '"hello"'::JSONB   ? 'h',
  'true'::JSONB      ? 'true',
  '1'::JSONB         ? '1',
  'null'::JSONB      ? 'null'
)

-- Test 26: query (line 146)
SELECT bar FROM foo WHERE bar ? 'hello'

-- Test 27: query (line 151)
SELECT bar FROM foo WHERE bar ? 'goodbye'

-- Test 28: query (line 155)
SELECT bar FROM foo WHERE bar ?| ARRAY['a','b']

-- Test 29: query (line 160)
SELECT bar FROM foo WHERE bar ?& ARRAY['a','b']

-- Test 30: query (line 165)
SELECT bar FROM foo WHERE bar ?| ARRAY['a', null]

-- Test 31: query (line 174)
SELECT bar FROM foo WHERE bar ?& ARRAY['a', null]

-- Test 32: query (line 179)
SELECT bar FROM foo WHERE bar->'a' = '"b"'::JSON

-- Test 33: statement (line 184)
SELECT bar FROM foo ORDER BY bar

-- Test 34: statement (line 187)
CREATE TABLE pk (k JSON PRIMARY KEY)

-- Test 35: query (line 190)
SELECT bar->'a' FROM foo

-- Test 36: query (line 203)
SELECT * from foo where bar->'x' = '[1]'

-- Test 37: query (line 207)
SELECT * from foo where bar->'x' = '{}'

-- Test 38: query (line 211)
SELECT array_agg(bar ORDER BY pk) FROM foo

-- Test 39: statement (line 216)
DELETE FROM foo

-- Test 40: statement (line 219)
INSERT INTO foo(bar) VALUES ('{"a": {"c": "d"}}');

-- Test 41: query (line 222)
SELECT bar->'a'->'c', bar->'a'->>'c' FROM foo

-- Test 42: statement (line 227)
CREATE TABLE multiple (a JSON, b JSON)

-- Test 43: statement (line 230)
INSERT INTO multiple VALUES ('{"a":"b"}', '[1,2,3,4,"foo"]')

-- Test 44: query (line 233)
SELECT a FROM multiple

-- Test 45: query (line 238)
SELECT b FROM multiple

-- Test 46: query (line 247)
SELECT '1'::JSON = '1'::JSON

-- Test 47: query (line 252)
SELECT '1'::JSON = '1'

-- Test 48: query (line 257)
SELECT '1'::JSON = '2'::JSON

-- Test 49: query (line 262)
SELECT '1.00'::JSON = '1'::JSON

-- Test 50: query (line 267)
SELECT '"hello"'::JSON = '"hello"'::JSON, '"hello"'::JSON = '"goodbye"'::JSON

-- Test 51: query (line 272)
SELECT '"hello"'::JSON IN ('"hello"'::JSON, '1'::JSON, '[]'::JSON)

-- Test 52: query (line 277)
SELECT 'false'::JSON IN ('"hello"'::JSON, '1'::JSON, '[]'::JSON)

-- Test 53: query (line 284)
SELECT '{"a": 1}'::JSONB->'a'

-- Test 54: query (line 289)
SELECT pg_typeof('{"a": 1}'::JSONB->'a')

-- Test 55: query (line 294)
SELECT '{"a": 1, "b": 2}'::JSONB->'b'

-- Test 56: query (line 299)
SELECT '{"a": 1, "b": {"c": 3}}'::JSONB->'b'->'c'

-- Test 57: query (line 304)
SELECT '{"a": 1, "b": 2}'::JSONB->'c', '{"c": 1}'::JSONB->'a'

-- Test 58: query (line 309)
SELECT '2'::JSONB->'b', '[1,2,3]'::JSONB->'0'

-- Test 59: query (line 314)
SELECT '[1, 2, 3]'::JSONB->0

-- Test 60: query (line 319)
SELECT '[1, 2, 3]'::JSONB->3

-- Test 61: query (line 324)
SELECT '{"a": "b"}'::JSONB->>'a'

-- Test 62: query (line 329)
SELECT '[null]'::JSONB->>0

-- Test 63: query (line 334)
SELECT '{"a":null}'::JSONB->>'a'

-- Test 64: query (line 339)
SELECT pg_typeof('{"a": 1}'::JSONB->>'a')

-- Test 65: query (line 344)
SELECT '{"a": 1, "b": 2}'::JSONB->>'b'

-- Test 66: query (line 349)
SELECT '{"a": 1, "b": 2}'::JSONB->>'c', '{"c": 1}'::JSONB->>'a'

-- Test 67: query (line 354)
SELECT '2'::JSONB->>'b', '[1,2,3]'::JSONB->>'0'

-- Test 68: query (line 359)
SELECT '[1, 2, 3]'::JSONB->>0

-- Test 69: query (line 364)
SELECT '[1, 2, 3]'::JSONB->>3

-- Test 70: query (line 369)
SELECT 'null'::jsonb->-2, 'null'::jsonb->-1, 'null'::jsonb->0, 'null'::jsonb->1

-- Test 71: query (line 374)
SELECT 'true'::jsonb->-2, 'true'::jsonb->-1, 'true'::jsonb->0, 'true'::jsonb->1

-- Test 72: query (line 379)
SELECT 'false'::jsonb->-2, 'false'::jsonb->-1, 'false'::jsonb->0, 'false'::jsonb->1

-- Test 73: query (line 384)
SELECT '"foo"'::jsonb->-2, '"foo"'::jsonb->-1, '"foo"'::jsonb->0, '"foo"'::jsonb->1

-- Test 74: query (line 389)
SELECT '123'::jsonb->-2, '123'::jsonb->-1, '123'::jsonb->0, '123'::jsonb->1

-- Test 75: query (line 394)
SELECT 'null'::jsonb->>-2, 'null'::jsonb->>-1, 'null'::jsonb->>0, 'null'::jsonb->>1

-- Test 76: query (line 399)
SELECT 'true'::jsonb->>-2, 'true'::jsonb->>-1, 'true'::jsonb->>0, 'true'::jsonb->>1

-- Test 77: query (line 404)
SELECT 'false'::jsonb->>-2, 'false'::jsonb->>-1, 'false'::jsonb->>0, 'false'::jsonb->>1

-- Test 78: query (line 409)
SELECT '"foo"'::jsonb->>-2, '"foo"'::jsonb->>-1, '"foo"'::jsonb->>0, '"foo"'::jsonb->>1

-- Test 79: query (line 414)
SELECT '123'::jsonb->>-2, '123'::jsonb->>-1, '123'::jsonb->>0, '123'::jsonb->>1

-- Test 80: query (line 439)
SELECT '{"a": 1}'::JSONB#>>ARRAY['foo', null]

-- Test 81: query (line 469)
SELECT '{"a": 1}'::JSONB ? 'a', '{"a": 1}'::JSONB ? 'b'

-- Test 82: query (line 474)
SELECT '{"a": 1, "b": 1}'::JSONB ? 'a', '{"a": 1, "b": 1}'::JSONB ? 'b'

-- Test 83: query (line 479)
SELECT '{"a": 1}'::JSONB ?| ARRAY['a', 'b'], '{"b": 1}'::JSONB ?| ARRAY['a', 'b']

-- Test 84: query (line 484)
SELECT '{"c": 1}'::JSONB ?| ARRAY['a', 'b']

-- Test 85: query (line 489)
SELECT '{"a": 1}'::JSONB ?& ARRAY['a', 'b'], '{"b": 1}'::JSONB ?& ARRAY['a', 'b']

-- Test 86: query (line 494)
SELECT '{"a": 1, "b": 1, "c": 1}'::JSONB ?& ARRAY['a', 'b']

-- Test 87: query (line 500)
SELECT '[1, 2, 3]'::JSONB ? '0'

-- Test 88: query (line 506)
SELECT '["foo", "bar", "baz"]'::JSONB ? 'foo'

-- Test 89: query (line 511)
SELECT '["foo", "bar", "baz"]'::JSONB ? 'baz'

-- Test 90: query (line 516)
SELECT '["foo", "bar", "baz"]'::JSONB ? 'gup'

-- Test 91: query (line 521)
SELECT '["foo", "bar", "baz"]'::JSONB ?| ARRAY['foo', 'gup']

-- Test 92: query (line 526)
SELECT '["foo", "bar", "baz"]'::JSONB ?| ARRAY['buh', 'gup']

-- Test 93: query (line 531)
SELECT '["foo", "bar", "baz"]'::JSONB ?& ARRAY['foo', 'bar']

-- Test 94: query (line 536)
SELECT '["foo", "bar", "baz"]'::JSONB ?& ARRAY['foo', 'buh']

-- Test 95: query (line 541)
SELECT '{"a": 1}'::JSONB - 'a'

-- Test 96: query (line 546)
SELECT '{"a": 1}'::JSONB - 'b'

-- Test 97: query (line 552)
SELECT '[1,2,3]'::JSONB - 0

-- Test 98: query (line 557)
SELECT '[1,2,3]'::JSONB - 1

-- Test 99: statement (line 562)
SELECT '3'::JSONB - 'b'

-- Test 100: statement (line 565)
SELECT '{}'::JSONB - 1

-- Test 101: query (line 568)
SELECT '[1, 2, 3]'::JSONB <@ '[1, 2]'::JSONB

-- Test 102: query (line 573)
SELECT '[1, 2]'::JSONB <@ '[1, 2, 3]'::JSONB

-- Test 103: query (line 578)
SELECT '[1, 2]'::JSONB @> '[1, 2, 3]'::JSONB

-- Test 104: query (line 583)
SELECT '[1, 2, 3]'::JSONB @> '[1, 2]'::JSONB

-- Test 105: query (line 588)
SELECT '{"a": [1, 2, 3]}'::JSONB->'a' @> '2'::JSONB

-- Test 106: statement (line 593)
CREATE TABLE x (j JSONB)

-- Test 107: statement (line 596)
INSERT INTO x VALUES ('{"a": [1,2,3]}')

-- Test 108: query (line 599)
SELECT true FROM x WHERE j->'a' @> '2'::JSONB

-- Test 109: statement (line 604)
CREATE INVERTED INDEX ON x (j)

-- Test 110: query (line 607)
SELECT true FROM x WHERE j->'a' @> '2'::JSONB

-- Test 111: query (line 612)
SELECT j FROM x WHERE j ?| ARRAY[NULL]

-- Test 112: query (line 621)
SELECT '{"foo": {"bar": 1}}'::JSONB #- ARRAY['foo', 'bar']

-- Test 113: statement (line 626)
SELECT '{"foo": {"bar": 1}}'::JSONB #- ARRAY[null, 'foo']

-- Test 114: statement (line 629)
SELECT '{"foo": {"bar": 1}}'::JSONB #- ARRAY['foo', null]

-- Test 115: query (line 632)
SELECT '{"foo": {"bar": 1}}'::JSONB #- ARRAY['foo']

-- Test 116: query (line 637)
SELECT '{"foo": {"bar": 1}}'::JSONB #- ARRAY['bar']

-- Test 117: query (line 642)
SELECT '{"foo": {"bar": 1}, "one": 1, "two": 2}'::JSONB #- ARRAY['one']

-- Test 118: query (line 647)
SELECT '{}'::JSONB #- ARRAY['foo']

-- Test 119: query (line 652)
SELECT '{"foo": {"bar": 1}}'::JSONB #- ARRAY['']

-- Test 120: query (line 667)
SELECT '["1", "2", "3"]'::JSONB - '1'

-- Test 121: query (line 672)
SELECT '["1", "2", "1", "2", "3"]'::JSONB - '2'

-- Test 122: query (line 677)
SELECT '["1", "2", "3"]'::JSONB - '4'

-- Test 123: query (line 682)
SELECT '[]'::JSONB - '1'

-- Test 124: query (line 687)
SELECT '["1", "2", "3"]'::JSONB - ''

-- Test 125: query (line 692)
SELECT '[1, "1", 1.0]'::JSONB - '1'

-- Test 126: query (line 697)
SELECT '[1, 2, 3]'::JSONB #- ARRAY['0']

-- Test 127: query (line 702)
SELECT '[1, 2, 3]'::JSONB #- ARRAY['3']

-- Test 128: query (line 707)
SELECT '[]'::JSONB #- ARRAY['0']

-- Test 129: statement (line 712)
SELECT '["foo"]'::JSONB #- ARRAY['foo']

-- Test 130: query (line 715)
SELECT '{"a": ["foo"]}'::JSONB #- ARRAY['a', '0']

-- Test 131: query (line 720)
SELECT '{"a": ["foo", "bar"]}'::JSONB #- ARRAY['a', '1']

-- Test 132: query (line 725)
SELECT '{"a": []}'::JSONB #- ARRAY['a', '0']

-- Test 133: query (line 730)
SELECT '{"a":123,"b":456,"c":567}'::JSONB - array[]:::text[];

-- Test 134: query (line 735)
SELECT '{"a":123,"b":456,"c":567}'::JSONB - array['a','c'];

-- Test 135: query (line 740)
SELECT '{"a":123,"c":"asdf"}'::JSONB - array['a','c'];

-- Test 136: query (line 745)
SELECT '{}'::JSONB - array['a','c'];

-- Test 137: query (line 750)
SELECT '{"b": [], "c": {"a": "b"}}'::JSONB - array['a'];

-- Test 138: query (line 756)
SELECT '{"b": [], "c": {"a": "b"}}'::JSONB - array['foo', NULL]

-- Test 139: statement (line 761)
SELECT '{"a": {"b": ["foo"]}}'::JSONB #- ARRAY['a', 'b', 'foo']

-- Test 140: statement (line 766)
CREATE TABLE json_family (a INT PRIMARY KEY, b JSONB, FAMILY fam0(a), FAMILY fam1(b))

-- Test 141: statement (line 769)
INSERT INTO json_family VALUES(0,'{}')

-- Test 142: statement (line 772)
INSERT INTO json_family VALUES(1,'{"a":123,"c":"asdf"}')

-- Test 143: query (line 775)
SELECT a, b FROM json_family ORDER BY a

-- Test 144: statement (line 782)
DROP TABLE json_family

-- Test 145: statement (line 789)
CREATE TABLE t49143 (k INT PRIMARY KEY, j JSON);
INSERT INTO t49143 VALUES
  (0, '[]'),
  (1, '[1]'),
  (2, '[2]'),
  (3, '[[1, 2], [3, 4]]'),
  (4, '[[5, 6], [7, 8]]'),
  (5, '{}'),
  (6, '{"a": 1}'),
  (7, '{"b": 1}'),
  (8, '{"b": 2}'),
  (9, '{"b": [1, 2]}'),
  (10, '{"b": [3, 4]}');

-- Test 146: query (line 804)
SELECT j FROM t49143 WHERE NOT (j->0 = '2') ORDER BY k

-- Test 147: query (line 811)
SELECT j FROM t49143 WHERE NOT (j->'b' = '1') ORDER BY k

-- Test 148: query (line 818)
SELECT j FROM t49143 WHERE NOT (j -> 0 @> '[1]') ORDER BY k

-- Test 149: query (line 825)
SELECT j FROM t49143 WHERE NOT (j -> 'b' @> '[1]') ORDER BY k

-- Test 150: query (line 839)
SELECT j - 'foo' AS a, j - 'bar' AS b FROM t57165 ORDER BY rowid

-- Test 151: query (line 845)
SELECT '{"foo": "bar"}' - s AS a, '{"bar": "foo"}' - s AS b FROM t57165 ORDER BY rowid

-- Test 152: query (line 851)
SELECT j - s FROM t57165

-- Test 153: query (line 857)
SELECT ARRAY['"hello"'::JSON]

-- Test 154: query (line 862)
SELECT '{}'::JSONB[]

-- Test 155: query (line 867)
SELECT json_valid('{"hello": {}}')

-- Test 156: query (line 872)
SELECT json_valid('{"foo": {"bar": 1, "one": 1, "two": 2')

-- Test 157: query (line 877)
SELECT json_valid('[{"bar": 1}, {"bar": 2}]')

-- Test 158: query (line 882)
SELECT json_valid(NULL)

-- Test 159: statement (line 890)
CREATE TABLE t81647(j JSON);
INSERT INTO t81647 VALUES ('["a", "b"]')

-- Test 160: query (line 894)
SELECT j, j ? 'a', j-1, (j-1) ? 'a' FROM t81647

-- Test 161: query (line 904)
SELECT
  ('{"a": {"b": {"c": 1}}}'::jsonb)['a'],
  ('{"a": {"b": {"c": 1}}}'::jsonb)['a']['b']['c'],
  ('[1, "2", null]'::jsonb)[1]

-- Test 162: query (line 913)
SELECT
  ('{"a": 1}'::jsonb)['b'],
  ('{"a": {"b": {"c": 1}}}'::jsonb)['c']['b']['c'],
  ('[1, "2", null]'::jsonb)[4],
  ('{"a": 1}'::jsonb)[NULL]

-- Test 163: statement (line 923)
SELECT ('{"a": 1}'::jsonb)[now()]

-- Test 164: statement (line 926)
SELECT ('{"a": 1}'::jsonb)['a':'b']

-- Test 165: statement (line 930)
CREATE TABLE json_subscript_test (
  id SERIAL PRIMARY KEY,
  j JSONB,
  extract_field TEXT,
  extract_int_field INT
);
INSERT INTO json_subscript_test (j, extract_field, extract_int_field) VALUES
  ('{"other_field": 2}', 'other_field', 1),
  ('{"field": {"field": 2}}', 'field', 0),
  ('[1, 2, 3]', 'nothing_to_fetch', 1)

-- Test 166: query (line 943)
SELECT j, extract_field, extract_int_field, j['field'], j[extract_field], j[extract_field][extract_field], j[extract_int_field]
FROM json_subscript_test ORDER BY id

-- Test 167: query (line 952)
SELECT j FROM json_subscript_test WHERE j['other_field'] = '2' ORDER BY id

-- Test 168: statement (line 960)
CREATE TABLE test_49144 (
    value jsonb
);
INSERT INTO test_49144 VALUES ('{"c": 2}'), ('{"c": 2.5}'), ('{"c": 3}')

-- Test 169: query (line 966)
SELECT * FROM test_49144 WHERE ("test_49144"."value" -> 'c') > '2' ORDER BY 1

-- Test 170: query (line 972)
SELECT * FROM test_49144 WHERE ("test_49144"."value" -> 'c') > '2.33' ORDER BY 1

-- Test 171: query (line 984)
SELECT j::TEXT
FROM (VALUES ('1.0'::JSON), ('1'::JSON), ('1.00'::JSON)) v(j)
ORDER BY 1

-- Test 172: query (line 995)
SELECT j::TEXT
FROM (VALUES ('1.0'::JSON), ('1'::JSON), ('1.00'::JSON)) v(j)
WHERE j = '1'::JSON
ORDER BY 1

-- Test 173: query (line 1009)
WITH cte1 AS (SELECT * FROM (VALUES
  (('1':::JSON, 1)),
  (('2':::JSON, 2))
) AS tab (col1))
SELECT * FROM cte1 GROUP BY cte1.col1;

