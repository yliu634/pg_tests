-- PostgreSQL compatible tests from drop_database
-- 68 tests

-- Test 1: statement (line 2)
SET CLUSTER SETTING sql.cross_db_views.enabled = TRUE

-- Test 2: statement (line 5)
SET CLUSTER SETTING sql.cross_db_sequence_references.enabled = TRUE

-- Test 3: statement (line 8)
CREATE DATABASE "foo-bar"

-- Test 4: query (line 11)
SHOW DATABASES

-- Test 5: statement (line 20)
CREATE TABLE "foo-bar".t(x INT)

-- Test 6: statement (line 23)
DROP DATABASE "foo-bar" RESTRICT

-- Test 7: statement (line 26)
DROP DATABASE "foo-bar" CASCADE

-- Test 8: query (line 29)
SELECT name, database_name, state FROM crdb_internal.tables WHERE name = 't'

-- Test 9: query (line 34)
SHOW DATABASES

-- Test 10: statement (line 52)
CREATE DATABASE "foo bar"

-- Test 11: query (line 55)
SELECT * FROM [SHOW DATABASES] ORDER BY database_name

-- Test 12: statement (line 64)
DROP DATABASE "foo bar" CASCADE

-- Test 13: query (line 67)
SHOW DATABASES

-- Test 14: statement (line 75)
CREATE DATABASE d1

-- Test 15: statement (line 78)
CREATE DATABASE d2

-- Test 16: statement (line 87)
CREATE VIEW d1.v1 AS SELECT k,v FROM d1.t1

-- Test 17: statement (line 90)
CREATE VIEW d1.v2 AS SELECT k,v FROM d1.v1

-- Test 18: statement (line 93)
CREATE VIEW d2.v1 AS SELECT k,v FROM d2.t1

-- Test 19: statement (line 96)
CREATE VIEW d2.v2 AS SELECT k,v FROM d1.t1

-- Test 20: statement (line 99)
CREATE VIEW d2.v3 AS SELECT k,v FROM d1.v2

-- Test 21: statement (line 102)
CREATE VIEW d2.v4 AS SELECT count(*) FROM d1.t1 as x JOIN d2.t1 as y ON x.k = y.k

-- Test 22: statement (line 105)
GRANT ALL ON DATABASE d1 TO testuser

-- Test 23: statement (line 108)
GRANT ALL ON d1.t1 TO testuser

-- Test 24: statement (line 111)
GRANT ALL ON d1.v1 TO testuser

-- Test 25: statement (line 114)
GRANT ALL ON d1.v2 TO testuser

-- Test 26: statement (line 117)
GRANT ALL ON d2.v2 TO testuser

-- Test 27: statement (line 120)
GRANT ALL ON d2.v3 TO testuser

user testuser

-- Test 28: statement (line 125)
DROP DATABASE d1 CASCADE

user root

-- Test 29: query (line 130)
SELECT * FROM d1.v2

-- Test 30: query (line 134)
SELECT * FROM d2.v1

-- Test 31: query (line 138)
SELECT * FROM d2.v2

-- Test 32: query (line 142)
SELECT * FROM d2.v3

-- Test 33: query (line 146)
SELECT * FROM d2.v4

-- Test 34: query (line 151)
SHOW DATABASES

-- Test 35: statement (line 161)
DROP DATABASE d1 CASCADE

-- Test 36: query (line 164)
SHOW DATABASES

-- Test 37: query (line 173)
SELECT * FROM d1.v2

query error pgcode 42P01 relation "d2.v2" does not exist
SELECT * FROM d2.v2

query error pgcode 42P01 relation "d2.v3" does not exist
SELECT * FROM d2.v3

query error pgcode 42P01 relation "d2.v4" does not exist
SELECT * FROM d2.v4

query TT
SELECT * FROM d2.v1

-- Test 38: statement (line 189)
DROP DATABASE d2 CASCADE

