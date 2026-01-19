-- PostgreSQL compatible tests from array
-- 396 tests

-- Test 1: statement (line 7)
SET bytea_output = escape

-- Test 2: query (line 12)
SELECT ARRAY[]

query T
SELECT ARRAY[1, 2, 3]

-- Test 3: statement (line 20)
CREATE TABLE k (
  k INT PRIMARY KEY
)

-- Test 4: statement (line 25)
INSERT INTO k VALUES (1), (2), (3), (4), (5)

-- Test 5: query (line 28)
SELECT ARRAY[k] FROM k

-- Test 6: query (line 37)
SELECT ARRAY['a', true, 1]

query T
SELECT ARRAY['a,', 'b{', 'c}', 'd', 'e f']

-- Test 7: query (line 45)
SELECT ARRAY['1}'::BYTES]

-- Test 8: query (line 56)
SELECT '', 'NULL', 'Null', 'null', NULL, '"', e'\''

-- Test 9: query (line 61)
SELECT ARRAY['', 'NULL', 'Null', 'null', NULL, '"', e'\'']

-- Test 10: query (line 66)
SELECT NULL::INT[]

-- Test 11: query (line 80)
SELECT NULL::INT[] IS DISTINCT FROM NULL, ARRAY[1,2,3] IS DISTINCT FROM NULL

-- Test 12: query (line 87)
SELECT ARRAY['one', 'two', 'fünf']

-- Test 13: query (line 97)
SELECT ARRAY['foo', 'bar']

-- Test 14: query (line 104)
SELECT ARRAY(SELECT 3 WHERE false)

-- Test 15: statement (line 109)
SELECT ARRAY(SELECT 3 WHERE false) FROM k

-- Test 16: query (line 112)
SELECT ARRAY(SELECT 3)

-- Test 17: query (line 117)
SELECT ARRAY(VALUES (1),(2),(1))

-- Test 18: query (line 125)
SELECT ARRAY(VALUES (ARRAY[1]))

-- Test 19: query (line 131)
SELECT ARRAY(VALUES (ARRAY[1]))

query T
SELECT ARRAY(VALUES ('a'),('b'),('c'))

-- Test 20: query (line 139)
SELECT ARRAY(SELECT (1,2))

-- Test 21: query (line 144)
SELECT ARRAY(SELECT 1, 2)

query T
SELECT ARRAY[]:::int[]

-- Test 22: query (line 154)
SELECT '{1,2,3}'::INT[]

-- Test 23: query (line 174)
SELECT '{hello}'::VARCHAR(2)[]

-- Test 24: query (line 179)
SELECT '{hello, a🐛b🏠c}'::VARCHAR(2)[]

-- Test 25: query (line 189)
SELECT s::VARCHAR(2)[] FROM hello

-- Test 26: query (line 218)
SELECT ARRAY[1,2,3]::INT[]

-- Test 27: query (line 223)
SELECT ARRAY[1,2,3]::UUID[]

query error invalid cast: inet[] -> INT[]
SELECT ARRAY['8.8.8.8'::INET, '8.8.4.4'::INET]::INT[]

query T
SELECT ARRAY[1,2,3]::TEXT[]

-- Test 28: query (line 234)
SELECT ARRAY[1,2,3]::INT2VECTOR

-- Test 29: query (line 239)
SELECT ARRAY[1,2,3]::OIDVECTOR

-- Test 30: query (line 246)
SELECT ARRAY['a', 'b', 'c'][-1]

-- Test 31: query (line 251)
SELECT ARRAY['a', 'b', 'c'][0]

-- Test 32: query (line 257)
SELECT '{a,b,c}'[0]

query T
SELECT (ARRAY['a', 'b', 'c'])[2]

-- Test 33: query (line 265)
SELECT ARRAY['a', 'b', 'c'][2]

-- Test 34: query (line 270)
SELECT ARRAY['a', 'b', 'c'][4]

-- Test 35: query (line 275)
SELECT ARRAY['a', 'b', 'c'][1 + 2]

-- Test 36: query (line 280)
SELECT ARRAY[1, 2, 3][-1]

-- Test 37: query (line 285)
SELECT ARRAY[1, 2, 3][0]

-- Test 38: query (line 290)
SELECT ARRAY[1, 2, 3][2]

-- Test 39: query (line 295)
SELECT ARRAY[1, 2, 3][4]

-- Test 40: query (line 300)
SELECT ARRAY[1, 2, 3][1 + 2]

-- Test 41: query (line 305)
SELECT ARRAY['a', 'b', 'c'][4][2]

query error incompatible ARRAY subscript type: decimal
SELECT ARRAY['a', 'b', 'c'][3.5]

query error could not parse "abc" as type int
SELECT ARRAY['a', 'b', 'c']['abc']

query error cannot subscript type int because it is not an array
SELECT (123)[2]

# array slicing

query error unimplemented: ARRAY slicing
SELECT ARRAY['a', 'b', 'c'][:]

query error unimplemented: ARRAY slicing
SELECT ARRAY['a', 'b', 'c'][1:]

query error unimplemented: ARRAY slicing
SELECT ARRAY['a', 'b', 'c'][1:2]

query error unimplemented: ARRAY slicing
SELECT ARRAY['a', 'b', 'c'][:2]

query error unimplemented: ARRAY slicing
SELECT ARRAY['a', 'b', 'c'][2:1]

# other forms of indirection

# From a column name.
query T
SELECT a[1] FROM (SELECT ARRAY['a','b','c'] AS a)

-- Test 42: query (line 343)
SELECT a[1] FROM (SELECT ARRAY['a','b','c'] AS a)

-- Test 43: query (line 349)
SELECT (ARRAY(VALUES (1),(2),(1)))[2]

-- Test 44: query (line 355)
SELECT ARRAY(VALUES (1),(2),(1))[2]

-- Test 45: query (line 361)
SELECT ((SELECT ARRAY[1, 2, 3]))[3]

-- Test 46: query (line 367)
SELECT (SELECT ARRAY['a', 'b', 'c'])[3]

-- Test 47: query (line 372)
SELECT ARRAY(SELECT generate_series(1,10) ORDER BY 1 DESC)

