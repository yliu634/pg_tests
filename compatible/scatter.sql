-- PostgreSQL compatible tests from scatter
--
-- CockroachDB has `ALTER TABLE ... SCATTER` for distributing ranges. PostgreSQL
-- has no equivalent. This file keeps a minimal DDL smoke test.

SET client_min_messages = warning;

DROP TABLE IF EXISTS t;
CREATE TABLE t (a INT PRIMARY KEY);
DROP TABLE t;

RESET client_min_messages;
