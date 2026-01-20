-- PostgreSQL compatible tests from hash_join
--
-- CockroachDB logic tests used explicit HASH JOIN hints; PostgreSQL chooses join
-- algorithms automatically. These queries validate join semantics and keep the
-- output deterministic.

SET client_min_messages = warning;

DROP TABLE IF EXISTS hj_t1;
DROP TABLE IF EXISTS hj_t2;
DROP TABLE IF EXISTS hj_empty;
DROP TABLE IF EXISTS hj_onecolumn;

CREATE TABLE hj_t1 (k INT PRIMARY KEY, v INT);
INSERT INTO hj_t1 VALUES (0, 4), (2, 1), (5, 4), (3, 4), (-1, -1);

CREATE TABLE hj_t2 (x INT PRIMARY KEY, y INT);
INSERT INTO hj_t2 VALUES (1, 3), (4, 6), (0, 5), (3, 2);

-- Inner join.
SELECT hj_t1.k, hj_t1.v, hj_t2.x, hj_t2.y
FROM hj_t1
JOIN hj_t2 ON hj_t1.k = hj_t2.x
ORDER BY 1;

-- Inner join with projection + ordering.
SELECT hj_t2.y, hj_t1.v
FROM hj_t1
JOIN hj_t2 ON hj_t1.k = hj_t2.x
ORDER BY 1 DESC;

-- Left/right/full joins on a different predicate.
SELECT hj_t1.k, hj_t1.v, hj_t2.x, hj_t2.y
FROM hj_t1
LEFT JOIN hj_t2 ON hj_t1.v = hj_t2.x
ORDER BY 1;

SELECT hj_t1.k, hj_t1.v, hj_t2.x, hj_t2.y
FROM hj_t1
RIGHT JOIN hj_t2 ON hj_t1.v = hj_t2.x
ORDER BY 3;

SELECT hj_t1.k, hj_t1.v, hj_t2.x, hj_t2.y
FROM hj_t1
FULL JOIN hj_t2 ON hj_t1.v = hj_t2.x
ORDER BY COALESCE(hj_t1.k, -999), COALESCE(hj_t2.x, -999);

-- FULL OUTER JOIN against an empty input.
CREATE TABLE hj_empty (x INT);
CREATE TABLE hj_onecolumn (x INT);
INSERT INTO hj_onecolumn(x) VALUES (44), (NULL), (42);

SELECT hj_empty.x AS a_x, hj_onecolumn.x AS b_x
FROM hj_empty
FULL OUTER JOIN hj_onecolumn ON hj_empty.x = hj_onecolumn.x
ORDER BY b_x NULLS LAST;

-- Cleanup.
DROP TABLE hj_empty;
DROP TABLE hj_onecolumn;
DROP TABLE hj_t1;
DROP TABLE hj_t2;

RESET client_min_messages;
