-- PostgreSQL compatible tests from set_role
-- 88 tests

-- Test 1: statement (line 2)
CREATE TABLE priv_t (pk INT PRIMARY KEY);
CREATE TABLE no_priv_t (pk INT PRIMARY KEY);
GRANT SELECT ON priv_t TO testuser

-- Test 2: statement (line 7)
CREATE SCHEMA root;
CREATE TABLE root.root_table ();
CREATE SCHEMA testuser;
GRANT ALL ON SCHEMA testuser TO testuser;
CREATE TABLE testuser.testuser_table ();
GRANT ALL ON TABLE testuser.testuser_table TO testuser

-- Test 3: statement (line 16)
CREATE ROLE public

-- Test 4: statement (line 19)
SET ROLE public

-- Test 5: statement (line 22)
CREATE ROLE node

-- Test 6: statement (line 25)
SET ROLE node

-- Test 7: query (line 29)
SELECT current_user(), current_user, session_user(), session_user

-- Test 8: query (line 34)
SHOW ROLE

-- Test 9: statement (line 39)
RESET ROLE

-- Test 10: statement (line 42)
SET ROLE non_existent_user

-- Test 11: query (line 45)
SELECT current_user(), current_user, session_user(), session_user

-- Test 12: query (line 50)
SHOW ROLE

-- Test 13: statement (line 55)
SET ROLE = root

-- Test 14: query (line 58)
SELECT current_user(), current_user, session_user(), session_user

-- Test 15: query (line 63)
SHOW ROLE

-- Test 16: statement (line 68)
SELECT * FROM root_table

-- Test 17: statement (line 71)
SELECT * FROM testuser_table

-- Test 18: statement (line 74)
SET ROLE = 'testuser'

-- Test 19: query (line 77)
SELECT current_user(), current_user, session_user(), session_user

-- Test 20: query (line 82)
SHOW is_superuser

-- Test 21: statement (line 87)
SELECT * FROM priv_t

-- Test 22: statement (line 90)
SELECT * FROM no_priv_t

-- Test 23: statement (line 93)
SELECT * FROM root_table

-- Test 24: statement (line 96)
SELECT * FROM testuser_table

-- Test 25: statement (line 99)
RESET ROLE

-- Test 26: statement (line 102)
SELECT * FROM root_table

-- Test 27: statement (line 105)
SELECT * FROM testuser_table

-- Test 28: statement (line 109)
CREATE USER testuser2

-- Test 29: statement (line 112)
SET ROLE testuser2

-- Test 30: query (line 115)
SELECT current_user(), current_user, session_user(), session_user

-- Test 31: query (line 120)
SHOW is_superuser

-- Test 32: statement (line 125)
SET ROLE = 'NoNe'

-- Test 33: query (line 128)
SELECT current_user(), current_user, session_user(), session_user

-- Test 34: query (line 133)
SHOW is_superuser

-- Test 35: statement (line 140)
RESET ALL

-- Test 36: query (line 143)
SHOW is_superuser

-- Test 37: query (line 151)
SELECT current_user(), current_user, session_user(), session_user

-- Test 38: query (line 156)
SHOW ROLE

-- Test 39: statement (line 161)
SET ROLE testuser

-- Test 40: query (line 164)
SELECT current_user(), current_user, session_user(), session_user

-- Test 41: query (line 169)
SHOW ROLE

-- Test 42: statement (line 174)
SET ROLE root

-- Test 43: statement (line 177)
SET ROLE testuser2

-- Test 44: statement (line 184)
GRANT admin TO testuser

-- Test 45: statement (line 191)
SET ROLE root

-- Test 46: statement (line 194)
SET ROLE testuser2

-- Test 47: query (line 197)
SELECT current_user(), current_user, session_user(), session_user

-- Test 48: query (line 202)
SHOW is_superuser

-- Test 49: statement (line 207)
SELECT * FROM priv_t

-- Test 50: statement (line 210)
SELECT * FROM no_priv_t

-- Test 51: statement (line 213)
RESET ROLE

-- Test 52: query (line 216)
SELECT current_user(), current_user, session_user(), session_user

-- Test 53: query (line 221)
SHOW is_superuser

-- Test 54: statement (line 230)
SET ROLE root

-- Test 55: statement (line 233)
SET ROLE testuser

-- Test 56: statement (line 236)
SET ROLE testuser2

-- Test 57: query (line 239)
SELECT current_user(), current_user, session_user(), session_user

-- Test 58: statement (line 244)
RESET ROLE

-- Test 59: query (line 247)
SELECT current_user(), current_user, session_user(), session_user

-- Test 60: statement (line 255)
GRANT admin TO testuser2

user testuser2

-- Test 61: statement (line 260)
SET ROLE testuser

-- Test 62: query (line 263)
SELECT current_user(), current_user, session_user(), session_user

-- Test 63: statement (line 268)
RESET ROLE

-- Test 64: statement (line 277)
CREATE ROLE testrole;
REVOKE admin FROM testuser2;
GRANT testuser TO testuser2

-- Test 65: statement (line 282)
RESET ROLE

user testuser2

-- Test 66: statement (line 287)
SET ROLE testuser

-- Test 67: query (line 290)
SELECT current_user(), current_user, session_user(), session_user

-- Test 68: statement (line 295)
SET ROLE testrole

-- Test 69: query (line 298)
SELECT current_user(), current_user, session_user(), session_user

-- Test 70: statement (line 303)
RESET ROLE

-- Test 71: statement (line 311)
SET ROLE testuser2

user root

-- Test 72: statement (line 316)
REVOKE admin FROM testuser

user testuser

-- Test 73: query (line 321)
SELECT current_user(), current_user, session_user(), session_user

-- Test 74: statement (line 326)
SET ROLE testuser2

-- Test 75: statement (line 329)
SET ROLE 'none'

-- Test 76: query (line 332)
SELECT current_user(), current_user, session_user(), session_user

-- Test 77: statement (line 344)
GRANT ADMIN TO testuser;

-- Test 78: statement (line 347)
BEGIN;
SET LOCAL ROLE testuser

-- Test 79: query (line 351)
SELECT current_user(), current_user, session_user(), session_user

-- Test 80: query (line 356)
SELECT user_name FROM crdb_internal.node_sessions
WHERE active_queries LIKE 'SELECT user_name%'

-- Test 81: statement (line 362)
ROLLBACK

-- Test 82: query (line 365)
SELECT current_user(), current_user, session_user(), session_user

-- Test 83: statement (line 370)
SET ROLE testuser

-- Test 84: statement (line 374)
RESET ALL

-- Test 85: query (line 377)
SELECT current_user(), current_user, session_user(), session_user

-- Test 86: query (line 382)
SELECT user_name FROM crdb_internal.node_sessions
WHERE active_queries LIKE 'SELECT user_name%'

-- Test 87: statement (line 389)
SET SESSION AUTHORIZATION DEFAULT

-- Test 88: query (line 392)
SELECT current_user(), current_user, session_user(), session_user

