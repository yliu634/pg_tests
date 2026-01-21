-- PostgreSQL compatible tests from jsonb_path_query
-- 368 tests

-- Test 1: query (line 3)
SELECT jsonb_path_query('{}', '$');

-- Test 2: statement (line 8)
-- SELECT jsonb_path_query('{}', 'strict $.a');

-- Test 3: query (line 11)
SELECT jsonb_path_query('{"a": "b"}', '$');

-- Test 4: query (line 16)
SELECT jsonb_path_query('{"a": ["b", true, false, null]}', '$');

-- Test 5: statement (line 48)
CREATE TABLE a AS SELECT '{"a": {"aa": {"aaa": "s1", "aab": 123, "aac": true, "aad": false, "aae": null, "aaf": [1, 2, 3], "aag": {"aaga": "s2"}}, "ab": "s3"}, "b": "s4", "c": [{"ca": "s5"}, {"ca": "s6"}, 1, true], "d": 123.45}'::JSONB AS data;

-- Test 6: query (line 51)
SELECT jsonb_path_query(data, '$.a.aa.aaa') FROM a;

-- Test 7: query (line 56)
SELECT jsonb_path_query(data, '$.a.aa.aab') FROM a;

-- Test 8: query (line 61)
SELECT jsonb_path_query(data, '$.a.aa.aac') FROM a;

-- Test 9: query (line 66)
SELECT jsonb_path_query(data, '$.a.aa.aad') FROM a;

-- Test 10: query (line 71)
SELECT jsonb_path_query(data, '$.a.aa.aae') FROM a;

-- Test 11: query (line 76)
SELECT jsonb_path_query(data, '$.a.aa.aaf') FROM a;

-- Test 12: query (line 81)
SELECT jsonb_path_query(data, '$.a.aa.aag') FROM a;

-- Test 13: query (line 86)
SELECT jsonb_path_query(data, '$.c') FROM a;

-- Test 14: query (line 91)
SELECT jsonb_path_query(data, '$.d') FROM a;

-- Test 15: query (line 96)
SELECT jsonb_path_query(data, '$.c[*].ca') FROM a;

-- Test 16: statement (line 102)
-- SELECT jsonb_path_query(data, 'strict $.aa') FROM a;

-- Test 17: statement (line 105)
-- SELECT jsonb_path_query(data, 'strict $.aa.aaa.aaaa') FROM a;

-- Test 18: query (line 108)
SELECT jsonb_path_query('{}', '$.a');

-- query empty
SELECT jsonb_path_query('[]', '$.a');

-- statement ok
CREATE TABLE b (j JSONB);

-- statement ok
INSERT INTO b VALUES ('{"a": [1, 2, 3], "b": "hello"}'), ('{"a": false}');

-- query T rowsort
SELECT jsonb_path_query(j, '$.a') FROM b;

-- Test 19: query (line 126)
SELECT jsonb_path_query(j, '$.b') FROM b;

-- Test 20: query (line 131)
SELECT jsonb_path_query('{"a": [1, 2, {"b": [4, 5]}, null, [true, false]]}', '$.a[*]');

-- Test 21: query (line 140)
SELECT jsonb_path_query('{"a": [1, 2, {"b": [{"c": true}, {"c": false}]}, null, [true, false], {"b": [{"c": 0.1}, {"d": null}, {"c": 10}]}]}', '$.a[*].b[*].c');

-- Test 22: query (line 148)
SELECT jsonb_path_query('{"a": [1]}', '$.a', '{}');

-- Test 23: statement (line 153)
-- SELECT jsonb_path_query('{"a": [1]}', '$.a', '[]');

-- Test 24: query (line 156)
SELECT jsonb_path_query('{"a": [1]}', '$.b', '{}', false);

-- Test 25: query (line 160)
SELECT jsonb_path_query('{"a": [1]}', '$.b', '{}', true);

-- Test 26: statement (line 164)
-- SELECT jsonb_path_query('{"a": [1]}', 'strict $.b', '{}', false);

-- Test 27: query (line 167)
SELECT jsonb_path_query('{"a": [1]}', 'strict $.b', '{}', true);

-- Test 28: query (line 171)
SELECT jsonb_path_query('{"a": {"b": [1, 2, 3]}}', '$.a[*].b[*]');

-- Test 29: statement (line 178)
-- SELECT jsonb_path_query('{"a": {"b": [1, 2, 3]}}', 'strict $.a[*].b[*]');

-- Test 30: query (line 181)
SELECT jsonb_path_query('{"a": [1, 2, 3, 4, 5]}', '$.a[0]');

-- Test 31: query (line 186)
SELECT jsonb_path_query('[1, 2, 3, 4, 5]', '$[1 to 3, 2, 1 to 3]');

-- Test 32: query (line 197)
SELECT jsonb_path_query('[1, 2, 3, 4, 5]', '$[3 to 1]');

-- query T rowsort
SELECT jsonb_path_query('[1, 2, 3, 4, 5]', '$[4 to 4]');

-- Test 33: query (line 205)
SELECT jsonb_path_query('{"a": "hello"}', '$.a[0 to 0]');

-- Test 34: query (line 210)
SELECT jsonb_path_query('{"a": [[5, 4], [7, 6], [6, 7], [10], []]}', '$.a[*][0]');

-- Test 35: statement (line 218)
-- SELECT jsonb_path_query('{"a": [[5, 4], [7, 6], [6, 7], [10], []]}', 'strict $.a[*][0]');

-- Test 36: query (line 221)
SELECT jsonb_path_query('{"a": [{}, [5, 4], [7, 6], [6, 7], [10], []]}', '$.a[*][0]');

-- Test 37: statement (line 230)
-- SELECT jsonb_path_query('{"a": [{}, [5, 4], [7, 6], [6, 7], [10], []]}', 'strict $.a[*][0]');

-- Test 38: query (line 233)
SELECT jsonb_path_query('{"a": ["hello", [5, 4], [7, 6], [6, 7], [10], []]}', '$.a[*][0]');

-- Test 39: query (line 242)
SELECT jsonb_path_query('{"a": ["hello", [5, 4], [7, 6], [6, 7], [10], []]}', '$.a[*][1]');

-- Test 40: statement (line 249)
-- SELECT jsonb_path_query('{"a": "hello"}', 'strict $.a[1 to 3]');

-- Test 41: statement (line 252)
-- SELECT jsonb_path_query('{"a": [1, 2, 3, 4, 5]}', 'strict $[3 to 1]');

-- Test 42: query (line 255)
SELECT jsonb_path_query('{"a": [1, 2, 3]}', '$.a.b');

-- statement error pgcode 2203A jsonpath member accessor can only be applied to an object
-- SELECT jsonb_path_query('{"a": [1, 2, 3]}', 'strict $.a.b');

-- query T
SELECT jsonb_path_query('[1, 2, 3, 4, 5]', '$[1]');

-- Test 43: query (line 266)
SELECT jsonb_path_query('{"a": [10, 9, 8, 7]}', '$.a[0.99]');

-- Test 44: query (line 271)
SELECT jsonb_path_query('{"a": [10, 9, 8, 7]}', '$.a[1.01]');

-- Test 45: query (line 276)
SELECT jsonb_path_query('{"a": [10, 9, 8, 7]}', '$.a[$varInt]', '{"varInt": 1, "varFloat": 2.3, "varString": "a", "varBool": true, "varNull": null}');

-- Test 46: query (line 281)
SELECT jsonb_path_query('{"a": [10, 9, 8, 7]}', '$.a[$varFloat]', '{"varInt": 1, "varFloat": 2.3, "varString": "a", "varBool": true, "varNull": null}');

