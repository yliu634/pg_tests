-- PostgreSQL compatible tests from grant_schema
--
-- CockroachDB exposes SHOW GRANTS and database-qualified schema references.
-- PostgreSQL schema privileges can be validated with has_schema_privilege().

SET client_min_messages = warning;

DROP SCHEMA IF EXISTS gs_derp CASCADE;
DROP SCHEMA IF EXISTS gs_s CASCADE;
DROP SCHEMA IF EXISTS gs_owner CASCADE;
DROP SCHEMA IF EXISTS gs_sc102962 CASCADE;
DROP SCHEMA IF EXISTS gs_roachema CASCADE;

DROP ROLE IF EXISTS gs_testuser;
DROP ROLE IF EXISTS gs_testuser2;
DROP ROLE IF EXISTS gs_other_owner;
DROP ROLE IF EXISTS gs_r102962;

CREATE ROLE gs_testuser;
CREATE ROLE gs_testuser2;
CREATE ROLE gs_other_owner;
CREATE ROLE gs_r102962;

-- Database-level privilege example.
GRANT CREATE ON DATABASE pg_tests TO gs_testuser;
SELECT has_database_privilege('gs_testuser', 'pg_tests', 'CREATE') AS db_has_create;

CREATE SCHEMA gs_derp;

CREATE SCHEMA gs_s;
GRANT CREATE ON SCHEMA gs_s TO gs_testuser2;
SELECT
  has_schema_privilege('gs_testuser2', 'gs_s', 'CREATE') AS gs_s_has_create,
  has_schema_privilege('gs_testuser2', 'gs_s', 'USAGE') AS gs_s_has_usage;

CREATE SCHEMA gs_owner;
GRANT USAGE ON SCHEMA gs_owner TO gs_testuser2;
SELECT has_schema_privilege('gs_testuser2', 'gs_owner', 'USAGE') AS gs_owner_has_usage_before;

ALTER SCHEMA gs_owner OWNER TO gs_other_owner;
SELECT has_schema_privilege('gs_testuser2', 'gs_owner', 'USAGE') AS gs_owner_has_usage_after;

CREATE SCHEMA gs_sc102962;
GRANT USAGE ON SCHEMA gs_sc102962 TO gs_r102962;
SELECT has_schema_privilege('gs_r102962', 'gs_sc102962', 'USAGE') AS gs_sc102962_has_usage;

-- Granting to PUBLIC applies to all roles.
CREATE SCHEMA gs_roachema;
GRANT USAGE ON SCHEMA gs_roachema TO PUBLIC;
SELECT has_schema_privilege('gs_testuser', 'gs_roachema', 'USAGE') AS public_usage_for_gs_testuser;

-- Cleanup.
DROP SCHEMA gs_derp CASCADE;
DROP SCHEMA gs_s CASCADE;
DROP SCHEMA gs_owner CASCADE;
DROP SCHEMA gs_sc102962 CASCADE;
DROP SCHEMA gs_roachema CASCADE;
DROP OWNED BY gs_testuser, gs_testuser2, gs_other_owner, gs_r102962;
DROP ROLE gs_testuser;
DROP ROLE gs_testuser2;
DROP ROLE gs_other_owner;
DROP ROLE gs_r102962;

RESET client_min_messages;
