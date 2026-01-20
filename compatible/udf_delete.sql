-- PostgreSQL compatible tests from udf_delete
-- Reduced subset: CockroachDB DELETE ... ORDER BY/LIMIT and various missing
-- setup tables are removed. Validate DELETE ... RETURNING in SQL functions.

SET client_min_messages = warning;
DROP TABLE IF EXISTS kv CASCADE;
DROP TABLE IF EXISTS unindexed CASCADE;
DROP FUNCTION IF EXISTS f_kv_predicate();
DROP FUNCTION IF EXISTS f_kv_all();
DROP FUNCTION IF EXISTS f_unindexed_predicate();
DROP FUNCTION IF EXISTS f_unindexed_all();
RESET client_min_messages;

CREATE TABLE kv (
  k INT PRIMARY KEY,
  v INT
);
INSERT INTO kv VALUES (1, 2), (3, 4), (5, 6), (7, 8);

CREATE FUNCTION f_kv_predicate() RETURNS TABLE(k INT, v INT)
LANGUAGE SQL
AS $$
  DELETE FROM kv WHERE k = 3 OR v = 6 RETURNING k, v;
$$;

SELECT * FROM f_kv_predicate() ORDER BY k;
SELECT * FROM kv ORDER BY k;

CREATE FUNCTION f_kv_all() RETURNS TABLE(k INT, v INT)
LANGUAGE SQL
AS $$
  DELETE FROM kv RETURNING k, v;
$$;

SELECT * FROM f_kv_all() ORDER BY k;
SELECT * FROM kv ORDER BY k;

CREATE TABLE unindexed (
  k INT PRIMARY KEY,
  v INT
);
INSERT INTO unindexed VALUES (1, 2), (3, 4), (5, 6), (7, 8);

CREATE FUNCTION f_unindexed_predicate() RETURNS TABLE(k INT, v INT)
LANGUAGE SQL
AS $$
  DELETE FROM unindexed WHERE k = 3 OR v = 6 RETURNING k, v;
$$;

SELECT * FROM f_unindexed_predicate() ORDER BY k;
SELECT * FROM unindexed ORDER BY k;

CREATE FUNCTION f_unindexed_all() RETURNS TABLE(k INT, v INT)
LANGUAGE SQL
AS $$
  DELETE FROM unindexed RETURNING k, v;
$$;

SELECT * FROM f_unindexed_all() ORDER BY k;
SELECT * FROM unindexed ORDER BY k;
