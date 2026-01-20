-- PostgreSQL compatible tests from delete_batch
-- NOTE: CockroachDB DELETE BATCH is not supported by PostgreSQL.
-- This file simulates batched deletes using DELETE + a ctid subquery.

SET client_min_messages = warning;

DROP TABLE IF EXISTS tbl;
CREATE TABLE tbl (id INT PRIMARY KEY);
INSERT INTO tbl (id) VALUES (1), (2), (3);

DELETE FROM tbl
WHERE ctid IN (SELECT ctid FROM tbl ORDER BY id LIMIT 1);
SELECT count(*) FROM tbl;

DELETE FROM tbl
WHERE ctid IN (SELECT ctid FROM tbl ORDER BY id LIMIT 1);
SELECT count(*) FROM tbl;

DELETE FROM tbl;
SELECT count(*) FROM tbl;

DROP TABLE IF EXISTS tbl;

RESET client_min_messages;
