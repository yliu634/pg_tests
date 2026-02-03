-- PostgreSQL compatible tests from procedure_privileges
-- 94 tests

SET client_min_messages = warning;

-- Roles are cluster-level objects in PostgreSQL; clean up for repeatable runs.
DROP ROLE IF EXISTS test_user;
DROP ROLE IF EXISTS testuser;
DROP ROLE IF EXISTS tester;
DROP ROLE IF EXISTS u_test_show_grants;

-- Test 1: statement (line 4)
CREATE SCHEMA test_priv_sc1;
SET search_path = public,test_priv_sc1;
CREATE PROCEDURE test_priv_p1() LANGUAGE SQL AS $$ SELECT 1 $$;
CREATE PROCEDURE test_priv_p2(int) LANGUAGE SQL AS $$ SELECT 1 $$;
CREATE PROCEDURE test_priv_sc1.test_priv_p3() LANGUAGE SQL AS $$ SELECT 1 $$;
CREATE USER test_user;
CREATE USER testuser;
GRANT testuser TO CURRENT_USER;

-- Test 2: query (line 12)
SELECT grantee, routine_schema, routine_name, privilege_type, is_grantable
FROM information_schema.role_routine_grants
WHERE routine_name IN ('test_priv_p1', 'test_priv_p2', 'test_priv_p3')
ORDER BY grantee, routine_schema, routine_name, privilege_type;

-- Test 3: query (line 28)
SELECT grantee, routine_schema, routine_name, privilege_type, is_grantable
FROM information_schema.role_routine_grants
WHERE routine_name IN ('test_priv_p1', 'test_priv_p2', 'test_priv_p3')
ORDER BY grantee, routine_schema, routine_name, privilege_type;

-- Test 4: query (line 42)
SELECT grantee, routine_schema, routine_name, privilege_type, is_grantable
FROM information_schema.role_routine_grants
WHERE routine_name IN ('test_priv_p1', 'test_priv_p2', 'test_priv_p3')
ORDER BY grantee, routine_schema, routine_name, privilege_type;

-- Test 5: query (line 59)
SELECT n.nspname AS procedure_schema,
       p.proname AS procedure_name,
       pg_get_function_identity_arguments(p.oid) AS arguments
FROM pg_proc p
JOIN pg_namespace n ON n.oid = p.pronamespace
WHERE p.prokind = 'p'
  AND n.nspname NOT IN ('pg_catalog', 'information_schema')
ORDER BY procedure_name, arguments, procedure_schema;

-- Test 6: query (line 67)
SELECT n.nspname AS procedure_schema,
       p.proname AS procedure_name,
       pg_get_function_identity_arguments(p.oid) AS arguments
FROM pg_proc p
JOIN pg_namespace n ON n.oid = p.pronamespace
WHERE p.prokind = 'p'
  AND n.nspname = 'public'
ORDER BY procedure_name, arguments, procedure_schema;

-- Test 7: query (line 74)
SELECT n.nspname AS procedure_schema,
       p.proname AS procedure_name,
       pg_get_function_identity_arguments(p.oid) AS arguments
FROM pg_proc p
JOIN pg_namespace n ON n.oid = p.pronamespace
WHERE p.prokind = 'p'
  AND n.nspname = 'test_priv_sc1'
ORDER BY procedure_name, arguments, procedure_schema;

-- Test 8: query (line 80)
SELECT n.nspname AS procedure_schema,
       p.proname AS procedure_name,
       pg_get_function_identity_arguments(p.oid) AS arguments
FROM pg_proc p
JOIN pg_namespace n ON n.oid = p.pronamespace
WHERE p.prokind = 'p'
  AND n.nspname = 'test'
ORDER BY procedure_name, arguments, procedure_schema;

-- Test 9: statement (line 88)
-- Expected ERROR (wrong object type - test_priv_p1 is a PROCEDURE in PG):
\set ON_ERROR_STOP 0
GRANT EXECUTE ON FUNCTION test_priv_p1() TO test_user WITH GRANT OPTION;
\set ON_ERROR_STOP 1

-- Test 10: statement (line 91)
GRANT EXECUTE ON PROCEDURE test_priv_p1(), test_priv_p2(int), test_priv_sc1.test_priv_p3() TO test_user WITH GRANT OPTION;

-- Test 11: query (line 94)
SELECT grantee, routine_schema, routine_name, privilege_type, is_grantable
FROM information_schema.role_routine_grants
WHERE routine_name IN ('test_priv_p1', 'test_priv_p2', 'test_priv_p3')
AND grantee = 'test_user'
ORDER BY grantee, routine_schema, routine_name, privilege_type;

