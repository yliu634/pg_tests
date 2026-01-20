-- PostgreSQL compatible tests from drop_procedure
-- 43 tests

-- Test 1: statement (line 1)
CREATE PROCEDURE p_test_drop() LANGUAGE SQL AS 'SELECT 1'

-- Test 2: statement (line 4)
CREATE PROCEDURE p_test_drop(int) LANGUAGE SQL AS 'SELECT 1'

-- Test 3: statement (line 7)
CREATE SCHEMA sc1

-- Test 4: statement (line 10)
CREATE PROCEDURE sc1.p_test_drop(int) LANGUAGE SQL AS 'SELECT 1'

-- Test 5: statement (line 13)
SET search_path = public,sc1

-- Test 6: query (line 16)
SELECT create_statement FROM [SHOW CREATE PROCEDURE public.p_test_drop] ORDER BY 1

-- Test 7: query (line 32)
SELECT create_statement FROM [SHOW CREATE PROCEDURE sc1.p_test_drop]

-- Test 8: statement (line 42)
DROP FUNCTION p_test_drop

-- Test 9: statement (line 45)
DROP PROCEDURE p_test_drop

-- Test 10: statement (line 48)
DROP PROCEDURE IF EXISTS p_not_existing

-- Test 11: statement (line 51)
DROP PROCEDURE p_not_existing

-- Test 12: statement (line 54)
SET autocommit_before_ddl = false

-- Test 13: statement (line 58)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
DROP PROCEDURE p_test_drop();
DROP PROCEDURE p_test_drop();
COMMIT;

-- Test 14: statement (line 64)
ROLLBACK

-- Test 15: statement (line 67)
RESET autocommit_before_ddl

-- Test 16: statement (line 70)
DROP FUNCTION p_test_drop

-- Test 17: statement (line 73)
DROP FUNCTION IF EXISTS p_test_drop

-- Test 18: statement (line 76)
DROP FUNCTION p_test_drop()

-- Test 19: statement (line 79)
DROP FUNCTION IF EXISTS p_test_drop()

-- Test 20: statement (line 82)
DROP PROCEDURE IF EXISTS p_test_drop()

-- Test 21: statement (line 85)
CALL p_test_drop()

-- Test 22: query (line 88)
SELECT create_statement FROM [SHOW CREATE PROCEDURE public.p_test_drop]

-- Test 23: query (line 98)
SELECT create_statement FROM [SHOW CREATE PROCEDURE sc1.p_test_drop]

-- Test 24: statement (line 110)
DROP PROCEDURE p_test_drop(INT), p_test_drop(INT)

-- Test 25: statement (line 113)
CALL public.p_test_drop(1)

-- Test 26: statement (line 116)
SELECT create_statement FROM [SHOW CREATE PROCEDURE public.p_test_drop]

-- Test 27: query (line 119)
SELECT create_statement FROM [SHOW CREATE PROCEDURE sc1.p_test_drop]

-- Test 28: statement (line 129)
DROP PROCEDURE p_test_drop(INT)

-- Test 29: statement (line 132)
CALL p_test_drop(1)

-- Test 30: statement (line 135)
SELECT create_statement FROM [SHOW CREATE PROCEDURE sc1.p_test_drop]

-- Test 31: statement (line 140)
CREATE PROCEDURE public.p_test_drop() LANGUAGE SQL AS $$ SELECT 1 $$;
CREATE PROCEDURE sc1.p_test_drop() LANGUAGE SQL AS $$ SELECT 1 $$;

-- Test 32: query (line 144)
SELECT create_statement FROM [SHOW CREATE PROCEDURE public.p_test_drop]

-- Test 33: query (line 154)
SELECT create_statement FROM [SHOW CREATE PROCEDURE sc1.p_test_drop]

-- Test 34: statement (line 164)
BEGIN;
DROP PROCEDURE p_test_drop();
DROP PROCEDURE p_test_drop();
COMMIT;

-- Test 35: statement (line 170)
SELECT create_statement FROM [SHOW CREATE PROCEDURE public.p_test_drop]

-- Test 36: statement (line 173)
SELECT create_statement FROM [SHOW CREATE PROCEDURE sc1.p_test_drop]

-- Test 37: statement (line 176)
SET search_path = public

-- Test 38: statement (line 179)
DROP SCHEMA sc1

-- Test 39: statement (line 186)
CREATE TYPE t114677 AS (x INT, y INT);

-- Test 40: statement (line 189)
CREATE PROCEDURE p114677(v t114677) LANGUAGE SQL AS $$ SELECT 0; $$;

-- Test 41: statement (line 192)
DROP PROCEDURE p114677(t114677);

-- Test 42: statement (line 199)
CREATE PROCEDURE p142886(p VARCHAR(10)) LANGUAGE SQL AS $$ SELECT 0; $$;

-- Test 43: statement (line 202)
DROP PROCEDURE p142886(VARCHAR);

