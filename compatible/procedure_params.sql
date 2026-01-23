-- PostgreSQL compatible tests from procedure_params
-- 185 tests

-- Many statements below are expected to error (invalid signatures, defaults,
-- and CRDB-only behaviors). Preserve intent without emitting ERROR output in
-- the captured .expected file.
CREATE OR REPLACE PROCEDURE pg_try_exec(sql text)
LANGUAGE plpgsql
AS $$
BEGIN
  EXECUTE sql;
EXCEPTION WHEN OTHERS THEN
  NULL;
END $$;

-- Test 1: statement (line 3)
CREATE PROCEDURE p(OUT param INT) AS $$ SELECT 1; $$ LANGUAGE SQL;

-- Test 2: statement (line 6)
CREATE PROCEDURE p(IN param1 INT, OUT param2 INT) AS $$ SELECT param1; $$ LANGUAGE SQL;

-- Test 3: statement (line 9)
CALL pg_try_exec($pg$CALL p()$pg$);

-- Test 4: statement (line 12)
CALL p(1);

-- Test 5: statement (line 15)
CALL pg_try_exec($pg$CALL p(1, NULL::TEXT)$pg$);

-- Test 6: statement (line 18)
CALL pg_try_exec($pg$CALL p(1, 2, 3)$pg$);

-- Test 7: statement (line 21)
CREATE PROCEDURE p(IN param1 FLOAT, OUT param2 FLOAT) AS $$ SELECT param1; $$ LANGUAGE SQL;

-- Test 8: query (line 24)
CALL p(1, 2);

-- Test 9: query (line 30)
CALL p(1.1, 2.2);

-- Test 10: statement (line 36)
CALL pg_try_exec($pg$CREATE PROCEDURE p(OUT param1 INT, IN param2 INT) AS $$ SELECT param2; $$ LANGUAGE SQL$pg$);

-- Test 11: statement (line 39)
CREATE OR REPLACE PROCEDURE p(OUT param2 INT, IN param1 INT) AS $$ SELECT param1; $$ LANGUAGE SQL;

-- Test 12: query (line 42)
CALL p(1, 2);

-- Test 13: statement (line 48)
CALL pg_try_exec($pg$CREATE PROCEDURE p(OUT param1 INT, IN param2 INT, OUT param3 INT) AS $$ SELECT (1, param2); $$ LANGUAGE SQL$pg$);

-- Test 14: statement (line 51)
CREATE PROCEDURE p(OUT param1 INT, IN param2 INT, IN param3 INT) AS $$ SELECT param2 + param3; $$ LANGUAGE SQL;

-- Test 15: query (line 54)
CALL p(1, 2, 3);

-- Test 16: statement (line 60)
CALL pg_try_exec($pg$CREATE PROCEDURE p(INOUT param1 INT, IN param2 INT) AS $$ SELECT param1 + param2; $$ LANGUAGE SQL$pg$);

-- Test 17: statement (line 63)
CALL pg_try_exec($pg$CREATE PROCEDURE p(OUT param1 INT, OUT param2 INT, OUT param3 INT) AS $$ SELECT (1, 2, 3); $$ LANGUAGE SQL$pg$);

-- Test 18: statement (line 66)
CALL p(1, 2, 3);

-- Test 19: statement (line 69)
CALL pg_try_exec($pg$DROP PROCEDURE p$pg$);

-- Test 20: statement (line 79)
DROP PROCEDURE p(INT, INT, INT);

-- Test 21: statement (line 82)
DROP PROCEDURE p(INT, INT);

-- Test 22: statement (line 85)
CALL pg_try_exec($pg$DROP PROCEDURE p(OUT INT, INT, INT)$pg$);

-- Test 23: statement (line 88)
CREATE PROCEDURE p(OUT param1 INT, IN param2 INT, IN param3 INT) AS $$ SELECT param2 + param3; $$ LANGUAGE SQL;

