-- PostgreSQL compatible tests from pgoidtype
-- 91 tests

-- Test 1: query (line 3)
SELECT 3::OID, '3'::OID

-- Test 2: query (line 8)
SELECT 3::OID::INT::OID

-- Test 3: query (line 13)
SELECT 1::OID, 1::REGCLASS, 1::REGNAMESPACE, 1::REGPROC, 1::REGPROCEDURE, 1::REGROLE, 1::REGTYPE

-- Test 4: query (line 18)
SELECT 1::OID::REGCLASS, 1::OID::REGNAMESPACE, 1::OID::REGPROC, 1::OID::REGPROCEDURE, 1::OID::REGROLE, 1::OID::REGTYPE

-- Test 5: query (line 23)
SELECT pg_typeof(1::OID), pg_typeof(1::REGCLASS), pg_typeof(1::REGNAMESPACE)

-- Test 6: query (line 28)
SELECT pg_typeof(1::REGPROC), pg_typeof(1::REGPROCEDURE), pg_typeof(1::REGROLE), pg_typeof(1::REGTYPE)

-- Test 7: query (line 33)
SELECT pg_typeof('1'::OID), pg_typeof('pg_constraint'::REGCLASS), pg_typeof('public'::REGNAMESPACE)

-- Test 8: statement (line 41)
SELECT 'upper'::REGPROCEDURE

-- Test 9: statement (line 44)
SELECT 'upper(int)'::REGPROCEDURE

-- Test 10: query (line 52)
SELECT pg_typeof('root'::REGROLE), pg_typeof('bool'::REGTYPE)

-- Test 11: query (line 57)
SELECT 'pg_constraint'::REGCLASS, 'pg_catalog.pg_constraint'::REGCLASS

-- Test 12: query (line 62)
SELECT 'foo.pg_constraint'::REGCLASS

query OO
SELECT '"pg_constraint"'::REGCLASS, '  "pg_constraint" '::REGCLASS

-- Test 13: query (line 70)
SELECT 'pg_constraint '::REGCLASS, '  pg_constraint '::REGCLASS

-- Test 14: query (line 77)
SELECT 'pg_constraint '::REGCLASS, ('"pg_constraint"'::REGCLASS::OID::INT-'"pg_constraint"'::REGCLASS::OID::INT)::OID

-- Test 15: query (line 82)
SELECT 4061301040::REGCLASS

-- Test 16: query (line 87)
SELECT (oid::int-oid::int)::oid, oid::regclass, (oid::regclass::int-oid::regclass::int), oid::regclass::int::regclass, oid::regclass::text
FROM pg_class
WHERE relname = 'pg_constraint'

-- Test 17: query (line 107)
SELECT 'blah(ignored)'::REGPROC

query error pq: unknown function: blah\(\)
SELECT 'blah(int, int)'::REGPROCEDURE

query error pq: invalid name: expected separator .: blah \( ignored , ignored \)
SELECT ' blah ( ignored , ignored ) '::REGPROC

query error pq: invalid name: expected separator .: blah \(\)
SELECT 'blah ()'::REGPROC

query error pq: invalid name: expected separator .: blah\( \)
SELECT 'blah( )'::REGPROC

query error invalid name: expected separator \.: blah\(, \)
SELECT 'blah(, )'::REGPROC

query error more than one function named 'sqrt'
SELECT 'sqrt'::REGPROC

query OO
SELECT 'array_in'::REGPROC, 'pg_catalog.array_in'::REGPROC

-- Test 18: query (line 133)
SELECT 'array_in(int)'::REGPROCEDURE, 'pg_catalog.array_in(int)'::REGPROCEDURE

-- Test 19: query (line 138)
SELECT 'public'::REGNAMESPACE, 'public'::REGNAMESPACE::OID

-- Test 20: query (line 143)
SELECT 'root'::REGROLE, 'root'::REGROLE::OID

-- Test 21: query (line 148)
SELECT 'bool'::REGTYPE, 'bool'::REGTYPE::OID

