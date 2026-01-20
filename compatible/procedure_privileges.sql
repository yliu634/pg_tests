-- PostgreSQL compatible tests from procedure_privileges
-- 94 tests

-- Test 1: statement (line 4)
CREATE SCHEMA test_priv_sc1;
SET search_path = public,test_priv_sc1;
CREATE PROCEDURE test_priv_p1() LANGUAGE SQL AS $$ SELECT 1 $$;
CREATE PROCEDURE test_priv_p2(int) LANGUAGE SQL AS $$ SELECT 1 $$;
CREATE PROCEDURE test_priv_sc1.test_priv_p3() LANGUAGE SQL AS $$ SELECT 1 $$;
CREATE USER test_user;

-- Test 2: query (line 12)
SELECT * FROM information_schema.role_routine_grants
WHERE routine_name IN ('test_priv_p1', 'test_priv_p2', 'test_priv_p3')
ORDER BY grantee, routine_name;

-- Test 3: query (line 28)
SHOW GRANTS ON PROCEDURE test_priv_p1, test_priv_p2, test_priv_p3

-- Test 4: query (line 42)
SHOW GRANTS ON PROCEDURE test_priv_p1(), test_priv_p2(INT), test_priv_p3()

-- Test 5: query (line 59)
SELECT * FROM [SHOW PROCEDURES] ORDER BY procedure_name

-- Test 6: query (line 67)
SELECT * FROM [SHOW PROCEDURES FROM public] ORDER BY procedure_name

-- Test 7: query (line 74)
SHOW PROCEDURES FROM test_priv_sc1

-- Test 8: query (line 80)
SELECT * FROM [SHOW PROCEDURES FROM test] ORDER BY procedure_name

-- Test 9: statement (line 88)
GRANT EXECUTE ON FUNCTION test_priv_p1() TO test_user WITH GRANT OPTION

-- Test 10: statement (line 91)
GRANT EXECUTE ON PROCEDURE test_priv_p1(), test_priv_p2(int), test_priv_sc1.test_priv_p3 TO test_user WITH GRANT OPTION;

-- Test 11: query (line 94)
SELECT * FROM information_schema.role_routine_grants
WHERE routine_name IN ('test_priv_p1', 'test_priv_p2', 'test_priv_p3')
AND grantee = 'test_user'
ORDER BY grantee, routine_name;

-- Test 12: query (line 105)
SHOW GRANTS ON PROCEDURE test_priv_p1, test_priv_p2, test_priv_p3

-- Test 13: statement (line 122)
DROP USER test_user;

-- Test 14: statement (line 125)
REVOKE GRANT OPTION FOR EXECUTE ON FUNCTION test_priv_p1() FROM test_user

-- Test 15: statement (line 128)
REVOKE GRANT OPTION FOR EXECUTE ON PROCEDURE test_priv_p1(), test_priv_p2(int), test_priv_sc1.test_priv_p3 FROM test_user;

-- Test 16: query (line 131)
SELECT * FROM information_schema.role_routine_grants
WHERE routine_name IN ('test_priv_p1', 'test_priv_p2', 'test_priv_p3')
AND grantee = 'test_user'
ORDER BY grantee, routine_name;

-- Test 17: query (line 142)
SHOW GRANTS ON PROCEDURE test_priv_p1, test_priv_p2, test_priv_p3

-- Test 18: statement (line 159)
REVOKE EXECUTE ON PROCEDURE test_priv_p1(), test_priv_p2(int), test_priv_sc1.test_priv_p3 FROM test_user;

-- Test 19: query (line 162)
SELECT * FROM information_schema.role_routine_grants
WHERE routine_name IN ('test_priv_p1', 'test_priv_p2', 'test_priv_p3')
AND grantee = 'test_user'
ORDER BY grantee, routine_name;

-- Test 20: query (line 170)
SHOW GRANTS ON PROCEDURE test_priv_p1, test_priv_p2, test_priv_p3

