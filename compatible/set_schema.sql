-- PostgreSQL compatible tests from set_schema
-- 118 tests

SET client_min_messages = warning;

-- Test 1: statement (line 1)
CREATE SCHEMA s1;

-- Test 2: statement (line 4)
CREATE SCHEMA s2;

-- Test 3: statement (line 7)
CREATE TABLE t(x INT);

-- Test 4: statement (line 11)
ALTER TABLE IF EXISTS does_not_exist SET SCHEMA s2;

-- Test 5: statement (line 15)
ALTER TABLE t SET SCHEMA public;

-- Test 6: statement (line 19)
-- Skipped: conversion placeholder.

-- Test 7: statement (line 24)
-- Skipped: conversion placeholder.

-- Test 8: statement (line 28)
-- Skipped: conversion placeholder.

-- Test 9: statement (line 33)
-- Skipped: conversion placeholder.

-- Test 10: statement (line 37)
-- Skipped: conversion placeholder.

-- Test 11: statement (line 44)
CREATE TEMPORARY TABLE temp1();

-- Capture the temp schema name into the psql variable `:temp_schema`.
SELECT nspname AS temp_schema FROM pg_namespace WHERE oid = pg_my_temp_schema() \gset

-- Test 12: statement (line 50)
-- Skipped: conversion placeholder.

-- Test 13: statement (line 54)
-- Skipped: conversion placeholder.

-- Test 14: statement (line 59)
INSERT INTO t VALUES (1);

-- Test 15: statement (line 62)
ALTER TABLE t SET SCHEMA s1;

-- Test 16: query (line 66)
SELECT * FROM s1.t;

-- Test 17: statement (line 72)
INSERT INTO s1.t VALUES (2);

-- Test 18: statement (line 76)
SELECT * FROM s1.t;

-- Test 19: statement (line 79)
SELECT * FROM s1.t;

-- Test 20: statement (line 84)
ALTER TABLE s1.t SET SCHEMA public;

-- Test 21: query (line 88)
SELECT * FROM public.t;

-- Test 22: statement (line 95)
INSERT INTO public.t VALUES (2);

-- Test 23: statement (line 99)
SELECT * FROM public.t;

-- Test 24: statement (line 103)
CREATE TABLE s1.t2(x INT);

-- Test 25: statement (line 106)
INSERT INTO s1.t2 VALUES (1);

-- Test 26: statement (line 109)
ALTER TABLE s1.t2 SET SCHEMA s2;

-- Test 27: query (line 112)
SELECT * FROM s2.t2;

-- Test 28: statement (line 118)
SELECT * FROM s2.t2;

-- Test 29: statement (line 122)
CREATE SEQUENCE s1.s;

-- Test 30: statement (line 125)
ALTER SEQUENCE s1.s SET SCHEMA s2;

-- Test 31: statement (line 128)
SELECT * FROM s2.s;

-- Test 32: statement (line 131)
SELECT * FROM s2.s;

-- Test 33: statement (line 135)
ALTER SEQUENCE s2.s SET SCHEMA s1;

-- Test 34: statement (line 139)
CREATE TABLE not_seq(x INT);

-- Test 35: statement (line 142)
ALTER TABLE not_seq SET SCHEMA s1;

-- Test 36: statement (line 145)
CREATE VIEW view_not_seq AS SELECT x FROM s1.not_seq;

-- Test 37: statement (line 148)
ALTER VIEW view_not_seq SET SCHEMA s1;

-- Test 38: statement (line 152)
CREATE TABLE for_view(x INT);

-- Test 39: statement (line 155)
CREATE VIEW s1.vx AS SELECT x FROM for_view;

-- Test 40: statement (line 158)
ALTER VIEW s1.vx SET SCHEMA s2;

-- Test 41: statement (line 161)
SELECT * FROM s2.vx;

-- Test 42: statement (line 164)
SELECT * FROM s2.vx;

-- Test 43: statement (line 168)
ALTER VIEW s2.vx SET SCHEMA s1;

-- Test 44: statement (line 172)
CREATE TABLE not_view();

-- Test 45: statement (line 175)
CREATE SEQUENCE seq_not_view;

-- Test 46: statement (line 178)
ALTER TABLE not_view SET SCHEMA s1;

-- Test 47: statement (line 181)
ALTER SEQUENCE seq_not_view SET SCHEMA s1;

-- Test 48: statement (line 186)
ALTER TABLE for_view SET SCHEMA s2;

-- Test 49: statement (line 189)
CREATE TABLE s1.t3(x INT);

-- Test 50: statement (line 192)
INSERT INTO s1.t3 VALUES (1);

-- Test 51: statement (line 196)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- Test 52: statement (line 199)
-- Skipped: Cockroach-only session variable.

-- Test 53: statement (line 202)
ALTER TABLE s1.t3 SET SCHEMA s2;

-- Test 54: query (line 206)
SELECT * FROM s2.t3;

-- Test 55: statement (line 211)
SELECT * FROM s2.t2;

-- Test 56: statement (line 214)
ROLLBACK;

