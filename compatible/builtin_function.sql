-- PostgreSQL compatible tests from builtin_function
-- 695 tests

-- Allow the full file to run even when some CRDB-only functions are missing.
\set ON_ERROR_STOP 0

CREATE EXTENSION IF NOT EXISTS unaccent;
CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE OR REPLACE FUNCTION uuid_v4() RETURNS UUID
LANGUAGE SQL
AS $$
  SELECT gen_random_uuid();
$$;

CREATE OR REPLACE FUNCTION sha512(data TEXT) RETURNS BYTEA
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT digest(data, 'sha512');
$$;

CREATE OR REPLACE FUNCTION sha512(data1 TEXT, data2 TEXT) RETURNS BYTEA
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT digest(data1 || data2, 'sha512');
$$;

CREATE OR REPLACE FUNCTION sha512(data BYTEA) RETURNS BYTEA
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT digest(data, 'sha512');
$$;

CREATE OR REPLACE FUNCTION regexp_extract(input TEXT, pattern TEXT) RETURNS TEXT
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT (regexp_match(input, pattern))[1];
$$;

-- Test 1: statement (line 4)
CREATE TABLE foo (a int);

-- Test 2: statement (line 7)
INSERT INTO foo (a) VALUES (1);

-- Test 3: query (line 10)
SELECT foo.bar();

-- query error unknown function: pg_catalog.defaults()
\set ON_ERROR_STOP 0
SELECT pg_catalog.defaults();
\set ON_ERROR_STOP 0

-- query error unknown function: defaults
\set ON_ERROR_STOP 0
SELECT defaults();
\set ON_ERROR_STOP 0

-- query II colnames
SELECT length('roach7'), length('\x726f6163683737'::bytea);

-- Test 4: query (line 25)
SELECT length('Hello, 世界'), length('\x48656c6c6f2c20e4b896e7958c'::bytea),
       char_length('Hello, 世界'), char_length('\x48656c6c6f2c20e4b896e7958c'::bytea),
       character_length('Hello, 世界'), character_length('\x48656c6c6f2c20e4b896e7958c'::bytea);

-- Test 5: statement (line 32)
SELECT length(23);

-- Test 6: query (line 35)
SELECT octet_length('Hello'), octet_length('世界'), octet_length('\xe4b896e7958c'::bytea);

-- Test 7: query (line 40)
SELECT bit_length('Hello'), bit_length('世界'), bit_length('\xe4b896e7958c'::bytea);

-- Test 8: statement (line 45)
CREATE TABLE bit_count_test (a BIT(3), b varbit, c bytea);

-- Test 9: statement (line 48)
INSERT INTO bit_count_test VALUES (B'101', B'00', '\x10'), (B'100', B'101', '\x10A2');

-- Test 10: query (line 51)
SELECT a, b, encode(c, 'hex'), bit_count(a), bit_count(b), bit_count(c) FROM bit_count_test;

-- Test 11: query (line 57)
SELECT quote_ident('abc'), quote_ident('ab.c'), quote_ident('ab"c'), quote_ident('世界'),
       quote_ident('array'), -- reserved keyword
       quote_ident('family'), -- type/func name keyword
       quote_ident('bigint'), -- col name keyword
       quote_ident('alter'); -- unreserved keyword

-- Test 12: query (line 66)
SELECT quote_literal('abc'), quote_literal('ab''c'), quote_literal('ab"c'), quote_literal(e'ab\nc');

-- Test 13: query (line 80)
SELECT
 quote_literal('1d'::interval),	quote_nullable('1d'::interval),
 quote_literal('2018-06-11 12:13:14'::timestamp), quote_nullable('2018-06-11 12:13:14'::timestamp),
 quote_literal('2018-06-11'::date), quote_nullable('2018-06-11'::date);

-- Test 14: query (line 88)
SELECT
 quote_literal(null::int), quote_nullable(null::int),
 quote_literal(null::int) IS NULL, quote_nullable(null::int) IS NULL;

-- Test 15: query (line 97)
SELECT quote_literal('\x616263'::bytea), quote_nullable('\x616263'::bytea);

-- Test 16: statement (line 102)
SET bytea_output = 'escape';

-- Test 17: query (line 105)
SELECT quote_literal('\x616263'::bytea), quote_nullable('\x616263'::bytea);

-- Test 18: statement (line 110)
RESET bytea_output;

-- Test 19: query (line 113)
SELECT upper('roacH7');

-- Test 20: query (line 119)
SELECT unaccent(str) FROM ( VALUES
   ('no_special_CHARACTERS1!'),
   ('Żółć'),
   ('⃞h̀ＥＬＬＯ`̀́⃞'),
   ('Softhyphen­separator'),
   ('some ̂thing'),
   ('héllö wòrld')
) tbl(str);

-- Test 21: statement (line 136)
SELECT upper(2.2);

-- Test 22: query (line 139)
SELECT lower('RoacH7');

-- Test 23: statement (line 145)
SELECT lower(32);

-- Test 24: query (line 149)
SELECT random() * 0.0;

-- Test 25: statement (line 154)
SELECT setseed(0.1);

-- Test 26: query (line 158)
SELECT i, random() FROM ROWS FROM (generate_series(1, 5)) AS i ORDER by i;

-- Test 27: statement (line 167)
SELECT setseed(0.1);

-- Test 28: query (line 170)
SELECT i, random() FROM ROWS FROM (generate_series(1, 5)) AS i ORDER by i;

-- Test 29: statement (line 180)
SELECT setseed(0.1);

-- Test 30: query (line 183)
WITH cte(col) AS (SELECT random()) SELECT col, random() FROM cte;

-- Test 31: query (line 189)
SELECT concat() || 'empty';

-- Test 32: query (line 194)
SELECT concat('RoacH', NULL);

-- Test 33: statement (line 199)
CREATE TYPE concat_enum AS ENUM ('foo', 'bar', 'baz');

-- Test 34: query (line 202)
SELECT concat('foo'::concat_enum, ' ', 64.532, ' ', 'baz'::concat_enum, ' ', 42, ' ', 1 = 0, ' ', '{"foo": "bar"}'::json, ' ', '{1, 2, 3}'::int[]);

-- Test 35: query (line 210)
EXECUTE concat_stmt(':');

-- Test 36: statement (line 215)
SET use_pre_25_2_variadic_builtins = true;

-- Test 37: statement (line 218)
PREPARE concat_stmt2 AS SELECT concat("foo"."a", $1) FROM foo;

-- Test 38: statement (line 221)
EXECUTE concat_stmt2(':');

-- Test 39: statement (line 224)
RESET use_pre_25_2_variadic_builtins;

-- Test 40: statement (line 227)
PREPARE concat_stmt3 AS SELECT concat("foo"."a", $1) FROM foo;

-- Test 41: query (line 230)
SELECT substr('RoacH', 2, 3);

-- Test 42: query (line 235)
SELECT substring('RoacH', 2, 3);

-- Test 43: query (line 240)
SELECT substring('💩oacH', 2, 3);

-- Test 44: query (line 245)
SELECT substring('RoacH' from 2 for 3);

-- Test 45: query (line 250)
SELECT substring('RoacH' for 3 from 2);

-- Test 46: query (line 255)
SELECT substr('RoacH', 2);

-- Test 47: query (line 260)
SELECT substr('💩oacH', 2);

-- Test 48: query (line 265)
SELECT substring('RoacH' from 2);

-- Test 49: query (line 270)
SELECT substr('RoacH', -2);

-- Test 50: query (line 275)
SELECT substr('RoacH', -2, 4);

-- Test 51: query (line 280)
SELECT substr('12345', 2, 77);

-- Test 52: query (line 285)
SELECT substr('12345', -2, 77);

-- Test 53: statement (line 290)
SELECT substr('12345', 2, -1);

-- Test 54: query (line 298)
SELECT substring('12345' for 3);

-- Test 55: query (line 303)
SELECT substring('foobar' from 'o.b');

-- Test 56: query (line 308)
SELECT substring('f(oabaroob' from '\(o(.)b');

-- Test 57: query (line 313)
SELECT substring('f(oabaroob' from '+(o(.)'\x20666f7220'::bytea+');

-- Test 58: query (line 318)
SELECT substring('f(oabaroob' from '\(o(.)'\x20666f7220'::bytea+');

-- query error unknown signature: substring\(\)
\set ON_ERROR_STOP 0
SELECT substring();
\set ON_ERROR_STOP 0

-- Adding testcases for substring against bit array.

-- query TTT
SELECT substring(B'11110000', 0), substring(B'11110000', -1), substring(B'11110000', 5);

-- Test 59: query (line 331)
SELECT substring(B'11110000', 8), substring(B'11110000', 10), substring(B'', 0);

-- Test 60: query (line 336)
SELECT substring('11100011'::bit(8), 4), substring('11100011'::bit(6), 4), substring(B'', 0, 1);

-- Test 61: query (line 341)
SELECT substring(B'11110000', 0, 4), substring(B'11110000', -1, 4), substring(B'11110000', 5, 10);

-- Test 62: query (line 346)
SELECT substring(B'11110000', 8, 1), substring(B'11110000', 8, 0), substring(B'11110000', 10, 5);

-- Test 63: query (line 351)
SELECT substring('11100011'::bit(10), 4, 10), substring('11100011'::bit(8), 1, 8);

-- Test 64: query (line 356)
SELECT substring(B'10001000' FOR 4 FROM 0), substring(B'10001000' FROM 0 FOR 4), substring(B'10001000' FOR 4);

-- Test 65: query (line 361)
SELECT substring('11100011'::bit(10), 4, -1);

-- Adding testcases for substring against byte array.

-- query TT
SELECT substring('\x616263'::bytea, 0), substring('\x616263'::bytea, -1);

-- Test 66: query (line 371)
SELECT substring('\x616263'::bytea, 3), substring('\x616263'::bytea, 5);

-- Test 67: query (line 376)
SELECT substring('abc'::bytea, 0);

-- Test 68: query (line 381)
SELECT substring('\x616263'::bytea, 0, 4), substring('\x616263'::bytea, -1, 4);

-- Test 69: query (line 386)
SELECT substring('\x616263'::bytea, 3, 1), substring('\x616263'::bytea, 3, 0), substring('\x616263'::bytea, 4, 3);

-- Test 70: query (line 391)
SELECT substring('abc'::bytea, 0, 4);

-- Test 71: query (line 396)
SELECT substring('\x616263'::bytea FOR 3 FROM 1), substring('\x616263'::bytea FROM 1 FOR 3), substring('\x616263'::bytea FOR 3);

-- Test 72: query (line 401)
SELECT substring('11100011'::bytea, 4, -1);

-- query TTTTT
SELECT
  encode(substring(decode('ff0001', 'hex'), 1), 'hex'),
  encode(substring(decode('ff0001', 'hex'), 1, 1), 'hex'),
  encode(substring(decode('ff0001', 'hex'), 1, 7), 'hex'),
  encode(substring(decode('ff0001', 'hex'), 2), 'hex'),
  encode(substring(decode('ff0001', 'hex'), 4), 'hex');

-- Test 73: query (line 414)
SELECT
  encode(substring(decode('5c0001', 'hex'), 1), 'hex'),
  encode(substring(decode('aa5c0001', 'hex'), 1), 'hex'),
  encode(substring(decode('aa5c0001', 'hex'), 2), 'hex'),
  encode(substring(decode('aa5c1a1a1a1a0001', 'hex'), 2), 'hex'),
  encode(substring(decode('5c0001', 'hex'), 1, 1), 'hex'),
  encode(substring(decode('aa5c0001', 'hex'), 1, 2), 'hex'),
  encode(substring(decode('aa5c0001', 'hex'), 2, 2), 'hex'),
  encode(substring(decode('aa5c1a1a1a1a0001', 'hex'), 2, 2), 'hex'),
  encode(substring(decode('5c0001', 'hex'), 1), 'escape'),
  encode(substring(decode('aa5c0001', 'hex'), 2, 1), 'escape');

-- Test 74: query (line 437)
SELECT concat_ws(',', 'abcde', NULL);

-- Test 75: query (line 442)
SELECT concat_ws(',', 'abcde', '2');

-- Test 76: query (line 447)
SELECT concat_ws(',', 'abcde', 2, NULL, 22);

-- Test 77: query (line 452)
SELECT split_part('abc~@~def~@~ghi', '~@~', 2);

-- Test 78: query (line 457)
SELECT split_part('abc,def,ghi,jkl', ',', -2);

-- Test 79: statement (line 462)
SELECT split_part('abc,def,ghi,jkl', ',', 0);

-- Test 80: query (line 467)
SELECT split_part('joeuser@mydatabase', '', 1);

-- Test 81: query (line 472)
SELECT split_part('joeuser@mydatabase', '', -1);

-- Test 82: query (line 477)
SELECT split_part('joeuser@mydatabase', '?', 1);

-- Test 83: query (line 482)
SELECT split_part('joeuser@mydatabase', '?', -1);

-- Test 84: query (line 487)
SELECT split_part('joeuser@mydatabase', '', 2);

-- Test 85: query (line 492)
SELECT split_part('joeuser@mydatabase', '?', -2);

-- Test 86: query (line 498)
SELECT split_part('joeuser@mydatabase', '@', -9223372036854775808);

