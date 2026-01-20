-- PostgreSQL compatible tests from grant_in_txn
--
-- CockroachDB's original test exercises GRANT/role changes inside transactions
-- and savepoints, plus Cockroach-only features (database-qualified tables,
-- admin role, system tables, autocommit_before_ddl). This adapted test focuses
-- on PostgreSQL transactional GRANT behavior using schemas as stand-ins for
-- Cockroach "databases".

SET statement_timeout = '10s';

SET client_min_messages = warning;
DROP SCHEMA IF EXISTS gitx_db1 CASCADE;
DROP SCHEMA IF EXISTS gitx_db2 CASCADE;
DROP ROLE IF EXISTS gitx_user1;
DROP ROLE IF EXISTS gitx_user2;
DROP ROLE IF EXISTS gitx_role1;
DROP ROLE IF EXISTS gitx_role2;
RESET client_min_messages;

CREATE SCHEMA gitx_db1;
CREATE SCHEMA gitx_db2;

CREATE TABLE gitx_db1.t (id int PRIMARY KEY);
CREATE TABLE gitx_db2.t (id int PRIMARY KEY);

CREATE ROLE gitx_user1 LOGIN;
CREATE ROLE gitx_user2 LOGIN;
CREATE ROLE gitx_role1;
CREATE ROLE gitx_role2;

BEGIN;

GRANT USAGE ON SCHEMA gitx_db1 TO gitx_role1;
GRANT SELECT ON TABLE gitx_db1.t TO gitx_role1;
GRANT gitx_role1 TO gitx_user1;

SELECT
  has_schema_privilege('gitx_user1', 'gitx_db1', 'USAGE') AS user1_schema_usage,
  has_table_privilege('gitx_user1', 'gitx_db1.t', 'SELECT') AS user1_table_select;

SAVEPOINT before_extra_grant;
GRANT INSERT ON TABLE gitx_db1.t TO gitx_role1;
SELECT has_table_privilege('gitx_user1', 'gitx_db1.t', 'INSERT') AS user1_insert_before_rb;
ROLLBACK TO SAVEPOINT before_extra_grant;
SELECT has_table_privilege('gitx_user1', 'gitx_db1.t', 'INSERT') AS user1_insert_after_rb;

COMMIT;

-- After COMMIT: SELECT persists, INSERT (rolled back) does not.
SELECT
  has_table_privilege('gitx_user1', 'gitx_db1.t', 'SELECT') AS user1_select_after_commit,
  has_table_privilege('gitx_user1', 'gitx_db1.t', 'INSERT') AS user1_insert_after_commit;

SET client_min_messages = warning;
DROP SCHEMA IF EXISTS gitx_db1 CASCADE;
DROP SCHEMA IF EXISTS gitx_db2 CASCADE;
DROP ROLE IF EXISTS gitx_user1;
DROP ROLE IF EXISTS gitx_user2;
DROP ROLE IF EXISTS gitx_role1;
DROP ROLE IF EXISTS gitx_role2;
RESET client_min_messages;

