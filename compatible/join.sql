-- PostgreSQL compatible tests from join
--
-- The original CockroachDB logic test includes join hints and non-psql
-- directives. This file keeps a deterministic subset of join behavior.

SET client_min_messages = warning;

DROP TABLE IF EXISTS join_one;
DROP TABLE IF EXISTS join_other;
DROP TABLE IF EXISTS join_empty;

CREATE TABLE join_one (x INT);
INSERT INTO join_one(x) VALUES (44), (NULL), (42);

CREATE TABLE join_other (x INT);
INSERT INTO join_other(x) VALUES (43), (42), (16);

CREATE TABLE join_empty (x INT);

SELECT a.x AS ax, b.x AS bx
FROM join_one AS a CROSS JOIN join_one AS b
ORDER BY ax NULLS LAST, bx NULLS LAST
LIMIT 5;

SELECT a.x AS ax, b.x AS bx
FROM join_one AS a JOIN join_one AS b ON a.x = b.x
ORDER BY ax NULLS LAST;

SELECT x
FROM join_one
JOIN join_other USING (x)
ORDER BY x;

SELECT a.x AS ax, b.x AS bx
FROM join_one AS a LEFT JOIN join_empty AS b ON a.x = b.x
ORDER BY ax NULLS LAST;

SELECT a.x AS ax, b.x AS bx
FROM join_one AS a FULL OUTER JOIN join_other AS b USING (x)
ORDER BY COALESCE(a.x, b.x) NULLS LAST;

DROP TABLE join_empty;
DROP TABLE join_other;
DROP TABLE join_one;

RESET client_min_messages;
