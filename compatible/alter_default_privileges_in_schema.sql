-- PostgreSQL compatible tests from alter_default_privileges_in_schema
-- 47 tests

SET client_min_messages = warning;

-- Cleanup from prior runs.
RESET ROLE;
DROP SCHEMA IF EXISTS crdb_internal CASCADE;
-- Drop-owned requires the roles to exist; run conditionally (psql-specific \gexec).
SELECT format('DROP OWNED BY %I CASCADE;', rolname)
FROM pg_roles
WHERE rolname IN ('testuser', 'testuser2') \gexec
DROP ROLE IF EXISTS testuser2;
DROP ROLE IF EXISTS testuser;

CREATE ROLE testuser;
GRANT CREATE ON DATABASE pg_tests TO testuser;
GRANT CREATE ON SCHEMA public TO testuser;

CREATE SCHEMA crdb_internal;
CREATE OR REPLACE VIEW crdb_internal.default_privileges AS
SELECT
  d.defaclrole::regrole::text AS role_name,
  CASE WHEN d.defaclnamespace = 0 THEN NULL ELSE n.nspname END AS schema_name,
  d.defaclobjtype AS object_type,
  a.grantor::regrole::text AS grantor,
  CASE WHEN a.grantee = 0 THEN 'PUBLIC' ELSE a.grantee::regrole::text END AS grantee,
  a.privilege_type,
  a.is_grantable
FROM pg_default_acl d
LEFT JOIN pg_namespace n ON n.oid = d.defaclnamespace
CROSS JOIN LATERAL aclexplode(COALESCE(d.defaclacl, '{}'::aclitem[])) AS a
ORDER BY 1, 2 NULLS FIRST, 3, 4, 5, 6;

-- Test 1: statement (line 3)
-- PostgreSQL doesn't allow IN SCHEMA with ON SCHEMAS.
ALTER DEFAULT PRIVILEGES GRANT USAGE ON SCHEMAS TO postgres;

-- Test 2: statement (line 6)
ALTER DEFAULT PRIVILEGES IN SCHEMA crdb_internal GRANT SELECT ON TABLES TO postgres;

-- Test 3: statement (line 9)
CREATE ROLE testuser2;

-- Test 4: statement (line 12)
GRANT CREATE ON DATABASE pg_tests TO testuser;

-- user testuser
SET ROLE testuser;

-- Test 5: statement (line 18)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser IN SCHEMA public GRANT SELECT ON TABLES TO testuser2;

-- Test 6: statement (line 21)
CREATE TABLE t1 ();

-- Test 7: query (line 24)
SELECT
  grantor::regrole::text AS grantor,
  CASE WHEN grantee = 0 THEN 'PUBLIC' ELSE grantee::regrole::text END AS grantee,
  privilege_type,
  is_grantable
FROM aclexplode(
  (SELECT COALESCE(relacl, acldefault('r', relowner)) FROM pg_class WHERE oid = 't1'::regclass)
)
ORDER BY 1, 2, 3, 4;

-- Test 8: statement (line 36)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser GRANT INSERT ON TABLES TO testuser2;

-- Test 9: statement (line 39)
CREATE TABLE t2 ();

-- Test 10: query (line 42)
SELECT
  grantor::regrole::text AS grantor,
  CASE WHEN grantee = 0 THEN 'PUBLIC' ELSE grantee::regrole::text END AS grantee,
  privilege_type,
  is_grantable
FROM aclexplode(
  (SELECT COALESCE(relacl, acldefault('r', relowner)) FROM pg_class WHERE oid = 't2'::regclass)
)
ORDER BY 1, 2, 3, 4;

-- Test 11: statement (line 52)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser GRANT ALL ON TABLES TO testuser2;

-- Test 12: statement (line 55)
CREATE TABLE t3 ();

-- Test 13: query (line 58)
SELECT
  grantor::regrole::text AS grantor,
  CASE WHEN grantee = 0 THEN 'PUBLIC' ELSE grantee::regrole::text END AS grantee,
  privilege_type,
  is_grantable
FROM aclexplode(
  (SELECT COALESCE(relacl, acldefault('r', relowner)) FROM pg_class WHERE oid = 't3'::regclass)
)
ORDER BY 1, 2, 3, 4;

-- Test 14: statement (line 68)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser REVOKE ALL ON TABLES FROM testuser2;

-- Test 15: statement (line 71)
CREATE TABLE t4 ();

