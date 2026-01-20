-- PostgreSQL compatible tests from grant_type
--
-- CockroachDB uses SHOW GRANTS and database-qualified type names.
-- PostgreSQL exposes type grants via information_schema.usage_privileges and
-- has_type_privilege().

SET client_min_messages = warning;

DROP SCHEMA IF EXISTS gt_schema_a CASCADE;
DROP TYPE IF EXISTS public.gt_enum_a;
DROP TYPE IF EXISTS public."gt_enum_a+b";
DROP TYPE IF EXISTS public.gt_owner_grant_option;
DROP TYPE IF EXISTS public.gt_custom_type1;
DROP TYPE IF EXISTS public.gt_custom_type2;
DROP TYPE IF EXISTS public.gt_custom_type3;

DROP ROLE IF EXISTS gt_user1;
DROP ROLE IF EXISTS gt_owner_child;
DROP ROLE IF EXISTS gt_other_owner;
DROP ROLE IF EXISTS gt_roach;

CREATE ROLE gt_user1;
CREATE ROLE gt_owner_child;
CREATE ROLE gt_other_owner;
CREATE ROLE gt_roach;

CREATE SCHEMA gt_schema_a;

CREATE TYPE public.gt_enum_a AS ENUM ('hello', 'goodbye');
GRANT USAGE ON TYPE public.gt_enum_a TO gt_user1;

CREATE TYPE public."gt_enum_a+b" AS ENUM ('hello', 'goodbye');
GRANT USAGE ON TYPE public."gt_enum_a+b" TO gt_user1;

CREATE TYPE gt_schema_a.gt_enum_b AS ENUM ('hi', 'bye');
GRANT USAGE ON TYPE gt_schema_a.gt_enum_b TO gt_user1 WITH GRANT OPTION;

-- information_schema.usage_privileges does not include enum types in PostgreSQL;
-- inspect pg_type.typacl instead.
SELECT
  n.nspname AS type_schema,
  t.typname AS type_name,
  COALESCE(grantee.rolname, 'PUBLIC') AS grantee,
  x.privilege_type,
  CASE x.is_grantable WHEN true THEN 'YES' ELSE 'NO' END AS is_grantable
FROM pg_type t
JOIN pg_namespace n ON n.oid = t.typnamespace
JOIN LATERAL aclexplode(t.typacl) AS x ON true
LEFT JOIN pg_roles grantee ON grantee.oid = x.grantee
WHERE n.nspname IN ('public', 'gt_schema_a')
  AND t.typname IN ('gt_enum_a', 'gt_enum_a+b', 'gt_enum_b')
  AND COALESCE(grantee.rolname, 'PUBLIC') = 'gt_user1'
ORDER BY 1, 2, 3, 4, 5;

-- Ownership change should not remove an explicit grant.
CREATE TYPE public.gt_owner_grant_option AS ENUM ('a');
GRANT USAGE ON TYPE public.gt_owner_grant_option TO gt_owner_child;
ALTER TYPE public.gt_owner_grant_option OWNER TO gt_other_owner;
SELECT has_type_privilege('gt_owner_child', 'gt_owner_grant_option', 'USAGE') AS owner_child_has_usage;

-- Multiple type grants to a single role.
CREATE TYPE public.gt_custom_type1 AS ENUM ('roach1', 'roach2', 'roach3');
CREATE TYPE public.gt_custom_type2 AS ENUM ('roachA', 'roachB', 'roachC');
CREATE TYPE public.gt_custom_type3 AS ENUM ('roachI', 'roachII', 'roachIII');
GRANT ALL ON TYPE public.gt_custom_type1 TO gt_roach;
GRANT ALL ON TYPE public.gt_custom_type2 TO gt_roach;
GRANT ALL ON TYPE public.gt_custom_type3 TO gt_roach;
SELECT
  t.typname AS type_name,
  has_type_privilege('gt_roach', t.oid, 'USAGE') AS has_usage
FROM pg_type t
JOIN pg_namespace n ON n.oid = t.typnamespace
WHERE n.nspname = 'public'
  AND t.typname IN ('gt_custom_type1', 'gt_custom_type2', 'gt_custom_type3')
ORDER BY 1;

-- Cleanup.
DROP SCHEMA gt_schema_a CASCADE;
DROP TYPE public.gt_enum_a;
DROP TYPE public."gt_enum_a+b";
DROP TYPE public.gt_owner_grant_option;
DROP TYPE public.gt_custom_type1;
DROP TYPE public.gt_custom_type2;
DROP TYPE public.gt_custom_type3;
DROP OWNED BY gt_user1, gt_owner_child, gt_other_owner, gt_roach;
DROP ROLE gt_user1;
DROP ROLE gt_owner_child;
DROP ROLE gt_other_owner;
DROP ROLE gt_roach;

RESET client_min_messages;
