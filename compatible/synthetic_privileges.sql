-- PostgreSQL compatible tests from synthetic_privileges
-- 88 tests

-- Test 1: statement (line 6)
SELECT * FROM crdb_internal.cluster_settings;

-- Test 2: statement (line 9)
CREATE EXTERNAL CONNECTION foo AS 'nodelocal://1/foo';

user root

-- Test 3: statement (line 14)
CREATE USER testuser2

-- Test 4: statement (line 17)
GRANT SYSTEM MODIFYCLUSTERSETTING TO testuser

-- Test 5: statement (line 20)
GRANT SYSTEM EXTERNALCONNECTION TO testuser

user testuser

-- Test 6: statement (line 25)
SELECT * FROM crdb_internal.cluster_settings;

-- Test 7: statement (line 29)
GRANT SYSTEM MODIFYCLUSTERSETTING TO testuser2

-- Test 8: statement (line 32)
CREATE EXTERNAL CONNECTION foo AS 'nodelocal://1/foo';

-- Test 9: statement (line 36)
GRANT SYSTEM EXTERNALCONNECTION TO testuser2

user root

-- Test 10: query (line 41)
SELECT username, path, privileges, grant_options FROM system.privileges ORDER BY 1, 2

-- Test 11: query (line 47)
SELECT connection_name, connection_type FROM system.external_connections

-- Test 12: statement (line 52)
REVOKE SYSTEM MODIFYCLUSTERSETTING FROM testuser

-- Test 13: statement (line 55)
REVOKE SYSTEM EXTERNALCONNECTION FROM testuser

-- Test 14: statement (line 60)
REVOKE ALL ON EXTERNAL CONNECTION foo FROM testuser

user testuser

-- Test 15: statement (line 65)
SELECT * FROM crdb_internal.cluster_settings;

-- Test 16: statement (line 68)
CREATE EXTERNAL CONNECTION foo AS 'nodelocal://1/foo';

user root

-- Test 17: query (line 73)
SELECT username, path, privileges, grant_options FROM system.privileges ORDER BY 1, 2

-- Test 18: statement (line 79)
GRANT SYSTEM MODIFYCLUSTERSETTING TO testuser

-- Test 19: statement (line 82)
GRANT SYSTEM MODIFYCLUSTERSETTING TO testuser WITH GRANT OPTION

user testuser

-- Test 20: statement (line 87)
GRANT SYSTEM MODIFYCLUSTERSETTING TO root

user root

-- Test 21: query (line 92)
SELECT username, path, privileges, grant_options FROM system.privileges ORDER BY 1, 2

-- Test 22: statement (line 98)
REVOKE GRANT OPTION FOR SYSTEM MODIFYCLUSTERSETTING FROM testuser

-- Test 23: query (line 101)
SELECT username, path, privileges, grant_options FROM system.privileges ORDER BY 1, 2

-- Test 24: statement (line 107)
REVOKE SYSTEM MODIFYCLUSTERSETTING FROM testuser

-- Test 25: query (line 110)
SELECT username, path, privileges, grant_options  FROM system.privileges ORDER BY 1, 2

-- Test 26: statement (line 115)
GRANT SYSTEM MODIFYCLUSTERSETTING TO testuser WITH GRANT OPTION

-- Test 27: query (line 118)
SELECT username, path, privileges, grant_options  FROM system.privileges ORDER BY 1, 2

-- Test 28: statement (line 124)
REVOKE SYSTEM MODIFYCLUSTERSETTING FROM testuser

-- Test 29: query (line 127)
SELECT username, path, privileges, grant_options  FROM system.privileges ORDER BY 1, 2

-- Test 30: statement (line 135)
SELECT * FROM crdb_internal.cluster_settings;

user root

-- Test 31: statement (line 140)
GRANT SYSTEM VIEWCLUSTERSETTING TO testuser

user testuser

-- Test 32: statement (line 145)
SELECT * FROM crdb_internal.cluster_settings;

user root

-- Test 33: query (line 150)
SELECT username, path, privileges, grant_options FROM system.privileges ORDER BY 1, 2

-- Test 34: statement (line 156)
REVOKE SYSTEM VIEWCLUSTERSETTING FROM testuser

user testuser

-- Test 35: statement (line 161)
SELECT * FROM crdb_internal.cluster_settings;

user root

-- Test 36: query (line 166)
SELECT username, path, privileges, grant_options FROM system.privileges

-- Test 37: statement (line 174)
SELECT * FROM crdb_internal.node_statement_statistics;

user root

-- Test 38: statement (line 179)
GRANT SYSTEM VIEWACTIVITY TO testuser

user testuser

-- Test 39: statement (line 184)
SELECT * FROM crdb_internal.node_statement_statistics;

user root

-- Test 40: query (line 189)
SELECT username, path, privileges, grant_options FROM system.privileges ORDER BY 1, 2

-- Test 41: statement (line 195)
REVOKE SYSTEM VIEWACTIVITY FROM testuser

user testuser

-- Test 42: statement (line 200)
SELECT * FROM crdb_internal.node_statement_statistics;