-- Test 22: query (line 153)
SELECT 'numeric(10,3)'::REGTYPE, 'numeric( 10, 3 )'::REGTYPE

-- Test 23: query (line 158)
SELECT '"char"'::REGTYPE, 'pg_catalog.int4'::REGTYPE

-- Test 24: query (line 163)
SELECT 'foo.'::REGTYPE

query error pgcode 42P01 relation "blah" does not exist
SELECT 'blah'::REGCLASS

query error pgcode 42883 unknown function: blah\(\)
SELECT 'blah'::REGPROC

query error pgcode 42883 unknown function: blah\(\)
SELECT 'blah()'::REGPROCEDURE

query error pgcode 42704 namespace 'blah' does not exist
SELECT 'blah'::REGNAMESPACE

query error pgcode 42704 role 'blah' does not exist
SELECT 'blah'::REGROLE

query error pgcode 42704 type 'blah' does not exist
SELECT 'blah'::REGTYPE

query error pgcode 42704 type 'pg_catalog.int' does not exist
SELECT 'pg_catalog.int'::REGTYPE

## Test other cast syntaxes

query O
SELECT CAST ('pg_constraint' AS REGCLASS)

-- Test 25: query (line 195)
SELECT ('pg_constraint')::REGCLASS, (('pg_constraint')::REGCLASS::OID::INT-('pg_constraint')::REGCLASS::OID::INT)::OID

-- Test 26: statement (line 202)
CREATE TABLE a (id INT PRIMARY KEY);
CREATE TYPE typ AS ENUM ('a')

let $table_oid
SELECT c.oid FROM pg_class c WHERE c.relname = 'a';

-- Test 27: query (line 209)
SELECT $table_oid::oid::regclass

-- Test 28: query (line 217)
SELECT $type_oid::oid::regtype

-- Test 29: query (line 222)
SELECT relname from pg_class where oid='a'::regclass

-- Test 30: query (line 227)
SELECT typname from pg_type where oid='typ'::regtype

-- Test 31: statement (line 234)
CREATE TABLE hasCase (id INT PRIMARY KEY);
CREATE TYPE typHasCase AS ENUM ('a')

-- Test 32: query (line 238)
SELECT relname from pg_class where oid='hasCase'::regclass

-- Test 33: query (line 243)
SELECT typname from pg_type where oid='typHasCase'::regtype

-- Test 34: statement (line 248)
CREATE TABLE "quotedCase" (id INT PRIMARY KEY)

-- Test 35: statement (line 251)
CREATE TYPE "typQuotedCase" AS ENUM ('a')

-- Test 36: query (line 254)
SELECT relname from pg_class where oid='quotedCase'::regclass

query T
SELECT relname from pg_class where oid='"quotedCase"'::regclass

-- Test 37: query (line 262)
SELECT typname from pg_type where oid='typQuotedCase'::regtype

query T
SELECT typname from pg_type where oid='"typQuotedCase"'::regtype

-- Test 38: statement (line 273)
GRANT ALL ON DATABASE test TO testuser

-- Test 39: statement (line 276)
GRANT SELECT ON test.* TO testuser

user testuser

-- Test 40: query (line 281)
SELECT relname from pg_class where oid='a'::regclass

-- Test 41: query (line 286)
SELECT typname from pg_type where oid='typ'::regtype

-- Test 42: statement (line 293)
CREATE DATABASE otherdb

-- Test 43: statement (line 300)
SET DATABASE = otherdb

-- Test 44: query (line 331)
SELECT t.typname, count(*) FROM pg_type t
LEFT JOIN pg_enum e ON t.oid = e.enumtypid
WHERE t.oid = 'typ'::regtype
GROUP BY t.typname;

-- Test 45: statement (line 339)
SET DATABASE = test

-- Test 46: query (line 342)
SELECT relname, relnatts FROM pg_class WHERE oid='a'::regclass

