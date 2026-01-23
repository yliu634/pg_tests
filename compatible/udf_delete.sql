-- PostgreSQL compatible tests from udf_delete
-- 64 tests

\set ON_ERROR_STOP 1
SET client_min_messages = warning;

-- Test 1: statement (line 1)
CREATE TABLE kv (
  k INT PRIMARY KEY,
  v INT,
  UNIQUE (v)
);
CREATE UNIQUE INDEX foo ON kv (v);
CREATE INDEX bar ON kv (k, v);

-- Test 2: statement (line 9)
INSERT INTO kv VALUES (1, 2), (3, 4), (5, 6), (7, 8);

-- Test 3: statement (line 12)
CREATE VIEW kview AS SELECT k,v FROM kv;

-- Test 4: statement (line 15)
CREATE FUNCTION f_view() RETURNS VOID AS
$$
  DELETE FROM kview;
$$ LANGUAGE SQL;

-- Test 5: statement (line 21)
CREATE FUNCTION f_kv_predicate() RETURNS SETOF RECORD AS
$$
  DELETE FROM kv WHERE k=3 OR v=6 RETURNING k, v;
$$ LANGUAGE SQL;

-- Test 6: query (line 27)
SELECT f_kv_predicate();

-- Test 7: query (line 33)
SELECT * FROM kv;

-- Test 8: query (line 40)
SELECT f_kv_predicate();

-- Test 9: statement (line 44)
CREATE FUNCTION f_kv_all() RETURNS SETOF RECORD AS
$$
  DELETE FROM kv RETURNING *;
$$ LANGUAGE SQL;

-- Test 10: query (line 50)
SELECT * FROM f_kv_all() AS foo(a INT, b INT);

-- Test 11: query (line 56)
SELECT * FROM kv;

-- Test 12: statement (line 60)
CREATE FUNCTION f_kv2(i INT, j INT) RETURNS SETOF RECORD AS
$$
  DELETE FROM kv WHERE k = i RETURNING k, v;
  DELETE FROM kv WHERE v = j RETURNING k, v;
$$ LANGUAGE SQL;

-- Test 13: statement (line 67)
INSERT INTO kv VALUES (1, 2), (3, 4), (5, 6), (7, 8);

-- Test 14: statement (line 70)
SELECT f_kv2(1, 9);

-- Test 15: query (line 73)
SELECT * FROM kv;

-- Test 16: statement (line 80)
SELECT f_kv2(i, j) FROM (VALUES (3, 0), (0, 8)) v(i, j);

-- Test 17: query (line 83)
SELECT * FROM kv;

-- Test 18: statement (line 88)
CREATE FUNCTION f_no_op(i INT, j INT) RETURNS SETOF RECORD AS
$$
  INSERT INTO kv VALUES (i, j);
  DELETE FROM kv WHERE k=i AND v=j RETURNING k, v;
$$ LANGUAGE SQL;

-- Test 19: statement (line 95)
SELECT f_no_op(9, 10);

-- Test 20: query (line 98)
SELECT * FROM kv;

-- Test 21: statement (line 103)
CREATE TABLE unindexed (
  k INT PRIMARY KEY,
  v INT
);

-- Test 22: statement (line 109)
INSERT INTO unindexed VALUES (1, 2), (3, 4), (5, 6), (7, 8);

-- Test 23: statement (line 112)
CREATE FUNCTION f_unindexed_predicate() RETURNS SETOF RECORD AS
$$
  DELETE FROM unindexed WHERE k=3 OR v=6 RETURNING k, v;
$$ LANGUAGE SQL;

-- Test 24: query (line 118)
SELECT f_unindexed_predicate();

-- Test 25: query (line 124)
SELECT * FROM unindexed;

-- Test 26: query (line 131)
SELECT f_unindexed_predicate();

-- Test 27: statement (line 135)
CREATE FUNCTION f_unindexed_all() RETURNS SETOF RECORD AS
$$
  DELETE FROM unindexed RETURNING *;
$$ LANGUAGE SQL;

-- Test 28: query (line 141)
SELECT * FROM f_unindexed_all() AS foo(a INT, b INT);

-- Test 29: query (line 147)
SELECT * FROM unindexed;

-- Test 30: statement (line 151)
INSERT INTO unindexed VALUES (1, 9), (8, 2), (3, 7), (6, 4);

-- Test 31: statement (line 154)
CREATE FUNCTION f_orderby1() RETURNS SETOF RECORD AS
$$
  WITH del AS (
    DELETE FROM unindexed
    WHERE ctid IN (
      SELECT ctid
      FROM unindexed
      WHERE k > 1 AND v < 7
      ORDER BY v DESC
      LIMIT 2
    )
    RETURNING v, k
  )
  SELECT v, k FROM del ORDER BY v DESC;
$$ LANGUAGE SQL;

-- Test 32: query (line 160)
SELECT * FROM f_orderby1() AS foo(a INT, b INT);

-- Test 33: statement (line 166)
CREATE FUNCTION f_orderby2() RETURNS SETOF RECORD AS
$$
  WITH del AS (
    DELETE FROM unindexed
    WHERE ctid IN (
      SELECT ctid
      FROM unindexed
      ORDER BY v
      LIMIT 2
    )
    RETURNING k, v
  )
  SELECT k, v FROM del ORDER BY v;
