-- PostgreSQL compatible tests from alter_role_set
-- 76 tests

-- Test 1: statement (line 1)
CREATE ROLE test_set_role;
CREATE DATABASE test_set_db

-- Test 2: query (line 5)
SELECT database_id, role_name, settings FROM system.database_role_settings

-- Test 3: statement (line 9)
ALTER ROLE test_set_role SET application_name = 'a';
ALTER ROLE test_set_role IN DATABASE test_set_db SET application_name = 'b';
ALTER ROLE ALL IN DATABASE test_set_db SET application_name = 'c';
ALTER ROLE ALL SET application_name = 'd';
ALTER ROLE test_set_role SET custom_option.setting = 'e'

-- Test 4: query (line 17)
SELECT database_id, role_name, settings FROM system.database_role_settings ORDER BY 1, 2

-- Test 5: query (line 27)
SELECT setdatabase, setrole, d.datname, r.rolname, setconfig
FROM pg_catalog.pg_db_role_setting
LEFT JOIN pg_catalog.pg_database d ON setdatabase = d.oid
LEFT JOIN pg_catalog.pg_roles r ON setrole = r.oid
ORDER BY 1, 2

-- Test 6: statement (line 40)
ALTER ROLE test_set_role SET backslash_quote = 'safe_encoding'

-- Test 7: query (line 44)
SELECT settings FROM system.database_role_settings
WHERE database_id = 0 AND role_name = 'test_set_role'

-- Test 8: statement (line 50)
ALTER ROLE test_set_role SET application_name = 'f'

-- Test 9: query (line 54)
SELECT settings FROM system.database_role_settings
WHERE database_id = 0 AND role_name = 'test_set_role'

-- Test 10: statement (line 60)
ALTER ROLE test_set_role SET serial_normalization = 'sql_sequence';
ALTER ROLE test_set_role RESET application_name

-- Test 11: query (line 65)
SELECT settings FROM system.database_role_settings
WHERE database_id = 0 AND role_name = 'test_set_role'

-- Test 12: statement (line 72)
ALTER ROLE test_set_role RESET application_name

-- Test 13: statement (line 76)
ALTER ROLE fake_role SET application_name = 'e';

-- Test 14: statement (line 80)
ALTER ROLE IF EXISTS fake_role SET application_name = 'e';

-- Test 15: statement (line 84)
ALTER ROLE IF EXISTS fake_role IN DATABASE fake_database SET application_name = 'e';

-- Test 16: statement (line 88)
ALTER ROLE test_set_role SET potato = 'potato'

-- Test 17: statement (line 92)
ALTER ROLE test_set_role RESET potato;
ALTER ROLE test_set_role SET potato TO DEFAULT;

-- Test 18: statement (line 97)
ALTER ROLE test_set_role SET serial_normalization = 'potato'

-- Test 19: statement (line 101)
ALTER ROLE test_set_role SET backslash_quote = 'off'

-- Test 20: statement (line 105)
ALTER ROLE test_set_role SET integer_datetimes = 'on'

-- Test 21: statement (line 110)
ALTER ROLE test_set_role SET transaction_isolation = 'serializable'

-- Test 22: statement (line 114)
ALTER ROLE test_set_role SET database = 'd'

-- Test 23: statement (line 117)
ALTER ROLE test_set_role SET role = 'd'

-- Test 24: statement (line 121)
ALTER ROLE test_set_role SET "" = 'foo'

-- Test 25: query (line 124)
SELECT current_user()

-- Test 26: statement (line 130)
ALTER ROLE admin SET application_name = 'g'

-- Test 27: statement (line 134)
ALTER ROLE root SET application_name = 'g'

-- Test 28: statement (line 138)
ALTER ROLE public SET application_name = 'g'

-- Test 29: statement (line 142)
ALTER ROLE "" SET application_name = 'g'

-- Test 30: statement (line 146)
CREATE ROLE other_admin;
GRANT admin TO other_admin;
ALTER ROLE other_admin SET application_name = 'g';
ALTER ROLE other_admin RESET application_name

user testuser

-- Test 31: statement (line 155)
ALTER ROLE testuser RESET application_name

-- Test 32: statement (line 161)
GRANT SYSTEM MODIFYCLUSTERSETTING TO testuser

user testuser

-- Test 33: statement (line 166)
ALTER ROLE testuser RESET application_name

user root

-- Test 34: statement (line 171)
REVOKE SYSTEM MODIFYCLUSTERSETTING FROM testuser

-- Test 35: statement (line 175)
GRANT SYSTEM MODIFYSQLCLUSTERSETTING TO testuser

user testuser

-- Test 36: statement (line 180)
ALTER ROLE testuser RESET application_name

