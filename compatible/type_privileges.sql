-- PostgreSQL compatible tests from type_privileges
-- 27 tests

-- The upstream logic tests switch between `root` and `testuser`. Implement
-- equivalent roles for a single-session psql run.
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'root') THEN
    CREATE ROLE root;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'testuser') THEN
    CREATE ROLE testuser LOGIN;
  END IF;
END
$$;

-- Ensure repeatable runs across isolated databases: role memberships are global
-- and may persist between runs of this file.
REVOKE root FROM testuser;

-- Test 1: statement (line 4)
-- PostgreSQL does not have a database-level DROP privilege; grant CREATE on the
-- current database and schema for the rest of this test.
SELECT current_database() AS db \gset
GRANT CREATE ON DATABASE :"db" TO testuser;
GRANT CREATE ON SCHEMA public TO testuser;
GRANT CREATE ON SCHEMA public TO root;

-- Test 2: statement (line 7)
SET ROLE root;
CREATE TYPE test AS ENUM ('hello');

-- Test 3: statement (line 10)
CREATE TABLE for_view(x test);

-- Test 4: statement (line 13)
GRANT SELECT on for_view TO testuser;

-- Test 5: statement (line 20)
CREATE TABLE t(x test);

-- Test 6: statement (line 23)
DROP TABLE t;

-- Test 7: statement (line 28)
REVOKE USAGE ON TYPE test FROM public;

SET ROLE testuser;

-- Test 8: statement (line 33)
-- Expected ERROR (no USAGE privilege on type test):
\set ON_ERROR_STOP 0
CREATE TABLE t(x test);

-- Test 9: statement (line 36)
SELECT 'hello'::test;

-- Test 10: statement (line 39)
CREATE VIEW vx1 as SELECT 'hello'::test;

-- Test 11: statement (line 42)
CREATE VIEW vx2 as SELECT x FROM for_view;
\set ON_ERROR_STOP 1

-- Test 12: statement (line 49)
RESET ROLE;
SET ROLE root;
GRANT USAGE ON TYPE test TO testuser;

SET ROLE testuser;

-- Test 13: statement (line 54)
CREATE TABLE t(x test);

-- Test 14: statement (line 57)
CREATE VIEW vx1 as SELECT 'hello'::test;

-- Test 15: statement (line 60)
CREATE VIEW vx2 as SELECT x FROM for_view;

-- Test 16: statement (line 64)
-- Expected ERROR (not owner of type test):
\set ON_ERROR_STOP 0
ALTER TYPE test RENAME TO not_test;

-- Test 17: statement (line 68)
DROP TYPE test;
\set ON_ERROR_STOP 1

RESET ROLE;

-- Test 18: statement (line 76)
-- Expected ERROR (PostgreSQL only supports USAGE on TYPE):
\set ON_ERROR_STOP 0
GRANT SELECT ON type TEST to testuser;

-- Test 19: statement (line 79)
GRANT INSERT ON type TEST to testuser;

-- Test 20: statement (line 82)
GRANT DELETE ON type TEST to testuser;

-- Test 21: statement (line 85)
GRANT UPDATE ON type TEST to testuser;

-- Test 22: statement (line 88)
GRANT ZONECONFIG ON type TEST to testuser;

-- Test 23: statement (line 93)
GRANT ALL ON type TEST to testuser;
\set ON_ERROR_STOP 1

-- Test 24: statement (line 97)
GRANT root TO testuser;

-- Test 25: statement (line 102)
DROP VIEW vx1;
DROP VIEW vx2;
DROP TABLE t;
DROP TABLE for_view;

SET ROLE testuser;

-- Test 26: statement (line 111)
ALTER TYPE test RENAME to test1;

-- Test 27: statement (line 115)
DROP TYPE test1;

-- Cleanup: this file grants role membership, which is global (not per-db).
RESET ROLE;
REVOKE root FROM testuser;
