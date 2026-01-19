-- PostgreSQL compatible tests from json_builtins
-- 218 tests

-- Test 1: query (line 4)
SELECT json_typeof('-123.4'::JSON)

-- Test 2: query (line 9)
SELECT jsonb_typeof('-123.4'::JSON)

-- Test 3: query (line 14)
SELECT json_typeof('"-123.4"'::JSON)

-- Test 4: query (line 19)
SELECT jsonb_typeof('"-123.4"'::JSON)

-- Test 5: query (line 24)
SELECT json_typeof('{"1": {"2": 3}}'::JSON)

-- Test 6: query (line 29)
SELECT jsonb_typeof('{"1": {"2": 3}}'::JSON)

-- Test 7: query (line 34)
SELECT json_typeof('[1, 2, [3]]'::JSON)

-- Test 8: query (line 39)
SELECT jsonb_typeof('[1, 2, [3]]'::JSON)

-- Test 9: query (line 44)
SELECT json_typeof('true'::JSON)

-- Test 10: query (line 49)
SELECT jsonb_typeof('true'::JSON)

-- Test 11: query (line 54)
SELECT json_typeof('false'::JSON)

-- Test 12: query (line 59)
SELECT jsonb_typeof('false'::JSON)

-- Test 13: query (line 64)
SELECT json_typeof('null'::JSON)

-- Test 14: query (line 69)
SELECT jsonb_typeof('null'::JSON)

-- Test 15: query (line 75)
SELECT array_to_json(ARRAY[[1, 2], [3, 4]])

-- Test 16: query (line 80)
SELECT array_to_json('{1, 2, 3}'::INT[])

-- Test 17: query (line 90)
SELECT array_to_json('{1.0, 2.0, 3.0}'::DECIMAL[])

-- Test 18: query (line 95)
SELECT array_to_json(NULL)

-- Test 19: query (line 100)
SELECT array_to_json(ARRAY[1, 2, 3], NULL)

-- Test 20: query (line 105)
SELECT array_to_json(ARRAY[1, 2, 3], false)

-- Test 21: query (line 123)
SELECT to_json('\a'::TEXT)

-- Test 22: query (line 128)
SELECT to_json('\a'::TEXT COLLATE "fr_FR")

-- Test 23: query (line 133)
SELECT to_json(3::OID::INT::OID)

-- Test 24: query (line 138)
SELECT to_json('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'::UUID);

-- Test 25: query (line 143)
SELECT to_json('\x0001'::BYTEA)

-- Test 26: query (line 148)
SELECT to_json(true::BOOL)

-- Test 27: query (line 153)
SELECT to_json(false::BOOL)

-- Test 28: query (line 158)
SELECT to_json('"a"'::JSON)

-- Test 29: query (line 163)
SELECT to_json(1.234::FLOAT)

-- Test 30: query (line 168)
SELECT to_json(1.234::DECIMAL)

-- Test 31: query (line 173)
SELECT to_json('10.1.0.0/16'::INET)

-- Test 32: query (line 178)
SELECT to_json(ARRAY[[1, 2], [3, 4]])

-- Test 33: query (line 183)
SELECT to_json('2014-05-28 12:22:35.614298'::TIMESTAMP)

-- Test 34: query (line 188)
SELECT to_json('2014-05-28 12:22:35.614298-04'::TIMESTAMPTZ)

-- Test 35: query (line 193)
SELECT to_json('2014-05-28 12:22:35.614298-04'::TIMESTAMP)

-- Test 36: query (line 198)
SELECT to_json('2014-05-28'::DATE)

-- Test 37: query (line 203)
SELECT to_json('00:00:00'::TIME)

-- Test 38: query (line 208)
SELECT to_json('2h45m2s234ms'::INTERVAL)

-- Test 39: query (line 213)
SELECT to_json((1, 2, 'hello', NULL, NULL))

-- Test 40: query (line 218)
SELECT to_json(('$'::JSONPATH, '$.foo'::JSONPATH))

-- Test 41: query (line 223)
SELECT to_json(('foo'::LTREE, 'bar'::LTREE))

-- Test 42: query (line 228)
SELECT to_jsonb(123::INT)

-- Test 43: query (line 233)
SELECT to_jsonb('\a'::TEXT)

-- Test 44: query (line 238)
SELECT to_jsonb('\a'::TEXT COLLATE "fr_FR")

-- Test 45: query (line 243)
SELECT to_jsonb(3::OID::INT::OID)