-- Test 48: statement (line 377)
CREATE TABLE z (
  x INT PRIMARY KEY,
  y INT
)

-- Test 49: statement (line 383)
INSERT INTO z VALUES (1, 5), (2, 4), (3, 3), (4, 2), (5, 1)

-- Test 50: query (line 386)
SELECT ARRAY(SELECT x FROM z ORDER BY y)

-- Test 51: query (line 392)
SELECT current_schemas(true)[1]

-- Test 52: query (line 398)
SELECT (CASE 1 = 1 WHEN true THEN ARRAY[1,2] ELSE ARRAY[2,3] END)[1]

-- Test 53: query (line 404)
SELECT (1,2,3)[1]

query error cannot subscript type tuple{int, int, int} because it is not an array
SELECT ROW (1,2,3)[1]

# Ensure grouping by an array column works

statement ok
SELECT conkey FROM pg_catalog.pg_constraint GROUP BY conkey

statement ok
SELECT indkey[0] FROM pg_catalog.pg_index

# Verify serialization of array in expression (with distsql).
statement ok
CREATE TABLE t (k INT)

statement ok
INSERT INTO t VALUES (1), (2), (3), (4), (5)

query I rowsort
SELECT k FROM t WHERE k = ANY ARRAY[2,4]

-- Test 54: query (line 431)
SELECT k FROM t WHERE k > ANY ARRAY[2,4]

-- Test 55: query (line 438)
SELECT k FROM t WHERE k < ALL ARRAY[2,4]

-- Test 56: statement (line 444)
CREATE TABLE boundedtable (b INT[10], c INT ARRAY[10])

-- Test 57: statement (line 447)
DROP TABLE boundedtable

-- Test 58: statement (line 451)
CREATE TABLE badtable (b INT[][])

-- Test 59: query (line 457)
SELECT ARRAY[ARRAY[1,2,3]]

-- Test 60: query (line 463)
SELECT ARRAY[ARRAY[1,2,3]]

# The postgres-compat aliases should be disallowed.
# INT2VECTOR is deprecated in Postgres.

query error VECTOR column types are unsupported
CREATE TABLE badtable (b INT2VECTOR)

# Regression test for #18745

statement ok
CREATE TABLE ident (x INT)

query T
SELECT ARRAY[ROW()] FROM ident

-- Test 61: statement (line 481)
CREATE TABLE a (b INT ARRAY)

onlyif config schema-locked-disabled

-- Test 62: query (line 485)
SHOW CREATE TABLE a

-- Test 63: query (line 495)
SHOW CREATE TABLE a

-- Test 64: statement (line 504)
DROP TABLE a

-- Test 65: statement (line 509)
CREATE TABLE a (b INT[])

-- Test 66: statement (line 512)
INSERT INTO a VALUES (ARRAY[1,2,3])

-- Test 67: query (line 515)
SELECT b FROM a

-- Test 68: statement (line 520)
DELETE FROM a

-- Test 69: statement (line 523)
INSERT INTO a VALUES (NULL)

-- Test 70: query (line 526)
SELECT b FROM a

-- Test 71: statement (line 531)
DELETE FROM a

-- Test 72: statement (line 534)
INSERT INTO a VALUES (ARRAY[])

-- Test 73: query (line 537)
SELECT b FROM a

-- Test 74: statement (line 542)
DELETE FROM a;

-- Test 75: statement (line 547)
INSERT INTO a (SELECT array_agg(generate_series) from generate_series(1,3))

-- Test 76: query (line 550)
SELECT * FROM a

-- Test 77: query (line 556)
SHOW CREATE TABLE a

-- Test 78: query (line 566)
SHOW CREATE TABLE a

-- Test 79: statement (line 575)
INSERT INTO a VALUES (ARRAY['foo'])

-- Test 80: statement (line 578)
INSERT INTO a VALUES (ARRAY[1, 'foo'])

-- Test 81: statement (line 581)
DELETE FROM a

-- Test 82: statement (line 584)
INSERT INTO a VALUES (ARRAY[1,2,3]), (ARRAY[4,5]), (ARRAY[6])

-- Test 83: query (line 587)
SELECT b[1] FROM a ORDER BY b[1]

-- Test 84: query (line 594)
SELECT b[2] FROM a ORDER BY b[1]

-- Test 85: statement (line 603)
DELETE FROM a

-- Test 86: statement (line 606)
INSERT INTO a VALUES (ARRAY[NULL::INT]), (ARRAY[NULL::INT, 1]), (ARRAY[1, NULL::INT]), (ARRAY[NULL::INT, NULL::INT])

-- Test 87: query (line 609)
SELECT * FROM a

-- Test 88: statement (line 617)
DELETE FROM a

-- Test 89: statement (line 622)
INSERT INTO a VALUES (ARRAY[1,2,3,4,5,6,7,8,NULL::INT])

-- Test 90: query (line 625)
SELECT * FROM a

-- Test 91: statement (line 630)
DROP TABLE a

-- Test 92: statement (line 635)
CREATE TABLE a (b SMALLINT[])

onlyif config schema-locked-disabled

-- Test 93: query (line 639)
SHOW CREATE TABLE a

-- Test 94: query (line 649)
SHOW CREATE TABLE a

-- Test 95: statement (line 658)
INSERT INTO a VALUES (ARRAY[100000])

-- Test 96: statement (line 661)
DROP TABLE a

-- Test 97: statement (line 669)
INSERT INTO a VALUES (ARRAY['foo', 'bar', 'baz'])

-- Test 98: query (line 672)
SELECT b FROM a

-- Test 99: statement (line 677)
UPDATE a SET b = ARRAY[]

-- Test 100: query (line 680)
SELECT b FROM a

-- Test 101: statement (line 687)
DELETE FROM a

-- Test 102: query (line 693)
SELECT * FROM a

-- Test 103: statement (line 698)
DROP TABLE a

-- Test 104: statement (line 703)
CREATE TABLE a (b BOOL[])

-- Test 105: statement (line 706)
INSERT INTO a VALUES (ARRAY[]), (ARRAY[TRUE]), (ARRAY[FALSE]), (ARRAY[TRUE, TRUE]), (ARRAY[FALSE, TRUE])

