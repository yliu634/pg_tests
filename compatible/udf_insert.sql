-- PostgreSQL compatible tests from udf_insert
-- 85 tests

-- Test 1: statement (line 1)
CREATE TABLE t (a INT PRIMARY KEY, b INT DEFAULT 0);

-- Test 2: statement (line 4)
CREATE FUNCTION f_err() RETURNS RECORD AS
$$
  INSERT INTO t VALUES (1,2) RETURNING *;
$$ LANGUAGE SQL;

-- Test 3: statement (line 10)
CREATE FUNCTION f_void() RETURNS VOID AS
$$
  INSERT INTO t VALUES (0,1);
$$ LANGUAGE SQL;

-- Test 4: query (line 16)
SELECT f_void();

-- Test 5: statement (line 22)
CREATE FUNCTION f_err(b INT) RETURNS RECORD AS
$$
  INSERT INTO t (b) VALUES (b);
  SELECT * FROM t WHERE t.a=a AND t.b=b;
$$ LANGUAGE SQL;

-- Test 6: statement (line 29)
CREATE FUNCTION f_err(i INT, j INT) RETURNS RECORD STABLE AS
$$
  INSERT INTO t VALUES (i,j) RETURNING *;
$$ LANGUAGE SQL;

-- Test 7: statement (line 35)
CREATE OR REPLACE FUNCTION f_err(i INT, j INT) RETURNS RECORD IMMUTABLE AS
$$
  INSERT INTO t VALUES (i,j) RETURNING *;
$$ LANGUAGE SQL;

-- Test 8: statement (line 41)
CREATE FUNCTION f_insert(i INT, j INT) RETURNS RECORD AS
$$
  INSERT INTO t VALUES (i, j);
  SELECT * FROM t WHERE t.a=i AND t.b=j;
$$ LANGUAGE SQL;

-- Test 9: query (line 48)
SELECT f_insert(1,2);

-- Test 10: query (line 53)
SELECT f_insert(3,4);

-- Test 11: statement (line 58)
\set ON_ERROR_STOP 0
SELECT f_insert(3,4);
\set ON_ERROR_STOP 1

-- Test 12: query (line 61)
SELECT * FROM t;

-- Test 13: statement (line 68)
CREATE FUNCTION f_insert_select(i INT, j INT) RETURNS SETOF RECORD AS
$$
  INSERT INTO t VALUES (i, j);
  SELECT * FROM t WHERE a > 3;
$$ LANGUAGE SQL;

-- Test 14: query (line 76)
SELECT * FROM f_insert_select(5,6) AS t1(a INT, b INT) UNION ALL SELECT * FROM f_insert_select(7,8) AS t2(a INT, b INT);

-- Test 15: statement (line 83)
CREATE FUNCTION f_returning(p_a INT, p_b INT) RETURNS RECORD AS
$$
  INSERT INTO t VALUES (p_a, p_b) RETURNING a, b as foo, a, b;
$$ LANGUAGE SQL;

-- Test 16: query (line 89)
select f_returning(15,16);

-- Test 17: statement (line 95)
CREATE FUNCTION f_returning_star(a INT, b INT) RETURNS RECORD AS
$$
  INSERT INTO t VALUES (a, b) RETURNING *;
$$ LANGUAGE SQL;

-- Test 18: query (line 101)
SELECT f_returning_star(17,18);

-- Test 19: query (line 107)
SELECT * FROM f_returning_star(19,20) AS foo(a INT, b INT);

-- Test 20: statement (line 113)
CREATE FUNCTION f_default(a INT) RETURNS RECORD AS
$$
  INSERT INTO t VALUES (a, DEFAULT) RETURNING *;
$$ LANGUAGE SQL;

-- Test 21: query (line 119)
SELECT f_default(21);

-- Test 22: statement (line 126)
CREATE TABLE t_multi (a INT PRIMARY KEY, b INT DEFAULT 0);

-- Test 23: statement (line 129)
CREATE FUNCTION f_2values(i INT, j INT, m INT, n INT) RETURNS SETOF RECORD AS
$$
  INSERT INTO t_multi VALUES (i, j), (m, n);
  SELECT * FROM t_multi WHERE t_multi.a=i OR t_multi.a=m;
