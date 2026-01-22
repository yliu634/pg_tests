-- PostgreSQL compatible tests from udf_subquery
-- 40 tests

-- Test 1: statement (line 3)
CREATE TABLE sub_all (a INT);
INSERT INTO sub_all VALUES (1), (2), (3), (4), (5), (6);

-- Test 2: statement (line 7)
CREATE TABLE sub_odd (a INT);
INSERT INTO sub_odd VALUES (1), (3), (5);

-- Test 3: statement (line 12)
CREATE FUNCTION sub_max_odd() RETURNS INT LANGUAGE SQL AS $$
  SELECT a FROM sub_all WHERE a = (SELECT max(a) FROM sub_odd)
$$;

-- Test 4: query (line 17)
SELECT a, sub_max_odd() FROM sub_all WHERE a = sub_max_odd();

-- Test 5: query (line 23)
SELECT a FROM sub_all WHERE sub_max_odd() = (SELECT max(a) FROM sub_odd);

-- Test 6: statement (line 34)
CREATE FUNCTION sub_max_odd_with_order_by() RETURNS INT LANGUAGE SQL AS $$
  SELECT a FROM sub_all WHERE a = (SELECT a FROM sub_odd ORDER BY a DESC LIMIT 1)
$$;

-- Test 7: query (line 39)
SELECT sub_max_odd_with_order_by();

-- Test 8: statement (line 45)
CREATE FUNCTION sub_prev_odd(i INT) RETURNS INT LANGUAGE SQL AS $$
  SELECT a FROM sub_all WHERE a = (SELECT max(a) FROM sub_odd WHERE a < i)
$$;

-- Test 9: query (line 50)
SELECT a, sub_prev_odd(a) FROM sub_all;

-- Test 10: statement (line 61)
CREATE FUNCTION sub_is_odd(i INT) RETURNS BOOL LANGUAGE SQL AS $$
  SELECT true FROM sub_all
  WHERE EXISTS (SELECT 1 FROM sub_odd where sub_odd.a = sub_all.a)
    AND a = i
$$;

-- Test 11: query (line 68)
SELECT a, sub_is_odd(a) FROM sub_all WHERE sub_is_odd(a) OR sub_is_odd(a) IS NULL;

-- Test 12: statement (line 79)
CREATE FUNCTION sub_first() RETURNS INT LANGUAGE SQL AS $$
  SELECT a FROM sub_all WHERE EXISTS (SELECT a FROM sub_odd) ORDER BY a LIMIT 1
$$;

-- Test 13: query (line 84)
SELECT sub_first(), a FROM sub_all;

-- Test 14: statement (line 95)
CREATE FUNCTION sub_two() RETURNS INT LANGUAGE SQL AS $$
  SELECT a FROM sub_all WHERE CASE
    WHEN a > 1 THEN EXISTS (SELECT 0 FROM sub_odd WHERE sub_odd.a = sub_all.a+1)
    ELSE false
  END
  ORDER BY a LIMIT 1
$$;

-- Test 15: query (line 104)
SELECT a, sub_two() FROM sub_all;

-- Test 16: statement (line 118)
CREATE TABLE any_tab (
  a INT,
  b INT
);

-- Test 17: statement (line 124)
CREATE FUNCTION any_fn(i INT) RETURNS BOOL LANGUAGE SQL AS $$
  SELECT i = ANY(SELECT a FROM any_tab)
$$;

-- Test 18: statement (line 129)
CREATE FUNCTION any_fn_lt(i INT) RETURNS BOOL LANGUAGE SQL AS $$
  SELECT i < ANY(SELECT a FROM any_tab)
$$;

-- Test 19: statement (line 134)
CREATE FUNCTION any_fn_tuple(i INT, j INT) RETURNS BOOL LANGUAGE SQL AS $$
  SELECT (i, j) = ANY(SELECT a, b FROM any_tab)
$$;

-- Test 20: query (line 140)
SELECT any_fn(1), any_fn(4), any_fn(NULL::INT);

-- Test 21: query (line 145)
SELECT any_fn_lt(1), any_fn_lt(4), any_fn_lt(NULL::INT);

-- Test 22: query (line 150)
SELECT any_fn_tuple(1, 10), any_fn_tuple(1, 20), any_fn_tuple(NULL::INT, NULL::INT);

-- Test 23: statement (line 155)
INSERT INTO any_tab VALUES (1, 10), (3, 30);

-- Test 24: query (line 158)
SELECT any_fn(1), any_fn(4), any_fn(NULL::INT);

-- Test 25: query (line 163)
SELECT any_fn_lt(1), any_fn_lt(4), any_fn_lt(NULL::INT);

-- Test 26: query (line 168)
SELECT any_fn_tuple(1, 10), any_fn_tuple(1, 20), any_fn_tuple(NULL::INT, NULL::INT);

-- Test 27: statement (line 173)
INSERT INTO any_tab VALUES (NULL, NULL);

-- Test 28: query (line 176)
SELECT any_fn(1), any_fn(4), any_fn(NULL::INT);

-- Test 29: query (line 181)
SELECT any_fn_lt(1), any_fn_lt(4), any_fn_lt(NULL::INT);

-- Test 30: query (line 186)
SELECT any_fn_tuple(1, 10), any_fn_tuple(1, 20), any_fn_tuple(NULL::INT, NULL::INT);

-- Test 31: statement (line 191)
CREATE FUNCTION any_fn2(i INT) RETURNS SETOF INT LANGUAGE SQL AS $$
  SELECT b FROM (VALUES (1), (2), (3), (NULL)) v(b)
  WHERE b = ANY (SELECT a FROM any_tab WHERE a <= i)
$$;

-- Test 32: query (line 197)
SELECT any_fn2(2);

-- Test 33: query (line 202)
SELECT any_fn2(3);

-- Test 34: statement (line 212)
CREATE TABLE all_tab (a INT);

-- Test 35: statement (line 215)
CREATE FUNCTION all_fn(i INT) RETURNS BOOL LANGUAGE SQL AS $$
  SELECT i = ALL(SELECT a FROM all_tab)
$$;

-- Test 36: query (line 221)
SELECT all_fn(1), all_fn(2), all_fn(NULL::INT);

-- Test 37: statement (line 226)
INSERT INTO all_tab VALUES (1), (1);

-- Test 38: query (line 229)
SELECT all_fn(1), all_fn(2), all_fn(NULL::INT);

-- Test 39: statement (line 234)
INSERT INTO all_tab VALUES (NULL);

-- Test 40: query (line 237)
SELECT all_fn(1), all_fn(2), all_fn(NULL::INT);
