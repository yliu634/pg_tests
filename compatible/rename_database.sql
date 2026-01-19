-- PostgreSQL compatible tests from rename_database
-- 70 tests

-- Test 1: statement (line 1)
SET CLUSTER SETTING sql.cross_db_views.enabled = TRUE

-- Test 2: statement (line 4)
SET CLUSTER SETTING sql.cross_db_sequence_references.enabled = TRUE

-- Test 3: query (line 7)
SHOW DATABASES

-- Test 4: query (line 15)
SHOW GRANTS ON DATABASE test

-- Test 5: statement (line 22)
CREATE TABLE kv (
  k INT PRIMARY KEY,
  v INT
)

-- Test 6: statement (line 28)
INSERT INTO kv VALUES (1, 2), (3, 4), (5, 6), (7, 8)

-- Test 7: query (line 31)
SELECT * FROM kv

-- Test 8: statement (line 39)
SET sql_safe_updates = TRUE;

-- Test 9: statement (line 42)
ALTER DATABASE test RENAME TO u

-- Test 10: statement (line 45)
SET sql_safe_updates = FALSE;

-- Test 11: statement (line 48)
ALTER DATABASE test RENAME TO u

-- Test 12: statement (line 51)
SELECT * FROM kv

-- Test 13: statement (line 54)
SHOW GRANTS ON DATABASE test

-- Test 14: query (line 57)
SHOW DATABASES

-- Test 15: query (line 66)
SHOW GRANTS ON DATABASE u

-- Test 16: statement (line 73)
SET DATABASE = u

-- Test 17: query (line 76)
SELECT * FROM kv

-- Test 18: statement (line 84)
ALTER DATABASE "" RENAME TO u

-- Test 19: statement (line 87)
ALTER DATABASE u RENAME TO ""

-- Test 20: statement (line 90)
ALTER DATABASE u RENAME TO u

-- Test 21: statement (line 93)
CREATE DATABASE t

-- Test 22: statement (line 96)
ALTER DATABASE t RENAME TO u

-- Test 23: statement (line 99)
GRANT ALL ON DATABASE t TO testuser

user testuser

-- Test 24: statement (line 104)
ALTER DATABASE t RENAME TO v

-- Test 25: query (line 107)
SHOW DATABASES

-- Test 26: statement (line 119)
ALTER USER testuser CREATEDB

user testuser

-- Test 27: statement (line 124)
CREATE DATABASE testuserdb

-- Test 28: statement (line 127)
ALTER DATABASE testuserdb RENAME TO testuserdb2

user root

-- Test 29: statement (line 132)
ALTER USER testuser NOCREATEDB

user testuser

-- Test 30: statement (line 137)
ALTER DATABASE testuserdb2 RENAME TO testuserdb3

user root

-- Test 31: statement (line 142)
DROP DATABASE testuserdb2

-- Test 32: statement (line 148)
CREATE VIEW t.v AS SELECT k,v FROM u.kv

-- Test 33: query (line 151)
SHOW TABLES FROM u

-- Test 34: statement (line 156)
ALTER DATABASE u RENAME TO v

-- Test 35: statement (line 159)
DROP VIEW t.v

-- Test 36: statement (line 162)
ALTER DATABASE u RENAME TO v

-- Test 37: statement (line 165)
CREATE VIEW v.v AS SELECT k,v FROM v.kv

-- Test 38: statement (line 168)
ALTER DATABASE v RENAME TO u

-- Test 39: statement (line 172)
ALTER DATABASE defaultdb RENAME TO w;
  ALTER DATABASE postgres RENAME TO defaultdb;
  ALTER DATABASE w RENAME TO postgres

-- Test 40: query (line 177)
SHOW DATABASES

-- Test 41: statement (line 186)
SET vectorize=on

-- Test 42: query (line 189)
EXPLAIN ALTER DATABASE v RENAME TO x

-- Test 43: statement (line 196)
RESET vectorize

-- Test 44: query (line 200)
SHOW DATABASES

-- Test 45: statement (line 215)
CREATE DATABASE db1; CREATE SEQUENCE db1.seq

-- Test 46: statement (line 218)
CREATE DATABASE db2; CREATE TABLE db2.tbl (a int DEFAULT nextval('db1.seq'))

-- Test 47: statement (line 221)
ALTER DATABASE db1 RENAME TO db3

-- Test 48: statement (line 224)
DROP DATABASE db2 CASCADE;

-- Test 49: statement (line 227)
DROP DATABASE db3 CASCADE

-- Test 50: statement (line 230)
CREATE DATABASE db1;

-- Test 51: statement (line 233)
CREATE SEQUENCE db1.a_seq;
CREATE SEQUENCE db1.b_seq;

-- Test 52: statement (line 237)
USE db1;

-- Test 53: statement (line 240)
CREATE TABLE db1.a (a int default nextval('a_seq') + nextval('b_seq') + 1); ALTER DATABASE db1 RENAME TO db2; USE db2;

-- Test 54: statement (line 243)
DROP TABLE db2.a;

-- Test 55: statement (line 246)
CREATE TABLE db2.a (a int default nextval('a_seq') + nextval('db2.b_seq') + 1);

-- Test 56: statement (line 249)
ALTER DATABASE db2 RENAME TO db1;

-- Test 57: statement (line 252)
ALTER DATABASE db1 RENAME TO db2

-- Test 58: statement (line 255)
DROP TABLE db2.a;

-- Test 59: statement (line 258)
CREATE TABLE db2.a (a int default nextval('a_seq') + nextval('db2.public.b_seq') + 1);

-- Test 60: statement (line 261)
ALTER DATABASE db2 RENAME TO db1; ALTER DATABASE db1 RENAME TO db2

-- Test 61: statement (line 264)
DROP TABLE db2.a;

-- Test 62: statement (line 267)
CREATE TABLE db2.a (a int default nextval('a_seq') + nextval('public.b_seq') + 1);

-- Test 63: statement (line 270)
ALTER DATABASE db2 RENAME TO db1

-- Test 64: statement (line 273)
USE defaultdb

-- Test 65: statement (line 276)
DROP DATABASE db1 CASCADE

-- Test 66: statement (line 279)
CREATE FUNCTION identity1(n INT) RETURNS INT LANGUAGE SQL AS $$
  SELECT n;
$$

-- Test 67: statement (line 284)
CREATE FUNCTION identity2(n INT) RETURNS INT LANGUAGE SQL AS $$
  SELECT identity1(n);
$$

-- Test 68: statement (line 289)
ALTER DATABASE defaultdb RENAME TO db;
USE db;

-- Test 69: query (line 293)
SELECT identity1(2);

-- Test 70: query (line 298)
SELECT identity2(2);

