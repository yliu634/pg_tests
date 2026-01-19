-- PostgreSQL compatible tests from udf_params
-- 186 tests

-- Test 1: statement (line 5)
CREATE FUNCTION f() AS $$ SELECT 1; $$ LANGUAGE SQL;

-- Test 2: statement (line 8)
CREATE FUNCTION f(OUT param INT) RETURNS FLOAT AS $$ SELECT 1; $$ LANGUAGE SQL;

-- Test 3: statement (line 11)
CREATE FUNCTION f(OUT param1 INT, OUT param2 INT) RETURNS INT AS $$ SELECT 1, 2; $$ LANGUAGE SQL;

-- Test 4: statement (line 14)
CREATE FUNCTION f(OUT param INT) RETURNS VOID AS $$ SELECT 1; $$ LANGUAGE SQL;

-- Test 5: statement (line 17)
CREATE FUNCTION f(OUT param INT) RETURNS RECORD AS $$ SELECT 1; $$ LANGUAGE SQL;

-- Test 6: statement (line 20)
CREATE FUNCTION f(param VOID) RETURNS UUID LANGUAGE SQL AS $$ SELECT NULL $$;

-- Test 7: statement (line 23)
CREATE FUNCTION f(OUT param INT) RETURNS INT AS $$ SELECT 1; $$ LANGUAGE SQL;

-- Test 8: statement (line 26)
CALL f(NULL);

-- Test 9: statement (line 29)
CALL f(NULL::INT);

-- Test 10: statement (line 32)
CALL f(1);

-- Test 11: statement (line 35)
DROP FUNCTION f;

-- Test 12: statement (line 38)
CREATE FUNCTION f(INOUT param1 INT, OUT param2 INT) RETURNS RECORD AS $$ SELECT 1, 2; $$ LANGUAGE SQL;

-- Test 13: statement (line 41)
DROP FUNCTION f;

-- Test 14: statement (line 44)
CREATE FUNCTION f(INOUT param1 INT, OUT param2 INT) AS $$ SELECT 1, 2, 3; $$ LANGUAGE SQL;

-- Test 15: statement (line 47)
CREATE FUNCTION f(INOUT param INT) AS $$ SELECT 'hello'; $$ LANGUAGE SQL;

-- Test 16: statement (line 52)
CREATE FUNCTION f(OUT param INT) AS $$ SELECT 1; $$ LANGUAGE SQL;

-- Test 17: statement (line 55)
DROP FUNCTION f;

-- Test 18: statement (line 58)
CREATE FUNCTION f(OUT param INT) AS $$ SELECT 1; $$ LANGUAGE SQL;

-- Test 19: statement (line 61)
DROP FUNCTION f(OUT INT);

-- Test 20: statement (line 64)
CREATE FUNCTION f(OUT param1 INT, OUT param2 INT) AS $$ SELECT 1, 2; $$ LANGUAGE SQL;

-- Test 21: statement (line 67)
DROP FUNCTION f(OUT INT);

-- Test 22: statement (line 70)
CREATE FUNCTION f(OUT param1 INT, OUT param2 INT) AS $$ SELECT 1, 2; $$ LANGUAGE SQL;

-- Test 23: statement (line 73)
DROP FUNCTION f(INT);

-- Test 24: statement (line 76)
DROP FUNCTION f;

-- Test 25: statement (line 79)
CREATE FUNCTION f() RETURNS INT AS $$ SELECT 1; $$ LANGUAGE SQL;

-- Test 26: statement (line 82)
DROP FUNCTION f(OUT INT, OUT text, OUT INT);

-- Test 27: statement (line 89)
CREATE FUNCTION f_param_types(IN p1 INT, INOUT p2 INT, IN OUT p3 INT, OUT p4 INT) AS $$
SELECT p2, p3, p1;
$$ LANGUAGE SQL;

-- Test 28: query (line 94)
SELECT create_statement FROM [SHOW CREATE FUNCTION f_param_types];

-- Test 29: statement (line 108)
DROP FUNCTION f_param_types;

-- Test 30: statement (line 111)
CREATE FUNCTION f_param_types(OUT param INT) AS $$
SELECT 1;
$$ LANGUAGE SQL;

-- Test 31: query (line 116)
SELECT create_statement FROM [SHOW CREATE FUNCTION f_param_types];