-- Test 106: query (line 709)
SELECT b FROM a

-- Test 107: statement (line 718)
DROP TABLE a

-- Test 108: statement (line 723)
CREATE TABLE a (b FLOAT[])

-- Test 109: statement (line 726)
INSERT INTO a VALUES (ARRAY[1.1, 2.2, 3.3])

-- Test 110: query (line 729)
SELECT b FROM a

-- Test 111: statement (line 734)
DROP TABLE a

-- Test 112: statement (line 739)
CREATE TABLE a (b DECIMAL[])

-- Test 113: statement (line 742)
INSERT INTO a VALUES (ARRAY[1.1, 2.2, 3.3])

-- Test 114: query (line 745)
SELECT b FROM a

-- Test 115: statement (line 750)
DROP TABLE a

-- Test 116: statement (line 755)
CREATE TABLE a (b BYTES[])

-- Test 117: statement (line 758)
INSERT INTO a VALUES (ARRAY['foo','bar','baz'])

-- Test 118: query (line 761)
SELECT b FROM a

-- Test 119: statement (line 766)
DROP TABLE a

-- Test 120: statement (line 771)
CREATE TABLE a (b DATE[])

-- Test 121: statement (line 774)
INSERT INTO a VALUES (ARRAY[current_date])

-- Test 122: query (line 777)
SELECT count(b) FROM a

-- Test 123: statement (line 782)
DROP TABLE a

-- Test 124: statement (line 787)
CREATE TABLE a (b TIMESTAMP[])

-- Test 125: statement (line 790)
INSERT INTO a VALUES (ARRAY[now()])

-- Test 126: query (line 793)
SELECT count(b) FROM a

-- Test 127: statement (line 798)
DROP TABLE a

-- Test 128: statement (line 803)
CREATE TABLE a (b INTERVAL[])

-- Test 129: statement (line 806)
INSERT INTO a VALUES (ARRAY['1-2'::interval])

-- Test 130: query (line 809)
SELECT b FROM a

-- Test 131: statement (line 814)
DROP TABLE a

-- Test 132: statement (line 819)
CREATE TABLE a (b UUID[])

-- Test 133: statement (line 822)
INSERT INTO a VALUES (ARRAY[uuid_v4()::uuid])

-- Test 134: query (line 825)
SELECT count(b) FROM a

-- Test 135: statement (line 830)
DROP TABLE a

-- Test 136: statement (line 835)
CREATE TABLE a (b OID[])

-- Test 137: statement (line 838)
INSERT INTO a VALUES (ARRAY[1])

-- Test 138: query (line 841)
SELECT b FROM a

-- Test 139: statement (line 846)
DROP TABLE a

-- Test 140: statement (line 854)
INSERT INTO a VALUES (ARRAY['hello' COLLATE en]), (ARRAY['goodbye' COLLATE en])

-- Test 141: query (line 857)
SELECT * FROM a

-- Test 142: statement (line 863)
INSERT INTO a VALUES (ARRAY['hello' COLLATE fr])

-- Test 143: statement (line 866)
DROP TABLE a

-- Test 144: query (line 869)
SELECT * FROM unnest(ARRAY['a', 'B']) ORDER BY UNNEST;

-- Test 145: query (line 875)
SELECT * FROM unnest(ARRAY['a' COLLATE en, 'B' COLLATE en]) ORDER BY UNNEST;

-- Test 146: statement (line 882)
SELECT ARRAY['foo' COLLATE en] || ARRAY['bar' COLLATE en]

-- Test 147: statement (line 885)
SELECT ARRAY['foo' COLLATE en] || 'bar' COLLATE en

-- Test 148: statement (line 891)
INSERT INTO a VALUES (ARRAY['foo'])

-- Test 149: statement (line 894)
INSERT INTO a VALUES (ARRAY['foo' COLLATE en])

-- Test 150: statement (line 897)
DROP TABLE a

-- Test 151: query (line 906)
SELECT ARRAY['a','b','c'] || 'd'::text

-- Test 152: query (line 911)
SELECT ARRAY['a','b','c'] || 'd'

query T
SELECT ARRAY[1,2,3] || 4

-- Test 153: query (line 919)
SELECT NULL::INT[] || 4

-- Test 154: query (line 924)
SELECT 4 || NULL::INT[]

-- Test 155: query (line 929)
SELECT ARRAY[1,2,3] || NULL::INT

-- Test 156: query (line 934)
SELECT NULL::INT[] || NULL::INT

-- Test 157: query (line 939)
SELECT NULL::INT || ARRAY[1,2,3]

-- Test 158: query (line 944)
SELECT NULL::INT || NULL::INT[], NULL::INT[] || NULL::INT

-- Test 159: query (line 949)
SELECT 1 || ARRAY[2,3,4]

-- Test 160: query (line 957)
SELECT ARRAY[1,2,3] || NULL

-- Test 161: query (line 962)
SELECT NULL || ARRAY[1,2,3]

-- Test 162: query (line 969)
SELECT NULL || 'asdf', 'asdf' || NULL

-- Test 163: statement (line 974)
CREATE TABLE a (b INT[])

-- Test 164: statement (line 979)
INSERT INTO a VALUES (ARRAY[])

-- Test 165: statement (line 982)
UPDATE a SET b = b || 1

-- Test 166: statement (line 985)
UPDATE a SET b = b || 2

-- Test 167: statement (line 988)
UPDATE a SET b = b || 3

-- Test 168: statement (line 991)
UPDATE a SET b = b || 4

-- Test 169: query (line 994)
SELECT b FROM a

-- Test 170: statement (line 999)
UPDATE a SET b = NULL::INT || b || NULL::INT

-- Test 171: query (line 1002)
SELECT b FROM a

-- Test 172: query (line 1009)
SELECT ARRAY[1,2,3] || ARRAY[4,5,6]

-- Test 173: query (line 1014)
SELECT ARRAY['a','b','c'] || ARRAY['d','e','f']

-- Test 174: query (line 1019)
SELECT ARRAY[1,2,3] || NULL::INT[]

-- Test 175: query (line 1024)
SELECT NULL::INT[] || ARRAY[4,5,6]

