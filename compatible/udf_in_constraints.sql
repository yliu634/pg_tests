-- PostgreSQL compatible tests from udf_in_constraints
-- 60 tests

-- Test 1: statement (line 3)
CREATE FUNCTION f1(a INT) RETURNS INT LANGUAGE SQL AS $$ SELECT a + 1 $$;

-- Test 2: statement (line 6)
CREATE VIEW v_checks AS
SELECT
     id,
     jsonb_pretty(
       crdb_internal.pb_to_json(
         'cockroach.sql.sqlbase.Descriptor',
         descriptor,
         false
       )->'table'->'checks'
     ) as checks
FROM system.descriptor

-- Test 3: statement (line 28)
CREATE VIEW v_fn_depended_on_by AS
SELECT
     id,
     jsonb_pretty(
       crdb_internal.pb_to_json(
         'cockroach.sql.sqlbase.Descriptor',
         descriptor,
         false
       )->'function'->'dependedOnBy'
     ) as depended_on_by
FROM system.descriptor

-- Test 4: statement (line 52)
CREATE TABLE t1(
  a INT PRIMARY KEY,
  b INT CHECK (f1(b) > 1),
  FAMILY fam_0 (a, b)
);

let $tbl_id
SELECT id FROM system.namespace WHERE name = 't1';

-- Test 5: query (line 62)
SELECT get_checks($tbl_id);

-- Test 6: query (line 77)
SELECT create_statement FROM [SHOW CREATE TABLE t1];

-- Test 7: query (line 89)
SELECT create_statement FROM [SHOW CREATE TABLE t1];

-- Test 8: query (line 104)
SELECT get_fn_depended_on_by($fn_id)

-- Test 9: statement (line 117)
ALTER TABLE t1 ADD CONSTRAINT cka CHECK (f1(a) > 1);

-- Test 10: statement (line 121)
ALTER TABLE t1 ADD CONSTRAINT ckb CHECK (f1(b) > 2) NOT VALID;

-- Test 11: query (line 124)
SELECT get_checks($tbl_id);

-- Test 12: query (line 155)
SELECT get_fn_depended_on_by($fn_id)

-- Test 13: statement (line 170)
CREATE TABLE t2(
  a INT PRIMARY KEY,
  b INT CHECK (f1(b) > 1),
  CONSTRAINT cka CHECK (f1(a) > 1)
);

-- Test 14: query (line 177)
SELECT get_fn_depended_on_by($fn_id)

-- Test 15: statement (line 199)
ALTER TABLE t2 DROP CONSTRAINT check_b;

-- Test 16: query (line 202)
SELECT get_fn_depended_on_by($fn_id)

-- Test 17: statement (line 222)
ALTER TABLE t2 DROP CONSTRAINT cka;

-- Test 18: query (line 225)
SELECT get_fn_depended_on_by($fn_id)

-- Test 19: statement (line 240)
DROP TABLE t1;
DROP TABLE t2;

-- Test 20: query (line 244)
SELECT get_fn_depended_on_by($fn_id)

-- Test 21: statement (line 250)
CREATE TABLE t1(
  a INT PRIMARY KEY,
  b INT CHECK (f1(b) > 1),
  FAMILY fam_0 (a, b)
);
CREATE TABLE t2(
  a INT PRIMARY KEY,
  b INT CHECK (f1(b) > 1),
  FAMILY fam_0 (a, b)
);

-- Test 22: statement (line 262)
DROP FUNCTION f1;

-- Test 23: statement (line 265)
ALTER TABLE t1 DROP CONSTRAINT check_b;
ALTER TABLE t2 DROP CONSTRAINT check_b;

-- Test 24: statement (line 269)
DROP FUNCTION f1;

-- Test 25: statement (line 272)
DROP TABLE t1;
DROP TABLE t2;

-- Test 26: statement (line 277)
BEGIN;
CREATE FUNCTION f1(a INT) RETURNS INT LANGUAGE SQL AS $$ SELECT a + 1 $$;
CREATE TABLE t1(
  a INT PRIMARY KEY,
  b INT CHECK (f1(b) > 1),
  FAMILY fam_0 (a, b)
);
END;

let $tbl_id
SELECT id FROM system.namespace WHERE name = 't1';

let $fn_id
SELECT oid::int - 100000 FROM pg_catalog.pg_proc WHERE proname = 'f1';

-- Test 27: query (line 293)
SELECT get_checks($tbl_id);

-- Test 28: query (line 307)
SELECT get_fn_depended_on_by($fn_id);

-- Test 29: statement (line 319)
BEGIN;
DROP TABLE t1;
DROP FUNCTION f1;
END;

-- Test 30: statement (line 326)
CREATE TABLE t1 (
  a INT PRIMARY KEY,
  b INT,
  FAMILY fam_0 (a, b)
);

-- Test 31: statement (line 333)
BEGIN;
CREATE FUNCTION f1(a INT) RETURNS INT LANGUAGE SQL AS $$ SELECT a + 1 $$;
ALTER TABLE t1 ADD CONSTRAINT check_b CHECK (f1(b) > 1);
END;

let $tbl_id
SELECT id FROM system.namespace WHERE name = 't1';

