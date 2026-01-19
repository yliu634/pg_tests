-- PostgreSQL compatible tests from drop_function
-- 84 tests

-- Test 1: statement (line 1)
CREATE FUNCTION f_test_drop() RETURNS INT LANGUAGE SQL AS $$ SELECT 1 $$;

-- Test 2: statement (line 4)
CREATE FUNCTION f_test_drop(int) RETURNS INT LANGUAGE SQL AS $$ SELECT 1 $$;

-- Test 3: statement (line 7)
CREATE SCHEMA sc1

-- Test 4: statement (line 10)
CREATE FUNCTION sc1.f_test_drop(int) RETURNS INT LANGUAGE SQL AS $$ SELECT 1 $$;

-- Test 5: statement (line 13)
SET search_path = public,sc1

-- Test 6: query (line 16)
SELECT create_statement FROM [SHOW CREATE FUNCTION public.f_test_drop] ORDER BY 1

-- Test 7: query (line 40)
SELECT create_statement FROM [SHOW CREATE FUNCTION sc1.f_test_drop];

-- Test 8: statement (line 54)
DROP PROCEDURE f_test_drop;

-- Test 9: statement (line 57)
DROP FUNCTION f_test_drop;

-- Test 10: statement (line 60)
DROP FUNCTION IF EXISTS f_not_existing;

-- Test 11: statement (line 63)
DROP FUNCTION f_not_existing;

-- Test 12: statement (line 66)
SET autocommit_before_ddl = false

-- Test 13: statement (line 70)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
DROP FUNCTION f_test_drop();
DROP FUNCTION f_test_drop();
COMMIT;

-- Test 14: statement (line 76)
ROLLBACK;

-- Test 15: statement (line 79)
RESET autocommit_before_ddl

-- Test 16: statement (line 82)
DROP PROCEDURE f_test_drop

-- Test 17: statement (line 85)
DROP PROCEDURE IF EXISTS f_test_drop

-- Test 18: statement (line 88)
DROP PROCEDURE f_test_drop()

-- Test 19: statement (line 91)
DROP PROCEDURE IF EXISTS f_test_drop()

-- Test 20: statement (line 94)
DROP FUNCTION f_test_drop()

-- Test 21: query (line 97)
SELECT create_statement FROM [SHOW CREATE FUNCTION public.f_test_drop];

-- Test 22: query (line 111)
SELECT create_statement FROM [SHOW CREATE FUNCTION sc1.f_test_drop];

-- Test 23: statement (line 127)
DROP FUNCTION f_test_drop(INT), f_test_drop(INT);

-- Test 24: statement (line 130)
SELECT create_statement FROM [SHOW CREATE FUNCTION public.f_test_drop];

-- Test 25: query (line 133)
SELECT create_statement FROM [SHOW CREATE FUNCTION sc1.f_test_drop];

-- Test 26: statement (line 147)
DROP FUNCTION f_test_drop(INT);

-- Test 27: statement (line 150)
SELECT create_statement FROM [SHOW CREATE FUNCTION sc1.f_test_drop];

-- Test 28: statement (line 155)
CREATE FUNCTION public.f_test_drop() RETURNS INT LANGUAGE SQL AS $$ SELECT 1 $$;
CREATE FUNCTION sc1.f_test_drop() RETURNS INT LANGUAGE SQL AS $$ SELECT 1 $$;

-- Test 29: query (line 159)
SELECT create_statement FROM [SHOW CREATE FUNCTION public.f_test_drop];

-- Test 30: query (line 173)
SELECT create_statement FROM [SHOW CREATE FUNCTION sc1.f_test_drop];

-- Test 31: statement (line 187)
BEGIN;
DROP FUNCTION f_test_drop();
DROP FUNCTION f_test_drop();
COMMIT;

-- Test 32: statement (line 193)
SELECT create_statement FROM [SHOW CREATE FUNCTION public.f_test_drop];

-- Test 33: statement (line 196)
SELECT create_statement FROM [SHOW CREATE FUNCTION sc1.f_test_drop];

-- Test 34: statement (line 199)
SET search_path = public

-- Test 35: statement (line 202)
DROP SCHEMA sc1;

-- Test 36: statement (line 209)
CREATE TYPE t114677 AS (x INT, y INT);
CREATE TYPE t114677_2 AS (a INT, b INT);

-- Test 37: statement (line 215)
CREATE FUNCTION f114677(v t114677) RETURNS INT LANGUAGE SQL AS $$ SELECT 0; $$;
CREATE FUNCTION f114677(v t114677_2) RETURNS INT LANGUAGE SQL AS $$ SELECT 1; $$;

-- Test 38: query (line 219)
SELECT create_statement FROM [SHOW CREATE FUNCTION f114677] ORDER BY create_statement;

-- Test 39: statement (line 243)
DROP FUNCTION f114677;

-- Test 40: statement (line 246)
DROP FUNCTION f114677(t114677);

-- Test 41: query (line 249)
SELECT create_statement FROM [SHOW CREATE FUNCTION f114677];

-- Test 42: statement (line 263)
DROP FUNCTION f114677;

-- Test 43: statement (line 266)
SHOW CREATE FUNCTION f114677;

