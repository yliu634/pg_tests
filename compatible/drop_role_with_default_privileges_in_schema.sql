-- PostgreSQL compatible tests from drop_role_with_default_privileges_in_schema
--
-- CockroachDB has root/admin roles and other directives that don't map to PG.
-- This file exercises schema-scoped default privileges and dropping roles.

SET client_min_messages = warning;
DROP SCHEMA IF EXISTS drwdp_is_schema CASCADE;
DROP ROLE IF EXISTS drwdp_is_owner;
DROP ROLE IF EXISTS drwdp_is_grantee;
RESET client_min_messages;

CREATE ROLE drwdp_is_owner LOGIN;
CREATE ROLE drwdp_is_grantee LOGIN;

-- Capture role OIDs so we can verify pg_default_acl cleanup after DROP ROLE.
CREATE TEMP TABLE role_oids(name text primary key, oid oid);
INSERT INTO role_oids
SELECT rolname, oid FROM pg_roles WHERE rolname IN ('drwdp_is_owner', 'drwdp_is_grantee');

CREATE SCHEMA drwdp_is_schema;
ALTER SCHEMA drwdp_is_schema OWNER TO drwdp_is_owner;

SET ROLE drwdp_is_owner;
ALTER DEFAULT PRIVILEGES IN SCHEMA drwdp_is_schema GRANT USAGE ON SEQUENCES TO drwdp_is_grantee;
ALTER DEFAULT PRIVILEGES IN SCHEMA drwdp_is_schema GRANT EXECUTE ON FUNCTIONS TO drwdp_is_grantee;
CREATE SEQUENCE drwdp_is_schema.seq;
CREATE FUNCTION drwdp_is_schema.f() RETURNS INT LANGUAGE SQL AS $$ SELECT 1 $$;
RESET ROLE;

SELECT has_sequence_privilege('drwdp_is_grantee', 'drwdp_is_schema.seq', 'USAGE') AS grantee_seq_usage;
SELECT has_function_privilege('drwdp_is_grantee', 'drwdp_is_schema.f()'::regprocedure, 'EXECUTE') AS grantee_f_exec;

SELECT count(*) AS default_acl_rows
FROM pg_default_acl d
JOIN role_oids r ON r.oid = d.defaclrole
WHERE r.name = 'drwdp_is_owner';

DROP SCHEMA drwdp_is_schema CASCADE;
DROP OWNED BY drwdp_is_owner;
DROP OWNED BY drwdp_is_grantee;
DROP ROLE drwdp_is_owner;
DROP ROLE drwdp_is_grantee;

SELECT count(*) AS default_acl_rows_after_drop
FROM pg_default_acl d
JOIN role_oids r ON r.oid = d.defaclrole
WHERE r.name = 'drwdp_is_owner';

