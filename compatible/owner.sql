-- PostgreSQL compatible tests from owner
-- 78 tests

-- Test 1: statement (line 1)
GRANT CREATE ON DATABASE test TO testuser

-- Test 2: statement (line 4)
CREATE ROLE new_role

user testuser

-- Test 3: statement (line 9)
CREATE TABLE t()

-- Test 4: statement (line 14)
REVOKE ALL ON t FROM testuser

-- Test 5: statement (line 17)
ALTER TABLE t RENAME to t2

-- Test 6: statement (line 20)
ALTER TABLE t2 RENAME to t

-- Test 7: statement (line 23)
REVOKE ALL ON t FROM testuser

-- Test 8: statement (line 28)
GRANT ALL ON t TO new_role WITH GRANT OPTION

-- Test 9: statement (line 33)
CREATE TABLE for_view(x INT);
CREATE VIEW v as SELECT x FROM for_view;

-- Test 10: statement (line 39)
REVOKE ALL ON v FROM testuser

-- Test 11: statement (line 42)
ALTER VIEW v RENAME to v2

-- Test 12: statement (line 45)
ALTER TABLE v2 RENAME to v

-- Test 13: statement (line 48)
GRANT ALL ON v TO new_role WITH GRANT OPTION

-- Test 14: statement (line 51)
DROP VIEW v

-- Test 15: statement (line 54)
DROP TABLE for_view

-- Test 16: statement (line 59)
CREATE SEQUENCE s;

-- Test 17: statement (line 64)
REVOKE ALL ON s FROM testuser

-- Test 18: statement (line 67)
ALTER SEQUENCE s RENAME to s2

-- Test 19: statement (line 70)
ALTER SEQUENCE s2 RENAME to s

-- Test 20: statement (line 73)
GRANT ALL ON s TO new_role WITH GRANT OPTION

-- Test 21: statement (line 76)
DROP SEQUENCE s

-- Test 22: statement (line 83)
ALTER USER testuser CREATEDB

user testuser

-- Test 23: statement (line 88)
CREATE DATABASE d

user testuser

-- Test 24: statement (line 96)
CREATE TABLE d.t()

-- Test 25: statement (line 99)
ALTER TABLE d.t RENAME TO d.t2

-- Test 26: statement (line 102)
ALTER TABLE d.t2 RENAME TO d.t

-- Test 27: statement (line 105)
GRANT ALL ON DATABASE d TO new_role WITH GRANT OPTION

-- Test 28: statement (line 108)
DROP TABLE d.t

-- Test 29: statement (line 111)
ALTER DATABASE d RENAME TO d2

-- Test 30: statement (line 114)
DROP DATABASE d2

-- Test 31: statement (line 121)
CREATE USER testuser2

-- Test 32: statement (line 124)
GRANT admin TO testuser

user testuser

-- Test 33: statement (line 129)
CREATE DATABASE d

user root

-- Test 34: statement (line 134)
REVOKE admin FROM testuser;
GRANT ALL ON DATABASE d to testuser2

-- Test 35: statement (line 139)
REVOKE GRANT OPTION FOR ALL PRIVILEGES ON DATABASE d FROM testuser2

user testuser2

-- Test 36: statement (line 146)
GRANT ALL ON DATABASE d TO new_role WITH GRANT OPTION

user root

-- Test 37: statement (line 151)
GRANT testuser TO testuser2;
REVOKE ALL ON DATABASE d FROM testuser2

user testuser2

-- Test 38: statement (line 162)
CREATE TABLE d.t()

-- Test 39: statement (line 165)
GRANT ALL ON DATABASE d TO new_role WITH GRANT OPTION

-- Test 40: statement (line 168)
DROP TABLE d.t

-- Test 41: statement (line 172)
ALTER DATABASE d RENAME TO d2

user root

-- Test 42: statement (line 177)
ALTER USER testuser2 WITH CREATEDB

user testuser2

-- Test 43: statement (line 182)
ALTER DATABASE d RENAME TO d2

-- Test 44: statement (line 185)
DROP DATABASE d2

-- Test 45: statement (line 192)
GRANT admin TO testuser

user testuser

-- Test 46: statement (line 197)
CREATE DATABASE d

-- Test 47: statement (line 200)
CREATE TABLE d.t()

user root

-- Test 48: statement (line 208)
REVOKE ALL ON DATABASE test FROM testuser;
REVOKE ALL ON TABLE d.t FROM testuser;

-- Test 49: statement (line 212)
DROP ROLE testuser

-- Test 50: statement (line 221)
CREATE TABLE t2()

-- Test 51: statement (line 224)
REVOKE ALL ON TABLE t2 FROM testuser2

-- Test 52: statement (line 227)
DROP ROLE testuser2, testuser

-- Test 53: statement (line 234)
USE d

-- Test 54: statement (line 237)
CREATE SCHEMA s

-- Test 55: statement (line 240)
CREATE TYPE typ AS ENUM ()

-- Test 56: statement (line 243)
CREATE TABLE s.t()

user root

-- Test 57: statement (line 248)
REVOKE ALL ON DATABASE test FROM testuser;
REVOKE ALL ON SCHEMA d.s FROM testuser;
REVOKE ALL ON TYPE d.typ FROM testuser;
REVOKE ALL ON TABLE d.s.t FROM testuser;

user testuser

-- Test 58: statement (line 256)
DROP ROLE testuser

user root

let $testuser_job_id
SELECT id FROM system.jobs WHERE owner = 'testuser' LIMIT 1

let $testuser2_job_id
SELECT id FROM system.jobs WHERE owner = 'testuser2' LIMIT 1

let $node_job_id
SELECT id FROM system.jobs WHERE owner = 'node' LIMIT 1

-- Test 59: statement (line 271)
ALTER JOB $testuser_job_id OWNER TO testuser2

-- Test 60: query (line 274)
SELECT owner FROM system.jobs WHERE id = $testuser_job_id

-- Test 61: statement (line 279)
ALTER JOB $testuser_job_id OWNER TO testuser

-- Test 62: query (line 282)
SELECT owner FROM system.jobs WHERE id = $testuser_job_id

-- Test 63: statement (line 289)
ALTER JOB $node_job_id OWNER TO testuser

-- Test 64: statement (line 292)
ALTER JOB $testuser_job_id OWNER TO node

-- Test 65: statement (line 298)
CREATE ROLE testrole

-- Test 66: statement (line 301)
CREATE ROLE otherrole

-- Test 67: statement (line 304)
CREATE USER testuser3

-- Test 68: statement (line 307)
GRANT testrole TO testuser3

-- Test 69: statement (line 310)
ALTER JOB $testuser_job_id OWNER TO testrole

-- Test 70: query (line 313)
SELECT owner FROM system.jobs WHERE id = $testuser_job_id

-- Test 71: statement (line 319)
ALTER JOB $testuser_job_id OWNER TO testuser2

-- Test 72: query (line 322)
SELECT owner FROM system.jobs WHERE id = $testuser_job_id

-- Test 73: statement (line 327)
ALTER JOB $testuser_job_id OWNER TO testuser

-- Test 74: query (line 330)
SELECT owner FROM system.jobs WHERE id = $testuser_job_id

-- Test 75: statement (line 338)
ALTER JOB $testuser_job_id OWNER TO testuser3

-- Test 76: statement (line 344)
ALTER JOB $testuser_job_id OWNER TO testrole

user testuser3

-- Test 77: statement (line 349)
ALTER JOB $testuser_job_id OWNER TO testuser3

-- Test 78: statement (line 354)
ALTER JOB $testuser_job_id OWNER TO otherrole

