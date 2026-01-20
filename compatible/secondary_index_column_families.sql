-- PostgreSQL compatible tests from secondary_index_column_families
--
-- CockroachDB supports column families and `STORING` on secondary indexes.
-- PostgreSQL does not support column families, but it does support INCLUDE
-- columns on indexes (similar to STORING).

SET client_min_messages = warning;

DROP TABLE IF EXISTS t;

CREATE TABLE t (
  x INT PRIMARY KEY,
  y INT,
  z INT,
  w INT
);

CREATE INDEX i ON t (y) INCLUDE (z, w);

INSERT INTO t VALUES (1, 2, 3, 4);
UPDATE t SET z = NULL, w = NULL WHERE y = 2;

SELECT y, z, w FROM t WHERE y = 2;

SELECT indexname, indexdef
  FROM pg_indexes
 WHERE schemaname = 'public' AND tablename = 't'
 ORDER BY indexname;

DROP TABLE t;

RESET client_min_messages;
