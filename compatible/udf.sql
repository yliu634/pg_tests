-- PostgreSQL compatible tests from udf
-- 237 tests

-- Test 1: statement (line 2)
CREATE TABLE ab (
  a INT PRIMARY KEY,
  b INT
)

-- Test 2: statement (line 8)
CREATE SEQUENCE sq1;

-- Test 3: statement (line 11)
CREATE TYPE notmyworkday AS ENUM ('Monday', 'Tuesday');

-- Test 4: statement (line 16)
CREATE FUNCTION f() RETURNS INT IMMUTABLE AS $$ SELECT 1 $$;

-- Test 5: statement (line 19)
CREATE FUNCTION f() RETURNS INT IMMUTABLE LANGUAGE SQL;

-- Test 6: statement (line 23)
CREATE FUNCTION a(i INT) RETURNS INT LANGUAGE SQL AS 'SELECT i'

-- Test 7: statement (line 26)
CREATE FUNCTION b(i INT) RETURNS INT LANGUAGE SQL AS 'SELECT a FROM ab WHERE a = i'

-- Test 8: statement (line 29)
CREATE FUNCTION c(i INT, j INT) RETURNS INT LANGUAGE SQL AS 'SELECT i - j'

-- Test 9: statement (line 32)
CREATE FUNCTION err(i INT) RETURNS INT LANGUAGE SQL AS 'SELECT j'

-- Test 10: statement (line 35)
CREATE FUNCTION err(i INT) RETURNS INT LANGUAGE SQL AS 'SELECT a FROM ab WHERE a = j'

-- Test 11: statement (line 38)
CREATE FUNCTION err() RETURNS INT LANGUAGE SQL AS 'SELECT a FROM dne'

-- Test 12: statement (line 41)
CREATE FUNCTION d(i INT2) RETURNS INT4 LANGUAGE SQL AS 'SELECT i'

-- Test 13: statement (line 44)
CREATE FUNCTION err(i INT, j INT) RETURNS BOOL LANGUAGE SQL AS 'SELECT i - j'

-- Test 14: statement (line 47)
CREATE FUNCTION err(b BOOL) RETURNS INT LANGUAGE SQL AS 'SELECT b'

-- Test 15: statement (line 50)
CREATE FUNCTION err(i INT, j INT) RETURNS BOOL LANGUAGE SQL AS 'SELECT i - j'

-- Test 16: statement (line 58)
CREATE FUNCTION f() RETURNS INT IMMUTABLE LANGUAGE SQL AS $$ SELECT a, b from t_implicit_type $$

-- Test 17: statement (line 62)
CREATE FUNCTION f_no_ref(a int) RETURNS INT IMMUTABLE AS 'SELECT 1' LANGUAGE SQL

-- Test 18: query (line 65)
SELECT create_statement FROM [SHOW CREATE FUNCTION f_no_ref];

-- Test 19: statement (line 81)
CREATE TABLE t(
a INT PRIMARY KEY,
b INT,
C INT,
INDEX t_idx_b(b),
INDEX t_idx_c(c)
);

-- Test 20: statement (line 91)
CREATE FUNCTION f(a notmyworkday) RETURNS INT VOLATILE LANGUAGE SQL AS $$
SELECT a FROM t;
SELECT b FROM t@t_idx_b;
SELECT c FROM t@t_idx_c;
SELECT nextval('sq1');
$$

-- Test 21: query (line 99)
SELECT create_statement FROM [SHOW CREATE FUNCTION f];

-- Test 22: statement (line 116)
ALTER FUNCTION f() DEPENDS ON EXTENSION postgis

-- Test 23: statement (line 123)
CREATE FUNCTION proc_f(INT) RETURNS INT LANGUAGE SQL AS $$ SELECT 1 $$;

-- Test 24: query (line 135)
SELECT oid, proname, pronamespace, proowner, prolang, proleakproof, proisstrict, proretset, provolatile, pronargs, prorettype, proargtypes, proargmodes, proargnames, prokind, prosrc
FROM pg_catalog.pg_proc WHERE proname IN ('proc_f', 'proc_f_2')
ORDER BY 1

-- Test 25: query (line 146)
SELECT oid, proname FROM pg_proc WHERE oid = 'sc.proc_f_2'::regproc

-- Test 26: statement (line 151)
USE defaultdb;

