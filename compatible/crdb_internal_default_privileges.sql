-- PostgreSQL compatible tests from crdb_internal_default_privileges
-- NOTE: CockroachDB crdb_internal.default_privileges and system.* tables are not available in PostgreSQL.
-- This file is rewritten to validate PostgreSQL ALTER DEFAULT PRIVILEGES behavior.

SET client_min_messages = warning;

-- Clean up roles from prior runs without DO wrappers.
SELECT 'DROP OWNED BY foo;'
WHERE EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'foo')
\gexec
SELECT 'DROP ROLE foo;'
WHERE EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'foo')
\gexec
SELECT 'DROP OWNED BY bar;'
WHERE EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'bar')
\gexec
SELECT 'DROP ROLE bar;'
WHERE EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'bar')
\gexec

CREATE ROLE foo;
CREATE ROLE bar;

DROP SCHEMA IF EXISTS dp CASCADE;
CREATE SCHEMA dp AUTHORIZATION foo;

-- Default privileges apply to objects created by role foo.
ALTER DEFAULT PRIVILEGES FOR ROLE foo IN SCHEMA dp
  GRANT SELECT ON TABLES TO bar;

SET ROLE foo;
CREATE TABLE dp.t (id INT);
RESET ROLE;

-- Verify bar got SELECT on dp.t.
SELECT has_table_privilege('bar', 'dp.t', 'SELECT') AS bar_can_select;

SELECT grantee, privilege_type
FROM information_schema.table_privileges
WHERE table_schema = 'dp'
  AND table_name = 't'
ORDER BY grantee, privilege_type;

-- Cleanup.
DROP SCHEMA dp CASCADE;
SELECT 'DROP OWNED BY foo;'
WHERE EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'foo')
\gexec
SELECT 'DROP ROLE foo;'
WHERE EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'foo')
\gexec
SELECT 'DROP OWNED BY bar;'
WHERE EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'bar')
\gexec
SELECT 'DROP ROLE bar;'
WHERE EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'bar')
\gexec

RESET client_min_messages;
