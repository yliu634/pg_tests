-- PostgreSQL compatible tests from distsql_subquery
-- NOTE: CockroachDB DistSQL subquery tests are not applicable to PostgreSQL.

SET client_min_messages = warning;

DROP TABLE IF EXISTS sq;
CREATE TABLE sq (id INT PRIMARY KEY, v INT);
INSERT INTO sq VALUES (1, 10), (2, 20), (3, 30);

SELECT id
FROM sq
WHERE v = (SELECT max(v) FROM sq);

RESET client_min_messages;