-- Test 32: statement (line 130)
DROP FUNCTION f_param_types;

-- Test 33: statement (line 140)
CREATE FUNCTION f_same_name(IN a INT, IN a INT) RETURNS INT IMMUTABLE LANGUAGE SQL AS $$ SELECT 1 $$;

-- Test 34: statement (line 143)
CREATE FUNCTION f_same_name(IN a INT, INOUT a INT) IMMUTABLE LANGUAGE SQL AS $$ SELECT 1 $$;

-- Test 35: statement (line 146)
CREATE FUNCTION f_same_name(OUT a INT, INOUT a INT) IMMUTABLE LANGUAGE SQL AS $$ SELECT 1, 1 $$;

-- Test 36: statement (line 149)
CREATE FUNCTION f_same_name(IN a INT, OUT a INT) IMMUTABLE LANGUAGE SQL AS $$ SELECT 1 $$;

-- Test 37: query (line 152)
SELECT f_same_name(2);

-- Test 38: query (line 158)
SELECT * FROM f_same_name(2);

-- Test 39: statement (line 164)
CREATE OR REPLACE FUNCTION f_same_name(IN a INT, OUT a INT) IMMUTABLE LANGUAGE SQL AS $$ SELECT a $$;

-- Test 40: query (line 167)
SELECT f_same_name(2);

-- Test 41: query (line 173)
SELECT * FROM f_same_name(2);

-- Test 42: statement (line 179)
CREATE FUNCTION f_names(IN param_in INT, OUT param_out INT) IMMUTABLE LANGUAGE SQL AS $$ SELECT param_out $$;

-- Test 43: statement (line 182)
CREATE FUNCTION f_names(IN param_in INT, OUT param_out INT) IMMUTABLE LANGUAGE SQL AS $$ SELECT param_in $$;

-- Test 44: query (line 185)
SELECT f_names(2);

-- Test 45: query (line 191)
SELECT * FROM f_names(2);

-- Test 46: statement (line 197)
CREATE FUNCTION f_out_int(OUT param INT) RETURNS INT AS $$ SELECT 1; $$ LANGUAGE SQL;

-- Test 47: query (line 200)
SELECT f_out_int();

-- Test 48: query (line 206)
SELECT * FROM f_out_int();

-- Test 49: statement (line 212)
CREATE FUNCTION f_in_int(IN param INT) RETURNS INT AS $$ SELECT param; $$ LANGUAGE SQL;

-- Test 50: query (line 215)
SELECT f_in_int(2);

-- Test 51: query (line 221)
SELECT * FROM f_in_int(2);

-- Test 52: statement (line 227)
CREATE FUNCTION f_inout_int(INOUT param INT) RETURNS INT AS $$ SELECT param; $$ LANGUAGE SQL;

-- Test 53: query (line 230)
SELECT f_inout_int(2);

-- Test 54: query (line 236)
SELECT * FROM f_inout_int(2);

-- Test 55: statement (line 243)
CREATE OR REPLACE FUNCTION f_out_int(OUT param_new INT) RETURNS INT AS $$ SELECT 1; $$ LANGUAGE SQL;

-- Test 56: query (line 246)
SELECT create_statement FROM [SHOW CREATE FUNCTION f_out_int];

-- Test 57: query (line 260)
SELECT f_out_int();

-- Test 58: query (line 266)
SELECT * FROM f_out_int();

-- Test 59: statement (line 273)
CREATE OR REPLACE FUNCTION f_in_int(IN param_new INT) RETURNS INT AS $$ SELECT 1; $$ LANGUAGE SQL;

-- Test 60: statement (line 276)
CREATE OR REPLACE FUNCTION f_inout_int(INOUT param_new INT) RETURNS INT AS $$ SELECT 1; $$ LANGUAGE SQL;

-- Test 61: statement (line 283)
CREATE FUNCTION f_int(IN param INT) RETURNS INT AS $$ SELECT param; $$ LANGUAGE SQL;

-- Test 62: query (line 286)
SELECT * FROM f_int(2);

-- Test 63: statement (line 294)
CREATE OR REPLACE FUNCTION f_int(INOUT param INT) RETURNS INT AS $$ SELECT param; $$ LANGUAGE SQL;

-- Test 64: query (line 297)
SELECT create_statement FROM [SHOW CREATE FUNCTION f_int];

-- Test 65: query (line 311)
SELECT * FROM f_int(2);

