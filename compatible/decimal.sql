-- PostgreSQL compatible tests from decimal
-- 78 tests

-- Test 1: query (line 10)
SELECT (1.4238790346995263e-40::DECIMAL / 6.011482313728436e+41::DECIMAL)

-- Test 2: query (line 16)
SELECT ln(7.682705743584112e-48::DECIMAL)

-- Test 3: query (line 22)
SELECT sqrt(9.789765531128956e-34::DECIMAL)

-- Test 4: query (line 28)
SELECT pow(4.727998800941528e-14::DECIMAL, 0.06081860494226844::DECIMAL)

-- Test 5: query (line 34)
SELECT pow(sqrt(1e-10::DECIMAL), 2), sqrt(pow(1e-5::DECIMAL, 2))

-- Test 6: query (line 40)
SELECT 1e-16::DECIMAL / 2, 1e-16::DECIMAL / 3, 1e-16::DECIMAL / 2 * 2

-- Test 7: query (line 46)
SELECT pow(1e-4::DECIMAL, 2), pow(1e-5::DECIMAL, 2), pow(1e-8::DECIMAL, 2), pow(1e-9::DECIMAL, 2)

-- Test 8: query (line 52)
SELECT pow(1e-10::DECIMAL, 2)

-- Test 9: query (line 58)
SELECT 'NaN'::FLOAT::DECIMAL, 'NaN'::DECIMAL

-- Test 10: query (line 64)
SELECT '0'::decimal(19,9)

-- Test 11: statement (line 72)
CREATE TABLE t (d decimal, v decimal(3, 1))

-- Test 12: statement (line 75)
INSERT INTO t VALUES (0.000::decimal, 0.00::decimal), (1.00::decimal, 1.00::decimal), (2.0::decimal, 2.0::decimal), (3::decimal, 3::decimal)

-- Test 13: query (line 78)
SELECT * FROM t ORDER BY d

-- Test 14: statement (line 88)
CREATE TABLE t2 (d decimal, v decimal(3, 1), primary key (d, v))

-- Test 15: statement (line 91)
INSERT INTO t2 VALUES
  (1.00::decimal, 1.00::decimal),
  (2.0::decimal, 2.0::decimal),
  (3::decimal, 3::decimal),
  ('NaN'::decimal, 'NaN'::decimal),
  ('Inf'::decimal, 'Inf'::decimal),
  ('-Inf'::decimal, '-Inf'::decimal),
  ('-0.0000'::decimal, '-0.0000'::decimal)

-- Test 16: query (line 101)
SELECT * FROM t2 ORDER BY d

-- Test 17: statement (line 114)
INSERT INTO t2 VALUES ('-NaN'::decimal, '-NaN'::decimal)

-- Test 18: statement (line 117)
INSERT INTO t2 VALUES (0, 0)

-- Test 19: query (line 122)
SELECT 'NaN'::decimal, '-NaN'::decimal, 'sNaN'::decimal, '-sNaN'::decimal

-- Test 20: query (line 127)
SELECT * FROM t2 WHERE d IS NaN and v IS NaN

-- Test 21: query (line 132)
SELECT * FROM t2 WHERE d = 'Infinity' and v = 'Infinity'

-- Test 22: query (line 137)
SELECT * FROM t2 WHERE d = '-Infinity' and v = '-Infinity'

-- Test 23: statement (line 144)
CREATE TABLE s (d decimal null, index (d))

-- Test 24: statement (line 147)
INSERT INTO s VALUES
  (null),
  ('NaN'::decimal),
  ('-NaN'::decimal),
  ('Inf'::decimal),
  ('-Inf'::decimal),
  ('0'::decimal),
  (1),
  (-1)

-- Test 25: statement (line 158)
INSERT INTO s VALUES
  ('-0'::decimal),
  ('-0.0'::decimal),
  ('-0.00'::decimal),
  ('-0.00E-1'::decimal),
  ('-0.0E-3'::decimal)

-- Test 26: query (line 166)
SELECT * FROM s WHERE d = 0

-- Test 27: query (line 176)
SELECT * FROM s WHERE d IS NAN

-- Test 28: query (line 182)
SELECT * FROM s WHERE d = 'inf'::decimal

-- Test 29: query (line 187)
SELECT * FROM s WHERE d = 'NaN'

-- Test 30: query (line 197)
SELECT d FROM s ORDER BY d, d::TEXT

-- Test 31: statement (line 279)
CREATE INDEX idx ON s (d)

-- Test 32: query (line 282)
SELECT * FROM s@idx WHERE d = 0

-- Test 33: statement (line 292)
INSERT INTO s VALUES
  ('10'::decimal),
  ('10.0'::decimal),
  ('10.00'::decimal),
  ('10.000'::decimal),
  ('100000E-4'::decimal),
  ('1000000E-5'::decimal),
  ('1.0000000E+1'::decimal)

-- Test 34: query (line 302)
SELECT * FROM s@s_pkey WHERE d = 10

-- Test 35: query (line 313)
SELECT * FROM s@idx WHERE d = 10

-- Test 36: query (line 324)
SELECT 1.00::decimal(6,4)

-- Test 37: statement (line 329)
SELECT 101.00::decimal(6,4)

-- Test 38: statement (line 332)
SELECT 101.00::decimal(4,6)

-- Test 39: statement (line 335)
SELECT 1::decimal(2, 2)

-- Test 40: query (line 346)
SELECT * FROM a

