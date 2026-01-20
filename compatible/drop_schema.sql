-- PostgreSQL compatible tests from drop_schema
--
-- CockroachDB has cross-database schema references and system schemas that do
-- not exist in PG. This file exercises DROP SCHEMA ... CASCADE.

SET client_min_messages = warning;
DROP SCHEMA IF EXISTS drop_schema_test CASCADE;
RESET client_min_messages;

CREATE SCHEMA drop_schema_test;
CREATE TYPE drop_schema_test.enum_test AS ENUM ('s', 't');
CREATE TABLE drop_schema_test.t(a INT, e drop_schema_test.enum_test);
CREATE VIEW drop_schema_test.v AS SELECT a FROM drop_schema_test.t;
CREATE SEQUENCE drop_schema_test.seq;

SELECT nspname FROM pg_namespace WHERE nspname = 'drop_schema_test';

DROP SCHEMA drop_schema_test CASCADE;

SELECT nspname FROM pg_namespace WHERE nspname = 'drop_schema_test';

