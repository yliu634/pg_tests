-- PostgreSQL compatible tests from show_external_connections
-- 13 tests

-- CockroachDB's EXTERNAL CONNECTION objects don't exist in PostgreSQL. We
-- approximate them with FOREIGN SERVER objects (postgres_fdw) and use catalog
-- queries in place of SHOW EXTERNAL CONNECTION(S).

\set ON_ERROR_STOP 1
SET client_min_messages = warning;

CREATE EXTENSION IF NOT EXISTS postgres_fdw;

-- Clean up database-local objects from previous runs.
DROP SERVER IF EXISTS foo_conn CASCADE;
DROP SERVER IF EXISTS bar_conn CASCADE;
DROP SERVER IF EXISTS baz_conn CASCADE;

-- Clean up cluster-wide role from previous runs.
DROP ROLE IF EXISTS show_external_connections_testuser;
CREATE ROLE show_external_connections_testuser;

-- Test 1: statement (line 5)
CREATE SERVER foo_conn FOREIGN DATA WRAPPER postgres_fdw
  OPTIONS (host 'localhost', dbname 'postgres', port '5432');

CREATE SERVER bar_conn FOREIGN DATA WRAPPER postgres_fdw
  OPTIONS (host 'localhost', dbname 'postgres', port '5432');

-- Test 2: query (line 9)
SELECT srvname AS connection_name
FROM pg_foreign_server
WHERE has_server_privilege(srvname, 'USAGE')
ORDER BY srvname;

-- Test 3: query (line 16)
SELECT srvname AS connection_name, srvoptions
FROM pg_foreign_server
WHERE srvname = 'foo_conn'
  AND has_server_privilege(srvname, 'USAGE');

-- Test 4: query (line 24)
SELECT srvname AS connection_name
FROM pg_foreign_server
WHERE has_server_privilege(srvname, 'USAGE')
ORDER BY srvname;

-- Test 6: statement (line 34)
GRANT USAGE ON FOREIGN SERVER foo_conn TO show_external_connections_testuser;

-- Test 7: query (line 39)
SET ROLE show_external_connections_testuser;
SELECT srvname AS connection_name
FROM pg_foreign_server
WHERE has_server_privilege(srvname, 'USAGE')
ORDER BY srvname;

-- Test 8: query (line 45)
SELECT srvname AS connection_name, srvoptions
FROM pg_foreign_server
WHERE srvname = 'foo_conn'
  AND has_server_privilege(srvname, 'USAGE');
RESET ROLE;

-- Test 9: statement (line 51)
SELECT srvname AS connection_name, srvoptions
FROM pg_foreign_server
WHERE srvname = 'bar_conn'
  AND has_server_privilege(srvname, 'USAGE');

-- Test 10: statement (line 56)
-- Cockroach's SYSTEM EXTERNALCONNECTION privilege is approximated by allowing
-- server creation via USAGE on the FDW.
GRANT USAGE ON FOREIGN DATA WRAPPER postgres_fdw TO show_external_connections_testuser;

-- Test 11: statement (line 62)
SET ROLE show_external_connections_testuser;
CREATE SERVER baz_conn FOREIGN DATA WRAPPER postgres_fdw
  OPTIONS (host 'localhost', dbname 'postgres', port '5432');

-- Test 12: query (line 65)
SELECT srvname AS connection_name
FROM pg_foreign_server
WHERE has_server_privilege(srvname, 'USAGE')
ORDER BY srvname;
RESET ROLE;

-- Test 13: statement (line 73)
-- Cockroach's CHECK EXTERNAL CONNECTION has no PostgreSQL equivalent; verify
-- the created catalog entry exists.
SELECT srvname, srvoptions
FROM pg_foreign_server
WHERE srvname = 'baz_conn';

-- Cleanup.
DROP SERVER baz_conn;
DROP SERVER bar_conn;
DROP SERVER foo_conn;
REVOKE USAGE ON FOREIGN DATA WRAPPER postgres_fdw FROM show_external_connections_testuser;
DROP ROLE show_external_connections_testuser;
RESET client_min_messages;