-- Test 41: query (line 352)
SELECT 'inf'::decimal + '-inf'::decimal

-- Test 42: query (line 358)
SELECT 1.0 / 'Infinity' + 2 FROM a;

-- Test 43: query (line 363)
SELECT 2.000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

-- Test 44: query (line 371)
SELECT var_pop('inf'::numeric), var_samp('inf'::numeric)

-- Test 45: query (line 376)
SELECT stddev_pop('inf'::numeric), stddev_samp('inf'::numeric)

-- Test 46: query (line 381)
SELECT sum(x::numeric), avg(x::numeric), var_pop(x::numeric)
FROM (VALUES ('1'), ('infinity')) v(x)

-- Test 47: query (line 387)
SELECT sum(x::numeric), avg(x::numeric), var_pop(x::numeric)
FROM (VALUES ('infinity'), ('1')) v(x)

-- Test 48: query (line 393)
SELECT sum(x::numeric), avg(x::numeric), var_pop(x::numeric)
FROM (VALUES ('infinity'), ('infinity')) v(x)

-- Test 49: query (line 399)
SELECT sum(x::numeric), avg(x::numeric), var_pop(x::numeric)
FROM (VALUES ('-infinity'), ('infinity')) v(x)

-- Test 50: query (line 405)
SELECT sum(x::numeric), avg(x::numeric), var_pop(x::numeric)
FROM (VALUES ('-infinity'), ('-infinity')) v(x)

-- Test 51: query (line 411)
WITH v(x) AS
  (VALUES('0'::numeric),('1'::numeric),('-1'::numeric),('4.2'::numeric),('inf'::numeric),('-inf'::numeric),('nan'::numeric))
SELECT x1, x2,
  x1 + x2 AS sum,
  x1 - x2 AS diff,
  x1 * x2 AS prod
FROM v AS v1(x1), v AS v2(x2)

-- Test 52: query (line 472)
WITH v(id, x) AS (VALUES (1, '0'::numeric), (2, '1'::numeric), (3, '-1'::numeric),
  (4, '4.2'::numeric), (5, 'inf'::numeric), (6, '-inf'::numeric), (7, 'nan'::numeric)
)
SELECT x1, x2,
  x1 / x2 AS quot,
  x1 % x2 AS mod,
  div(x1, x2) AS div
FROM v AS v1(id1, x1), v AS v2(id2, x2) WHERE x2 != 0
ORDER BY id1, id2

-- Test 53: statement (line 526)
SELECT 'inf'::numeric / '0'

-- Test 54: statement (line 529)
SELECT '-inf'::numeric / '0'

-- Test 55: query (line 533)
SELECT 'NaN'::DECIMAL / 0::DECIMAL;

-- Test 56: query (line 538)
SELECT 'Infinity'::float8::numeric

-- Test 57: query (line 543)
SELECT '-Infinity'::float8::numeric

-- Test 58: query (line 548)
SELECT 'NaN'::numeric::float8

-- Test 59: query (line 553)
SELECT 'Infinity'::numeric::float8

-- Test 60: query (line 558)
SELECT '-Infinity'::numeric::float8

-- Test 61: statement (line 563)
SELECT 'NaN'::numeric::int2

-- Test 62: statement (line 566)
SELECT '-Infinity'::numeric::int8

-- Test 63: query (line 569)
SELECT width_bucket('inf', 3.0, 4.0, 888)

-- Test 64: statement (line 574)
SELECT width_bucket(2.0, 3.0, '-inf', 888)

-- Test 65: statement (line 577)
SELECT width_bucket(0, '-inf', 4.0, 888)

-- Test 66: query (line 580)
select exp('nan'::numeric), exp('inf'::numeric), exp('-inf'::numeric)

-- Test 67: query (line 585)
WITH v(x) AS
(VALUES (' inf '), (' +inf '), (' -inf '), (' Infinity '), (' +inFinity '), (' -INFINITY '))
SELECT x1::decimal
FROM v AS v1(x1)

-- Test 68: statement (line 598)
CREATE TABLE t71926(no_typmod decimal, precision decimal(5), precision_and_width decimal(5,3))

-- Test 69: query (line 601)
SELECT attname, atttypmod FROM pg_attribute WHERE attrelid = 't71926'::regclass::oid AND atttypid = 'decimal'::regtype::oid

-- Test 70: statement (line 609)
CREATE TABLE t86790 (x INT8 NOT NULL)

-- Test 71: statement (line 612)
INSERT INTO t86790 VALUES (-4429772553778622992)

-- Test 72: query (line 615)
SELECT (x / 1)::DECIMAL FROM t86790

-- Test 73: statement (line 620)
SET testing_optimizer_disable_rule_probability = 1

-- Test 74: query (line 624)
SELECT (x / 1)::DECIMAL FROM t86790

-- Test 75: statement (line 629)
RESET testing_optimizer_disable_rule_probability

-- Test 76: statement (line 634)
CREATE TABLE regression_40929 AS SELECT g FROM (VALUES (1)) AS v(g);

-- Test 77: query (line 637)
SELECT
g,
0 / '-Infinity'::DECIMAL,
0 / 'Infinity'::DECIMAL,
1 / '-Infinity'::DECIMAL,
1 / 'Infinity'::DECIMAL
FROM regression_40929

-- Test 78: query (line 648)
SELECT 0::DECIMAL / 'infinity'::DECIMAL;

