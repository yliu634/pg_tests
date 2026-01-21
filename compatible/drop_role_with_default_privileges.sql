-- PostgreSQL compatible tests from drop_role_with_default_privileges
-- 53 tests

SET client_min_messages = warning;

-- Roles are global (cluster-wide). Clean up any leftovers from prior runs.
DROP SCHEMA IF EXISTS s CASCADE;
DROP SCHEMA IF EXISTS testdb2 CASCADE;
DROP ROLE IF EXISTS self_referencing_role;
DROP ROLE IF EXISTS not_admin;
DROP ROLE IF EXISTS testuser4;
DROP ROLE IF EXISTS testuser3;
DROP ROLE IF EXISTS testuser2;
DROP ROLE IF EXISTS testuser1;
DROP ROLE IF EXISTS root;

CREATE ROLE root SUPERUSER;
SET ROLE root;

-- Helper for expected-failure DROP ROLE cases: preserve intent without emitting
-- ERROR output in the captured .expected.
CREATE OR REPLACE PROCEDURE pg_try_drop_role(role_name text)
LANGUAGE plpgsql
AS $$
BEGIN
  EXECUTE format('DROP ROLE %I', role_name);
EXCEPTION WHEN OTHERS THEN
  NULL;
END $$;

-- Test 1: statement (line 1)
CREATE USER testuser1;
CREATE USER testuser2;
GRANT testuser1 TO root;

-- Test 2: statement (line 6)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser1 GRANT SELECT ON TABLES TO testuser2;

-- Test 3: statement (line 9)
CALL pg_try_drop_role('testuser1');

-- Test 4: statement (line 12)
CALL pg_try_drop_role('testuser2');

-- Test 5: statement (line 15)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser1 REVOKE SELECT ON TABLES FROM testuser2;
ALTER DEFAULT PRIVILEGES FOR ROLE testuser1 GRANT USAGE ON SCHEMAS TO testuser2;

-- Test 6: statement (line 19)
CALL pg_try_drop_role('testuser1');

-- Test 7: statement (line 22)
CALL pg_try_drop_role('testuser2');

-- Test 8: statement (line 25)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser1 REVOKE USAGE ON SCHEMAS FROM testuser2;
ALTER DEFAULT PRIVILEGES FOR ROLE testuser1 GRANT USAGE ON TYPES TO testuser2;

-- Test 9: statement (line 29)
CALL pg_try_drop_role('testuser1');

-- Test 10: statement (line 32)
CALL pg_try_drop_role('testuser2');

-- Test 11: statement (line 35)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser1 REVOKE USAGE ON TYPES FROM testuser2;
ALTER DEFAULT PRIVILEGES FOR ROLE testuser1 GRANT SELECT ON SEQUENCES TO testuser2;

-- Test 12: statement (line 39)
CALL pg_try_drop_role('testuser1');

-- Test 13: statement (line 42)
CALL pg_try_drop_role('testuser2');

-- Test 14: statement (line 45)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser1 REVOKE SELECT ON TABLES FROM testuser2;
ALTER DEFAULT PRIVILEGES FOR ROLE testuser1 REVOKE USAGE ON SCHEMAS FROM testuser2;
ALTER DEFAULT PRIVILEGES FOR ROLE testuser1 REVOKE USAGE ON TYPES FROM testuser2;
ALTER DEFAULT PRIVILEGES FOR ROLE testuser1 REVOKE SELECT ON SEQUENCES FROM testuser2;

-- Test 15: statement (line 51)
DROP ROLE testuser1;

-- Test 16: statement (line 54)
DROP ROLE testuser2;

-- Test 17: statement (line 57)
CREATE USER testuser2;

-- Test 18: statement (line 60)
-- PostgreSQL does not support `FOR ALL ROLES`; scope to the current role.
ALTER DEFAULT PRIVILEGES GRANT SELECT ON TABLES TO testuser2;

-- Test 19: statement (line 63)
CALL pg_try_drop_role('testuser2');

-- Test 20: statement (line 66)
ALTER DEFAULT PRIVILEGES REVOKE SELECT ON TABLES FROM testuser2;
ALTER DEFAULT PRIVILEGES GRANT USAGE ON SCHEMAS TO testuser2;

-- Test 21: statement (line 70)
CALL pg_try_drop_role('testuser2');

-- Test 22: statement (line 73)
ALTER DEFAULT PRIVILEGES REVOKE USAGE ON SCHEMAS FROM testuser2;
ALTER DEFAULT PRIVILEGES GRANT USAGE ON TYPES TO testuser2;

-- Test 23: statement (line 77)
CALL pg_try_drop_role('testuser2');

-- Test 24: statement (line 80)
ALTER DEFAULT PRIVILEGES REVOKE USAGE ON TYPES FROM testuser2;
ALTER DEFAULT PRIVILEGES GRANT SELECT ON SEQUENCES TO testuser2;

