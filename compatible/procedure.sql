-- PostgreSQL compatible tests from procedure
-- 130 tests

SET client_min_messages = warning;

-- Test 1: statement (line 1)
CREATE PROCEDURE p() LANGUAGE SQL AS $$
  SELECT 1;
$$;

-- Test 2: query (line 5)
SELECT prokind = 'p' AS is_procedure
FROM pg_proc
WHERE proname = 'p'
  AND pronamespace = 'public'::regnamespace;

-- Test 3: statement (line 13)
CREATE SEQUENCE s;

-- Test 4: statement (line 16)
CREATE OR REPLACE PROCEDURE p() LANGUAGE SQL AS $$
  SELECT nextval('s');
$$;

-- Test 5: statement (line 21)
CALL p();

-- Test 6: query (line 24)
SELECT currval('s');

-- Test 7: statement (line 29)
CREATE OR REPLACE PROCEDURE p() LANGUAGE SQL AS $$
  SELECT 1;
$$;

-- Test 8: statement (line 34)
CALL p();

-- Test 9: query (line 38)
SELECT currval('s');

-- Test 10: statement (line 44)
\set ON_ERROR_STOP 0
SELECT p();

-- Test 11: statement (line 47)
CALL p(p());

-- Test 12: statement (line 50)
SELECT * FROM (VALUES (1), (2), (3)) LIMIT p();

-- Test 13: statement (line 53)
SELECT * FROM (VALUES (1), (2), (3)) ORDER BY p();

-- Test 14: statement (line 56)
SELECT * FROM (VALUES (1), (2), (3)) v(i) WHERE i = p();

-- Test 15: statement (line 59)
SELECT * FROM (VALUES (1), (2), (3)) v(i) GROUP BY i HAVING i > p();

-- Test 16: statement (line 62)
SELECT * FROM (VALUES (1), (2)) v(i) JOIN (VALUES (2), (3)) w(j) ON i = p();

-- Test 17: statement (line 65)
SELECT * FROM generate_series(1, p());

-- Test 18: statement (line 68)
SELECT * FROM generate_series(1, p());

-- Test 19: statement (line 71)
SELECT abs(p());

-- Test 20: statement (line 74)
SELECT nth_value(1, p()) OVER () FROM (VALUES (1), (2));

-- Test 21: statement (line 77)
SELECT nth_value(1, i) OVER (ORDER BY p()) FROM (VALUES (1), (2)) v(i);
\set ON_ERROR_STOP 1

-- Test 22: statement (line 80)
CREATE OR REPLACE PROCEDURE p() LANGUAGE SQL AS $$ $$;

-- Test 23: statement (line 84)
\set ON_ERROR_STOP 0
SELECT p();
\set ON_ERROR_STOP 1

-- Test 24: statement (line 87)
CREATE OR REPLACE PROCEDURE p(i INT) LANGUAGE SQL AS $$ $$;

-- Test 25: statement (line 90)
\set ON_ERROR_STOP 0
SELECT p(1);
\set ON_ERROR_STOP 1

-- Test 26: statement (line 95)
\set ON_ERROR_STOP 0
CALL no_exist();
\set ON_ERROR_STOP 1

-- Test 27: statement (line 98)
\set ON_ERROR_STOP 0
CALL p(1, 'foo');
\set ON_ERROR_STOP 1

-- Test 28: statement (line 103)
\set ON_ERROR_STOP 0
CALL p(foo());
\set ON_ERROR_STOP 1

-- Test 29: statement (line 106)
CREATE FUNCTION foo(i INT) RETURNS VOID LANGUAGE SQL AS $$ $$;

-- Test 30: statement (line 110)
\set ON_ERROR_STOP 0
CALL p(foo());
\set ON_ERROR_STOP 1

-- Test 31: statement (line 113)
\set ON_ERROR_STOP 0
CREATE FUNCTION p() RETURNS VOID LANGUAGE SQL AS $$ $$;
\set ON_ERROR_STOP 1

