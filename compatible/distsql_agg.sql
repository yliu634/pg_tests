-- PostgreSQL compatible tests from distsql_agg
-- 87 tests

SET client_min_messages = warning;
DROP TABLE IF EXISTS data CASCADE;
DROP TABLE IF EXISTS one CASCADE;
DROP TABLE IF EXISTS two CASCADE;
DROP TABLE IF EXISTS nullables CASCADE;
DROP TABLE IF EXISTS sorted_data CASCADE;
DROP TABLE IF EXISTS statistics_agg_test CASCADE;
DROP TABLE IF EXISTS uv CASCADE;
DROP TABLE IF EXISTS t55837 CASCADE;
DROP TABLE IF EXISTS table58683_1 CASCADE;
DROP TABLE IF EXISTS table58683_2 CASCADE;
DROP TABLE IF EXISTS table74736 CASCADE;
DROP TABLE IF EXISTS t108901 CASCADE;
DROP TABLE IF EXISTS t109334 CASCADE;
RESET client_min_messages;

-- Test 1: statement (line 3)
CREATE TABLE data (a INT, b INT, c FLOAT, d DECIMAL, PRIMARY KEY (a, b, c, d));

-- Test 2: statement (line 17)
INSERT INTO data SELECT a, b, c::FLOAT, d::DECIMAL FROM
   generate_series(1, 10) AS a(a),
   generate_series(1, 10) AS b(b),
   generate_series(1, 10) AS c(c),
   generate_series(1, 10) AS d(d);

-- Test 3: query (line 41)
SELECT sum(a), sum(a) FROM data;

-- Test 4: query (line 46)
SELECT sum((a-1)*1000 + (b-1)*100 + (c::INT-1)*10 + (d-1)) FROM data;

-- Test 5: query (line 51)
SELECT sum((a-1)*1000 + (b-1)*100 + (c::INT-1)*10 + (d::INT-1)) FROM data;

-- Test 6: query (line 56)
SELECT sum(a), sum(a), count(a), max(a) FROM data;

-- Test 7: query (line 61)
SELECT sum(a+b), sum(a+b), count(a+b), max(a+b) FROM data;

-- Test 8: query (line 66)
SELECT sum((a-1)*1000) + sum((b-1)*100) + sum((c::INT-1)*10) + sum(d-1) FROM data;

-- Test 9: query (line 71)
SELECT sum((a-1)*1000) + sum((b-1)*100) + sum((c::INT-1)*10) + sum(d::INT-1) FROM data;

-- Test 10: query (line 76)
SELECT sum(a), min(b), max(c), count(d) FROM data;

-- Test 11: query (line 81)
SELECT avg(a+b+c::INT+d) FROM data;

-- Test 12: query (line 86)
SELECT sum(a), round(stddev(b), 1), round(stddev_pop(b), 1) FROM data;

-- Test 13: query (line 91)
SELECT sum(a), round(variance(b), 1), round(var_pop(b), 1) FROM data;

-- Test 14: query (line 96)
SELECT stddev(a+b+c::INT+d), stddev_pop(a+b+c::INT+d) FROM data;

-- Test 15: query (line 101)
SELECT variance(a+b+c::INT+d), var_pop(a+b+c::INT+d) FROM data;

-- Test 16: query (line 106)
SELECT sum(a), sum(a), avg(b), sum(c), avg(d), stddev(a), stddev_pop(a), variance(b), var_pop(b), sum(a+b+c::INT+d) FROM data;

-- Test 17: query (line 111)
SELECT sum(a), min(b), max(c), count(d), avg(a+b+c::INT+d), stddev(a+b), stddev_pop(a+b), variance(c::INT+d), var_pop(c::INT+d) FROM data;

-- Test 18: query (line 116)
SELECT sum(a), stddev(a), stddev_pop(a), avg(a) FILTER (WHERE a > 5), count(b), avg(b), variance(b), var_pop(b) FILTER (WHERE b < 8), sum(b) FILTER (WHERE b < 8), stddev(b) FILTER (WHERE b > 2) FROM data;

