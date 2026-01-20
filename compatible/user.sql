-- PostgreSQL compatible tests from user
-- 58 tests

-- Test 1: query (line 3)
SHOW is_superuser

-- Test 2: query (line 8)
select username, options, member_of from [SHOW USERS]

-- Test 3: statement (line 16)
CREATE USER user1

-- Test 4: query (line 19)
select username, options, member_of from [SHOW USERS]

-- Test 5: query (line 28)
SHOW USERS

-- Test 6: statement (line 33)
CREATE USER admin

-- Test 7: statement (line 36)
CREATE USER IF NOT EXISTS admin

-- Test 8: statement (line 39)
CREATE USER user1

-- Test 9: statement (line 42)
CREATE USER IF NOT EXISTS user1

-- Test 10: statement (line 45)
CREATE USER UsEr1

-- Test 11: statement (line 48)
CREATE USER Ομηρος

-- Test 12: statement (line 51)
CREATE USER node

-- Test 13: statement (line 54)
CREATE USER public

-- Test 14: statement (line 57)
CREATE USER "none"

-- Test 15: statement (line 60)
CREATE USER test WITH PASSWORD ''

-- Test 16: statement (line 63)
CREATE USER uSEr2 WITH PASSWORD 'cockroach'

-- Test 17: statement (line 66)
CREATE USER user3 WITH PASSWORD '蟑螂'

-- Test 18: statement (line 69)
CREATE USER foo☂

-- Test 19: statement (line 72)
CREATE USER "-foo"

-- Test 20: statement (line 75)
CREATE USER foo-bar

-- Test 21: statement (line 78)
CREATE USER "foo-bar"

-- Test 22: statement (line 81)
PREPARE pcu AS CREATE USER foo WITH PASSWORD $1;
  EXECUTE pcu('bar')

-- Test 23: statement (line 85)
ALTER USER foo WITH PASSWORD 'somepass'

-- Test 24: statement (line 88)
PREPARE chpw AS ALTER USER foo WITH PASSWORD $1;
  EXECUTE chpw('bar')

-- Test 25: statement (line 92)
PREPARE chpw2 AS ALTER USER blix WITH PASSWORD $1;
  EXECUTE chpw2('baz')

-- Test 26: query (line 96)
select username, options, member_of from [SHOW USERS]

-- Test 27: statement (line 110)
CREATE USER ""

-- Test 28: query (line 113)
SELECT current_user, current_user(), session_user, session_user(), user

-- Test 29: statement (line 118)
CREATE USER testuser2;
GRANT admin TO testuser2

user testuser2

-- Test 30: query (line 124)
SHOW is_superuser

-- Test 31: query (line 131)
SHOW is_superuser

-- Test 32: statement (line 136)
CREATE USER user4

-- Test 33: statement (line 139)
UPSERT INTO system.users (username, "hashedPassword", "isRole") VALUES (user1, 'newpassword', false)

-- Test 34: statement (line 142)
SHOW USERS

-- Test 35: query (line 145)
SELECT current_user, current_user(), session_user, session_user(), user

-- Test 36: statement (line 150)
SET SESSION AUTHORIZATION DEFAULT

-- Test 37: query (line 153)
SHOW session_user

-- Test 38: statement (line 160)
SET SESSION AUTHORIZATION DEFAULT

-- Test 39: query (line 163)
SHOW session_user

-- Test 40: statement (line 170)
ALTER USER testuser CREATEROLE

user testuser

-- Test 41: statement (line 175)
CREATE ROLE user4 CREATEROLE

-- Test 42: statement (line 178)
CREATE USER user5 NOLOGIN

user root

-- Test 43: query (line 183)
SELECT username, option, value FROM system.role_options

-- Test 44: query (line 194)
SHOW is_superuser

-- Test 45: statement (line 199)
DROP ROLE user4

-- Test 46: statement (line 202)
DROP ROLE user5

-- Test 47: statement (line 209)
SET CLUSTER SETTING server.user_login.min_password_length = 12

-- Test 48: statement (line 212)
CREATE USER baduser WITH PASSWORD 'abc'

-- Test 49: statement (line 215)
ALTER USER testuser WITH PASSWORD 'abc'

-- Test 50: statement (line 218)
CREATE USER userlongpassword WITH PASSWORD '012345678901'

-- Test 51: statement (line 221)
ALTER USER userlongpassword WITH PASSWORD '987654321021'

-- Test 52: statement (line 224)
DROP USER userlongpassword

-- Test 53: statement (line 233)
set cluster setting security.provisioning.ldap.enabled = true;

-- Test 54: statement (line 236)
DROP user testuser

user testuser nodeidx=0 newsession

-- Test 55: statement (line 246)
SHOW session_user

user root

-- Test 56: statement (line 251)
CREATE user IF NOT EXISTS testuser

-- Test 57: query (line 262)
SHOW session_user

-- Test 58: query (line 271)
SELECT count(*) FROM system.users WHERE estimated_last_login_time IS NOT NULL AND username = 'testuser2'