-- Test 27: query (line 154)
SELECT oid, proname, pronamespace, proowner, prolang, proleakproof, proisstrict, proretset, provolatile, pronargs, prorettype, proargtypes, proargmodes, proargnames, prosrc
FROM pg_catalog.pg_proc WHERE proname IN ('proc_f', 'proc_f_2');

-- Test 28: statement (line 159)
USE test;

-- Test 29: query (line 166)
SELECT '100126'::REGPROC;

-- Test 30: query (line 171)
SELECT 'sc.proc_f_2'::REGPROC;

-- Test 31: query (line 176)
SELECT 'sc.proc_f_2'::REGPROC::INT;

-- Test 32: statement (line 181)
SELECT 'no_such_func'::REGPROC;

-- Test 33: statement (line 184)
SELECT 'proc_f'::REGPROC;

-- Test 34: query (line 187)
SELECT 100126::regproc;

-- Test 35: query (line 192)
SELECT 100117::regproc::INT;

-- Test 36: query (line 197)
SELECT 999999::regproc;

-- Test 37: statement (line 207)
CREATE FUNCTION f_test_exec_dropped(a int) RETURNS INT LANGUAGE SQL AS $$ SELECT a $$;

-- Test 38: query (line 210)
SELECT f_test_exec_dropped(123);

-- Test 39: statement (line 215)
DROP FUNCTION f_test_exec_dropped;

-- Test 40: statement (line 218)
SELECT f_test_exec_dropped(321);

-- Test 41: statement (line 226)
CREATE FUNCTION f_test_cor(a INT, b INT) RETURNS INT IMMUTABLE LEAKPROOF STRICT LANGUAGE SQL AS $$ SELECT 1 $$;

-- Test 42: statement (line 229)
CREATE FUNCTION f_test_cor(a INT, b INT) RETURNS INT IMMUTABLE LANGUAGE SQL AS $$ SELECT 1 $$;

-- Test 43: statement (line 232)
CREATE OR REPLACE PROCEDURE f_test_cor(a INT, b INT) LANGUAGE SQL AS $$ SELECT 2 $$;

-- Test 44: statement (line 235)
CREATE OR REPLACE FUNCTION f_test_cor_not_exist(a INT, b INT) RETURNS INT IMMUTABLE LANGUAGE SQL AS $$ SELECT 1 $$;

-- Test 45: statement (line 238)
CREATE OR REPLACE FUNCTION f_test_cor(a INT, c INT) RETURNS INT IMMUTABLE LANGUAGE SQL AS $$ SELECT 1 $$;

-- Test 46: statement (line 244)
CREATE OR REPLACE FUNCTION f_test_cor(a INT, b INT) RETURNS INT LEAKPROOF LANGUAGE SQL AS $$ SELECT 1 $$;

-- Test 47: query (line 247)
SELECT create_statement FROM [SHOW CREATE FUNCTION f_test_cor];

-- Test 48: statement (line 263)
CREATE OR REPLACE FUNCTION f_test_cor(a INT, b INT) RETURNS INT LANGUAGE SQL AS $$ SELECT 2 $$;

-- Test 49: query (line 266)
SELECT create_statement FROM [SHOW CREATE FUNCTION f_test_cor];

-- Test 50: statement (line 280)
CREATE OR REPLACE FUNCTION f_test_cor(a INT, b INT) RETURNS INT IMMUTABLE LEAKPROOF STRICT LANGUAGE SQL AS $$ SELECT 3 $$;

-- Test 51: query (line 283)
SELECT create_statement FROM [SHOW CREATE FUNCTION f_test_cor];

-- Test 52: statement (line 302)
CREATE SCHEMA sc_seq_qualified_name;
CREATE SEQUENCE sc_seq_qualified_name.sq;

-- Test 53: statement (line 306)
CREATE FUNCTION f_seq_qualified_name() RETURNS INT LANGUAGE SQL AS $$ SELECT * FROM nextval('"sc_seq_qualified_name.sq"') $$;

-- Test 54: statement (line 309)
CREATE FUNCTION f_seq_qualified_name() RETURNS INT LANGUAGE SQL AS $$ SELECT nextval('sc_seq_qualified_name.sq') $$;

-- Test 55: query (line 312)
SELECT f_seq_qualified_name()

-- Test 56: statement (line 317)
CREATE FUNCTION f_seq_qualified_name_quoted() RETURNS INT LANGUAGE SQL AS $$ SELECT nextval('"sc_seq_qualified_name"."sq"') $$;