-- Test 47: statement (line 286)
-- SELECT jsonb_path_query('{"a": [10, 9, 8, 7]}', '$.a[$varString]', '{"varInt": 1, "varFloat": 2.3, "varString": "a", "varBool": true, "varNull": null}');

-- Test 48: statement (line 289)
-- SELECT jsonb_path_query('{"a": [10, 9, 8, 7]}', '$.a[$varBool]', '{"varInt": 1, "varFloat": 2.3, "varString": "a", "varBool": true, "varNull": null}');

-- Test 49: statement (line 292)
-- SELECT jsonb_path_query('{"a": [10, 9, 8, 7]}', '$.a[$varNull]', '{"varInt": 1, "varFloat": 2.3, "varString": "a", "varBool": true, "varNull": null}');

-- Test 50: query (line 295)
SELECT jsonb_path_query('{"foo": [{"bar": "value"}]}', '$.foo.bar');

-- Test 51: query (line 300)
SELECT jsonb_path_query('{"foo": [{"bar": "value"}, {"bar": "value2"}, {"baz": "value3"}]}', '$.foo.bar');

-- Test 52: statement (line 306)
-- SELECT jsonb_path_query('{"foo": [{"bar": "value"}, {"bar": "value2"}]}', 'strict $.foo.bar');

-- Test 53: statement (line 309)
-- SELECT jsonb_path_query('{"a": [1, 2, 3, 4, 5]}', '$.a[$.a]');

-- Test 54: query (line 312)
SELECT jsonb_path_query('{}', '$"true"', '{"true": "hello"}');

-- Test 55: statement (line 317)
-- SELECT jsonb_path_query('{"a": []}', '$.a[true]');

-- Test 56: statement (line 320)
-- SELECT jsonb_path_query('[{"a": 1}]', '$undefined_var');

-- Test 57: query (line 323)
SELECT jsonb_path_query('{}', '2');

-- Test 58: query (line 328)
SELECT jsonb_path_query('{}'::jsonb, '8.73'::jsonpath);

-- Test 59: query (line 333)
SELECT jsonb_path_query('{}', 'false');

-- Test 60: query (line 338)
SELECT jsonb_path_query('{}', '$varInt', '{"varInt": 1, "varFloat": 2.3, "varString": "a", "varBool": true, "varNull": null}');

-- Test 61: query (line 343)
SELECT jsonb_path_query('{}', '$varFloat', '{"varInt": 1, "varFloat": 2.3, "varString": "a", "varBool": true, "varNull": null}');

-- Test 62: query (line 348)
SELECT jsonb_path_query('{}', '$varString', '{"varInt": 1, "varFloat": 2.3, "varString": "a", "varBool": true, "varNull": null}');

-- Test 63: query (line 353)
SELECT jsonb_path_query('{}', '$varBool', '{"varInt": 1, "varFloat": 2.3, "varString": "a", "varBool": true, "varNull": null}');

-- Test 64: query (line 358)
SELECT jsonb_path_query('{}', '1 < 1');

-- Test 65: query (line 363)
SELECT jsonb_path_query('{}', '1 <= 1');

-- Test 66: query (line 368)
SELECT jsonb_path_query('{}', '1 > 1');

-- Test 67: query (line 373)
SELECT jsonb_path_query('{}', '1 >= 1');

-- Test 68: query (line 378)
SELECT jsonb_path_query('{}', '1 != 1');

-- Test 69: query (line 383)
SELECT jsonb_path_query('{}', '1 == 1');

-- Test 70: query (line 388)
SELECT jsonb_path_query('{}', '(true < false)');

-- Test 71: query (line 393)
SELECT jsonb_path_query('{}', '((true <= false))');

-- Test 72: query (line 398)
SELECT jsonb_path_query('{}', '(((true > false)))');

-- Test 73: query (line 403)
SELECT jsonb_path_query('{}', 'true >= false');

-- Test 74: query (line 408)
SELECT jsonb_path_query('{}', 'true != false');

-- Test 75: query (line 413)
SELECT jsonb_path_query('{}', 'true == false');

-- Test 76: query (line 418)
SELECT jsonb_path_query('{}', '$ < 1');

-- Test 77: query (line 423)
SELECT jsonb_path_query('{}', '$ == $');

-- Test 78: query (line 428)
SELECT jsonb_path_query('{}', '1 < 2');

-- Test 79: query (line 433)
SELECT jsonb_path_query('{}', '1 <= 2');

-- Test 80: query (line 438)
SELECT jsonb_path_query('{}', '2 > 1');

-- Test 81: query (line 443)
SELECT jsonb_path_query('{}', '2 >= 1');

-- Test 82: query (line 448)
SELECT jsonb_path_query('{}', '1 == 2');

-- Test 83: query (line 453)
SELECT jsonb_path_query('{}', '1 != 2');

-- Test 84: query (line 458)
SELECT jsonb_path_query('{}', '((1 < 2))');

-- Test 85: query (line 463)
SELECT jsonb_path_query('{}', '((2 > 1))');

-- Test 86: query (line 468)
SELECT jsonb_path_query('{}', '1.5 > 1');

-- Test 87: query (line 473)
SELECT jsonb_path_query('{}', '1.5 < 2');

-- Test 88: query (line 478)
SELECT jsonb_path_query('{}', '1.5 == 1.5');

-- Test 89: query (line 483)
SELECT jsonb_path_query('{}', '1.5 != 1.5');

-- Test 90: query (line 488)
SELECT jsonb_path_query('{}', '1.0 == 1.0000');

-- Test 91: query (line 493)
SELECT jsonb_path_query('{}', '$var == $var2', '{"var": 1, "var2": 1}');

-- Test 92: query (line 498)
SELECT jsonb_path_query('{}', '$var != $var2', '{"var": 1, "var2": 1}');

-- Test 93: query (line 503)
SELECT jsonb_path_query('{}', '$var < $var2', '{"var": 1, "var2": 2}');

-- Test 94: query (line 508)
SELECT jsonb_path_query('{}', '$var <= $var2', '{"var": 1, "var2": 2}');

-- Test 95: query (line 513)
SELECT jsonb_path_query('{}', '$var > $var2', '{"var": 1, "var2": 2}');

-- Test 96: query (line 518)
SELECT jsonb_path_query('{}', '$var >= $var2', '{"var": 1, "var2": 2}');

-- Test 97: query (line 523)
SELECT jsonb_path_query('{"a": {"b": 5}}', '$.a.b > 3');

-- Test 98: query (line 528)
SELECT jsonb_path_query('{"a": {"b": 5}}', '$.a.b <= 3');

-- Test 99: query (line 533)
SELECT jsonb_path_query('{"arr": [1,2,3,4]}', '$.arr[0] == 1');

-- Test 100: query (line 538)
SELECT jsonb_path_query('{"arr": [1,2,3,4]}', '$.arr[3] >= 4');

-- Test 101: query (line 543)
SELECT jsonb_path_query('{"a": {"b": [10,20,30]}}', '$.a.b[1] < $.a.b[2]');

-- Test 102: query (line 548)
SELECT jsonb_path_query('{"x": 5, "y": 5}', '$.x == $.y');

-- Test 103: query (line 553)
SELECT jsonb_path_query('{"vals": [{"a": 1}, {"a": 2}]}', '$.vals[0].a != $.vals[1].a');

-- Test 104: query (line 558)
SELECT jsonb_path_query('{"outer": {"inner": {"val": 100}}}', '$.outer.inner.val >= 100');

-- Test 105: query (line 563)
SELECT jsonb_path_query('{"a": [2, 3]}', '$.a == 2');

-- Test 106: query (line 568)
SELECT jsonb_path_query('{"a": [1, 3]}', '$.a == 2');

-- Test 107: query (line 573)
SELECT jsonb_path_query('{"a": [2, 3]}', 'strict $.a == 2');

