-- PostgreSQL compatible tests from pg_catalog_pg_default_acl
-- 38 tests

SET client_min_messages = warning;

-- Use test-scoped role names to avoid collisions with other suites.
DROP ROLE IF EXISTS crdb_tests_pg_default_acl_testuser;
DROP ROLE IF EXISTS crdb_tests_pg_default_acl_bar;
DROP ROLE IF EXISTS crdb_tests_pg_default_acl_foo;

-- Test 1: statement (line 1)
ALTER DEFAULT PRIVILEGES GRANT SELECT ON TABLES TO PUBLIC;
ALTER DEFAULT PRIVILEGES GRANT USAGE ON SCHEMAS TO PUBLIC;
ALTER DEFAULT PRIVILEGES GRANT SELECT ON SEQUENCES TO PUBLIC;
ALTER DEFAULT PRIVILEGES REVOKE EXECUTE ON FUNCTIONS FROM PUBLIC;

-- Test 2: query (line 8)
SELECT
  r.rolname AS defaclrole,
  COALESCE(n.nspname, '<global>') AS defaclnamespace,
  d.defaclobjtype,
  d.defaclacl
FROM pg_catalog.pg_default_acl AS d
JOIN pg_catalog.pg_roles AS r ON r.oid = d.defaclrole
LEFT JOIN pg_catalog.pg_namespace AS n ON n.oid = d.defaclnamespace
ORDER BY 1, 2, 3;

-- Test 3: statement (line 17)
ALTER DEFAULT PRIVILEGES GRANT EXECUTE ON FUNCTIONS TO PUBLIC;

-- Test 4: statement (line 20)
CREATE ROLE crdb_tests_pg_default_acl_foo;

-- Test 5: statement (line 23)
CREATE ROLE crdb_tests_pg_default_acl_bar;

-- Test 6: statement (line 26)
ALTER DEFAULT PRIVILEGES GRANT ALL ON TABLES TO crdb_tests_pg_default_acl_foo, crdb_tests_pg_default_acl_bar WITH GRANT OPTION;
ALTER DEFAULT PRIVILEGES GRANT ALL ON TYPES TO crdb_tests_pg_default_acl_foo, crdb_tests_pg_default_acl_bar WITH GRANT OPTION;
ALTER DEFAULT PRIVILEGES GRANT ALL ON SCHEMAS TO crdb_tests_pg_default_acl_foo, crdb_tests_pg_default_acl_bar WITH GRANT OPTION;
ALTER DEFAULT PRIVILEGES GRANT ALL ON SEQUENCES TO crdb_tests_pg_default_acl_foo, crdb_tests_pg_default_acl_bar WITH GRANT OPTION;
ALTER DEFAULT PRIVILEGES GRANT ALL ON FUNCTIONS TO crdb_tests_pg_default_acl_foo, crdb_tests_pg_default_acl_bar WITH GRANT OPTION;

-- Test 7: query (line 33)
SELECT
  r.rolname AS defaclrole,
  COALESCE(n.nspname, '<global>') AS defaclnamespace,
  d.defaclobjtype,
  d.defaclacl
FROM pg_catalog.pg_default_acl AS d
JOIN pg_catalog.pg_roles AS r ON r.oid = d.defaclrole
LEFT JOIN pg_catalog.pg_namespace AS n ON n.oid = d.defaclnamespace
ORDER BY 1, 2, 3;

-- Test 8: statement (line 43)
GRANT crdb_tests_pg_default_acl_foo, crdb_tests_pg_default_acl_bar TO postgres;

