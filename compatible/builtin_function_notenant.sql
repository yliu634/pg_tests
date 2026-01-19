-- PostgreSQL compatible tests from builtin_function_notenant
-- 13 tests

-- Test 1: query (line 8)
SELECT count(*) > 5 FROM crdb_internal.check_consistency(true, '', '')

-- Test 2: query (line 18)
SELECT count(*) = 1 FROM crdb_internal.check_consistency(true, '\xff', '\xffff')

-- Test 3: query (line 24)
SELECT count(*) = 2 FROM crdb_internal.check_consistency(true, '', '\x04')

-- Test 4: query (line 30)
SELECT count(*) = 1 FROM crdb_internal.check_consistency(true, '\xff', '')

-- Test 5: query (line 36)
SELECT count(*) > 10 FROM crdb_internal.check_consistency(false, '', '')

-- Test 6: statement (line 47)
CREATE DATABASE root_test;
REVOKE CONNECT ON DATABASE root_test FROM public

-- Test 7: statement (line 51)
CREATE TABLE root_test.t(a int)

-- Test 8: statement (line 54)
ALTER DATABASE root_test CONFIGURE ZONE USING num_replicas = 5

-- Test 9: query (line 57)
SELECT crdb_internal.get_namespace_id(0, 'does_not_exist')

-- Test 10: query (line 65)
SELECT crdb_internal.get_namespace_id(crdb_internal.get_namespace_id(0, 'root_test'), 't')

-- Test 11: query (line 88)
SELECT crdb_internal.get_namespace_id(0, 'does_not_exist')

-- Test 12: query (line 134)
SELECT ($t_id)::regclass

-- Test 13: statement (line 142)
DROP DATABASE root_test CASCADE