-- Test 176: query (line 1029)
SELECT NULL::INT[] || NULL::INT[]

-- Test 177: statement (line 1036)
CREATE TABLE t_bool (b BOOL[]);

-- Test 178: query (line 1039)
SELECT b || NULL FROM t_bool;

-- Test 179: statement (line 1043)
INSERT INTO t_bool VALUES (Array[]);

-- Test 180: query (line 1046)
SELECT b || NULL FROM t_bool;

-- Test 181: statement (line 1051)
DROP TABLE t_bool;

-- Test 182: query (line 1056)
SELECT ARRAY[1,2,3] = ARRAY[1,2,3]

-- Test 183: query (line 1061)
SELECT ARRAY[1,2,4] = ARRAY[1,2,3]

-- Test 184: query (line 1066)
SELECT ARRAY[1,2,3] != ARRAY[1,2,3]

-- Test 185: query (line 1071)
SELECT ARRAY[1,2,4] != ARRAY[1,2,3]

-- Test 186: query (line 1076)
SELECT ARRAY[1,2,4] = NULL

-- Test 187: query (line 1083)
SELECT ARRAY[1,2,NULL] = ARRAY[1,2,3]

-- Test 188: query (line 1090)
SELECT array_append(ARRAY[1,2,3], 4), array_append(ARRAY[1,2,3], NULL::INT)

-- Test 189: query (line 1095)
SELECT array_append(NULL::INT[], 4), array_append(NULL::INT[], NULL::INT)

-- Test 190: query (line 1102)
SELECT array_prepend(4, ARRAY[1,2,3]), array_prepend(NULL::INT, ARRAY[1,2,3])

-- Test 191: query (line 1107)
SELECT array_prepend(4, NULL::INT[]), array_prepend(NULL::INT, NULL::INT[])

-- Test 192: query (line 1114)
SELECT array_cat(ARRAY[1,2,3], ARRAY[4,5,6]), array_cat(ARRAY[1,2,3], NULL::INT[])

-- Test 193: query (line 1119)
SELECT array_cat(NULL::INT[], ARRAY[4,5,6]), array_cat(NULL::INT[], NULL::INT[])

-- Test 194: query (line 1126)
SELECT array_remove(ARRAY[1,2,3,2], 2)

-- Test 195: query (line 1131)
SELECT array_remove(ARRAY[1,2,3,NULL::INT], NULL::INT)

-- Test 196: query (line 1136)
SELECT array_remove(NULL::INT[], NULL::INT)

-- Test 197: query (line 1143)
SELECT array_replace(ARRAY[1,2,5,4], 5, 3)

-- Test 198: query (line 1148)
SELECT array_replace(ARRAY[1,2,NULL,4], NULL::INT, 3), array_replace(NULL::INT[], 5, 3)

-- Test 199: query (line 1169)
SELECT array_position(ARRAY['sun','mon','tue','wed','thu','fri','sat','mon'], 'abc')

-- Test 200: query (line 1196)
SELECT array_position(ARRAY['sun','mon','tue','wed','thu','fri','sat','mon'], 'mon', 3)

-- Test 201: query (line 1201)
SELECT array_position(ARRAY['sun','mon','tue','wed','thu','fri','sat','mon'], 'tue', 4)

-- Test 202: query (line 1206)
SELECT array_position(ARRAY['sun','mon','tue','wed','thu','fri','sat','mon'], 'abc', 1)

-- Test 203: query (line 1211)
SELECT array_position(ARRAY['sun','mon','tue','wed','thu','fri','sat','mon'], 'wed', 9)

-- Test 204: query (line 1216)
SELECT array_position(ARRAY['sun','mon','tue','wed','thu','fri','sat','mon'], 'wed', 0)

-- Test 205: query (line 1228)
SELECT array_positions(ARRAY['A','A','B','A'], 'A'), array_positions(ARRAY['A','A','B','A'], 'C')

-- Test 206: query (line 1238)
SELECT string_to_array('axbxc', 'x')

-- Test 207: query (line 1243)
SELECT string_to_array('~a~~b~c', '~')

-- Test 208: query (line 1248)
SELECT string_to_array('~foo~~bar~baz', '~', 'bar')

-- Test 209: query (line 1253)
SELECT string_to_array('xx~^~yy~^~zz', '~^~', 'yy')

-- Test 210: query (line 1258)
SELECT string_to_array('foo', '')

-- Test 211: query (line 1263)
SELECT string_to_array('', '')

-- Test 212: query (line 1268)
SELECT string_to_array('', 'foo')

-- Test 213: query (line 1273)
SELECT string_to_array('a', NULL)

-- Test 214: query (line 1278)
SELECT string_to_array(NULL, 'a')

-- Test 215: query (line 1283)
SELECT string_to_array(NULL, 'a', 'b')

-- Test 216: query (line 1288)
SELECT string_to_array('a', 'foo', NULL)

-- Test 217: query (line 1293)
SELECT string_to_array('foofoofoofoo', 'foo', 'foo')

-- Test 218: statement (line 1300)
CREATE TABLE str_arr(j JSONB)

-- Test 219: statement (line 1303)
INSERT INTO str_arr
VALUES
    ('{"a": ["foo", "bar", "z"]}'),
    ('{"a": ["1", "2", "3"]}'),
    ('{"a": []}'),
    ('{"b": "not-array"}')

-- Test 220: query (line 1311)
SELECT jsonb_array_to_string_array(j -> 'a') FROM str_arr ORDER BY j ASC

-- Test 221: query (line 1319)
SELECT jsonb_array_to_string_array(j -> 'b') FROM str_arr ORDER BY j ASC

query T
SELECT jsonb_array_to_string_array('[1, 2, 3]':::JSONB)

-- Test 222: query (line 1327)
SELECT jsonb_array_to_string_array('[true, false, false, true]':::JSONB)

-- Test 223: query (line 1332)
SELECT jsonb_array_to_string_array('[null]':::JSONB)

-- Test 224: query (line 1337)
SELECT jsonb_array_to_string_array('[1, "abc", true, ["a", "b"], {"b": "foo"}, null]':::JSONB)

