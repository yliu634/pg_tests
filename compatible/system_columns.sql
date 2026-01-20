-- PostgreSQL compatible tests from system_columns
-- Reduced subset: CockroachDB MVCC timestamp system columns are not available
-- in PostgreSQL; validate standard PostgreSQL system columns instead.

SET client_min_messages = warning;
DROP TABLE IF EXISTS t CASCADE;
DROP TABLE IF EXISTS tab1 CASCADE;
DROP TABLE IF EXISTS tab2 CASCADE;
RESET client_min_messages;

CREATE TABLE t (x INT PRIMARY KEY, y INT, z INT);
INSERT INTO t VALUES (1, 2, 3), (2, 3, 4);

-- xmin: inserting transaction id for each row.
SELECT x, xmin IS NOT NULL AS xmin_set FROM t ORDER BY x;

-- ctid: physical tuple identifier.
SELECT x, ctid FROM t ORDER BY x;

CREATE TABLE tab1 (x INT PRIMARY KEY);
CREATE TABLE tab2 (x INT PRIMARY KEY);
INSERT INTO tab1 VALUES (1), (2);
INSERT INTO tab2 VALUES (1), (2);

-- tableoid identifies the source relation.
SELECT tableoid::regclass AS rel, x FROM tab1 ORDER BY x;
SELECT tableoid::regclass AS rel, x FROM tab2 ORDER BY x;

SELECT tab1.tableoid::regclass AS rel1, tab1.x, tab2.tableoid::regclass AS rel2, tab2.x
FROM tab1 JOIN tab2 ON tab1.x = tab2.x
ORDER BY tab1.x;