-- Test 21: statement (line 185)
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public, test_priv_sc1 TO test_user WITH GRANT OPTION;

-- Test 22: query (line 188)
SELECT * FROM information_schema.role_routine_grants
WHERE routine_name IN ('test_priv_p1', 'test_priv_p2', 'test_priv_p3')
AND grantee = 'test_user'
ORDER BY grantee, routine_name;

-- Test 23: statement (line 196)
GRANT EXECUTE ON ALL PROCEDURES IN SCHEMA public, test_priv_sc1 TO test_user WITH GRANT OPTION;

-- Test 24: query (line 199)
SELECT * FROM information_schema.role_routine_grants
WHERE routine_name IN ('test_priv_p1', 'test_priv_p2', 'test_priv_p3')
AND grantee = 'test_user'
ORDER BY grantee, routine_name;

-- Test 25: query (line 210)
SHOW GRANTS ON PROCEDURE test_priv_p1, test_priv_p2, test_priv_p3

-- Test 26: statement (line 228)
REVOKE GRANT OPTION FOR EXECUTE ON ALL FUNCTIONS in schema public, test_priv_sc1 FROM test_user;

-- Test 27: query (line 231)
SELECT * FROM information_schema.role_routine_grants
WHERE routine_name IN ('test_priv_p1', 'test_priv_p2', 'test_priv_p3')
AND grantee = 'test_user'
ORDER BY grantee, routine_name;

-- Test 28: statement (line 242)
REVOKE GRANT OPTION FOR EXECUTE ON ALL PROCEDURES in schema public, test_priv_sc1 FROM test_user;

-- Test 29: query (line 245)
SELECT * FROM information_schema.role_routine_grants
WHERE routine_name IN ('test_priv_p1', 'test_priv_p2', 'test_priv_p3')
AND grantee = 'test_user'
ORDER BY grantee, routine_name;

-- Test 30: query (line 256)
SHOW GRANTS ON PROCEDURE test_priv_p1, test_priv_p2, test_priv_p3

-- Test 31: statement (line 274)
REVOKE EXECUTE ON ALL FUNCTIONS IN SCHEMA public, test_priv_sc1 FROM test_user;

-- Test 32: query (line 277)
SELECT * FROM information_schema.role_routine_grants
WHERE routine_name IN ('test_priv_p1', 'test_priv_p2', 'test_priv_p3')
AND grantee = 'test_user'
ORDER BY grantee, routine_name;

-- Test 33: statement (line 288)
REVOKE EXECUTE ON ALL PROCEDURES IN SCHEMA public, test_priv_sc1 FROM test_user;

-- Test 34: query (line 291)
SELECT * FROM information_schema.role_routine_grants
WHERE routine_name IN ('test_priv_p1', 'test_priv_p2', 'test_priv_p3')
AND grantee = 'test_user'
ORDER BY grantee, routine_name;

-- Test 35: query (line 299)
SHOW GRANTS ON PROCEDURE test_priv_p1, test_priv_p2, test_priv_p3

-- Test 36: statement (line 314)
CREATE FUNCTION test_priv_f1() RETURNS int LANGUAGE SQL AS $$ SELECT 1 $$;

-- Test 37: statement (line 317)
GRANT EXECUTE ON ALL ROUTINES IN SCHEMA public, test_priv_sc1 TO test_user;

-- Test 38: query (line 320)
SELECT * FROM information_schema.role_routine_grants
WHERE routine_name IN ('test_priv_p1', 'test_priv_p2', 'test_priv_p3', 'test_priv_f1')
AND grantee = 'test_user'
ORDER BY grantee, routine_name;

-- Test 39: statement (line 333)
REVOKE EXECUTE ON ALL ROUTINES IN SCHEMA public, test_priv_sc1 FROM test_user;