-- Test 46: query (line 248)
SELECT to_jsonb('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'::UUID);

-- Test 47: query (line 253)
SELECT to_jsonb('\x0001'::BYTEA)

-- Test 48: query (line 258)
SELECT to_jsonb(true::BOOL)

-- Test 49: query (line 263)
SELECT to_jsonb(false::BOOL)

-- Test 50: query (line 268)
SELECT to_jsonb('"a"'::JSON)

-- Test 51: query (line 273)
SELECT to_jsonb(1.234::FLOAT)

-- Test 52: query (line 278)
SELECT to_jsonb(1.234::DECIMAL)

-- Test 53: query (line 283)
SELECT to_jsonb('10.1.0.0/16'::INET)

-- Test 54: query (line 288)
SELECT to_jsonb(ARRAY[[1, 2], [3, 4]])

-- Test 55: query (line 293)
SELECT to_jsonb('2014-05-28 12:22:35.614298'::TIMESTAMP)

-- Test 56: query (line 298)
SELECT to_jsonb('2014-05-28 12:22:35.614298-04'::TIMESTAMPTZ)

-- Test 57: query (line 303)
SELECT to_jsonb('2014-05-28 12:22:35.614298-04'::TIMESTAMP)

-- Test 58: query (line 308)
SELECT to_jsonb('2014-05-28'::DATE)

-- Test 59: query (line 313)
SELECT to_jsonb('00:00:00'::TIME)

-- Test 60: query (line 318)
SELECT to_jsonb('2h45m2s234ms'::INTERVAL)

-- Test 61: query (line 323)
SELECT to_jsonb((1, 2, 'hello', NULL, NULL))

-- Test 62: query (line 328)
SELECT to_json(x.*) FROM (VALUES (1,2)) AS x(a,b);

-- Test 63: query (line 333)
SELECT to_json(x.*) FROM (VALUES (1,2)) AS x(a);

-- Test 64: query (line 338)
SELECT to_json(x.*) FROM (VALUES (1,2)) AS x(column2);

-- Test 65: statement (line 344)
SELECT json_agg((3808362714,))

-- Test 66: query (line 349)
SELECT json_array_elements('[1, 2, 3]'::JSON)

-- Test 67: query (line 357)
SELECT * FROM json_array_elements('[1, 2, 3]'::JSON)

-- Test 68: query (line 365)
SELECT jsonb_array_elements('[1, 2, 3]'::JSON)

-- Test 69: query (line 373)
SELECT * FROM jsonb_array_elements('[1, 2, 3]'::JSON)

-- Test 70: query (line 381)
SELECT json_array_elements('[1, true, null, "text", -1.234, {"2": 3, "4": "5"}, [1, 2, 3]]'::JSON)

-- Test 71: query (line 393)
SELECT * FROM json_array_elements('[1, true, null, "text", -1.234, {"2": 3, "4": "5"}, [1, 2, 3]]'::JSON)

-- Test 72: query (line 405)
SELECT json_array_elements('[]'::JSON)

-- Test 73: query (line 410)
SELECT json_array_elements('{"1": 2}'::JSON)

query error pq: cannot be called on a non-array
SELECT jsonb_array_elements('{"1": 2}'::JSON)


## json_array_elements_text and jsonb_array_elements_text

query T colnames,nosort
SELECT json_array_elements_text('[1, 2, 3]'::JSON)

-- Test 74: query (line 427)
SELECT * FROM json_array_elements_text('[1, 2, 3]'::JSON)

-- Test 75: query (line 435)
SELECT json_array_elements_text('[1, 2, 3]'::JSON)

-- Test 76: query (line 443)
SELECT * FROM json_array_elements_text('[1, 2, 3]'::JSON)

-- Test 77: query (line 451)
SELECT json_array_elements_text('[1, true, null, "text", -1.234, {"2": 3, "4": "5"}, [1, 2, 3]]'::JSON)

-- Test 78: query (line 462)
SELECT json_array_elements('[]'::JSON)

-- Test 79: query (line 466)
SELECT json_array_elements_text('{"1": 2}'::JSON)

query error pq: cannot be called on a non-array
SELECT jsonb_array_elements_text('{"1": 2}'::JSON)


## json_object_keys and jsonb_object_keys

query T nosort
SELECT json_object_keys('{"1": 2, "3": 4}'::JSON)

-- Test 80: query (line 481)
SELECT jsonb_object_keys('{"1": 2, "3": 4}'::JSON)