-- Test 66: statement (line 320)
CREATE OR REPLACE FUNCTION f_int(IN param_in INT, OUT param_out INT) RETURNS INT AS $$ SELECT 1; $$ LANGUAGE SQL;

-- Test 67: statement (line 323)
CREATE OR REPLACE FUNCTION f_int(IN param INT, OUT param_out INT) RETURNS INT AS $$ SELECT param; $$ LANGUAGE SQL;

-- Test 68: query (line 326)
SELECT create_statement FROM [SHOW CREATE FUNCTION f_int];

-- Test 69: query (line 340)
SELECT * FROM f_int(2);

-- Test 70: statement (line 346)
CREATE OR REPLACE FUNCTION f_int(OUT param_out INT, IN param INT) RETURNS INT AS $$ SELECT param; $$ LANGUAGE SQL;

-- Test 71: query (line 349)
SELECT create_statement FROM [SHOW CREATE FUNCTION f_int];

-- Test 72: query (line 363)
SELECT * FROM f_int(2);

-- Test 73: statement (line 369)
CREATE OR REPLACE FUNCTION f_int(INOUT param INT) RETURNS INT AS $$ SELECT param; $$ LANGUAGE SQL;

-- Test 74: query (line 372)
SELECT create_statement FROM [SHOW CREATE FUNCTION f_int];

-- Test 75: query (line 386)
SELECT * FROM f_int(2);

-- Test 76: statement (line 394)
CREATE FUNCTION f_3_in_2_out(IN param1 INT, IN param2 INT, IN param3 INT, OUT param1 INT, OUT param2 INT) AS $$ SELECT (param1, param2 + param3); $$ LANGUAGE SQL;

-- Test 77: query (line 397)
SELECT * FROM f_3_in_2_out(2, 2, 2);

-- Test 78: query (line 403)
SELECT proname, pronargs, pronargdefaults, proargtypes, proallargtypes, proargmodes, proargnames, proargdefaults
FROM pg_catalog.pg_proc WHERE proname = 'f_3_in_2_out';

-- Test 79: statement (line 409)
CREATE OR REPLACE FUNCTION f_3_in_2_out(IN param1 INT, OUT param1 INT, IN param2 INT, IN param3 INT, OUT param2 INT) AS $$ SELECT (param1, param2 + param3); $$ LANGUAGE SQL;

-- Test 80: query (line 412)
SELECT create_statement FROM [SHOW CREATE FUNCTION f_3_in_2_out];

-- Test 81: query (line 426)
SELECT * FROM f_3_in_2_out(2, 2, 2);

-- Test 82: statement (line 433)
CREATE OR REPLACE FUNCTION f_3_in_2_out(INOUT param1 INT, IN param2 INT, INOUT param3 INT) AS $$ SELECT (1, 1); $$ LANGUAGE SQL;

-- Test 83: statement (line 436)
CREATE OR REPLACE FUNCTION f_3_in_2_out(INOUT param1 INT, INOUT param2 INT, IN param3 INT) AS $$ SELECT (param1, param2 + param3); $$ LANGUAGE SQL;

-- Test 84: query (line 439)
SELECT create_statement FROM [SHOW CREATE FUNCTION f_3_in_2_out];

-- Test 85: query (line 453)
SELECT * FROM f_3_in_2_out(2, 2, 2);

-- Test 86: statement (line 467)
CREATE FUNCTION f_default_names(OUT INT, OUT param2 INT, IN INT, OUT INT) RETURNS RECORD AS $$ SELECT (1, 2, 3); $$ LANGUAGE SQL;

-- Test 87: query (line 470)
SELECT create_statement FROM [SHOW CREATE FUNCTION f_default_names];

-- Test 88: query (line 484)
SELECT f_default_names(0);

-- Test 89: query (line 490)
SELECT * FROM f_default_names(0);

-- Test 90: query (line 496)
SELECT column1 FROM f_default_names(0);

-- Test 91: query (line 502)
SELECT param2 FROM f_default_names(0);

-- Test 92: query (line 508)
SELECT column3 FROM f_default_names(0);

-- Test 93: query (line 514)
SELECT proname, pronargs, pronargdefaults, proargtypes, proallargtypes, proargmodes, proargnames, proargdefaults
FROM pg_catalog.pg_proc WHERE proname = 'f_default_names';