-- Test 19: query (line 121)
SELECT sum(a), avg(DISTINCT a), variance(a) FILTER (WHERE a > 0) FROM data;

-- Test 20: query (line 126)
SELECT sum(a), avg(a), count(a), stddev(a), variance(a) FROM data;

-- Test 21: query (line 131)
SELECT sum(a), avg(b), sum(a), sum(a), avg(b) FROM data;

-- Test 22: query (line 136)
SELECT avg(c), sum(c), sum(c::INT), avg(d), sum(d) FROM data;

-- Test 23: query (line 141)
SELECT max(a), min(b) FROM data HAVING min(b) > 2;

-- Test 24: query (line 146)
SELECT DISTINCT (a) FROM data;

-- Test 25: query (line 160)
SELECT sum(DISTINCT a), sum(DISTINCT a) FROM data;

-- Test 26: query (line 165)
SELECT sum(DISTINCT a), sum(DISTINCT a), sum(DISTINCT b), sum(DISTINCT b) from data;

-- Test 27: query (line 170)
SELECT DISTINCT a, b FROM data WHERE (a + b + c::INT) = 27 ORDER BY a,b;

-- Test 28: query (line 184)
SELECT DISTINCT a, b FROM data WHERE (a + b + c::INT) = 27 ORDER BY b,a;

-- Test 29: query (line 198)
SELECT c, d, sum(a+c::INT) + avg(b+d), sum(a+c::INT) + avg(b+d)::INT FROM data GROUP BY c, d ORDER BY c, d;

-- Test 30: statement (line 303)
CREATE TABLE one (k INT PRIMARY KEY, v INT);

-- Test 31: statement (line 313)
INSERT INTO one VALUES (1,1), (2,2), (3,3), (4,4), (5,5), (6,6), (7,7), (8,8), (9,9), (10,10);

-- Test 32: statement (line 316)
CREATE TABLE two (k INT PRIMARY KEY, v INT);

-- Test 33: statement (line 326)
INSERT INTO two VALUES (1,1), (2,2), (3,3), (4,4), (5,5), (6,6), (7,7), (8,8), (9,9), (10,10);

-- Test 34: query (line 345)
SELECT count(*) FROM one AS a, one AS b, two AS c;

-- Test 35: query (line 350)
SELECT sum(a), sum(b), sum(c) FROM data GROUP BY d HAVING sum(a+b) > 10;

-- Test 36: query (line 365)
SELECT avg(a+b), c FROM data GROUP BY c, d HAVING c = d;

-- Test 37: query (line 379)
SELECT sum(a+b), sum(a+b) FILTER (WHERE a < d), sum(a+b) FILTER (WHERE a < d), sum(a+b) FILTER (WHERE a = c) FROM data GROUP BY d;

-- Test 38: query (line 394)
SELECT sum(a+b), sum(a+b) FILTER (WHERE a < d), sum(a+b) FILTER (WHERE a < d), sum(a+b) FILTER (WHERE a = c) FROM data WHERE a = 1 GROUP BY d;

-- Test 39: query (line 408)
VALUES (1, 2, 1.0, 'string1'), (4, 3, 2.3, 'string2');

-- Test 40: query (line 414)
SELECT max(t.a), min(t.b), avg(t.c) FROM (VALUES (1, 2, 3), (4, 5, 6), (7, 8, 0)) AS t(a, b, c) WHERE b > 3;

-- Test 41: query (line 419)
SELECT * FROM (VALUES (1, '222'), (2, '444')) t1(a,b) JOIN (VALUES (1, 100.0), (3, 32.0)) t2(a,b) ON t1.a = t2.a;

-- Test 42: statement (line 424)
CREATE TABLE nullables (a INT, b INT, c INT, PRIMARY KEY (a));

-- Test 43: statement (line 427)
INSERT INTO nullables VALUES (1,1,1);