-- Test 81: query (line 487)
SELECT json_object_keys('{}'::JSON)

-- Test 82: query (line 491)
SELECT json_object_keys('{"\"1\"": 2}'::JSON)

-- Test 83: query (line 497)
SELECT json_object_keys('{"a": 1, "1": 2, "3": {"4": 5, "6": 7}}'::JSON)

-- Test 84: query (line 505)
SELECT * FROM json_object_keys('{"a": 1, "1": 2, "3": {"4": 5, "6": 7}}'::JSON)

-- Test 85: query (line 513)
SELECT json_object_keys('null'::JSON)

query error pq: cannot call json_object_keys on an array
SELECT json_object_keys('[1, 2, 3]'::JSON)

## json_build_object

query T
SELECT json_build_object()

-- Test 86: query (line 526)
SELECT json_build_object('a', 2, 'b', 4)

-- Test 87: query (line 531)
SELECT jsonb_build_object(true,'val',1, 0, 1.3, 2, date '2019-02-03' - date '2019-01-01', 4, '2001-01-01 11:00+3'::timestamptz, '11:00+3'::timetz)

-- Test 88: query (line 536)
SELECT json_build_object('a',1,'b',1.2,'c',true,'d',null,'e','{"x": 3, "y": [1,2,3]}'::JSON)

-- Test 89: query (line 541)
SELECT json_build_object(
       'a', json_build_object('b',false,'c',99),
       'd', json_build_object('e',ARRAY[9,8,7]::int[])
)

-- Test 90: query (line 549)
SELECT json_build_object(a,3) FROM (SELECT 1 AS a, 2 AS b) r

-- Test 91: query (line 554)
SELECT json_build_object('\a'::TEXT COLLATE "fr_FR", 1)

-- Test 92: query (line 559)
SELECT json_build_object('\a', 1)

-- Test 93: query (line 564)
SELECT json_build_object(json_object_keys('{"x":3, "y":4}'::JSON), 2)

-- Test 94: query (line 571)
SELECT json_build_object('a', '0100110'::varbit)

-- Test 95: statement (line 576)
CREATE TABLE foo (a INT);

-- Test 96: statement (line 579)
INSERT INTO foo VALUES (42);

-- Test 97: query (line 585)
EXECUTE jbo_stmt(':');

-- Test 98: statement (line 591)
CREATE TYPE e AS ENUM ('e');

-- Test 99: query (line 594)
SELECT json_build_object('e'::e, 1)

-- Test 100: query (line 599)
SELECT json_build_object(''::void, 1)

-- Test 101: statement (line 605)
SELECT json_build_object(1,2,3)

-- Test 102: statement (line 609)
SELECT json_build_object(null,2)

-- Test 103: statement (line 612)
SELECT json_build_object((1,2),3)

-- Test 104: statement (line 615)
SELECT json_build_object('{"a":1,"b":2}'::JSON, 3)

-- Test 105: statement (line 618)
SELECT json_build_object('{1,2,3}'::int[], 3)

-- Test 106: query (line 621)
SELECT json_build_object('a'::tsvector, 1, 'b'::tsquery, 2)

-- Test 107: query (line 626)
SELECT json_build_object('$'::JSONPATH, 1)

-- Test 108: query (line 631)
SELECT json_build_object('foo'::LTREE, 2)

-- Test 109: query (line 636)
SELECT json_extract_path('{"a": 1}', 'a')

-- Test 110: query (line 641)
SELECT json_extract_path('{"a": 1}', 'a', NULL)

-- Test 111: query (line 646)
SELECT json_extract_path('{"a": 1}')

-- Test 112: query (line 651)
SELECT json_extract_path('{"a": {"b": 2}}', 'a')

-- Test 113: query (line 656)
SELECT json_extract_path('{"a": {"b": 2}}', 'a', 'b')

-- Test 114: query (line 661)
SELECT jsonb_extract_path('{"a": {"b": 2}}', 'a', 'b')

-- Test 115: query (line 666)
SELECT json_extract_path('{"a": {"b": 2}}', 'a', 'b', 'c')

-- Test 116: query (line 671)
SELECT json_extract_path('null')

-- Test 117: query (line 676)
SELECT json_extract_path_text('{"a": 1}', 'a')

-- Test 118: query (line 681)
SELECT json_extract_path_text('{"a": 1}', 'a', NULL)

-- Test 119: query (line 686)
SELECT json_extract_path_text('{"a": 1}')

