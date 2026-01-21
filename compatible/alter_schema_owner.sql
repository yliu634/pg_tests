-- PostgreSQL compatible tests from alter_schema_owner
-- 17 tests

-- Test 1: statement (line 1)
SET client_min_messages = warning;
DROP SCHEMA IF EXISTS s CASCADE;
DROP ROLE IF EXISTS aso_testuser;
DROP ROLE IF EXISTS aso_testuser2;
DROP ROLE IF EXISTS aso_root;
RESET client_min_messages;

CREATE ROLE aso_root LOGIN SUPERUSER;
CREATE ROLE aso_testuser LOGIN;
CREATE ROLE aso_testuser2 LOGIN;

-- Grant privileges needed for non-superuser role ownership/DDL in the temp DB.
SELECT format('GRANT CREATE ON DATABASE %I TO aso_testuser, aso_testuser2', current_database()) \gexec
GRANT aso_testuser2 TO aso_testuser;

-- user root
SET SESSION AUTHORIZATION aso_root;

CREATE SCHEMA s;

-- Test 2: statement (line 6)
ALTER SCHEMA s OWNER TO aso_testuser;

-- Test 3: statement (line 9)
ALTER SCHEMA s OWNER TO aso_root;

-- Test 4: statement (line 15)
ALTER SCHEMA s OWNER TO aso_testuser;

-- Test 5: statement (line 19)
ALTER SCHEMA s OWNER TO aso_root;

-- Test 6: statement (line 25)
ALTER SCHEMA s OWNER TO aso_testuser;

-- user testuser
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION aso_testuser;

-- Test 7: statement (line 30)
\set ON_ERROR_STOP 0
ALTER SCHEMA s OWNER TO aso_testuser2;
\set ON_ERROR_STOP 1

-- user root
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION aso_root;

-- Test 8: statement (line 35)

-- user testuser
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION aso_testuser;

-- Test 9: statement (line 40)
\set ON_ERROR_STOP 0
ALTER SCHEMA s OWNER TO aso_testuser2;
\set ON_ERROR_STOP 1

-- user root
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION aso_root;

-- Test 10: statement (line 45)
SELECT format('GRANT CREATE ON DATABASE %I TO aso_testuser', current_database()) \gexec

-- user testuser
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION aso_testuser;

-- Test 11: statement (line 50)
ALTER SCHEMA s OWNER TO aso_testuser2;

-- Test 12: query (line 53)
SELECT pg_get_userbyid(nspowner) FROM pg_namespace WHERE nspname = 's';

-- Test 13: statement (line 58)
ALTER SCHEMA s OWNER TO CURRENT_USER;

-- Test 14: query (line 61)
SELECT pg_get_userbyid(nspowner) FROM pg_namespace WHERE nspname = 's';

-- Test 15: statement (line 66)
ALTER SCHEMA s OWNER TO aso_testuser2;

-- Test 16: statement (line 69)
ALTER SCHEMA s OWNER TO SESSION_USER;

-- Test 17: query (line 72)
SELECT pg_get_userbyid(nspowner) FROM pg_namespace WHERE nspname = 's';

-- Cleanup (roles are cluster-wide, so remove them to keep the suite isolated).
RESET SESSION AUTHORIZATION;
SELECT format('REVOKE CREATE ON DATABASE %I FROM aso_testuser, aso_testuser2', current_database()) \gexec
DROP SCHEMA IF EXISTS s CASCADE;
DROP ROLE IF EXISTS aso_testuser;
DROP ROLE IF EXISTS aso_testuser2;
DROP ROLE IF EXISTS aso_root;