-- Test 57: query (line 320)
SELECT f_seq_qualified_name_quoted()

-- Test 58: statement (line 330)
INSERT INTO ab VALUES (1, 1), (2, 2), (3, 3), (4, 1), (5, 1)

-- Test 59: statement (line 333)
CREATE FUNCTION one() RETURNS INT LANGUAGE SQL AS 'SELECT 2-1';

-- Test 60: query (line 336)
SELECT one()

-- Test 61: query (line 341)
SELECT * FROM one()

-- Test 62: query (line 347)
SELECT *, one() FROM ab WHERE a = one()

-- Test 63: query (line 353)
SELECT *, one() FROM ab WHERE b = one()

-- Test 64: query (line 361)
SELECT * FROM ab WHERE b = one() + 1

-- Test 65: statement (line 367)
CREATE FUNCTION max_in_values() RETURNS INT LANGUAGE SQL AS $$
  SELECT i FROM (VALUES (1, 0), (2, 0), (3, 0)) AS v(i, j) ORDER BY i DESC
$$

-- Test 66: query (line 372)
SELECT max_in_values()

-- Test 67: statement (line 377)
CREATE FUNCTION fetch_one_then_two() RETURNS INT LANGUAGE SQL AS $$
SELECT b FROM ab WHERE a = 1;
SELECT b FROM ab WHERE a = 2;
$$

-- Test 68: query (line 383)
SELECT i, fetch_one_then_two()
FROM (VALUES (1), (2), (3)) AS v(i)
WHERE i = fetch_one_then_two()

-- Test 69: query (line 390)
SELECT * FROM fetch_one_then_two()

-- Test 70: statement (line 396)
CREATE TABLE empty (e INT);
CREATE FUNCTION empty_result() RETURNS INT LANGUAGE SQL AS $$
SELECT e FROM empty
$$

-- Test 71: query (line 402)
SELECT empty_result()

-- Test 72: statement (line 407)
CREATE FUNCTION int_identity(i INT) RETURNS INT LANGUAGE SQL AS 'SELECT i';

-- Test 73: query (line 410)
SELECT int_identity(1)

-- Test 74: query (line 415)
SELECT int_identity(10 + int_identity(1))

-- Test 75: query (line 420)
SELECT a+b, int_identity(a+b) FROM ab WHERE a = int_identity(a) AND b = int_identity(b)

-- Test 76: statement (line 431)
CREATE FUNCTION add(x INT, y INT) RETURNS INT LANGUAGE SQL AS 'SELECT x+y';

-- Test 77: statement (line 434)
CREATE FUNCTION sub(x INT, y INT) RETURNS INT LANGUAGE SQL AS 'SELECT x-y';

-- Test 78: statement (line 437)
CREATE FUNCTION mult(x INT, y INT) RETURNS INT LANGUAGE SQL AS 'SELECT x*y';

-- Test 79: query (line 440)
SELECT a + a + a + b + b + b, add(a, add(a, add(a, add(b, add(b, b))))) FROM ab

-- Test 80: query (line 449)
SELECT (a * (a + b)) - b, sub(mult(a, add(a, b)), b) FROM ab

-- Test 81: query (line 458)
SELECT a * (3 + b - a) + a * b * a, add(mult(a, add(3, sub(b, a))), mult(a, mult(b, a))) FROM ab

-- Test 82: statement (line 467)
CREATE FUNCTION fetch_b(arg_a INT) RETURNS INT LANGUAGE SQL AS $$
SELECT b FROM ab WHERE a = arg_a
$$

-- Test 83: query (line 472)
SELECT b, fetch_b(a) FROM ab

-- Test 84: query (line 481)
SELECT b + (a * 7) - (a * b), add(fetch_b(a), sub(mult(a, 7), mult(a, fetch_b(a)))) FROM ab

-- Test 85: query (line 490)
SELECT fetch_b(99999999)

-- Test 86: statement (line 495)
CREATE FUNCTION one_nth(n INT) RETURNS INT LANGUAGE SQL AS 'SELECT 1/n'

-- Test 87: statement (line 498)
SELECT one_nth(0)

-- Test 88: statement (line 501)
SELECT int_identity((1/0)::INT)

-- Test 89: statement (line 509)
CREATE FUNCTION f(r RECORD) RETURNS INT LANGUAGE SQL AS 'SELECT i'