user root

-- Test 37: statement (line 185)
REVOKE SYSTEM MODIFYSQLCLUSTERSETTING FROM testuser

-- Test 38: statement (line 190)
ALTER ROLE testuser with MODIFYCLUSTERSETTING

user testuser

-- Test 39: statement (line 195)
ALTER ROLE testuser RESET application_name

user root

-- Test 40: statement (line 200)
ALTER ROLE testuser WITH NOMODIFYCLUSTERSETTING

-- Test 41: statement (line 203)
ALTER ROLE testuser WITH CREATEROLE

user testuser

-- Test 42: statement (line 209)
ALTER ROLE testuser RESET application_name

-- Test 43: statement (line 213)
ALTER ROLE test_set_role RESET application_name

-- Test 44: statement (line 217)
ALTER ROLE ALL IN DATABASE test_set_db RESET application_name

-- Test 45: statement (line 221)
ALTER ROLE other_admin SET application_name = 'abc'

user root

-- Test 46: statement (line 226)
ALTER ROLE ALL RESET ALL

-- Test 47: query (line 230)
SELECT database_id, role_name, settings FROM system.database_role_settings ORDER BY 1, 2

-- Test 48: statement (line 238)
DROP DATABASE test_set_db

-- Test 49: query (line 242)
SELECT database_id, role_name, settings FROM system.database_role_settings ORDER BY 1, 2

-- Test 50: statement (line 248)
DROP ROLE test_set_role

-- Test 51: query (line 252)
SELECT database_id, role_name, settings FROM system.database_role_settings ORDER BY 1, 2

-- Test 52: statement (line 303)
SHOW DEFAULT SESSION VARIABLES FOR ROLE roach

-- Test 53: statement (line 309)
ALTER USER testuser MODIFYCLUSTERSETTING

-- Test 54: statement (line 312)
GRANT admin TO testuser

user testuser

-- Test 55: statement (line 317)
ALTER ROLE ALL SET application_name = 'c'

-- Test 56: query (line 320)
SELECT * FROM [SHOW DEFAULT SESSION VARIABLES FOR ROLE roach] ORDER BY 1, 2

-- Test 57: statement (line 329)
CREATE DATABASE test_db

-- Test 58: statement (line 332)
ALTER ROLE ALL IN DATABASE test_db SET application_name = 'd'

-- Test 59: query (line 335)
SELECT * FROM [SHOW DEFAULT SESSION VARIABLES FOR ROLE ALL] ORDER BY 1, 2

-- Test 60: query (line 342)
SELECT * FROM [SHOW DEFAULT SESSION VARIABLES FOR ROLE roach] ORDER BY 1, 2

-- Test 61: statement (line 351)
ALTER ROLE roach SET application_name = 'e'

-- Test 62: query (line 354)
SELECT * FROM [SHOW DEFAULT SESSION VARIABLES FOR ROLE roach] ORDER BY 1, 2

-- Test 63: statement (line 362)
ALTER ROLE roach IN DATABASE test_db SET application_name = 'f'

-- Test 64: query (line 365)
SELECT * FROM [SHOW DEFAULT SESSION VARIABLES FOR ROLE roach] ORDER BY 1, 2

-- Test 65: statement (line 375)
SELECT * FROM [SHOW DEFAULT SESSION VARIABLES FOR ROLE]

-- Test 66: statement (line 378)
CREATE USER testuser2

-- Test 67: statement (line 382)
ALTER DATABASE test_db OWNER TO testuser2

user testuser2

-- Test 68: statement (line 388)
ALTER ROLE ALL IN DATABASE test_db SET application_name = 'abc'

user root

-- Test 69: query (line 393)
SELECT * FROM [SHOW DEFAULT SESSION VARIABLES FOR ROLE ALL] WHERE database='test_db' ORDER BY 1, 2

-- Test 70: statement (line 401)
ALTER ROLE ALL IN DATABASE test_db RESET application_name

user root

-- Test 71: query (line 406)
SELECT * FROM [SHOW DEFAULT SESSION VARIABLES FOR ROLE ALL] WHERE database='test_db' ORDER BY 1, 2

-- Test 72: statement (line 411)
CREATE DATABASE test_db2

user testuser2

-- Test 73: statement (line 417)
ALTER ROLE ALL IN DATABASE test_db2 SET application_name = 'abc'

user root

-- Test 74: statement (line 422)
DROP DATABASE test_db2

user testuser2

-- Test 75: statement (line 428)
ALTER ROLE roach IN DATABASE test_db SET application_name = 'abc'

-- Test 76: statement (line 432)
ALTER ROLE ALL SET application_name = 'abc'

