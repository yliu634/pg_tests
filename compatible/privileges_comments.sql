-- PostgreSQL compatible tests from privileges_comments
--
-- CockroachDB logic-test directives like `user`, `SET DATABASE`, `onlyif`, and
-- `skipif` are not valid SQL in psql scripts. PostgreSQL also requires an
-- explicit connection switch to operate on a different database.

SET client_min_messages = warning;

-- Cleanup from prior runs.
DROP DATABASE IF EXISTS d45707;
DROP ROLE IF EXISTS pc_testuser;

CREATE ROLE pc_testuser;
CREATE DATABASE d45707 OWNER pc_testuser;

\c d45707
SET client_min_messages = warning;

SET ROLE pc_testuser;

CREATE TABLE t45707(x INT PRIMARY KEY);

COMMENT ON DATABASE d45707 IS 'd45707';
COMMENT ON TABLE t45707 IS 't45707';
COMMENT ON COLUMN t45707.x IS 'x45707';
COMMENT ON INDEX t45707_pkey IS 'p45707';

SELECT shobj_description(oid, 'pg_database')
  FROM pg_database
 WHERE datname = 'd45707';

SELECT col_description('t45707'::regclass, 1);
SELECT obj_description('t45707'::regclass);
SELECT obj_description('t45707_pkey'::regclass);

-- Update comments as the owning role.
COMMENT ON DATABASE d45707 IS 'd45707_2';
COMMENT ON TABLE t45707 IS 't45707_2';
COMMENT ON COLUMN t45707.x IS 'x45707_2';
COMMENT ON INDEX t45707_pkey IS 'p45707_2';

RESET ROLE;

\c postgres
SET client_min_messages = warning;
DROP DATABASE d45707;
DROP ROLE pc_testuser;

RESET client_min_messages;
