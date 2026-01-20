-- PostgreSQL compatible tests from delete
-- NOTE: CockroachDB DELETE tests may include CRDB-specific syntax and directives.
-- This file is rewritten to cover core PostgreSQL DELETE behavior.

SET client_min_messages = warning;

DROP TABLE IF EXISTS t_delete;
CREATE TABLE t_delete (id INT PRIMARY KEY, v TEXT);
INSERT INTO t_delete (id, v) VALUES (1, 'a'), (2, 'b'), (3, 'c');

DELETE FROM t_delete WHERE id = 2;
SELECT * FROM t_delete ORDER BY id;

WITH del AS (
  DELETE FROM t_delete WHERE id > 0 RETURNING id
)
SELECT id FROM del ORDER BY id;
SELECT count(*) FROM t_delete;

RESET client_min_messages;