-- Test 16: query (line 74)
SELECT
  grantor::regrole::text AS grantor,
  CASE WHEN grantee = 0 THEN 'PUBLIC' ELSE grantee::regrole::text END AS grantee,
  privilege_type,
  is_grantable
FROM aclexplode(
  (SELECT COALESCE(relacl, acldefault('r', relowner)) FROM pg_class WHERE oid = 't4'::regclass)
)
ORDER BY 1, 2, 3, 4;

-- Test 17: statement (line 84)
CREATE SCHEMA s;

-- Test 18: statement (line 87)
GRANT CREATE, USAGE ON SCHEMA s TO testuser;

-- Test 19: statement (line 90)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser IN SCHEMA s, public GRANT ALL ON TABLES TO testuser2;

-- Test 20: statement (line 93)
CREATE TABLE public.t5 ();
CREATE TABLE s.t6 ();

-- Test 21: query (line 97)
SELECT
  grantor::regrole::text AS grantor,
  CASE WHEN grantee = 0 THEN 'PUBLIC' ELSE grantee::regrole::text END AS grantee,
  privilege_type,
  is_grantable
FROM aclexplode(
  (SELECT COALESCE(relacl, acldefault('r', relowner)) FROM pg_class WHERE oid = 'public.t5'::regclass)
)
ORDER BY 1, 2, 3, 4;

-- Test 22: query (line 106)
SELECT
  grantor::regrole::text AS grantor,
  CASE WHEN grantee = 0 THEN 'PUBLIC' ELSE grantee::regrole::text END AS grantee,
  privilege_type,
  is_grantable
FROM aclexplode(
  (SELECT COALESCE(relacl, acldefault('r', relowner)) FROM pg_class WHERE oid = 's.t6'::regclass)
)
ORDER BY 1, 2, 3, 4;

-- Test 23: statement (line 118)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser IN SCHEMA s, public REVOKE ALL ON TABLES FROM testuser2;
-- Cockroach-only: FOR ALL ROLES. Use the current role in PostgreSQL.
ALTER DEFAULT PRIVILEGES IN SCHEMA s, public GRANT SELECT ON TABLES TO testuser2;

-- user testuser
SET ROLE testuser;

-- Test 24: statement (line 124)
CREATE TABLE public.t7 ();
CREATE TABLE s.t8 ();

-- Test 25: query (line 128)
SELECT
  grantor::regrole::text AS grantor,
  CASE WHEN grantee = 0 THEN 'PUBLIC' ELSE grantee::regrole::text END AS grantee,
  privilege_type,
  is_grantable
FROM aclexplode(
  (SELECT COALESCE(relacl, acldefault('r', relowner)) FROM pg_class WHERE oid = 'public.t7'::regclass)
)
ORDER BY 1, 2, 3, 4;

-- Test 26: query (line 137)
SELECT
  grantor::regrole::text AS grantor,
  CASE WHEN grantee = 0 THEN 'PUBLIC' ELSE grantee::regrole::text END AS grantee,
  privilege_type,
  is_grantable
FROM aclexplode(
  (SELECT COALESCE(relacl, acldefault('r', relowner)) FROM pg_class WHERE oid = 's.t8'::regclass)
)
ORDER BY 1, 2, 3, 4;

-- Test 27: statement (line 151)
CREATE TABLE public.t9 ();
CREATE TABLE s.t10 ();

-- Test 28: query (line 155)
SELECT
  grantor::regrole::text AS grantor,
  CASE WHEN grantee = 0 THEN 'PUBLIC' ELSE grantee::regrole::text END AS grantee,
  privilege_type,
  is_grantable
FROM aclexplode(
  (SELECT COALESCE(relacl, acldefault('r', relowner)) FROM pg_class WHERE oid = 'public.t9'::regclass)
)
ORDER BY 1, 2, 3, 4;

-- Test 29: query (line 163)
SELECT
  grantor::regrole::text AS grantor,
  CASE WHEN grantee = 0 THEN 'PUBLIC' ELSE grantee::regrole::text END AS grantee,
  privilege_type,
  is_grantable
FROM aclexplode(
  (SELECT COALESCE(relacl, acldefault('r', relowner)) FROM pg_class WHERE oid = 's.t10'::regclass)
)
ORDER BY 1, 2, 3, 4;

-- Test 30: statement (line 173)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser REVOKE ALL ON TABLES FROM testuser;

-- Test 31: statement (line 176)
CREATE TABLE t11 ();

