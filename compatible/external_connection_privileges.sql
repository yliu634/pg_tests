-- PostgreSQL compatible tests from external_connection_privileges
--
-- CockroachDB has EXTERNAL CONNECTION objects and system.privileges. PostgreSQL
-- does not. The closest analogue is a FOREIGN SERVER (e.g., via postgres_fdw),
-- which supports USAGE privileges.

SET client_min_messages = warning;
DROP SERVER IF EXISTS ext_conn_foo CASCADE;
DROP ROLE IF EXISTS ext_conn_testuser;
DROP ROLE IF EXISTS ext_conn_bar;
DROP ROLE IF EXISTS ext_conn_testuser2;
RESET client_min_messages;

CREATE EXTENSION IF NOT EXISTS postgres_fdw;

CREATE SERVER ext_conn_foo FOREIGN DATA WRAPPER postgres_fdw
  OPTIONS (host 'localhost', dbname 'pg_tests');

CREATE ROLE ext_conn_testuser LOGIN;
CREATE ROLE ext_conn_bar LOGIN;
CREATE ROLE ext_conn_testuser2 LOGIN;

SELECT srvname, srvacl FROM pg_foreign_server WHERE srvname = 'ext_conn_foo';

GRANT USAGE ON FOREIGN SERVER ext_conn_foo TO ext_conn_testuser;
SELECT has_server_privilege('ext_conn_testuser', 'ext_conn_foo', 'USAGE') AS testuser_usage;

REVOKE USAGE ON FOREIGN SERVER ext_conn_foo FROM ext_conn_testuser;
SELECT has_server_privilege('ext_conn_testuser', 'ext_conn_foo', 'USAGE') AS testuser_usage_after_revoke;

GRANT USAGE ON FOREIGN SERVER ext_conn_foo TO ext_conn_testuser WITH GRANT OPTION;
GRANT USAGE ON FOREIGN SERVER ext_conn_foo TO ext_conn_bar;

SELECT srvname, srvacl FROM pg_foreign_server WHERE srvname = 'ext_conn_foo';

-- Cleanup.
DROP SERVER ext_conn_foo CASCADE;
DROP ROLE ext_conn_testuser;
DROP ROLE ext_conn_bar;
DROP ROLE ext_conn_testuser2;