$$ LANGUAGE SQL;

-- Test 34: query (line 172)
SELECT * FROM f_orderby2() AS foo(a INT, b INT);

-- Test 35: statement (line 178)
INSERT INTO unindexed VALUES (1, 2), (3, 4), (5, 6), (7, 8);

-- Test 36: statement (line 181)
CREATE FUNCTION f_limit(i INT) RETURNS SETOF RECORD AS
$$
  DELETE FROM unindexed
  WHERE ctid IN (SELECT ctid FROM unindexed LIMIT i)
  RETURNING v;
$$ LANGUAGE SQL;

-- Test 37: query (line 187)
SELECT count(*) FROM f_limit(2) AS foo(v INT);

-- Test 38: query (line 192)
SELECT count(*) FROM f_limit(1) AS foo(v INT);

-- Test 39: query (line 197)
SELECT count(*) FROM f_limit(5) AS foo(v INT);

-- Test 40: statement (line 225)
CREATE TABLE u_a (
  a INT,
  b TEXT,
  c INT
);
CREATE TABLE u_b (
  a INT,
  b TEXT
);
CREATE TABLE u_c (
  a INT,
  b TEXT,
  c INT
);
CREATE TABLE u_d (
  a INT,
  b INT
);
CREATE FUNCTION f_using_filter(p_b TEXT) RETURNS INT LANGUAGE SQL AS $$
  WITH del AS (
    DELETE FROM u_a
    USING u_b
    WHERE u_a.c = u_b.a
      AND u_b.b = p_b
    RETURNING 1
  )
  SELECT count(*) FROM del;
$$;

-- Test 41: statement (line 231)
INSERT INTO u_a VALUES (1, 'a', 10), (2, 'b', 20), (3, 'c', 30), (4, 'd', 40);

-- Test 42: statement (line 234)
INSERT INTO u_b VALUES (10, 'a'), (20, 'b'), (30, 'c'), (40, 'd');

-- Test 43: statement (line 237)
INSERT INTO u_c VALUES (1, 'a', 10), (2, 'b', 50), (3, 'c', 50), (4, 'd', 40);

-- Test 44: query (line 247)
SELECT f_using_filter('d');

-- Test 45: query (line 252)
SELECT * FROM u_a;

-- Test 46: statement (line 260)
INSERT INTO u_a VALUES (5, 'd', 5), (6, 'e', 6);

-- Test 47: statement (line 263)
CREATE FUNCTION f_using_self_join() RETURNS SETOF RECORD AS
$$
  DELETE FROM u_a USING u_a u_a2 WHERE u_a.a = u_a2.c RETURNING *
$$ LANGUAGE SQL;

-- Test 48: query (line 269)
SELECT f_using_self_join();

-- Test 49: query (line 275)
SELECT * FROM u_a;

-- Test 50: statement (line 284)
INSERT INTO u_c VALUES (30, 'a', 1);

-- Test 51: statement (line 287)
CREATE FUNCTION f_using_multi() RETURNS SETOF RECORD AS
$$
DELETE FROM u_a USING u_b, u_c WHERE u_a.c = u_b.a AND u_a.c = u_c.a RETURNING *
$$ LANGUAGE SQL;

-- Test 52: query (line 293)
SELECT f_using_multi();

-- Test 53: query (line 298)
SELECT * FROM u_a;

-- Test 54: statement (line 308)
CREATE TABLE t146414 (
  a INT NOT NULL,
  b INT GENERATED ALWAYS AS (a + 1) STORED
);

-- Test 55: statement (line 314)
CREATE FUNCTION f146414() RETURNS INT LANGUAGE SQL AS $$
  DELETE FROM t146414 WHERE a = 1 RETURNING b;
  SELECT 1;
$$;

-- Test 56: statement (line 320)
ALTER TABLE t146414 DROP COLUMN b;

-- Test 57: statement (line 323)
\set ON_ERROR_STOP 0
SELECT f146414();
\set ON_ERROR_STOP 1

-- Test 58: statement (line 331)
CREATE TABLE table_drop (
  a INT NOT NULL,
  b INT NOT NULL,
  c INT NOT NULL,
  d INT GENERATED ALWAYS AS (a + b) STORED
  -- Hash-sharded indexes generate a hidden computed column.
);
CREATE INDEX i ON table_drop USING hash (b);
INSERT INTO table_drop VALUES (1,2,3), (4,5,6), (7,8,9);

-- Test 59: statement (line 342)
CREATE FUNCTION f_delete() RETURNS INT LANGUAGE SQL AS $$
  DELETE FROM table_drop WHERE a = b - 1;
  SELECT 1;
$$;

-- Test 60: statement (line 348)
DROP INDEX i;

-- Test 61: statement (line 351)
ALTER TABLE table_drop DROP COLUMN d;

-- Test 62: statement (line 354)
ALTER TABLE table_drop DROP COLUMN c;

-- Test 63: statement (line 357)
ALTER TABLE table_drop DROP COLUMN b;

-- Test 64: statement (line 360)
ALTER TABLE table_drop DROP COLUMN a;

RESET client_min_messages;