-- Test 12: query (line 105)
SELECT grantee, routine_schema, routine_name, privilege_type, is_grantable
FROM information_schema.role_routine_grants
WHERE routine_name IN ('test_priv_p1', 'test_priv_p2', 'test_priv_p3')
ORDER BY grantee, routine_schema, routine_name, privilege_type;

-- Test 13: statement (line 122)
-- Expected ERROR (role still has dependent privileges):
\set ON_ERROR_STOP 0
DROP USER test_user;
\set ON_ERROR_STOP 1

-- Test 14: statement (line 125)
-- Expected ERROR (wrong object type - test_priv_p1 is a PROCEDURE in PG):
\set ON_ERROR_STOP 0
REVOKE GRANT OPTION FOR EXECUTE ON FUNCTION test_priv_p1() FROM test_user;
\set ON_ERROR_STOP 1

-- Test 15: statement (line 128)
REVOKE GRANT OPTION FOR EXECUTE ON PROCEDURE test_priv_p1(), test_priv_p2(int), test_priv_sc1.test_priv_p3() FROM test_user;

-- Test 16: query (line 131)
SELECT grantee, routine_schema, routine_name, privilege_type, is_grantable
FROM information_schema.role_routine_grants
WHERE routine_name IN ('test_priv_p1', 'test_priv_p2', 'test_priv_p3')
AND grantee = 'test_user'
ORDER BY grantee, routine_schema, routine_name, privilege_type;

-- Test 17: query (line 142)
SELECT grantee, routine_schema, routine_name, privilege_type, is_grantable
FROM information_schema.role_routine_grants
WHERE routine_name IN ('test_priv_p1', 'test_priv_p2', 'test_priv_p3')
ORDER BY grantee, routine_schema, routine_name, privilege_type;

-- Test 18: statement (line 159)
REVOKE EXECUTE ON PROCEDURE test_priv_p1(), test_priv_p2(int), test_priv_sc1.test_priv_p3() FROM test_user;

-- Test 19: query (line 162)
SELECT grantee, routine_schema, routine_name, privilege_type, is_grantable
FROM information_schema.role_routine_grants
WHERE routine_name IN ('test_priv_p1', 'test_priv_p2', 'test_priv_p3')
AND grantee = 'test_user'
ORDER BY grantee, routine_schema, routine_name, privilege_type;

-- Test 20: query (line 170)
SELECT grantee, routine_schema, routine_name, privilege_type, is_grantable
FROM information_schema.role_routine_grants
WHERE routine_name IN ('test_priv_p1', 'test_priv_p2', 'test_priv_p3')
ORDER BY grantee, routine_schema, routine_name, privilege_type;

-- Test 21: statement (line 185)
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public, test_priv_sc1 TO test_user WITH GRANT OPTION;

-- Test 22: query (line 188)
SELECT grantee, routine_schema, routine_name, privilege_type, is_grantable
FROM information_schema.role_routine_grants
WHERE routine_name IN ('test_priv_p1', 'test_priv_p2', 'test_priv_p3')
AND grantee = 'test_user'
ORDER BY grantee, routine_schema, routine_name, privilege_type;

-- Test 23: statement (line 196)
GRANT EXECUTE ON ALL PROCEDURES IN SCHEMA public, test_priv_sc1 TO test_user WITH GRANT OPTION;

-- Test 24: query (line 199)
SELECT grantee, routine_schema, routine_name, privilege_type, is_grantable
FROM information_schema.role_routine_grants
WHERE routine_name IN ('test_priv_p1', 'test_priv_p2', 'test_priv_p3')
AND grantee = 'test_user'
ORDER BY grantee, routine_schema, routine_name, privilege_type;

-- Test 25: query (line 210)
SELECT grantee, routine_schema, routine_name, privilege_type, is_grantable
FROM information_schema.role_routine_grants
WHERE routine_name IN ('test_priv_p1', 'test_priv_p2', 'test_priv_p3')
ORDER BY grantee, routine_schema, routine_name, privilege_type;

-- Test 26: statement (line 228)
REVOKE GRANT OPTION FOR EXECUTE ON ALL FUNCTIONS in schema public, test_priv_sc1 FROM test_user;

-- Test 27: query (line 231)
SELECT grantee, routine_schema, routine_name, privilege_type, is_grantable
FROM information_schema.role_routine_grants
WHERE routine_name IN ('test_priv_p1', 'test_priv_p2', 'test_priv_p3')
AND grantee = 'test_user'
ORDER BY grantee, routine_schema, routine_name, privilege_type;

