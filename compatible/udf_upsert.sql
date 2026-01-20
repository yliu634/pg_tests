-- PostgreSQL compatible tests from udf_upsert
-- 55 tests

-- Test 1: statement (line 3)
CREATE TABLE t_ocdn (a INT PRIMARY KEY, b INT UNIQUE, c INT);

-- Test 2: statement (line 6)
CREATE FUNCTION f_ocdn(i INT, j INT, k INT) RETURNS RECORD AS
$$
  INSERT INTO t_ocdn VALUES (i, j, k) ON CONFLICT DO NOTHING RETURNING *;
$$ LANGUAGE SQL;

-- Test 3: query (line 12)
SELECT f_ocdn(1,1,1);

-- Test 4: query (line 17)
SELECT f_ocdn(1,1,1);

-- Test 5: query (line 22)
SELECT f_ocdn(2,1,1);

-- Test 6: query (line 27)
SELECT f_ocdn(1,2,1);

-- Test 7: query (line 32)
SELECT f_ocdn(1,1,1), f_ocdn(3,2,2), f_ocdn(6,6,2), f_ocdn(2,1,1);

-- Test 8: query (line 37)
SELECT f_ocdn(x, y, z) FROM (VALUES (1, 1, 1), (2, 2, 1), (3, 3, 3), (3, 4, 4), (5, 5, 5)) v(x, y, z)

-- Test 9: query (line 46)
SELECT * FROM t_ocdn

-- Test 10: statement (line 55)
CREATE FUNCTION f_ocdn_2vals(i INT, j INT, k INT, m INT, n INT, o INT) RETURNS RECORD AS
$$
  INSERT INTO t_ocdn VALUES (i, j, k), (m,n,o) ON CONFLICT DO NOTHING RETURNING *;
$$ LANGUAGE SQL;

-- Test 11: statement (line 61)
SELECT f_ocdn_2vals(7,7,7,7,7,7);

-- Test 12: query (line 64)
SELECT * FROM t_ocdn;

-- Test 13: statement (line 73)
CREATE FUNCTION f_multi_ins(i INT, j INT, k INT, m INT, n INT, o INT) RETURNS RECORD AS
$$
  INSERT INTO t_ocdn VALUES (i, j, k) ON CONFLICT DO NOTHING;
  INSERT INTO t_ocdn VALUES (m, n, o) ON CONFLICT DO NOTHING;
  SELECT * FROM t_ocdn WHERE a=i OR a=m ORDER BY a;
$$ LANGUAGE SQL;

-- Test 14: query (line 81)
SELECT f_multi_ins(1, 1, 1, 1, 1, 1), f_multi_ins(1, 1, 1, 1, 1, 1)

-- Test 15: query (line 86)
SELECT f_multi_ins(2, 2, 2, 3, 3, 3), f_multi_ins(3, 3, 3, 4, 4, 4)

-- Test 16: query (line 91)
SELECT * FROM t_ocdn

-- Test 17: statement (line 105)
CREATE TABLE t_ocdu (a INT PRIMARY KEY, b INT UNIQUE, c INT);

-- Test 18: statement (line 108)
CREATE FUNCTION f_ocdu(i INT, j INT, k INT) RETURNS RECORD AS
$$
  INSERT INTO t_ocdu VALUES (i, j, k) ON CONFLICT (a) DO UPDATE SET b = j, c = t_ocdu.c + 1 RETURNING *;
$$ LANGUAGE SQL;

-- Test 19: query (line 114)
SELECT f_ocdu(1,1,1);

-- Test 20: query (line 119)
SELECT f_ocdu(1,1,8);

-- Test 21: query (line 124)
SELECT f_ocdu(1,4,6);

-- Test 22: statement (line 129)
SELECT f_ocdu(2,4,6);

-- Test 23: statement (line 137)
CREATE TABLE t_upsert (a INT PRIMARY KEY, b INT);

-- Test 24: statement (line 141)
CREATE FUNCTION f_upsert(i INT, j INT) RETURNS RECORD AS
$$
  UPSERT INTO t_upsert VALUES (i, j) RETURNING *;
$$ LANGUAGE SQL;

-- Test 25: query (line 147)
SELECT f_upsert(1,1);

-- Test 26: query (line 152)
SELECT f_upsert(1,4);

-- Test 27: statement (line 157)
CREATE FUNCTION f_upsert_2vals(i INT, j INT, m INT, n INT) RETURNS SETOF RECORD AS
$$
  UPSERT INTO t_upsert VALUES (i, j), (m, n) RETURNING *;