user root

-- Test 43: query (line 205)
SELECT username, path, privileges, grant_options FROM system.privileges

-- Test 44: statement (line 213)
SELECT * FROM crdb_internal.node_statement_statistics;

user root

-- Test 45: statement (line 218)
GRANT SYSTEM VIEWACTIVITYREDACTED TO testuser

user testuser

-- Test 46: statement (line 223)
SELECT * FROM crdb_internal.node_statement_statistics;

user root

-- Test 47: query (line 228)
SELECT username, path, privileges, grant_options FROM system.privileges ORDER BY 1, 2

-- Test 48: statement (line 234)
REVOKE SYSTEM VIEWACTIVITYREDACTED FROM testuser

user testuser

-- Test 49: statement (line 239)
SELECT * FROM crdb_internal.node_statement_statistics;

user root

-- Test 50: query (line 244)
SELECT username, path, privileges, grant_options FROM system.privileges

-- Test 51: statement (line 249)
DROP USER testuser

-- Test 52: statement (line 252)
CREATE USER testuser

-- Test 53: statement (line 255)
GRANT SYSTEM MODIFYCLUSTERSETTING TO testuser

-- Test 54: statement (line 258)
GRANT SELECT ON crdb_internal.tables TO testuser

-- Test 55: statement (line 261)
GRANT USAGE ON EXTERNAL CONNECTION foo TO testuser

-- Test 56: statement (line 264)
DROP USER testuser

-- Test 57: statement (line 267)
GRANT SYSTEM MODIFYCLUSTERSETTING TO testuser2

-- Test 58: statement (line 270)
GRANT USAGE ON EXTERNAL CONNECTION foo TO testuser2

-- Test 59: statement (line 273)
DROP USER testuser, testuser2

-- Test 60: statement (line 277)
CREATE USER testuser3

-- Test 61: statement (line 280)
GRANT SYSTEM MODIFYCLUSTERSETTING, EXTERNALCONNECTION TO testuser3

-- Test 62: statement (line 283)
ALTER DEFAULT PRIVILEGES GRANT SELECT ON TABLES TO testuser3

-- Test 63: statement (line 286)
DROP USER testuser3

-- Test 64: statement (line 290)
CREATE USER testuser4

-- Test 65: statement (line 293)
REVOKE SELECT ON crdb_internal.feature_usage FROM public

-- Test 66: query (line 296)
SELECT has_table_privilege('testuser4', 'crdb_internal.feature_usage', 'SELECT')

-- Test 67: statement (line 302)
BEGIN TRANSACTION PRIORITY HIGH ISOLATION LEVEL SERIALIZABLE;

-- Test 68: statement (line 305)
SET LOCAL autocommit_before_ddl=off;

-- Test 69: statement (line 308)
GRANT SELECT ON crdb_internal.feature_usage TO testuser4

-- Test 70: query (line 312)
SELECT has_table_privilege('testuser4', 'crdb_internal.feature_usage', 'SELECT')

-- Test 71: statement (line 317)
ROLLBACK

-- Test 72: query (line 320)
SELECT has_table_privilege('testuser4', 'crdb_internal.feature_usage', 'SELECT')

-- Test 73: statement (line 326)
REVOKE SYSTEM MODIFYCLUSTERSETTING FROM testuser

-- Test 74: statement (line 336)
GRANT SYSTEM CREATEDB TO testuser

-- Test 75: statement (line 339)
INSERT INTO system.users VALUES ('node', NULL, true, 0);

-- Test 76: statement (line 342)
GRANT node TO root;

-- Test 77: statement (line 345)
UPDATE system.privileges SET privileges = '{FAKE_PRIVILEGE}'
WHERE username = 'testuser' AND path = '/global/'

-- Test 78: query (line 349)
SELECT username, path, privileges, grant_options FROM system.privileges
WHERE username = 'testuser' AND path = '/global/'

-- Test 79: statement (line 358)
SET CLUSTER SETTING sql.defaults.default_int_size = 8

user root

-- Test 80: statement (line 363)
REVOKE SYSTEM ALL FROM testuser;
REVOKE node FROM root;
DELETE FROM system.users WHERE username = 'node';

-- Test 81: statement (line 374)
GRANT SYSTEM ALL TO testuser

-- Test 82: statement (line 377)
CANCEL SESSION (SELECT session_id FROM [SHOW SESSIONS] WHERE user_name = 'testuser')

-- Test 83: statement (line 383)
SELECT 1

user root

-- Test 84: statement (line 388)
REVOKE SYSTEM ALL FROM testuser

-- Test 85: statement (line 398)
SELECT * FROM system.users WHERE username = 'testuser'

user root

-- Test 86: statement (line 403)
GRANT SYSTEM VIEWSYSTEMTABLE TO testuser

user testuser

-- Test 87: query (line 408)
SELECT username, "hashedPassword" FROM system.users WHERE username = 'testuser'

-- Test 88: statement (line 414)
INSERT INTO system.users (username, "hashedPassword", "isRole", user_id) VALUES ('cat', null, true, 200)

