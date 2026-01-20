-- PostgreSQL compatible tests from distsql_distinct_on
-- NOTE: CockroachDB DistSQL is not applicable to PostgreSQL.
-- This file runs a small DISTINCT ON query.

SET client_min_messages = warning;

DROP TABLE IF EXISTS ddo;
CREATE TABLE ddo (a INT, b INT);
INSERT INTO ddo VALUES (1, 10), (1, 20), (2, 5), (2, 7);

SELECT DISTINCT ON (a) a, b
FROM ddo
ORDER BY a, b DESC;

RESET client_min_messages;
