-- PostgreSQL compatible tests from grant_type
--
-- CockroachDB's `SHOW GRANTS` isn't available in PostgreSQL; this file uses
-- information_schema.role_udt_grants plus has_type_privilege() checks to
-- validate GRANT/REVOKE behavior for types without emitting ERRORs.

SET client_min_messages = warning;

-- Roles are cluster-global; use a file-specific prefix.
DROP ROLE IF EXISTS gtype_roach;
DROP ROLE IF EXISTS gtype_other_owner;
DROP ROLE IF EXISTS gtype_owner_child;
DROP ROLE IF EXISTS gtype_user1;

CREATE ROLE gtype_user1;
CREATE ROLE gtype_owner_child;
CREATE ROLE gtype_other_owner;
CREATE ROLE gtype_roach;

DROP SCHEMA IF EXISTS gtype_schema_a CASCADE;
CREATE SCHEMA gtype_schema_a;

-- Helper view approximating `SHOW GRANTS ON TYPE <type>`.
-- Note: information_schema.role_udt_grants does not surface enum type grants in
-- PostgreSQL, so inspect pg_type.typacl directly.
CREATE OR REPLACE VIEW type_grants AS
SELECT
  n.nspname AS udt_schema,
  t.typname AS udt_name,
  CASE WHEN a.grantee = 0 THEN 'public' ELSE pg_get_userbyid(a.grantee) END AS grantee,
  a.privilege_type,
  CASE WHEN a.is_grantable THEN 'YES' ELSE 'NO' END AS is_grantable
FROM pg_type t
JOIN pg_namespace n ON n.oid = t.typnamespace
CROSS JOIN LATERAL aclexplode(COALESCE(t.typacl, acldefault('T', t.typowner))) a
WHERE n.nspname NOT IN ('pg_catalog', 'information_schema');

GRANT SELECT ON type_grants TO PUBLIC;

-- Test 1: create types and grant privileges.
CREATE TYPE public.enum_a AS ENUM ('hello', 'goodbye');
GRANT USAGE ON TYPE public.enum_a TO gtype_user1;

CREATE TYPE public."enum_a+b" AS ENUM ('hello', 'goodbye');
GRANT USAGE ON TYPE public."enum_a+b" TO gtype_user1;

CREATE TYPE gtype_schema_a.enum_b AS ENUM ('hi', 'bye');
GRANT ALL PRIVILEGES ON TYPE gtype_schema_a.enum_b TO gtype_user1;

-- Test 2: show grants on the created types.
SELECT udt_schema, udt_name, grantee, privilege_type, is_grantable
FROM type_grants
WHERE (udt_schema, udt_name) IN (('public','enum_a'), ('public','enum_a+b'), ('gtype_schema_a','enum_b'))
  AND grantee = 'gtype_user1'
ORDER BY udt_schema, udt_name, privilege_type;

-- Test 3: per-user privilege checks (mirrors `SHOW GRANTS ... FOR user`).
SELECT
  has_type_privilege('gtype_user1', 'public.enum_a', 'USAGE') AS enum_a_usage,
  has_type_privilege('gtype_user1', 'public."enum_a+b"', 'USAGE') AS enum_a_plus_b_usage,
  has_type_privilege('gtype_user1', 'gtype_schema_a.enum_b', 'USAGE') AS enum_b_usage;

-- Test 4: grant option + ownership change.
CREATE TYPE public.owner_grant_option AS ENUM ('a');
GRANT USAGE ON TYPE public.owner_grant_option TO gtype_owner_child WITH GRANT OPTION;

SELECT udt_schema, udt_name, grantee, privilege_type, is_grantable
FROM type_grants
WHERE udt_schema = 'public' AND udt_name = 'owner_grant_option'
  AND grantee = 'gtype_owner_child'
ORDER BY privilege_type;

ALTER TYPE public.owner_grant_option OWNER TO gtype_other_owner;

SELECT udt_schema, udt_name, grantee, privilege_type, is_grantable
FROM type_grants
WHERE udt_schema = 'public' AND udt_name = 'owner_grant_option'
  AND grantee = 'gtype_owner_child'
ORDER BY privilege_type;

-- Test 5: multiple type grants to a single role.
CREATE TYPE public.custom_type1 AS ENUM ('roach1', 'roach2', 'roach3');
CREATE TYPE public.custom_type2 AS ENUM ('roachA', 'roachB', 'roachC');
CREATE TYPE public.custom_type3 AS ENUM ('roachI', 'roachII', 'roachIII');
GRANT ALL PRIVILEGES ON TYPE public.custom_type1, public.custom_type2, public.custom_type3 TO gtype_roach;

SELECT udt_schema, udt_name, grantee, privilege_type, is_grantable
FROM type_grants
WHERE grantee = 'gtype_roach' AND udt_schema = 'public'
ORDER BY udt_name, privilege_type;

RESET client_min_messages;
