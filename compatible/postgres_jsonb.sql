-- PostgreSQL compatible tests from postgres_jsonb
-- 87 tests

-- Test 1: query (line 6)
SELECT '[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]'::jsonb;

-- Test 2: statement (line 11)
CREATE TABLE test_jsonb (
    json_type text,
    test_json jsonb
);

-- Test 3: statement (line 17)
INSERT INTO test_jsonb VALUES
 ('scalar','"a scalar"'),
 ('array','["zero", "one","two",null,"four","five", [1,2,3],{"f1":9}]'),
 ('object','{"field1":"val1","field2":"val2","field3":null, "field4": 4, "field5": [1,2,3], "field6": {"f1":9}}');

-- Test 4: query (line 23)
SELECT test_json -> 'x' FROM test_jsonb WHERE json_type = 'scalar';

-- Test 5: query (line 28)
SELECT test_json -> 'x' FROM test_jsonb WHERE json_type = 'array';

-- Test 6: query (line 33)
SELECT test_json -> 'x' FROM test_jsonb WHERE json_type = 'object';

-- Test 7: query (line 38)
SELECT test_json -> 'field2' FROM test_jsonb WHERE json_type = 'object';

-- Test 8: query (line 43)
SELECT test_json ->> 'field2' FROM test_jsonb WHERE json_type = 'scalar';

-- Test 9: query (line 48)
SELECT test_json ->> 'field2' FROM test_jsonb WHERE json_type = 'array';

-- Test 10: query (line 53)
SELECT test_json ->> 'field2' FROM test_jsonb WHERE json_type = 'object';

-- Test 11: query (line 58)
SELECT test_json -> 2 FROM test_jsonb WHERE json_type = 'scalar';

-- Test 12: query (line 63)
SELECT test_json -> 2 FROM test_jsonb WHERE json_type = 'array';

-- Test 13: query (line 68)
SELECT test_json -> 9 FROM test_jsonb WHERE json_type = 'array';

-- Test 14: query (line 73)
SELECT test_json -> 2 FROM test_jsonb WHERE json_type = 'object';

-- Test 15: query (line 78)
SELECT test_json ->> 6 FROM test_jsonb WHERE json_type = 'array';

-- Test 16: query (line 83)
SELECT test_json ->> 7 FROM test_jsonb WHERE json_type = 'array';

-- Test 17: query (line 88)
SELECT test_json ->> 'field4' FROM test_jsonb WHERE json_type = 'object';

-- Test 18: query (line 93)
SELECT test_json ->> 'field5' FROM test_jsonb WHERE json_type = 'object';

-- Test 19: query (line 98)
SELECT test_json ->> 'field6' FROM test_jsonb WHERE json_type = 'object';

-- Test 20: query (line 103)
SELECT test_json ->> 2 FROM test_jsonb WHERE json_type = 'scalar';

-- Test 21: query (line 108)
SELECT test_json ->> 2 FROM test_jsonb WHERE json_type = 'array';

-- Test 22: query (line 113)
SELECT test_json ->> 2 FROM test_jsonb WHERE json_type = 'object';

-- Test 23: query (line 120)
SELECT (test_json->'field3') IS NULL AS expect_false FROM test_jsonb WHERE json_type = 'object';

-- Test 24: query (line 125)
SELECT (test_json->>'field3') FROM test_jsonb WHERE json_type = 'object';

-- Test 25: query (line 130)
SELECT (test_json->>'field3') IS NULL AS expect_true FROM test_jsonb WHERE json_type = 'object';

-- Test 26: query (line 135)
SELECT (test_json->3) IS NULL AS expect_false FROM test_jsonb WHERE json_type = 'array';

-- Test 27: query (line 140)
SELECT (test_json->>3) IS NULL AS expect_true FROM test_jsonb WHERE json_type = 'array';

-- Test 28: query (line 146)
SELECT '{"a": [{"b": "c"}, {"b": "cc"}]}'::jsonb -> null::text;