-- Test 9: statement (line 46)
ALTER DEFAULT PRIVILEGES FOR ROLE crdb_tests_pg_default_acl_foo, crdb_tests_pg_default_acl_bar GRANT ALL ON TABLES TO crdb_tests_pg_default_acl_foo, crdb_tests_pg_default_acl_bar WITH GRANT OPTION;
ALTER DEFAULT PRIVILEGES FOR ROLE crdb_tests_pg_default_acl_foo, crdb_tests_pg_default_acl_bar GRANT ALL ON TYPES TO crdb_tests_pg_default_acl_foo, crdb_tests_pg_default_acl_bar WITH GRANT OPTION;
ALTER DEFAULT PRIVILEGES FOR ROLE crdb_tests_pg_default_acl_foo, crdb_tests_pg_default_acl_bar GRANT ALL ON SCHEMAS TO crdb_tests_pg_default_acl_foo, crdb_tests_pg_default_acl_bar WITH GRANT OPTION;
ALTER DEFAULT PRIVILEGES FOR ROLE crdb_tests_pg_default_acl_foo, crdb_tests_pg_default_acl_bar GRANT ALL ON SEQUENCES TO crdb_tests_pg_default_acl_foo, crdb_tests_pg_default_acl_bar WITH GRANT OPTION;
ALTER DEFAULT PRIVILEGES FOR ROLE crdb_tests_pg_default_acl_foo, crdb_tests_pg_default_acl_bar GRANT ALL ON FUNCTIONS TO crdb_tests_pg_default_acl_foo, crdb_tests_pg_default_acl_bar WITH GRANT OPTION;

-- Test 10: query (line 54)
SELECT
  r.rolname AS defaclrole,
  COALESCE(n.nspname, '<global>') AS defaclnamespace,
  d.defaclobjtype,
  d.defaclacl
FROM pg_catalog.pg_default_acl AS d
JOIN pg_catalog.pg_roles AS r ON r.oid = d.defaclrole
LEFT JOIN pg_catalog.pg_namespace AS n ON n.oid = d.defaclnamespace
ORDER BY 1, 2, 3;

-- Test 11: statement (line 74)
ALTER DEFAULT PRIVILEGES FOR ROLE crdb_tests_pg_default_acl_foo, crdb_tests_pg_default_acl_bar REVOKE ALL ON TABLES FROM crdb_tests_pg_default_acl_foo, crdb_tests_pg_default_acl_bar;
ALTER DEFAULT PRIVILEGES FOR ROLE crdb_tests_pg_default_acl_foo, crdb_tests_pg_default_acl_bar REVOKE ALL ON TYPES FROM crdb_tests_pg_default_acl_foo, crdb_tests_pg_default_acl_bar;
ALTER DEFAULT PRIVILEGES FOR ROLE crdb_tests_pg_default_acl_foo, crdb_tests_pg_default_acl_bar REVOKE ALL ON SCHEMAS FROM crdb_tests_pg_default_acl_foo, crdb_tests_pg_default_acl_bar;
ALTER DEFAULT PRIVILEGES FOR ROLE crdb_tests_pg_default_acl_foo, crdb_tests_pg_default_acl_bar REVOKE ALL ON SEQUENCES FROM crdb_tests_pg_default_acl_foo, crdb_tests_pg_default_acl_bar;
ALTER DEFAULT PRIVILEGES FOR ROLE crdb_tests_pg_default_acl_foo, crdb_tests_pg_default_acl_bar REVOKE ALL ON FUNCTIONS FROM crdb_tests_pg_default_acl_foo, crdb_tests_pg_default_acl_bar;

-- Test 12: query (line 83)
SELECT
  r.rolname AS defaclrole,
  COALESCE(n.nspname, '<global>') AS defaclnamespace,
  d.defaclobjtype,
  d.defaclacl
FROM pg_catalog.pg_default_acl AS d
JOIN pg_catalog.pg_roles AS r ON r.oid = d.defaclrole
LEFT JOIN pg_catalog.pg_namespace AS n ON n.oid = d.defaclnamespace
ORDER BY 1, 2, 3;