-- Test 108: query (line 578)
SELECT jsonb_path_query('{"a": [1, 3]}', 'strict $.a == 2');

-- Test 109: query (line 583)
SELECT jsonb_path_query('{"a": 5, "b": 10}', '$.a == 5 && $.b == 10');

-- Test 110: query (line 588)
SELECT jsonb_path_query('{"a": 5, "b": 10}', '$.a == 5 && $.b == 5');

-- Test 111: query (line 593)
SELECT jsonb_path_query('{"a": 5, "b": 10}', '$.a == 5 || $.b == 5');

-- Test 112: query (line 598)
SELECT jsonb_path_query('{"a": 5, "b": 10}', '$.a == 1 || $.b == 1');

-- Test 113: query (line 603)
SELECT jsonb_path_query('{"a": 5}', '!($.a == 1)');

-- Test 114: query (line 608)
SELECT jsonb_path_query('{"a": 5}', '!($.a == 5)');

-- Test 115: query (line 613)
SELECT jsonb_path_query('{"a": 5, "b": 10}', '(1.5 > 1.2 && (!($.a == 1) || $.b == 1))');

-- Test 116: query (line 618)
SELECT jsonb_path_query('{"a": [1,2,3]}', '$.a ? (1 == 1)');

-- Test 117: query (line 625)
SELECT jsonb_path_query('{"a": [1,2,3]}', '$.a ? (1 != 1)');

-- query T
SELECT jsonb_path_query('{"a": [1,2,3]}', 'strict $.a ? (1 == 1)');

-- Test 118: query (line 634)
SELECT jsonb_path_query('{"a": [1,2,3]}', 'StriCt $.a ? (1 == 1)');

-- Test 119: query (line 639)
SELECT jsonb_path_query('{"a": [1,2,3]}', 'strict $.a ? (1 != 1)');

-- query T rowsort
SELECT jsonb_path_query('{"a": [{"b": 1, "c": "hello"}, {"b": 2, "c": "world"}, {"b": 1, "c": "!"}]}', '$.a[*] ? (@.b == 1)');

-- Test 120: query (line 648)
SELECT jsonb_path_query('{"a": [{"b": 1, "c": "hello"}, {"b": 2, "c": "world"}, {"b": 1, "c": "!"}]}', 'strict $.a ? (@.b == 1)');

-- query T rowsort
SELECT jsonb_path_query('{"a": [{"b": 1, "c": "hello"}, {"b": 2, "c": "world"}, {"b": 1, "c": "!"}]}', '$.a ? (@.b == 1)');

-- Test 121: query (line 657)
SELECT jsonb_path_query('{"a": [[{"b": 1, "c": "hello"}, {"b": 2, "c": "world"}, {"b": 1, "c": "!"}], [{"b": 1, "c": "hello"}, {"b": 2, "c": "world"}, {"b": 1, "c": "!"}]]}', '$.a ? (@.b == 1)');

-- Test 122: query (line 663)
SELECT jsonb_path_query('{"a": [[{"b": 1, "c": "hello"}, {"b": 2, "c": "world"}, {"b": 1, "c": "!"}], [{"b": 1, "c": "hello"}, {"b": 2, "c": "world"}, {"b": 1, "c": "!"}]]}', '$.a[*] ? (@.b == 1)');

-- Test 123: query (line 671)
SELECT jsonb_path_query('{"a": [[{"b": 1, "c": "hello"}, {"b": 2, "c": "world"}, {"b": 1, "c": "!"}], [{"b": 1, "c": "hello"}, {"b": 2, "c": "world"}, {"b": 1, "c": "!"}]]}', 'strict $.a ? (@.b == 1)');

-- query empty
SELECT jsonb_path_query('{"a": [[{"b": 1, "c": "hello"}, {"b": 2, "c": "world"}, {"b": 1, "c": "!"}], [{"b": 1, "c": "hello"}, {"b": 2, "c": "world"}, {"b": 1, "c": "!"}]]}', 'strict $.a[*] ? (@.b == 1)');

-- query T rowsort
SELECT jsonb_path_query('{"a": [1,2,3,4,5]}', '$.a ? (@ > 3)');

-- Test 124: query (line 683)
SELECT jsonb_path_query('{"a": [{"b": 1, "c": 10}, {"b": 2, "c": 20}, {"b": 3, "c": 30}]}', '$.a ? (@.c > 15)');

-- Test 125: query (line 689)
SELECT jsonb_path_query('{"a": [{"b": "x", "c": true}, {"b": "y", "c": false}, {"b": "z", "c": true}]}', '$.a ? (@.c == true)');

-- Test 126: query (line 695)
SELECT jsonb_path_query('{"c": {"a": 1, "b":1}}', '$.c ? ($.c.a == @.b)');

-- Test 127: query (line 700)
SELECT jsonb_path_query('{"a": [1,2,3]}', '$.a ? (@ > 10)');

-- query empty
SELECT jsonb_path_query('{"a": [{"b": 1, "c": 10}, {"b": 2, "c": 20}]}', '$.a ? (@.c > 100)');

-- query empty
SELECT jsonb_path_query('{"a": [[[{"b": 1}], [{"b": 2}]], [[{"b": 2}], [{"b": 1}]]]}', '$.a ? (@.b == 1)');

-- query empty
SELECT jsonb_path_query('{"a": [[[[[[{"b": 1}]]]]]]}', '$.a ? (@.b == 1)');

-- query empty
SELECT jsonb_path_query('{"a": [[[{"b": 1}], [{"b": 2}]]]}', '$.a ? (@.b == 1)');

-- query T
SELECT jsonb_path_query('{}', '1 + 2');

-- Test 128: query (line 720)
SELECT jsonb_path_query('{}', '1 - 2');

-- Test 129: query (line 725)
SELECT jsonb_path_query('{}', '1 * 2');

-- Test 130: query (line 730)
SELECT jsonb_path_query('{}', '1 / 2');

-- Test 131: query (line 735)
SELECT jsonb_path_query('{}', '3 % 2');

-- Test 132: statement (line 740)
-- SELECT jsonb_path_query('{}', '1 % 0');

-- Test 133: query (line 743)
SELECT jsonb_path_query('{"a": 4, "b": 5}', '$.a + $.b');

-- Test 134: query (line 748)
SELECT jsonb_path_query('{"a": 4, "b": 5, "c": [9, 8, 7]}', '$.c[0] + $.c[1]');

-- Test 135: query (line 753)
SELECT jsonb_path_query('{"a": 4, "b": 5, "c": [9, 8, 7]}', '$.c[$.b - $.a]');

-- Test 136: query (line 758)
SELECT jsonb_path_query('{"a": 4, "b": 5, "c": [9, 8, 7]}', '$.c[$.b - $.a] + $var', '{"var": 10}');

-- Test 137: statement (line 763)
-- SELECT jsonb_path_query('{}', '1 / 0');

-- Test 138: statement (line 766)
-- SELECT jsonb_path_query('[1, 2]', '$[*] / 2');

-- Test 139: statement (line 769)
-- SELECT jsonb_path_query('[1, 2]', '2 + $[*]');

-- Test 140: statement (line 772)
-- SELECT jsonb_path_query('{"a": "hello"}', '$.a / 2');

-- Test 141: statement (line 775)
-- SELECT jsonb_path_query('{"a": null}', '2 + $.a');

-- Test 142: query (line 778)
SELECT jsonb_path_query('{}', '"a" == "b"');

-- Test 143: query (line 783)
SELECT jsonb_path_query('{}', '"a" < "b"');

-- Test 144: query (line 788)
SELECT jsonb_path_query('{}', '"a" > "b"');