-- Test 225: statement (line 1347)
UPDATE x SET a = ARRAY[], b = ARRAY[]

-- Test 226: statement (line 1352)
CREATE TABLE documents (shared_users UUID[]);

-- Test 227: statement (line 1355)
INSERT INTO documents
VALUES
    (ARRAY[]),
    (ARRAY['3ae3560e-d771-4b63-affb-47e8d7853680'::UUID,
           '6CC1B5C1-FE4F-417D-96BD-AFD1FEEEC34F'::UUID]),
    (ARRAY['C6F8286C-3A41-4D7E-A4F4-3234B7A57BA9'::UUID])

-- Test 228: query (line 1363)
SELECT *
FROM documents
WHERE '3ae3560e-d771-4b63-affb-47e8d7853680'::UUID = ANY (documents.shared_users);

-- Test 229: statement (line 1370)
CREATE TABLE u (x INT)

-- Test 230: statement (line 1373)
INSERT INTO u VALUES (1), (2)

-- Test 231: statement (line 1376)
CREATE TABLE v (y INT[])

-- Test 232: statement (line 1379)
INSERT INTO v VALUES (ARRAY[1, 2])

-- Test 233: query (line 1383)
SELECT * FROM v WHERE y = ARRAY(SELECT x FROM u ORDER BY x);

-- Test 234: query (line 1389)
SELECT ARRAY[''] = ARRAY[] FROM (VALUES (1)) WHERE ARRAY[B''] != ARRAY[]

-- Test 235: statement (line 1396)
CREATE TABLE array_single_family (a INT PRIMARY KEY, b INT[], FAMILY fam0(a), FAMILY fam1(b))

-- Test 236: statement (line 1399)
INSERT INTO array_single_family VALUES(0,ARRAY[])

-- Test 237: statement (line 1402)
INSERT INTO array_single_family VALUES(1,ARRAY[1])

-- Test 238: statement (line 1405)
INSERT INTO array_single_family VALUES(2,ARRAY[1,2])

-- Test 239: statement (line 1408)
INSERT INTO array_single_family VALUES(3,ARRAY[1,2,NULL])

-- Test 240: statement (line 1411)
INSERT INTO array_single_family VALUES(4,ARRAY[NULL,2,3])

-- Test 241: statement (line 1414)
INSERT INTO array_single_family VALUES(5,ARRAY[1,NULL,3])

-- Test 242: statement (line 1417)
INSERT INTO array_single_family VALUES(6,ARRAY[NULL::INT])

-- Test 243: statement (line 1420)
INSERT INTO array_single_family VALUES(7,ARRAY[NULL::INT,NULL::INT])

-- Test 244: statement (line 1423)
INSERT INTO array_single_family VALUES(8,ARRAY[NULL::INT,NULL::INT,NULL::INT])

-- Test 245: query (line 1426)
SELECT a, b FROM array_single_family ORDER BY a

-- Test 246: statement (line 1440)
DROP TABLE array_single_family

-- Test 247: query (line 1443)
SELECT ARRAY[]::int[], ARRAY[]:::int[]

-- Test 248: query (line 1450)
SELECT
    col_1
FROM
    (
        VALUES
            (ARRAY[]::INT8[]),
            (ARRAY[]::INT8[])
    )
        AS tab_1 (col_1)
GROUP BY
    tab_1.col_1

-- Test 249: statement (line 1466)
CREATE TABLE defvals (
    id SERIAL NOT NULL PRIMARY KEY,
    arr1 STRING(100) ARRAY NOT NULL DEFAULT ARRAY[],
    arr2 INT ARRAY NOT NULL DEFAULT ARRAY[]
)

-- Test 250: statement (line 1473)
INSERT INTO defvals(id) VALUES (1)

-- Test 251: statement (line 1476)
CREATE TABLE defvals2 (
    id SERIAL NOT NULL PRIMARY KEY,
    arr1 STRING(100) ARRAY NOT NULL DEFAULT ARRAY[NULL],
    arr2 INT ARRAY NOT NULL DEFAULT ARRAY[NULL]
)

-- Test 252: statement (line 1483)
INSERT INTO defvals2(id) VALUES (1)

-- Test 253: statement (line 1488)
DROP TABLE IF EXISTS t;

-- Test 254: statement (line 1494)
SELECT * FROM t WHERE y < z

-- Test 255: statement (line 1497)
INSERT INTO t VALUES (ARRAY[1], ARRAY[1, 2], NULL), (ARRAY[1, 1, 1, 1], ARRAY[2], NULL)

-- Test 256: query (line 1500)
SELECT x, y FROM t WHERE x < y

-- Test 257: query (line 1506)
SELECT x, y FROM t WHERE x > y

-- Test 258: query (line 1510)
SELECT x, y FROM t ORDER BY (x, y)

-- Test 259: statement (line 1521)
DROP TABLE IF EXISTS t

-- Test 260: statement (line 1524)
CREATE TABLE t_indexed (x INT[] PRIMARY KEY)

-- Test 261: statement (line 1527)
CREATE TABLE t (x INT[])

-- Test 262: statement (line 1530)
INSERT INTO t VALUES
  (ARRAY[1]),
  (ARRAY[5]),
  (ARRAY[4]),
  (ARRAY[1,4,5]),
  (ARRAY[1,4,6]),
  (ARRAY[1,NULL,10]),
  (ARRAY[NULL]),
  (ARRAY[NULL, NULL, NULL])

-- Test 263: query (line 1546)
SELECT x FROM t ORDER BY x

-- Test 264: query (line 1559)
SELECT x FROM t WHERE x = ARRAY[1,4,6]

-- Test 265: query (line 1571)
SELECT x FROM t WHERE x < ARRAY[1, 4, 3] ORDER BY x

-- Test 266: query (line 1579)
SELECT x FROM t WHERE x > ARRAY [1, NULL] ORDER BY x DESC

-- Test 267: query (line 1588)
SELECT x FROM t WHERE x > ARRAY[1, 3] AND x < ARRAY[1, 4, 10] ORDER BY x

-- Test 268: query (line 1594)
SELECT x FROM t WHERE x > ARRAY[NULL, NULL]:::INT[] ORDER BY x