-- Test 13: statement (line 103)
ALTER DEFAULT PRIVILEGES FOR ROLE crdb_tests_pg_default_acl_foo GRANT ALL ON TABLES TO crdb_tests_pg_default_acl_foo WITH GRANT OPTION;
ALTER DEFAULT PRIVILEGES FOR ROLE crdb_tests_pg_default_acl_foo GRANT ALL ON SEQUENCES TO crdb_tests_pg_default_acl_foo WITH GRANT OPTION;
ALTER DEFAULT PRIVILEGES FOR ROLE crdb_tests_pg_default_acl_foo GRANT ALL ON SCHEMAS TO crdb_tests_pg_default_acl_foo WITH GRANT OPTION;
ALTER DEFAULT PRIVILEGES FOR ROLE crdb_tests_pg_default_acl_foo GRANT ALL ON TYPES TO crdb_tests_pg_default_acl_foo WITH GRANT OPTION;
ALTER DEFAULT PRIVILEGES FOR ROLE crdb_tests_pg_default_acl_foo GRANT ALL ON FUNCTIONS TO crdb_tests_pg_default_acl_foo WITH GRANT OPTION;
ALTER DEFAULT PRIVILEGES FOR ROLE crdb_tests_pg_default_acl_bar GRANT ALL ON TABLES TO crdb_tests_pg_default_acl_bar WITH GRANT OPTION;
ALTER DEFAULT PRIVILEGES FOR ROLE crdb_tests_pg_default_acl_bar GRANT ALL ON SEQUENCES TO crdb_tests_pg_default_acl_bar WITH GRANT OPTION;
ALTER DEFAULT PRIVILEGES FOR ROLE crdb_tests_pg_default_acl_bar GRANT ALL ON SCHEMAS TO crdb_tests_pg_default_acl_bar WITH GRANT OPTION;
ALTER DEFAULT PRIVILEGES FOR ROLE crdb_tests_pg_default_acl_bar GRANT ALL ON TYPES TO crdb_tests_pg_default_acl_bar WITH GRANT OPTION;
ALTER DEFAULT PRIVILEGES FOR ROLE crdb_tests_pg_default_acl_bar GRANT ALL ON FUNCTIONS TO crdb_tests_pg_default_acl_bar WITH GRANT OPTION;

-- Test 14: query (line 117)
SELECT
  r.rolname AS defaclrole,
  COALESCE(n.nspname, '<global>') AS defaclnamespace,
  d.defaclobjtype,
  d.defaclacl
FROM pg_catalog.pg_default_acl AS d
JOIN pg_catalog.pg_roles AS r ON r.oid = d.defaclrole
LEFT JOIN pg_catalog.pg_namespace AS n ON n.oid = d.defaclnamespace
ORDER BY 1, 2, 3;

-- Test 15: statement (line 139)
ALTER DEFAULT PRIVILEGES FOR ROLE crdb_tests_pg_default_acl_foo REVOKE SELECT ON TABLES FROM crdb_tests_pg_default_acl_foo;

-- Test 16: query (line 142)
SELECT
  r.rolname AS defaclrole,
  COALESCE(n.nspname, '<global>') AS defaclnamespace,
  d.defaclobjtype,
  d.defaclacl
FROM pg_catalog.pg_default_acl AS d
JOIN pg_catalog.pg_roles AS r ON r.oid = d.defaclrole
LEFT JOIN pg_catalog.pg_namespace AS n ON n.oid = d.defaclnamespace
ORDER BY 1, 2, 3;

-- Test 17: statement (line 162)
ALTER DEFAULT PRIVILEGES FOR ROLE crdb_tests_pg_default_acl_foo GRANT SELECT ON TABLES TO crdb_tests_pg_default_acl_foo;

-- Test 18: query (line 165)
SELECT
  r.rolname AS defaclrole,
  COALESCE(n.nspname, '<global>') AS defaclnamespace,
  d.defaclobjtype,
  d.defaclacl
FROM pg_catalog.pg_default_acl AS d
JOIN pg_catalog.pg_roles AS r ON r.oid = d.defaclrole
LEFT JOIN pg_catalog.pg_namespace AS n ON n.oid = d.defaclnamespace
ORDER BY 1, 2, 3;