-- Test 44: statement (line 430)
INSERT INTO nullables VALUES (2,NULL,1);

-- Test 45: query (line 433)
SELECT c, count(*) FROM nullables GROUP BY c;

-- Test 46: query (line 438)
SELECT array_agg(a) FROM (SELECT a FROM data WHERE b = 1 AND c = 1.0 AND d = 1.0 ORDER BY a) s;

-- Test 47: query (line 443)
SELECT array_agg(ab) FROM (SELECT a*b AS ab FROM data WHERE c = 1.0 AND d = 1.0 ORDER BY a*b) s;

-- Test 48: query (line 448)
SELECT json_agg(a) FROM (SELECT a FROM data WHERE b = 1 AND c = 1.0 AND d = 1.0 ORDER BY a) s;

-- Test 49: query (line 453)
SELECT jsonb_agg(a) FROM (SELECT a FROM data WHERE b = 1 AND c = 1.0 AND d = 1.0 ORDER BY a) s;

-- Test 50: statement (line 459)
CREATE TABLE sorted_data (a INT PRIMARY KEY, b INT, c FLOAT);
CREATE INDEX foo ON sorted_data(b);

-- Test 51: statement (line 462)
INSERT INTO sorted_data VALUES
(1, 4, 5.0),
(2, 3, 3.4),
(3, 9, 2.2),
(4, 13, 1.99),
(5, 2, 5.7),
(6, 7, 6.2),
(7, 9, 8.9),
(8, 1, 1.22),
(9, -2, 23.0),
(10, 100, -3.1);

-- Test 52: query (line 487)
SELECT a, max(b) FROM sorted_data GROUP BY a;

-- Test 53: query (line 503)
SELECT a, max(b) FROM sorted_data GROUP BY a ORDER BY a;

-- Test 54: query (line 519)
SELECT c, min(b), a FROM sorted_data GROUP BY a, c;

-- Test 55: query (line 535)
SELECT c, min(b), a FROM sorted_data GROUP BY a, c ORDER BY a;

-- Test 56: query (line 551)
-- SELECT b, max(c) FROM sorted_data@foo GROUP BY b;
SELECT b, max(c) FROM sorted_data GROUP BY b;

-- Test 57: query (line 567)
-- SELECT * FROM (SELECT a, max(c) FROM sorted_data GROUP BY a) JOIN (SELECT b, min(c) FROM sorted_data@foo GROUP BY b) ON a = b;
SELECT * FROM (SELECT a, max(c) FROM sorted_data GROUP BY a) s1 JOIN (SELECT b, min(c) FROM sorted_data GROUP BY b) s2 ON a = b;

-- Test 58: query (line 578)
SELECT sum(a) FROM data WHERE FALSE;

-- Test 59: statement (line 584)
CREATE TABLE statistics_agg_test (y INT, x INT);

-- Test 60: statement (line 587)
INSERT INTO statistics_agg_test SELECT y, y%10 FROM generate_series(1, 100) AS y;

-- Test 61: query (line 590)
SELECT corr(y, x)::decimal, covar_pop(y, x)::decimal, covar_samp(y, x)::decimal FROM statistics_agg_test;

-- Test 62: query (line 595)
SELECT regr_intercept(y, x), regr_r2(y, x), regr_slope(y, x) FROM statistics_agg_test;

-- Test 63: query (line 600)
SELECT regr_sxx(y, x), regr_sxy(y, x), regr_syy(y, x) FROM statistics_agg_test;

-- Test 64: query (line 605)
-- SELECT regr_count(y, x), sqrdiff(y) FROM statistics_agg_test;
SELECT regr_count(y, x), variance(y) FROM statistics_agg_test;

-- Test 65: query (line 610)
SELECT regr_avgx(y, x), regr_avgy(y, x) FROM statistics_agg_test;

-- Test 66: query (line 626)
SELECT corr(y, x)::decimal, covar_pop(y, x)::decimal, covar_samp(y, x)::decimal FROM statistics_agg_test;

