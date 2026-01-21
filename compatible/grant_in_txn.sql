-- PostgreSQL compatible tests from grant_in_txn
-- 72 tests

SET client_min_messages = warning;
SET statement_timeout = '10s';

-- This test focuses on transactional behavior of GRANT/REVOKE and role
-- membership changes in PostgreSQL. CockroachDB-specific database/table
-- wildcards and system tables are omitted.

-- Cleanup any leftover global objects from a previous run.
DROP SCHEMA IF EXISTS gitxn CASCADE;
DROP ROLE IF EXISTS gitxn_user1;
DROP ROLE IF EXISTS gitxn_user2;
DROP ROLE IF EXISTS gitxn_role1;
DROP ROLE IF EXISTS gitxn_role2;

CREATE ROLE gitxn_user1 LOGIN;
CREATE ROLE gitxn_user2 LOGIN;
CREATE ROLE gitxn_role1;
CREATE ROLE gitxn_role2;

-- Allow the harness user to switch roles with `SET ROLE`.
GRANT gitxn_user1, gitxn_user2, gitxn_role1, gitxn_role2 TO CURRENT_USER;

CREATE SCHEMA gitxn;
CREATE TABLE gitxn.t(i int);

-- Transaction 1: GRANT then ROLLBACK.
BEGIN;
GRANT SELECT ON TABLE gitxn.t TO gitxn_role1;
SELECT has_table_privilege('gitxn_role1', 'gitxn.t', 'SELECT') AS role1_select_in_txn;
ROLLBACK;

SELECT has_table_privilege('gitxn_role1', 'gitxn.t', 'SELECT') AS role1_select_after_rollback;

-- Transaction 2: GRANT then COMMIT.
BEGIN;
GRANT SELECT ON TABLE gitxn.t TO gitxn_role1;
COMMIT;

SELECT has_table_privilege('gitxn_role1', 'gitxn.t', 'SELECT') AS role1_select_after_commit;

-- Transaction 3: role membership (GRANT role TO role) with ADMIN OPTION.
-- Grant role1 to CURRENT_USER so role2 becomes applicable via inheritance.
GRANT gitxn_role1 TO CURRENT_USER;

BEGIN;
GRANT gitxn_role2 TO gitxn_role1 WITH ADMIN OPTION;
COMMIT;

SELECT
  pg_get_userbyid(m.roleid) AS role,
  pg_get_userbyid(m.member) AS member,
  m.admin_option
FROM pg_auth_members m
WHERE pg_get_userbyid(m.roleid) = 'gitxn_role2'
  AND pg_get_userbyid(m.member) = 'gitxn_role1'
ORDER BY role, member;

SELECT grantee, role_name, is_grantable
FROM information_schema.applicable_roles
WHERE grantee = current_user
  AND role_name IN ('gitxn_role1', 'gitxn_role2')
ORDER BY grantee, role_name;

-- Cleanup.
DROP SCHEMA gitxn CASCADE;

DROP ROLE gitxn_role2;
DROP ROLE gitxn_role1;
DROP ROLE gitxn_user2;
DROP ROLE gitxn_user1;

RESET client_min_messages;

