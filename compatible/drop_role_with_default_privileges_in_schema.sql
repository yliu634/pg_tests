-- PostgreSQL compatible tests from drop_role_with_default_privileges_in_schema
-- 29 tests
--
-- Notes for PostgreSQL:
-- - Default privileges are persisted in pg_default_acl and create dependencies.
-- - Roles are global (cluster-wide), so this test must clean up roles explicitly.

SET client_min_messages = warning;

-- Use unique role/schema names to avoid cross-test collisions.
\set ON_ERROR_STOP 0
DROP ROLE IF EXISTS dpdp_test1;
DROP ROLE IF EXISTS dpdp_test2;
DROP ROLE IF EXISTS dpdp_test3;
DROP ROLE IF EXISTS dpdp_test4;
DROP SCHEMA IF EXISTS dpdp_s CASCADE;
\set ON_ERROR_STOP 1

-- Default privileges owned by another role (FOR ROLE ...).
CREATE ROLE dpdp_test1;
CREATE ROLE dpdp_test2;

ALTER DEFAULT PRIVILEGES FOR ROLE dpdp_test1 IN SCHEMA public GRANT SELECT ON TABLES TO dpdp_test2;

\set ON_ERROR_STOP 0
DROP ROLE dpdp_test1;
DROP ROLE dpdp_test2;
\set ON_ERROR_STOP 1

ALTER DEFAULT PRIVILEGES FOR ROLE dpdp_test1 IN SCHEMA public REVOKE ALL ON TABLES FROM dpdp_test2;
ALTER DEFAULT PRIVILEGES FOR ROLE dpdp_test1 IN SCHEMA public REVOKE ALL ON TYPES FROM dpdp_test2;
ALTER DEFAULT PRIVILEGES FOR ROLE dpdp_test1 IN SCHEMA public REVOKE ALL ON SEQUENCES FROM dpdp_test2;

DROP ROLE dpdp_test1;
DROP ROLE dpdp_test2;

-- Cockroach "FOR ALL ROLES" does not exist in PostgreSQL; use CURRENT_USER as a
-- representative owner role for default privileges.
CREATE USER dpdp_test2;

ALTER DEFAULT PRIVILEGES FOR ROLE CURRENT_USER IN SCHEMA public GRANT SELECT ON TABLES TO dpdp_test2;

\set ON_ERROR_STOP 0
DROP ROLE dpdp_test2;
\set ON_ERROR_STOP 1

ALTER DEFAULT PRIVILEGES FOR ROLE CURRENT_USER IN SCHEMA public REVOKE SELECT ON TABLES FROM dpdp_test2;
ALTER DEFAULT PRIVILEGES FOR ROLE CURRENT_USER IN SCHEMA public GRANT USAGE ON TYPES TO dpdp_test2;

\set ON_ERROR_STOP 0
DROP ROLE dpdp_test2;
\set ON_ERROR_STOP 1

ALTER DEFAULT PRIVILEGES FOR ROLE CURRENT_USER IN SCHEMA public REVOKE USAGE ON TYPES FROM dpdp_test2;
ALTER DEFAULT PRIVILEGES FOR ROLE CURRENT_USER IN SCHEMA public GRANT SELECT ON SEQUENCES TO dpdp_test2;

\set ON_ERROR_STOP 0
DROP ROLE dpdp_test2;
\set ON_ERROR_STOP 1

-- Cleanup: remove remaining references so the role can be dropped.
ALTER DEFAULT PRIVILEGES FOR ROLE CURRENT_USER IN SCHEMA public REVOKE SELECT ON SEQUENCES FROM dpdp_test2;
DROP ROLE dpdp_test2;

-- Repeat in a custom schema.
CREATE SCHEMA dpdp_s;

CREATE ROLE dpdp_test3;
CREATE ROLE dpdp_test4;

ALTER DEFAULT PRIVILEGES FOR ROLE dpdp_test3 IN SCHEMA dpdp_s GRANT SELECT ON TABLES TO dpdp_test4;

\set ON_ERROR_STOP 0
DROP ROLE dpdp_test3;
DROP ROLE dpdp_test4;
\set ON_ERROR_STOP 1

ALTER DEFAULT PRIVILEGES FOR ROLE dpdp_test3 IN SCHEMA dpdp_s REVOKE ALL ON TABLES FROM dpdp_test4;
ALTER DEFAULT PRIVILEGES FOR ROLE dpdp_test3 IN SCHEMA dpdp_s REVOKE ALL ON TYPES FROM dpdp_test4;
ALTER DEFAULT PRIVILEGES FOR ROLE dpdp_test3 IN SCHEMA dpdp_s REVOKE ALL ON SEQUENCES FROM dpdp_test4;

DROP ROLE dpdp_test3;
DROP ROLE dpdp_test4;

DROP SCHEMA dpdp_s CASCADE;

RESET client_min_messages;
