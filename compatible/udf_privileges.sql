-- PostgreSQL compatible tests from udf_privileges
-- 104 tests

-- Test 1: statement (line 5)
CREATE SCHEMA test_priv_sc1;
SET search_path = public,test_priv_sc1;
CREATE FUNCTION test_priv_f1() RETURNS INT LANGUAGE SQL AS $$ SELECT 1 $$;
CREATE FUNCTION test_priv_f2(int) RETURNS INT LANGUAGE SQL AS $$ SELECT 1 $$;
CREATE FUNCTION test_priv_sc1.test_priv_f3() RETURNS INT LANGUAGE SQL AS $$ SELECT 1 $$;
DROP ROLE IF EXISTS udf_test_user;
CREATE USER udf_test_user;

-- Test 2: query (line 13)
SELECT grantor, grantee, routine_schema, routine_name, privilege_type, is_grantable
FROM information_schema.role_routine_grants
WHERE routine_name IN ('test_priv_f1', 'test_priv_f2', 'test_priv_f3')
ORDER BY grantee, routine_schema, routine_name, privilege_type;

-- Test 3: query (line 29)
SELECT grantor, grantee, routine_schema, routine_name, privilege_type, is_grantable
FROM information_schema.role_routine_grants
WHERE routine_name IN ('test_priv_f1', 'test_priv_f2', 'test_priv_f3')
ORDER BY grantee, routine_schema, routine_name, privilege_type;

-- Test 4: query (line 43)
SELECT grantor, grantee, routine_schema, routine_name, privilege_type, is_grantable
FROM information_schema.role_routine_grants
WHERE routine_name IN ('test_priv_f1', 'test_priv_f2', 'test_priv_f3')
ORDER BY grantee, routine_schema, routine_name, privilege_type;

-- Test 5: query (line 57)
SELECT n.nspname AS function_schema, p.proname AS function_name, pg_get_function_result(p.oid) AS result_data_type
FROM pg_catalog.pg_proc AS p
JOIN pg_catalog.pg_namespace AS n ON n.oid = p.pronamespace
WHERE n.nspname NOT IN ('pg_catalog', 'information_schema')
ORDER BY function_name, result_data_type;

-- Test 6: query (line 65)
SELECT n.nspname AS function_schema, p.proname AS function_name, pg_get_function_result(p.oid) AS result_data_type
FROM pg_catalog.pg_proc AS p
JOIN pg_catalog.pg_namespace AS n ON n.oid = p.pronamespace
WHERE n.nspname = 'public'
ORDER BY function_name, result_data_type;

-- Test 7: query (line 72)
SELECT n.nspname AS function_schema, p.proname AS function_name, pg_get_function_result(p.oid) AS result_data_type
FROM pg_catalog.pg_proc AS p
JOIN pg_catalog.pg_namespace AS n ON n.oid = p.pronamespace
WHERE n.nspname = 'test_priv_sc1'
ORDER BY function_name, result_data_type;

-- Test 8: query (line 78)
SELECT n.nspname AS function_schema, p.proname AS function_name, pg_get_function_result(p.oid) AS result_data_type
FROM pg_catalog.pg_proc AS p
JOIN pg_catalog.pg_namespace AS n ON n.oid = p.pronamespace
WHERE n.nspname = 'test'
ORDER BY function_name, result_data_type;

-- Test 9: statement (line 86)
GRANT EXECUTE ON FUNCTION test_priv_f1() TO udf_test_user WITH GRANT OPTION;

-- Test 10: statement (line 89)
GRANT EXECUTE ON FUNCTION test_priv_f1(), test_priv_f2(int), test_priv_sc1.test_priv_f3 TO udf_test_user WITH GRANT OPTION;

-- Test 11: query (line 92)
SELECT grantor, grantee, routine_schema, routine_name, privilege_type, is_grantable
FROM information_schema.role_routine_grants
WHERE routine_name IN ('test_priv_f1', 'test_priv_f2', 'test_priv_f3')
AND grantee = 'udf_test_user'
ORDER BY grantee, routine_schema, routine_name, privilege_type;