-- Test 44: statement (line 274)
CREATE FUNCTION f_called_by_b() RETURNS INT LANGUAGE SQL AS $$ SELECT 1 $$;

-- Test 45: statement (line 277)
CREATE FUNCTION f_called_by_b2() RETURNS INT LANGUAGE SQL AS $$ SELECT 1 + f_called_by_b() $$;

-- Test 46: statement (line 280)
CREATE FUNCTION f_b()  RETURNS INT LANGUAGE SQL AS $$ SELECT (f_called_by_b2()) /f_called_by_b2() FROM f_called_by_b() $$;

-- Test 47: statement (line 283)
DROP FUNCTION f_called_by_b;

-- Test 48: statement (line 286)
DROP FUNCTION f_called_by_b2;

-- Test 49: statement (line 289)
CREATE OR REPLACE FUNCTION f_b()  RETURNS INT LANGUAGE SQL AS $$ SELECT 1 $$;

-- Test 50: statement (line 292)
DROP FUNCTION f_called_by_b;

-- Test 51: statement (line 295)
DROP FUNCTION f_called_by_b;

-- Test 52: statement (line 299)
CREATE SCHEMA altSchema;
CREATE FUNCTION altSchema.f_called_by_b() RETURNS INT LANGUAGE SQL AS $$ SELECT 1 $$;

-- Test 53: statement (line 303)
CREATE TABLE t1_with_b_2_ref(j int default altSchema.f_called_by_b() CHECK (altSchema.f_called_by_b() > 0));

-- Test 54: statement (line 306)
ALTER FUNCTION f_called_by_b SET SCHEMA altSchema;

skipif config local-legacy-schema-changer

-- Test 55: statement (line 310)
DROP SCHEMA altSchema CASCADE;

onlyif config local-legacy-schema-changer

-- Test 56: statement (line 314)
DROP SCHEMA altSchema CASCADE;

-- Test 57: statement (line 317)
SELECT * FROM  f_called_by_b2();

skipif config local-legacy-schema-changer
onlyif config schema-locked-disabled

-- Test 58: query (line 322)
SELECT create_statement FROM [SHOW CREATE TABLE t1_with_b_2_ref];

-- Test 59: query (line 333)
SELECT create_statement FROM [SHOW CREATE TABLE t1_with_b_2_ref];

-- Test 60: statement (line 343)
DROP FUNCTION f_called_by_b2;
DROP TABLE t1_with_b_2_ref;

-- Test 61: statement (line 347)
SET ROLE testuser;

-- Test 62: statement (line 352)
DROP FUNCTION f_b();

-- Test 63: statement (line 355)
SET ROLE root;

-- Test 64: statement (line 358)
DROP FUNCTION f_b;

-- Test 65: statement (line 361)
CREATE FUNCTION f_char(c CHAR) RETURNS INT LANGUAGE SQL AS 'SELECT 1'

-- Test 66: statement (line 364)
DROP FUNCTION f_char(BPCHAR)

-- Test 67: statement (line 367)
CREATE FUNCTION f_char(c CHAR(2)) RETURNS INT LANGUAGE SQL AS 'SELECT 1'

-- Test 68: statement (line 370)
DROP FUNCTION f_char(BPCHAR)

-- Test 69: statement (line 373)
CREATE FUNCTION f_char(c BPCHAR) RETURNS INT LANGUAGE SQL AS 'SELECT 1'

-- Test 70: statement (line 376)
DROP FUNCTION f_char(BPCHAR)

-- Test 71: statement (line 379)
CREATE FUNCTION f_char(c BPCHAR) RETURNS INT LANGUAGE SQL AS 'SELECT 1'

-- Test 72: statement (line 382)
DROP FUNCTION f_char(CHAR)

-- Test 73: statement (line 385)
CREATE FUNCTION f_char(c BPCHAR) RETURNS INT LANGUAGE SQL AS 'SELECT 1'

-- Test 74: statement (line 388)
DROP FUNCTION f_char(CHAR(2))

-- Test 75: statement (line 391)
CREATE FUNCTION f_bit(c BIT) RETURNS INT LANGUAGE SQL AS 'SELECT 1'

-- Test 76: statement (line 394)
DROP FUNCTION f_bit(BIT(0))

-- Test 77: statement (line 397)
CREATE FUNCTION f_bit(c BIT(2)) RETURNS INT LANGUAGE SQL AS 'SELECT 1'

-- Test 78: statement (line 400)
DROP FUNCTION f_bit(BIT(0))

-- Test 79: statement (line 403)
CREATE FUNCTION f_bit(c BIT(0)) RETURNS INT LANGUAGE SQL AS 'SELECT 1'

-- Test 80: statement (line 406)
DROP FUNCTION f_bit(BIT(0))

-- Test 81: statement (line 409)
CREATE FUNCTION f_bit(c BIT(0)) RETURNS INT LANGUAGE SQL AS 'SELECT 1'

-- Test 82: statement (line 412)
DROP FUNCTION f_bit(BIT(2))

-- Test 83: statement (line 417)
CREATE FUNCTION f142886(p VARCHAR(10)) RETURNS INT LANGUAGE SQL AS $$ SELECT 0; $$;

-- Test 84: statement (line 420)
DROP FUNCTION f142886(VARCHAR);