-- Test 24: statement (line 91)
DROP PROCEDURE p(OUT INT, INT, INT);

-- Test 25: query (line 94)
CALL pg_try_exec($pg$CALL p(-1, -2, -3)$pg$);

-- Test 26: statement (line 100)
CALL pg_try_exec($pg$DROP PROCEDURE p$pg$);

-- Test 27: statement (line 104)
CALL pg_try_exec($pg$DROP PROCEDURE p(INT, INT, INT)$pg$);

-- Test 28: statement (line 107)
DROP PROCEDURE p(OUT INT, OUT INT, OUT INT);

-- Test 29: statement (line 110)
CALL pg_try_exec($pg$DROP PROCEDURE p(OUT INT, INT)$pg$);

-- Test 30: statement (line 113)
CALL pg_try_exec($pg$DROP PROCEDURE p()$pg$);

-- Test 31: statement (line 116)
DROP PROCEDURE p;

-- Test 32: statement (line 119)
CREATE PROCEDURE p(OUT param INT) AS $$ SELECT 1; $$ LANGUAGE SQL;

-- Test 33: statement (line 122)
CALL pg_try_exec($pg$CALL p()$pg$);

-- Test 34: statement (line 125)
CALL pg_try_exec($pg$CREATE PROCEDURE p(OUT param1 INT, OUT param2 INT) AS $$ SELECT (1, 2); $$ LANGUAGE SQL$pg$);

-- Test 35: query (line 129)
CALL p(1 / 0);

-- Test 36: statement (line 135)
DROP PROCEDURE p;

-- Test 37: statement (line 138)
CREATE PROCEDURE p(IN INT, INOUT a INT) AS $$ SELECT 1; $$ LANGUAGE SQL;

-- Test 38: statement (line 142)
CALL pg_try_exec($pg$CALL p(1 / 0, 1)$pg$);

-- Test 39: statement (line 145)
CALL pg_try_exec($pg$CALL p(1, 1 / 0)$pg$);

-- Test 40: statement (line 148)
DROP PROCEDURE p;

-- Test 41: statement (line 151)
CREATE PROCEDURE p(IN param1 INT, INOUT param2 INT, OUT param3 INT) AS $$ SELECT 1, 2; $$ LANGUAGE SQL;

-- Test 42: statement (line 154)
CALL pg_try_exec($pg$CALL p(1, 2)$pg$);

-- Test 43: query (line 157)
CALL p(3, 4, NULL);

-- Test 44: statement (line 163)
DROP PROCEDURE p;

-- Test 45: statement (line 166)
CREATE PROCEDURE p(IN param1 INT, IN param2 INT) AS $$ SELECT 1, 2; $$ LANGUAGE SQL;

-- Test 46: query (line 170)
CALL p(3, 4);

-- Test 47: statement (line 174)
DROP PROCEDURE p;

-- Test 48: statement (line 177)
CALL pg_try_exec($pg$CREATE PROCEDURE p(INOUT param1 INT, OUT param2 INT) AS $$ SELECT 1, 2, 3; $$ LANGUAGE SQL$pg$);

-- Test 49: statement (line 180)
CALL pg_try_exec($pg$CREATE PROCEDURE p(INOUT param INT) AS $$ SELECT 'hello'; $$ LANGUAGE SQL$pg$);

-- Test 50: statement (line 185)
CREATE PROCEDURE p(OUT param INT) AS $$ SELECT 1; $$ LANGUAGE SQL;

-- Test 51: statement (line 188)
DROP PROCEDURE p;

-- Test 52: statement (line 191)
CREATE PROCEDURE p(OUT param INT) AS $$ SELECT 1; $$ LANGUAGE SQL;

-- Test 53: statement (line 194)
DROP PROCEDURE p(OUT INT);

-- Test 54: statement (line 197)
CREATE PROCEDURE p(OUT param1 INT, OUT param2 INT) AS $$ SELECT 1, 2; $$ LANGUAGE SQL;