-- Test 120: query (line 691)
SELECT json_extract_path_text('{"a": {"b": 2}}', 'a')

-- Test 121: query (line 696)
SELECT json_extract_path_text('{"a": {"b": 2}}', 'a', 'b')

-- Test 122: query (line 701)
SELECT jsonb_extract_path_text('{"a": {"b": 2}}', 'a', 'b')

-- Test 123: query (line 706)
SELECT json_extract_path_text('{"a": {"b": 2}}', 'a', 'b', 'c')

-- Test 124: query (line 711)
SELECT json_extract_path_text('null')

-- Test 125: query (line 716)
SELECT jsonb_pretty('{"a": 1}')

-- Test 126: query (line 723)
SELECT '[1,2,3]'::JSON || '[4,5,6]'::JSON

-- Test 127: query (line 728)
SELECT '{"a": 1, "b": 2}'::JSON || '{"b": 3, "c": 4}'

-- Test 128: query (line 733)
SELECT '{"a": 1, "b": 2}'::JSON || '"c"'

query T
SELECT json_build_array()

-- Test 129: query (line 741)
SELECT json_build_array('\x0001'::BYTEA)

-- Test 130: query (line 746)
SELECT json_build_array(1, '1'::JSON, 1.2, NULL, ARRAY['x', 'y'])

-- Test 131: query (line 754)
EXECUTE jba_stmt(':');

-- Test 132: query (line 759)
SELECT jsonb_build_array()

-- Test 133: query (line 764)
SELECT jsonb_build_array('\x0001'::BYTEA)

-- Test 134: query (line 769)
SELECT jsonb_build_array(1, '1'::JSON, 1.2, NULL, ARRAY['x', 'y'])

-- Test 135: statement (line 780)
SELECT json_object('{a,b,c}'::TEXT[])

-- Test 136: statement (line 783)
SELECT json_object('{NULL, a}'::TEXT[])

-- Test 137: statement (line 786)
SELECT json_object('{a,b,NULL,"d e f"}'::TEXT[],'{1,2,3,"a b c"}'::TEXT[])

-- Test 138: query (line 789)
SELECT json_object('{a,b,c,"d e f",g}'::TEXT[],'{1,2,3,"a b c"}'::TEXT[])

query error pq: mismatched array dimensions
SELECT json_object('{a,b,c,"d e f"}'::TEXT[],'{1,2,3,"a b c",g}'::TEXT[])

query error pq: unknown signature: json_object\(collatedstring\{fr_FR\}\[\]\)
SELECT json_object(ARRAY['a'::TEXT COLLATE "fr_FR"])

query T
SELECT json_object('{}'::TEXT[])

-- Test 139: query (line 803)
SELECT json_object('{}'::TEXT[], '{}'::TEXT[])

-- Test 140: query (line 808)
SELECT json_object('{b, 3, a, 1, b, 4, a, 2}'::TEXT[])

-- Test 141: query (line 813)
SELECT json_object('{b, b, a, a}'::TEXT[], '{1, 2, 3, 4}'::TEXT[])

-- Test 142: query (line 818)
SELECT json_object('{a,1,b,2,3,NULL,"d e f","a b c"}'::TEXT[])

-- Test 143: query (line 823)
SELECT json_object('{a,b,"","d e f"}'::TEXT[],'{1,2,3,"a b c"}'::TEXT[])

-- Test 144: query (line 828)
SELECT json_object('{a,b,c,"d e f"}'::TEXT[],'{1,2,3,"a b c"}'::TEXT[])

-- Test 145: statement (line 833)
SELECT jsonb_object('{a,b,c}'::TEXT[])

-- Test 146: statement (line 836)
SELECT jsonb_object('{NULL, a}'::TEXT[])

-- Test 147: statement (line 839)
SELECT jsonb_object('{a,b,NULL,"d e f"}'::TEXT[],'{1,2,3,"a b c"}'::TEXT[])

-- Test 148: query (line 842)
SELECT jsonb_object('{a,b,c,"d e f",g}'::TEXT[],'{1,2,3,"a b c"}'::TEXT[])

query error pq: mismatched array dimensions
SELECT jsonb_object('{a,b,c,"d e f"}'::TEXT[],'{1,2,3,"a b c",g}'::TEXT[])

query error pq: unknown signature: jsonb_object\(collatedstring\{fr_FR\}\[\]\)
SELECT jsonb_object(ARRAY['a'::TEXT COLLATE "fr_FR"])

query T
SELECT jsonb_object('{}'::TEXT[])