-- Test 29: query (line 151)
SELECT '{"a": [{"b": "c"}, {"b": "cc"}]}'::jsonb -> null::int;

-- Test 30: query (line 156)
SELECT '{"a": [{"b": "c"}, {"b": "cc"}]}'::jsonb -> 1;

-- Test 31: query (line 161)
SELECT '{"a": [{"b": "c"}, {"b": "cc"}]}'::jsonb -> 'z';

-- Test 32: query (line 166)
SELECT '{"a": [{"b": "c"}, {"b": "cc"}]}'::jsonb -> '';

-- Test 33: query (line 171)
SELECT '[{"b": "c"}, {"b": "cc"}]'::jsonb -> 1;

-- Test 34: query (line 176)
SELECT '[{"b": "c"}, {"b": "cc"}]'::jsonb -> 3;

-- Test 35: query (line 181)
SELECT '[{"b": "c"}, {"b": "cc"}]'::jsonb -> 'z';

-- Test 36: query (line 186)
SELECT '{"a": "c", "b": null}'::jsonb -> 'b';

-- Test 37: query (line 191)
SELECT '"foo"'::jsonb -> 1;

-- Test 38: query (line 196)
SELECT '"foo"'::jsonb -> 'z';

-- Test 39: query (line 201)
SELECT '{"a": [{"b": "c"}, {"b": "cc"}]}'::jsonb ->> null::text;

-- Test 40: query (line 206)
SELECT '{"a": [{"b": "c"}, {"b": "cc"}]}'::jsonb ->> null::int;

-- Test 41: query (line 211)
SELECT '{"a": [{"b": "c"}, {"b": "cc"}]}'::jsonb ->> 1;

-- Test 42: query (line 216)
SELECT '{"a": [{"b": "c"}, {"b": "cc"}]}'::jsonb ->> 'z';

-- Test 43: query (line 221)
SELECT '{"a": [{"b": "c"}, {"b": "cc"}]}'::jsonb ->> '';

-- Test 44: query (line 226)
SELECT '[{"b": "c"}, {"b": "cc"}]'::jsonb ->> 1;

-- Test 45: query (line 231)
SELECT '[{"b": "c"}, {"b": "cc"}]'::jsonb ->> 3;

-- Test 46: query (line 236)
SELECT '[{"b": "c"}, {"b": "cc"}]'::jsonb ->> 'z';

-- Test 47: query (line 241)
SELECT '{"a": "c", "b": null}'::jsonb ->> 'b';

-- Test 48: query (line 246)
SELECT '"foo"'::jsonb ->> 1;

-- Test 49: query (line 251)
SELECT '"foo"'::jsonb ->> 'z';

-- Test 50: query (line 258)
SELECT '{"x":"y"}'::jsonb = '{"x":"y"}'::jsonb;

-- Test 51: query (line 263)
SELECT '{"x":"y"}'::jsonb = '{"x":"z"}'::jsonb;

-- Test 52: query (line 268)
SELECT '{"x":"y"}'::jsonb <> '{"x":"y"}'::jsonb;

-- Test 53: query (line 273)
SELECT '{"x":"y"}'::jsonb <> '{"x":"z"}'::jsonb;

-- Test 54: query (line 280)
SELECT '{"a":"b", "b":1, "c":null}'::JSONB @> '{"a":"b"}';

-- Test 55: query (line 285)
SELECT '{"a":"b", "b":1, "c":null}'::JSONB @> '{"a":"b", "c":null}';

-- Test 56: query (line 290)
SELECT '{"a":"b", "b":1, "c":null}'::JSONB @> '{"a":"b", "g":null}';

-- Test 57: query (line 295)
SELECT '{"a":"b", "b":1, "c":null}'::JSONB @> '{"g":null}';

-- Test 58: query (line 300)
SELECT '{"a":"b", "b":1, "c":null}'::JSONB @> '{"a":"c"}';

