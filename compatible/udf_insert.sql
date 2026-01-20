-- PostgreSQL compatible tests from udf_insert
-- Reduced subset: CockroachDB routine dependency settings, VIRTUAL computed
-- columns, and hash-sharded internals are removed. Validate INSERT/UPSERT
-- behavior inside SQL-language functions, including RETURNING and defaults.

SET client_min_messages = warning;
DROP TABLE IF EXISTS t CASCADE;
DROP TABLE IF EXISTS t_multi CASCADE;
DROP TABLE IF EXISTS t_gen CASCADE;
DROP TABLE IF EXISTS t_checkb CASCADE;
DROP FUNCTION IF EXISTS f_void();
DROP FUNCTION IF EXISTS f_insert(int,int);
DROP FUNCTION IF EXISTS f_default(int);
DROP FUNCTION IF EXISTS f_insert_select(int,int);
DROP FUNCTION IF EXISTS f_2values(int,int,int,int);
DROP FUNCTION IF EXISTS f_upsert(int,int);
DROP FUNCTION IF EXISTS f_gen(int);
DROP FUNCTION IF EXISTS f_checkb(int,int);
RESET client_min_messages;

CREATE TABLE t (
  a INT PRIMARY KEY,
  b INT DEFAULT 0
);

CREATE FUNCTION f_void() RETURNS VOID
LANGUAGE SQL
AS $$
  INSERT INTO t VALUES (0, 1) ON CONFLICT (a) DO UPDATE SET b = EXCLUDED.b;
$$;

SELECT f_void();

CREATE FUNCTION f_insert(i INT, j INT) RETURNS TABLE(a INT, b INT)
LANGUAGE SQL
AS $$
  INSERT INTO t VALUES (i, j) RETURNING a, b;
$$;

SELECT * FROM f_insert(1, 2);
SELECT * FROM f_insert(3, 4);

CREATE FUNCTION f_default(i INT) RETURNS TABLE(a INT, b INT)
LANGUAGE SQL
AS $$
  INSERT INTO t VALUES (i, DEFAULT) RETURNING a, b;
$$;

SELECT * FROM f_default(5);

-- Insert then return a filtered view of the table.
CREATE FUNCTION f_insert_select(i INT, j INT) RETURNS TABLE(a INT, b INT)
LANGUAGE SQL
AS $$
  INSERT INTO t VALUES (i, j) ON CONFLICT (a) DO UPDATE SET b = EXCLUDED.b;
  SELECT a, b FROM t WHERE a >= 3 ORDER BY a;
$$;

SELECT * FROM f_insert_select(3, 40);
SELECT * FROM f_insert_select(7, 8);

SELECT * FROM t ORDER BY a;

CREATE TABLE t_multi (
  a INT PRIMARY KEY,
  b INT DEFAULT 0
);

CREATE FUNCTION f_2values(i INT, j INT, m INT, n INT) RETURNS TABLE(a INT, b INT)
LANGUAGE SQL
AS $$
  INSERT INTO t_multi VALUES (i, j), (m, n)
  ON CONFLICT (a) DO UPDATE SET b = EXCLUDED.b;
  SELECT a, b FROM t_multi WHERE a IN (i, m) ORDER BY a;
$$;

SELECT * FROM f_2values(7, 8, 9, 10);
SELECT * FROM f_2values(7, 80, 9, 100);

-- Upsert with RETURNING.
CREATE FUNCTION f_upsert(i INT, j INT) RETURNS TABLE(a INT, b INT)
LANGUAGE SQL
AS $$
  INSERT INTO t VALUES (i, j)
  ON CONFLICT (a) DO UPDATE SET b = EXCLUDED.b
  RETURNING a, b;
$$;

SELECT * FROM f_upsert(3, 400);
SELECT * FROM t ORDER BY a;

-- INSERT ... RETURNING on generated columns.
CREATE TABLE t_gen (
  a INT NOT NULL,
  b INT GENERATED ALWAYS AS (a + 1) STORED
);

CREATE FUNCTION f_gen(x INT) RETURNS INT
LANGUAGE SQL
AS $$
  INSERT INTO t_gen (a) VALUES (x) RETURNING b;
$$;

SELECT f_gen(100) AS gen_b;
SELECT * FROM t_gen ORDER BY a;

-- Upsert into table with check constraint (use valid values to keep output clean).
CREATE TABLE t_checkb (
  a INT PRIMARY KEY,
  b INT,
  CONSTRAINT check_b CHECK (b > 1)
);

CREATE FUNCTION f_checkb(i INT, j INT) RETURNS TABLE(a INT, b INT)
LANGUAGE SQL
AS $$
  INSERT INTO t_checkb VALUES (i, j)
  ON CONFLICT (a) DO UPDATE SET b = EXCLUDED.b
  RETURNING a, b;
$$;

SELECT * FROM f_checkb(1, 2);
SELECT * FROM f_checkb(1, 3);
SELECT * FROM t_checkb ORDER BY a;