-- Test 149: query (line 856)
SELECT jsonb_object('{}'::TEXT[], '{}'::TEXT[])

-- Test 150: query (line 861)
SELECT jsonb_object('{b, 3, a, 1, b, 4, a, 2}'::TEXT[])

-- Test 151: query (line 866)
SELECT jsonb_object('{b, b, a, a}'::TEXT[], '{1, 2, 3, 4}'::TEXT[])

-- Test 152: query (line 871)
SELECT jsonb_object('{a,1,b,2,3,NULL,"d e f","a b c"}'::TEXT[])

-- Test 153: query (line 876)
SELECT jsonb_object('{a,b,"","d e f"}'::TEXT[],'{1,2,3,"a b c"}'::TEXT[])

-- Test 154: query (line 881)
SELECT jsonb_object('{a,b,c,"d e f"}'::TEXT[],'{1,2,3,"a b c"}'::TEXT[])

-- Test 155: query (line 886)
SELECT json_each('[1]'::JSON)

query error pq: cannot deconstruct a scalar
SELECT json_each('null'::JSON)

query TT
SELECT * FROM json_each('{}') q

-- Test 156: query (line 896)
SELECT json_each('{"f1":[1,2,3],"f2":{"f3":1},"f4":null,"f5":99,"f6":"stringy"}')

-- Test 157: query (line 906)
SELECT * FROM json_each('{"f1":[1,2,3],"f2":{"f3":1},"f4":null,"f5":99,"f6":"stringy"}') q

-- Test 158: query (line 916)
SELECT jsonb_each('[1]'::JSON)

query error pq: cannot deconstruct a scalar
SELECT jsonb_each('null'::JSON)

query TT
SELECT * FROM jsonb_each('{}') q

-- Test 159: query (line 926)
SELECT jsonb_each('{"f1":[1,2,3],"f2":{"f3":1},"f4":null,"f5":99,"f6":"stringy"}')

-- Test 160: query (line 936)
SELECT * FROM jsonb_each('{"f1":[1,2,3],"f2":{"f3":1},"f4":null,"f5":99,"f6":"stringy"}') q

-- Test 161: query (line 946)
SELECT jsonb_each_text('[1]'::JSON)

query error pq: cannot deconstruct a scalar
SELECT jsonb_each_text('null'::JSON)

query TT
SELECT * FROM jsonb_each_text('{}') q

-- Test 162: query (line 956)
SELECT jsonb_each_text('{"f1":[1,2,3],"f2":{"f3":1},"f4":null,"f5":99,"f6":"stringy"}')

-- Test 163: query (line 966)
SELECT jsonb_each_text('{"f1":[1,2,3],"f2":{"f3":1},"f4":null,"f5":99,"f6":"stringy"}') q

-- Test 164: query (line 976)
SELECT * FROM jsonb_each_text('{"f1":[1,2,3],"f2":{"f3":1},"f4":null,"f5":99,"f6":"stringy"}') q

-- Test 165: query (line 986)
SELECT json_each_text('[1]'::JSON)

query error pq: cannot deconstruct a scalar
SELECT json_each_text('null'::JSON)

query TT
SELECT * FROM json_each_text('{}') q

-- Test 166: query (line 996)
SELECT * FROM json_each_text('{}') q

-- Test 167: query (line 1000)
SELECT json_each_text('{"f1":[1,2,3],"f2":{"f3":1},"f4":null,"f5":99,"f6":"stringy"}')

-- Test 168: query (line 1010)
SELECT json_each_text('{"f1":[1,2,3],"f2":{"f3":1},"f4":null,"f5":99,"f6":"stringy"}') q

-- Test 169: query (line 1020)
SELECT * FROM json_each_text('{"f1":[1,2,3],"f2":{"f3":1},"f4":null,"f5":99,"f6":"stringy"}') q

-- Test 170: query (line 1084)
SELECT jsonb_insert(NULL, '{a}', NULL, false)

-- Test 171: query (line 1115)
SELECT jsonb_insert('1', NULL, '10')

-- Test 172: query (line 1126)
SELECT jsonb_strip_nulls(NULL)

-- Test 173: query (line 1131)
SELECT json_strip_nulls('1')

-- Test 174: query (line 1141)
SELECT json_strip_nulls('null')

-- Test 175: query (line 1146)
SELECT json_strip_nulls('[1,2,null,3,4]')

