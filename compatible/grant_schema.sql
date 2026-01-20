-- PostgreSQL compatible tests from grant_schema
-- 29 tests

-- Test 1: statement (line 1)
GRANT CREATE ON DATABASE test TO testuser;
CREATE USER testuser2

-- Test 2: statement (line 5)
CREATE SCHEMA IF NOT EXISTS derp

-- Test 3: query (line 12)
SHOW GRANTS ON SCHEMA pg_catalog

-- Test 4: query (line 19)
SHOW GRANTS ON SCHEMA information_schema

-- Test 5: query (line 26)
SHOW GRANTS ON SCHEMA public

-- Test 6: query (line 35)
SHOW GRANTS ON SCHEMA test.*

-- Test 7: statement (line 49)
CREATE TEMP TABLE t(a INT)

let $temp_schema
SELECT schema_name FROM [show schemas] WHERE schema_name LIKE '%pg_temp%'

-- Test 8: query (line 56)
SELECT grantee, privilege_type FROM [SHOW GRANTS ON SCHEMA $temp_schema]

-- Test 9: statement (line 65)
CREATE SCHEMA s;
GRANT CREATE ON SCHEMA s TO testuser2

-- Test 10: query (line 70)
SHOW GRANTS ON SCHEMA s

-- Test 11: query (line 81)
SELECT
  grantee,
  table_catalog,
  IF(table_schema LIKE 'pg_temp%', 'pg_temp', table_schema) AS table_schema,
  privilege_type,
  is_grantable
FROM information_schema.schema_privileges

-- Test 12: query (line 111)
WITH schema_names(schema_name) AS (
   SELECT n.nspname AS schema_name
     FROM pg_catalog.pg_namespace n
) SELECT IF(schema_name LIKE 'pg_temp%', 'pg_temp', schema_name) AS schema_name,
  pg_catalog.has_schema_privilege('testuser2', schema_name, 'CREATE') AS has_create,
  pg_catalog.has_schema_privilege('testuser2', schema_name, 'USAGE') AS has_usage
FROM schema_names

-- Test 13: statement (line 134)
CREATE USER owner_grant_option_child

-- Test 14: statement (line 137)
GRANT testuser to owner_grant_option_child

user testuser

-- Test 15: statement (line 142)
CREATE SCHEMA owner_grant_option

-- Test 16: statement (line 145)
GRANT USAGE ON SCHEMA owner_grant_option TO owner_grant_option_child

-- Test 17: query (line 148)
SHOW GRANTS ON SCHEMA owner_grant_option

-- Test 18: statement (line 161)
CREATE ROLE other_owner

-- Test 19: statement (line 164)
ALTER SCHEMA owner_grant_option OWNER TO other_owner

-- Test 20: query (line 167)
SHOW GRANTS ON SCHEMA owner_grant_option

-- Test 21: statement (line 179)
CREATE SCHEMA sc102962

-- Test 22: statement (line 182)
CREATE ROLE r102962

-- Test 23: statement (line 185)
GRANT USAGE ON SCHEMA sc102962 TO r102962

-- Test 24: query (line 188)
SHOW GRANTS ON SCHEMA sc102962

-- Test 25: statement (line 196)
DROP ROLE r102962

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
WITH roach_grants AS (
  SHOW GRANTS FOR roach
)
SELECT database_name,
  IF(schema_name LIKE 'pg_temp%', 'pg_temp', schema_name) AS schema_name,
  object_name,
  object_type,
  grantee,
  privilege_type,
  is_grantable
FROM roach_grants

-- Test 28: statement (line 238)
CREATE SCHEMA roachema;
GRANT USAGE ON SCHEMA roachema TO public;

-- Test 29: query (line 242)
SELECT has_schema_privilege('public', 'roachema', 'USAGE');