-- Test 32: statement (line 116)
\set ON_ERROR_STOP 0
CREATE FUNCTION err(i INT) RETURNS VOID LANGUAGE SQL AS $$ SELECT p(); $$;
\set ON_ERROR_STOP 1

-- Test 33: statement (line 119)
\set ON_ERROR_STOP 0
CREATE TABLE err (i INT DEFAULT p());
\set ON_ERROR_STOP 1

-- Test 34: statement (line 122)
\set ON_ERROR_STOP 0
CREATE TABLE err (i INT GENERATED ALWAYS AS (p()) STORED);
\set ON_ERROR_STOP 1

-- Test 35: statement (line 125)
CREATE TABLE err (i INT);
\set ON_ERROR_STOP 0
CREATE INDEX err_p_idx ON err (p());
\set ON_ERROR_STOP 1
DROP TABLE err;

-- Test 36: statement (line 128)
CREATE TABLE err (a INT, b INT);
\set ON_ERROR_STOP 0
CREATE INDEX err_ab_idx ON err (a, (b + p()));
\set ON_ERROR_STOP 1
DROP TABLE err;

-- Test 37: statement (line 131)
CREATE TABLE err (a INT);
\set ON_ERROR_STOP 0
CREATE INDEX err_a_idx ON err (a) WHERE p() = 1;
\set ON_ERROR_STOP 1
DROP TABLE err;

-- Test 38: statement (line 134)
CREATE TABLE t (
  k INT PRIMARY KEY,
  v INT
);
INSERT INTO t VALUES (1, 10);

-- Test 39: statement (line 141)
CREATE OR REPLACE PROCEDURE t_update(k_arg INT, v_arg INT) LANGUAGE SQL AS $$
  UPDATE t SET v = v_arg WHERE k = k_arg;
$$;

-- Test 40: statement (line 146)
CALL t_update(1, 11);

-- Test 41: statement (line 149)
CALL t_update(2, 22);

-- Test 42: query (line 152)
SELECT * FROM t;

-- Test 43: statement (line 157)
CREATE FUNCTION one() RETURNS INT LANGUAGE SQL AS $$ SELECT 1; $$;

-- Test 44: statement (line 160)
CALL t_update(one(), 12);

-- Test 45: query (line 163)
SELECT * FROM t;

-- Test 46: statement (line 168)
CALL t_update(one(), one()+12);

-- Test 47: query (line 171)
SELECT * FROM t;

-- Test 48: statement (line 176)
CREATE FUNCTION t_update() RETURNS INT LANGUAGE SQL AS $$ SELECT 1; $$;

-- Test 49: query (line 181)
SELECT t_update();

-- Test 50: statement (line 188)
CALL t_update(1, 110+1);

-- Test 51: query (line 191)
SELECT * FROM t;

-- Test 52: statement (line 201)
CALL t_update(1, 1111);

-- Test 53: query (line 204)
SELECT * FROM t;

-- Test 54: statement (line 216)
CALL t_update(1, 0);

-- Setup for anon-arg procedure calls.
CREATE TABLE anon_args (i INT, s TEXT);
CREATE PROCEDURE insert_into_anon_args(i INT, s TEXT) LANGUAGE SQL AS $$
  INSERT INTO anon_args VALUES (i, s);
$$;
CREATE PROCEDURE insert_into_anon_args(s TEXT, i INT) LANGUAGE SQL AS $$
  INSERT INTO anon_args VALUES (i, s);
$$;

-- Test 55: statement (line 229)
CALL insert_into_anon_args(1, 'a');

-- Test 56: query (line 232)
SELECT * FROM anon_args ORDER BY i;

-- Test 57: statement (line 242)
CALL insert_into_anon_args('b', 2);

-- Test 58: query (line 245)
SELECT * FROM anon_args ORDER BY i;

-- Setup for overload/replace procedure calls.
CREATE TABLE replace (k INT PRIMARY KEY, v TEXT);
CREATE PROCEDURE insert_into_replace(k_new INT, v_new TEXT) LANGUAGE SQL AS $$
  INSERT INTO replace(k, v) VALUES (k_new, v_new)
  ON CONFLICT (k) DO UPDATE SET v = EXCLUDED.v;
