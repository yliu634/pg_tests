-- PostgreSQL compatible tests from grant_on_all_tables_in_schema
-- 22 tests

SET client_min_messages = warning;

-- Roles are cluster-scoped in PostgreSQL; make the test re-runnable.
DROP ROLE IF EXISTS testuser2;
DROP ROLE IF EXISTS testuser;

CREATE ROLE testuser LOGIN;
CREATE ROLE testuser2 LOGIN;
GRANT testuser TO :"USER";
GRANT testuser2 TO :"USER";

-- Test 1: statement (line 1)
-- (covered by role setup above)

-- Test 2: statement (line 4)
CREATE SCHEMA s;
CREATE SCHEMA s2;

-- Test 3: statement (line 9)
GRANT SELECT ON ALL TABLES IN SCHEMA s TO testuser;

-- Test 4: query (line 12)
SELECT table_schema, table_name, lower(grantee) AS grantee, privilege_type, is_grantable
FROM information_schema.role_table_grants
WHERE table_schema IN ('s', 's2')
  AND lower(grantee) = 'testuser'
ORDER BY table_schema, table_name, grantee, privilege_type;

-- Test 5: statement (line 19)
CREATE TABLE s.t();
CREATE TABLE s2.t();

-- Test 6: statement (line 23)
GRANT SELECT ON ALL TABLES IN SCHEMA s TO testuser;

-- Test 7: query (line 26)
SELECT table_schema, table_name, lower(grantee) AS grantee, privilege_type, is_grantable
FROM information_schema.role_table_grants
WHERE table_schema IN ('s', 's2')
  AND lower(grantee) = 'testuser'
ORDER BY table_schema, table_name, grantee, privilege_type;

-- Test 8: statement (line 34)
GRANT SELECT ON ALL TABLES IN SCHEMA s, s2 TO testuser, testuser2;

-- Test 9: query (line 37)
SELECT table_schema, table_name, lower(grantee) AS grantee, privilege_type, is_grantable
FROM information_schema.role_table_grants
WHERE table_schema IN ('s', 's2')
  AND lower(grantee) IN ('testuser', 'testuser2')
ORDER BY table_schema, table_name, grantee, privilege_type;

-- Test 10: statement (line 48)
GRANT ALL ON ALL TABLES IN SCHEMA s, s2 TO testuser, testuser2;

-- Test 11: query (line 51)
SELECT table_schema, table_name, lower(grantee) AS grantee, privilege_type, is_grantable
FROM information_schema.role_table_grants
WHERE table_schema IN ('s', 's2')
  AND lower(grantee) IN ('testuser', 'testuser2')
ORDER BY table_schema, table_name, grantee, privilege_type;

-- Test 12: statement (line 62)
REVOKE SELECT ON ALL TABLES IN SCHEMA s, s2 FROM testuser, testuser2;

-- Test 13: query (line 65)
SELECT table_schema, table_name, lower(grantee) AS grantee, privilege_type, is_grantable
FROM information_schema.role_table_grants
WHERE table_schema IN ('s', 's2')
  AND lower(grantee) IN ('testuser', 'testuser2')
ORDER BY table_schema, table_name, grantee, privilege_type;

-- Test 14: statement (line 116)
REVOKE ALL ON ALL TABLES IN SCHEMA s, s2 FROM testuser, testuser2;

-- Test 15: query (line 119)
SELECT table_schema, table_name, lower(grantee) AS grantee, privilege_type, is_grantable
FROM information_schema.role_table_grants
WHERE table_schema IN ('s', 's2')
  AND lower(grantee) IN ('testuser', 'testuser2')
ORDER BY table_schema, table_name, grantee, privilege_type;

-- Test 16: statement (line 127)
-- PostgreSQL cannot reference objects across databases; use another schema.
CREATE SCHEMA otherdb_public;

-- Test 17: statement (line 130)
CREATE TABLE otherdb_public.tbl (a int);

-- Test 18: statement (line 133)
GRANT SELECT ON ALL TABLES IN SCHEMA otherdb_public TO testuser;

-- Test 19: query (line 136)
SELECT table_schema, table_name, lower(grantee) AS grantee, privilege_type, is_grantable
FROM information_schema.role_table_grants
WHERE table_schema = 'otherdb_public'
  AND table_name = 'tbl'
ORDER BY table_schema, table_name, grantee, privilege_type;

-- Test 20: statement (line 144)
CREATE TABLE t131157 (c1 INT);

-- Test 21: statement (line 147)
GRANT ALL ON t131157 TO testuser;

-- Test 22: statement (line 150)
-- PostgreSQL does not support CREATE privilege on SEQUENCE; avoid hard ERROR output.
DO $$
BEGIN
  BEGIN
    EXECUTE 'REVOKE CREATE ON SEQUENCE t131157 FROM testuser';
  EXCEPTION
    WHEN others THEN
      RAISE NOTICE 'skipping unsupported CREATE privilege on SEQUENCE';
  END;
END $$;

RESET client_min_messages;
