-- PostgreSQL compatible tests from grant_table
--
-- CockroachDB's `SHOW GRANTS` isn't available in PostgreSQL; this file uses
-- information_schema helpers plus has_table_privilege() checks to validate
-- GRANT/REVOKE behavior without emitting ERRORs during expected regen.

SET client_min_messages = warning;

-- Roles are cluster-global; use a file-specific prefix.
DROP ROLE IF EXISTS gt_roach;
DROP ROLE IF EXISTS "gt-test-user";
DROP ROLE IF EXISTS gt_readwrite;

DROP SCHEMA IF EXISTS gt CASCADE;

CREATE ROLE gt_readwrite;
CREATE ROLE "gt-test-user";
CREATE ROLE gt_roach;

CREATE SCHEMA gt;
GRANT USAGE, CREATE ON SCHEMA gt TO gt_readwrite, "gt-test-user", gt_roach;

-- Helper view approximating `SHOW GRANTS ON <table>`.
CREATE OR REPLACE VIEW table_grants AS
SELECT table_schema, table_name, grantee, privilege_type, is_grantable
FROM information_schema.role_table_grants;

GRANT SELECT ON table_grants TO PUBLIC;

-- Test 1: create table.
CREATE TABLE gt.t (id INT PRIMARY KEY);

-- Test 2: initial privileges for a role (should be false).
SELECT
  has_table_privilege('gt_readwrite', 'gt.t', 'SELECT') AS rw_select,
  has_table_privilege('gt_readwrite', 'gt.t', 'INSERT') AS rw_insert,
  has_table_privilege('gt_readwrite', 'gt.t', 'UPDATE') AS rw_update,
  has_table_privilege('gt_readwrite', 'gt.t', 'DELETE') AS rw_delete;

-- Test 3: grant ALL with GRANT OPTION.
GRANT ALL PRIVILEGES ON TABLE gt.t TO gt_readwrite, "gt-test-user" WITH GRANT OPTION;

-- Test 4: show grants on table t.
SELECT grantee, privilege_type, is_grantable
FROM table_grants
WHERE table_schema = 'gt' AND table_name = 't'
  AND grantee IN ('gt_readwrite', 'gt-test-user')
ORDER BY grantee, privilege_type;

-- Test 5: revoke a subset of privileges from both.
REVOKE INSERT, DELETE ON TABLE gt.t FROM "gt-test-user", gt_readwrite;

-- Test 6: show grants after partial revoke.
SELECT grantee, privilege_type, is_grantable
FROM table_grants
WHERE table_schema = 'gt' AND table_name = 't'
  AND grantee IN ('gt_readwrite', 'gt-test-user')
ORDER BY grantee, privilege_type;

-- Test 7: revoke ALL (removes remaining rows for these grantees).
REVOKE ALL PRIVILEGES ON TABLE gt.t FROM gt_readwrite, "gt-test-user";

-- Test 8: show grants after full revoke (0 rows).
SELECT grantee, privilege_type, is_grantable
FROM table_grants
WHERE table_schema = 'gt' AND table_name = 't'
  AND grantee IN ('gt_readwrite', 'gt-test-user')
ORDER BY grantee, privilege_type;

-- Test 9: view grants use the same information_schema view.
CREATE VIEW gt.v AS SELECT id FROM gt.t;
GRANT SELECT ON TABLE gt.v TO gt_readwrite, "gt-test-user" WITH GRANT OPTION;

SELECT grantee, privilege_type, is_grantable
FROM table_grants
WHERE table_schema = 'gt' AND table_name = 'v'
  AND grantee IN ('gt_readwrite', 'gt-test-user')
ORDER BY grantee, privilege_type;

-- Test 10: `SHOW GRANTS FOR <user>` equivalent for table privileges.
CREATE TABLE gt.table1 (count INT);
CREATE TABLE gt.table2 (count INT);
GRANT ALL PRIVILEGES ON TABLE gt.table1, gt.table2 TO gt_roach;

SELECT table_schema, table_name, privilege_type, is_grantable
FROM table_grants
WHERE grantee = 'gt_roach' AND table_schema = 'gt'
ORDER BY table_name, privilege_type;

RESET client_min_messages;