-- Test 145: statement (line 793)
-- SELECT jsonb_path_query('{}', '"a" + "b"');

-- Test 146: query (line 796)
SELECT jsonb_path_query('{"data": [{"val": "a", "num": 1}, {"val": "b", "num": 2}, {"val": "a", "num": 3}]}', '$.data ? (@.val == "a")');

-- Test 147: query (line 802)
SELECT jsonb_path_query('{}', 'null == null');

-- Test 148: query (line 807)
SELECT jsonb_path_query('{}', 'null != null');

-- Test 149: query (line 812)
SELECT jsonb_path_query('{}', 'null != 1');

-- Test 150: query (line 817)
SELECT jsonb_path_query('{}', 'null <= "null"');

-- Test 151: statement (line 822)
-- SELECT jsonb_path_query('{}', 'null % 1');

-- Test 152: query (line 825)
SELECT jsonb_path_query('{}', 'null like_regex "^he.*$"');

-- Test 153: query (line 830)
SELECT jsonb_path_query('{}', '"hello" like_regex "^he.*$"');

-- Test 154: query (line 835)
SELECT jsonb_path_query('{}', '"ahello" like_regex "^he.*$"');

-- Test 155: query (line 840)
SELECT jsonb_path_query('{"a": "e"}', '$.a ? (@ like_regex "^[aeiou]")');

-- Test 156: query (line 845)
SELECT jsonb_path_query('{"a": {"b": "e"}}', '$.a ? (@.b like_regex "^[aeiou]")');

-- Test 157: query (line 850)
SELECT jsonb_path_query('{"a": {"b": "r"}}', '$.a ? (@.b like_regex "^[aeiou]")');

-- query T rowsort
SELECT jsonb_path_query('["apple", "banana", "orange", "umbrella", "grape"]', 'strict $[*] ? (@ like_regex "^[aeiou]")');

-- Test 158: query (line 860)
SELECT jsonb_path_query('[{"balance": "987_650", "name": "a"}, {"balance": "987_424", "name": "b"}, {"balance": "100", "name": "c"}]', '$[*] ? (@.balance like_regex "987_.*").balance');

-- Test 159: query (line 866)
SELECT jsonb_path_query('{"ab\\c": "hello"}', '$."ab\\c"');

-- Test 160: query (line 871)
SELECT jsonb_path_query('"a\nb"', '$ ? (@ like_regex "^.*$")');

-- query T
SELECT jsonb_path_query('"\\"', '$ ? (@ like_regex "^\\\\$")');

-- Test 161: query (line 879)
SELECT jsonb_path_query('"\\\\"', '$ ? (@ like_regex "^\\\\\\\\$")');

-- Test 162: query (line 884)
SELECT jsonb_path_query('{"paths": ["C:\\Program Files", "D:\\Data"]}', '$.paths[*] ? (@ like_regex "^[A-Z]:\\\\[A-Za-z]+$")');

-- Test 163: query (line 889)
SELECT jsonb_path_query('{"paths": ["C:\\Program Files (x86)\\", "D:\\My Documents\\", "E:\\Test!@#$"]}', '$.paths[*] ? (@ like_regex "^[A-Z]:\\\\.*\\\\$")');

-- Test 164: query (line 895)
SELECT jsonb_path_query('{"urls": ["http:\/\/example.com", "https:\/\/test.com\/path"]}', '$.urls[*] ? (@ like_regex "^https?:\/\/.*\.com")');

-- Test 165: query (line 901)
SELECT jsonb_path_query('{"mixed": ["C:/path\\to/file", "D:\\path/to\\file"]}', '$.mixed[*] ? (@ like_regex "^[A-Z]:[/\\\\].*")');

-- Test 166: query (line 907)
SELECT jsonb_path_query('["a+b", "a*b", "a?b", "a.b", "a[b]", "a{b}"]', '$[*] ? (@ like_regex "^a[\\+\\*\\?\\.]b$|^a\\[b\\]$|^a\\{b\\}$")');

-- Test 167: query (line 917)
SELECT jsonb_path_query('[null, 1, "abc", "abd", "aBdC", "abdacb", "babc", "adc\nabc", "ab\nadc"]', 'lax $[*] ? (@ like_regex "^ab.*c")');

-- Test 168: query (line 924)
SELECT jsonb_path_query('[null, 1, "abc", "abd", "aBdC", "abdacb", "babc", "adc\nabc", "ab\nadc"]', 'LaX $[*] ? (@ like_rEgeX "^ab.*c")');

-- Test 169: query (line 930)
SELECT jsonb_path_query('"He said \"Hello\\World!\""', '$ ? (@ like_regex ".*\"H.*\\\\.*!.*\".*")');

-- Test 170: query (line 935)
SELECT jsonb_path_query('["hello", "a"]', '$ like_regex "he"');

-- Test 171: query (line 940)
SELECT jsonb_path_query('["hello", "a"]', 'strict $ like_regex "he"');

-- Test 172: query (line 945)
SELECT jsonb_path_query('{"a": [1, 2], "b": "hello"}', '$.a ? ($.b == "hello") ');

-- Test 173: query (line 952)
SELECT jsonb_path_query('{"a": [1], "b": []}', '$.a == $.b');

-- Test 174: query (line 957)
SELECT jsonb_path_query('{"a": [], "b": []}', '$.a == $.b');

-- Test 175: query (line 962)
SELECT jsonb_path_query('{"a": [], "b": {}}', '$.a == $.b');

-- Test 176: query (line 967)
SELECT jsonb_path_query('{"a": [], "b": {"c": 1}}', '$.a == $.b');

-- Test 177: query (line 973)
SELECT jsonb_path_query('{"a": [], "b": []}', '$.a != $.b');

-- Test 178: query (line 978)
SELECT jsonb_path_query('{"a": [1], "b": []}', '$.a != $.b');

-- Test 179: query (line 983)
SELECT jsonb_path_query('{"a": [], "b": [1]}', '$.a < $.b');

-- Test 180: query (line 988)
SELECT jsonb_path_query('{"a": [], "b": [1]}', '$.a <= $.b');

-- Test 181: query (line 993)
SELECT jsonb_path_query('{"a": [], "b": [1]}', '$.a > $.b');

-- Test 182: query (line 998)
SELECT jsonb_path_query('{"a": [], "b": [1]}', '$.a >= $.b');

-- Test 183: query (line 1004)
SELECT jsonb_path_query('{"a": [1], "b": []}', 'strict $.a == $.b');

-- Test 184: query (line 1009)
SELECT jsonb_path_query('{"a": [], "b": []}', 'strict $.a == $.b');

-- Test 185: query (line 1014)
SELECT jsonb_path_query('{"a": [], "b": {}}', 'strict $.a == $.b');

-- Test 186: query (line 1019)
SELECT jsonb_path_query('{"a": [], "b": {"c": 1}}', 'strict $.a == $.b');

-- Test 187: query (line 1025)
SELECT jsonb_path_query('{"a": [1, 2], "b": []}', '$.a == $.b');

-- Test 188: query (line 1030)
SELECT jsonb_path_query('{"a": [], "b": [1, 2]}', '$.a == $.b');

-- Test 189: query (line 1036)
SELECT jsonb_path_query('{"a": [], "b": [null]}', '$.a == $.b');

-- Test 190: query (line 1041)
SELECT jsonb_path_query('{"a": [], "b": [0]}', '$.a == $.b');

-- Test 191: query (line 1046)
SELECT jsonb_path_query('{"a": [], "b": [false]}', '$.a == $.b');

-- Test 192: query (line 1051)
SELECT jsonb_path_query('{"a": [], "b": [""]}', '$.a == $.b');

-- Test 193: query (line 1057)
SELECT jsonb_path_query('{"a": [1], "b": [1]}', '$.a == $.b');

