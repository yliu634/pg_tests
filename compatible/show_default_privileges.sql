-- PostgreSQL compatible tests from show_default_privileges
-- 40 tests

SET client_min_messages = warning;

-- Cluster-level objects referenced by this file. Drop first so repeated runs
-- remain deterministic.
DROP DATABASE IF EXISTS test2;
DROP DATABASE IF EXISTS "MixedCaseDB";

DROP ROLE IF EXISTS testuser2;
DROP ROLE IF EXISTS testuser;
DROP ROLE IF EXISTS bar;
DROP ROLE IF EXISTS foo;
DROP ROLE IF EXISTS root;

-- Ensure the roles referenced by the CockroachDB test exist.
CREATE ROLE root SUPERUSER;
CREATE ROLE testuser;

-- CockroachDB's `SHOW DEFAULT PRIVILEGES` isn't available in PostgreSQL.
-- Provide a query helper backed by pg_default_acl.
CREATE SCHEMA IF NOT EXISTS crdb_internal;
CREATE OR REPLACE VIEW crdb_internal.default_privileges AS
SELECT
  r.rolname AS defaclrole,
  COALESCE(n.nspname, '<global>') AS defaclnamespace,
  CASE d.defaclobjtype
    WHEN 'r' THEN 'table'
    WHEN 'S' THEN 'sequence'
    WHEN 'f' THEN 'function'
    WHEN 'T' THEN 'type'
    WHEN 'n' THEN 'schema'
    ELSE d.defaclobjtype::text
  END AS defaclobjtype,
  CASE WHEN a.grantee = 0 THEN 'PUBLIC' ELSE g.rolname END AS grantee,
  a.privilege_type,
  CASE WHEN a.is_grantable THEN 'YES' ELSE 'NO' END AS is_grantable
FROM pg_catalog.pg_default_acl AS d
JOIN pg_catalog.pg_roles AS r ON r.oid = d.defaclrole
LEFT JOIN pg_catalog.pg_namespace AS n ON n.oid = d.defaclnamespace
CROSS JOIN LATERAL pg_catalog.aclexplode(d.defaclacl) AS a
LEFT JOIN pg_catalog.pg_roles AS g ON g.oid = a.grantee;

RESET client_min_messages;

-- Remember the per-run harness database so we can return after `\c`.
SELECT current_database() AS original_db \gset

SET ROLE root;

-- Test 1: query (line 3)
SELECT * FROM crdb_internal.default_privileges ORDER BY 1, 2, 3, 4, 5, 6;

-- Test 2: statement (line 17)
ALTER DEFAULT PRIVILEGES REVOKE ALL ON TABLES FROM root;
ALTER DEFAULT PRIVILEGES REVOKE USAGE ON TYPES FROM PUBLIC;

-- Test 3: query (line 21)
SELECT * FROM crdb_internal.default_privileges ORDER BY 1, 2, 3, 4, 5, 6;

-- Test 4: statement (line 31)
ALTER DEFAULT PRIVILEGES GRANT SELECT ON TABLES TO PUBLIC;
ALTER DEFAULT PRIVILEGES GRANT USAGE ON TYPES TO PUBLIC;
ALTER DEFAULT PRIVILEGES GRANT USAGE ON SCHEMAS TO PUBLIC;
ALTER DEFAULT PRIVILEGES GRANT SELECT ON SEQUENCES TO PUBLIC;

-- Test 5: query (line 37)
SELECT * FROM crdb_internal.default_privileges ORDER BY 1, 2, 3, 4, 5, 6;

-- Test 6: statement (line 51)
CREATE USER foo;

-- Test 7: statement (line 54)
CREATE USER bar;

-- Test 8: query (line 57)
SELECT * FROM crdb_internal.default_privileges ORDER BY 1, 2, 3, 4, 5, 6;

-- Test 9: statement (line 71)
ALTER DEFAULT PRIVILEGES GRANT ALL ON TABLES TO foo, bar;
ALTER DEFAULT PRIVILEGES GRANT ALL ON TYPES TO foo, bar;
ALTER DEFAULT PRIVILEGES GRANT ALL ON SCHEMAS TO foo, bar;
ALTER DEFAULT PRIVILEGES GRANT ALL ON SEQUENCES TO foo, bar;

-- Test 10: query (line 77)
SELECT *
FROM crdb_internal.default_privileges
WHERE defaclrole IN ('foo', 'bar', 'root')
ORDER BY 1, 2, 3, 4, 5, 6;

-- Test 11: statement (line 113)
GRANT foo, bar TO root;

-- Test 12: statement (line 116)
ALTER DEFAULT PRIVILEGES FOR ROLE foo, bar GRANT ALL ON TABLES TO foo, bar;
ALTER DEFAULT PRIVILEGES FOR ROLE foo, bar GRANT ALL ON TYPES TO foo, bar;
ALTER DEFAULT PRIVILEGES FOR ROLE foo, bar GRANT ALL ON SCHEMAS TO foo, bar;
ALTER DEFAULT PRIVILEGES FOR ROLE foo, bar GRANT ALL ON SEQUENCES TO foo, bar;