-- Test 19: statement (line 185)
ALTER DEFAULT PRIVILEGES REVOKE SELECT ON TABLES FROM crdb_tests_pg_default_acl_foo, crdb_tests_pg_default_acl_bar, PUBLIC;
ALTER DEFAULT PRIVILEGES REVOKE ALL ON SCHEMAS FROM crdb_tests_pg_default_acl_foo, crdb_tests_pg_default_acl_bar, PUBLIC;
ALTER DEFAULT PRIVILEGES REVOKE ALL ON SEQUENCES FROM crdb_tests_pg_default_acl_foo, crdb_tests_pg_default_acl_bar, PUBLIC;
ALTER DEFAULT PRIVILEGES REVOKE ALL ON FUNCTIONS FROM crdb_tests_pg_default_acl_foo, crdb_tests_pg_default_acl_bar, PUBLIC;

-- Test 20: statement (line 191)
ALTER DEFAULT PRIVILEGES REVOKE ALL ON TYPES FROM crdb_tests_pg_default_acl_foo, crdb_tests_pg_default_acl_bar;

-- Test 21: query (line 194)
SELECT
  r.rolname AS defaclrole,
  COALESCE(n.nspname, '<global>') AS defaclnamespace,
  d.defaclobjtype,
  d.defaclacl
FROM pg_catalog.pg_default_acl AS d
JOIN pg_catalog.pg_roles AS r ON r.oid = d.defaclrole
LEFT JOIN pg_catalog.pg_namespace AS n ON n.oid = d.defaclnamespace
ORDER BY 1, 2, 3;

-- Test 22: statement (line 212)
ALTER DEFAULT PRIVILEGES REVOKE ALL ON TABLES FROM crdb_tests_pg_default_acl_foo, crdb_tests_pg_default_acl_bar, PUBLIC;
ALTER DEFAULT PRIVILEGES GRANT TRUNCATE, REFERENCES ON TABLES TO crdb_tests_pg_default_acl_foo;

-- Test 23: query (line 216)
SELECT
  r.rolname AS defaclrole,
  COALESCE(n.nspname, '<global>') AS defaclnamespace,
  d.defaclobjtype,
  d.defaclacl
FROM pg_catalog.pg_default_acl AS d
JOIN pg_catalog.pg_roles AS r ON r.oid = d.defaclrole
LEFT JOIN pg_catalog.pg_namespace AS n ON n.oid = d.defaclnamespace
ORDER BY 1, 2, 3;

-- Test 24: statement (line 233)
ALTER DEFAULT PRIVILEGES REVOKE TRUNCATE, REFERENCES ON TABLES FROM crdb_tests_pg_default_acl_foo;

-- Test 25: statement (line 238)
ALTER DEFAULT PRIVILEGES FOR ROLE postgres, crdb_tests_pg_default_acl_foo, crdb_tests_pg_default_acl_bar GRANT ALL ON TABLES TO crdb_tests_pg_default_acl_foo, crdb_tests_pg_default_acl_bar WITH GRANT OPTION;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres, crdb_tests_pg_default_acl_foo, crdb_tests_pg_default_acl_bar GRANT ALL ON TYPES TO crdb_tests_pg_default_acl_foo, crdb_tests_pg_default_acl_bar WITH GRANT OPTION;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres, crdb_tests_pg_default_acl_foo, crdb_tests_pg_default_acl_bar GRANT ALL ON SCHEMAS TO crdb_tests_pg_default_acl_foo, crdb_tests_pg_default_acl_bar WITH GRANT OPTION;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres, crdb_tests_pg_default_acl_foo, crdb_tests_pg_default_acl_bar GRANT ALL ON SEQUENCES TO crdb_tests_pg_default_acl_foo, crdb_tests_pg_default_acl_bar WITH GRANT OPTION;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres, crdb_tests_pg_default_acl_foo, crdb_tests_pg_default_acl_bar GRANT ALL ON FUNCTIONS TO crdb_tests_pg_default_acl_foo, crdb_tests_pg_default_acl_bar WITH GRANT OPTION;

