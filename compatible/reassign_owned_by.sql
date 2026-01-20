-- PostgreSQL compatible tests from reassign_owned_by
-- 87 tests

-- Test 1: statement (line 1)
CREATE TABLE t()

-- Test 2: statement (line 5)
REASSIGN OWNED BY fake_old_role TO new_role

-- Test 3: statement (line 8)
CREATE ROLE old_role;

-- Test 4: statement (line 11)
GRANT CREATE ON DATABASE test TO old_role;

-- Test 5: statement (line 14)
ALTER TABLE t OWNER TO old_role

user testuser

-- Test 6: statement (line 20)
REASSIGN OWNED BY old_role TO testuser

-- Test 7: statement (line 23)
REASSIGN OWNED BY testuser, old_role TO testuser

user root

-- Test 8: statement (line 29)
GRANT old_role TO testuser

user testuser

-- Test 9: statement (line 35)
REASSIGN OWNED BY old_role TO fake_new_role

user root

-- Test 10: statement (line 40)
CREATE ROLE new_role;

-- Test 11: statement (line 43)
GRANT CREATE ON DATABASE test TO new_role

user testuser

-- Test 12: statement (line 49)
REASSIGN OWNED BY old_role TO new_role

-- Test 13: statement (line 52)
REASSIGN OWNED BY old_role, testuser TO new_role

user root

-- Test 14: statement (line 58)
GRANT new_role TO testuser

user testuser

-- Test 15: statement (line 64)
REASSIGN OWNED BY old_role TO new_role

-- Test 16: statement (line 67)
DROP TABLE t

user root

-- Test 17: statement (line 72)
CREATE ROLE testuser2 WITH LOGIN;

-- Test 18: statement (line 76)
CREATE DATABASE d;

-- Test 19: statement (line 79)
ALTER DATABASE d OWNER TO testuser

-- Test 20: query (line 83)
SELECT database_name, owner FROM [SHOW DATABASES] WHERE database_name='d'

-- Test 21: statement (line 89)
use d

-- Test 22: statement (line 92)
REASSIGN OWNED BY testuser TO testuser2

-- Test 23: query (line 96)
SELECT database_name, owner FROM [SHOW DATABASES] WHERE database_name='d'

-- Test 24: statement (line 104)
DROP DATABASE d

user root

-- Test 25: statement (line 110)
DROP ROLE testuser

-- Test 26: statement (line 115)
use test;

-- Test 27: statement (line 118)
CREATE ROLE testuser;

-- Test 28: statement (line 122)
CREATE SCHEMA s1;

-- Test 29: statement (line 125)
ALTER SCHEMA s1 OWNER TO testuser

-- Test 30: statement (line 128)
CREATE SCHEMA s2

-- Test 31: query (line 132)
SELECT schema_name, owner FROM [SHOW SCHEMAS] WHERE schema_name IN ('s1', 's2', 'public')

-- Test 32: statement (line 142)
REASSIGN OWNED BY testuser, root TO testuser2

user testuser2

-- Test 33: query (line 148)
SELECT schema_name, owner FROM [SHOW SCHEMAS] WHERE schema_name IN ('s1', 's2', 'public')

-- Test 34: statement (line 156)
DROP SCHEMA s1;

-- Test 35: statement (line 159)
DROP SCHEMA s2

user root

-- Test 36: statement (line 164)
ALTER DATABASE test OWNER TO root

-- Test 37: statement (line 168)
DROP ROLE testuser

-- Test 38: statement (line 176)
use test

-- Test 39: statement (line 179)
CREATE ROLE testuser

-- Test 40: statement (line 182)
GRANT CREATE ON DATABASE test TO testuser, testuser2

-- Test 41: statement (line 185)
CREATE SCHEMA s;
ALTER SCHEMA s OWNER TO testuser

-- Test 42: statement (line 189)
CREATE TABLE s.t();
ALTER TABLE s.t OWNER TO testuser

-- Test 43: statement (line 193)
CREATE TYPE s.typ AS ENUM ();
ALTER TYPE s.typ OWNER to testuser

-- Test 44: query (line 198)
SELECT schema_name, owner FROM [SHOW SCHEMAS] WHERE schema_name IN ('s', 'public')

-- Test 45: query (line 204)
SELECT tablename, tableowner FROM pg_tables WHERE tablename='t'

-- Test 46: query (line 209)
SELECT name, owner FROM [SHOW TYPES] WHERE name = 'typ'

-- Test 47: statement (line 214)
REASSIGN OWNED BY testuser TO testuser2

-- Test 48: query (line 218)
SELECT schema_name, owner FROM [SHOW SCHEMAS] WHERE schema_name IN ('s', 'public')

-- Test 49: query (line 224)
SELECT tablename, tableowner FROM pg_tables WHERE tablename='t'

-- Test 50: query (line 229)
SELECT name, owner FROM [SHOW TYPES] WHERE name = 'typ'

