-- PostgreSQL compatible tests from drop_type
-- 102 tests

-- Test 1: statement (line 1)
SET sql_safe_updates = false;

onlyif config local-legacy-schema-changer

-- Test 2: statement (line 9)
CREATE TYPE t AS ENUM ('hello');

-- Test 3: statement (line 12)
DROP TYPE t

-- Test 4: statement (line 15)
SELECT 'hello'::t

-- Test 5: statement (line 19)
SELECT ARRAY['hello']::_t

-- Test 6: statement (line 23)
CREATE TYPE t AS ENUM ('hello');

-- Test 7: statement (line 26)
SET autocommit_before_ddl = false

-- Test 8: statement (line 29)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
DROP TYPE t;

-- Test 9: statement (line 33)
DROP TYPE t

-- Test 10: statement (line 36)
ROLLBACK

-- Test 11: statement (line 39)
RESET autocommit_before_ddl

-- Test 12: statement (line 43)
DROP TYPE t, t

-- Test 13: statement (line 47)
DROP TYPE IF EXISTS t

-- Test 14: statement (line 51)
CREATE TYPE t AS ENUM ('hello')

-- Test 15: statement (line 54)
DROP TYPE _t

-- Test 16: statement (line 59)
CREATE TABLE t1 (x t)

-- Test 17: statement (line 62)
DROP TYPE t

-- Test 18: statement (line 66)
ALTER TABLE t1 ADD COLUMN y t

-- Test 19: statement (line 69)
DROP TYPE t

-- Test 20: statement (line 73)
ALTER TABLE t1 DROP COLUMN x

-- Test 21: statement (line 76)
DROP TYPE t

-- Test 22: statement (line 80)
ALTER TABLE t1 DROP COLUMN y

-- Test 23: statement (line 83)
DROP TYPE t

-- Test 24: statement (line 87)
CREATE TYPE t AS ENUM ('hello');

-- Test 25: statement (line 90)
ALTER TABLE t1 ADD COLUMN x t[]

-- Test 26: statement (line 93)
DROP TYPE t

-- Test 27: statement (line 96)
ALTER TABLE t1 DROP COLUMN x;

-- Test 28: statement (line 99)
DROP TYPE t

-- Test 29: statement (line 103)
CREATE TYPE t AS ENUM ('hello');

-- Test 30: statement (line 112)
ALTER TABLE t1 ALTER COLUMN x SET DATA TYPE t USING x::t

skipif config local-legacy-schema-changer

-- Test 31: statement (line 116)
DROP TYPE t

-- Test 32: statement (line 119)
DROP TABLE t1

-- Test 33: statement (line 123)
DROP TYPE t

-- Test 34: statement (line 127)
CREATE TYPE t AS ENUM ('hello');

-- Test 35: statement (line 130)
CREATE VIEW v AS SELECT 'hello':::t

-- Test 36: statement (line 133)
DROP TYPE t

-- Test 37: statement (line 136)
DROP VIEW v

-- Test 38: statement (line 139)
DROP TYPE t

-- Test 39: statement (line 144)
CREATE TYPE t1 AS ENUM ('hello');

-- Test 40: statement (line 147)
CREATE TYPE t2 AS ENUM ('howdy');

-- Test 41: statement (line 150)
CREATE TYPE t3 AS ENUM ('hi');

-- Test 42: statement (line 153)
CREATE TYPE t4 AS ENUM ('cheers')

-- Test 43: statement (line 165)
DROP TYPE t1

-- Test 44: statement (line 168)
DROP TYPE t2

-- Test 45: statement (line 171)
DROP TYPE t3

-- Test 46: statement (line 174)
DROP TYPE t4

-- Test 47: statement (line 178)
DROP INDEX expr@i;

-- Test 48: statement (line 181)
DROP TYPE t4

-- Test 49: statement (line 184)
ALTER TABLE expr DROP CONSTRAINT "check";

-- Test 50: statement (line 187)
DROP TYPE t3

-- Test 51: statement (line 190)
ALTER TABLE expr DROP COLUMN y;

-- Test 52: statement (line 193)
DROP TYPE t2

-- Test 53: statement (line 196)
ALTER TABLE expr DROP COLUMN x;