-- Test 90: statement (line 514)
CREATE FUNCTION err(x INT, y INT) RETURNS INT LANGUAGE SQL AS 'SELECT x + y + $1 + $2 + $3'

-- Test 91: statement (line 517)
CREATE FUNCTION err(INT, INT) RETURNS INT LANGUAGE SQL AS 'SELECT $1 + $2 + $3'

-- Test 92: statement (line 520)
CREATE FUNCTION err(INT) RETURNS INT LANGUAGE SQL AS 'SELECT 1 + $0'

-- Test 93: statement (line 523)
CREATE FUNCTION add(x INT, y INT, z INT) RETURNS INT LANGUAGE SQL AS $$
  SELECT (x - $1 + x) + ($2 - y + $2) + (z - $3 + z);
$$

-- Test 94: statement (line 528)
CREATE FUNCTION mult(x INT, y INT, z INT) RETURNS INT LANGUAGE SQL AS $$
  SELECT $1 * y * (z - $3 + z);
$$

-- Test 95: query (line 533)
SELECT a + b + a, add(a, b, a) FROM ab

-- Test 96: query (line 542)
SELECT a FROM ab WHERE (a + b + b) != add(a, b, b)

-- Test 97: query (line 546)
SELECT
  (a + b + a) * (a + 3 + 7) * (b + 11 + 17),
  mult(add(a, b, a), add(a, 3, 7), add(b, 11, 17))
FROM ab

-- Test 98: statement (line 558)
PREPARE do_math(INT, INT, INT, INT) AS
SELECT
  (a + b + a) * (a + $1 + $2) * (b + $3 + $4),
  mult(add(a, b, a), add(a, $1, $2), add(b, $3, $4))
FROM ab

-- Test 99: query (line 565)
EXECUTE do_math(3, 7, 11, 17)

-- Test 100: statement (line 574)
CREATE FUNCTION err(
  INT, INT, INT, INT, INT, INT, INT, INT, INT, INT,
  INT, INT, INT, INT, INT, INT, INT, INT, INT, INT,
  INT, INT, INT, INT, INT, INT, INT, INT, INT, INT,
  INT, INT, INT, INT, INT, INT, INT, INT, INT, INT,
  INT, INT, INT, INT, INT, INT, INT, INT, INT, INT,
  INT, INT, INT, INT, INT, INT, INT, INT, INT, INT,
  INT, INT, INT, INT, INT, INT, INT, INT, INT, INT,
  INT, INT, INT, INT, INT, INT, INT, INT, INT, INT,
  INT, INT, INT, INT, INT, INT, INT, INT, INT, INT,
  INT, INT, INT, INT, INT, INT, INT, INT, INT, INT,
  INT
) RETURNS INT LANGUAGE SQL AS 'SELECT $1';

-- Test 101: statement (line 590)
CREATE FUNCTION add(
  INT, INT, INT, INT, INT, INT, INT, INT, INT, INT,
  INT, INT, INT, INT, INT, INT, INT, INT, INT, INT,
  INT, INT, INT, INT, INT, INT, INT, INT, INT, INT,
  INT, INT, INT, INT, INT, INT, INT, INT, INT, INT,
  INT, INT, INT, INT, INT, INT, INT, INT, INT, INT,
  INT, INT, INT, INT, INT, INT, INT, INT, INT, INT,
  INT, INT, INT, INT, INT, INT, INT, INT, INT, INT,
  INT, INT, INT, INT, INT, INT, INT, INT, INT, INT,
  INT, INT, INT, INT, INT, INT, INT, INT, INT, INT,
  INT, INT, INT, INT, INT, INT, INT, INT, INT, INT
) RETURNS INT LANGUAGE SQL AS $$
  SELECT $1 + $2 + $3 + $4 + $5 + $6 + $7 + $8 + $9 + $10 +
    $11 + $12 + $13 + $14 + $15 + $16 + $17 + $18 + $19 + $20 +
    $21 + $22 + $23 + $24 + $25 + $26 + $27 + $28 + $29 + $30 +
    $31 + $32 + $33 + $34 + $35 + $36 + $37 + $38 + $39 + $40 +
    $41 + $42 + $43 + $44 + $45 + $46 + $47 + $48 + $49 + $50 +
    $51 + $52 + $53 + $54 + $55 + $56 + $57 + $58 + $59 + $60 +
    $61 + $62 + $63 + $64 + $65 + $66 + $67 + $68 + $69 + $70 +
    $71 + $72 + $73 + $74 + $75 + $76 + $77 + $78 + $79 + $80 +
    $81 + $82 + $83 + $84 + $85 + $86 + $87 + $88 + $89 + $90 +
    $91 + $92 + $93 + $94 + $95 + $96 + $97 + $98 + $99 + $100;