-- Test 51: statement (line 237)
DROP TABLE s.t;
DROP TYPE s.typ;
DROP SCHEMA s;

-- Test 52: statement (line 245)
REVOKE CREATE ON DATABASE test FROM testuser, testuser2;
DROP ROLE testuser;

-- Test 53: statement (line 251)
DROP ROLE testuser2

-- Test 54: statement (line 254)
REASSIGN OWNED BY testuser2 TO root

-- Test 55: statement (line 257)
DROP ROLE testuser2

-- Test 56: statement (line 266)
CREATE ROLE testuser;
GRANT CREATE ON DATABASE test TO testuser;

-- Test 57: statement (line 270)
CREATE DATABASE d;
ALTER DATABASE d OWNER TO testuser

-- Test 58: statement (line 275)
CREATE TABLE t1();
ALTER TABLE t1 OWNER TO testuser

-- Test 59: statement (line 280)
CREATE TABLE d.t2();
ALTER TABLE d.t2 OWNER TO testuser

-- Test 60: query (line 285)
SELECT database_name, owner FROM [SHOW DATABASES] WHERE database_name IN ('d', 'test')

-- Test 61: query (line 291)
SELECT tablename, tableowner FROM pg_tables WHERE tablename='t1'

-- Test 62: statement (line 296)
use d

-- Test 63: query (line 299)
SELECT tablename, tableowner FROM pg_tables WHERE tablename='t2'

-- Test 64: statement (line 304)
CREATE ROLE testuser2;
GRANT CREATE ON DATABASE test TO testuser2

-- Test 65: statement (line 308)
use test

-- Test 66: statement (line 312)
REASSIGN OWNED BY testuser TO testuser2

-- Test 67: query (line 316)
SELECT database_name, owner FROM [SHOW DATABASES] WHERE database_name IN ('d', 'test')

-- Test 68: query (line 322)
SELECT tablename, tableowner FROM pg_tables WHERE tablename='t1'

-- Test 69: statement (line 327)
use d

-- Test 70: query (line 330)
SELECT tablename, tableowner FROM pg_tables WHERE tablename='t2'

-- Test 71: statement (line 338)
DROP TABLE d.t2;
DROP DATABASE d;

-- Test 72: statement (line 345)
DROP TABLE t1;

-- Test 73: statement (line 355)
CREATE DATABASE db1;
ALTER DATABASE db1 OWNER TO testuser;
CREATE SCHEMA db1.sc1;
ALTER SCHEMA db1.sc1 OWNER TO testuser;
CREATE TABLE db1.sc1.table(n int);
ALTER TABLE db1.sc1.table OWNER TO testuser;

-- Test 74: statement (line 363)
DROP SCHEMA db1.sc1 CASCADE;

-- Test 75: statement (line 366)
USE db1;

-- Test 76: statement (line 369)
REASSIGN OWNED BY testuser TO testuser2;

user root

-- Test 77: statement (line 373)
USE test;

-- Test 78: statement (line 376)
DROP DATABASE db1 CASCADE;

-- Test 79: statement (line 383)
CREATE DATABASE db1;
ALTER DATABASE db1 OWNER TO testuser;
CREATE SCHEMA db1.sc1;
ALTER SCHEMA db1.sc1 OWNER TO testuser;
CREATE TABLE db1.sc1.table(n int);
ALTER TABLE db1.sc1.table OWNER TO testuser;

-- Test 80: statement (line 391)
SET CLUSTER SETTING jobs.debug.pausepoints = 'schemachanger.before.exec';

-- Test 81: statement (line 394)
use db1;

skipif config local-legacy-schema-changer

-- Test 82: statement (line 398)
REASSIGN OWNED BY testuser TO testuser2;

-- Test 83: statement (line 401)
SET CLUSTER SETTING jobs.debug.pausepoints = 'newschemachanger.before.exec';

user root

skipif config local-legacy-schema-changer

-- Test 84: statement (line 407)
DROP DATABASE db1 CASCADE;

-- Test 85: statement (line 410)
SET CLUSTER SETTING jobs.debug.pausepoints = '';

-- Test 86: statement (line 415)
USE test;
RESUME JOB (SELECT job_id FROM crdb_internal.jobs WHERE description LIKE 'REASSIGN OWNED BY%' AND status='paused' FETCH FIRST 1 ROWS ONLY);
RESUME JOB (SELECT job_id FROM crdb_internal.jobs WHERE description LIKE 'REASSIGN OWNED BY%' AND status='paused' FETCH FIRST 1 ROWS ONLY);
RESUME JOB (SELECT job_id FROM crdb_internal.jobs WHERE description LIKE 'REASSIGN OWNED BY%' AND status='paused' FETCH FIRST 1 ROWS ONLY);

-- Test 87: statement (line 423)
RESUME JOB (SELECT job_id FROM crdb_internal.jobs WHERE description LIKE  'DROP DATABASE%' AND status='paused' FETCH FIRST 1 ROWS ONLY);

