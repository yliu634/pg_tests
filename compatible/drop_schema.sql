-- PostgreSQL compatible tests from drop_schema
-- 10 tests

SET client_min_messages = warning;

-- Ensure Cockroach-style roles exist so we can emulate `user root`/`user testuser`.
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'root') THEN
    CREATE ROLE root SUPERUSER;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'testuser') THEN
    CREATE ROLE testuser;
  END IF;
END
$$;

SET ROLE root;

-- Keep track of the original DB so we can hop across databases and return.
SELECT current_database() AS orig_db \gset

-- Test 1: statement (line 1)
DROP SCHEMA public;

-- Test 2: statement (line 4)
DROP DATABASE IF EXISTS test2;
CREATE DATABASE test2;

-- Test 3: statement (line 7)
\connect test2
SET client_min_messages = warning;
SET ROLE root;
DROP SCHEMA public;
\connect :orig_db
SET client_min_messages = warning;
SET ROLE root;
DROP DATABASE test2;

-- Test 4: statement (line 13)
CREATE SCHEMA schema_123539;

-- Test 5: statement (line 16)
CREATE TYPE schema_123539.enum_123539 AS ENUM ('s', 't');

-- Test 6: statement (line 19)
BEGIN;
ALTER TYPE schema_123539.enum_123539 RENAME VALUE 's' TO 's2';
DROP SCHEMA schema_123539 CASCADE;
COMMIT;

-- Test 7: statement (line 28)
CREATE SCHEMA crdb_internal;
CREATE TABLE crdb_internal.t(i int);

DROP DATABASE IF EXISTS system;
CREATE DATABASE system OWNER root;
\connect system
SET client_min_messages = warning;
SET ROLE root;
CREATE TABLE system_table(i int);
SELECT table_name FROM information_schema.tables WHERE table_schema = 'public' ORDER BY table_name;
\connect :orig_db
SET client_min_messages = warning;
SET ROLE root;

-- Test 8: statement (line 31)
SELECT nspname FROM pg_namespace WHERE nspname = 'pg_catalog';

-- user testuser
SET ROLE testuser;

-- Test 9: statement (line 36)
\connect system
SET client_min_messages = warning;
SET ROLE testuser;
SELECT current_database(), current_user;
\connect :orig_db
SET client_min_messages = warning;
SET ROLE testuser;

-- Test 10: statement (line 39)
SELECT nspname, nspowner::regrole AS owner FROM pg_namespace WHERE nspname = 'crdb_internal';

-- user root
SET ROLE root;

DROP DATABASE system;
RESET ROLE;
RESET client_min_messages;