$$;

-- Test 102: query (line 615)
SELECT sum(i),
  add(1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
  11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
  21, 22, 23, 24, 25, 26, 27, 28, 29, 30,
  31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
  41, 42, 43, 44, 45, 46, 47, 48, 49, 50,
  51, 52, 53, 54, 55, 56, 57, 58, 59, 60,
  61, 62, 63, 64, 65, 66, 67, 68, 69, 70,
  71, 72, 73, 74, 75, 76, 77, 78, 79, 80,
  81, 82, 83, 84, 85, 86, 87, 88, 89, 90,
  91, 92, 93, 94, 95, 96, 97, 98, 99, 100)
FROM generate_series(1, 100) AS g(i)

-- Test 103: statement (line 638)
CREATE FUNCTION err(i INT) RETURNS BOOL LANGUAGE SQL AS 'SELECT i'

-- Test 104: statement (line 641)
CREATE FUNCTION itof(i INT) RETURNS FLOAT8 LANGUAGE SQL AS 'SELECT i'

-- Test 105: query (line 644)
SELECT itof(123), pg_typeof(itof(123))

-- Test 106: query (line 652)
SELECT stoc('a'), pg_typeof(stoc('a'))

-- Test 107: statement (line 657)
SELECT stoc('abc')

-- Test 108: query (line 670)
SELECT create_statement FROM [SHOW CREATE FUNCTION single_quote]

-- Test 109: query (line 684)
SELECT single_quote('hello')

-- Test 110: statement (line 699)
CREATE FUNCTION arr(x INT) RETURNS INT[] LANGUAGE SQL AS $$
  SELECT ARRAY(VALUES (1), (2), (x));
$$

-- Test 111: query (line 704)
SELECT arr(10)

-- Test 112: query (line 709)
SELECT arr(i) FROM generate_series(1, 3) g(i)

-- Test 113: statement (line 721)
CREATE FUNCTION lowercase_hint_error_implicit_schema_fn() RETURNS INT AS 'SELECT 1' LANGUAGE SQL

-- Test 114: statement (line 724)
SELECT "LOWERCASE_HINT_ERROR_IMPLICIT_SCHEMA_FN"();

-- Test 115: statement (line 731)
CREATE FUNCTION public.lowercase_hint_error_explicit_schema_fn() RETURNS INT AS 'SELECT 1' LANGUAGE SQL

-- Test 116: statement (line 734)
SELECT public."LOWERCASE_HINT_ERROR_EXPLICIT_SCHEMA_FN"();

-- Test 117: statement (line 746)
CREATE TABLE "purchase" (
    "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "amount" amount NOT NULL,
    "timestamp" TIMESTAMP NOT NULL DEFAULT now()
)

-- Test 118: statement (line 753)
INSERT INTO "purchase" (amount) VALUES
    ((1000,  'GBP', 100)),
    ((10,    'YEN', 1)),
    ((10000, 'BHD', 1000))

-- Test 119: statement (line 759)
CREATE FUNCTION decimal_amount(a amount) RETURNS DECIMAL(10, 2) IMMUTABLE LANGUAGE SQL AS $$
    SELECT (a)."value" / (a)."minor_units";
$$

-- Test 120: query (line 764)
SELECT
    decimal_amount(amount) AS amount,
    (amount).currency
FROM purchase

-- Test 121: statement (line 774)
UPDATE purchase
SET amount = ((amount).value, (amount).currency, 10000)
WHERE (amount).currency = 'BHD'

-- Test 122: query (line 779)
SELECT
    decimal_amount(amount) AS amount,
    (amount).currency
FROM purchase

-- Test 123: statement (line 791)
CREATE FUNCTION f113186() RETURNS RECORD AS $$ SELECT 1.99; $$ LANGUAGE SQL;

-- Test 124: query (line 794)
SELECT * FROM f113186() AS foo(x INT);

-- Test 125: statement (line 802)
CREATE TYPE one_typ AS (x INT);
CREATE TYPE two_typ AS (x INT, y INT);

-- Test 126: statement (line 807)
DROP FUNCTION f;
CREATE FUNCTION f() RETURNS one_typ LANGUAGE SQL AS $$ SELECT 1; $$;