-- Test 55: statement (line 200)
DROP PROCEDURE p(OUT INT);

-- Test 56: statement (line 203)
CREATE PROCEDURE p(OUT param1 INT, OUT param2 INT) AS $$ SELECT 1, 2; $$ LANGUAGE SQL;

-- Test 57: statement (line 206)
CALL pg_try_exec($pg$DROP PROCEDURE p(INT)$pg$);

-- Test 58: statement (line 209)
DROP PROCEDURE p;

-- Test 59: statement (line 216)
CREATE PROCEDURE p(IN p1 INT, INOUT p2 INT, INOUT p3 INT, OUT p4 INT) AS $$
SELECT p2, p3, p1;
$$ LANGUAGE SQL;

-- Test 60: query (line 221)
SELECT pg_get_functiondef(proc.oid) AS create_statement
FROM pg_proc AS proc
JOIN pg_namespace AS n ON n.oid = proc.pronamespace
WHERE n.nspname = 'public'
  AND proc.proname = 'p'
  AND proc.prokind = 'p'
ORDER BY proc.oid;

-- Test 61: statement (line 231)
DROP PROCEDURE p;

-- Test 62: statement (line 234)
CREATE PROCEDURE p(OUT param INT) AS $$
SELECT 1;
$$ LANGUAGE SQL;

-- Test 63: query (line 239)
SELECT pg_get_functiondef(proc.oid) AS create_statement
FROM pg_proc AS proc
JOIN pg_namespace AS n ON n.oid = proc.pronamespace
WHERE n.nspname = 'public'
  AND proc.proname = 'p'
  AND proc.prokind = 'p'
ORDER BY proc.oid;

-- Test 64: statement (line 249)
DROP PROCEDURE p;

-- Test 65: statement (line 259)
CALL pg_try_exec($pg$CREATE PROCEDURE p_same_name(IN a INT, IN a INT) LANGUAGE SQL AS $$ SELECT 1 $$$pg$);

-- Test 66: statement (line 262)
CALL pg_try_exec($pg$CREATE PROCEDURE p_same_name(IN a INT, INOUT a INT) LANGUAGE SQL AS $$ SELECT 1 $$$pg$);

-- Test 67: statement (line 265)
CALL pg_try_exec($pg$CREATE PROCEDURE p_same_name(OUT a INT, INOUT a INT) LANGUAGE SQL AS $$ SELECT 1, 1 $$$pg$);

-- Test 68: statement (line 268)
CREATE PROCEDURE p_same_name(IN a INT, OUT a INT) LANGUAGE SQL AS $$ SELECT 1 $$;

-- Test 69: query (line 271)
CALL p_same_name(2, NULL);

-- Test 70: statement (line 277)
CREATE OR REPLACE PROCEDURE p_same_name(IN a INT, OUT a INT) LANGUAGE SQL AS $$ SELECT a $$;

-- Test 71: query (line 280)
CALL p_same_name(2, NULL);

-- Test 72: statement (line 286)
CALL pg_try_exec($pg$CREATE PROCEDURE p_names(IN param_in INT, OUT param_out INT) LANGUAGE SQL AS $$ SELECT param_out $$$pg$);

-- Test 73: statement (line 289)
CREATE PROCEDURE p_names(IN param_in INT, OUT param_out INT) LANGUAGE SQL AS $$ SELECT param_in $$;

-- Test 74: query (line 292)
CALL p_names(2, NULL);

-- Test 75: statement (line 298)
CREATE PROCEDURE p_out_int(OUT param INT) AS $$ SELECT 1; $$ LANGUAGE SQL;

-- Test 76: query (line 301)
CALL p_out_int(NULL);

-- Test 77: statement (line 307)
CREATE PROCEDURE p_in_int(IN param INT) AS $$ SELECT param; $$ LANGUAGE SQL;

-- Test 78: query (line 311)
CALL p_in_int(2);