-- Test 13: query (line 122)
SELECT * FROM crdb_internal.default_privileges ORDER BY 1, 2, 3, 4, 5, 6;

-- Test 14: statement (line 144)
ALTER DEFAULT PRIVILEGES FOR ROLE foo, bar REVOKE ALL ON TABLES FROM foo, bar;
ALTER DEFAULT PRIVILEGES FOR ROLE foo, bar REVOKE ALL ON TYPES FROM foo, bar;
ALTER DEFAULT PRIVILEGES FOR ROLE foo, bar REVOKE ALL ON SCHEMAS FROM foo, bar;
ALTER DEFAULT PRIVILEGES FOR ROLE foo, bar REVOKE ALL ON SEQUENCES FROM foo, bar;

-- Test 15: query (line 150)
SELECT * FROM crdb_internal.default_privileges ORDER BY 1, 2, 3, 4, 5, 6;

-- Test 16: statement (line 172)
ALTER DEFAULT PRIVILEGES REVOKE SELECT ON TABLES FROM foo, bar, PUBLIC;
ALTER DEFAULT PRIVILEGES REVOKE ALL ON TYPES FROM foo, bar, PUBLIC;
ALTER DEFAULT PRIVILEGES REVOKE ALL ON SCHEMAS FROM foo, bar, PUBLIC;
ALTER DEFAULT PRIVILEGES REVOKE ALL ON SEQUENCES FROM foo, bar, PUBLIC;

-- Test 17: query (line 178)
SELECT * FROM crdb_internal.default_privileges ORDER BY 1, 2, 3, 4, 5, 6;

-- Test 18: statement (line 210)
ALTER DEFAULT PRIVILEGES REVOKE ALL ON TABLES FROM foo, bar, PUBLIC;
-- CockroachDB-specific privileges. Map to the closest PostgreSQL table privileges.
ALTER DEFAULT PRIVILEGES GRANT TRIGGER, TRUNCATE ON TABLES TO foo WITH GRANT OPTION;

-- Test 19: query (line 214)
SELECT * FROM crdb_internal.default_privileges ORDER BY 1, 2, 3, 4, 5, 6;

-- Test 20: statement (line 227)
CREATE DATABASE test2;
\c test2

CREATE SCHEMA IF NOT EXISTS crdb_internal;
CREATE OR REPLACE VIEW crdb_internal.default_privileges AS
SELECT
  r.rolname AS defaclrole,
  COALESCE(n.nspname, '<global>') AS defaclnamespace,
  CASE d.defaclobjtype
    WHEN 'r' THEN 'table'
    WHEN 'S' THEN 'sequence'
    WHEN 'f' THEN 'function'
    WHEN 'T' THEN 'type'
    WHEN 'n' THEN 'schema'
    ELSE d.defaclobjtype::text
  END AS defaclobjtype,
  CASE WHEN a.grantee = 0 THEN 'PUBLIC' ELSE g.rolname END AS grantee,
  a.privilege_type,
  CASE WHEN a.is_grantable THEN 'YES' ELSE 'NO' END AS is_grantable
FROM pg_catalog.pg_default_acl AS d
JOIN pg_catalog.pg_roles AS r ON r.oid = d.defaclrole
LEFT JOIN pg_catalog.pg_namespace AS n ON n.oid = d.defaclnamespace
CROSS JOIN LATERAL pg_catalog.aclexplode(d.defaclacl) AS a
LEFT JOIN pg_catalog.pg_roles AS g ON g.oid = a.grantee;

SET ROLE root;

CREATE USER testuser2;

-- Test 21: statement (line 232)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser GRANT TRIGGER, TRUNCATE ON TABLES TO foo WITH GRANT OPTION;

-- Test 22: query (line 235)
SELECT *
FROM crdb_internal.default_privileges
WHERE defaclrole IN ('testuser')
ORDER BY 1, 2, 3, 4, 5, 6;

-- Test 23: query (line 251)
SELECT * FROM crdb_internal.default_privileges ORDER BY 1, 2, 3, 4, 5, 6;

-- Test 24: query (line 265)
SELECT *
FROM crdb_internal.default_privileges
WHERE defaclrole IN ('testuser')
ORDER BY 1, 2, 3, 4, 5, 6;

-- Test 25: statement (line 279)
ALTER DEFAULT PRIVILEGES FOR ROLE root GRANT TRIGGER, TRUNCATE ON TABLES TO foo WITH GRANT OPTION;

-- Test 26: query (line 282)
SELECT *
FROM crdb_internal.default_privileges
WHERE defaclrole IN ('root', 'testuser')
ORDER BY 1, 2, 3, 4, 5, 6;