$$;
CREATE PROCEDURE insert_into_replace_v2(k_new INT, v_new TEXT) LANGUAGE SQL AS $$
  CALL insert_into_replace(k_new, v_new);
$$;

-- Test 59: statement (line 268)
CALL insert_into_replace(1, 'a');

-- Test 60: statement (line 279)
CALL insert_into_replace(1, 'a');

-- Test 61: query (line 282)
SELECT * FROM replace ORDER BY k;

-- Test 62: statement (line 289)
CREATE OR REPLACE PROCEDURE insert_into_replace(k_new INT) LANGUAGE SQL AS $$
  INSERT INTO replace(k, v) VALUES (k_new, 'overload');
$$;

-- Test 63: statement (line 300)
CALL insert_into_replace(2, 'b');
CALL insert_into_replace(3);
CALL insert_into_replace_v2(4, 'b');

-- Test 64: query (line 305)
SELECT * FROM replace ORDER BY k;

-- Test 65: statement (line 324)
CREATE PROCEDURE rfp(i INT) LANGUAGE SQL AS $$ SELECT 0; $$;

-- Test 66: statement (line 327)
\set ON_ERROR_STOP 0
SELECT rfp(1);
\set ON_ERROR_STOP 1

-- Test 67: statement (line 330)
DROP PROCEDURE rfp(INT);

-- Test 68: statement (line 333)
CREATE FUNCTION rfp(i INT) RETURNS INT LANGUAGE SQL AS $$ SELECT 100+i; $$;

-- Test 69: query (line 336)
SELECT rfp(1);

-- Test 70: statement (line 341)
DROP FUNCTION rfp;
CREATE PROCEDURE rfp(i INT) LANGUAGE SQL AS $$ SELECT 0; $$;

-- Test 71: statement (line 347)
\set ON_ERROR_STOP 0
SELECT rfp(1);
\set ON_ERROR_STOP 1

-- Test 72: statement (line 350)
DROP PROCEDURE rfp(INT);

-- Test 73: statement (line 357)
CREATE PROCEDURE p111021(i INT) LANGUAGE SQL AS $$ SELECT i; $$;

-- Test 74: statement (line 361)
\set ON_ERROR_STOP 0
CALL p111021((SELECT 1));
\set ON_ERROR_STOP 1

-- Test 75: statement (line 366)
\set ON_ERROR_STOP 0
CALL p111021(CASE WHEN false THEN 1 ELSE (SELECT 1) END);
\set ON_ERROR_STOP 1

-- Test 76: statement (line 370)
\set ON_ERROR_STOP 0
CALL p(ALL NULL);
\set ON_ERROR_STOP 1

-- Test 77: statement (line 374)
\set ON_ERROR_STOP 0
CALL p(ALL 1);
\set ON_ERROR_STOP 1

-- Test 78: statement (line 378)
\set ON_ERROR_STOP 0
CALL family(ALL NULL);
\set ON_ERROR_STOP 1

-- Test 79: statement (line 385)
\set ON_ERROR_STOP 0
CREATE PROCEDURE pv() AS 'SELECT 1' VOLATILE LANGUAGE SQL;

-- Test 80: statement (line 388)
CREATE PROCEDURE pv() AS 'SELECT 1' IMMUTABLE LANGUAGE SQL;

-- Test 81: statement (line 391)
CREATE PROCEDURE pv() AS 'SELECT 1' STABLE LANGUAGE SQL;

-- Test 82: statement (line 394)
CREATE PROCEDURE pv() AS 'SELECT 1' LEAKPROOF LANGUAGE SQL;

-- Test 83: statement (line 397)
CREATE PROCEDURE pv() AS 'SELECT 1' NOT LEAKPROOF LANGUAGE SQL;

-- Test 84: statement (line 400)
CREATE PROCEDURE pv() AS 'SELECT 1' CALLED ON NULL INPUT LANGUAGE SQL;