-- Test 12: query (line 103)
SELECT grantor, grantee, routine_schema, routine_name, privilege_type, is_grantable
FROM information_schema.role_routine_grants
WHERE routine_name IN ('test_priv_f1', 'test_priv_f2', 'test_priv_f3')
ORDER BY grantee, routine_schema, routine_name, privilege_type;

-- Test 13: statement (line 120)
-- Keep the role for subsequent REVOKE/GRANT tests.

-- Test 14: statement (line 123)
REVOKE GRANT OPTION FOR EXECUTE ON FUNCTION test_priv_f1(), test_priv_f2(int), test_priv_sc1.test_priv_f3 FROM udf_test_user;

-- Test 15: query (line 126)
SELECT grantor, grantee, routine_schema, routine_name, privilege_type, is_grantable
FROM information_schema.role_routine_grants
WHERE routine_name IN ('test_priv_f1', 'test_priv_f2', 'test_priv_f3')
AND grantee = 'udf_test_user'
ORDER BY grantee, routine_schema, routine_name, privilege_type;

-- Test 16: query (line 137)
SELECT grantor, grantee, routine_schema, routine_name, privilege_type, is_grantable
FROM information_schema.role_routine_grants
WHERE routine_name IN ('test_priv_f1', 'test_priv_f2', 'test_priv_f3')
ORDER BY grantee, routine_schema, routine_name, privilege_type;

-- Test 17: statement (line 154)
REVOKE EXECUTE ON FUNCTION test_priv_f1() FROM udf_test_user;

-- Test 18: statement (line 157)
REVOKE EXECUTE ON FUNCTION test_priv_f1(), test_priv_f2(int), test_priv_sc1.test_priv_f3 FROM udf_test_user;

-- Test 19: query (line 160)
SELECT grantor, grantee, routine_schema, routine_name, privilege_type, is_grantable
FROM information_schema.role_routine_grants
WHERE routine_name IN ('test_priv_f1', 'test_priv_f2', 'test_priv_f3')
AND grantee = 'udf_test_user'
ORDER BY grantee, routine_schema, routine_name, privilege_type;

-- Test 20: query (line 168)
SELECT grantor, grantee, routine_schema, routine_name, privilege_type, is_grantable
FROM information_schema.role_routine_grants
WHERE routine_name IN ('test_priv_f1', 'test_priv_f2', 'test_priv_f3')
ORDER BY grantee, routine_schema, routine_name, privilege_type;

-- Test 21: statement (line 183)
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public, test_priv_sc1 TO udf_test_user WITH GRANT OPTION;

-- Test 22: query (line 186)
SELECT grantor, grantee, routine_schema, routine_name, privilege_type, is_grantable
FROM information_schema.role_routine_grants
WHERE routine_name IN ('test_priv_f1', 'test_priv_f2', 'test_priv_f3')
AND grantee = 'udf_test_user'
ORDER BY grantee, routine_schema, routine_name, privilege_type;

-- Test 23: statement (line 194)
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public, test_priv_sc1 TO udf_test_user WITH GRANT OPTION;

-- Test 24: query (line 197)
SELECT grantor, grantee, routine_schema, routine_name, privilege_type, is_grantable
FROM information_schema.role_routine_grants
WHERE routine_name IN ('test_priv_f1', 'test_priv_f2', 'test_priv_f3')
AND grantee = 'udf_test_user'
ORDER BY grantee, routine_schema, routine_name, privilege_type;

-- Test 25: query (line 208)
SELECT grantor, grantee, routine_schema, routine_name, privilege_type, is_grantable
FROM information_schema.role_routine_grants
WHERE routine_name IN ('test_priv_f1', 'test_priv_f2', 'test_priv_f3')
ORDER BY grantee, routine_schema, routine_name, privilege_type;