-- Test 194: query (line 1062)
SELECT jsonb_path_query('{"a": [1], "b": [2]}', '$.a == $.b');

-- Test 195: query (line 1067)
SELECT jsonb_path_query('{"a": "test", "b": "test"}', '$.a == $.b');

-- Test 196: query (line 1072)
SELECT jsonb_path_query('{"a": [1, 2], "b": "hello"}', 'strict $.a ? ($.b == "hello") ');

-- Test 197: query (line 1078)
SELECT jsonb_path_query('{"a": [], "b": []}', '$ ? ($.a == $.b || $.a != $.b)');

-- Test 198: query (line 1082)
SELECT jsonb_path_query('{"a": [], "b": []}', '$ ? ($.a == $.b && $.a != $.b)');

-- Test 199: query (line 1086)
SELECT jsonb_path_query('{"a": "world", "b": 2, "c": true}', '$.*');

-- Test 200: query (line 1093)
SELECT jsonb_path_query('{"a": ["hello", "world"], "b": [2, 5], "c": [true, false], "d": "non-array"}', '$.*[1]');

-- Test 201: query (line 1100)
SELECT jsonb_path_query('{"a": {"ab": 1}, "b": {"bc": 2}, "c": {"cd": 3}}', '$.*.bc');

-- Test 202: query (line 1105)
SELECT jsonb_path_query('{}', '$.*');

-- query empty
SELECT jsonb_path_query('[1, 2, 3, 4, 5]', '$.*');

-- query T rowsort
SELECT jsonb_path_query('{"a": {"x": {"y": 1}}, "b": {"x": {"z": 2}}}', '$.*.x.*');

-- Test 203: query (line 1117)
SELECT jsonb_path_query('{}', '-1');

-- Test 204: query (line 1122)
SELECT jsonb_path_query('[1, 2, 3]', '-$[*]');

-- Test 205: query (line 1129)
SELECT jsonb_path_query('[1, 2, 3]', '-$');

-- Test 206: query (line 1136)
SELECT jsonb_path_query('{}', '1 + 2 * -4');

-- Test 207: query (line 1141)
SELECT jsonb_path_query('{"a": -10, "b": -5}', '$.a * -2 + $.b');

-- Test 208: query (line 1146)
SELECT jsonb_path_query('[1, -2, 3, -4]', '$[*] ? (@ < -1)');

-- Test 209: query (line 1152)
SELECT jsonb_path_query('{"x": 5, "y": -3}', '(-$.x * 2 + $.y) / -1');

-- Test 210: statement (line 1157)
-- SELECT jsonb_path_query('{"x": 5, "y": -3}', '(-$.x * 2 + $.y) / -0');

-- Test 211: query (line 1160)
SELECT jsonb_path_query('[1, 2, 3, 4, 5]', '$[-1]');

-- statement error pgcode 22033 pq: jsonpath array subscript is out of bounds
-- SELECT jsonb_path_query('[1, 2, 3, 4, 5]', 'strict $[-1]');

-- statement error pgcode 2203B pq: operand of unary jsonpath operator - is not a numeric value
-- SELECT jsonb_path_query('[1, 2, 3, 4, "hello"]', '-$[*]');

-- statement error pgcode 2203B pq: operand of unary jsonpath operator \+ is not a numeric value
-- SELECT jsonb_path_query('null', '+$');

-- query T
SELECT jsonb_path_query('{}', '+1');

-- Test 212: query (line 1177)
SELECT jsonb_path_query('[1, 2, 3]', '+$[*]');

-- Test 213: query (line 1184)
SELECT jsonb_path_query('{}', '+1 + 2 * +4');

-- Test 214: query (line 1189)
SELECT jsonb_path_query('[1, 2, 3, 4]', '$[*] ? (@ > +2)');

-- Test 215: statement (line 1195)
-- SELECT jsonb_path_query('{}', 'last'::JSONPATH);

-- Test 216: statement (line 1198)
-- SELECT jsonb_path_query('{}', '@'::JSONPATH);

-- Test 217: query (line 1201)
SELECT jsonb_path_query('[1, 2, 3, 4]', '$[last]');

-- Test 218: query (line 1207)
SELECT jsonb_path_query('[1, 2, 3, 4]', '$[LaSt]');

-- Test 219: query (line 1212)
SELECT jsonb_path_query('"hello"', '$[last]');

-- Test 220: query (line 1217)
SELECT jsonb_path_query('[1, 2, 3, 4]', '$[1 to last, last to last]');

-- Test 221: query (line 1225)
SELECT jsonb_path_query('[1, 2, 3]', 'exists($[*])');

-- Test 222: query (line 1230)
SELECT jsonb_path_query('[]', 'exists($[*])');

-- Test 223: query (line 1235)
SELECT jsonb_path_query('[{"items": [{"id": 1}, {"id": 2}]}, {"items": []}]', '$[*] ? (exists(@.items[*].id))');

-- Test 224: query (line 1240)
SELECT jsonb_path_query('[{"a": 1, "b": 2}, {"a": 1}, {"b": 2}, {}]', '$[*] ? (exists(@.a) && exists(@.b))');

-- Test 225: query (line 1245)
SELECT jsonb_path_query('{}', '(1 + 2 == 3) is unknown');

-- Test 226: query (line 1250)
SELECT jsonb_path_query('{}', '($ < 1) is unknown');

-- Test 227: query (line 1255)
SELECT jsonb_path_query('{}', '(null like_regex "^he.*$") is unknown');

-- Test 228: query (line 1261)
SELECT jsonb_path_query('{}', '(null like_RegEx "^he.*$") is unknown');

-- Test 229: query (line 1266)
SELECT jsonb_path_query('"abcdef"', '$ starts with "abc"');

-- Test 230: query (line 1271)
SELECT jsonb_path_query('"abc"', '$ starts with "abc"');

-- Test 231: query (line 1276)
SELECT jsonb_path_query('"ab"', '$ starts with "abc"');

-- Test 232: query (line 1281)
SELECT jsonb_path_query('"abcdef"', '$ starts with $var', '{"var": "abc"}');

-- Test 233: query (line 1286)
SELECT jsonb_path_query('"abc"', '$ starts with $var', '{"var": "abc"}');

-- Test 234: query (line 1291)
SELECT jsonb_path_query('"ab"', '$ starts with $var', '{"var": "abc"}');

-- Test 235: query (line 1296)
SELECT jsonb_path_query('["ab", "abc"]', '$ starts with $var', '{"var": "abc"}');

-- Test 236: query (line 1301)
SELECT jsonb_path_query('["ab", "a"]', '$ starts with $var', '{"var": "abc"}');

-- Test 237: query (line 1306)
SELECT jsonb_path_query('["ab", "abc"]', 'strict $ starts with $var', '{"var": "abc"}');

-- Test 238: query (line 1311)
SELECT jsonb_path_query('["ab", "abc"]', 'strict $ starts with $var', '{"var": 1}');

-- Test 239: query (line 1316)
SELECT jsonb_path_query('["ab", 1]', 'strict $ starts with $var', '{"var": "abc"}');

-- Test 240: query (line 1321)
SELECT jsonb_path_query('{}', 'exists(2 + "3")');

-- Test 241: query (line 1326)
SELECT jsonb_path_query('{}', '2 / 0 > 0');

-- Test 242: query (line 1331)
SELECT jsonb_path_query('{"g": [{"x": 2}, {"y": 3}]}', 'lax $.g ? ((exists (@.x + "3")) is unknown)');

-- Test 243: query (line 1337)
SELECT jsonb_path_query('{"g": [{"x": 2}, {"y": 3}]}', 'strict $.g[*] ? ((exists (@.x)) is unknown)');