-- Test 87: query (line 504)
SELECT split_part('joeuser@mydatabase', '@', 9223372036854775807);

-- Test 88: query (line 509)
SELECT repeat('Pg', 4);

-- Test 89: query (line 514)
SELECT repeat('Pg', -1) || 'empty';

-- Test 90: statement (line 519)
SELECT repeat('s', 9223372036854775807);

-- Test 91: query (line 526)
SELECT ascii('x');

-- Test 92: query (line 531)
select ascii('禅');

-- Test 93: query (line 536)
select ascii('');

-- Test 94: query (line 541)
select chr(122);

-- Test 95: query (line 546)
select chr(ascii('Z'));

-- Test 96: query (line 551)
select chr(31109);

-- Test 97: query (line 556)
SELECT chr(-1);

-- query T
SELECT md5('abc');

-- Test 98: query (line 564)
SELECT sha1('abc');

-- Test 99: query (line 569)
SELECT sha224('abc');

-- Test 100: query (line 574)
SELECT sha256('abc');

-- Test 101: query (line 579)
SELECT sha384('abc');

-- Test 102: query (line 584)
SELECT fnv32('abc'), fnv32a('abc'), fnv64('abc'), fnv64a('abc');

-- Test 103: query (line 589)
SELECT crc32ieee('abc'), crc32c('abc');

-- Test 104: query (line 600)
SELECT md5('');

-- Test 105: query (line 640)
SELECT to_hex(2147483647);

-- Test 106: query (line 645)
SELECT strpos('high', 'a');

-- Test 107: query (line 650)
SELECT strpos('high', 'ig');

-- Test 108: query (line 655)
SELECT strpos('💩high', 'ig');

-- Test 109: query (line 660)
SELECT strpos(B'00001111', B'1111'), strpos(B'', B''), strpos(B'0000111', B'1111');

-- Test 110: query (line 665)
SELECT strpos('000001'::varbit, '1'::varbit);

-- Test 111: query (line 670)
SELECT position(B'100' in B'100101');

-- Test 112: query (line 675)
SELECT strpos('\x616561616263'::bytea, '\x616263'::bytea), strpos('\x'::bytea, '\x'::bytea), strpos('\x747474616163'::bytea, '\x616263'::bytea);

-- Test 113: query (line 680)
SELECT position('\x616263'::bytea in 'abc'::bytea);

-- Test 114: query (line 685)
SELECT position('ig' in 'high');

-- Test 115: query (line 690)
SELECT position('a' in 'high');

-- Test 116: query (line 695)
SELECT position();

-- query T
SELECT overlay('123456789' placing 'xxxx' from 3);

-- Test 117: query (line 703)
SELECT overlay('123456789' placing 'xxxx' from 3 for 2);

-- Test 118: query (line 708)
SELECT overlay('123456789' placing 'xxxx' from 3 for 6);

-- Test 119: query (line 713)
SELECT overlay('123456789' placing 'xxxx' from 15 for 6);

-- Test 120: query (line 718)
SELECT overlay('123456789' placing 'xxxx' from 3 for 10);

-- Test 121: query (line 723)
SELECT overlay('123456789' placing 'xxxx' from 3 for -1);

-- Test 122: query (line 728)
SELECT overlay('123456789' placing 'xxxx' from 3 for -8);

-- Test 123: query (line 733)
SELECT overlay('💩123456789' placing 'xxxxÂ' from 3 for 3);

-- Test 124: query (line 738)
SELECT overlay('123456789' placing 'xxxx' from -1 for 6);

-- query T
SELECT btrim('xyxtrimyyx', 'xy');

-- Test 125: query (line 746)
SELECT trim('xy' from 'xyxtrimyyx');

-- Test 126: query (line 751)
SELECT trim(both 'xy' from 'xyxtrimyyx');

-- Test 127: query (line 756)
SELECT 'a' || btrim('    postgres    ') || 'b';

-- Test 128: query (line 761)
SELECT ltrim('zzzytrimxyz', 'xyz');

-- Test 129: query (line 766)
SELECT trim(leading 'xyz' from 'zzzytrimxyz');

-- Test 130: query (line 771)
SELECT ltrim('   trimxyz');

-- Test 131: query (line 776)
SELECT trim(leading '   trimxyz');

-- Test 132: query (line 781)
SELECT trim(leading from '   trimxyz');

-- Test 133: query (line 787)
SELECT rtrim('xyzzzzytrimxyz', 'xyz');

-- Test 134: query (line 792)
SELECT trim(trailing 'xyz' from 'xyzzzzytrimxyz');

-- Test 135: query (line 797)
SELECT 'a' || rtrim(' zzzytrimxyz   ');

-- Test 136: query (line 802)
SELECT reverse('abcde');

-- Test 137: query (line 807)
SELECT reverse('世界');

-- Test 138: query (line 812)
SELECT replace('abcdefabcdef', 'cd', 'XX');

-- Test 139: query (line 817)
SELECT replace(initcap('hi THOMAS'), ' ', '');

-- Test 140: query (line 822)
SELECT initcap('THOMAS');

-- Test 141: query (line 827)
SELECT left('💩abcde'::BYTEA, 2);

-- Test 142: query (line 832)
SELECT right('abcde💩'::BYTEA, 2);

-- Test 143: query (line 837)
SELECT left('💩abcde', 2);

-- Test 144: query (line 842)
SELECT right('abcde💩', 2);

-- Test 145: query (line 847)
SELECT abs(-1.2::float), abs(1.2::float), abs(-0.0::float), abs(0), abs(1), abs(-1.2121::decimal);

-- Test 146: query (line 852)
SELECT abs(NULL);

-- Test 147: query (line 857)
SELECT abs(-9223372036854775808);

-- query I
SELECT abs(-9223372036854775807);

-- Test 148: query (line 865)
SELECT abs(sin(pi())) < 1e-12;

-- Test 149: query (line 872)
SELECT acos(-0.5), round(acos(0.5), 15);

-- Test 150: query (line 877)
SELECT cot(-0.5), cot(0.5);

-- Test 151: query (line 882)
SELECT asin(-0.5), asin(0.5), asin(1.5);

-- Test 152: query (line 887)
SELECT atan(-0.5), atan(0.5);

-- Test 153: query (line 892)
SELECT atan2(-10.0, 5.0), atan2(10.0, 5.0);

-- Test 154: query (line 897)
SELECT cbrt(-1.0::float), round(cbrt(27.0::float), 15), cbrt(19.3::decimal);

-- Test 155: query (line 903)
SELECT ceil(-0.5::float), ceil(0.5::float), ceiling(0.5::float), ceil(0.1::decimal), ceiling (-0.9::decimal);

-- Test 156: query (line 908)
SELECT cos(-0.5), cos(0.5);

-- Test 157: query (line 913)
SELECT sin(-1.0), sin(0.0), sin(1.0);

-- Test 158: query (line 918)
SELECT degrees(-0.5), degrees(0.5);

-- Test 159: statement (line 925)
SET extra_float_digits = 3;

-- Test 160: query (line 928)
SELECT acos(-0.5), round(acos(0.5), 15);

-- Test 161: query (line 933)
SELECT cot(-0.5), cot(0.5);

-- Test 162: query (line 938)
SELECT asin(-0.5), asin(0.5), asin(1.5);

-- Test 163: query (line 943)
SELECT atan(-0.5), atan(0.5);

-- Test 164: query (line 948)
SELECT atan2(-10.0, 5.0), atan2(10.0, 5.0);

-- Test 165: query (line 953)
SELECT cbrt(-1.0::float), round(cbrt(27.0::float), 15), cbrt(19.3::decimal);

-- Test 166: query (line 958)
SELECT ceil(-0.5::float), ceil(0.5::float), ceiling(0.5::float), ceil(0.1::decimal), ceiling(-0.9::decimal);

-- Test 167: query (line 963)
SELECT cos(-0.5), cos(0.5);

-- Test 168: query (line 968)
SELECT sin(-1.0), sin(0.0), sin(1.0);

-- Test 169: query (line 973)
SELECT degrees(-0.5), degrees(0.5);

-- Test 170: statement (line 978)
SET extra_float_digits = 0;

-- Test 171: query (line 983)
SELECT div(-1::int, 2::int), div(1::int, 2::int), div(9::int, 4::int), div(-9::int, 4::int);

-- Test 172: query (line 988)
SELECT div(-1.0::float, 2.0), div(1.0::float, 2.0), div(9.0::float, 4.0), div(-9.0::float, 4.0), div(1.0::float, 0.0), div(1111.0::decimal, 9.44);

-- Test 173: query (line 993)
SELECT div(1.0::decimal, 0.0::decimal);

-- query error division by zero
\set ON_ERROR_STOP 0
SELECT div(1::int, 0::int);
\set ON_ERROR_STOP 0

-- math.Exp(1.0) returns different results on amd64 vs arm64.
-- Round to make this test consistent across archs.
-- See https://github.com/golang/go/issues/20319.
-- query RRR
SELECT exp(-1.0::float), round(exp(1.0::float), 13), exp(2.0::decimal);

-- Test 174: query (line 1007)
SELECT exp(1e2000::decimal);

-- query RRR
SELECT floor(-1.5::float), floor(1.5::float), floor(9.123456789::decimal);

-- Test 175: query (line 1015)
SELECT 1::FLOAT IS NAN, 1::FLOAT IS NOT NAN, isnan(1::FLOAT), 'NaN'::FLOAT IS NAN, 'NaN'::FLOAT IS NOT NAN, isnan('NaN'::FLOAT);

-- Test 176: query (line 1020)
SELECT ln(-2.0::float), ln(2.0::float), ln(2.5::decimal);

-- Test 177: query (line 1025)
SELECT ln(-100.000::decimal);

-- query error cannot take logarithm of zero
\set ON_ERROR_STOP 0
SELECT ln(0::decimal);
\set ON_ERROR_STOP 0

-- query RR
SELECT log(10.0::float), log(100.000::decimal);

-- Test 178: query (line 1036)
SELECT log(2.0::float, 4.0::float);

-- Test 179: query (line 1041)
SELECT log(2.0::decimal, 4.0::decimal);

-- Test 180: query (line 1046)
SELECT log(2.0::float, -10.0::float);

-- query error cannot take logarithm of zero
\set ON_ERROR_STOP 0
SELECT log(2.0::float, 0.0::float);
\set ON_ERROR_STOP 0

-- query error cannot take logarithm of a negative number
\set ON_ERROR_STOP 0
SELECT log(2.0::decimal, -10.0::decimal);
\set ON_ERROR_STOP 0

-- query error cannot take logarithm of zero
\set ON_ERROR_STOP 0
SELECT log(2.0::decimal, 0.0::decimal);
\set ON_ERROR_STOP 0

-- query error cannot take logarithm of a negative number
\set ON_ERROR_STOP 0
SELECT log(-100.000::decimal);
\set ON_ERROR_STOP 0

-- query error cannot take logarithm of zero
\set ON_ERROR_STOP 0
SELECT log(0::decimal);
\set ON_ERROR_STOP 0

-- query RRIR
SELECT mod(5.0::float, 2.0), mod(1.0::float, 0.0), mod(5, 2), mod(19.3::decimal, 2);

-- Test 181: query (line 1072)
SELECT mod(5, 0);

-- query error division by zero
\set ON_ERROR_STOP 0
SELECT mod(5::decimal, 0::decimal);
\set ON_ERROR_STOP 0

-- query II
SELECT mod(-100, -8), mod(-100, 8);

-- Test 182: query (line 1083)
SELECT mod(-9223372036854775808, 3);

-- Test 183: query (line 1088)
SELECT mod(-9223372036854775808, -1);

-- Test 184: query (line 1093)
SELECT mod(9223372036854775807, -1);

-- Test 185: query (line 1098)
SELECT mod(9223372036854775807, -2);

-- Test 186: query (line 1103)
SELECT mod(9223372036854775807, 1);

-- Test 187: query (line 1108)
SELECT mod(9223372036854775807, 2);

-- Test 188: query (line 1113)
SELECT mod(9223372036854775807, 4);

-- Test 189: query (line 1120)
SELECT div(9.0::float, 2.0) * 2.0 + mod(9.0::float, 2.0);

-- Test 190: query (line 1125)
SELECT div(9.0::float, -2.0) * -2.0 + mod(9.0::float, -2.0);

-- Test 191: query (line 1130)
SELECT div(-9.0::float, 2.0) * 2.0 + mod(-9.0::float, 2.0);

-- Test 192: query (line 1135)
SELECT div(-9.0::float, -2.0) * -2.0 + mod(-9.0::float, -2.0);

-- Test 193: query (line 1140)
SELECT pi();

-- Test 194: query (line 1145)
SELECT pow(-2::int, 3::int), pow(2::int, 3::int);

-- Test 195: statement (line 1150)
SELECT pow(2::int, -3::int);

-- Test 196: query (line 1153)
SELECT pow(0::int, 3::int), pow(3::int, 0::int), pow(-3::int, 0::int);

-- Test 197: statement (line 1158)
SELECT pow(0::int, -3::int);

-- Test 198: query (line 1161)
SELECT pow(0::int, 0::int);

-- Test 199: query (line 1166)
SELECT pow(-3.0::float, 2.0), power(3.0::float, 2.0), pow(5.0::decimal, 2.0);

