-- PostgreSQL compatible tests from direct_columnar_scans
-- NOTE: CockroachDB direct_columnar_scans_enabled and column FAMILY clauses are not supported by PostgreSQL.

SET client_min_messages = warning;

DROP TABLE IF EXISTS t145232;

CREATE TABLE t145232 (
  k INT PRIMARY KEY,
  a INT NOT NULL,
  b INT NOT NULL,
  c INT NOT NULL,
  v INT NOT NULL DEFAULT 5
);

INSERT INTO t145232 VALUES (2, 2, 2, 2, DEFAULT);

SELECT * FROM t145232 WHERE k = 2;

RESET client_min_messages;