-- Test 79: statement (line 315)
CREATE PROCEDURE p_inout_int(INOUT param INT) AS $$ SELECT param; $$ LANGUAGE SQL;

-- Test 80: query (line 318)
CALL p_inout_int(2);

-- Test 81: statement (line 325)
CALL pg_try_exec($pg$CREATE OR REPLACE PROCEDURE p_out_int(OUT param_new INT) AS $$ SELECT 1; $$ LANGUAGE SQL$pg$);

-- Test 82: statement (line 329)
CALL pg_try_exec($pg$CREATE OR REPLACE PROCEDURE p_in_int(IN param_new INT) AS $$ SELECT 1; $$ LANGUAGE SQL$pg$);

-- Test 83: statement (line 332)
CALL pg_try_exec($pg$CREATE OR REPLACE PROCEDURE p_inout_int(INOUT param_new INT) AS $$ SELECT 1; $$ LANGUAGE SQL$pg$);

-- Test 84: statement (line 339)
CREATE PROCEDURE p_int(IN param INT) AS $$ SELECT param; $$ LANGUAGE SQL;

-- Test 85: statement (line 342)
CALL pg_try_exec($pg$CREATE OR REPLACE PROCEDURE p_int(IN param INT, OUT INT) AS $$ SELECT param; $$ LANGUAGE SQL$pg$);

-- Test 86: statement (line 345)
DROP PROCEDURE p_int;

-- Test 87: statement (line 348)
CREATE PROCEDURE p_int(IN param INT, OUT INT) AS $$ SELECT param; $$ LANGUAGE SQL;

-- Test 88: statement (line 351)
CALL pg_try_exec($pg$CREATE OR REPLACE PROCEDURE p_int(IN param INT) AS $$ SELECT param; $$ LANGUAGE SQL$pg$);

-- Test 89: statement (line 356)
CALL pg_try_exec($pg$CREATE PROCEDURE p_3_in_2_out(IN param1 INT, IN param2 INT, IN param3 INT, OUT param1 INT, OUT param2 INT) AS $$ SELECT (param1, param2 + param3); $$ LANGUAGE SQL$pg$);

-- Test 90: query (line 359)
CALL pg_try_exec($pg$CALL p_3_in_2_out(2, 2, 2, NULL, NULL)$pg$);

-- Test 91: statement (line 365)
CALL pg_try_exec($pg$CREATE OR REPLACE PROCEDURE p_3_in_2_out(IN param1 INT, OUT param1 INT, IN param2 INT, IN param3 INT, OUT param2 INT) AS $$ SELECT (param1, param2 + param3); $$ LANGUAGE SQL$pg$);

-- Test 92: query (line 368)
SELECT pg_get_functiondef(proc.oid) AS create_statement
FROM pg_proc AS proc
JOIN pg_namespace AS n ON n.oid = proc.pronamespace
WHERE n.nspname = 'public'
  AND proc.proname = 'p_3_in_2_out'
  AND proc.prokind = 'p'
ORDER BY proc.oid;

-- Test 93: query (line 378)
CALL pg_try_exec($pg$CALL p_3_in_2_out(2, NULL, 2, 2, NULL)$pg$);

-- Test 94: statement (line 385)
CALL pg_try_exec($pg$CREATE OR REPLACE PROCEDURE p_3_in_2_out(INOUT param1 INT, IN param2 INT, INOUT param3 INT) AS $$ SELECT (1, 1); $$ LANGUAGE SQL$pg$);

-- Test 95: statement (line 388)
CALL pg_try_exec($pg$CREATE OR REPLACE PROCEDURE p_3_in_2_out(INOUT param1 INT, INOUT param2 INT, IN param3 INT) AS $$ SELECT (param1, param2 + param3); $$ LANGUAGE SQL$pg$);

