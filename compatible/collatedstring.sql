-- PostgreSQL compatible tests from collatedstring
-- 110 tests

-- Test 1: statement (line 2)
SELECT 'a' COLLATE bad_locale

-- Test 2: query (line 5)
SELECT 'A' COLLATE en = 'a'

-- Test 3: statement (line 10)
SELECT 'A' COLLATE en = 'a' COLLATE de

-- Test 4: statement (line 13)
SELECT ('a' COLLATE en_u_ks_level1) IN ('A' COLLATE en_u_ks_level1, 'b' COLLATE en)

-- Test 5: statement (line 16)
SELECT ('a' COLLATE en_u_ks_level1, 'a' COLLATE en) < ('A' COLLATE en, 'B' COLLATE en)

-- Test 6: query (line 20)
SELECT 'A' COLLATE en

-- Test 7: query (line 25)
SELECT ('A' COLLATE de) COLLATE en

-- Test 8: query (line 30)
SELECT NAME 'A' COLLATE en

-- Test 9: query (line 35)
SELECT (NAME 'A' COLLATE de) COLLATE en

-- Test 10: query (line 40)
SELECT NULL COLLATE en

-- Test 11: query (line 45)
SELECT 'a' COLLATE en < ('B' COLLATE de) COLLATE en

-- Test 12: query (line 51)
SELECT (1, 'a' COLLATE en) < (1, 'B' COLLATE en)

-- Test 13: query (line 56)
SELECT ('a' COLLATE en_u_ks_level1, 'a' COLLATE en) < ('A' COLLATE en_u_ks_level1, 'B' COLLATE en)

-- Test 14: query (line 62)
SELECT 'A' COLLATE en_u_ks_level1 = 'a' COLLATE en_u_ks_level1

-- Test 15: query (line 67)
SELECT 'A' COLLATE en_u_ks_level1 <> 'a' COLLATE en_u_ks_level1

-- Test 16: query (line 72)
SELECT 'A' COLLATE en_u_ks_level1 < 'a' COLLATE en_u_ks_level1

-- Test 17: query (line 77)
SELECT 'A' COLLATE en_u_ks_level1 >= 'a' COLLATE en_u_ks_level1

-- Test 18: query (line 82)
SELECT 'A' COLLATE en_u_ks_level1 <= 'a' COLLATE en_u_ks_level1

-- Test 19: query (line 87)
SELECT 'A' COLLATE en_u_ks_level1 > 'a' COLLATE en_u_ks_level1

-- Test 20: query (line 93)
SELECT 'a' COLLATE en_u_ks_level1 = 'B' COLLATE en_u_ks_level1

-- Test 21: query (line 98)
SELECT 'a' COLLATE en_u_ks_level1 <> 'B' COLLATE en_u_ks_level1

-- Test 22: query (line 103)
SELECT 'a' COLLATE en_u_ks_level1 < 'B' COLLATE en_u_ks_level1

-- Test 23: query (line 108)
SELECT 'a' COLLATE en_u_ks_level1 >= 'B' COLLATE en_u_ks_level1

-- Test 24: query (line 113)
SELECT 'a' COLLATE en_u_ks_level1 <= 'B' COLLATE en_u_ks_level1

-- Test 25: query (line 118)
SELECT 'a' COLLATE en_u_ks_level1 > 'B' COLLATE en_u_ks_level1

-- Test 26: query (line 124)
SELECT 'B' COLLATE en_u_ks_level1 = 'A' COLLATE en_u_ks_level1

-- Test 27: query (line 129)
SELECT 'B' COLLATE en_u_ks_level1 <> 'A' COLLATE en_u_ks_level1

-- Test 28: query (line 134)
SELECT 'B' COLLATE en_u_ks_level1 < 'A' COLLATE en_u_ks_level1

-- Test 29: query (line 139)
SELECT 'B' COLLATE en_u_ks_level1 >= 'A' COLLATE en_u_ks_level1

-- Test 30: query (line 144)
SELECT 'B' COLLATE en_u_ks_level1 <= 'A' COLLATE en_u_ks_level1

-- Test 31: query (line 149)
SELECT 'B' COLLATE en_u_ks_level1 > 'A' COLLATE en_u_ks_level1

-- Test 32: query (line 155)
SELECT ('a' COLLATE en_u_ks_level1) IN ('A' COLLATE en_u_ks_level1, 'b' COLLATE en_u_ks_level1)

-- Test 33: query (line 160)
SELECT ('a' COLLATE en_u_ks_level1) NOT IN ('A' COLLATE en_u_ks_level1, 'b' COLLATE en_u_ks_level1)

-- Test 34: query (line 165)
SELECT ('a' COLLATE en) IN ('A' COLLATE en, 'b' COLLATE en)

-- Test 35: query (line 170)
SELECT ('a' COLLATE en) NOT IN ('A' COLLATE en, 'b' COLLATE en)

-- Test 36: query (line 176)
SELECT 'Fussball' COLLATE de = 'Fußball' COLLATE de

