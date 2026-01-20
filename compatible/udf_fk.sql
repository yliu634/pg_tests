-- PostgreSQL compatible tests from udf_fk
-- Reduced subset: CockroachDB schema locking, index-hint syntax, and some
-- dependency-tracking internals are removed. Validate SQL UDFs that perform
-- DML in the presence of FOREIGN KEY constraints (including deferrable FKs).

SET client_min_messages = warning;
DROP TABLE IF EXISTS child CASCADE;
DROP TABLE IF EXISTS parent CASCADE;
DROP SEQUENCE IF EXISTS s;
DROP FUNCTION IF EXISTS f_fk_p(int);
DROP FUNCTION IF EXISTS f_fk_c(int,int);
DROP FUNCTION IF EXISTS f_fk_p_c(int,int);
DROP FUNCTION IF EXISTS f_fk_del_parent(int);
DROP FUNCTION IF EXISTS f_fk_c_seq(int,int);
RESET client_min_messages;

CREATE TABLE parent (
  p INT PRIMARY KEY
);

CREATE TABLE child (
  c INT PRIMARY KEY,
  p INT NOT NULL REFERENCES parent(p) ON DELETE CASCADE DEFERRABLE INITIALLY IMMEDIATE
);

CREATE FUNCTION f_fk_p(r INT) RETURNS TABLE(p INT)
LANGUAGE SQL
AS $$
  INSERT INTO parent VALUES (r) RETURNING p;
$$;

CREATE FUNCTION f_fk_c(k INT, r INT) RETURNS TABLE(c INT, p INT)
LANGUAGE SQL
AS $$
  INSERT INTO child VALUES (k, r) RETURNING c, p;
$$;

-- Immediate FK checks: insert parent first, then child.
SELECT * FROM f_fk_p(1);
SELECT * FROM f_fk_c(100, 1);

-- Deferred FK checks: insert child before parent within a deferred transaction.
BEGIN;
SET CONSTRAINTS ALL DEFERRED;
SELECT * FROM f_fk_c(101, 2);
SELECT * FROM f_fk_p(2);
COMMIT;

SELECT * FROM parent ORDER BY p;
SELECT * FROM child ORDER BY c;

-- Multi-statement SQL UDF that ensures parent exists before inserting child.
CREATE FUNCTION f_fk_p_c(k INT, r INT) RETURNS TABLE(c INT, p INT)
LANGUAGE SQL
AS $$
  INSERT INTO parent VALUES (r) ON CONFLICT (p) DO NOTHING;
  INSERT INTO child VALUES (k, r) RETURNING c, p;
$$;

SELECT * FROM f_fk_p_c(102, 3);

-- Sequence + FK interaction in a single SQL statement via CTEs.
CREATE SEQUENCE s;

CREATE FUNCTION f_fk_c_seq(k INT, r INT) RETURNS TABLE(c INT, p INT, seq BIGINT)
LANGUAGE SQL
AS $$
  WITH seq AS (SELECT nextval('s') AS seq),
       ins_p AS (INSERT INTO parent VALUES (r) ON CONFLICT (p) DO NOTHING),
       ins_c AS (INSERT INTO child VALUES (k, r) RETURNING c, p)
  SELECT ins_c.c, ins_c.p, seq.seq
  FROM ins_c, seq;
$$;

SELECT * FROM f_fk_c_seq(200, 4);
SELECT currval('s') AS curr_seq;

-- Cascading delete via SQL UDF (child rows are removed by ON DELETE CASCADE).
CREATE FUNCTION f_fk_del_parent(r INT) RETURNS TABLE(p INT)
LANGUAGE SQL
AS $$
  DELETE FROM parent WHERE p = r RETURNING p;
$$;

SELECT * FROM f_fk_del_parent(1);
SELECT * FROM parent ORDER BY p;
SELECT * FROM child ORDER BY c;