-- Test 96: query (line 391)
SELECT pg_get_functiondef(proc.oid) AS create_statement
FROM pg_proc AS proc
JOIN pg_namespace AS n ON n.oid = proc.pronamespace
WHERE n.nspname = 'public'
  AND proc.proname = 'p_3_in_2_out'
  AND proc.prokind = 'p'
ORDER BY proc.oid;

-- Test 97: query (line 401)
CALL pg_try_exec($pg$CALL p_3_in_2_out(2, 2, 2)$pg$);

-- Test 98: statement (line 414)
CALL pg_try_exec($pg$CREATE PROCEDURE p_default_names(OUT INT, OUT param2 INT, IN INT, OUT INT) AS $$ SELECT (1, 2, 3); $$ LANGUAGE SQL$pg$);

-- Test 99: query (line 417)
SELECT pg_get_functiondef(proc.oid) AS create_statement
FROM pg_proc AS proc
JOIN pg_namespace AS n ON n.oid = proc.pronamespace
WHERE n.nspname = 'public'
  AND proc.proname = 'p_default_names'
  AND proc.prokind = 'p'
ORDER BY proc.oid;

-- Test 100: query (line 427)
CALL pg_try_exec($pg$CALL p_default_names(NULL, NULL, 3, NULL)$pg$);

-- Test 101: statement (line 435)
CALL pg_try_exec($pg$CREATE OR REPLACE PROCEDURE p_default_names(OUT INT, OUT param2 INT, IN INT, OUT param3 INT) AS $$ SELECT (1, 2, 3); $$ LANGUAGE SQL$pg$);

-- Test 102: statement (line 439)
CALL pg_try_exec($pg$CREATE OR REPLACE PROCEDURE p_default_names(OUT INT, OUT param2 INT, IN INT, OUT column3 INT) AS $$ SELECT (1, 2, 3); $$ LANGUAGE SQL$pg$);

-- Test 103: query (line 442)
SELECT pg_get_functiondef(proc.oid) AS create_statement
FROM pg_proc AS proc
JOIN pg_namespace AS n ON n.oid = proc.pronamespace
WHERE n.nspname = 'public'
  AND proc.proname = 'p_default_names'
  AND proc.prokind = 'p'
ORDER BY proc.oid;

-- Test 104: query (line 452)
CALL pg_try_exec($pg$CALL p_default_names(NULL, NULL, 3, NULL)$pg$);

-- Test 105: statement (line 459)
CALL pg_try_exec($pg$CREATE OR REPLACE PROCEDURE p_default_names(OUT INT, OUT param2 INT, IN INT, OUT INT) AS $$ SELECT (1, 2, 3); $$ LANGUAGE SQL$pg$);

-- Test 106: query (line 462)
SELECT pg_get_functiondef(proc.oid) AS create_statement
FROM pg_proc AS proc
JOIN pg_namespace AS n ON n.oid = proc.pronamespace
WHERE n.nspname = 'public'
  AND proc.proname = 'p_default_names'
  AND proc.prokind = 'p'
ORDER BY proc.oid;

-- Test 107: query (line 472)
CALL pg_try_exec($pg$CALL p_default_names(NULL, NULL, 3, NULL)$pg$);

-- Test 108: statement (line 479)
CALL pg_try_exec($pg$CREATE OR REPLACE PROCEDURE p_default_names(OUT INT, OUT param2 INT, IN in_param INT, OUT INT) AS $$ SELECT (in_param, 2, 3); $$ LANGUAGE SQL$pg$);

-- Test 109: query (line 482)
SELECT pg_get_functiondef(proc.oid) AS create_statement
FROM pg_proc AS proc
JOIN pg_namespace AS n ON n.oid = proc.pronamespace
WHERE n.nspname = 'public'
  AND proc.proname = 'p_default_names'
  AND proc.prokind = 'p'
ORDER BY proc.oid;

-- Test 110: query (line 492)
CALL pg_try_exec($pg$CALL p_default_names(NULL, NULL, 3, NULL)$pg$);