-- Test 244: query (line 1342)
SELECT jsonb_path_query('{"g": [{"x": 2}, {"y": 3}]}', 'strict $.g ? ((exists (@[*].x)) is unknown)');

-- Test 245: query (line 1347)
SELECT jsonb_path_query('[1,2,0,3]', '$[*] ? ((2 / @ > 0) is unknown)');

-- Test 246: statement (line 1352)
-- SELECT jsonb_path_query('{}', 'strict $.a', '{}', false);

-- Test 247: query (line 1355)
SELECT jsonb_path_query('{}', 'strict $.a', '{}', true);

-- query empty
SELECT jsonb_path_query('{}', '$.a', '{}', false);

-- query empty
SELECT jsonb_path_query('{}', '$.a', '{}', true);

-- query empty
SELECT jsonb_path_query('{}', 'strict 0 / 0', '{}', true);

-- statement error pgcode 22012 pq: division by zero
-- SELECT jsonb_path_query('{}', 'strict 0 / 0', '{}', false);

-- query empty
SELECT jsonb_path_query('{}', '0 / 0', '{}', true);

-- statement error pgcode 22012 pq: division by zero
-- SELECT jsonb_path_query('{}', '0 / 0', '{}', false);

-- query T
SELECT jsonb_path_query('{}', 'strict (0 / 0) < (0 / 0)', '{}', true);

-- Test 248: query (line 1381)
SELECT jsonb_path_query('{}', 'strict (0 / 0) < (0 / 0)', '{}', false);

-- Test 249: query (line 1386)
SELECT jsonb_path_query('{}', '(0 / 0) < (0 / 0)', '{}', true);

-- Test 250: query (line 1391)
SELECT jsonb_path_query('{}', '(0 / 0) < (0 / 0)', '{}', false);

-- Test 251: query (line 1396)
SELECT jsonb_path_query('{}', 'strict $[*]', '{}', true);

-- statement error pgcode 22039 pq: jsonpath wildcard array accessor can only be applied to an array
-- SELECT jsonb_path_query('{}', 'strict $[*]', '{}', false);

-- query T
SELECT jsonb_path_query('{}', '$[*]', '{}', true);

-- Test 252: query (line 1407)
SELECT jsonb_path_query('{}', '$[*]', '{}', false);

-- Test 253: query (line 1412)
SELECT jsonb_path_query('{"a": 1}', 'strict $[0]', '{}', true);

-- statement error pgcode 22039 pq: jsonpath array accessor can only be applied to an array
-- SELECT jsonb_path_query('{"a": 1}', 'strict $[0]', '{}', false);

-- query T
SELECT jsonb_path_query('{"a": 1}', '$[0]', '{}', true);

-- Test 254: query (line 1423)
SELECT jsonb_path_query('{"a": 1}', '$[0]', '{}', false);

-- Test 255: query (line 1428)
SELECT jsonb_path_query('[1, 2, 3]', 'strict $[3]', '{}', true);

-- statement error pgcode 22033 pq: jsonpath array subscript is out of bounds
-- SELECT jsonb_path_query('[1, 2, 3]', 'strict $[3]', '{}', false);

-- query empty
SELECT jsonb_path_query('[1, 2, 3]', '$[3]', '{}', true);

-- query empty
SELECT jsonb_path_query('[1, 2, 3]', '$[3]', '{}', false);

-- query empty
SELECT jsonb_path_query('[1, 2, 3]', 'strict $["a"]', '{}', true);

-- statement error pgcode 22033 pq: jsonpath array subscript is not a single numeric value
-- SELECT jsonb_path_query('[1, 2, 3]', 'strict $["a"]', '{}', false);

-- query empty
SELECT jsonb_path_query('[1, 2, 3]', '$["a"]', '{}', true);

-- statement error pgcode 22033 pq: jsonpath array subscript is not a single numeric value
-- SELECT jsonb_path_query('[1, 2, 3]', '$["a"]', '{}', false);

-- query empty
SELECT jsonb_path_query('{"a": "hello"}', 'strict $.a[1 to 3]', '{}', true);

-- statement error pgcode 22039 pq: jsonpath array accessor can only be applied to an array
-- SELECT jsonb_path_query('{"a": "hello"}', 'strict $.a[1 to 3]', '{}', false);

-- query empty
SELECT jsonb_path_query('{"a": "hello"}', '$.a[1 to 3]', '{}', true);

-- query empty
SELECT jsonb_path_query('{"a": "hello"}', '$.a[1 to 3]', '{}', false);

-- query empty
SELECT jsonb_path_query('"abc"', 'strict $.a', '{}', true);

-- statement error pgcode 2203A pq: jsonpath member accessor can only be applied to an object
-- SELECT jsonb_path_query('"abc"', 'strict $.a', '{}', false);

-- query empty
SELECT jsonb_path_query('"abc"', '$.a', '{}', true);

-- query empty
SELECT jsonb_path_query('"abc"', '$.a', '{}', false);

-- query empty
SELECT jsonb_path_query('"abc"', 'strict $.*', '{}', true);

-- statement error pgcode 2203C pq: jsonpath wildcard member accessor can only be applied to an object
-- SELECT jsonb_path_query('"abc"', 'strict $.*', '{}', false);

-- query empty
SELECT jsonb_path_query('"abc"', '$.*', '{}', true);

-- query empty
SELECT jsonb_path_query('"abc"', '$.*', '{}', false);

-- query empty
SELECT jsonb_path_query('{}', 'strict -$', '{}', true);

-- statement error pgcode 2203B pq: operand of unary jsonpath operator - is not a numeric value
-- SELECT jsonb_path_query('{}', 'strict -$', '{}', false);

-- query empty
SELECT jsonb_path_query('{}', '-$', '{}', true);

-- statement error pgcode 2203B pq: operand of unary jsonpath operator - is not a numeric value
-- SELECT jsonb_path_query('{}', '-$', '{}', false);

-- query empty
SELECT jsonb_path_query('{}', 'strict $ - 1', '{}', true);

-- statement error pgcode 22038 pq: left operand of jsonpath operator - is not a single numeric value
-- SELECT jsonb_path_query('{}', 'strict $ - 1', '{}', false);

-- query empty
SELECT jsonb_path_query('{}', '$ - 1', '{}', true);

-- statement error pgcode 22038 pq: left operand of jsonpath operator - is not a single numeric value
-- SELECT jsonb_path_query('{}', '$ - 1', '{}', false);

-- query empty
SELECT jsonb_path_query('{}', 'strict 1 - $', '{}', true);

-- statement error pgcode 22038 pq: right operand of jsonpath operator - is not a single numeric value
-- SELECT jsonb_path_query('{}', 'strict 1 - $', '{}', false);

-- query empty
SELECT jsonb_path_query('{}', '1 - $', '{}', true);

-- statement error pgcode 22038 pq: right operand of jsonpath operator - is not a single numeric value
-- SELECT jsonb_path_query('{}', '1 - $', '{}', false);

-- statement error pgcode 42704 pq: could not find jsonpath variable "var"
-- SELECT jsonb_path_query('{}', 'strict $var', '{}', true);

-- statement error pgcode 42704 pq: could not find jsonpath variable "var"
-- SELECT jsonb_path_query('{}', 'strict $var', '{}', false);

-- statement error pgcode 42704 pq: could not find jsonpath variable "var"
-- SELECT jsonb_path_query('{}', '$var', '{}', true);

-- statement error pgcode 42704 pq: could not find jsonpath variable "var"
-- SELECT jsonb_path_query('{}', '$var', '{}', false);

-- query T
SELECT jsonb_path_query('[1, 2, 3]', '($[*] > 2) ? (@ == true)');

