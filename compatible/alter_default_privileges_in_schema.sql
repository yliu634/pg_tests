-- PostgreSQL compatible tests from alter_default_privileges_in_schema
-- 47 tests

-- Test 1: statement (line 3)
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT USAGE ON SCHEMAS TO root

-- Test 2: statement (line 6)
ALTER DEFAULT PRIVILEGES IN SCHEMA crdb_internal GRANT SELECT ON TABLES TO root

-- Test 3: statement (line 9)
CREATE USER testuser2

-- Test 4: statement (line 12)
GRANT CREATE ON DATABASE test TO testuser

user testuser

-- Test 5: statement (line 18)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser IN SCHEMA public GRANT SELECT ON TABLES TO testuser2

-- Test 6: statement (line 21)
CREATE TABLE t1()

-- Test 7: query (line 24)
SHOW GRANTS ON t1

-- Test 8: statement (line 36)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser GRANT INSERT ON TABLES TO testuser2

-- Test 9: statement (line 39)
CREATE TABLE t2()

-- Test 10: query (line 42)
SHOW GRANTS ON t2

-- Test 11: statement (line 52)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser GRANT ALL ON TABLES TO testuser2

-- Test 12: statement (line 55)
CREATE TABLE t3()

-- Test 13: query (line 58)
SHOW GRANTS ON t3

-- Test 14: statement (line 68)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser REVOKE ALL ON TABLES FROM testuser2

-- Test 15: statement (line 71)
CREATE TABLE t4()

-- Test 16: query (line 74)
SHOW GRANTS ON t4

-- Test 17: statement (line 84)
CREATE SCHEMA s

-- Test 18: statement (line 87)
GRANT CREATE, USAGE ON SCHEMA s TO testuser

-- Test 19: statement (line 90)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser IN SCHEMA s, public GRANT ALL ON TABLES TO testuser2

-- Test 20: statement (line 93)
CREATE TABLE public.t5();
CREATE TABLE s.t6();

-- Test 21: query (line 97)
SHOW GRANTS ON public.t5

-- Test 22: query (line 106)
SHOW GRANTS ON s.t6

-- Test 23: statement (line 118)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser IN SCHEMA s, public REVOKE ALL ON TABLES FROM testuser2;
ALTER DEFAULT PRIVILEGES FOR ALL ROLES IN SCHEMA s, public GRANT SELECT ON TABLES TO testuser2;

user testuser

-- Test 24: statement (line 124)
CREATE TABLE public.t7();
CREATE TABLE s.t8();

-- Test 25: query (line 128)
SHOW GRANTS ON public.t7

-- Test 26: query (line 137)
SHOW GRANTS ON s.t8

-- Test 27: statement (line 151)
CREATE TABLE public.t9();
CREATE TABLE s.t10();

-- Test 28: query (line 155)
SHOW GRANTS ON public.t9

-- Test 29: query (line 163)
SHOW GRANTS ON s.t10

-- Test 30: statement (line 173)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser REVOKE ALL ON TABLES FROM testuser;

-- Test 31: statement (line 176)
CREATE TABLE t11()

-- Test 32: query (line 181)
SHOW GRANTS ON t11

-- Test 33: statement (line 192)
CREATE SCHEMA s2

-- Test 34: statement (line 195)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser REVOKE ALL ON TABLES FROM testuser;
ALTER DEFAULT PRIVILEGES FOR ROLE testuser REVOKE ALL ON TABLES FROM testuser2

-- Test 35: statement (line 199)
CREATE TABLE s2.t12()

-- Test 36: query (line 204)
SHOW GRANTS ON s2.t12

-- Test 37: query (line 212)
SELECT * FROM crdb_internal.default_privileges WHERE schema_name IS NOT NULL

-- Test 38: query (line 219)
SHOW DEFAULT PRIVILEGES IN SCHEMA public

-- Test 39: query (line 224)
SHOW DEFAULT PRIVILEGES IN SCHEMA s

-- Test 40: query (line 229)
SHOW DEFAULT PRIVILEGES IN SCHEMA s2

-- Test 41: statement (line 234)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser IN SCHEMA public GRANT ALL ON TABLES TO testuser;
ALTER DEFAULT PRIVILEGES FOR ROLE testuser IN SCHEMA s GRANT USAGE ON TYPES TO testuser2;
ALTER DEFAULT PRIVILEGES FOR ROLE testuser IN SCHEMA s2 GRANT SELECT, UPDATE, DROP ON TABLES TO testuser2

-- Test 42: query (line 239)
SELECT * FROM crdb_internal.default_privileges WHERE schema_name IS NOT NULL

-- Test 43: query (line 252)
SHOW DEFAULT PRIVILEGES IN SCHEMA public

-- Test 44: query (line 258)
SHOW DEFAULT PRIVILEGES IN SCHEMA s

-- Test 45: query (line 264)
SHOW DEFAULT PRIVILEGES IN SCHEMA s2

-- Test 46: query (line 274)
SHOW DEFAULT PRIVILEGES FOR ROLE testuser IN SCHEMA s2

-- Test 47: query (line 282)
SHOW DEFAULT PRIVILEGES IN SCHEMA "'; drop database test; SELECT '";