-- Test 94: statement (line 522)
CREATE OR REPLACE FUNCTION f_default_names(OUT INT, OUT param2 INT, IN INT, OUT param3 INT) RETURNS RECORD AS $$ SELECT (1, 2, 3); $$ LANGUAGE SQL;

-- Test 95: statement (line 526)
CREATE OR REPLACE FUNCTION f_default_names(OUT INT, OUT param2 INT, IN INT, OUT column3 INT) RETURNS RECORD AS $$ SELECT (1, 2, 3); $$ LANGUAGE SQL;

-- Test 96: query (line 529)
SELECT create_statement FROM [SHOW CREATE FUNCTION f_default_names];

-- Test 97: statement (line 544)
CREATE OR REPLACE FUNCTION f_default_names(OUT INT, OUT param2 INT, IN INT, OUT INT) RETURNS RECORD AS $$ SELECT (1, 2, 3); $$ LANGUAGE SQL;

-- Test 98: query (line 547)
SELECT create_statement FROM [SHOW CREATE FUNCTION f_default_names];

-- Test 99: statement (line 562)
CREATE OR REPLACE FUNCTION f_default_names(OUT INT, OUT param2 INT, IN in_param INT, OUT INT) RETURNS RECORD AS $$ SELECT (in_param, 2, 3); $$ LANGUAGE SQL;

-- Test 100: query (line 565)
SELECT create_statement FROM [SHOW CREATE FUNCTION f_default_names];

-- Test 101: statement (line 580)
CREATE OR REPLACE FUNCTION f_default_names(OUT INT, OUT param2 INT, IN in_param_new INT, OUT INT) RETURNS RECORD AS $$ SELECT (1, 2, 3); $$ LANGUAGE SQL;

-- Test 102: query (line 583)
SELECT f_default_names(0);

-- Test 103: query (line 589)
SELECT * FROM f_default_names(0);

-- Test 104: statement (line 597)
CREATE TYPE typ AS (a INT, b INT);
CREATE FUNCTION f_udt(OUT typ) LANGUAGE SQL AS $$ SELECT 1 AS x, 2 AS y; $$;

-- Test 105: query (line 601)
SELECT f_udt()

-- Test 106: query (line 607)
SELECT * FROM f_udt()

-- Test 107: query (line 613)
SELECT a FROM f_udt()

-- Test 108: query (line 619)
SELECT b FROM f_udt()

-- Test 109: statement (line 625)
DROP TYPE typ;

-- Test 110: statement (line 628)
DROP FUNCTION f_udt;

-- Test 111: statement (line 631)
CREATE TYPE greeting AS ENUM('hello', 'hi', 'yo');
CREATE FUNCTION f_enum(OUT greeting greeting) LANGUAGE SQL AS $$ SELECT 'hi'::greeting; $$;

-- Test 112: query (line 635)
SELECT * FROM f_enum()

-- Test 113: statement (line 641)
DROP TYPE greeting;

-- Test 114: statement (line 644)
DROP FUNCTION f_enum;

-- Test 115: statement (line 649)
CREATE FUNCTION my_sum(a INT, b INT DEFAULT 2, c INT DEFAULT 'a') RETURNS INT LANGUAGE SQL AS $$ SELECT a + b + c; $$;

-- Test 116: statement (line 652)
CREATE FUNCTION my_sum(a INT, b INT DEFAULT 2, c INT) RETURNS INT LANGUAGE SQL AS $$ SELECT a + b + c; $$;

-- Test 117: statement (line 655)
CREATE FUNCTION my_sum(a INT, b INT DEFAULT 2, INOUT c INT) RETURNS INT LANGUAGE SQL AS $$ SELECT a + b + c; $$;

-- Test 118: statement (line 658)
CREATE FUNCTION my_sum(a INT, b INT DEFAULT 2, OUT c INT = 3) LANGUAGE SQL AS $$ SELECT a + b; $$;

-- Test 119: statement (line 661)
CREATE FUNCTION my_sum(a INT, b INT, c INT = b + 1) RETURNS INT LANGUAGE SQL AS $$ SELECT a + b + c; $$;

-- Test 120: statement (line 664)
CREATE FUNCTION my_sum(a INT, b INT DEFAULT 2, c INT = b + 1) RETURNS INT LANGUAGE SQL AS $$ SELECT a + b + c; $$;

