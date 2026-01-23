-- PostgreSQL compatible tests from owner
-- 78 tests

-- Setup: roles referenced by this script are cluster-wide in PostgreSQL.
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'testuser') THEN
    EXECUTE 'CREATE ROLE testuser LOGIN';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'admin') THEN
    EXECUTE 'CREATE ROLE admin';
  END IF;
END
$$;

-- Test 1: statement (line 1)
-- CockroachDB uses a fixed "test" database name; under this harness the database name is dynamic.
-- GRANT CREATE ON DATABASE test TO testuser;

-- Test 2: statement (line 4)
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'new_role') THEN
    EXECUTE 'CREATE ROLE new_role';
  END IF;
END
$$;

-- user testuser

-- Test 3: statement (line 9)
CREATE TABLE t();

-- Test 4: statement (line 14)
REVOKE ALL ON t FROM testuser;

-- Test 5: statement (line 17)
ALTER TABLE t RENAME TO t2;

-- Test 6: statement (line 20)
ALTER TABLE t2 RENAME TO t;

-- Test 7: statement (line 23)
REVOKE ALL ON t FROM testuser;

-- Test 8: statement (line 28)
GRANT ALL ON t TO new_role WITH GRANT OPTION;

-- Test 9: statement (line 33)
CREATE TABLE for_view(x INT);
CREATE VIEW v as SELECT x FROM for_view;

-- Test 10: statement (line 39)
REVOKE ALL ON v FROM testuser;

-- Test 11: statement (line 42)
ALTER VIEW v RENAME TO v2;

-- Test 12: statement (line 45)
ALTER TABLE v2 RENAME TO v;

-- Test 13: statement (line 48)
GRANT ALL ON v TO new_role WITH GRANT OPTION;

-- Test 14: statement (line 51)
DROP VIEW v;

-- Test 15: statement (line 54)
DROP TABLE for_view;

-- Test 16: statement (line 59)
DROP SEQUENCE IF EXISTS s2 CASCADE;
DROP SEQUENCE IF EXISTS s CASCADE;
CREATE SEQUENCE s;

-- Test 17: statement (line 64)
REVOKE ALL ON s FROM testuser;

-- Test 18: statement (line 67)
ALTER SEQUENCE s RENAME TO s2;

-- Test 19: statement (line 70)
ALTER SEQUENCE s2 RENAME TO s;

-- Test 20: statement (line 73)
GRANT ALL ON s TO new_role WITH GRANT OPTION;

-- Test 21: statement (line 76)
DROP SEQUENCE s;

-- Test 22: statement (line 83)
ALTER USER testuser CREATEDB;

-- user testuser

-- Test 23: statement (line 88)
CREATE SCHEMA d;

-- user testuser

-- Test 24: statement (line 96)
CREATE TABLE d.t();

-- Test 25: statement (line 99)
ALTER TABLE d.t RENAME TO t2;

-- Test 26: statement (line 102)
ALTER TABLE d.t2 RENAME TO t;

-- Test 27: statement (line 105)
GRANT ALL ON SCHEMA d TO new_role WITH GRANT OPTION;

-- Test 28: statement (line 108)
DROP TABLE d.t;

-- Test 29: statement (line 111)
ALTER SCHEMA d RENAME TO d2;

-- Test 30: statement (line 114)
DROP SCHEMA d2 CASCADE;

-- Test 31: statement (line 121)
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'testuser2') THEN
    EXECUTE 'CREATE ROLE testuser2 LOGIN';
  END IF;
END
$$;

-- Test 32: statement (line 124)
GRANT admin TO testuser;

-- user testuser

-- Test 33: statement (line 129)
CREATE SCHEMA d;

-- user root

-- Test 34: statement (line 134)
REVOKE admin FROM testuser;
GRANT ALL ON SCHEMA d TO testuser2;

-- Test 35: statement (line 139)
REVOKE GRANT OPTION FOR ALL PRIVILEGES ON SCHEMA d FROM testuser2;

-- user testuser2

-- Test 36: statement (line 146)
GRANT ALL ON SCHEMA d TO new_role WITH GRANT OPTION;

-- user root

-- Test 37: statement (line 151)
GRANT testuser TO testuser2;
REVOKE ALL ON SCHEMA d FROM testuser2;

-- user testuser2

-- Test 38: statement (line 162)
CREATE TABLE d.t();

-- Test 39: statement (line 165)
GRANT ALL ON SCHEMA d TO new_role WITH GRANT OPTION;

-- Test 40: statement (line 168)
DROP TABLE d.t;

-- Test 41: statement (line 172)
-- ALTER DATABASE d RENAME TO d2

-- user root

-- Test 42: statement (line 177)
ALTER USER testuser2 WITH CREATEDB;

-- user testuser2

-- Test 43: statement (line 182)
ALTER SCHEMA d RENAME TO d2;

-- Test 44: statement (line 185)
DROP SCHEMA d2 CASCADE;

-- Test 45: statement (line 192)
GRANT admin TO testuser;

-- user testuser

-- Test 46: statement (line 197)
CREATE SCHEMA d;

-- Test 47: statement (line 200)
CREATE TABLE d.t();

-- user root

-- Test 48: statement (line 208)
-- REVOKE ALL ON DATABASE test FROM testuser;
REVOKE ALL ON TABLE d.t FROM testuser;

-- Test 49: statement (line 212)
DROP OWNED BY testuser;
DROP ROLE IF EXISTS testuser;

-- Test 50: statement (line 221)
CREATE TABLE t2();

-- Test 51: statement (line 224)
REVOKE ALL ON TABLE t2 FROM testuser2;

-- Test 52: statement (line 227)
DROP OWNED BY testuser2;
DROP ROLE IF EXISTS testuser2;
DROP ROLE IF EXISTS testuser;

-- Remaining tests are CockroachDB-specific (USE, system.jobs, ALTER JOB, harness variables)
-- and are skipped for PostgreSQL.