-- Test 59: query (line 305)
SELECT '{"a":"b", "b":1, "c":null}'::JSONB @> '{"a":"b"}';

-- Test 60: query (line 310)
SELECT '{"a":"b", "b":1, "c":null}'::JSONB @> '{"a":"b", "c":"q"}';

-- Test 61: query (line 315)
SELECT '{"a":"b", "b":1, "c":null}'::JSONB @> '{"a":"b"}';

-- Test 62: query (line 320)
SELECT '{"a":"b", "b":1, "c":null}'::JSONB @> '{"a":"b", "c":null}';

-- Test 63: query (line 325)
SELECT '{"a":"b", "b":1, "c":null}'::JSONB @> '{"a":"b", "g":null}';

-- Test 64: query (line 330)
SELECT '{"a":"b", "b":1, "c":null}'::JSONB @> '{"g":null}';

-- Test 65: query (line 335)
SELECT '{"a":"b", "b":1, "c":null}'::JSONB @> '{"a":"c"}';

-- Test 66: query (line 340)
SELECT '{"a":"b", "b":1, "c":null}'::JSONB @> '{"a":"b"}';

-- Test 67: query (line 345)
SELECT '{"a":"b", "b":1, "c":null}'::JSONB @> '{"a":"b", "c":"q"}';

-- Test 68: query (line 350)
SELECT '[1,2]'::JSONB @> '[1,2,2]'::jsonb;

-- Test 69: query (line 355)
SELECT '[1,1,2]'::JSONB @> '[1,2,2]'::jsonb;

-- Test 70: query (line 360)
SELECT '[[1,2]]'::JSONB @> '[[1,2,2]]'::jsonb;

-- Test 71: query (line 365)
SELECT '[1,2,2]'::JSONB <@ '[1,2]'::jsonb;

-- Test 72: query (line 370)
SELECT '[1,2,2]'::JSONB <@ '[1,1,2]'::jsonb;

-- Test 73: query (line 375)
SELECT '[[1,2,2]]'::JSONB <@ '[[1,2]]'::jsonb;

-- Test 74: query (line 380)
SELECT '{"a":"b"}'::JSONB <@ '{"a":"b", "b":1, "c":null}';

-- Test 75: query (line 385)
SELECT '{"a":"b", "c":null}'::JSONB <@ '{"a":"b", "b":1, "c":null}';

-- Test 76: query (line 390)
SELECT '{"a":"b", "g":null}'::JSONB <@ '{"a":"b", "b":1, "c":null}';

-- Test 77: query (line 395)
SELECT '{"g":null}'::JSONB <@ '{"a":"b", "b":1, "c":null}';

-- Test 78: query (line 400)
SELECT '{"a":"c"}'::JSONB <@ '{"a":"b", "b":1, "c":null}';

-- Test 79: query (line 405)
SELECT '{"a":"b"}'::JSONB <@ '{"a":"b", "b":1, "c":null}';

-- Test 80: query (line 410)
SELECT '{"a":"b", "c":"q"}'::JSONB <@ '{"a":"b", "b":1, "c":null}';

-- Test 81: query (line 416)
SELECT '[5]'::JSONB @> '[5]';

-- Test 82: query (line 421)
SELECT '5'::JSONB @> '5';

-- Test 83: query (line 426)
SELECT '[5]'::JSONB @> '5';

-- Test 84: query (line 432)
SELECT '5'::JSONB @> '[5]';

-- Test 85: query (line 438)
SELECT '["9", ["7", "3"], 1]'::JSONB @> '["9", ["7", "3"], 1]'::jsonb;

-- Test 86: query (line 443)
SELECT '["9", ["7", "3"], ["1"]]'::JSONB @> '["9", ["7", "3"], ["1"]]'::jsonb;

-- Test 87: query (line 449)
SELECT '{ "name": "Bob", "tags": [ "enim", "qui"]}'::JSONB @> '{"tags":["qu"]}';