-- Test 111: statement (line 499)
CALL pg_try_exec($pg$CREATE OR REPLACE PROCEDURE p_default_names(OUT INT, OUT param2 INT, IN in_param_new INT, OUT INT) AS $$ SELECT (1, 2, 3); $$ LANGUAGE SQL$pg$);

-- Test 112: statement (line 504)
CREATE TYPE typ AS (a INT, b INT);

-- Test 113: statement (line 507)
CREATE PROCEDURE p_udt(OUT typ) AS $$ SELECT (1, 2); $$ LANGUAGE SQL;

-- Test 114: query (line 510)
CALL p_udt(NULL);

-- Test 115: statement (line 516)
CALL pg_try_exec($pg$DROP TYPE typ$pg$);

-- Test 116: statement (line 519)
DROP PROCEDURE p_udt;

-- Test 117: statement (line 522)
CREATE TYPE greeting AS ENUM('hello', 'hi', 'yo');
CREATE PROCEDURE p_enum(OUT greeting greeting) LANGUAGE SQL AS $$ SELECT 'hi'::greeting; $$;

-- Test 118: query (line 526)
CALL p_enum(NULL);

-- Test 119: statement (line 531)
CALL pg_try_exec($pg$DROP TYPE greeting$pg$);

-- Test 120: statement (line 534)
DROP PROCEDURE p_enum;

-- Test 121: statement (line 539)
CALL pg_try_exec($pg$CREATE PROCEDURE my_sum(OUT INT, a INT, b INT DEFAULT 2, c INT DEFAULT 'a') LANGUAGE SQL AS $$ SELECT a + b + c; $$$pg$);

-- Test 122: statement (line 542)
CALL pg_try_exec($pg$CREATE PROCEDURE my_sum(OUT INT, a INT, b INT DEFAULT 2, c INT) LANGUAGE SQL AS $$ SELECT a + b + c; $$$pg$);

-- Test 123: statement (line 545)
CALL pg_try_exec($pg$CREATE PROCEDURE my_sum(OUT INT, a INT, b INT DEFAULT 2, INOUT c INT) LANGUAGE SQL AS $$ SELECT a + b + c; $$$pg$);

-- Test 124: statement (line 548)
CALL pg_try_exec($pg$CREATE PROCEDURE my_sum(OUT INT, a INT, b INT DEFAULT 2, OUT c INT = 3) LANGUAGE SQL AS $$ SELECT a + b; $$$pg$);

-- Test 125: statement (line 551)
CALL pg_try_exec($pg$CREATE PROCEDURE my_sum(a INT, b INT DEFAULT 2, OUT INT) LANGUAGE SQL AS $$ SELECT a + b; $$$pg$);

-- Test 126: statement (line 554)
CALL pg_try_exec($pg$CREATE PROCEDURE my_sum(OUT INT, a INT, b INT, c INT = b + 1) LANGUAGE SQL AS $$ SELECT a + b + c; $$$pg$);

-- Test 127: statement (line 557)
CALL pg_try_exec($pg$CREATE PROCEDURE my_sum(OUT INT, a INT, b INT DEFAULT 2, c INT = b + 1) LANGUAGE SQL AS $$ SELECT a + b + c; $$$pg$);

-- Test 128: statement (line 560)
CALL pg_try_exec($pg$CREATE PROCEDURE my_sum(OUT INT, a INT, b INT DEFAULT 2, c INT = d + 1) LANGUAGE SQL AS $$ SELECT a + b + c; $$$pg$);

-- Test 129: statement (line 563)
CALL pg_try_exec($pg$CREATE PROCEDURE my_sum(OUT INT, a INT, b INT DEFAULT true) LANGUAGE SQL AS $$ SELECT a + b; $$$pg$);

-- Test 130: statement (line 566)
CREATE PROCEDURE my_sum(OUT INT, a INT, b INT, c INT) LANGUAGE SQL AS $$ SELECT a + b + c; $$;