-- Test 47: query (line 347)
SELECT t.typname, count(*) FROM pg_type t
LEFT JOIN pg_enum e ON t.oid = e.enumtypid
WHERE t.oid = 'typ'::regtype
GROUP BY t.typname;

-- Test 48: statement (line 355)
CREATE DATABASE thirddb

-- Test 49: statement (line 358)
SET DATABASE = thirddb

-- Test 50: query (line 365)
SELECT relname, relnatts FROM pg_class WHERE oid='a'::regclass

query error pgcode 42704 type 'typ' does not exist
SELECT t.typname, count(*) FROM pg_type t
LEFT JOIN pg_enum e ON t.oid = e.enumtypid
WHERE t.oid = 'typ'::regtype
GROUP BY t.typname;

statement ok
CREATE TABLE o (a OID PRIMARY KEY)

statement ok
INSERT INTO o VALUES (1), (4)

query O
SELECT * FROM o WHERE a < 3

-- Test 51: query (line 385)
SELECT * FROM o WHERE a <= 4

-- Test 52: query (line 393)
SELECT NOT (prorettype::regtype::text = 'foo') AND proretset FROM pg_proc WHERE proretset=false LIMIT 1

-- Test 53: query (line 398)
SELECT crdb_internal.create_regtype(10, 'foo'),
       crdb_internal.create_regclass(10, 'foo'),
       crdb_internal.create_regproc(10, 'foo'),
       crdb_internal.create_regprocedure(10, 'foo'),
       crdb_internal.create_regnamespace(10, 'foo'),
       crdb_internal.create_regrole(10, 'foo')

-- Test 54: query (line 408)
SELECT crdb_internal.create_regtype(10, 'foo')::oid,
       crdb_internal.create_regclass(10, 'foo')::oid,
       crdb_internal.create_regproc(10, 'foo')::oid,
       crdb_internal.create_regprocedure(10, 'foo')::oid,
       crdb_internal.create_regnamespace(10, 'foo')::oid,
       crdb_internal.create_regrole(10, 'foo')::oid

-- Test 55: query (line 421)
VALUES ('pg_constraint'::REGCLASS, 'pg_catalog.pg_constraint'::REGCLASS)

-- Test 56: query (line 427)
SELECT proargtypes::REGTYPE[] FROM pg_proc WHERE proname = 'obj_description'

-- Test 57: query (line 434)
SELECT 'trigger'::REGTYPE::INT

-- Test 58: query (line 441)
SELECT 1::OID::TEXT, quote_literal(1::OID)

-- Test 59: statement (line 447)
SELECT
  c.oid,
  a.attnum,
  a.attname,
  c.relname,
  n.nspname,
  a.attnotnull
  OR (t.typtype = 'd' AND t.typnotnull),
  pg_catalog.pg_get_expr(d.adbin, d.adrelid) LIKE '%nextval(%'
FROM
  pg_catalog.pg_class AS c
  JOIN pg_catalog.pg_namespace AS n ON (c.relnamespace = n.oid)
  JOIN pg_catalog.pg_attribute AS a ON (c.oid = a.attrelid)
  JOIN pg_catalog.pg_type AS t ON (a.atttypid = t.oid)
  LEFT JOIN pg_catalog.pg_attrdef AS d ON
      (d.adrelid = a.attrelid AND d.adnum = a.attnum)
  JOIN (SELECT 1 AS oid, 1 AS attnum) AS vals ON
      (c.oid = vals.oid AND a.attnum = vals.attnum);

-- Test 60: statement (line 467)
SELECT '\"regression_53686\"'::regclass

-- Test 61: statement (line 470)
CREATE TABLE "regression_53686""" (a int)

-- Test 62: query (line 473)
SELECT 'regression_53686"'::regclass

-- Test 63: query (line 478)
SELECT 'public.regression_53686"'::regclass

-- Test 64: query (line 483)
SELECT 'pg_catalog."radians"'::regproc

-- Test 65: query (line 488)
SELECT 'pg_catalog."radians"'::regproc