-- Test 26: statement (line 226)
REVOKE GRANT OPTION FOR EXECUTE ON ALL FUNCTIONS IN SCHEMA public, test_priv_sc1 FROM udf_test_user;

-- Test 27: query (line 229)
SELECT grantor, grantee, routine_schema, routine_name, privilege_type, is_grantable
FROM information_schema.role_routine_grants
WHERE routine_name IN ('test_priv_f1', 'test_priv_f2', 'test_priv_f3')
AND grantee = 'udf_test_user'
ORDER BY grantee, routine_schema, routine_name, privilege_type;

-- Test 28: statement (line 240)
REVOKE GRANT OPTION FOR EXECUTE ON ALL FUNCTIONS in schema public, test_priv_sc1 FROM udf_test_user;

-- Test 29: query (line 243)
SELECT grantor, grantee, routine_schema, routine_name, privilege_type, is_grantable
FROM information_schema.role_routine_grants
WHERE routine_name IN ('test_priv_f1', 'test_priv_f2', 'test_priv_f3')
AND grantee = 'udf_test_user'
ORDER BY grantee, routine_schema, routine_name, privilege_type;

-- Test 30: query (line 254)
SELECT grantor, grantee, routine_schema, routine_name, privilege_type, is_grantable
FROM information_schema.role_routine_grants
WHERE routine_name IN ('test_priv_f1', 'test_priv_f2', 'test_priv_f3')
ORDER BY grantee, routine_schema, routine_name, privilege_type;

-- Test 31: statement (line 271)
REVOKE EXECUTE ON ALL FUNCTIONS IN SCHEMA public, test_priv_sc1 FROM udf_test_user;

-- Test 32: query (line 274)
SELECT grantor, grantee, routine_schema, routine_name, privilege_type, is_grantable
FROM information_schema.role_routine_grants
WHERE routine_name IN ('test_priv_f1', 'test_priv_f2', 'test_priv_f3')
AND grantee = 'udf_test_user'
ORDER BY grantee, routine_schema, routine_name, privilege_type;

-- Test 33: query (line 282)
SELECT grantor, grantee, routine_schema, routine_name, privilege_type, is_grantable
FROM information_schema.role_routine_grants
WHERE routine_name IN ('test_priv_f1', 'test_priv_f2', 'test_priv_f3')
ORDER BY grantee, routine_schema, routine_name, privilege_type;

-- Test 34: statement (line 296)
DROP FUNCTION IF EXISTS test_priv_f1();
DROP FUNCTION IF EXISTS test_priv_f2(int);
DROP FUNCTION IF EXISTS test_priv_sc1.test_priv_f3();
DROP ROLE IF EXISTS udf_test_user;

-- Test 35: statement (line 306)
DROP ROLE IF EXISTS udf_test_user;
CREATE USER udf_test_user;
CREATE FUNCTION test_priv_f1() RETURNS INT LANGUAGE SQL AS $$ SELECT 1 $$;

-- Test 36: query (line 310)
SELECT grantor, grantee, routine_schema, routine_name, privilege_type, is_grantable
FROM information_schema.role_routine_grants
WHERE routine_name IN ('test_priv_f1', 'test_priv_f2', 'test_priv_f3')
AND grantee = 'udf_test_user'
ORDER BY grantee, routine_schema, routine_name, privilege_type;

-- Test 37: query (line 318)
SELECT grantor, grantee, routine_schema, routine_name, privilege_type, is_grantable
FROM information_schema.role_routine_grants
WHERE routine_name IN ('test_priv_f1')
ORDER BY grantee, routine_schema, routine_name, privilege_type;

-- Test 38: statement (line 327)
ALTER DEFAULT PRIVILEGES IN SCHEMA public, test_priv_sc1 GRANT EXECUTE ON FUNCTIONS TO udf_test_user WITH GRANT OPTION;

