-- PostgreSQL compatible tests from export
--
-- CockroachDB has EXPORT INTO CSV/PARQUET. PostgreSQL does not; the closest
-- equivalent is COPY. This file uses COPY ... TO STDOUT for deterministic
-- output under psql.

SET client_min_messages = warning;
DROP TABLE IF EXISTS t;
DROP TABLE IF EXISTS t115290;
RESET client_min_messages;

CREATE TABLE t(k INT PRIMARY KEY);
INSERT INTO t VALUES (1);

COPY (SELECT * FROM t ORDER BY k) TO STDOUT WITH (FORMAT csv, HEADER true);

CREATE TABLE t115290 (
  id INT PRIMARY KEY,
  a INT NOT NULL,
  b INT
);
INSERT INTO t115290 VALUES (1, 10, 100), (2, 20, 200), (3, 30, NULL);

COPY (SELECT b FROM t115290 ORDER BY a) TO STDOUT WITH (FORMAT csv);

