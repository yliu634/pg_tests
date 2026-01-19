-- PostgreSQL compatible tests from crdb_internal_default_privileges
-- 42 tests

-- Test 1: statement (line 1)
ALTER DEFAULT PRIVILEGES GRANT SELECT ON TABLES TO PUBLIC;
ALTER DEFAULT PRIVILEGES GRANT USAGE ON TYPES TO PUBLIC;
ALTER DEFAULT PRIVILEGES GRANT USAGE ON SCHEMAS TO PUBLIC;
ALTER DEFAULT PRIVILEGES GRANT SELECT ON SEQUENCES TO PUBLIC;

-- Test 2: query (line 7)
SELECT * FROM crdb_internal.default_privileges

-- Test 3: statement (line 107)
CREATE USER foo

-- Test 4: statement (line 110)
CREATE USER bar

-- Test 5: statement (line 113)
ALTER DEFAULT PRIVILEGES GRANT ALL ON TABLES TO foo, bar;
ALTER DEFAULT PRIVILEGES GRANT ALL ON TYPES TO foo, bar;
ALTER DEFAULT PRIVILEGES GRANT ALL ON SCHEMAS TO foo, bar;
ALTER DEFAULT PRIVILEGES GRANT ALL ON SEQUENCES TO foo, bar;

-- Test 6: query (line 119)
SELECT * FROM crdb_internal.default_privileges WHERE grantee='foo' OR grantee='bar'

-- Test 7: statement (line 172)
GRANT foo, bar TO root;

-- Test 8: statement (line 175)
ALTER DEFAULT PRIVILEGES FOR ROLE foo, bar GRANT ALL ON TABLES TO foo, bar;
ALTER DEFAULT PRIVILEGES FOR ROLE foo, bar GRANT ALL ON TYPES TO foo, bar;
ALTER DEFAULT PRIVILEGES FOR ROLE foo, bar GRANT ALL ON SCHEMAS TO foo, bar;
ALTER DEFAULT PRIVILEGES FOR ROLE foo, bar GRANT ALL ON SEQUENCES TO foo, bar;

-- Test 9: query (line 181)
SELECT * FROM crdb_internal.default_privileges WHERE role='foo' OR role='bar'

-- Test 10: statement (line 250)
ALTER DEFAULT PRIVILEGES FOR ROLE foo, bar REVOKE ALL ON TABLES FROM foo, bar;
ALTER DEFAULT PRIVILEGES FOR ROLE foo, bar REVOKE ALL ON TYPES FROM foo, bar;
ALTER DEFAULT PRIVILEGES FOR ROLE foo, bar REVOKE ALL ON SCHEMAS FROM foo, bar;
ALTER DEFAULT PRIVILEGES FOR ROLE foo, bar REVOKE ALL ON SEQUENCES FROM foo, bar;

-- Test 11: query (line 256)
SELECT * FROM crdb_internal.default_privileges

-- Test 12: statement (line 412)
ALTER DEFAULT PRIVILEGES REVOKE SELECT ON TABLES FROM foo, bar, public;
ALTER DEFAULT PRIVILEGES REVOKE ALL ON TYPES FROM foo, bar, public;
ALTER DEFAULT PRIVILEGES REVOKE ALL ON SCHEMAS FROM foo, bar, public;
ALTER DEFAULT PRIVILEGES REVOKE ALL ON SEQUENCES FROM foo, bar, public;

-- Test 13: query (line 418)
SELECT * FROM crdb_internal.default_privileges

-- Test 14: statement (line 584)
ALTER DEFAULT PRIVILEGES REVOKE ALL ON TABLES FROM foo, bar, public;
ALTER DEFAULT PRIVILEGES GRANT DROP, ZONECONFIG ON TABLES TO foo WITH GRANT OPTION;

-- Test 15: query (line 588)
SELECT * FROM crdb_internal.default_privileges

-- Test 16: statement (line 735)
CREATE DATABASE test2;
use test2;

-- Test 17: statement (line 739)
ALTER DEFAULT PRIVILEGES GRANT DROP, ZONECONFIG ON TABLES TO foo WITH GRANT OPTION;

