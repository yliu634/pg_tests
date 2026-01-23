-- PostgreSQL compatible tests from udf_setof
-- 62 tests

-- Test 1: statement (line 3)
CREATE TABLE ab (
  a INT PRIMARY KEY,
  b INT
);

-- Test 2: statement (line 9)
INSERT INTO ab SELECT i, i*10 FROM generate_series(1, 4) g(i);

-- Test 3: statement (line 12)
CREATE FUNCTION empty() RETURNS SETOF INT LANGUAGE SQL AS $$
  SELECT a FROM ab WHERE a < 0
$$;

-- Test 4: query (line 17)
SELECT * FROM empty();

-- Test 5: query (line 21)
SELECT b, empty() FROM ab;

-- Test 6: statement (line 25)
CREATE FUNCTION all_a() RETURNS SETOF INT LANGUAGE SQL AS $$
  SELECT a FROM ab ORDER BY a
$$;

-- Test 7: query (line 30)
SELECT * FROM all_a();

-- Test 8: query (line 38)
select b, all_a() from ab;

-- Test 9: statement (line 58)
CREATE FUNCTION some_a() RETURNS SETOF INT LANGUAGE SQL AS $$
  SELECT a FROM ab WHERE a < 3 ORDER BY a
$$;

-- Test 10: query (line 63)
select b, all_a(), some_a() from ab;

-- Test 11: query (line 86)
SELECT 1 IN (SELECT * FROM all_a());

-- Test 12: statement (line 94)
CREATE FUNCTION all_a_lt(i INT) RETURNS SETOF INT LANGUAGE SQL AS $$
  SELECT a FROM ab WHERE a < i ORDER BY a
$$;

-- Test 13: query (line 99)
SELECT * FROM all_a_lt(3);

-- Test 14: query (line 105)
SELECT a, all_a_lt(a) FROM ab;

-- Test 15: statement (line 115)
CREATE FUNCTION all_a_desc() RETURNS SETOF INT STABLE LANGUAGE SQL AS $$
  SELECT a FROM ab ORDER BY a DESC
$$;

-- Test 16: query (line 121)
SELECT array_agg(a) FROM all_a_desc() g(a);

-- Test 17: statement (line 127)
\set ON_ERROR_STOP 0
SELECT all_a_lt(all_a());
\set ON_ERROR_STOP 1

-- Test 18: statement (line 130)
CREATE FUNCTION all_a_strict(INT) RETURNS SETOF INT STRICT LANGUAGE SQL AS $$
  SELECT a FROM ab
$$;

-- Test 19: query (line 135)
SELECT * FROM all_a_strict(NULL);

-- Test 20: query (line 139)
SELECT * FROM all_a_strict(3);

-- Test 21: statement (line 147)
CREATE TABLE n (n INT);
INSERT INTO n VALUES (NULL), (3);

-- Test 22: query (line 151)
SELECT all_a_strict(n) FROM n;

-- Test 23: statement (line 159)
\set ON_ERROR_STOP 0
CREATE FUNCTION err(INT) RETURNS SETOF INT STRICT LANGUAGE SQL AS $$
  SELECT a, b FROM ab ORDER BY a
$$;
\set ON_ERROR_STOP 1

-- Test 24: statement (line 164)
CREATE FUNCTION all_ab() RETURNS SETOF ab LANGUAGE SQL AS $$
  SELECT a, b FROM ab
$$;

-- Test 25: query (line 169)
SELECT * FROM all_ab();

-- Test 26: statement (line 177)
CREATE FUNCTION all_ab_tuple() RETURNS SETOF ab LANGUAGE SQL AS $$
  SELECT (a, b) FROM ab
$$;

-- Test 27: query (line 182)
SELECT * FROM all_ab_tuple();

-- Test 28: statement (line 190)
CREATE FUNCTION all_ab_record() RETURNS SETOF RECORD LANGUAGE SQL AS $$
  SELECT a, b FROM ab
$$;

-- Test 29: query (line 195)
SELECT * FROM all_ab_tuple();

-- Test 30: statement (line 206)
CREATE FUNCTION f128403(OUT x INT, OUT y TEXT) RETURNS SETOF RECORD AS $$
  SELECT t, t::TEXT FROM generate_series(1, 10) g(t);
$$ LANGUAGE SQL;

-- Test 31: query (line 211)
select f128403();

-- Test 32: query (line 225)
SELECT * FROM f128403();

