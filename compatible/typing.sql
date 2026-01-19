-- PostgreSQL compatible tests from typing
-- 111 tests

-- Test 1: statement (line 2)
CREATE TABLE f (x FLOAT)

-- Test 2: statement (line 5)
INSERT INTO f(x) VALUES (3/2), (1)

-- Test 3: query (line 8)
SELECT * FROM f

-- Test 4: statement (line 14)
CREATE TABLE i (x INT)

-- Test 5: statement (line 17)
INSERT INTO i(x) VALUES ('1970-01-01'::timestamptz)

-- Test 6: statement (line 20)
INSERT INTO i(x) VALUES (2.0)

-- Test 7: statement (line 23)
INSERT INTO i(x) VALUES (9223372036854775809)

-- Test 8: query (line 26)
SELECT * FROM i

-- Test 9: statement (line 31)
CREATE TABLE d (x DECIMAL)

-- Test 10: statement (line 34)
INSERT INTO d(x) VALUES (((9 / 3) * (1 / 3))), (2.0), (2.4 + 4.6)

-- Test 11: query (line 37)
SELECT * FROM d

-- Test 12: statement (line 44)
UPDATE d SET x = x + 1 WHERE x + sqrt(x) >= 2 + .1

-- Test 13: query (line 47)
SELECT * FROM d

-- Test 14: query (line 57)
SELECT * FROM s WHERE x > b'\x00'

-- Test 15: statement (line 61)
INSERT INTO s(x) VALUES (b'qwe'), ('start' || b'end')

-- Test 16: statement (line 64)
INSERT INTO s(x) VALUES (b'\xfffefd')

-- Test 17: query (line 67)
SELECT length(x), encode(x::bytes, 'escape') from s

-- Test 18: statement (line 74)
INSERT INTO s VALUES (COALESCE(1, 'foo'))

-- Test 19: statement (line 77)
INSERT INTO i VALUES (COALESCE(1, 'foo'))

-- Test 20: query (line 80)
SELECT COALESCE(1, 'foo')

query error incompatible COALESCE expressions: could not parse "foo" as type int
SELECT COALESCE(1::INT, 'foo')

query error expected 2.3 to be of type int, found type decimal
SELECT greatest(-1, 1, 2.3, 123456789, 3 + 5, -(-4))

query I
SELECT greatest(-1, 1, 2, 123456789, 3 + 5, -(-4))

-- Test 21: query (line 94)
SELECT greatest('2010-09-29', '2010-09-28'::TIMESTAMP)

-- Test 22: query (line 99)
SELECT greatest('PT12H2M', 'PT12H2M'::INTERVAL, '1s')

-- Test 23: query (line 104)
SELECT greatest(-1.123, 1.21313, 2.3, 123456789.321, 3 + 5.3213, -(-4.3213), abs(-9))

-- Test 24: statement (line 109)
CREATE TABLE untyped (b bool, n INT, f FLOAT, e DECIMAL, d DATE, ts TIMESTAMP, tz TIMESTAMPTZ, i INTERVAL)

-- Test 25: statement (line 112)
INSERT INTO untyped VALUES ('f', '42', '4.2', '4.20', '2010-09-28', '2010-09-28 12:00:00.1', '2010-09-29 12:00:00.1', 'PT12H2M')

-- Test 26: query (line 115)
SELECT * FROM untyped

-- Test 27: query (line 121)
SELECT ts FROM untyped WHERE ts != '2015-09-18 00:00:00'

-- Test 28: query (line 127)
SELECT 1::pg_catalog.int4, 1::pg_catalog.int8, 'aa'::pg_catalog.text, 4.2::pg_catalog.float4

-- Test 29: query (line 134)
SELECT VARCHAR(4) 'foo', CHAR(2) 'bar', STRING(1) 'cat'

-- Test 30: query (line 157)
SELECT 'foo'::BPCHAR != 'foo   '

-- Test 31: query (line 162)
SELECT 'foo'::BPCHAR >= 'foo   '

-- Test 32: query (line 167)
SELECT 'foo'::BPCHAR <= 'foo   '

-- Test 33: query (line 172)
SELECT 'foo'::BPCHAR > 'foo   '

-- Test 34: query (line 177)
SELECT 'foo'::BPCHAR < 'foo   '

-- Test 35: query (line 182)
SELECT 'foo'::BPCHAR IN ('foo   ')

-- Test 36: query (line 187)
SELECT 'foo'::BPCHAR IN ('foo   ', 'bar')

-- Test 37: query (line 194)
SELECT 'foo'::BPCHAR LIKE 'foo   '

-- Test 38: query (line 201)
SELECT 'foo'::BPCHAR ~ 'foo   '

-- Test 39: statement (line 206)
PREPARE p AS SELECT 'foo'::BPCHAR = $1

-- Test 40: query (line 209)
EXECUTE p('foo   ')

