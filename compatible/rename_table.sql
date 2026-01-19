-- PostgreSQL compatible tests from rename_table
-- 93 tests

-- Test 1: statement (line 1)
ALTER TABLE foo RENAME TO bar

-- Test 2: statement (line 4)
ALTER TABLE IF EXISTS foo RENAME TO bar

-- Test 3: statement (line 7)
CREATE TABLE kv (
  k INT PRIMARY KEY,
  v INT
)

-- Test 4: statement (line 13)
INSERT INTO kv VALUES (1, 2), (3, 4)

-- Test 5: query (line 16)
SELECT * FROM kv

-- Test 6: query (line 22)
SHOW TABLES

-- Test 7: statement (line 27)
ALTER TABLE kv RENAME TO new_kv

-- Test 8: statement (line 30)
SELECT * FROM kv

-- Test 9: query (line 33)
SELECT * FROM new_kv

-- Test 10: query (line 39)
SHOW TABLES

-- Test 11: query (line 45)
SHOW GRANTS ON TABLE new_kv

-- Test 12: statement (line 51)
ALTER TABLE "" RENAME TO foo

-- Test 13: statement (line 54)
ALTER TABLE new_kv RENAME TO ""

-- Test 14: statement (line 57)
ALTER TABLE new_kv RENAME TO new_kv

-- Test 15: statement (line 60)
CREATE TABLE t (
  c1 INT PRIMARY KEY,
  c2 INT
)

-- Test 16: statement (line 66)
INSERT INTO t VALUES (4, 16), (5, 25)

-- Test 17: statement (line 69)
ALTER TABLE t RENAME TO new_kv

user testuser

-- Test 18: statement (line 74)
ALTER TABLE test.t RENAME TO t2

user root

-- Test 19: statement (line 79)
GRANT DROP ON TABLE test.t TO testuser

-- Test 20: statement (line 82)
create database test2

user testuser

-- Test 21: statement (line 87)
ALTER TABLE test.t RENAME TO t2

user root

-- Test 22: statement (line 92)
GRANT CREATE ON DATABASE test TO testuser

-- Test 23: statement (line 95)
ALTER TABLE test.t RENAME TO t2

-- Test 24: query (line 98)
SHOW TABLES

-- Test 25: statement (line 106)
ALTER TABLE test.t2 RENAME TO test2.t

user root

-- Test 26: statement (line 111)
GRANT CREATE ON DATABASE test2 TO testuser

-- Test 27: statement (line 114)
GRANT DROP ON test.new_kv TO testuser

user testuser

-- Test 28: query (line 119)
SHOW TABLES

-- Test 29: query (line 125)
SHOW TABLES FROM test2

-- Test 30: statement (line 131)
CREATE TABLE test2.t2(c1 INT, c2 INT)

-- Test 31: statement (line 134)
CREATE VIEW test2.v1 AS SELECT c1,c2 FROM test2.t2

-- Test 32: statement (line 137)
ALTER TABLE test2.v1 RENAME TO test2.v2

-- Test 33: statement (line 140)
ALTER TABLE test2.v2 RENAME TO test2.v1

-- Test 34: statement (line 143)
ALTER TABLE test2.t2 RENAME TO test2.t3

-- Test 35: statement (line 150)
BEGIN

-- Test 36: statement (line 153)
CREATE DATABASE d; CREATE TABLE d.kv (k CHAR PRIMARY KEY, v CHAR);

-- Test 37: statement (line 156)
INSERT INTO d.kv (k,v) VALUES ('a', 'b')

-- Test 38: statement (line 159)
COMMIT

-- Test 39: statement (line 162)
INSERT INTO d.kv (k,v) VALUES ('c', 'd')

-- Test 40: statement (line 166)
SET autocommit_before_ddl = false

-- Test 41: statement (line 169)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- Test 42: statement (line 172)
CREATE DATABASE dd; CREATE TABLE dd.kv (k CHAR PRIMARY KEY, v CHAR)

-- Test 43: statement (line 175)
INSERT INTO dd.kv (k,v) VALUES ('a', 'b')

-- Test 44: statement (line 178)
ROLLBACK