-- Test 127: query (line 811)
SELECT f();

-- Test 128: query (line 816)
SELECT * FROM f();

-- Test 129: statement (line 821)
DROP FUNCTION f;
CREATE FUNCTION f() RETURNS one_typ LANGUAGE SQL AS $$ SELECT ROW(1); $$;

-- Test 130: query (line 825)
SELECT f();

-- Test 131: query (line 830)
SELECT * FROM f();

-- Test 132: statement (line 835)
DROP FUNCTION f;

-- Test 133: statement (line 838)
CREATE FUNCTION f() RETURNS one_typ LANGUAGE SQL AS $$ SELECT ROW(ROW(1)); $$;

-- Test 134: statement (line 842)
CREATE FUNCTION f() RETURNS two_typ LANGUAGE SQL AS $$ SELECT 1, 2; $$;

-- Test 135: query (line 845)
SELECT f();

-- Test 136: query (line 850)
SELECT * FROM f();

-- Test 137: statement (line 855)
DROP FUNCTION f;

-- Test 138: statement (line 858)
CREATE FUNCTION f() RETURNS two_typ LANGUAGE SQL AS $$ SELECT ROW(1, 2); $$;

-- Test 139: query (line 861)
SELECT f();

-- Test 140: query (line 866)
SELECT * FROM f();

-- Test 141: statement (line 871)
DROP FUNCTION f;

-- Test 142: statement (line 874)
CREATE FUNCTION f() RETURNS two_typ LANGUAGE SQL AS $$ SELECT ROW(ROW(1, 2)); $$;

-- Test 143: statement (line 878)
CREATE FUNCTION f(OUT x INT, OUT y INT) LANGUAGE SQL AS $$ SELECT 1, 2; $$;

-- Test 144: query (line 881)
SELECT f();

-- Test 145: query (line 886)
SELECT * FROM f();

-- Test 146: statement (line 891)
DROP FUNCTION f;
CREATE FUNCTION f(OUT x INT, OUT y INT) LANGUAGE SQL AS $$ SELECT ROW(1, 2); $$;

-- Test 147: query (line 895)
SELECT f();

-- Test 148: query (line 900)
SELECT * FROM f();

-- Test 149: statement (line 905)
DROP FUNCTION f;

-- Test 150: statement (line 908)
CREATE FUNCTION f(OUT x INT, OUT y INT) LANGUAGE SQL AS $$ SELECT ROW(ROW(1, 2)); $$;

-- Test 151: statement (line 911)
CREATE FUNCTION f(x ANYELEMENT) RETURNS INT LANGUAGE SQL AS $$ SELECT 1; $$;

-- Test 152: statement (line 914)
SELECT f(0);

-- Test 153: statement (line 917)
SELECT f(0);

-- Test 154: statement (line 920)
DROP FUNCTION f;
CREATE FUNCTION f(x INT) RETURNS INT LANGUAGE SQL AS $$ SELECT 1; $$;

-- Test 155: statement (line 924)
SELECT f('0');

-- Test 156: statement (line 927)
DROP FUNCTION f;
CREATE FUNCTION f(x TEXT) RETURNS INT LANGUAGE SQL AS $$ SELECT 1; $$;

-- Test 157: statement (line 931)
SELECT f('0');

-- Test 158: statement (line 934)
DROP FUNCTION f;

-- Test 159: statement (line 941)
CREATE FUNCTION f117101() RETURNS RECORD CALLED ON NULL INPUT AS $funcbody$
  SELECT ((42)::INT8, (43)::INT8)
$funcbody$ LANGUAGE SQL;

-- Test 160: statement (line 946)
SELECT
  *
FROM
(
  VALUES
    (
     (('aloha'::TEXT,
     (44)::INT8), NULL)
    ),
    (COALESCE(f117101(), NULL))
);

-- Test 161: statement (line 965)
SELECT
	tab_18298.col_30903
FROM
	(
		VALUES
			(
				('-26 years -422 days -21:13:57.660026':::INTERVAL::INTERVAL + now():::TIMESTAMP::TIMESTAMP::TIMESTAMP)::TIMESTAMP
			),
			(NULL)
	)
		AS tab_18298 (col_30903)
ORDER BY
	tab_18298.col_30903 ASC
LIMIT
	3:::INT8;

