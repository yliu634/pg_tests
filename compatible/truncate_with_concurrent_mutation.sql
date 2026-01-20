-- PostgreSQL compatible tests from truncate_with_concurrent_mutation
-- Reduced subset: CockroachDB schema changer pausepoints/jobs are not available
-- in PostgreSQL; validate TRUNCATE after common DDL changes.

SET client_min_messages = warning;
DROP TABLE IF EXISTS t1 CASCADE;
DROP TABLE IF EXISTS t2 CASCADE;
DROP TABLE IF EXISTS t3 CASCADE;
DROP TABLE IF EXISTS t4 CASCADE;
DROP TYPE IF EXISTS e;
RESET client_min_messages;

CREATE TABLE t1(a INT PRIMARY KEY, b INT);
CREATE INDEX idx_b ON t1(b);
DROP INDEX idx_b;
TRUNCATE TABLE t1;

CREATE TYPE e AS ENUM ('v1', 'v2');
CREATE TABLE t2(a INT PRIMARY KEY, b e);
ALTER TABLE t2 DROP COLUMN b;
TRUNCATE TABLE t2;

CREATE TABLE t3(a INT PRIMARY KEY, b INT);
ALTER TABLE t3 ADD CONSTRAINT ckb CHECK (b > 3);
TRUNCATE TABLE t3;

CREATE TABLE t4(a INT PRIMARY KEY, b INT NOT NULL);
TRUNCATE TABLE t4;