-- Test 256: query (line 1541)
SELECT jsonb_path_query('[1, 2, 3]', '((($[*] > (2)))) ? ((@ == true))');

-- Test 257: query (line 1546)
SELECT jsonb_path_query('{"a": {"b": {"c": 1}}}', '($.a.b).c');

-- Test 258: query (line 1551)
SELECT jsonb_path_query('{"a": {"b": {"c": 1, "d": 2}}}', '($.a.b).*');

-- Test 259: query (line 1557)
SELECT jsonb_path_query('{"a": [10, 20, 30]}', '($.a)[1]');

-- Test 260: query (line 1562)
SELECT jsonb_path_query('{"a": {"b": [{"c": 1}, {"c": 2}]}}', '($.a.b[1]).c');

-- Test 261: statement (line 1567)
-- SELECT jsonb_path_query('[1]', 'lax $[10000000000000000]');

-- Test 262: statement (line 1570)
-- SELECT jsonb_path_query('[1]', 'lax $[-10000000000000000]');

-- Test 263: query (line 1574)
SELECT jsonb_path_query('[1]', '$[2147483647]');

-- # MaxInt32 + 1
-- statement error pgcode 22033 pq: jsonpath array subscript is out of integer range
-- SELECT jsonb_path_query('[1]', '$[2147483648]');

-- # MinInt32
-- query empty
SELECT jsonb_path_query('[1]', '$[-2147483648]');

-- # MinInt32 - 1
-- statement error pgcode 22033 pq: jsonpath array subscript is out of integer range
-- SELECT jsonb_path_query('[1]', '$[-2147483649]');

-- query T
SELECT jsonb_path_query('[1, 2]', '$.size()');

-- Test 264: query (line 1594)
SELECT jsonb_path_query('[]', '$.size()');

-- Test 265: query (line 1599)
SELECT jsonb_path_query('{}', '$.size()');

-- Test 266: statement (line 1604)
-- SELECT jsonb_path_query('{}', 'strict $.size()');

-- Test 267: query (line 1607)
SELECT jsonb_path_query('[1,null,true,"11",[],[1],[1,2,3],{},{"a":1,"b":2}]', 'lax $[*].size()');

-- Test 268: statement (line 1620)
-- SELECT jsonb_path_query('[1,null,true,"11",[],[1],[1,2,3],{},{"a":1,"b":2}]', 'strict $[*].size()');

-- Test 269: query (line 1623)
SELECT jsonb_path_query('[12, {"a": 13}, {"b": 14}, "ccc", true]', '$[2 - 1 to $.size() - 2]');

-- Test 270: query (line 1630)
SELECT jsonb_path_query('{}', '$.type()');

-- Test 271: query (line 1635)
SELECT jsonb_path_query('[]', '$.type()');

-- Test 272: query (line 1640)
SELECT jsonb_path_query('"hello"', '$.type()');

-- Test 273: query (line 1645)
SELECT jsonb_path_query('0', '$.type()');

-- Test 274: query (line 1650)
SELECT jsonb_path_query('0.1', '$.type()');

-- Test 275: query (line 1655)
SELECT jsonb_path_query('true', '$.type()');

-- Test 276: query (line 1660)
SELECT jsonb_path_query('false', '$.type()');

-- Test 277: query (line 1665)
SELECT jsonb_path_query('null', '$.type()');

-- Test 278: query (line 1670)
SELECT jsonb_path_query('null', '"123".type()');

-- Test 279: query (line 1675)
SELECT jsonb_path_query('null', '(123).type()');

-- Test 280: query (line 1680)
SELECT jsonb_path_query('null', 'true.type()');

-- Test 281: query (line 1685)
SELECT jsonb_path_query('null', 'null.type()');

-- Test 282: query (line 1690)
SELECT jsonb_path_query('[null,1,true,"a",[],{}]', '$[*].type()');

-- Test 283: query (line 1700)
SELECT jsonb_path_query('[null,1,true,"a",[],{}]', 'lax $.type()');

-- Test 284: query (line 1708)
SELECT jsonb_path_query('[1,2,3]', '$[last ? (@.type() == "number")]');

-- Test 285: query (line 1713)
SELECT jsonb_path_query('[1, 2, 3]', '$[1.1]');

-- Test 286: query (line 1718)
SELECT jsonb_path_query('[1, 2, 3]', '$[1.5]');

-- Test 287: query (line 1723)
SELECT jsonb_path_query('[1, 2, 3]', '$[1.99999999]');

-- Test 288: query (line 1728)
SELECT jsonb_path_query('[1, 2, 3]', '$[2.1]');

-- Test 289: query (line 1733)
SELECT jsonb_path_query('[1, 2, 3]', '$[2.5]');

-- Test 290: query (line 1738)
SELECT jsonb_path_query('[1, 2, 3]', '$[2.99999999]');

-- Test 291: query (line 1743)
SELECT jsonb_path_query('[1, 2, 3]', '$[-0.1]');

-- Test 292: query (line 1748)
SELECT jsonb_path_query('[1, 2, 3]', '$[-0.5]');

-- Test 293: query (line 1753)
SELECT jsonb_path_query('[1, 2, 3]', '$[-0.99999999]');

-- Test 294: query (line 1758)
SELECT jsonb_path_query('[1, 2, 3]', '$[-1.01]');

-- query T
SELECT jsonb_path_query('[1, 2, 3]', 'strict $[-0.9999999999999]');

-- Test 295: statement (line 1766)
-- SELECT jsonb_path_query('[1, 2, 3]', 'strict $[-1.01]');

-- Test 296: statement (line 1769)
-- SELECT jsonb_path_query('{"a": 10}', '$ ? (@.a < $value)');

-- Test 297: statement (line 1772)
-- SELECT jsonb_path_query('{"a": 10}', '$ ? (@.a < $value)', '{}');

-- Test 298: statement (line 1775)
-- SELECT jsonb_path_query('{"a": 10}', '$ ? (@.a < $value)', '{"other": 10}');

-- Test 299: query (line 1778)
SELECT jsonb_path_query('{"a": 10}', '$ ? (@.a < $value)', '{"value": 11}');

-- Test 300: statement (line 1783)
-- SELECT jsonb_path_query('{"a": 10, "b": 20}', '$ ? (@.a < $value && @.b > $value)');

-- Test 301: statement (line 1786)
-- SELECT jsonb_path_query('{"a": 10, "b": 20}', '$ ? (@.a < $min && @.b > $max)');

-- Test 302: statement (line 1789)
-- SELECT jsonb_path_query('{"a": 10}', 'strict $ ? (@.a < $value)', '{}', true);

-- Test 303: statement (line 1792)
-- SELECT jsonb_path_query('{"a": 10}', 'strict $ ? (@.a < $value)', '{}', false);

-- Test 304: statement (line 1795)
-- SELECT jsonb_path_query('{"a": 10}', '$ ? (@.a < $value)', '{}', true);

-- Test 305: statement (line 1798)
-- SELECT jsonb_path_query('{"a": 10}', '$ ? (@.a < $value)', '{}', false);

-- Test 306: statement (line 1801)
-- SELECT jsonb_path_query('{}', '$ ? ($d < $a && @.c > $b)');

-- Test 307: query (line 1804)
SELECT jsonb_path_query('{"a": 10}', '$ ? ((@.a < 12) || (@.a < $value))');

-- Test 308: statement (line 1809)
-- SELECT jsonb_path_query('{}', '$.abs()');

-- Test 309: statement (line 1812)
-- SELECT jsonb_path_query('"a"', '$.abs()');

-- Test 310: statement (line 1815)
-- SELECT jsonb_path_query('true', '$.abs()');

-- Test 311: statement (line 1818)
-- SELECT jsonb_path_query('null', '$.abs()');