-- Test 85: statement (line 403)
CREATE PROCEDURE pv() AS 'SELECT 1' STRICT LANGUAGE SQL;
\set ON_ERROR_STOP 1

-- Test 86: statement (line 410)
\set ON_ERROR_STOP 0
CALL sum(1);
\set ON_ERROR_STOP 1

-- Test 87: statement (line 413)
\set ON_ERROR_STOP 0
CALL first_value(1);
\set ON_ERROR_STOP 1

-- Test 88: statement (line 416)
\set ON_ERROR_STOP 0
CALL addgeometrycolumn(null, null, null, null, null);
\set ON_ERROR_STOP 1

-- Test 89: statement (line 422)
-- Cockroach-only: calling a function by OID via `[ FUNCTION <oid> ]` is not supported in PostgreSQL.

-- Test 90: statement (line 427)
CREATE PROCEDURE p_inner(OUT param INTEGER) LANGUAGE SQL AS $$ SELECT 1; $$;

-- Test 91: statement (line 430)
\set ON_ERROR_STOP 0
CREATE FUNCTION f() RETURNS INT LANGUAGE SQL AS $$ CALL p_inner(NULL); $$;
\set ON_ERROR_STOP 1

-- Test 92: statement (line 433)
\set ON_ERROR_STOP 0
CREATE PROCEDURE p_outer(OUT param INTEGER) LANGUAGE SQL AS $$ CALL p_inner(NULL); $$;
\set ON_ERROR_STOP 1

-- Test 93: statement (line 436)
\set ON_ERROR_STOP 0
DROP PROCEDURE p_inner;
\set ON_ERROR_STOP 1

-- Test 94: statement (line 442)
CREATE TYPE one_typ AS (x INT);
CREATE TYPE two_typ AS (x INT, y INT);

-- Test 95: statement (line 446)
\set ON_ERROR_STOP 0
DROP PROCEDURE p(INT);
DROP PROCEDURE p;
\set ON_ERROR_STOP 1

-- Test 96: statement (line 451)
\set ON_ERROR_STOP 0
CREATE PROCEDURE p(OUT foo one_typ) LANGUAGE SQL AS $$ SELECT 1; $$;
\set ON_ERROR_STOP 1

-- Test 97: statement (line 454)
CREATE PROCEDURE p(OUT foo one_typ) LANGUAGE SQL AS $$ SELECT ROW(1); $$;

-- Test 98: query (line 457)
CALL p(NULL);

-- Test 99: statement (line 462)
DROP PROCEDURE p;
\set ON_ERROR_STOP 0
CREATE PROCEDURE p(OUT foo one_typ) LANGUAGE SQL AS $$ SELECT ROW(ROW(1)); $$;
\set ON_ERROR_STOP 1

-- Test 100: query (line 466)
\set ON_ERROR_STOP 0
CALL p(NULL);
\set ON_ERROR_STOP 1

-- Test 101: statement (line 471)
\set ON_ERROR_STOP 0
DROP PROCEDURE p;
\set ON_ERROR_STOP 1

-- Test 102: statement (line 475)
\set ON_ERROR_STOP 0
CREATE PROCEDURE p(OUT foo two_typ) LANGUAGE SQL AS $$ SELECT 1, 2; $$;
\set ON_ERROR_STOP 1

-- Test 103: statement (line 478)
CREATE PROCEDURE p(OUT foo two_typ) LANGUAGE SQL AS $$ SELECT ROW(1, 2); $$;

-- Test 104: query (line 481)
CALL p(NULL);

-- Test 105: statement (line 486)
DROP PROCEDURE p;
\set ON_ERROR_STOP 0
CREATE PROCEDURE p(OUT foo two_typ) LANGUAGE SQL AS $$ SELECT ROW(ROW(1, 2)); $$;
\set ON_ERROR_STOP 1

-- Test 106: query (line 490)
\set ON_ERROR_STOP 0
CALL p(NULL);
\set ON_ERROR_STOP 1

