-- PostgreSQL compatible tests from drop_user
-- 69 tests

-- Test 1: statement (line 1)
CREATE USER user1

-- Test 2: query (line 4)
select username, options, member_of from [SHOW USERS]

-- Test 3: statement (line 13)
DROP USER user1

-- Test 4: query (line 16)
select username, options, member_of from [SHOW USERS]

-- Test 5: statement (line 24)
CREATE USER user1

-- Test 6: query (line 27)
select username, options, member_of from [SHOW USERS]

-- Test 7: statement (line 36)
DROP USER USEr1

-- Test 8: query (line 39)
select username, options, member_of from [SHOW USERS]

-- Test 9: statement (line 47)
DROP USER user1

-- Test 10: statement (line 50)
DROP USER usER1

-- Test 11: statement (line 53)
DROP USER IF EXISTS user1

-- Test 12: statement (line 56)
DROP USER node

-- Test 13: statement (line 59)
DROP USER public

-- Test 14: statement (line 62)
DROP USER "none"

-- Test 15: statement (line 65)
DROP ROLE CURRENT_USER

-- Test 16: statement (line 68)
DROP ROLE user4, SESSION_USER

-- Test 17: statement (line 71)
DROP USER foo☂

-- Test 18: statement (line 74)
CREATE USER user1

-- Test 19: statement (line 77)
CREATE USER user2

-- Test 20: statement (line 80)
CREATE USER user3

-- Test 21: statement (line 83)
CREATE USER user4

-- Test 22: query (line 86)
select username, options, member_of from [SHOW USERS]

-- Test 23: statement (line 98)
DROP USER user1,user2

-- Test 24: query (line 101)
select username, options, member_of from [SHOW USERS]

-- Test 25: statement (line 111)
DROP USER user1,user3

-- Test 26: query (line 114)
select username, options, member_of from [SHOW USERS]

-- Test 27: statement (line 124)
CREATE USER user1

-- Test 28: statement (line 127)
CREATE TABLE foo(x INT);
GRANT SELECT ON foo TO user3;
GRANT CONNECT ON DATABASE test TO user1

-- Test 29: statement (line 132)
DROP USER IF EXISTS user1,user3

-- Test 30: statement (line 135)
REVOKE SELECT ON foo FROM user3;

-- Test 31: statement (line 138)
DROP USER IF EXISTS user1,user3

-- Test 32: statement (line 141)
REVOKE CONNECT ON DATABASE test FROM user1;

-- Test 33: statement (line 144)
DROP USER IF EXISTS user1,user3

-- Test 34: statement (line 147)
PREPARE du AS DROP USER user4;
EXECUTE du

-- Test 35: query (line 151)
select username, options, member_of from [SHOW USERS]

-- Test 36: statement (line 161)
DROP USER user2

user root

-- Test 37: statement (line 166)
DROP USER root

-- Test 38: statement (line 169)
DROP USER admin

-- Test 39: statement (line 172)
CREATE USER user1

-- Test 40: statement (line 175)
INSERT INTO system.scheduled_jobs (schedule_name, owner, executor_type,execution_args) values('schedule', 'user1', 'invalid', '');

-- Test 41: statement (line 178)
DROP USER user1

-- Test 42: statement (line 184)
CREATE ROLE schema_owner

-- Test 43: statement (line 187)
GRANT admin TO schema_owner

-- Test 44: statement (line 190)
SET ROLE schema_owner

-- Test 45: statement (line 193)
CREATE SCHEMA the_schema

-- Test 46: statement (line 196)
USE defaultdb

-- Test 47: statement (line 199)
CREATE SCHEMA the_schema

-- Test 48: statement (line 202)
RESET ROLE;
RESET DATABASE

-- Test 49: statement (line 206)
DROP ROLE schema_owner

-- Test 50: statement (line 215)
CREATE USER default_priv_user

-- Test 51: statement (line 220)
ALTER DEFAULT PRIVILEGES FOR ROLE default_priv_user REVOKE EXECUTE ON ROUTINES FROM public

-- Test 52: statement (line 223)
ALTER DEFAULT PRIVILEGES FOR ROLE default_priv_user REVOKE USAGE ON TYPES FROM public

-- Test 53: statement (line 228)
ALTER DEFAULT PRIVILEGES FOR ROLE default_priv_user REVOKE USAGE ON SEQUENCES FROM public

-- Test 54: statement (line 231)
ALTER DEFAULT PRIVILEGES FOR ROLE default_priv_user REVOKE ALL ON TABLES FROM public

-- Test 55: statement (line 234)
ALTER DEFAULT PRIVILEGES FOR ROLE default_priv_user REVOKE ALL ON SCHEMAS FROM public

-- Test 56: statement (line 237)
DROP USER default_priv_user

-- Test 57: statement (line 241)
CREATE USER default_priv_user2

-- Test 58: statement (line 244)
ALTER DEFAULT PRIVILEGES FOR ROLE default_priv_user2 GRANT ALL ON TABLES TO public

-- Test 59: statement (line 247)
ALTER DEFAULT PRIVILEGES FOR ROLE default_priv_user2 GRANT ALL ON SCHEMAS TO public

-- Test 60: statement (line 250)
ALTER DEFAULT PRIVILEGES FOR ROLE default_priv_user2 GRANT USAGE ON SEQUENCES TO public

-- Test 61: statement (line 253)
DROP USER default_priv_user2

-- Test 62: statement (line 257)
ALTER DEFAULT PRIVILEGES FOR ROLE default_priv_user GRANT EXECUTE ON FUNCTIONS TO public

-- Test 63: statement (line 260)
ALTER DEFAULT PRIVILEGES FOR ROLE default_priv_user GRANT USAGE ON TYPES TO public

-- Test 64: statement (line 263)
ALTER DEFAULT PRIVILEGES FOR ROLE default_priv_user2 REVOKE ALL ON TABLES FROM public

-- Test 65: statement (line 266)
ALTER DEFAULT PRIVILEGES FOR ROLE default_priv_user2 REVOKE ALL ON SCHEMAS FROM public

-- Test 66: statement (line 269)
ALTER DEFAULT PRIVILEGES FOR ROLE default_priv_user2 REVOKE USAGE ON SEQUENCES FROM public

-- Test 67: statement (line 272)
DROP USER default_priv_user

-- Test 68: statement (line 275)
DROP USER default_priv_user2

-- Test 69: query (line 280)
SELECT database_name, schema_name, obj_name, error FROM crdb_internal.invalid_objects;