-- Test 40: query (line 336)
SELECT * FROM information_schema.role_routine_grants
WHERE routine_name IN ('test_priv_p1', 'test_priv_p2', 'test_priv_p3', 'test_priv_f1')
AND grantee = 'test_user'
ORDER BY grantee, routine_name;

-- Test 41: statement (line 344)
DROP PROCEDURE test_priv_p1;
DROP PROCEDURE test_priv_p2;
DROP PROCEDURE test_priv_sc1.test_priv_p3;
DROP FUNCTION test_priv_f1;
DROP USER test_user;

-- Test 42: statement (line 355)
CREATE USER test_user;
CREATE PROCEDURE test_priv_p1() LANGUAGE SQL AS $$ SELECT 1 $$;

-- Test 43: query (line 359)
SELECT * FROM information_schema.role_routine_grants
WHERE routine_name IN ('test_priv_p1', 'test_priv_p2', 'test_priv_p3')
ORDER BY grantee, routine_name;

-- Test 44: query (line 369)
SHOW GRANTS ON PROCEDURE test_priv_p1

-- Test 45: statement (line 382)
ALTER DEFAULT PRIVILEGES IN SCHEMA public, test_priv_sc1 GRANT EXECUTE ON FUNCTIONS TO test_user WITH GRANT OPTION;

-- Test 46: statement (line 385)
CREATE PROCEDURE test_priv_p2(int) LANGUAGE SQL AS $$ SELECT 1 $$;
CREATE PROCEDURE test_priv_sc1.test_priv_p3() LANGUAGE SQL AS $$ SELECT 1 $$;

-- Test 47: query (line 389)
SELECT * FROM information_schema.role_routine_grants
WHERE routine_name IN ('test_priv_p1', 'test_priv_p2', 'test_priv_p3')
AND grantee = 'test_user'
ORDER BY grantee, routine_name;

-- Test 48: query (line 399)
SHOW GRANTS ON PROCEDURE test_priv_p1, test_priv_p2, test_priv_p3

-- Test 49: statement (line 415)
DROP PROCEDURE test_priv_p2;
DROP PROCEDURE test_priv_sc1.test_priv_p3;

-- Test 50: query (line 419)
SELECT * FROM information_schema.role_routine_grants
WHERE routine_name IN ('test_priv_p1', 'test_priv_p2', 'test_priv_p3')
ORDER BY grantee, routine_name;

-- Test 51: query (line 429)
SHOW GRANTS ON PROCEDURE test_priv_p1

-- Test 52: statement (line 437)
ALTER DEFAULT PRIVILEGES IN SCHEMA public, test_priv_sc1 REVOKE EXECUTE ON FUNCTIONS FROM test_user;

-- Test 53: statement (line 440)
CREATE PROCEDURE test_priv_p2(int) LANGUAGE SQL AS $$ SELECT 1 $$;
CREATE PROCEDURE test_priv_sc1.test_priv_p3() LANGUAGE SQL AS $$ SELECT 1 $$;

-- Test 54: query (line 444)
SELECT * FROM information_schema.role_routine_grants
WHERE routine_name IN ('test_priv_p1', 'test_priv_p2', 'test_priv_p3')
ORDER BY grantee, routine_name;

-- Test 55: query (line 460)
SHOW GRANTS ON PROCEDURE test_priv_p1, test_priv_p2, test_priv_p3

-- Test 56: query (line 475)
SELECT has_function_privilege('test_priv_p2(INT)', 'EXECUTE')

-- Test 57: query (line 480)
SELECT has_function_privilege('test_priv_p2(INT)', 'EXECUTE WITH GRANT OPTION')

-- Test 58: query (line 485)
SELECT has_function_privilege('test_priv_p2(INT)', 'EXECUTE, EXECUTE WITH GRANT OPTION')

-- Test 59: query (line 492)
SELECT has_function_privilege('test_priv_p2(INT)', 'EXECUTE')

