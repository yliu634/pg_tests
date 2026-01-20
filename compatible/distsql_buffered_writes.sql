-- PostgreSQL compatible tests from distsql_buffered_writes
-- NOTE: CockroachDB DistSQL buffered writes are not applicable to PostgreSQL.
-- This file is rewritten to run a small transactional write workload.

SET client_min_messages = warning;

DROP TABLE IF EXISTS bw_tbl;
CREATE TABLE bw_tbl (id INT PRIMARY KEY, v TEXT);

BEGIN;
INSERT INTO bw_tbl (id, v) VALUES (1, 'a'), (2, 'b');
INSERT INTO bw_tbl (id, v) VALUES (3, 'c');
COMMIT;

SELECT count(*) FROM bw_tbl;

RESET client_min_messages;