-- Test 269: statement (line 1606)
CREATE INDEX i ON t(x DESC)

-- Test 270: query (line 1609)
SELECT x FROM t@i WHERE x <= ARRAY[1] ORDER BY x DESC

-- Test 271: query (line 1616)
SELECT x FROM t@i WHERE x > ARRAY[1] ORDER BY x

-- Test 272: statement (line 1626)
DROP TABLE t

-- Test 273: statement (line 1629)
CREATE TABLE t (x INT[])

-- Test 274: statement (line 1632)
INSERT INTO t VALUES
  (ARRAY[1]),
  (ARRAY[5]),
  (ARRAY[4]),
  (ARRAY[1,4,5]),
  (ARRAY[1,4,6]),
  (ARRAY[1,NULL,10]),
  (ARRAY[NULL]),
  (ARRAY[NULL, NULL, NULL])

-- Test 275: query (line 1643)
SELECT x FROM t ORDER BY x

-- Test 276: query (line 1655)
SELECT x FROM t ORDER BY x DESC

-- Test 277: statement (line 1667)
CREATE INDEX i ON t (x);

-- Test 278: query (line 1672)
SELECT x FROM t@i ORDER BY x

-- Test 279: query (line 1684)
SELECT x FROM t@i ORDER BY x DESC

-- Test 280: statement (line 1696)
INSERT INTO t VALUES (NULL), (NULL)

-- Test 281: query (line 1701)
SELECT x FROM t WHERE x IS NOT NULL ORDER BY x

-- Test 282: statement (line 1714)
CREATE TABLE unique_array (a INT[] UNIQUE, b INT[])

-- Test 283: statement (line 1717)
INSERT INTO unique_array VALUES (ARRAY[1], ARRAY[2, 3])

-- Test 284: statement (line 1720)
INSERT INTO unique_array VALUES (ARRAY[1], ARRAY[2, 3])

-- Test 285: statement (line 1723)
INSERT INTO unique_array VALUES (ARRAY[2], ARRAY[2, 3])

-- Test 286: statement (line 1726)
CREATE UNIQUE INDEX ON unique_array(b)

-- Test 287: statement (line 1730)
CREATE TABLE tbad (x GEOGRAPHY[] PRIMARY KEY)

-- Test 288: statement (line 1735)
CREATE TABLE tarray(x DECIMAL[]);
INSERT INTO tarray VALUES (ARRAY[1.00]), (ARRAY[1.501])

-- Test 289: query (line 1740)
SELECT x FROM tarray ORDER BY x

-- Test 290: statement (line 1748)
DROP TABLE t;

-- Test 291: statement (line 1751)
CREATE TABLE t (x INT, y INT[], z INT);

-- Test 292: statement (line 1754)
INSERT INTO t VALUES
  (1, ARRAY[1, 2, 3], 3),
  (NULL, ARRAY[1, NULL, 3], NULL),
  (2, ARRAY[NULL, NULL, NULL], NULL),
  (NULL, ARRAY[NULL, NULL], 3),
  (2, ARRAY[4, 5], 7)

-- Test 293: query (line 1762)
SELECT x, y, z FROM t WHERE x IS NOT NULL AND y > ARRAY[1] ORDER BY z

-- Test 294: query (line 1768)
SELECT x, y, z FROM t WHERE x = 2 AND y < ARRAY[10] ORDER BY y

-- Test 295: statement (line 1776)
DROP TABLE t;

-- Test 296: query (line 1789)
SELECT x FROM t ORDER BY x DESC

-- Test 297: query (line 1797)
SELECT x FROM t WHERE x > ARRAY['hell'] AND x < ARRAY['i']

-- Test 298: statement (line 1805)
DROP TABLE t;

-- Test 299: statement (line 1808)
CREATE TABLE t (x BYTES[]);

-- Test 300: statement (line 1811)
INSERT INTO t VALUES
  (ARRAY[b'\xFF', b'\x00']),
  (ARRAY[NULL, b'\x01', b'\x01', NULL]),
  (ARRAY[NULL, b'\xFF'])

-- Test 301: query (line 1817)
SELECT x FROM t ORDER BY x

-- Test 302: statement (line 1826)
DROP TABLE t;

-- Test 303: statement (line 1829)
CREATE TABLE t (x BYTES[]);

-- Test 304: statement (line 1832)
INSERT INTO t VALUES
  (ARRAY[b'\xFF', b'\x00']),
  (ARRAY[NULL, b'\x01', b'\x01', NULL]),
  (ARRAY[NULL, b'\xFF'])

-- Test 305: query (line 1838)
SELECT x FROM t ORDER BY x

-- Test 306: statement (line 1847)
DROP TABLE t;

-- Test 307: statement (line 1850)
CREATE TABLE t (x INT[], y INT[]);

-- Test 308: statement (line 1853)
INSERT INTO t VALUES
  (ARRAY[1, 2], ARRAY[3, 4]),
  (ARRAY[NULL, NULL], ARRAY[NULL, NULL]),
  (ARRAY[], ARRAY[]),
  (ARRAY[], ARRAY[NULL, 2]),
  (ARRAY[NULL], ARRAY[])

-- Test 309: query (line 1861)
SELECT x, y FROM t ORDER BY x, y

-- Test 310: query (line 1870)
SELECT x, y FROM t WHERE x > ARRAY[NULL]:::INT[] ORDER BY y

-- Test 311: statement (line 1898)
DROP TABLE IF EXISTS t1, t2 CASCADE;

-- Test 312: statement (line 1901)
CREATE TABLE t1 (x INT[]);

-- Test 313: statement (line 1904)
CREATE TABLE t2 (x INT[]);

-- Test 314: statement (line 1907)
INSERT INTO t1 VALUES
  (ARRAY[1, 2]),
  (ARRAY[NULL]),
  (ARRAY[3, 4]);
INSERT INTO t2 VALUES
  (ARRAY[]),
  (ARRAY[1, 2]),
  (ARRAY[NULL])

-- Test 315: query (line 1917)
SELECT t1.x FROM t1 INNER HASH JOIN t2 ON t1.x = t2.x