-- Test 28: statement (line 242)
REVOKE GRANT OPTION FOR EXECUTE ON ALL PROCEDURES in schema public, test_priv_sc1 FROM test_user;

-- Test 29: query (line 245)
SELECT grantee, routine_schema, routine_name, privilege_type, is_grantable
FROM information_schema.role_routine_grants
WHERE routine_name IN ('test_priv_p1', 'test_priv_p2', 'test_priv_p3')
AND grantee = 'test_user'
ORDER BY grantee, routine_schema, routine_name, privilege_type;

-- Test 30: query (line 256)
SELECT grantee, routine_schema, routine_name, privilege_type, is_grantable
FROM information_schema.role_routine_grants
WHERE routine_name IN ('test_priv_p1', 'test_priv_p2', 'test_priv_p3')
ORDER BY grantee, routine_schema, routine_name, privilege_type;

-- Test 31: statement (line 274)
REVOKE EXECUTE ON ALL FUNCTIONS IN SCHEMA public, test_priv_sc1 FROM test_user;

-- Test 32: query (line 277)
SELECT grantee, routine_schema, routine_name, privilege_type, is_grantable
FROM information_schema.role_routine_grants
WHERE routine_name IN ('test_priv_p1', 'test_priv_p2', 'test_priv_p3')
AND grantee = 'test_user'
ORDER BY grantee, routine_schema, routine_name, privilege_type;

-- Test 33: statement (line 288)
REVOKE EXECUTE ON ALL PROCEDURES IN SCHEMA public, test_priv_sc1 FROM test_user;

-- Test 34: query (line 291)
SELECT grantee, routine_schema, routine_name, privilege_type, is_grantable
FROM information_schema.role_routine_grants
WHERE routine_name IN ('test_priv_p1', 'test_priv_p2', 'test_priv_p3')
AND grantee = 'test_user'
ORDER BY grantee, routine_schema, routine_name, privilege_type;

-- Test 35: query (line 299)
SELECT grantee, routine_schema, routine_name, privilege_type, is_grantable
FROM information_schema.role_routine_grants
WHERE routine_name IN ('test_priv_p1', 'test_priv_p2', 'test_priv_p3')
ORDER BY grantee, routine_schema, routine_name, privilege_type;

-- Test 36: statement (line 314)
CREATE FUNCTION test_priv_f1() RETURNS int LANGUAGE SQL AS $$ SELECT 1 $$;

-- Test 37: statement (line 317)
GRANT EXECUTE ON ALL ROUTINES IN SCHEMA public, test_priv_sc1 TO test_user;

-- Test 38: query (line 320)
SELECT grantee, routine_schema, routine_name, privilege_type, is_grantable
FROM information_schema.role_routine_grants
WHERE routine_name IN ('test_priv_p1', 'test_priv_p2', 'test_priv_p3', 'test_priv_f1')
AND grantee = 'test_user'
ORDER BY grantee, routine_schema, routine_name, privilege_type;

-- Test 39: statement (line 333)
REVOKE EXECUTE ON ALL ROUTINES IN SCHEMA public, test_priv_sc1 FROM test_user;

-- Test 40: query (line 336)
SELECT grantee, routine_schema, routine_name, privilege_type, is_grantable
FROM information_schema.role_routine_grants
WHERE routine_name IN ('test_priv_p1', 'test_priv_p2', 'test_priv_p3', 'test_priv_f1')
AND grantee = 'test_user'
ORDER BY grantee, routine_schema, routine_name, privilege_type;

-- Test 41: statement (line 344)
DROP PROCEDURE test_priv_p1();
DROP PROCEDURE test_priv_p2(int);
DROP PROCEDURE test_priv_sc1.test_priv_p3();
DROP FUNCTION test_priv_f1();
DROP USER test_user;

-- Test 42: statement (line 355)
CREATE USER test_user;
CREATE PROCEDURE test_priv_p1() LANGUAGE SQL AS $$ SELECT 1 $$;

-- Test 43: query (line 359)
SELECT grantee, routine_schema, routine_name, privilege_type, is_grantable
FROM information_schema.role_routine_grants
WHERE routine_name IN ('test_priv_p1', 'test_priv_p2', 'test_priv_p3')
ORDER BY grantee, routine_schema, routine_name, privilege_type;

-- Test 44: query (line 369)
SELECT grantee, routine_schema, routine_name, privilege_type, is_grantable
FROM information_schema.role_routine_grants
WHERE routine_name = 'test_priv_p1'
ORDER BY grantee, routine_schema, routine_name, privilege_type;