-- Test 18: query (line 742)
SELECT * FROM crdb_internal.default_privileges

-- Test 19: statement (line 927)
ALTER DEFAULT PRIVILEGES FOR ALL ROLES GRANT SELECT ON TABLES TO foo;

-- Test 20: query (line 930)
SELECT * FROM crdb_internal.default_privileges

-- Test 21: statement (line 1118)
CREATE ROLE roach_a;
CREATE ROLE roach_b;
SET ROLE roach_b;

-- Test 22: statement (line 1123)
ALTER DEFAULT PRIVILEGES FOR ROLE roach_b GRANT SELECT ON TABLES TO roach_a;

-- Test 23: statement (line 1126)
SET ROLE root;

-- Test 24: statement (line 1129)
ALTER DEFAULT PRIVILEGES FOR ALL ROLES GRANT SELECT ON TABLES TO roach_a;

-- Test 25: statement (line 1132)
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT INSERT ON TABLES TO roach_a;

-- Test 26: statement (line 1137)
DELETE FROM system.users WHERE username = 'roach_a';

-- Test 27: statement (line 1141)
CREATE ROLE tmp;

-- Test 28: query (line 1144)
SELECT * FROM crdb_internal.default_privileges WHERE grantee = 'roach_a'
ORDER BY role;

-- Test 29: statement (line 1153)
CREATE ROLE roach_c;
CREATE ROLE roach_d;
SET ROLE roach_d;

-- Test 30: statement (line 1158)
ALTER DEFAULT PRIVILEGES FOR ROLE roach_d GRANT SELECT ON TABLES TO roach_b;

-- Test 31: statement (line 1161)
SET ROLE roach_c;

-- Test 32: statement (line 1164)
ALTER DEFAULT PRIVILEGES FOR ROLE roach_c GRANT SELECT ON TABLES TO roach_d;

-- Test 33: statement (line 1167)
SET ROLE root;

-- Test 34: statement (line 1172)
DELETE FROM system.users WHERE username = 'roach_d';

-- Test 35: statement (line 1176)
DELETE FROM system.users WHERE username = 'roach_c';

-- Test 36: query (line 1181)
WITH t AS (
   SELECT json_array_elements(crdb_internal.pb_to_json('cockroach.sql.sqlbase.Descriptor', descriptor)
     -> 'database'
     -> 'defaultPrivileges'
     -> 'defaultPrivilegesPerRole') AS default_privs_per_role
   FROM system.descriptor
   WHERE id = (SELECT oid FROM pg_database WHERE datname = 'test2')
) SELECT
  default_privs_per_role->'defaultPrivilegesPerObject'->'1'->'users' AS grantees,
  default_privs_per_role->'explicitRole'->'userProto' AS role
 FROM t
ORDER BY role;

-- Test 37: statement (line 1203)
CREATE ROLE invalidate;

-- Test 38: query (line 1206)
SELECT database_name, schema_name, obj_name, error FROM crdb_internal.invalid_objects
ORDER BY schema_name;

-- Test 39: query (line 1214)
SELECT name, corruption FROM crdb_internal.kv_repairable_catalog_corruptions
ORDER BY name;

-- Test 40: statement (line 1222)
SELECT crdb_internal.repair_catalog_corruption(id, corruption) FROM "".crdb_internal.kv_repairable_catalog_corruptions;

-- Test 41: query (line 1225)
SELECT count(*) FROM crdb_internal.invalid_objects;

-- Test 42: query (line 1231)
WITH t AS (
   SELECT json_array_elements(crdb_internal.pb_to_json('cockroach.sql.sqlbase.Descriptor', descriptor)
     -> 'database'
     -> 'defaultPrivileges'
     -> 'defaultPrivilegesPerRole') AS default_privs_per_role
   FROM system.descriptor
   WHERE id = (SELECT oid FROM pg_database WHERE datname = 'test2')
) SELECT
  default_privs_per_role->'defaultPrivilegesPerObject'->'1'->'users' AS grantees,
  default_privs_per_role->'explicitRole'->'userProto' AS role
 FROM t
ORDER BY role;