$$ LANGUAGE SQL;

-- Test 28: query (line 163)
SELECT f_upsert_2vals(1,9,2,8);

-- Test 29: statement (line 174)
CREATE TABLE t_check1(a INT NULL CHECK(a IS NOT NULL), b CHAR(4) CHECK(length(b) < 4));

-- Test 30: statement (line 177)
CREATE FUNCTION f_check_null() RETURNS RECORD AS
$$
  UPSERT INTO t_check1(a) VALUES (NULL) RETURNING *;
$$ LANGUAGE SQL;

-- Test 31: statement (line 183)
SELECT f_check_null();

-- Test 32: statement (line 186)
CREATE FUNCTION f_check_len() RETURNS RECORD AS
$$
  UPSERT INTO t_check1(b) VALUES ('abcd') RETURNING *;
$$ LANGUAGE SQL;

-- Test 33: statement (line 192)
SELECT f_check_len()

-- Test 34: statement (line 195)
CREATE FUNCTION f_check_vals(i INT, j CHAR(4)) RETURNS RECORD AS
$$
  UPSERT INTO t_check1(b,a) VALUES (j,i) RETURNING *;
$$ LANGUAGE SQL;

-- Test 35: statement (line 201)
SELECT f_check_vals(NULL, 'ab');

-- Test 36: statement (line 204)
SELECT f_check_vals(3, 'abcd');

-- Test 37: statement (line 207)
CREATE TABLE t_check2(a INT NOT NULL CHECK(a IS NOT NULL), b CHAR(3) CHECK(length(b) < 4));

-- Test 38: statement (line 210)
CREATE FUNCTION f_check_colerr_null() RETURNS RECORD AS
$$
  UPSERT INTO t_check2(a) VALUES (NULL) RETURNING *;
$$ LANGUAGE SQL;

-- Test 39: statement (line 216)
SELECT f_check_colerr_null();

-- Test 40: statement (line 219)
CREATE FUNCTION f_check_colerr_len() RETURNS RECORD AS
$$
  UPSERT INTO t_check2(b) VALUES ('abcd') RETURNING *;
$$ LANGUAGE SQL;

-- Test 41: statement (line 225)
SELECT f_check_colerr_len()

-- Test 42: statement (line 228)
CREATE FUNCTION f_check_colerr_vals(i INT, j CHAR(4)) RETURNS RECORD AS
$$
  UPSERT INTO t_check2(a,b) VALUES (i,j) RETURNING *;
$$ LANGUAGE SQL;

-- Test 43: statement (line 234)
SELECT f_check_colerr_vals(NULL, 'ab')

-- Test 44: statement (line 237)
SELECT f_check_colerr_vals(NULL, 'abcd')

-- Test 45: statement (line 244)
CREATE TABLE t146414 (
  a INT NOT NULL,
  b INT AS (a + 1) VIRTUAL
)

-- Test 46: statement (line 250)
CREATE FUNCTION f146414() RETURNS INT LANGUAGE SQL AS $$
  UPSERT INTO t146414 (a) VALUES (100) RETURNING b;
  SELECT 1;
$$;

-- Test 47: statement (line 256)
ALTER TABLE t146414 DROP COLUMN b;

-- Test 48: statement (line 259)
SELECT f146414()

-- Test 49: statement (line 267)
CREATE TABLE table_drop (
  a INT NOT NULL,
  b INT NOT NULL,
  c INT NOT NULL,
  d INT AS (a + b) STORED,
  -- Hash-sharded indexes generate a hidden computed column.
  INDEX i (b ASC) USING HASH
);
INSERT INTO table_drop VALUES (1,2,3), (4,5,6), (7,8,9);

-- Test 50: statement (line 278)
DROP FUNCTION f_upsert;
CREATE FUNCTION f_upsert() RETURNS INT LANGUAGE SQL AS $$
  UPSERT INTO table_drop (a, b) VALUES (100, 200);
  SELECT 1;
$$;

-- Test 51: statement (line 285)
DROP INDEX i;

-- Test 52: statement (line 288)
ALTER TABLE table_drop DROP COLUMN d;

-- Test 53: statement (line 291)
ALTER TABLE table_drop DROP COLUMN c;

-- Test 54: statement (line 294)
ALTER TABLE table_drop DROP COLUMN b;

-- Test 55: statement (line 297)
ALTER TABLE table_drop DROP COLUMN a;