-- Test 39: statement (line 330)
CREATE FUNCTION test_priv_f2(int) RETURNS INT LANGUAGE SQL AS $$ SELECT 1 $$;
CREATE FUNCTION test_priv_sc1.test_priv_f3() RETURNS INT LANGUAGE SQL AS $$ SELECT 1 $$;

-- Test 40: query (line 334)
SELECT grantor, grantee, routine_schema, routine_name, privilege_type, is_grantable
FROM information_schema.role_routine_grants
WHERE routine_name IN ('test_priv_f1', 'test_priv_f2', 'test_priv_f3')
AND grantee = 'udf_test_user'
ORDER BY grantee, routine_schema, routine_name, privilege_type;

-- Test 41: query (line 344)
SELECT grantor, grantee, routine_schema, routine_name, privilege_type, is_grantable
FROM information_schema.role_routine_grants
WHERE routine_name IN ('test_priv_f1', 'test_priv_f2', 'test_priv_f3')
ORDER BY grantee, routine_schema, routine_name, privilege_type;

-- Test 42: statement (line 360)
DROP FUNCTION IF EXISTS test_priv_f2(int);
DROP FUNCTION IF EXISTS test_priv_sc1.test_priv_f3();

-- Test 43: query (line 364)
SELECT grantor, grantee, routine_schema, routine_name, privilege_type, is_grantable
FROM information_schema.role_routine_grants
WHERE routine_name IN ('test_priv_f1', 'test_priv_f2', 'test_priv_f3')
ORDER BY grantee, routine_schema, routine_name, privilege_type;

-- Test 44: query (line 374)
SELECT grantor, grantee, routine_schema, routine_name, privilege_type, is_grantable
FROM information_schema.role_routine_grants
WHERE routine_name IN ('test_priv_f1')
ORDER BY grantee, routine_schema, routine_name, privilege_type;

-- Test 45: statement (line 382)
ALTER DEFAULT PRIVILEGES IN SCHEMA public, test_priv_sc1 REVOKE EXECUTE ON FUNCTIONS FROM udf_test_user;

-- Test 46: statement (line 385)
CREATE FUNCTION test_priv_f2(int) RETURNS INT LANGUAGE SQL AS $$ SELECT 1 $$;
CREATE FUNCTION test_priv_sc1.test_priv_f3() RETURNS INT LANGUAGE SQL AS $$ SELECT 1 $$;

-- Test 47: query (line 389)
SELECT grantor, grantee, routine_schema, routine_name, privilege_type, is_grantable
FROM information_schema.role_routine_grants
WHERE routine_name IN ('test_priv_f1', 'test_priv_f2', 'test_priv_f3')
ORDER BY grantee, routine_schema, routine_name, privilege_type;

-- Test 48: query (line 405)
SELECT grantor, grantee, routine_schema, routine_name, privilege_type, is_grantable
FROM information_schema.role_routine_grants
WHERE routine_name IN ('test_priv_f1', 'test_priv_f2', 'test_priv_f3')
ORDER BY grantee, routine_schema, routine_name, privilege_type;

-- Test 49: query (line 420)
SELECT has_function_privilege('test_priv_f2(INT)', 'EXECUTE');

-- Test 50: query (line 425)
SELECT has_function_privilege('test_priv_f2(INT)', 'EXECUTE WITH GRANT OPTION');

-- Test 51: query (line 430)
SELECT has_function_privilege('test_priv_f2(INT)', 'EXECUTE, EXECUTE WITH GRANT OPTION');

-- Test 52: query (line 437)
SELECT has_function_privilege('test_priv_f2(INT)', 'EXECUTE');

-- Test 53: query (line 442)
SELECT has_function_privilege('test_priv_f2(INT)', 'EXECUTE WITH GRANT OPTION');

-- Test 54: query (line 447)
SELECT has_function_privilege('test_priv_f2(INT)', 'EXECUTE, EXECUTE WITH GRANT OPTION');

-- Test 55: statement (line 454)
GRANT EXECUTE ON FUNCTION test_priv_f1(), test_priv_f2(int), test_priv_sc1.test_priv_f3 TO udf_test_user WITH GRANT OPTION;

