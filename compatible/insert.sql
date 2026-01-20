-- PostgreSQL compatible tests from insert
--
-- The original CockroachDB logic test contains many intentional error cases and
-- CRDB-only table definitions. This file keeps a deterministic subset of INSERT
-- behaviors that run cleanly on PostgreSQL.

SET client_min_messages = warning;

DROP TABLE IF EXISTS ins_kv;
DROP TABLE IF EXISTS ins_nums;

CREATE TABLE ins_kv (
  k TEXT PRIMARY KEY,
  v TEXT
);

INSERT INTO ins_kv VALUES ('a', 'b');
INSERT INTO ins_kv (v, k) VALUES ('d', 'c');
INSERT INTO ins_kv (k) VALUES ('nil1');
INSERT INTO ins_kv (k, v) VALUES ('e', 'f'), ('g', '');

-- INSERT .. RETURNING used as a subquery/cte.
WITH ins AS (
  INSERT INTO ins_kv VALUES ('i', 'j')
  RETURNING v
)
SELECT v || 'hello' AS vhello FROM ins;

-- Simple upsert.
INSERT INTO ins_kv(k, v) VALUES ('a', 'bb')
ON CONFLICT (k) DO UPDATE SET v = EXCLUDED.v;

SELECT * FROM ins_kv ORDER BY k;

CREATE TABLE ins_nums (i INT PRIMARY KEY, v INT);
INSERT INTO ins_nums
SELECT x, x * 10 FROM generate_series(1, 3) AS g(x);
SELECT * FROM ins_nums ORDER BY i;

-- Cleanup.
DROP TABLE ins_nums;
DROP TABLE ins_kv;

RESET client_min_messages;
