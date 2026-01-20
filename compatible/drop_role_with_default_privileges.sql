-- PostgreSQL compatible tests from drop_role_with_default_privileges
--
-- CockroachDB has root/admin roles and USE statements that don't map to PG.
-- This file exercises default privileges and dropping roles in PostgreSQL.

SET client_min_messages = warning;
DROP SCHEMA IF EXISTS drwdp_schema CASCADE;
DROP ROLE IF EXISTS drwdp_owner;
DROP ROLE IF EXISTS drwdp_grantee;
RESET client_min_messages;

CREATE ROLE drwdp_owner LOGIN;
CREATE ROLE drwdp_grantee LOGIN;

-- Capture role OIDs so we can verify pg_default_acl cleanup after DROP ROLE.
CREATE TEMP TABLE role_oids(name text primary key, oid oid);
INSERT INTO role_oids
SELECT rolname, oid FROM pg_roles WHERE rolname IN ('drwdp_owner', 'drwdp_grantee');

CREATE SCHEMA drwdp_schema;
ALTER SCHEMA drwdp_schema OWNER TO drwdp_owner;

SET ROLE drwdp_owner;
ALTER DEFAULT PRIVILEGES IN SCHEMA drwdp_schema GRANT SELECT ON TABLES TO drwdp_grantee;
CREATE TABLE drwdp_schema.t(a INT);
RESET ROLE;

SELECT has_table_privilege('drwdp_grantee', 'drwdp_schema.t', 'SELECT') AS grantee_can_select;

SELECT count(*) AS default_acl_rows
FROM pg_default_acl d
JOIN role_oids r ON r.oid = d.defaclrole
WHERE r.name = 'drwdp_owner';

-- Clean up owned objects and roles.
DROP SCHEMA drwdp_schema CASCADE;
DROP OWNED BY drwdp_owner;
DROP OWNED BY drwdp_grantee;
DROP ROLE drwdp_owner;
DROP ROLE drwdp_grantee;

SELECT count(*) AS default_acl_rows_after_drop
FROM pg_default_acl d
JOIN role_oids r ON r.oid = d.defaclrole
WHERE r.name = 'drwdp_owner';