-- Test 316: query (line 1923)
SELECT t1.x FROM t1 INNER MERGE JOIN t2 ON t1.x = t2.x

-- Test 317: statement (line 1938)
DROP TABLE t;

-- Test 318: statement (line 1941)
CREATE TABLE t (x INT[]);

-- Test 319: statement (line 1944)
INSERT INTO t VALUES
  (ARRAY[1, 2]),
  (ARRAY[1, 2]),
  (ARRAY[1, 2]),
  (ARRAY[NULL, NULL]),
  (ARRAY[NULL, NULL]),
  (ARRAY[1,2,NULL,4,NULL]),
  (ARRAY[1,2,NULL,4,NULL])

-- Test 320: query (line 1954)
SELECT x FROM t GROUP BY x

-- Test 321: query (line 1962)
SELECT CASE
  WHEN NULL THEN (('1':::INT8, ARRAY[]:::INT2[]))
  ELSE ('2':::INT8, ARRAY[(-23791):::INT8])
END

-- Test 322: statement (line 1971)
DROP TABLE t;

-- Test 323: statement (line 1987)
INSERT INTO t VALUES (
  '{1, 2}',
  '{1.1, 2.2}',
  '{18e7b17e-4ead-4e27-bfd5-bb6d11261bb6, 18e7b17e-4ead-4e27-bfd5-bb6d11261bb7}',
  '{cat, dog}',
  '{2010-09-28 12:00:00.1, 2010-09-29 12:00:00.1}',
  '{2010-09-28, 2010-09-29}',
  '{PT12H2M, -23:00:00}',
  '{192.168.100.128, ::ffff:10.4.3.2}',
  '{0101, 11}',
  '{12.34, 45.67}');

-- Test 324: query (line 2002)
SELECT array_prepend(1, NULL);

-- Test 325: query (line 2007)
SELECT array_append(NULL, 'cat');

-- Test 326: query (line 2012)
SELECT array_cat(NULL, ARRAY[1]);

-- Test 327: query (line 2017)
SELECT array_cat(ARRAY[1], NULL);

-- Test 328: query (line 2022)
SELECT array_remove(NULL, 'cat');

-- Test 329: query (line 2027)
SELECT array_replace(NULL, 'cat', 'dog');

-- Test 330: query (line 2032)
SELECT array_position(NULL, 'cat');

-- Test 331: query (line 2037)
SELECT array_positions(NULL, 'cat');

-- Test 332: statement (line 2052)
INSERT INTO kv VALUES (1, 'one'), (2, 'two'), (3, 'three'), (4, 'four'), (5, null)

-- Test 333: query (line 2055)
SELECT ARRAY[(k, k)] FROM kv

-- Test 334: query (line 2064)
SELECT ARRAY[(k, k), (1, 2)] FROM kv

-- Test 335: query (line 2073)
SELECT ARRAY[(k, 'foo'), (1, v)] FROM kv

-- Test 336: query (line 2084)
SELECT array_cat(ARRAY[ROW(10,'fish')], ARRAY[(k,v)]) FROM kv

-- Test 337: query (line 2093)
SELECT array_cat(ARRAY[ROW(1,NULL)], ARRAY[(k,v)]) FROM kv

-- Test 338: query (line 2102)
SELECT array_cat(ARRAY[NULL::record], ARRAY[(k,v)]) FROM kv

-- Test 339: query (line 2111)
SELECT array_cat(ARRAY[ROW(1,2)], ARRAY[NULL::record])

-- Test 340: query (line 2116)
SELECT array_agg(ROW(1, 2))

-- Test 341: query (line 2121)
SELECT array_agg(ROW(k,v) ORDER BY k) FROM kv

-- Test 342: query (line 2126)
SELECT array_append(ARRAY[ROW(10,'fish')], (k,v)) FROM kv

-- Test 343: query (line 2135)
SELECT array_append(ARRAY[ROW(1,2)], NULL::record)

-- Test 344: query (line 2140)
SELECT array_append(NULL::record[], (k,v)) FROM kv

-- Test 345: query (line 2149)
SELECT array_append(NULL::record[], NULL::record)

-- Test 346: query (line 2154)
SELECT array_prepend((k,v), ARRAY[ROW(10,'fish'), ROW(11,'zebra')]) FROM kv

-- Test 347: query (line 2163)
SELECT array_prepend(NULL::record, ARRAY[ROW(10,'fish'), ROW(11,'zebra')])

-- Test 348: query (line 2168)
SELECT array_prepend(ROW(1,2), NULL::record[])

-- Test 349: query (line 2173)
SELECT array_prepend(NULL::record, NULL::record[])

-- Test 350: query (line 2178)
SELECT array_remove(ARRAY[ROW(1,'cat'), ROW(10,'fish'), ROW(11,'zebra')], ROW(10,'fish'))

-- Test 351: query (line 2183)
SELECT array_remove(ARRAY[ROW(1,'cat'), ROW(10,'fish'), ROW(11,'zebra'), NULL], NULL::record)

-- Test 352: query (line 2188)
SELECT array_remove(NULL::record[], NULL::record)

-- Test 353: query (line 2193)
SELECT array_replace(ARRAY[ROW(1,'cat'), ROW(10,'fish'), ROW(11,'zebra')], ROW(10,'fish'), ROW(2,'dog'))

-- Test 354: query (line 2198)
SELECT array_replace(ARRAY[ROW(1,'cat'), NULL, ROW(11,'zebra')], NULL::record, ROW(2,'dog')), array_replace(NULL::record[], ROW(10,'fish'), ROW(2,'dog'))

-- Test 355: query (line 2205)
SELECT array_position(ARRAY[ROW(1,'cat'), ROW(10,'fish'), ROW(11,'zebra')], ROW(11,'zebra'))

-- Test 356: query (line 2210)
SELECT array_position(ARRAY[ROW(1,'cat'), ROW(10,'fish'), ROW(11,'zebra')], ROW(33,'hippo'))

-- Test 357: query (line 2215)
SELECT array_position(NULL::record[], ROW(33,'hippo'))

-- Test 358: query (line 2222)
SELECT array_positions(ARRAY[ROW(1,'cat'), ROW(11,'zebra'), ROW(10,'fish'), ROW(11,'zebra')], ROW(11,'zebra'))