-- Test 41: statement (line 214)
DEALLOCATE p;
PREPARE p AS SELECT 'foo'::BPCHAR = $1

-- Test 42: query (line 218)
EXECUTE p('foo   ')

-- Test 43: query (line 223)
SELECT 'foo'::CHAR = 'f  '

-- Test 44: query (line 230)
SELECT 'foo'::CHAR = 'foo'

-- Test 45: query (line 235)
SELECT 'foo'::CHAR = 'foo  '

-- Test 46: statement (line 240)
CREATE TABLE chars (
  bp BPCHAR,
  c CHAR(20)
)

-- Test 47: statement (line 246)
INSERT INTO chars VALUES ('foo   ', 'bar    ');

-- Test 48: query (line 249)
SELECT bp, length(bp) FROM chars WHERE bp = 'foo   '

-- Test 49: statement (line 254)
DEALLOCATE p;
PREPARE p AS SELECT bp, length(bp) FROM chars WHERE bp = $1

-- Test 50: query (line 258)
EXECUTE p('foo   ')

-- Test 51: query (line 263)
SELECT c, length(c) FROM chars WHERE c = 'bar   '

-- Test 52: statement (line 268)
DEALLOCATE p;
PREPARE p AS SELECT c, length(c) FROM chars WHERE c = $1

-- Test 53: query (line 272)
EXECUTE p('bar   ')

-- Test 54: query (line 277)
SELECT ROW('foo'::BPCHAR) = ROW('foo   ')

-- Test 55: query (line 282)
SELECT bp = c FROM
  (VALUES ('foo'::BPCHAR)) v1(bp),
  (VALUES ('foo  ')) v2(c)

-- Test 56: statement (line 291)
CREATE TABLE t15050a (c DECIMAL DEFAULT CASE WHEN now() < 'Not Timestamp' THEN 2 ELSE 2 END);

-- Test 57: statement (line 294)
CREATE TABLE t15050b (c DECIMAL DEFAULT IF(now() < 'Not Timestamp', 2, 2));

-- Test 58: statement (line 299)
SELECT IFNULL('foo', false)

-- Test 59: statement (line 302)
SELECT IFNULL(true, 'foo')

-- Test 60: query (line 305)
SELECT IFNULL(false, 'true')

-- Test 61: query (line 310)
SELECT IFNULL('true', false)

-- Test 62: query (line 317)
SELECT 1 in (SELECT 1)

-- Test 63: statement (line 322)
SELECT 1 IN (SELECT 'a')

-- Test 64: statement (line 325)
SELECT 1 IN (SELECT (1, 2))

-- Test 65: query (line 328)
SELECT (1, 2) IN (SELECT 1, 2)

-- Test 66: query (line 333)
SELECT (1, 2) IN (SELECT (1, 2))

-- Test 67: statement (line 338)
CREATE TABLE t1 (a DATE)

-- Test 68: statement (line 341)
CREATE TABLE t2 (b TIMESTAMPTZ)

-- Test 69: statement (line 344)
INSERT INTO t1 VALUES (DATE '2018-01-01'); INSERT INTO t2 VALUES (TIMESTAMPTZ '2018-01-01');

-- Test 70: query (line 349)
SELECT * FROM t1, t2 WHERE a = b AND age(b, TIMESTAMPTZ '2017-01-01') > INTERVAL '1 day'

-- Test 71: query (line 356)
SELECT '' BETWEEN ''::BYTES AND '';

-- Test 72: query (line 362)
SELECT NULLIF(NULL, 0) + NULLIF(NULL, 0)

-- Test 73: query (line 367)
SELECT NULLIF(0, 0) + NULLIF(0, 0)

-- Test 74: query (line 372)
SELECT NULLIF(0, NULL) + NULLIF(0, NULL)

-- Test 75: query (line 378)
SELECT max(t0.c0) FROM (VALUES (NULL), (NULL)) t0(c0)

-- Test 76: query (line 383)
SELECT max(NULL) FROM (VALUES (NULL), (NULL)) t0(c0)

-- Test 77: query (line 389)
SELECT CASE WHEN true THEN 1234:::OID ELSE COALESCE(NULL, NULL) END

-- Test 78: query (line 395)
SELECT CASE WHEN x > 1 THEN true ELSE NULL AND true END FROM (VALUES (1), (2)) AS v(x)

-- Test 79: query (line 401)
SELECT CASE WHEN x > 1 THEN true ELSE NULL OR false END FROM (VALUES (1), (2)) AS v(x)

-- Test 80: query (line 407)
SELECT ARRAY[]::TIMESTAMPTZ[] >
       SOME (ARRAY[TIMESTAMPTZ '1969-12-29T21:20:13+01'], ARRAY[NULL])

-- Test 81: query (line 413)
SELECT ARRAY[]::TIMESTAMPTZ[] <
       SOME (ARRAY[TIMESTAMPTZ '1969-12-29T21:20:13+01'], ARRAY[NULL])