-- Test 37: query (line 181)
SELECT 'Fussball' COLLATE de_u_ks_level1 = 'Fußball' COLLATE de_u_ks_level1

-- Test 38: query (line 187)
SELECT 'ü' COLLATE da < 'x' COLLATE da

-- Test 39: query (line 192)
SELECT 'ü' COLLATE de < 'x' COLLATE de

-- Test 40: query (line 197)
SELECT e'\u00E9' COLLATE "en_US" = e'\u0065\u0301' COLLATE "en_US";

-- Test 41: query (line 202)
SELECT e'\u00E9' COLLATE "en_US" LIKE e'\u0065\u0301' COLLATE "en_US";

-- Test 42: statement (line 218)
CREATE TABLE e3 (
  a INT COLLATE en
)

-- Test 43: query (line 229)
SHOW CREATE TABLE t

-- Test 44: query (line 239)
SHOW CREATE TABLE t

-- Test 45: statement (line 248)
INSERT INTO t VALUES
  ('A' COLLATE en),
  ('B' COLLATE en),
  ('a' COLLATE en),
  ('b' COLLATE en),
  ('x' COLLATE en),
  ('ü' COLLATE en)

-- Test 46: statement (line 257)
INSERT INTO t VALUES
  ('X' COLLATE de),
  ('y' COLLATE de)

-- Test 47: query (line 262)
SELECT a FROM t ORDER BY t.a

-- Test 48: query (line 274)
SELECT a FROM t ORDER BY t.a COLLATE da

-- Test 49: query (line 286)
SELECT a FROM t WHERE a = 'A' COLLATE en;

-- Test 50: query (line 296)
SELECT 'a🐛b🏠c' COLLATE en::VARCHAR(3)

-- Test 51: query (line 301)
SELECT 't' COLLATE en::BOOLEAN

-- Test 52: query (line 306)
SELECT '42' COLLATE en::INTEGER

-- Test 53: query (line 311)
SELECT '42.0' COLLATE en::FLOAT

-- Test 54: query (line 316)
SELECT '42.0' COLLATE en::DECIMAL

-- Test 55: query (line 321)
SELECT 'a' COLLATE en::BYTES

-- Test 56: query (line 326)
SELECT '2017-01-10 16:05:50.734049+00:00' COLLATE en::TIMESTAMP

-- Test 57: query (line 331)
SELECT '2017-01-10 16:05:50.734049+00:00' COLLATE en::TIMESTAMPTZ

-- Test 58: query (line 336)
SELECT '40 days' COLLATE en::INTERVAL

-- Test 59: statement (line 344)
PREPARE x AS INSERT INTO foo VALUES ($1 COLLATE en_u_ks_level2) RETURNING a

-- Test 60: query (line 347)
EXECUTE x(NULL)

-- Test 61: query (line 352)
SELECT a FROM foo

-- Test 62: statement (line 359)
INSERT INTO foo VALUES ('aBcD' COLLATE en_u_ks_level2)

-- Test 63: query (line 362)
SELECT * FROM foo WHERE a = 'aBcD' COLLATE en_u_ks_level2

-- Test 64: query (line 367)
SELECT * FROM foo WHERE a = 'abcd' COLLATE en_u_ks_level2

-- Test 65: query (line 385)
SHOW CREATE TABLE quoted_coll

-- Test 66: query (line 399)
SHOW CREATE TABLE quoted_coll

-- Test 67: statement (line 439)
CREATE TABLE t50015(id int PRIMARY KEY, a char(100), b char(100) COLLATE en);
INSERT INTO t50015 VALUES
  (1, 'hello', 'hello' COLLATE en),
  (2, 'hello ', 'hello ' COLLATE en),
  (3, repeat('hello ', 2), repeat('hello ', 2) COLLATE en)

-- Test 68: statement (line 453)
CREATE TABLE t54989(
  no_collation_str text,
  no_collation_str_array text[],
  collated_str text COLLATE en,
  default_collation text COLLATE "default"
)

-- Test 69: query (line 461)
SELECT
    a.attname AS column_name,
    collname AS collation
FROM pg_attribute a
LEFT JOIN pg_collation co ON a.attcollation = co.oid
JOIN pg_class c ON a.attrelid = c.oid
JOIN pg_namespace n ON c.relnamespace = n.oid
WHERE c.relname = 't54989'
ORDER BY column_name

-- Test 70: query (line 480)
SELECT 'cat' = ('cat'::text collate "default"), 'cat' = ('cat'::VARCHAR(64) collate "C"), 'cat' = ('cat'::CHAR(3) collate "POSIX")

-- Test 71: statement (line 485)
INSERT INTO t54989 VALUES ('a', '{b}', 'c', 'd')

-- Test 72: query (line 488)
SELECT default_collation = 'd' COLLATE "C", no_collation_str = 'a' COLLATE "POSIX" FROM t54989

-- Test 73: statement (line 496)
CREATE TABLE disallowed(a text COLLATE "C")