-- Test 200: query (line 1171)
SELECT pow(CAST (pi() AS DECIMAL), DECIMAL '2.0');

-- Test 201: statement (line 1176)
SELECT power(0::decimal, -1);

-- Test 202: statement (line 1179)
SELECT power(-1, -.1);

-- Test 203: query (line 1182)
SELECT radians(-45.0), radians(45.0);

-- Test 204: query (line 1187)
SELECT round(123.456::float, -2438602134409251682);

-- Test 205: query (line 1192)
SELECT round(4.2::float, 0), round(4.2::float, 10), round(4.22222222::decimal, 3);

-- Test 206: query (line 1197)
SELECT round(1e-308::float, 324);

-- Test 207: query (line 1203)
SELECT round(-2.5::float, 0), round(-1.5::float, 0), round(1.5::float, 0), round(2.5::float, 0);

-- Test 208: query (line 1208)
SELECT round(-2.5::float), round(-1.5::float), round(-0.0::float), round(0.0::float), round(1.5::float), round(2.5::float);

-- Test 209: query (line 1214)
SELECT round(1.390671161567e-309::float), round(0.49999999999999994::float), round(0.5000000000000001::float), round(2251799813685249.5::float), round(2251799813685250.5::float), round(4503599627370495.5::float), round(4503599627370497::float);

-- Test 210: query (line 1222)
SELECT round(-2.5::decimal, 0), round(-1.5::decimal, 0), round(1.5::decimal, 0), round(2.5::decimal, 0);

-- Test 211: query (line 1227)
SELECT round(-2.5::decimal, 3), round(-1.5::decimal, 3), round(0.0::decimal, 3), round(1.5::decimal, 3), round(2.5::decimal, 3);

-- Test 212: query (line 1232)
SELECT round(-2.5::decimal), round(-1.5::decimal), round(0.0::decimal), round(1.5::decimal), round(2.5::decimal);

-- Test 213: statement (line 1242)
SET extra_float_digits = 3;

-- Test 214: query (line 1245)
SELECT round(-2.123456789, 5), round(2.123456789, 5), round(2.12345678901234567890, 14);

-- Test 215: query (line 1250)
SELECT round(-1.7976931348623157e+308::float, 1), round(1.7976931348623157e+308::float, 1);

-- Test 216: query (line 1255)
SELECT round(-1.7976931348623157e+308::float, -303), round(1.7976931348623157e+308::float, -303);

-- Test 217: query (line 1260)
SELECT round(-1.23456789e+308::float, -308), round(1.23456789e+308::float, -308);

-- Test 218: query (line 1265)
SELECT 1.234567890123456789::float, round(1.234567890123456789::float, 15), round(1.234567890123456789::float, 16), round(1.234567890123456789::float, 17);

-- Test 219: statement (line 1270)
SET extra_float_digits = 0;

-- Test 220: statement (line 1275)
SET extra_float_digits = -6;

-- Test 221: query (line 1278)
SELECT round(-2.123456789, 5), round(2.123456789, 5), round(2.12345678901234567890, 14);

-- Test 222: query (line 1283)
SELECT round(-1.7976931348623157e+308::float, 1), round(1.7976931348623157e+308::float, 1);

-- Test 223: query (line 1288)
SELECT round(-1.7976931348623157e+308::float, -303), round(1.7976931348623157e+308::float, -303);

-- Test 224: query (line 1293)
SELECT round(-1.23456789e+308::float, -308), round(1.23456789e+308::float, -308);

-- Test 225: query (line 1298)
SELECT 1.234567890123456789::float, round(1.234567890123456789::float, 15), round(1.234567890123456789::float, 16), round(1.234567890123456789::float, 17);

-- Test 226: statement (line 1303)
SET extra_float_digits = 0;

-- Test 227: query (line 1308)
SELECT round(-1.7976931348623157e-308::float, 1), round(1.7976931348623157e-308::float, 1);

-- Test 228: query (line 1314)
SELECT round(123.456::float, -1), round(123.456::float, -2), round(123.456::float, -3);

-- Test 229: query (line 1319)
SELECT round(123.456::decimal, -1), round(123.456::decimal, -2), round(123.456::decimal, -3), round(123.456::decimal, -200), round(-0.1::decimal);

-- Test 230: query (line 1324)
SELECT round('nan'::decimal), round('nan'::decimal, 1), round('nan'::float), round('nan'::float, 1);

-- Test 231: query (line 1330)
SELECT round('inf'::float), round('inf'::float, 1), round('-inf'::float), round('-inf'::float, 1);

-- Test 232: query (line 1338)
SELECT round('inf'::decimal);

-- Test 233: query (line 1343)
SELECT round(1::decimal, 3000);

-- Test 234: query (line 1350)
SELECT sign(-2), sign(0), sign(2);

-- Test 235: query (line 1355)
SELECT sign(-2.0), sign(-0.0), sign(0.0), sign(2.0);

-- Test 236: query (line 1360)
SELECT sqrt(4.0::float), sqrt(9.0::decimal);

-- Test 237: query (line 1365)
SELECT sqrt(-1.0::float);

-- query error cannot take square root of a negative number
\set ON_ERROR_STOP 0
SELECT sqrt(-1.0::decimal);
\set ON_ERROR_STOP 0

-- query RRR
SELECT round(tan(-5.0), 14), tan(0.0), round(tan(5.0), 14);

-- Test 238: query (line 1376)
SELECT trunc(-0.0), trunc(0.0), trunc(1.9), trunc(19.5678::decimal);

-- Test 239: query (line 1381)
WITH v(x) AS
  (VALUES('0'::numeric),('1'::numeric),('-1'::numeric),('4.2'::numeric),
    ('-7.777'::numeric),('9127.777'::numeric),('inf'::numeric),('-inf'::numeric),('nan'::numeric))
SELECT x, trunc(x), trunc(x,1), trunc(x,2), trunc(x,0), trunc(x,-1), trunc(x,-2)
FROM v;

-- Test 240: query (line 1398)
SELECT translate('Techonthenet.com', 'e.to', '456');

-- Test 241: query (line 1403)
SELECT translate('12345', '143', 'ax');

-- Test 242: query (line 1408)
SELECT translate('12345', 'abc', 'ax');

-- Test 243: query (line 1413)
SELECT translate('a‰ÒÁ', 'aÒ', '∏p');

-- Test 244: query (line 1418)
SELECT regexp_extract('foobar', 'o.b');

-- Test 245: query (line 1423)
SELECT regexp_extract('foobar', 'o(.)b');

-- Test 246: query (line 1428)
SELECT regexp_extract('foobar', '(o(.)b)');

-- Test 247: query (line 1433)
SELECT regexp_extract('foabaroob', 'o(.)b');

-- Test 248: query (line 1438)
SELECT regexp_extract('foobar', 'o.x');

-- Test 249: query (line 1443)
SELECT regexp_replace('foobarbaz', 'b..', 'X');

-- Test 250: query (line 1448)
SELECT regexp_replace('foobarbaz', 'b..', 'X', 'g');

-- Test 251: query (line 1453)
SELECT regexp_replace('foobarbaz', 'b(..)', E'X\\1Y', 'g');

-- Test 252: query (line 1458)
SELECT regexp_replace('foobarbaz', 'b(.)(.)', E'X\\2\\1\\3Y', 'g');

-- Test 253: query (line 1463)
SELECT regexp_replace(E'fooBa\nrbaz', 'b(..)', E'X\\&Y', 'gi');

-- Test 254: query (line 1469)
SELECT regexp_replace(E'fooBa\nrbaz', 'b(..)', E'X\\&Y', 'gmi');

-- Test 255: query (line 1475)
SELECT regexp_replace(E'fooBar\nbaz', 'b(..)$', E'X\\&Y', 'gpi');

-- Test 256: query (line 1481)
SELECT regexp_replace(E'fooBar\nbaz', 'b(..)$', E'X\\&Y', 'gwi');

-- Test 257: query (line 1487)
SELECT regexp_replace('foobarbaz', 'nope', 'NO');

-- Test 258: query (line 1492)
SELECT regexp_replace(E'fooBar\nbaz', 'b(..)$', E'X\\&Y', 'z');

-- query T
SELECT regexp_replace(E'Foo\nFoo', '^(foo)', 'BAR', 'i');

-- Test 259: query (line 1501)
SELECT regexp_replace(e'DOGGIE\ndog \nDOG', '^d.+', 'CAT', 's');

-- Test 260: query (line 1508)
SELECT regexp_replace(e'DOGGIE\ndog \nDOG', '^d.+', 'CAT', 'n');

-- Test 261: query (line 1515)
SELECT regexp_replace(e'DOGGIE\ndog \nDOG', '^D.+', 'CAT', 'p');

-- Test 262: query (line 1522)
SELECT regexp_replace(e'DOGGIE\ndog \nDOG', '^d.+', 'CAT', 'w');

-- Test 263: query (line 1528)
SELECT regexp_replace('abc', 'b', e'\n', 'w');