$$ LANGUAGE SQL;

-- Test 24: query (line 136)
SELECT f_2values(7,8,9,10);

-- Test 25: statement (line 142)
\set ON_ERROR_STOP 0
SELECT f_2values(42,42,42,42);
\set ON_ERROR_STOP 1

-- Test 26: statement (line 145)
CREATE FUNCTION f_2inserts(i INT, j INT, m INT, n INT) RETURNS SETOF RECORD AS
$$
  INSERT INTO t_multi VALUES (i, j);
  INSERT INTO t_multi VALUES (m, n);
  SELECT * FROM t_multi WHERE t_multi.a=i OR t_multi.a=m;
$$ LANGUAGE SQL;

-- Test 27: query (line 153)
SELECT f_2inserts(11,12,13,14);

-- Test 28: statement (line 159)
\set ON_ERROR_STOP 0
SELECT f_2inserts(42,42,42,42);
\set ON_ERROR_STOP 1

-- Test 29: query (line 163)
SELECT count(*) FROM t_multi WHERE a = 42;

-- Test 30: statement (line 172)
CREATE TABLE t_alter (a INT);

-- Test 31: statement (line 175)
CREATE FUNCTION f_int(i INT) RETURNS INT AS
$$
  INSERT INTO t_alter VALUES (i) RETURNING *;
$$ LANGUAGE SQL;

-- Test 32: query (line 181)
SELECT f_int(0);

-- Test 33: statement (line 186)
CREATE FUNCTION f_record(i INT) RETURNS RECORD AS
$$
  INSERT INTO t_alter VALUES (i) RETURNING *;
$$ LANGUAGE SQL;

-- Test 34: query (line 192)
SELECT f_record(1);

-- Test 35: statement (line 197)
ALTER TABLE t_alter ADD COLUMN b INT DEFAULT 0;

-- Test 36: query (line 200)
SELECT f_record(2);

-- Test 37: statement (line 205)
ALTER TABLE t_alter ADD COLUMN c INT;

-- Test 38: query (line 208)
SELECT f_record(3);

-- Test 39: query (line 213)
\set ON_ERROR_STOP 0
SELECT f_int(4);
\set ON_ERROR_STOP 1

-- Test 40: query (line 218)
SELECT * FROM t_alter;

-- Test 41: statement (line 227)
CREATE FUNCTION f_drop(i INT, j INT, k INT) RETURNS RECORD AS
$$
  INSERT INTO t_alter VALUES (i, j, k) RETURNING *;
$$ LANGUAGE SQL;

-- Test 42: query (line 233)
SELECT f_drop(5,100,101);

-- Test 43: statement (line 238)
ALTER TABLE t_alter DROP COLUMN c;

-- Test 44: statement (line 241)
DROP FUNCTION f_drop;

-- Test 45: statement (line 245)
\set ON_ERROR_STOP 0
ALTER TABLE t_alter DROP COLUMN c;
ALTER TABLE t_alter DROP COLUMN b;
\set ON_ERROR_STOP 1

-- Test 46: statement (line 249)
ALTER TABLE t_alter DROP COLUMN a;

-- Test 47: query (line 252)
\set ON_ERROR_STOP 0
SELECT f_record(6);
\set ON_ERROR_STOP 1

-- Test 48: statement (line 261)
CREATE TABLE t_checkb(
  a INT PRIMARY KEY,
  b INT,
  CHECK (b > 1)
);

-- Test 49: statement (line 268)
CREATE FUNCTION f_checkb() RETURNS RECORD AS
$$
  INSERT INTO t_checkb VALUES (1, 0) ON CONFLICT(a) DO UPDATE SET b=0 RETURNING *;
$$ LANGUAGE SQL;

-- Test 50: statement (line 274)
\set ON_ERROR_STOP 0
SELECT f_checkb();
\set ON_ERROR_STOP 1

