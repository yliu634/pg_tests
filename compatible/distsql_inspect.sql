-- PostgreSQL compatible tests from distsql_inspect
-- NOTE: CockroachDB INSPECT and DistSQL diagnostics are not available in PostgreSQL.
-- This file runs a simple EXPLAIN.

SET client_min_messages = warning;

DROP TABLE IF EXISTS insp_tbl;
CREATE TABLE insp_tbl (id INT PRIMARY KEY, v INT);
INSERT INTO insp_tbl VALUES (1, 10), (2, 20);

EXPLAIN (COSTS OFF)
SELECT * FROM insp_tbl WHERE id = 2;

RESET client_min_messages;