-- Test 107: statement (line 496)
\set ON_ERROR_STOP 0
DROP PROCEDURE p;
\set ON_ERROR_STOP 1
CREATE PROCEDURE p(OUT x INT, OUT y INT) LANGUAGE SQL AS $$ SELECT 1, 2; $$;

-- Test 108: query (line 500)
CALL p(NULL, NULL);

-- Test 109: statement (line 505)
DROP PROCEDURE p;
\set ON_ERROR_STOP 0
CREATE PROCEDURE p(OUT x INT, OUT y INT) LANGUAGE SQL AS $$ SELECT ROW(1, 2); $$;
\set ON_ERROR_STOP 1

-- Test 110: query (line 509)
\set ON_ERROR_STOP 0
CALL p(NULL, NULL);
\set ON_ERROR_STOP 1

-- Test 111: statement (line 514)
\set ON_ERROR_STOP 0
DROP PROCEDURE p;
\set ON_ERROR_STOP 1

-- Test 112: statement (line 517)
\set ON_ERROR_STOP 0
CREATE PROCEDURE p(OUT x INT, OUT y INT) LANGUAGE SQL AS $$ SELECT ROW(ROW(1, 2)); $$;
\set ON_ERROR_STOP 1

-- Test 113: statement (line 523)
CREATE TABLE bank (accountno INT PRIMARY KEY, balance NUMERIC);
CREATE PROCEDURE withdraw(accountno INT, debit NUMERIC, OUT new_balance NUMERIC) LANGUAGE SQL AS $$
    UPDATE bank
        SET balance = balance - debit
        WHERE bank.accountno = accountno
    RETURNING balance;
$$;

-- Test 114: statement (line 532)
\set ON_ERROR_STOP 0
CALL withdraw(17, 100.0, NULL);
\set ON_ERROR_STOP 1

-- Test 115: statement (line 535)
INSERT INTO bank VALUES (17, 1000.0);

-- Test 116: query (line 538)
CALL withdraw(17, 100.0, NULL);

-- Test 117: statement (line 543)
DROP PROCEDURE withdraw;
DROP TABLE bank;

-- Test 118: statement (line 549)
CREATE PROCEDURE p142886(p VARCHAR(10)) LANGUAGE SQL AS $$ SELECT 0; $$;

-- Test 119: statement (line 552)
\set ON_ERROR_STOP 0
CREATE PROCEDURE p142886(p VARCHAR(100)) LANGUAGE SQL AS $$ SELECT 0; $$;
\set ON_ERROR_STOP 1

-- Test 120: statement (line 555)
DROP PROCEDURE p142886;

-- Test 121: statement (line 560)
CREATE TABLE xy (x INT, y INT);

-- Test 122: statement (line 563)
CREATE PROCEDURE p1_143282() LANGUAGE PLpgSQL AS $$
  BEGIN
    INSERT INTO xy VALUES (1, 2);
  END;
$$;

-- Test 123: statement (line 570)
CREATE PROCEDURE p2_143282() LANGUAGE PLpgSQL AS $$
  DECLARE foo INT;
  BEGIN
    CALL p1_143282();
  END;
$$;

-- Test 124: statement (line 578)
CREATE PROCEDURE p3_143282() LANGUAGE PLpgSQL AS $$
  BEGIN
    CALL p1_143282();
    CALL p2_143282();
  END;
$$;

-- Test 125: statement (line 586)
CALL p3_143282();

-- Test 126: query (line 590)
SELECT * FROM xy ORDER BY x;

-- Test 127: statement (line 596)
DROP TABLE xy CASCADE;

-- Test 128: statement (line 599)
\set ON_ERROR_STOP 0
CALL p3_143282();
\set ON_ERROR_STOP 1

-- Test 129: statement (line 602)
\set ON_ERROR_STOP 0
CALL p2_143282();
\set ON_ERROR_STOP 1

-- Test 130: statement (line 605)
\set ON_ERROR_STOP 0
CALL p1_143282();
\set ON_ERROR_STOP 1

RESET client_min_messages;