-- Test 45: statement (line 181)
INSERT INTO dd.kv (k,v) VALUES ('c', 'd')

-- Test 46: statement (line 185)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- Test 47: statement (line 188)
CREATE TABLE d.kv2 (k CHAR PRIMARY KEY, v CHAR)

-- Test 48: statement (line 191)
INSERT INTO d.kv2 (k,v) VALUES ('a', 'b')

-- Test 49: statement (line 194)
ROLLBACK

-- Test 50: statement (line 197)
RESET autocommit_before_ddl

-- Test 51: statement (line 200)
INSERT INTO d.kv2 (k,v) VALUES ('c', 'd')

-- Test 52: statement (line 203)
USE d

-- Test 53: query (line 206)
SHOW TABLES

-- Test 54: statement (line 211)
SET vectorize=on

-- Test 55: query (line 214)
EXPLAIN ALTER TABLE kv RENAME TO kv2

-- Test 56: statement (line 221)
RESET vectorize

-- Test 57: query (line 225)
SHOW TABLES

-- Test 58: statement (line 234)
CREATE DATABASE olddb

-- Test 59: statement (line 237)
CREATE DATABASE newdb

-- Test 60: statement (line 240)
USE olddb

-- Test 61: statement (line 243)
CREATE SCHEMA oldsc

-- Test 62: statement (line 246)
USE newdb

-- Test 63: statement (line 249)
CREATE SCHEMA newsc

-- Test 64: statement (line 252)
CREATE TABLE olddb.public.tbl1();

-- Test 65: statement (line 255)
CREATE TABLE olddb.oldsc.tbl2();

-- Test 66: statement (line 258)
ALTER TABLE olddb.public.tbl1 RENAME TO newdb.newsc.tbl1

-- Test 67: statement (line 261)
ALTER TABLE olddb.oldsc.tbl2 RENAME TO newdb.public.tbl2

-- Test 68: statement (line 264)
ALTER TABLE olddb.oldsc.tbl2 RENAME TO newdb.newsc.tbl2

-- Test 69: statement (line 269)
ALTER TABLE olddb.tbl1 RENAME TO newdb.newsc.tbl1

-- Test 70: statement (line 272)
ALTER TABLE olddb.oldsc.tbl2 RENAME TO newdb.tbl2

-- Test 71: statement (line 275)
DROP DATABASE olddb CASCADE

-- Test 72: statement (line 278)
DROP DATABASE newdb CASCADE

-- Test 73: statement (line 283)
CREATE DATABASE olddb

-- Test 74: statement (line 286)
CREATE DATABASE newdb

-- Test 75: statement (line 289)
USE olddb

-- Test 76: statement (line 292)
CREATE TYPE typ AS ENUM ('foo')

-- Test 77: statement (line 295)
CREATE TABLE tbl(a typ)

-- Test 78: statement (line 298)
ALTER TABLE tbl RENAME TO newdb.tbl

-- Test 79: statement (line 303)
CREATE TABLE tbl2()

-- Test 80: statement (line 306)
BEGIN

-- Test 81: statement (line 309)
ALTER TABLE tbl2 ADD COLUMN b typ

-- Test 82: statement (line 312)
ALTER TABLE tbl2 RENAME TO newdb.tbl2

-- Test 83: statement (line 315)
ROLLBACK

-- Test 84: statement (line 318)
BEGIN

-- Test 85: statement (line 321)
ALTER TABLE tbl DROP COLUMN a

-- Test 86: statement (line 324)
ALTER TABLE tbl RENAME TO newdb.tbl

-- Test 87: statement (line 327)
ROLLBACK

-- Test 88: statement (line 330)
DROP DATABASE olddb CASCADE

-- Test 89: statement (line 333)
DROP DATABASE newdb CASCADE

-- Test 90: statement (line 338)
CREATE DATABASE newdb;

-- Test 91: statement (line 341)
SET database = newdb;

-- Test 92: statement (line 346)
CREATE DATABASE d1;
CREATE TABLE d1.t();
CREATE DATABASE d2;

-- Test 93: statement (line 351)
ALTER TABLE d1.t RENAME TO d2.t;