-- Test 121: statement (line 667)
CREATE FUNCTION my_sum(a INT, b INT DEFAULT 2, c INT = d + 1) RETURNS INT LANGUAGE SQL AS $$ SELECT a + b + c; $$;

-- Test 122: statement (line 670)
CREATE FUNCTION my_sum(a INT, b INT DEFAULT true) RETURNS INT LANGUAGE SQL AS $$ SELECT a + b; $$;

-- Test 123: statement (line 673)
CREATE FUNCTION my_sum(a INT, b INT DEFAULT (SELECT 1)) RETURNS INT LANGUAGE SQL AS $$ SELECT a + b; $$;

-- Test 124: statement (line 676)
CREATE FUNCTION my_sum(a INT, b INT DEFAULT 1 + (SELECT 2 FROM (VALUES (NULL)))) RETURNS INT LANGUAGE SQL AS $$ SELECT a + b; $$;

-- Test 125: statement (line 680)
CREATE FUNCTION f_nan(a INT, b INT DEFAULT 2, c FLOAT DEFAULT 'NaN':::FLOAT) RETURNS INT LANGUAGE SQL AS $$ SELECT a + b; $$;

-- Test 126: statement (line 683)
CREATE FUNCTION my_sum(a INT, b INT, c INT) RETURNS INT LANGUAGE SQL AS $$ SELECT a + b + c; $$;

-- Test 127: statement (line 686)
CREATE OR REPLACE FUNCTION my_sum(a INT = 1, b INT, c INT = 3) RETURNS INT LANGUAGE SQL AS $$ SELECT a + b + c; $$;

-- Test 128: statement (line 690)
CREATE OR REPLACE FUNCTION my_sum(a INT, b INT DEFAULT 2, c INT = 3) RETURNS INT LANGUAGE SQL AS $$ SELECT a + b + c; $$;

-- Test 129: query (line 693)
SELECT proname, pronargs, pronargdefaults, proargtypes, proallargtypes, proargmodes, proargnames, proargdefaults
FROM pg_catalog.pg_proc WHERE proname = 'my_sum';

-- Test 130: statement (line 700)
CREATE OR REPLACE FUNCTION my_sum(a INT, b INT, c INT = 3) RETURNS INT LANGUAGE SQL AS $$ SELECT a + b + c; $$;

-- Test 131: statement (line 703)
CREATE OR REPLACE FUNCTION my_sum(a INT = 'a', b INT DEFAULT 2, c INT = 3) RETURNS INT LANGUAGE SQL AS $$ SELECT a + b + c; $$;

-- Test 132: query (line 706)
SELECT my_sum(1);

-- Test 133: query (line 711)
SELECT my_sum(1, 1);

-- Test 134: query (line 716)
SELECT my_sum(1, 1, 1);

-- Test 135: statement (line 722)
SELECT my_sum();

-- Test 136: statement (line 726)
SELECT my_sum(1, 1, 1, 1);

-- Test 137: statement (line 731)
CREATE OR REPLACE FUNCTION my_sum(a INT, b INT DEFAULT 2, c INT = 3.5) RETURNS INT LANGUAGE SQL AS $$ SELECT a + b + c; $$;

-- Test 138: query (line 734)
SELECT my_sum(1);

-- Test 139: query (line 739)
SELECT my_sum(1, 1);

-- Test 140: statement (line 746)
CREATE FUNCTION my_sum(a INT) RETURNS INT LANGUAGE SQL AS $$ SELECT a; $$;

-- Test 141: statement (line 749)
SELECT my_sum(1);

-- Test 142: statement (line 752)
DROP FUNCTION my_sum(INT);

-- Test 143: statement (line 755)
DROP FUNCTION my_sum;

-- Test 144: statement (line 761)
CREATE FUNCTION my_sum(OUT sum INT, INOUT a INT, INOUT b INT = 3) AS $$ SELECT (a + b, a, b); $$ LANGUAGE SQL;

-- Test 145: query (line 764)
SELECT my_sum(1);

-- Test 146: query (line 769)
SELECT * FROM my_sum(1);

-- Test 147: query (line 774)
SELECT my_sum(1, 1);

-- Test 148: query (line 779)
SELECT * FROM my_sum(1, 1);

-- Test 149: statement (line 784)
DROP FUNCTION my_sum;