-- Test 45: statement (line 382)
ALTER DEFAULT PRIVILEGES IN SCHEMA public, test_priv_sc1 GRANT EXECUTE ON FUNCTIONS TO test_user WITH GRANT OPTION;

-- Test 46: statement (line 385)
CREATE PROCEDURE test_priv_p2(int) LANGUAGE SQL AS $$ SELECT 1 $$;
CREATE PROCEDURE test_priv_sc1.test_priv_p3() LANGUAGE SQL AS $$ SELECT 1 $$;

-- Test 47: query (line 389)
SELECT grantee, routine_schema, routine_name, privilege_type, is_grantable
FROM information_schema.role_routine_grants
WHERE routine_name IN ('test_priv_p1', 'test_priv_p2', 'test_priv_p3')
AND grantee = 'test_user'
ORDER BY grantee, routine_schema, routine_name, privilege_type;

-- Test 48: query (line 399)
SELECT grantee, routine_schema, routine_name, privilege_type, is_grantable
FROM information_schema.role_routine_grants
WHERE routine_name IN ('test_priv_p1', 'test_priv_p2', 'test_priv_p3')
ORDER BY grantee, routine_schema, routine_name, privilege_type;

-- Test 49: statement (line 415)
DROP PROCEDURE test_priv_p2(int);
DROP PROCEDURE test_priv_sc1.test_priv_p3();

-- Test 50: query (line 419)
SELECT grantee, routine_schema, routine_name, privilege_type, is_grantable
FROM information_schema.role_routine_grants
WHERE routine_name IN ('test_priv_p1', 'test_priv_p2', 'test_priv_p3')
ORDER BY grantee, routine_schema, routine_name, privilege_type;

-- Test 51: query (line 429)
SELECT grantee, routine_schema, routine_name, privilege_type, is_grantable
FROM information_schema.role_routine_grants
WHERE routine_name = 'test_priv_p1'
ORDER BY grantee, routine_schema, routine_name, privilege_type;

-- Test 52: statement (line 437)
ALTER DEFAULT PRIVILEGES IN SCHEMA public, test_priv_sc1 REVOKE EXECUTE ON FUNCTIONS FROM test_user;

-- Test 53: statement (line 440)
CREATE PROCEDURE test_priv_p2(int) LANGUAGE SQL AS $$ SELECT 1 $$;
CREATE PROCEDURE test_priv_sc1.test_priv_p3() LANGUAGE SQL AS $$ SELECT 1 $$;

-- Test 54: query (line 444)
SELECT grantee, routine_schema, routine_name, privilege_type, is_grantable
FROM information_schema.role_routine_grants
WHERE routine_name IN ('test_priv_p1', 'test_priv_p2', 'test_priv_p3')
ORDER BY grantee, routine_schema, routine_name, privilege_type;

-- Test 55: query (line 460)
SELECT grantee, routine_schema, routine_name, privilege_type, is_grantable
FROM information_schema.role_routine_grants
WHERE routine_name IN ('test_priv_p1', 'test_priv_p2', 'test_priv_p3')
ORDER BY grantee, routine_schema, routine_name, privilege_type;

-- Test 56: query (line 475)
SELECT has_function_privilege('test_priv_p2(INT)', 'EXECUTE');

-- Test 57: query (line 480)
SELECT has_function_privilege('test_priv_p2(INT)', 'EXECUTE WITH GRANT OPTION');

-- Test 58: query (line 485)
SELECT has_function_privilege('test_priv_p2(INT)', 'EXECUTE, EXECUTE WITH GRANT OPTION');

-- Test 59: query (line 492)
SELECT has_function_privilege('test_priv_p2(INT)', 'EXECUTE');

-- Test 60: query (line 497)
SELECT has_function_privilege('test_priv_p2(INT)', 'EXECUTE WITH GRANT OPTION');

-- Test 61: query (line 502)
SELECT has_function_privilege('test_priv_p2(INT)', 'EXECUTE, EXECUTE WITH GRANT OPTION');

-- Test 62: statement (line 509)
GRANT EXECUTE ON PROCEDURE test_priv_p1(), test_priv_p2(int), test_priv_sc1.test_priv_p3() TO testuser WITH GRANT OPTION;

SET ROLE testuser;

-- Test 63: query (line 514)
SELECT has_function_privilege('test_priv_p2(INT)', 'EXECUTE');

-- Test 64: query (line 519)
SELECT has_function_privilege('test_priv_p2(INT)', 'EXECUTE WITH GRANT OPTION');