-- Test 60: query (line 497)
SELECT has_function_privilege('test_priv_p2(INT)', 'EXECUTE WITH GRANT OPTION')

-- Test 61: query (line 502)
SELECT has_function_privilege('test_priv_p2(INT)', 'EXECUTE, EXECUTE WITH GRANT OPTION')

-- Test 62: statement (line 509)
GRANT EXECUTE ON PROCEDURE test_priv_p1(), test_priv_p2(int), test_priv_sc1.test_priv_p3 TO testuser WITH GRANT OPTION;

user testuser

-- Test 63: query (line 514)
SELECT has_function_privilege('test_priv_p2(INT)', 'EXECUTE')

-- Test 64: query (line 519)
SELECT has_function_privilege('test_priv_p2(INT)', 'EXECUTE WITH GRANT OPTION')

-- Test 65: query (line 524)
SELECT has_function_privilege('test_priv_p2(INT)', 'EXECUTE, EXECUTE WITH GRANT OPTION')

-- Test 66: statement (line 531)
REVOKE GRANT OPTION FOR EXECUTE ON PROCEDURE test_priv_p1(), test_priv_p2(int), test_priv_sc1.test_priv_p3 FROM testuser;

user testuser

-- Test 67: query (line 536)
SELECT has_function_privilege('test_priv_p2(INT)', 'EXECUTE WITH GRANT OPTION')

-- Test 68: query (line 541)
SELECT has_function_privilege('test_priv_p2(INT)', 'EXECUTE')

-- Test 69: query (line 546)
SELECT has_function_privilege('test_priv_p2(INT)', 'EXECUTE, EXECUTE WITH GRANT OPTION')

-- Test 70: statement (line 553)
SET search_path = public;

-- Test 71: statement (line 569)
SHOW GRANTS ON PROCEDURE p_test_show_grants;

-- Test 72: query (line 590)
SELECT * FROM [SHOW GRANTS ON PROCEDURE p_test_show_grants(INT)] ORDER BY grantee

-- Test 73: statement (line 610)
SHOW GRANTS ON PROCEDURE p_not_existing;

-- Test 74: query (line 624)
SELECT * FROM [SHOW GRANTS FOR u_test_show_grants] ORDER BY object_name

-- Test 75: statement (line 639)
SET search_path = public;

-- Test 76: statement (line 646)
CREATE SCHEMA sc_test_priv;

user testuser

-- Test 77: statement (line 651)
CREATE PROCEDURE sc_test_priv.f() LANGUAGE SQL AS $$ SELECT 1 $$;

user root

-- Test 78: statement (line 656)
GRANT CREATE ON SCHEMA sc_test_priv TO testuser

user testuser

-- Test 79: statement (line 661)
CREATE PROCEDURE sc_test_priv.f() LANGUAGE SQL AS $$ SELECT 1 $$;

user root

-- Test 80: statement (line 670)
CREATE USER tester

-- Test 81: statement (line 673)
CREATE SCHEMA test;

-- Test 82: statement (line 676)
GRANT USAGE ON SCHEMA test TO tester;

-- Test 83: statement (line 679)
CREATE PROCEDURE test.p() LANGUAGE SQL AS 'SELECT 1'

-- Test 84: statement (line 682)
SET ROLE tester

-- Test 85: statement (line 686)
CALL test.p()

-- Test 86: statement (line 689)
SET ROLE root

-- Test 87: statement (line 693)
REVOKE EXECUTE ON PROCEDURE test.p FROM public

-- Test 88: statement (line 697)
CALL test.p()

-- Test 89: statement (line 700)
SET ROLE tester

-- Test 90: statement (line 703)
CALL test.p()

-- Test 91: statement (line 706)
SET ROLE root

-- Test 92: statement (line 710)
GRANT EXECUTE ON PROCEDURE test.p TO public

-- Test 93: statement (line 713)
SET ROLE tester

-- Test 94: statement (line 716)
CALL test.p()

