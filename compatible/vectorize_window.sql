-- PostgreSQL compatible tests from vectorize_window
-- 34 tests

SET client_min_messages = warning;

DROP AGGREGATE IF EXISTS sum_int(integer);
CREATE AGGREGATE sum_int(integer) (
  SFUNC = int4_sum,
  STYPE = bigint,
  INITCOND = '0'
);

DROP AGGREGATE IF EXISTS concat_agg(text);
CREATE AGGREGATE concat_agg(text) (
  SFUNC = textcat,
  STYPE = text,
  INITCOND = ''
);

DROP TABLE IF EXISTS t;
CREATE TABLE t (
  a INT,
  b INT,
  c INT,
  d BOOL,
  e TEXT
);

-- Test 1: statement (line 10)
INSERT INTO t VALUES
  (0, 1, 0, true, 'foo'),
  (1, 1, 1, false, 'bar'),
  (0, 2, 2, true, 'baz'),
  (1, 2, 3, false, 'deadbeef');

-- Test 2: query (line 19)
SELECT a, b, row_number() OVER (ORDER BY a, b) FROM t ORDER BY a, b;

-- Test 3: query (line 27)
SELECT a, b, row_number() OVER (PARTITION BY a ORDER BY b) FROM t ORDER BY a, b;

-- Test 4: query (line 35)
SELECT a, b, row_number() OVER (PARTITION BY a, b) FROM t ORDER BY a, b;

-- Test 5: query (line 43)
SELECT a, b, rank() OVER () FROM t;

-- Test 6: query (line 51)
SELECT a, b, rank() OVER (ORDER BY a) FROM t;

-- Test 7: query (line 59)
SELECT a, b, c, rank() OVER (PARTITION BY a ORDER BY c) FROM t;

-- Test 8: query (line 67)
SELECT a, b, dense_rank() OVER () FROM t;

-- Test 9: query (line 75)
SELECT a, b, dense_rank() OVER (ORDER BY a) FROM t;

-- Test 10: query (line 83)
SELECT a, b, c, dense_rank() OVER (PARTITION BY a ORDER BY c) FROM t;

-- Test 11: query (line 91)
SELECT a, b, rank() OVER w, dense_rank() OVER w, percent_rank() OVER w, cume_dist() OVER w FROM t WINDOW w AS ();

-- Test 12: query (line 99)
SELECT a, b, rank() OVER w, dense_rank() OVER w, percent_rank() OVER w, cume_dist() OVER w FROM t WINDOW w AS (PARTITION BY a);

-- Test 13: query (line 108)
SELECT a, b, rank() OVER w, dense_rank() OVER w, percent_rank() OVER w, cume_dist() OVER w FROM t WINDOW w AS (ORDER BY a);

-- Test 14: query (line 116)
SELECT a, b, rank() OVER w, dense_rank() OVER w, percent_rank() OVER w, cume_dist() OVER w FROM t WINDOW w AS (PARTITION BY a ORDER BY b);

-- Test 15: query (line 124)
SELECT a, b, percent_rank() OVER () FROM t;

-- Test 16: query (line 132)
SELECT a, b, percent_rank() OVER (ORDER BY a) FROM t;

-- Test 17: query (line 140)
SELECT a, b, c, percent_rank() OVER (PARTITION BY a ORDER BY c) FROM t;

-- Test 18: query (line 148)
SELECT a, b, cume_dist() OVER () FROM t;

-- Test 19: query (line 156)
SELECT a, b, cume_dist() OVER (ORDER BY a) FROM t;

-- Test 20: query (line 164)
SELECT a, b, c, cume_dist() OVER (PARTITION BY a ORDER BY c) FROM t;

-- Test 21: query (line 172)
SELECT a, b, ntile(2) OVER (ORDER BY a, b) FROM t;

-- Test 22: query (line 180)
SELECT a, b, c, ntile(2) OVER (PARTITION BY a ORDER BY c) FROM t;