-- Test 33: statement (line 246)
\set ON_ERROR_STOP 0
CREATE FUNCTION f_table1(OUT x INT, OUT y TEXT) RETURNS TABLE(x INT, y TEXT) AS $$
  SELECT t, t::TEXT FROM generate_series(1, 10) g(t);
$$ LANGUAGE SQL;
\set ON_ERROR_STOP 1

-- Test 34: statement (line 251)
CREATE FUNCTION f_table1() RETURNS TABLE(x INT, y TEXT) AS $$
  SELECT t, t::TEXT FROM generate_series(1, 10) g(t);
$$ LANGUAGE SQL;

-- Test 35: query (line 256)
select f_table1();

-- Test 36: query (line 270)
SELECT * FROM f_table1();

-- Test 37: statement (line 285)
CREATE FUNCTION f_table2() RETURNS TABLE(x INT) AS $$
  SELECT t FROM generate_series(1, 10) g(t);
$$ LANGUAGE SQL;

-- Test 38: query (line 290)
select f_table2();

-- Test 39: statement (line 304)
\set ON_ERROR_STOP 0
CREATE FUNCTION err() RETURNS TABLE (x INT) STRICT LANGUAGE SQL AS $$
  SELECT a, b FROM ab ORDER BY a
$$;
\set ON_ERROR_STOP 1

-- Test 40: statement (line 315)
CREATE FUNCTION f145414() RETURNS SETOF RECORD LANGUAGE SQL AS $$ SELECT 1, 2; $$;

-- Test 41: statement (line 318)
\set ON_ERROR_STOP 0
SELECT * FROM f145414() AS foo(x, y INT);
\set ON_ERROR_STOP 1

-- Test 42: statement (line 321)
\set ON_ERROR_STOP 0
SELECT * FROM f145414() AS foo(x INT, y);
\set ON_ERROR_STOP 1

-- Test 43: statement (line 324)
DROP FUNCTION f145414;

-- Test 44: statement (line 332)
CREATE TABLE test_ordering (x INT PRIMARY KEY, y INT);

-- Test 45: statement (line 335)
INSERT INTO test_ordering VALUES (1, 10), (2, 20), (3, 30), (4, 40);

-- Test 46: statement (line 338)
CREATE FUNCTION f_out_desc(OUT a INT, OUT b INT) RETURNS SETOF RECORD AS $$
  SELECT x, y FROM test_ordering ORDER BY x DESC;
$$ LANGUAGE SQL;

-- Test 47: query (line 343)
SELECT f_out_desc();

-- Test 48: query (line 351)
SELECT * FROM f_out_desc();

-- Test 49: statement (line 359)
DROP FUNCTION f_out_desc;

-- Test 50: statement (line 362)
CREATE FUNCTION f_out_asc(OUT a INT, OUT b INT) RETURNS SETOF RECORD AS $$
  SELECT x, y FROM test_ordering ORDER BY x ASC;
$$ LANGUAGE SQL;

-- Test 51: query (line 367)
SELECT f_out_asc();

-- Test 52: query (line 375)
SELECT * FROM f_out_asc();

-- Test 53: statement (line 383)
DROP FUNCTION f_out_asc;

-- Test 54: statement (line 389)
CREATE FUNCTION f_record_cast() RETURNS SETOF RECORD AS $$
  SELECT x, y FROM test_ordering ORDER BY x DESC;
$$ LANGUAGE SQL;

-- Test 55: query (line 394)
SELECT * FROM f_record_cast() AS f(a FLOAT, b FLOAT);

-- Test 56: statement (line 402)
DROP FUNCTION f_record_cast;

-- Test 57: statement (line 406)
CREATE FUNCTION f_out_for_agg(OUT a INT, OUT b INT) RETURNS SETOF RECORD AS $$
  SELECT x, y FROM test_ordering ORDER BY x DESC;
$$ LANGUAGE SQL;

-- Test 58: query (line 411)
SELECT array_agg(f) FROM f_out_for_agg() AS f;

-- Test 59: statement (line 416)
DROP FUNCTION f_out_for_agg;

-- Test 60: statement (line 421)
CREATE FUNCTION f_tuple() RETURNS SETOF RECORD AS $$
  SELECT ROW(x, y) FROM test_ordering ORDER BY x DESC;
$$ LANGUAGE SQL;

-- Test 61: query (line 426)
SELECT * FROM f_tuple() AS f(a INT, b INT);

-- Test 62: statement (line 434)
DROP FUNCTION f_tuple;
DROP TABLE test_ordering;