-- Test 65: query (line 524)
SELECT has_function_privilege('test_priv_p2(INT)', 'EXECUTE, EXECUTE WITH GRANT OPTION');

RESET ROLE;

-- Test 66: statement (line 531)
REVOKE GRANT OPTION FOR EXECUTE ON PROCEDURE test_priv_p1(), test_priv_p2(int), test_priv_sc1.test_priv_p3() FROM testuser;

SET ROLE testuser;

-- Test 67: query (line 536)
SELECT has_function_privilege('test_priv_p2(INT)', 'EXECUTE WITH GRANT OPTION');

-- Test 68: query (line 541)
SELECT has_function_privilege('test_priv_p2(INT)', 'EXECUTE');

-- Test 69: query (line 546)
SELECT has_function_privilege('test_priv_p2(INT)', 'EXECUTE, EXECUTE WITH GRANT OPTION');

RESET ROLE;

-- Test 70: statement (line 553)
SET search_path = public;

CREATE USER u_test_show_grants;
GRANT u_test_show_grants TO CURRENT_USER;
CREATE PROCEDURE p_test_show_grants(INT) LANGUAGE SQL AS $$ SELECT 1 $$;
GRANT EXECUTE ON PROCEDURE p_test_show_grants(INT) TO u_test_show_grants;

-- Test 71: statement (line 569)
SELECT grantee, routine_schema, routine_name, privilege_type, is_grantable
FROM information_schema.role_routine_grants
WHERE routine_name = 'p_test_show_grants'
ORDER BY grantee, routine_schema, routine_name, privilege_type;

-- Test 72: query (line 590)
SELECT grantee, routine_schema, routine_name, privilege_type, is_grantable
FROM information_schema.role_routine_grants
WHERE routine_name = 'p_test_show_grants'
ORDER BY grantee, routine_schema, routine_name, privilege_type;

-- Test 73: statement (line 610)
-- Expected ERROR (procedure does not exist):
\set ON_ERROR_STOP 0
GRANT EXECUTE ON PROCEDURE p_not_existing() TO u_test_show_grants;
\set ON_ERROR_STOP 1

-- Test 74: query (line 624)
SELECT routine_schema AS object_schema,
       routine_name AS object_name,
       privilege_type,
       is_grantable
FROM information_schema.role_routine_grants
WHERE grantee = 'u_test_show_grants'
ORDER BY object_name, object_schema, privilege_type;

-- Test 75: statement (line 639)
SET search_path = public;

-- Test 76: statement (line 646)
CREATE SCHEMA sc_test_priv;

SET ROLE testuser;

-- Test 77: statement (line 651)
-- Expected ERROR (no CREATE privilege on schema sc_test_priv):
\set ON_ERROR_STOP 0
CREATE PROCEDURE sc_test_priv.f() LANGUAGE SQL AS $$ SELECT 1 $$;
\set ON_ERROR_STOP 1

RESET ROLE;

-- Test 78: statement (line 656)
GRANT CREATE ON SCHEMA sc_test_priv TO testuser;

SET ROLE testuser;

-- Test 79: statement (line 661)
CREATE PROCEDURE sc_test_priv.f() LANGUAGE SQL AS $$ SELECT 1 $$;

RESET ROLE;

-- Test 80: statement (line 670)
CREATE USER tester;
GRANT tester TO CURRENT_USER;

-- Test 81: statement (line 673)
CREATE SCHEMA test;

-- Test 82: statement (line 676)
GRANT USAGE ON SCHEMA test TO tester;

-- Test 83: statement (line 679)
CREATE PROCEDURE test.p() LANGUAGE SQL AS $$ SELECT 1 $$;

-- Test 84: statement (line 682)
SET ROLE tester;

-- Test 85: statement (line 686)
CALL test.p();

-- Test 86: statement (line 689)
RESET ROLE;

-- Test 87: statement (line 693)
REVOKE EXECUTE ON PROCEDURE test.p() FROM public;

-- Test 88: statement (line 697)
CALL test.p();

-- Test 89: statement (line 700)
SET ROLE tester;

-- Test 90: statement (line 703)
-- Expected ERROR (permission denied for procedure test.p()):
\set ON_ERROR_STOP 0
CALL test.p();
\set ON_ERROR_STOP 1

-- Test 91: statement (line 706)
RESET ROLE;

-- Test 92: statement (line 710)
GRANT EXECUTE ON PROCEDURE test.p() TO public;

-- Test 93: statement (line 713)
SET ROLE tester;

-- Test 94: statement (line 716)
CALL test.p();