-- Test 162: statement (line 987)
CREATE TABLE ab104009(a INT PRIMARY KEY, b INT)

-- Test 163: statement (line 990)
CREATE TABLE cd104009(c INT PRIMARY KEY, d INT)

-- Test 164: statement (line 993)
CREATE TABLE e104009(e INT PRIMARY KEY)

-- Test 165: statement (line 1005)
PREPARE p AS SELECT f($1::REGCLASS::INT)

-- Test 166: statement (line 1008)
EXECUTE p(10)

-- Test 167: statement (line 1017)
CREATE FUNCTION f142886(p VARCHAR(10)) RETURNS INT LANGUAGE SQL AS $$ SELECT 0; $$;

-- Test 168: statement (line 1020)
CREATE FUNCTION f142886(p VARCHAR(100)) RETURNS INT LANGUAGE SQL AS $$ SELECT 0; $$;

-- Test 169: statement (line 1023)
DROP FUNCTION f142886;

-- Test 170: statement (line 1031)
create function app_to_db_id(app_id INT8) RETURNS INT8 LANGUAGE plpgsql AS $$ BEGIN RETURN app_id * 2; END; $$;

-- Test 171: statement (line 1034)
create sequence seq1;

-- Test 172: statement (line 1037)
create table test (id int8 not null default app_to_db_id(nextval('seq1'::REGCLASS)));

-- Test 173: query (line 1040)
select * from pg_catalog.pg_attrdef;

-- Test 174: statement (line 1053)
CREATE TABLE xy (x INT, y INT);
INSERT INTO xy VALUES (1, 2), (3, 4), (5, 6);

-- Test 175: statement (line 1057)
CREATE FUNCTION f_scalar() RETURNS INT LANGUAGE SQL AS $$ SELECT count(*) FROM xy $$;

-- Test 176: statement (line 1060)
CREATE FUNCTION f_setof() RETURNS SETOF xy LANGUAGE SQL AS $$ SELECT * FROM xy $$;

-- Test 177: statement (line 1063)
CREATE VIEW v AS SELECT x, y, f_scalar() FROM f_setof();

-- Test 178: statement (line 1066)
CREATE MATERIALIZED VIEW mv AS SELECT x, y, f_scalar() FROM f_setof();

-- Test 179: query (line 1069)
SELECT * FROM v ORDER BY x, y;

-- Test 180: query (line 1076)
SELECT * FROM mv ORDER BY x, y;

-- Test 181: statement (line 1083)
REFRESH MATERIALIZED VIEW mv;

-- Test 182: query (line 1086)
SELECT * FROM mv ORDER BY x, y;

-- Test 183: statement (line 1093)
INSERT INTO xy VALUES (7, 8);

-- Test 184: query (line 1096)
SELECT * FROM v ORDER BY x, y;

-- Test 185: query (line 1104)
SELECT * FROM mv ORDER BY x, y;

-- Test 186: statement (line 1111)
REFRESH MATERIALIZED VIEW mv;

-- Test 187: query (line 1114)
SELECT * FROM mv ORDER BY x, y;

-- Test 188: statement (line 1122)
CREATE ROLE bob;

-- Test 189: statement (line 1125)
GRANT ALL ON SCHEMA public TO bob;

-- Test 190: statement (line 1128)
GRANT ALL ON v TO bob;

-- Test 191: statement (line 1131)
GRANT ALL ON mv TO bob;

-- Test 192: statement (line 1134)
REVOKE EXECUTE ON FUNCTION f_scalar() FROM PUBLIC;

-- Test 193: statement (line 1137)
REVOKE EXECUTE ON FUNCTION f_scalar() FROM bob;

-- Test 194: statement (line 1140)
SET ROLE bob;

-- Test 195: statement (line 1143)
SELECT f_scalar();

-- Test 196: statement (line 1146)
SELECT * FROM v;

-- Test 197: statement (line 1149)
SELECT * FROM mv;

-- Test 198: statement (line 1152)
SET ROLE root;

-- Test 199: statement (line 1155)
ALTER FUNCTION f_scalar RENAME TO f_scalar_renamed;

-- Test 200: statement (line 1158)
ALTER FUNCTION f_setof RENAME TO f_setof_renamed;

-- Test 201: statement (line 1161)
DROP FUNCTION f_scalar;

-- Test 202: statement (line 1164)
DROP FUNCTION f_setof;

-- Test 203: statement (line 1167)
DROP VIEW v;