-- Test 67: query (line 631)
SELECT regr_intercept(y, x), regr_r2(y, x), regr_slope(y, x) FROM statistics_agg_test;

-- Test 68: query (line 636)
SELECT regr_sxx(y, x), regr_sxy(y, x), regr_syy(y, x) FROM statistics_agg_test;

-- Test 69: query (line 641)
-- SELECT regr_count(y, x), sqrdiff(y) FROM statistics_agg_test;
SELECT regr_count(y, x), variance(y) FROM statistics_agg_test;

-- Test 70: query (line 646)
SELECT regr_avgx(y, x), regr_avgy(y, x) FROM statistics_agg_test;

-- Test 71: statement (line 652)
CREATE TABLE uv (u INT PRIMARY KEY, v INT);
INSERT INTO uv SELECT x, x*10 FROM generate_series(2, 8) AS g(x);

-- Test 72: query (line 656)
-- SELECT sum(v) FROM data INNER LOOKUP JOIN uv ON (a=u) GROUP BY u ORDER BY u;
SELECT sum(v) FROM data INNER JOIN uv ON (a=u) GROUP BY u ORDER BY u;

-- Test 73: statement (line 684)
CREATE TABLE t55837(y INT, x INT);
INSERT INTO t55837 VALUES (1,1);
SELECT * FROM t55837; -- make sure that the range cache is populated

-- Test 74: query (line 688)
SELECT corr(DISTINCT y, x), count(y) FROM t55837;

-- Test 75: statement (line 704)
CREATE TABLE table58683_1 (col1 INT);
CREATE TABLE table58683_2 (col2 BOOL);

-- Test 76: statement (line 711)
-- SELECT every(col2) FROM table58683_1 JOIN table58683_2 ON col1 = (table58683_2.tableoid)::INT8 GROUP BY col2 HAVING bool_and(col2);

-- Test 77: statement (line 726)
CREATE TABLE table74736 (k INT, blob TEXT);
INSERT INTO table74736 SELECT x * 10000, repeat('a', 200000) FROM generate_series(1, 130) AS g(x);

-- Test 78: statement (line 736)
-- SET DISTSQL = OFF;

-- Test 79: query (line 739)
SELECT count(*), sum(length(blob)) FROM table74736 WHERE (k >= 1 AND k <= 900000) OR k = 1200000 OR k = 1250000;

-- Test 80: statement (line 744)
-- SET DISTSQL = ON;

-- Test 81: statement (line 757)
-- SET disable_optimizer_rules = PruneWindowOutputCols;

-- Test 82: statement (line 760)
CREATE TABLE t108901(x INT);
INSERT INTO t108901 VALUES (1);
-- SELECT 1 FROM t108901 WHERE
--   EXISTS(
--     SELECT regr_slope(1.2345678901234562e+27:::FLOAT8::INT8,0.968018273253753:::FLOAT8::DECIMAL) OVER ()::FLOAT8
--     FROM t108901
--   );

-- Test 83: statement (line 767)
-- RESET testing_optimizer_random_seed;
-- RESET testing_optimizer_disable_rule_probability;

-- Test 84: statement (line 775)
CREATE TABLE IF NOT EXISTS t109334 AS
        SELECT
                1.7976931348623157e+308::FLOAT8 AS _float8,
                1::FLOAT8 AS grouping_col
        FROM
                generate_series(1, 1) AS g;

-- Test 85: query (line 790)
SELECT
        _float8,
        var_pop(_float8::FLOAT8)::FLOAT8,
        count(*)
FROM
        t109334
GROUP BY
        _float8;

-- Test 86: statement (line 802)
INSERT INTO t109334 SELECT g*1.23456789, 2::FLOAT8 FROM generate_series(1, 50) AS g;

-- Test 87: query (line 816)
SELECT
        var_pop(_float8::FLOAT8)::FLOAT8,
        count(*)
FROM
        t109334
GROUP BY
        grouping_col;