-- Test 264: query (line 1534)
SELECT regexp_replace('abc\', 'b', 'a', 'w');

-- Test 265: query (line 1539)
SELECT regexp_replace('abc', 'c', 'a\', 'w');

-- Test 266: query (line 1545)
SELECT regexp_replace('ReRe','R(e)','1\\1','g');

-- Test 267: query (line 1551)
SELECT regexp_replace('TIMESTAMP(6)', '.*(\((\d+)\))?.*', '\2');

-- Test 268: query (line 1556)
SELECT regexp_replace('TIMESTAMP(6)', '.*(\((\d+)\)).*', '\2');

-- Test 269: query (line 1561)
SELECT regexp_replace('TIMESTAMP(6)', '.*(\((\d+)\)?).*', '\2');

-- Test 270: query (line 1566)
SELECT unique_rowid() < unique_rowid();

-- Test 271: query (line 1571)
SELECT uuid_v4() != uuid_v4(), length(uuid_v4());

-- Test 272: query (line 1576)
SELECT greatest();

-- query error at or near.*: syntax error
\set ON_ERROR_STOP 0
SELECT least();
\set ON_ERROR_STOP 0

-- query I
SELECT greatest(4, 5, 7, 1, 2);

-- Test 273: query (line 1587)
SELECT least(4, 5, 7, 1, 2);

-- Test 274: query (line 1592)
SELECT greatest(4, NULL, 7, 1, 2);

-- Test 275: query (line 1597)
SELECT greatest(NULL, NULL, 7, NULL, 2);

-- Test 276: query (line 1602)
SELECT greatest(NULL, NULL, NULL, NULL, 2);

-- Test 277: query (line 1607)
SELECT greatest(2, NULL, NULL, NULL, NULL);

-- Test 278: query (line 1612)
SELECT least(4, NULL, 7, 1, 2);

-- Test 279: query (line 1617)
SELECT greatest(NULL, NULL, NULL);

-- Test 280: query (line 1622)
SELECT least(NULL, NULL, NULL);

-- Test 281: query (line 1627)
SELECT greatest(2, '4');

-- Test 282: query (line 1632)
SELECT least(2, '4');

-- Test 283: query (line 1637)
SELECT greatest('foo', 'bar', 'foobar');

-- Test 284: query (line 1642)
SELECT least('foo', 'bar', 'foobar');

-- Test 285: query (line 1647)
SELECT greatest(1, 1.2);

-- Test 286: query (line 1653)
SELECT greatest(NULL, a, 5, NULL) FROM foo;

-- Test 287: query (line 1658)
SELECT greatest(NULL, NULL, NULL, a, -1) FROM foo;

-- Test 288: query (line 1663)
SELECT least(NULL, a, 5, NULL) FROM foo;

-- Test 289: query (line 1668)
SELECT least(NULL, NULL, NULL, a, -1) FROM foo;

-- Test 290: query (line 1675)
select 1 = 1.0::float, 1.0::float = 1, 1 = 2.0::float, 2.0::float = 1;

-- Test 291: query (line 1680)
select 1 < 2.0::float, 1.0::float < 2, 2.0::float < 1, 2 < 1.0::float;

-- Test 292: query (line 1685)
select 1 <= 1.0::float, 1.0::float <= 1, 2.0::float <= 1, 2 <= 1.0::float;

-- Test 293: query (line 1690)
select 2 > 1.0::float, 2.0::float > 1, 1 > 2.0::float, 1.0::float > 2;

-- Test 294: query (line 1695)
select 1 >= 1.0::float, 1.0::float >= 1, 1.0::float >= 2, 1 >= 2.0::float;

-- Test 295: query (line 1702)
select 1 = 1.0::decimal, 1.0::decimal = 1, 1 = 2.0::decimal, 2.0::decimal = 1;

-- Test 296: query (line 1707)
select 1 < 2.0::decimal, 1.0::decimal < 2, 2.0::decimal < 1, 2 < 1.0::decimal;

-- Test 297: query (line 1712)
select 1 <= 1.0::decimal, 1.0::decimal <= 1, 2.0::decimal <= 1, 2 <= 1.0::decimal;

-- Test 298: query (line 1717)
select 2 > 1.0::decimal, 2.0::decimal > 1, 1 > 2.0::decimal, 1.0::decimal > 2;

-- Test 299: query (line 1722)
select 1 >= 1.0::decimal, 1.0::decimal >= 1, 1.0::decimal >= 2, 1 >= 2.0::decimal;

-- Test 300: query (line 1729)
select 1::decimal = 1.0, 1.0 = 1::decimal, 1::decimal = 2.0, 2.0 = 1::decimal;

-- Test 301: query (line 1734)
select 1::decimal < 2.0, 1.0 < 2::decimal, 2.0 < 1::decimal, 2::decimal < 1.0;

-- Test 302: query (line 1739)
select 1::decimal <= 1.0, 1.0 <= 1::decimal, 2.0 <= 1::decimal, 2::decimal <= 1.0;

-- Test 303: query (line 1744)
select 2::decimal > 1.0, 2.0 > 1::decimal, 1::decimal > 2.0, 1.0 > 2::decimal;

-- Test 304: query (line 1749)
select 1::decimal >= 1.0, 1.0 >= 1::decimal, 1.0 >= 2::decimal, 1::decimal >= 2.0;

-- Test 305: query (line 1754)
SELECT strpos(version(), 'CockroachDB');

-- Test 306: query (line 1789)
SELECT current_schemas(false);

-- Test 307: query (line 1796)
SELECT current_schemas(x) FROM (VALUES (true), (false)) AS t(x);

-- Test 308: statement (line 1802)
SET search_path=test,pg_catalog;

-- Test 309: query (line 1805)
SELECT current_schemas(true);

-- Test 310: query (line 1810)
SELECT current_schemas(false);

-- Test 311: statement (line 1815)
RESET search_path;

-- Test 312: query (line 1818)
SELECT current_schemas();

-- query T
SELECT current_schemas(NULL::bool);

-- Test 313: query (line 1826)
SELECT 'public' = ANY (current_schemas(true));

-- Test 314: query (line 1831)
SELECT 'not test' = ANY (current_schemas(true));

-- Test 315: query (line 1836)
SELECT pg_catalog.pg_table_is_visible('foo'::regclass);

-- Test 316: statement (line 1841)
SET search_path = pg_catalog;

-- Test 317: query (line 1844)
SELECT pg_catalog.pg_table_is_visible((SELECT oid FROM pg_class WHERE relname='foo'));

-- Test 318: statement (line 1849)
SET SEARCH_PATH = public, pg_catalog;

-- Test 319: query (line 1852)
SELECT pg_catalog.pg_table_is_visible((SELECT oid FROM pg_class WHERE relname='foo'));

-- Test 320: statement (line 1857)
RESET search_path;

-- Test 321: query (line 1860)
SELECT current_schema();

-- Test 322: query (line 1865)
SELECT pg_catalog.pg_function_is_visible((select 'pg_table_is_visible'::regproc));

-- Test 323: query (line 1870)
SELECT pg_catalog.pg_function_is_visible(0);

-- Test 324: query (line 1878)
SELECT COLLATION FOR ('foo');

-- Test 325: query (line 1883)
SELECT COLLATION FOR ('foo' COLLATE "de_DE");

-- Test 326: statement (line 1888)
SELECT COLLATION FOR (1);

-- Test 327: query (line 1891)
SELECT pg_collation_for ('foo');

-- Test 328: query (line 1896)
SELECT pg_collation_for ('foo' COLLATE "de_DE");

-- Test 329: statement (line 1901)
SELECT pg_collation_for(1);

-- Test 330: query (line 1904)
SELECT array_length(ARRAY['a', 'b'], 1);

-- Test 331: query (line 1909)
SELECT array_length(ARRAY['a'], 1);

-- Test 332: query (line 1914)
SELECT array_length(ARRAY['a'], 0);

-- Test 333: query (line 1919)
SELECT array_length(ARRAY['a'], 2);

-- Test 334: query (line 1924)
SELECT cardinality(ARRAY['a', 'b']);

-- Test 335: query (line 1929)
SELECT cardinality(ARRAY[]::int[]);

-- Test 336: query (line 1934)
SELECT cardinality(NULL::int[]);

-- Test 337: query (line 1939)
SELECT array_lower(ARRAY['a', 'b'], 1);

-- Test 338: query (line 1944)
SELECT array_lower(ARRAY['a'], 1);

-- Test 339: query (line 1949)
SELECT array_lower(ARRAY['a'], 0);

-- Test 340: query (line 1954)
SELECT array_lower(ARRAY['a'], 2);

-- Test 341: query (line 1959)
SELECT array_upper(ARRAY['a', 'b'], 1);

-- Test 342: query (line 1964)
SELECT array_upper(ARRAY['a'], 1);

-- Test 343: query (line 1969)
SELECT array_upper(ARRAY['a'], 0);

-- Test 344: query (line 1974)
SELECT array_upper(ARRAY['a'], 2);

-- Test 345: query (line 1979)
SELECT array_length(ARRAY[]::int[], 1);

-- Test 346: query (line 1984)
SELECT array_lower(ARRAY[]::int[], 1);

-- Test 347: query (line 1989)
SELECT array_upper(ARRAY[]::int[], 1);

-- Test 348: query (line 1994)
SELECT array_length(ARRAY[ARRAY[1, 2]], 2);

-- Test 349: query (line 1999)
SELECT array_lower(ARRAY[ARRAY[1, 2]], 2);

-- Test 350: query (line 2004)
SELECT array_upper(ARRAY[ARRAY[1, 2]], 2);

-- Test 351: query (line 2009)
SELECT encode('\xa7', 'hex');

-- Test 352: query (line 2014)
SELECT encode('abc', 'hex'), decode('616263', 'hex');

-- Test 353: query (line 2019)
SELECT encode(e'123\000456', 'escape');

-- Test 354: query (line 2029)
SELECT encode('abc', 'base64'), decode('YWJj', 'base64');

-- Test 355: query (line 2044)
SELECT decode('invalid', 'base64');

-- query error only 'hex', 'escape', and 'base64' formats are supported for encode\(\)
\set ON_ERROR_STOP 0
SELECT encode('abc', 'fake');
\set ON_ERROR_STOP 0

-- query error only 'hex', 'escape', and 'base64' formats are supported for decode\(\)
\set ON_ERROR_STOP 0
SELECT decode('abc', 'fake');
\set ON_ERROR_STOP 0

-- query T
SELECT from_ip('\x00000000000000000000ffff01020304'::bytea);

-- Test 356: query (line 2058)
SELECT from_ip(to_ip('1.2.3.4'));

-- Test 357: query (line 2064)
select from_ip(to_ip('2001:0db8:85a3:0000:0000:8a2e:0370:7334'));

-- Test 358: query (line 2069)
SELECT to_ip();

-- query error pq: zero length IP
\set ON_ERROR_STOP 0
SELECT from_ip('\x'::bytea);
\set ON_ERROR_STOP 0

-- query error pq: invalid IP format: ''
\set ON_ERROR_STOP 0
SELECT to_ip('');
\set ON_ERROR_STOP 0

-- query error pq: invalid IP format: 'asdf'
\set ON_ERROR_STOP 0
select to_ip('asdf');
\set ON_ERROR_STOP 0

-- query R
select ln(4.0786335175292462e+34::decimal);

-- Test 359: query (line 2086)
SELECT length(gen_random_ulid()::BYTEA), gen_random_ulid() = gen_random_ulid();

-- Test 360: query (line 2091)
SELECT uuid_to_ulid('0178951c-b665-30a7-19a2-a18999834858'),
       ulid_to_uuid('01F2AHSDK562KHK8N1H6CR6J2R'),
       ulid_to_uuid(uuid_to_ulid('0178951c-b665-30a7-19a2-a18999834858')),
       uuid_to_ulid(ulid_to_uuid('01F2AHSDK562KHK8N1H6CR6J2R'));

-- Test 361: statement (line 2103)
SELECT pg_sleep(0.001);

-- let $ulid2
SELECT gen_random_ulid();

-- Test 362: query (line 2109)
SELECT '$ulid1' < '$ulid2',
       '$ulid1' > '$ulid2',
       uuid_to_ulid('$ulid1') < uuid_to_ulid('$ulid2'),
       uuid_to_ulid('$ulid1') > uuid_to_ulid('$ulid2');

-- Test 363: query (line 2117)
SELECT to_uuid('63616665-6630-3064-6465-616462656566'),
       to_uuid('{63616665-6630-3064-6465-616462656566}'),
       to_uuid('urn:uuid:63616665-6630-3064-6465-616462656566'),
       from_uuid('\x63616665663030646465616462656566'::bytea),
       to_uuid(from_uuid('\x63616665663030646465616462656566'::bytea)),
       from_uuid(to_uuid('63616665-6630-3064-6465-616462656566'));

-- Test 364: query (line 2132)
SELECT to_uuid('63616665-6630-3064-6465');

-- query error uuid: incorrect UUID format
\set ON_ERROR_STOP 0
SELECT to_uuid('63616665-6630-3064-6465-616462656566-123');
\set ON_ERROR_STOP 0

-- query error uuid: incorrect UUID format
\set ON_ERROR_STOP 0
SELECT to_uuid('6361666512-6630-3064-6465-616462656566');
\set ON_ERROR_STOP 0

-- query error uuid: UUID must be exactly 16 bytes long, got 4 bytes
\set ON_ERROR_STOP 0
SELECT from_uuid('\x66303064'::bytea);
\set ON_ERROR_STOP 0

-- query T
SELECT pg_catalog.pg_typeof(sign(1::decimal));

-- Test 365: query (line 2261)
VALUES (format_type('anyelement'::regtype, NULL)),
       (format_type('bool'::regtype, NULL)),
       (format_type('bytea'::regtype, NULL)),
       (format_type('date'::regtype, NULL)),
       (format_type('numeric'::regtype, NULL)),
       (format_type('interval'::regtype, NULL)),
       (format_type('timestamp'::regtype, NULL)),
       (format_type('timestamptz'::regtype, NULL)),
       (format_type('record'::regtype, NULL));

-- Test 366: query (line 2282)
SELECT format_type(oid, -1) FROM pg_type WHERE typname='text' LIMIT 1;

-- Test 367: query (line 2287)
SELECT format_type(oid, -1) FROM pg_type WHERE typname='BIGINT' LIMIT 1;

-- Test 368: query (line 2292)
SELECT format_type(oid, -1) FROM pg_type WHERE typname='float8' LIMIT 1;

-- Test 369: query (line 2297)
SELECT format_type(oid, -1) FROM pg_type WHERE typname='_int8' LIMIT 1;

-- Test 370: query (line 2302)
SELECT format_type(oid, -1) FROM pg_type WHERE typname='_text' LIMIT 1;

-- Test 371: statement (line 2308)
SELECT format_type(oid, NULL) FROM pg_type;

-- Test 372: query (line 2312)
select format_type('pg_namespace'::regtype, null);

-- Test 373: query (line 2317)
SELECT pg_catalog.pg_get_userbyid((SELECT oid FROM pg_roles WHERE rolname='root'));

-- Test 374: query (line 2322)
SELECT pg_catalog.pg_get_userbyid(d.datdba)
FROM pg_database d
WHERE d.datname = 'system';

-- Test 375: query (line 2329)
SELECT pg_catalog.pg_get_userbyid(20);

-- Test 376: query (line 2334)
SELECT pg_catalog.pg_get_indexdef(0);

-- Test 377: statement (line 2339)
CREATE TYPE testenum AS ENUM ('foo', 'bar', 'baz');

-- Test 378: statement (line 2342)
CREATE TABLE test.pg_indexdef_test (
    a INT,
    e testenum,
    UNIQUE INDEX pg_indexdef_idx (a ASC),
    INDEX pg_indexdef_partial_idx (a) WHERE a > 0,
    INDEX pg_indexdef_partial_enum_idx (a) WHERE e IN ('foo', 'bar'),
    INDEX other (a DESC)
);

-- Test 379: query (line 2352)
SELECT pg_catalog.pg_get_indexdef((SELECT oid from pg_class WHERE relname='pg_indexdef_idx'));

-- Test 380: query (line 2357)
SELECT pg_catalog.pg_get_indexdef((SELECT oid from pg_class WHERE relname='pg_indexdef_partial_idx'));

-- Test 381: query (line 2362)
SELECT pg_catalog.pg_get_indexdef((SELECT oid from pg_class WHERE relname='pg_indexdef_partial_enum_idx'));

-- Test 382: query (line 2367)
SELECT pg_catalog.pg_get_indexdef(0, 0, true);

-- Test 383: query (line 2372)
SELECT pg_catalog.pg_get_indexdef((SELECT oid from pg_class WHERE relname='pg_indexdef_idx'), 0, true);

-- Test 384: statement (line 2377)
CREATE TABLE test.pg_indexdef_test_cols (a INT, b INT, UNIQUE INDEX pg_indexdef_cols_idx (a ASC, b DESC), INDEX other (a DESC));

-- Test 385: query (line 2380)
SELECT pg_catalog.pg_get_indexdef((SELECT oid from pg_class WHERE relname='pg_indexdef_cols_idx'), 0, true);

-- Test 386: query (line 2385)
SELECT pg_catalog.pg_get_indexdef((SELECT oid from pg_class WHERE relname='pg_indexdef_cols_idx'), 1, true);

-- Test 387: query (line 2390)
SELECT pg_catalog.pg_get_indexdef((SELECT oid from pg_class WHERE relname='pg_indexdef_cols_idx'), 2, false);

-- Test 388: query (line 2398)
SELECT pg_catalog.pg_get_indexdef((SELECT oid from pg_class WHERE relname='pg_indexdef_cols_idx'), 3, false);

-- Test 389: query (line 2403)
SELECT length(pg_catalog.pg_get_indexdef((SELECT oid from pg_class WHERE relname='pg_indexdef_cols_idx'), 4, false));

-- Test 390: query (line 2408)
SELECT length(pg_catalog.pg_get_indexdef((SELECT oid from pg_class WHERE relname='pg_indexdef_cols_idx'), -1, false));

-- Test 391: query (line 2413)
SELECT pg_catalog.pg_get_viewdef(0);

-- Test 392: statement (line 2418)
CREATE TABLE test.pg_viewdef_test (a int, b int, c int);

-- Test 393: statement (line 2421)
CREATE VIEW test.pg_viewdef_view AS SELECT a, b FROM test.pg_viewdef_test;

-- Test 394: query (line 2424)
SELECT pg_catalog.pg_get_viewdef('pg_viewdef_view'::regclass::oid);

-- Test 395: query (line 2429)
SELECT pg_catalog.pg_get_viewdef(0, true);

-- Test 396: query (line 2434)
SELECT pg_catalog.pg_get_viewdef(0, false);

-- Test 397: query (line 2439)
SELECT pg_catalog.pg_get_viewdef('pg_viewdef_view'::regclass::oid, true);

-- Test 398: query (line 2444)
SELECT pg_catalog.pg_get_viewdef('pg_viewdef_view'::regclass::oid, false);

-- Test 399: statement (line 2449)
CREATE MATERIALIZED VIEW test.pg_viewdef_mview AS SELECT b, a FROM test.pg_viewdef_test;

-- Test 400: query (line 2452)
SELECT pg_catalog.pg_get_viewdef('pg_viewdef_mview'::regclass::oid);

-- Test 401: query (line 2469)
SELECT pg_catalog.pg_get_constraintdef(oid)
FROM pg_catalog.pg_constraint
WHERE conrelid='pg_constraintdef_test'::regclass;

-- Test 402: query (line 2483)
SELECT col_description('pg_class'::regclass::oid, 2),
       shobj_description('pg_class'::regclass::oid, 'pg_class');

-- Test 403: query (line 2490)
SELECT regexp_replace(obj_description('pg_class'::regclass::oid), e' .*', '') AS comment1,
       regexp_replace(obj_description('pg_class'::regclass::oid, 'pg_class'), e' .*', '') AS comment2;

-- Test 404: statement (line 2497)
CREATE TABLE t(x INT);

-- Test 405: statement (line 2500)
COMMENT ON TABLE t IS 'waa';

-- Test 406: statement (line 2503)
COMMENT ON COLUMN t.x IS 'woo';

-- Test 407: query (line 2506)
SELECT obj_description('t'::regclass::oid),
       obj_description('t'::regclass::oid, 'pg_class'),
       obj_description('t'::regclass::oid, 'notexist'),
       col_description('t'::regclass, 1);

-- Test 408: statement (line 2514)
COMMENT ON DATABASE test is 'foo';

-- Test 409: query (line 2517)
SELECT shobj_description((select oid from pg_database where datname = 'defaultdb')::oid, 'pg_database'),
       shobj_description((select oid from pg_database where datname = 'test')::oid, 'pg_database'),
       shobj_description((select oid from pg_database where datname = 'notexist')::oid, 'pg_database'),
       shobj_description((select oid from pg_database where datname = 'test')::oid, 'notexist');

-- Test 410: query (line 2527)
SELECT shobj_description('t'::regclass::oid, 'pg_class'),
       obj_description((select oid from pg_database where datname = 'test')::oid, 'pg_database');

-- Test 411: query (line 2534)
SELECT pg_catalog.length('hello');

-- Test 412: query (line 2541)
SELECT oid(3), oid(0), (-1)::oid, (-2147483648)::oid, (4294967295)::oid;

-- Test 413: query (line 2547)
SELECT oid(-2147483649);

-- 4294967296 is (MaxUint32 + 1).
-- query error OID out of range: 4294967296
\set ON_ERROR_STOP 0
SELECT oid(4294967296);
\set ON_ERROR_STOP 0

-- query T rowsort
SELECT to_english(i) FROM (VALUES (1), (13), (617), (-2), (-9223372036854775808)) AS a(i);

-- Test 414: query (line 2564)
SELECT
  sha512('1') = sha512('1'),
  sha512('1') = sha512('2'),
  sha512('1', '2') = sha512('1', '2'),
  sha512('1', '2') = sha512('2', '1'),
  sha512('1', '2') = sha512('12'),
  sha512('1', '2') = sha512('21'),
  sha512('bar') = sha512('\x626172'::bytea::BYTEA),
  sha512('\x626172'::bytea::BYTEA) = sha512('\x626172'::bytea::BYTEA),
  sha512('\x626172'::bytea::BYTEA) = sha512('bar');

-- Test 415: query (line 2605)
SELECT pg_catalog.pg_encoding_to_char(6), pg_catalog.pg_encoding_to_char(7);

-- Test 416: query (line 2612)
SELECT pg_catalog.inet_client_addr(), pg_catalog.inet_client_port(), pg_catalog.inet_server_addr(), pg_catalog.inet_server_port()
FROM pg_class
WHERE relname = 'pg_constraint';

-- Test 417: query (line 2619)
SELECT quote_ident('foo'), quote_ident('select'), quote_ident('BIGINT'), quote_ident('numeric');

-- Test 418: query (line 2625)
SELECT lpad('abc', 5, 'xy'), rpad('abc', 5, 'xy');

-- Test 419: query (line 2630)
SELECT lpad('abc', 5, ''), rpad('abc', 5, '');

-- Test 420: query (line 2635)
SELECT lpad('abc', 100000000000000);

-- query error requested length too large
\set ON_ERROR_STOP 0
SELECT rpad('abc', 100000000000000);
\set ON_ERROR_STOP 0

-- query TT
SELECT array_to_string(ARRAY['a', 'b,', NULL, 'c'], ','), array_to_string(ARRAY['a', 'b,', NULL, 'c'], ',', NULL);

-- Test 421: query (line 2646)
SELECT array_to_string(ARRAY['a', 'b,', 'c'], NULL), array_to_string(ARRAY['a', 'b,', NULL, 'c'], 'foo', 'zerp');

-- Test 422: query (line 2651)
SELECT array_to_string(NULL, ','), array_to_string(NULL, 'foo', 'zerp');

-- Test 423: query (line 2657)
SELECT array_to_string(ARRAY[ARRAY[ARRAY[5,6], ARRAY[2,3]], ARRAY[ARRAY[7,8], ARRAY[4,44]]], ' ');

-- Test 424: query (line 2663)
SELECT array_to_string(ARRAY[(SELECT ARRAY[1,2]::int2vector)],' ');

-- Test 425: query (line 2669)
SELECT format('Hello %s', 'World');

-- Test 426: query (line 2674)
SELECT format('INSERT INTO %I VALUES(%L)', 'locations', 'C:\Program Files');

-- Test 427: query (line 2679)
SELECT format('|%10s|', 'foo');

-- Test 428: query (line 2684)
SELECT format('|%-10s|', 'foo');

-- Test 429: query (line 2689)
SELECT format('|%*s|', 10, 'foo');

-- Test 430: query (line 2694)
SELECT format('|%*s|', -10, 'foo');

-- Test 431: query (line 2699)
SELECT format('|%-*s|', 10, 'foo');

-- Test 432: query (line 2704)
SELECT format('|%-*s|', -10, 'foo');

-- Test 433: query (line 2712)
EXECUTE format_stmt(10, 'foo');

-- Test 434: query (line 2717)
EXECUTE format_stmt(-10, 'foo');

-- Test 435: query (line 2723)
SELECT format(E'Testing %3\x24s, %2\x24s, %1\x24s', 'one', 'two', 'three');

-- Test 436: query (line 2728)
SELECT format(E'Testing %3\x24s, %2\x24s, %s', 'one', 'two', 'three');

-- Test 437: query (line 2733)
SELECT format(E'%2\x24s','foo');

-- statement error pgcode 42883 pq: unknown signature: format\(\)
\set ON_ERROR_STOP 0
SELECT format();
\set ON_ERROR_STOP 0

-- statement error pgcode 42883 pq: unknown signature: format\(int\)
\set ON_ERROR_STOP 0
SELECT format(42);
\set ON_ERROR_STOP 0

-- subtest pg_is_in_recovery

-- query B colnames
SELECT pg_is_in_recovery();

-- Test 438: query (line 2752)
SELECT pg_is_xlog_replay_paused();

-- Test 439: query (line 2758)
SELECT pg_catalog.pg_client_encoding();

-- Test 440: query (line 2766)
SELECT width_bucket(8.0, 2.0, 3.0, 5);

-- Test 441: query (line 2771)
SELECT width_bucket(5.35, 0.024, 10.06, 5);

-- Test 442: query (line 2776)
SELECT width_bucket(7, 3, 11, 5);

-- Test 443: query (line 2781)
SELECT width_bucket(now(), array['yesterday', 'today', 'tomorrow']::timestamptz[]);

-- Test 444: query (line 2786)
SELECT width_bucket(1, array['a', 'h', 'l', 'z']);

-- Regression for #40623
-- query I
SELECT width_bucket(1, array[]::int[]);

-- Test 445: query (line 2795)
SELECT width_bucket('Infinity'::numeric, 1, 10, 10);

-- Test 446: query (line 2800)
SELECT width_bucket('-Infinity'::numeric, 1, 10, 10);

-- Test 447: statement (line 2805)
SELECT width_bucket('NaN', 3.0, 4.0, 888);

-- Test 448: query (line 2810)
SELECT pg_type_is_visible('int'::regtype), pg_type_is_visible(NULL), pg_type_is_visible(99999);

-- Test 449: query (line 2816)
SELECT pg_get_function_arguments('convert_from'::regproc::oid);

-- Test 450: query (line 2822)
SELECT pg_get_function_arguments('version'::regproc::oid);

-- Test 451: query (line 2827)
SELECT pg_get_function_arguments('array_length'::regproc);

-- Test 452: query (line 2832)
SELECT pg_get_function_arguments((select oid from pg_proc where proname='variance' and proargtypes[0] = 'int'::regtype));

-- Test 453: query (line 2838)
SELECT pg_get_function_identity_arguments('convert_from'::regproc::oid);

-- Test 454: query (line 2844)
SELECT pg_get_function_identity_arguments('version'::regproc::oid);

-- Test 455: query (line 2849)
SELECT pg_get_function_identity_arguments('array_length'::regproc);

-- Test 456: query (line 2854)
SELECT pg_get_function_identity_arguments((select oid from pg_proc where proname='variance' and proargtypes[0] = 'int'::regtype));

-- Test 457: query (line 2861)
SELECT pg_get_function_result('array_length'::regproc);

-- Test 458: query (line 2866)
SELECT pg_get_function_result((select oid from pg_proc where proname='variance' and proargtypes[0] = 'int'::regtype));

-- Test 459: query (line 2871)
SELECT pg_get_function_result('pg_sleep'::regproc);

-- Test 460: query (line 2877)
SELECT pg_get_function_result('unnest'::regproc);

-- query T
SELECT CASE WHEN true THEN (1, 2) ELSE NULL END;

-- Test 461: query (line 2885)
SELECT (1, 2) IN ((2, 3), NULL, (1, 2));

-- Test 462: query (line 2890)
SELECT (1, 2) IN ((2, 3), NULL);

-- Test 463: query (line 2899)
select to_hex(-2147483649), to_hex(-2147483648::BIGINT), to_hex(-1::BIGINT), to_hex(0), to_hex(1), to_hex(2147483647), to_hex(2147483648);

-- Test 464: query (line 2904)
select to_hex(E'\\047\\134'::bytea);

-- Test 465: query (line 2909)
select to_hex('abc');

-- Test 466: statement (line 2917)
SET TIME ZONE -3;

-- Test 467: query (line 2920)
SELECT timezone('UTC+6', '1970-01-01 01:00');

-- Test 468: query (line 2925)
SELECT timezone('UTC+6', '1970-01-01 01:00'::time);

-- Test 469: query (line 2930)
SELECT timezone('UTC+6', '1970-01-01 01:00'::timetz);

-- Test 470: query (line 2935)
SELECT timezone('UTC+6', '1970-01-01 01:00'::timestamp);

-- Test 471: query (line 2940)
SELECT timezone('UTC+6', '1970-01-01 01:00'::timestamptz);

-- Test 472: statement (line 2945)
SET TIME ZONE +0;

-- Test 473: query (line 2950)
SELECT getdatabaseencoding();

-- Test 474: query (line 2957)
SELECT get_byte('Th\000omas'::BYTEA, 4);

-- Test 475: query (line 2962)
SELECT get_byte('abc'::BYTEA, 10);

-- query error byte index -10 out of valid range
\set ON_ERROR_STOP 0
SELECT get_byte('abc'::BYTEA, -10);
\set ON_ERROR_STOP 0

-- subtest set_byte

-- query T
SELECT set_byte('Th\000omas'::BYTEA, 2, 64);

-- Test 476: query (line 2976)
SELECT set_byte('Th\000omas'::BYTEA, 2, 16448);

-- Test 477: query (line 2981)
SELECT set_byte('abc'::BYTEA, 10, 123);

-- query error byte index -10 out of valid range
\set ON_ERROR_STOP 0
SELECT set_byte('abc'::BYTEA, -10, 123);
\set ON_ERROR_STOP 0

-- subtest get_bit

-- query I rowsort
SELECT get_bit(B'100101110101', 3) UNION SELECT get_bit(B'100101110101', 2);

-- Test 478: query (line 2995)
SELECT get_bit('000000'::varbit, 5) UNION SELECT get_bit('1111111'::varbit, 5);

-- Test 479: query (line 3001)
SELECT get_bit(B'10110', 10);

-- query error bit index 0 out of valid range \(0..-1\)
\set ON_ERROR_STOP 0
SELECT get_bit(B'', 0);
\set ON_ERROR_STOP 0

-- query II
SELECT i, get_bit('\x11'::BYTEA, i) FROM generate_series(0, 7) i ORDER BY i;

-- Test 480: query (line 3019)
SELECT i, get_bit('\x11ef'::BYTEA, i) FROM generate_series(0, 15) i ORDER BY i;

-- Test 481: query (line 3039)
SELECT get_bit('\x61'::bytea, 8);

-- query error bit index 0 out of valid range \(0..-1\)
\set ON_ERROR_STOP 0
SELECT get_bit('\x'::bytea, 0);
\set ON_ERROR_STOP 0

-- subtest set_bit

-- query T rowsort
SELECT set_bit(B'1101010', 0, 0) UNION SELECT set_bit(B'1101010', 2, 1);

-- Test 482: query (line 3053)
SELECT set_bit('000000'::varbit, 5, 1) UNION SELECT set_bit('111111'::varbit, 5, 0);

-- Test 483: query (line 3059)
SELECT set_bit(B'1101010', 10, 1);

-- query error new bit must be 0 or 1
\set ON_ERROR_STOP 0
SELECT set_bit(B'1001010', 0, 2);
\set ON_ERROR_STOP 0

-- query error bit index 0 out of valid range \(0..-1\)
\set ON_ERROR_STOP 0
SELECT set_bit(B'', 0, 1);
\set ON_ERROR_STOP 0

-- query IT
SELECT i, encode(set_bit('\x00'::BYTEA, i, 1), 'hex') FROM generate_series(0, 7) i ORDER BY i;

-- Test 484: query (line 3080)
SELECT i, encode(set_bit('\x0000'::bytea, i, 1), 'hex') FROM generate_series(0, 15) i ORDER BY i;

-- Test 485: query (line 3136)
EXECUTE nn_stmt(NULL);

-- Test 486: query (line 3144)
EXECUTE nn_stmt('foo');

-- Test 487: statement (line 3152)
SET use_pre_25_2_variadic_builtins = true;

-- Test 488: statement (line 3155)
PREPARE nn_stmt2 AS SELECT num_nulls(42, $1, a, b) FROM nulls_test;

-- Test 489: statement (line 3161)
PREPARE nn_stmt3 AS SELECT num_nulls(42, $1::INT, a) FROM nulls_test;

-- Test 490: query (line 3164)
EXECUTE nn_stmt3(42);

-- Test 491: statement (line 3172)
EXECUTE nn_stmt3('foo');

-- Test 492: statement (line 3175)
RESET use_pre_25_2_variadic_builtins;

-- Test 493: statement (line 3178)
PREPARE nn_stmt4 AS SELECT num_nulls(42, $1, a) FROM nulls_test;

-- Test 494: query (line 3183)
select crdb_internal.pb_to_json('cockroach.sql.sqlbase.Descriptor', descriptor)->'database'->>'name' from system.descriptor where id=1;

-- Test 495: query (line 3188)
select crdb_internal.pb_to_json('cockroach.sql.sqlbase.Descriptor', descriptor, true, true)->'database'->>'name' from system.descriptor where id=1;

-- Test 496: query (line 3193)
select crdb_internal.pb_to_json('cockroach.sql.sqlbase.descriptor', descriptor)->'database'->>'name' from system.descriptor where id=1;

-- query B
SELECT (SELECT * FROM [SHOW crdb_version]) = version();

-- Test 497: query (line 3202)
select crdb_internal.json_to_pb('cockroach.sql.sqlbase.Descriptor', crdb_internal.pb_to_json('cockroach.sql.sqlbase.Descriptor', descriptor)) = descriptor from system.descriptor where id = 1;

-- Test 498: query (line 3207)
select crdb_internal.json_to_pb('cockroach.sql.sqlbase.Descriptor', crdb_internal.pb_to_json('cockroach.sql.sqlbase.Descriptor', descriptor, true, true)) = descriptor from system.descriptor where id = 1;

-- subtest regexp_split

-- query T nosort
SELECT regexp_split_to_table('3aa0AAa1', 'a+');

-- Test 499: query (line 3219)
SELECT regexp_split_to_table('3aa0AAa1', 'a+', 'i');

-- Test 500: query (line 3226)
SELECT regexp_split_to_array('3aa0AAa1', 'a+');

-- Test 501: query (line 3231)
SELECT regexp_split_to_array('3aaa0AAa1', 'a+', 'i');

-- Test 502: query (line 3241)
SELECT * FROM crdb_internal.trace_id();

-- user root

-- query B
SELECT count(*) = 1 FROM crdb_internal.trace_id();

-- Test 503: query (line 3256)
SELECT * FROM crdb_internal.payloads_for_span(0);

-- user root

-- query TT colnames
SELECT * FROM crdb_internal.payloads_for_span(0)
WHERE false;

-- Test 504: query (line 3272)
SELECT * FROM crdb_internal.payloads_for_span(0);

-- user root

-- query TTT colnames
SELECT * FROM crdb_internal.payloads_for_trace(0)
WHERE false;

-- Test 505: query (line 3286)
SELECT * FROM crdb_internal.set_trace_verbose(0, false);

-- user root

-- query B
SELECT * FROM crdb_internal.set_trace_verbose(0, false)
WHERE false;

-- Test 506: statement (line 3297)
SET timezone = 'Europe/Berlin';

-- Test 507: query (line 3300)
select generate_series('2021-07-05'::timestamptz, '2021-07-06'::timestamptz, '1day'::interval);

-- Test 508: statement (line 3306)
SET TIME ZONE +0;

-- Test 509: statement (line 3309)
set timezone = 'Europe/Bucharest';

-- Test 510: query (line 3313)
select '2020-10-25 00:00'::TIMESTAMPTZ + (i::text || ' hour')::interval from generate_series(0, 24) AS g(i);

-- Test 511: query (line 3342)
select generate_series('2020-10-25 00:00'::TIMESTAMPTZ, '2020-10-25 23:00'::TIMESTAMPTZ, '1 hour');

-- Test 512: statement (line 3371)
SET TIME ZONE +0;

-- Test 513: query (line 3374)
SELECT 'AAA'::text ~ similar_escape('(ACTIVE|CLOSED|PENDING)'::text, NULL::text);

-- Test 514: query (line 3379)
SELECT 'ACTIVE'::text ~ similar_escape('(ACTIVE|CLOSED|PENDING)'::text, NULL::text);

-- Test 515: query (line 3384)
SELECT 'ACTIVE'::text ~ similar_escape(NULL::text, NULL::text);

-- Test 516: query (line 3389)
SELECT 'AAA'::text ~ similar_to_escape('(ACTIVE|CLOSED|PENDING)'::text, NULL::text);

-- Test 517: query (line 3394)
SELECT 'ACTIVE'::text ~ similar_to_escape('(ACTIVE|CLOSED|PENDING)'::text, NULL::text);

-- Test 518: query (line 3399)
SELECT 'ACTIVE'::text ~ similar_to_escape('(ACTIVE|CLOSED|PENDING)'::text);

-- Test 519: query (line 3404)
SELECT 'AAA'::text ~ similar_to_escape('(ACTIVE|CLOSED|PENDING)'::text);

-- Test 520: query (line 3409)
SELECT 'ACTIVE'::text ~ similar_to_escape(NULL::text);

-- Test 521: query (line 3418)
SELECT crdb_internal.check_password_hash_format(('CRDB-BCRYPT$'||'3a$'||'10$'||'vcmoIBvgeHjgScVHWRMWI.Z3v03WMixAw2bBS6qZihljSUuwi88Yq')::BYTEA);

-- query error pgcode 42601 too short to be a bcrypted password
\set ON_ERROR_STOP 0
SELECT crdb_internal.check_password_hash_format(('CRDB-BCRYPT$'||'2a$'||'10$'||'vcmoIBvgeHjgScVHWRMWI.Z3v0')::BYTEA);
\set ON_ERROR_STOP 0

-- query error pgcode 42601 cost 1 is outside allowed inclusive range 4..31
\set ON_ERROR_STOP 0
SELECT crdb_internal.check_password_hash_format(('CRDB-BCRYPT$'||'2a$'||'01$'||'vcmoIBvgeHjgScVHWRMWI.Z3v03WMixAw2bBS6qZihljSUuwi88Yq')::BYTEA);
\set ON_ERROR_STOP 0

-- query T
SELECT crdb_internal.check_password_hash_format(('CRDB-BCRYPT$'||'2a$'||'10$'||'vcmoIBvgeHjgScVHWRMWI.Z3v03WMixAw2bBS6qZihljSUuwi88Yq')::BYTEA);

-- Test 522: query (line 3433)
SELECT crdb_internal.check_password_hash_format('md5aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');

-- Test 523: query (line 3439)
SELECT crdb_internal.check_password_hash_format(('SCRAM-SHA-256$'||'4096:B5VaTCvCLDzZxSYL829oVA==$'||'3Ako3mNxNtdsaSOJl0Av3i6vyV2OiSP9Ly7famdFSbw=:d7BfSmrtjwbF74mSoOhQiDSpoIvlakXKdpBNb3Meunc=')::BYTEA);

-- Test 524: statement (line 3462)
select crdb_internal.create_session_revival_token();

-- user testuser

-- Test 525: statement (line 3471)
SET ROLE parentuser;

-- Test 526: query (line 3477)
WITH
  a AS (SELECT crdb_internal.create_session_revival_token() AS token),
  b AS (
    SELECT
      crdb_internal.pb_to_json(
        'cockroach.sql.sessiondatapb.SessionRevivalToken',
        a.token
      ) AS json_token
    FROM a
  ),
  c AS (
    SELECT
      (json_populate_record(
        NULL::token_payload,
        crdb_internal.pb_to_json(
          'cockroach.sql.sessiondatapb.SessionRevivalToken.Payload',
          decode(b.json_token->>'payload', 'base64'),
          true
        )
      )).*
    FROM b
  )
SELECT
  algorithm,
  "user",
  "expiresAt" > now(),
  "expiresAt" < (now() + INTERVAL '11 minutes'),
  "expiresAt" > "issuedAt",
  crdb_internal.validate_session_revival_token(a.token)
FROM
  c, a;

-- Test 527: query (line 3520)
SELECT overlaps(
TIMESTAMP '2000-01-01 00:00:00',
TIMESTAMP '2000-01-01 01:00:00',
TIMESTAMP '2000-01-01 00:30:00',
TIMESTAMP '2000-01-01 01:30:00');

-- Test 528: query (line 3529)
SELECT overlaps(
TIMESTAMP '2000-01-01 01:00:00',
TIMESTAMP '2000-01-01 00:00:00',
TIMESTAMP '2000-01-01 00:30:00',
TIMESTAMP '2000-01-01 01:30:00');

-- Test 529: query (line 3538)
SELECT overlaps(
TIMESTAMP '2000-01-01 00:00:00',
TIMESTAMP '2000-01-01 00:15:00',
TIMESTAMP '2000-01-01 00:30:00',
TIMESTAMP '2000-01-01 01:30:00');

-- Test 530: query (line 3547)
SELECT overlaps(
TIMESTAMP '2000-01-01 00:00:00',
TIMESTAMP '2000-01-01 00:30:00',
TIMESTAMP '2000-01-01 00:30:00',
TIMESTAMP '2000-01-01 01:30:00');

-- Test 531: query (line 3556)
SELECT overlaps(
TIMESTAMP '2000-01-01 00:30:00',
TIMESTAMP '2000-01-01 00:30:00',
TIMESTAMP '2000-01-01 00:30:00',
TIMESTAMP '2000-01-01 01:30:00');

-- Test 532: query (line 3565)
SELECT overlaps(
TIMESTAMPTZ '2000-01-01 00:00:00',
TIMESTAMPTZ '2000-01-01 01:00:00',
TIMESTAMPTZ '2000-01-01 00:30:00',
TIMESTAMPTZ '2000-01-01 01:30:00');

-- Test 533: query (line 3574)
SELECT overlaps(
TIMESTAMPTZ '2000-01-01 01:00:00',
TIMESTAMPTZ '2000-01-01 00:00:00',
TIMESTAMPTZ '2000-01-01 00:30:00',
TIMESTAMPTZ '2000-01-01 01:30:00');

-- Test 534: query (line 3583)
SELECT overlaps(
TIMESTAMPTZ '2000-01-01 00:00:00',
TIMESTAMPTZ '2000-01-01 00:15:00',
TIMESTAMPTZ '2000-01-01 00:30:00',
TIMESTAMPTZ '2000-01-01 01:30:00');

-- Test 535: query (line 3592)
SELECT overlaps(
TIMESTAMPTZ '2000-01-01 00:00:00',
TIMESTAMPTZ '2000-01-01 00:30:00',
TIMESTAMPTZ '2000-01-01 00:30:00',
TIMESTAMPTZ '2000-01-01 01:30:00');

-- Test 536: query (line 3601)
SELECT overlaps(
TIMESTAMPTZ '2000-01-01 00:30:00',
TIMESTAMPTZ '2000-01-01 00:30:00',
TIMESTAMPTZ '2000-01-01 00:30:00',
TIMESTAMPTZ '2000-01-01 01:30:00');

-- Test 537: query (line 3610)
SELECT overlaps(
TIME '2000-01-01 00:00:00',
TIME '2000-01-01 01:00:00',
TIME '2000-01-01 00:30:00',
TIME '2000-01-01 01:30:00');

-- Test 538: query (line 3619)
SELECT overlaps(
TIME '2000-01-01 01:00:00',
TIME '2000-01-01 00:00:00',
TIME '2000-01-01 00:30:00',
TIME '2000-01-01 01:30:00');

-- Test 539: query (line 3628)
SELECT overlaps(
TIME '2000-01-01 00:00:00',
TIME '2000-01-01 00:15:00',
TIME '2000-01-01 00:30:00',
TIME '2000-01-01 01:30:00');

-- Test 540: query (line 3637)
SELECT overlaps(
TIME '2000-01-01 00:00:00',
TIME '2000-01-01 00:30:00',
TIME '2000-01-01 00:30:00',
TIME '2000-01-01 01:30:00');

-- Test 541: query (line 3646)
SELECT overlaps(
TIME '2000-01-01 00:30:00',
TIME '2000-01-01 00:30:00',
TIME '2000-01-01 00:30:00',
TIME '2000-01-01 01:30:00');

-- Test 542: query (line 3655)
SELECT overlaps(
TIMETZ '2000-01-01 00:00:00',
TIMETZ '2000-01-01 01:00:00',
TIMETZ '2000-01-01 00:30:00',
TIMETZ '2000-01-01 01:30:00');

-- Test 543: query (line 3664)
SELECT overlaps(
TIMETZ '2000-01-01 01:00:00',
TIMETZ '2000-01-01 00:00:00',
TIMETZ '2000-01-01 00:30:00',
TIMETZ '2000-01-01 01:30:00');

-- Test 544: query (line 3673)
SELECT overlaps(
TIMETZ '2000-01-01 00:00:00',
TIMETZ '2000-01-01 00:15:00',
TIMETZ '2000-01-01 00:30:00',
TIMETZ '2000-01-01 01:30:00');

-- Test 545: query (line 3682)
SELECT overlaps(
TIMETZ '2000-01-01 00:00:00',
TIMETZ '2000-01-01 00:30:00',
TIMETZ '2000-01-01 00:30:00',
TIMETZ '2000-01-01 01:30:00');

-- Test 546: query (line 3691)
SELECT overlaps(
TIMETZ '2000-01-01 00:30:00',
TIMETZ '2000-01-01 00:30:00',
TIMETZ '2000-01-01 00:30:00',
TIMETZ '2000-01-01 01:30:00');

-- Test 547: query (line 3700)
SELECT overlaps(
DATE '2000-01-01',
DATE '2000-01-03',
DATE '2000-01-02',
DATE '2000-01-04');

-- Test 548: query (line 3709)
SELECT overlaps(
DATE '2000-01-03',
DATE '2000-01-01',
DATE '2000-01-02',
DATE '2000-01-04');

-- Test 549: query (line 3718)
SELECT overlaps(
DATE '2000-01-01',
DATE '2000-01-02',
DATE '2000-01-03',
DATE '2000-01-04');

-- Test 550: query (line 3727)
SELECT overlaps(
DATE '2000-01-01',
DATE '2000-01-03',
DATE '2000-01-03',
DATE '2000-01-04');

-- Test 551: query (line 3736)
SELECT overlaps(
DATE '2000-01-03',
DATE '2000-01-03',
DATE '2000-01-03',
DATE '2000-01-04');

-- Test 552: query (line 3745)
SELECT overlaps(
TIMESTAMP '2000-01-01 00:00:00',
INTERVAL '100 days',
TIMESTAMP '2000-01-01 00:30:00',
INTERVAL '30 minutes');

-- Test 553: query (line 3754)
SELECT overlaps(
TIMESTAMP '2000-01-01 00:00:00',
INTERVAL '100 s',
TIMESTAMP '2000-01-01 00:30:00',
INTERVAL '30 minutes');

-- Test 554: query (line 3763)
SELECT overlaps(
TIMESTAMP '2000-01-01 00:00:00',
INTERVAL '30 minutes',
TIMESTAMP '2000-01-01 00:30:00',
INTERVAL '30 minutes');

-- Test 555: query (line 3772)
SELECT overlaps(
TIMESTAMPTZ '2000-01-01 00:00:00',
INTERVAL '100 days',
TIMESTAMPTZ '2000-01-01 00:30:00',
INTERVAL '30 minutes');

-- Test 556: query (line 3781)
SELECT overlaps(
TIMESTAMPTZ '2000-01-01 00:00:00',
INTERVAL '100 s',
TIMESTAMPTZ '2000-01-01 00:30:00',
INTERVAL '30 minutes');

-- Test 557: query (line 3790)
SELECT overlaps(
TIMESTAMPTZ '2000-01-01 00:00:00',
INTERVAL '30 minutes',
TIMESTAMPTZ '2000-01-01 00:30:00',
INTERVAL '30 minutes');

-- Test 558: query (line 3799)
SELECT overlaps(
TIME '2000-01-01 00:00:00',
INTERVAL '2 hours',
TIME '2000-01-01 00:30:00',
INTERVAL '30 minutes');

-- Test 559: query (line 3808)
SELECT overlaps(
TIME '2000-01-01 00:00:00',
INTERVAL '100 s',
TIME '2000-01-01 00:30:00',
INTERVAL '30 minutes');

-- Test 560: query (line 3817)
SELECT overlaps(
TIME '2000-01-01 00:00:00',
INTERVAL '30 minutes',
TIME '2000-01-01 00:30:00',
INTERVAL '30 minutes');

-- Test 561: query (line 3826)
SELECT overlaps(
TIMETZ '00:00:00',
INTERVAL '3 hours',
TIMETZ '00:30:00',
INTERVAL '30 minutes');

-- Test 562: query (line 3835)
SELECT overlaps(
TIMETZ '00:00:00',
INTERVAL '100 s',
TIMETZ '00:30:00',
INTERVAL '30 minutes');

-- Test 563: query (line 3844)
SELECT overlaps(
TIMETZ '00:00:00',
INTERVAL '30 minutes',
TIMETZ '00:30:00',
INTERVAL '30 minutes');

-- Test 564: query (line 3853)
SELECT overlaps(
DATE '2000-01-01',
INTERVAL '3 hours',
DATE '2000-01-02',
INTERVAL '2 days');

-- Test 565: query (line 3862)
SELECT overlaps(
DATE '2000-01-01',
INTERVAL '2 days',
DATE '2000-01-02',
INTERVAL '2 days');

-- Test 566: query (line 3871)
SELECT overlaps(
DATE '2000-01-01',
INTERVAL '1 day',
DATE '2000-01-02',
INTERVAL '2 days');

-- Test 567: query (line 3880)
SELECT overlaps
(DATE '2000-01-03',
DATE '2000-02-03',
DATE '2000-03-03',
DATE '2000-01-03',
DATE '2000-01-04');

-- query T
SELECT overlaps(NULL, NULL, NULL, NULL);

-- Test 568: query (line 3893)
SELECT overlaps(NULL, INTERVAL '1 day', NULL, NULL);

-- Test 569: query (line 3898)
SELECT overlaps(DATE '2000-01-01', INTERVAL '1 day', NULL, NULL);

-- Test 570: query (line 3903)
SELECT overlaps(DATE '2000-01-01', NULL, DATE '2000-01-01', DATE '2000-01-02');

-- Test 571: query (line 3908)
SELECT overlaps(
TIMESTAMP '2000-01-01 00:00:00',
TIME '2000-01-01 01:00:00',
TIME '2000-01-01 00:30:00',
TIMESTAMP '2000-01-01 01:30:00');

-- query error pq: unknown signature: overlaps\(timestamp, interval, date, timestamptz\)
\set ON_ERROR_STOP 0
SELECT overlaps(
TIMESTAMP '2000-01-01 00:00:00',
INTERVAL '2 days',
DATE '2000-01-01',
TIMESTAMPTZ '2000-01-01 01:30:00');
\set ON_ERROR_STOP 0

-- query T
SELECT encode(decompress(compress('Hello World', 'gzip'), 'gzip'), 'escape');

-- Test 572: query (line 3927)
SELECT encode(decompress(compress('Hello World', 'zstd'), 'zstd'), 'escape');

-- Test 573: query (line 3932)
SELECT encode(decompress(compress('Hello World', 'snappy'), 'snappy'), 'escape');

-- Test 574: query (line 3937)
SELECT encode(decompress(compress('Hello World', 'lz4'), 'LZ4'), 'escape');

-- Test 575: query (line 3942)
SELECT encode(decompress(compress('Hello World', 'snappy'), 'lz4'), 'escape');

-- query error pq: only 'gzip', 'lz4', 'snappy', or 'zstd' compression codecs are supported
\set ON_ERROR_STOP 0
SELECT compress('Hello World', 'infiniteCompressionCodec');
\set ON_ERROR_STOP 0

-- subtest crdb_internal.hide_sql_constants
-- query T
SELECT crdb_internal.hide_sql_constants('select 1, 2, 3');

-- Test 576: query (line 3955)
SELECT crdb_internal.hide_sql_constants('select _, _, _');

-- Test 577: query (line 3960)
SELECT crdb_internal.hide_sql_constants(ARRAY('select 1', NULL, 'select ''hello''', '', 'not a sql stmt'));

-- Test 578: query (line 3965)
SELECT crdb_internal.hide_sql_constants(ARRAY['banana']);

-- Test 579: query (line 3970)
SELECT crdb_internal.hide_sql_constants('SELECT ''yes'' IN (''no'', ''maybe'', ''yes'')');

-- Test 580: query (line 3975)
SELECT crdb_internal.hide_sql_constants('');

-- Test 581: query (line 3980)
SELECT crdb_internal.hide_sql_constants(NULL);

-- Test 582: query (line 3985)
SELECT crdb_internal.hide_sql_constants('not a sql stmt');

-- Test 583: query (line 3991)
select crdb_internal.hide_sql_constants(e'\r');

-- Test 584: query (line 3998)
SELECT crdb_internal.hide_sql_constants(create_statement) from crdb_internal.create_statements where descriptor_name = 'foo';

-- Test 585: query (line 4004)
SELECT crdb_internal.hide_sql_constants(create_statement) from crdb_internal.create_statements where descriptor_name = 'foo';

-- Test 586: query (line 4010)
SELECT parse_ident(str) FROM ( VALUES
  ('a.b.c'),
  ('"YesCaps".NoCaps'),
  ('"a""b".xyz'),
  ('"a\b".xyz')
) tbl(str);

-- Test 587: query (line 4023)
SELECT parse_ident('ab.xyz()', false);

-- Test 588: query (line 4028)
SELECT parse_ident('ab.xyz()', true);

-- Test that we return appropriate user-facing errors when trying to decode invalid bytes.
-- query error pgcode 22023 pq: invalid protocol message: proto: wrong wireType = 1 for field Import
\set ON_ERROR_STOP 0
select crdb_internal.job_payload_type('invalid'::BYTEA);
\set ON_ERROR_STOP 0

-- query error pgcode 22023 pq: invalid type in job payload protocol message: Payload.Type called on a payload with an unknown details type: <nil>
\set ON_ERROR_STOP 0
select crdb_internal.job_payload_type('');
\set ON_ERROR_STOP 0

-- subtest crdb_internal.get_fully_qualified_table_name
-- query T
SELECT crdb_internal.get_fully_qualified_table_name(NULL);

-- Test 589: query (line 4044)
SELECT crdb_internal.get_fully_qualified_table_name(9999999);

-- Test 590: statement (line 4049)
CREATE DATABASE "testDatabase";

-- Test 591: query (line 4052)
SELECT crdb_internal.get_fully_qualified_table_name((SELECT id FROM system.namespace WHERE name = 'foo'));

-- Test 592: statement (line 4057)
SELECT crdb_internal.get_fully_qualified_table_name('');

-- Test 593: statement (line 4060)
USE "testDatabase";

-- Test 594: statement (line 4063)
CREATE SCHEMA "testSchema";

-- Test 595: statement (line 4066)
CREATE TABLE "testSchema"."testTable" (a INT);

-- let $testTableID
SELECT id FROM system.namespace WHERE name = 'testTable';

-- Test 596: statement (line 4072)
USE test;

-- Test 597: query (line 4075)
SELECT crdb_internal.get_fully_qualified_table_name($testTableID);

-- Test 598: query (line 4084)
SELECT crdb_internal.get_fully_qualified_table_name($testTableID);

-- Test 599: statement (line 4091)
REVOKE CONNECT ON DATABASE "testDatabase" FROM public;

-- user testuser

-- Test 600: query (line 4097)
SELECT crdb_internal.get_fully_qualified_table_name($testTableID);

-- Test 601: query (line 4105)
SELECT crdb_internal.redactable_sql_constants(NULL);

-- Test 602: query (line 4110)
SELECT crdb_internal.redactable_sql_constants('');

-- Test 603: query (line 4115)
SELECT crdb_internal.redactable_sql_constants('SELECT 1, 2, 3');

-- Test 604: query (line 4120)
SELECT crdb_internal.redactable_sql_constants('UPDATE mytable SET col = ''abc'' WHERE key = 0');

-- Test 605: query (line 4125)
SELECT crdb_internal.redactable_sql_constants('not a sql statement');

-- Test 606: query (line 4130)
SELECT crdb_internal.redactable_sql_constants('1');

-- Test 607: statement (line 4135)
SELECT crdb_internal.redactable_sql_constants(1);

-- Test 608: query (line 4143)
SELECT crdb_internal.redactable_sql_constants(ARRAY['']);

-- Test 609: query (line 4148)
SELECT crdb_internal.redactable_sql_constants(ARRAY[NULL]);

-- Test 610: query (line 4153)
SELECT crdb_internal.redactable_sql_constants(ARRAY['banana']);

-- Test 611: query (line 4158)
SELECT crdb_internal.redactable_sql_constants(ARRAY['SELECT 1', NULL, 'SELECT ''hello''', '']);

-- Test 612: query (line 4163)
SELECT crdb_internal.redactable_sql_constants('SELECT ''yes'' IN (''no'', ''maybe'', ''yes'')');

-- Test 613: query (line 4168)
SELECT crdb_internal.redactable_sql_constants(e'\r');

-- Test 614: query (line 4174)
SELECT crdb_internal.redactable_sql_constants('SELECT crdb_internal.redactable_sql_constants('''')');

-- Test 615: query (line 4179)
SELECT crdb_internal.redactable_sql_constants('WITH j AS (VALUES (0.1, false, ''{}''::jsonb, ARRAY[''x'', ''y'', ''''])) INSERT INTO i SELECT *, 7 FROM j WHERE true');

-- Test 616: query (line 4185)
SELECT crdb_internal.redactable_sql_constants(create_statement)
FROM crdb_internal.create_statements
WHERE descriptor_name = 'foo';

-- Test 617: query (line 4193)
SELECT crdb_internal.redactable_sql_constants(create_statement)
FROM crdb_internal.create_statements
WHERE descriptor_name = 'foo';

-- Test 618: query (line 4210)
SELECT crdb_internal.redactable_sql_constants(create_statement)
FROM crdb_internal.create_statements
WHERE descriptor_name = 'redactable_sql_constants_table';

-- Test 619: query (line 4218)
SELECT crdb_internal.redactable_sql_constants(create_statement)
FROM crdb_internal.create_statements
WHERE descriptor_name = 'redactable_sql_constants_table';

-- Test 620: statement (line 4225)
DROP TABLE redactable_sql_constants_table;

-- Test 621: query (line 4230)
SELECT crdb_internal.redact(NULL);

-- Test 622: query (line 4235)
SELECT crdb_internal.redact('');

-- Test 623: query (line 4240)
SELECT crdb_internal.redact('0');

-- Test 624: query (line 4245)
SELECT crdb_internal.redact('‹0›');

-- Test 625: query (line 4250)
SELECT crdb_internal.redact('‹‹0››');

-- Test 626: query (line 4255)
SELECT crdb_internal.redact('‹0› ‹0›');

-- Test 627: query (line 4260)
SELECT crdb_internal.redact('‹‹0›');

-- Test 628: query (line 4270)
SELECT crdb_internal.redact(ARRAY[NULL]);

-- Test 629: query (line 4275)
SELECT crdb_internal.redact(ARRAY['']);

-- Test 630: query (line 4280)
SELECT crdb_internal.redact(ARRAY['‹0›', '', NULL, '‹0› ‹0›', '‹0']);

-- Test 631: query (line 4285)
SELECT crdb_internal.redact(crdb_internal.redactable_sql_constants('SELECT 1, 2, 3'));

-- Test 632: query (line 4290)
SELECT crdb_internal.redact(crdb_internal.redactable_sql_constants(ARRAY['SELECT 1', NULL, 'SELECT ''hello''', '']));

-- Test 633: statement (line 4320)
CREATE TABLE conscheckresult AS (SELECT * FROM crdb_internal.check_consistency(false, '', ''));

-- Test 634: query (line 4327)
SELECT crdb_internal.merge_aggregated_stmt_metadata(ARRAY[ '{ "db": [ "defaultdb", "movr" ], "distSQLCount": 1, "fullScanCount": 0, "implicitTxn": true, "query": "SELECT 1", "querySummary": "SELECT 1", "stmtType": "TypeDML", "totalCount": 33, "vecCount": 0 }'::JSON, '{ "db": ["tpcc"], "distSQLCount": 1, "fullScanCount": 0, "implicitTxn": true, "query": "SELECT 1", "querySummary": "SELECT 1", "stmtType": "TypeDML", "totalCount": 85, "vecCount": 2 }'::JSON ]);

-- Test 635: query (line 4332)
SELECT crdb_internal.merge_aggregated_stmt_metadata(ARRAY[]);

-- Test 636: query (line 4337)
SELECT crdb_internal.merge_aggregated_stmt_metadata(ARRAY[ '{ "db": [ "defaultdb", "tpcc" ], "distSQLCount": 1, "fullScanCount": 0, "implicitTxn": true, "query": "SELECT 1", "querySummary": "SELECT 1", "stmtType": "TypeDML", "totalCount": 33, "vecCount": 0 }'::JSON, '{ "db": ["tpcc"], "distSQLCount": 23, "fullScanCount": 99, "implicitTxn": true, "query": "SELECT 1", "querySummary": "SELECT 1", "stmtType": "TypeDML", "totalCount": 3, "vecCount": 2 }'::JSON, '{"hello": "world"}'::JSON ]);

-- Test 637: query (line 4342)
SELECT crdb_internal.merge_aggregated_stmt_metadata(ARRAY[ '{"aMalformedMetadaObj": 123}'::JSON, '{"key": "value"}'::JSON ]);

-- Test 638: query (line 4348)
SELECT crdb_internal.merge_aggregated_stmt_metadata(ARRAY[ '{"distSQLCount": 111, "fullScanCount": 333 }'::JSON, '{"totalCount": 1, "vecCount": 2}'::JSON, '{"key": "value"}'::JSON ]);

-- Test 639: query (line 4356)
SELECT bitmask_or('1010010', '0101');

-- Test 640: query (line 4361)
SELECT bitmask_or('1010010'::bit(7), '0101'::bit(4));

-- Test 641: query (line 4366)
SELECT bitmask_or('1010010'::bit(7), '0101');

-- Test 642: query (line 4371)
SELECT bitmask_or('1010010', '0101'::bit(4));

-- Test 643: query (line 4376)
SELECT bitmask_or('1010010'::varbit, '0101'::varbit);

-- Test 644: query (line 4382)
SELECT bitmask_and('1010010', '0101');

-- Test 645: query (line 4387)
SELECT bitmask_and('1010010'::bit(7), '0101'::bit(4));

-- Test 646: query (line 4392)
SELECT bitmask_and('1010010'::bit(7), '0101');

-- Test 647: query (line 4397)
SELECT bitmask_and('1010010', '0101'::bit(4));

-- Test 648: query (line 4402)
SELECT bitmask_and('1010010'::varbit, '0101'::varbit);

-- Test 649: query (line 4408)
SELECT bitmask_xor('1010010', '0101');

-- Test 650: query (line 4413)
SELECT bitmask_xor('1010010'::bit(7), '0101'::bit(4));

-- Test 651: query (line 4418)
SELECT bitmask_xor('1010010'::bit(7), '0101');

-- Test 652: query (line 4423)
SELECT bitmask_xor('1010010', '0101'::bit(4));

-- Test 653: query (line 4428)
SELECT bitmask_xor('1010010'::varbit, '0101'::varbit);

-- Test 654: statement (line 4434)
SELECT bitmask_or('not binary', '111');

-- Test 655: statement (line 4437)
SELECT bitmask_or('111', 'not binary');

-- Test 656: statement (line 4440)
SELECT bitmask_and('not binary', '111');

-- Test 657: statement (line 4443)
SELECT bitmask_and('111', 'not binary');

-- Test 658: statement (line 4446)
SELECT bitmask_xor('not binary', '111');

-- Test 659: statement (line 4449)
SELECT bitmask_xor('111', 'not binary');

-- Test 660: query (line 4453)
SELECT bitmask_or('xfe8c', '1111');

-- Test 661: query (line 4458)
SELECT bitmask_and('1111', 'xfe8c');

-- Test 662: query (line 4463)
SELECT bitmask_xor('xfe8c', '1111');

-- Test 663: query (line 4469)
SELECT bitmask_or('xffffffffffffffffff', '010');

-- Test 664: query (line 4474)
SELECT bitmask_and('xffffffffffffffffff', '010');

-- Test 665: query (line 4479)
SELECT bitmask_xor('xffffffffffffffffff', '010');

-- Test 666: query (line 4516)
SELECT oidvectortypes(proargtypes) FROM pg_proc WHERE oid=263;

-- Test 667: statement (line 4522)
CREATE TYPE custom_typ AS ENUM ('good', 'bad');
CREATE OR REPLACE FUNCTION custom_fn(c custom_typ) RETURNS custom_typ AS 'SELECT c' LANGUAGE SQL;

-- Test 668: query (line 4526)
SELECT oidvectortypes(proargtypes) FROM pg_proc WHERE proname='custom_fn';

-- Test 669: statement (line 4534)
CREATE TYPE roach_dwellings AS ENUM ('roach_motel','roach_kitchen','roach_bathroom','roach_house');

-- skipif config local-legacy-schema-changer

-- Test 670: statement (line 4538)
COMMENT ON TYPE roach_dwellings IS 'roach_penthouse coming soon';

-- Test 671: query (line 4543)
SELECT n.nspname AS "Schema",
         pg_catalog.format_type(t.oid, NULL) AS "Name",
         COALESCE(pg_catalog.obj_description(t.oid, 'pg_type'),'') AS "Description"
    FROM pg_catalog.pg_type t
LEFT JOIN pg_catalog.pg_namespace n ON n.oid = t.typnamespace
   WHERE (t.typrelid = 0
         OR (SELECT c.relkind = 'c'
               FROM pg_catalog.pg_class c
              WHERE c.oid = t.typrelid))
     AND (NOT EXISTS(
         SELECT 1
           FROM pg_catalog.pg_type el
          WHERE el.oid = t.typelem AND el.typarray = t.oid))
     AND n.nspname !~ '^pg_'
     AND n.nspname <> 'information_schema'
     AND n.nspname <> 'crdb_internal'
     AND pg_catalog.pg_type_is_visible(t.oid)
ORDER BY 1, 2;

-- Test 672: query (line 4574)
SELECT crdb_internal.type_is_indexable(23);

-- Test 673: query (line 4580)
SELECT crdb_internal.type_is_indexable(1790);

-- Test 674: statement (line 4585)
CREATE TYPE foo_type AS ENUM ('v1', 'v2', 'v3');

-- Test 675: query (line 4588)
SELECT crdb_internal.type_is_indexable((SELECT oid FROM pg_type WHERE typname = 'foo_type'));

-- Test 676: query (line 4593)
SELECT crdb_internal.type_is_indexable(NULL);

-- Test 677: query (line 4601)
SELECT substring_index('www.cockroachlabs.com', '.', 2);

-- Test 678: query (line 4606)
SELECT substring_index('www.cockroachlabs.com', '.', -2);

-- Test 679: query (line 4611)
SELECT substring_index('hello.world.example.com', '.', 3);

-- Test 680: query (line 4616)
SELECT substring_index('hello.world.example.com', '.', -1);

-- Test 681: query (line 4622)
SELECT substring_index('111-22222-3333', '-', 0);

-- Test 682: query (line 4628)
SELECT substring_index('example.com', '.', 5);

-- Test 683: query (line 4633)
SELECT substring_index('example.com', '.', -5);

-- Test 684: query (line 4639)
SELECT substring_index('no.delimiters.here', ':', 1);

-- Test 685: query (line 4644)
SELECT substring_index('singleword', '.', 1);

-- Test 686: query (line 4650)
SELECT substring_index('', '.', 1);

-- Test 687: query (line 4657)
SELECT substring_index('teststring', '', 1);

-- Test 688: query (line 4663)
SELECT substring_index(NULL, '.', 1);

-- Test 689: query (line 4679)
SELECT substring_index('apple--banana--cherry--date', '--', 2);

-- Test 690: query (line 4684)
SELECT substring_index('apple--banana--cherry--date', '--', -2);

-- Test 691: query (line 4690)
SELECT substring_index('a..b..c..d', '..', 2);

-- Test 692: query (line 4695)
SELECT substring_index('a..b..c..d', '..', -2);

-- Test 693: query (line 4701)
SELECT substring_index('a..b..c..d', '..', -9223372036854775808);

-- Test 694: query (line 4706)
SELECT substring_index('a..b..c..d', '..', -9223372036854775807);

-- Test 695: query (line 4711)
SELECT substring_index('a..b..c..d', '..', 9223372036854775807);