-- Test 23: query (line 188)
SELECT a, b, lag(a, b) OVER w, lead(a, b) OVER w FROM t WINDOW w AS (ORDER BY a, b);

-- Test 24: query (line 196)
SELECT a, b, c, lag(a, b) OVER w, lead(a, b) OVER w FROM t WINDOW w AS (PARTITION BY a ORDER BY c);

-- Test 25: query (line 204)
SELECT a, b, c, first_value(a) OVER w, last_value(a) OVER w, nth_value(a, b) OVER w
FROM t WINDOW w AS (ORDER BY c, b);

-- Test 26: query (line 213)
SELECT a, b, c, first_value(a) OVER w, last_value(a) OVER w, nth_value(a, b) OVER w
FROM t WINDOW w AS (PARTITION BY a ORDER BY c);

-- Test 27: query (line 222)
SELECT a, b, c, first_value(a) OVER w, last_value(a) OVER w, nth_value(a, b) OVER w
FROM t WINDOW w AS (ORDER BY c, b ROWS BETWEEN 5 PRECEDING AND CURRENT ROW);

-- Test 28: query (line 231)
SELECT a, b, c, first_value(a) OVER w, last_value(a) OVER w, nth_value(a, b) OVER w
FROM t WINDOW w AS (ORDER BY c, b GROUPS BETWEEN 5 PRECEDING AND CURRENT ROW);

-- Test 29: query (line 240)
SELECT c, first_value(c) OVER w, last_value(c) OVER w, nth_value(c, 2) OVER w
FROM t WINDOW w AS (ORDER BY c RANGE BETWEEN 5 PRECEDING AND CURRENT ROW);

-- Test 30: query (line 249)
SELECT a, b, c, sum_int(a) OVER w, sum(a) OVER w, count(*) OVER w, count(a) OVER w, avg(a) OVER w,
       max(a) OVER w, min(a) OVER w, bool_and(d) OVER w, bool_or(d) OVER w, concat_agg(e) OVER w
FROM t WINDOW w AS (ORDER BY c, b);

-- Test 31: query (line 259)
SELECT a, b, c, sum_int(a) OVER w, sum(a) OVER w, count(*) OVER w, count(a) OVER w, avg(a) OVER w,
       max(a) OVER w, min(a) OVER w, bool_and(d) OVER w, bool_or(d) OVER w, concat_agg(e) OVER w
FROM t WINDOW w AS (PARTITION BY a ORDER BY c);

-- Test 32: query (line 269)
SELECT a, b, c, sum_int(a) OVER w, sum(a) OVER w, count(*) OVER w, count(a) OVER w, avg(a) OVER w,
       max(a) OVER w, min(a) OVER w, bool_and(d) OVER w, bool_or(d) OVER w, concat_agg(e) OVER w
FROM t WINDOW w AS (ORDER BY c, b ROWS BETWEEN 5 PRECEDING AND CURRENT ROW);

-- Test 33: query (line 279)
SELECT a, b, c, sum_int(a) OVER w, sum(a) OVER w, count(*) OVER w, count(a) OVER w, avg(a) OVER w,
       max(a) OVER w, min(a) OVER w, bool_and(d) OVER w, bool_or(d) OVER w, concat_agg(e) OVER w
FROM t WINDOW w AS (ORDER BY c, b GROUPS BETWEEN 5 PRECEDING AND CURRENT ROW);

-- Test 34: query (line 289)
SELECT a, b, c, sum_int(a) OVER w, sum(a) OVER w, count(*) OVER w, count(a) OVER w, avg(a) OVER w,
       max(a) OVER w, min(a) OVER w, bool_and(d) OVER w, bool_or(d) OVER w, concat_agg(e) OVER w
FROM t WINDOW w AS (ORDER BY c RANGE BETWEEN 5 PRECEDING AND CURRENT ROW);

RESET client_min_messages;