-- Test 27: statement (line 305)
ALTER DEFAULT PRIVILEGES FOR ROLE root GRANT TRIGGER, TRUNCATE ON TABLES TO foo WITH GRANT OPTION;
ALTER DEFAULT PRIVILEGES FOR ROLE testuser GRANT TRIGGER, TRUNCATE ON TABLES TO foo WITH GRANT OPTION;
ALTER DEFAULT PRIVILEGES FOR ROLE foo GRANT TRIGGER, TRUNCATE ON TABLES TO foo WITH GRANT OPTION;
ALTER DEFAULT PRIVILEGES FOR ROLE bar GRANT TRIGGER, TRUNCATE ON TABLES TO foo WITH GRANT OPTION;
ALTER DEFAULT PRIVILEGES FOR ROLE testuser2 GRANT TRIGGER, TRUNCATE ON TABLES TO foo WITH GRANT OPTION;

-- Test 28: query (line 309)
SELECT * FROM crdb_internal.default_privileges ORDER BY 1, 2, 3, 4, 5, 6;

-- Test 29: statement (line 318)
CREATE DATABASE "MixedCaseDB";

-- Test 30: statement (line 321)
\c "MixedCaseDB"

CREATE SCHEMA IF NOT EXISTS crdb_internal;
CREATE OR REPLACE VIEW crdb_internal.default_privileges AS
SELECT
  r.rolname AS defaclrole,
  COALESCE(n.nspname, '<global>') AS defaclnamespace,
  CASE d.defaclobjtype
    WHEN 'r' THEN 'table'
    WHEN 'S' THEN 'sequence'
    WHEN 'f' THEN 'function'
    WHEN 'T' THEN 'type'
    WHEN 'n' THEN 'schema'
    ELSE d.defaclobjtype::text
  END AS defaclobjtype,
  CASE WHEN a.grantee = 0 THEN 'PUBLIC' ELSE g.rolname END AS grantee,
  a.privilege_type,
  CASE WHEN a.is_grantable THEN 'YES' ELSE 'NO' END AS is_grantable
FROM pg_catalog.pg_default_acl AS d
JOIN pg_catalog.pg_roles AS r ON r.oid = d.defaclrole
LEFT JOIN pg_catalog.pg_namespace AS n ON n.oid = d.defaclnamespace
CROSS JOIN LATERAL pg_catalog.aclexplode(d.defaclacl) AS a
LEFT JOIN pg_catalog.pg_roles AS g ON g.oid = a.grantee;

SET ROLE root;

CREATE SCHEMA "MixedCaseSchema";

-- Test 31: statement (line 324)
-- Already connected to "MixedCaseDB" above.

-- Test 32: statement (line 327)
ALTER DEFAULT PRIVILEGES IN SCHEMA "MixedCaseSchema" GRANT SELECT ON TABLES TO foo WITH GRANT OPTION;
ALTER DEFAULT PRIVILEGES IN SCHEMA "MixedCaseSchema" GRANT ALL ON TABLES TO bar;

-- Test 33: query (line 331)
SELECT * FROM crdb_internal.default_privileges ORDER BY 1, 2, 3, 4, 5, 6;

-- Test 34: query (line 343)
SELECT *
FROM crdb_internal.default_privileges
WHERE defaclnamespace IN ('MixedCaseSchema')
ORDER BY 1, 2, 3, 4, 5, 6;

-- Test 35: statement (line 350)
ALTER DEFAULT PRIVILEGES FOR ROLE root GRANT SELECT ON TABLES TO testuser;

-- Test 36: query (line 353)
SELECT * FROM crdb_internal.default_privileges ORDER BY 1, 2, 3, 4, 5, 6;

-- Test 37: query (line 366)
SELECT *
FROM crdb_internal.default_privileges
WHERE grantee IN ('testuser')
ORDER BY 1, 2, 3, 4, 5, 6;

-- Test 38: statement (line 377)
ALTER DEFAULT PRIVILEGES FOR ROLE root GRANT TRIGGER, TRUNCATE ON TABLES TO foo, bar WITH GRANT OPTION;
ALTER DEFAULT PRIVILEGES FOR ROLE testuser GRANT TRIGGER, TRUNCATE ON TABLES TO foo, bar WITH GRANT OPTION;
ALTER DEFAULT PRIVILEGES FOR ROLE foo GRANT TRIGGER, TRUNCATE ON TABLES TO foo, bar WITH GRANT OPTION;
ALTER DEFAULT PRIVILEGES FOR ROLE bar GRANT TRIGGER, TRUNCATE ON TABLES TO foo, bar WITH GRANT OPTION;
ALTER DEFAULT PRIVILEGES FOR ROLE testuser2 GRANT TRIGGER, TRUNCATE ON TABLES TO foo, bar WITH GRANT OPTION;

-- Test 39: query (line 380)
SELECT *
FROM crdb_internal.default_privileges
WHERE grantee IN ('foo', 'bar')
ORDER BY 1, 2, 3, 4, 5, 6;

-- Test 40: query (line 399)
SELECT *
FROM crdb_internal.default_privileges
WHERE grantee IN ('foo') AND defaclnamespace IN ('MixedCaseSchema')
ORDER BY 1, 2, 3, 4, 5, 6;

\c :original_db
DROP DATABASE IF EXISTS test2;
DROP DATABASE IF EXISTS "MixedCaseDB";