-- Test 66: query (line 493)
SELECT 'pg_catalog."radians"("float4")'::regprocedure

-- Test 67: statement (line 498)
SELECT 'pg_catalog."radians"""'::regproc

-- Test 68: query (line 511)
PREPARE regression_56193 AS SELECT $1::regclass;
EXECUTE regression_56193('regression_53686"'::regclass)

-- Test 69: query (line 517)
SELECT (-1)::OID

-- Test 70: query (line 522)
SELECT (-1)::REGPROC

-- Test 71: query (line 527)
SELECT (-1)::REGCLASS

-- Test 72: statement (line 533)
CREATE TABLE regression_62205(a INT PRIMARY KEY)

let $regression_62205_oid
SELECT 'regression_62205'::regclass::oid

-- Test 73: query (line 539)
SELECT $regression_62205_oid::regclass

-- Test 74: statement (line 545)
SELECT 'regression_69907'::oid

-- Test 75: query (line 550)
SELECT o, i, o > i, i > o FROM (VALUES
  (1::oid, 4294967295::int8),
  (1::oid, -2147483648::int8),
  ((-1)::oid, 4294967295::int8),
  ((-1)::oid, -2147483648::int8),
  ((-2147483648)::oid, 4294967295::int8),
  ((-2147483648)::oid, -2147483648::int8),
  (4294967295::oid, 4294967295::int8),
  (4294967295::oid, -2147483648::int8)
) tbl(o, i)

-- Test 76: statement (line 595)
CREATE INDEX my_b_index ON table_with_indexes(b)

-- Test 77: statement (line 605)
CREATE SCHEMA other_schema

-- Test 78: statement (line 608)
CREATE TABLE other_schema.table_with_indexes (a INT PRIMARY key, b INT)

-- Test 79: statement (line 611)
CREATE INDEX my_b_index ON other_schema.table_with_indexes(b)

-- Test 80: statement (line 637)
SET search_path = other_schema, public

-- Test 81: statement (line 661)
SET search_path = public, other_schema

-- Test 82: statement (line 685)
RESET search_path

-- Test 83: statement (line 700)
CREATE TABLE t118273 (x REGROLE PRIMARY KEY, y REGROLE);
INSERT INTO t118273 VALUES (0, 0);

-- Test 84: query (line 704)
SELECT * FROM t118273;

-- Test 85: query (line 709)
SELECT 0::REGROLE, 0::REGROLE::TEXT;

-- Test 86: statement (line 716)
CREATE TABLE t123474 (
  col_0 REGROLE, col_1 OID, col_2 INT,
  INDEX (col_1 DESC) STORING (col_2),
  INDEX (col_0) STORING (col_1)
);
INSERT INTO t123474 (col_0, col_1, col_2) VALUES (0, 0, 0);
SET testing_optimizer_random_seed = 6047211422050928467;
SET testing_optimizer_disable_rule_probability = 0.500000;

-- Test 87: query (line 726)
SELECT t2.col_1
  FROM t123474 AS t1 JOIN t123474 AS t2 ON (t1.col_0) = (t2.col_1)
  ORDER BY t1.col_0;

-- Test 88: statement (line 733)
RESET testing_optimizer_random_seed;
RESET testing_optimizer_disable_rule_probability;

-- Test 89: statement (line 739)
CREATE TABLE t123548_1 (col1 REGCLASS, INDEX (col1));
CREATE TABLE t123548_2 (col2 OID, UNIQUE (col2));
INSERT INTO t123548_1 VALUES (0);
INSERT INTO t123548_2 VALUES (0);
SET testing_optimizer_random_seed = 5928357781746163642;
SET testing_optimizer_disable_rule_probability = 1.000000;

-- Test 90: query (line 747)
SELECT col1 FROM t123548_1 JOIN t123548_2 ON col1 = col2;

-- Test 91: statement (line 752)
RESET testing_optimizer_random_seed;
RESET testing_optimizer_disable_rule_probability;

