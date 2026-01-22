-- PostgreSQL compatible tests from procedure_privileges
-- 15 tests
BEGIN;

-- Test 1: statement (line 7)
CREATE SCHEMA test_priv_sc1;
SET search_path = public, test_priv_sc1;

-- Test 2: statement (line 11)
CREATE PROCEDURE test_priv_p1() LANGUAGE SQL AS $$ SELECT 1 $$;
CREATE PROCEDURE test_priv_p2(IN i INT) LANGUAGE SQL AS $$ SELECT i $$;
CREATE PROCEDURE test_priv_sc1.test_priv_p3() LANGUAGE SQL AS $$ SELECT 1 $$;

-- Test 3: statement (line 17)
CREATE ROLE test_grantee_proc_priv;

-- Test 4: query (line 20)
-- Default routine privileges in PostgreSQL are visible via information_schema.
SELECT
  grantor,
  grantee,
  routine_schema,
  routine_name,
  privilege_type,
  is_grantable
FROM information_schema.routine_privileges
WHERE routine_schema IN ('public', 'test_priv_sc1')
  AND routine_name IN ('test_priv_p1', 'test_priv_p2', 'test_priv_p3')
ORDER BY grantee, routine_schema, routine_name, privilege_type;

-- Test 5: statement (line 35)
GRANT EXECUTE ON PROCEDURE
  test_priv_p1(),
  test_priv_p2(INT),
  test_priv_sc1.test_priv_p3()
TO test_grantee_proc_priv WITH GRANT OPTION;

-- Test 6: query (line 43)
SELECT
  grantor,
  grantee,
  routine_schema,
  routine_name,
  privilege_type,
  is_grantable
FROM information_schema.routine_privileges
WHERE routine_schema IN ('public', 'test_priv_sc1')
  AND routine_name IN ('test_priv_p1', 'test_priv_p2', 'test_priv_p3')
  AND grantee = 'test_grantee_proc_priv'
ORDER BY routine_schema, routine_name, privilege_type;

-- Test 7: statement (line 58)
REVOKE GRANT OPTION FOR EXECUTE ON PROCEDURE
  test_priv_p1(),
  test_priv_p2(INT),
  test_priv_sc1.test_priv_p3()
FROM test_grantee_proc_priv;

-- Test 8: query (line 66)
SELECT
  grantor,
  grantee,
  routine_schema,
  routine_name,
  privilege_type,
  is_grantable
FROM information_schema.routine_privileges
WHERE routine_schema IN ('public', 'test_priv_sc1')
  AND routine_name IN ('test_priv_p1', 'test_priv_p2', 'test_priv_p3')
  AND grantee = 'test_grantee_proc_priv'
ORDER BY routine_schema, routine_name, privilege_type;

-- Test 9: statement (line 81)
REVOKE EXECUTE ON PROCEDURE
  test_priv_p1(),
  test_priv_p2(INT),
  test_priv_sc1.test_priv_p3()
FROM test_grantee_proc_priv;

-- Test 10: query (line 89)
SELECT count(*)
FROM information_schema.routine_privileges
WHERE routine_schema IN ('public', 'test_priv_sc1')
  AND routine_name IN ('test_priv_p1', 'test_priv_p2', 'test_priv_p3')
  AND grantee = 'test_grantee_proc_priv';

-- Test 11: statement (line 97)
GRANT EXECUTE ON ALL PROCEDURES IN SCHEMA public, test_priv_sc1 TO test_grantee_proc_priv;

-- Test 12: query (line 100)
SELECT
  grantor,
  grantee,
  routine_schema,
  routine_name,
  privilege_type,
  is_grantable
FROM information_schema.routine_privileges
WHERE routine_schema IN ('public', 'test_priv_sc1')
  AND routine_name IN ('test_priv_p1', 'test_priv_p2', 'test_priv_p3')
  AND grantee = 'test_grantee_proc_priv'
ORDER BY routine_schema, routine_name, privilege_type;

-- Test 13: query (line 115)
-- PostgreSQL equivalent of CockroachDB SHOW PROCEDURES.
SELECT
  routine_schema,
  routine_name,
  specific_name
FROM information_schema.routines
WHERE routine_type = 'PROCEDURE'
  AND routine_schema IN ('public', 'test_priv_sc1')
  AND routine_name LIKE 'test_priv_%'
ORDER BY routine_schema, routine_name, specific_name;

-- Test 14: query (line 127)
SELECT has_function_privilege('test_grantee_proc_priv', 'test_priv_p2(INT)', 'EXECUTE');

-- Test 15: statement (line 130)
ROLLBACK;
