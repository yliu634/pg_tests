-- PostgreSQL compatible tests from hash_join_dist
--
-- CockroachDB logic tests included distributed-execution introspection and HASH
-- JOIN hints; PostgreSQL chooses join strategies automatically.

SET client_min_messages = warning;

DROP TABLE IF EXISTS hjd_t;
DROP TABLE IF EXISTS hjd_xy;
DROP TABLE IF EXISTS hjd_small;
DROP TABLE IF EXISTS hjd_large;

CREATE TABLE hjd_t (k INT, v INT);
INSERT INTO hjd_t VALUES (1, 10), (2, 20), (3, 30);

CREATE TABLE hjd_xy (x INT PRIMARY KEY, y INT);
INSERT INTO hjd_xy VALUES (2, 200), (3, 300), (4, 400);

SELECT *
FROM hjd_t
WHERE EXISTS (SELECT 1 FROM hjd_xy WHERE x = hjd_t.k)
ORDER BY 1;

CREATE TABLE hjd_small (a INT PRIMARY KEY, b INT);
CREATE TABLE hjd_large (c INT, d INT);

INSERT INTO hjd_small SELECT x, 3 * x FROM generate_series(1, 10) AS g(x);
INSERT INTO hjd_large SELECT 2 * x, 4 * x FROM generate_series(1, 10) AS g(x);

SELECT hjd_small.b, hjd_large.d
FROM hjd_large
RIGHT JOIN hjd_small ON hjd_small.b = hjd_large.c AND hjd_large.d < 30
ORDER BY 1
LIMIT 5;

-- Cleanup.
DROP TABLE hjd_t;
DROP TABLE hjd_xy;
DROP TABLE hjd_small;
DROP TABLE hjd_large;

RESET client_min_messages;
