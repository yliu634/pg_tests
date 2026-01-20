-- PostgreSQL compatible tests from dist_vectorize
-- NOTE: CockroachDB distsql/vectorize settings are not applicable to PostgreSQL.
-- This file is rewritten to run a simple EXPLAIN over a query.

SET client_min_messages = warning;

DROP TABLE IF EXISTS vec_tbl;
CREATE TABLE vec_tbl (id INT PRIMARY KEY, v INT);
INSERT INTO vec_tbl VALUES (1, 10), (2, 20), (3, 30);

EXPLAIN (COSTS OFF)
SELECT sum(v) FROM vec_tbl;

RESET client_min_messages;
