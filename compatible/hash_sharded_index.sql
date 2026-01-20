-- PostgreSQL compatible tests from hash_sharded_index
--
-- CockroachDB hash-sharded indexes (USING HASH WITH bucket_count) are not
-- supported in PostgreSQL. This file keeps a small deterministic sanity test.

SET client_min_messages = warning;

DROP TABLE IF EXISTS hsi_t;

CREATE TABLE hsi_t (a INT PRIMARY KEY, b INT);
INSERT INTO hsi_t VALUES (1, 10), (2, 20), (3, 30);

SELECT * FROM hsi_t ORDER BY a;

DROP TABLE hsi_t;

RESET client_min_messages;