-- Test 54: statement (line 199)
DROP TYPE t1

-- Test 55: statement (line 202)
DROP TABLE expr

-- Test 56: statement (line 206)
CREATE TABLE expr ();

-- Test 57: statement (line 209)
CREATE TYPE t1 AS ENUM ('hello');

-- Test 58: statement (line 212)
CREATE TYPE t2 AS ENUM ('howdy');

-- Test 59: statement (line 215)
CREATE TYPE t3 AS ENUM ('hi');

-- Test 60: statement (line 218)
CREATE TYPE t4 AS ENUM ('cheers')

-- Test 61: statement (line 224)
SET autocommit_before_ddl = false;

skipif config schema-locked-disabled

-- Test 62: statement (line 228)
ALTER TABLE expr SET (schema_locked=false)

-- Test 63: statement (line 231)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
ALTER TABLE expr ADD COLUMN x BOOL DEFAULT ('hello'::t1 = 'hello'::t1)

-- Test 64: statement (line 235)
DROP TYPE t1

-- Test 65: statement (line 238)
ROLLBACK

-- Test 66: statement (line 245)
DROP TYPE t2

-- Test 67: statement (line 248)
ROLLBACK

-- Test 68: statement (line 255)
DROP TYPE t3

-- Test 69: statement (line 258)
ROLLBACK

-- Test 70: statement (line 261)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
CREATE INDEX i ON expr (rowid) WHERE ('cheers'::t4 = 'cheers'::t4)

-- Test 71: statement (line 265)
DROP TYPE t4

-- Test 72: statement (line 268)
ROLLBACK

-- Test 73: statement (line 271)
RESET autocommit_before_ddl

skipif config schema-locked-disabled

-- Test 74: statement (line 275)
ALTER TABLE expr RESET (schema_locked)

-- Test 75: statement (line 279)
ALTER TABLE expr ADD COLUMN x BOOL DEFAULT ('hello'::t1 = 'hello'::t1);

-- Test 76: statement (line 288)
CREATE INDEX i ON expr (y) WHERE ('cheers'::t4 = 'cheers'::t4)

-- Test 77: statement (line 291)
DROP TYPE t1

-- Test 78: statement (line 294)
DROP TYPE t2

-- Test 79: statement (line 297)
DROP TYPE t3

-- Test 80: statement (line 300)
DROP TYPE t4

-- Test 81: statement (line 304)
DROP INDEX expr@i;

-- Test 82: statement (line 307)
DROP TYPE t4

-- Test 83: statement (line 310)
ALTER TABLE expr DROP CONSTRAINT "check";

-- Test 84: statement (line 313)
DROP TYPE t3

-- Test 85: statement (line 316)
ALTER TABLE expr DROP COLUMN y;

-- Test 86: statement (line 319)
DROP TYPE t2

-- Test 87: statement (line 322)
ALTER TABLE expr DROP COLUMN x;

-- Test 88: statement (line 325)
DROP TYPE t1

-- Test 89: statement (line 329)
CREATE TYPE ty AS ENUM ('hello');

-- Test 90: statement (line 332)
CREATE TABLE tab (x ty);

-- Test 91: statement (line 335)
INSERT INTO tab VALUES ('hello');

-- Test 92: statement (line 338)
ALTER TABLE tab SET (schema_locked=false);

-- Test 93: statement (line 341)
TRUNCATE TABLE tab

-- Test 94: statement (line 344)
ALTER TABLE tab RESET (schema_locked);

-- Test 95: statement (line 347)
DROP TYPE ty

-- Test 96: statement (line 351)
CREATE TYPE t AS ENUM ('hello');

-- Test 97: statement (line 354)
CREATE TABLE tt (x t)

-- Test 98: statement (line 357)
BEGIN;
DROP TABLE tt;
DROP TYPE t;
COMMIT

-- Test 99: statement (line 364)
CREATE DATABASE d;

-- Test 100: statement (line 367)
CREATE TYPE d.d_t AS ENUM ()

-- Test 101: statement (line 370)
DROP DATABASE d RESTRICT

let $t_id
SELECT id FROM system.namespace WHERE name = 'd_t'

-- Test 102: statement (line 377)
DROP DATABASE d

