-- PostgreSQL compatible tests from udf_privileges_mutations
-- 24 tests

SET client_min_messages = warning;

-- Test 1: statement (line 3)
CREATE TABLE t (a INT, b INT);
CREATE FUNCTION f_insert() RETURNS VOID LANGUAGE SQL AS $$ INSERT INTO t VALUES (1,2); $$;
CREATE FUNCTION f_select() RETURNS INT LANGUAGE SQL AS $$ SELECT b FROM t WHERE a = 1; $$;
CREATE FUNCTION f_update() RETURNS VOID LANGUAGE SQL AS $$ UPDATE t SET b = 3 WHERE a = 1; $$;
CREATE FUNCTION f_delete() RETURNS VOID LANGUAGE SQL AS $$ DELETE FROM t WHERE a = 1; $$;
DROP ROLE IF EXISTS test_user;
CREATE USER test_user;

-- Test 2: statement (line 11)
SET ROLE test_user;

-- Test 3: statement (line 14)
DO $$
BEGIN
  PERFORM f_insert();
  RAISE NOTICE 'unexpected success: f_insert';
EXCEPTION
  WHEN insufficient_privilege THEN
    RAISE NOTICE 'expected insufficient_privilege: f_insert';
END $$;

-- Test 4: statement (line 17)
DO $$
BEGIN
  PERFORM f_select();
  RAISE NOTICE 'unexpected success: f_select';
EXCEPTION
  WHEN insufficient_privilege THEN
    RAISE NOTICE 'expected insufficient_privilege: f_select';
END $$;

-- Test 5: statement (line 20)
DO $$
BEGIN
  PERFORM f_update();
  RAISE NOTICE 'unexpected success: f_update';
EXCEPTION
  WHEN insufficient_privilege THEN
    RAISE NOTICE 'expected insufficient_privilege: f_update';
END $$;

-- Test 6: statement (line 23)
DO $$
BEGIN
  PERFORM f_delete();
  RAISE NOTICE 'unexpected success: f_delete';
EXCEPTION
  WHEN insufficient_privilege THEN
    RAISE NOTICE 'expected insufficient_privilege: f_delete';
END $$;

-- Test 7: statement (line 26)
RESET ROLE;

-- Test 8: statement (line 29)
GRANT SELECT, INSERT, DELETE, UPDATE ON t TO test_user;

-- Test 9: statement (line 32)
SET ROLE test_user;

-- Test 10: statement (line 36)
SELECT f_insert();

-- Test 11: query (line 39)
SELECT f_select();

-- Test 12: statement (line 44)
SELECT f_update();

-- Test 13: query (line 47)
SELECT * FROM t;

-- Test 14: statement (line 52)
SELECT f_delete();

-- Test 15: query (line 55)
SELECT * FROM t;

-- Test 16: statement (line 59)
RESET ROLE;

-- Test 17: statement (line 62)
REVOKE SELECT, INSERT, DELETE, UPDATE ON t FROM test_user;

-- Test 18: statement (line 65)
SET ROLE test_user;

-- Test 19: statement (line 68)
DO $$
BEGIN
  PERFORM f_select();
  RAISE NOTICE 'unexpected success: f_select';
EXCEPTION
  WHEN insufficient_privilege THEN
    RAISE NOTICE 'expected insufficient_privilege: f_select';
END $$;

-- Test 20: statement (line 71)
DO $$
BEGIN
  PERFORM f_insert();
  RAISE NOTICE 'unexpected success: f_insert';
EXCEPTION
  WHEN insufficient_privilege THEN
    RAISE NOTICE 'expected insufficient_privilege: f_insert';
END $$;

-- Test 21: statement (line 74)
DO $$
BEGIN
  PERFORM f_update();
  RAISE NOTICE 'unexpected success: f_update';
EXCEPTION
  WHEN insufficient_privilege THEN
    RAISE NOTICE 'expected insufficient_privilege: f_update';
END $$;

-- Test 22: statement (line 77)
DO $$
BEGIN
  PERFORM f_delete();
  RAISE NOTICE 'unexpected success: f_delete';
EXCEPTION
  WHEN insufficient_privilege THEN
    RAISE NOTICE 'expected insufficient_privilege: f_delete';
END $$;

-- Test 23: statement (line 80)
RESET ROLE;

-- Test 24: statement (line 83)
DROP FUNCTION f_insert;
DROP FUNCTION f_select;
DROP FUNCTION f_update;
DROP FUNCTION f_delete;
DROP USER test_user;