-- Test 26: query (line 245)
SELECT
  r.rolname AS defaclrole,
  COALESCE(n.nspname, '<global>') AS defaclnamespace,
  d.defaclobjtype,
  d.defaclacl
FROM pg_catalog.pg_default_acl AS d
JOIN pg_catalog.pg_roles AS r ON r.oid = d.defaclrole
LEFT JOIN pg_catalog.pg_namespace AS n ON n.oid = d.defaclnamespace
ORDER BY 1, 2, 3;

-- Test 27: statement (line 266)
ALTER DEFAULT PRIVILEGES FOR ROLE postgres, crdb_tests_pg_default_acl_foo, crdb_tests_pg_default_acl_bar REVOKE ALL ON TABLES FROM crdb_tests_pg_default_acl_foo, crdb_tests_pg_default_acl_bar;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres, crdb_tests_pg_default_acl_foo, crdb_tests_pg_default_acl_bar REVOKE ALL ON TYPES FROM crdb_tests_pg_default_acl_foo, crdb_tests_pg_default_acl_bar;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres, crdb_tests_pg_default_acl_foo, crdb_tests_pg_default_acl_bar REVOKE ALL ON SCHEMAS FROM crdb_tests_pg_default_acl_foo, crdb_tests_pg_default_acl_bar;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres, crdb_tests_pg_default_acl_foo, crdb_tests_pg_default_acl_bar REVOKE ALL ON SEQUENCES FROM crdb_tests_pg_default_acl_foo, crdb_tests_pg_default_acl_bar;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres, crdb_tests_pg_default_acl_foo, crdb_tests_pg_default_acl_bar REVOKE ALL ON FUNCTIONS FROM crdb_tests_pg_default_acl_foo, crdb_tests_pg_default_acl_bar;

-- Test 28: query (line 273)
SELECT
  r.rolname AS defaclrole,
  COALESCE(n.nspname, '<global>') AS defaclnamespace,
  d.defaclobjtype,
  d.defaclacl
FROM pg_catalog.pg_default_acl AS d
JOIN pg_catalog.pg_roles AS r ON r.oid = d.defaclrole
LEFT JOIN pg_catalog.pg_namespace AS n ON n.oid = d.defaclnamespace
ORDER BY 1, 2, 3;

-- Test 29: statement (line 291)
CREATE ROLE crdb_tests_pg_default_acl_testuser;
ALTER DEFAULT PRIVILEGES REVOKE ALL ON TABLES FROM crdb_tests_pg_default_acl_testuser;
ALTER DEFAULT PRIVILEGES REVOKE ALL ON SEQUENCES FROM crdb_tests_pg_default_acl_testuser;
ALTER DEFAULT PRIVILEGES REVOKE ALL ON SCHEMAS FROM crdb_tests_pg_default_acl_testuser;
ALTER DEFAULT PRIVILEGES REVOKE ALL ON TYPES FROM crdb_tests_pg_default_acl_testuser;
ALTER DEFAULT PRIVILEGES REVOKE ALL ON FUNCTIONS FROM crdb_tests_pg_default_acl_testuser;

-- Test 30: query (line 300)
SELECT
  r.rolname AS defaclrole,
  COALESCE(n.nspname, '<global>') AS defaclnamespace,
  d.defaclobjtype,
  d.defaclacl
FROM pg_catalog.pg_default_acl AS d
JOIN pg_catalog.pg_roles AS r ON r.oid = d.defaclrole
LEFT JOIN pg_catalog.pg_namespace AS n ON n.oid = d.defaclnamespace
ORDER BY 1, 2, 3;

