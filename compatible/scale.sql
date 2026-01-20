-- PostgreSQL compatible tests from scale
--
-- The upstream CockroachDB logic-test file contains many overflow/invalid-value
-- cases that would emit ERRORs in PostgreSQL. This reduced version keeps only
-- valid inserts/updates that demonstrate type ranges and numeric scale.

SET client_min_messages = warning;

DROP TABLE IF EXISTS test;
DROP TABLE IF EXISTS tb;
DROP TABLE IF EXISTS tc;
DROP TABLE IF EXISTS tc1;
DROP TABLE IF EXISTS td;

CREATE TABLE test (t CHAR(4));
CREATE UNIQUE INDEX test_t_uq ON test(t);
INSERT INTO test VALUES ('a'), ('ab'), ('abcd');

CREATE TABLE tb (b BIT(3));
CREATE UNIQUE INDEX tb_b_uq ON tb(b);
INSERT INTO tb VALUES (B'001'), (B'011'), (B'111');
UPDATE tb SET b = B'010' WHERE b = B'111';

CREATE TABLE tc (b INT2);
CREATE UNIQUE INDEX tc_b_uq ON tc(b);
INSERT INTO tc VALUES (50), (-32768), (32767);
UPDATE tc SET b = 80 WHERE b = 50;

CREATE TABLE tc1 (b INT4);
CREATE UNIQUE INDEX tc1_b_uq ON tc1(b);
INSERT INTO tc1 VALUES (50), (-2147483648), (2147483647);
UPDATE tc1 SET b = 80 WHERE b = 50;

CREATE TABLE td (d NUMERIC(3, 2));
INSERT INTO td VALUES (NUMERIC '3.1'), (NUMERIC '3.14'), (NUMERIC '3.1415');
SELECT d FROM td ORDER BY d;
UPDATE td SET d = NUMERIC '1.414' WHERE d = NUMERIC '3.14';
SELECT d FROM td ORDER BY d;

DROP TABLE test;
DROP TABLE tb;
DROP TABLE tc;
DROP TABLE tc1;
DROP TABLE td;

RESET client_min_messages;