-- Test 51: statement (line 281)
CREATE TABLE t146414 (
  a INT NOT NULL,
  b INT GENERATED ALWAYS AS (a + 1) STORED
);

-- Test 52: statement (line 287)
CREATE FUNCTION f146414() RETURNS INT LANGUAGE SQL AS $$
  INSERT INTO t146414 (a) VALUES (100) RETURNING b;
  SELECT 1;
$$;

-- Test 53: statement (line 293)
ALTER TABLE t146414 DROP COLUMN b;

-- Test 54: statement (line 296)
\set ON_ERROR_STOP 0
SELECT f146414();
\set ON_ERROR_STOP 1

-- Test 55: statement (line 303)
CREATE TABLE t_computed (
  a INT NOT NULL,
  b INT GENERATED ALWAYS AS (a + 1) STORED,
  c INT GENERATED ALWAYS AS (a * 2) STORED
);
CREATE INDEX i ON t_computed USING hash (a);

-- Test 56: statement (line 313)
CREATE FUNCTION f145098() RETURNS INT LANGUAGE SQL AS $$
  INSERT INTO t_computed VALUES (100);
  SELECT 1;
$$;

-- Test 57: statement (line 319)
SELECT f145098();

-- Test 58: query (line 322)
SELECT * FROM t_computed;

-- Test 59: statement (line 329)
DROP INDEX i;

-- Test 60: statement (line 332)
SELECT f145098();

-- Test 61: query (line 335)
SELECT * FROM t_computed;

-- Test 62: statement (line 341)
ALTER TABLE t_computed DROP COLUMN c;

-- Test 63: statement (line 344)
SELECT f145098();

-- Test 64: query (line 347)
SELECT * FROM t_computed;

-- Test 65: statement (line 354)
ALTER TABLE t_computed DROP COLUMN b;

-- Test 66: statement (line 357)
SELECT f145098();

-- Test 67: query (line 360)
SELECT * FROM t_computed;

-- Test 68: statement (line 368)
ALTER TABLE t_computed DROP COLUMN a;

-- Test 69: statement (line 371)
DROP FUNCTION f145098;

-- Test 70: statement (line 374)
DROP TABLE t_computed;

-- Test 71: statement (line 377)
CREATE TABLE t_computed (
  a INT NOT NULL,
  b INT GENERATED ALWAYS AS (a + 1) STORED,
  c INT GENERATED ALWAYS AS (a * 2) STORED
);
CREATE INDEX i ON t_computed USING hash (a);

-- Test 72: statement (line 387)
-- CockroachDB-only settings.
-- SET use_improved_routine_dependency_tracking = false;
-- SET use_improved_routine_deps_triggers_and_computed_cols = false;

-- Test 73: statement (line 391)
CREATE FUNCTION f145098() RETURNS INT LANGUAGE SQL AS $$
  INSERT INTO t_computed VALUES (100);
  SELECT 1;
$$;

-- Test 74: statement (line 397)
-- RESET use_improved_routine_dependency_tracking;
-- RESET use_improved_routine_deps_triggers_and_computed_cols;

-- Test 75: statement (line 401)
DROP INDEX i;

-- Test 76: statement (line 404)
ALTER TABLE t_computed DROP COLUMN c;

-- Test 77: statement (line 407)
ALTER TABLE t_computed DROP COLUMN b;

-- Test 78: statement (line 410)
DROP FUNCTION f145098;

-- Test 79: statement (line 413)
DROP TABLE t_computed;

-- Test 80: statement (line 418)
CREATE TABLE t_hash_sharded (
  a INT NOT NULL
);
CREATE INDEX i ON t_hash_sharded USING hash (a);

-- Test 81: statement (line 424)
CREATE FUNCTION f145098() RETURNS INT LANGUAGE SQL AS $$
  INSERT INTO t_hash_sharded VALUES (100);
  SELECT 1;
$$;

-- Test 82: statement (line 430)
DROP INDEX i;

-- Test 83: statement (line 433)
SELECT f145098();

-- Test 84: statement (line 436)
DROP FUNCTION f145098;

-- Test 85: statement (line 439)
DROP TABLE t_hash_sharded;
