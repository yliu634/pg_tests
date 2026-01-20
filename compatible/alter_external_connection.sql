-- PostgreSQL compatible tests from alter_external_connection
-- 11 tests

SET client_min_messages = warning;

-- PostgreSQL doesn't support CockroachDB EXTERNAL CONNECTION objects.
-- Use FOREIGN SERVER (postgres_fdw) as the closest analogue.

-- Cleanup from prior runs.
RESET ROLE;
DROP SERVER IF EXISTS conn_1 CASCADE;
DROP SERVER IF EXISTS conn_2 CASCADE;
DROP ROLE IF EXISTS testuser;
CREATE ROLE testuser;
CREATE EXTENSION IF NOT EXISTS postgres_fdw;

-- Test 1: statement (line 3)
CREATE SERVER conn_1 FOREIGN DATA WRAPPER postgres_fdw OPTIONS (dbname 'nodelocal://1/conn_1');
CREATE SERVER conn_2 FOREIGN DATA WRAPPER postgres_fdw OPTIONS (dbname 'nodelocal://1/conn_2');

-- Test 2: query (line 7)
SELECT srvname, srvowner::regrole::text AS owner, srvoptions
FROM pg_foreign_server
WHERE srvname IN ('conn_1', 'conn_2')
ORDER BY srvname;

-- Test 3: statement (line 17)
ALTER SERVER conn_1 OPTIONS (SET dbname 'nodelocal://1/conn_update');

-- user root
RESET ROLE;

-- Test 4: statement (line 22)
-- PostgreSQL only supports USAGE on FOREIGN SERVER; treat UPDATE as USAGE for this port.
GRANT USAGE ON FOREIGN SERVER conn_1 TO testuser;
ALTER SERVER conn_1 OWNER TO testuser;

-- user testuser
SET ROLE testuser;

-- Test 5: statement (line 28)
ALTER SERVER conn_1 OPTIONS (SET dbname 'nodelocal://1/conn_update_with_privilege');

-- Test 6: query (line 31)
SELECT srvname, srvowner::regrole::text AS owner, srvoptions
FROM pg_foreign_server
WHERE srvname = 'conn_1';

-- Test 7: statement (line 39)
RESET ROLE;
ALTER SERVER conn_2 OPTIONS (SET dbname 'nodelocal://1/conn_update');

-- user root
RESET ROLE;

-- Test 8: statement (line 44)
GRANT USAGE ON FOREIGN SERVER conn_2 TO testuser;
ALTER SERVER conn_2 OWNER TO testuser;

-- user testuser
SET ROLE testuser;

-- Test 9: statement (line 50)
SELECT format('ALTER SERVER %I OPTIONS (SET dbname %L);', srvname, 'nodelocal://1/not_exist')
FROM pg_foreign_server
WHERE srvname = 'conn_not_exist' \gexec

-- Test 10: statement (line 53)
ALTER SERVER conn_2 OPTIONS (SET dbname 'nodelocal://1/connection_2_alter');

-- Test 11: query (line 56)
SELECT srvname, srvowner::regrole::text AS owner, srvoptions
FROM pg_foreign_server
WHERE srvname = 'conn_2';

-- Cleanup so the file can be re-run.
RESET ROLE;
DROP SERVER IF EXISTS conn_1 CASCADE;
DROP SERVER IF EXISTS conn_2 CASCADE;
DROP OWNED BY testuser;
DROP ROLE IF EXISTS testuser;

RESET client_min_messages;