-- Test 176: query (line 1151)
SELECT json_strip_nulls('{"a":1,"b":null,"c":[2,null,3],"d":{"e":4,"f":null}}')

-- Test 177: query (line 1156)
SELECT json_strip_nulls('[1,{"a":1,"b":null,"c":2},3]')

-- Test 178: query (line 1161)
SELECT jsonb_strip_nulls('{"a": {"b": null, "c": null}, "d": {}}')

-- Test 179: query (line 1166)
SELECT jsonb_strip_nulls(NULL)

-- Test 180: query (line 1171)
SELECT jsonb_strip_nulls('1')

-- Test 181: query (line 1181)
SELECT jsonb_strip_nulls('null')

-- Test 182: query (line 1186)
SELECT jsonb_strip_nulls('[1,2,null,3,4]')

-- Test 183: query (line 1191)
SELECT jsonb_strip_nulls('{"a":1,"b":null,"c":[2,null,3],"d":{"e":4,"f":null}}')

-- Test 184: query (line 1196)
SELECT jsonb_strip_nulls('[1,{"a":1,"b":null,"c":2},3]')

-- Test 185: query (line 1201)
SELECT jsonb_strip_nulls('{"a": {"b": null, "c": null}, "d": {}}')

-- Test 186: query (line 1206)
SELECT json_array_length('{"f1":1,"f2":[5,6]}')

query error pq: cannot get array length of a scalar
SELECT json_array_length('4')

query I
SELECT json_array_length('[1,2,3,{"f1":1,"f2":[5,6]},4]')

-- Test 187: query (line 1217)
SELECT json_array_length('[]')

-- Test 188: query (line 1222)
SELECT jsonb_array_length('{"f1":1,"f2":[5,6]}')

query error pq: cannot get array length of a scalar
SELECT jsonb_array_length('4')

query I
SELECT jsonb_array_length('[1,2,3,{"f1":1,"f2":[5,6]},4]')

-- Test 189: query (line 1233)
SELECT jsonb_array_length('[]')

-- Test 190: query (line 1238)
SELECT row_to_json(row(1,'foo')), row_to_json(NULL), row_to_json(row())

-- Test 191: query (line 1243)
SELECT row_to_json(x) FROM (SELECT 1 AS "OnE", 2 AS "tO_") x

-- Test 192: query (line 1250)
select row_to_json(t.*)
from (
  select 1 as a, 2 as b
) t

-- Test 193: query (line 1258)
SELECT '["a", {"b":1}]'::jsonb #- '{1,b}'

-- Test 194: query (line 1263)
select
       jsonb_exists_any('{"id":12,"name":"Michael","address": {"postcode":12,"state":"California"}}'::jsonb, array['id']),
       jsonb_exists_any('{"id":12,"name":"Michael","address": {"postcode":12,"state":"California"}}'::jsonb->'address', array['state']),
       jsonb_exists_any('{"id":12,"name":"Michael","address": {"postcode":12,"state":"California"}}'::jsonb, array[NULL,'id']),
       jsonb_exists_any('{"id":12,"name":"Michael","address": {"postcode":12,"state":"California"}}'::jsonb, array[NULL,'ids']),
       jsonb_exists_any('["a","b"]', array['a']),
       jsonb_exists_any('["a", 10, 12]', '{"a"}'::text[]),
       jsonb_exists_any('["a"]', '{"a"}'),
       jsonb_exists_any('["a"]', '{}');

-- Test 195: query (line 1276)
select
    jsonb_exists_any('{"id":12,"name":"Michael","address": {"postcode":12,"state":"California"}}'::jsonb, array[1]);

query error pq: jsonb_exists_any\(\): could not parse "id" as type int: strconv\.ParseInt: parsing "id": invalid syntax
select
    jsonb_exists_any('{"id":12,"name":"Michael","address": {"postcode":12,"state":"California"}}'::jsonb, array['id',1]);

# json_populate_record
query FIII colnames
SELECT *, c FROM json_populate_record(((1.01, 2, 3) AS d, c, a), '{"a": 3, "c": 10, "d": 11.001}')

-- Test 196: query (line 1291)
SELECT * FROM json_populate_record(((true, ARRAY[1], ARRAY['f']) AS a, b, c), '{"a": true, "b": [1,2], "c": ["a", "b"]}')

-- Test 197: query (line 1297)
SELECT * FROM json_populate_record(((true, ((1, 'bar', ARRAY['a']) AS x, y, z)) AS a, b), '{"a": true, "b": {"x": "3", "y": "foo", "z": ["a", "b"]}}')