-- Test 32: query (line 181)
SELECT
  grantor::regrole::text AS grantor,
  CASE WHEN grantee = 0 THEN 'PUBLIC' ELSE grantee::regrole::text END AS grantee,
  privilege_type,
  is_grantable
FROM aclexplode(
  (SELECT COALESCE(relacl, acldefault('r', relowner)) FROM pg_class WHERE oid = 't11'::regclass)
)
ORDER BY 1, 2, 3, 4;

-- Test 33: statement (line 192)
CREATE SCHEMA s2;

-- Test 34: statement (line 195)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser REVOKE ALL ON TABLES FROM testuser;
ALTER DEFAULT PRIVILEGES FOR ROLE testuser REVOKE ALL ON TABLES FROM testuser2;

-- Test 35: statement (line 199)
CREATE TABLE s2.t12 ();

-- Test 36: query (line 204)
SELECT
  grantor::regrole::text AS grantor,
  CASE WHEN grantee = 0 THEN 'PUBLIC' ELSE grantee::regrole::text END AS grantee,
  privilege_type,
  is_grantable
FROM aclexplode(
  (SELECT COALESCE(relacl, acldefault('r', relowner)) FROM pg_class WHERE oid = 's2.t12'::regclass)
)
ORDER BY 1, 2, 3, 4;

-- Switch back to superuser for catalog-style queries.
RESET ROLE;

-- Test 37: query (line 212)
SELECT * FROM crdb_internal.default_privileges WHERE schema_name IS NOT NULL;

-- Test 38: query (line 219)
SELECT role_name, schema_name, object_type, grantee, privilege_type, is_grantable
FROM crdb_internal.default_privileges
WHERE schema_name = 'public'
ORDER BY 1, 2, 3, 4, 5, 6;

-- Test 39: query (line 224)
SELECT role_name, schema_name, object_type, grantee, privilege_type, is_grantable
FROM crdb_internal.default_privileges
WHERE schema_name = 's'
ORDER BY 1, 2, 3, 4, 5, 6;

-- Test 40: query (line 229)
SELECT role_name, schema_name, object_type, grantee, privilege_type, is_grantable
FROM crdb_internal.default_privileges
WHERE schema_name = 's2'
ORDER BY 1, 2, 3, 4, 5, 6;

-- Test 41: statement (line 234)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser IN SCHEMA public GRANT ALL ON TABLES TO testuser;
ALTER DEFAULT PRIVILEGES FOR ROLE testuser IN SCHEMA s GRANT USAGE ON TYPES TO testuser2;
-- PostgreSQL doesn't have DROP privilege on tables.
ALTER DEFAULT PRIVILEGES FOR ROLE testuser IN SCHEMA s2 GRANT SELECT, UPDATE ON TABLES TO testuser2;

-- Test 42: query (line 239)
SELECT * FROM crdb_internal.default_privileges WHERE schema_name IS NOT NULL;

-- Test 43: query (line 252)
SELECT role_name, schema_name, object_type, grantee, privilege_type, is_grantable
FROM crdb_internal.default_privileges
WHERE schema_name = 'public'
ORDER BY 1, 2, 3, 4, 5, 6;

-- Test 44: query (line 258)
SELECT role_name, schema_name, object_type, grantee, privilege_type, is_grantable
FROM crdb_internal.default_privileges
WHERE schema_name = 's'
ORDER BY 1, 2, 3, 4, 5, 6;

-- Test 45: query (line 264)
SELECT role_name, schema_name, object_type, grantee, privilege_type, is_grantable
FROM crdb_internal.default_privileges
WHERE schema_name = 's2'
ORDER BY 1, 2, 3, 4, 5, 6;

-- Test 46: query (line 274)
SELECT role_name, schema_name, object_type, grantee, privilege_type, is_grantable
FROM crdb_internal.default_privileges
WHERE role_name = 'testuser'
  AND schema_name = 's2'
ORDER BY 1, 2, 3, 4, 5, 6;

-- Test 47: query (line 282)
SELECT role_name, schema_name, object_type, grantee, privilege_type, is_grantable
FROM crdb_internal.default_privileges
WHERE schema_name = '''; drop database test; SELECT '''
ORDER BY 1, 2, 3, 4, 5, 6;

-- Cleanup so the file can be re-run without role dependency errors.
RESET ROLE;
DROP OWNED BY testuser CASCADE;
DROP OWNED BY testuser2 CASCADE;
DROP SCHEMA IF EXISTS crdb_internal CASCADE;
DROP ROLE IF EXISTS testuser2;
DROP ROLE IF EXISTS testuser;

RESET client_min_messages;