let $fn_id
SELECT oid::int - 100000 FROM pg_catalog.pg_proc WHERE proname = 'f1';

-- Test 32: query (line 345)
SELECT get_checks($tbl_id);

-- Test 33: query (line 359)
SELECT get_fn_depended_on_by($fn_id);

-- Test 34: statement (line 372)
SET use_declarative_schema_changer = 'unsafe_always';

-- Test 35: statement (line 378)
BEGIN;
ALTER TABLE t1 DROP CONSTRAINT check_b;
DROP FUNCTION f1;
END;

-- Test 36: statement (line 384)
DROP TABLE t1;

skipif config local-legacy-schema-changer

-- Test 37: statement (line 388)
SET use_declarative_schema_changer = 'on';

-- Test 38: statement (line 393)
CREATE OR REPLACE FUNCTION f1(a INT) RETURNS INT LANGUAGE SQL AS $$ SELECT a + 1 $$;
CREATE TABLE t1 (
  a INT PRIMARY KEY,
  b INT CHECK (f1(b) > 1),
  FAMILY fam_0 (a, b)
);

-- Test 39: statement (line 401)
INSERT INTO t1 VALUES (1,0);

-- Test 40: statement (line 404)
INSERT INTO t1 VALUES (1,1);

-- Test 41: statement (line 407)
ALTER TABLE t1 ADD CONSTRAINT cka CHECK (f1(a) > 10);

-- Test 42: statement (line 411)
ALTER TABLE t1 ADD CONSTRAINT cka CHECK (f1(a) > 1);

-- Test 43: statement (line 414)
INSERT INTO t1 VALUES (2, -1);

-- Test 44: statement (line 417)
ALTER FUNCTION f1 RENAME to f2;

-- Test 45: statement (line 420)
INSERT INTO t1 VALUES (2, -1);

onlyif config schema-locked-disabled

-- Test 46: query (line 424)
SELECT create_statement FROM [SHOW CREATE TABLE t1]

-- Test 47: query (line 437)
SELECT create_statement FROM [SHOW CREATE TABLE t1]

-- Test 48: statement (line 452)
CREATE DATABASE db1;
USE db1;
CREATE SCHEMA sc1;
CREATE FUNCTION sc1.f1(a INT) RETURNS INT LANGUAGE SQL AS $$ SELECT a + 1 $$;
CREATE FUNCTION sc1.f1() RETURNS INT LANGUAGE SQL AS $$ SELECT 1 $$;
CREATE TABLE t(
  a INT PRIMARY KEY,
  b INT CHECK (sc1.f1(b) > 1),
  FAMILY fam_0_b_a (b, a)
);

onlyif config schema-locked-disabled

-- Test 49: query (line 465)
SELECT create_statement FROM [SHOW CREATE TABLE t]

-- Test 50: query (line 477)
SELECT create_statement FROM [SHOW CREATE TABLE t]

-- Test 51: statement (line 489)
CREATE TABLE t_circle(a INT PRIMARY KEY, b INT);
CREATE FUNCTION f_circle() RETURNS INT LANGUAGE SQL AS $$ SELECT a FROM t_circle $$;

-- Test 52: statement (line 494)
ALTER TABLE t_circle ADD CONSTRAINT ckb CHECK (b + f_circle() > 1);

-- Test 53: statement (line 501)
CREATE FUNCTION true_is_true() RETURNS BOOL LANGUAGE SQL AS $$ SELECT true = true $$;

-- Test 54: statement (line 504)
BEGIN;
CREATE TABLE alter_add_check_constraint();
ALTER TABLE alter_add_check_constraint ADD CONSTRAINT noop CHECK (true_is_true());
COMMIT;

onlyif config schema-locked-disabled

-- Test 55: query (line 511)
SELECT create_statement FROM [SHOW CREATE TABLE alter_add_check_constraint];

-- Test 56: query (line 521)
SELECT create_statement FROM [SHOW CREATE TABLE alter_add_check_constraint];

-- Test 57: statement (line 535)
CREATE TABLE accounts_a (id UUID NOT NULL, FAMILY "primary" (id, rowid));
CREATE TABLE accounts_b (id UUID NOT NULL, FAMILY "primary" (id, rowid));
CREATE FUNCTION is_a_or_b(account_id UUID, account_type TEXT) RETURNS BOOL LANGUAGE SQL AS $$ SELECT (CASE
        WHEN account_type = 'type_a' THEN (SELECT EXISTS(SELECT * FROM accounts_a WHERE id = account_id))
        WHEN account_type = 'type_b' THEN (SELECT EXISTS(SELECT * FROM accounts_b WHERE id = account_id))
        ELSE false
END) $$;

-- Test 58: statement (line 544)
BEGIN;
CREATE TABLE a (
  account_id UUID NOT NULL,
  account_type TEXT NOT NULL,
  FAMILY "primary" (account_id, account_type, rowid)
);
ALTER TABLE a ADD CONSTRAINT is_a_or_b CHECK (is_a_or_b(account_id, account_type));
COMMIT;

skipif config schema-locked-disabled

-- Test 59: query (line 555)
SELECT create_statement FROM [SHOW CREATE TABLE a];

-- Test 60: query (line 567)
SELECT create_statement FROM [SHOW CREATE TABLE a];

