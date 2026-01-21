-- PostgreSQL compatible tests from grant_schema
-- 29 tests

SET client_min_messages = warning;

-- Roles are cluster-global; keep this script idempotent across runs.
DROP ROLE IF EXISTS testuser;
DROP ROLE IF EXISTS testuser2;
DROP ROLE IF EXISTS owner_grant_option_child;
DROP ROLE IF EXISTS other_owner;
DROP ROLE IF EXISTS roach;
DROP ROLE IF EXISTS r102962;

-- Cockroach's SHOW GRANTS isn't available in PostgreSQL; provide a helper view.
CREATE OR REPLACE VIEW schema_grants AS
SELECT
  n.nspname AS schema_name,
  CASE WHEN a.grantee = 0 THEN 'public' ELSE pg_get_userbyid(a.grantee) END AS grantee,
  a.privilege_type,
  CASE WHEN a.is_grantable THEN 'YES' ELSE 'NO' END AS is_grantable
FROM pg_namespace n
CROSS JOIN LATERAL aclexplode(COALESCE(n.nspacl, acldefault('n', n.nspowner))) a;

GRANT SELECT ON schema_grants TO PUBLIC;

-- Test 1: statement (line 1)
CREATE USER testuser;
CREATE USER testuser2;
DO $$
BEGIN
  EXECUTE format('GRANT CREATE ON DATABASE %I TO testuser', current_database());
END $$;

-- Test 2: statement (line 5)
CREATE SCHEMA IF NOT EXISTS derp;

-- Test 3: query (line 12)
SELECT grantee, privilege_type, is_grantable
FROM schema_grants
WHERE schema_name = 'pg_catalog'
ORDER BY grantee, privilege_type;

-- Test 4: query (line 19)
SELECT grantee, privilege_type, is_grantable
FROM schema_grants
WHERE schema_name = 'information_schema'
ORDER BY grantee, privilege_type;

-- Test 5: query (line 26)
SELECT grantee, privilege_type, is_grantable
FROM schema_grants
WHERE schema_name = 'public'
ORDER BY grantee, privilege_type;

-- Test 6: query (line 35)
SELECT schema_name, grantee, privilege_type, is_grantable
FROM schema_grants
WHERE schema_name NOT IN ('pg_catalog', 'information_schema')
  AND schema_name NOT LIKE 'pg_toast%'
  AND schema_name NOT LIKE 'pg_temp_%'
ORDER BY schema_name, grantee, privilege_type;

-- Test 7: statement (line 49)
CREATE TEMP TABLE t(a INT);

-- Capture the temp schema name (pg_temp_N) created for this session.
SELECT n.nspname AS temp_schema
FROM pg_namespace n
WHERE n.oid = pg_my_temp_schema()
\gset

-- Test 8: query (line 56)
SELECT grantee, privilege_type, is_grantable
FROM schema_grants
WHERE schema_name = :'temp_schema'
ORDER BY grantee, privilege_type;

-- Test 9: statement (line 65)
CREATE SCHEMA s;
GRANT CREATE ON SCHEMA s TO testuser2;

-- Test 10: query (line 70)
SELECT grantee, privilege_type, is_grantable
FROM schema_grants
WHERE schema_name = 's'
ORDER BY grantee, privilege_type;

-- Test 11: query (line 81)
SELECT
  grantee,
  current_database() AS table_catalog,
  CASE WHEN schema_name LIKE 'pg_temp%' THEN 'pg_temp' ELSE schema_name END AS table_schema,
  privilege_type,
  is_grantable
FROM schema_grants
ORDER BY grantee, table_schema, privilege_type;

-- Test 12: query (line 111)
WITH schema_names(schema_name) AS (
   SELECT n.nspname AS schema_name
     FROM pg_catalog.pg_namespace n
)
SELECT
  CASE WHEN schema_name LIKE 'pg_temp%' THEN 'pg_temp' ELSE schema_name END AS schema_name,
  pg_catalog.has_schema_privilege('testuser2', schema_name, 'CREATE') AS has_create,
  pg_catalog.has_schema_privilege('testuser2', schema_name, 'USAGE') AS has_usage
FROM schema_names
ORDER BY schema_name;

-- Test 13: statement (line 134)
CREATE USER owner_grant_option_child;

-- Test 14: statement (line 137)
GRANT testuser TO owner_grant_option_child;

-- Test 15: statement (line 142)
SET ROLE testuser;
CREATE SCHEMA owner_grant_option;

-- Test 16: statement (line 145)
GRANT USAGE ON SCHEMA owner_grant_option TO owner_grant_option_child;

-- Test 17: query (line 148)
SELECT grantee, privilege_type, is_grantable
FROM schema_grants
WHERE schema_name = 'owner_grant_option'
ORDER BY grantee, privilege_type;

-- Test 18: statement (line 161)
RESET ROLE;
CREATE ROLE other_owner;

-- Test 19: statement (line 164)
ALTER SCHEMA owner_grant_option OWNER TO other_owner;

-- Test 20: query (line 167)
SELECT grantee, privilege_type, is_grantable
FROM schema_grants
WHERE schema_name = 'owner_grant_option'
ORDER BY grantee, privilege_type;

-- Test 21: statement (line 179)
CREATE SCHEMA sc102962;

-- Test 22: statement (line 182)
CREATE ROLE r102962;

-- Test 23: statement (line 185)
GRANT USAGE ON SCHEMA sc102962 TO r102962;

-- Test 24: query (line 188)
SELECT grantee, privilege_type, is_grantable
FROM schema_grants
WHERE schema_name = 'sc102962'
ORDER BY grantee, privilege_type;

-- Test 25: statement (line 196)
REVOKE USAGE ON SCHEMA sc102962 FROM r102962;
DROP ROLE r102962;

-- Test 26: statement (line 199)
CREATE USER ROACH;
CREATE SCHEMA ROACHHOUSE;
CREATE SCHEMA ROACHLAYER;
CREATE SCHEMA ROACHSTATION;
BEGIN;
GRANT ALL ON SCHEMA ROACHHOUSE TO ROACH;
GRANT ALL ON SCHEMA ROACHLAYER TO ROACH;
GRANT ALL ON SCHEMA ROACHSTATION TO ROACH;
COMMIT;

-- Test 27: query (line 214)
SELECT
  current_database() AS database_name,
  CASE WHEN schema_name LIKE 'pg_temp%' THEN 'pg_temp' ELSE schema_name END AS schema_name,
  NULL::text AS object_name,
  'schema'::text AS object_type,
  grantee,
  privilege_type,
  is_grantable
FROM schema_grants
WHERE grantee = 'roach'
ORDER BY schema_name, privilege_type;

-- Test 28: statement (line 238)
CREATE SCHEMA roachema;
GRANT USAGE ON SCHEMA roachema TO public;

-- Test 29: query (line 242)
SELECT has_schema_privilege('public', 'roachema', 'USAGE');

RESET client_min_messages;