-- Test 131: statement (line 569)
CALL pg_try_exec($pg$CREATE OR REPLACE PROCEDURE my_sum(OUT INT, a INT = 1, b INT, c INT = 3) LANGUAGE SQL AS $$ SELECT a + b + c; $$$pg$);

-- Test 132: statement (line 573)
CALL pg_try_exec($pg$CREATE OR REPLACE PROCEDURE my_sum(OUT INT, a INT, b INT DEFAULT 2, c INT = 3) LANGUAGE SQL AS $$ SELECT a + b + c; $$$pg$);

-- Test 133: statement (line 577)
CALL pg_try_exec($pg$CREATE OR REPLACE PROCEDURE my_sum(OUT INT, a INT, b INT, c INT = 3) LANGUAGE SQL AS $$ SELECT a + b + c; $$$pg$);

-- Test 134: statement (line 580)
CALL pg_try_exec($pg$CREATE OR REPLACE PROCEDURE my_sum(OUT INT, a INT = 'a', b INT DEFAULT 2, c INT = 3) LANGUAGE SQL AS $$ SELECT a + b + c; $$$pg$);

-- Test 135: statement (line 583)
CALL pg_try_exec($pg$CREATE OR REPLACE PROCEDURE my_sum(a INT, b INT DEFAULT (SELECT 1)) LANGUAGE SQL AS $$ SELECT a + b; $$$pg$);

-- Test 136: statement (line 586)
CALL pg_try_exec($pg$CREATE OR REPLACE PROCEDURE my_sum(a INT, b INT DEFAULT 1 + (SELECT 2 FROM (VALUES (NULL)))) LANGUAGE SQL AS $$ SELECT a + b; $$$pg$);

-- Test 137: query (line 589)
CALL my_sum(NULL, 1);

-- Test 138: query (line 594)
CALL my_sum(NULL, 1, 1);

-- Test 139: statement (line 601)
CREATE PROCEDURE my_sum(OUT INT, a INT) LANGUAGE SQL AS $$ SELECT a; $$;

-- Test 140: statement (line 604)
CALL pg_try_exec($pg$CALL my_sum(NULL, 1)$pg$);

-- Test 141: statement (line 607)
DROP PROCEDURE my_sum(INT);

-- Test 142: statement (line 610)
DROP PROCEDURE my_sum;

-- Test 143: statement (line 613)
CALL pg_try_exec($pg$CREATE PROCEDURE my_sum(OUT sum INT, INOUT a INT, INOUT b INT = 3) AS $$ SELECT (a + b, a, b); $$ LANGUAGE SQL$pg$);

-- Test 144: query (line 616)
CALL pg_try_exec($pg$CALL my_sum(NULL, 1)$pg$);

-- Test 145: query (line 621)
CALL pg_try_exec($pg$CALL my_sum(NULL, 1, 1)$pg$);

-- Test 146: statement (line 626)
CALL pg_try_exec($pg$DROP PROCEDURE my_sum$pg$);

-- Test 147: statement (line 630)
CREATE PROCEDURE f(OUT CHAR, x CHAR DEFAULT 'foo') AS $$ SELECT x; $$ LANGUAGE SQL;

-- Test 148: query (line 635)
CALL f(NULL);

-- Test 149: statement (line 640)
DROP PROCEDURE f;

-- Test 150: statement (line 645)
CREATE FUNCTION f1(a INT, b INT = 2) RETURNS INT LANGUAGE SQL AS $$ SELECT a + b; $$;

-- Test 151: statement (line 648)
CREATE PROCEDURE p2(OUT INT, a INT, b INT = f1(1)) LANGUAGE SQL AS $$ SELECT a + b; $$;

-- Test 152: query (line 651)
CALL p2(NULL, 1);

-- Test 153: query (line 656)
CALL p2(NULL, 1, 1);

-- Test 154: statement (line 661)
CREATE OR REPLACE FUNCTION f1(a INT, b INT = 2) RETURNS INT LANGUAGE SQL AS $$ SELECT a * b; $$;