-- Test 204: statement (line 1170)
DROP MATERIALIZED VIEW mv;

-- Test 205: statement (line 1173)
DROP FUNCTION f_scalar;

-- Test 206: statement (line 1176)
DROP FUNCTION f_setof;

-- Test 207: statement (line 1180)
CREATE VIEW v_builtin AS SELECT * FROM generate_series(1, 4);

-- Test 208: query (line 1183)
SELECT * FROM v_builtin ORDER BY 1;

-- Test 209: statement (line 1191)
DROP VIEW v_builtin;

-- Test 210: statement (line 1198)
CREATE TYPE cast_udf_enum AS ENUM ('a', 'b', 'c');

-- Test 211: statement (line 1201)
DROP TABLE IF EXISTS cast_udf_enum_t;

-- Test 212: statement (line 1207)
INSERT INTO cast_udf_enum_t VALUES ('a'), ('a'), ('b')

-- Test 213: statement (line 1210)
CREATE FUNCTION cast_to_enum() RETURNS INT LANGUAGE PLpgSQL AS $$
  DECLARE
    i INT;
  BEGIN
    SELECT count(*) INTO i FROM cast_udf_enum_t WHERE c::cast_udf_enum = 'a'::cast_udf_enum;
    RETURN i;
  END
$$;

-- Test 214: query (line 1220)
SELECT create_statement FROM [SHOW CREATE FUNCTION cast_to_enum];

-- Test 215: query (line 1239)
SELECT cast_to_enum()

-- Test 216: statement (line 1244)
DROP FUNCTION cast_to_enum;

-- Test 217: statement (line 1247)
DROP TABLE cast_udf_enum_t;

-- Test 218: statement (line 1250)
DROP TYPE cast_udf_enum;

-- Test 219: statement (line 1257)
CREATE TYPE composite_coord AS (x INT, y INT);

-- Test 220: statement (line 1263)
CREATE FUNCTION cast_to_composite() RETURNS INT LANGUAGE PLpgSQL AS $$
  DECLARE
    result INT;
  BEGIN
    SELECT 1 INTO result FROM composite_test_t WHERE coord::composite_coord IS NOT NULL;
    RETURN result;
  END
$$;

-- Test 221: query (line 1273)
SELECT create_statement FROM [SHOW CREATE FUNCTION cast_to_composite];

-- Test 222: statement (line 1292)
DROP FUNCTION cast_to_composite;

-- Test 223: statement (line 1295)
DROP TABLE composite_test_t;

-- Test 224: statement (line 1298)
DROP TYPE composite_coord;

-- Test 225: statement (line 1305)
CREATE TYPE array_status AS ENUM ('active', 'inactive', 'pending');

-- Test 226: statement (line 1311)
CREATE FUNCTION process_array() RETURNS INT LANGUAGE PLpgSQL AS $$
  DECLARE
    count INT;
  BEGIN
    SELECT count(*) INTO count FROM array_test_t WHERE statuses[1]::array_status = 'active'::array_status;
    RETURN count;
  END
$$;

-- Test 227: query (line 1321)
SELECT create_statement FROM [SHOW CREATE FUNCTION process_array];

-- Test 228: statement (line 1340)
DROP FUNCTION process_array;

-- Test 229: statement (line 1343)
DROP TABLE array_test_t;

-- Test 230: statement (line 1346)
DROP TYPE array_status;

-- Test 231: statement (line 1353)
CREATE TYPE user_status AS ENUM ('guest', 'member', 'admin');

-- Test 232: statement (line 1362)
CREATE FUNCTION mixed_udt_func() RETURNS TEXT LANGUAGE PLpgSQL AS $$
  DECLARE
    status_val user_status;
    profile_val user_profile;
    result TEXT;
  BEGIN
    SELECT status::user_status, profile::user_profile INTO status_val, profile_val
    FROM mixed_udt_t WHERE status::user_status = 'admin'::user_status;
    result := status_val::TEXT;
    RETURN result;
  END
$$;

-- Test 233: query (line 1376)
SELECT create_statement FROM [SHOW CREATE FUNCTION mixed_udt_func];

-- Test 234: statement (line 1398)
DROP FUNCTION mixed_udt_func;

-- Test 235: statement (line 1401)
DROP TABLE mixed_udt_t;

-- Test 236: statement (line 1404)
DROP TYPE user_profile;

-- Test 237: statement (line 1407)
DROP TYPE user_status;