-- Test 39: query (line 192)
SHOW DATABASES

-- Test 40: query (line 200)
SELECT * FROM d2.v1

## drop a database containing tables with foreign key constraints, e.g. #8497

statement ok
CREATE DATABASE constraint_db

statement ok
CREATE TABLE constraint_db.t1 (
  p FLOAT PRIMARY KEY,
  a INT UNIQUE CHECK (a > 4),
  CONSTRAINT c2 CHECK (a < 99)
)

statement ok
CREATE TABLE constraint_db.t2 (
    t1_ID INT,
    CONSTRAINT fk FOREIGN KEY (t1_ID) REFERENCES constraint_db.t1(a),
    INDEX (t1_ID)
)

statement ok
DROP DATABASE constraint_db CASCADE

skipif config local-legacy-schema-changer
query TT
WITH cte AS (
  SELECT job_type, description
  FROM crdb_internal.jobs
  WHERE (job_type = 'NEW SCHEMA CHANGE' OR job_type = 'SCHEMA CHANGE GC')
  AND (status = 'succeeded' OR status = 'running')
  AND (description LIKE '%DROP%')
  ORDER BY created DESC
) SELECT * FROM cte ORDER BY job_type, description

-- Test 41: query (line 246)
SHOW DATABASES

-- Test 42: statement (line 308)
CREATE DATABASE db50997

-- Test 43: statement (line 311)
CREATE SEQUENCE db50997.seq50997

-- Test 44: statement (line 314)
CREATE SEQUENCE db50997.useq50997

-- Test 45: statement (line 317)
CREATE TABLE db50997.t50997(a INT DEFAULT nextval('db50997.seq50997'))

-- Test 46: statement (line 320)
CREATE TABLE db50997.t250997(a INT DEFAULT nextval('db50997.seq50997'))

-- Test 47: statement (line 323)
DROP DATABASE db50997 CASCADE

-- Test 48: query (line 326)
SELECT count(*) FROM system.namespace WHERE name = 'seq50997'

-- Test 49: query (line 331)
SELECT count(*) FROM system.namespace WHERE name = 'useq50997'

-- Test 50: statement (line 340)
CREATE DATABASE db50997

-- Test 51: statement (line 343)
CREATE SEQUENCE seq50997

-- Test 52: statement (line 346)
CREATE TABLE db50997.t50997(a INT DEFAULT nextval('seq50997'))

-- Test 53: statement (line 349)
DROP DATABASE db50997 CASCADE

-- Test 54: query (line 352)
SELECT count(*) FROM system.namespace WHERE name LIKE 'seq50997'

-- Test 55: statement (line 359)
CREATE DATABASE db_73323

-- Test 56: statement (line 362)
DROP DATABASE db_73323 RESTRICT

-- Test 57: statement (line 367)
CREATE DATABASE db_51782

-- Test 58: statement (line 370)
CREATE TABLE db_51782.t_51782(a int, b int);

-- Test 59: statement (line 373)
CREATE VIEW db_51782.v_51782 AS SELECT a, b FROM db_51782.t_51782

-- Test 60: statement (line 376)
CREATE VIEW db_51782.w_51782 AS SELECT a FROM db_51782.v_51782

-- Test 61: statement (line 379)
DROP DATABASE db_51782 CASCADE

-- Test 62: query (line 382)
SELECT count(*) FROM system.namespace WHERE name LIKE 'v_51782'

-- Test 63: query (line 387)
SELECT count(*) FROM system.namespace WHERE name LIKE 'w_51782'

-- Test 64: statement (line 397)
CREATE USER db_owner WITH CREATEDB

-- Test 65: statement (line 400)
SET ROLE db_owner

-- Test 66: statement (line 403)
CREATE DATABASE db_121808

-- Test 67: statement (line 406)
DROP DATABASE db_121808 RESTRICT

-- Test 68: statement (line 409)
RESET role