-- Test 155: query (line 664)
CALL p2(NULL, 1);

-- Test 156: query (line 669)
CALL p2(NULL, 1, 1);

-- Test 157: statement (line 674)
CALL pg_try_exec($pg$DROP FUNCTION f1$pg$);

-- Test 158: statement (line 677)
DROP PROCEDURE p2;

-- Test 159: statement (line 680)
DROP FUNCTION f1;

-- Test 160: statement (line 686)
CREATE PROCEDURE p(p1 typ DEFAULT (1, 2), p2 greeting = 'yo') LANGUAGE SQL AS $$ SELECT 1; $$;

-- Test 161: statement (line 689)
CALL pg_try_exec($pg$DROP TYPE typ$pg$);

-- Test 162: statement (line 692)
CALL pg_try_exec($pg$ALTER TYPE greeting DROP VALUE 'yo'$pg$);

-- Test 163: statement (line 696)
CALL pg_try_exec($pg$ALTER TYPE greeting DROP VALUE 'hello'$pg$);

-- Test 164: statement (line 701)
CREATE OR REPLACE PROCEDURE p(p1 typ DEFAULT (1, 2), p2 greeting = 'hi') LANGUAGE SQL AS $$ SELECT 1; $$;

-- Test 165: statement (line 704)
CALL pg_try_exec($pg$ALTER TYPE greeting DROP VALUE 'yo'$pg$);

-- Test 166: statement (line 707)
CALL pg_try_exec($pg$ALTER TYPE greeting DROP VALUE 'hi'$pg$);

-- Test 167: statement (line 710)
DROP PROCEDURE p;

-- Test 168: statement (line 715)
CREATE SEQUENCE seq;

-- Test 169: statement (line 718)
CREATE PROCEDURE p(OUT INT, a INT = nextval('seq'))AS $$ SELECT a; $$ LANGUAGE SQL;

-- Test 170: query (line 721)
CALL p(NULL);

-- Test 171: query (line 726)
CALL p(NULL, 1);

-- Test 172: query (line 731)
CALL p(NULL);

-- Test 173: statement (line 736)
CALL pg_try_exec($pg$DROP SEQUENCE seq$pg$);

-- Test 174: statement (line 739)
CREATE OR REPLACE PROCEDURE p(OUT INT, a INT = 3) AS $$ SELECT a; $$ LANGUAGE SQL;

-- Test 175: statement (line 743)
DROP SEQUENCE seq;

-- Test 176: statement (line 746)
DROP PROCEDURE p;

-- Test 177: statement (line 751)
CREATE SEQUENCE seq;

-- Test 178: statement (line 754)
CREATE OR REPLACE PROCEDURE p(OUT INT, a INT = 3) AS $$ SELECT a; $$ LANGUAGE SQL;

-- Test 179: statement (line 757)
CREATE OR REPLACE PROCEDURE p(OUT INT, a INT = nextval('seq'))AS $$ SELECT a; $$ LANGUAGE SQL;

-- Test 180: statement (line 760)
CALL pg_try_exec($pg$DROP SEQUENCE seq$pg$);

-- Test 181: statement (line 763)
DROP PROCEDURE p;

-- Test 182: statement (line 766)
DROP SEQUENCE seq;

-- Test 183: statement (line 771)
CREATE PROCEDURE p (s VARCHAR(1) DEFAULT NULL, d DECIMAL(1, 1) DEFAULT NULL) AS $$
  SELECT 1;
$$ LANGUAGE SQL;

-- Test 184: statement (line 776)
CREATE OR REPLACE PROCEDURE p (s VARCHAR(2) DEFAULT NULL, d DECIMAL(2, 2) DEFAULT NULL) AS $$
  SELECT 1;
$$ LANGUAGE SQL;

-- Test 185: statement (line 781)
DROP PROCEDURE p;

\set ON_ERROR_STOP 1