-- Test 198: query (line 1303)
SELECT * FROM json_populate_record(((true, 3) AS a, b), '{"a": null, "b": null}')

-- Test 199: query (line 1309)
SELECT json_populate_record(((1.01, 2, 3) AS d, c, a), '{"a": 3, "c": 10, "d": 11.001}')

-- Test 200: query (line 1315)
SELECT json_populate_record(((1.01, 2) AS a, b), '{"a": "1.2345", "b": "33"}')

-- Test 201: query (line 1321)
SELECT (json_populate_record(((1.01, 2, 3) AS d, c, a), '{"a": 3, "c": 10, "d": 11.001}')).d

-- Test 202: statement (line 1327)
SELECT * FROM json_populate_record(((1, 2) AS a, b), '"a"')

-- Test 203: statement (line 1330)
CREATE TABLE testtab (
	i	int,
	ia	int[],
	t	text,
	ta	text[],
	ts	timestamp,
	j	jsonb
)

-- Test 204: query (line 1340)
SELECT * FROM json_populate_record(NULL::testtab, '{"i": 3, "ia": [1,2,3], "t": "foo", "ta": ["a", "b"], "ts": "2017-01-01 00:00", "j": {"a": "b", "c": 3, "d": [1,false,true,null,{"1":"2"}]}}'::JSON)

-- Test 205: query (line 1345)
SELECT json_populate_record(NULL::testtab, '{"i": 3, "ia": [1,2,3], "t": "foo", "ta": ["a", "b"], "ts": "2017-01-01 00:00", "j": {"a": "b", "c": 3, "d": [1,false,true,null,{"1":"2"}]}}'::JSON)

-- Test 206: query (line 1350)
SELECT * FROM json_populate_record(NULL::testtab, NULL)

-- Test 207: query (line 1355)
SELECT json_populate_record(((3,) AS a), '{"a": "foo"}')

query error anonymous records cannot be used with json{b}_populate_record{set}
SELECT * FROM json_populate_record((1,2,3,4), '{"a": 3, "c": 10, "d": 11.001}')

query error anonymous records cannot be used with json{b}_populate_record{set}
SELECT * FROM json_populate_record(NULL, '{"a": 3, "c": 10, "d": 11.001}')

query error first argument of json{b}_populate_record{set} must be a record type
SELECT * FROM json_populate_record(1, '{"a": 3, "c": 10, "d": 11.001}')

query error first argument of json{b}_populate_record{set} must be a record type
SELECT * FROM json_populate_record(NULL::INT, '{"a": 3, "c": 10, "d": 11.001}')

query error anonymous records cannot be used with json{b}_populate_record{set}
SELECT * FROM json_populate_record(NULL::record, '{"a": 3, "c": 10, "d": 11.001}')

query error anonymous records cannot be used with json{b}_populate_record{set}
SELECT * FROM json_populate_recordset(NULL, '[{"a": 3, "c": 10, "d": 11.001}, {}]')

query error first argument of json{b}_populate_record{set} must be a record type
SELECT * FROM json_populate_recordset(NULL::INT, '[{"a": 3, "c": 10, "d": 11.001}, {}]')

query I
SELECT * FROM json_populate_record(((3,) AS a), NULL)

-- Test 208: query (line 1384)
SELECT *, c FROM json_populate_recordset(((1.01, 2, 3) AS d, c, a), '[{"a": 3, "c": 10, "d": 11.001}, {}]')

-- Test 209: query (line 1391)
SELECT *, c FROM json_populate_recordset(((NULL::NUMERIC, 2::INT, 3::TEXT) AS d, c, a), '[{"a": 3, "c": 10, "d": 11.001}, {}]')

-- Test 210: query (line 1398)
SELECT * FROM json_populate_recordset(((NULL::NUMERIC, 2::INT, 3::TEXT) AS d, c, a), NULL)

-- Test 211: query (line 1402)
SELECT * FROM json_populate_recordset(((NULL::NUMERIC, 2::INT, 3::TEXT) AS d, c, a), '[]')

-- Test 212: query (line 1406)
SELECT * FROM json_populate_recordset(((NULL::NUMERIC, 2::INT, 3::TEXT) AS d, c, a), '{"foo": "bar"}')

query error argument of json_populate_recordset must be an array
SELECT * FROM json_populate_recordset(((NULL::NUMERIC, 2::INT, 3::TEXT) AS d, c, a), 'true')