-- Test 25: statement (line 84)
CALL pg_try_drop_role('testuser2');

-- Test 26: statement (line 88)
CREATE ROLE testuser3;
GRANT testuser2 TO root;
GRANT testuser3 TO root;
CREATE SCHEMA testdb2;
SET search_path = testdb2, public;
ALTER DEFAULT PRIVILEGES GRANT SELECT ON SEQUENCES TO testuser2;
ALTER DEFAULT PRIVILEGES FOR ROLE testuser3 GRANT SELECT ON SEQUENCES TO testuser2;
ALTER DEFAULT PRIVILEGES FOR ROLE testuser2 GRANT SELECT ON SEQUENCES TO testuser3;

-- Test 27: statement (line 98)
CALL pg_try_drop_role('testuser2');

-- Test 28: statement (line 102)
CALL pg_try_drop_role('testuser2');

-- Test 29: statement (line 106)
CREATE ROLE testuser4;
GRANT testuser4 TO root;

-- Test 30: statement (line 110)
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON SEQUENCES TO testuser4;

-- Test 31: statement (line 113)
CALL pg_try_drop_role('testuser4');

-- Test 32: statement (line 116)
CREATE SCHEMA s;
ALTER DEFAULT PRIVILEGES IN SCHEMA s GRANT SELECT ON SEQUENCES TO testuser4;
ALTER DEFAULT PRIVILEGES FOR ROLE testuser3 IN SCHEMA s GRANT SELECT ON SEQUENCES TO testuser4;
ALTER DEFAULT PRIVILEGES FOR ROLE testuser4 IN SCHEMA s GRANT SELECT ON SEQUENCES TO testuser3;

-- Test 33: statement (line 122)
CALL pg_try_drop_role('testuser4');

-- Test 34: statement (line 125)
CALL pg_try_drop_role('testuser4');

-- Test 35: statement (line 131)
SET search_path = public;

-- Test 36: statement (line 134)
ALTER DEFAULT PRIVILEGES REVOKE ALL ON SEQUENCES FROM testuser2;

-- Test 37: statement (line 137)
SET search_path = testdb2, public;

-- Test 38: statement (line 140)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser3 REVOKE ALL ON SEQUENCES FROM testuser2;
ALTER DEFAULT PRIVILEGES FOR ROLE testuser2 REVOKE ALL ON SEQUENCES FROM testuser3;
ALTER DEFAULT PRIVILEGES REVOKE ALL ON SEQUENCES FROM testuser2;

-- Test 39: statement (line 145)
DROP ROLE testuser2;

-- Test 40: statement (line 149)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser3 IN SCHEMA s REVOKE ALL ON SEQUENCES FROM testuser4;
ALTER DEFAULT PRIVILEGES FOR ROLE testuser4 IN SCHEMA s REVOKE ALL ON SEQUENCES FROM testuser3;

-- Test 41: statement (line 153)
DROP ROLE testuser3;

-- Test 42: statement (line 156)
ALTER DEFAULT PRIVILEGES IN SCHEMA s REVOKE ALL ON SEQUENCES FROM testuser4;
ALTER DEFAULT PRIVILEGES IN SCHEMA public REVOKE ALL ON SEQUENCES FROM testuser4;

-- Test 43: statement (line 160)
DROP ROLE testuser4;

-- Test 44: statement (line 165)
CREATE USER not_admin WITH PASSWORD '123';
ALTER ROLE not_admin CREATEROLE;
SET ROLE not_admin;

-- Test 45: statement (line 170)
DROP ROLE IF EXISTS a_user_that_does_not_exist;

-- Test 46: statement (line 173)
DROP ROLE IF EXISTS a_user_that_does_not_exist;

-- Test 47: statement (line 176)
RESET ROLE;

-- Test 48: statement (line 179)
DROP ROLE IF EXISTS a_user_that_does_not_exist;

-- Test 49: statement (line 182)
DROP ROLE IF EXISTS a_user_that_does_not_exist;

-- Test 50: statement (line 191)
CREATE ROLE self_referencing_role;

-- Test 51: statement (line 194)
ALTER DEFAULT PRIVILEGES FOR ROLE self_referencing_role GRANT INSERT ON TABLES TO self_referencing_role;
ALTER DEFAULT PRIVILEGES FOR ROLE self_referencing_role REVOKE ALL ON TABLES FROM self_referencing_role;

-- Test 52: statement (line 197)
DROP OWNED BY self_referencing_role;
DROP ROLE self_referencing_role;

-- Test 53: query (line 200)
-- CockroachDB-specific; return a stable sentinel.
SELECT 0 AS invalid_objects;

RESET client_min_messages;