SET ROLE udf_test_user;

-- Test 56: query (line 459)
SELECT has_function_privilege('test_priv_f2(INT)', 'EXECUTE');

-- Test 57: query (line 464)
SELECT has_function_privilege('test_priv_f2(INT)', 'EXECUTE WITH GRANT OPTION');

-- Test 58: query (line 469)
SELECT has_function_privilege('test_priv_f2(INT)', 'EXECUTE, EXECUTE WITH GRANT OPTION');

RESET ROLE;

-- Test 59: statement (line 476)
REVOKE GRANT OPTION FOR EXECUTE ON FUNCTION test_priv_f1(), test_priv_f2(int), test_priv_sc1.test_priv_f3 FROM udf_test_user;

SET ROLE udf_test_user;

-- Test 60: query (line 481)
SELECT has_function_privilege('test_priv_f2(INT)', 'EXECUTE WITH GRANT OPTION');

-- Test 61: query (line 486)
SELECT has_function_privilege('test_priv_f2(INT)', 'EXECUTE');

-- Test 62: query (line 491)
SELECT has_function_privilege('test_priv_f2(INT)', 'EXECUTE, EXECUTE WITH GRANT OPTION');

RESET ROLE;

-- Test 63: statement (line 498)
SET search_path = public;

-- Test 64: statement (line 512)
CREATE PROCEDURE test_priv_p() LANGUAGE SQL AS $$ SELECT 1 $$;

-- Test 65: statement (line 518)
SELECT grantor, grantee, routine_schema, routine_name, privilege_type, is_grantable
FROM information_schema.role_routine_grants
WHERE routine_name = 'f_test_show_grants'
ORDER BY grantee, routine_schema, routine_name, privilege_type;

-- Test 66: query (line 539)
SELECT grantor, grantee, routine_schema, routine_name, privilege_type, is_grantable
FROM information_schema.role_routine_grants
WHERE routine_name = 'f_test_show_grants'
ORDER BY grantee, routine_schema, routine_name, privilege_type;

-- Test 67: statement (line 557)
SELECT grantor, grantee, routine_schema, routine_name, privilege_type, is_grantable
FROM information_schema.role_routine_grants
WHERE routine_name = 'f_not_existing'
ORDER BY grantee, routine_schema, routine_name, privilege_type;

-- Test 68: query (line 571)
SELECT grantee,
       routine_schema || '.' || routine_name AS object_name,
       privilege_type,
       is_grantable,
       grantor
FROM information_schema.role_routine_grants
WHERE grantee = 'u_test_show_grants'
ORDER BY object_name;

-- Test 69: statement (line 586)
SET search_path = public;

-- Test 70: statement (line 593)
CREATE SCHEMA sc_test_priv;

SET ROLE udf_test_user;

-- Test 71: statement (line 598)
-- Creating in another user's schema should fail without CREATE privilege.
DO $do$
BEGIN
  EXECUTE $sql$CREATE FUNCTION sc_test_priv.f() RETURNS INT LANGUAGE SQL AS $$ SELECT 1 $$;$sql$;
EXCEPTION
  WHEN insufficient_privilege THEN
    NULL;
END
$do$;

RESET ROLE;

-- Test 72: statement (line 603)
GRANT CREATE ON SCHEMA sc_test_priv TO udf_test_user;

SET ROLE udf_test_user;

-- Test 73: statement (line 608)
CREATE OR REPLACE FUNCTION sc_test_priv.f() RETURNS INT LANGUAGE SQL AS $$ SELECT 1 $$;

RESET ROLE;

-- Test 74: statement (line 617)
DROP ROLE IF EXISTS u_test_owner;
CREATE USER u_test_owner;
CREATE FUNCTION f_test_alter_owner() RETURNS INT LANGUAGE SQL AS $$ SELECT 1 $$;