-- Test 359: query (line 2227)
SELECT array_positions(ARRAY[ROW(1,'cat'), ROW(11,'zebra'), ROW(10,'fish'), ROW(11,'zebra')], ROW(33,'hippo'))

-- Test 360: query (line 2232)
SELECT array_positions(NULL::record[], ROW(33,'hippo'))

-- Test 361: query (line 2242)
SELECT array_replace(ARRAY[(1,'cat'),(2,'dog')], (1, 12.3::decimal), (3,'fish'))

# array_append does not require the tuple types to match exactly.
query error pgcode 42804 unsupported comparison.*\n.*at record column 2
SELECT array_replace(array_append(array[(1,'cat')], (2,true)), (2,'fish'), (3,'dog'))

# This works because the comparison short-circuits before comparing the boolean column
query T
SELECT array_replace(array_append(array[(1,'cat')], (2,true)), (1,'fish'), (3,'dog'))

-- Test 362: query (line 2256)
SELECT array_replace(ARRAY[(1,'cat'),(2,'dog')], (2, 'dog'), (3,true))

-- Test 363: query (line 2261)
SELECT array_position(ARRAY[(12::OID,NULL),(NULL,NULL)], ('\xc03b4478eb'::BYTEA,NULL))

query error pgcode 42804 unsupported comparison.*\n.*at record column 2
SELECT array_positions(ARRAY[(1,'cat'),(2,'dog')], (2,true))

query error pgcode 42804 unsupported comparison.*\n.*at record column 2
SELECT array_remove(ARRAY[(1,'cat'),(2,'dog')], (2,'\xc03b4478eb'::BYTEA))

# This works because the comparison short-circuits before comparing the BYTEA column
query T
SELECT array_remove(ARRAY[(1,'cat'),(2,'dog')], (3,'\xc03b4478eb'::BYTEA))

-- Test 364: statement (line 2278)
PREPARE regression_71394 AS SELECT ARRAY[$1]::int[];

-- Test 365: query (line 2281)
EXECUTE regression_71394(71394)

-- Test 366: statement (line 2290)
CREATE TYPE letter AS ENUM ('a', 'b', 'c');

-- Test 367: statement (line 2293)
CREATE TABLE kv_enum (
  k INT PRIMARY KEY,
  v letter
);

-- Test 368: statement (line 2299)
INSERT INTO kv_enum VALUES (1, 'a'), (2, 'b'), (3, 'c'), (4, NULL)

-- Test 369: query (line 2302)
SELECT ARRAY[v] FROM kv_enum

-- Test 370: query (line 2312)
SELECT array_cat(ARRAY['a'::letter, 'b'], ARRAY[v]) FROM kv_enum

-- Test 371: query (line 2320)
SELECT array_cat(ARRAY[NULL::letter], ARRAY[v]) FROM kv_enum

-- Test 372: query (line 2328)
SELECT array_cat(ARRAY['a'::letter], ARRAY[NULL::letter])

-- Test 373: query (line 2333)
SELECT array_agg('a'::letter)

-- Test 374: query (line 2338)
SELECT array_agg(v ORDER BY k) FROM kv_enum

-- Test 375: query (line 2343)
SELECT array_append(ARRAY['a'::letter], v) FROM kv_enum

-- Test 376: query (line 2351)
SELECT array_append(ARRAY['a'::letter], NULL::letter)

-- Test 377: query (line 2356)
SELECT array_append(NULL::letter[], v) FROM kv_enum

-- Test 378: query (line 2364)
SELECT array_append(NULL::letter[], NULL::letter)

-- Test 379: query (line 2369)
SELECT array_prepend(v, ARRAY['a'::letter, 'b']) FROM kv_enum

-- Test 380: query (line 2377)
SELECT array_prepend(NULL::letter, ARRAY['a'::letter])

-- Test 381: query (line 2382)
SELECT array_prepend('a'::letter, NULL::letter[])

-- Test 382: query (line 2387)
SELECT array_prepend(NULL::letter, NULL::letter[])

-- Test 383: query (line 2392)
SELECT array_remove(ARRAY['a'::letter, 'b'], 'a'::letter)

-- Test 384: query (line 2397)
SELECT array_remove(ARRAY['a'::letter, 'b', NULL], NULL::letter)

-- Test 385: query (line 2402)
SELECT array_remove(NULL::letter[], NULL::letter)

-- Test 386: query (line 2407)
SELECT array_replace(ARRAY['a'::letter, 'b'], 'b'::letter, 'c'::letter)

-- Test 387: query (line 2412)
SELECT array_replace(ARRAY['a'::letter, NULL], NULL::letter, 'c'::letter), array_replace(NULL::letter[], 'a'::letter, 'b'::letter)

-- Test 388: query (line 2419)
SELECT array_position(ARRAY['a'::letter, 'b', 'c'], 'c'::letter)

-- Test 389: query (line 2424)
SELECT array_position(NULL::letter[], 'a'::letter)

-- Test 390: query (line 2431)
SELECT array_positions(ARRAY['a'::letter, 'b', 'a'], 'a'::letter)

-- Test 391: query (line 2436)
SELECT array_positions(NULL::letter[], 'b'::letter)

-- Test 392: statement (line 2445)
SET distsql_workmem = '2B'

-- Test 393: query (line 2449)
SELECT indkey FROM pg_index WHERE indrelid = (SELECT oid FROM pg_class WHERE relname = 'k') ORDER BY 1

-- Test 394: statement (line 2454)
RESET distsql_workmem

-- Test 395: statement (line 2467)
CREATE TABLE t1_87919 (
  a  INT
);
CREATE TABLE t2_87919 (
  b INT,
  c TIME[]
);
INSERT INTO t1_87919 (a) VALUES (NULL);
INSERT INTO t2_87919 (c) VALUES (ARRAY['03:23:06.042923']);

-- Test 396: query (line 2478)
SELECT ('09:20:35.19023'::TIME || c)::TIME[] AS col_25551
FROM t1_87919
FULL JOIN t2_87919 ON a = b
ORDER BY a;