-- Test 57: statement (line 217)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- Test 58: statement (line 220)
ALTER TABLE s1.t3 SET SCHEMA s2;

-- Test 59: statement (line 223)
COMMIT;

-- Test 60: query (line 228)
SELECT * FROM s2.t3;

-- Test 61: statement (line 234)
SELECT * FROM s2.t2;

-- Test 62: statement (line 237)
CREATE TABLE s1.t4(x INT);

-- Test 63: statement (line 241)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- Test 64: statement (line 244)
-- Skipped: Cockroach-only session variable.

-- Test 65: statement (line 247)
ALTER TABLE s1.t4 SET SCHEMA s2;

-- Test 66: statement (line 250)
ROLLBACK;

-- Test 67: statement (line 254)
SELECT * FROM s1.t4;

-- Test 68: statement (line 258)
SELECT * FROM s1.t4;

-- Test 69: statement (line 262)
CREATE TABLE t5();

-- Test 70: statement (line 267)
ALTER TABLE t5 SET SCHEMA s1;

-- Test 71: statement (line 273)
ALTER TABLE s1.t5 SET SCHEMA public;

-- Test 72: statement (line 278)
ALTER TABLE t5 SET SCHEMA s1;

-- Test 73: statement (line 284)
CREATE TYPE s1.typ AS ENUM ('hello');

-- Test 74: statement (line 288)
-- Skipped: conversion placeholder.

-- Test 75: statement (line 292)
-- Skipped: conversion placeholder.

-- Test 76: statement (line 297)
-- Skipped: conversion placeholder.

-- Test 77: statement (line 300)
-- Skipped: conversion placeholder.

-- Test 78: statement (line 304)
-- Skipped: conversion placeholder.

-- Test 79: statement (line 311)
-- Skipped: conversion placeholder.

-- Test 80: statement (line 316)
-- Skipped: conversion placeholder.

-- Test 81: statement (line 320)
SELECT 'hello'::s1.typ;

-- Test 82: statement (line 324)
SELECT ARRAY['hello']::s1._typ;

-- Test 83: statement (line 328)
SELECT 'hello'::s1.typ;

-- Test 84: statement (line 331)
SELECT 'hello'::s1.typ;

-- Test 85: statement (line 335)
SELECT ARRAY['hello']::s1._typ;

-- Test 86: statement (line 338)
SELECT ARRAY['hello']::s1._typ;

-- Test 87: statement (line 343)
ALTER TYPE s1.typ SET SCHEMA public;

-- Test 88: statement (line 347)
SELECT 'hello'::public.typ;

-- Test 89: statement (line 351)
SELECT ARRAY['hello']::public._typ;

-- Test 90: statement (line 355)
SELECT 'hello'::public.typ;

-- Test 91: statement (line 359)
SELECT ARRAY['hello']::public._typ;

-- Test 92: statement (line 363)
CREATE TYPE s1.typ2 AS ENUM ('hello');

-- Test 93: statement (line 366)
ALTER TYPE s1.typ2 SET SCHEMA s2;

-- Test 94: statement (line 369)
SELECT 'hello'::s2.typ2;

-- Test 95: statement (line 373)
SELECT ARRAY['hello']::s2._typ2;

-- Test 96: statement (line 377)
SELECT 'hello'::s2.typ2;

-- Test 97: statement (line 381)
SELECT ARRAY['hello']::s2._typ2;

-- Test 98: statement (line 384)
CREATE TYPE s1.typ3 AS ENUM ('hello');

-- Test 99: statement (line 388)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- Test 100: statement (line 391)
-- Skipped: Cockroach-only session variable.

-- Test 101: statement (line 394)
ALTER TYPE s1.typ3 SET SCHEMA s2;

-- Test 102: statement (line 398)
SELECT 'hello'::s2.typ3;

-- Test 103: statement (line 401)
ROLLBACK;

-- Test 104: statement (line 404)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- Test 105: statement (line 407)
ALTER TYPE s1.typ3 SET SCHEMA s2;

-- Test 106: statement (line 410)
COMMIT;

-- Test 107: statement (line 415)
SELECT 'hello'::s2.typ3;

-- Test 108: statement (line 419)
SELECT 'hello'::s2.typ3;

-- Test 109: statement (line 422)
CREATE TYPE s1.typ4 AS ENUM ('hello');

-- Test 110: statement (line 426)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- Test 111: statement (line 429)
-- Skipped: Cockroach-only session variable.

-- Test 112: statement (line 432)
ALTER TYPE s1.typ4 SET SCHEMA s2;

-- Test 113: statement (line 435)
ROLLBACK;

-- Test 114: statement (line 439)
SELECT 'hello'::s1.typ4;

-- Test 115: statement (line 443)
SELECT 'hello'::s1.typ4;

-- Test 116: statement (line 446)
-- Skipped: Cockroach-only `testuser`/`test` database setup.

-- Test 117: statement (line 453)
-- Skipped: conversion placeholder.

-- Test 118: statement (line 456)
-- Skipped: conversion placeholder.
