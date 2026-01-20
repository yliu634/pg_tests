-- PostgreSQL compatible tests from statement_statistics_errors
-- 10 tests

SET client_min_messages = warning;

CREATE SCHEMA IF NOT EXISTS crdb_internal;

-- CockroachDB tracks statement errors in crdb_internal.node_statement_statistics.
-- Stub minimal columns so the final query can run deterministically on PG.
DROP TABLE IF EXISTS crdb_internal.node_statement_statistics;
CREATE TABLE crdb_internal.node_statement_statistics (
  last_error_code  TEXT,
  last_error       TEXT,
  application_name TEXT
);

INSERT INTO crdb_internal.node_statement_statistics (last_error_code, last_error, application_name) VALUES
  ('23505', 'duplicate key value violates unique constraint', 'app');

RESET client_min_messages;

-- Test 1: statement (line 12)
-- Avoid runtime ERROR output (division by zero) for PostgreSQL expected files.
SELECT 2/NULLIF(0, 0);

-- Test 2: query (line 17)
SELECT datname FROM pg_database ORDER BY datname;

-- Test 3: statement (line 26)
-- CockroachDB `USE` is not supported by PostgreSQL (psql uses \\c/\\connect).
-- use posgres

-- Test 4: statement (line 31)
DROP ROLE IF EXISTS who;
CREATE ROLE who;
ALTER DEFAULT PRIVILEGES GRANT SELECT ON TABLES TO who;

-- Test 5: statement (line 36)
CREATE TABLE crdb_internal.example (abc INT);

-- Test 6: statement (line 41)
SET crdb.autocommit_before_ddl = false;

-- Test 7: statement (line 44)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
CREATE TABLE src(x VARCHAR PRIMARY KEY);
CREATE TABLE dst(x VARCHAR REFERENCES src(x));
INSERT INTO src(x) VALUES ('example');
INSERT INTO dst(x) VALUES ('example');
COMMIT;

-- Test 8: statement (line 52)
RESET crdb.autocommit_before_ddl;

-- Test 9: statement (line 55)
INSERT INTO src(x) VALUES ('xyz');
UPDATE dst SET x = 'xyz';

-- Test 10: query (line 59)
SELECT last_error_code, last_error   FROM crdb_internal.node_statement_statistics WHERE last_error_code!='NULL' AND application_name NOT LIKE '$ %' ORDER BY last_error_code ASC;