-- Test 312: query (line 1821)
SELECT jsonb_path_query('{}', '(1).abs()');

-- Test 313: query (line 1826)
SELECT jsonb_path_query('{}', '(-1).abs()');

-- Test 314: query (line 1831)
SELECT jsonb_path_query('{}', '(0.5).abs()');

-- Test 315: query (line 1836)
SELECT jsonb_path_query('{}', '(-0.5).abs()');

-- Test 316: query (line 1841)
SELECT jsonb_path_query('[1, -1, 0.5, -0.5]', '$.abs()');

-- Test 317: query (line 1849)
SELECT jsonb_path_query('{}', '(1).ceiling()');

-- Test 318: query (line 1854)
SELECT jsonb_path_query('{}', '(-1).ceiling()');

-- Test 319: query (line 1859)
SELECT jsonb_path_query('{}', '(0.5).ceiling()');

-- Test 320: query (line 1864)
SELECT jsonb_path_query('{}', '(-0.5).ceiling()');

-- Test 321: query (line 1869)
SELECT jsonb_path_query('{}', '(0.1).ceiling()');

-- Test 322: query (line 1874)
SELECT jsonb_path_query('{}', '(-0.1).ceiling()');

-- Test 323: query (line 1879)
SELECT jsonb_path_query('{}', '(0.9).ceiling()');

-- Test 324: query (line 1884)
SELECT jsonb_path_query('{}', '(-0.9).ceiling()');

-- Test 325: query (line 1889)
SELECT jsonb_path_query('[1, -1, 0.5, -0.5, 0.1, -0.1, 0.9, -0.9]', '$.ceiling()');

-- Test 326: query (line 1901)
SELECT jsonb_path_query('{}', '(1).floor()');

-- Test 327: query (line 1906)
SELECT jsonb_path_query('{}', '(-1).floor()');

-- Test 328: query (line 1911)
SELECT jsonb_path_query('{}', '(0.5).floor()');

-- Test 329: query (line 1916)
SELECT jsonb_path_query('{}', '(-0.5).floor()');

-- Test 330: query (line 1921)
SELECT jsonb_path_query('{}', '(0.1).floor()');

-- Test 331: query (line 1926)
SELECT jsonb_path_query('{}', '(-0.1).floor()');

-- Test 332: query (line 1931)
SELECT jsonb_path_query('{}', '(0.9).floor()');

-- Test 333: query (line 1936)
SELECT jsonb_path_query('{}', '(-0.9).floor()');

-- Test 334: query (line 1941)
SELECT jsonb_path_query('[1, -1, 0.5, -0.5, 0.1, -0.1, 0.9, -0.9]', '$.floor()');

-- Test 335: statement (line 1953)
-- SELECT jsonb_path_query('[[1, 2]]', '$.abs()');

-- Test 336: statement (line 1956)
-- SELECT jsonb_path_query('[1, 2, [3, 4]]', '$.abs()');

-- Test 337: query (line 1959)
SELECT jsonb_path_query('{"a": -0.5}', '$.a.abs()');

-- Test 338: statement (line 1964)
-- SELECT jsonb_path_query('"1"', '$.abs()');

-- Test 339: statement (line 1967)
-- SELECT jsonb_path_query('{}', '(null).floor()');

-- Test 340: query (line 1970)
SELECT jsonb_path_query('"Hello"', '$ like_regex "hello" flag "i"');

-- Test 341: query (line 1975)
SELECT jsonb_path_query('"HELLO"', '$ like_regex "hello" flag "i"');

-- Test 342: query (line 1982)
SELECT jsonb_path_query('"HELLO"', '$ like_regex "hello" flag ""');

-- Test 343: query (line 1987)
SELECT jsonb_path_query('"Hello\nWorld"', '$ like_regex "Hello.World" flag "s"');

-- Test 344: query (line 1992)
SELECT jsonb_path_query('"Hello\nWorld"', '$ like_regex "Hello.World" flag ""');

-- Test 345: query (line 1997)
SELECT jsonb_path_query('"Line1\nLine2"', '$ like_regex "^Line2$" flag "m"');

-- Test 346: query (line 2002)
SELECT jsonb_path_query('"Line1\nLine2"', '$ like_regex "^Line2$" flag ""');

-- Test 347: query (line 2007)
SELECT jsonb_path_query('"Hello123World"', '$ like_regex "Hello.*World" flag "q"');

-- Test 348: query (line 2012)
SELECT jsonb_path_query('"Hello123World"', '$ like_regex "Hello.*World" flag ""');

-- Test 349: query (line 2018)
SELECT jsonb_path_query('"Hello\nWorld"', '$ like_regex "hello.world" flag "is"');

-- Test 350: query (line 2024)
SELECT jsonb_path_query('"Line1\nline2"', '$ like_regex "^LINE2$" flag "im"');

-- Test 351: query (line 2030)
SELECT jsonb_path_query('"Hello123World"', '$ like_regex "HELLO.*WORLD" flag "iq"');

-- Test 352: query (line 2036)
SELECT jsonb_path_query('"Line1\nLine2\nLine3"', '$ like_regex "^Line1.Line2.Line3$" flag "ms"');

-- Test 353: query (line 2041)
SELECT jsonb_path_query('"Line1\nLine2\nLine3"', '$ like_regex "^Line1.Line2.Line3$" flag "m"');

-- Test 354: query (line 2047)
SELECT jsonb_path_query('"Hello\nWorld"', '$ like_regex "Hello.World" flag "sq"');

-- Test 355: query (line 2053)
SELECT jsonb_path_query('"Line1\nLine2"', '$ like_regex "^Line1\nLine2$" flag "mq"');

-- Test 356: query (line 2059)
SELECT jsonb_path_query('{"STRICT": 1}'::JSONB, 'strIct $.STRICT'::JSONPATH);

-- Test 357: query (line 2064)
SELECT jsonb_path_query('{"STRICT": 1}'::JSONB, 'lax $.STRICT'::JSONPATH);

-- Test 358: query (line 2069)
SELECT jsonb_path_query('{"STRICT": 1}'::JSONB, 'lax $.strict'::JSONPATH);

-- Test 359: query (line 2073)
SELECT jsonb_path_query('{"STRICt": 1}'::JSONB, '$.STRICt'::JSONPATH);

-- Test 360: query (line 2078)
SELECT jsonb_path_query('{"STRICt": 1}'::JSONB, '$.STRICT'::JSONPATH);

-- Test 361: query (line 2082)
SELECT jsonb_path_query('{"strict": 1}'::JSONB, '$.STRICT'::JSONPATH);

-- Test 362: query (line 2086)
SELECT jsonb_path_query('{"strict": 1}'::JSONB, 'lax $.STRICT'::JSONPATH);

-- Test 363: query (line 2090)
SELECT jsonb_path_query('{"strict": 1}'::JSONB, '$.STRICt'::JSONPATH);

-- Test 364: query (line 2094)
SELECT jsonb_path_query('{"strict": 1}'::JSONB, 'lax $.STRICt'::JSONPATH);

-- Test 365: query (line 2098)
SELECT jsonb_path_query('{"strict": 1}'::JSONB, '$.strict'::JSONPATH);

-- Test 366: query (line 2103)
SELECT jsonb_path_query('{"LIKE_REGEX": 1}'::JSONB, '$.LIKE_REGEX'::JSONPATH);

-- Test 367: query (line 2108)
SELECT jsonb_path_query('{"LIKE_REGEx": 1}'::JSONB, '$.LIKE_REGEx'::JSONPATH);

-- Test 368: query (line 2113)
SELECT jsonb_path_query('{"LIKE_REGEx": 1}'::JSONB, '$.LIKE_REGEX'::JSONPATH);