-- Test 75: query (line 621)
SELECT rolname FROM pg_catalog.pg_proc f
JOIN pg_catalog.pg_roles r ON f.proowner = r.oid
WHERE proname = 'f_test_alter_owner';

-- Test 76: statement (line 628)
DO $do$
BEGIN
  EXECUTE 'ALTER FUNCTION f_test_alter_owner() OWNER TO user_not_exists';
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END
$do$;

-- Test 77: statement (line 631)
ALTER FUNCTION f_test_alter_owner() OWNER TO u_test_owner;

-- Test 78: query (line 634)
SELECT rolname FROM pg_catalog.pg_proc f
JOIN pg_catalog.pg_roles r ON f.proowner = r.oid
WHERE proname = 'f_test_alter_owner';

-- Test 79: statement (line 641)
REASSIGN OWNED BY u_test_owner TO postgres;

-- Test 80: query (line 644)
SELECT rolname FROM pg_catalog.pg_proc f
JOIN pg_catalog.pg_roles r ON f.proowner = r.oid
WHERE proname = 'f_test_alter_owner';

-- Test 81: statement (line 651)
ALTER FUNCTION f_test_alter_owner() OWNER TO u_test_owner;

-- Test 82: query (line 654)
SELECT rolname FROM pg_catalog.pg_proc f
JOIN pg_catalog.pg_roles r ON f.proowner = r.oid
WHERE proname = 'f_test_alter_owner';

-- Test 83: statement (line 661)
DO $do$
BEGIN
  EXECUTE 'DROP ROLE u_test_owner';
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END
$do$;

-- Test 84: statement (line 664)
DROP FUNCTION IF EXISTS f_test_alter_owner();

-- Test 85: statement (line 667)
DROP ROLE IF EXISTS u_test_owner;

-- Test 86: statement (line 670)
CREATE PROCEDURE p() LANGUAGE SQL AS $$ SELECT 1 $$;

-- Test 87: statement (line 673)
ALTER PROCEDURE p() OWNER TO postgres;

-- Test 88: statement (line 676)
DROP PROCEDURE p();

-- Test 89: statement (line 683)
DROP ROLE IF EXISTS udf_priv_tester;
CREATE USER udf_priv_tester;

-- Test 90: statement (line 686)
CREATE SCHEMA test;

-- Test 91: statement (line 689)
GRANT USAGE ON SCHEMA test TO udf_priv_tester;

-- Test 92: statement (line 692)
CREATE FUNCTION test.my_add(a INT, b INT) RETURNS INT IMMUTABLE LEAKPROOF LANGUAGE SQL AS 'SELECT a + b';

-- Test 93: statement (line 695)
SET ROLE udf_priv_tester;

-- Test 94: statement (line 699)
SELECT test.my_add(1,2);

-- Test 95: statement (line 702)
RESET ROLE;

-- Test 96: statement (line 706)
REVOKE EXECUTE ON FUNCTION test.my_add(int, int) FROM public;

-- Test 97: statement (line 710)
SELECT test.my_add(1,2);

-- Test 98: statement (line 713)
SET ROLE udf_priv_tester;

-- Test 99: statement (line 716)
DO $do$
BEGIN
  EXECUTE 'SELECT * FROM (VALUES (1), (2)) AS v(i) WHERE i = test.my_add(1,2)';
EXCEPTION
  WHEN insufficient_privilege THEN
    NULL;
END
$do$;

-- Test 100: statement (line 719)
RESET ROLE;

-- Test 101: statement (line 723)
GRANT EXECUTE ON FUNCTION test.my_add(int, int) TO public;

-- Test 102: statement (line 726)
SET ROLE udf_priv_tester;

-- Test 103: statement (line 729)
SELECT test.my_add(1,2);

-- Test 104: statement (line 732)
RESET ROLE;

-- Cleanup: keep this file idempotent across runs.
DROP OWNED BY udf_priv_tester;
DROP ROLE IF EXISTS udf_priv_tester;