-- Test 31: statement (line 321)
ALTER DEFAULT PRIVILEGES REVOKE USAGE ON TYPES FROM public;

-- Test 32: query (line 325)
SELECT
  r.rolname AS defaclrole,
  COALESCE(n.nspname, '<global>') AS defaclnamespace,
  d.defaclobjtype,
  d.defaclacl
FROM pg_catalog.pg_default_acl AS d
JOIN pg_catalog.pg_roles AS r ON r.oid = d.defaclrole
LEFT JOIN pg_catalog.pg_namespace AS n ON n.oid = d.defaclnamespace
ORDER BY 1, 2, 3;

-- Test 33: statement (line 347)
ALTER DEFAULT PRIVILEGES GRANT ALL ON TYPES TO crdb_tests_pg_default_acl_testuser WITH GRANT OPTION;

-- Test 34: query (line 352)
SELECT
  r.rolname AS defaclrole,
  COALESCE(n.nspname, '<global>') AS defaclnamespace,
  d.defaclobjtype,
  d.defaclacl
FROM pg_catalog.pg_default_acl AS d
JOIN pg_catalog.pg_roles AS r ON r.oid = d.defaclrole
LEFT JOIN pg_catalog.pg_namespace AS n ON n.oid = d.defaclnamespace
ORDER BY 1, 2, 3;

-- Test 35: statement (line 373)
ALTER DEFAULT PRIVILEGES GRANT ALL ON TABLES TO crdb_tests_pg_default_acl_foo WITH GRANT OPTION;
ALTER DEFAULT PRIVILEGES GRANT ALL ON SEQUENCES TO crdb_tests_pg_default_acl_foo WITH GRANT OPTION;
ALTER DEFAULT PRIVILEGES GRANT ALL ON SCHEMAS TO crdb_tests_pg_default_acl_foo WITH GRANT OPTION;
ALTER DEFAULT PRIVILEGES GRANT ALL ON TYPES TO crdb_tests_pg_default_acl_foo WITH GRANT OPTION;
ALTER DEFAULT PRIVILEGES GRANT ALL ON FUNCTIONS TO crdb_tests_pg_default_acl_foo WITH GRANT OPTION;

-- Test 36: query (line 382)
SELECT
  r.rolname AS defaclrole,
  COALESCE(n.nspname, '<global>') AS defaclnamespace,
  d.defaclobjtype,
  d.defaclacl
FROM pg_catalog.pg_default_acl AS d
JOIN pg_catalog.pg_roles AS r ON r.oid = d.defaclrole
LEFT JOIN pg_catalog.pg_namespace AS n ON n.oid = d.defaclnamespace
ORDER BY 1, 2, 3;

-- Test 37: statement (line 403)
ALTER DEFAULT PRIVILEGES IN SCHEMA PUBLIC GRANT SELECT,UPDATE,INSERT,DELETE ON TABLES TO crdb_tests_pg_default_acl_foo;
ALTER DEFAULT PRIVILEGES IN SCHEMA PUBLIC GRANT ALL ON SEQUENCES TO crdb_tests_pg_default_acl_foo;
ALTER DEFAULT PRIVILEGES IN SCHEMA PUBLIC GRANT ALL ON TYPES TO crdb_tests_pg_default_acl_foo;
ALTER DEFAULT PRIVILEGES IN SCHEMA PUBLIC GRANT ALL ON FUNCTIONS TO crdb_tests_pg_default_acl_foo;

-- Test 38: query (line 411)
SELECT
  r.rolname AS defaclrole,
  COALESCE(n.nspname, '<global>') AS defaclnamespace,
  d.defaclobjtype,
  d.defaclacl
FROM pg_catalog.pg_default_acl AS d
JOIN pg_catalog.pg_roles AS r ON r.oid = d.defaclrole
LEFT JOIN pg_catalog.pg_namespace AS n ON n.oid = d.defaclnamespace
WHERE d.defaclnamespace <> 0
ORDER BY 1, 2, 3;