-- Test 150: statement (line 788)
CREATE FUNCTION f(x CHAR DEFAULT 'foo') RETURNS CHAR LANGUAGE SQL AS $$ SELECT x; $$;

-- Test 151: query (line 793)
SELECT f();

-- Test 152: statement (line 798)
DROP FUNCTION f;

-- Test 153: statement (line 803)
CREATE FUNCTION f1(a INT, b INT = 2) RETURNS INT LANGUAGE SQL AS $$ SELECT a + b; $$;

-- Test 154: statement (line 806)
CREATE FUNCTION f2(a INT, b INT = f1(1)) RETURNS INT LANGUAGE SQL AS $$ SELECT a + b; $$;

-- Test 155: query (line 809)
SELECT f1(1), f2(1), f2(1, 1);

-- Test 156: statement (line 814)
CREATE OR REPLACE FUNCTION f1 (a INT, b INT = 2) RETURNS INT LANGUAGE SQL AS $$ SELECT a * b; $$;

-- Test 157: query (line 817)
SELECT f1(1), f2(1), f2(1, 1);

-- Test 158: statement (line 822)
DROP FUNCTION f1;

-- Test 159: statement (line 825)
DROP FUNCTION f2;

-- Test 160: statement (line 828)
DROP FUNCTION f1;

-- Test 161: statement (line 834)
CREATE FUNCTION f(p1 typ DEFAULT (1, 2), p2 greeting = 'yo') RETURNS INT LANGUAGE SQL AS $$ SELECT 1; $$;

-- Test 162: statement (line 837)
DROP TYPE typ;

-- Test 163: statement (line 840)
ALTER TYPE greeting DROP VALUE 'yo';

-- Test 164: statement (line 844)
ALTER TYPE greeting DROP VALUE 'hello';

-- Test 165: statement (line 849)
CREATE OR REPLACE FUNCTION f(p1 typ DEFAULT (1, 2), p2 greeting = 'hi') RETURNS INT LANGUAGE SQL AS $$ SELECT 1; $$;

-- Test 166: statement (line 852)
ALTER TYPE greeting DROP VALUE 'yo';

-- Test 167: statement (line 855)
ALTER TYPE greeting DROP VALUE 'hi';

-- Test 168: statement (line 858)
DROP FUNCTION f;

-- Test 169: statement (line 863)
CREATE SEQUENCE seq;

-- Test 170: statement (line 866)
CREATE FUNCTION f(a INT = nextval('seq')) RETURNS INT AS $$ SELECT a; $$ LANGUAGE SQL;

-- Test 171: query (line 869)
SELECT f();

-- Test 172: query (line 874)
SELECT f(1);

-- Test 173: query (line 879)
SELECT f();

-- Test 174: statement (line 884)
DROP SEQUENCE seq;

-- Test 175: statement (line 887)
CREATE OR REPLACE FUNCTION f(a INT = 3) RETURNS INT AS $$ SELECT a; $$ LANGUAGE SQL;

-- Test 176: statement (line 891)
DROP SEQUENCE seq;

-- Test 177: statement (line 894)
DROP FUNCTION f;

-- Test 178: statement (line 899)
CREATE SEQUENCE seq;

-- Test 179: statement (line 902)
CREATE FUNCTION f(a INT = 3) RETURNS INT AS $$ SELECT a; $$ LANGUAGE SQL;

-- Test 180: statement (line 905)
CREATE OR REPLACE FUNCTION f(a INT = nextval('seq')) RETURNS INT AS $$ SELECT a; $$ LANGUAGE SQL;

-- Test 181: statement (line 908)
DROP SEQUENCE seq;

-- Test 182: statement (line 911)
DROP FUNCTION f;

-- Test 183: statement (line 914)
DROP SEQUENCE seq;

-- Test 184: statement (line 919)
CREATE FUNCTION f (s STRING(1) DEFAULT NULL, d DECIMAL(1, 1) DEFAULT NULL) RETURNS INT AS $$
  SELECT 1;
$$ LANGUAGE SQL;

-- Test 185: statement (line 924)
CREATE OR REPLACE FUNCTION f (s STRING(2) DEFAULT NULL, d DECIMAL(2, 2) DEFAULT NULL) RETURNS INT AS $$
  SELECT 1;
$$ LANGUAGE SQL;

-- Test 186: statement (line 929)
DROP FUNCTION f;

