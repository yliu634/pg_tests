-- PostgreSQL compatible tests from distsql_join
-- NOTE: CockroachDB DistSQL join planning is not applicable to PostgreSQL.
-- This file runs a basic join query.

SET client_min_messages = warning;

DROP TABLE IF EXISTS j1;
DROP TABLE IF EXISTS j2;

CREATE TABLE j1 (id INT PRIMARY KEY, v TEXT);
CREATE TABLE j2 (id INT PRIMARY KEY, w TEXT);

INSERT INTO j1 VALUES (1, 'a'), (2, 'b');
INSERT INTO j2 VALUES (2, 'B'), (3, 'C');

SELECT j1.id, j1.v, j2.w
FROM j1
LEFT JOIN j2 USING (id)
ORDER BY j1.id;

RESET client_min_messages;