-- Test 74: statement (line 499)
CREATE TABLE disallowed(a text COLLATE "POSIX")

-- Test 75: statement (line 508)
INSERT INTO nocase_strings VALUES ('Aaa' COLLATE "en-US-u-ks-level2"), ('Bbb' COLLATE "en-US-u-ks-level2");

-- Test 76: query (line 511)
SELECT s FROM nocase_strings WHERE s = ('bbb' COLLATE "en-US-u-ks-level2")

-- Test 77: query (line 516)
SELECT s FROM nocase_strings WHERE s = ('bbb' COLLATE "en-us-u-ks-level2")

-- Test 78: query (line 521)
SELECT s FROM nocase_strings WHERE s = ('bbb' COLLATE "en_US_u_ks_level2")

-- Test 79: query (line 530)
SHOW CREATE TABLE collation_name_case

-- Test 80: query (line 540)
SHOW CREATE TABLE collation_name_case

-- Test 81: statement (line 555)
SELECT s FROM nocase_strings WHERE s = ('bbb' COLLATE "en-us-u-ks-l""evel2")

-- Test 82: statement (line 558)
SELECT s FROM nocase_strings WHERE s = ('bbb' COLLATE "en-us-u-ks-l"evel2")

-- Test 83: statement (line 567)
INSERT INTO nocase_strings2 VALUES (1, 'Aaa' COLLATE "en-US-u-ks-level2"), (2, 'Bbb' COLLATE "en-US-u-ks-level2");

-- Test 84: query (line 570)
SELECT s FROM nocase_strings2 WHERE s = ('bbb' COLLATE "en-US-u-ks-level2")

-- Test 85: query (line 575)
SELECT s FROM nocase_strings2 WHERE s = ('bbb' COLLATE "en-us-u-ks-level2")

-- Test 86: query (line 580)
SELECT s FROM nocase_strings2 WHERE s = ('bbb' COLLATE "en_US_u_ks_level2")

-- Test 87: statement (line 588)
CREATE TABLE t65631(a "char", b "char" COLLATE en)

-- Test 88: statement (line 591)
INSERT INTO t65631 VALUES ('abc', 'abc' COLLATE en)

-- Test 89: query (line 594)
SELECT a, b FROM t65631

-- Test 90: query (line 630)
SELECT id FROM test_collate WHERE "string_field" = 'sTR_cOLLATE_1'

-- Test 91: statement (line 635)
INSERT INTO test_collate VALUES (2, 'Foo'), (3, 'Bar'), (4, 'Baz')

-- Test 92: query (line 638)
SELECT string_field FROM test_collate WHERE string_field < 'baz' ORDER BY id

-- Test 93: query (line 643)
SELECT string_field FROM test_collate WHERE string_field <= 'baz' ORDER BY id

-- Test 94: query (line 649)
SELECT string_field FROM test_collate WHERE string_field > 'baz' ORDER BY id

-- Test 95: query (line 655)
SELECT string_field FROM test_collate WHERE string_field >= 'baz' ORDER BY id

-- Test 96: query (line 666)
SELECT NULL COLLATE "en_US_u_ks_level2"

-- Test 97: query (line 676)
SELECT ARRAY['a'] COLLATE "en_US_u_ks_level2"

-- Test 98: query (line 686)
SELECT ARRAY[NULL] COLLATE "en_US_u_ks_level2"

-- Test 99: query (line 696)
SELECT ARRAY['a', NULL] COLLATE "en_US_u_ks_level2"

-- Test 100: query (line 701)
SELECT ARRAY['a' COLLATE "en_US_u_ks_level2"] COLLATE "en_US_u_ks_level2"

-- Test 101: query (line 721)
SELECT ARRAY['a' COLLATE "en_US_u_ks_level2", 'b' COLLATE "en_US_u_ks_level2", NULL] COLLATE "en_US_u_ks_level2"

-- Test 102: statement (line 731)
SET distsql = off

-- Test 103: query (line 734)
SELECT ARRAY[ARRAY['a' COLLATE "en_US_u_ks_level2"]]

-- Test 104: query (line 739)
SELECT ARRAY[ARRAY['a'] COLLATE "en_US_u_ks_level2"]

-- Test 105: query (line 744)
SELECT ARRAY[ARRAY['a']] COLLATE "en_US_u_ks_level2"

-- Test 106: statement (line 749)
RESET distsql

-- Test 107: query (line 752)
SELECT string_to_array('a/b/c', '/') COLLATE "en_US_u_ks_level2"

-- Test 108: statement (line 760)
INSERT INTO str_arr VALUES ('{d,e,f}', 'd'), ('{h,i,j}', 'h'), (NULL, NULL)

-- Test 109: query (line 763)
SELECT a COLLATE "en_US_u_ks_level2" FROM str_arr

-- Test 110: query (line 770)
SELECT b COLLATE "en_US_u_ks_level2" FROM str_arr ORDER BY 1