query error argument of json_populate_recordset must be an array
SELECT * FROM json_populate_recordset(((NULL::NUMERIC, 2::INT, 3::TEXT) AS d, c, a), '0')

query error argument of json_populate_recordset must be an array
SELECT * FROM json_populate_recordset(((NULL::NUMERIC, 2::INT, 3::TEXT) AS d, c, a), 'null')

query error argument of json_populate_recordset must be an array of objects
SELECT * FROM json_populate_recordset(((NULL::NUMERIC, 2::INT, 3::TEXT) AS d, c, a), '[null]')

query error argument of json_populate_recordset must be an array of objects
SELECT * FROM json_populate_recordset(((NULL::NUMERIC, 2::INT, 3::TEXT) AS d, c, a), '[{"foo":"bar"}, 3]')

query ITTTTT nosort
SELECT * FROM json_populate_recordset(NULL::testtab, '[{"i": 3, "ia": [1,2,3], "t": "foo", "ta": ["a", "b"], "ts": "2017-01-01 00:00", "j": {"a": "b", "c": 3, "d": [1,false,true,null,{"1":"2"}]}}, {}]'::JSON)

-- Test 213: query (line 1430)
SELECT * FROM json_to_record('3') AS t(a INT)

query error invalid non-object argument to json_to_record
SELECT * FROM json_to_record('"a"') AS t(a TEXT)

query error invalid non-object argument to json_to_record
SELECT * FROM json_to_record('null') AS t(a INT)

query error invalid non-object argument to json_to_record
SELECT * FROM json_to_record('true') AS t(a INT)

query error invalid non-object argument to json_to_record
SELECT * FROM json_to_record('[1,2]') AS t(a INT)

query error column definition list is required for functions returning \"record\"
SELECT * FROM json_to_record('{"a": "b"}') AS t(a)

query error column definition list is required for functions returning \"record\"
SELECT * FROM json_to_record('{"a": "b"}')

# Test that non-record generators don't permit col definition lists (with types).
query error a column definition list is only allowed for functions returning \"record\"
SELECT * FROM generate_series(1,10) g(g int)

statement ok
CREATE TABLE j (j) AS SELECT '{
  "str": "a",
  "int": 1,
  "bool": true,
  "nul": null,
  "dec": 2.45,
  "arrint": [1,2],
  "arrmixed": [1,2,true],
  "arrstr": ["a", "b"],
  "arrbool": [true, false],
  "obj": {"i": 3, "t": "blah", "z": true}
  }'::JSONB

statement ok
INSERT INTO j VALUES('{"str": "zzz"}')

query TIBTFTTTTT
SELECT t.* FROM j, json_to_record(j.j) AS t(
  str TEXT,
  int INT,
  bool BOOL,
  nul TEXT,
  dec DECIMAL,
  arrint INT[],
  arrmixed TEXT,
  arrstr TEXT[],
  arrbool BOOL[],
  obj TEXT
) ORDER BY rowid

-- Test 214: query (line 1490)
SELECT t.bool FROM j, json_to_record(j.j) AS t(bool INT)

# But types can be coerced.
query TT rowsort
SELECT t.* FROM j, json_to_record(j.j) AS t(int TEXT, bool TEXT)

-- Test 215: query (line 1501)
SELECT t.arrmixed FROM j, json_to_record(j.j) AS t(arrmixed BOOL[])

# Record with custom type
query T rowsort
SELECT t.obj FROM j, json_to_record(j.j) AS t(obj testtab)

-- Test 216: query (line 1512)
SELECT t.* FROM j, json_to_recordset(j.j || '[]' || j.j) AS t(
  str TEXT,
  int INT,
  bool BOOL,
  nul TEXT,
  dec DECIMAL,
  arrint INT[],
  arrmixed TEXT,
  arrstr TEXT[],
  arrbool BOOL[],
  obj TEXT
) ORDER BY rowid

-- Test 217: query (line 1531)
SELECT * FROM jsonb_to_recordset('[{"foo": "bar"}, {"foo": "bar2"}]') AS t(foo TEXT),
              jsonb_to_recordset('[{"foo": "blah"}, {"foo": "blah2"}]') AS u(foo TEXT)

-- Test 218: query (line 1542)
WITH cte(col) AS (
  VALUES
    ('false'::JSONB),
    (jsonb_object(ARRAY['0', '', e'\x14', '']::TEXT[]))
  )
SELECT jsonb_object_agg('k', 'v') OVER (PARTITION BY cte.col) FROM cte;

