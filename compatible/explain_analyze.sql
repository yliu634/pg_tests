-- PostgreSQL compatible tests from explain_analyze
--
-- CockroachDB supports EXPLAIN ANALYZE (DISTSQL)/(PLAN) and EXPLAIN on DDL.
-- PostgreSQL does not. This file uses PG-native EXPLAIN (ANALYZE) on DML/SELECT
-- and disables timing/summary output for deterministic results.

SET client_min_messages = warning;
DROP TABLE IF EXISTS kv;
DROP TABLE IF EXISTS ab;
DROP TABLE IF EXISTS a;
DROP TABLE IF EXISTS c;
DROP TABLE IF EXISTS p;
RESET client_min_messages;

CREATE TABLE kv (k INT PRIMARY KEY, v INT);
INSERT INTO kv VALUES (1, 10), (2, 20), (3, 30), (4, 40);

CREATE TABLE ab (a INT PRIMARY KEY, b INT);
INSERT INTO ab VALUES (10, 100), (40, 400), (50, 500);

CREATE TABLE a (a INT PRIMARY KEY);
INSERT INTO a VALUES (1), (2), (3);

EXPLAIN (ANALYZE, TIMING off, SUMMARY off, COSTS false)
SELECT a FROM a WHERE a > 1;

EXPLAIN (ANALYZE, TIMING off, SUMMARY off, COSTS false)
UPDATE a SET a = a + 10;

EXPLAIN (ANALYZE, TIMING off, SUMMARY off, COSTS false)
INSERT INTO a VALUES (10) ON CONFLICT (a) DO NOTHING;

EXPLAIN (ANALYZE, TIMING off, SUMMARY off, COSTS false)
DELETE FROM a WHERE a >= 3;

-- Foreign key DDL (no EXPLAIN for DDL in PG).
CREATE TABLE p (p INT8 PRIMARY KEY);
CREATE TABLE c (c INT8 PRIMARY KEY, p INT8 REFERENCES p (p));