-- Test 82: statement (line 420)
CREATE TABLE t102110_1 (t TEXT);
INSERT INTO t102110_1 VALUES ('tt');

-- Test 83: statement (line 424)
CREATE TABLE t102110_2 (c CHAR);
INSERT INTO t102110_2 VALUES ('c');

-- Test 84: query (line 428)
SELECT t102110_1.t FROM t102110_1, t102110_2
WHERE t102110_1.t NOT BETWEEN t102110_1.t AND
  (CASE WHEN NULL THEN t102110_2.c ELSE t102110_1.t END);

-- Test 85: query (line 434)
SELECT t102110_1.t FROM t102110_1, t102110_2
WHERE t102110_1.t NOT BETWEEN t102110_1.t AND
  IF(NULL, t102110_2.c, t102110_1.t);

-- Test 86: statement (line 440)
CREATE TABLE t108360_1 (t TEXT);
INSERT INTO t108360_1 VALUES ('tt');

-- Test 87: statement (line 444)
CREATE TABLE t108360_2 (c CHAR);
INSERT INTO t108360_2 VALUES ('c');

-- Test 88: query (line 448)
SELECT (CASE WHEN t108360_1.t > t108360_2.c THEN t108360_1.t ELSE t108360_2.c END)
FROM t108360_1, t108360_2
WHERE t108360_1.t = (CASE WHEN t108360_1.t > t108360_2.c THEN t108360_1.t ELSE t108360_2.c END);

-- Test 89: statement (line 458)
CREATE TABLE t131346v (v VARBIT);
INSERT INTO t131346v VALUES ('11');

-- Test 90: statement (line 462)
CREATE TABLE t131346b (b BIT);
INSERT INTO t131346b VALUES ('0');

-- Test 91: query (line 466)
SELECT v FROM t131346v, t131346b
WHERE v NOT BETWEEN v AND
  (CASE WHEN NULL THEN '0'::BIT ELSE v END)

-- Test 92: query (line 472)
SELECT v FROM t131346v, t131346b
WHERE v NOT BETWEEN v AND
  (CASE WHEN NULL THEN b ELSE v END)

-- Test 93: query (line 478)
SELECT v FROM t131346v, t131346b
WHERE v NOT BETWEEN v AND
  IF(NULL, '0'::BIT, v);

-- Test 94: query (line 484)
SELECT v FROM t131346v, t131346b
WHERE v NOT BETWEEN v AND
  IF(NULL, b, v);

-- Test 95: query (line 490)
SELECT (CASE WHEN v > '0'::BIT THEN v ELSE '0'::BIT END)
FROM t131346v, t131346b
WHERE v = (CASE WHEN v > '0'::BIT THEN v ELSE '0'::BIT END)

-- Test 96: query (line 497)
SELECT (CASE WHEN v > b THEN v ELSE b END)
FROM t131346v, t131346b
WHERE v = (CASE WHEN v > b THEN v ELSE b END)

-- Test 97: query (line 504)
SELECT (CASE WHEN v > '0'::BIT THEN v ELSE '0'::BIT END)
FROM t131346v, t131346b
WHERE v = (CASE WHEN v < '0'::BIT THEN '0'::BIT ELSE v END)

-- Test 98: query (line 511)
SELECT (CASE WHEN v > b THEN v ELSE b END)
FROM t131346v, t131346b
WHERE v = (CASE WHEN v < b THEN b ELSE v END)

-- Test 99: statement (line 526)
SELECT * FROM t83496
WHERE (
  (SELECT 'bar':::typ83496 FROM t83496 WHERE false)
  IS NOT DISTINCT FROM CASE WHEN NULL THEN NULL ELSE NULL END
);

-- Test 100: statement (line 534)
CREATE TABLE t115054_1 (v varchar(2));

-- Test 101: statement (line 537)
INSERT INTO t115054_1 (v) VALUES ('c     ');

-- Test 102: statement (line 540)
INSERT INTO t115054_1 (v) VALUES (' c    ');

-- Test 103: statement (line 543)
INSERT INTO t115054_1 (v) VALUES ('cc    ');

-- Test 104: statement (line 546)
INSERT INTO t115054_1 (v) VALUES ('ccc   ');

-- Test 105: query (line 549)
SELECT json_agg(v ORDER BY v) FROM t115054_1

-- Test 106: statement (line 554)
CREATE TABLE t115054_2 (v varchar);

-- Test 107: statement (line 557)
INSERT INTO t115054_2 (v) VALUES ('c     ');

-- Test 108: statement (line 560)
INSERT INTO t115054_2 (v) VALUES (' c    ');

-- Test 109: statement (line 563)
INSERT INTO t115054_2 (v) VALUES ('cc    ');

-- Test 110: statement (line 566)
INSERT INTO t115054_2 (v) VALUES ('ccc   ');

-- Test 111: query (line 569)
SELECT json_agg(v ORDER BY v) FROM t115054_2

